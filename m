From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 0/8] crypto: aes - retire table based generic AES
Date: Tue, 18 Jul 2017 13:06:37 +0100
Message-ID: <20170718120645.15880-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        nico@linaro.org, ebiggers@google.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:33397 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbdGRMG4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 08:06:56 -0400
Received: by mail-wr0-f176.google.com with SMTP id a10so26563935wrd.0
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 05:06:55 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The generic AES driver uses 16 lookup tables of 1 KB each, and has
encryption and decryption routines that are fully unrolled. Given how
the dependencies between this code and other drivers are declared in
Kconfig files, this code is always pulled into the core kernel, even
if it is usually superseded at runtime by accelerated drivers that
exist for many architectures.

This leaves us with 25 KB of dead code in the kernel, which is negligible
in typical environments, but which is actually a big deal for the IoT
domain, where every kilobyte counts.

Also, the scalar, table based AES routines that exist for ARM, arm64, i586
and x86_64 share the lookup tables with AES generic, and may be invoked
occasionally when the time-invariant AES-NI or other special instruction
drivers are called in interrupt context, at which time the SIMD register
file cannot be used. Pulling 16 KB of code and 9 KB of instructions into
the L1s (and evicting what was already there) when a softirq happens to
be handled in the context of an interrupt taken from kernel mode (which
means no SIMD on x86) is also something that we may like to avoid, by
falling back to a much smaller and moderately less performant driver.
(Note that arm64 will be updated shortly to supply fallbacks for all
SIMD based AES implementations, which will be based on the core routines)

For the reasons above, this series refactors the way the various AES
implementations are wired up, to allow the generic version in
crypto/aes_generic.c to be omitted from the build entirely.

Patch #1 removes some bogus 'select CRYPTO_AES' statement.

Patch #2 factors out aes-generic's lookup tables, which are shared with
arch-specific implementations in arch/x86, arch/arm and arch/arm64.

Patch #3 replaces the table based aes-generic.o with a new aes.o based on
the fixed time cipher, and uses it to fulfil dependencies on CRYPTO_AES.

Patch #4 switches the fallback in the AES-NI code to the new, generic encrypt
and decrypt routines so it no longer depends on the x86 scalar code or
[transitively] on AES-generic.

Patch #5 tweaks the ARM table based code to only use 2 KB + 256 bytes worth
of lookup tables instead of 4 KB.

Patch #6 does the same for arm64

Patch #7 removes the local copy of the AES sboxes from the arm64 NEON driver,
and switches to the ones exposed by the new AES core module instead.

Patch #8 updates the Kconfig help text to be more descriptive of what they
actually control, rather than duplicating AES's wikipedia entry a number of
times.

v4: - remove aes-generic altogether instead of allow a preference to be set
    - factor out shared lookup tables (#2)
    - reduce dependency of ARM's table based code on shared lookup tables
      (#5, #6)

v3: - fix big-endian issue in refactored fixed-time AES driver
    - improve Kconfig help texts
    - add patch #4

v2: - repurpose CRYPTO_AES and avoid HAVE_AES/NEED_AES Kconfig symbols
    - don't factor out tables from AES generic to be reused by per arch drivers,
      since the space saving is moderate (the generic code only), and the
      drivers weren't made to be small anyway

Ard Biesheuvel (8):
  drivers/crypto/Kconfig: drop bogus CRYPTO_AES dependencies
  crypto - aes: use dedicated lookup tables for table based asm routines
  crypto: aes - retire table based generic AES in favor of fixed time
    driver
  crypto: x86/aes-ni - switch to generic fallback
  crypto: arm/aes - avoid expanded lookup tables in the final round
  crypto: arm64/aes - avoid expanded lookup tables in the final round
  crypto: arm64/aes-neon - reuse Sboxes from AES core module
  crypto: aes - add meaningful help text to the various AES drivers

 arch/arm/crypto/Kconfig             |   16 +-
 arch/arm/crypto/aes-cipher-core.S   |   54 +-
 arch/arm64/crypto/Kconfig           |   30 +-
 arch/arm64/crypto/aes-cipher-core.S |  159 ++-
 arch/arm64/crypto/aes-neon.S        |   74 +-
 arch/x86/crypto/aes-i586-asm_32.S   |   13 +-
 arch/x86/crypto/aes-x86_64-asm_64.S |   12 +-
 arch/x86/crypto/aesni-intel_glue.c  |    4 +-
 crypto/Kconfig                      |  138 +-
 crypto/Makefile                     |    3 +-
 crypto/{aes_ti.c => aes.c}          |  169 ++-
 crypto/aes_generic.c                | 1478 --------------------
 drivers/crypto/Kconfig              |    5 -
 drivers/crypto/chelsio/chcr_algo.c  |    4 +-
 include/crypto/aes-tables.S         | 1104 +++++++++++++++
 include/crypto/aes.h                |   11 +-
 16 files changed, 1464 insertions(+), 1810 deletions(-)
 rename crypto/{aes_ti.c => aes.c} (76%)
 delete mode 100644 crypto/aes_generic.c
 create mode 100644 include/crypto/aes-tables.S

-- 
2.9.3

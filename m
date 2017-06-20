From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 0/7] crypto: aes - allow generic AES to be omitted
Date: Tue, 20 Jun 2017 11:28:53 +0200
Message-ID: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36150 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdFTJ3F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 05:29:05 -0400
Received: by mail-wm0-f48.google.com with SMTP id m125so15863047wmm.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2017 02:29:04 -0700 (PDT)
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
SIMD based AES implementations, which will be based on the core routines
[if they are accepted].)

For the reasons above, this series refactors the way the various AES
implementations are wired up, to allow the generic version in
crypto/aes_generic.c to be omitted from the build entirely.

Patch #1 removes some bogus 'select CRYPTO_AES' statement.

Patch #2 introduces CRYPTO_AES_CORE and its implementation crypto/aes_core.c,
which contains the existing key expansion routines, and default encrypt and
decrypt routines that are not exposed as a crypto_cipher themselves, but
can be pulled in by other AES drivers. These routines only depend on the two
256 byte Sboxes

Patch #3 switches the fallback in the AES-NI code to the new, generic encrypt
and decrypt routines so it no longer depends on the x86 scalar code or
[transitively] on AES-generic.

Patch #4 removes the local copy of the AES sboxes from the arm64 NEON driver,
and switches to the ones exposed by the new AES core module instead.

Patch #5 repurposes the CRYPTO_AES Kconfig symbol as an abstract symbol that
indicates whether some implementation of AES needs to be available. The
existing generic code is now controlled by CRYPTO_AES_GENERIC.

Patch #6 updates the Kconfig help text to be more descriptive of what they
actually control, rather than duplicating AES's wikipedia entry a number of
times.

Patch #7 updates the Kconfig logic so CRYPTO_AES_GENERIC can be disabled if
any CRYPTO_AES dependencies are satisfied by the fixed time driver.

v3: - fix big-endian issue in refactored fixed-time AES driver
    - improve Kconfig help texts
    - add patch #4

v2: - repurpose CRYPTO_AES and avoid HAVE_AES/NEED_AES Kconfig symbols
    - don't factor out tables from AES generic to be reused by per arch drivers,
      since the space saving is moderate (the generic code only), and the
      drivers weren't made to be small anyway


Ard Biesheuvel (7):
  drivers/crypto/Kconfig: drop bogus CRYPTO_AES dependencies
  crypto: aes - refactor shared routines into separate core module
  crypto: x86/aes-ni - switch to generic fallback
  crypto: arm64/aes-neon - reuse Sboxes from AES core module
  crypto: aes - repurpose CRYPTO_AES and introduce CRYPTO_AES_GENERIC
  crypto: aes - add meaningful help text to the various AES drivers
  crypto: aes - allow generic AES to be replaced by fixed time AES

 arch/arm/crypto/Kconfig            |  20 +-
 arch/arm64/crypto/Kconfig          |  34 +-
 arch/arm64/crypto/aes-neon.S       |  74 +----
 arch/x86/crypto/aesni-intel_glue.c |   4 +-
 crypto/Kconfig                     | 161 ++++------
 crypto/Makefile                    |   3 +-
 crypto/aes_core.c                  | 333 ++++++++++++++++++++
 crypto/aes_generic.c               | 178 -----------
 crypto/aes_ti.c                    | 315 ++----------------
 drivers/crypto/Kconfig             |  13 +-
 include/crypto/aes.h               |   6 +
 net/sunrpc/Kconfig                 |   3 +-
 12 files changed, 486 insertions(+), 658 deletions(-)
 create mode 100644 crypto/aes_core.c

-- 
2.7.4

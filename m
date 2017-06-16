From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/6] crypto: aes - allow generic AES to be omitted
Date: Fri, 16 Jun 2017 13:17:43 +0200
Message-ID: <1497611869-6126-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35105 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752587AbdFPLR7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 07:17:59 -0400
Received: by mail-wm0-f53.google.com with SMTP id x70so23059970wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jun 2017 04:17:59 -0700 (PDT)
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

Patch #4 repurposes the CRYPTO_AES Kconfig symbol as an abstract symbol that
indicates whether some implementation of AES needs to be available. The
existing generic code is now controlled by CRYPTO_AES_GENERIC.

Patch #5 updates the Kconfig help text to be more descriptive of what they
actually control, rather than duplicating AES's wikipedia entry a number of
times.

Patch #6 updates the Kconfig logic so CRYPTO_AES_GENERIC can be disabled if
any CRYPTO_AES dependencies are satisfied by the fixed time driver.

v2: - repurpose CRYPTO_AES and avoid HAVE_AES/NEED_AES Kconfig symbols
    - don't factor out tables from AES generic to be reused by per arch drivers,
      since the space saving is moderate (the generic code only), and the
      drivers weren't made to be small anyway

Ard Biesheuvel (6):
  drivers/crypto/Kconfig: drop bogus CRYPTO_AES dependencies
  crypto: aes - refactor shared routines into separate core module
  crypto: x86/aes-ni - switch to generic fallback
  crypto: aes - repurpose CRYPTO_AES and introduce CRYPTO_AES_GENERIC
  crypto: aes - add meaningful help text to the various AES drivers
  crypto: aes - allow generic AES to be replaced by fixed time AES

 arch/arm/crypto/Kconfig            |   8 +-
 arch/arm64/crypto/Kconfig          |  11 +-
 arch/x86/crypto/aesni-intel_glue.c |   4 +-
 crypto/Kconfig                     |  85 ++---
 crypto/Makefile                    |   3 +-
 crypto/aes_core.c                  | 333 ++++++++++++++++++++
 crypto/aes_generic.c               | 178 -----------
 crypto/aes_ti.c                    | 305 ++----------------
 drivers/crypto/Kconfig             |  13 +-
 include/crypto/aes.h               |   6 +
 net/sunrpc/Kconfig                 |   3 +-
 11 files changed, 407 insertions(+), 542 deletions(-)
 create mode 100644 crypto/aes_core.c

-- 
2.7.4

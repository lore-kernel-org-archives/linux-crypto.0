From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/7] crypto: ARM/arm64 - AES and ChaCha20 updates for v4.11
Date: Wed, 11 Jan 2017 16:41:48 +0000
Message-ID: <1484152915-26517-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f181.google.com ([209.85.210.181]:33335 "EHLO
        mail-wj0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936997AbdAKQmE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Jan 2017 11:42:04 -0500
Received: by mail-wj0-f181.google.com with SMTP id kq3so60947943wjc.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jan 2017 08:42:03 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds ARM and arm64 implementations of ChaCha20, scalar AES and SIMD
AES (using bit slicing). The SIMD algorithms in this series take advantage
of the new skcipher walksize attribute to iterate over the input in the most
efficient manner possible.

Patch #1 adds a NEON implementation of ChaCha20 for ARM.

Patch #2 adds a NEON implementation of ChaCha20 for arm64.

Patch #3 modifies the existing NEON and ARMv8 Crypto Extensions implementations
of AES-CTR to be available as a synchronous skcipher as well. This is intended
for the mac80211 code, which uses synchronous encapsulations of ctr(aes)
[ccm, gcm] in softirq context, during which arm64 supports use of SIMD code.

Patch #4 adds a scalar implementation of AES for arm64, using the key schedule
generation routines and lookup tables of the generic code in crypto/aes_generic.

Patch #5 does the same for ARM, replacing existing scalar code that originated
in the OpenSSL project, and contains redundant key schedule generation routines
and lookup tables (and is slightly slower on modern cores)

Patch #6 replaces the ARM bit sliced NEON code with a new implementation that
has a number of advantages over the original code (which also originated in the
OpenSSL project.) The performance should be identical.

Patch #7 adds a port of the ARM bit-sliced AES code to arm64, in ECB, CBC, CTR
and XTS modes.

Due to the size of patch #7, it may be difficult to apply these patches from
patchwork, so I pushed them here as well:

  git://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git crypto-arm-v4.11
  https://git.kernel.org/cgit/linux/kernel/git/ardb/linux.git/log/?h=crypto-arm-v4.11

Ard Biesheuvel (7):
  crypto: arm64/chacha20 - implement NEON version based on SSE3 code
  crypto: arm/chacha20 - implement NEON version based on SSE3 code
  crypto: arm64/aes-blk - expose AES-CTR as synchronous cipher as well
  crypto: arm64/aes - add scalar implementation
  crypto: arm/aes - replace scalar AES cipher
  crypto: arm/aes - replace bit-sliced OpenSSL NEON code
  crypto: arm64/aes - reimplement bit-sliced ARM/NEON implementation for
    arm64

 arch/arm/crypto/Kconfig                |   27 +-
 arch/arm/crypto/Makefile               |   11 +-
 arch/arm/crypto/aes-armv4.S            | 1089 ---------
 arch/arm/crypto/aes-cipher-core.S      |  179 ++
 arch/arm/crypto/aes-cipher-glue.c      |   74 +
 arch/arm/crypto/aes-neonbs-core.S      | 1021 ++++++++
 arch/arm/crypto/aes-neonbs-glue.c      |  405 ++++
 arch/arm/crypto/aes_glue.c             |   98 -
 arch/arm/crypto/aes_glue.h             |   19 -
 arch/arm/crypto/aesbs-core.S_shipped   | 2548 --------------------
 arch/arm/crypto/aesbs-glue.c           |  367 ---
 arch/arm/crypto/bsaes-armv7.pl         | 2471 -------------------
 arch/arm/crypto/chacha20-neon-core.S   |  524 ++++
 arch/arm/crypto/chacha20-neon-glue.c   |  128 +
 arch/arm64/crypto/Kconfig              |   17 +
 arch/arm64/crypto/Makefile             |    9 +
 arch/arm64/crypto/aes-cipher-core.S    |  127 +
 arch/arm64/crypto/aes-cipher-glue.c    |   69 +
 arch/arm64/crypto/aes-glue.c           |   25 +-
 arch/arm64/crypto/aes-neonbs-core.S    |  963 ++++++++
 arch/arm64/crypto/aes-neonbs-glue.c    |  420 ++++
 arch/arm64/crypto/chacha20-neon-core.S |  450 ++++
 arch/arm64/crypto/chacha20-neon-glue.c |  127 +
 23 files changed, 4549 insertions(+), 6619 deletions(-)
 delete mode 100644 arch/arm/crypto/aes-armv4.S
 create mode 100644 arch/arm/crypto/aes-cipher-core.S
 create mode 100644 arch/arm/crypto/aes-cipher-glue.c
 create mode 100644 arch/arm/crypto/aes-neonbs-core.S
 create mode 100644 arch/arm/crypto/aes-neonbs-glue.c
 delete mode 100644 arch/arm/crypto/aes_glue.c
 delete mode 100644 arch/arm/crypto/aes_glue.h
 delete mode 100644 arch/arm/crypto/aesbs-core.S_shipped
 delete mode 100644 arch/arm/crypto/aesbs-glue.c
 delete mode 100644 arch/arm/crypto/bsaes-armv7.pl
 create mode 100644 arch/arm/crypto/chacha20-neon-core.S
 create mode 100644 arch/arm/crypto/chacha20-neon-glue.c
 create mode 100644 arch/arm64/crypto/aes-cipher-core.S
 create mode 100644 arch/arm64/crypto/aes-cipher-glue.c
 create mode 100644 arch/arm64/crypto/aes-neonbs-core.S
 create mode 100644 arch/arm64/crypto/aes-neonbs-glue.c
 create mode 100644 arch/arm64/crypto/chacha20-neon-core.S
 create mode 100644 arch/arm64/crypto/chacha20-neon-glue.c

-- 
2.7.4

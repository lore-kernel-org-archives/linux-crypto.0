From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 00/18] crypto: ARM/arm64 roundup for v4.14
Date: Mon, 24 Jul 2017 11:28:02 +0100
Message-ID: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, dave.martin@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38854 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdGXK23 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 06:28:29 -0400
Received: by mail-wm0-f52.google.com with SMTP id m85so13405575wma.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jul 2017 03:28:28 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a resend of all the patches I sent out recently that I would
like to be considered for v4.14. Their main purpose is to prepare the
arm64 crypto code to deal with situations where the SIMD register file
is unavailable, which never occurs at present, but this will change in
the future when support for SVE is added.

Patches #1 and #2 have been sent out last week as 'crypto/algapi - refactor
crypto_xor() to avoid memcpy()s' (v2). This version of #2 fixes an error
caught by kbuild. The non-SIMD fallback code added in the remaining patches
relies on crypto_xor() extensively, which is why these patches have been
included here.

Patches #3 - #13 implement the non-SIMD fallbacks for the various NEON
based drivers.

Patch #14 implements AES-GCM natively instead of relying on the generic
GCM module to wire accelerated AES-CTR and GHASH together, resulting in
a ~37% speedup.

Patches #15 and #16 implement an accelerated GHASH algorithm for ARM cores
that lack the 64x64 PMULL instruction.

Patches #17 and #18 update the scalar AES implementations to stop using
the expanded lookup tables for the final round. This reduces the Dcache
footprint, and thus the key correlated jitter.

This supersedes all other crypto patches I have outstanding, including the
AES refactor ones which I will rework later.

Ard Biesheuvel (18):
  crypto/algapi - use separate dst and src operands for __crypto_xor()
  crypto/algapi - make crypto_xor() take separate dst and src arguments
  crypto: arm64/ghash-ce - add non-SIMD scalar fallback
  crypto: arm64/crct10dif - add non-SIMD generic fallback
  crypto: arm64/crc32 - add non-SIMD scalar fallback
  crypto: arm64/sha1-ce - add non-SIMD generic fallback
  crypto: arm64/sha2-ce - add non-SIMD scalar fallback
  crypto: arm64/aes-ce-cipher - match round key endianness with generic
    code
  crypto: arm64/aes-ce-cipher: add non-SIMD generic fallback
  crypto: arm64/aes-ce-ccm: add non-SIMD generic fallback
  crypto: arm64/aes-blk - add a non-SIMD fallback for synchronous CTR
  crypto: arm64/chacha20 - take may_use_simd() into account
  crypto: arm64/aes-bs - implement non-SIMD fallback for AES-CTR
  crypto: arm64/gcm - implement native driver using v8 Crypto Extensions
  crypto: arm/ghash - add NEON accelerated fallback for vmull.p64
  crypto: arm64/ghash - add NEON accelerated fallback for 64-bit PMULL
  crypto: arm/aes - avoid expanded lookup tables in the final round
  crypto: arm64/aes - avoid expanded lookup tables in the final round

 arch/arm/crypto/Kconfig                |   5 +-
 arch/arm/crypto/aes-ce-glue.c          |   4 +-
 arch/arm/crypto/aes-cipher-core.S      |  88 +++-
 arch/arm/crypto/aes-neonbs-glue.c      |   5 +-
 arch/arm/crypto/ghash-ce-core.S        | 234 +++++++--
 arch/arm/crypto/ghash-ce-glue.c        |  24 +-
 arch/arm64/crypto/Kconfig              |  22 +-
 arch/arm64/crypto/aes-ce-ccm-core.S    |  30 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c    | 174 +++++--
 arch/arm64/crypto/aes-ce-cipher.c      |  55 ++-
 arch/arm64/crypto/aes-ce.S             |  12 +-
 arch/arm64/crypto/aes-cipher-core.S    | 152 ++++--
 arch/arm64/crypto/aes-ctr-fallback.h   |  53 ++
 arch/arm64/crypto/aes-glue.c           |  63 ++-
 arch/arm64/crypto/aes-neonbs-glue.c    |  53 +-
 arch/arm64/crypto/chacha20-neon-glue.c |   5 +-
 arch/arm64/crypto/crc32-ce-glue.c      |  11 +-
 arch/arm64/crypto/crct10dif-ce-glue.c  |  13 +-
 arch/arm64/crypto/ghash-ce-core.S      | 401 ++++++++++++++-
 arch/arm64/crypto/ghash-ce-glue.c      | 517 ++++++++++++++++++--
 arch/arm64/crypto/sha1-ce-glue.c       |  18 +-
 arch/arm64/crypto/sha2-ce-glue.c       |  30 +-
 arch/arm64/crypto/sha256-glue.c        |   1 +
 arch/sparc/crypto/aes_glue.c           |   3 +-
 arch/x86/crypto/aesni-intel_glue.c     |   4 +-
 arch/x86/crypto/blowfish_glue.c        |   3 +-
 arch/x86/crypto/cast5_avx_glue.c       |   3 +-
 arch/x86/crypto/des3_ede_glue.c        |   3 +-
 crypto/algapi.c                        |  25 +-
 crypto/ctr.c                           |   3 +-
 crypto/pcbc.c                          |  12 +-
 drivers/crypto/vmx/aes_ctr.c           |   3 +-
 drivers/md/dm-crypt.c                  |  11 +-
 include/crypto/algapi.h                |  23 +-
 34 files changed, 1719 insertions(+), 344 deletions(-)
 create mode 100644 arch/arm64/crypto/aes-ctr-fallback.h

-- 
2.9.3

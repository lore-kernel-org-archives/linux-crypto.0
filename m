From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/2] crypto: Remove VLA usage from skcipher
Date: Tue,  4 Sep 2018 11:16:27 -0700
Message-ID: <20180904181629.20712-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This removes VLAs[1] from SKCIPHER_REQUEST_ON_STACK by making it possible
for crypto_skcipher_set_reqsize() to fail. Callers are updated to handle
the error condition.

-Kees

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Kees Cook (2):
  crypto: skcipher: Allow crypto_skcipher_set_reqsize() to fail
  crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK

 crypto/cryptd.c                                |  7 +++++--
 crypto/ctr.c                                   |  7 +++++--
 crypto/cts.c                                   |  7 +++++--
 crypto/lrw.c                                   |  9 ++++++---
 crypto/simd.c                                  |  7 +++++--
 crypto/xts.c                                   | 11 ++++++++---
 drivers/crypto/amcc/crypto4xx_core.c           |  8 +++++++-
 drivers/crypto/cavium/nitrox/nitrox_algs.c     |  9 +++++++--
 drivers/crypto/ccree/cc_cipher.c               |  6 ++++--
 drivers/crypto/hisilicon/sec/sec_algs.c        |  5 ++++-
 drivers/crypto/inside-secure/safexcel_cipher.c |  5 ++++-
 drivers/crypto/marvell/cipher.c                |  4 +---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c      |  4 +---
 include/crypto/internal/skcipher.h             |  7 ++++++-
 include/crypto/skcipher.h                      |  4 +++-
 15 files changed, 71 insertions(+), 29 deletions(-)

-- 
2.17.1

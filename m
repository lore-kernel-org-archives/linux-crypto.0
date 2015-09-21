From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [RFC][PATCH 0/9] use CRYPTO_ALG_TFM_MAY_SHARE cra flag (full patchset)
Date: Mon, 21 Sep 2015 22:13:40 +0900
Message-ID: <1442841229-8122-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

RFC

resend reason:
git (2.6.0-rc2) has crashed and spme patches were not sent out.


Sorry for the noise.

===================


This patch set implements a bit different approach to shared tfm. It
defines a new CRYPTO_ALG_TFM_MAY_SHARE ->cra_flag which each algorithm
setups in its `static struct crypto_alg'. Crypto API provides
crypto_tfm_may_share() function that returns true if the algorithm
has CRYPTO_ALG_TFM_MAY_SHARE set and, thus, we can supply a shared
`struct crypto_comp *tfm'.

Not properly tested yet.


Sergey Senozhatsky (9):
  crypto: introduce CRYPTO_ALG_TFM_MAY_SHARE flag
  crypto/lzo: set CRYPTO_ALG_TFM_MAY_SHARE
  crypto/lz4: set CRYPTO_ALG_TFM_MAY_SHARE
  crypto/lz4hc: set CRYPTO_ALG_TFM_MAY_SHARE
  crypto/842: set CRYPTO_ALG_TFM_MAY_SHARE
  zram: make stream find and release functions static
  zram: pass zstrm down to decompression path
  zram: use crypto API for compression
  zram: use crypto CRYPTO_ALG_TFM_MAY_SHARE API

 crypto/842.c                   |   3 +-
 crypto/lz4.c                   |   3 +-
 crypto/lz4hc.c                 |   3 +-
 crypto/lzo.c                   |   3 +-
 drivers/block/zram/Kconfig     |   8 ++--
 drivers/block/zram/Makefile    |   4 +-
 drivers/block/zram/zcomp.c     | 103 +++++++++++++++++++++++++++++++----------
 drivers/block/zram/zcomp.h     |  42 +++++++----------
 drivers/block/zram/zcomp_lz4.c |  47 -------------------
 drivers/block/zram/zcomp_lz4.h |  17 -------
 drivers/block/zram/zcomp_lzo.c |  47 -------------------
 drivers/block/zram/zcomp_lzo.h |  17 -------
 drivers/block/zram/zram_drv.c  |  32 +++++++++----
 include/linux/crypto.h         |  10 ++++
 14 files changed, 138 insertions(+), 201 deletions(-)
 delete mode 100644 drivers/block/zram/zcomp_lz4.c
 delete mode 100644 drivers/block/zram/zcomp_lz4.h
 delete mode 100644 drivers/block/zram/zcomp_lzo.c
 delete mode 100644 drivers/block/zram/zcomp_lzo.h

-- 
2.6.0.rc2.10.gf4d9753

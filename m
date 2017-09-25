From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] block: cryptoloop - Fix build warning
Date: Mon, 25 Sep 2017 19:10:07 +0200
Message-ID: <20170925171007.4660-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: axboe@kernel.dk, herbert@gondor.apana.org.au
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch fix the following build warning:
drivers/block/cryptoloop.c:46:8: warning: variable 'cipher' set but not used [-Wunused-but-set-variable]

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/block/cryptoloop.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
index 74e03aa537ad..7033a4beda66 100644
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -43,7 +43,6 @@ cryptoloop_init(struct loop_device *lo, const struct loop_info64 *info)
 	int cipher_len;
 	int mode_len;
 	char cms[LO_NAME_SIZE];			/* cipher-mode string */
-	char *cipher;
 	char *mode;
 	char *cmsp = cms;			/* c-m string pointer */
 	struct crypto_skcipher *tfm;
@@ -56,7 +55,6 @@ cryptoloop_init(struct loop_device *lo, const struct loop_info64 *info)
 	strncpy(cms, info->lo_crypt_name, LO_NAME_SIZE);
 	cms[LO_NAME_SIZE - 1] = 0;
 
-	cipher = cmsp;
 	cipher_len = strcspn(cmsp, "-");
 
 	mode = cmsp + cipher_len;
-- 
2.13.5

From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 5/6] crypto: sun4i-ss: Always use sun4i_tfm_ctx for storing pointer to dev ss
Date: Wed, 10 Aug 2016 11:45:33 +0200
Message-ID: <1470822334-20672-5-git-send-email-clabbe.montjoie@gmail.com>
References: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	maxime.ripard@free-electrons.com, wens@csie.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The dev *ss is stored both in sun4i_tfm_ctx and sun4i_req_ctx.
Since this pointer will never be changed during tfm life, it is better
to remove it from sun4i_req_ctx.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 13 +++++++++++--
 drivers/crypto/sunxi-ss/sun4i-ss.h      |  1 -
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 60031e0..2ee3b59 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -20,6 +20,15 @@
 
 int sun4i_hash_crainit(struct crypto_tfm *tfm)
 {
+	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
+	struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
+	struct sun4i_ss_alg_template *algt;
+
+	memset(op, 0, sizeof(struct sun4i_tfm_ctx));
+
+	algt = container_of(alg, struct sun4i_ss_alg_template, alg.hash);
+	op->ss = algt->ss;
+
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct sun4i_req_ctx));
 	return 0;
@@ -36,7 +45,6 @@ int sun4i_hash_init(struct ahash_request *areq)
 	memset(op, 0, sizeof(struct sun4i_req_ctx));
 
 	algt = container_of(alg, struct sun4i_ss_alg_template, alg.hash);
-	op->ss = algt->ss;
 	op->mode = algt->mode;
 
 	return 0;
@@ -168,8 +176,9 @@ int sun4i_hash(struct ahash_request *areq)
 	 */
 
 	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
-	struct sun4i_ss_ctx *ss = op->ss;
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun4i_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
+	struct sun4i_ss_ctx *ss = tfmctx->ss;
 	unsigned int in_i = 0; /* advancement in the current SG */
 	unsigned int end;
 	/*
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
index ece5a1c..f04c0f8 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -163,7 +163,6 @@ struct sun4i_req_ctx {
 	u32 hash[5]; /* for storing SS_IVx register */
 	char buf[64];
 	unsigned int len;
-	struct sun4i_ss_ctx *ss;
 	int flags;
 };
 
-- 
2.7.3

From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 09/11] crypto: sun4i-ss: move from ablkcipher to skcipher API
Date: Wed, 24 May 2017 21:06:50 +0200
Message-ID: <20170524190652.13278-10-antoine.tenart@free-electrons.com>
References: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:50342 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941010AbdEXV1X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 17:27:23 -0400
In-Reply-To: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update the sun4i-ss driver to use the skcipher API instead of the old
ablkcipher one. It's a bit more tricky than s/ablkcipher/skcipher/, but
still nothing special and the driver's logic stays the same.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 189 ++++++++++++-------------
 drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 227 +++++++++++++++---------------
 drivers/crypto/sunxi-ss/sun4i-ss.h        |  34 ++---
 3 files changed, 226 insertions(+), 224 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 23e549204365..5cf64746731a 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -16,13 +16,13 @@
  */
 #include "sun4i-ss.h"
 
-static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
+static int sun4i_ss_opti_poll(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct sun4i_ss_ctx *ss = op->ss;
-	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
-	struct sun4i_cipher_req_ctx *ctx = ablkcipher_request_ctx(areq);
+	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	struct sun4i_cipher_req_ctx *ctx = skcipher_request_ctx(areq);
 	u32 mode = ctx->mode;
 	/* when activating SS, the default FIFO space is SS_RX_DEFAULT(32) */
 	u32 rx_cnt = SS_RX_DEFAULT;
@@ -31,17 +31,17 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 	u32 v;
 	int err = 0;
 	unsigned int i;
-	unsigned int ileft = areq->nbytes;
-	unsigned int oleft = areq->nbytes;
+	unsigned int ileft = areq->cryptlen;
+	unsigned int oleft = areq->cryptlen;
 	unsigned int todo;
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo; /* offset for in and out */
 	unsigned long flags;
 
-	if (!areq->nbytes)
+	if (!areq->cryptlen)
 		return 0;
 
-	if (!areq->info) {
+	if (!areq->iv) {
 		dev_err_ratelimited(ss->dev, "ERROR: Empty IV\n");
 		return -EINVAL;
 	}
@@ -56,9 +56,9 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 	for (i = 0; i < op->keylen; i += 4)
 		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
 
-	if (areq->info) {
+	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
-			v = *(u32 *)(areq->info + i * 4);
+			v = *(u32 *)(areq->iv + i * 4);
 			writel(v, ss->base + SS_IV0 + i * 4);
 		}
 	}
@@ -76,8 +76,8 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 		goto release_ss;
 	}
 
-	ileft = areq->nbytes / 4;
-	oleft = areq->nbytes / 4;
+	ileft = areq->cryptlen / 4;
+	oleft = areq->cryptlen / 4;
 	oi = 0;
 	oo = 0;
 	do {
@@ -108,10 +108,10 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 		}
 	} while (oleft);
 
-	if (areq->info) {
+	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = readl(ss->base + SS_IV0 + i * 4);
-			*(u32 *)(areq->info + i * 4) = v;
+			*(u32 *)(areq->iv + i * 4) = v;
 		}
 	}
 
@@ -124,16 +124,16 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 }
 
 /* Generic function that support SG with size not multiple of 4 */
-static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
+static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct sun4i_ss_ctx *ss = op->ss;
 	int no_chunk = 1;
 	struct scatterlist *in_sg = areq->src;
 	struct scatterlist *out_sg = areq->dst;
-	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
-	struct sun4i_cipher_req_ctx *ctx = ablkcipher_request_ctx(areq);
+	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	struct sun4i_cipher_req_ctx *ctx = skcipher_request_ctx(areq);
 	u32 mode = ctx->mode;
 	/* when activating SS, the default FIFO space is SS_RX_DEFAULT(32) */
 	u32 rx_cnt = SS_RX_DEFAULT;
@@ -142,8 +142,8 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 	u32 spaces;
 	int err = 0;
 	unsigned int i;
-	unsigned int ileft = areq->nbytes;
-	unsigned int oleft = areq->nbytes;
+	unsigned int ileft = areq->cryptlen;
+	unsigned int oleft = areq->cryptlen;
 	unsigned int todo;
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo;	/* offset for in and out */
@@ -154,10 +154,10 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 	unsigned int obl = 0;	/* length of data in bufo */
 	unsigned long flags;
 
-	if (!areq->nbytes)
+	if (!areq->cryptlen)
 		return 0;
 
-	if (!areq->info) {
+	if (!areq->iv) {
 		dev_err_ratelimited(ss->dev, "ERROR: Empty IV\n");
 		return -EINVAL;
 	}
@@ -190,9 +190,9 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 	for (i = 0; i < op->keylen; i += 4)
 		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
 
-	if (areq->info) {
+	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
-			v = *(u32 *)(areq->info + i * 4);
+			v = *(u32 *)(areq->iv + i * 4);
 			writel(v, ss->base + SS_IV0 + i * 4);
 		}
 	}
@@ -209,8 +209,8 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 		err = -EINVAL;
 		goto release_ss;
 	}
-	ileft = areq->nbytes;
-	oleft = areq->nbytes;
+	ileft = areq->cryptlen;
+	oleft = areq->cryptlen;
 	oi = 0;
 	oo = 0;
 
@@ -257,8 +257,8 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
 		dev_dbg(ss->dev, "%x %u/%u %u/%u cnt=%u %u/%u %u/%u cnt=%u %u\n",
 			mode,
-			oi, mi.length, ileft, areq->nbytes, rx_cnt,
-			oo, mo.length, oleft, areq->nbytes, tx_cnt, ob);
+			oi, mi.length, ileft, areq->cryptlen, rx_cnt,
+			oo, mo.length, oleft, areq->cryptlen, tx_cnt, ob);
 
 		if (!tx_cnt)
 			continue;
@@ -300,10 +300,10 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 			/* bufo must be fully used here */
 		}
 	}
-	if (areq->info) {
+	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = readl(ss->base + SS_IV0 + i * 4);
-			*(u32 *)(areq->info + i * 4) = v;
+			*(u32 *)(areq->iv + i * 4) = v;
 		}
 	}
 
@@ -317,22 +317,22 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 }
 
 /* CBC AES */
-int sun4i_ss_cbc_aes_encrypt(struct ablkcipher_request *areq)
+int sun4i_ss_cbc_aes_encrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_AES | SS_CBC | SS_ENABLED | SS_ENCRYPTION |
 		op->keymode;
 	return sun4i_ss_cipher_poll(areq);
 }
 
-int sun4i_ss_cbc_aes_decrypt(struct ablkcipher_request *areq)
+int sun4i_ss_cbc_aes_decrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_AES | SS_CBC | SS_ENABLED | SS_DECRYPTION |
 		op->keymode;
@@ -340,22 +340,22 @@ int sun4i_ss_cbc_aes_decrypt(struct ablkcipher_request *areq)
 }
 
 /* ECB AES */
-int sun4i_ss_ecb_aes_encrypt(struct ablkcipher_request *areq)
+int sun4i_ss_ecb_aes_encrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_AES | SS_ECB | SS_ENABLED | SS_ENCRYPTION |
 		op->keymode;
 	return sun4i_ss_cipher_poll(areq);
 }
 
-int sun4i_ss_ecb_aes_decrypt(struct ablkcipher_request *areq)
+int sun4i_ss_ecb_aes_decrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_AES | SS_ECB | SS_ENABLED | SS_DECRYPTION |
 		op->keymode;
@@ -363,22 +363,22 @@ int sun4i_ss_ecb_aes_decrypt(struct ablkcipher_request *areq)
 }
 
 /* CBC DES */
-int sun4i_ss_cbc_des_encrypt(struct ablkcipher_request *areq)
+int sun4i_ss_cbc_des_encrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_DES | SS_CBC | SS_ENABLED | SS_ENCRYPTION |
 		op->keymode;
 	return sun4i_ss_cipher_poll(areq);
 }
 
-int sun4i_ss_cbc_des_decrypt(struct ablkcipher_request *areq)
+int sun4i_ss_cbc_des_decrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_DES | SS_CBC | SS_ENABLED | SS_DECRYPTION |
 		op->keymode;
@@ -386,22 +386,22 @@ int sun4i_ss_cbc_des_decrypt(struct ablkcipher_request *areq)
 }
 
 /* ECB DES */
-int sun4i_ss_ecb_des_encrypt(struct ablkcipher_request *areq)
+int sun4i_ss_ecb_des_encrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_DES | SS_ECB | SS_ENABLED | SS_ENCRYPTION |
 		op->keymode;
 	return sun4i_ss_cipher_poll(areq);
 }
 
-int sun4i_ss_ecb_des_decrypt(struct ablkcipher_request *areq)
+int sun4i_ss_ecb_des_decrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_DES | SS_ECB | SS_ENABLED | SS_DECRYPTION |
 		op->keymode;
@@ -409,22 +409,22 @@ int sun4i_ss_ecb_des_decrypt(struct ablkcipher_request *areq)
 }
 
 /* CBC 3DES */
-int sun4i_ss_cbc_des3_encrypt(struct ablkcipher_request *areq)
+int sun4i_ss_cbc_des3_encrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_3DES | SS_CBC | SS_ENABLED | SS_ENCRYPTION |
 		op->keymode;
 	return sun4i_ss_cipher_poll(areq);
 }
 
-int sun4i_ss_cbc_des3_decrypt(struct ablkcipher_request *areq)
+int sun4i_ss_cbc_des3_decrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_3DES | SS_CBC | SS_ENABLED | SS_DECRYPTION |
 		op->keymode;
@@ -432,22 +432,22 @@ int sun4i_ss_cbc_des3_decrypt(struct ablkcipher_request *areq)
 }
 
 /* ECB 3DES */
-int sun4i_ss_ecb_des3_encrypt(struct ablkcipher_request *areq)
+int sun4i_ss_ecb_des3_encrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_3DES | SS_ECB | SS_ENABLED | SS_ENCRYPTION |
 		op->keymode;
 	return sun4i_ss_cipher_poll(areq);
 }
 
-int sun4i_ss_ecb_des3_decrypt(struct ablkcipher_request *areq)
+int sun4i_ss_ecb_des3_decrypt(struct skcipher_request *areq)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
-	struct sun4i_cipher_req_ctx *rctx = ablkcipher_request_ctx(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 
 	rctx->mode = SS_OP_3DES | SS_ECB | SS_ENABLED | SS_DECRYPTION |
 		op->keymode;
@@ -457,24 +457,25 @@ int sun4i_ss_ecb_des3_decrypt(struct ablkcipher_request *areq)
 int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
 {
 	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
-	struct crypto_alg *alg = tfm->__crt_alg;
 	struct sun4i_ss_alg_template *algt;
 
 	memset(op, 0, sizeof(struct sun4i_tfm_ctx));
 
-	algt = container_of(alg, struct sun4i_ss_alg_template, alg.crypto);
+	algt = container_of(tfm->__crt_alg, struct sun4i_ss_alg_template,
+			    alg.crypto.base);
 	op->ss = algt->ss;
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct sun4i_cipher_req_ctx);
+	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
+				    sizeof(struct sun4i_cipher_req_ctx));
 
 	return 0;
 }
 
 /* check and set the AES key, prepare the mode to be used */
-int sun4i_ss_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+int sun4i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen)
 {
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct sun4i_ss_ctx *ss = op->ss;
 
 	switch (keylen) {
@@ -489,7 +490,7 @@ int sun4i_ss_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 		break;
 	default:
 		dev_err(ss->dev, "ERROR: Invalid keylen %u\n", keylen);
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	op->keylen = keylen;
@@ -498,10 +499,10 @@ int sun4i_ss_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 }
 
 /* check and set the DES key, prepare the mode to be used */
-int sun4i_ss_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen)
 {
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct sun4i_ss_ctx *ss = op->ss;
 	u32 flags;
 	u32 tmp[DES_EXPKEY_WORDS];
@@ -509,15 +510,15 @@ int sun4i_ss_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 
 	if (unlikely(keylen != DES_KEY_SIZE)) {
 		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
-	flags = crypto_ablkcipher_get_flags(tfm);
+	flags = crypto_skcipher_get_flags(tfm);
 
 	ret = des_ekey(tmp, key);
 	if (unlikely(!ret) && (flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
 		dev_dbg(ss->dev, "Weak key %u\n", keylen);
 		return -EINVAL;
 	}
@@ -528,15 +529,15 @@ int sun4i_ss_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 }
 
 /* check and set the 3DES key, prepare the mode to be used */
-int sun4i_ss_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			 unsigned int keylen)
 {
-	struct sun4i_tfm_ctx *op = crypto_ablkcipher_ctx(tfm);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct sun4i_ss_ctx *ss = op->ss;
 
 	if (unlikely(keylen != 3 * DES_KEY_SIZE)) {
 		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	op->keylen = keylen;
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index 50af81c3eb45..02ad8256e900 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -83,134 +83,133 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 		}
 	}
 },
-{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+{       .type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.alg.crypto = {
-		.cra_name = "cbc(aes)",
-		.cra_driver_name = "cbc-aes-sun4i-ss",
-		.cra_priority = 300,
-		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.cra_ctxsize = sizeof(struct sun4i_tfm_ctx),
-		.cra_module = THIS_MODULE,
-		.cra_alignmask = 3,
-		.cra_type = &crypto_ablkcipher_type,
-		.cra_init = sun4i_ss_cipher_init,
-		.cra_ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey         = sun4i_ss_aes_setkey,
-			.encrypt        = sun4i_ss_cbc_aes_encrypt,
-			.decrypt        = sun4i_ss_cbc_aes_decrypt,
+		.setkey         = sun4i_ss_aes_setkey,
+		.encrypt        = sun4i_ss_cbc_aes_encrypt,
+		.decrypt        = sun4i_ss_cbc_aes_decrypt,
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.base = {
+			.cra_name = "cbc(aes)",
+			.cra_driver_name = "cbc-aes-sun4i-ss",
+			.cra_priority = 300,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_ctxsize = sizeof(struct sun4i_tfm_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_alignmask = 3,
+			.cra_init = sun4i_ss_cipher_init,
 		}
 	}
 },
-{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+{       .type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.alg.crypto = {
-		.cra_name = "ecb(aes)",
-		.cra_driver_name = "ecb-aes-sun4i-ss",
-		.cra_priority = 300,
-		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.cra_ctxsize = sizeof(struct sun4i_tfm_ctx),
-		.cra_module = THIS_MODULE,
-		.cra_alignmask = 3,
-		.cra_type = &crypto_ablkcipher_type,
-		.cra_init = sun4i_ss_cipher_init,
-		.cra_ablkcipher = {
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.ivsize		= AES_BLOCK_SIZE,
-			.setkey         = sun4i_ss_aes_setkey,
-			.encrypt        = sun4i_ss_ecb_aes_encrypt,
-			.decrypt        = sun4i_ss_ecb_aes_decrypt,
+		.setkey         = sun4i_ss_aes_setkey,
+		.encrypt        = sun4i_ss_ecb_aes_encrypt,
+		.decrypt        = sun4i_ss_ecb_aes_decrypt,
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.base = {
+			.cra_name = "ecb(aes)",
+			.cra_driver_name = "ecb-aes-sun4i-ss",
+			.cra_priority = 300,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_ctxsize = sizeof(struct sun4i_tfm_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_alignmask = 3,
+			.cra_init = sun4i_ss_cipher_init,
 		}
 	}
 },
-{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+{       .type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.alg.crypto = {
-		.cra_name = "cbc(des)",
-		.cra_driver_name = "cbc-des-sun4i-ss",
-		.cra_priority = 300,
-		.cra_blocksize = DES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.cra_ctxsize = sizeof(struct sun4i_req_ctx),
-		.cra_module = THIS_MODULE,
-		.cra_alignmask = 3,
-		.cra_type = &crypto_ablkcipher_type,
-		.cra_init = sun4i_ss_cipher_init,
-		.cra_u.ablkcipher = {
-			.min_keysize    = DES_KEY_SIZE,
-			.max_keysize    = DES_KEY_SIZE,
-			.ivsize         = DES_BLOCK_SIZE,
-			.setkey         = sun4i_ss_des_setkey,
-			.encrypt        = sun4i_ss_cbc_des_encrypt,
-			.decrypt        = sun4i_ss_cbc_des_decrypt,
+		.setkey         = sun4i_ss_des_setkey,
+		.encrypt        = sun4i_ss_cbc_des_encrypt,
+		.decrypt        = sun4i_ss_cbc_des_decrypt,
+		.min_keysize    = DES_KEY_SIZE,
+		.max_keysize    = DES_KEY_SIZE,
+		.ivsize         = DES_BLOCK_SIZE,
+		.base = {
+			.cra_name = "cbc(des)",
+			.cra_driver_name = "cbc-des-sun4i-ss",
+			.cra_priority = 300,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_ctxsize = sizeof(struct sun4i_req_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_alignmask = 3,
+			.cra_init = sun4i_ss_cipher_init,
 		}
 	}
 },
-{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+{       .type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.alg.crypto = {
-		.cra_name = "ecb(des)",
-		.cra_driver_name = "ecb-des-sun4i-ss",
-		.cra_priority = 300,
-		.cra_blocksize = DES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.cra_ctxsize = sizeof(struct sun4i_req_ctx),
-		.cra_module = THIS_MODULE,
-		.cra_alignmask = 3,
-		.cra_type = &crypto_ablkcipher_type,
-		.cra_init = sun4i_ss_cipher_init,
-		.cra_u.ablkcipher = {
-			.min_keysize    = DES_KEY_SIZE,
-			.max_keysize    = DES_KEY_SIZE,
-			.setkey         = sun4i_ss_des_setkey,
-			.encrypt        = sun4i_ss_ecb_des_encrypt,
-			.decrypt        = sun4i_ss_ecb_des_decrypt,
+		.setkey         = sun4i_ss_des_setkey,
+		.encrypt        = sun4i_ss_ecb_des_encrypt,
+		.decrypt        = sun4i_ss_ecb_des_decrypt,
+		.min_keysize    = DES_KEY_SIZE,
+		.max_keysize    = DES_KEY_SIZE,
+		.base = {
+			.cra_name = "ecb(des)",
+			.cra_driver_name = "ecb-des-sun4i-ss",
+			.cra_priority = 300,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_ctxsize = sizeof(struct sun4i_req_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_alignmask = 3,
+			.cra_init = sun4i_ss_cipher_init,
 		}
 	}
 },
-{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+{       .type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.alg.crypto = {
-		.cra_name = "cbc(des3_ede)",
-		.cra_driver_name = "cbc-des3-sun4i-ss",
-		.cra_priority = 300,
-		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.cra_ctxsize = sizeof(struct sun4i_req_ctx),
-		.cra_module = THIS_MODULE,
-		.cra_alignmask = 3,
-		.cra_type = &crypto_ablkcipher_type,
-		.cra_init = sun4i_ss_cipher_init,
-		.cra_u.ablkcipher = {
-			.min_keysize    = DES3_EDE_KEY_SIZE,
-			.max_keysize    = DES3_EDE_KEY_SIZE,
-			.ivsize         = DES3_EDE_BLOCK_SIZE,
-			.setkey         = sun4i_ss_des3_setkey,
-			.encrypt        = sun4i_ss_cbc_des3_encrypt,
-			.decrypt        = sun4i_ss_cbc_des3_decrypt,
+		.setkey         = sun4i_ss_des3_setkey,
+		.encrypt        = sun4i_ss_cbc_des3_encrypt,
+		.decrypt        = sun4i_ss_cbc_des3_decrypt,
+		.min_keysize    = DES3_EDE_KEY_SIZE,
+		.max_keysize    = DES3_EDE_KEY_SIZE,
+		.ivsize         = DES3_EDE_BLOCK_SIZE,
+		.base = {
+			.cra_name = "cbc(des3_ede)",
+			.cra_driver_name = "cbc-des3-sun4i-ss",
+			.cra_priority = 300,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_ctxsize = sizeof(struct sun4i_req_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_alignmask = 3,
+			.cra_init = sun4i_ss_cipher_init,
 		}
 	}
 },
-{       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+{       .type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.alg.crypto = {
-		.cra_name = "ecb(des3_ede)",
-		.cra_driver_name = "ecb-des3-sun4i-ss",
-		.cra_priority = 300,
-		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.cra_ctxsize = sizeof(struct sun4i_req_ctx),
-		.cra_module = THIS_MODULE,
-		.cra_alignmask = 3,
-		.cra_type = &crypto_ablkcipher_type,
-		.cra_init = sun4i_ss_cipher_init,
-		.cra_u.ablkcipher = {
-			.min_keysize    = DES3_EDE_KEY_SIZE,
-			.max_keysize    = DES3_EDE_KEY_SIZE,
-			.ivsize         = DES3_EDE_BLOCK_SIZE,
-			.setkey         = sun4i_ss_des3_setkey,
-			.encrypt        = sun4i_ss_ecb_des3_encrypt,
-			.decrypt        = sun4i_ss_ecb_des3_decrypt,
+		.setkey         = sun4i_ss_des3_setkey,
+		.encrypt        = sun4i_ss_ecb_des3_encrypt,
+		.decrypt        = sun4i_ss_ecb_des3_decrypt,
+		.min_keysize    = DES3_EDE_KEY_SIZE,
+		.max_keysize    = DES3_EDE_KEY_SIZE,
+		.ivsize         = DES3_EDE_BLOCK_SIZE,
+		.base = {
+			.cra_name = "ecb(des3_ede)",
+			.cra_driver_name = "ecb-des3-sun4i-ss",
+			.cra_priority = 300,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER,
+			.cra_ctxsize = sizeof(struct sun4i_req_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_alignmask = 3,
+			.cra_init = sun4i_ss_cipher_init,
 		}
 	}
 },
@@ -340,11 +339,11 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(ss_algs); i++) {
 		ss_algs[i].ss = ss;
 		switch (ss_algs[i].type) {
-		case CRYPTO_ALG_TYPE_ABLKCIPHER:
-			err = crypto_register_alg(&ss_algs[i].alg.crypto);
+		case CRYPTO_ALG_TYPE_SKCIPHER:
+			err = crypto_register_skcipher(&ss_algs[i].alg.crypto);
 			if (err) {
 				dev_err(ss->dev, "Fail to register %s\n",
-					ss_algs[i].alg.crypto.cra_name);
+					ss_algs[i].alg.crypto.base.cra_name);
 				goto error_alg;
 			}
 			break;
@@ -364,8 +363,8 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 	i--;
 	for (; i >= 0; i--) {
 		switch (ss_algs[i].type) {
-		case CRYPTO_ALG_TYPE_ABLKCIPHER:
-			crypto_unregister_alg(&ss_algs[i].alg.crypto);
+		case CRYPTO_ALG_TYPE_SKCIPHER:
+			crypto_unregister_skcipher(&ss_algs[i].alg.crypto);
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			crypto_unregister_ahash(&ss_algs[i].alg.hash);
@@ -388,8 +387,8 @@ static int sun4i_ss_remove(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(ss_algs); i++) {
 		switch (ss_algs[i].type) {
-		case CRYPTO_ALG_TYPE_ABLKCIPHER:
-			crypto_unregister_alg(&ss_algs[i].alg.crypto);
+		case CRYPTO_ALG_TYPE_SKCIPHER:
+			crypto_unregister_skcipher(&ss_algs[i].alg.crypto);
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			crypto_unregister_ahash(&ss_algs[i].alg.hash);
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
index f04c0f8cf026..a0e1efc1cb2a 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -24,9 +24,11 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <crypto/md5.h>
+#include <crypto/skcipher.h>
 #include <crypto/sha.h>
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/aes.h>
 #include <crypto/des.h>
 #include <crypto/internal/rng.h>
@@ -140,7 +142,7 @@ struct sun4i_ss_alg_template {
 	u32 type;
 	u32 mode;
 	union {
-		struct crypto_alg crypto;
+		struct skcipher_alg crypto;
 		struct ahash_alg hash;
 	} alg;
 	struct sun4i_ss_ctx *ss;
@@ -177,25 +179,25 @@ int sun4i_hash_import_md5(struct ahash_request *areq, const void *in);
 int sun4i_hash_export_sha1(struct ahash_request *areq, void *out);
 int sun4i_hash_import_sha1(struct ahash_request *areq, const void *in);
 
-int sun4i_ss_cbc_aes_encrypt(struct ablkcipher_request *areq);
-int sun4i_ss_cbc_aes_decrypt(struct ablkcipher_request *areq);
-int sun4i_ss_ecb_aes_encrypt(struct ablkcipher_request *areq);
-int sun4i_ss_ecb_aes_decrypt(struct ablkcipher_request *areq);
+int sun4i_ss_cbc_aes_encrypt(struct skcipher_request *areq);
+int sun4i_ss_cbc_aes_decrypt(struct skcipher_request *areq);
+int sun4i_ss_ecb_aes_encrypt(struct skcipher_request *areq);
+int sun4i_ss_ecb_aes_decrypt(struct skcipher_request *areq);
 
-int sun4i_ss_cbc_des_encrypt(struct ablkcipher_request *areq);
-int sun4i_ss_cbc_des_decrypt(struct ablkcipher_request *areq);
-int sun4i_ss_ecb_des_encrypt(struct ablkcipher_request *areq);
-int sun4i_ss_ecb_des_decrypt(struct ablkcipher_request *areq);
+int sun4i_ss_cbc_des_encrypt(struct skcipher_request *areq);
+int sun4i_ss_cbc_des_decrypt(struct skcipher_request *areq);
+int sun4i_ss_ecb_des_encrypt(struct skcipher_request *areq);
+int sun4i_ss_ecb_des_decrypt(struct skcipher_request *areq);
 
-int sun4i_ss_cbc_des3_encrypt(struct ablkcipher_request *areq);
-int sun4i_ss_cbc_des3_decrypt(struct ablkcipher_request *areq);
-int sun4i_ss_ecb_des3_encrypt(struct ablkcipher_request *areq);
-int sun4i_ss_ecb_des3_decrypt(struct ablkcipher_request *areq);
+int sun4i_ss_cbc_des3_encrypt(struct skcipher_request *areq);
+int sun4i_ss_cbc_des3_decrypt(struct skcipher_request *areq);
+int sun4i_ss_ecb_des3_encrypt(struct skcipher_request *areq);
+int sun4i_ss_ecb_des3_decrypt(struct skcipher_request *areq);
 
 int sun4i_ss_cipher_init(struct crypto_tfm *tfm);
-int sun4i_ss_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+int sun4i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen);
-int sun4i_ss_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen);
-int sun4i_ss_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			 unsigned int keylen);
-- 
2.9.4

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: ccm - honour alignmask of subordinate MAC cipher
Date: Sat, 11 Feb 2017 19:25:21 +0000
Message-ID: <1486841122-1686-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35302 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdBKTZe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2017 14:25:34 -0500
Received: by mail-wm0-f44.google.com with SMTP id v186so133295998wmd.0
        for <linux-crypto@vger.kernel.org>; Sat, 11 Feb 2017 11:25:34 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CCM driver was recently updated to defer the MAC part of the algorithm
to a dedicated crypto transform, and a template for instantiating such
transforms was added at the same time.

However, this new cbcmac template fails to take the alignmask of the
encapsulated cipher into account, which may result in buffer addresses
being passed down that are not sufficiently aligned.

So update the code to ensure that the digest buffer in the desc ctx
appears at a sufficiently aligned offset, and tweak the code so that all
calls to crypto_cipher_encrypt_one() operate on this buffer exclusively.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/ccm.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 52e307807ff6..24c26ab052ca 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -58,7 +58,6 @@ struct cbcmac_tfm_ctx {
 
 struct cbcmac_desc_ctx {
 	unsigned int len;
-	u8 dg[];
 };
 
 static inline struct crypto_ccm_req_priv_ctx *crypto_ccm_reqctx(
@@ -868,9 +867,10 @@ static int crypto_cbcmac_digest_init(struct shash_desc *pdesc)
 {
 	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	int bs = crypto_shash_digestsize(pdesc->tfm);
+	u8 *dg = (u8 *)ctx + crypto_shash_descsize(pdesc->tfm) - bs;
 
 	ctx->len = 0;
-	memset(ctx->dg, 0, bs);
+	memset(dg, 0, bs);
 
 	return 0;
 }
@@ -883,17 +883,18 @@ static int crypto_cbcmac_digest_update(struct shash_desc *pdesc, const u8 *p,
 	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_digestsize(parent);
+	u8 *dg = (u8 *)ctx + crypto_shash_descsize(parent) - bs;
 
 	while (len > 0) {
 		unsigned int l = min(len, bs - ctx->len);
 
-		crypto_xor(ctx->dg + ctx->len, p, l);
+		crypto_xor(dg + ctx->len, p, l);
 		ctx->len +=l;
 		len -= l;
 		p += l;
 
 		if (ctx->len == bs) {
-			crypto_cipher_encrypt_one(tfm, ctx->dg, ctx->dg);
+			crypto_cipher_encrypt_one(tfm, dg, dg);
 			ctx->len = 0;
 		}
 	}
@@ -908,12 +909,12 @@ static int crypto_cbcmac_digest_final(struct shash_desc *pdesc, u8 *out)
 	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_digestsize(parent);
+	u8 *dg = (u8 *)ctx + crypto_shash_descsize(parent) - bs;
 
 	if (ctx->len)
-		crypto_cipher_encrypt_one(tfm, out, ctx->dg);
-	else
-		memcpy(out, ctx->dg, bs);
+		crypto_cipher_encrypt_one(tfm, dg, dg);
 
+	memcpy(out, dg, bs);
 	return 0;
 }
 
@@ -969,7 +970,8 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_blocksize = 1;
 
 	inst->alg.digestsize = alg->cra_blocksize;
-	inst->alg.descsize = sizeof(struct cbcmac_desc_ctx) +
+	inst->alg.descsize = ALIGN(sizeof(struct cbcmac_desc_ctx),
+				   alg->cra_alignmask + 1) +
 			     alg->cra_blocksize;
 
 	inst->alg.base.cra_ctxsize = sizeof(struct cbcmac_tfm_ctx);
-- 
2.7.4

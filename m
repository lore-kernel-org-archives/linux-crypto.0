From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/10] crypto: aesni - Convert top-level rfc4106 algorithm to new interface
Date: Thu, 28 May 2015 22:08:03 +0800
Message-ID: <E1YxyTb-0002L9-6g@gondolin.me.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51923 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbbE1OIH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 10:08:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts rfc4106-gcm-aesni to the new AEAD interface.
The low-level interface remains as is for now because we can't
touch it until cryptd itself is upgraded.

In the conversion I've also removed the duplicate copy of the
context in the top-level algorithm.  Now all processing is carried
out in the low-level __driver-gcm-aes-aesni algorithm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/x86/crypto/aesni-intel_glue.c |  172 +++++++++++++++++--------------------
 1 file changed, 83 insertions(+), 89 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 2ade2400..5660a18 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -52,7 +52,6 @@ struct aesni_rfc4106_gcm_ctx {
 	u8 hash_subkey[16];
 	struct crypto_aes_ctx aes_key_expanded;
 	u8 nonce[4];
-	struct cryptd_aead *cryptd_tfm;
 };
 
 struct aesni_gcm_set_hash_subkey_result {
@@ -790,37 +789,30 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 #endif
 
 #ifdef CONFIG_X86_64
-static int rfc4106_init(struct crypto_tfm *tfm)
+static int rfc4106_init(struct crypto_aead *aead)
 {
 	struct cryptd_aead *cryptd_tfm;
-	struct aesni_rfc4106_gcm_ctx *ctx = (struct aesni_rfc4106_gcm_ctx *)
-		PTR_ALIGN((u8 *)crypto_tfm_ctx(tfm), AESNI_ALIGN);
-	struct crypto_aead *cryptd_child;
-	struct aesni_rfc4106_gcm_ctx *child_ctx;
+	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
+
 	cryptd_tfm = cryptd_alloc_aead("__driver-gcm-aes-aesni",
 				       CRYPTO_ALG_INTERNAL,
 				       CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(cryptd_tfm))
 		return PTR_ERR(cryptd_tfm);
 
-	cryptd_child = cryptd_aead_child(cryptd_tfm);
-	child_ctx = aesni_rfc4106_gcm_ctx_get(cryptd_child);
-	memcpy(child_ctx, ctx, sizeof(*ctx));
-	ctx->cryptd_tfm = cryptd_tfm;
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+	*ctx = cryptd_tfm;
+	crypto_aead_set_reqsize(
+		aead,
 		sizeof(struct aead_request) +
 		crypto_aead_reqsize(&cryptd_tfm->base));
 	return 0;
 }
 
-static void rfc4106_exit(struct crypto_tfm *tfm)
+static void rfc4106_exit(struct crypto_aead *aead)
 {
-	struct aesni_rfc4106_gcm_ctx *ctx =
-		(struct aesni_rfc4106_gcm_ctx *)
-		PTR_ALIGN((u8 *)crypto_tfm_ctx(tfm), AESNI_ALIGN);
-	if (!IS_ERR(ctx->cryptd_tfm))
-		cryptd_free_aead(ctx->cryptd_tfm);
-	return;
+	struct cryptd_aead **ctx = crypto_aead_ctx(aead);
+
+	cryptd_free_aead(*ctx);
 }
 
 static void
@@ -951,18 +943,10 @@ exit:
 static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
 			   unsigned int key_len)
 {
-	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
-	struct crypto_aead *child = cryptd_aead_child(ctx->cryptd_tfm);
-	struct aesni_rfc4106_gcm_ctx *c_ctx = aesni_rfc4106_gcm_ctx_get(child);
-	struct cryptd_aead *cryptd_tfm = ctx->cryptd_tfm;
-	int ret;
+	struct cryptd_aead **ctx = crypto_aead_ctx(parent);
+	struct cryptd_aead *cryptd_tfm = *ctx;
 
-	ret = crypto_aead_setkey(child, key, key_len);
-	if (!ret) {
-		memcpy(ctx, c_ctx, sizeof(*ctx));
-		ctx->cryptd_tfm = cryptd_tfm;
-	}
-	return ret;
+	return crypto_aead_setkey(&cryptd_tfm->base, key, key_len);
 }
 
 static int common_rfc4106_set_authsize(struct crypto_aead *aead,
@@ -985,14 +969,10 @@ static int common_rfc4106_set_authsize(struct crypto_aead *aead,
 static int rfc4106_set_authsize(struct crypto_aead *parent,
 				unsigned int authsize)
 {
-	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
-	struct crypto_aead *child = cryptd_aead_child(ctx->cryptd_tfm);
-	int ret;
+	struct cryptd_aead **ctx = crypto_aead_ctx(parent);
+	struct cryptd_aead *cryptd_tfm = *ctx;
 
-	ret = crypto_aead_setauthsize(child, authsize);
-	if (!ret)
-		crypto_aead_crt(parent)->authsize = authsize;
-	return ret;
+	return crypto_aead_setauthsize(&cryptd_tfm->base, authsize);
 }
 
 static int __driver_rfc4106_encrypt(struct aead_request *req)
@@ -1171,44 +1151,42 @@ static int __driver_rfc4106_decrypt(struct aead_request *req)
 
 static int rfc4106_encrypt(struct aead_request *req)
 {
-	int ret;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
+	struct cryptd_aead **ctx = crypto_aead_ctx(tfm);
+	struct cryptd_aead *cryptd_tfm = *ctx;
+	struct aead_request *subreq = aead_request_ctx(req);
 
-	if (!irq_fpu_usable()) {
-		struct aead_request *cryptd_req =
-			(struct aead_request *) aead_request_ctx(req);
+	aead_request_set_tfm(subreq, irq_fpu_usable() ?
+				     cryptd_aead_child(cryptd_tfm) :
+				     &cryptd_tfm->base);
 
-		memcpy(cryptd_req, req, sizeof(*req));
-		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
-		ret = crypto_aead_encrypt(cryptd_req);
-	} else {
-		kernel_fpu_begin();
-		ret = __driver_rfc4106_encrypt(req);
-		kernel_fpu_end();
-	}
-	return ret;
+	aead_request_set_callback(subreq, req->base.flags,
+				  req->base.complete, req->base.data);
+	aead_request_set_crypt(subreq, req->src, req->dst,
+			       req->cryptlen, req->iv);
+	aead_request_set_ad(subreq, req->assoclen);
+
+	return crypto_aead_encrypt(subreq);
 }
 
 static int rfc4106_decrypt(struct aead_request *req)
 {
-	int ret;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
+	struct cryptd_aead **ctx = crypto_aead_ctx(tfm);
+	struct cryptd_aead *cryptd_tfm = *ctx;
+	struct aead_request *subreq = aead_request_ctx(req);
 
-	if (!irq_fpu_usable()) {
-		struct aead_request *cryptd_req =
-			(struct aead_request *) aead_request_ctx(req);
+	aead_request_set_tfm(subreq, irq_fpu_usable() ?
+				     cryptd_aead_child(cryptd_tfm) :
+				     &cryptd_tfm->base);
 
-		memcpy(cryptd_req, req, sizeof(*req));
-		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
-		ret = crypto_aead_decrypt(cryptd_req);
-	} else {
-		kernel_fpu_begin();
-		ret = __driver_rfc4106_decrypt(req);
-		kernel_fpu_end();
-	}
-	return ret;
+	aead_request_set_callback(subreq, req->base.flags,
+				  req->base.complete, req->base.data);
+	aead_request_set_crypt(subreq, req->src, req->dst,
+			       req->cryptlen, req->iv);
+	aead_request_set_ad(subreq, req->assoclen);
+
+	return crypto_aead_decrypt(subreq);
 }
 
 static int helper_rfc4106_encrypt(struct aead_request *req)
@@ -1432,30 +1410,6 @@ static struct crypto_alg aesni_algs[] = { {
 			.maxauthsize	= 16,
 		},
 	},
-}, {
-	.cra_name		= "rfc4106(gcm(aes))",
-	.cra_driver_name	= "rfc4106-gcm-aesni",
-	.cra_priority		= 400,
-	.cra_flags		= CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= 1,
-	.cra_ctxsize		= sizeof(struct aesni_rfc4106_gcm_ctx) +
-				  AESNI_ALIGN,
-	.cra_alignmask		= 0,
-	.cra_type		= &crypto_nivaead_type,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= rfc4106_init,
-	.cra_exit		= rfc4106_exit,
-	.cra_u = {
-		.aead = {
-			.setkey		= rfc4106_set_key,
-			.setauthsize	= rfc4106_set_authsize,
-			.encrypt	= rfc4106_encrypt,
-			.decrypt	= rfc4106_decrypt,
-			.geniv		= "seqiv",
-			.ivsize		= 8,
-			.maxauthsize	= 16,
-		},
-	},
 #endif
 #if IS_ENABLED(CONFIG_CRYPTO_PCBC)
 }, {
@@ -1570,6 +1524,30 @@ static struct crypto_alg aesni_algs[] = { {
 	},
 } };
 
+#ifdef CONFIG_X86_64
+static struct aead_alg aesni_aead_algs[] = { {
+	.init			= rfc4106_init,
+	.exit			= rfc4106_exit,
+	.setkey			= rfc4106_set_key,
+	.setauthsize		= rfc4106_set_authsize,
+	.encrypt		= rfc4106_encrypt,
+	.decrypt		= rfc4106_decrypt,
+	.ivsize			= 8,
+	.maxauthsize		= 16,
+	.base = {
+		.cra_name		= "rfc4106(gcm(aes))",
+		.cra_driver_name	= "rfc4106-gcm-aesni",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= sizeof(struct cryptd_aead *),
+		.cra_module		= THIS_MODULE,
+	},
+} };
+#else
+static struct aead_alg aesni_aead_algs[0];
+#endif
+
 
 static const struct x86_cpu_id aesni_cpu_id[] = {
 	X86_FEATURE_MATCH(X86_FEATURE_AES),
@@ -1617,11 +1595,27 @@ static int __init aesni_init(void)
 	if (err)
 		return err;
 
-	return crypto_register_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
+	err = crypto_register_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
+	if (err)
+		goto fpu_exit;
+
+	err = crypto_register_aeads(aesni_aead_algs,
+				    ARRAY_SIZE(aesni_aead_algs));
+	if (err)
+		goto unregister_algs;
+
+	return err;
+
+unregister_algs:
+	crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
+fpu_exit:
+	crypto_fpu_exit();
+	return err;
 }
 
 static void __exit aesni_exit(void)
 {
+	crypto_unregister_aeads(aesni_aead_algs, ARRAY_SIZE(aesni_aead_algs));
 	crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
 
 	crypto_fpu_exit();

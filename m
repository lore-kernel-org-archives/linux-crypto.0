From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: aesni - make driver-gcm-aes-aesni helper a proper
 aead alg
Date: Fri, 06 Feb 2015 10:25:20 -0800
Message-ID: <20150206182520.5705.54282.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: adrian.hoban@intel.com, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33084 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492AbbBFS3A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Feb 2015 13:29:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changed the __driver-gcm-aes-aesni to be a proper aead algorithm.
This required a valid setkey and setauthsize functions to be added and also
some changes to make sure that math context is not corrupted when the alg is
used directly.
Note that the __driver-gcm-aes-aesni should not be used directly by modules
that can use it in interrupt context as we don't have a good fallback mechanism
in this case.

Signed-off-by: Adrian Hoban <adrian.hoban@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 arch/x86/crypto/aesni-intel_glue.c |  164 ++++++++++++++++++++++++------------
 1 file changed, 110 insertions(+), 54 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 947c6bf..6893f49 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -890,15 +890,12 @@ out_free_ablkcipher:
 	return ret;
 }
 
-static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
-						   unsigned int key_len)
+static int common_rfc4106_set_key(struct crypto_aead *aead, const u8 *key,
+				  unsigned int key_len)
 {
 	int ret = 0;
-	struct crypto_tfm *tfm = crypto_aead_tfm(parent);
-	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
-	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
-	struct aesni_rfc4106_gcm_ctx *child_ctx =
-                                 aesni_rfc4106_gcm_ctx_get(cryptd_child);
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(aead);
 	u8 *new_key_align, *new_key_mem = NULL;
 
 	if (key_len < 4) {
@@ -943,20 +940,31 @@ static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
 		goto exit;
 	}
 	ret = rfc4106_set_hash_subkey(ctx->hash_subkey, key, key_len);
-	memcpy(child_ctx, ctx, sizeof(*ctx));
 exit:
 	kfree(new_key_mem);
 	return ret;
 }
 
-/* This is the Integrity Check Value (aka the authentication tag length and can
- * be 8, 12 or 16 bytes long. */
-static int rfc4106_set_authsize(struct crypto_aead *parent,
-				unsigned int authsize)
+static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
+			   unsigned int key_len)
 {
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
-	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
+	struct crypto_aead *child = cryptd_aead_child(ctx->cryptd_tfm);
+	struct aesni_rfc4106_gcm_ctx *c_ctx = aesni_rfc4106_gcm_ctx_get(child);
+	struct cryptd_aead *cryptd_tfm = ctx->cryptd_tfm;
+	int ret;
 
+	ret = crypto_aead_setkey(child, key, key_len);
+	if (!ret) {
+		memcpy(ctx, c_ctx, sizeof(*ctx));
+		ctx->cryptd_tfm = cryptd_tfm;
+	}
+	return ret;
+}
+
+static int common_rfc4106_set_authsize(struct crypto_aead *aead,
+				       unsigned int authsize)
+{
 	switch (authsize) {
 	case 8:
 	case 12:
@@ -965,51 +973,23 @@ static int rfc4106_set_authsize(struct crypto_aead *parent,
 	default:
 		return -EINVAL;
 	}
-	crypto_aead_crt(parent)->authsize = authsize;
-	crypto_aead_crt(cryptd_child)->authsize = authsize;
+	crypto_aead_crt(aead)->authsize = authsize;
 	return 0;
 }
 
-static int rfc4106_encrypt(struct aead_request *req)
-{
-	int ret;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
-
-	if (!irq_fpu_usable()) {
-		struct aead_request *cryptd_req =
-			(struct aead_request *) aead_request_ctx(req);
-		memcpy(cryptd_req, req, sizeof(*req));
-		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
-		return crypto_aead_encrypt(cryptd_req);
-	} else {
-		struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
-		kernel_fpu_begin();
-		ret = cryptd_child->base.crt_aead.encrypt(req);
-		kernel_fpu_end();
-		return ret;
-	}
-}
-
-static int rfc4106_decrypt(struct aead_request *req)
+/* This is the Integrity Check Value (aka the authentication tag length and can
+ * be 8, 12 or 16 bytes long. */
+static int rfc4106_set_authsize(struct crypto_aead *parent,
+				unsigned int authsize)
 {
+	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
+	struct crypto_aead *child = cryptd_aead_child(ctx->cryptd_tfm);
 	int ret;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
 
-	if (!irq_fpu_usable()) {
-		struct aead_request *cryptd_req =
-			(struct aead_request *) aead_request_ctx(req);
-		memcpy(cryptd_req, req, sizeof(*req));
-		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
-		return crypto_aead_decrypt(cryptd_req);
-	} else {
-		struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
-		kernel_fpu_begin();
-		ret = cryptd_child->base.crt_aead.decrypt(req);
-		kernel_fpu_end();
-		return ret;
-	}
+	ret = crypto_aead_setauthsize(child, authsize);
+	if (!ret)
+		crypto_aead_crt(parent)->authsize = authsize;
+	return ret;
 }
 
 static int __driver_rfc4106_encrypt(struct aead_request *req)
@@ -1185,6 +1165,78 @@ static int __driver_rfc4106_decrypt(struct aead_request *req)
 	}
 	return retval;
 }
+
+static int rfc4106_encrypt(struct aead_request *req)
+{
+	int ret;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
+
+	if (!irq_fpu_usable()) {
+		struct aead_request *cryptd_req =
+			(struct aead_request *) aead_request_ctx(req);
+
+		memcpy(cryptd_req, req, sizeof(*req));
+		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+		ret = crypto_aead_encrypt(cryptd_req);
+	} else {
+		kernel_fpu_begin();
+		ret = __driver_rfc4106_encrypt(req);
+		kernel_fpu_end();
+	}
+	return ret;
+}
+
+static int rfc4106_decrypt(struct aead_request *req)
+{
+	int ret;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
+
+	if (!irq_fpu_usable()) {
+		struct aead_request *cryptd_req =
+			(struct aead_request *) aead_request_ctx(req);
+
+		memcpy(cryptd_req, req, sizeof(*req));
+		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+		ret = crypto_aead_decrypt(cryptd_req);
+	} else {
+		kernel_fpu_begin();
+		ret = __driver_rfc4106_decrypt(req);
+		kernel_fpu_end();
+	}
+	return ret;
+}
+
+static int helper_rfc4106_encrypt(struct aead_request *req)
+{
+	int ret;
+
+	if (unlikely(!irq_fpu_usable())) {
+		WARN_ONCE(1, "__gcm-aes-aesni alg used in invalid context");
+		ret = -EINVAL;
+	} else {
+		kernel_fpu_begin();
+		ret = __driver_rfc4106_encrypt(req);
+		kernel_fpu_end();
+	}
+	return ret;
+}
+
+static int helper_rfc4106_decrypt(struct aead_request *req)
+{
+	int ret;
+
+	if (unlikely(!irq_fpu_usable())) {
+		WARN_ONCE(1, "__gcm-aes-aesni alg used in invalid context");
+		ret = -EINVAL;
+	} else {
+		kernel_fpu_begin();
+		ret = __driver_rfc4106_decrypt(req);
+		kernel_fpu_end();
+	}
+	return ret;
+}
 #endif
 
 static struct crypto_alg aesni_algs[] = { {
@@ -1366,8 +1418,12 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_module		= THIS_MODULE,
 	.cra_u = {
 		.aead = {
-			.encrypt	= __driver_rfc4106_encrypt,
-			.decrypt	= __driver_rfc4106_decrypt,
+			.setkey		= common_rfc4106_set_key,
+			.setauthsize	= common_rfc4106_set_authsize,
+			.encrypt	= helper_rfc4106_encrypt,
+			.decrypt	= helper_rfc4106_decrypt,
+			.ivsize		= 8,
+			.maxauthsize	= 16,
 		},
 	},
 }, {

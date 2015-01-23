From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: aesni - make driver-gcm-aes-aesni helper a proper
 aead alg
Date: Fri, 23 Jan 2015 14:33:57 -0800
Message-ID: <20150123223357.15316.72597.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:64588 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbbAWWhZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Jan 2015 17:37:25 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changed the __driver-gcm-aes-aesni to be a proper aead algorithm.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 arch/x86/crypto/aesni-intel_glue.c |   53 ++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 947c6bf..5544ad9 100644
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
@@ -943,20 +940,29 @@ static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
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
 	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
+	struct aesni_rfc4106_gcm_ctx *child_ctx =
+		aesni_rfc4106_gcm_ctx_get(cryptd_child);
+	int ret;
 
+	ret = common_rfc4106_set_key(parent, key, key_len);
+	if (!ret)
+		memcpy(child_ctx, ctx, sizeof(*ctx));
+	return ret;
+}
+
+static int common_rfc4106_set_authsize(struct crypto_aead *aead,
+				       unsigned int authsize)
+{
 	switch (authsize) {
 	case 8:
 	case 12:
@@ -965,11 +971,26 @@ static int rfc4106_set_authsize(struct crypto_aead *parent,
 	default:
 		return -EINVAL;
 	}
-	crypto_aead_crt(parent)->authsize = authsize;
-	crypto_aead_crt(cryptd_child)->authsize = authsize;
+	crypto_aead_crt(aead)->authsize = authsize;
 	return 0;
 }
 
+/* This is the Integrity Check Value (aka the authentication tag length and can
+ * be 8, 12 or 16 bytes long. */
+static int rfc4106_set_authsize(struct crypto_aead *parent,
+				unsigned int authsize)
+{
+	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
+	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
+	int ret;
+
+	ret = common_rfc4106_set_authsize(parent, authsize);
+	if (!ret)
+		ret = common_rfc4106_set_authsize(cryptd_child, authsize);
+
+	return ret;
+}
+
 static int rfc4106_encrypt(struct aead_request *req)
 {
 	int ret;
@@ -1366,8 +1387,12 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_module		= THIS_MODULE,
 	.cra_u = {
 		.aead = {
+			.setkey		= common_rfc4106_set_key,
+			.setauthsize	= common_rfc4106_set_authsize,
 			.encrypt	= __driver_rfc4106_encrypt,
 			.decrypt	= __driver_rfc4106_decrypt,
+			.ivsize		= 8,
+			.maxauthsize	= 16,
 		},
 	},
 }, {

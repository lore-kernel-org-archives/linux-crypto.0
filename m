Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbfAJUSY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 15:18:24 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Dave Watson <davejwatson@fb.com>
Subject: [PATCH 06/11] crypto: x86/aesni-gcm - make 'struct aesni_gcm_tfm_s' static const
Date: Thu, 10 Jan 2019 12:17:57 -0800
Message-Id: <20190110201802.82442-7-ebiggers@kernel.org>
In-Reply-To: <20190110201802.82442-1-ebiggers@kernel.org>
References: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Add missing static keywords to fix the following sparse warnings:

    arch/x86/crypto/aesni-intel_glue.c:197:24: warning: symbol 'aesni_gcm_tfm_sse' was not declared. Should it be static?
    arch/x86/crypto/aesni-intel_glue.c:246:24: warning: symbol 'aesni_gcm_tfm_avx_gen2' was not declared. Should it be static?
    arch/x86/crypto/aesni-intel_glue.c:291:24: warning: symbol 'aesni_gcm_tfm_avx_gen4' was not declared. Should it be static?

I also made the affected structures 'const', and adjusted the
indentation in the struct definition to not be insane.

Cc: Dave Watson <davejwatson@fb.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 34 ++++++++++++------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 1321700d6647f..9b5ccde3ef315 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -175,26 +175,18 @@ asmlinkage void aesni_gcm_finalize(void *ctx,
 				   struct gcm_context_data *gdata,
 				   u8 *auth_tag, unsigned long auth_tag_len);
 
-static struct aesni_gcm_tfm_s {
-void (*init)(void *ctx,
-				struct gcm_context_data *gdata,
-				u8 *iv,
-				u8 *hash_subkey, const u8 *aad,
-				unsigned long aad_len);
-void (*enc_update)(void *ctx,
-					struct gcm_context_data *gdata, u8 *out,
-					const u8 *in,
-					unsigned long plaintext_len);
-void (*dec_update)(void *ctx,
-					struct gcm_context_data *gdata, u8 *out,
-					const u8 *in,
-					unsigned long ciphertext_len);
-void (*finalize)(void *ctx,
-				struct gcm_context_data *gdata,
-				u8 *auth_tag, unsigned long auth_tag_len);
+static const struct aesni_gcm_tfm_s {
+	void (*init)(void *ctx, struct gcm_context_data *gdata, u8 *iv,
+		     u8 *hash_subkey, const u8 *aad, unsigned long aad_len);
+	void (*enc_update)(void *ctx, struct gcm_context_data *gdata, u8 *out,
+			   const u8 *in, unsigned long plaintext_len);
+	void (*dec_update)(void *ctx, struct gcm_context_data *gdata, u8 *out,
+			   const u8 *in, unsigned long ciphertext_len);
+	void (*finalize)(void *ctx, struct gcm_context_data *gdata,
+			 u8 *auth_tag, unsigned long auth_tag_len);
 } *aesni_gcm_tfm;
 
-struct aesni_gcm_tfm_s aesni_gcm_tfm_sse = {
+static const struct aesni_gcm_tfm_s aesni_gcm_tfm_sse = {
 	.init = &aesni_gcm_init,
 	.enc_update = &aesni_gcm_enc_update,
 	.dec_update = &aesni_gcm_dec_update,
@@ -243,7 +235,7 @@ asmlinkage void aesni_gcm_dec_avx_gen2(void *ctx,
 			const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
-struct aesni_gcm_tfm_s aesni_gcm_tfm_avx_gen2 = {
+static const struct aesni_gcm_tfm_s aesni_gcm_tfm_avx_gen2 = {
 	.init = &aesni_gcm_init_avx_gen2,
 	.enc_update = &aesni_gcm_enc_update_avx_gen2,
 	.dec_update = &aesni_gcm_dec_update_avx_gen2,
@@ -288,7 +280,7 @@ asmlinkage void aesni_gcm_dec_avx_gen4(void *ctx,
 			const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
-struct aesni_gcm_tfm_s aesni_gcm_tfm_avx_gen4 = {
+static const struct aesni_gcm_tfm_s aesni_gcm_tfm_avx_gen4 = {
 	.init = &aesni_gcm_init_avx_gen4,
 	.enc_update = &aesni_gcm_enc_update_avx_gen4,
 	.dec_update = &aesni_gcm_dec_update_avx_gen4,
@@ -778,7 +770,7 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
-	struct aesni_gcm_tfm_s *gcm_tfm = aesni_gcm_tfm;
+	const struct aesni_gcm_tfm_s *gcm_tfm = aesni_gcm_tfm;
 	struct gcm_context_data data AESNI_ALIGN_ATTR;
 	struct scatter_walk dst_sg_walk = {};
 	unsigned long left = req->cryptlen;
-- 
2.20.1.97.g81188d93c3-goog

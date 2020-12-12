Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E262C433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 09:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D845E23BCD
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 09:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390938AbgLLJzM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Dec 2020 04:55:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390925AbgLLJzK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Dec 2020 04:55:10 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/4] crypto: x86/gcm-aes-ni - drop unused asm prototypes
Date:   Sat, 12 Dec 2020 10:16:58 +0100
Message-Id: <20201212091700.11776-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201212091700.11776-1-ardb@kernel.org>
References: <20201212091700.11776-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop some prototypes that are declared but never called.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 67 --------------------
 1 file changed, 67 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 223670feaffa..063cf579a8fc 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -111,49 +111,6 @@ asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 asmlinkage void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *out,
 				 const u8 *in, bool enc, le128 *iv);
 
-/* asmlinkage void aesni_gcm_enc()
- * void *ctx,  AES Key schedule. Starts on a 16 byte boundary.
- * struct gcm_context_data.  May be uninitialized.
- * u8 *out, Ciphertext output. Encrypt in-place is allowed.
- * const u8 *in, Plaintext input
- * unsigned long plaintext_len, Length of data in bytes for encryption.
- * u8 *iv, Pre-counter block j0: 12 byte IV concatenated with 0x00000001.
- *         16-byte aligned pointer.
- * u8 *hash_subkey, the Hash sub key input. Data starts on a 16-byte boundary.
- * const u8 *aad, Additional Authentication Data (AAD)
- * unsigned long aad_len, Length of AAD in bytes.
- * u8 *auth_tag, Authenticated Tag output.
- * unsigned long auth_tag_len), Authenticated Tag Length in bytes.
- *          Valid values are 16 (most likely), 12 or 8.
- */
-asmlinkage void aesni_gcm_enc(void *ctx,
-			struct gcm_context_data *gdata, u8 *out,
-			const u8 *in, unsigned long plaintext_len, u8 *iv,
-			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
-			u8 *auth_tag, unsigned long auth_tag_len);
-
-/* asmlinkage void aesni_gcm_dec()
- * void *ctx, AES Key schedule. Starts on a 16 byte boundary.
- * struct gcm_context_data.  May be uninitialized.
- * u8 *out, Plaintext output. Decrypt in-place is allowed.
- * const u8 *in, Ciphertext input
- * unsigned long ciphertext_len, Length of data in bytes for decryption.
- * u8 *iv, Pre-counter block j0: 12 byte IV concatenated with 0x00000001.
- *         16-byte aligned pointer.
- * u8 *hash_subkey, the Hash sub key input. Data starts on a 16-byte boundary.
- * const u8 *aad, Additional Authentication Data (AAD)
- * unsigned long aad_len, Length of AAD in bytes. With RFC4106 this is going
- * to be 8 or 12 bytes
- * u8 *auth_tag, Authenticated Tag output.
- * unsigned long auth_tag_len) Authenticated Tag Length in bytes.
- * Valid values are 16 (most likely), 12 or 8.
- */
-asmlinkage void aesni_gcm_dec(void *ctx,
-			struct gcm_context_data *gdata, u8 *out,
-			const u8 *in, unsigned long ciphertext_len, u8 *iv,
-			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
-			u8 *auth_tag, unsigned long auth_tag_len);
-
 /* Scatter / Gather routines, with args similar to above */
 asmlinkage void aesni_gcm_init(void *ctx,
 			       struct gcm_context_data *gdata,
@@ -218,18 +175,6 @@ asmlinkage void aesni_gcm_finalize_avx_gen2(void *ctx,
 				   struct gcm_context_data *gdata,
 				   u8 *auth_tag, unsigned long auth_tag_len);
 
-asmlinkage void aesni_gcm_enc_avx_gen2(void *ctx,
-				struct gcm_context_data *gdata, u8 *out,
-			const u8 *in, unsigned long plaintext_len, u8 *iv,
-			const u8 *aad, unsigned long aad_len,
-			u8 *auth_tag, unsigned long auth_tag_len);
-
-asmlinkage void aesni_gcm_dec_avx_gen2(void *ctx,
-				struct gcm_context_data *gdata, u8 *out,
-			const u8 *in, unsigned long ciphertext_len, u8 *iv,
-			const u8 *aad, unsigned long aad_len,
-			u8 *auth_tag, unsigned long auth_tag_len);
-
 static const struct aesni_gcm_tfm_s aesni_gcm_tfm_avx_gen2 = {
 	.init = &aesni_gcm_init_avx_gen2,
 	.enc_update = &aesni_gcm_enc_update_avx_gen2,
@@ -260,18 +205,6 @@ asmlinkage void aesni_gcm_finalize_avx_gen4(void *ctx,
 				   struct gcm_context_data *gdata,
 				   u8 *auth_tag, unsigned long auth_tag_len);
 
-asmlinkage void aesni_gcm_enc_avx_gen4(void *ctx,
-				struct gcm_context_data *gdata, u8 *out,
-			const u8 *in, unsigned long plaintext_len, u8 *iv,
-			const u8 *aad, unsigned long aad_len,
-			u8 *auth_tag, unsigned long auth_tag_len);
-
-asmlinkage void aesni_gcm_dec_avx_gen4(void *ctx,
-				struct gcm_context_data *gdata, u8 *out,
-			const u8 *in, unsigned long ciphertext_len, u8 *iv,
-			const u8 *aad, unsigned long aad_len,
-			u8 *auth_tag, unsigned long auth_tag_len);
-
 static const struct aesni_gcm_tfm_s aesni_gcm_tfm_avx_gen4 = {
 	.init = &aesni_gcm_init_avx_gen4,
 	.enc_update = &aesni_gcm_enc_update_avx_gen4,
-- 
2.17.1


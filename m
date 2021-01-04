Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1603EC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA0BB207AE
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbhADP4s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:56:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbhADP4s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 10:56:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDD9F2245C;
        Mon,  4 Jan 2021 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609775767;
        bh=MN0kv1pL0o/firwVhRVdhZ364/6dOvxEj3IQDkTB9hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXAIFW5BIxRfgvOZaVlbYu1VY9h6L6Mo8pQNb5XotXFcXRYeGcVqG7XQAmwR2OnFG
         biYg/h7RDa15LJev20J1v97/bwss28bHBdcNEev9gTp93q2n/xknQvswZYH0CAuE+I
         Sto4NZGCFf3RpoQtc4mV42/v20KLOQg/M+t6H2FrvE1yiW5l/mIRgC3lsWzG0WoeCy
         GFwe/YIrcQSM4s3tBhsOYkm+tdP0vGNmf/Cqc4BM9mIgSucZgFMJrZvhIU1IQJvU+B
         FrVvkvAlW1ojtrtWfseTkczLTS8PXz8Ja60bEJt7XybbL5FKn7uANe1bdsADiu1aT4
         Y0YBq7Pke2fnw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 2/5] crypto: x86/gcm-aes-ni - drop unused asm prototypes
Date:   Mon,  4 Jan 2021 16:55:47 +0100
Message-Id: <20210104155550.6359-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210104155550.6359-1-ardb@kernel.org>
References: <20210104155550.6359-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop some prototypes that are declared but never called.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 67 --------------------
 1 file changed, 67 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 880f9f8b5153..0f124d72e6b4 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -111,49 +111,6 @@ static void (*aesni_ctr_enc_tfm)(struct crypto_aes_ctx *ctx, u8 *out,
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
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


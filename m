Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC977C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C1F8207AE
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbhADP5Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:57:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbhADP5Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 10:57:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F397224DE;
        Mon,  4 Jan 2021 15:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609775772;
        bh=XwkMj3UyhDAvM1CWdFbT9VpLilKcvxCu85BcKqLxzU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3s3E77DL2M3JRLACawYBGu4x5xFGEO6D/1WFEIWqTTCjGGcbn+roFCYR2F0vs0b2
         FQ1+gD5bAX878WNRXQdsTPND8ArRoQrJUci44Ki2QnfV+KPLbcE6kuHF+RjOm8Kywi
         94m+IfGbEMnxN34xNkGIIG0N4oNBQWCplem9sC6iJLYhbgvklLWL5NU3kx33zpPgaL
         fsITpuw0x3GLeqCpN7Nz9KC3d+3giD/WFkV9PlHiJhFkpoKKbKiXPLMMwjG1jE642B
         Q86UJ2JHkV6acSpQYIPvE2bDPKYplyEYl2TxzwmB98bKJgrLoumhPXSP5UdXaQ0Pcd
         orgFZImHbAebQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 5/5] crypto: x86/gcm-aes-ni - replace function pointers with static branches
Date:   Mon,  4 Jan 2021 16:55:50 +0100
Message-Id: <20210104155550.6359-6-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210104155550.6359-1-ardb@kernel.org>
References: <20210104155550.6359-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace the function pointers in the GCM implementation with static branches,
which are based on code patching, which occurs only at module load time.
This avoids the severe performance penalty caused by the use of retpolines.

In order to retain the ability to switch between different versions of the
implementation based on the input size on cores that support AVX and AVX2,
use static branches instead of static calls.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 98 +++++++++++---------
 1 file changed, 54 insertions(+), 44 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index d0b4fa7bd2d0..fb17d4a2a5ca 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -31,6 +31,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
+#include <linux/jump_label.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 
@@ -128,24 +129,6 @@ asmlinkage void aesni_gcm_finalize(void *ctx,
 				   struct gcm_context_data *gdata,
 				   u8 *auth_tag, unsigned long auth_tag_len);
 
-static const struct aesni_gcm_tfm_s {
-	void (*init)(void *ctx, struct gcm_context_data *gdata, u8 *iv,
-		     u8 *hash_subkey, const u8 *aad, unsigned long aad_len);
-	void (*enc_update)(void *ctx, struct gcm_context_data *gdata, u8 *out,
-			   const u8 *in, unsigned long plaintext_len);
-	void (*dec_update)(void *ctx, struct gcm_context_data *gdata, u8 *out,
-			   const u8 *in, unsigned long ciphertext_len);
-	void (*finalize)(void *ctx, struct gcm_context_data *gdata,
-			 u8 *auth_tag, unsigned long auth_tag_len);
-} *aesni_gcm_tfm;
-
-static const struct aesni_gcm_tfm_s aesni_gcm_tfm_sse = {
-	.init = &aesni_gcm_init,
-	.enc_update = &aesni_gcm_enc_update,
-	.dec_update = &aesni_gcm_dec_update,
-	.finalize = &aesni_gcm_finalize,
-};
-
 asmlinkage void aes_ctr_enc_128_avx_by8(const u8 *in, u8 *iv,
 		void *keys, u8 *out, unsigned int num_bytes);
 asmlinkage void aes_ctr_enc_192_avx_by8(const u8 *in, u8 *iv,
@@ -175,13 +158,6 @@ asmlinkage void aesni_gcm_finalize_avx_gen2(void *ctx,
 				   struct gcm_context_data *gdata,
 				   u8 *auth_tag, unsigned long auth_tag_len);
 
-static const struct aesni_gcm_tfm_s aesni_gcm_tfm_avx_gen2 = {
-	.init = &aesni_gcm_init_avx_gen2,
-	.enc_update = &aesni_gcm_enc_update_avx_gen2,
-	.dec_update = &aesni_gcm_dec_update_avx_gen2,
-	.finalize = &aesni_gcm_finalize_avx_gen2,
-};
-
 /*
  * asmlinkage void aesni_gcm_init_avx_gen4()
  * gcm_data *my_ctx_data, context data
@@ -205,12 +181,8 @@ asmlinkage void aesni_gcm_finalize_avx_gen4(void *ctx,
 				   struct gcm_context_data *gdata,
 				   u8 *auth_tag, unsigned long auth_tag_len);
 
-static const struct aesni_gcm_tfm_s aesni_gcm_tfm_avx_gen4 = {
-	.init = &aesni_gcm_init_avx_gen4,
-	.enc_update = &aesni_gcm_enc_update_avx_gen4,
-	.dec_update = &aesni_gcm_dec_update_avx_gen4,
-	.finalize = &aesni_gcm_finalize_avx_gen4,
-};
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(gcm_use_avx);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(gcm_use_avx2);
 
 static inline struct
 aesni_rfc4106_gcm_ctx *aesni_rfc4106_gcm_ctx_get(struct crypto_aead *tfm)
@@ -641,12 +613,12 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 			      u8 *iv, void *aes_ctx, u8 *auth_tag,
 			      unsigned long auth_tag_len)
 {
-	const struct aesni_gcm_tfm_s *gcm_tfm = aesni_gcm_tfm;
 	u8 databuf[sizeof(struct gcm_context_data) + (AESNI_ALIGN - 8)] __aligned(8);
 	struct gcm_context_data *data = PTR_ALIGN((void *)databuf, AESNI_ALIGN);
 	unsigned long left = req->cryptlen;
 	struct scatter_walk assoc_sg_walk;
 	struct skcipher_walk walk;
+	bool do_avx, do_avx2;
 	u8 *assocmem = NULL;
 	u8 *assoc;
 	int err;
@@ -654,10 +626,8 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 	if (!enc)
 		left -= auth_tag_len;
 
-	if (left < AVX_GEN4_OPTSIZE && gcm_tfm == &aesni_gcm_tfm_avx_gen4)
-		gcm_tfm = &aesni_gcm_tfm_avx_gen2;
-	if (left < AVX_GEN2_OPTSIZE && gcm_tfm == &aesni_gcm_tfm_avx_gen2)
-		gcm_tfm = &aesni_gcm_tfm_sse;
+	do_avx = (left >= AVX_GEN2_OPTSIZE);
+	do_avx2 = (left >= AVX_GEN4_OPTSIZE);
 
 	/* Linearize assoc, if not already linear */
 	if (req->src->length >= assoclen && req->src->length) {
@@ -677,7 +647,14 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 	}
 
 	kernel_fpu_begin();
-	gcm_tfm->init(aes_ctx, data, iv, hash_subkey, assoc, assoclen);
+	if (static_branch_likely(&gcm_use_avx2) && do_avx2)
+		aesni_gcm_init_avx_gen4(aes_ctx, data, iv, hash_subkey, assoc,
+					assoclen);
+	else if (static_branch_likely(&gcm_use_avx) && do_avx)
+		aesni_gcm_init_avx_gen2(aes_ctx, data, iv, hash_subkey, assoc,
+					assoclen);
+	else
+		aesni_gcm_init(aes_ctx, data, iv, hash_subkey, assoc, assoclen);
 	kernel_fpu_end();
 
 	if (!assocmem)
@@ -690,9 +667,35 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 
 	while (walk.nbytes > 0) {
 		kernel_fpu_begin();
-		(enc ? gcm_tfm->enc_update
-		     : gcm_tfm->dec_update)(aes_ctx, data, walk.dst.virt.addr,
-					    walk.src.virt.addr, walk.nbytes);
+		if (static_branch_likely(&gcm_use_avx2) && do_avx2) {
+			if (enc)
+				aesni_gcm_enc_update_avx_gen4(aes_ctx, data,
+							      walk.dst.virt.addr,
+							      walk.src.virt.addr,
+							      walk.nbytes);
+			else
+				aesni_gcm_dec_update_avx_gen4(aes_ctx, data,
+							      walk.dst.virt.addr,
+							      walk.src.virt.addr,
+							      walk.nbytes);
+		} else if (static_branch_likely(&gcm_use_avx) && do_avx) {
+			if (enc)
+				aesni_gcm_enc_update_avx_gen2(aes_ctx, data,
+							      walk.dst.virt.addr,
+							      walk.src.virt.addr,
+							      walk.nbytes);
+			else
+				aesni_gcm_dec_update_avx_gen2(aes_ctx, data,
+							      walk.dst.virt.addr,
+							      walk.src.virt.addr,
+							      walk.nbytes);
+		} else if (enc) {
+			aesni_gcm_enc_update(aes_ctx, data, walk.dst.virt.addr,
+					     walk.src.virt.addr, walk.nbytes);
+		} else {
+			aesni_gcm_dec_update(aes_ctx, data, walk.dst.virt.addr,
+					     walk.src.virt.addr, walk.nbytes);
+		}
 		kernel_fpu_end();
 
 		err = skcipher_walk_done(&walk, 0);
@@ -702,7 +705,14 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 		return err;
 
 	kernel_fpu_begin();
-	gcm_tfm->finalize(aes_ctx, data, auth_tag, auth_tag_len);
+	if (static_branch_likely(&gcm_use_avx2) && do_avx2)
+		aesni_gcm_finalize_avx_gen4(aes_ctx, data, auth_tag,
+					    auth_tag_len);
+	else if (static_branch_likely(&gcm_use_avx) && do_avx)
+		aesni_gcm_finalize_avx_gen2(aes_ctx, data, auth_tag,
+					    auth_tag_len);
+	else
+		aesni_gcm_finalize(aes_ctx, data, auth_tag, auth_tag_len);
 	kernel_fpu_end();
 
 	return 0;
@@ -1141,14 +1151,14 @@ static int __init aesni_init(void)
 #ifdef CONFIG_X86_64
 	if (boot_cpu_has(X86_FEATURE_AVX2)) {
 		pr_info("AVX2 version of gcm_enc/dec engaged.\n");
-		aesni_gcm_tfm = &aesni_gcm_tfm_avx_gen4;
+		static_branch_enable(&gcm_use_avx);
+		static_branch_enable(&gcm_use_avx2);
 	} else
 	if (boot_cpu_has(X86_FEATURE_AVX)) {
 		pr_info("AVX version of gcm_enc/dec engaged.\n");
-		aesni_gcm_tfm = &aesni_gcm_tfm_avx_gen2;
+		static_branch_enable(&gcm_use_avx);
 	} else {
 		pr_info("SSE version of gcm_enc/dec engaged.\n");
-		aesni_gcm_tfm = &aesni_gcm_tfm_sse;
 	}
 	aesni_ctr_enc_tfm = aesni_ctr_enc;
 	if (boot_cpu_has(X86_FEATURE_AVX)) {
-- 
2.17.1


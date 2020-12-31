Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BA4C433E9
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 16:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88E49222F9
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 16:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgLaQmr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 11:42:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgLaQmr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 11:42:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E30223E8;
        Thu, 31 Dec 2020 16:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609432926;
        bh=a61NyhU4EXc07m0yuMkCp7M7ARt0rWyjbcfXQtTmxBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrBZavjA5J0OBYzV1ra6sJweeNrkwn+6SRHvLhv/ZUcaRHqiNOkNbOj2K/pWkWacq
         XlfWl8DxjT+y7X5wbhYyxu/S5LwBiGp+1LXmdRPOUoHzHgTbDHqTLeiKEdUqupQaHe
         K9W7SOrPWq1ENO5ohORQGaiZN5oXkNeURAzGcKu3lk8L4kjTtUF37cLPbYkPXuzh4r
         SxvGT4sBA+HHNq/3JWuWNboTe+cAHOY40rDjOhy5lLyfJrEzwz1flaCPk1bJR75n42
         RKhewKqsqoBOLeRBsDlYQye2fU5d+KJ5Jtck+THGgdxDW+qdmASTO7XHsHLeqBie9p
         oEp+K3Xp+mOXg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH v2 1/2] crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
Date:   Thu, 31 Dec 2020 17:41:54 +0100
Message-Id: <20201231164155.21792-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231164155.21792-1-ardb@kernel.org>
References: <20201231164155.21792-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The XTS asm helper arrangement is a bit odd: the 8-way stride helper
consists of back-to-back calls to the 4-way core transforms, which
are called indirectly, based on a boolean that indicates whether we
are performing encryption or decryption.

Given how costly indirect calls are on x86, let's switch to direct
calls, and given how the 8-way stride doesn't really add anything
substantial, use a 4-way stride instead, and make the asm core
routine deal with any multiple of 4 blocks. Since 512 byte sectors
or 4 KB blocks are the typical quantities XTS operates on, increase
the stride exported to the glue helper to 512 bytes as well.

As a result, the number of indirect calls is reduced from 3 per 64 bytes
of in/output to 1 per 512 bytes of in/output, which produces a 65% speedup
when operating on 1 KB blocks (measured on a Intel(R) Core(TM) i7-8650U CPU)

Fixes: 9697fa39efd3f ("x86/retpoline/crypto: Convert crypto assembler indirect jumps")
Tested-by: Eric Biggers <ebiggers@google.com> # x86_64
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_asm.S  | 115 ++++++++++++--------
 arch/x86/crypto/aesni-intel_glue.c |  25 +++--
 2 files changed, 84 insertions(+), 56 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index a2710f76862f..84d8a156cdcd 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2842,25 +2842,18 @@ SYM_FUNC_END(aesni_ctr_enc)
 	pxor CTR, IV;
 
 /*
- * void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *dst,
- *			 const u8 *src, bool enc, le128 *iv)
+ * void aesni_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst,
+ *			  const u8 *src, unsigned int len, le128 *iv)
  */
-SYM_FUNC_START(aesni_xts_crypt8)
+SYM_FUNC_START(aesni_xts_encrypt)
 	FRAME_BEGIN
-	testb %cl, %cl
-	movl $0, %ecx
-	movl $240, %r10d
-	leaq _aesni_enc4, %r11
-	leaq _aesni_dec4, %rax
-	cmovel %r10d, %ecx
-	cmoveq %rax, %r11
 
 	movdqa .Lgf128mul_x_ble_mask, GF128MUL_MASK
 	movups (IVP), IV
 
 	mov 480(KEYP), KLEN
-	addq %rcx, KEYP
 
+.Lxts_enc_loop4:
 	movdqa IV, STATE1
 	movdqu 0x00(INP), INC
 	pxor INC, STATE1
@@ -2884,71 +2877,103 @@ SYM_FUNC_START(aesni_xts_crypt8)
 	pxor INC, STATE4
 	movdqu IV, 0x30(OUTP)
 
-	CALL_NOSPEC r11
+	call _aesni_enc4
 
 	movdqu 0x00(OUTP), INC
 	pxor INC, STATE1
 	movdqu STATE1, 0x00(OUTP)
 
-	_aesni_gf128mul_x_ble()
-	movdqa IV, STATE1
-	movdqu 0x40(INP), INC
-	pxor INC, STATE1
-	movdqu IV, 0x40(OUTP)
-
 	movdqu 0x10(OUTP), INC
 	pxor INC, STATE2
 	movdqu STATE2, 0x10(OUTP)
 
-	_aesni_gf128mul_x_ble()
-	movdqa IV, STATE2
-	movdqu 0x50(INP), INC
-	pxor INC, STATE2
-	movdqu IV, 0x50(OUTP)
-
 	movdqu 0x20(OUTP), INC
 	pxor INC, STATE3
 	movdqu STATE3, 0x20(OUTP)
 
-	_aesni_gf128mul_x_ble()
-	movdqa IV, STATE3
-	movdqu 0x60(INP), INC
-	pxor INC, STATE3
-	movdqu IV, 0x60(OUTP)
-
 	movdqu 0x30(OUTP), INC
 	pxor INC, STATE4
 	movdqu STATE4, 0x30(OUTP)
 
 	_aesni_gf128mul_x_ble()
-	movdqa IV, STATE4
-	movdqu 0x70(INP), INC
-	pxor INC, STATE4
-	movdqu IV, 0x70(OUTP)
 
-	_aesni_gf128mul_x_ble()
+	add $64, INP
+	add $64, OUTP
+	sub $64, LEN
+	ja .Lxts_enc_loop4
+
 	movups IV, (IVP)
 
-	CALL_NOSPEC r11
+	FRAME_END
+	ret
+SYM_FUNC_END(aesni_xts_encrypt)
+
+/*
+ * void aesni_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *dst,
+ *			  const u8 *src, unsigned int len, le128 *iv)
+ */
+SYM_FUNC_START(aesni_xts_decrypt)
+	FRAME_BEGIN
+
+	movdqa .Lgf128mul_x_ble_mask, GF128MUL_MASK
+	movups (IVP), IV
+
+	mov 480(KEYP), KLEN
+	add $240, KEYP
 
-	movdqu 0x40(OUTP), INC
+.Lxts_dec_loop4:
+	movdqa IV, STATE1
+	movdqu 0x00(INP), INC
 	pxor INC, STATE1
-	movdqu STATE1, 0x40(OUTP)
+	movdqu IV, 0x00(OUTP)
 
-	movdqu 0x50(OUTP), INC
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE2
+	movdqu 0x10(INP), INC
+	pxor INC, STATE2
+	movdqu IV, 0x10(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE3
+	movdqu 0x20(INP), INC
+	pxor INC, STATE3
+	movdqu IV, 0x20(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE4
+	movdqu 0x30(INP), INC
+	pxor INC, STATE4
+	movdqu IV, 0x30(OUTP)
+
+	call _aesni_dec4
+
+	movdqu 0x00(OUTP), INC
+	pxor INC, STATE1
+	movdqu STATE1, 0x00(OUTP)
+
+	movdqu 0x10(OUTP), INC
 	pxor INC, STATE2
-	movdqu STATE2, 0x50(OUTP)
+	movdqu STATE2, 0x10(OUTP)
 
-	movdqu 0x60(OUTP), INC
+	movdqu 0x20(OUTP), INC
 	pxor INC, STATE3
-	movdqu STATE3, 0x60(OUTP)
+	movdqu STATE3, 0x20(OUTP)
 
-	movdqu 0x70(OUTP), INC
+	movdqu 0x30(OUTP), INC
 	pxor INC, STATE4
-	movdqu STATE4, 0x70(OUTP)
+	movdqu STATE4, 0x30(OUTP)
+
+	_aesni_gf128mul_x_ble()
+
+	add $64, INP
+	add $64, OUTP
+	sub $64, LEN
+	ja .Lxts_dec_loop4
+
+	movups IV, (IVP)
 
 	FRAME_END
 	ret
-SYM_FUNC_END(aesni_xts_crypt8)
+SYM_FUNC_END(aesni_xts_decrypt)
 
 #endif
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 96bdc1584215..84e3ed49b35d 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -101,6 +101,12 @@ asmlinkage void aesni_cts_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 #define AVX_GEN2_OPTSIZE 640
 #define AVX_GEN4_OPTSIZE 4096
 
+asmlinkage void aesni_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *out,
+				  const u8 *in, unsigned int len, u8 *iv);
+
+asmlinkage void aesni_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *out,
+				  const u8 *in, unsigned int len, u8 *iv);
+
 #ifdef CONFIG_X86_64
 
 static void (*aesni_ctr_enc_tfm)(struct crypto_aes_ctx *ctx, u8 *out,
@@ -108,9 +114,6 @@ static void (*aesni_ctr_enc_tfm)(struct crypto_aes_ctx *ctx, u8 *out,
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
-asmlinkage void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *out,
-				 const u8 *in, bool enc, le128 *iv);
-
 /* asmlinkage void aesni_gcm_enc()
  * void *ctx,  AES Key schedule. Starts on a 16 byte boundary.
  * struct gcm_context_data.  May be uninitialized.
@@ -663,14 +666,14 @@ static void aesni_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 	glue_xts_crypt_128bit_one(ctx, dst, src, iv, aesni_dec);
 }
 
-static void aesni_xts_enc8(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void aesni_xts_enc32(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	aesni_xts_crypt8(ctx, dst, src, true, iv);
+	aesni_xts_encrypt(ctx, dst, src, 32 * AES_BLOCK_SIZE, (u8 *)iv);
 }
 
-static void aesni_xts_dec8(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void aesni_xts_dec32(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	aesni_xts_crypt8(ctx, dst, src, false, iv);
+	aesni_xts_decrypt(ctx, dst, src, 32 * AES_BLOCK_SIZE, (u8 *)iv);
 }
 
 static const struct common_glue_ctx aesni_enc_xts = {
@@ -678,8 +681,8 @@ static const struct common_glue_ctx aesni_enc_xts = {
 	.fpu_blocks_limit = 1,
 
 	.funcs = { {
-		.num_blocks = 8,
-		.fn_u = { .xts = aesni_xts_enc8 }
+		.num_blocks = 32,
+		.fn_u = { .xts = aesni_xts_enc32 }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .xts = aesni_xts_enc }
@@ -691,8 +694,8 @@ static const struct common_glue_ctx aesni_dec_xts = {
 	.fpu_blocks_limit = 1,
 
 	.funcs = { {
-		.num_blocks = 8,
-		.fn_u = { .xts = aesni_xts_dec8 }
+		.num_blocks = 32,
+		.fn_u = { .xts = aesni_xts_dec32 }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .xts = aesni_xts_dec }
-- 
2.17.1


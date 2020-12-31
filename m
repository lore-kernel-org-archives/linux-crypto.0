Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C855C433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 16:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B49E20798
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 16:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgLaQmv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 11:42:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgLaQmt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 11:42:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B0C82242A;
        Thu, 31 Dec 2020 16:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609432928;
        bh=zUZ7GUXFYeA2eSzsEmQ2Av/NY1vvvhml16SEIXKU/NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0EP4iQQyD7veqMAqJVpGfgjhO7MQmcGK3AAPARDxGvN7QuKxZJ9HlZIUODJe39Ki
         FT5iWvBu+lpX6m4sx82XH8mO/2tFVjgYoD/lCPP35mil09T6NfqvIt6o7mJCtnEsIL
         Qz5CgW5EWQmoi/ItWgDqDmLnoNNNCauDlTLTZm9npJEczxrb1bAOeFvzVdzyC3JfEb
         +zOyZFoWhRfXuJQNqrs0AYpzSDUAR50HaiMNy78vduW6NZn862dGdvxzrOvRskLeE3
         qyiz7An6qFRMuYFaoTcYdOBQKRZVOoMFznecoJwHZ+6Wo2Phr1tw/IzJ4NImt22Gqx
         w+YcviV3N+qsA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH v2 2/2] crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper
Date:   Thu, 31 Dec 2020 17:41:55 +0100
Message-Id: <20201231164155.21792-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231164155.21792-1-ardb@kernel.org>
References: <20201231164155.21792-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AES-NI driver implements XTS via the glue helper, which consumes
a struct with sets of function pointers which are invoked on chunks
of input data of the appropriate size, as annotated in the struct.

Let's get rid of this indirection, so that we can perform direct calls
to the assembler helpers. Instead, let's adopt the arm64 strategy, i.e.,
provide a helper which can consume inputs of any size, provided that the
penultimate, full block is passed via the last call if ciphertext stealing
needs to be applied.

This also allows us to enable the XTS mode for i386.

Tested-by: Eric Biggers <ebiggers@google.com> # x86_64
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_asm.S  | 280 ++++++++++++++++----
 arch/x86/crypto/aesni-intel_glue.c | 220 ++++++++-------
 crypto/Kconfig                     |   1 -
 3 files changed, 356 insertions(+), 145 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 84d8a156cdcd..4e3972570916 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -43,10 +43,6 @@
 #ifdef __x86_64__
 
 # constants in mergeable sections, linker can reorder and merge
-.section	.rodata.cst16.gf128mul_x_ble_mask, "aM", @progbits, 16
-.align 16
-.Lgf128mul_x_ble_mask:
-	.octa 0x00000000000000010000000000000087
 .section	.rodata.cst16.POLY, "aM", @progbits, 16
 .align 16
 POLY:   .octa 0xC2000000000000000000000000000001
@@ -146,7 +142,7 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 #define CTR	%xmm11
 #define INC	%xmm12
 
-#define GF128MUL_MASK %xmm10
+#define GF128MUL_MASK %xmm7
 
 #ifdef __x86_64__
 #define AREG	%rax
@@ -2823,6 +2819,14 @@ SYM_FUNC_START(aesni_ctr_enc)
 	ret
 SYM_FUNC_END(aesni_ctr_enc)
 
+#endif
+
+.section	.rodata.cst16.gf128mul_x_ble_mask, "aM", @progbits, 16
+.align 16
+.Lgf128mul_x_ble_mask:
+	.octa 0x00000000000000010000000000000087
+.previous
+
 /*
  * _aesni_gf128mul_x_ble:		internal ABI
  *	Multiply in GF(2^128) for XTS IVs
@@ -2835,11 +2839,11 @@ SYM_FUNC_END(aesni_ctr_enc)
  *	CTR:	== temporary value
  */
 #define _aesni_gf128mul_x_ble() \
-	pshufd $0x13, IV, CTR; \
+	pshufd $0x13, IV, KEY; \
 	paddq IV, IV; \
-	psrad $31, CTR; \
-	pand GF128MUL_MASK, CTR; \
-	pxor CTR, IV;
+	psrad $31, KEY; \
+	pand GF128MUL_MASK, KEY; \
+	pxor KEY, IV;
 
 /*
  * void aesni_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst,
@@ -2847,65 +2851,153 @@ SYM_FUNC_END(aesni_ctr_enc)
  */
 SYM_FUNC_START(aesni_xts_encrypt)
 	FRAME_BEGIN
-
+#ifndef __x86_64__
+	pushl IVP
+	pushl LEN
+	pushl KEYP
+	pushl KLEN
+	movl (FRAME_OFFSET+20)(%esp), KEYP	# ctx
+	movl (FRAME_OFFSET+24)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+28)(%esp), INP	# src
+	movl (FRAME_OFFSET+32)(%esp), LEN	# len
+	movl (FRAME_OFFSET+36)(%esp), IVP	# iv
 	movdqa .Lgf128mul_x_ble_mask, GF128MUL_MASK
+#else
+	movdqa .Lgf128mul_x_ble_mask(%rip), GF128MUL_MASK
+#endif
 	movups (IVP), IV
 
 	mov 480(KEYP), KLEN
 
 .Lxts_enc_loop4:
+	sub $64, LEN
+	jl .Lxts_enc_1x
+
 	movdqa IV, STATE1
-	movdqu 0x00(INP), INC
-	pxor INC, STATE1
+	movdqu 0x00(INP), IN
+	pxor IN, STATE1
 	movdqu IV, 0x00(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE2
-	movdqu 0x10(INP), INC
-	pxor INC, STATE2
+	movdqu 0x10(INP), IN
+	pxor IN, STATE2
 	movdqu IV, 0x10(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE3
-	movdqu 0x20(INP), INC
-	pxor INC, STATE3
+	movdqu 0x20(INP), IN
+	pxor IN, STATE3
 	movdqu IV, 0x20(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE4
-	movdqu 0x30(INP), INC
-	pxor INC, STATE4
+	movdqu 0x30(INP), IN
+	pxor IN, STATE4
 	movdqu IV, 0x30(OUTP)
 
 	call _aesni_enc4
 
-	movdqu 0x00(OUTP), INC
-	pxor INC, STATE1
+	movdqu 0x00(OUTP), IN
+	pxor IN, STATE1
 	movdqu STATE1, 0x00(OUTP)
 
-	movdqu 0x10(OUTP), INC
-	pxor INC, STATE2
+	movdqu 0x10(OUTP), IN
+	pxor IN, STATE2
 	movdqu STATE2, 0x10(OUTP)
 
-	movdqu 0x20(OUTP), INC
-	pxor INC, STATE3
+	movdqu 0x20(OUTP), IN
+	pxor IN, STATE3
 	movdqu STATE3, 0x20(OUTP)
 
-	movdqu 0x30(OUTP), INC
-	pxor INC, STATE4
+	movdqu 0x30(OUTP), IN
+	pxor IN, STATE4
 	movdqu STATE4, 0x30(OUTP)
 
 	_aesni_gf128mul_x_ble()
 
 	add $64, INP
 	add $64, OUTP
-	sub $64, LEN
-	ja .Lxts_enc_loop4
+	test LEN, LEN
+	jnz .Lxts_enc_loop4
 
+.Lxts_enc_ret_iv:
 	movups IV, (IVP)
 
+.Lxts_enc_ret:
+#ifndef __x86_64__
+	popl KLEN
+	popl KEYP
+	popl LEN
+	popl IVP
+#endif
 	FRAME_END
 	ret
+
+.Lxts_enc_1x:
+	add $64, LEN
+	jz .Lxts_enc_ret_iv
+	sub $16, LEN
+	jl .Lxts_enc_cts4
+
+.Lxts_enc_loop1:
+	movdqu (INP), STATE
+	pxor IV, STATE
+	call _aesni_enc1
+	pxor IV, STATE
+	_aesni_gf128mul_x_ble()
+
+	test LEN, LEN
+	jz .Lxts_enc_out
+
+	add $16, INP
+	sub $16, LEN
+	jl .Lxts_enc_cts1
+
+	movdqu STATE, (OUTP)
+	add $16, OUTP
+	jmp .Lxts_enc_loop1
+
+.Lxts_enc_out:
+	movdqu STATE, (OUTP)
+	jmp .Lxts_enc_ret_iv
+
+.Lxts_enc_cts4:
+	movdqa STATE4, STATE
+	sub $16, OUTP
+
+.Lxts_enc_cts1:
+#ifndef __x86_64__
+	lea .Lcts_permute_table, T1
+#else
+	lea .Lcts_permute_table(%rip), T1
+#endif
+	add LEN, INP		/* rewind input pointer */
+	add $16, LEN		/* # bytes in final block */
+	movups (INP), IN1
+
+	mov T1, IVP
+	add $32, IVP
+	add LEN, T1
+	sub LEN, IVP
+	add OUTP, LEN
+
+	movups (T1), %xmm4
+	movaps STATE, IN2
+	pshufb %xmm4, STATE
+	movups STATE, (LEN)
+
+	movups (IVP), %xmm0
+	pshufb %xmm0, IN1
+	pblendvb IN2, IN1
+	movaps IN1, STATE
+
+	pxor IV, STATE
+	call _aesni_enc1
+	pxor IV, STATE
+
+	movups STATE, (OUTP)
+	jmp .Lxts_enc_ret
 SYM_FUNC_END(aesni_xts_encrypt)
 
 /*
@@ -2914,66 +3006,158 @@ SYM_FUNC_END(aesni_xts_encrypt)
  */
 SYM_FUNC_START(aesni_xts_decrypt)
 	FRAME_BEGIN
-
+#ifndef __x86_64__
+	pushl IVP
+	pushl LEN
+	pushl KEYP
+	pushl KLEN
+	movl (FRAME_OFFSET+20)(%esp), KEYP	# ctx
+	movl (FRAME_OFFSET+24)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+28)(%esp), INP	# src
+	movl (FRAME_OFFSET+32)(%esp), LEN	# len
+	movl (FRAME_OFFSET+36)(%esp), IVP	# iv
 	movdqa .Lgf128mul_x_ble_mask, GF128MUL_MASK
+#else
+	movdqa .Lgf128mul_x_ble_mask(%rip), GF128MUL_MASK
+#endif
 	movups (IVP), IV
 
 	mov 480(KEYP), KLEN
 	add $240, KEYP
 
+	test $15, LEN
+	jz .Lxts_dec_loop4
+	sub $16, LEN
+
 .Lxts_dec_loop4:
+	sub $64, LEN
+	jl .Lxts_dec_1x
+
 	movdqa IV, STATE1
-	movdqu 0x00(INP), INC
-	pxor INC, STATE1
+	movdqu 0x00(INP), IN
+	pxor IN, STATE1
 	movdqu IV, 0x00(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE2
-	movdqu 0x10(INP), INC
-	pxor INC, STATE2
+	movdqu 0x10(INP), IN
+	pxor IN, STATE2
 	movdqu IV, 0x10(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE3
-	movdqu 0x20(INP), INC
-	pxor INC, STATE3
+	movdqu 0x20(INP), IN
+	pxor IN, STATE3
 	movdqu IV, 0x20(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE4
-	movdqu 0x30(INP), INC
-	pxor INC, STATE4
+	movdqu 0x30(INP), IN
+	pxor IN, STATE4
 	movdqu IV, 0x30(OUTP)
 
 	call _aesni_dec4
 
-	movdqu 0x00(OUTP), INC
-	pxor INC, STATE1
+	movdqu 0x00(OUTP), IN
+	pxor IN, STATE1
 	movdqu STATE1, 0x00(OUTP)
 
-	movdqu 0x10(OUTP), INC
-	pxor INC, STATE2
+	movdqu 0x10(OUTP), IN
+	pxor IN, STATE2
 	movdqu STATE2, 0x10(OUTP)
 
-	movdqu 0x20(OUTP), INC
-	pxor INC, STATE3
+	movdqu 0x20(OUTP), IN
+	pxor IN, STATE3
 	movdqu STATE3, 0x20(OUTP)
 
-	movdqu 0x30(OUTP), INC
-	pxor INC, STATE4
+	movdqu 0x30(OUTP), IN
+	pxor IN, STATE4
 	movdqu STATE4, 0x30(OUTP)
 
 	_aesni_gf128mul_x_ble()
 
 	add $64, INP
 	add $64, OUTP
-	sub $64, LEN
-	ja .Lxts_dec_loop4
+	test LEN, LEN
+	jnz .Lxts_dec_loop4
 
+.Lxts_dec_ret_iv:
 	movups IV, (IVP)
 
+.Lxts_dec_ret:
+#ifndef __x86_64__
+	popl KLEN
+	popl KEYP
+	popl LEN
+	popl IVP
+#endif
 	FRAME_END
 	ret
-SYM_FUNC_END(aesni_xts_decrypt)
 
+.Lxts_dec_1x:
+	add $64, LEN
+	jz .Lxts_dec_ret_iv
+
+.Lxts_dec_loop1:
+	movdqu (INP), STATE
+
+	add $16, INP
+	sub $16, LEN
+	jl .Lxts_dec_cts1
+
+	pxor IV, STATE
+	call _aesni_dec1
+	pxor IV, STATE
+	_aesni_gf128mul_x_ble()
+
+	test LEN, LEN
+	jz .Lxts_dec_out
+
+	movdqu STATE, (OUTP)
+	add $16, OUTP
+	jmp .Lxts_dec_loop1
+
+.Lxts_dec_out:
+	movdqu STATE, (OUTP)
+	jmp .Lxts_dec_ret_iv
+
+.Lxts_dec_cts1:
+	movdqa IV, STATE4
+	_aesni_gf128mul_x_ble()
+
+	pxor IV, STATE
+	call _aesni_dec1
+	pxor IV, STATE
+
+#ifndef __x86_64__
+	lea .Lcts_permute_table, T1
+#else
+	lea .Lcts_permute_table(%rip), T1
 #endif
+	add LEN, INP		/* rewind input pointer */
+	add $16, LEN		/* # bytes in final block */
+	movups (INP), IN1
+
+	mov T1, IVP
+	add $32, IVP
+	add LEN, T1
+	sub LEN, IVP
+	add OUTP, LEN
+
+	movups (T1), %xmm4
+	movaps STATE, IN2
+	pshufb %xmm4, STATE
+	movups STATE, (LEN)
+
+	movups (IVP), %xmm0
+	pshufb %xmm0, IN1
+	pblendvb IN2, IN1
+	movaps IN1, STATE
+
+	pxor STATE4, STATE
+	call _aesni_dec1
+	pxor STATE4, STATE
+
+	movups STATE, (OUTP)
+	jmp .Lxts_dec_ret
+SYM_FUNC_END(aesni_xts_decrypt)
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 84e3ed49b35d..2116bc2b9507 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -33,9 +33,6 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
-#ifdef CONFIG_X86_64
-#include <asm/crypto/glue_helper.h>
-#endif
 
 
 #define AESNI_ALIGN	16
@@ -632,98 +629,6 @@ static int ctr_crypt(struct skcipher_request *req)
 	return err;
 }
 
-static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			    unsigned int keylen)
-{
-	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err;
-
-	err = xts_verify_key(tfm, key, keylen);
-	if (err)
-		return err;
-
-	keylen /= 2;
-
-	/* first half of xts-key is for crypt */
-	err = aes_set_key_common(crypto_skcipher_tfm(tfm), ctx->raw_crypt_ctx,
-				 key, keylen);
-	if (err)
-		return err;
-
-	/* second half of xts-key is for tweak */
-	return aes_set_key_common(crypto_skcipher_tfm(tfm), ctx->raw_tweak_ctx,
-				  key + keylen, keylen);
-}
-
-
-static void aesni_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
-{
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, aesni_enc);
-}
-
-static void aesni_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
-{
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, aesni_dec);
-}
-
-static void aesni_xts_enc32(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
-{
-	aesni_xts_encrypt(ctx, dst, src, 32 * AES_BLOCK_SIZE, (u8 *)iv);
-}
-
-static void aesni_xts_dec32(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
-{
-	aesni_xts_decrypt(ctx, dst, src, 32 * AES_BLOCK_SIZE, (u8 *)iv);
-}
-
-static const struct common_glue_ctx aesni_enc_xts = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = 1,
-
-	.funcs = { {
-		.num_blocks = 32,
-		.fn_u = { .xts = aesni_xts_enc32 }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = aesni_xts_enc }
-	} }
-};
-
-static const struct common_glue_ctx aesni_dec_xts = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = 1,
-
-	.funcs = { {
-		.num_blocks = 32,
-		.fn_u = { .xts = aesni_xts_dec32 }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .xts = aesni_xts_dec }
-	} }
-};
-
-static int xts_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&aesni_enc_xts, req, aesni_enc,
-				   aes_ctx(ctx->raw_tweak_ctx),
-				   aes_ctx(ctx->raw_crypt_ctx),
-				   false);
-}
-
-static int xts_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return glue_xts_req_128bit(&aesni_dec_xts, req, aesni_enc,
-				   aes_ctx(ctx->raw_tweak_ctx),
-				   aes_ctx(ctx->raw_crypt_ctx),
-				   true);
-}
-
 static int
 rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 {
@@ -996,6 +901,128 @@ static int helper_rfc4106_decrypt(struct aead_request *req)
 }
 #endif
 
+static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err;
+
+	err = xts_verify_key(tfm, key, keylen);
+	if (err)
+		return err;
+
+	keylen /= 2;
+
+	/* first half of xts-key is for crypt */
+	err = aes_set_key_common(crypto_skcipher_tfm(tfm), ctx->raw_crypt_ctx,
+				 key, keylen);
+	if (err)
+		return err;
+
+	/* second half of xts-key is for tweak */
+	return aes_set_key_common(crypto_skcipher_tfm(tfm), ctx->raw_tweak_ctx,
+				  key + keylen, keylen);
+}
+
+static int xts_crypt(struct skcipher_request *req, bool encrypt)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int tail = req->cryptlen % AES_BLOCK_SIZE;
+	struct skcipher_request subreq;
+	struct skcipher_walk walk;
+	int err;
+
+	if (req->cryptlen < AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
+		int blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
+
+		skcipher_walk_abort(&walk);
+
+		skcipher_request_set_tfm(&subreq, tfm);
+		skcipher_request_set_callback(&subreq,
+					      skcipher_request_flags(req),
+					      NULL, NULL);
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   blocks * AES_BLOCK_SIZE, req->iv);
+		req = &subreq;
+		err = skcipher_walk_virt(&walk, req, false);
+	} else {
+		tail = 0;
+	}
+
+	kernel_fpu_begin();
+
+	/* calculate first value of T */
+	aesni_enc(aes_ctx(ctx->raw_tweak_ctx), walk.iv, walk.iv);
+
+	while (walk.nbytes > 0) {
+		int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes &= ~(AES_BLOCK_SIZE - 1);
+
+		if (encrypt)
+			aesni_xts_encrypt(aes_ctx(ctx->raw_crypt_ctx),
+					  walk.dst.virt.addr, walk.src.virt.addr,
+					  nbytes, walk.iv);
+		else
+			aesni_xts_decrypt(aes_ctx(ctx->raw_crypt_ctx),
+					  walk.dst.virt.addr, walk.src.virt.addr,
+					  nbytes, walk.iv);
+		kernel_fpu_end();
+
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+
+		if (walk.nbytes > 0)
+			kernel_fpu_begin();
+	}
+
+	if (unlikely(tail > 0 && !err)) {
+		struct scatterlist sg_src[2], sg_dst[2];
+		struct scatterlist *src, *dst;
+
+		dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
+
+		skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
+					   req->iv);
+
+		err = skcipher_walk_virt(&walk, &subreq, false);
+		if (err)
+			return err;
+
+		kernel_fpu_begin();
+		if (encrypt)
+			aesni_xts_encrypt(aes_ctx(ctx->raw_crypt_ctx),
+					  walk.dst.virt.addr, walk.src.virt.addr,
+					  walk.nbytes, walk.iv);
+		else
+			aesni_xts_decrypt(aes_ctx(ctx->raw_crypt_ctx),
+					  walk.dst.virt.addr, walk.src.virt.addr,
+					  walk.nbytes, walk.iv);
+		kernel_fpu_end();
+
+		err = skcipher_walk_done(&walk, 0);
+	}
+	return err;
+}
+
+static int xts_encrypt(struct skcipher_request *req)
+{
+	return xts_crypt(req, true);
+}
+
+static int xts_decrypt(struct skcipher_request *req)
+{
+	return xts_crypt(req, false);
+}
+
 static struct crypto_alg aesni_cipher_alg = {
 	.cra_name		= "aes",
 	.cra_driver_name	= "aes-aesni",
@@ -1082,6 +1109,7 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= ctr_crypt,
 		.decrypt	= ctr_crypt,
+#endif
 	}, {
 		.base = {
 			.cra_name		= "__xts(aes)",
@@ -1095,10 +1123,10 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
 		.max_keysize	= 2 * AES_MAX_KEY_SIZE,
 		.ivsize		= AES_BLOCK_SIZE,
+		.walksize	= 2 * AES_BLOCK_SIZE,
 		.setkey		= xts_aesni_setkey,
 		.encrypt	= xts_encrypt,
 		.decrypt	= xts_decrypt,
-#endif
 	}
 };
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index a367fcfeb5d4..c48ca26e2169 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1133,7 +1133,6 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_LIB_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_SKCIPHER
-	select CRYPTO_GLUE_HELPER_X86 if 64BIT
 	select CRYPTO_SIMD
 	help
 	  Use Intel AES-NI instructions for AES algorithm.
-- 
2.17.1


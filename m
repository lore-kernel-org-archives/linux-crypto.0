Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA85C4361B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 23:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0677123A1C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 23:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgLGXes (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:34:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:32972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLGXes (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 18:34:48 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        dhowells@redhat.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2] crypto: aes-ni - implement support for cts(cbc(aes))
Date:   Tue,  8 Dec 2020 00:34:02 +0100
Message-Id: <20201207233402.17472-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Follow the same approach as the arm64 driver for implementing a version
of AES-NI in CBC mode that supports ciphertext stealing. This results in
a ~2x speed increase for relatively short inputs (less than 256 bytes),
which is relevant given that AES-CBC with ciphertext stealing is used
for filename encryption in the fscrypt layer. For larger inputs, the
speedup is still significant (~25% on decryption, ~6% on encryption)

Tested-by: Eric Biggers <ebiggers@google.com> # x86_64
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v2: add 32-bit support:
    . load IV earlier so we can reuse the IVP register to replace T2 which is
      not defined on i386
    . add i386 boilerplate for preserving/restoring callee-saved registers
    . use absolute reference to .Lcts_permute_table on i386

 arch/x86/crypto/aesni-intel_asm.S  | 129 ++++++++++++++++++-
 arch/x86/crypto/aesni-intel_glue.c | 133 ++++++++++++++++++++
 2 files changed, 261 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index d1436c37008b..a2710f76862f 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2577,13 +2577,140 @@ SYM_FUNC_START(aesni_cbc_dec)
 	ret
 SYM_FUNC_END(aesni_cbc_dec)
 
-#ifdef __x86_64__
+/*
+ * void aesni_cts_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *			  size_t len, u8 *iv)
+ */
+SYM_FUNC_START(aesni_cts_cbc_enc)
+	FRAME_BEGIN
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
+	lea .Lcts_permute_table, T1
+#else
+	lea .Lcts_permute_table(%rip), T1
+#endif
+	mov 480(KEYP), KLEN
+	movups (IVP), STATE
+	sub $16, LEN
+	mov T1, IVP
+	add $32, IVP
+	add LEN, T1
+	sub LEN, IVP
+	movups (T1), %xmm4
+	movups (IVP), %xmm5
+
+	movups (INP), IN1
+	add LEN, INP
+	movups (INP), IN2
+
+	pxor IN1, STATE
+	call _aesni_enc1
+
+	pshufb %xmm5, IN2
+	pxor STATE, IN2
+	pshufb %xmm4, STATE
+	add OUTP, LEN
+	movups STATE, (LEN)
+
+	movaps IN2, STATE
+	call _aesni_enc1
+	movups STATE, (OUTP)
+
+#ifndef __x86_64__
+	popl KLEN
+	popl KEYP
+	popl LEN
+	popl IVP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(aesni_cts_cbc_enc)
+
+/*
+ * void aesni_cts_cbc_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *			  size_t len, u8 *iv)
+ */
+SYM_FUNC_START(aesni_cts_cbc_dec)
+	FRAME_BEGIN
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
+	lea .Lcts_permute_table, T1
+#else
+	lea .Lcts_permute_table(%rip), T1
+#endif
+	mov 480(KEYP), KLEN
+	add $240, KEYP
+	movups (IVP), IV
+	sub $16, LEN
+	mov T1, IVP
+	add $32, IVP
+	add LEN, T1
+	sub LEN, IVP
+	movups (T1), %xmm4
+
+	movups (INP), STATE
+	add LEN, INP
+	movups (INP), IN1
+
+	call _aesni_dec1
+	movaps STATE, IN2
+	pshufb %xmm4, STATE
+	pxor IN1, STATE
+
+	add OUTP, LEN
+	movups STATE, (LEN)
+
+	movups (IVP), %xmm0
+	pshufb %xmm0, IN1
+	pblendvb IN2, IN1
+	movaps IN1, STATE
+	call _aesni_dec1
+
+	pxor IV, STATE
+	movups STATE, (OUTP)
+
+#ifndef __x86_64__
+	popl KLEN
+	popl KEYP
+	popl LEN
+	popl IVP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(aesni_cts_cbc_dec)
+
 .pushsection .rodata
 .align 16
+.Lcts_permute_table:
+	.byte		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+	.byte		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+	.byte		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
+	.byte		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
+	.byte		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+	.byte		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+#ifdef __x86_64__
 .Lbswap_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+#endif
 .popsection
 
+#ifdef __x86_64__
 /*
  * _aesni_inc_init:	internal ABI
  *	setup registers used by _aesni_inc
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ad8a7188a2bf..96bdc1584215 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -93,6 +93,10 @@ asmlinkage void aesni_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
+asmlinkage void aesni_cts_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
+				  const u8 *in, unsigned int len, u8 *iv);
+asmlinkage void aesni_cts_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
+				  const u8 *in, unsigned int len, u8 *iv);
 
 #define AVX_GEN2_OPTSIZE 640
 #define AVX_GEN4_OPTSIZE 4096
@@ -454,6 +458,118 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
+static int cts_cbc_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
+	struct scatterlist *src = req->src, *dst = req->dst;
+	struct scatterlist sg_src[2], sg_dst[2];
+	struct skcipher_request subreq;
+	struct skcipher_walk walk;
+	int err;
+
+	skcipher_request_set_tfm(&subreq, tfm);
+	skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
+				      NULL, NULL);
+
+	if (req->cryptlen <= AES_BLOCK_SIZE) {
+		if (req->cryptlen < AES_BLOCK_SIZE)
+			return -EINVAL;
+		cbc_blocks = 1;
+	}
+
+	if (cbc_blocks > 0) {
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   cbc_blocks * AES_BLOCK_SIZE,
+					   req->iv);
+
+		err = cbc_encrypt(&subreq);
+		if (err)
+			return err;
+
+		if (req->cryptlen == AES_BLOCK_SIZE)
+			return 0;
+
+		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(sg_dst, req->dst,
+					       subreq.cryptlen);
+	}
+
+	/* handle ciphertext stealing */
+	skcipher_request_set_crypt(&subreq, src, dst,
+				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
+				   req->iv);
+
+	err = skcipher_walk_virt(&walk, &subreq, false);
+	if (err)
+		return err;
+
+	kernel_fpu_begin();
+	aesni_cts_cbc_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+			  walk.nbytes, walk.iv);
+	kernel_fpu_end();
+
+	return skcipher_walk_done(&walk, 0);
+}
+
+static int cts_cbc_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
+	struct scatterlist *src = req->src, *dst = req->dst;
+	struct scatterlist sg_src[2], sg_dst[2];
+	struct skcipher_request subreq;
+	struct skcipher_walk walk;
+	int err;
+
+	skcipher_request_set_tfm(&subreq, tfm);
+	skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
+				      NULL, NULL);
+
+	if (req->cryptlen <= AES_BLOCK_SIZE) {
+		if (req->cryptlen < AES_BLOCK_SIZE)
+			return -EINVAL;
+		cbc_blocks = 1;
+	}
+
+	if (cbc_blocks > 0) {
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   cbc_blocks * AES_BLOCK_SIZE,
+					   req->iv);
+
+		err = cbc_decrypt(&subreq);
+		if (err)
+			return err;
+
+		if (req->cryptlen == AES_BLOCK_SIZE)
+			return 0;
+
+		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(sg_dst, req->dst,
+					       subreq.cryptlen);
+	}
+
+	/* handle ciphertext stealing */
+	skcipher_request_set_crypt(&subreq, src, dst,
+				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
+				   req->iv);
+
+	err = skcipher_walk_virt(&walk, &subreq, false);
+	if (err)
+		return err;
+
+	kernel_fpu_begin();
+	aesni_cts_cbc_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+			  walk.nbytes, walk.iv);
+	kernel_fpu_end();
+
+	return skcipher_walk_done(&walk, 0);
+}
+
 #ifdef CONFIG_X86_64
 static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
 			    struct skcipher_walk *walk)
@@ -928,6 +1044,23 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= cbc_encrypt,
 		.decrypt	= cbc_decrypt,
+	}, {
+		.base = {
+			.cra_name		= "__cts(cbc(aes))",
+			.cra_driver_name	= "__cts-cbc-aes-aesni",
+			.cra_priority		= 400,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.walksize	= 2 * AES_BLOCK_SIZE,
+		.setkey		= aesni_skcipher_setkey,
+		.encrypt	= cts_cbc_encrypt,
+		.decrypt	= cts_cbc_decrypt,
 #ifdef CONFIG_X86_64
 	}, {
 		.base = {
-- 
2.17.1


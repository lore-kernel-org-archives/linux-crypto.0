Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCB6C433FE
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Dec 2020 22:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C8FF23107
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Dec 2020 22:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgLFWqQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Dec 2020 17:46:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgLFWqP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Dec 2020 17:46:15 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        dhowells@redhat.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: aes-ni - implement support for cts(cbc(aes))
Date:   Sun,  6 Dec 2020 23:45:23 +0100
Message-Id: <20201206224523.30777-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Follow the same approach as the arm64 driver for implementing a version
of AES-NI in CBC mode that supports ciphertext stealing. Compared to the
generic CTS template wrapped around the existing cbc-aes-aesni skcipher,
this results in a ~2x speed increase for relatively short inputs (less
than 256 bytes), which is relevant given that AES-CBC with ciphertext
stealing is used for filename encryption in the fscrypt layer. For larger
inputs, the speedup is still significant (~25% on decryption, ~6% on
encryption).

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
Full tcrypt benchmark results for cts(cbc-aes-aesni) vs cts-cbc-aes-aesni
after the diff (Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz)

 arch/x86/crypto/aesni-intel_asm.S  |  87 +++++++++++++
 arch/x86/crypto/aesni-intel_glue.c | 133 ++++++++++++++++++++
 2 files changed, 220 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index d1436c37008b..99361ea5e706 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2578,8 +2578,95 @@ SYM_FUNC_START(aesni_cbc_dec)
 SYM_FUNC_END(aesni_cbc_dec)
 
 #ifdef __x86_64__
+/*
+ * void aesni_cts_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *			  size_t len, u8 *iv)
+ */
+SYM_FUNC_START(aesni_cts_cbc_enc)
+	FRAME_BEGIN
+	mov 480(KEYP), KLEN
+	lea .Lcts_permute_table(%rip), T1
+	sub $16, LEN
+	mov T1, T2
+	add $32, T2
+	add LEN, T1
+	sub LEN, T2
+	movups (T1), %xmm4
+	movups (T2), %xmm5
+
+	movups (INP), IN1
+	add LEN, INP
+	movups (INP), IN2
+
+	movups (IVP), STATE
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
+	mov 480(KEYP), KLEN
+	add $240, KEYP
+	lea .Lcts_permute_table(%rip), T1
+	sub $16, LEN
+	mov T1, T2
+	add $32, T2
+	add LEN, T1
+	sub LEN, T2
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
+	movups (T2), %xmm0
+	pshufb %xmm0, IN1
+	pblendvb IN2, IN1
+	movaps IN1, STATE
+	call _aesni_dec1
+
+	movups (IVP), IN1
+	pxor IN1, STATE
+	movups STATE, (OUTP)
+
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
 .Lbswap_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
 .popsection
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ad8a7188a2bf..f00af4c9bf7f 100644
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
@@ -929,6 +1045,23 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.encrypt	= cbc_encrypt,
 		.decrypt	= cbc_decrypt,
 #ifdef CONFIG_X86_64
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
 	}, {
 		.base = {
 			.cra_name		= "__ctr(aes)",
-- 
2.17.1


testing speed of async cts(cbc(aes)) (cts(cbc-aes-aesni)) encryption
tcrypt: test 0 (128 bit key, 16 byte blocks): 11002728 operations in 1 seconds (176043648 bytes)
tcrypt: test 1 (128 bit key, 64 byte blocks): 3628540 operations in 1 seconds (232226560 bytes)
tcrypt: test 2 (128 bit key, 256 byte blocks): 2432730 operations in 1 seconds (622778880 bytes)
tcrypt: test 3 (128 bit key, 1024 byte blocks): 1044684 operations in 1 seconds (1069756416 bytes)
tcrypt: test 4 (128 bit key, 1424 byte blocks): 805806 operations in 1 seconds (1147467744 bytes)
tcrypt: test 5 (128 bit key, 4096 byte blocks): 303048 operations in 1 seconds (1241284608 bytes)
tcrypt: test 6 (192 bit key, 16 byte blocks): 11165425 operations in 1 seconds (178646800 bytes)
tcrypt: test 7 (192 bit key, 64 byte blocks): 3528184 operations in 1 seconds (225803776 bytes)
tcrypt: test 8 (192 bit key, 256 byte blocks): 2238441 operations in 1 seconds (573040896 bytes)
tcrypt: test 9 (192 bit key, 1024 byte blocks): 916733 operations in 1 seconds (938734592 bytes)
tcrypt: test 10 (192 bit key, 1424 byte blocks): 702795 operations in 1 seconds (1000780080 bytes)
tcrypt: test 11 (192 bit key, 4096 byte blocks): 251054 operations in 1 seconds (1028317184 bytes)
tcrypt: test 12 (256 bit key, 16 byte blocks): 11109066 operations in 1 seconds (177745056 bytes)
tcrypt: test 13 (256 bit key, 64 byte blocks): 3423735 operations in 1 seconds (219119040 bytes)
tcrypt: test 14 (256 bit key, 256 byte blocks): 2101283 operations in 1 seconds (537928448 bytes)
tcrypt: test 15 (256 bit key, 1024 byte blocks): 820254 operations in 1 seconds (839940096 bytes)
tcrypt: test 16 (256 bit key, 1424 byte blocks): 621601 operations in 1 seconds (885159824 bytes)
tcrypt: test 17 (256 bit key, 4096 byte blocks): 238333 operations in 1 seconds (976211968 bytes)

testing speed of async cts(cbc(aes)) (cts(cbc-aes-aesni)) decryption
tcrypt: test 0 (128 bit key, 16 byte blocks): 11285252 operations in 1 seconds (180564032 bytes)
tcrypt: test 1 (128 bit key, 64 byte blocks): 3182021 operations in 1 seconds (203649344 bytes)
tcrypt: test 2 (128 bit key, 256 byte blocks): 2873898 operations in 1 seconds (735717888 bytes)
tcrypt: test 3 (128 bit key, 1024 byte blocks): 2119503 operations in 1 seconds (2170371072 bytes)
tcrypt: test 4 (128 bit key, 1424 byte blocks): 1875724 operations in 1 seconds (2671030976 bytes)
tcrypt: test 5 (128 bit key, 4096 byte blocks): 856116 operations in 1 seconds (3506651136 bytes)
tcrypt: test 6 (192 bit key, 16 byte blocks): 11186696 operations in 1 seconds (178987136 bytes)
tcrypt: test 7 (192 bit key, 64 byte blocks): 3155896 operations in 1 seconds (201977344 bytes)
tcrypt: test 8 (192 bit key, 256 byte blocks): 2785745 operations in 1 seconds (713150720 bytes)
tcrypt: test 9 (192 bit key, 1024 byte blocks): 1963042 operations in 1 seconds (2010155008 bytes)
tcrypt: test 10 (192 bit key, 1424 byte blocks): 1720274 operations in 1 seconds (2449670176 bytes)
tcrypt: test 11 (192 bit key, 4096 byte blocks): 677445 operations in 1 seconds (2774814720 bytes)
tcrypt: test 12 (256 bit key, 16 byte blocks): 11224007 operations in 1 seconds (179584112 bytes)
tcrypt: test 13 (256 bit key, 64 byte blocks): 3110559 operations in 1 seconds (199075776 bytes)
tcrypt: test 14 (256 bit key, 256 byte blocks): 2706721 operations in 1 seconds (692920576 bytes)
tcrypt: test 15 (256 bit key, 1024 byte blocks): 1843348 operations in 1 seconds (1887588352 bytes)
tcrypt: test 16 (256 bit key, 1424 byte blocks): 1575321 operations in 1 seconds (2243257104 bytes)
tcrypt: test 17 (256 bit key, 4096 byte blocks): 730655 operations in 1 seconds (2992762880 bytes)

testing speed of async cts(cbc(aes)) (cts-cbc-aes-aesni) encryption
tcrypt: test 0 (128 bit key, 16 byte blocks): 11677428 operations in 1 seconds (186838848 bytes)
tcrypt: test 1 (128 bit key, 64 byte blocks): 6244605 operations in 1 seconds (399654720 bytes)
tcrypt: test 2 (128 bit key, 256 byte blocks): 3381151 operations in 1 seconds (865574656 bytes)
tcrypt: test 3 (128 bit key, 1024 byte blocks): 1187918 operations in 1 seconds (1216428032 bytes)
tcrypt: test 4 (128 bit key, 1424 byte blocks): 888966 operations in 1 seconds (1265887584 bytes)
tcrypt: test 5 (128 bit key, 4096 byte blocks): 321949 operations in 1 seconds (1318703104 bytes)
tcrypt: test 6 (192 bit key, 16 byte blocks): 11822119 operations in 1 seconds (189153904 bytes)
tcrypt: test 7 (192 bit key, 64 byte blocks): 6049331 operations in 1 seconds (387157184 bytes)
tcrypt: test 8 (192 bit key, 256 byte blocks): 3055655 operations in 1 seconds (782247680 bytes)
tcrypt: test 9 (192 bit key, 1024 byte blocks): 1002566 operations in 1 seconds (1026627584 bytes)
tcrypt: test 10 (192 bit key, 1424 byte blocks): 756043 operations in 1 seconds (1076605232 bytes)
tcrypt: test 11 (192 bit key, 4096 byte blocks): 259765 operations in 1 seconds (1063997440 bytes)
tcrypt: test 12 (256 bit key, 16 byte blocks): 10833454 operations in 1 seconds (173335264 bytes)
tcrypt: test 13 (256 bit key, 64 byte blocks): 5033700 operations in 1 seconds (322156800 bytes)
tcrypt: test 14 (256 bit key, 256 byte blocks): 2673855 operations in 1 seconds (684506880 bytes)
tcrypt: test 15 (256 bit key, 1024 byte blocks): 843345 operations in 1 seconds (863585280 bytes)
tcrypt: test 16 (256 bit key, 1424 byte blocks): 670364 operations in 1 seconds (954598336 bytes)
tcrypt: test 17 (256 bit key, 4096 byte blocks): 245605 operations in 1 seconds (1005998080 bytes)

testing speed of async cts(cbc(aes)) (cts-cbc-aes-aesni) decryption
tcrypt: test 0 (128 bit key, 16 byte blocks): 11844771 operations in 1 seconds (189516336 bytes)
tcrypt: test 1 (128 bit key, 64 byte blocks): 6271624 operations in 1 seconds (401383936 bytes)
tcrypt: test 2 (128 bit key, 256 byte blocks): 5216143 operations in 1 seconds (1335332608 bytes)
tcrypt: test 3 (128 bit key, 1024 byte blocks): 3160808 operations in 1 seconds (3236667392 bytes)
tcrypt: test 4 (128 bit key, 1424 byte blocks): 2575029 operations in 1 seconds (3666841296 bytes)
tcrypt: test 5 (128 bit key, 4096 byte blocks): 1086934 operations in 1 seconds (4452081664 bytes)
tcrypt: test 6 (192 bit key, 16 byte blocks): 10079406 operations in 1 seconds (161270496 bytes)
tcrypt: test 7 (192 bit key, 64 byte blocks): 6045814 operations in 1 seconds (386932096 bytes)
tcrypt: test 8 (192 bit key, 256 byte blocks): 4974126 operations in 1 seconds (1273376256 bytes)
tcrypt: test 9 (192 bit key, 1024 byte blocks): 2846820 operations in 1 seconds (2915143680 bytes)
tcrypt: test 10 (192 bit key, 1424 byte blocks): 2341879 operations in 1 seconds (3334835696 bytes)
tcrypt: test 11 (192 bit key, 4096 byte blocks): 917145 operations in 1 seconds (3756625920 bytes)
tcrypt: test 12 (256 bit key, 16 byte blocks): 11913798 operations in 1 seconds (190620768 bytes)
tcrypt: test 13 (256 bit key, 64 byte blocks): 6256335 operations in 1 seconds (400405440 bytes)
tcrypt: test 14 (256 bit key, 256 byte blocks): 4776465 operations in 1 seconds (1222775040 bytes)
tcrypt: test 15 (256 bit key, 1024 byte blocks): 2615874 operations in 1 seconds (2678654976 bytes)
tcrypt: test 16 (256 bit key, 1424 byte blocks): 2015093 operations in 1 seconds (2869492432 bytes)
tcrypt: test 17 (256 bit key, 4096 byte blocks): 899894 operations in 1 seconds (3685965824 bytes)

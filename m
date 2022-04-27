Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF461C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Apr 2022 00:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356416AbiD0Alf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356411AbiD0AlV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Apr 2022 20:41:21 -0400
Received: from mail-ua1-x949.google.com (mail-ua1-x949.google.com [IPv6:2607:f8b0:4864:20::949])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF7538DA4
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 17:38:11 -0700 (PDT)
Received: by mail-ua1-x949.google.com with SMTP id t20-20020ab04ad4000000b003627cd606a2so94801uae.11
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 17:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wai2WebXs1M4YdoveT/JFbitRDYwCrdTLbnJbmqVi9Y=;
        b=IV1CrRU0T3xyBeu6vrFtBl+WWf6EODZ6pnIOV473vun7pPwiknlFgU3AIVdViWtna0
         Q6+A4kVdEmXuJjpsjs4ymokjDhSDe9zuzPAGBG17G9fbxl6SF8XkubDhDpjaVQ1IbA6/
         jgTzCzZwTEyvYVKAjm1UnnHu5Glp75FoCVGk0fPPKKMvuiPzv/FidHSXtYVLsonBLioI
         4E2frBWTY78C5scN+F3C1BS/bKg3i0oM6X3ilrJloAcFfL7dZi3mVpJZdxztqUhbg9H7
         0GIiL+JpLgoxTBUS7RnXu0mgoeSU1Bh/c1P8Ti6xnp/EIX4m+113DjFgLhJ/COnNwqlU
         BpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wai2WebXs1M4YdoveT/JFbitRDYwCrdTLbnJbmqVi9Y=;
        b=bzYM+QxobyduXkA5fWJMFOQvVTcRXRVLAHkBraqyku63yzgWD1qJB3Z9TntTdlSCIH
         yXPoq7d+bcVNIi5dc3471Px7APQ2tqgiodDOeB2giYzbjr90Bo35DZAGa+ZkFnnUQn/Q
         8s4RrdX6XCCtGi34nFqIdccfz8cMOVwFw6tnxDJlfoZ6Hh/X69Ru/hj6ifD5b6xDhnc/
         9ZwbTi1iGbiWb+5nWoPj1pOPWDKCuNfMMvB7m202qSbc/eHUxgTDPt9I6QphjJ/h45wm
         NSQbqb2axS1+JjAMXzo91PzHqrjx42ctFut0NWq+ht/J1CZPWjGNa1SDFVB8XW2bSDUM
         gAYA==
X-Gm-Message-State: AOAM530qD3Op4m+S3AA8rKso9xtv6h2I2ux/3B6vpqIpFvGrsFg45CJn
        mk2eRa8dgdjpBmJs4lk0gCqROtpWBaPBj5rpYF1CvvbnmHxZNwippvBrJ7tTtIiyLWwKxUWatFD
        Gb+qLkwUCV8A55qIDGx3CAbqpnLHRQbsz9RadJcT9M64/J7S31ClGT5mzYcap6h7WSlQ=
X-Google-Smtp-Source: ABdhPJwB4CaqNiX9uZc6syPr+2zeQc7mluEdA0B8+VC3cABfCtYDmuKSRF/eQMfv4TrinZAo3Dw/GBwqhQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:ac5:cfd8:0:b0:34d:4e87:368 with SMTP id
 m24-20020ac5cfd8000000b0034d4e870368mr5000314vkf.5.1651019890459; Tue, 26 Apr
 2022 17:38:10 -0700 (PDT)
Date:   Wed, 27 Apr 2022 00:37:56 +0000
In-Reply-To: <20220427003759.1115361-1-nhuck@google.com>
Message-Id: <20220427003759.1115361-6-nhuck@google.com>
Mime-Version: 1.0
References: <20220427003759.1115361-1-nhuck@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v5 5/8] crypto: arm64/aes-xctr: Add accelerated implementation
 of XCTR
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     linux-fscrypt.vger.kernel.org@google.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add hardware accelerated version of XCTR for ARM64 CPUs with ARMv8
Crypto Extension support.  This XCTR implementation is based on the CTR
implementation in aes-modes.S.

More information on XCTR can be found in
the HCTR2 paper: Length-preserving encryption with HCTR2:
https://eprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/Kconfig     |   4 +-
 arch/arm64/crypto/aes-glue.c  |  64 +++++++-
 arch/arm64/crypto/aes-modes.S | 290 ++++++++++++++++++++++------------
 3 files changed, 257 insertions(+), 101 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 2a965aa0188d..897f9a4b5b67 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -84,13 +84,13 @@ config CRYPTO_AES_ARM64_CE_CCM
 	select CRYPTO_LIB_AES
 
 config CRYPTO_AES_ARM64_CE_BLK
-	tristate "AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions"
+	tristate "AES in ECB/CBC/CTR/XTS/XCTR modes using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_AES_ARM64_CE
 
 config CRYPTO_AES_ARM64_NEON_BLK
-	tristate "AES in ECB/CBC/CTR/XTS modes using NEON instructions"
+	tristate "AES in ECB/CBC/CTR/XTS/XCTR modes using NEON instructions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 561dd2332571..b6883288234c 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -34,10 +34,11 @@
 #define aes_essiv_cbc_encrypt	ce_aes_essiv_cbc_encrypt
 #define aes_essiv_cbc_decrypt	ce_aes_essiv_cbc_decrypt
 #define aes_ctr_encrypt		ce_aes_ctr_encrypt
+#define aes_xctr_encrypt	ce_aes_xctr_encrypt
 #define aes_xts_encrypt		ce_aes_xts_encrypt
 #define aes_xts_decrypt		ce_aes_xts_decrypt
 #define aes_mac_update		ce_aes_mac_update
-MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
+MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS/XCTR using ARMv8 Crypto Extensions");
 #else
 #define MODE			"neon"
 #define PRIO			200
@@ -50,16 +51,18 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #define aes_essiv_cbc_encrypt	neon_aes_essiv_cbc_encrypt
 #define aes_essiv_cbc_decrypt	neon_aes_essiv_cbc_decrypt
 #define aes_ctr_encrypt		neon_aes_ctr_encrypt
+#define aes_xctr_encrypt	neon_aes_xctr_encrypt
 #define aes_xts_encrypt		neon_aes_xts_encrypt
 #define aes_xts_decrypt		neon_aes_xts_decrypt
 #define aes_mac_update		neon_aes_mac_update
-MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 NEON");
+MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS/XCTR using ARMv8 NEON");
 #endif
 #if defined(USE_V8_CRYPTO_EXTENSIONS) || !IS_ENABLED(CONFIG_CRYPTO_AES_ARM64_BS)
 MODULE_ALIAS_CRYPTO("ecb(aes)");
 MODULE_ALIAS_CRYPTO("cbc(aes)");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
 MODULE_ALIAS_CRYPTO("xts(aes)");
+MODULE_ALIAS_CRYPTO("xctr(aes)");
 #endif
 MODULE_ALIAS_CRYPTO("cts(cbc(aes))");
 MODULE_ALIAS_CRYPTO("essiv(cbc(aes),sha256)");
@@ -89,6 +92,9 @@ asmlinkage void aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
 asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int bytes, u8 ctr[]);
 
+asmlinkage void aes_xctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
+				 int rounds, int bytes, u8 ctr[], int byte_ctr);
+
 asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
 				int rounds, int bytes, u32 const rk2[], u8 iv[],
 				int first);
@@ -442,6 +448,44 @@ static int __maybe_unused essiv_cbc_decrypt(struct skcipher_request *req)
 	return err ?: cbc_decrypt_walk(req, &walk);
 }
 
+static int __maybe_unused xctr_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err, rounds = 6 + ctx->key_length / 4;
+	struct skcipher_walk walk;
+	unsigned int byte_ctr = 0;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while (walk.nbytes > 0) {
+		const u8 *src = walk.src.virt.addr;
+		unsigned int nbytes = walk.nbytes;
+		u8 *dst = walk.dst.virt.addr;
+		u8 buf[AES_BLOCK_SIZE];
+
+		if (unlikely(nbytes < AES_BLOCK_SIZE))
+			src = dst = memcpy(buf + sizeof(buf) - nbytes,
+					   src, nbytes);
+		else if (nbytes < walk.total)
+			nbytes &= ~(AES_BLOCK_SIZE - 1);
+
+		kernel_neon_begin();
+		aes_xctr_encrypt(dst, src, ctx->key_enc, rounds, nbytes,
+						 walk.iv, byte_ctr);
+		kernel_neon_end();
+
+		if (unlikely(nbytes < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr,
+			       buf + sizeof(buf) - nbytes, nbytes);
+		byte_ctr += nbytes;
+
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+	}
+
+	return err;
+}
+
 static int __maybe_unused ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -669,6 +713,22 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey		= skcipher_aes_setkey,
 	.encrypt	= ctr_encrypt,
 	.decrypt	= ctr_encrypt,
+}, {
+	.base = {
+		.cra_name		= "xctr(aes)",
+		.cra_driver_name	= "xctr-aes-" MODE,
+		.cra_priority		= PRIO,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+		.cra_module		= THIS_MODULE,
+	},
+	.min_keysize	= AES_MIN_KEY_SIZE,
+	.max_keysize	= AES_MAX_KEY_SIZE,
+	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= AES_BLOCK_SIZE,
+	.setkey		= skcipher_aes_setkey,
+	.encrypt	= xctr_encrypt,
+	.decrypt	= xctr_encrypt,
 }, {
 	.base = {
 		.cra_name		= "xts(aes)",
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index dc35eb0245c5..39a0c2b5c24d 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -318,126 +318,186 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
 	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
 	.previous
 
-
 	/*
-	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-	 *		   int bytes, u8 ctr[])
+	 * This macro generates the code for CTR and XCTR mode.
 	 */
+.macro ctr_encrypt xctr
+	OUT		.req x0
+	IN		.req x1
+	KEY		.req x2
+	ROUNDS_W	.req w3
+	BYTES_W		.req w4
+	IV		.req x5
+	BLOCKS_W	.req w7
+	BLOCKS		.req x7
+	IV_PART		.req x12
+	.if \xctr
+		BYTE_CTR_W	.req w6
+		CTR_W		.req w11
+		CTR		.req x11
+	.endif
 
-AES_FUNC_START(aes_ctr_encrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
-	enc_prepare	w3, x2, x12
+	enc_prepare	ROUNDS_W, KEY, x12
 	ld1		{vctr.16b}, [x5]
 
-	umov		x12, vctr.d[1]		/* keep swabbed ctr in reg */
-	rev		x12, x12
-
-.LctrloopNx:
-	add		w7, w4, #15
-	sub		w4, w4, #MAX_STRIDE << 4
-	lsr		w7, w7, #4
-	mov		w8, #MAX_STRIDE
-	cmp		w7, w8
-	csel		w7, w7, w8, lt
-	adds		x12, x12, x7
+	.if \xctr
+		umov		IV_PART, vctr.d[0]
+		lsr		CTR_W, BYTE_CTR_W, #4
+	.else
+		umov		IV_PART, vctr.d[1] /* keep swabbed ctr in reg */
+		rev		IV_PART, IV_PART
+	.endif
+
+.LctrloopNx\xctr:
+	add		BLOCKS_W, BYTES_W, #15
+	sub		BYTES_W, BYTES_W, #MAX_STRIDE << 4
+	lsr		BLOCKS, BLOCKS, #4
+	mov		x8, #MAX_STRIDE
+	cmp		BLOCKS, x8
+	csel		BLOCKS, BLOCKS, x8, lt
 
+	/*
+	 * Set up the counter values in v0-v4.
+	 *
+	 * If we are encrypting less than MAX_STRIDE blocks, the tail block
+	 * handling code expects the last keystream block to be in v4.  For
+	 * example, if encrypting two blocks with MAX_STRIDE=5, then v3 and v4
+	 * should have the next two counter blocks.
+	 */
+	.if \xctr
+		add		CTR, CTR, BLOCKS
+	.else
+		adds		IV_PART, IV_PART, BLOCKS
+	.endif
 	mov		v0.16b, vctr.16b
 	mov		v1.16b, vctr.16b
 	mov		v2.16b, vctr.16b
 	mov		v3.16b, vctr.16b
 ST5(	mov		v4.16b, vctr.16b		)
-	bcs		0f
-
-	.subsection	1
-	/* apply carry to outgoing counter */
-0:	umov		x8, vctr.d[0]
-	rev		x8, x8
-	add		x8, x8, #1
-	rev		x8, x8
-	ins		vctr.d[0], x8
-
-	/* apply carry to N counter blocks for N := x12 */
-	cbz		x12, 2f
-	adr		x16, 1f
-	sub		x16, x16, x12, lsl #3
-	br		x16
-	bti		c
-	mov		v0.d[0], vctr.d[0]
-	bti		c
-	mov		v1.d[0], vctr.d[0]
-	bti		c
-	mov		v2.d[0], vctr.d[0]
-	bti		c
-	mov		v3.d[0], vctr.d[0]
-ST5(	bti		c				)
-ST5(	mov		v4.d[0], vctr.d[0]		)
-1:	b		2f
-	.previous
-
-2:	rev		x7, x12
-	ins		vctr.d[1], x7
-	sub		x7, x12, #MAX_STRIDE - 1
-	sub		x8, x12, #MAX_STRIDE - 2
-	sub		x9, x12, #MAX_STRIDE - 3
-	rev		x7, x7
-	rev		x8, x8
-	mov		v1.d[1], x7
-	rev		x9, x9
-ST5(	sub		x10, x12, #MAX_STRIDE - 4	)
-	mov		v2.d[1], x8
-ST5(	rev		x10, x10			)
-	mov		v3.d[1], x9
-ST5(	mov		v4.d[1], x10			)
-	tbnz		w4, #31, .Lctrtail
-	ld1		{v5.16b-v7.16b}, [x1], #48
+	.if \xctr
+		sub		x6, CTR, #MAX_STRIDE - 1
+		sub		x7, CTR, #MAX_STRIDE - 2
+		sub		x8, CTR, #MAX_STRIDE - 3
+		sub		x9, CTR, #MAX_STRIDE - 4
+ST5(		sub		x10, CTR, #MAX_STRIDE - 5	)
+		eor		x6, x6, x12
+		eor		x7, x7, x12
+		eor		x8, x8, x12
+		eor		x9, x9, x12
+		eor		x10, x10, x12
+		mov		v0.d[0], x6
+		mov		v1.d[0], x7
+		mov		v2.d[0], x8
+		mov		v3.d[0], x9
+ST5(		mov		v4.d[0], x10			)
+	.else
+		bcs		0f
+		.subsection	1
+		/* apply carry to outgoing counter */
+0:		umov		x8, vctr.d[0]
+		rev		x8, x8
+		add		x8, x8, #1
+		rev		x8, x8
+		ins		vctr.d[0], x8
+
+		/* apply carry to N counter blocks for N := x12 */
+		cbz		IV_PART, 2f
+		adr		x16, 1f
+		sub		x16, x16, IV_PART, lsl #3
+		br		x16
+		bti		c
+		mov		v0.d[0], vctr.d[0]
+		bti		c
+		mov		v1.d[0], vctr.d[0]
+		bti		c
+		mov		v2.d[0], vctr.d[0]
+		bti		c
+		mov		v3.d[0], vctr.d[0]
+ST5(		bti		c				)
+ST5(		mov		v4.d[0], vctr.d[0]		)
+1:		b		2f
+		.previous
+
+2:		rev		x7, IV_PART
+		ins		vctr.d[1], x7
+		sub		x7, IV_PART, #MAX_STRIDE - 1
+		sub		x8, IV_PART, #MAX_STRIDE - 2
+		sub		x9, IV_PART, #MAX_STRIDE - 3
+		rev		x7, x7
+		rev		x8, x8
+		mov		v1.d[1], x7
+		rev		x9, x9
+ST5(		sub		x10, IV_PART, #MAX_STRIDE - 4	)
+		mov		v2.d[1], x8
+ST5(		rev		x10, x10			)
+		mov		v3.d[1], x9
+ST5(		mov		v4.d[1], x10			)
+	.endif
+	/*
+	 * XOR input with keystream and store.
+	 */
+	tbnz		BYTES_W, #31, .Lctrtail\xctr
+    	ld1		{v5.16b-v7.16b}, [IN], #48
 ST4(	bl		aes_encrypt_block4x		)
 ST5(	bl		aes_encrypt_block5x		)
 	eor		v0.16b, v5.16b, v0.16b
-ST4(	ld1		{v5.16b}, [x1], #16		)
+ST4(	ld1		{v5.16b}, [IN], #16		)
 	eor		v1.16b, v6.16b, v1.16b
-ST5(	ld1		{v5.16b-v6.16b}, [x1], #32	)
+ST5(	ld1		{v5.16b-v6.16b}, [IN], #32	)
 	eor		v2.16b, v7.16b, v2.16b
 	eor		v3.16b, v5.16b, v3.16b
 ST5(	eor		v4.16b, v6.16b, v4.16b		)
-	st1		{v0.16b-v3.16b}, [x0], #64
-ST5(	st1		{v4.16b}, [x0], #16		)
-	cbz		w4, .Lctrout
-	b		.LctrloopNx
-
-.Lctrout:
-	st1		{vctr.16b}, [x5]	/* return next CTR value */
+	st1		{v0.16b-v3.16b}, [OUT], #64
+ST5(	st1		{v4.16b}, [OUT], #16		)
+	cbz		BYTES_W, .Lctrout\xctr
+	b		.LctrloopNx\xctr
+
+.Lctrout\xctr:
+	.if !\xctr
+		st1		{vctr.16b}, [IV] /* return next CTR value */
+	.endif
 	ldp		x29, x30, [sp], #16
 	ret
 
-.Lctrtail:
-	/* XOR up to MAX_STRIDE * 16 - 1 bytes of in/output with v0 ... v3/v4 */
+.Lctrtail\xctr:
+	/*
+	 * Handle up to MAX_STRIDE * 16 - 1 bytes of input
+	 *
+	 * This code expects the last keystream block to be in v4.  For example,
+	 * if encrypting two blocks with MAX_STRIDE=5, then v3 and v4 should
+	 * have the next two counter blocks.
+	 *
+	 * This allows us to use overlapping stores to efficiently store the
+	 * ciphertext after encryption.
+	 */
 	mov		x16, #16
-	ands		x6, x4, #0xf
+	ands		w6, BYTES_W, #0xf
 	csel		x13, x6, x16, ne
 
-ST5(	cmp		w4, #64 - (MAX_STRIDE << 4)	)
-ST5(	csel		x14, x16, xzr, gt		)
-	cmp		w4, #48 - (MAX_STRIDE << 4)
+ST5(	cmp		BYTES_W, #64 - (MAX_STRIDE << 4)	)
+ST5(	csel		x14, x16, xzr, gt			)
+	cmp		BYTES_W, #48 - (MAX_STRIDE << 4)
 	csel		x15, x16, xzr, gt
-	cmp		w4, #32 - (MAX_STRIDE << 4)
+	cmp		BYTES_W, #32 - (MAX_STRIDE << 4)
 	csel		x16, x16, xzr, gt
-	cmp		w4, #16 - (MAX_STRIDE << 4)
+	cmp		BYTES_W, #16 - (MAX_STRIDE << 4)
 
 	adr_l		x12, .Lcts_permute_table
 	add		x12, x12, x13
-	ble		.Lctrtail1x
+	ble		.Lctrtail1x\xctr
 
-ST5(	ld1		{v5.16b}, [x1], x14		)
-	ld1		{v6.16b}, [x1], x15
-	ld1		{v7.16b}, [x1], x16
+ST5(	ld1		{v5.16b}, [IN], x14		)
+	ld1		{v6.16b}, [IN], x15
+	ld1		{v7.16b}, [IN], x16
 
 ST4(	bl		aes_encrypt_block4x		)
 ST5(	bl		aes_encrypt_block5x		)
 
-	ld1		{v8.16b}, [x1], x13
-	ld1		{v9.16b}, [x1]
+	ld1		{v8.16b}, [IN], x13
+	ld1		{v9.16b}, [IN]
 	ld1		{v10.16b}, [x12]
 
 ST4(	eor		v6.16b, v6.16b, v0.16b		)
@@ -453,32 +513,68 @@ ST5(	eor		v7.16b, v7.16b, v2.16b		)
 ST5(	eor		v8.16b, v8.16b, v3.16b		)
 ST5(	eor		v9.16b, v9.16b, v4.16b		)
 
-ST5(	st1		{v5.16b}, [x0], x14		)
-	st1		{v6.16b}, [x0], x15
-	st1		{v7.16b}, [x0], x16
-	add		x13, x13, x0
+ST5(	st1		{v5.16b}, [OUT], x14		)
+	st1		{v6.16b}, [OUT], x15
+	st1		{v7.16b}, [OUT], x16
+	add		x13, x13, OUT
 	st1		{v9.16b}, [x13]		// overlapping stores
-	st1		{v8.16b}, [x0]
-	b		.Lctrout
+	st1		{v8.16b}, [OUT]
+	b		.Lctrout\xctr
 
-.Lctrtail1x:
+.Lctrtail1x\xctr:
+	/*
+	 * Handle <= 16 bytes of input
+	 */
 	sub		x7, x6, #16
 	csel		x6, x6, x7, eq
-	add		x1, x1, x6
-	add		x0, x0, x6
-	ld1		{v5.16b}, [x1]
-	ld1		{v6.16b}, [x0]
+	add		IN, IN, x6
+	add		OUT, OUT, x6
+	ld1		{v5.16b}, [IN]
+	ld1		{v6.16b}, [OUT]
 ST5(	mov		v3.16b, v4.16b			)
-	encrypt_block	v3, w3, x2, x8, w7
+	encrypt_block	v3, ROUNDS_W, KEY, x8, BLOCKS_W
 	ld1		{v10.16b-v11.16b}, [x12]
 	tbl		v3.16b, {v3.16b}, v10.16b
 	sshr		v11.16b, v11.16b, #7
 	eor		v5.16b, v5.16b, v3.16b
 	bif		v5.16b, v6.16b, v11.16b
-	st1		{v5.16b}, [x0]
-	b		.Lctrout
+	st1		{v5.16b}, [OUT]
+	b		.Lctrout\xctr
+
+	.unreq OUT
+	.unreq IN
+	.unreq KEY
+	.unreq ROUNDS_W
+	.unreq BYTES_W
+	.unreq IV
+	.unreq BLOCKS_W
+	.unreq BLOCKS
+	.unreq IV_PART
+	.if \xctr
+		.unreq BYTE_CTR_W
+		.unreq CTR_W
+		.unreq CTR
+	.endif
+.endm
+
+	/*
+	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	 *		   int bytes, u8 ctr[])
+	 */
+
+AES_FUNC_START(aes_ctr_encrypt)
+	ctr_encrypt 0
 AES_FUNC_END(aes_ctr_encrypt)
 
+	/*
+	 * aes_xctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	 *		   int bytes, u8 const iv[], int byte_ctr)
+	 */
+
+AES_FUNC_START(aes_xctr_encrypt)
+	ctr_encrypt 1
+AES_FUNC_END(aes_xctr_encrypt)
+
 
 	/*
 	 * aes_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[], int rounds,
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog


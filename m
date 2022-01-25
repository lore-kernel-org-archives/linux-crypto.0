Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06922C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jan 2022 02:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242104AbiAYCU1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415594AbiAYBsD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jan 2022 20:48:03 -0500
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4D8C0A8876
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jan 2022 17:45:34 -0800 (PST)
Received: by mail-ua1-x94a.google.com with SMTP id i28-20020a9f305c000000b00305923be96aso11346963uab.9
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jan 2022 17:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yop861uZhSRKFHK0UQUa37UzQeGZz+5HoGorYTPSm5Q=;
        b=sj/nCNF8HamwagXS+EPNhjbA4q20tpRlFKtfn8x+9uHdFDUsFHhKx83JVTqo5sv5bU
         sMUxTou3NBoFu2wrTBkx0IelG1HBUCbgu/2mHt1g5mViF/B8m15eOOOXltvNQFmJb2TY
         KCnFZ1NefVuy4k081XWm79HCMOtHlYy4aaX8UhrJUXOo4ANJ2umhI+I5UR/fs72ECNpJ
         Y0C2YASxMjLCQrHZJherE89BQyu60dXJOgDLwyK3dLDqr8xjxx5tn/imx7ZEGhwWRdJ2
         PmuPgyWRuTUDSwFOApicgoncqyK8lsIaPteHhRDErl2Ytuodmz6NArbDML4p4K/S6W/z
         XaDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yop861uZhSRKFHK0UQUa37UzQeGZz+5HoGorYTPSm5Q=;
        b=jPh6sKQx93TXcHEIAv1qxxt69n2pgGpZKlkhkZ85nTvXubPBhWU8Ur0VzttE2B+7ON
         mB8l8uS+Awi/FyzoMahuJNYsAqGgSSn0FpKNuAHF+2zjJHPORbmJEahIGQ70yOLa8U6J
         KLPOFdkvImfX97WhllTzaBJ1LCkW6yNoDRijOUJ/quqQhML0EmuvsMAVseyYkMVRVQxP
         STlG9AIuBJwu9ie9SPVdlfwoqZK2jYrek76fvUMbTSlbPhM5LyPW4JJ3eSFHlPuPTMM7
         btARBH+zq61c6soZ82X33DlvYt9AsQfgX6ex9Z7XWXHxjMZi/N3khukix5uHkQN5kPTN
         epEg==
X-Gm-Message-State: AOAM533t8XQLG5Zn6Ex9+ZvgW6aBfyOUyV8hJUGFISvHSWArHzJLoKmk
        jqTTOG16rr1O9vJnTN3OgNLOo3ec66FYN3ygbGSvToCasZtMeYiT0TAha5LThA14zgmBytsQl5L
        WZr6I6rMVQd0RWWirUrvyr7Q3tM6fMbuo0+Wo1BvT/2cYNOYEJPoQNh3PpbHhDVzfwfU=
X-Google-Smtp-Source: ABdhPJyEwp9XQnc13STw0xpOK0lKHi3zsgvrx7Ht+gwh3RwLKAoIZiou73v9PNCC8E54htSL8Xo/7Lrkgg==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a67:ca1d:: with SMTP id z29mr6355548vsk.32.1643075133678;
 Mon, 24 Jan 2022 17:45:33 -0800 (PST)
Date:   Mon, 24 Jan 2022 19:44:20 -0600
In-Reply-To: <20220125014422.80552-1-nhuck@google.com>
Message-Id: <20220125014422.80552-6-nhuck@google.com>
Mime-Version: 1.0
References: <20220125014422.80552-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [RFC PATCH 5/7] crypto: arm64/aes-xctr: Add accelerated
 implementation of XCTR
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
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
---
 arch/arm64/crypto/Kconfig     |   4 +-
 arch/arm64/crypto/aes-glue.c  |  70 ++++++++++++++++++-
 arch/arm64/crypto/aes-modes.S | 128 ++++++++++++++++++++++++++++++++++
 3 files changed, 198 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index addfa413650b..cab469e279ec 100644
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
index 30b7cc6a7079..377f8d8369fb 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -35,10 +35,11 @@
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
@@ -52,16 +53,18 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
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
@@ -91,6 +94,10 @@ asmlinkage void aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
 asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int bytes, u8 ctr[], u8 finalbuf[]);
 
+asmlinkage void aes_xctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
+				 int rounds, int bytes, u8 ctr[], u8 finalbuf[],
+				 int byte_ctr);
+
 asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
 				int rounds, int bytes, u32 const rk2[], u8 iv[],
 				int first);
@@ -444,6 +451,49 @@ static int __maybe_unused essiv_cbc_decrypt(struct skcipher_request *req)
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
+		unsigned int tail;
+
+		if (unlikely(nbytes < AES_BLOCK_SIZE))
+			src = memcpy(buf, src, nbytes);
+		else if (nbytes < walk.total)
+			nbytes &= ~(AES_BLOCK_SIZE - 1);
+
+		kernel_neon_begin();
+		aes_xctr_encrypt(dst, src, ctx->key_enc, rounds, nbytes,
+						 walk.iv, buf, byte_ctr);
+		kernel_neon_end();
+
+		tail = nbytes % (STRIDE * AES_BLOCK_SIZE);
+		if (tail > 0 && tail < AES_BLOCK_SIZE)
+			/*
+			 * The final partial block could not be returned using
+			 * an overlapping store, so it was passed via buf[]
+			 * instead.
+			 */
+			memcpy(dst + nbytes - tail, buf, tail);
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
@@ -676,6 +726,22 @@ static struct skcipher_alg aes_algs[] = { {
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
index ff01f0167ba2..7128907f8190 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -471,6 +471,134 @@ ST5(	mov		v3.16b, v4.16b			)
 	b		.Lctrout
 AES_FUNC_END(aes_ctr_encrypt)
 
+    /*
+	 * aes_xctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	 *		   int bytes, u8 const ctr[], u8 finalbuf[], int byte_ctr)
+	 */
+
+AES_FUNC_START(aes_xctr_encrypt)
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
+
+	enc_prepare	w3, x2, x12
+	ld1		{vctr.16b}, [x5]
+
+	umov		x12, vctr.d[0]		/* keep ctr in reg */
+	lsr		x7, x7, #4
+	add		x11, x7, #1
+
+.LxctrloopNx:
+	add		w7, w4, #15
+	sub		w4, w4, #MAX_STRIDE << 4
+	lsr		w7, w7, #4
+	mov		w8, #MAX_STRIDE
+	cmp		w7, w8
+	csel		w7, w7, w8, lt
+	add		x11, x11, x7
+
+	mov		v0.16b, vctr.16b
+	mov		v1.16b, vctr.16b
+	mov		v2.16b, vctr.16b
+	mov		v3.16b, vctr.16b
+ST5(	mov		v4.16b, vctr.16b		)
+
+	sub		x7, x11, #MAX_STRIDE
+	eor		x7, x12, x7
+	ins		v0.d[0], x7
+	sub		x7, x11, #MAX_STRIDE - 1
+	sub		x8, x11, #MAX_STRIDE - 2
+	eor		x7, x7, x12
+	sub		x9, x11, #MAX_STRIDE - 3
+	mov		v1.d[0], x7
+	eor		x8, x8, x12
+	eor		x9, x9, x12
+ST5(	sub		x10, x11, #MAX_STRIDE - 4)
+	mov		v2.d[0], x8
+	eor		x10, x10, x12
+	mov		v3.d[0], x9
+ST5(	mov		v4.d[0], x10			)
+	tbnz		w4, #31, .Lxctrtail
+	ld1		{v5.16b-v7.16b}, [x1], #48
+ST4(	bl		aes_encrypt_block4x		)
+ST5(	bl		aes_encrypt_block5x		)
+	eor		v0.16b, v5.16b, v0.16b
+ST4(	ld1		{v5.16b}, [x1], #16		)
+	eor		v1.16b, v6.16b, v1.16b
+ST5(	ld1		{v5.16b-v6.16b}, [x1], #32	)
+	eor		v2.16b, v7.16b, v2.16b
+	eor		v3.16b, v5.16b, v3.16b
+ST5(	eor		v4.16b, v6.16b, v4.16b		)
+	st1		{v0.16b-v3.16b}, [x0], #64
+ST5(	st1		{v4.16b}, [x0], #16		)
+	cbz		w4, .Lxctrout
+	b		.LxctrloopNx
+
+.Lxctrout:
+	ldp		x29, x30, [sp], #16
+	ret
+
+.Lxctrtail:
+	/* XOR up to MAX_STRIDE * 16 - 1 bytes of in/output with v0 ... v3/v4 */
+	mov		x17, #16
+	ands		x13, x4, #0xf
+	csel		x13, x13, x17, ne
+
+ST5(	cmp		w4, #64 - (MAX_STRIDE << 4))
+ST5(	csel		x14, x17, xzr, gt		)
+	cmp		w4, #48 - (MAX_STRIDE << 4)
+	csel		x15, x17, xzr, gt
+	cmp		w4, #32 - (MAX_STRIDE << 4)
+	csel		x16, x17, xzr, gt
+	cmp		w4, #16 - (MAX_STRIDE << 4)
+	ble		.Lxctrtail1x
+
+ST5(	mov		v4.d[0], x10			)
+
+	adr_l		x12, .Lcts_permute_table
+	add		x12, x12, x13
+
+ST5(	ld1		{v5.16b}, [x1], x14		)
+	ld1		{v6.16b}, [x1], x15
+	ld1		{v7.16b}, [x1], x16
+
+ST4(	bl		aes_encrypt_block4x		)
+ST5(	bl		aes_encrypt_block5x		)
+
+	ld1		{v8.16b}, [x1], x13
+	ld1		{v9.16b}, [x1]
+	ld1		{v10.16b}, [x12]
+
+ST4(	eor		v6.16b, v6.16b, v0.16b		)
+ST4(	eor		v7.16b, v7.16b, v1.16b		)
+ST4(	tbl		v3.16b, {v3.16b}, v10.16b	)
+ST4(	eor		v8.16b, v8.16b, v2.16b		)
+ST4(	eor		v9.16b, v9.16b, v3.16b		)
+
+ST5(	eor		v5.16b, v5.16b, v0.16b		)
+ST5(	eor		v6.16b, v6.16b, v1.16b		)
+ST5(	tbl		v4.16b, {v4.16b}, v10.16b	)
+ST5(	eor		v7.16b, v7.16b, v2.16b		)
+ST5(	eor		v8.16b, v8.16b, v3.16b		)
+ST5(	eor		v9.16b, v9.16b, v4.16b		)
+
+ST5(	st1		{v5.16b}, [x0], x14		)
+	st1		{v6.16b}, [x0], x15
+	st1		{v7.16b}, [x0], x16
+	add		x13, x13, x0
+	st1		{v9.16b}, [x13]		// overlapping stores
+	st1		{v8.16b}, [x0]
+	b		.Lxctrout
+
+.Lxctrtail1x:
+	csel		x0, x0, x6, eq		// use finalbuf if less than a full block
+	ld1		{v5.16b}, [x1]
+ST5(	mov		v3.16b, v4.16b			)
+	encrypt_block	v3, w3, x2, x8, w7
+	eor		v5.16b, v5.16b, v3.16b
+	st1		{v5.16b}, [x0]
+	b		.Lxctrout
+AES_FUNC_END(aes_xctr_encrypt)
+
 
 	/*
 	 * aes_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[], int rounds,
-- 
2.35.0.rc0.227.g00780c9af4-goog


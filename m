Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E563C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Mar 2022 23:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352471AbiCOXCU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Mar 2022 19:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352468AbiCOXCS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Mar 2022 19:02:18 -0400
Received: from mail-ua1-x949.google.com (mail-ua1-x949.google.com [IPv6:2607:f8b0:4864:20::949])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38B25D655
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2022 16:00:56 -0700 (PDT)
Received: by mail-ua1-x949.google.com with SMTP id s13-20020a056130020d00b0034dfb85694dso273874uac.2
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2022 16:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rz8N446mTSLefFNoEtyFK74QL+fmOMcuPrwtJd6r7H0=;
        b=kk+RJIv01z3hp6yPErMEWM49vy+tPDsCnjjjMLH7QbrHvrq+Xow5H3ZVazuzjT/yU9
         tWxStnl5MnSiKkX6ESxB8vSt5CXCk6MBalkOo3RjRUeLhM7bPUcIZ5eOIJ8UhvC3iiQk
         YMF6+OrzXNXcehOUgsWqgnhOZh69Oh1u0M+Ac0xN/efMtwpO7rUfTc5JbtBoQu4G2poj
         LRiBzC/3ll/3PYvIC+HIQabMmUVycxsiIbHKQVO67tI6oFQ+oKF4f5YhTWxx4vsr3EyV
         nGcbRiakjelARFPjtzpLXT87OVSsG9Ye+Ve/a1PjtrmSHCEnjfXYQWP0aAdC4bq0q8w8
         aHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rz8N446mTSLefFNoEtyFK74QL+fmOMcuPrwtJd6r7H0=;
        b=ndTuUHELExbX4Tplgsq44MgYzTm1/EOtIuRUqYgT05m8AD1+0yFQ5atwwIZHuduEQ+
         Vw+TcoiqZZ3Q6jG59930OE3hxd1CtCr1mVLWTQmuahrJJGhJA3l8YN3WBpviWITEz+RJ
         uFeES3uvxrUpIBcBnZyymP8TNnaXcoqgQGiF/kC9mbWc09ds9ltvdi5uuUOksN+1WPZH
         JIgQN02sJhz34imHACWkf0sGShmMciCRn1VlSS1YP3zRnTgNFVT9Hs00MEMUylm2vs3d
         vA/SMgeq8Jp/V7InM7Y4QRoFOpeyP+R6VrZcNjLHGjCn07IRJFzfr0WCXG7+/wbEIvf7
         +cJQ==
X-Gm-Message-State: AOAM532daoYHT4Q0YdjTchgmotI94lF5kLz2VE+JmDLd446Rx9LgBN1t
        cp+PkqmZ8ChaxtjHlhc/G5DdaKhk2HmJX9OgS4l7SCLVFJUABqorfOdeYXEVP9rmT19ZPOOBaG2
        KIRBjtpGaeLPjWFb+zCueTp07FQUGUbc3Cp/PJAwd2r1cLXtsBi1qrwqJjQ8viguZP0w=
X-Google-Smtp-Source: ABdhPJxHUftlthNq8dMCd2YwfhaPtSVZjHm2+YHMsxwsy4+118gIvxsmwfPb0IL8DsW30ekkqn9Am8sbvg==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:ab0:6403:0:b0:346:9e51:c1f3 with SMTP id
 x3-20020ab06403000000b003469e51c1f3mr11015426uao.122.1647385256052; Tue, 15
 Mar 2022 16:00:56 -0700 (PDT)
Date:   Tue, 15 Mar 2022 23:00:32 +0000
In-Reply-To: <20220315230035.3792663-1-nhuck@google.com>
Message-Id: <20220315230035.3792663-6-nhuck@google.com>
Mime-Version: 1.0
References: <20220315230035.3792663-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v3 5/8] crypto: arm64/aes-xctr: Add accelerated implementation
 of XCTR
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
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
---
 arch/arm64/crypto/Kconfig     |   4 +-
 arch/arm64/crypto/aes-glue.c  |  65 ++++++++++++++++-
 arch/arm64/crypto/aes-modes.S | 134 ++++++++++++++++++++++++++++++++++
 3 files changed, 199 insertions(+), 4 deletions(-)

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
index 561dd2332571..06ebd466cf7c 100644
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
@@ -89,6 +92,10 @@ asmlinkage void aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
 asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int bytes, u8 ctr[]);
 
+asmlinkage void aes_xctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
+				 int rounds, int bytes, u8 ctr[], u8 finalbuf[],
+				 int byte_ctr);
+
 asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
 				int rounds, int bytes, u32 const rk2[], u8 iv[],
 				int first);
@@ -442,6 +449,44 @@ static int __maybe_unused essiv_cbc_decrypt(struct skcipher_request *req)
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
+						 walk.iv, buf, byte_ctr);
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
@@ -669,6 +714,22 @@ static struct skcipher_alg aes_algs[] = { {
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
index dc35eb0245c5..ac37e2f7ca84 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -479,6 +479,140 @@ ST5(	mov		v3.16b, v4.16b			)
 	b		.Lctrout
 AES_FUNC_END(aes_ctr_encrypt)
 
+	/*
+	 * aes_xctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	 *		   int bytes, u8 const ctr[], u8 finalbuf[], int
+	 *		   byte_ctr)
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
+	mov		x16, #16
+	ands		x6, x4, #0xf
+	csel		x13, x6, x16, ne
+
+ST5(	cmp		w4, #64 - (MAX_STRIDE << 4)	)
+ST5(	csel		x14, x16, xzr, gt		)
+	cmp		w4, #48 - (MAX_STRIDE << 4)
+	csel		x15, x16, xzr, gt
+	cmp		w4, #32 - (MAX_STRIDE << 4)
+	csel		x16, x16, xzr, gt
+	cmp		w4, #16 - (MAX_STRIDE << 4)
+
+	adr_l		x12, .Lcts_permute_table
+	add		x12, x12, x13
+	ble		.Lctrtail1x
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
+	b		.Lctrout
+.Lxctrtail1x:
+	sub		x7, x6, #16
+	csel		x6, x6, x7, eq
+	add		x1, x1, x6
+	add		x0, x0, x6
+	ld1		{v5.16b}, [x1]
+	ld1		{v6.16b}, [x0]
+ST5(	mov		v3.16b, v4.16b			)
+	encrypt_block	v3, w3, x2, x8, w7
+	ld1		{v10.16b-v11.16b}, [x12]
+	tbl		v3.16b, {v3.16b}, v10.16b
+	sshr		v11.16b, v11.16b, #7
+	eor		v5.16b, v5.16b, v3.16b
+	bif		v5.16b, v6.16b, v11.16b
+	st1		{v5.16b}, [x0]
+	b		.Lctrout
+AES_FUNC_END(aes_xctr_encrypt)
+
 
 	/*
 	 * aes_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[], int rounds,
-- 
2.35.1.723.g4982287a31-goog


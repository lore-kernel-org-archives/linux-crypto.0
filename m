Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1706C433DB
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9B4A64E0F
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhBCLis (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 06:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234354AbhBCLiI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 06:38:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10D7464F84;
        Wed,  3 Feb 2021 11:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612352219;
        bh=1/7T5nhachlGsV/UqJ9Ku+aYDYf/9pX++9/csj3spqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyUAoYBo69LJeekpkQFOIdH1DHciaMTNz9fbh8C9GaI61ru0JWBX3zCovyaN4qciT
         kY7IP4Sv9PhWLZpZUpiqb29dmzqpEhZKLcBrHF2r5LDa9QkQQptqxeQT/EoyQtS8Yh
         EzpFD9x4N64VOh0xXjzLWkkvt+FciKcAuwMiYXI11S6ENNw2Zypwac2heivrAcgseH
         KC0PpitBv0dh8dkARpIkf2KTRU0iMtEbvCup8E2npRcnQrL2DBYiM3IQwbVuCkdVu+
         nmPw5NS090NrlCQWHB5R3dkckdSQDmq13mW/g+uzGNi5loNLulo0L5D1kphafYWYBw
         uxvNXz2sK+wIA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, will@kernel.org,
        mark.rutland@arm.com, catalin.marinas@arm.com,
        herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 7/9] crypto: arm64/aes-ce-mac - simplify NEON yield
Date:   Wed,  3 Feb 2021 12:36:24 +0100
Message-Id: <20210203113626.220151-8-ardb@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210203113626.220151-1-ardb@kernel.org>
References: <20210203113626.220151-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-glue.c  | 21 +++++---
 arch/arm64/crypto/aes-modes.S | 52 +++++++-------------
 2 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index e7f116d833b9..17e735931a0c 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -105,9 +105,9 @@ asmlinkage void aes_essiv_cbc_decrypt(u8 out[], u8 const in[], u32 const rk1[],
 				      int rounds, int blocks, u8 iv[],
 				      u32 const rk2[]);
 
-asmlinkage void aes_mac_update(u8 const in[], u32 const rk[], int rounds,
-			       int blocks, u8 dg[], int enc_before,
-			       int enc_after);
+asmlinkage int aes_mac_update(u8 const in[], u32 const rk[], int rounds,
+			      int blocks, u8 dg[], int enc_before,
+			      int enc_after);
 
 struct crypto_aes_xts_ctx {
 	struct crypto_aes_ctx key1;
@@ -856,10 +856,17 @@ static void mac_do_update(struct crypto_aes_ctx *ctx, u8 const in[], int blocks,
 	int rounds = 6 + ctx->key_length / 4;
 
 	if (crypto_simd_usable()) {
-		kernel_neon_begin();
-		aes_mac_update(in, ctx->key_enc, rounds, blocks, dg, enc_before,
-			       enc_after);
-		kernel_neon_end();
+		int rem;
+
+		do {
+			kernel_neon_begin();
+			rem = aes_mac_update(in, ctx->key_enc, rounds, blocks,
+					     dg, enc_before, enc_after);
+			kernel_neon_end();
+			in += (blocks - rem) * AES_BLOCK_SIZE;
+			blocks = rem;
+			enc_before = 0;
+		} while (blocks);
 	} else {
 		if (enc_before)
 			aes_encrypt(ctx, dg, dg);
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 3d1f97799899..bbdb54702aa7 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -678,61 +678,47 @@ AES_FUNC_END(aes_xts_decrypt)
 	 *		  int blocks, u8 dg[], int enc_before, int enc_after)
 	 */
 AES_FUNC_START(aes_mac_update)
-	frame_push	6
-
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-	mov		x22, x3
-	mov		x23, x4
-	mov		x24, x6
-
-	ld1		{v0.16b}, [x23]			/* get dg */
+	ld1		{v0.16b}, [x4]			/* get dg */
 	enc_prepare	w2, x1, x7
 	cbz		w5, .Lmacloop4x
 
 	encrypt_block	v0, w2, x1, x7, w8
 
 .Lmacloop4x:
-	subs		w22, w22, #4
+	subs		w3, w3, #4
 	bmi		.Lmac1x
-	ld1		{v1.16b-v4.16b}, [x19], #64	/* get next pt block */
+	ld1		{v1.16b-v4.16b}, [x0], #64	/* get next pt block */
 	eor		v0.16b, v0.16b, v1.16b		/* ..and xor with dg */
-	encrypt_block	v0, w21, x20, x7, w8
+	encrypt_block	v0, w2, x1, x7, w8
 	eor		v0.16b, v0.16b, v2.16b
-	encrypt_block	v0, w21, x20, x7, w8
+	encrypt_block	v0, w2, x1, x7, w8
 	eor		v0.16b, v0.16b, v3.16b
-	encrypt_block	v0, w21, x20, x7, w8
+	encrypt_block	v0, w2, x1, x7, w8
 	eor		v0.16b, v0.16b, v4.16b
-	cmp		w22, wzr
-	csinv		x5, x24, xzr, eq
+	cmp		w3, wzr
+	csinv		x5, x6, xzr, eq
 	cbz		w5, .Lmacout
-	encrypt_block	v0, w21, x20, x7, w8
-	st1		{v0.16b}, [x23]			/* return dg */
-	cond_yield_neon	.Lmacrestart
+	encrypt_block	v0, w2, x1, x7, w8
+	st1		{v0.16b}, [x4]			/* return dg */
+	cond_yield	.Lmacout, x7
 	b		.Lmacloop4x
 .Lmac1x:
-	add		w22, w22, #4
+	add		w3, w3, #4
 .Lmacloop:
-	cbz		w22, .Lmacout
-	ld1		{v1.16b}, [x19], #16		/* get next pt block */
+	cbz		w3, .Lmacout
+	ld1		{v1.16b}, [x0], #16		/* get next pt block */
 	eor		v0.16b, v0.16b, v1.16b		/* ..and xor with dg */
 
-	subs		w22, w22, #1
-	csinv		x5, x24, xzr, eq
+	subs		w3, w3, #1
+	csinv		x5, x6, xzr, eq
 	cbz		w5, .Lmacout
 
 .Lmacenc:
-	encrypt_block	v0, w21, x20, x7, w8
+	encrypt_block	v0, w2, x1, x7, w8
 	b		.Lmacloop
 
 .Lmacout:
-	st1		{v0.16b}, [x23]			/* return dg */
-	frame_pop
+	st1		{v0.16b}, [x4]			/* return dg */
+	mov		w0, w3
 	ret
-
-.Lmacrestart:
-	ld1		{v0.16b}, [x23]			/* get dg */
-	enc_prepare	w21, x20, x0
-	b		.Lmacloop4x
 AES_FUNC_END(aes_mac_update)
-- 
2.30.0


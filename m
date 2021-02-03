Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E821CC4332E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8D3A64E34
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhBCLhw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 06:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234281AbhBCLhc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 06:37:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0650464DE7;
        Wed,  3 Feb 2021 11:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612352211;
        bh=/OcYnbe5Kun+kf1jaqhajfU1gagBntUnyWAwXopsYJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=az5J3W14C3lrASG20sEmk3FjSjj2wsEqd0lMxI0ZhhqwGPVSKn+nfv9dWzLziGYYL
         P3HR5vqXJXxMllQ+pvI9UXDcgm8aml0PfsAqqKAyDwi2uMLpfUkrbjApS2W3yvW39a
         hhLS53fc7fiMN1kb65Vxaxtujwikg7pwyX7miKU3Zt1bkUp8SRfDLN59m9oXwEpWKk
         aBK23fGby93AXAUN9pLJnmmREksawuuUwD7+KK58HKYuGvItJAtRrSxREtCtN6gCXZ
         f3AJCNQxWEroR1Wj9ErZtrOY4qfLBq/3knjPwZgudSYAlznYgAhtmQncDJAi1+bbuN
         Ax5bqdPtg2bMw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, will@kernel.org,
        mark.rutland@arm.com, catalin.marinas@arm.com,
        herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 4/9] crypto: arm64/sha3-ce - simplify NEON yield
Date:   Wed,  3 Feb 2021 12:36:21 +0100
Message-Id: <20210203113626.220151-5-ardb@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210203113626.220151-1-ardb@kernel.org>
References: <20210203113626.220151-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of calling into kernel_neon_end() and kernel_neon_begin() (and
potentially into schedule()) from the assembler code when running in
task mode and a reschedule is pending, perform only the preempt count
check in assembler, but simply return early in this case, and let the C
code deal with the consequences.

This reverts commit 7edc86cb1c18b4c274672232117586ea2bef1d9a.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sha3-ce-core.S | 81 ++++++++------------
 arch/arm64/crypto/sha3-ce-glue.c | 14 ++--
 2 files changed, 39 insertions(+), 56 deletions(-)

diff --git a/arch/arm64/crypto/sha3-ce-core.S b/arch/arm64/crypto/sha3-ce-core.S
index 1cfb768df350..6f5208414fe3 100644
--- a/arch/arm64/crypto/sha3-ce-core.S
+++ b/arch/arm64/crypto/sha3-ce-core.S
@@ -37,20 +37,13 @@
 	.endm
 
 	/*
-	 * sha3_ce_transform(u64 *st, const u8 *data, int blocks, int dg_size)
+	 * int sha3_ce_transform(u64 *st, const u8 *data, int blocks, int dg_size)
 	 */
 	.text
 SYM_FUNC_START(sha3_ce_transform)
-	frame_push	4
-
-	mov	x19, x0
-	mov	x20, x1
-	mov	x21, x2
-	mov	x22, x3
-
-0:	/* load state */
-	add	x8, x19, #32
-	ld1	{ v0.1d- v3.1d}, [x19]
+	/* load state */
+	add	x8, x0, #32
+	ld1	{ v0.1d- v3.1d}, [x0]
 	ld1	{ v4.1d- v7.1d}, [x8], #32
 	ld1	{ v8.1d-v11.1d}, [x8], #32
 	ld1	{v12.1d-v15.1d}, [x8], #32
@@ -58,13 +51,13 @@ SYM_FUNC_START(sha3_ce_transform)
 	ld1	{v20.1d-v23.1d}, [x8], #32
 	ld1	{v24.1d}, [x8]
 
-1:	sub	w21, w21, #1
+0:	sub	w2, w2, #1
 	mov	w8, #24
 	adr_l	x9, .Lsha3_rcon
 
 	/* load input */
-	ld1	{v25.8b-v28.8b}, [x20], #32
-	ld1	{v29.8b-v31.8b}, [x20], #24
+	ld1	{v25.8b-v28.8b}, [x1], #32
+	ld1	{v29.8b-v31.8b}, [x1], #24
 	eor	v0.8b, v0.8b, v25.8b
 	eor	v1.8b, v1.8b, v26.8b
 	eor	v2.8b, v2.8b, v27.8b
@@ -73,10 +66,10 @@ SYM_FUNC_START(sha3_ce_transform)
 	eor	v5.8b, v5.8b, v30.8b
 	eor	v6.8b, v6.8b, v31.8b
 
-	tbnz	x22, #6, 3f		// SHA3-512
+	tbnz	x3, #6, 2f		// SHA3-512
 
-	ld1	{v25.8b-v28.8b}, [x20], #32
-	ld1	{v29.8b-v30.8b}, [x20], #16
+	ld1	{v25.8b-v28.8b}, [x1], #32
+	ld1	{v29.8b-v30.8b}, [x1], #16
 	eor	 v7.8b,  v7.8b, v25.8b
 	eor	 v8.8b,  v8.8b, v26.8b
 	eor	 v9.8b,  v9.8b, v27.8b
@@ -84,34 +77,34 @@ SYM_FUNC_START(sha3_ce_transform)
 	eor	v11.8b, v11.8b, v29.8b
 	eor	v12.8b, v12.8b, v30.8b
 
-	tbnz	x22, #4, 2f		// SHA3-384 or SHA3-224
+	tbnz	x3, #4, 1f		// SHA3-384 or SHA3-224
 
 	// SHA3-256
-	ld1	{v25.8b-v28.8b}, [x20], #32
+	ld1	{v25.8b-v28.8b}, [x1], #32
 	eor	v13.8b, v13.8b, v25.8b
 	eor	v14.8b, v14.8b, v26.8b
 	eor	v15.8b, v15.8b, v27.8b
 	eor	v16.8b, v16.8b, v28.8b
-	b	4f
+	b	3f
 
-2:	tbz	x22, #2, 4f		// bit 2 cleared? SHA-384
+1:	tbz	x3, #2, 3f		// bit 2 cleared? SHA-384
 
 	// SHA3-224
-	ld1	{v25.8b-v28.8b}, [x20], #32
-	ld1	{v29.8b}, [x20], #8
+	ld1	{v25.8b-v28.8b}, [x1], #32
+	ld1	{v29.8b}, [x1], #8
 	eor	v13.8b, v13.8b, v25.8b
 	eor	v14.8b, v14.8b, v26.8b
 	eor	v15.8b, v15.8b, v27.8b
 	eor	v16.8b, v16.8b, v28.8b
 	eor	v17.8b, v17.8b, v29.8b
-	b	4f
+	b	3f
 
 	// SHA3-512
-3:	ld1	{v25.8b-v26.8b}, [x20], #16
+2:	ld1	{v25.8b-v26.8b}, [x1], #16
 	eor	 v7.8b,  v7.8b, v25.8b
 	eor	 v8.8b,  v8.8b, v26.8b
 
-4:	sub	w8, w8, #1
+3:	sub	w8, w8, #1
 
 	eor3	v29.16b,  v4.16b,  v9.16b, v14.16b
 	eor3	v26.16b,  v1.16b,  v6.16b, v11.16b
@@ -190,33 +183,19 @@ SYM_FUNC_START(sha3_ce_transform)
 
 	eor	 v0.16b,  v0.16b, v31.16b
 
-	cbnz	w8, 4b
-	cbz	w21, 5f
-
-	if_will_cond_yield_neon
-	add	x8, x19, #32
-	st1	{ v0.1d- v3.1d}, [x19]
-	st1	{ v4.1d- v7.1d}, [x8], #32
-	st1	{ v8.1d-v11.1d}, [x8], #32
-	st1	{v12.1d-v15.1d}, [x8], #32
-	st1	{v16.1d-v19.1d}, [x8], #32
-	st1	{v20.1d-v23.1d}, [x8], #32
-	st1	{v24.1d}, [x8]
-	do_cond_yield_neon
-	b		0b
-	endif_yield_neon
-
-	b	1b
+	cbnz	w8, 3b
+	cond_yield 3f, x8
+	cbnz	w2, 0b
 
 	/* save state */
-5:	st1	{ v0.1d- v3.1d}, [x19], #32
-	st1	{ v4.1d- v7.1d}, [x19], #32
-	st1	{ v8.1d-v11.1d}, [x19], #32
-	st1	{v12.1d-v15.1d}, [x19], #32
-	st1	{v16.1d-v19.1d}, [x19], #32
-	st1	{v20.1d-v23.1d}, [x19], #32
-	st1	{v24.1d}, [x19]
-	frame_pop
+3:	st1	{ v0.1d- v3.1d}, [x0], #32
+	st1	{ v4.1d- v7.1d}, [x0], #32
+	st1	{ v8.1d-v11.1d}, [x0], #32
+	st1	{v12.1d-v15.1d}, [x0], #32
+	st1	{v16.1d-v19.1d}, [x0], #32
+	st1	{v20.1d-v23.1d}, [x0], #32
+	st1	{v24.1d}, [x0]
+	mov	w0, w2
 	ret
 SYM_FUNC_END(sha3_ce_transform)
 
diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index 7288d3046354..8c65cecf560a 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -28,8 +28,8 @@ MODULE_ALIAS_CRYPTO("sha3-256");
 MODULE_ALIAS_CRYPTO("sha3-384");
 MODULE_ALIAS_CRYPTO("sha3-512");
 
-asmlinkage void sha3_ce_transform(u64 *st, const u8 *data, int blocks,
-				  int md_len);
+asmlinkage int sha3_ce_transform(u64 *st, const u8 *data, int blocks,
+				 int md_len);
 
 static int sha3_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
@@ -59,11 +59,15 @@ static int sha3_update(struct shash_desc *desc, const u8 *data,
 		blocks = len / sctx->rsiz;
 		len %= sctx->rsiz;
 
-		if (blocks) {
+		while (blocks) {
+			int rem;
+
 			kernel_neon_begin();
-			sha3_ce_transform(sctx->st, data, blocks, digest_size);
+			rem = sha3_ce_transform(sctx->st, data, blocks,
+						digest_size);
 			kernel_neon_end();
-			data += blocks * sctx->rsiz;
+			data += (blocks - rem) * sctx->rsiz;
+			blocks = rem;
 		}
 	}
 
-- 
2.30.0


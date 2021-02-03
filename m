Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92FD4C43381
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4871064E34
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhBCLhb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 06:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234116AbhBCLh3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 06:37:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 590EE64F77;
        Wed,  3 Feb 2021 11:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612352208;
        bh=pON+Mm1Ax02PzvWSSSCviGEhJ79J5Heu3op9Q39IulI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMxv4RGptAb1NkHOuONMkSREgthesFWSSIgcreKwexww1lCO55R8cSSmLPiXOnjff
         M55LoSEksFVGO1IVP5xcakKMDGq45Oit5JLHt3yGhKZgrkC22bI+NyqWUIJfID5quR
         KaBMZsJ3HnSYxPLWQ2hepbTBDb+ZZGV/KDnMM+U/x31hsBHr2RGq0hVRKmXsnEBUFQ
         O528xgx1nDmgOANmAVJMYtvhdNXnqZOARfEmOKMMzLAsrcRMNou8waLoCYqu9sO+kU
         6mHEPgJD/Ft0G94lpBdq+Pl0mJBy9wScfZuwt/tsF/7+mfDjrSFHrD7hbnedx1BUSe
         fbWdh3NlBdbtg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, will@kernel.org,
        mark.rutland@arm.com, catalin.marinas@arm.com,
        herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 3/9] crypto: arm64/sha2-ce - simplify NEON yield
Date:   Wed,  3 Feb 2021 12:36:20 +0100
Message-Id: <20210203113626.220151-4-ardb@kernel.org>
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

This reverts commit d82f37ab5e2426287013eba38b1212e8b71e5be3.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sha2-ce-core.S | 38 +++++++-------------
 arch/arm64/crypto/sha2-ce-glue.c | 22 ++++++------
 2 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 3f9d0f326987..6cdea7d56059 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -76,36 +76,30 @@
 	 */
 	.text
 SYM_FUNC_START(sha2_ce_transform)
-	frame_push	3
-
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-
 	/* load round constants */
-0:	adr_l		x8, .Lsha2_rcon
+	adr_l		x8, .Lsha2_rcon
 	ld1		{ v0.4s- v3.4s}, [x8], #64
 	ld1		{ v4.4s- v7.4s}, [x8], #64
 	ld1		{ v8.4s-v11.4s}, [x8], #64
 	ld1		{v12.4s-v15.4s}, [x8]
 
 	/* load state */
-	ld1		{dgav.4s, dgbv.4s}, [x19]
+	ld1		{dgav.4s, dgbv.4s}, [x0]
 
 	/* load sha256_ce_state::finalize */
 	ldr_l		w4, sha256_ce_offsetof_finalize, x4
-	ldr		w4, [x19, x4]
+	ldr		w4, [x0, x4]
 
 	/* load input */
-1:	ld1		{v16.4s-v19.4s}, [x20], #64
-	sub		w21, w21, #1
+0:	ld1		{v16.4s-v19.4s}, [x1], #64
+	sub		w2, w2, #1
 
 CPU_LE(	rev32		v16.16b, v16.16b	)
 CPU_LE(	rev32		v17.16b, v17.16b	)
 CPU_LE(	rev32		v18.16b, v18.16b	)
 CPU_LE(	rev32		v19.16b, v19.16b	)
 
-2:	add		t0.4s, v16.4s, v0.4s
+1:	add		t0.4s, v16.4s, v0.4s
 	mov		dg0v.16b, dgav.16b
 	mov		dg1v.16b, dgbv.16b
 
@@ -134,24 +128,18 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	add		dgbv.4s, dgbv.4s, dg1v.4s
 
 	/* handled all input blocks? */
-	cbz		w21, 3f
-
-	if_will_cond_yield_neon
-	st1		{dgav.4s, dgbv.4s}, [x19]
-	do_cond_yield_neon
+	cbz		w2, 2f
+	cond_yield	3f, x5
 	b		0b
-	endif_yield_neon
-
-	b		1b
 
 	/*
 	 * Final block: add padding and total bit count.
 	 * Skip if the input size was not a round multiple of the block size,
 	 * the padding is handled by the C code in that case.
 	 */
-3:	cbz		x4, 4f
+2:	cbz		x4, 3f
 	ldr_l		w4, sha256_ce_offsetof_count, x4
-	ldr		x4, [x19, x4]
+	ldr		x4, [x0, x4]
 	movi		v17.2d, #0
 	mov		x8, #0x80000000
 	movi		v18.2d, #0
@@ -160,10 +148,10 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	mov		x4, #0
 	mov		v19.d[0], xzr
 	mov		v19.d[1], x7
-	b		2b
+	b		1b
 
 	/* store new state */
-4:	st1		{dgav.4s, dgbv.4s}, [x19]
-	frame_pop
+3:	st1		{dgav.4s, dgbv.4s}, [x0]
+	mov		w0, w2
 	ret
 SYM_FUNC_END(sha2_ce_transform)
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index ded3a6488f81..c57a6119fefc 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -30,14 +30,22 @@ struct sha256_ce_state {
 extern const u32 sha256_ce_offsetof_count;
 extern const u32 sha256_ce_offsetof_finalize;
 
-asmlinkage void sha2_ce_transform(struct sha256_ce_state *sst, u8 const *src,
-				  int blocks);
+asmlinkage int sha2_ce_transform(struct sha256_ce_state *sst, u8 const *src,
+				 int blocks);
 
 static void __sha2_ce_transform(struct sha256_state *sst, u8 const *src,
 				int blocks)
 {
-	sha2_ce_transform(container_of(sst, struct sha256_ce_state, sst), src,
-			  blocks);
+	while (blocks) {
+		int rem;
+
+		kernel_neon_begin();
+		rem = sha2_ce_transform(container_of(sst, struct sha256_ce_state,
+						     sst), src, blocks);
+		kernel_neon_end();
+		src += (blocks - rem) * SHA256_BLOCK_SIZE;
+		blocks = rem;
+	}
 }
 
 const u32 sha256_ce_offsetof_count = offsetof(struct sha256_ce_state,
@@ -63,9 +71,7 @@ static int sha256_ce_update(struct shash_desc *desc, const u8 *data,
 				__sha256_block_data_order);
 
 	sctx->finalize = 0;
-	kernel_neon_begin();
 	sha256_base_do_update(desc, data, len, __sha2_ce_transform);
-	kernel_neon_end();
 
 	return 0;
 }
@@ -90,11 +96,9 @@ static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
 	 */
 	sctx->finalize = finalize;
 
-	kernel_neon_begin();
 	sha256_base_do_update(desc, data, len, __sha2_ce_transform);
 	if (!finalize)
 		sha256_base_do_finalize(desc, __sha2_ce_transform);
-	kernel_neon_end();
 	return sha256_base_finish(desc, out);
 }
 
@@ -108,9 +112,7 @@ static int sha256_ce_final(struct shash_desc *desc, u8 *out)
 	}
 
 	sctx->finalize = 0;
-	kernel_neon_begin();
 	sha256_base_do_finalize(desc, __sha2_ce_transform);
-	kernel_neon_end();
 	return sha256_base_finish(desc, out);
 }
 
-- 
2.30.0


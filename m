Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E54C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE16964DDE
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhBCLh2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 06:37:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234345AbhBCLh0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 06:37:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B286864E34;
        Wed,  3 Feb 2021 11:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612352205;
        bh=l0e0vMLQ9nXLc/iEm563E32nVgCaZdCixH0YxSaU37Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqaesSTjLqhWy/ouBziVvIoQdPLdSJ58OXSB8nOcUpy1mk5vrkXmP10dRgSmcp6f/
         wjmeQWarVm9i49ppnBVAlJdxMmXemR8OVQajmU0JiEIiCIJ0clksDuLgErEMFHtMDh
         VCNl26SLNbxHAGn53FldluhsZmhmATBfdUkOPRHIO06SSoqVt3ebnJ34CMGTJHg4lN
         /RgWayoA8JuvG64/sayijH5TsT5zqFikGZZJr87CIvHAfnkONtvP+/8/P2n6Y0v0zg
         v6Kd0kjZ645AyHxbFdEjxQIEixSy1WzOC11HdfFMBEij0TyouFFq7DTrFu7f2ZfzqN
         vlb1OhesA8U2Q==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, will@kernel.org,
        mark.rutland@arm.com, catalin.marinas@arm.com,
        herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 2/9] crypto: arm64/sha1-ce - simplify NEON yield
Date:   Wed,  3 Feb 2021 12:36:19 +0100
Message-Id: <20210203113626.220151-3-ardb@kernel.org>
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

This reverts commit 7df8d164753e6e6f229b72767595072bc6a71f48.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sha1-ce-core.S | 47 +++++++-------------
 arch/arm64/crypto/sha1-ce-glue.c | 22 ++++-----
 2 files changed, 29 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
index 92d0d2753e81..8c02bbc2684e 100644
--- a/arch/arm64/crypto/sha1-ce-core.S
+++ b/arch/arm64/crypto/sha1-ce-core.S
@@ -62,40 +62,34 @@
 	.endm
 
 	/*
-	 * void sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
-	 *			  int blocks)
+	 * int sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
+	 *			 int blocks)
 	 */
 SYM_FUNC_START(sha1_ce_transform)
-	frame_push	3
-
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-
 	/* load round constants */
-0:	loadrc		k0.4s, 0x5a827999, w6
+	loadrc		k0.4s, 0x5a827999, w6
 	loadrc		k1.4s, 0x6ed9eba1, w6
 	loadrc		k2.4s, 0x8f1bbcdc, w6
 	loadrc		k3.4s, 0xca62c1d6, w6
 
 	/* load state */
-	ld1		{dgav.4s}, [x19]
-	ldr		dgb, [x19, #16]
+	ld1		{dgav.4s}, [x0]
+	ldr		dgb, [x0, #16]
 
 	/* load sha1_ce_state::finalize */
 	ldr_l		w4, sha1_ce_offsetof_finalize, x4
-	ldr		w4, [x19, x4]
+	ldr		w4, [x0, x4]
 
 	/* load input */
-1:	ld1		{v8.4s-v11.4s}, [x20], #64
-	sub		w21, w21, #1
+0:	ld1		{v8.4s-v11.4s}, [x1], #64
+	sub		w2, w2, #1
 
 CPU_LE(	rev32		v8.16b, v8.16b		)
 CPU_LE(	rev32		v9.16b, v9.16b		)
 CPU_LE(	rev32		v10.16b, v10.16b	)
 CPU_LE(	rev32		v11.16b, v11.16b	)
 
-2:	add		t0.4s, v8.4s, k0.4s
+1:	add		t0.4s, v8.4s, k0.4s
 	mov		dg0v.16b, dgav.16b
 
 	add_update	c, ev, k0,  8,  9, 10, 11, dgb
@@ -126,25 +120,18 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	add		dgbv.2s, dgbv.2s, dg1v.2s
 	add		dgav.4s, dgav.4s, dg0v.4s
 
-	cbz		w21, 3f
-
-	if_will_cond_yield_neon
-	st1		{dgav.4s}, [x19]
-	str		dgb, [x19, #16]
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
 	ldr_l		w4, sha1_ce_offsetof_count, x4
-	ldr		x4, [x19, x4]
+	ldr		x4, [x0, x4]
 	movi		v9.2d, #0
 	mov		x8, #0x80000000
 	movi		v10.2d, #0
@@ -153,11 +140,11 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	mov		x4, #0
 	mov		v11.d[0], xzr
 	mov		v11.d[1], x7
-	b		2b
+	b		1b
 
 	/* store new state */
-4:	st1		{dgav.4s}, [x19]
-	str		dgb, [x19, #16]
-	frame_pop
+3:	st1		{dgav.4s}, [x0]
+	str		dgb, [x0, #16]
+	mov		w0, w2
 	ret
 SYM_FUNC_END(sha1_ce_transform)
diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index c1362861765f..71fa4f1122d7 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -29,14 +29,22 @@ struct sha1_ce_state {
 extern const u32 sha1_ce_offsetof_count;
 extern const u32 sha1_ce_offsetof_finalize;
 
-asmlinkage void sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
-				  int blocks);
+asmlinkage int sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
+				 int blocks);
 
 static void __sha1_ce_transform(struct sha1_state *sst, u8 const *src,
 				int blocks)
 {
-	sha1_ce_transform(container_of(sst, struct sha1_ce_state, sst), src,
-			  blocks);
+	while (blocks) {
+		int rem;
+
+		kernel_neon_begin();
+		rem = sha1_ce_transform(container_of(sst, struct sha1_ce_state,
+						     sst), src, blocks);
+		kernel_neon_end();
+		src += (blocks - rem) * SHA1_BLOCK_SIZE;
+		blocks = rem;
+	}
 }
 
 const u32 sha1_ce_offsetof_count = offsetof(struct sha1_ce_state, sst.count);
@@ -51,9 +59,7 @@ static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
 		return crypto_sha1_update(desc, data, len);
 
 	sctx->finalize = 0;
-	kernel_neon_begin();
 	sha1_base_do_update(desc, data, len, __sha1_ce_transform);
-	kernel_neon_end();
 
 	return 0;
 }
@@ -73,11 +79,9 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 	 */
 	sctx->finalize = finalize;
 
-	kernel_neon_begin();
 	sha1_base_do_update(desc, data, len, __sha1_ce_transform);
 	if (!finalize)
 		sha1_base_do_finalize(desc, __sha1_ce_transform);
-	kernel_neon_end();
 	return sha1_base_finish(desc, out);
 }
 
@@ -89,9 +93,7 @@ static int sha1_ce_final(struct shash_desc *desc, u8 *out)
 		return crypto_sha1_finup(desc, NULL, 0, out);
 
 	sctx->finalize = 0;
-	kernel_neon_begin();
 	sha1_base_do_finalize(desc, __sha1_ce_transform);
-	kernel_neon_end();
 	return sha1_base_finish(desc, out);
 }
 
-- 
2.30.0


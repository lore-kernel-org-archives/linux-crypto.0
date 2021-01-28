Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE49C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 13:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB80864D9D
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 13:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhA1NIO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jan 2021 08:08:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhA1NIE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jan 2021 08:08:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BA9D64D9D;
        Thu, 28 Jan 2021 13:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611839221;
        bh=Q39NwdyUAA/3iXYPVImYh+BeU+6qmllGHGCOUwEMCPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkTlPrZQw/atom/FaI4XkmmAdU+7vQeMwcxuxtEW3U0o38mCDEEwOVh+rjeysam+C
         suwDtTtEj5lJlS1eIFSFfd2BUSMxF1uVqrhxYBgtWKKCfLPjIpFlDS59tCmXziwl2b
         2N1xmzKAlEi2/tX9TxctltMs7uV+xN74tDG+1qu4/1DDNGUxR7xjzrU76m7wprz3Dx
         9DOBfBBDNfp0gDYVvLOPoRBn/TL4zylrA2vGsPspJjd0AFCfDxbvNZGX6RNmYSNXgh
         UFyLsuQei72cLugeHfcci0f55ewbEJ5zaR+7co/nWldUP0J1dnvMC2KKzQQw/KGCx9
         WOQNyfMSwzfIA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
        Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 8/9] crypto: arm64/crc-t10dif - move NEON yield to C code
Date:   Thu, 28 Jan 2021 14:06:24 +0100
Message-Id: <20210128130625.54076-9-ardb@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128130625.54076-1-ardb@kernel.org>
References: <20210128130625.54076-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of yielding from the bowels of the asm routine if a reschedule
is needed, divide up the input into 4 KB chunks in the C glue. This
simplifies the code substantially, and avoids scheduling out the task
with the asm routine on the call stack, which is undesirable from a
CFI/instrumentation point of view.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/crct10dif-ce-core.S | 43 +++++---------------
 arch/arm64/crypto/crct10dif-ce-glue.c | 30 +++++++++++---
 2 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index 111d9c9abddd..dce6dcebfca1 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -68,10 +68,10 @@
 	.text
 	.arch		armv8-a+crypto
 
-	init_crc	.req	w19
-	buf		.req	x20
-	len		.req	x21
-	fold_consts_ptr	.req	x22
+	init_crc	.req	w0
+	buf		.req	x1
+	len		.req	x2
+	fold_consts_ptr	.req	x3
 
 	fold_consts	.req	v10
 
@@ -257,12 +257,6 @@ CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
 	.endm
 
 	.macro		crc_t10dif_pmull, p
-	frame_push	4, 128
-
-	mov		init_crc, w0
-	mov		buf, x1
-	mov		len, x2
-
 	__pmull_init_\p
 
 	// For sizes less than 256 bytes, we can't fold 128 bytes at a time.
@@ -317,26 +311,7 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	fold_32_bytes	\p, v6, v7
 
 	subs		len, len, #128
-	b.lt		.Lfold_128_bytes_loop_done_\@
-
-	if_will_cond_yield_neon
-	stp		q0, q1, [sp, #.Lframe_local_offset]
-	stp		q2, q3, [sp, #.Lframe_local_offset + 32]
-	stp		q4, q5, [sp, #.Lframe_local_offset + 64]
-	stp		q6, q7, [sp, #.Lframe_local_offset + 96]
-	do_cond_yield_neon
-	ldp		q0, q1, [sp, #.Lframe_local_offset]
-	ldp		q2, q3, [sp, #.Lframe_local_offset + 32]
-	ldp		q4, q5, [sp, #.Lframe_local_offset + 64]
-	ldp		q6, q7, [sp, #.Lframe_local_offset + 96]
-	ld1		{fold_consts.2d}, [fold_consts_ptr]
-	__pmull_init_\p
-	__pmull_pre_\p	fold_consts
-	endif_yield_neon
-
-	b		.Lfold_128_bytes_loop_\@
-
-.Lfold_128_bytes_loop_done_\@:
+	b.ge		.Lfold_128_bytes_loop_\@
 
 	// Now fold the 112 bytes in v0-v6 into the 16 bytes in v7.
 
@@ -453,7 +428,9 @@ CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
 	// Final CRC value (x^16 * M(x)) mod G(x) is in low 16 bits of v0.
 
 	umov		w0, v0.h[0]
-	frame_pop
+	.ifc		\p, p8
+	ldp		x29, x30, [sp], #16
+	.endif
 	ret
 
 .Lless_than_256_bytes_\@:
@@ -489,7 +466,9 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 // Assumes len >= 16.
 //
 SYM_FUNC_START(crc_t10dif_pmull_p8)
-	crc_t10dif_pmull	p8
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
+	crc_t10dif_pmull p8
 SYM_FUNC_END(crc_t10dif_pmull_p8)
 
 	.align		5
diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index ccc3f6067742..09eb1456aed4 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -37,9 +37,18 @@ static int crct10dif_update_pmull_p8(struct shash_desc *desc, const u8 *data,
 	u16 *crc = shash_desc_ctx(desc);
 
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
-		kernel_neon_begin();
-		*crc = crc_t10dif_pmull_p8(*crc, data, length);
-		kernel_neon_end();
+		do {
+			unsigned int chunk = length;
+
+			if (chunk > SZ_4K + CRC_T10DIF_PMULL_CHUNK_SIZE)
+				chunk = SZ_4K;
+
+			kernel_neon_begin();
+			*crc = crc_t10dif_pmull_p8(*crc, data, chunk);
+			kernel_neon_end();
+			data += chunk;
+			length -= chunk;
+		} while (length);
 	} else {
 		*crc = crc_t10dif_generic(*crc, data, length);
 	}
@@ -53,9 +62,18 @@ static int crct10dif_update_pmull_p64(struct shash_desc *desc, const u8 *data,
 	u16 *crc = shash_desc_ctx(desc);
 
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
-		kernel_neon_begin();
-		*crc = crc_t10dif_pmull_p64(*crc, data, length);
-		kernel_neon_end();
+		do {
+			unsigned int chunk = length;
+
+			if (chunk > SZ_4K + CRC_T10DIF_PMULL_CHUNK_SIZE)
+				chunk = SZ_4K;
+
+			kernel_neon_begin();
+			*crc = crc_t10dif_pmull_p64(*crc, data, chunk);
+			kernel_neon_end();
+			data += chunk;
+			length -= chunk;
+		} while (length);
 	} else {
 		*crc = crc_t10dif_generic(*crc, data, length);
 	}
-- 
2.29.2


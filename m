From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 14/15] arm64/crypto: add voluntary preemption to Crypto Extensions SHA2
Date: Thu,  1 May 2014 17:51:25 +0200
Message-ID: <1398959486-8222-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1398959486-8222-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
	steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60657 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaEAPvk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 May 2014 11:51:40 -0400
Received: by mail-wi0-f181.google.com with SMTP id f8so967735wiw.14
        for <linux-crypto@vger.kernel.org>; Thu, 01 May 2014 08:51:39 -0700 (PDT)
In-Reply-To: <1398959486-8222-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Crypto Extensions based SHA2 implementation uses the NEON register file,
and hence runs with preemption disabled. This patch adds a TIF_NEED_RESCHED
check to its inner loop so we at least give up the CPU voluntarily when we
are running in process context and have been tagged for preemption by the
scheduler.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha2-ce-core.S | 19 ++++++++-------
 arch/arm64/crypto/sha2-ce-glue.c | 51 ++++++++++++++++++++++++++++++----------
 2 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 53e750614169..46b669d91c29 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -73,8 +73,8 @@
 	.word		0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
 
 	/*
-	 * void sha2_ce_transform(int blocks, u8 const *src, u32 *state,
-	 *                        u8 *head, long bytes)
+	 * int sha2_ce_transform(int blocks, u8 const *src, u32 *state,
+	 *                       u8 *head, long bytes, struct thread_info *ti)
 	 */
 ENTRY(sha2_ce_transform)
 	/* load round constants */
@@ -131,7 +131,14 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	add		dgbv.4s, dgbv.4s, dg1v.4s
 
 	/* handled all input blocks? */
-	cbnz		w0, 0b
+	cbz		w0, 4f
+
+	/* should we exit early? */
+	b_if_no_resched	x5, x8, 0b
+
+	/* store new state */
+3:	stp		dga, dgb, [x2]
+	ret
 
 	/*
 	 * Final block: add padding and total bit count.
@@ -139,7 +146,7 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	 * size was not a round multiple of the block size, and the padding is
 	 * handled by the C code.
 	 */
-	cbz		x4, 3f
+4:	cbz		x4, 3b
 	movi		v17.2d, #0
 	mov		x8, #0x80000000
 	movi		v18.2d, #0
@@ -149,8 +156,4 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 	mov		v19.d[0], xzr
 	mov		v19.d[1], x7
 	b		2b
-
-	/* store new state */
-3:	stp		dga, dgb, [x2]
-	ret
 ENDPROC(sha2_ce_transform)
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index 81617262b3df..6566ad3fdf82 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -1,4 +1,4 @@
-/*
+h/*
  * sha2-ce-glue.c - SHA-224/SHA-256 using ARMv8 Crypto Extensions
  *
  * Copyright (C) 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
@@ -20,8 +20,8 @@ MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
-asmlinkage void sha2_ce_transform(int blocks, u8 const *src, u32 *state,
-				 u8 *head, long bytes);
+asmlinkage int sha2_ce_transform(int blocks, u8 const *src, u32 *state,
+				 u8 *head, long bytes, struct thread_info *ti);
 
 static int sha224_init(struct shash_desc *desc)
 {
@@ -58,6 +58,7 @@ static int sha2_update(struct shash_desc *desc, const u8 *data,
 	sctx->count += len;
 
 	if ((partial + len) >= SHA256_BLOCK_SIZE) {
+		struct thread_info *ti = NULL;
 		int blocks;
 
 		if (partial) {
@@ -68,16 +69,30 @@ static int sha2_update(struct shash_desc *desc, const u8 *data,
 			len -= p;
 		}
 
+		/*
+		 * Pass current's thread info pointer to sha2_ce_transform()
+		 * below if we want it to play nice under preemption.
+		 */
+		if ((IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) ||
+		     IS_ENABLED(CONFIG_PREEMPT)) && !in_interrupt())
+			ti = current_thread_info();
+
 		blocks = len / SHA256_BLOCK_SIZE;
 		len %= SHA256_BLOCK_SIZE;
 
-		kernel_neon_begin_partial(28);
-		sha2_ce_transform(blocks, data, sctx->state,
-				  partial ? sctx->buf : NULL, 0);
-		kernel_neon_end();
+		do {
+			int rem;
+
+			kernel_neon_begin_partial(28);
+			rem = sha2_ce_transform(blocks, data, sctx->state,
+						partial ? sctx->buf : NULL,
+						0, ti);
+			kernel_neon_end();
 
-		data += blocks * SHA256_BLOCK_SIZE;
-		partial = 0;
+			data += (blocks - rem) * SHA256_BLOCK_SIZE;
+			blocks = rem;
+			partial = 0;
+		} while (unlikely(ti && blocks > 0));
 	}
 	if (len)
 		memcpy(sctx->buf + partial, data, len);
@@ -131,6 +146,7 @@ static void sha2_finup(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct thread_info *ti = NULL;
 	int blocks;
 
 	if (sctx->count || !len || (len % SHA256_BLOCK_SIZE)) {
@@ -147,9 +163,20 @@ static void sha2_finup(struct shash_desc *desc, const u8 *data,
 	 */
 	blocks = len / SHA256_BLOCK_SIZE;
 
-	kernel_neon_begin_partial(28);
-	sha2_ce_transform(blocks, data, sctx->state, NULL, len);
-	kernel_neon_end();
+	if ((IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) ||
+	     IS_ENABLED(CONFIG_PREEMPT)) && !in_interrupt())
+		ti = current_thread_info();
+
+	do {
+		int rem;
+
+		kernel_neon_begin_partial(28);
+		rem = sha2_ce_transform(blocks, data, sctx->state,
+					NULL, len, ti);
+		kernel_neon_end();
+		data += (blocks - rem) * SHA256_BLOCK_SIZE;
+		blocks = rem;
+	} while (unlikely(ti && blocks > 0));
 }
 
 static int sha224_finup(struct shash_desc *desc, const u8 *data,
-- 
1.8.3.2

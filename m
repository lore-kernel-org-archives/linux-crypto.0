From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 13/15] arm64/crypto: add voluntary preemption to Crypto Extensions SHA1
Date: Thu,  1 May 2014 17:51:24 +0200
Message-ID: <1398959486-8222-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1398959486-8222-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
	steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34127 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaEAPvj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 May 2014 11:51:39 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so969753wib.4
        for <linux-crypto@vger.kernel.org>; Thu, 01 May 2014 08:51:37 -0700 (PDT)
In-Reply-To: <1398959486-8222-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Crypto Extensions based SHA1 implementation uses the NEON register file,
and hence runs with preemption disabled. This patch adds a TIF_NEED_RESCHED
check to its inner loop so we at least give up the CPU voluntarily when we
are running in process context and have been tagged for preemption by the
scheduler.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha1-ce-core.S | 19 ++++++++--------
 arch/arm64/crypto/sha1-ce-glue.c | 49 +++++++++++++++++++++++++++++++---------
 2 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
index bd4af29f2722..831e332f9331 100644
--- a/arch/arm64/crypto/sha1-ce-core.S
+++ b/arch/arm64/crypto/sha1-ce-core.S
@@ -66,8 +66,8 @@
 	.word		0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xca62c1d6
 
 	/*
-	 * void sha1_ce_transform(int blocks, u8 const *src, u32 *state,
-	 * 			  u8 *head, long bytes)
+	 * int sha1_ce_transform(int blocks, u8 const *src, u32 *state,
+	 * 			 u8 *head, long bytes, struct thread_info *ti)
 	 */
 ENTRY(sha1_ce_transform)
 	/* load round constants */
@@ -127,7 +127,13 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	add		dgbv.2s, dgbv.2s, dg1v.2s
 	add		dgav.4s, dgav.4s, dg0v.4s
 
-	cbnz		w0, 0b
+	cbz		w0, 4f
+	b_if_no_resched	x5, x8, 0b
+
+	/* store new state */
+3:	str		dga, [x2]
+	str		dgb, [x2, #16]
+	ret
 
 	/*
 	 * Final block: add padding and total bit count.
@@ -135,7 +141,7 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	 * size was not a round multiple of the block size, and the padding is
 	 * handled by the C code.
 	 */
-	cbz		x4, 3f
+4:	cbz		x4, 3b
 	movi		v9.2d, #0
 	mov		x8, #0x80000000
 	movi		v10.2d, #0
@@ -145,9 +151,4 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	mov		v11.d[0], xzr
 	mov		v11.d[1], x7
 	b		2b
-
-	/* store new state */
-3:	str		dga, [x2]
-	str		dgb, [x2, #16]
-	ret
 ENDPROC(sha1_ce_transform)
diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index 6fe83f37a750..69850a163668 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -20,8 +20,8 @@ MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
-asmlinkage void sha1_ce_transform(int blocks, u8 const *src, u32 *state,
-				  u8 *head, long bytes);
+asmlinkage int sha1_ce_transform(int blocks, u8 const *src, u32 *state,
+				 u8 *head, long bytes, struct thread_info *ti);
 
 static int sha1_init(struct shash_desc *desc)
 {
@@ -42,6 +42,7 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 	sctx->count += len;
 
 	if ((partial + len) >= SHA1_BLOCK_SIZE) {
+		struct thread_info *ti = NULL;
 		int blocks;
 
 		if (partial) {
@@ -52,16 +53,30 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 			len -= p;
 		}
 
+		/*
+		 * Pass current's thread info pointer to sha1_ce_transform()
+		 * below if we want it to play nice under preemption.
+		 */
+		if ((IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) ||
+		     IS_ENABLED(CONFIG_PREEMPT)) && !in_interrupt())
+			ti = current_thread_info();
+
 		blocks = len / SHA1_BLOCK_SIZE;
 		len %= SHA1_BLOCK_SIZE;
 
-		kernel_neon_begin_partial(16);
-		sha1_ce_transform(blocks, data, sctx->state,
-				  partial ? sctx->buffer : NULL, 0);
-		kernel_neon_end();
+		do {
+			int rem;
+
+			kernel_neon_begin_partial(16);
+			rem = sha1_ce_transform(blocks, data, sctx->state,
+						partial ? sctx->buffer : NULL,
+						0, ti);
+			kernel_neon_end();
 
-		data += blocks * SHA1_BLOCK_SIZE;
-		partial = 0;
+			data += (blocks - rem) * SHA1_BLOCK_SIZE;
+			blocks = rem;
+			partial = 0;
+		} while (unlikely(ti && blocks > 0));
 	}
 	if (len)
 		memcpy(sctx->buffer + partial, data, len);
@@ -94,6 +109,7 @@ static int sha1_finup(struct shash_desc *desc, const u8 *data,
 		      unsigned int len, u8 *out)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
+	struct thread_info *ti = NULL;
 	__be32 *dst = (__be32 *)out;
 	int blocks;
 	int i;
@@ -111,9 +127,20 @@ static int sha1_finup(struct shash_desc *desc, const u8 *data,
 	 */
 	blocks = len / SHA1_BLOCK_SIZE;
 
-	kernel_neon_begin_partial(16);
-	sha1_ce_transform(blocks, data, sctx->state, NULL, len);
-	kernel_neon_end();
+	if ((IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) ||
+	     IS_ENABLED(CONFIG_PREEMPT)) && !in_interrupt())
+		ti = current_thread_info();
+
+	do {
+		int rem;
+
+		kernel_neon_begin_partial(16);
+		rem = sha1_ce_transform(blocks, data, sctx->state,
+					NULL, len, ti);
+		kernel_neon_end();
+		data += (blocks - rem) * SHA1_BLOCK_SIZE;
+		blocks = rem;
+	} while (unlikely(ti && blocks > 0));
 
 	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(__be32); i++)
 		put_unaligned_be32(sctx->state[i], dst++);
-- 
1.8.3.2

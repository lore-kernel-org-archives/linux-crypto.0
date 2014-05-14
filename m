From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 09/11] arm64/crypto: add voluntary preemption to Crypto Extensions SHA1
Date: Wed, 14 May 2014 11:17:29 -0700
Message-ID: <1400091451-9117-10-git-send-email-ard.biesheuvel@linaro.org>
References: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, jussi.kivilinna@iki.fi,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:52499 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaENSSC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 14:18:02 -0400
Received: by mail-yh0-f53.google.com with SMTP id i57so2027753yha.26
        for <linux-crypto@vger.kernel.org>; Wed, 14 May 2014 11:18:01 -0700 (PDT)
In-Reply-To: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Crypto Extensions based SHA1 implementation uses the NEON register file,
and hence runs with preemption disabled. This patch adds a TIF_NEED_RESCHED
check to its inner loop so we at least give up the CPU voluntarily when we
are running in process context and have been tagged for preemption by the
scheduler.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/sha1-ce-core.S | 19 ++++++++-------
 arch/arm64/crypto/sha1-ce-glue.c | 52 ++++++++++++++++++++++++++--------------
 2 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
index 09d57d98609c..0cb9b8f4906b 100644
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
index 6fe83f37a750..b195f7104706 100644
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
@@ -33,6 +33,34 @@ static int sha1_init(struct shash_desc *desc)
 	return 0;
 }
 
+static u8 const *sha1_do_update(struct shash_desc *desc, const u8 *data,
+				int blocks, u8 *head, unsigned int len)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	struct thread_info *ti = NULL;
+
+	/*
+	 * Pass current's thread info pointer to sha1_ce_transform()
+	 * below if we want it to play nice under preemption.
+	 */
+	if ((IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) || IS_ENABLED(CONFIG_PREEMPT))
+	    && (desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP))
+		ti = current_thread_info();
+
+	do {
+		int rem;
+
+		kernel_neon_begin_partial(16);
+		rem = sha1_ce_transform(blocks, data, sctx->state, head, 0, ti);
+		kernel_neon_end();
+
+		data += (blocks - rem) * SHA1_BLOCK_SIZE;
+		blocks = rem;
+		head = NULL;
+	} while (unlikely(ti && blocks > 0));
+	return data;
+}
+
 static int sha1_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
 {
@@ -42,8 +70,6 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 	sctx->count += len;
 
 	if ((partial + len) >= SHA1_BLOCK_SIZE) {
-		int blocks;
-
 		if (partial) {
 			int p = SHA1_BLOCK_SIZE - partial;
 
@@ -52,15 +78,10 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 			len -= p;
 		}
 
-		blocks = len / SHA1_BLOCK_SIZE;
-		len %= SHA1_BLOCK_SIZE;
+		data = sha1_do_update(desc, data, len / SHA1_BLOCK_SIZE,
+				      partial ? sctx->buffer : NULL, 0);
 
-		kernel_neon_begin_partial(16);
-		sha1_ce_transform(blocks, data, sctx->state,
-				  partial ? sctx->buffer : NULL, 0);
-		kernel_neon_end();
-
-		data += blocks * SHA1_BLOCK_SIZE;
+		len %= SHA1_BLOCK_SIZE;
 		partial = 0;
 	}
 	if (len)
@@ -95,7 +116,6 @@ static int sha1_finup(struct shash_desc *desc, const u8 *data,
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
 	__be32 *dst = (__be32 *)out;
-	int blocks;
 	int i;
 
 	if (sctx->count || !len || (len % SHA1_BLOCK_SIZE)) {
@@ -109,11 +129,7 @@ static int sha1_finup(struct shash_desc *desc, const u8 *data,
 	 * perform the entire digest calculation in a single invocation
 	 * of sha1_ce_transform()
 	 */
-	blocks = len / SHA1_BLOCK_SIZE;
-
-	kernel_neon_begin_partial(16);
-	sha1_ce_transform(blocks, data, sctx->state, NULL, len);
-	kernel_neon_end();
+	sha1_do_update(desc, data, len / SHA1_BLOCK_SIZE, NULL, len);
 
 	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(__be32); i++)
 		put_unaligned_be32(sctx->state[i], dst++);
-- 
1.8.3.2

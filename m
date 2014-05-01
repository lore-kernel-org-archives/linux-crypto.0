From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 15/15] arm64/crypto: add voluntary preemption to Crypto Extensions GHASH
Date: Thu,  1 May 2014 17:51:26 +0200
Message-ID: <1398959486-8222-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1398959486-8222-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
	steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:38121 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaEAPvl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 May 2014 11:51:41 -0400
Received: by mail-we0-f179.google.com with SMTP id q59so956796wes.38
        for <linux-crypto@vger.kernel.org>; Thu, 01 May 2014 08:51:40 -0700 (PDT)
In-Reply-To: <1398959486-8222-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Crypto Extensions based GHASH implementation uses the NEON register file,
and hence runs with preemption disabled. This patch adds a TIF_NEED_RESCHED
check to its inner loop so we at least give up the CPU voluntarily when we
are running in process context and have been tagged for preemption by the
scheduler.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 10 ++++++----
 arch/arm64/crypto/ghash-ce-glue.c | 33 +++++++++++++++++++++++++--------
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index b9e6eaf41c9b..523432f24ed2 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -31,8 +31,9 @@
 	.arch		armv8-a+crypto
 
 	/*
-	 * void pmull_ghash_update(int blocks, u64 dg[], const char *src,
-	 *			   struct ghash_key const *k, const char *head)
+	 * int pmull_ghash_update(int blocks, u64 dg[], const char *src,
+	 *			  struct ghash_key const *k, const char *head,
+	 * 			  struct thread_info *ti)
 	 */
 ENTRY(pmull_ghash_update)
 	ld1		{DATA.16b}, [x1]
@@ -88,8 +89,9 @@ CPU_LE(	rev64		IN1.16b, IN1.16b	)
 	eor		T1.16b, T1.16b, T2.16b
 	eor		DATA.16b, DATA.16b, T1.16b
 
-	cbnz		w0, 0b
+	cbz		w0, 2f
+	b_if_no_resched	x5, x7, 0b
 
-	st1		{DATA.16b}, [x1]
+2:	st1		{DATA.16b}, [x1]
 	ret
 ENDPROC(pmull_ghash_update)
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index b92baf3f68c7..4df64832617d 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -33,8 +33,9 @@ struct ghash_desc_ctx {
 	u32 count;
 };
 
-asmlinkage void pmull_ghash_update(int blocks, u64 dg[], const char *src,
-				   struct ghash_key const *k, const char *head);
+asmlinkage int pmull_ghash_update(int blocks, u64 dg[], const char *src,
+				  struct ghash_key const *k, const char *head,
+				  struct thread_info *ti);
 
 static int ghash_init(struct shash_desc *desc)
 {
@@ -54,6 +55,7 @@ static int ghash_update(struct shash_desc *desc, const u8 *src,
 
 	if ((partial + len) >= GHASH_BLOCK_SIZE) {
 		struct ghash_key *key = crypto_shash_ctx(desc->tfm);
+		struct thread_info *ti = NULL;
 		int blocks;
 
 		if (partial) {
@@ -64,14 +66,29 @@ static int ghash_update(struct shash_desc *desc, const u8 *src,
 			len -= p;
 		}
 
+		/*
+		 * Pass current's thread info pointer to pmull_ghash_update()
+		 * below if we want it to play nice under preemption.
+		 */
+		if ((IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) ||
+		     IS_ENABLED(CONFIG_PREEMPT)) && !in_interrupt())
+			ti = current_thread_info();
+
 		blocks = len / GHASH_BLOCK_SIZE;
 		len %= GHASH_BLOCK_SIZE;
 
-		kernel_neon_begin_partial(6);
-		pmull_ghash_update(blocks, ctx->digest, src, key,
-				   partial ? ctx->buf : NULL);
-		kernel_neon_end();
-		src += blocks * GHASH_BLOCK_SIZE;
+		do {
+			int rem;
+
+			kernel_neon_begin_partial(6);
+			rem = pmull_ghash_update(blocks, ctx->digest, src, key,
+						 partial ? ctx->buf : NULL, ti);
+			kernel_neon_end();
+
+			src += (blocks - rem) * GHASH_BLOCK_SIZE;
+			blocks = rem;
+			partial = 0;
+		} while (unlikely(ti && blocks > 0));
 	}
 	if (len)
 		memcpy(ctx->buf + partial, src, len);
@@ -89,7 +106,7 @@ static int ghash_final(struct shash_desc *desc, u8 *dst)
 		memset(ctx->buf + partial, 0, GHASH_BLOCK_SIZE - partial);
 
 		kernel_neon_begin_partial(6);
-		pmull_ghash_update(1, ctx->digest, ctx->buf, key, NULL);
+		pmull_ghash_update(1, ctx->digest, ctx->buf, key, NULL, NULL);
 		kernel_neon_end();
 	}
 	put_unaligned_be64(ctx->digest[1], dst);
-- 
1.8.3.2

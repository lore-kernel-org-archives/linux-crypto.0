From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: sha512-mb - remove HASH_FIRST flag
Date: Wed, 24 Jan 2018 19:10:21 -0800
Message-ID: <20180125031021.888-1-ebiggers3@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:40974 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932925AbeAYDKZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 22:10:25 -0500
Received: by mail-pg0-f67.google.com with SMTP id 136so4173890pgd.8
        for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2018 19:10:25 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The HASH_FIRST flag is never set.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sha512-mb/sha512_mb.c     | 30 +++---------------------------
 arch/x86/crypto/sha512-mb/sha512_mb_ctx.h |  8 +++-----
 2 files changed, 6 insertions(+), 32 deletions(-)

diff --git a/arch/x86/crypto/sha512-mb/sha512_mb.c b/arch/x86/crypto/sha512-mb/sha512_mb.c
index 458409b7568d..39e2bbdc1836 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb.c
+++ b/arch/x86/crypto/sha512-mb/sha512_mb.c
@@ -107,15 +107,6 @@ static asmlinkage struct job_sha512* (*sha512_job_mgr_flush)
 static asmlinkage struct job_sha512* (*sha512_job_mgr_get_comp_job)
 						(struct sha512_mb_mgr *state);
 
-inline void sha512_init_digest(uint64_t *digest)
-{
-	static const uint64_t initial_digest[SHA512_DIGEST_LENGTH] = {
-					SHA512_H0, SHA512_H1, SHA512_H2,
-					SHA512_H3, SHA512_H4, SHA512_H5,
-					SHA512_H6, SHA512_H7 };
-	memcpy(digest, initial_digest, sizeof(initial_digest));
-}
-
 inline uint32_t sha512_pad(uint8_t padblock[SHA512_BLOCK_SIZE * 2],
 			 uint64_t total_len)
 {
@@ -263,11 +254,8 @@ static struct sha512_hash_ctx
 
 	mgr = cstate->mgr;
 	spin_lock_irqsave(&cstate->work_lock, irqflags);
-	if (flags & (~HASH_ENTIRE)) {
-		/*
-		 * User should not pass anything other than FIRST, UPDATE, or
-		 * LAST
-		 */
+	if (flags & ~(HASH_UPDATE | HASH_LAST)) {
+		/* User should not pass anything other than UPDATE or LAST */
 		ctx->error = HASH_CTX_ERROR_INVALID_FLAGS;
 		goto unlock;
 	}
@@ -278,24 +266,12 @@ static struct sha512_hash_ctx
 		goto unlock;
 	}
 
-	if ((ctx->status & HASH_CTX_STS_COMPLETE) && !(flags & HASH_FIRST)) {
+	if (ctx->status & HASH_CTX_STS_COMPLETE) {
 		/* Cannot update a finished job. */
 		ctx->error = HASH_CTX_ERROR_ALREADY_COMPLETED;
 		goto unlock;
 	}
 
-
-	if (flags & HASH_FIRST) {
-		/* Init digest */
-		sha512_init_digest(ctx->job.result_digest);
-
-		/* Reset byte counter */
-		ctx->total_length = 0;
-
-		/* Clear extra blocks */
-		ctx->partial_block_buffer_length = 0;
-	}
-
 	/*
 	 * If we made it here, there were no errors during this call to
 	 * submit
diff --git a/arch/x86/crypto/sha512-mb/sha512_mb_ctx.h b/arch/x86/crypto/sha512-mb/sha512_mb_ctx.h
index e4653f5eec3f..e5c465bd821e 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb_ctx.h
+++ b/arch/x86/crypto/sha512-mb/sha512_mb_ctx.h
@@ -57,11 +57,9 @@
 #include "sha512_mb_mgr.h"
 
 #define HASH_UPDATE          0x00
-#define HASH_FIRST           0x01
-#define HASH_LAST            0x02
-#define HASH_ENTIRE          0x03
-#define HASH_DONE            0x04
-#define HASH_FINAL           0x08
+#define HASH_LAST            0x01
+#define HASH_DONE            0x02
+#define HASH_FINAL           0x04
 
 #define HASH_CTX_STS_IDLE       0x00
 #define HASH_CTX_STS_PROCESSING 0x01
-- 
2.16.0

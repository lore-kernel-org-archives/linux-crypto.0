From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: sha1-mb - remove HASH_FIRST flag
Date: Wed, 24 Jan 2018 19:10:08 -0800
Message-ID: <20180125031008.778-1-ebiggers3@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:44410 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932956AbeAYDKM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 22:10:12 -0500
Received: by mail-pg0-f68.google.com with SMTP id m20so4173422pgc.11
        for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2018 19:10:12 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The HASH_FIRST flag is never set.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sha1-mb/sha1_mb.c     | 28 +++-------------------------
 arch/x86/crypto/sha1-mb/sha1_mb_ctx.h |  8 +++-----
 2 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/arch/x86/crypto/sha1-mb/sha1_mb.c b/arch/x86/crypto/sha1-mb/sha1_mb.c
index acf9fdf01671..e17655ffde79 100644
--- a/arch/x86/crypto/sha1-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha1-mb/sha1_mb.c
@@ -106,13 +106,6 @@ static asmlinkage struct job_sha1* (*sha1_job_mgr_flush)
 static asmlinkage struct job_sha1* (*sha1_job_mgr_get_comp_job)
 						(struct sha1_mb_mgr *state);
 
-static inline void sha1_init_digest(uint32_t *digest)
-{
-	static const uint32_t initial_digest[SHA1_DIGEST_LENGTH] = {SHA1_H0,
-					SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 };
-	memcpy(digest, initial_digest, sizeof(initial_digest));
-}
-
 static inline uint32_t sha1_pad(uint8_t padblock[SHA1_BLOCK_SIZE * 2],
 			 uint64_t total_len)
 {
@@ -244,11 +237,8 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(struct sha1_ctx_mgr *mgr,
 					  uint32_t len,
 					  int flags)
 {
-	if (flags & (~HASH_ENTIRE)) {
-		/*
-		 * User should not pass anything other than FIRST, UPDATE, or
-		 * LAST
-		 */
+	if (flags & ~(HASH_UPDATE | HASH_LAST)) {
+		/* User should not pass anything other than UPDATE or LAST */
 		ctx->error = HASH_CTX_ERROR_INVALID_FLAGS;
 		return ctx;
 	}
@@ -259,24 +249,12 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(struct sha1_ctx_mgr *mgr,
 		return ctx;
 	}
 
-	if ((ctx->status & HASH_CTX_STS_COMPLETE) && !(flags & HASH_FIRST)) {
+	if (ctx->status & HASH_CTX_STS_COMPLETE) {
 		/* Cannot update a finished job. */
 		ctx->error = HASH_CTX_ERROR_ALREADY_COMPLETED;
 		return ctx;
 	}
 
-
-	if (flags & HASH_FIRST) {
-		/* Init digest */
-		sha1_init_digest(ctx->job.result_digest);
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
diff --git a/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h b/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
index 13590ccf965c..9454bd16f9f8 100644
--- a/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
@@ -57,11 +57,9 @@
 #include "sha1_mb_mgr.h"
 
 #define HASH_UPDATE          0x00
-#define HASH_FIRST           0x01
-#define HASH_LAST            0x02
-#define HASH_ENTIRE          0x03
-#define HASH_DONE	     0x04
-#define HASH_FINAL	     0x08
+#define HASH_LAST            0x01
+#define HASH_DONE	     0x02
+#define HASH_FINAL	     0x04
 
 #define HASH_CTX_STS_IDLE       0x00
 #define HASH_CTX_STS_PROCESSING 0x01
-- 
2.16.0

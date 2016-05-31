From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH 1/2] crypto : stylistic cleanup in sha1-mb
Date: Tue, 31 May 2016 14:42:20 -0700
Message-ID: <1464730941-8847-2-git-send-email-megha.dey@intel.com>
References: <1464730941-8847-1-git-send-email-megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	megha.dey@intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28357 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbcEaVhH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 17:37:07 -0400
In-Reply-To: <1464730941-8847-1-git-send-email-megha.dey@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Megha Dey <megha.dey@linux.intel.com>

Currently there are several checkpatch warnings in the sha1_mb.c file:
'WARNING: line over 80 characters' in the sha1_mb.c file. Also, the
syntax of some multi-line comments are not correct. This patch fixes
these issues.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
---
 arch/x86/crypto/sha-mb/sha1_mb.c | 110 ++++++++++++++++++++++++++-------------
 1 file changed, 74 insertions(+), 36 deletions(-)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
index 9c5af33..0a46491 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha-mb/sha1_mb.c
@@ -77,7 +77,8 @@ struct sha1_mb_ctx {
 	struct mcryptd_ahash *mcryptd_tfm;
 };
 
-static inline struct mcryptd_hash_request_ctx *cast_hash_to_mcryptd_ctx(struct sha1_hash_ctx *hash_ctx)
+static inline struct mcryptd_hash_request_ctx
+		*cast_hash_to_mcryptd_ctx(struct sha1_hash_ctx *hash_ctx)
 {
 	struct shash_desc *desc;
 
@@ -85,7 +86,8 @@ static inline struct mcryptd_hash_request_ctx *cast_hash_to_mcryptd_ctx(struct s
 	return container_of(desc, struct mcryptd_hash_request_ctx, desc);
 }
 
-static inline struct ahash_request *cast_mcryptd_ctx_to_req(struct mcryptd_hash_request_ctx *ctx)
+static inline struct ahash_request
+		*cast_mcryptd_ctx_to_req(struct mcryptd_hash_request_ctx *ctx)
 {
 	return container_of((void *) ctx, struct ahash_request, __ctx);
 }
@@ -97,10 +99,12 @@ static void req_ctx_init(struct mcryptd_hash_request_ctx *rctx,
 }
 
 static asmlinkage void (*sha1_job_mgr_init)(struct sha1_mb_mgr *state);
-static asmlinkage struct job_sha1* (*sha1_job_mgr_submit)(struct sha1_mb_mgr *state,
-							  struct job_sha1 *job);
-static asmlinkage struct job_sha1* (*sha1_job_mgr_flush)(struct sha1_mb_mgr *state);
-static asmlinkage struct job_sha1* (*sha1_job_mgr_get_comp_job)(struct sha1_mb_mgr *state);
+static asmlinkage struct job_sha1* (*sha1_job_mgr_submit)
+			(struct sha1_mb_mgr *state, struct job_sha1 *job);
+static asmlinkage struct job_sha1* (*sha1_job_mgr_flush)
+						(struct sha1_mb_mgr *state);
+static asmlinkage struct job_sha1* (*sha1_job_mgr_get_comp_job)
+						(struct sha1_mb_mgr *state);
 
 static inline void sha1_init_digest(uint32_t *digest)
 {
@@ -131,7 +135,8 @@ static inline uint32_t sha1_pad(uint8_t padblock[SHA1_BLOCK_SIZE * 2],
 	return i >> SHA1_LOG2_BLOCK_SIZE;
 }
 
-static struct sha1_hash_ctx *sha1_ctx_mgr_resubmit(struct sha1_ctx_mgr *mgr, struct sha1_hash_ctx *ctx)
+static struct sha1_hash_ctx *sha1_ctx_mgr_resubmit(struct sha1_ctx_mgr *mgr,
+						struct sha1_hash_ctx *ctx)
 {
 	while (ctx) {
 		if (ctx->status & HASH_CTX_STS_COMPLETE) {
@@ -177,8 +182,8 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_resubmit(struct sha1_ctx_mgr *mgr, str
 
 				ctx->job.buffer = (uint8_t *) buffer;
 				ctx->job.len = len;
-				ctx = (struct sha1_hash_ctx *) sha1_job_mgr_submit(&mgr->mgr,
-										  &ctx->job);
+				ctx = (struct sha1_hash_ctx *)sha1_job_mgr_submit(&mgr->mgr,
+										&ctx->job);
 				continue;
 			}
 		}
@@ -191,13 +196,15 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_resubmit(struct sha1_ctx_mgr *mgr, str
 		if (ctx->status & HASH_CTX_STS_LAST) {
 
 			uint8_t *buf = ctx->partial_block_buffer;
-			uint32_t n_extra_blocks = sha1_pad(buf, ctx->total_length);
+			uint32_t n_extra_blocks =
+					sha1_pad(buf, ctx->total_length);
 
 			ctx->status = (HASH_CTX_STS_PROCESSING |
 				       HASH_CTX_STS_COMPLETE);
 			ctx->job.buffer = buf;
 			ctx->job.len = (uint32_t) n_extra_blocks;
-			ctx = (struct sha1_hash_ctx *) sha1_job_mgr_submit(&mgr->mgr, &ctx->job);
+			ctx = (struct sha1_hash_ctx *)
+				sha1_job_mgr_submit(&mgr->mgr, &ctx->job);
 			continue;
 		}
 
@@ -208,14 +215,17 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_resubmit(struct sha1_ctx_mgr *mgr, str
 	return NULL;
 }
 
-static struct sha1_hash_ctx *sha1_ctx_mgr_get_comp_ctx(struct sha1_ctx_mgr *mgr)
+static struct sha1_hash_ctx
+			*sha1_ctx_mgr_get_comp_ctx(struct sha1_ctx_mgr *mgr)
 {
 	/*
 	 * If get_comp_job returns NULL, there are no jobs complete.
-	 * If get_comp_job returns a job, verify that it is safe to return to the user.
+	 * If get_comp_job returns a job, verify that it is safe to return to
+	 * the user.
 	 * If it is not ready, resubmit the job to finish processing.
 	 * If sha1_ctx_mgr_resubmit returned a job, it is ready to be returned.
-	 * Otherwise, all jobs currently being managed by the hash_ctx_mgr still need processing.
+	 * Otherwise, all jobs currently being managed by the hash_ctx_mgr
+	 * still need processing.
 	 */
 	struct sha1_hash_ctx *ctx;
 
@@ -235,7 +245,10 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(struct sha1_ctx_mgr *mgr,
 					  int flags)
 {
 	if (flags & (~HASH_ENTIRE)) {
-		/* User should not pass anything other than FIRST, UPDATE, or LAST */
+		/*
+		 * User should not pass anything other than FIRST, UPDATE, or
+		 * LAST
+		 */
 		ctx->error = HASH_CTX_ERROR_INVALID_FLAGS;
 		return ctx;
 	}
@@ -264,14 +277,20 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(struct sha1_ctx_mgr *mgr,
 		ctx->partial_block_buffer_length = 0;
 	}
 
-	/* If we made it here, there were no errors during this call to submit */
+	/*
+	 * If we made it here, there were no errors during this call to
+	 * submit
+	 */
 	ctx->error = HASH_CTX_ERROR_NONE;
 
 	/* Store buffer ptr info from user */
 	ctx->incoming_buffer = buffer;
 	ctx->incoming_buffer_length = len;
 
-	/* Store the user's request flags and mark this ctx as currently being processed. */
+	/*
+	 * Store the user's request flags and mark this ctx as currently
+	 * being processed.
+	 */
 	ctx->status = (flags & HASH_LAST) ?
 			(HASH_CTX_STS_PROCESSING | HASH_CTX_STS_LAST) :
 			HASH_CTX_STS_PROCESSING;
@@ -286,8 +305,12 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(struct sha1_ctx_mgr *mgr,
 	 * append as much as possible to the extra block.
 	 */
 	if ((ctx->partial_block_buffer_length) | (len < SHA1_BLOCK_SIZE)) {
-		/* Compute how many bytes to copy from user buffer into extra block */
-		uint32_t copy_len = SHA1_BLOCK_SIZE - ctx->partial_block_buffer_length;
+		/*
+		 * Compute how many bytes to copy from user buffer into
+		 * extra block
+		 */
+		uint32_t copy_len = SHA1_BLOCK_SIZE -
+					ctx->partial_block_buffer_length;
 		if (len < copy_len)
 			copy_len = len;
 
@@ -297,20 +320,28 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(struct sha1_ctx_mgr *mgr,
 				buffer, copy_len);
 
 			ctx->partial_block_buffer_length += copy_len;
-			ctx->incoming_buffer = (const void *)((const char *)buffer + copy_len);
+			ctx->incoming_buffer = (const void *)
+					((const char *)buffer + copy_len);
 			ctx->incoming_buffer_length = len - copy_len;
 		}
 
-		/* The extra block should never contain more than 1 block here */
+		/*
+		 * The extra block should never contain more than 1 block
+		 * here
+		 */
 		assert(ctx->partial_block_buffer_length <= SHA1_BLOCK_SIZE);
 
-		/* If the extra block buffer contains exactly 1 block, it can be hashed. */
+		/*
+		 * If the extra block buffer contains exactly 1 block, it can
+		 * be hashed.
+		 */
 		if (ctx->partial_block_buffer_length >= SHA1_BLOCK_SIZE) {
 			ctx->partial_block_buffer_length = 0;
 
 			ctx->job.buffer = ctx->partial_block_buffer;
 			ctx->job.len = 1;
-			ctx = (struct sha1_hash_ctx *) sha1_job_mgr_submit(&mgr->mgr, &ctx->job);
+			ctx = (struct sha1_hash_ctx *)
+				sha1_job_mgr_submit(&mgr->mgr, &ctx->job);
 		}
 	}
 
@@ -329,14 +360,15 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_flush(struct sha1_ctx_mgr *mgr)
 			return NULL;
 
 		/*
-		 * If flush returned a job, resubmit the job to finish processing.
+		 * If flush returned a job, resubmit the job to finish
+		 * processing.
 		 */
 		ctx = sha1_ctx_mgr_resubmit(mgr, ctx);
 
 		/*
-		 * If sha1_ctx_mgr_resubmit returned a job, it is ready to be returned.
-		 * Otherwise, all jobs currently being managed by the sha1_ctx_mgr
-		 * still need processing. Loop.
+		 * If sha1_ctx_mgr_resubmit returned a job, it is ready to be
+		 * returned. Otherwise, all jobs currently being managed by the
+		 * sha1_ctx_mgr still need processing. Loop.
 		 */
 		if (ctx)
 			return ctx;
@@ -394,9 +426,11 @@ static int sha_finish_walk(struct mcryptd_hash_request_ctx **ret_rctx,
 				flag |= HASH_LAST;
 
 		}
-		sha_ctx = (struct sha1_hash_ctx *) shash_desc_ctx(&rctx->desc);
+		sha_ctx = (struct sha1_hash_ctx *)
+						shash_desc_ctx(&rctx->desc);
 		kernel_fpu_begin();
-		sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data, nbytes, flag);
+		sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx,
+						rctx->walk.data, nbytes, flag);
 		if (!sha_ctx) {
 			if (flush)
 				sha_ctx = sha1_ctx_mgr_flush(cstate->mgr);
@@ -489,7 +523,7 @@ static int sha1_mb_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
 	struct mcryptd_hash_request_ctx *rctx =
-			container_of(desc, struct mcryptd_hash_request_ctx, desc);
+		container_of(desc, struct mcryptd_hash_request_ctx, desc);
 	struct mcryptd_alg_cstate *cstate =
 				this_cpu_ptr(sha1_mb_alg_state.alg_cstate);
 
@@ -521,7 +555,8 @@ static int sha1_mb_update(struct shash_desc *desc, const u8 *data,
 	sha_ctx = (struct sha1_hash_ctx *) shash_desc_ctx(desc);
 	sha1_mb_add_list(rctx, cstate);
 	kernel_fpu_begin();
-	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data, nbytes, HASH_UPDATE);
+	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data,
+							nbytes, HASH_UPDATE);
 	kernel_fpu_end();
 
 	/* check if anything is returned */
@@ -548,7 +583,7 @@ static int sha1_mb_finup(struct shash_desc *desc, const u8 *data,
 			     unsigned int len, u8 *out)
 {
 	struct mcryptd_hash_request_ctx *rctx =
-			container_of(desc, struct mcryptd_hash_request_ctx, desc);
+		container_of(desc, struct mcryptd_hash_request_ctx, desc);
 	struct mcryptd_alg_cstate *cstate =
 				this_cpu_ptr(sha1_mb_alg_state.alg_cstate);
 
@@ -584,7 +619,8 @@ static int sha1_mb_finup(struct shash_desc *desc, const u8 *data,
 	sha1_mb_add_list(rctx, cstate);
 
 	kernel_fpu_begin();
-	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data, nbytes, flag);
+	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data,
+								nbytes, flag);
 	kernel_fpu_end();
 
 	/* check if anything is returned */
@@ -608,7 +644,7 @@ done:
 static int sha1_mb_final(struct shash_desc *desc, u8 *out)
 {
 	struct mcryptd_hash_request_ctx *rctx =
-			container_of(desc, struct mcryptd_hash_request_ctx, desc);
+		container_of(desc, struct mcryptd_hash_request_ctx, desc);
 	struct mcryptd_alg_cstate *cstate =
 				this_cpu_ptr(sha1_mb_alg_state.alg_cstate);
 
@@ -632,7 +668,8 @@ static int sha1_mb_final(struct shash_desc *desc, u8 *out)
 	/* flag HASH_FINAL and 0 data size */
 	sha1_mb_add_list(rctx, cstate);
 	kernel_fpu_begin();
-	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, &data, 0, HASH_LAST);
+	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, &data, 0,
+								HASH_LAST);
 	kernel_fpu_end();
 
 	/* check if anything is returned */
@@ -866,7 +903,8 @@ static unsigned long sha1_mb_flusher(struct mcryptd_alg_cstate *cstate)
 		if (time_before(cur_time, rctx->tag.expire))
 			break;
 		kernel_fpu_begin();
-		sha_ctx = (struct sha1_hash_ctx *) sha1_ctx_mgr_flush(cstate->mgr);
+		sha_ctx = (struct sha1_hash_ctx *)
+					sha1_ctx_mgr_flush(cstate->mgr);
 		kernel_fpu_end();
 		if (!sha_ctx) {
 			pr_err("sha1_mb error: nothing got flushed for non-empty list\n");
-- 
1.9.1

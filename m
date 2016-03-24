From: megha.dey@linux.intel.com
Subject: [PATCH 1/7] crypto: sha1-mb - rename sha-mb to sha1-mb
Date: Thu, 24 Mar 2016 13:25:57 -0700
Message-ID: <1458851163-3448-2-git-send-email-megha.dey@linux.intel.com>
References: <1458851163-3448-1-git-send-email-megha.dey@linux.intel.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tim.c.chen@linux.intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458851163-3448-1-git-send-email-megha.dey@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

Until now, there was only support for the SHA1 multibuffer algorithm.
Hence, there was just one sha-mb folder. Now, with the introduction of
the SHA256 multi-buffer algorithm , it is logical to name the existing
folder as sha1-mb.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/{sha-mb => sha1-mb}/Makefile       |   0
 arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb.c      | 122 ++++++++++++++-------
 .../{sha-mb/sha_mb_ctx.h => sha1-mb/sha1_mb_ctx.h} |   2 +-
 .../{sha-mb/sha_mb_mgr.h => sha1-mb/sha1_mb_mgr.h} |   0
 .../{sha-mb => sha1-mb}/sha1_mb_mgr_datastruct.S   |   0
 .../{sha-mb => sha1-mb}/sha1_mb_mgr_flush_avx2.S   |   0
 .../{sha-mb => sha1-mb}/sha1_mb_mgr_init_avx2.c    |   3 +-
 .../{sha-mb => sha1-mb}/sha1_mb_mgr_submit_avx2.S  |   0
 arch/x86/crypto/{sha-mb => sha1-mb}/sha1_x8_avx2.S |   0
 9 files changed, 83 insertions(+), 44 deletions(-)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/Makefile (100%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb.c (89%)
 rename arch/x86/crypto/{sha-mb/sha_mb_ctx.h => sha1-mb/sha1_mb_ctx.h} (99%)
 rename arch/x86/crypto/{sha-mb/sha_mb_mgr.h => sha1-mb/sha1_mb_mgr.h} (100%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_datastruct.S (100%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_flush_avx2.S (100%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_init_avx2.c (99%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_submit_avx2.S (100%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_x8_avx2.S (100%)

diff --git a/arch/x86/crypto/sha-mb/Makefile b/arch/x86/crypto/sha1-mb/Makefile
similarity index 100%
rename from arch/x86/crypto/sha-mb/Makefile
rename to arch/x86/crypto/sha1-mb/Makefile
diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha1-mb/sha1_mb.c
similarity index 89%
rename from arch/x86/crypto/sha-mb/sha1_mb.c
rename to arch/x86/crypto/sha1-mb/sha1_mb.c
index a8a0224..e1c74c4 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha1-mb/sha1_mb.c
@@ -67,7 +67,7 @@
 #include <asm/byteorder.h>
 #include <linux/hardirq.h>
 #include <asm/fpu/api.h>
-#include "sha_mb_ctx.h"
+#include "sha1_mb_ctx.h"
 
 #define FLUSH_INTERVAL 1000 /* in usec */
 
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
 
 inline void sha1_init_digest(uint32_t *digest)
 {
@@ -131,7 +135,8 @@ inline uint32_t sha1_pad(uint8_t padblock[SHA1_BLOCK_SIZE * 2],
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
+				ctx = (struct sha1_hash_ctx *)
+				sha1_job_mgr_submit(&mgr->mgr, &ctx->job);
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
 
@@ -208,14 +215,16 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_resubmit(struct sha1_ctx_mgr *mgr, str
 	return NULL;
 }
 
-static struct sha1_hash_ctx *sha1_ctx_mgr_get_comp_ctx(struct sha1_ctx_mgr *mgr)
+static struct sha1_hash_ctx
+			*sha1_ctx_mgr_get_comp_ctx(struct sha1_ctx_mgr *mgr)
 {
 	/*
 	 * If get_comp_job returns NULL, there are no jobs complete.
-	 * If get_comp_job returns a job, verify that it is safe to return to the user.
-	 * If it is not ready, resubmit the job to finish processing.
+	 * If get_comp_job returns a job, verify that it is safe to return to
+	 * the user. If it is not ready, resubmit the job to finish processing.
 	 * If sha1_ctx_mgr_resubmit returned a job, it is ready to be returned.
-	 * Otherwise, all jobs currently being managed by the hash_ctx_mgr still need processing.
+	 * Otherwise, all jobs currently being managed by the hash_ctx_mgr
+	 * still need processing.
 	 */
 	struct sha1_hash_ctx *ctx;
 
@@ -235,7 +244,9 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(struct sha1_ctx_mgr *mgr,
 					  int flags)
 {
 	if (flags & (~HASH_ENTIRE)) {
-		/* User should not pass anything other than FIRST, UPDATE, or LAST */
+		/* User should not pass anything other than FIRST, UPDATE, or
+		 * LAST
+		 */
 		ctx->error = HASH_CTX_ERROR_INVALID_FLAGS;
 		return ctx;
 	}
@@ -264,14 +275,18 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(struct sha1_ctx_mgr *mgr,
 		ctx->partial_block_buffer_length = 0;
 	}
 
-	/* If we made it here, there were no errors during this call to submit */
+	/* If we made it here, there were no errors during this call to
+	 * submit
+	 */
 	ctx->error = HASH_CTX_ERROR_NONE;
 
 	/* Store buffer ptr info from user */
 	ctx->incoming_buffer = buffer;
 	ctx->incoming_buffer_length = len;
 
-	/* Store the user's request flags and mark this ctx as currently being processed. */
+	/* Store the user's request flags and mark this ctx as currently being
+	 * processed.
+	 */
 	ctx->status = (flags & HASH_LAST) ?
 			(HASH_CTX_STS_PROCESSING | HASH_CTX_STS_LAST) :
 			HASH_CTX_STS_PROCESSING;
@@ -286,31 +301,41 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(struct sha1_ctx_mgr *mgr,
 	 * append as much as possible to the extra block.
 	 */
 	if ((ctx->partial_block_buffer_length) | (len < SHA1_BLOCK_SIZE)) {
-		/* Compute how many bytes to copy from user buffer into extra block */
-		uint32_t copy_len = SHA1_BLOCK_SIZE - ctx->partial_block_buffer_length;
+		/* Compute how many bytes to copy from user buffer into
+		 * extra block
+		 */
+		uint32_t copy_len = SHA1_BLOCK_SIZE -
+					ctx->partial_block_buffer_length;
 		if (len < copy_len)
 			copy_len = len;
 
 		if (copy_len) {
 			/* Copy and update relevant pointers and counters */
-			memcpy(&ctx->partial_block_buffer[ctx->partial_block_buffer_length],
+			memcpy
+		(&ctx->partial_block_buffer[ctx->partial_block_buffer_length],
 				buffer, copy_len);
 
 			ctx->partial_block_buffer_length += copy_len;
-			ctx->incoming_buffer = (const void *)((const char *)buffer + copy_len);
+			ctx->incoming_buffer = (const void *)
+					((const char *)buffer + copy_len);
 			ctx->incoming_buffer_length = len - copy_len;
 		}
 
-		/* The extra block should never contain more than 1 block here */
+		/* The extra block should never contain more than 1 block
+		 * here
+		 */
 		assert(ctx->partial_block_buffer_length <= SHA1_BLOCK_SIZE);
 
-		/* If the extra block buffer contains exactly 1 block, it can be hashed. */
+		/* If the extra block buffer contains exactly 1 block, it
+		 * can be hashed.
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
 
@@ -329,14 +354,15 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_flush(struct sha1_ctx_mgr *mgr)
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
@@ -396,7 +422,8 @@ static int sha_finish_walk(struct mcryptd_hash_request_ctx **ret_rctx,
 		}
 		sha_ctx = (struct sha1_hash_ctx *) shash_desc_ctx(&rctx->desc);
 		kernel_fpu_begin();
-		sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data, nbytes, flag);
+		sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx,
+						rctx->walk.data, nbytes, flag);
 		if (!sha_ctx) {
 			if (flush)
 				sha_ctx = sha1_ctx_mgr_flush(cstate->mgr);
@@ -489,7 +516,8 @@ static int sha1_mb_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
 	struct mcryptd_hash_request_ctx *rctx =
-			container_of(desc, struct mcryptd_hash_request_ctx, desc);
+			container_of(desc, struct mcryptd_hash_request_ctx,
+									desc);
 	struct mcryptd_alg_cstate *cstate =
 				this_cpu_ptr(sha1_mb_alg_state.alg_cstate);
 
@@ -521,7 +549,8 @@ static int sha1_mb_update(struct shash_desc *desc, const u8 *data,
 	sha_ctx = (struct sha1_hash_ctx *) shash_desc_ctx(desc);
 	sha1_mb_add_list(rctx, cstate);
 	kernel_fpu_begin();
-	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data, nbytes, HASH_UPDATE);
+	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data,
+							nbytes, HASH_UPDATE);
 	kernel_fpu_end();
 
 	/* check if anything is returned */
@@ -548,7 +577,8 @@ static int sha1_mb_finup(struct shash_desc *desc, const u8 *data,
 			     unsigned int len, u8 *out)
 {
 	struct mcryptd_hash_request_ctx *rctx =
-			container_of(desc, struct mcryptd_hash_request_ctx, desc);
+			container_of(desc, struct mcryptd_hash_request_ctx,
+									desc);
 	struct mcryptd_alg_cstate *cstate =
 				this_cpu_ptr(sha1_mb_alg_state.alg_cstate);
 
@@ -584,7 +614,8 @@ static int sha1_mb_finup(struct shash_desc *desc, const u8 *data,
 	sha1_mb_add_list(rctx, cstate);
 
 	kernel_fpu_begin();
-	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data, nbytes, flag);
+	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data,
+								nbytes, flag);
 	kernel_fpu_end();
 
 	/* check if anything is returned */
@@ -608,7 +639,8 @@ done:
 static int sha1_mb_final(struct shash_desc *desc, u8 *out)
 {
 	struct mcryptd_hash_request_ctx *rctx =
-			container_of(desc, struct mcryptd_hash_request_ctx, desc);
+			container_of(desc, struct mcryptd_hash_request_ctx,
+									desc);
 	struct mcryptd_alg_cstate *cstate =
 				this_cpu_ptr(sha1_mb_alg_state.alg_cstate);
 
@@ -632,7 +664,8 @@ static int sha1_mb_final(struct shash_desc *desc, u8 *out)
 	/* flag HASH_FINAL and 0 data size */
 	sha1_mb_add_list(rctx, cstate);
 	kernel_fpu_begin();
-	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, &data, 0, HASH_LAST);
+	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, &data, 0,
+								HASH_LAST);
 	kernel_fpu_end();
 
 	/* check if anything is returned */
@@ -695,7 +728,8 @@ static struct shash_alg sha1_mb_shash_alg = {
 				   CRYPTO_ALG_INTERNAL,
 		.cra_blocksize	 = SHA1_BLOCK_SIZE,
 		.cra_module	 = THIS_MODULE,
-		.cra_list	 = LIST_HEAD_INIT(sha1_mb_shash_alg.base.cra_list),
+		.cra_list	 = LIST_HEAD_INIT
+					(sha1_mb_shash_alg.base.cra_list),
 	}
 };
 
@@ -837,11 +871,13 @@ static struct ahash_alg sha1_mb_async_alg = {
 			.cra_name               = "sha1",
 			.cra_driver_name        = "sha1_mb",
 			.cra_priority           = 200,
-			.cra_flags              = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_flags              = CRYPTO_ALG_TYPE_AHASH |
+							CRYPTO_ALG_ASYNC,
 			.cra_blocksize          = SHA1_BLOCK_SIZE,
 			.cra_type               = &crypto_ahash_type,
 			.cra_module             = THIS_MODULE,
-			.cra_list               = LIST_HEAD_INIT(sha1_mb_async_alg.halg.base.cra_list),
+			.cra_list               = LIST_HEAD_INIT
+					(sha1_mb_async_alg.halg.base.cra_list),
 			.cra_init               = sha1_mb_async_init_tfm,
 			.cra_exit               = sha1_mb_async_exit_tfm,
 			.cra_ctxsize		= sizeof(struct sha1_mb_ctx),
@@ -866,10 +902,12 @@ static unsigned long sha1_mb_flusher(struct mcryptd_alg_cstate *cstate)
 		if (time_before(cur_time, rctx->tag.expire))
 			break;
 		kernel_fpu_begin();
-		sha_ctx = (struct sha1_hash_ctx *) sha1_ctx_mgr_flush(cstate->mgr);
+		sha_ctx = (struct sha1_hash_ctx *)
+					sha1_ctx_mgr_flush(cstate->mgr);
 		kernel_fpu_end();
 		if (!sha_ctx) {
-			pr_err("sha1_mb error: nothing got flushed for non-empty list\n");
+			pr_err("sha1_mb error: nothing got flushed for"
+							" non-empty list\n");
 			break;
 		}
 		rctx = cast_hash_to_mcryptd_ctx(sha_ctx);
diff --git a/arch/x86/crypto/sha-mb/sha_mb_ctx.h b/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
similarity index 99%
rename from arch/x86/crypto/sha-mb/sha_mb_ctx.h
rename to arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
index e36069d..98a35bc 100644
--- a/arch/x86/crypto/sha-mb/sha_mb_ctx.h
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
@@ -54,7 +54,7 @@
 #ifndef _SHA_MB_CTX_INTERNAL_H
 #define _SHA_MB_CTX_INTERNAL_H
 
-#include "sha_mb_mgr.h"
+#include "sha1_mb_mgr.h"
 
 #define HASH_UPDATE          0x00
 #define HASH_FIRST           0x01
diff --git a/arch/x86/crypto/sha-mb/sha_mb_mgr.h b/arch/x86/crypto/sha1-mb/sha1_mb_mgr.h
similarity index 100%
rename from arch/x86/crypto/sha-mb/sha_mb_mgr.h
rename to arch/x86/crypto/sha1-mb/sha1_mb_mgr.h
diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_datastruct.S b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_datastruct.S
similarity index 100%
rename from arch/x86/crypto/sha-mb/sha1_mb_mgr_datastruct.S
rename to arch/x86/crypto/sha1-mb/sha1_mb_mgr_datastruct.S
diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
similarity index 100%
rename from arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S
rename to arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_init_avx2.c
similarity index 99%
rename from arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
rename to arch/x86/crypto/sha1-mb/sha1_mb_mgr_init_avx2.c
index 822acb5..ead8654 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_init_avx2.c
@@ -51,11 +51,12 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include "sha_mb_mgr.h"
+#include "sha1_mb_mgr.h"
 
 void sha1_mb_mgr_init_avx2(struct sha1_mb_mgr *state)
 {
 	unsigned int j;
+
 	state->unused_lanes = 0xF76543210ULL;
 	for (j = 0; j < 8; j++) {
 		state->lens[j] = 0xFFFFFFFF;
diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
similarity index 100%
rename from arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S
rename to arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
diff --git a/arch/x86/crypto/sha-mb/sha1_x8_avx2.S b/arch/x86/crypto/sha1-mb/sha1_x8_avx2.S
similarity index 100%
rename from arch/x86/crypto/sha-mb/sha1_x8_avx2.S
rename to arch/x86/crypto/sha1-mb/sha1_x8_avx2.S
-- 
1.9.1

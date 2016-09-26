From: Megha Dey <megha.dey@linux.intel.com>
Subject: [PATCH v5 5/7] crypto: AES CBC multi-buffer glue code
Date: Mon, 26 Sep 2016 10:27:37 -0700
Message-ID: <1474910859-11713-6-git-send-email-megha.dey@linux.intel.com>
References: <1474910859-11713-1-git-send-email-megha.dey@linux.intel.com>
Cc: linux-crypto@vger.kernel.org, tim.c.chen@linux.intel.com,
        megha.dey@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:22892 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161424AbcIZRUq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2016 13:20:46 -0400
In-Reply-To: <1474910859-11713-1-git-send-email-megha.dey@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tim Chen <tim.c.chen@linux.intel.com>

This patch introduces the multi-buffer job manager which is responsible
for submitting scatter-gather buffers from several AES CBC jobs
to the multi-buffer algorithm. The glue code interfaces with the
underlying algorithm that handles 8 data streams of AES CBC encryption
in parallel. AES key expansion and CBC decryption requests are performed
in a manner similar to the existing AESNI Intel glue driver.

The outline of the algorithm for AES CBC encryption requests is
sketched below:

Any driver requesting the crypto service will place an async crypto
request on the workqueue.  The multi-buffer crypto daemon will pull an
AES CBC encryption request from work queue and put each request in an
empty data lane for multi-buffer crypto computation.  When all the empty
lanes are filled, computation will commence on the jobs in parallel and
the job with the shortest remaining buffer will get completed and be
returned. To prevent prolonged stall, when no new jobs arrive, we will
flush workqueue of jobs after a maximum allowable delay has elapsed.

To accommodate the fragmented nature of scatter-gather, we will keep
submitting the next scatter-buffer fragment for a job for multi-buffer
computation until a job is completed and no more buffer fragments remain.
At that time we will pull a new job to fill the now empty data slot.
We check with the multibuffer scheduler to see if there are other
completed jobs to prevent extraneous delay in returning any completed
jobs.

This multi-buffer algorithm should be used for cases where we get at
least 8 streams of crypto jobs submitted at a reasonably high rate.
For low crypto job submission rate and low number of data streams, this
algorithm will not be beneficial. The reason is at low rate, we do not
fill out the data lanes before flushing the jobs instead of processing
them with all the data lanes full.  We will miss the benefit of parallel
computation, and adding delay to the processing of the crypto job at the
same time.  Some tuning of the maximum latency parameter may be needed
to get the best performance.

Originally-by: Chandramouli Narayanan <mouli_7982@yahoo.com>
Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/Makefile                |   1 +
 arch/x86/crypto/aes-cbc-mb/Makefile     |  22 +
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb.c | 839 ++++++++++++++++++++++++++++++++
 3 files changed, 862 insertions(+)
 create mode 100644 arch/x86/crypto/aes-cbc-mb/Makefile
 create mode 100644 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 34b3fa2..cc556a7 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_CRYPTO_CRC32_PCLMUL) += crc32-pclmul.o
 obj-$(CONFIG_CRYPTO_SHA256_SSSE3) += sha256-ssse3.o
 obj-$(CONFIG_CRYPTO_SHA512_SSSE3) += sha512-ssse3.o
 obj-$(CONFIG_CRYPTO_CRCT10DIF_PCLMUL) += crct10dif-pclmul.o
+obj-$(CONFIG_CRYPTO_AES_CBC_MB) += aes-cbc-mb/
 obj-$(CONFIG_CRYPTO_POLY1305_X86_64) += poly1305-x86_64.o
 
 # These modules require assembler to support AVX.
diff --git a/arch/x86/crypto/aes-cbc-mb/Makefile b/arch/x86/crypto/aes-cbc-mb/Makefile
new file mode 100644
index 0000000..b642bd8
--- /dev/null
+++ b/arch/x86/crypto/aes-cbc-mb/Makefile
@@ -0,0 +1,22 @@
+#
+# Arch-specific CryptoAPI modules.
+#
+
+avx_supported := $(call as-instr,vpxor %xmm0$(comma)%xmm0$(comma)%xmm0,yes,no)
+
+# we need decryption and key expansion routine symbols
+# if either AESNI_NI_INTEL or AES_CBC_MB is a module
+
+ifeq ($(CONFIG_CRYPTO_AES_NI_INTEL),m)
+	dec_support := ../aesni-intel_asm.o
+endif
+ifeq ($(CONFIG_CRYPTO_AES_CBC_MB),m)
+	dec_support := ../aesni-intel_asm.o
+endif
+
+ifeq ($(avx_supported),yes)
+	obj-$(CONFIG_CRYPTO_AES_CBC_MB) += aes-cbc-mb.o
+	aes-cbc-mb-y := $(dec_support) aes_cbc_mb.o aes_mb_mgr_init.o \
+			mb_mgr_inorder_x8_asm.o mb_mgr_ooo_x8_asm.o \
+			aes_cbc_enc_x8.o
+endif
diff --git a/arch/x86/crypto/aes-cbc-mb/aes_cbc_mb.c b/arch/x86/crypto/aes-cbc-mb/aes_cbc_mb.c
new file mode 100644
index 0000000..190a4fc
--- /dev/null
+++ b/arch/x86/crypto/aes-cbc-mb/aes_cbc_mb.c
@@ -0,0 +1,839 @@
+/*
+ *	Multi buffer AES CBC algorithm glue code
+ *
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * James Guilford <james.guilford@intel.com>
+ * Sean Gulley <sean.m.gulley@intel.com>
+ * Tim Chen <tim.c.chen@linux.intel.com>
+ * Megha Dey <megha.dey@linux.intel.com>
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/hardirq.h>
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/internal/hash.h>
+#include <crypto/mcryptd.h>
+#include <crypto/crypto_wq.h>
+#include <crypto/ctr.h>
+#include <crypto/b128ops.h>
+#include <crypto/lrw.h>
+#include <crypto/xts.h>
+#include <asm/cpu_device_id.h>
+#include <asm/fpu/api.h>
+#include <asm/crypto/aes.h>
+#include <crypto/ablk_helper.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/aead.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#ifdef CONFIG_X86_64
+#include <asm/crypto/glue_helper.h>
+#endif
+#include <asm/simd.h>
+
+#include "aes_cbc_mb_ctx.h"
+
+#define AESNI_ALIGN	(16)
+#define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE-1))
+#define FLUSH_INTERVAL 500 /* in usec */
+
+static struct mcryptd_alg_state cbc_mb_alg_state;
+
+struct aes_cbc_mb_ctx {
+	struct mcryptd_ablkcipher *mcryptd_tfm;
+};
+
+static inline struct aes_cbc_mb_mgr_inorder_x8
+	*get_key_mgr(void *mgr, u32 key_len)
+{
+	struct aes_cbc_mb_mgr_inorder_x8 *key_mgr;
+
+	key_mgr = (struct aes_cbc_mb_mgr_inorder_x8 *) mgr;
+	/* valid keysize is guranteed to be one of 128/192/256 */
+	switch (key_len) {
+	case AES_KEYSIZE_256:
+		return key_mgr+2;
+	case AES_KEYSIZE_192:
+		return key_mgr+1;
+	case AES_KEYSIZE_128:
+	default:
+		return key_mgr;
+	}
+}
+
+/* support code from arch/x86/crypto/aesni-intel_glue.c */
+static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
+{
+	unsigned long addr = (unsigned long)raw_ctx;
+	unsigned long align = AESNI_ALIGN;
+	struct crypto_aes_ctx *ret_ctx;
+
+	if (align <= crypto_tfm_ctx_alignment())
+		align = 1;
+	ret_ctx = (struct crypto_aes_ctx *)ALIGN(addr, align);
+	return ret_ctx;
+}
+
+static struct job_aes_cbc *aes_cbc_job_mgr_submit(
+	struct aes_cbc_mb_mgr_inorder_x8 *key_mgr, u32 key_len)
+{
+	/* valid keysize is guranteed to be one of 128/192/256 */
+	switch (key_len) {
+	case AES_KEYSIZE_256:
+		return aes_cbc_submit_job_inorder_256x8(key_mgr);
+	case AES_KEYSIZE_192:
+		return aes_cbc_submit_job_inorder_192x8(key_mgr);
+	case AES_KEYSIZE_128:
+	default:
+		return aes_cbc_submit_job_inorder_128x8(key_mgr);
+	}
+}
+
+static inline struct ablkcipher_request *cast_mcryptd_ctx_to_req(
+	struct mcryptd_ablkcipher_request_ctx *ctx)
+{
+	return container_of((void *) ctx, struct ablkcipher_request, __ctx);
+}
+
+/*
+ * Interface functions to the synchronous algorithm with acces
+ * to the underlying multibuffer AES CBC implementation
+ */
+
+/* Map the error in request context appropriately */
+
+static struct mcryptd_ablkcipher_request_ctx *process_job_sts(
+		struct job_aes_cbc *job)
+{
+	struct mcryptd_ablkcipher_request_ctx *ret_rctx;
+
+	ret_rctx = (struct mcryptd_ablkcipher_request_ctx *)job->user_data;
+
+	switch (job->status) {
+	default:
+	case STS_COMPLETED:
+		ret_rctx->error = CBC_CTX_ERROR_NONE;
+		break;
+	case STS_BEING_PROCESSED:
+		ret_rctx->error = -EINPROGRESS;
+		break;
+	case STS_INTERNAL_ERROR:
+	case STS_ERROR:
+	case STS_UNKNOWN:
+		/* mark it done with error */
+		ret_rctx->flag = CBC_DONE;
+		ret_rctx->error = -EIO;
+		break;
+	}
+	return ret_rctx;
+}
+
+static struct mcryptd_ablkcipher_request_ctx
+	*aes_cbc_ctx_mgr_flush(struct aes_cbc_mb_mgr_inorder_x8 *key_mgr)
+{
+	struct job_aes_cbc *job;
+
+	job = aes_cbc_flush_job_inorder_x8(key_mgr);
+	if (job)
+		return process_job_sts(job);
+	return NULL;
+}
+
+static struct mcryptd_ablkcipher_request_ctx *aes_cbc_ctx_mgr_submit(
+	struct aes_cbc_mb_mgr_inorder_x8 *key_mgr,
+	struct mcryptd_ablkcipher_request_ctx *rctx
+	)
+{
+	struct crypto_aes_ctx *mb_key_ctx;
+	struct job_aes_cbc *job;
+	unsigned long src_paddr;
+	unsigned long dst_paddr;
+
+	mb_key_ctx = aes_ctx(crypto_tfm_ctx(rctx->desc.base.tfm));
+
+	/* get job, fill the details and submit */
+	job = aes_cbc_get_next_job_inorder_x8(key_mgr);
+
+	src_paddr = (page_to_phys(rctx->walk.src.page) + rctx->walk.src.offset);
+	dst_paddr = (page_to_phys(rctx->walk.dst.page) + rctx->walk.dst.offset);
+	job->plaintext = phys_to_virt(src_paddr);
+	job->ciphertext = phys_to_virt(dst_paddr);
+	if (rctx->flag & CBC_START) {
+		/* fresh sequence, copy iv from walk buffer initially */
+		memcpy(&job->iv, rctx->walk.iv, AES_BLOCK_SIZE);
+		rctx->flag &= ~CBC_START;
+	} else {
+		/* For a multi-part sequence, set up the updated IV */
+		job->iv = rctx->seq_iv;
+	}
+
+	job->keys = (u128 *)mb_key_ctx->key_enc;
+	/* set up updated length from the walk buffers */
+	job->len = rctx->walk.nbytes & AES_BLOCK_MASK;
+	/* stow away the req_ctx so we can later check */
+	job->user_data = (void *)rctx;
+	job->key_len = mb_key_ctx->key_length;
+	rctx->job = job;
+	rctx->error = CBC_CTX_ERROR_NONE;
+	job = aes_cbc_job_mgr_submit(key_mgr, mb_key_ctx->key_length);
+	if (job) {
+		/* we already have the request context stashed in job */
+		return process_job_sts(job);
+	}
+	return NULL;
+}
+
+static int cbc_encrypt_finish(struct mcryptd_ablkcipher_request_ctx **ret_rctx,
+			      struct mcryptd_alg_cstate *cstate,
+			      bool flush)
+{
+	struct mcryptd_ablkcipher_request_ctx *rctx = *ret_rctx;
+	struct job_aes_cbc *job;
+	int err = 0;
+	unsigned int nbytes;
+	struct crypto_aes_ctx *mb_key_ctx;
+	struct aes_cbc_mb_mgr_inorder_x8 *key_mgr;
+	struct ablkcipher_request *req;
+
+
+	mb_key_ctx = aes_ctx(crypto_tfm_ctx(rctx->desc.base.tfm));
+	key_mgr = get_key_mgr(cstate->mgr, mb_key_ctx->key_length);
+
+	/*
+	 * Some low-level mb job is done. Keep going till done.
+	 * This loop may process multiple multi part requests
+	 */
+	while (!(rctx->flag & CBC_DONE)) {
+		/* update bytes and check for more work */
+		nbytes = rctx->walk.nbytes & (AES_BLOCK_SIZE - 1);
+		req = cast_mcryptd_ctx_to_req(rctx);
+		err = ablkcipher_walk_done(req, &rctx->walk, nbytes);
+		if (err) {
+			/* done with error */
+			rctx->flag = CBC_DONE;
+			rctx->error = err;
+			goto out;
+		}
+		nbytes = rctx->walk.nbytes;
+		if (!nbytes) {
+			/* done with successful encryption */
+			rctx->flag = CBC_DONE;
+			goto out;
+		}
+		/*
+		 * This is a multi-part job and there is more work to do.
+		 * From the completed job, copy the running sequence of IV
+		 * and start the next one in sequence.
+		 */
+		job = (struct job_aes_cbc *)rctx->job;
+		rctx->seq_iv = job->iv;	/* copy the running sequence of iv */
+		kernel_fpu_begin();
+		rctx = aes_cbc_ctx_mgr_submit(key_mgr, rctx);
+		if (!rctx) {
+			/* multi part job submitted, no completed job. */
+			if (flush)
+				rctx = aes_cbc_ctx_mgr_flush(key_mgr);
+		}
+		kernel_fpu_end();
+		if (!rctx) {
+			/* no completions yet to process further */
+			break;
+		}
+		/* some job finished when we submitted multi part job. */
+		if (rctx->error) {
+			/*
+			 * some request completed with error
+			 * bail out of chain processing
+			 */
+			err = rctx->error;
+			break;
+		}
+		/* we have a valid request context to process further */
+	}
+	/* encrypted text is expected to be in out buffer already */
+out:
+	/* We came out multi-part processing for some request */
+	*ret_rctx = rctx;
+	return err;
+}
+
+/* notify the caller of progress ; request still stays in queue */
+
+static void notify_callback(struct mcryptd_ablkcipher_request_ctx *rctx,
+			    struct mcryptd_alg_cstate *cstate,
+			    int err)
+{
+	struct ablkcipher_request *req = cast_mcryptd_ctx_to_req(rctx);
+
+	if (irqs_disabled())
+		rctx->complete(&req->base, err);
+	else {
+		local_bh_disable();
+		rctx->complete(&req->base, err);
+		local_bh_enable();
+	}
+}
+
+/* A request that completed is dequeued and the caller is notified */
+
+static void completion_callback(struct mcryptd_ablkcipher_request_ctx *rctx,
+			    struct mcryptd_alg_cstate *cstate,
+			    int err)
+{
+	struct ablkcipher_request *req = cast_mcryptd_ctx_to_req(rctx);
+
+       /* remove from work list and invoke completion callback */
+	spin_lock(&cstate->work_lock);
+	list_del(&rctx->waiter);
+	spin_unlock(&cstate->work_lock);
+
+	if (irqs_disabled())
+		rctx->complete(&req->base, err);
+	else {
+		local_bh_disable();
+		rctx->complete(&req->base, err);
+		local_bh_enable();
+	}
+}
+
+/* complete a blkcipher request and process any further completions */
+
+static void cbc_complete_job(struct mcryptd_ablkcipher_request_ctx *rctx,
+			    struct mcryptd_alg_cstate *cstate,
+			    int err)
+{
+	struct job_aes_cbc *job;
+	int ret;
+	struct mcryptd_ablkcipher_request_ctx *sctx;
+	struct crypto_aes_ctx *mb_key_ctx;
+	struct aes_cbc_mb_mgr_inorder_x8 *key_mgr;
+	struct ablkcipher_request *req;
+
+	req = cast_mcryptd_ctx_to_req(rctx);
+	ablkcipher_walk_complete(&rctx->walk);
+	completion_callback(rctx, cstate, err);
+
+	mb_key_ctx = aes_ctx(crypto_tfm_ctx(rctx->desc.base.tfm));
+	key_mgr = get_key_mgr(cstate->mgr, mb_key_ctx->key_length);
+
+	/* check for more completed jobs and process */
+	while ((job = aes_cbc_get_completed_job_inorder_x8(key_mgr)) != NULL) {
+		sctx = process_job_sts(job);
+		if (WARN_ON(sctx == NULL))
+			return;
+		ret = sctx->error;
+		if (!ret) {
+			/* further process it */
+			ret = cbc_encrypt_finish(&sctx, cstate, false);
+		}
+		if (sctx) {
+			req = cast_mcryptd_ctx_to_req(sctx);
+			ablkcipher_walk_complete(&sctx->walk);
+			completion_callback(sctx, cstate, ret);
+		}
+	}
+}
+
+/* Add request to the waiter list. It stays in queue until completion */
+
+static void cbc_mb_add_list(struct mcryptd_ablkcipher_request_ctx *rctx,
+				struct mcryptd_alg_cstate *cstate)
+{
+	unsigned long next_flush;
+	unsigned long delay = usecs_to_jiffies(FLUSH_INTERVAL);
+
+	/* initialize tag */
+	rctx->tag.arrival = jiffies;    /* tag the arrival time */
+	rctx->tag.seq_num = cstate->next_seq_num++;
+	next_flush = rctx->tag.arrival + delay;
+	rctx->tag.expire = next_flush;
+
+	spin_lock(&cstate->work_lock);
+	list_add_tail(&rctx->waiter, &cstate->work_list);
+	spin_unlock(&cstate->work_lock);
+
+	mcryptd_arm_flusher(cstate, delay);
+}
+
+static int mb_aes_cbc_encrypt(struct ablkcipher_request *desc)
+{
+	struct mcryptd_ablkcipher_request_ctx *rctx =
+		container_of(desc, struct mcryptd_ablkcipher_request_ctx, desc);
+	struct mcryptd_ablkcipher_request_ctx *ret_rctx;
+	struct mcryptd_alg_cstate *cstate =
+				this_cpu_ptr(cbc_mb_alg_state.alg_cstate);
+	int err;
+	int ret = 0;
+	struct crypto_aes_ctx *mb_key_ctx;
+	struct aes_cbc_mb_mgr_inorder_x8 *key_mgr;
+	struct ablkcipher_request *req;
+
+	mb_key_ctx = aes_ctx(crypto_tfm_ctx(rctx->desc.base.tfm));
+	key_mgr = get_key_mgr(cstate->mgr, mb_key_ctx->key_length);
+
+	/* sanity check */
+	if (rctx->tag.cpu != smp_processor_id()) {
+		/* job not on list yet */
+		pr_err("mcryptd error: cpu clash\n");
+		notify_callback(rctx, cstate, -EINVAL);
+		return 0;
+	}
+
+	/* a new job, initialize the cbc context and add to worklist */
+	cbc_ctx_init(rctx, desc->nbytes, CBC_ENCRYPT);
+	cbc_mb_add_list(rctx, cstate);
+
+	req = cast_mcryptd_ctx_to_req(rctx);
+	ablkcipher_walk_init(&rctx->walk, desc->dst, desc->src, desc->nbytes);
+	err = ablkcipher_walk_phys(req, &rctx->walk);
+	if (err || !rctx->walk.nbytes) {
+		/* terminate this request */
+		ablkcipher_walk_complete(&rctx->walk);
+		completion_callback(rctx, cstate, (!err) ? -EINVAL : err);
+		return 0;
+	}
+	/* submit job */
+	kernel_fpu_begin();
+	ret_rctx = aes_cbc_ctx_mgr_submit(key_mgr, rctx);
+	kernel_fpu_end();
+
+	if (!ret_rctx) {
+		/* we submitted a job, but none completed */
+		/* just notify the caller */
+		notify_callback(rctx, cstate, -EINPROGRESS);
+		return 0;
+	}
+	/* some job completed */
+	if (ret_rctx->error) {
+		/* some job finished with error */
+		cbc_complete_job(ret_rctx, cstate, ret_rctx->error);
+		return 0;
+	}
+	/* some job finished without error, process it */
+	ret = cbc_encrypt_finish(&ret_rctx, cstate, false);
+	if (!ret_rctx) {
+		/* No completed job yet, notify caller */
+		notify_callback(rctx, cstate, -EINPROGRESS);
+		return 0;
+	}
+
+	/* complete the job */
+	cbc_complete_job(ret_rctx, cstate, ret);
+	return 0;
+}
+
+static int mb_aes_cbc_decrypt(struct ablkcipher_request *desc)
+{
+	struct crypto_aes_ctx *aesni_ctx;
+	struct mcryptd_ablkcipher_request_ctx *rctx =
+		container_of(desc, struct mcryptd_ablkcipher_request_ctx, desc);
+	struct ablkcipher_request *req;
+	bool is_mcryptd_req;
+	unsigned long src_paddr;
+	unsigned long dst_paddr;
+	int err;
+
+	/* note here whether it is mcryptd req */
+	is_mcryptd_req = desc->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	req = cast_mcryptd_ctx_to_req(rctx);
+	aesni_ctx = aes_ctx(crypto_tfm_ctx(desc->base.tfm));
+
+	ablkcipher_walk_init(&rctx->walk, desc->dst, desc->src, desc->nbytes);
+	err = ablkcipher_walk_phys(req, &rctx->walk);
+	if (err || !rctx->walk.nbytes)
+		goto done1;
+	desc->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	kernel_fpu_begin();
+	while ((desc->nbytes = rctx->walk.nbytes)) {
+		src_paddr = (page_to_phys(rctx->walk.src.page) +
+						rctx->walk.src.offset);
+		dst_paddr = (page_to_phys(rctx->walk.dst.page) +
+						rctx->walk.dst.offset);
+		aesni_cbc_dec(aesni_ctx, phys_to_virt(dst_paddr),
+					phys_to_virt(src_paddr),
+					rctx->walk.nbytes & AES_BLOCK_MASK,
+					rctx->walk.iv);
+		desc->nbytes &= AES_BLOCK_SIZE - 1;
+		err = ablkcipher_walk_done(req, &rctx->walk, desc->nbytes);
+		if (err)
+			goto done2;
+	}
+done2:
+	kernel_fpu_end();
+done1:
+	ablkcipher_walk_complete(&rctx->walk);
+	if (!is_mcryptd_req) {
+		/* synchronous request */
+		return err;
+	}
+	/* from mcryptd, we need to callback */
+	if (irqs_disabled())
+		rctx->complete(&req->base, err);
+	else {
+		local_bh_disable();
+		rctx->complete(&req->base, err);
+		local_bh_enable();
+	}
+	return 0;
+}
+
+/* use the same common code in aesni to expand key */
+
+static int aes_set_key_common(struct crypto_ablkcipher *tfm, void *raw_ctx,
+			      const u8 *in_key, unsigned int key_len)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx(raw_ctx);
+	u32 *flags = &tfm->base.crt_flags;
+	int err;
+
+	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_192 &&
+	    key_len != AES_KEYSIZE_256) {
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	if (!irq_fpu_usable())
+		err = crypto_aes_expand_key(ctx, in_key, key_len);
+	else {
+		kernel_fpu_begin();
+		err = aesni_set_key(ctx, in_key, key_len);
+		kernel_fpu_end();
+	}
+
+	return err;
+}
+
+static int aes_set_key(struct crypto_ablkcipher *tfm, const u8 *in_key,
+		       unsigned int key_len)
+{
+	return aes_set_key_common(tfm, crypto_ablkcipher_ctx(tfm), in_key,
+								key_len);
+}
+
+/* Interface functions to the asynchronous algorithm */
+
+static int cbc_mb_async_ablk_decrypt(struct ablkcipher_request *req)
+{
+	struct ablkcipher_request *mcryptd_req = ablkcipher_request_ctx(req);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct aes_cbc_mb_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct mcryptd_ablkcipher *mcryptd_tfm = ctx->mcryptd_tfm;
+	struct mcryptd_ablkcipher_request_ctx *rctx;
+	struct crypto_ablkcipher *child_tfm;
+	int err;
+
+	memcpy(mcryptd_req, req, sizeof(*req));
+	ablkcipher_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
+
+	if (!may_use_simd())
+		/* request sent via mcryptd, completes asynchronously */
+		return crypto_ablkcipher_decrypt(mcryptd_req);
+
+	/*
+	 * Package decryption descriptor in mcryptd req structure
+	 * and let the child tfm execute the decryption
+	 * without incurring the cost of mcryptd layers.
+	 * Request completes synchronously.
+	 * Multi-buffer technique unnecessary as decrypt is
+	 * done in parallel.
+	 */
+
+	rctx = ablkcipher_request_ctx(mcryptd_req);
+	child_tfm = mcryptd_ablkcipher_child(ctx->mcryptd_tfm);
+	rctx->desc.base.tfm = crypto_ablkcipher_tfm(child_tfm);
+	rctx->desc.info = req->info;
+	rctx->desc.base.flags = 0;
+	rctx->desc.src = req->src;
+	rctx->desc.dst = req->dst;
+	rctx->desc.nbytes = req->nbytes;
+
+	err = crypto_ablkcipher_crt(child_tfm)->decrypt(&rctx->desc);
+	return err;
+}
+
+static int cbc_mb_async_ablk_encrypt(struct ablkcipher_request *req)
+{
+	struct ablkcipher_request *mcryptd_req = ablkcipher_request_ctx(req);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct aes_cbc_mb_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct mcryptd_ablkcipher *mcryptd_tfm = ctx->mcryptd_tfm;
+
+	/* get the async driver ctx and tfm to package the request */
+	memcpy(mcryptd_req, req, sizeof(*req));
+	ablkcipher_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
+
+	return crypto_ablkcipher_encrypt(mcryptd_req);
+
+}
+
+/*
+ * CRYPTO_ALG_ASYNC flag is passed to indicate we have an ablk
+ * scatter-gather walk.
+ */
+
+static struct crypto_alg aes_cbc_mb_alg = {
+	.cra_name		= "__cbc-aes-aesni-mb",
+	.cra_driver_name	= "__driver-cbc-aes-aesni-mb",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC
+					| CRYPTO_ALG_INTERNAL,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
+				  AESNI_ALIGN - 1,
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(aes_cbc_mb_alg.cra_list),
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= aes_set_key,
+			.encrypt	= mb_aes_cbc_encrypt,
+			.decrypt	= mb_aes_cbc_decrypt
+		},
+	},
+};
+
+static int ablk_cbc_async_init_tfm(struct crypto_tfm *tfm)
+{
+	struct mcryptd_ablkcipher *mcryptd_tfm;
+	struct aes_cbc_mb_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct mcryptd_ablkcipher_ctx *mctx;
+
+	mcryptd_tfm = mcryptd_alloc_ablkcipher(
+				"__driver-cbc-aes-aesni-mb",
+				CRYPTO_ALG_INTERNAL, CRYPTO_ALG_INTERNAL);
+	if (IS_ERR(mcryptd_tfm))
+		return PTR_ERR(mcryptd_tfm);
+	mctx = crypto_ablkcipher_ctx(&mcryptd_tfm->base);
+	mctx->alg_state = &cbc_mb_alg_state;
+	ctx->mcryptd_tfm = mcryptd_tfm;
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
+		crypto_ablkcipher_reqsize(&mcryptd_tfm->base);
+
+	return 0;
+
+}
+
+static void ablk_cbc_async_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct aes_cbc_mb_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	mcryptd_free_ablkcipher(ctx->mcryptd_tfm);
+}
+
+/* Asynchronous interface to CBC multibuffer implementation */
+
+static struct crypto_alg aes_cbc_mb_async_alg = {
+	.cra_name		= "cbc(aes)",
+	.cra_driver_name	= "cbc-aes-aesni-mb",
+	.cra_priority		= 450,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct aes_cbc_mb_ctx) +
+				  AESNI_ALIGN - 1,
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_cbc_async_init_tfm,
+	.cra_exit		= ablk_cbc_async_exit_tfm,
+	.cra_list		= LIST_HEAD_INIT(aes_cbc_mb_async_alg.cra_list),
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= cbc_mb_async_ablk_encrypt,
+			.decrypt	= cbc_mb_async_ablk_decrypt,
+		},
+	},
+};
+
+/*
+ * When there are no new jobs arriving, the multibuffer queue may stall.
+ * To prevent prolonged stall, the flusher can be invoked to alleviate
+ * the following conditions:
+ * a) There are partially completed multi-part crypto jobs after a
+ * maximum allowable delay
+ * b) We have exhausted crypto jobs in queue, and the cpu
+ * does not have other tasks and cpu will become idle otherwise.
+ */
+unsigned long cbc_mb_flusher(struct mcryptd_alg_cstate *cstate)
+{
+	struct mcryptd_ablkcipher_request_ctx *rctx;
+	unsigned long cur_time;
+	unsigned long next_flush = 0;
+
+	struct crypto_aes_ctx *mb_key_ctx;
+	struct aes_cbc_mb_mgr_inorder_x8 *key_mgr;
+
+
+	cur_time = jiffies;
+
+	while (!list_empty(&cstate->work_list)) {
+		rctx = list_entry(cstate->work_list.next,
+				struct mcryptd_ablkcipher_request_ctx, waiter);
+		if time_before(cur_time, rctx->tag.expire)
+			break;
+
+		mb_key_ctx = aes_ctx(crypto_tfm_ctx(rctx->desc.base.tfm));
+		key_mgr = get_key_mgr(cstate->mgr, mb_key_ctx->key_length);
+
+		kernel_fpu_begin();
+		rctx = aes_cbc_ctx_mgr_flush(key_mgr);
+		kernel_fpu_end();
+		if (!rctx) {
+			pr_err("cbc_mb_flusher: nothing got flushed\n");
+			break;
+		}
+		cbc_encrypt_finish(&rctx, cstate, true);
+		if (rctx)
+			cbc_complete_job(rctx, cstate, rctx->error);
+	}
+
+	if (!list_empty(&cstate->work_list)) {
+		rctx = list_entry(cstate->work_list.next,
+				struct mcryptd_ablkcipher_request_ctx, waiter);
+		/* get the blkcipher context and then flush time */
+		next_flush = rctx->tag.expire;
+		mcryptd_arm_flusher(cstate, get_delay(next_flush));
+	}
+	return next_flush;
+}
+
+static int __init aes_cbc_mb_mod_init(void)
+{
+
+	int cpu, i;
+	int err;
+	struct mcryptd_alg_cstate *cpu_state;
+	struct aes_cbc_mb_mgr_inorder_x8 *key_mgr;
+
+	/* check for dependent cpu features */
+	if (!boot_cpu_has(X86_FEATURE_AES)) {
+		pr_err("aes_cbc_mb_mod_init: no aes support\n");
+		err = -ENODEV;
+		goto err1;
+	}
+
+	if (!boot_cpu_has(X86_FEATURE_XMM)) {
+		pr_err("aes_cbc_mb_mod_init: no xmm support\n");
+		err = -ENODEV;
+		goto err1;
+	}
+
+	/* initialize multibuffer structures */
+
+	cbc_mb_alg_state.alg_cstate = alloc_percpu(struct mcryptd_alg_cstate);
+	if (!cbc_mb_alg_state.alg_cstate) {
+		pr_err("aes_cbc_mb_mod_init: insufficient memory\n");
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	for_each_possible_cpu(cpu) {
+		cpu_state = per_cpu_ptr(cbc_mb_alg_state.alg_cstate, cpu);
+		cpu_state->next_flush = 0;
+		cpu_state->next_seq_num = 0;
+		cpu_state->flusher_engaged = false;
+		INIT_DELAYED_WORK(&cpu_state->flush, mcryptd_flusher);
+		cpu_state->cpu = cpu;
+		cpu_state->alg_state = &cbc_mb_alg_state;
+		cpu_state->mgr =
+			(struct aes_cbc_mb_mgr_inorder_x8 *)
+			kzalloc(3 * sizeof(struct aes_cbc_mb_mgr_inorder_x8),
+				GFP_KERNEL);
+		if (!cpu_state->mgr) {
+			err = -ENOMEM;
+			goto err2;
+		}
+		key_mgr = (struct aes_cbc_mb_mgr_inorder_x8 *) cpu_state->mgr;
+		/* initialize manager state for 128, 192 and 256 bit keys */
+		for (i = 0; i < 3; ++i) {
+			aes_cbc_init_mb_mgr_inorder_x8(key_mgr);
+			++key_mgr;
+		}
+		INIT_LIST_HEAD(&cpu_state->work_list);
+		spin_lock_init(&cpu_state->work_lock);
+	}
+	cbc_mb_alg_state.flusher = &cbc_mb_flusher;
+
+	/* register the synchronous mb algo */
+	err = crypto_register_alg(&aes_cbc_mb_alg);
+	if (err)
+		goto err3;
+
+	/* register the asynchronous mb algo */
+	err = crypto_register_alg(&aes_cbc_mb_async_alg);
+	if (err) {
+		/* unregister synchronous mb algo */
+		crypto_unregister_alg(&aes_cbc_mb_alg);
+		goto err3;
+	}
+
+	pr_info("x86 CBC multibuffer crypto module initialized successfully\n");
+	return 0; /* module init success */
+
+	/* error in algo registration */
+err3:
+	for_each_possible_cpu(cpu) {
+		cpu_state = per_cpu_ptr(cbc_mb_alg_state.alg_cstate, cpu);
+		kfree(cpu_state->mgr);
+	}
+err2:
+	free_percpu(cbc_mb_alg_state.alg_cstate);
+err1:
+	return err;
+}
+
+static void __exit aes_cbc_mb_mod_fini(void)
+{
+	int cpu;
+	struct mcryptd_alg_cstate *cpu_state;
+
+	crypto_unregister_alg(&aes_cbc_mb_alg);
+	crypto_unregister_alg(&aes_cbc_mb_async_alg);
+
+	for_each_possible_cpu(cpu) {
+		cpu_state = per_cpu_ptr(cbc_mb_alg_state.alg_cstate, cpu);
+		kfree(cpu_state->mgr);
+	}
+	free_percpu(cbc_mb_alg_state.alg_cstate);
+}
+
+module_init(aes_cbc_mb_mod_init);
+module_exit(aes_cbc_mb_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("AES CBC Algorithm, multi buffer accelerated");
+MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com");
+
+MODULE_ALIAS("aes-cbc-mb");
+MODULE_ALIAS_CRYPTO("cbc-aes-aesni-mb");
-- 
1.9.1

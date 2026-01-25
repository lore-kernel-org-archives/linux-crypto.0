Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663EA2222C5;
	Sun, 25 Jan 2026 03:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312173; cv=none; b=UgVdWlZjFl2Y70mC93q35jvjrrHMbGQ5w7te2kborPzBqSdlEZdBU46a0lfgcdGvyzY8st8freyv0kpsiWz304CyFZ+tTivxzYgWjEP9DMoX+KQ/8H6iG3/gBB/IyvLzMU57HH7JL/Di71UHdNSZDqdWaCb4M2oUsvmFrsE5ZCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312173; c=relaxed/simple;
	bh=bR1iNfDYKkltgdSabWACZpB2PlvjS1g3cOJAx17tkvY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hcmEbEYd+958IapExiLf4+aeg4pIbix6JbAr3KtqpY4j+l/LrANrm6I/waqbdnYSx0AKZkaEcVudOOFATSLm1PdLFBZtvxGEeG4ZCAvYpxL2zMPV9v/UH8u5TrU2lM2pSuI09bcy6N+9ZSTAcY2U3rPuMbNeY/NFV/JHZwPgvVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lp1Ju6FU; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lp1Ju6FU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312169; x=1800848169;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bR1iNfDYKkltgdSabWACZpB2PlvjS1g3cOJAx17tkvY=;
  b=lp1Ju6FU27d+UzzjIwdWiHJ1bj/BxZk2x4gos9RsVKCxB6x/voYzit0k
   pvbJ8LTd8KGxVa7dkCK6HF6il6Oy+yU1HBtEi7Va60i/QCXDlRNk280mr
   da6cvskEjhx16neJMATnF2n2W+DUl5Y8yUyt+AGK7vilUXq/auL7/UsnE
   KtkFhPUVpHXIjug2hyIwClBs/fufFjVaRomHrn85Pbau+8p21+kl8+hTr
   nhot+IIU7UXrJS6uKccaGutZuCp/ym1C6qOVzbpYEKoTGrrJa2BYegTUW
   4MLlki7BmhMjHn8cleUE5p1LNe9A2FhGWuVE0D0ggnVj8HVGsokiE0uPO
   g==;
X-CSE-ConnectionGUID: goGTPLpoQdO+y62aVg+J5g==
X-CSE-MsgGUID: wXjc9p4vSM2fpRpH0wxmAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887573"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887573"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:05 -0800
X-CSE-ConnectionGUID: 3oX98+pvR7WYGHv9/ZDvRQ==
X-CSE-MsgGUID: Uzm3evzKQm+XCWCVJWEW5w==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:36:04 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	sj@kernel.org,
	kasong@tencent.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 18/26] crypto: acomp, iaa - crypto_acomp integration of IAA Batching.
Date: Sat, 24 Jan 2026 19:35:29 -0800
Message-Id: <20260125033537.334628-19-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit makes the necessary changes for correctly integrating IAA
compress/decompress batching with the crypto_acomp API as per the
discussions in [1]. Further, IAA sets crypto_alg flags to indicate
support for segmentation.

To provide context from the perspective of a kernel user such as zswap,
the zswap interface to these batching API will be done by setting up the
acomp_req through these crypto API to designate multiple src/dst SG
lists representing the batch being sent to iaa_crypto:

 acomp_request_set_src_folio()
 acomp_request_set_dst_sg()
 acomp_request_set_unit_size()

before proceeding to invoke batch compression using the existing
crypto_acomp_compress() interface.

Within crypto_acomp_compress(), an acomp_req whose tfm supports
segmentation is further tested for an "slen" that is greater than the
request's unit_size. If so, we invoke "acomp_do_req_batch_parallel()",
similar to the "acomp_do_req_chain()" case.

acomp_do_req_batch_parallel() creates a wait_queue_head
"batch_parallel_wq", stores it in the acomp_req's "__ctx", then calls
tfm->compress()/tfm->decompress().

Next, the iaa_crypto driver alg's compress() implementation submits the
batch's requests and immediately returns to
acomp_do_req_batch_parallel(); which then waits for the
"batch_parallel_wq" to be notified by a tfm->batch_completed() event.
To support this, a "batch_completed()" API is added to
"struct crypto_acomp" and "struct acomp_alg".

The iaa_crypto driver alg's batch_completed() implementation waits for
each batch sub-request to complete and notifies the batch_parallel_wq.

If any sub-request has an error, -EINVAL is returned to the acomp_req's
callback, else 0.

[1]: https://lore.kernel.org/all/aRqSqQxR4eHzvb2g@gondor.apana.org.au/

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 crypto/acompress.c                         |  63 ++++++++++
 drivers/crypto/intel/iaa/iaa_crypto.h      |   3 +
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 137 +++++++++++++++++++--
 include/crypto/acompress.h                 |   7 ++
 include/crypto/internal/acompress.h        |   7 ++
 5 files changed, 210 insertions(+), 7 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index cfb8ede02cf4..c48a1a20e21f 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -105,6 +105,7 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
+	acomp->batch_completed = alg->batch_completed;
 	acomp->reqsize = alg->base.cra_reqsize;
 
 	acomp->base.exit = crypto_acomp_exit_tfm;
@@ -291,6 +292,65 @@ static __always_inline int acomp_do_req_chain(struct acomp_req *req, bool comp)
 	return acomp_reqchain_finish(req, err);
 }
 
+static int acomp_do_req_batch_parallel(struct acomp_req *req, bool comp)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	unsigned long *bpwq_addr = acomp_request_ctx(req);
+	wait_queue_head_t batch_parallel_wq;
+	int ret;
+
+	init_waitqueue_head(&batch_parallel_wq);
+	*bpwq_addr = (unsigned long)&batch_parallel_wq;
+
+	ret = comp ? tfm->compress(req) : tfm->decompress(req);
+
+	wait_event(batch_parallel_wq, tfm->batch_completed(req, comp));
+
+	if (req->slen < 0)
+		ret |= -EINVAL;
+
+	return ret;
+}
+
+/**
+ * Please note:
+ * ============
+ *
+ * 1) If @req->unit_size is 0, there is no impact to existing acomp users.
+ *
+ * 2) If @req->unit_size is non-0 (for e.g. zswap compress batching) and
+ *    @req->src and @req->dst are scatterlists:
+ *
+ *    a) Algorithms that do not support segmentation:
+ *
+ *       We call acomp_do_req_chain() that handles the trivial case when
+ *       the caller has passed exactly one segment. The dst SG list's length is
+ *       set to the compression error/compressed length for that segment.
+ *
+ *    b) Algorithms that support segmentation:
+ *
+ *       If the source length is more than @req->unit_size,
+ *       acomp_do_req_batch_parallel() is invoked: this calls the tfm's
+ *       compress() API, which uses the @req->unit_size being greater than
+ *       @req->slen to ascertain that it needs to do batching. The algorithm's
+ *       compress() implementation submits the batch's sub-requests for
+ *       compression and returns.
+ *
+ *       Algorithms that support batching must provide a batch_completed() API.
+ *       When the batch's compression sub-requests have completed, they must
+ *       notify a wait_queue using the batch_completed() API. The batching tfm
+ *       implementation must set the dst SG lists to contain the individual
+ *       sub-requests' error/compressed lengths.
+ *
+ *       If the source length == @req->unit_size, the tfm's compress() API is
+ *       invoked. The assumption is that segmentation algorithms will internally
+ *       set the dst SG list's length to indicate error/compressed length in
+ *       this case, similar to the batching case.
+ *
+ * 3) To prevent functional/performance regressions, we preserve existing
+ *    behavior in all other cases, such as, when @req->unit_size is non-0 and
+ *    @req->src and/or @req->dst is virtual; instead of returning an error.
+ */
 int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
@@ -302,6 +362,9 @@ int crypto_acomp_compress(struct acomp_req *req)
 		if (!crypto_acomp_req_seg(tfm))
 			return acomp_do_req_chain(req, true);
 
+		if (likely((req->slen > req->unit_size) && tfm->batch_completed))
+			return acomp_do_req_batch_parallel(req, true);
+
 		return tfm->compress(req);
 	}
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index db83c21e92f1..d85a8f1cbb93 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -69,10 +69,13 @@
  *         IAA. In other words, don't make any assumptions, and protect
  *         compression/decompression data.
  *
+ * @data:  Driver internal data to interface with crypto_acomp.
+ *
  */
 struct iaa_batch_ctx {
 	struct iaa_req **reqs;
 	struct mutex mutex;
+	void *data;
 };
 
 #define IAA_COMP_MODES_MAX  IAA_MODE_NONE
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 8d83a1ea15d7..915bf9b17b39 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2524,6 +2524,71 @@ static void compression_ctx_init(struct iaa_compression_ctx *ctx, enum iaa_mode
  * Interfaces to crypto_alg and crypto_acomp.
  *********************************************/
 
+static __always_inline int iaa_crypto_acomp_acompress_batch(
+	struct iaa_compression_ctx *ctx,
+	struct iaa_req *parent_req,
+	struct iaa_req **reqs,
+	unsigned int unit_size)
+{
+	int nr_reqs = parent_req->slen / unit_size;
+
+	return iaa_comp_submit_acompress_batch(ctx, parent_req, reqs, nr_reqs, unit_size);
+}
+
+static __always_inline int iaa_crypto_acomp_adecompress_batch(
+	struct iaa_compression_ctx *ctx,
+	struct iaa_req *parent_req,
+	struct iaa_req **reqs,
+	unsigned int unit_size)
+{
+	int nr_reqs = parent_req->dlen / unit_size;
+
+	return iaa_comp_submit_adecompress_batch(ctx, parent_req, reqs, nr_reqs);
+}
+
+static bool iaa_crypto_acomp_batch_completed(struct acomp_req *areq, bool comp)
+{
+	unsigned long *cpu_ctx_addr = acomp_request_ctx(areq);
+	struct iaa_batch_ctx *cpu_ctx = (struct iaa_batch_ctx *)*cpu_ctx_addr;
+	wait_queue_head_t *batch_parallel_wq = (wait_queue_head_t *)cpu_ctx->data;
+	struct iaa_req **reqs = cpu_ctx->reqs;
+	int nr_reqs = (comp ? areq->slen : areq->dlen) / areq->unit_size;
+
+	/*
+	 * Since both, compress and decompress require the eventual
+	 * caller (zswap) to verify @areq->dlen, we use @areq->slen to
+	 * flag the batch's success/error to crypto_acomp, which will
+	 * return this as the @err status to the crypto_acomp callback
+	 * function.
+	 */
+	if (iaa_comp_batch_completed(NULL, reqs, nr_reqs))
+		areq->slen = -EINVAL;
+
+	/*
+	 * Set the acomp_req's dlen to be the first SG list's
+	 * compressed/decompressed length/error value to enable zswap code
+	 * equivalence for non-batching and batching acomp_algs.
+	 */
+	areq->dlen = areq->dst->length;
+
+	/* All sub-requests have finished. Notify the @batch_parallel_wq. */
+	if (waitqueue_active(batch_parallel_wq))
+		wake_up(batch_parallel_wq);
+
+	mutex_unlock(&cpu_ctx->mutex);
+
+	return true;
+}
+
+/*
+ * Main compression API for kernel users of crypto_acomp, such as zswap.
+ *
+ * crypto_acomp_compress() calls into this procedure for:
+ *   - Sequential compression of a single page,
+ *   - Parallel batch compression of multiple pages.
+ *
+ * @areq: asynchronous compress request
+ */
 static int iaa_crypto_acomp_acompress_main(struct acomp_req *areq)
 {
 	struct crypto_tfm *tfm = areq->base.tfm;
@@ -2534,14 +2599,47 @@ static int iaa_crypto_acomp_acompress_main(struct acomp_req *areq)
 	if (iaa_alg_is_registered(crypto_tfm_alg_driver_name(tfm), &idx)) {
 		ctx = iaa_ctx[idx];
 
-		acomp_to_iaa(areq, &parent_req, ctx);
-		ret = iaa_comp_acompress(ctx, &parent_req);
-		iaa_to_acomp(unlikely(ret) ? ret : parent_req.dlen, areq);
+		if (likely(areq->slen == areq->unit_size) || !areq->unit_size) {
+			acomp_to_iaa(areq, &parent_req, ctx);
+			ret = iaa_comp_acompress(ctx, &parent_req);
+			iaa_to_acomp(unlikely(ret) ? ret : parent_req.dlen, areq);
+		} else {
+			struct iaa_batch_ctx *cpu_ctx = raw_cpu_ptr(iaa_batch_ctx);
+			struct iaa_req **reqs;
+			unsigned long *cpu_ctx_addr, *bpwq_addr;
+
+			acomp_to_iaa(areq, &parent_req, ctx);
+
+			mutex_lock(&cpu_ctx->mutex);
+
+			bpwq_addr = acomp_request_ctx(areq);
+			/* Save the wait_queue_head. */
+			cpu_ctx->data = (wait_queue_head_t *)*bpwq_addr;
+
+			reqs = cpu_ctx->reqs;
+
+			ret = iaa_crypto_acomp_acompress_batch(ctx,
+							       &parent_req,
+							       reqs,
+							       areq->unit_size);
+
+			cpu_ctx_addr = acomp_request_ctx(areq);
+			*cpu_ctx_addr = (unsigned long)cpu_ctx;
+		}
 	}
 
 	return ret;
 }
 
+/*
+ * Main decompression API for kernel users of crypto_acomp, such as zswap.
+ *
+ * crypto_acomp_decompress() calls into this procedure for:
+ *   - Sequential decompression of a single buffer,
+ *   - Parallel batch decompression of multiple buffers.
+ *
+ * @areq: asynchronous decompress request
+ */
 static int iaa_crypto_acomp_adecompress_main(struct acomp_req *areq)
 {
 	struct crypto_tfm *tfm = areq->base.tfm;
@@ -2552,9 +2650,33 @@ static int iaa_crypto_acomp_adecompress_main(struct acomp_req *areq)
 	if (iaa_alg_is_registered(crypto_tfm_alg_driver_name(tfm), &idx)) {
 		ctx = iaa_ctx[idx];
 
-		acomp_to_iaa(areq, &parent_req, ctx);
-		ret = iaa_comp_adecompress(ctx, &parent_req);
-		iaa_to_acomp(parent_req.dlen, areq);
+		if (likely(areq->dlen == areq->unit_size) || !areq->unit_size) {
+			acomp_to_iaa(areq, &parent_req, ctx);
+			ret = iaa_comp_adecompress(ctx, &parent_req);
+			iaa_to_acomp(parent_req.dlen, areq);
+		} else {
+			struct iaa_batch_ctx *cpu_ctx = raw_cpu_ptr(iaa_batch_ctx);
+			struct iaa_req **reqs;
+			unsigned long *cpu_ctx_addr, *bpwq_addr;
+
+			acomp_to_iaa(areq, &parent_req, ctx);
+
+			mutex_lock(&cpu_ctx->mutex);
+
+			bpwq_addr = acomp_request_ctx(areq);
+			/* Save the wait_queue_head. */
+			cpu_ctx->data = (wait_queue_head_t *)*bpwq_addr;
+
+			reqs = cpu_ctx->reqs;
+
+			ret = iaa_crypto_acomp_adecompress_batch(ctx,
+								 &parent_req,
+								 reqs,
+								 areq->unit_size);
+
+			cpu_ctx_addr = acomp_request_ctx(areq);
+			*cpu_ctx_addr = (unsigned long)cpu_ctx;
+		}
 	}
 
 	return ret;
@@ -2574,10 +2696,11 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_crypto_acomp_init_fixed,
 	.compress		= iaa_crypto_acomp_acompress_main,
 	.decompress		= iaa_crypto_acomp_adecompress_main,
+	.batch_completed	= iaa_crypto_acomp_batch_completed,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
-		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_SEG,
 		.cra_ctxsize		= sizeof(struct iaa_compression_ctx),
 		.cra_reqsize		= sizeof(u32),
 		.cra_module		= THIS_MODULE,
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 86e4932cd112..752110a7719c 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -109,6 +109,12 @@ struct acomp_req {
  *
  * @compress:		Function performs a compress operation
  * @decompress:		Function performs a de-compress operation
+ * @batch_completed:	Waits for batch completion of parallel
+ *                      compress/decompress requests submitted via
+ *                      @compress/@decompress. Returns bool status
+ *                      of all batch sub-requests having completed.
+ *                      Returns an error code in @req->slen if any
+ *                      of the sub-requests completed with an error.
  * @reqsize:		Context size for (de)compression requests
  * @fb:			Synchronous fallback tfm
  * @base:		Common crypto API algorithm data structure
@@ -116,6 +122,7 @@ struct acomp_req {
 struct crypto_acomp {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	bool (*batch_completed)(struct acomp_req *req, bool comp);
 	unsigned int reqsize;
 	struct crypto_tfm base;
 };
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 366dbdb987e8..7c4e14491d59 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -28,6 +28,12 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @batch_completed:	Waits for batch completion of parallel
+ *                      compress/decompress requests submitted via
+ *                      @compress/@decompress. Returns bool status
+ *                      of all batch sub-requests having completed.
+ *                      Returns an error code in @req->slen if any
+ *                      of the sub-requests completed with an error.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -46,6 +52,7 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	bool (*batch_completed)(struct acomp_req *req, bool comp);
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.27.0


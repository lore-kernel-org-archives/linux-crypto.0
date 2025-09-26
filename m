Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FADF2777E0;
	Fri, 26 Sep 2025 03:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758857718; cv=none; b=POIlRSD98Eontt8LGW4x5Iz5SX7rv5HTj8wAeR3neElLhDeWv66SofIYXLqD050U4KRMWETOxqA55YRCSB8OfNFpp/svlmd1D6BCl4RFTmvg6tdx/2PR/EV2AqNHnzToRbc4sAIyY2lMdq6S2Y4b+GQRf3g0uJwFEjlBsOI+R0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758857718; c=relaxed/simple;
	bh=O6Y/KqSHNNgjHA7lJ/nseE1s3+rHj9XrHsce22HNXnk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aLeLPL00McffNChB+VmVu/kNKfhQgsiDHL8vhQN0rp8tuFU6D6tnWVtyfykGfyLvh3OoIjbxq2D+sNneO5HZLrNTRaNmazp/nX9wOR/Fn9E/ptQfzmjiXcLiPq0ZOmy1j2u/UVFWicsAsYuc5sR4U6BqhF7w9o8RiREdTJmH4Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Thg1hPZu; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Thg1hPZu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857716; x=1790393716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O6Y/KqSHNNgjHA7lJ/nseE1s3+rHj9XrHsce22HNXnk=;
  b=Thg1hPZumAoSpibEGOtmBcCzlGbj/dOGCcK2Y12RrFRbVg31YKiNTCk2
   Ab0/AUrc4HP83I9gj75ysxM6FkwTthdTcuboTRBMzw0IFn7wGKLvMJro3
   G796EPo1vlvOsHEf1pnPzafvNo0KgMgHYxCo75yoT1KMIyiPvNkwDMyug
   F5kuSejKmNgMC/Iwi9PZssm+iKAvRggEeqUZddlGN4e9C/+VU5Pjx3wT4
   iN7wDj1aDhwUCbKk70u8YSf/TTA1ig903SBJ1te0ipSGGULXJ1mZJuT8P
   iZtClt549MIx8FbKNVdYADkvHRYZfiN22EjLEyDHs3vBYOvLhRvpGTxiu
   w==;
X-CSE-ConnectionGUID: cNCpi9JkSmec8Qhh+thtnw==
X-CSE-MsgGUID: wZv0OPK2RhKcWRPMZKuPOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819548"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819548"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:06 -0700
X-CSE-ConnectionGUID: AFxCyJRuTT65k9GCwiosJw==
X-CSE-MsgGUID: +ZdoxfwoQgS5NAUBnswviQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636583"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:05 -0700
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
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v12 12/23] crypto: iaa - Enablers for submitting descriptors then polling for completion.
Date: Thu, 25 Sep 2025 20:34:51 -0700
Message-Id: <20250926033502.7486-13-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds capabilities in the IAA driver for kernel users to avail
of the benefits of compressing/decompressing multiple jobs in parallel
using IAA hardware acceleration, without the use of interrupts. Instead,
this is accomplished using an async "submit-poll" mechanism.

To achieve this, we break down a compress/decompress job into two
separate activities if the driver is configured for non-irq async mode:

1) Submit a descriptor after caching the "idxd_desc" descriptor in the
   req->drv_data, and return -EINPROGRESS.
2) Poll: Given a request, retrieve the descriptor and poll its completion
   status for success/error.

This is enabled by the following additions in the driver:

1) The idxd_desc is cached in the "drv_data" member of "struct iaa_req".

2) IAA_REQ_POLL_FLAG: if set in the iaa_req's flags, this tells
   the driver that it should submit the descriptor and return
   -EINPROGRESS. If not set, the driver will proceed to call
   check_completion() in fully synchronous mode, until the hardware
   returns a completion status.

3) iaa_comp_poll() procedure: This routine is intended to be called
   after submission returns -EINPROGRESS. It will check the completion
   status once, and return -EAGAIN if the job has not completed. If the
   job has completed, it will return the completion status.

The purpose of this commit is to allow kernel users of iaa_crypto, such
as zswap, to be able to invoke the crypto_acomp_compress() API in fully
synchronous mode for sequential/non-batching use cases (i.e. today's
status-quo), wherein zswap calls:

  crypto_wait_req(crypto_acomp_compress(req), wait);

and to non-instrusively invoke the fully asynchronous batch
compress/decompress functionality that will be introduced in subsequent
patches. Both use cases need to reuse same code paths in the driver to
interface with hardware: the IAA_REQ_POLL_FLAG allows this
shared code to determine whether we need to process an iaa_req
synchronously/asynchronously. The idea is to simplify iaa_crypto's
sequential/batching interfaces for use by zswap and zram.

Thus, regardless of the iaa_crypto driver's 'sync_mode' setting, it
can still be forced to use synchronous mode by *not setting* the
IAA_REQ_POLL_FLAG in iaa_req->flags: this is the default to support
sequential use cases in zswap today.

When IAA batching functionality is introduced subsequently, it will set
the IAA_REQ_POLL_FLAG for the requests in a batch. We will submit the
descriptors for each request in the batch in iaa_[de]compress(), and
return -EINPROGRESS. The hardware will begin processing each request as
soon as it is submitted, essentially all compress/decompress jobs will
be parallelized. The polling function, "iaa_comp_poll()", will retrieve
the descriptor from each iaa_req->drv_data to check its completion
status. This enables the iaa_crypto driver to implement true async
"submit-polling" for parallel compressions and decompressions in the IAA
hardware accelerator.

To summarize, both these conditions need to be met for a request to be
processed in fully async submit-poll mode:

 1) use_irq should be "false"
 2) iaa_req->flags & IAA_REQ_POLL_FLAG should be "true"

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |  6 ++
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 71 +++++++++++++++++++++-
 2 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 190157967e3b..1cc383c94fb8 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -41,6 +41,12 @@
 					 IAA_DECOMP_CHECK_FOR_EOB | \
 					 IAA_DECOMP_STOP_ON_EOB)
 
+/*
+ * If set, the driver must have a way to submit the req, then
+ * poll its completion status for success/error.
+ */
+#define IAA_REQ_POLL_FLAG		0x00000002
+
 /* Representation of IAA workqueue */
 struct iaa_wq {
 	struct list_head	list;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index f5abad950371..7395822430b1 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1891,13 +1891,14 @@ static int iaa_compress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 					  ctx->mode, iaa_device->compression_modes[ctx->mode]);
 
 	if (likely(!ctx->use_irq)) {
+		req->drv_data = idxd_desc;
 		iaa_submit_desc_movdir64b(wq, idxd_desc);
 
 		/* Update stats */
 		update_total_comp_calls();
 		update_wq_comp_calls(wq);
 
-		if (ctx->async_mode)
+		if (req->flags & IAA_REQ_POLL_FLAG)
 			return -EINPROGRESS;
 
 		ret = check_completion(dev, idxd_desc->iax_completion, true, false);
@@ -1979,13 +1980,14 @@ static int iaa_decompress(struct iaa_compression_ctx *ctx, struct iaa_req *req,
 	desc = iaa_setup_decompress_hw_desc(idxd_desc, src_addr, slen, dst_addr, *dlen);
 
 	if (likely(!ctx->use_irq)) {
+		req->drv_data = idxd_desc;
 		iaa_submit_desc_movdir64b(wq, idxd_desc);
 
 		/* Update stats */
 		update_total_decomp_calls();
 		update_wq_decomp_calls(wq);
 
-		if (ctx->async_mode)
+		if (req->flags & IAA_REQ_POLL_FLAG)
 			return -EINPROGRESS;
 
 		ret = check_completion(dev, idxd_desc->iax_completion, false, false);
@@ -2188,6 +2190,71 @@ static int iaa_comp_adecompress(struct iaa_compression_ctx *ctx, struct iaa_req
 	return ret;
 }
 
+static int __maybe_unused iaa_comp_poll(struct iaa_compression_ctx *ctx, struct iaa_req *req)
+{
+	struct idxd_desc *idxd_desc;
+	struct idxd_device *idxd;
+	struct iaa_wq *iaa_wq;
+	struct pci_dev *pdev;
+	struct device *dev;
+	struct idxd_wq *wq;
+	bool compress_op;
+	int ret;
+
+	idxd_desc = req->drv_data;
+	if (!idxd_desc)
+		return -EAGAIN;
+
+	compress_op = (idxd_desc->iax_hw->opcode == IAX_OPCODE_COMPRESS);
+	wq = idxd_desc->wq;
+	iaa_wq = idxd_wq_get_private(wq);
+	idxd = iaa_wq->iaa_device->idxd;
+	pdev = idxd->pdev;
+	dev = &pdev->dev;
+
+	ret = check_completion(dev, idxd_desc->iax_completion, compress_op, true);
+	if (ret == -EAGAIN)
+		return ret;
+	if (ret)
+		goto out;
+
+	req->dlen = idxd_desc->iax_completion->output_size;
+
+	/* Update stats */
+	if (compress_op) {
+		update_total_comp_bytes_out(req->dlen);
+		update_wq_comp_bytes(wq, req->dlen);
+	} else {
+		update_total_decomp_bytes_in(req->slen);
+		update_wq_decomp_bytes(wq, req->slen);
+	}
+
+	if (compress_op && ctx->verify_compress) {
+		dma_addr_t src_addr, dst_addr;
+
+		req->compression_crc = idxd_desc->iax_completion->crc;
+
+		dma_sync_sg_for_device(dev, req->dst, 1, DMA_FROM_DEVICE);
+		dma_sync_sg_for_device(dev, req->src, 1, DMA_TO_DEVICE);
+
+		src_addr = sg_dma_address(req->src);
+		dst_addr = sg_dma_address(req->dst);
+
+		ret = iaa_compress_verify(ctx, req, wq, src_addr, req->slen,
+					  dst_addr, req->dlen);
+	}
+
+out:
+	/* caller doesn't call crypto_wait_req, so no acomp_request_complete() */
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
+
+	idxd_free_desc(idxd_desc->wq, idxd_desc);
+	percpu_ref_put(&iaa_wq->ref);
+
+	return ret;
+}
+
 static void compression_ctx_init(struct iaa_compression_ctx *ctx, enum iaa_mode mode)
 {
 	ctx->mode = mode;
-- 
2.27.0


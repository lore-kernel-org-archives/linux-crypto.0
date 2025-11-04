Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2573148B1;
	Tue,  4 Nov 2025 09:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247567; cv=none; b=ry3ZyE52zhRhxd0muvRAPJReHbpoh2opyazceLdYs/c6gxb3/2UOcJzsHjdbcDYnvmCsQ+9sQAujzJ+GneI/JUTk2cbe5jPilHpbk2KTH9lA+WP5NEWASqHEaNziPkM4Gbmpw4RehBr9skBq4EpD4ycSs6G4/fmEtDCnNIbi/bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247567; c=relaxed/simple;
	bh=DYdbUQmDyjma1Uk7ERKMfMbJfAu0/DQUfg94r8ghqgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VdVCxhlRIwAR9vdUfrj8sOZABRtagVtRn946X6QPeyNA0s6KqZtWD/eYdTssXRlnWkjKcNs3H7NUVJEb+d540Jn0SxX18FAI9mC4AjtEfo6BGq1CT0xgI6Ga9ghwEVcPUq8ysBqRuhLrh23jifVt6Q9L+zEk2IbL6sDWij0+Ick=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LoSZTep2; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LoSZTep2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247565; x=1793783565;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DYdbUQmDyjma1Uk7ERKMfMbJfAu0/DQUfg94r8ghqgQ=;
  b=LoSZTep2uSyy0+p+rKVMWXuC3+gdccnmTKzhaRm4e4eO36COVBMhfooe
   tv8Ek4mmfiQJiFjvpizjVc7SvcSXx8di23lKaTCZmi6iNCbO/3nczMqNv
   kKAisR3W1d443X5XAZx6kNq7XlbIFpRLTHpm2v+8cJD0fdNMfp9wJWzTL
   gVqK8DSBnxQYf1DHaDf/aKPuhXw7hkJYtoPCVpLfqzizSTyBrnkLEa+DE
   jU+HMmF5LEtQQVohS6jHzyInUdtYPVBYwrDaeueaCcGof/QfeNsBl30+W
   8wwsIhR5aOgaqTURIk5fzCcz3Cdxw6jI06fqZZgn9T8fWKPAh0UOEcRd7
   w==;
X-CSE-ConnectionGUID: GyPXrzXcSNy3SSKA0Dv8DA==
X-CSE-MsgGUID: XZTm4NEiTgiFU0tXLPxH3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89798682"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="89798682"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:38 -0800
X-CSE-ConnectionGUID: CefLIxCmQiGT2et7GffAEw==
X-CSE-MsgGUID: ExBGBeCxSbqxCSwqxUv1qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795805"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:38 -0800
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
Subject: [PATCH v13 10/22] crypto: iaa - Expect a single scatterlist for a [de]compress request's src/dst.
Date: Tue,  4 Nov 2025 01:12:23 -0800
Message-Id: <20251104091235.8793-11-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The calls to dma_map_sg() were passing sg_nents() for the @nents
parameter, then error-ing out if more than one @nr_sgs were
returned. Furthermore, there are no use-cases for iaa_crypto that allow
multiple SG lists to be mapped for dma at once.

Moreover, as per Herbert's direction in [1] for the batching API from
higher mm layers to interface with crypto using SG lists, batching
within iaa_crypto will rely on there being exactly one SG list per
"unit" of [de]compression in a batch, where the component SG lists are
obtained by breaking down the @req->src and @req->dst.

Given all of the above, this patch simplifies the design by expecting
only 1 @nents in req->src and req->dst, which aligns with current and
batching use cases that will be developed in subsequent patches.

This alleviates the latency penalty of calling sg_nents() per
[de]compress op submitted to the hardware.

Some unlikely() annotations are added to conditionals in the core
[de]compress routines to further improve latency per op.

[1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 54 +++++++++++-----------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 061e3403d365..04602df8d173 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1520,11 +1520,11 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 	int ret = 0;
 	int nr_sgs;
 
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "verify: couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -1536,13 +1536,13 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 		" req->slen %d, sg_dma_len(sg) %d\n", *src_addr, nr_sgs,
 		req->src, req->slen, sg_dma_len(req->src));
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "verify: couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
 		ret = -EIO;
-		dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, req->src, 1, DMA_FROM_DEVICE);
 		goto out;
 	}
 	*dst_addr = sg_dma_address(req->dst);
@@ -1710,14 +1710,14 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 			err = -EIO;
 		}
 
-		dma_unmap_sg(dev, ctx->req->dst, sg_nents(ctx->req->dst), DMA_TO_DEVICE);
-		dma_unmap_sg(dev, ctx->req->src, sg_nents(ctx->req->src), DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, ctx->req->dst, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, ctx->req->src, 1, DMA_FROM_DEVICE);
 
 		goto out;
 	}
 err:
-	dma_unmap_sg(dev, ctx->req->dst, sg_nents(ctx->req->dst), DMA_FROM_DEVICE);
-	dma_unmap_sg(dev, ctx->req->src, sg_nents(ctx->req->src), DMA_TO_DEVICE);
+	dma_unmap_sg(dev, ctx->req->dst, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, ctx->req->src, 1, DMA_TO_DEVICE);
 out:
 	if (ret != 0)
 		dev_dbg(dev, "asynchronous compress failed ret=%d\n", ret);
@@ -2020,8 +2020,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2030,8 +2030,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	}
 	src_addr = sg_dma_address(req->src);
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2057,18 +2057,18 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
 
-		dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_TO_DEVICE);
-		dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, req->dst, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, req->src, 1, DMA_FROM_DEVICE);
 
 		goto out;
 	}
 
-	if (ret)
+	if (unlikely(ret))
 		dev_dbg(dev, "asynchronous compress failed ret=%d\n", ret);
 
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
 err_map_dst:
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
 out:
 	percpu_ref_put(&iaa_wq->ref);
 
@@ -2101,8 +2101,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2111,8 +2111,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	}
 	src_addr = sg_dma_address(req->src);
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2126,12 +2126,12 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	if (ret == -EINPROGRESS)
 		return ret;
 
-	if (ret != 0)
+	if (unlikely(ret != 0))
 		dev_dbg(dev, "asynchronous decompress failed ret=%d\n", ret);
 
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
 err_map_dst:
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
 out:
 	percpu_ref_put(&iaa_wq->ref);
 
-- 
2.27.0


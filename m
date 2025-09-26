Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5782727F9;
	Fri, 26 Sep 2025 03:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758857716; cv=none; b=BmowWKbr2fG65665jl18zmXxk+SKj6VWPQpavb0XjU52FzEGjSUgXURyELmBlzhEr7ouxKJ6IXDRRyGCz32FQNKRfVeh7j2S+zwARwghx5Hqcwfk9ZQ/tMU7AObTZFZIrub2IKEU1WDR2dD/Bz8xsBFjv3niC2Lxh5LnEx6FsVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758857716; c=relaxed/simple;
	bh=YeucmBW4uE3v66fZdWNHbrEXnqb/5N0a3izK6ymDr0I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GHLp/6hiChWhgLMNzHUDzbceShXM+X3RheboqT3G7e4jIzpVUvNsD/T7zQe2pLB3DStIxdGu2phLsmm3Drl32wnKnQz3c2DZwlYGLpL3xOLwJLDtwdaQDVbAEDXLwzEbUtOd65IyAKMZNoCNIZk1EhqFDzKE8T7AexEy5maQpYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PrsRtVcd; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PrsRtVcd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857714; x=1790393714;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YeucmBW4uE3v66fZdWNHbrEXnqb/5N0a3izK6ymDr0I=;
  b=PrsRtVcdmIuhfdhAnPYZ3O9WcoyVa5l+zprcbpUUFqVNdC6nA4aWOTmm
   vwlku5UTTyF7XhVJw9xAw7WIEXNhtHxwQACn0SU/KKqWKUDIeM0XuTjtA
   iHFqcEINDlHgZcyX1HYeqtLcpfvgiPcJWmt0U74/MSNzXDVIUyyHDrwru
   nFrxib6d4mnYQUgcBOqcDW1ZwsQK5wodyjEiqkqM/u2h8vDuNXtMqENxz
   Ly+KME4dBR4hhwcdamzFNcMtnnxc6bcBExF+f99Ga6al6vok7d+TgsT3w
   Pn4LzB2Oe/9t2gPQKe+lMg7wK5runM0zlROjusWWWuLZ6vKd1GxVnLaZo
   w==;
X-CSE-ConnectionGUID: fQxS3I+8SUO1zvEQ+LTE6w==
X-CSE-MsgGUID: tS183Z8DQsayw6bknf3Lsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819528"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819528"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:05 -0700
X-CSE-ConnectionGUID: /bspJ5WQSiWc8d4EuZm2iw==
X-CSE-MsgGUID: MXWsdFXuSoCqOvxAuuj0xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636577"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:04 -0700
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
Subject: [PATCH v12 10/23] crypto: iaa - Expect a single scatterlist for a [de]compress request's src/dst.
Date: Thu, 25 Sep 2025 20:34:49 -0700
Message-Id: <20250926033502.7486-11-kanchana.p.sridhar@intel.com>
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
index dd7c4831e092..16b071058f2b 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1514,11 +1514,11 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
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
@@ -1530,13 +1530,13 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
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
@@ -1704,14 +1704,14 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
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
@@ -2014,8 +2014,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2024,8 +2024,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	}
 	src_addr = sg_dma_address(req->src);
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2051,18 +2051,18 @@ static int iaa_comp_acompress(struct acomp_req *req)
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
 
@@ -2095,8 +2095,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2105,8 +2105,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	}
 	src_addr = sg_dma_address(req->src);
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
+	nr_sgs = dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	if (unlikely(nr_sgs <= 0 || nr_sgs > 1)) {
 		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
 			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
 			iaa_wq->wq->id, ret);
@@ -2120,12 +2120,12 @@ static int iaa_comp_adecompress(struct acomp_req *req)
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


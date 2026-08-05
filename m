Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219253EFFD7;
	Wed,  5 Aug 2026 21:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785964830; cv=none; b=NKQVawTR1a25sUJW8ot90Lju7/2c9g+biyqU9CUyGe92lN11Fz5JMgRxWwxgQbDpd8moI6+VI+YQdk/HNqyy2t9fdvKnX1WZE/Md/7eYei4lfzCiOOXjxamdgd3vslnPUpwOx64MMaYBDxwwHUxz96peIzWR4wh2rwXx/BCny5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785964830; c=relaxed/simple;
	bh=0mIe74F5PdbWYCSbupTYVjo6B9yeDb1iYFqJ46ZN/dU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c+4CyGa0zI60vw7HXgWWgDJus0jSGK0+0VEc2kU3V3bMvOrzbfC5i2nPAwRHwaBedYOucPX2tsbhOyFLIb6Fv6ruz2JXKdcZUj11b7hUWSZ3YA+Wyb0ImBzmQKUiBx8/nWiGXSbl777GcOduWM9ww7b6UYI1mzHPxYdclGCj/G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ve6KKSFc; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ve6KKSFc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785964823; x=1817500823;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=0mIe74F5PdbWYCSbupTYVjo6B9yeDb1iYFqJ46ZN/dU=;
  b=Ve6KKSFcxWtDfyAbb1yIxsH2K3CO7AVhBAcw7fRKgVATSIcCXtko+qmS
   2FNUk7k2hgJ6DJ82ttyWLJg6e9AIaBqf71dReUsFXWCmgKGbq96ln9yek
   StlgGgu3uzPntck/uNkQdbIsGR6zJdtMXYlJdPiyQ9Ve9vQn2+MR2YYFX
   iycl3X3OgRYBbafwIjIc6YLR3nGohb8WRXOmcnrftPtExX1sRd/OlTjRa
   1kxVp1tUxVSiKbFWUxsAoOGKRxQgi9i8w5FExMC93XvyvNbepFDRmpCHu
   uJX63Vfw1RH8nouX6iXWSDQv95PaKHDdhVN9hblt24MOQMk8hyuMS/Cs4
   g==;
X-CSE-ConnectionGUID: SZzX3QTERGGvwbPLwFno/g==
X-CSE-MsgGUID: lxhGOup/RXe/oDo9TQLryw==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109341700"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109341700"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:49 -0700
X-CSE-ConnectionGUID: YjmhC5JcQe6Jrr/j4e7cJw==
X-CSE-MsgGUID: vvtATsv4SLO0X0w4cPHztg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="300138484"
Received: from vcostago-desk1.jf.intel.com (HELO [10.88.27.144]) ([10.88.27.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:49 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Wed, 05 Aug 2026 14:19:25 -0700
Subject: [PATCH v2 4/5] crypto: iaa - use bounce buffer for multi-sg
 decompress input
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260805-iaa-crypto-fixes-zswap-v2-4-55c02694f499@intel.com>
References: <20260805-iaa-crypto-fixes-zswap-v2-0-55c02694f499@intel.com>
In-Reply-To: <20260805-iaa-crypto-fixes-zswap-v2-0-55c02694f499@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>, 
 Frank Li <Frank.Li@kernel.org>, 
 Kristen Accardi <kristen.c.accardi@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785964788; l=11356;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=WaCy7IueYkKmTYUbajrgjaDrujLjnExlWbtCQfhH0U8=;
 b=OIiwLors/0BHeSlv0NzPWxDPaMgYRMWXBs0d81cC2Pqrsr4sebszTnbeqc1fwjunyXdJEhPTQ
 bp8PrpsYiLzBBs1svhmcv91ElGIpfPnlJlQ3yAc+YGNtAFAFoIFTveN
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Since commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs
from zsmalloc"), zswap passes the raw zsmalloc SG list directly to
crypto drivers, so a compressed object spanning multiple pages reaches
IAA as a multi-entry source. Such requests currently fall back to
software decompression.

As IAA hardware requires a single DMA source buffer, linearize small
multi-entry sources into a pre-allocated bounce page and submit that to
the hardware instead of falling back to software. Keep the software
fallback only for multi-entry destinations. This recovers most of the
performance lost by using the software fallback.

Store the bounce-page state in the acomp request context alongside the
existing compression CRC, free it through a shared source-unmap helper,
and back the pages with a small module-wide mempool so the path remains
available in reclaim-driven callers.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 128 ++++++++++++++++++++++++-----
 1 file changed, 106 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 9505ca23e6f3..51547c5fcf70 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -9,6 +9,7 @@
 #include <linux/sysfs.h>
 #include <linux/device.h>
 #include <linux/iommu.h>
+#include <linux/mempool.h>
 #include <uapi/linux/idxd.h>
 #include <linux/highmem.h>
 #include <linux/sched/smt.h>
@@ -157,6 +158,16 @@ static bool async_mode;
 /* Use interrupts */
 static bool use_irq;
 
+struct iaa_req_ctx {
+	u32 compression_crc;
+	struct page *bounce_src;
+	dma_addr_t bounce_src_dma;
+	unsigned int bounce_src_len;
+};
+
+static mempool_t *iaa_bounce_pool;
+#define IAA_BOUNCE_POOL_SIZE	128
+
 /**
  * set_iaa_sync_mode - Set IAA sync mode
  * @name: The name of the sync mode
@@ -984,6 +995,23 @@ static inline int check_completion(struct device *dev,
 	return ret;
 }
 
+static void iaa_unmap_src(struct device *dev, struct acomp_req *req)
+{
+	struct iaa_req_ctx *req_ctx = acomp_request_ctx(req);
+
+	if (req_ctx->bounce_src) {
+		dma_unmap_page(dev, req_ctx->bounce_src_dma,
+			       req_ctx->bounce_src_len, DMA_TO_DEVICE);
+		mempool_free(req_ctx->bounce_src, iaa_bounce_pool);
+		req_ctx->bounce_src = NULL;
+		req_ctx->bounce_src_dma = 0;
+		req_ctx->bounce_src_len = 0;
+		return;
+	}
+
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
+}
+
 static int deflate_generic_decompress(struct acomp_req *req)
 {
 	ACOMP_FBREQ_ON_STACK(fbreq, req);
@@ -1027,6 +1055,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *compression_ctx;
 	struct crypto_ctx *ctx = __ctx;
+	struct iaa_req_ctx *req_ctx = acomp_request_ctx(ctx->req);
 	struct iaa_device *iaa_device;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1085,10 +1114,9 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	}
 
 	if (ctx->compress && compression_ctx->verify_compress) {
-		u32 *compression_crc = acomp_request_ctx(ctx->req);
 		dma_addr_t src_addr, dst_addr;
 
-		*compression_crc = idxd_desc->iax_completion->crc;
+		req_ctx->compression_crc = idxd_desc->iax_completion->crc;
 
 		ret = iaa_remap_for_verify(dev, iaa_wq, ctx->req, &src_addr, &dst_addr);
 		if (ret) {
@@ -1111,7 +1139,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	}
 err:
 	dma_unmap_sg(dev, ctx->req->dst, sg_nents(ctx->req->dst), DMA_FROM_DEVICE);
-	dma_unmap_sg(dev, ctx->req->src, sg_nents(ctx->req->src), DMA_TO_DEVICE);
+	iaa_unmap_src(dev, ctx->req);
 out:
 	if (ret != 0)
 		dev_dbg(dev, "asynchronous compress failed ret=%d\n", ret);
@@ -1131,7 +1159,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *compression_crc = acomp_request_ctx(req);
+	struct iaa_req_ctx *req_ctx = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc;
 	struct iax_hw_desc *desc;
@@ -1222,7 +1250,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 	update_total_comp_bytes_out(*dlen);
 	update_wq_comp_bytes(wq, *dlen);
 
-	*compression_crc = idxd_desc->iax_completion->crc;
+	req_ctx->compression_crc = idxd_desc->iax_completion->crc;
 
 	if (!ctx->async_mode)
 		idxd_free_desc(wq, idxd_desc);
@@ -1282,7 +1310,7 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *compression_crc = acomp_request_ctx(req);
+	struct iaa_req_ctx *req_ctx = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc;
 	struct iax_hw_desc *desc;
@@ -1342,10 +1370,10 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 		goto err;
 	}
 
-	if (*compression_crc != idxd_desc->iax_completion->crc) {
+	if (req_ctx->compression_crc != idxd_desc->iax_completion->crc) {
 		ret = -EINVAL;
-		dev_dbg(dev, "(verify) iaa comp/decomp crc mismatch:"
-			" comp=0x%x, decomp=0x%x\n", *compression_crc,
+		dev_dbg(dev, "(verify) iaa comp/decomp crc mismatch: comp=0x%x, decomp=0x%x\n",
+			req_ctx->compression_crc,
 			idxd_desc->iax_completion->crc);
 		print_hex_dump(KERN_INFO, "cmp-rec: ", DUMP_PREFIX_OFFSET,
 			       8, 1, idxd_desc->iax_completion, 64, 0);
@@ -1485,6 +1513,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 static int iaa_comp_acompress(struct acomp_req *req)
 {
+	struct iaa_req_ctx *req_ctx = acomp_request_ctx(req);
 	struct iaa_compression_ctx *compression_ctx;
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
@@ -1493,6 +1522,10 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	struct idxd_wq *wq;
 	struct device *dev;
 
+	req_ctx->bounce_src = NULL;
+	req_ctx->bounce_src_dma = 0;
+	req_ctx->bounce_src_len = 0;
+
 	compression_ctx = crypto_tfm_ctx(tfm);
 
 	if (!iaa_crypto_enabled) {
@@ -1584,12 +1617,19 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 static int iaa_comp_adecompress(struct acomp_req *req)
 {
+	struct iaa_req_ctx *req_ctx = acomp_request_ctx(req);
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
+	bool use_bounce_src = false;
 	int cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct device *dev;
 	struct idxd_wq *wq;
+	struct page *page;
+
+	req_ctx->bounce_src = NULL;
+	req_ctx->bounce_src_dma = 0;
+	req_ctx->bounce_src_len = 0;
 
 	if (!iaa_crypto_enabled) {
 		pr_debug("iaa_crypto disabled, not decompressing\n");
@@ -1601,10 +1641,16 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		return -EINVAL;
 	}
 
-	/* Fall back to software if src or dst has multiple sg entries */
-	if (sg_nents(req->src) > 1 || sg_nents(req->dst) > 1)
+	/* Fall back to software if dst has multiple sg entries */
+	if (sg_nents(req->dst) > 1)
 		return deflate_generic_decompress(req);
 
+	if (sg_nents(req->src) > 1) {
+		if (req->slen > PAGE_SIZE)
+			return deflate_generic_decompress(req);
+		use_bounce_src = true;
+	}
+
 	cpu = get_cpu();
 	wq = wq_table_next_wq(cpu);
 	put_cpu();
@@ -1623,20 +1669,47 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	if (!dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE)) {
-		dev_dbg(dev, "couldn't map src sg for iaa device %d, wq %d\n",
-			iaa_wq->iaa_device->idxd->id, iaa_wq->wq->id);
-		iaa_wq_put(wq);
-		return deflate_generic_decompress(req);
+	if (unlikely(use_bounce_src)) {
+		page = mempool_alloc(iaa_bounce_pool, GFP_ATOMIC);
+		if (!page) {
+			iaa_wq_put(wq);
+			return deflate_generic_decompress(req);
+		}
+
+		if (sg_copy_to_buffer(req->src, sg_nents(req->src),
+				      page_address(page), req->slen) != req->slen) {
+			mempool_free(page, iaa_bounce_pool);
+			iaa_wq_put(wq);
+			return deflate_generic_decompress(req);
+		}
+
+		src_addr = dma_map_page(dev, page, 0, req->slen, DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, src_addr)) {
+			mempool_free(page, iaa_bounce_pool);
+			iaa_wq_put(wq);
+			return deflate_generic_decompress(req);
+		}
+
+		req_ctx->bounce_src = page;
+		req_ctx->bounce_src_dma = src_addr;
+		req_ctx->bounce_src_len = req->slen;
+	} else {
+		if (!dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE)) {
+			dev_dbg(dev, "couldn't map src sg for iaa device %d, wq %d\n",
+				iaa_wq->iaa_device->idxd->id, iaa_wq->wq->id);
+			iaa_wq_put(wq);
+			return deflate_generic_decompress(req);
+		}
+
+		src_addr = sg_dma_address(req->src);
+		dev_dbg(dev, "map src %llx req->src %p slen %d sg_len %d\n", src_addr,
+			req->src, req->slen, sg_dma_len(req->src));
 	}
-	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "map src %llx req->src %p slen %d sg_len %d\n", src_addr,
-		req->src, req->slen, sg_dma_len(req->src));
 
 	if (!dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE)) {
 		dev_dbg(dev, "couldn't map dst sg for iaa device %d, wq %d\n",
 			iaa_wq->iaa_device->idxd->id, iaa_wq->wq->id);
-		dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
+		iaa_unmap_src(dev, req);
 		iaa_wq_put(wq);
 		return deflate_generic_decompress(req);
 	}
@@ -1653,7 +1726,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		dev_dbg(dev, "asynchronous decompress failed ret=%d\n", ret);
 
 	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
-	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
+	iaa_unmap_src(dev, req);
 	iaa_wq_put(wq);
 
 	return ret;
@@ -1687,7 +1760,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 		.cra_driver_name	= "deflate-iaa",
 		.cra_flags		= CRYPTO_ALG_ASYNC,
 		.cra_ctxsize		= sizeof(struct iaa_compression_ctx),
-		.cra_reqsize		= sizeof(u32),
+		.cra_reqsize		= sizeof(struct iaa_req_ctx),
 		.cra_module		= THIS_MODULE,
 		.cra_priority		= IAA_ALG_PRIORITY,
 	}
@@ -1886,6 +1959,12 @@ static int __init iaa_crypto_init_module(void)
 		goto err_aecs_init;
 	}
 
+	iaa_bounce_pool = mempool_create_page_pool(IAA_BOUNCE_POOL_SIZE, 0);
+	if (!iaa_bounce_pool) {
+		ret = -ENOMEM;
+		goto err_bounce_pool;
+	}
+
 	ret = idxd_driver_register(&iaa_crypto_driver);
 	if (ret) {
 		pr_debug("IAA wq sub-driver registration failed\n");
@@ -1919,6 +1998,9 @@ static int __init iaa_crypto_init_module(void)
 err_verify_attr_create:
 	idxd_driver_unregister(&iaa_crypto_driver);
 err_driver_reg:
+	mempool_destroy(iaa_bounce_pool);
+	iaa_bounce_pool = NULL;
+err_bounce_pool:
 	iaa_aecs_cleanup_fixed();
 err_aecs_init:
 
@@ -1935,6 +2017,8 @@ static void __exit iaa_crypto_cleanup_module(void)
 	driver_remove_file(&iaa_crypto_driver.drv,
 			   &driver_attr_verify_compress);
 	idxd_driver_unregister(&iaa_crypto_driver);
+	mempool_destroy(iaa_bounce_pool);
+	iaa_bounce_pool = NULL;
 	iaa_aecs_cleanup_fixed();
 
 	pr_debug("cleaned up\n");

-- 
2.55.0


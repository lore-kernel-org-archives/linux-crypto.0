Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764713EEAC4;
	Wed,  5 Aug 2026 21:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785964819; cv=none; b=ZbEajE3jVSyTsp136qotLQlEFXZL4NXBhROgb8mN9YSnw3n3s3tLgNodrbC+tk1HVcj8EJlQ9vakoxkn/xeU4+gdm1MHE5aEWdQ86mtbSthEx+DmatR7+3nJ8r4eBCzRqz09vsgtOy4q4cAi+mS5G5TsiPr5ol80QA4Fvm1emsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785964819; c=relaxed/simple;
	bh=WGQ/kaRFdhmLazLFJgHnGUbRo6qOeCsrYg861dEF8FU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hicKsaeHqNIcaaYIwMyBEchyFK0Tj/H6fm6NV4ACHJW8MMdkuiOi5DrPHZSGNj6Roc0ma/oHaBM4QgP+FGD824SIgwH9km6Q63QDxB02mCYw9PA4txuFqyxHQCKhBWzSP/lcAxJaFQ/JeoGDq6t5RFD77uwrag1BWKhWYP8rzbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=da+IXLCD; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="da+IXLCD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785964812; x=1817500812;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=WGQ/kaRFdhmLazLFJgHnGUbRo6qOeCsrYg861dEF8FU=;
  b=da+IXLCDfrie3VAhyyEeCc9WA1bRVGBLulONnECMSFREHHY3OB6F7PpS
   faQpAVDHr1yb5NPhfmhhnQjk/4mBcLYLe/L0f7d0EDdIH1SMTAwiDamcO
   qmgmjZ8p1B2wdaOooWTlm+TbZnLt/e6PS/zc3aDT5QIc3f5PavRfqF/Qy
   UCZ03cV7CrYC32mttf1BrBE/1dWRC/aW8H0gsGlfS29S1rf4ndEuARroq
   gFeabfb90jBL+LQIfsqGQ8BZXNxqAFLMJ69w39Zaq4ISsNSGQiEGtpMlX
   nNXWqovRrWFT/CfGigPT7HMIzwurO6bBFwitLGadTPWcPxxDX0ioWkcQN
   Q==;
X-CSE-ConnectionGUID: TEJnuGKLSO26UjM0mvAnRA==
X-CSE-MsgGUID: vCOMsGxATv+UF4/xPyfc5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109341681"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109341681"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:49 -0700
X-CSE-ConnectionGUID: J9ETO/b+QAezz81HYVNHpA==
X-CSE-MsgGUID: zJT9IvCfT7mwVxP4rP67Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="300138478"
Received: from vcostago-desk1.jf.intel.com (HELO [10.88.27.144]) ([10.88.27.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:49 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Wed, 05 Aug 2026 14:19:23 -0700
Subject: [PATCH v2 2/5] crypto: iaa - fall back to software for multi-entry
 scatterlists
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260805-iaa-crypto-fixes-zswap-v2-2-55c02694f499@intel.com>
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
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785964788; l=11943;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=s+BRcnMhBAw0HL5SYdMWjPETgpmi/Pu5LVKKe5+JoRQ=;
 b=RvjDJ7hOhyP+2Ixasn7PhtEUvTW96qtcjpb4ok8epXvE/ybgGeRtLKdgggGSBgTePR/+o9v6r
 GrqW/4VLfi5A1ZFLN9iuYKrYj6kHl5Q7Y49V4A1UZArw80DIe8Wo+71
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

IAA cannot process source or destination scatterlists with more than one
entry directly. Instead of failing these requests, route them through a
separate deflate acomp transform and keep the request alive in software.

The IAA driver has never handled multi-entry scatterlists, but the
limitation was latent until commit e2c3b6b21c77 ("mm: zswap: use SG list
decompression APIs from zsmalloc") made zswap pass the raw zsmalloc SG
list directly to crypto drivers, so objects spanning multiple pages now
reach IAA as multi-entry sources and would otherwise fail decompression.

Fallback to the generic DEFLATE implementation for scatterlists with
more than one entry. After the multi-entry cases fall back early,
simplify the DMA mapping path to a single scatterlist entry and fall
back on mapping failure as well.

Add counters to track the number of requests processed by the software
implementation on the compression direction.

Fixes: 2ec6761df889 ("crypto: iaa - Add support for deflate-iaa compression algorithm")
Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsmalloc")
Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c  | 111 +++++++++++++++-------------
 drivers/crypto/intel/iaa/iaa_crypto_stats.c |   9 +++
 drivers/crypto/intel/iaa/iaa_crypto_stats.h |   2 +
 3 files changed, 71 insertions(+), 51 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index f62b994e18e5..904d9413ba18 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2021 Intel Corporation. All rights rsvd. */
 
 #include <linux/init.h>
+#include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -996,6 +997,19 @@ static int deflate_generic_decompress(struct acomp_req *req)
 	return ret;
 }
 
+static int deflate_generic_compress(struct acomp_req *req)
+{
+	ACOMP_FBREQ_ON_STACK(fbreq, req);
+	int ret;
+
+	ret = crypto_acomp_compress(fbreq);
+	req->dlen = fbreq->dlen;
+
+	update_total_sw_comp_calls();
+
+	return ret;
+}
+
 static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 				struct acomp_req *req,
 				dma_addr_t *src_addr, dma_addr_t *dst_addr);
@@ -1472,7 +1486,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	struct iaa_compression_ctx *compression_ctx;
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
-	int nr_sgs, cpu, ret = 0;
+	int cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct idxd_wq *wq;
 	struct device *dev;
@@ -1484,11 +1498,15 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		return -ENODEV;
 	}
 
-	if (!req->src || !req->slen) {
-		pr_debug("invalid src, not compressing\n");
+	if (!req->src || !req->slen || !req->dst) {
+		pr_debug("invalid req, not compressing\n");
 		return -EINVAL;
 	}
 
+	/* Fall back to software if src or dst has multiple sg entries */
+	if (sg_nents(req->src) > 1 || sg_nents(req->dst) > 1)
+		return deflate_generic_compress(req);
+
 	cpu = get_cpu();
 	wq = wq_table_next_wq(cpu);
 	put_cpu();
@@ -1507,30 +1525,25 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto out;
+	if (!dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE)) {
+		dev_dbg(dev, "couldn't map src sg for iaa device %d, wq %d\n",
+			iaa_wq->iaa_device->idxd->id, iaa_wq->wq->id);
+		iaa_wq_put(wq);
+		return deflate_generic_compress(req);
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
+	dev_dbg(dev, "map src %llx req->src %p slen %d sg_len %d\n", src_addr,
 		req->src, req->slen, sg_dma_len(req->src));
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto err_map_dst;
+	if (!dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE)) {
+		dev_dbg(dev, "couldn't map dst sg for iaa device %d, wq %d\n",
+			iaa_wq->iaa_device->idxd->id, iaa_wq->wq->id);
+		dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
+		iaa_wq_put(wq);
+		return deflate_generic_compress(req);
 	}
 	dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", dst_addr, nr_sgs,
+	dev_dbg(dev, "map dst %llx req->dst %p dlen %d sg_len %d\n", dst_addr,
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_compress(tfm, req, wq, src_addr, req->slen, dst_addr,
@@ -1550,8 +1563,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
 
-		dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_TO_DEVICE);
-		dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, req->dst, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, req->src, 1, DMA_FROM_DEVICE);
 
 		goto out;
 	}
@@ -1559,9 +1572,8 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	if (ret)
 		dev_dbg(dev, "asynchronous compress failed ret=%d\n", ret);
 
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-err_map_dst:
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
 out:
 	iaa_wq_put(wq);
 
@@ -1572,7 +1584,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 {
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
-	int nr_sgs, cpu, ret = 0;
+	int cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct device *dev;
 	struct idxd_wq *wq;
@@ -1582,11 +1594,15 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		return -ENODEV;
 	}
 
-	if (!req->src || !req->slen) {
-		pr_debug("invalid src, not decompressing\n");
+	if (!req->src || !req->slen || !req->dst) {
+		pr_debug("invalid req, not decompressing\n");
 		return -EINVAL;
 	}
 
+	/* Fall back to software if src or dst has multiple sg entries */
+	if (sg_nents(req->src) > 1 || sg_nents(req->dst) > 1)
+		return deflate_generic_decompress(req);
+
 	cpu = get_cpu();
 	wq = wq_table_next_wq(cpu);
 	put_cpu();
@@ -1605,30 +1621,25 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 
 	dev = &wq->idxd->pdev->dev;
 
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "couldn't map src sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto out;
+	if (!dma_map_sg(dev, req->src, 1, DMA_TO_DEVICE)) {
+		dev_dbg(dev, "couldn't map src sg for iaa device %d, wq %d\n",
+			iaa_wq->iaa_device->idxd->id, iaa_wq->wq->id);
+		iaa_wq_put(wq);
+		return deflate_generic_decompress(req);
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
+	dev_dbg(dev, "map src %llx req->src %p slen %d sg_len %d\n", src_addr,
 		req->src, req->slen, sg_dma_len(req->src));
 
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "couldn't map dst sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto err_map_dst;
+	if (!dma_map_sg(dev, req->dst, 1, DMA_FROM_DEVICE)) {
+		dev_dbg(dev, "couldn't map dst sg for iaa device %d, wq %d\n",
+			iaa_wq->iaa_device->idxd->id, iaa_wq->wq->id);
+		dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
+		iaa_wq_put(wq);
+		return deflate_generic_decompress(req);
 	}
 	dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", dst_addr, nr_sgs,
+	dev_dbg(dev, "map dst %llx req->dst %p dlen %d sg_len %d\n", dst_addr,
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
@@ -1639,10 +1650,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	if (ret != 0)
 		dev_dbg(dev, "asynchronous decompress failed ret=%d\n", ret);
 
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-err_map_dst:
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-out:
+	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, 1, DMA_TO_DEVICE);
 	iaa_wq_put(wq);
 
 	return ret;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_stats.c b/drivers/crypto/intel/iaa/iaa_crypto_stats.c
index f5cc3d29ca19..2f2ed88c8812 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_stats.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_stats.c
@@ -19,6 +19,7 @@
 
 static atomic64_t total_comp_calls;
 static atomic64_t total_decomp_calls;
+static atomic64_t total_sw_comp_calls;
 static atomic64_t total_sw_decomp_calls;
 static atomic64_t total_comp_bytes_out;
 static atomic64_t total_decomp_bytes_in;
@@ -43,6 +44,11 @@ void update_total_decomp_calls(void)
 	atomic64_inc(&total_decomp_calls);
 }
 
+void update_total_sw_comp_calls(void)
+{
+	atomic64_inc(&total_sw_comp_calls);
+}
+
 void update_total_sw_decomp_calls(void)
 {
 	atomic64_inc(&total_sw_decomp_calls);
@@ -104,6 +110,7 @@ static void reset_iaa_crypto_stats(void)
 {
 	atomic64_set(&total_comp_calls, 0);
 	atomic64_set(&total_decomp_calls, 0);
+	atomic64_set(&total_sw_comp_calls, 0);
 	atomic64_set(&total_sw_decomp_calls, 0);
 	atomic64_set(&total_comp_bytes_out, 0);
 	atomic64_set(&total_decomp_bytes_in, 0);
@@ -174,6 +181,8 @@ static int global_stats_show(struct seq_file *m, void *v)
 		   atomic64_read(&total_comp_calls));
 	seq_printf(m, "  total_decomp_calls: %llu\n",
 		   atomic64_read(&total_decomp_calls));
+	seq_printf(m, "  total_sw_comp_calls: %llu\n",
+		   atomic64_read(&total_sw_comp_calls));
 	seq_printf(m, "  total_sw_decomp_calls: %llu\n",
 		   atomic64_read(&total_sw_decomp_calls));
 	seq_printf(m, "  total_comp_bytes_out: %llu\n",
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_stats.h b/drivers/crypto/intel/iaa/iaa_crypto_stats.h
index 3787a5f507eb..6e0c6f9939bf 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_stats.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto_stats.h
@@ -11,6 +11,7 @@ void	iaa_crypto_debugfs_cleanup(void);
 void	update_total_comp_calls(void);
 void	update_total_comp_bytes_out(int n);
 void	update_total_decomp_calls(void);
+void	update_total_sw_comp_calls(void);
 void	update_total_sw_decomp_calls(void);
 void	update_total_decomp_bytes_in(int n);
 void	update_completion_einval_errs(void);
@@ -29,6 +30,7 @@ static inline void	iaa_crypto_debugfs_cleanup(void) {}
 static inline void	update_total_comp_calls(void) {}
 static inline void	update_total_comp_bytes_out(int n) {}
 static inline void	update_total_decomp_calls(void) {}
+static inline void	update_total_sw_comp_calls(void) {}
 static inline void	update_total_sw_decomp_calls(void) {}
 static inline void	update_total_decomp_bytes_in(int n) {}
 static inline void	update_completion_einval_errs(void) {}

-- 
2.55.0


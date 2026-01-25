Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84044225417;
	Sun, 25 Jan 2026 03:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312153; cv=none; b=kOB50+gwYyTLDZwa/StcO0CKCaG2FJOB9spkyBs3JY9E4GwUEUXS/jQJNVqVg3YFymLpRLe11aAP7HjbrqTbCAV2ljilTZxys6QNyUi7DgnFrO7rGfuMn8Gu1v9qMFU5VQlg/fkDU9nK3FXLu1/RWAEoZBUi9PVpM8VRJXuupKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312153; c=relaxed/simple;
	bh=chu3mCAeP0wjFOIz/yBzyDrIjGaCv78aq80eLeyDUEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TJzjqgAJs04mxdvqFEWOxTHWlY4NKtKdedz/LSj2OR50Ppp3UZqq284aF0ivKQSuDD3eGlvcDwY9IUDJX2g46q+qyYxitQEsUsWPj5s7gVEgxPwc6DGvuU03o54OndJ/sW7LJSMhgrGzBTx+qGqSZ7VlArQ47t+dQ8bYr2yqtNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jDK/KsBm; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jDK/KsBm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312151; x=1800848151;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=chu3mCAeP0wjFOIz/yBzyDrIjGaCv78aq80eLeyDUEI=;
  b=jDK/KsBmk6N+mY+80S/1FLGDYvG6VD30+v4LUvMi39R5JrNxvMT1pAM5
   Om6quO8KFHynZM1DSy/xKFEuGGXwUhOIspRufcZtuM2dpt4aqO1gJ2NaC
   sMlY/YNKvTQwPh4SX5qoWyCjFqg9fPULko8nqQS9DGdbWNAEYq8pBCvhW
   OV87GAJzQylIUPOKaLhurEwbNAVN6WbfUSc5eFb/e0IkZA0h+R/QhEgJ0
   wWYOKc0HlcHbg5wxvkzkrh685a3fgg6zOIHk8giHsT/s9kjp/bjck32nO
   ARbkxaDbIfaYERPg0kFnahYGnPLdH+Nrly0qasQqj+PGsJGZ5+mN2nuSq
   Q==;
X-CSE-ConnectionGUID: 5UX562zQRh6eUzBdaw00DA==
X-CSE-MsgGUID: uEmfHS3pQna116VFQD7DBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887418"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887418"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:51 -0800
X-CSE-ConnectionGUID: T/10WBPPSwms9qTZoautxA==
X-CSE-MsgGUID: pC5tBX5jQ1ml8oNpW3wuOw==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:49 -0800
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
Subject: [PATCH v14 08/26] crypto: iaa - Refactor hardware descriptor setup into separate procedures.
Date: Sat, 24 Jan 2026 19:35:19 -0800
Message-Id: <20260125033537.334628-9-kanchana.p.sridhar@intel.com>
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

This patch refactors the code that sets up the "struct iax_hw_desc" for
compress/decompress ops, into distinct procedures to make the code more
readable.

Also, get_iaa_device_compression_mode() is deleted and the compression
mode directly accessed from the iaa_device in the calling procedures.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 99 ++++++++++++----------
 1 file changed, 56 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index a727496d5791..f0e9eb52eec4 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -484,12 +484,6 @@ int add_iaa_compression_mode(const char *name,
 }
 EXPORT_SYMBOL_GPL(add_iaa_compression_mode);
 
-static struct iaa_device_compression_mode *
-get_iaa_device_compression_mode(struct iaa_device *iaa_device, int idx)
-{
-	return iaa_device->compression_modes[idx];
-}
-
 static void free_device_compression_mode(struct iaa_device *iaa_device,
 					 struct iaa_device_compression_mode *device_mode)
 {
@@ -1571,7 +1565,6 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       dma_addr_t src_addr, unsigned int slen,
 			       dma_addr_t dst_addr, unsigned int dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
@@ -1590,8 +1583,6 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1667,8 +1658,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device,
-								  compression_ctx->mode);
+	active_compression_mode = iaa_device->compression_modes[compression_ctx->mode];
 	dev_dbg(dev, "%s: compression mode %s,"
 		" ctx->src_addr %llx, ctx->dst_addr %llx\n", __func__,
 		active_compression_mode->name,
@@ -1748,12 +1738,63 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	percpu_ref_put(&iaa_wq->ref);
 }
 
+static struct iax_hw_desc *
+iaa_setup_compress_hw_desc(struct idxd_desc *idxd_desc,
+			   dma_addr_t src_addr,
+			   unsigned int slen,
+			   dma_addr_t dst_addr,
+			   unsigned int dlen,
+			   enum iaa_mode mode,
+			   struct iaa_device_compression_mode *active_compression_mode)
+{
+	struct iax_hw_desc *desc = idxd_desc->iax_hw;
+
+	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR | IDXD_OP_FLAG_CC;
+	desc->opcode = IAX_OPCODE_COMPRESS;
+	desc->compr_flags = IAA_COMP_FLAGS;
+	desc->priv = 0;
+
+	desc->src1_addr = (u64)src_addr;
+	desc->src1_size = slen;
+	desc->dst_addr = (u64)dst_addr;
+	desc->max_dst_size = dlen;
+	desc->flags |= IDXD_OP_FLAG_RD_SRC2_AECS;
+	desc->src2_addr = active_compression_mode->aecs_comp_table_dma_addr;
+	desc->src2_size = sizeof(struct aecs_comp_table_record);
+	desc->completion_addr = idxd_desc->compl_dma;
+
+	return desc;
+}
+
+static struct iax_hw_desc *
+iaa_setup_decompress_hw_desc(struct idxd_desc *idxd_desc,
+			     dma_addr_t src_addr,
+			     unsigned int slen,
+			     dma_addr_t dst_addr,
+			     unsigned int dlen)
+{
+	struct iax_hw_desc *desc = idxd_desc->iax_hw;
+
+	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR | IDXD_OP_FLAG_CC;
+	desc->opcode = IAX_OPCODE_DECOMPRESS;
+	desc->max_dst_size = PAGE_SIZE;
+	desc->decompr_flags = IAA_DECOMP_FLAGS;
+	desc->priv = 0;
+
+	desc->src1_addr = (u64)src_addr;
+	desc->dst_addr = (u64)dst_addr;
+	desc->max_dst_size = dlen;
+	desc->src1_size = slen;
+	desc->completion_addr = idxd_desc->compl_dma;
+
+	return desc;
+}
+
 static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
 			dma_addr_t dst_addr, unsigned int *dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
@@ -1772,8 +1813,6 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_comp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1784,21 +1823,9 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			PTR_ERR(idxd_desc));
 		return -ENODEV;
 	}
-	desc = idxd_desc->iax_hw;
 
-	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR |
-		IDXD_OP_FLAG_RD_SRC2_AECS | IDXD_OP_FLAG_CC;
-	desc->opcode = IAX_OPCODE_COMPRESS;
-	desc->compr_flags = IAA_COMP_FLAGS;
-	desc->priv = 0;
-
-	desc->src1_addr = (u64)src_addr;
-	desc->src1_size = slen;
-	desc->dst_addr = (u64)dst_addr;
-	desc->max_dst_size = *dlen;
-	desc->src2_addr = active_compression_mode->aecs_comp_table_dma_addr;
-	desc->src2_size = sizeof(struct aecs_comp_table_record);
-	desc->completion_addr = idxd_desc->compl_dma;
+	desc = iaa_setup_compress_hw_desc(idxd_desc, src_addr, slen, dst_addr, *dlen,
+					  ctx->mode, iaa_device->compression_modes[ctx->mode]);
 
 	if (likely(!ctx->use_irq)) {
 		ret = idxd_submit_desc(wq, idxd_desc);
@@ -1860,7 +1887,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			  dma_addr_t src_addr, unsigned int slen,
 			  dma_addr_t dst_addr, unsigned int *dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
@@ -1878,8 +1904,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1892,19 +1916,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc = NULL;
 		goto fallback_software_decomp;
 	}
-	desc = idxd_desc->iax_hw;
 
-	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR | IDXD_OP_FLAG_CC;
-	desc->opcode = IAX_OPCODE_DECOMPRESS;
-	desc->max_dst_size = PAGE_SIZE;
-	desc->decompr_flags = IAA_DECOMP_FLAGS;
-	desc->priv = 0;
-
-	desc->src1_addr = (u64)src_addr;
-	desc->dst_addr = (u64)dst_addr;
-	desc->max_dst_size = *dlen;
-	desc->src1_size = slen;
-	desc->completion_addr = idxd_desc->compl_dma;
+	desc = iaa_setup_decompress_hw_desc(idxd_desc, src_addr, slen, dst_addr, *dlen);
 
 	if (likely(!ctx->use_irq)) {
 		ret = idxd_submit_desc(wq, idxd_desc);
-- 
2.27.0


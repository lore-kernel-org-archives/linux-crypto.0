Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056012690EC;
	Fri, 26 Sep 2025 03:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758857713; cv=none; b=qc3LcZn+S6GSxQ5ykYQTkLmu/gV1ej33NZeRDv/gKWoJ+6DoYogQhk4JEcfNDnOxSMIvlmzQQelUwcu/8Kc1NL24mz4XZOTwoAX1drl3vwLsPQn/o/401dC/GHweGiNTOSz+0mxYE97vDowMne5Yj3t1yPkaiPWDvS7ZHHL9CLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758857713; c=relaxed/simple;
	bh=FALZN5fZ5Gqh9fvIgLNDNXJiGlP/yWDeY85+GzyStiw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O3iZ3Az++pRGH4kNMUEXK8hfwK+ARvXErLdjgN0tO9MNf07CvPJ2VV56F4yiUHbma7H9gPkeYnKyuRWjIlnrwtIaHTXWSs0SUPLlMl6NEC3omWJQH8Npfhu1JicqBq9ApL3AZYMyWCoGChk14TmXnta44JN0Qnd4MlYSA2hC6ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HT5Z+YqQ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HT5Z+YqQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857712; x=1790393712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FALZN5fZ5Gqh9fvIgLNDNXJiGlP/yWDeY85+GzyStiw=;
  b=HT5Z+YqQAWFGKKcMHoqizx4CicQlax4Mcfp25waeAmTg6m+JlpJBrskC
   OFsfjXTBfUIAAroAkuL7+rk4jnAVQWcreoLAAmoivD0ZMEzVzG+1oVamx
   eLswa+fjc34utcyK3ub5Ro2PqKv1H3e4kSEQdmYaQmSOA8uLKUpOwGXLr
   qOYBrd5CIm0BiWd50lPlTki484Igx0l7bkpRXA9Wq/vXwq9KjFB7UPvMA
   3Mog7j6/96i0wGDVYccvfOzwnUt/h6fFitT+JWAmNRqdOvlFO6FsleKSJ
   Y/b1axVRj72ogT4mOe2kuRDF1yl1nMTqsaOzI0WozYI85IqjU/frFMRvT
   w==;
X-CSE-ConnectionGUID: en5kAJHsSG2C7bCy4PpFWg==
X-CSE-MsgGUID: Q08jm3+wQEKCI8IT4wWT3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819491"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819491"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:05 -0700
X-CSE-ConnectionGUID: eu3Q2VFWT52sG6FeWQnnQA==
X-CSE-MsgGUID: 0jC17iSzS8OrUGdUyu9Iew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636568"
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
Subject: [PATCH v12 07/23] crypto: iaa - Refactor hardware descriptor setup into separate procedures.
Date: Thu, 25 Sep 2025 20:34:46 -0700
Message-Id: <20250926033502.7486-8-kanchana.p.sridhar@intel.com>
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
index 38b4be0c10b0..c94e7abd3909 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -483,12 +483,6 @@ int add_iaa_compression_mode(const char *name,
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
@@ -1564,7 +1558,6 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       dma_addr_t src_addr, unsigned int slen,
 			       dma_addr_t dst_addr, unsigned int dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
@@ -1583,8 +1576,6 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1660,8 +1651,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device,
-								  compression_ctx->mode);
+	active_compression_mode = iaa_device->compression_modes[compression_ctx->mode];
 	dev_dbg(dev, "%s: compression mode %s,"
 		" ctx->src_addr %llx, ctx->dst_addr %llx\n", __func__,
 		active_compression_mode->name,
@@ -1740,12 +1730,63 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	percpu_ref_put(&iaa_wq->ref);
 }
 
+static __always_inline struct iax_hw_desc *
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
+static __always_inline struct iax_hw_desc *
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
@@ -1764,8 +1805,6 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_comp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1776,21 +1815,9 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1852,7 +1879,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			  dma_addr_t src_addr, unsigned int slen,
 			  dma_addr_t dst_addr, unsigned int *dlen)
 {
-	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
@@ -1870,8 +1896,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	pdev = idxd->pdev;
 	dev = &pdev->dev;
 
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
 	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < ctx->alloc_decomp_desc_timeout)) {
 		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
 		cpu_relax();
@@ -1884,19 +1908,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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


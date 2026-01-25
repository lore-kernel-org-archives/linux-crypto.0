Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81B5218580;
	Sun, 25 Jan 2026 03:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312147; cv=none; b=DNZOdqllAdzgFx62vks6O2W9QfbUCwUPJvXM4hl2+Rmgt+VjkDkoAgjF+VWkg/Ms0+0NZ7PDQJ/TpN4TYoDe6sbePDvZZzlrKJ0puX2eVlG25ozDMO2f2YIg+pBruXNPXY0kv8PVL0wFFS/mGdD8f8OLkh2i0Zop+4UX/zSwddg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312147; c=relaxed/simple;
	bh=8qEnUscBAhTGBThTZr2YCrnOoiRxGamC5eXnrBE4hU8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=czgH/7cVdZuhlqutTBXQBEVtgTqB8v6GU/pbbkmcWRkKmuNpNa+fYjr1vYxZ9Slc4uLmjlZs4MG47ZOmUxsaVqPguLSa769u7GsQp5lTYIKF0fzS/cb1asahx4+TRAk6bmK5PRhN/XW5h4VAiUzu5eT6rrr02RRDVI7GQMG4cqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VfzDL1jG; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VfzDL1jG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312146; x=1800848146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8qEnUscBAhTGBThTZr2YCrnOoiRxGamC5eXnrBE4hU8=;
  b=VfzDL1jGRA+9mebuVvj+7WvRMPGMmtu2jgEZ4aTdOF10lx1ID8mbLEIA
   wEGp1Ia5T2RLpx7tdw5I2uLYjrGB4PZGKRu+wq1pVMFh8kXfwazyGX5dk
   LnSNQNm5O0QymIy37Ksai4vgVpyAVUhKFy5VvoEF95AsZUw/liqHo+SZP
   eIpj9hWJPbX31xRa5Vfu+dWU/wfjlZ8mICfj1SLwgw7wg9LHLeQPQnmon
   Ar1wokcEZVf8zofWQIX7QinPzzfmjYLCzR5Qk/w3dppzX6U5280ByKhCz
   QU221y3oTkDTXqBKwIHadaP7rV6r6hKNzjQDFtylhFFsXaKpB1UEX/gYo
   A==;
X-CSE-ConnectionGUID: ozi5ikIMQyiNXqwTB7HEZw==
X-CSE-MsgGUID: XsrKAAdxTOmWsRdZuI+eCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887348"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887348"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:45 -0800
X-CSE-ConnectionGUID: Ar+EX0NlRCWKU7IuF+LYuQ==
X-CSE-MsgGUID: A4gimB/pRAGgGA38uNPl9Q==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:44 -0800
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
Subject: [PATCH v14 04/26] crypto: iaa - Simplify, consistency of function parameters, minor stats bug fix.
Date: Sat, 24 Jan 2026 19:35:15 -0800
Message-Id: <20260125033537.334628-5-kanchana.p.sridhar@intel.com>
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

This patch further simplifies the code in some places and makes it more
consistent and readable:

1) Change iaa_compress_verify() @dlen parameter to be a value instead of
   a pointer, because @dlen's value is only read, not modified by this
   procedure.

2) Simplify the success/error return paths in iaa_compress(),
   iaa_decompress() and iaa_compress_verify().

3) Delete dev_dbg() statements to make the code more readable.

4) Change return value from descriptor allocation failures to be
   -ENODEV, for better maintainability.

5) Fix a minor statistics bug in iaa_decompress(), with the
   decomp_bytes getting updated in case of errors.

6) Change some dev_dbg() statements related to verify compress errors
   to instead be pr_err().

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 114 +++++----------------
 1 file changed, 26 insertions(+), 88 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 85944ff212e5..bbc72254982c 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1597,7 +1597,7 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
-			       dma_addr_t dst_addr, unsigned int *dlen)
+			       dma_addr_t dst_addr, unsigned int dlen)
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -1621,10 +1621,8 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
 	if (IS_ERR(idxd_desc)) {
-		dev_dbg(dev, "idxd descriptor allocation failed\n");
-		dev_dbg(dev, "iaa compress failed: ret=%ld\n",
-			PTR_ERR(idxd_desc));
-		return PTR_ERR(idxd_desc);
+		dev_dbg(dev, "iaa compress_verify failed: idxd descriptor allocation failure: ret=%ld\n", PTR_ERR(idxd_desc));
+		return -ENODEV;
 	}
 	desc = idxd_desc->iax_hw;
 
@@ -1636,19 +1634,11 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->priv = 0;
 
 	desc->src1_addr = (u64)dst_addr;
-	desc->src1_size = *dlen;
+	desc->src1_size = dlen;
 	desc->dst_addr = (u64)src_addr;
 	desc->max_dst_size = slen;
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	dev_dbg(dev, "(verify) compression mode %s,"
-		" desc->src1_addr %llx, desc->src1_size %d,"
-		" desc->dst_addr %llx, desc->max_dst_size %d,"
-		" desc->src2_addr %llx, desc->src2_size %d\n",
-		active_compression_mode->name,
-		desc->src1_addr, desc->src1_size, desc->dst_addr,
-		desc->max_dst_size, desc->src2_addr, desc->src2_size);
-
 	ret = idxd_submit_desc(wq, idxd_desc);
 	if (ret) {
 		dev_dbg(dev, "submit_desc (verify) failed ret=%d\n", ret);
@@ -1671,14 +1661,10 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 		goto err;
 	}
 
-	idxd_free_desc(wq, idxd_desc);
-out:
-	return ret;
 err:
 	idxd_free_desc(wq, idxd_desc);
-	dev_dbg(dev, "iaa compress failed: ret=%d\n", ret);
 
-	goto out;
+	return ret;
 }
 
 static void iaa_desc_complete(struct idxd_desc *idxd_desc,
@@ -1752,15 +1738,15 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 
 		ret = iaa_remap_for_verify(dev, iaa_wq, ctx->req, &src_addr, &dst_addr);
 		if (ret) {
-			dev_dbg(dev, "%s: compress verify remap failed ret=%d\n", __func__, ret);
+			pr_err("%s: compress verify remap failed ret=%d\n", __func__, ret);
 			err = -EIO;
 			goto out;
 		}
 
 		ret = iaa_compress_verify(ctx->tfm, ctx->req, iaa_wq->wq, src_addr,
-					  ctx->req->slen, dst_addr, &ctx->req->dlen);
+					  ctx->req->slen, dst_addr, ctx->req->dlen);
 		if (ret) {
-			dev_dbg(dev, "%s: compress verify failed ret=%d\n", __func__, ret);
+			pr_err("%s: compress verify failed ret=%d\n", __func__, ret);
 			err = -EIO;
 		}
 
@@ -1774,7 +1760,8 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	dma_unmap_sg(dev, ctx->req->src, sg_nents(ctx->req->src), DMA_TO_DEVICE);
 out:
 	if (ret != 0)
-		dev_dbg(dev, "asynchronous compress failed ret=%d\n", ret);
+		dev_dbg(dev, "asynchronous %s failed ret=%d\n",
+			ctx->compress ? "compress":"decompress", ret);
 
 	if (ctx->req->base.complete)
 		acomp_request_complete(ctx->req, err);
@@ -1784,7 +1771,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	iaa_wq_put(idxd_desc->wq);
 }
 
-static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
+static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
 			dma_addr_t dst_addr, unsigned int *dlen)
@@ -1811,9 +1798,9 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
 	if (IS_ERR(idxd_desc)) {
-		dev_dbg(dev, "idxd descriptor allocation failed\n");
-		dev_dbg(dev, "iaa compress failed: ret=%ld\n", PTR_ERR(idxd_desc));
-		return PTR_ERR(idxd_desc);
+		dev_dbg(dev, "iaa compress failed: idxd descriptor allocation failure: ret=%ld\n",
+			PTR_ERR(idxd_desc));
+		return -ENODEV;
 	}
 	desc = idxd_desc->iax_hw;
 
@@ -1839,21 +1826,8 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = true;
-
-		dev_dbg(dev, "%s use_async_irq: compression mode %s,"
-			" src_addr %llx, dst_addr %llx\n", __func__,
-			active_compression_mode->name,
-			src_addr, dst_addr);
 	}
 
-	dev_dbg(dev, "%s: compression mode %s,"
-		" desc->src1_addr %llx, desc->src1_size %d,"
-		" desc->dst_addr %llx, desc->max_dst_size %d,"
-		" desc->src2_addr %llx, desc->src2_size %d\n", __func__,
-		active_compression_mode->name,
-		desc->src1_addr, desc->src1_size, desc->dst_addr,
-		desc->max_dst_size, desc->src2_addr, desc->src2_size);
-
 	ret = idxd_submit_desc(wq, idxd_desc);
 	if (ret) {
 		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
@@ -1866,7 +1840,6 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	if (ctx->async_mode) {
 		ret = -EINPROGRESS;
-		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
 	}
 
@@ -1884,15 +1857,10 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	*compression_crc = idxd_desc->iax_completion->crc;
 
-	if (!ctx->async_mode)
-		idxd_free_desc(wq, idxd_desc);
-out:
-	return ret;
 err:
 	idxd_free_desc(wq, idxd_desc);
-	dev_dbg(dev, "iaa compress failed: ret=%d\n", ret);
-
-	goto out;
+out:
+	return ret;
 }
 
 static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
@@ -1921,10 +1889,10 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
 	if (IS_ERR(idxd_desc)) {
-		dev_dbg(dev, "idxd descriptor allocation failed\n");
-		dev_dbg(dev, "iaa decompress failed: ret=%ld\n",
+		ret = -ENODEV;
+		dev_dbg(dev, "%s: idxd descriptor allocation failed: ret=%ld\n", __func__,
 			PTR_ERR(idxd_desc));
-		return PTR_ERR(idxd_desc);
+		return ret;
 	}
 	desc = idxd_desc->iax_hw;
 
@@ -1948,21 +1916,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = false;
-
-		dev_dbg(dev, "%s: use_async_irq compression mode %s,"
-			" src_addr %llx, dst_addr %llx\n", __func__,
-			active_compression_mode->name,
-			src_addr, dst_addr);
 	}
 
-	dev_dbg(dev, "%s: decompression mode %s,"
-		" desc->src1_addr %llx, desc->src1_size %d,"
-		" desc->dst_addr %llx, desc->max_dst_size %d,"
-		" desc->src2_addr %llx, desc->src2_size %d\n", __func__,
-		active_compression_mode->name,
-		desc->src1_addr, desc->src1_size, desc->dst_addr,
-		desc->max_dst_size, desc->src2_addr, desc->src2_size);
-
 	ret = idxd_submit_desc(wq, idxd_desc);
 	if (ret) {
 		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
@@ -1975,7 +1930,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	if (ctx->async_mode) {
 		ret = -EINPROGRESS;
-		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
 	}
 
@@ -1997,23 +1951,19 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		}
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
+
+		/* Update stats */
+		update_total_decomp_bytes_in(slen);
+		update_wq_decomp_bytes(wq, slen);
 	}
 
 	*dlen = req->dlen;
 
-	if (!ctx->async_mode)
+err:
+	if (idxd_desc)
 		idxd_free_desc(wq, idxd_desc);
-
-	/* Update stats */
-	update_total_decomp_bytes_in(slen);
-	update_wq_decomp_bytes(wq, slen);
 out:
 	return ret;
-err:
-	idxd_free_desc(wq, idxd_desc);
-	dev_dbg(dev, "iaa decompress failed: ret=%d\n", ret);
-
-	goto out;
 }
 
 static int iaa_comp_acompress(struct acomp_req *req)
@@ -2060,9 +2010,6 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		goto out;
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
-		req->src, req->slen, sg_dma_len(req->src));
 
 	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
 	if (nr_sgs <= 0 || nr_sgs > 1) {
@@ -2073,9 +2020,6 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		goto err_map_dst;
 	}
 	dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", dst_addr, nr_sgs,
-		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_compress(tfm, req, wq, src_addr, req->slen, dst_addr,
 			   &req->dlen);
@@ -2090,7 +2034,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		}
 
 		ret = iaa_compress_verify(tfm, req, wq, src_addr, req->slen,
-					  dst_addr, &req->dlen);
+					  dst_addr, req->dlen);
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
 
@@ -2153,9 +2097,6 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		goto out;
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
-		req->src, req->slen, sg_dma_len(req->src));
 
 	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
 	if (nr_sgs <= 0 || nr_sgs > 1) {
@@ -2166,9 +2107,6 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		goto err_map_dst;
 	}
 	dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", dst_addr, nr_sgs,
-		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
 			     dst_addr, &req->dlen);
-- 
2.27.0


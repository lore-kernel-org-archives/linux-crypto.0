Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463A92472BB;
	Fri, 26 Sep 2025 03:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758857711; cv=none; b=dx9NC4XgOGZxyF7dbw19PyOktWLbbQGToHHLVBDIxfV5zakO4ERW3viyUAhlA1OYeAzfWJ5CAYqSqT/z+MYgi2IHPqd4XuHxFziUvyd3Fe2qV1S0uZOaQ4sz9RXiUOSFMx8Cbsqpj7sRqgXW7Yc6+u5LrLdf0lGYsb++IKhR1dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758857711; c=relaxed/simple;
	bh=wd7fVPxR6RBZDaBBnSS4xf4KqsHFpNau8JbUhMchEpE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MoHGw+jsgU2//00CLOZR8RisIdVqWda3xc+HSCKOt4EJnegtqcbo7Gz9ApSxc08I3Ur4Ppu5xqPfseTaHET5Jr7C5eJXRQe0d2tQrDjQibwVQx2AuRHG6LURbb+NbyfVl1sePeDQwzetjf6lHY3uEeDgCJtN5LD6WHQnaOc2oNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eEmStbz4; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eEmStbz4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857709; x=1790393709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wd7fVPxR6RBZDaBBnSS4xf4KqsHFpNau8JbUhMchEpE=;
  b=eEmStbz4Fksge6ump8vx6r/E0mX1aKj3YCWYZZcuiDsdoa2afLF4G/oT
   EwiDkDTtvKnkPNnD0a2RQAd21r0R14u0e1EFVQQgl5+Fs7vJvvO6QfvkX
   ss6qL7MbdJorleW+KUDKQ/Xe+sIuIq4xpK7GwsUpyj5gUai9VrWZTWrJB
   0lh9uMKlSpu9AmjKlXTdxBSyMrKLUr9KxJ8RYurrFC3WND2BBOC6RbFr0
   hv/5xuCkqIK7/AoRamhVwEyteD5ODqOaKTKrHw5V5aGTsK9kEvkm3YXCT
   F6V/1l2A/9/7DBhY0BUauyMESg4IsifRHb2tjQMc3fJMpTrOqR+4bEzxZ
   g==;
X-CSE-ConnectionGUID: oIiAF/evTQanNd1DCpRSOg==
X-CSE-MsgGUID: CVcb3nvaSH+n3do83fQP7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819451"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819451"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:05 -0700
X-CSE-ConnectionGUID: +EGlOjRNRo+zmsaE28U3tQ==
X-CSE-MsgGUID: LvlZUYaBQeOZdYF/jnSQ6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636552"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:03 -0700
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
Subject: [PATCH v12 03/23] crypto: iaa - Simplify, consistency of function parameters, minor stats bug fix.
Date: Thu, 25 Sep 2025 20:34:42 -0700
Message-Id: <20250926033502.7486-4-kanchana.p.sridhar@intel.com>
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

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 107 +++++----------------
 1 file changed, 22 insertions(+), 85 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index c6db721eaa79..ed3325bb3291 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1590,7 +1590,7 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
-			       dma_addr_t dst_addr, unsigned int *dlen)
+			       dma_addr_t dst_addr, unsigned int dlen)
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -1614,10 +1614,8 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 
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
 
@@ -1629,19 +1627,11 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1664,14 +1654,10 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1751,7 +1737,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 		}
 
 		ret = iaa_compress_verify(ctx->tfm, ctx->req, iaa_wq->wq, src_addr,
-					  ctx->req->slen, dst_addr, &ctx->req->dlen);
+					  ctx->req->slen, dst_addr, ctx->req->dlen);
 		if (ret) {
 			dev_dbg(dev, "%s: compress verify failed ret=%d\n", __func__, ret);
 			err = -EIO;
@@ -1777,7 +1763,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	iaa_wq_put(idxd_desc->wq);
 }
 
-static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
+static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
 			dma_addr_t dst_addr, unsigned int *dlen)
@@ -1804,9 +1790,9 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
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
 
@@ -1832,21 +1818,8 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
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
@@ -1859,7 +1832,6 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	if (ctx->async_mode) {
 		ret = -EINPROGRESS;
-		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
 	}
 
@@ -1877,15 +1849,10 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
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
@@ -1914,10 +1881,10 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
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
 
@@ -1941,21 +1908,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1968,7 +1922,6 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	if (ctx->async_mode) {
 		ret = -EINPROGRESS;
-		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
 	}
 
@@ -1990,23 +1943,19 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -2053,9 +2002,6 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		goto out;
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
-		req->src, req->slen, sg_dma_len(req->src));
 
 	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
 	if (nr_sgs <= 0 || nr_sgs > 1) {
@@ -2066,9 +2012,6 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		goto err_map_dst;
 	}
 	dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", dst_addr, nr_sgs,
-		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_compress(tfm, req, wq, src_addr, req->slen, dst_addr,
 			   &req->dlen);
@@ -2083,7 +2026,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		}
 
 		ret = iaa_compress_verify(tfm, req, wq, src_addr, req->slen,
-					  dst_addr, &req->dlen);
+					  dst_addr, req->dlen);
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
 
@@ -2146,9 +2089,6 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		goto out;
 	}
 	src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", src_addr, nr_sgs,
-		req->src, req->slen, sg_dma_len(req->src));
 
 	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
 	if (nr_sgs <= 0 || nr_sgs > 1) {
@@ -2159,9 +2099,6 @@ static int iaa_comp_adecompress(struct acomp_req *req)
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


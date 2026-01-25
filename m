Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B192236F2;
	Sun, 25 Jan 2026 03:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312152; cv=none; b=bW+pPpkKMJrsFxORAPWV3tLMW6EBtNY8F37G1AQZN/D1Gkg839FJ3+sF8CfFq4V1S7nkNWICdKjq542WyNbaHrck/sdvFMuPvP/FaXubfAszLH2v1M5+JpfOMjVqwokcJWMhEMSeevaBjRloeyt83RMJVkiAPFGcMFT7hYKbCFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312152; c=relaxed/simple;
	bh=uouKU0vsxu25WjgQZAwJOmR1+ifiHlkSgXwdMLeZ+pA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jw924QGZlSjnE9FWY9fjIJrH8oRr25jAsdkxR9j060c5OVlYQoNonVbK8E/9S/0QHAaHgBSLmUPt9VKLEr7C3dYumwjmR2I/jlHtuD03p3zW6KQdAp92oa4wWZDjMBEv3YBZ1+wZi48Oi2dMYbjOzfS46YsCCpOS7PXREGyboDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NNHO8b2p; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NNHO8b2p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312150; x=1800848150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uouKU0vsxu25WjgQZAwJOmR1+ifiHlkSgXwdMLeZ+pA=;
  b=NNHO8b2pM7jjdH0WqEO4dTo/aeO1tBTe6i+0flVSahbfgHHTdYaD6uL7
   GHLu2xZTiZqWdqD4RhxwoEo6Xvvdy0vbiPITLI28YQCg1zHLNFg7rORAN
   eLm8ssE9G9agzRITCk4t3jW813N9Q1NQMa35plmd30+KF9davNoyqBMec
   KJpqd4rh2hS0jgE/LnjlGDMa80aQ8tOfbXAl/W8meTkWo4vm6ja63vZjL
   2pVjMLMt2rxptXePIP3tbNtPanHK5gyndLsq4ZGJIBVbArQPsWYIWDfEl
   MqcqkMTALqPB8RzhoGDvgfH15NR4UvvYGRfTelG/5MA+SCIKy15W63A7T
   w==;
X-CSE-ConnectionGUID: qc8z0+iiTTus0GP6RSwdkw==
X-CSE-MsgGUID: 2ezXkovpRKCqh4ueAmyCHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887403"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887403"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:49 -0800
X-CSE-ConnectionGUID: dKiPaKA3Rcepklzio8wAkQ==
X-CSE-MsgGUID: ymmFnGsSSOiKenGczLpWyA==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:48 -0800
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
Subject: [PATCH v14 07/26] crypto: iaa - Simplify the code flow in iaa_compress() and iaa_decompress().
Date: Sat, 24 Jan 2026 19:35:18 -0800
Message-Id: <20260125033537.334628-8-kanchana.p.sridhar@intel.com>
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

This commit simplifies and streamlines the logic in the core
iaa_compress() and iaa_decompress() routines, eliminates branches, etc.

This makes it easier to add improvements such as asynchronous
submissions and polling for job completions, essential to accomplish
batching with hardware parallelism.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 114 ++++++++++++---------
 1 file changed, 67 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 01d7150dbbd8..a727496d5791 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1800,7 +1800,34 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->src2_size = sizeof(struct aecs_comp_table_record);
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	if (ctx->use_irq) {
+	if (likely(!ctx->use_irq)) {
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto out;
+		}
+
+		/* Update stats */
+		update_total_comp_calls();
+		update_wq_comp_calls(wq);
+
+		if (ctx->async_mode)
+			return -EINPROGRESS;
+
+		ret = check_completion(dev, idxd_desc->iax_completion, true, false);
+		if (ret) {
+			dev_dbg(dev, "check_completion failed ret=%d\n", ret);
+			goto out;
+		}
+
+		*dlen = idxd_desc->iax_completion->output_size;
+
+		/* Update stats */
+		update_total_comp_bytes_out(*dlen);
+		update_wq_comp_bytes(wq, *dlen);
+
+		*compression_crc = idxd_desc->iax_completion->crc;
+	} else {
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
 		idxd_desc->crypto.req = req;
@@ -1808,40 +1835,23 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = true;
-	}
-
-	ret = idxd_submit_desc(wq, idxd_desc);
-	if (ret) {
-		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto err;
-	}
 
-	/* Update stats */
-	update_total_comp_calls();
-	update_wq_comp_calls(wq);
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto out;
+		}
 
-	if (ctx->async_mode) {
-		ret = -EINPROGRESS;
-		goto out;
-	}
+		/* Update stats */
+		update_total_comp_calls();
+		update_wq_comp_calls(wq);
 
-	ret = check_completion(dev, idxd_desc->iax_completion, true, false);
-	if (ret) {
-		dev_dbg(dev, "check_completion failed ret=%d\n", ret);
-		goto err;
+		return -EINPROGRESS;
 	}
 
-	*dlen = idxd_desc->iax_completion->output_size;
-
-	/* Update stats */
-	update_total_comp_bytes_out(*dlen);
-	update_wq_comp_bytes(wq, *dlen);
-
-	*compression_crc = idxd_desc->iax_completion->crc;
-
-err:
-	idxd_free_desc(wq, idxd_desc);
 out:
+	idxd_free_desc(wq, idxd_desc);
+
 	return ret;
 }
 
@@ -1896,7 +1906,22 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->src1_size = slen;
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	if (ctx->use_irq) {
+	if (likely(!ctx->use_irq)) {
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto fallback_software_decomp;
+		}
+
+		/* Update stats */
+		update_total_decomp_calls();
+		update_wq_decomp_calls(wq);
+
+		if (ctx->async_mode)
+			return -EINPROGRESS;
+
+		ret = check_completion(dev, idxd_desc->iax_completion, false, false);
+	} else {
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
 		idxd_desc->crypto.req = req;
@@ -1904,25 +1929,20 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = false;
-	}
 
-	ret = idxd_submit_desc(wq, idxd_desc);
-	if (ret) {
-		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto fallback_software_decomp;
-	}
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto fallback_software_decomp;
+		}
 
-	/* Update stats */
-	update_total_decomp_calls();
-	update_wq_decomp_calls(wq);
+		/* Update stats */
+		update_total_decomp_calls();
+		update_wq_decomp_calls(wq);
 
-	if (ctx->async_mode) {
-		ret = -EINPROGRESS;
-		goto out;
+		return -EINPROGRESS;
 	}
 
-	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
-
 fallback_software_decomp:
 	if (ret) {
 		dev_dbg(dev, "%s: desc allocation/submission/check_completion failed ret=%d\n", __func__, ret);
@@ -1937,7 +1957,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		if (ret) {
 			pr_err("%s: iaa decompress failed: deflate-generic fallback error ret=%d\n",
 			       __func__, ret);
-			goto err;
+			goto out;
 		}
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
@@ -1949,10 +1969,10 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	*dlen = req->dlen;
 
-err:
+out:
 	if (idxd_desc)
 		idxd_free_desc(wq, idxd_desc);
-out:
+
 	return ret;
 }
 
-- 
2.27.0


Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F7A225783;
	Thu,  6 Feb 2025 07:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826474; cv=none; b=MncEyUxSnliEHk4+FtqOY2AJP2wmroGpi8wstVM9UBScPsmEdwWlGj3/ifDRIXlDqUgNeLj6JJzCVpgnT23f9IUWmrBizBxbBuExJRPmXMLuuS6F/ZNJQ97z12nu0efJhYia+AfZqx9+4FBnxCBAV/eQ0NXQCkow4Wyw/Kogobk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826474; c=relaxed/simple;
	bh=N5FH+kdEATUlMgFfKUdUQJnWoZvD4Wvii2jQxOoHG0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F+g7dA9fVu7nuSb8JzlOuv8lH+f+Se4Aw5bRhO0MqKgPxfdfe3s9+w2tQJ+eq8eOstTGeyjQrbVrzYtKWPhvUipvWnCR/EQLvPocyw0Vy6NqeOCh3qYyZL8t9S+WPwmes0Y/6joqTntyIAE6opuH+mlyp81WXCyXlbMMdMJZ/hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bl3Nkfmn; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bl3Nkfmn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738826473; x=1770362473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N5FH+kdEATUlMgFfKUdUQJnWoZvD4Wvii2jQxOoHG0g=;
  b=Bl3Nkfmn07rmnF6kT7nAOiUqg7qYZrsk24ih+MRCDbza6cJVDDVDlWZ1
   YuZAQhf0Op9eXx85A7mfv2wZeplKLOp7qlg8huAC4ocE1d2rrcsvBxNi1
   cKJ6vSbgSAr3dxo7v8uIuruBykFTjoOmBSaKR2kdSx5M1DW3Pr0Xrsap7
   LVMVR0V9/Kk1sw9JRwGtS9DOF6kzOUtqqlA65Nj4USU5SPgyzht1G0ghD
   pnu1+Y1aPKzidnVM7gCSHzzbkXJMn6ov72fKX85wjnW1FjY83kxlBuvK5
   6RcvwWSAGTPlG/vcsOR01UjqHWgKj0AlqVULY2jMAzOTxg5uqtCEWpnT3
   g==;
X-CSE-ConnectionGUID: mjO+FTt/TLKnUynqb9+1aw==
X-CSE-MsgGUID: bIbuL7QhSjSSM1vjN+MkTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="56962710"
X-IronPort-AV: E=Sophos;i="6.13,263,1732608000"; 
   d="scan'208";a="56962710"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 23:21:05 -0800
X-CSE-ConnectionGUID: 6++sgLdmQ82mgLCGkPkmNA==
X-CSE-MsgGUID: TSTCr4N2SO6ManNSMSYRPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112022628"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 05 Feb 2025 23:21:05 -0800
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
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v6 10/16] crypto: iaa - Descriptor allocation timeouts with mitigations in iaa_crypto.
Date: Wed,  5 Feb 2025 23:20:56 -0800
Message-Id: <20250206072102.29045-11-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch modifies the descriptor allocation from blocking to non-blocking
with bounded retries or "timeouts".

This is necessary to prevent task blocked errors with higher
compress/decompress batch-sizes in high contention scenarios, for instance,
when the platform has only 1 IAA device enabled. With 1 IAA device enabled
per package on a dual-package SPR with 56 cores/package, there are 112
logical cores mapped to this single IAA device. In this scenario, the task
blocked errors can occur because idxd_alloc_desc() is called with
IDXD_OP_BLOCK. Any process that is able to obtain IAA_CRYPTO_MAX_BATCH_SIZE
(8UL) descriptors, will cause contention for allocating descriptors for all
other processes. Under IDXD_OP_BLOCK, this can cause compress/decompress
jobs to stall in stress test scenarios (e.g. zswap_store() of 2M folios).

In order to make the iaa_crypto driver be more fail-safe, this commit
implements the following:

1) Change compress/decompress descriptor allocations to be non-blocking
   with retries ("timeouts").
2) Return compress error to zswap if descriptor allocation with timeouts
   fails during compress ops. zswap_store() will return an error and the
   folio gets stored in the backing swap device.
3) Fallback to software decompress if descriptor allocation with timeouts
   fails during decompress ops.
4) Bug fixes for freeing the descriptor consistently in all error cases.

With these fixes, there are no task blocked errors seen under stress
testing conditions, and no performance degradation observed.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |  3 +
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 81 +++++++++++++---------
 2 files changed, 51 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index c46c70ecf355..b175e9065025 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -21,6 +21,9 @@
 
 #define IAA_COMPLETION_TIMEOUT		1000000
 
+#define IAA_ALLOC_DESC_COMP_TIMEOUT	   1000
+#define IAA_ALLOC_DESC_DECOMP_TIMEOUT	    500
+
 #define IAA_ANALYTICS_ERROR		0x0a
 #define IAA_ERROR_DECOMP_BUF_OVERFLOW	0x0b
 #define IAA_ERROR_COMP_BUF_OVERFLOW	0x19
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 4ca9028d6050..5292d8f7ebd6 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1406,6 +1406,7 @@ static int deflate_generic_decompress(struct acomp_req *req)
 	void *src, *dst;
 	int ret;
 
+	req->dlen = PAGE_SIZE;
 	src = kmap_local_page(sg_page(req->src)) + req->src->offset;
 	dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
 
@@ -1469,7 +1470,8 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	int alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1485,7 +1487,11 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
 
-	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
+	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < IAA_ALLOC_DESC_DECOMP_TIMEOUT)) {
+		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
+		cpu_relax();
+	}
+
 	if (IS_ERR(idxd_desc)) {
 		dev_dbg(dev, "idxd descriptor allocation failed\n");
 		dev_dbg(dev, "iaa compress failed: ret=%ld\n",
@@ -1661,7 +1667,8 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	int alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1677,7 +1684,11 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
 
-	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
+	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < IAA_ALLOC_DESC_COMP_TIMEOUT)) {
+		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
+		cpu_relax();
+	}
+
 	if (IS_ERR(idxd_desc)) {
 		dev_dbg(dev, "idxd descriptor allocation failed\n");
 		dev_dbg(dev, "iaa compress failed: ret=%ld\n", PTR_ERR(idxd_desc));
@@ -1753,15 +1764,10 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 
 	*compression_crc = idxd_desc->iax_completion->crc;
 
-	if (!ctx->async_mode || disable_async)
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
@@ -1773,7 +1779,8 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
+	struct idxd_desc *idxd_desc = ERR_PTR(-EAGAIN);
+	int alloc_desc_retries = 0;
 	struct iax_hw_desc *desc;
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
@@ -1789,12 +1796,18 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
 
-	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
+	while ((idxd_desc == ERR_PTR(-EAGAIN)) && (alloc_desc_retries++ < IAA_ALLOC_DESC_DECOMP_TIMEOUT)) {
+		idxd_desc = idxd_alloc_desc(wq, IDXD_OP_NONBLOCK);
+		cpu_relax();
+	}
+
 	if (IS_ERR(idxd_desc)) {
 		dev_dbg(dev, "idxd descriptor allocation failed\n");
 		dev_dbg(dev, "iaa decompress failed: ret=%ld\n",
 			PTR_ERR(idxd_desc));
-		return PTR_ERR(idxd_desc);
+		ret = PTR_ERR(idxd_desc);
+		idxd_desc = NULL;
+		goto fallback_software_decomp;
 	}
 	desc = idxd_desc->iax_hw;
 
@@ -1837,7 +1850,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	ret = idxd_submit_desc(wq, idxd_desc);
 	if (ret) {
 		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto err;
+		goto fallback_software_decomp;
 	}
 
 	/* Update stats */
@@ -1851,19 +1864,20 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	}
 
 	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
+
+fallback_software_decomp:
 	if (ret) {
-		dev_dbg(dev, "%s: check_completion failed ret=%d\n", __func__, ret);
-		if (idxd_desc->iax_completion->status == IAA_ANALYTICS_ERROR) {
+		dev_dbg(dev, "%s: desc allocation/submission/check_completion failed ret=%d\n", __func__, ret);
+		if (idxd_desc && idxd_desc->iax_completion->status == IAA_ANALYTICS_ERROR) {
 			pr_warn("%s: falling back to deflate-generic decompress, "
 				"analytics error code %x\n", __func__,
 				idxd_desc->iax_completion->error_code);
-			ret = deflate_generic_decompress(req);
-			if (ret) {
-				dev_dbg(dev, "%s: deflate-generic failed ret=%d\n",
-					__func__, ret);
-				goto err;
-			}
-		} else {
+		}
+
+		ret = deflate_generic_decompress(req);
+
+		if (ret) {
+			pr_err("%s: iaa decompress failed: fallback to deflate-generic software decompress error ret=%d\n", __func__, ret);
 			goto err;
 		}
 	} else {
@@ -1872,19 +1886,15 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	*dlen = req->dlen;
 
-	if (!ctx->async_mode || disable_async)
-		idxd_free_desc(wq, idxd_desc);
-
 	/* Update stats */
 	update_total_decomp_bytes_in(slen);
 	update_wq_decomp_bytes(wq, slen);
+
+err:
+	if (idxd_desc)
+		idxd_free_desc(wq, idxd_desc);
 out:
 	return ret;
-err:
-	idxd_free_desc(wq, idxd_desc);
-	dev_dbg(dev, "iaa decompress failed: ret=%d\n", ret);
-
-	goto out;
 }
 
 static int iaa_comp_acompress(struct acomp_req *req)
@@ -2375,6 +2385,7 @@ static bool iaa_comp_acompress_batch(
 			if (errors[i] != -EINPROGRESS) {
 				errors[i] = -EINVAL;
 				err = -EINVAL;
+				pr_debug("%s desc was not submitted\n", __func__);
 			} else {
 				errors[i] = -EAGAIN;
 			}
@@ -2521,9 +2532,13 @@ static bool iaa_comp_adecompress_batch(
 		} else {
 			errors[i] = iaa_comp_adecompress(reqs[i]);
 
+			/*
+			 * If it failed desc allocation/submission, errors[i] can
+			 * be 0 or error value from software decompress.
+			 */
 			if (errors[i] != -EINPROGRESS) {
-				errors[i] = -EINVAL;
 				err = -EINVAL;
+				pr_debug("%s desc was not submitted\n", __func__);
 			} else {
 				errors[i] = -EAGAIN;
 			}
-- 
2.27.0


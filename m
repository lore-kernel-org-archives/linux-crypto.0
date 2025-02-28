Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A2E25D205;
	Fri, 28 Feb 2025 10:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736836; cv=none; b=JW6HyB2eRAp6cNkj3YISiOHq5i4rbG2/QYbkMGmC2zVm2Ai/Xxw7wJiihXVCW3DEYHAayOL1/gJMcO+z5qFwm/jz+ZhaZz5nJpgnP5/2QZRK1oQybyWiLd+xsYvi2nHOT5iBBXvwpL8YV/Xns3kzFk05Sa27Dqu8CunFEJtxJLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736836; c=relaxed/simple;
	bh=xzJxxiFYwAjT5Xrqds5C/407QeaiWfMMqcMGCN4vRiA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JwQywMUWkv4C1m9aVK6AqsnDggLTWrUFqhvmkBuerxKGq3Xstkf2IyWNsxDZDWMKLy3rmxuOWpu7yQAIh0ol2M5iLFeFRFa18H/FIWm3QEzZ/aFXVv65KOT2v0zdykiy5FnoCejPVbrsC8h35CyWfiAFHkLtMwMRPwYiNWV6aMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gCzmiGX4; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gCzmiGX4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736834; x=1772272834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xzJxxiFYwAjT5Xrqds5C/407QeaiWfMMqcMGCN4vRiA=;
  b=gCzmiGX49oYH14MehK8qn3L6v6z1jlxMJWsybUhuFsY5acFpxFexEVSm
   SfHxJMm18oBL8wjN5U0vsnzyWeVaOT5VlsItISlmmgV9nDUVo14Hr3flj
   hUM7qxj93CO2mxLpLxxgLDoGdBx1WhAZIkxbumrlQGtTkTjDDv84DNCZG
   EYaEaEPhHflxqS/7yovmO3rfZsd6DkO1vK9T07cluxo8KOafNhTbYpbxs
   TkcZNawWJCZXpuqHzXSFe9eAJ1sLXnr0EbBYM10S0f78eRyS73hnLiW0K
   7L/GePrW7dL9jolIAuMvKasyknIu5TxtE9CerkQxt4QZlnVvUoCH5UPZy
   A==;
X-CSE-ConnectionGUID: HP6MzRMzS5WL6gV3Lmdgqg==
X-CSE-MsgGUID: cL7zeIIaSYiykw7bkKxArQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40902679"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="40902679"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:28 -0800
X-CSE-ConnectionGUID: nOJPl9TkR3mbkH/s2qeF2g==
X-CSE-MsgGUID: wuLPm5x3S/61atdiUPCorw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="117325736"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 28 Feb 2025 02:00:28 -0800
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
Subject: [PATCH v7 10/15] crypto: iaa - Descriptor allocation timeouts with mitigations in iaa_crypto.
Date: Fri, 28 Feb 2025 02:00:19 -0800
Message-Id: <20250228100024.332528-11-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
References: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch modifies the descriptor allocation from blocking to non-blocking
with bounded retries or "timeouts".

This is necessary to prevent task blocked errors in high contention
scenarios, for instance, when the platform has only 1 IAA device
enabled. With 1 IAA device enabled per package on a dual-package SPR with
56 cores/package, there are 112 logical cores mapped to this single IAA
device. In this scenario, the task blocked errors can occur because
idxd_alloc_desc() is called with IDXD_OP_BLOCK. Any process that is able to
obtain IAA_CRYPTO_MAX_BATCH_SIZE (8U) descriptors, will cause contention
for allocating descriptors for all other processes. Under IDXD_OP_BLOCK,
this can cause compress/decompress jobs to stall in stress test scenarios
(e.g. zswap_store() of 2M folios).

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
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 74 ++++++++++++----------
 2 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 5f38f530c33d..de14e5e2a017 100644
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
index cb96897e7fed..7503fafca279 100644
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
-- 
2.27.0


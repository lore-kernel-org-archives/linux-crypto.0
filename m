Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A5C1F4612;
	Fri,  1 Aug 2025 04:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023014; cv=none; b=JRLSY3CAeoejtmys+MrkMLBWoXvfLHr21Eoe4cKYXKj1zOJUGOR54hhEaHrFif/lcLmFjn7WpD96h9tdevbcaF5tCSwKHBEuaqpF7hAWXbjZgZZGMMET/hu+OCL2xDcxpjSJUiuCv9gnM9rczOH5y2Ru0JmQO2cMloyiW1iigfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023014; c=relaxed/simple;
	bh=EHRV1i0kscwsN0ARbX38Rrgo1/s26b8T5aeEMDGCmlU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MobQ9segLzA7qdVRLpeHnqQuo7dCLSznmRGXDk5OFuMmg41LJcvmKtgnqzuc9pziv4G+Mw1p076Voq3GyN5dftLbnfDEBjkKSkWk+Wm2S6MuyIKapik1oLK8zaNbmVlXIKGlKvjIBYrGAQLqrk1G6woatIIRQSOBmgFpTjXwpiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SKmtzFdJ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SKmtzFdJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023013; x=1785559013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EHRV1i0kscwsN0ARbX38Rrgo1/s26b8T5aeEMDGCmlU=;
  b=SKmtzFdJpYXRnnqj1DhkSAo/VoF62KQFOaApuZAweTqHvh/PJS5BuLaB
   3jBkEG5xJk7eh7CXllUehVQnjGpzTWKWseHOzX1jaD2EWymongfag7yTa
   yXBuPX4OW7T11HVS323ZUawSPBsUsHEntUauWLlHbsr6Sdz39EHnE4BVF
   GgpRf6An5Fl7pcbeep9NlOvP7LvH2y0tB3kR6uW4WyEX00/TiGs0kHdnq
   o8aVIir3G7Tw0jj8bQgWf0BklepU3ngBrBHBY9PhNufRmMdQ7CM/XvJI4
   xyRebA+QnGplxd58dGSLYvKPOLk5DHadWd6sB11RveanmBEbjQ595DH/F
   w==;
X-CSE-ConnectionGUID: wj8DsA/OSH6mqxgsF8/Eyw==
X-CSE-MsgGUID: 89yqV+PpSreW2cD7dLnHuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820234"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820234"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:44 -0700
X-CSE-ConnectionGUID: ZFXyZA/mTgSl9sNgr3jntg==
X-CSE-MsgGUID: VUq+bsOhQ5yh7b9rbL9dNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796249"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:44 -0700
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
Subject: [PATCH v11 08/24] crypto: iaa - Simplified, efficient job submissions for non-irq mode.
Date: Thu, 31 Jul 2025 21:36:26 -0700
Message-Id: <20250801043642.8103-9-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds a new procedure, iaa_submit_desc_movdir64b(), that
directly calls movdir64b. The core iaa_crypto routines that submit
compress and decompress jobs now invoke iaa_submit_desc_movdir64b() in
non-irq driver modes, instead of idxd_submit_desc().

idxd_submit_desc() is called only in irq mode.

This improves latency for the most commonly used iaa_crypto usage
(i.e., async non-irq) in zswap/zram by eliminating redundant computes
that would otherwise be incurred in idxd_submit_desc():

  p50: -32 ns
  p99: -1,048 ns

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 30 ++++++++++++++--------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index a9e6809e63dff..63d0cb4015433 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1782,6 +1782,24 @@ iaa_setup_decompress_hw_desc(struct idxd_desc *idxd_desc,
 	return desc;
 }
 
+/*
+ * Call this for non-irq, non-enqcmds job submissions.
+ */
+static __always_inline void iaa_submit_desc_movdir64b(struct idxd_wq *wq,
+						     struct idxd_desc *desc)
+{
+	void __iomem *portal = idxd_wq_portal_addr(wq);
+
+	/*
+	 * The wmb() flushes writes to coherent DMA data before
+	 * possibly triggering a DMA read. The wmb() is necessary
+	 * even on UP because the recipient is a device.
+	 */
+	wmb();
+
+	iosubmit_cmds512(portal, desc->hw, 1);
+}
+
 static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
@@ -1820,11 +1838,7 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 					  ctx->mode, iaa_device->compression_modes[ctx->mode]);
 
 	if (likely(!ctx->use_irq)) {
-		ret = idxd_submit_desc(wq, idxd_desc);
-		if (ret) {
-			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-			goto out;
-		}
+		iaa_submit_desc_movdir64b(wq, idxd_desc);
 
 		/* Update stats */
 		update_total_comp_calls();
@@ -1912,11 +1926,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc = iaa_setup_decompress_hw_desc(idxd_desc, src_addr, slen, dst_addr, *dlen);
 
 	if (likely(!ctx->use_irq)) {
-		ret = idxd_submit_desc(wq, idxd_desc);
-		if (ret) {
-			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-			goto fallback_software_decomp;
-		}
+		iaa_submit_desc_movdir64b(wq, idxd_desc);
 
 		/* Update stats */
 		update_total_decomp_calls();
-- 
2.27.0


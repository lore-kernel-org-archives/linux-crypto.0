Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC5C220698;
	Sun, 25 Jan 2026 03:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312155; cv=none; b=aSw91Dtb0oUj+zPrq5YIzBIslwH/mlpa3Rq4v1xbOCmbXUCnZ8fcOpqIygbKwhHO5Ov4Hqs9VyLRuJYu/S7XPIloyfKWshnokYYmU7/48aYZZM/Ca5+48TLqo+U31kuJ8GBY1ZNXVs/I+qsNh0sHGE5vZSp+6UgHcho3/wCEJKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312155; c=relaxed/simple;
	bh=TXS6CTscafJd3lQMfTmunv6KR6knJ1F1wFy/sJU25Y8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z81w33RJGMPeI/Nx7ulWJCXTs/a5eHGlWTMgM/M6isHlTbkgwvGNjZABLOVDzEtjMBnEkzbIC77Jv8v1FeOSfIJbPiGLxmHvtuea/LHbEF/onsYyMsMr8Ux2IdHcHNVMcuNhiH5nwv0TJBKr0AN1UqSjU9vSRDx7zlADhlYiw5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X3YI5ACt; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X3YI5ACt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312153; x=1800848153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TXS6CTscafJd3lQMfTmunv6KR6knJ1F1wFy/sJU25Y8=;
  b=X3YI5ACtCQ0Ytapa3kHWDhbVWytgdDNXebiL8mFYZuVAyt9PwQxi7CFR
   am+mtjjwXranYarUstfW1OrOahIF3xmYUNeLnZf4Sb/RWFxFdPEQlrQ69
   4fiqViCgDa46+fyp2/yr6aufgOatG97NxidUkQ496ARBANWdWP9gARe6y
   HVU3l1vipXI7p5UdHrYCwlhbagXrdNgXK5uVmU5pm6U00dzWn62fL7f4m
   8rCbD8u0JVeEWtmvTdmo6Viqm62nGl0oqhGKn+EW6ZQDCmIzBghHDrZF2
   hLfeHqFovhwyd29gKWuJzRWHSKxhNfQrUmvW3lm+CA7jYjy86OfANCd2E
   A==;
X-CSE-ConnectionGUID: GoMrlIC8RL2t8kfhY5gNyg==
X-CSE-MsgGUID: h09o1BExSJaXiMDzxVM8NQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887434"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887434"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:52 -0800
X-CSE-ConnectionGUID: k99u/6GAQNWgvmrs5Y/PeQ==
X-CSE-MsgGUID: d5166B6RSsGzE7qv4gQMbw==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:51 -0800
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
Subject: [PATCH v14 09/26] crypto: iaa - Simplified, efficient job submissions for non-irq mode.
Date: Sat, 24 Jan 2026 19:35:20 -0800
Message-Id: <20260125033537.334628-10-kanchana.p.sridhar@intel.com>
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

This patch adds a new procedure, iaa_submit_desc_movdir64b(), that
directly calls movdir64b. The core iaa_crypto routines that submit
compress and decompress jobs now invoke iaa_submit_desc_movdir64b() in
non-irq driver modes, instead of idxd_submit_desc().

idxd_submit_desc() is called only in irq mode.

This improves latency for the most commonly used iaa_crypto usage
(i.e., async non-irq) in zswap by eliminating redundant computes
that would otherwise be incurred in idxd_submit_desc():

For a single-threaded madvise-based workload with the Silesia.tar
dataset, these are the before/after batch compression latencies for a
compress batch of 8 pages:

     ==================================
                   p50 (ns)    p99 (ns)
     ==================================
     before           5,568       6,056
     after            5,472       5,848
     Change             -96        -208
     ==================================

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 30 ++++++++++++++--------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index f0e9eb52eec4..4b275cc09404 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1790,6 +1790,24 @@ iaa_setup_decompress_hw_desc(struct idxd_desc *idxd_desc,
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
@@ -1828,11 +1846,7 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1920,11 +1934,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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


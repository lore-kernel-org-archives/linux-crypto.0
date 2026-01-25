Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67E4221DB1;
	Sun, 25 Jan 2026 03:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312150; cv=none; b=qCou9AW+UGNn+/18UyZed82cJe4mE2T3j6fVCpAJid5R6dYC/pWl25uh4YUBssll0SWU3+GA0iw/nirM2oqCVkgkaR8oDnrXj3za2ZuHbH9aPtS4WZ5r9807ubmYUK9HfVN9COXbMUt6XZcyWyAgXLPIUOXBUEoWsz0oJWd6FU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312150; c=relaxed/simple;
	bh=R1d16AugdTU+dxffX7g2H/eEuKGm/v5AQk9DA55X8iI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gpBmoVo6FJukAC0wUlhzIRzR0QUUBOJHo6QsI6/S9lYmZ0CY7PEICj4pv22AM4YJAtyuoq9Kb3OIR/iPmWqEAys9rOUwPEqUiQdF9Z3j7X1TtlhZQ7xJuh7UErfGFHss77D3ksru9Ke1Fa1AQpqfCW1OdFigvUxN081Dmdn9XKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JOBoheA2; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JOBoheA2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312148; x=1800848148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R1d16AugdTU+dxffX7g2H/eEuKGm/v5AQk9DA55X8iI=;
  b=JOBoheA2fAbobiL/BiTimS0FD2TD9s98surq6ehzeinYFb/N2OyaPQDK
   J2leuHos/HXXtr+ir9SSMY0Rx6VeXl6Niw6SdG4WYMaMXUEJzRGcMIiDw
   SqOpwz6T7ZxOCJXTcmFhQHMgR/sYrHHIljgTnTuUWPrFwZ3ZQjcu3jpQF
   62fCwV6rpk8sZ85756WvAR7+d2gXMh/l/EpbD6u8eXXT1mm/9uBnl8tRi
   j2fKPcRpLgldP8WGl3DcivLcMak1djm029YwxSbSFvmORPJ+kVEeFv1us
   RaBXXOxIV0cut7oBJHwOIIwg3Pvrrzixcq0PeBI7/+w9I8QviJXvfWXos
   Q==;
X-CSE-ConnectionGUID: OPMdXpV8QHGHf5aiIhcmcQ==
X-CSE-MsgGUID: fBl3DoKUQPWqbxhEK858Kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887397"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887397"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:48 -0800
X-CSE-ConnectionGUID: aBZlt/ZORpiyo+w/FeqO9A==
X-CSE-MsgGUID: KzY5wfLsQYSG/LirKaN3ig==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:47 -0800
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
Subject: [PATCH v14 06/26] crypto: iaa - iaa_wq uses percpu_refs for get/put reference counting.
Date: Sat, 24 Jan 2026 19:35:17 -0800
Message-Id: <20260125033537.334628-7-kanchana.p.sridhar@intel.com>
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

This patch modifies the reference counting on "struct iaa_wq" to be a
percpu_ref in atomic mode, instead of an "int refcount" combined with
the "idxd->dev_lock" spin_lock currently used as a synchronization
mechanism to achieve get/put semantics.

This enables a more light-weight, cleaner and effective refcount
implementation for the iaa_wq, that prevents race conditions and
significantly reduces batch compress/decompress latency submitted to
the IAA accelerator.

For a single-threaded madvise-based workload with the Silesia.tar
dataset, these are the before/after batch compression latencies for a
compress batch of 8 pages:

 ==================================
               p50 (ns)    p99 (ns)
 ==================================
 before           5,576       5,992
 after            5,472       5,848
 Change            -104        -144
 ==================================

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |   4 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 119 +++++++--------------
 2 files changed, 41 insertions(+), 82 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index cc76a047b54a..9611f2518f42 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -47,8 +47,8 @@ struct iaa_wq {
 	struct list_head	list;
 
 	struct idxd_wq		*wq;
-	int			ref;
-	bool			remove;
+	struct percpu_ref	ref;
+	bool			free;
 	bool			mapped;
 
 	struct iaa_device	*iaa_device;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 3466414f926a..01d7150dbbd8 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -702,7 +702,7 @@ static void del_iaa_device(struct iaa_device *iaa_device)
 
 static void free_iaa_device(struct iaa_device *iaa_device)
 {
-	if (!iaa_device)
+	if (!iaa_device || iaa_device->n_wq)
 		return;
 
 	remove_device_compression_modes(iaa_device);
@@ -732,6 +732,13 @@ static bool iaa_has_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
 	return false;
 }
 
+static void __iaa_wq_release(struct percpu_ref *ref)
+{
+	struct iaa_wq *iaa_wq = container_of(ref, typeof(*iaa_wq), ref);
+
+	iaa_wq->free = true;
+}
+
 static int add_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq,
 		      struct iaa_wq **new_wq)
 {
@@ -739,11 +746,20 @@ static int add_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq,
 	struct pci_dev *pdev = idxd->pdev;
 	struct device *dev = &pdev->dev;
 	struct iaa_wq *iaa_wq;
+	int ret;
 
 	iaa_wq = kzalloc(sizeof(*iaa_wq), GFP_KERNEL);
 	if (!iaa_wq)
 		return -ENOMEM;
 
+	ret = percpu_ref_init(&iaa_wq->ref, __iaa_wq_release,
+			      PERCPU_REF_INIT_ATOMIC, GFP_KERNEL);
+
+	if (ret) {
+		kfree(iaa_wq);
+		return -ENOMEM;
+	}
+
 	iaa_wq->wq = wq;
 	iaa_wq->iaa_device = iaa_device;
 	idxd_wq_set_private(wq, iaa_wq);
@@ -819,6 +835,9 @@ static void __free_iaa_wq(struct iaa_wq *iaa_wq)
 	if (!iaa_wq)
 		return;
 
+	WARN_ON(!percpu_ref_is_zero(&iaa_wq->ref));
+	percpu_ref_exit(&iaa_wq->ref);
+
 	iaa_device = iaa_wq->iaa_device;
 	if (iaa_device->n_wq == 0)
 		free_iaa_device(iaa_wq->iaa_device);
@@ -913,53 +932,6 @@ static int save_iaa_wq(struct idxd_wq *wq)
 	return ret;
 }
 
-static int iaa_wq_get(struct idxd_wq *wq)
-{
-	struct idxd_device *idxd = wq->idxd;
-	struct iaa_wq *iaa_wq;
-	int ret = 0;
-
-	spin_lock(&idxd->dev_lock);
-	iaa_wq = idxd_wq_get_private(wq);
-	if (iaa_wq && !iaa_wq->remove) {
-		iaa_wq->ref++;
-		idxd_wq_get(wq);
-	} else {
-		ret = -ENODEV;
-	}
-	spin_unlock(&idxd->dev_lock);
-
-	return ret;
-}
-
-static int iaa_wq_put(struct idxd_wq *wq)
-{
-	struct idxd_device *idxd = wq->idxd;
-	struct iaa_wq *iaa_wq;
-	bool free = false;
-	int ret = 0;
-
-	spin_lock(&idxd->dev_lock);
-	iaa_wq = idxd_wq_get_private(wq);
-	if (iaa_wq) {
-		iaa_wq->ref--;
-		if (iaa_wq->ref == 0 && iaa_wq->remove) {
-			idxd_wq_set_private(wq, NULL);
-			free = true;
-		}
-		idxd_wq_put(wq);
-	} else {
-		ret = -ENODEV;
-	}
-	spin_unlock(&idxd->dev_lock);
-	if (free) {
-		__free_iaa_wq(iaa_wq);
-		kfree(iaa_wq);
-	}
-
-	return ret;
-}
-
 /***************************************************************
  * Mapping IAA devices and wqs to cores with per-cpu wq_tables.
  ***************************************************************/
@@ -1773,7 +1745,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 
 	if (free_desc)
 		idxd_free_desc(idxd_desc->wq, idxd_desc);
-	iaa_wq_put(idxd_desc->wq);
+	percpu_ref_put(&iaa_wq->ref);
 }
 
 static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
@@ -2004,19 +1976,13 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	cpu = get_cpu();
 	wq = comp_wq_table_next_wq(cpu);
 	put_cpu();
-	if (!wq) {
-		pr_debug("no wq configured for cpu=%d\n", cpu);
-		return -ENODEV;
-	}
 
-	ret = iaa_wq_get(wq);
-	if (ret) {
+	iaa_wq = wq ? idxd_wq_get_private(wq) : NULL;
+	if (unlikely(!iaa_wq || !percpu_ref_tryget(&iaa_wq->ref))) {
 		pr_debug("no wq available for cpu=%d\n", cpu);
 		return -ENODEV;
 	}
 
-	iaa_wq = idxd_wq_get_private(wq);
-
 	dev = &wq->idxd->pdev->dev;
 
 	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
@@ -2069,7 +2035,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 err_map_dst:
 	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 out:
-	iaa_wq_put(wq);
+	percpu_ref_put(&iaa_wq->ref);
 
 	return ret;
 }
@@ -2091,19 +2057,13 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	cpu = get_cpu();
 	wq = decomp_wq_table_next_wq(cpu);
 	put_cpu();
-	if (!wq) {
-		pr_debug("no wq configured for cpu=%d\n", cpu);
-		return -ENODEV;
-	}
 
-	ret = iaa_wq_get(wq);
-	if (ret) {
+	iaa_wq = wq ? idxd_wq_get_private(wq) : NULL;
+	if (unlikely(!iaa_wq || !percpu_ref_tryget(&iaa_wq->ref))) {
 		pr_debug("no wq available for cpu=%d\n", cpu);
-		return -ENODEV;
+		return deflate_generic_decompress(req);
 	}
 
-	iaa_wq = idxd_wq_get_private(wq);
-
 	dev = &wq->idxd->pdev->dev;
 
 	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
@@ -2138,7 +2098,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 err_map_dst:
 	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 out:
-	iaa_wq_put(wq);
+	percpu_ref_put(&iaa_wq->ref);
 
 	return ret;
 }
@@ -2311,7 +2271,6 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 	struct idxd_wq *wq = idxd_dev_to_wq(idxd_dev);
 	struct idxd_device *idxd = wq->idxd;
 	struct iaa_wq *iaa_wq;
-	bool free = false;
 
 	atomic_set(&iaa_crypto_enabled, 0);
 	idxd_wq_quiesce(wq);
@@ -2332,18 +2291,18 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 		goto out;
 	}
 
-	if (iaa_wq->ref) {
-		iaa_wq->remove = true;
-	} else {
-		wq = iaa_wq->wq;
-		idxd_wq_set_private(wq, NULL);
-		free = true;
-	}
+	/* Drop the initial reference. */
+	percpu_ref_kill(&iaa_wq->ref);
+
+	while (!iaa_wq->free)
+		cpu_relax();
+
+	__free_iaa_wq(iaa_wq);
+
+	idxd_wq_set_private(wq, NULL);
 	spin_unlock(&idxd->dev_lock);
-	if (free) {
-		__free_iaa_wq(iaa_wq);
-		kfree(iaa_wq);
-	}
+
+	kfree(iaa_wq);
 
 	idxd_drv_disable_wq(wq);
 
-- 
2.27.0


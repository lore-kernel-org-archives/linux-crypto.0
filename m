Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0D61F099C;
	Fri,  1 Aug 2025 04:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023012; cv=none; b=iadTw9RXBhGqdPvPKxOoctqI6AyY6uHSr6p1lRVckHiNXT4FsfJGoIPNZqN0D90My0qRtlSHZQET/PPhclaJn3g5cK5PEtCshmymAs9NtIU2fWz9Dwh5EbqxmNefWzLpMzwwJsMJ18MS8WtLcd5BdNRIoQ7VAKw3K+BgAUu9z2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023012; c=relaxed/simple;
	bh=Fqo5Dixe597cz0RjfYR205Y2bqbC/FYhOmDv/Hw+wpM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qwpt3rF+UWkAYUlEZHJiuE3FKmsqItpb+qx8noec5ItA+V5fBJe95GP0mJPU7sDGA0nci9L6yJ8K2kvJIiNdDRM4VRpQDq8RvkOpNA3aof9xztrRlPBPecVuXrRQ7AQtmnDtsjKCeT4uUbGg50PFnwc7x/1BeOfQoaLh1sTh/Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IEkA+FaO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IEkA+FaO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023011; x=1785559011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fqo5Dixe597cz0RjfYR205Y2bqbC/FYhOmDv/Hw+wpM=;
  b=IEkA+FaOKE+qkU9u+PxAKY3Y7aYcHmb8NwBdoSWQH7PFmEKshh4huZRz
   yGgptX2q9Qh4GbYdCs8SlbOSFARtqqTmUk7wfV24YwQrSZ7TtSSwefuO5
   CIL/7VElVf8ic2QLiXy6xEClj3Pqkp81WYfKaoKSqnGMow67i3ItMWcBk
   x+QnCzi0JGj4YCL3CTezIhYA9AyLtnI05FjeNoTfyXA/FuDy3YNsaCwez
   OXAf9j9yFOe4MeHCzkjLzk84Lli56xdtUXsEwmWaSCFo0ud7eIHm6ZY7R
   80Ntyoht4PwAp8umJjX30JGVk5Z77b9STssSVpuA3h2Ljdevpa8USDu5e
   A==;
X-CSE-ConnectionGUID: 6Xrf0+86QheMHX6mXp+8tw==
X-CSE-MsgGUID: +H3DO7i9S2OzkIHjrbjDXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820196"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820196"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:44 -0700
X-CSE-ConnectionGUID: xnJ8uAQtTYyivwxm/Nu/mQ==
X-CSE-MsgGUID: 4YXeeMATQxaXUKZ4A+fGxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796239"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:43 -0700
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
Subject: [PATCH v11 05/24] crypto: iaa - iaa_wq uses percpu_refs for get/put reference counting.
Date: Thu, 31 Jul 2025 21:36:23 -0700
Message-Id: <20250801043642.8103-6-kanchana.p.sridhar@intel.com>
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

This patch modifies the reference counting on "struct iaa_wq" to be a
percpu_ref in atomic mode, instead of an "int refcount" combined with
the "idxd->dev_lock" spin_lock currently used as a synchronization
mechanism to achieve get/put semantics.

This enables a more light-weight, cleaner and effective refcount
implementation for the iaa_wq, significantly reducing latency per
compress/decompress job submitted to the IAA accelerator:

  p50: -136 ns
  p99: -880 ns

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |   4 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 119 +++++++--------------
 2 files changed, 41 insertions(+), 82 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index cc76a047b54ad..9611f2518f42c 100644
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
index 1169cd44c8e78..a12ea3dd5ba80 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -701,7 +701,7 @@ static void del_iaa_device(struct iaa_device *iaa_device)
 
 static void free_iaa_device(struct iaa_device *iaa_device)
 {
-	if (!iaa_device)
+	if (!iaa_device || iaa_device->n_wq)
 		return;
 
 	remove_device_compression_modes(iaa_device);
@@ -731,6 +731,13 @@ static bool iaa_has_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
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
@@ -738,11 +745,20 @@ static int add_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq,
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
@@ -818,6 +834,9 @@ static void __free_iaa_wq(struct iaa_wq *iaa_wq)
 	if (!iaa_wq)
 		return;
 
+	WARN_ON(!percpu_ref_is_zero(&iaa_wq->ref));
+	percpu_ref_exit(&iaa_wq->ref);
+
 	iaa_device = iaa_wq->iaa_device;
 	if (iaa_device->n_wq == 0)
 		free_iaa_device(iaa_wq->iaa_device);
@@ -912,53 +931,6 @@ static int save_iaa_wq(struct idxd_wq *wq)
 	return 0;
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
@@ -1765,7 +1737,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 
 	if (free_desc)
 		idxd_free_desc(idxd_desc->wq, idxd_desc);
-	iaa_wq_put(idxd_desc->wq);
+	percpu_ref_put(&iaa_wq->ref);
 }
 
 static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
@@ -1996,19 +1968,13 @@ static int iaa_comp_acompress(struct acomp_req *req)
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
+	if (!iaa_wq || !percpu_ref_tryget(&iaa_wq->ref)) {
 		pr_debug("no wq available for cpu=%d\n", cpu);
 		return -ENODEV;
 	}
 
-	iaa_wq = idxd_wq_get_private(wq);
-
 	dev = &wq->idxd->pdev->dev;
 
 	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
@@ -2061,7 +2027,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 err_map_dst:
 	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 out:
-	iaa_wq_put(wq);
+	percpu_ref_put(&iaa_wq->ref);
 
 	return ret;
 }
@@ -2083,19 +2049,13 @@ static int iaa_comp_adecompress(struct acomp_req *req)
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
+	if (!iaa_wq || !percpu_ref_tryget(&iaa_wq->ref)) {
 		pr_debug("no wq available for cpu=%d\n", cpu);
-		return -ENODEV;
+		return deflate_generic_decompress(req);
 	}
 
-	iaa_wq = idxd_wq_get_private(wq);
-
 	dev = &wq->idxd->pdev->dev;
 
 	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
@@ -2130,7 +2090,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 err_map_dst:
 	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 out:
-	iaa_wq_put(wq);
+	percpu_ref_put(&iaa_wq->ref);
 
 	return ret;
 }
@@ -2303,7 +2263,6 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 	struct idxd_wq *wq = idxd_dev_to_wq(idxd_dev);
 	struct idxd_device *idxd = wq->idxd;
 	struct iaa_wq *iaa_wq;
-	bool free = false;
 
 	atomic_set(&iaa_crypto_enabled, 0);
 	idxd_wq_quiesce(wq);
@@ -2324,18 +2283,18 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
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


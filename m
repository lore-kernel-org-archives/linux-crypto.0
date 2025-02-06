Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FBB2253E3;
	Thu,  6 Feb 2025 07:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826472; cv=none; b=nXh74wxH2Ni+WqFL0fv05NPanFGsGDHkoaya1s+HavJdK5RRtmIKhy6qdO3y7taGXla025mRu3SWjvV5WzPecHz1GHEnWMhhe63w2yx2atKFTQkxF4k8oflN+SPfEF/6dSZfyJpA4lKy9V6BiHbWDmj7/qYgYsE1TknkSdpPjws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826472; c=relaxed/simple;
	bh=yBCr+FraBHYq64d9eiZRbYqzgC3sqMOsBxQBn5IGL/8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fu5ORfw58kYv/LpRoX7Ho2sjbJR7fNFCT93vxYLemL+Zo382FJlhLLGWF5gjXmtHcrvlDaMX27Iyr+TMSOIYvO/GASDyq072uDUWwBby9zXxTBkVkeX24pxUikutroUvdWLmaRmCG4YuRhgxA+V1mhs9Jn09I6J9RmYkEcky1KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iiuBDfar; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iiuBDfar"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738826470; x=1770362470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yBCr+FraBHYq64d9eiZRbYqzgC3sqMOsBxQBn5IGL/8=;
  b=iiuBDfarFcdOu5NhBWqah+M+P1NTfTgc77tRh0dESn0jL/V6Pou38e/O
   nkH0BMQxEKo+dEjquk7Edlvbf8cSRsGSqXTlepp5Yg0IgxOx5Ab0TjubG
   78+4rS7gIiikm3teuIGVW7Za6t0a2mWiEJfz4C53WmmlcotBCo2dW7Zx7
   t8fcs6rxIUY7e+d0GEPBZy9R3+F3t8Mpwr0bey3RznMcIsV950XmxH1ku
   1YiA8gSBlsZCj9rskimCeOgYtcF6M7w0+V7xeuXjLdrKv1hCfmL93LVFH
   /9JLHjsoxv+e07QDmxDn10jZbFjf/g/jxxXJi0xa5c1F/q1GiaK6LkOzz
   w==;
X-CSE-ConnectionGUID: a8rZY5sFQHWHi7fLWiDH7A==
X-CSE-MsgGUID: gIfRIuj2QRKwYGrywtQNEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="56962684"
X-IronPort-AV: E=Sophos;i="6.13,263,1732608000"; 
   d="scan'208";a="56962684"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 23:21:05 -0800
X-CSE-ConnectionGUID: LtK4e2iJTwuCI8wnN5o80Q==
X-CSE-MsgGUID: bhKYVzw+RqiEF8300phynA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112022615"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 05 Feb 2025 23:21:04 -0800
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
Subject: [PATCH v6 07/16] crypto: iaa - Re-organize the iaa_crypto driver code.
Date: Wed,  5 Feb 2025 23:20:53 -0800
Message-Id: <20250206072102.29045-8-kanchana.p.sridhar@intel.com>
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

This patch merely reorganizes the code in iaa_crypto_main.c, so that
the functions are consolidated into logically related sub-sections of
code.

This is expected to make the code more maintainable and for it to be easier
to replace functional layers and/or add new features.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 540 +++++++++++----------
 1 file changed, 275 insertions(+), 265 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index f4807a828034..2c5b7ce041d6 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -24,6 +24,9 @@
 
 #define IAA_ALG_PRIORITY               300
 
+/**************************************
+ * Driver internal global variables.
+ **************************************/
 /* number of iaa instances probed */
 static unsigned int nr_iaa;
 static unsigned int nr_cpus;
@@ -36,55 +39,46 @@ static unsigned int cpus_per_iaa;
 static struct crypto_comp *deflate_generic_tfm;
 
 /* Per-cpu lookup table for balanced wqs */
-static struct wq_table_entry __percpu *wq_table;
+static struct wq_table_entry __percpu *wq_table = NULL;
 
-static struct idxd_wq *wq_table_next_wq(int cpu)
-{
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
-
-	if (++entry->cur_wq >= entry->n_wqs)
-		entry->cur_wq = 0;
-
-	if (!entry->wqs[entry->cur_wq])
-		return NULL;
-
-	pr_debug("%s: returning wq at idx %d (iaa wq %d.%d) from cpu %d\n", __func__,
-		 entry->cur_wq, entry->wqs[entry->cur_wq]->idxd->id,
-		 entry->wqs[entry->cur_wq]->id, cpu);
-
-	return entry->wqs[entry->cur_wq];
-}
-
-static void wq_table_add(int cpu, struct idxd_wq *wq)
-{
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
-
-	if (WARN_ON(entry->n_wqs == entry->max_wqs))
-		return;
-
-	entry->wqs[entry->n_wqs++] = wq;
-
-	pr_debug("%s: added iaa wq %d.%d to idx %d of cpu %d\n", __func__,
-		 entry->wqs[entry->n_wqs - 1]->idxd->id,
-		 entry->wqs[entry->n_wqs - 1]->id, entry->n_wqs - 1, cpu);
-}
-
-static void wq_table_free_entry(int cpu)
-{
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+/* Verify results of IAA compress or not */
+static bool iaa_verify_compress = false;
 
-	kfree(entry->wqs);
-	memset(entry, 0, sizeof(*entry));
-}
+/*
+ * The iaa crypto driver supports three 'sync' methods determining how
+ * compressions and decompressions are performed:
+ *
+ * - sync:      the compression or decompression completes before
+ *              returning.  This is the mode used by the async crypto
+ *              interface when the sync mode is set to 'sync' and by
+ *              the sync crypto interface regardless of setting.
+ *
+ * - async:     the compression or decompression is submitted and returns
+ *              immediately.  Completion interrupts are not used so
+ *              the caller is responsible for polling the descriptor
+ *              for completion.  This mode is applicable to only the
+ *              async crypto interface and is ignored for anything
+ *              else.
+ *
+ * - async_irq: the compression or decompression is submitted and
+ *              returns immediately.  Completion interrupts are
+ *              enabled so the caller can wait for the completion and
+ *              yield to other threads.  When the compression or
+ *              decompression completes, the completion is signaled
+ *              and the caller awakened.  This mode is applicable to
+ *              only the async crypto interface and is ignored for
+ *              anything else.
+ *
+ * These modes can be set using the iaa_crypto sync_mode driver
+ * attribute.
+ */
 
-static void wq_table_clear_entry(int cpu)
-{
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+/* Use async mode */
+static bool async_mode = true;
+/* Use interrupts */
+static bool use_irq;
 
-	entry->n_wqs = 0;
-	entry->cur_wq = 0;
-	memset(entry->wqs, 0, entry->max_wqs * sizeof(struct idxd_wq *));
-}
+static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
 
 LIST_HEAD(iaa_devices);
 DEFINE_MUTEX(iaa_devices_lock);
@@ -93,9 +87,9 @@ DEFINE_MUTEX(iaa_devices_lock);
 static bool iaa_crypto_enabled;
 static bool iaa_crypto_registered;
 
-/* Verify results of IAA compress or not */
-static bool iaa_verify_compress = false;
-
+/**************************************************
+ * Driver attributes along with get/set functions.
+ **************************************************/
 static ssize_t verify_compress_show(struct device_driver *driver, char *buf)
 {
 	return sprintf(buf, "%d\n", iaa_verify_compress);
@@ -123,40 +117,6 @@ static ssize_t verify_compress_store(struct device_driver *driver,
 }
 static DRIVER_ATTR_RW(verify_compress);
 
-/*
- * The iaa crypto driver supports three 'sync' methods determining how
- * compressions and decompressions are performed:
- *
- * - sync:      the compression or decompression completes before
- *              returning.  This is the mode used by the async crypto
- *              interface when the sync mode is set to 'sync' and by
- *              the sync crypto interface regardless of setting.
- *
- * - async:     the compression or decompression is submitted and returns
- *              immediately.  Completion interrupts are not used so
- *              the caller is responsible for polling the descriptor
- *              for completion.  This mode is applicable to only the
- *              async crypto interface and is ignored for anything
- *              else.
- *
- * - async_irq: the compression or decompression is submitted and
- *              returns immediately.  Completion interrupts are
- *              enabled so the caller can wait for the completion and
- *              yield to other threads.  When the compression or
- *              decompression completes, the completion is signaled
- *              and the caller awakened.  This mode is applicable to
- *              only the async crypto interface and is ignored for
- *              anything else.
- *
- * These modes can be set using the iaa_crypto sync_mode driver
- * attribute.
- */
-
-/* Use async mode */
-static bool async_mode = true;
-/* Use interrupts */
-static bool use_irq;
-
 /**
  * set_iaa_sync_mode - Set IAA sync mode
  * @name: The name of the sync mode
@@ -219,8 +179,9 @@ static ssize_t sync_mode_store(struct device_driver *driver,
 }
 static DRIVER_ATTR_RW(sync_mode);
 
-static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
-
+/****************************
+ * Driver compression modes.
+ ****************************/
 static int find_empty_iaa_compression_mode(void)
 {
 	int i = -EINVAL;
@@ -411,11 +372,6 @@ static void free_device_compression_mode(struct iaa_device *iaa_device,
 						IDXD_OP_FLAG_WR_SRC2_AECS_COMP | \
 						IDXD_OP_FLAG_AECS_RW_TGLS)
 
-static int check_completion(struct device *dev,
-			    struct iax_completion_record *comp,
-			    bool compress,
-			    bool only_once);
-
 static int init_device_compression_mode(struct iaa_device *iaa_device,
 					struct iaa_compression_mode *mode,
 					int idx, struct idxd_wq *wq)
@@ -502,6 +458,10 @@ static void remove_device_compression_modes(struct iaa_device *iaa_device)
 	}
 }
 
+/***********************************************************
+ * Functions for use in crypto probe and remove interfaces:
+ * allocate/init/query/deallocate devices/wqs.
+ ***********************************************************/
 static struct iaa_device *iaa_device_alloc(void)
 {
 	struct iaa_device *iaa_device;
@@ -614,16 +574,6 @@ static void del_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
 	}
 }
 
-static void clear_wq_table(void)
-{
-	int cpu;
-
-	for (cpu = 0; cpu < nr_cpus; cpu++)
-		wq_table_clear_entry(cpu);
-
-	pr_debug("cleared wq table\n");
-}
-
 static void free_iaa_device(struct iaa_device *iaa_device)
 {
 	if (!iaa_device)
@@ -704,43 +654,6 @@ static int iaa_wq_put(struct idxd_wq *wq)
 	return ret;
 }
 
-static void free_wq_table(void)
-{
-	int cpu;
-
-	for (cpu = 0; cpu < nr_cpus; cpu++)
-		wq_table_free_entry(cpu);
-
-	free_percpu(wq_table);
-
-	pr_debug("freed wq table\n");
-}
-
-static int alloc_wq_table(int max_wqs)
-{
-	struct wq_table_entry *entry;
-	int cpu;
-
-	wq_table = alloc_percpu(struct wq_table_entry);
-	if (!wq_table)
-		return -ENOMEM;
-
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		entry = per_cpu_ptr(wq_table, cpu);
-		entry->wqs = kcalloc(max_wqs, sizeof(struct wq *), GFP_KERNEL);
-		if (!entry->wqs) {
-			free_wq_table();
-			return -ENOMEM;
-		}
-
-		entry->max_wqs = max_wqs;
-	}
-
-	pr_debug("initialized wq table\n");
-
-	return 0;
-}
-
 static int save_iaa_wq(struct idxd_wq *wq)
 {
 	struct iaa_device *iaa_device, *found = NULL;
@@ -829,6 +742,87 @@ static void remove_iaa_wq(struct idxd_wq *wq)
 		cpus_per_iaa = 1;
 }
 
+/***************************************************************
+ * Mapping IAA devices and wqs to cores with per-cpu wq_tables.
+ ***************************************************************/
+static void wq_table_free_entry(int cpu)
+{
+	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+
+	kfree(entry->wqs);
+	memset(entry, 0, sizeof(*entry));
+}
+
+static void wq_table_clear_entry(int cpu)
+{
+	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+
+	entry->n_wqs = 0;
+	entry->cur_wq = 0;
+	memset(entry->wqs, 0, entry->max_wqs * sizeof(struct idxd_wq *));
+}
+
+static void clear_wq_table(void)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < nr_cpus; cpu++)
+		wq_table_clear_entry(cpu);
+
+	pr_debug("cleared wq table\n");
+}
+
+static void free_wq_table(void)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < nr_cpus; cpu++)
+		wq_table_free_entry(cpu);
+
+	free_percpu(wq_table);
+
+	pr_debug("freed wq table\n");
+}
+
+static int alloc_wq_table(int max_wqs)
+{
+	struct wq_table_entry *entry;
+	int cpu;
+
+	wq_table = alloc_percpu(struct wq_table_entry);
+	if (!wq_table)
+		return -ENOMEM;
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		entry = per_cpu_ptr(wq_table, cpu);
+		entry->wqs = kcalloc(max_wqs, sizeof(struct wq *), GFP_KERNEL);
+		if (!entry->wqs) {
+			free_wq_table();
+			return -ENOMEM;
+		}
+
+		entry->max_wqs = max_wqs;
+	}
+
+	pr_debug("initialized wq table\n");
+
+	return 0;
+}
+
+static void wq_table_add(int cpu, struct idxd_wq *wq)
+{
+	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+
+	if (WARN_ON(entry->n_wqs == entry->max_wqs))
+		return;
+
+	entry->wqs[entry->n_wqs++] = wq;
+
+	pr_debug("%s: added iaa wq %d.%d to idx %d of cpu %d\n", __func__,
+		 entry->wqs[entry->n_wqs - 1]->idxd->id,
+		 entry->wqs[entry->n_wqs - 1]->id, entry->n_wqs - 1, cpu);
+}
+
 static int wq_table_add_wqs(int iaa, int cpu)
 {
 	struct iaa_device *iaa_device, *found_device = NULL;
@@ -939,6 +933,29 @@ static void rebalance_wq_table(void)
 	}
 }
 
+/***************************************************************
+ * Assign work-queues for driver ops using per-cpu wq_tables.
+ ***************************************************************/
+static struct idxd_wq *wq_table_next_wq(int cpu)
+{
+	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+
+	if (++entry->cur_wq >= entry->n_wqs)
+		entry->cur_wq = 0;
+
+	if (!entry->wqs[entry->cur_wq])
+		return NULL;
+
+	pr_debug("%s: returning wq at idx %d (iaa wq %d.%d) from cpu %d\n", __func__,
+		 entry->cur_wq, entry->wqs[entry->cur_wq]->idxd->id,
+		 entry->wqs[entry->cur_wq]->id, cpu);
+
+	return entry->wqs[entry->cur_wq];
+}
+
+/*************************************************
+ * Core iaa_crypto compress/decompress functions.
+ *************************************************/
 static inline int check_completion(struct device *dev,
 				   struct iax_completion_record *comp,
 				   bool compress,
@@ -1020,13 +1037,130 @@ static int deflate_generic_decompress(struct acomp_req *req)
 
 static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 				struct acomp_req *req,
-				dma_addr_t *src_addr, dma_addr_t *dst_addr);
+				dma_addr_t *src_addr, dma_addr_t *dst_addr)
+{
+	int ret = 0;
+	int nr_sgs;
+
+	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
+
+	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
+	if (nr_sgs <= 0 || nr_sgs > 1) {
+		dev_dbg(dev, "verify: couldn't map src sg for iaa device %d,"
+			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
+			iaa_wq->wq->id, ret);
+		ret = -EIO;
+		goto out;
+	}
+	*src_addr = sg_dma_address(req->src);
+	dev_dbg(dev, "verify: dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
+		" req->slen %d, sg_dma_len(sg) %d\n", *src_addr, nr_sgs,
+		req->src, req->slen, sg_dma_len(req->src));
+
+	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_TO_DEVICE);
+	if (nr_sgs <= 0 || nr_sgs > 1) {
+		dev_dbg(dev, "verify: couldn't map dst sg for iaa device %d,"
+			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
+			iaa_wq->wq->id, ret);
+		ret = -EIO;
+		dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
+		goto out;
+	}
+	*dst_addr = sg_dma_address(req->dst);
+	dev_dbg(dev, "verify: dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
+		" req->dlen %d, sg_dma_len(sg) %d\n", *dst_addr, nr_sgs,
+		req->dst, req->dlen, sg_dma_len(req->dst));
+out:
+	return ret;
+}
 
 static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
 			       dma_addr_t dst_addr, unsigned int *dlen,
-			       u32 compression_crc);
+			       u32 compression_crc)
+{
+	struct iaa_device_compression_mode *active_compression_mode;
+	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct iaa_device *iaa_device;
+	struct idxd_desc *idxd_desc;
+	struct iax_hw_desc *desc;
+	struct idxd_device *idxd;
+	struct iaa_wq *iaa_wq;
+	struct pci_dev *pdev;
+	struct device *dev;
+	int ret = 0;
+
+	iaa_wq = idxd_wq_get_private(wq);
+	iaa_device = iaa_wq->iaa_device;
+	idxd = iaa_device->idxd;
+	pdev = idxd->pdev;
+	dev = &pdev->dev;
+
+	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
+
+	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
+	if (IS_ERR(idxd_desc)) {
+		dev_dbg(dev, "idxd descriptor allocation failed\n");
+		dev_dbg(dev, "iaa compress failed: ret=%ld\n",
+			PTR_ERR(idxd_desc));
+		return PTR_ERR(idxd_desc);
+	}
+	desc = idxd_desc->iax_hw;
+
+	/* Verify (optional) - decompress and check crc, suppress dest write */
+
+	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR | IDXD_OP_FLAG_CC;
+	desc->opcode = IAX_OPCODE_DECOMPRESS;
+	desc->decompr_flags = IAA_DECOMP_FLAGS | IAA_DECOMP_SUPPRESS_OUTPUT;
+	desc->priv = 0;
+
+	desc->src1_addr = (u64)dst_addr;
+	desc->src1_size = *dlen;
+	desc->dst_addr = (u64)src_addr;
+	desc->max_dst_size = slen;
+	desc->completion_addr = idxd_desc->compl_dma;
+
+	dev_dbg(dev, "(verify) compression mode %s,"
+		" desc->src1_addr %llx, desc->src1_size %d,"
+		" desc->dst_addr %llx, desc->max_dst_size %d,"
+		" desc->src2_addr %llx, desc->src2_size %d\n",
+		active_compression_mode->name,
+		desc->src1_addr, desc->src1_size, desc->dst_addr,
+		desc->max_dst_size, desc->src2_addr, desc->src2_size);
+
+	ret = idxd_submit_desc(wq, idxd_desc);
+	if (ret) {
+		dev_dbg(dev, "submit_desc (verify) failed ret=%d\n", ret);
+		goto err;
+	}
+
+	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
+	if (ret) {
+		dev_dbg(dev, "(verify) check_completion failed ret=%d\n", ret);
+		goto err;
+	}
+
+	if (compression_crc != idxd_desc->iax_completion->crc) {
+		ret = -EINVAL;
+		dev_dbg(dev, "(verify) iaa comp/decomp crc mismatch:"
+			" comp=0x%x, decomp=0x%x\n", compression_crc,
+			idxd_desc->iax_completion->crc);
+		print_hex_dump(KERN_INFO, "cmp-rec: ", DUMP_PREFIX_OFFSET,
+			       8, 1, idxd_desc->iax_completion, 64, 0);
+		goto err;
+	}
+
+	idxd_free_desc(wq, idxd_desc);
+out:
+	return ret;
+err:
+	idxd_free_desc(wq, idxd_desc);
+	dev_dbg(dev, "iaa compress failed: ret=%d\n", ret);
+
+	goto out;
+}
 
 static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 			      enum idxd_complete_type comp_type,
@@ -1245,133 +1379,6 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 	goto out;
 }
 
-static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
-				struct acomp_req *req,
-				dma_addr_t *src_addr, dma_addr_t *dst_addr)
-{
-	int ret = 0;
-	int nr_sgs;
-
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "verify: couldn't map src sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto out;
-	}
-	*src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "verify: dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", *src_addr, nr_sgs,
-		req->src, req->slen, sg_dma_len(req->src));
-
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "verify: couldn't map dst sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
-		goto out;
-	}
-	*dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "verify: dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", *dst_addr, nr_sgs,
-		req->dst, req->dlen, sg_dma_len(req->dst));
-out:
-	return ret;
-}
-
-static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
-			       struct idxd_wq *wq,
-			       dma_addr_t src_addr, unsigned int slen,
-			       dma_addr_t dst_addr, unsigned int *dlen,
-			       u32 compression_crc)
-{
-	struct iaa_device_compression_mode *active_compression_mode;
-	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
-	struct iax_hw_desc *desc;
-	struct idxd_device *idxd;
-	struct iaa_wq *iaa_wq;
-	struct pci_dev *pdev;
-	struct device *dev;
-	int ret = 0;
-
-	iaa_wq = idxd_wq_get_private(wq);
-	iaa_device = iaa_wq->iaa_device;
-	idxd = iaa_device->idxd;
-	pdev = idxd->pdev;
-	dev = &pdev->dev;
-
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
-	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
-	if (IS_ERR(idxd_desc)) {
-		dev_dbg(dev, "idxd descriptor allocation failed\n");
-		dev_dbg(dev, "iaa compress failed: ret=%ld\n",
-			PTR_ERR(idxd_desc));
-		return PTR_ERR(idxd_desc);
-	}
-	desc = idxd_desc->iax_hw;
-
-	/* Verify (optional) - decompress and check crc, suppress dest write */
-
-	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR | IDXD_OP_FLAG_CC;
-	desc->opcode = IAX_OPCODE_DECOMPRESS;
-	desc->decompr_flags = IAA_DECOMP_FLAGS | IAA_DECOMP_SUPPRESS_OUTPUT;
-	desc->priv = 0;
-
-	desc->src1_addr = (u64)dst_addr;
-	desc->src1_size = *dlen;
-	desc->dst_addr = (u64)src_addr;
-	desc->max_dst_size = slen;
-	desc->completion_addr = idxd_desc->compl_dma;
-
-	dev_dbg(dev, "(verify) compression mode %s,"
-		" desc->src1_addr %llx, desc->src1_size %d,"
-		" desc->dst_addr %llx, desc->max_dst_size %d,"
-		" desc->src2_addr %llx, desc->src2_size %d\n",
-		active_compression_mode->name,
-		desc->src1_addr, desc->src1_size, desc->dst_addr,
-		desc->max_dst_size, desc->src2_addr, desc->src2_size);
-
-	ret = idxd_submit_desc(wq, idxd_desc);
-	if (ret) {
-		dev_dbg(dev, "submit_desc (verify) failed ret=%d\n", ret);
-		goto err;
-	}
-
-	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
-	if (ret) {
-		dev_dbg(dev, "(verify) check_completion failed ret=%d\n", ret);
-		goto err;
-	}
-
-	if (compression_crc != idxd_desc->iax_completion->crc) {
-		ret = -EINVAL;
-		dev_dbg(dev, "(verify) iaa comp/decomp crc mismatch:"
-			" comp=0x%x, decomp=0x%x\n", compression_crc,
-			idxd_desc->iax_completion->crc);
-		print_hex_dump(KERN_INFO, "cmp-rec: ", DUMP_PREFIX_OFFSET,
-			       8, 1, idxd_desc->iax_completion, 64, 0);
-		goto err;
-	}
-
-	idxd_free_desc(wq, idxd_desc);
-out:
-	return ret;
-err:
-	idxd_free_desc(wq, idxd_desc);
-	dev_dbg(dev, "iaa compress failed: ret=%d\n", ret);
-
-	goto out;
-}
-
 static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			  struct idxd_wq *wq,
 			  dma_addr_t src_addr, unsigned int slen,
@@ -2197,6 +2204,9 @@ static bool iaa_comp_adecompress_batch(
 	return !err;
 }
 
+/*********************************************
+ * Interfaces to crypto_alg and crypto_acomp.
+ *********************************************/
 static int iaa_comp_init_fixed(struct crypto_acomp *acomp_tfm)
 {
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
-- 
2.27.0


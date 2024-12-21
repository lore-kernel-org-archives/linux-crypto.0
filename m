Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AE71F03E4;
	Sat, 21 Dec 2024 06:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762689; cv=none; b=Gn8vNNhy2iz6z2AtcRtJsP2C1sDvGnOO6G+iaQ5oZkcQmgm/IIVA/qMlGAOGmYhgjjBv3mJQRd6MicdGWeldzwdTs/aePkZyXxbe8cfOx4RQnF6HAVUSuGGe4O4X8pyYc+dIZ5yYGxvvCVRvIg8W1BU9APlERbDoYfRez6VsKU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762689; c=relaxed/simple;
	bh=yBCr+FraBHYq64d9eiZRbYqzgC3sqMOsBxQBn5IGL/8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GvS6b+9CtIQyeM4NEM2cLPQ5ZeSflC1bvQ3g2VG64SwJYziGQFIPNz7oufAlKzxdW9CWEWTYr7z/ybXw9hXrtper63XQTce989dRGuTHFiGoZ+bzYJXSPUOFX80d8tO4bTBETvrotNo/QkEX30ztGIgDUBbOf0xm7E3XgwUd8CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TbdPpMMd; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TbdPpMMd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734762686; x=1766298686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yBCr+FraBHYq64d9eiZRbYqzgC3sqMOsBxQBn5IGL/8=;
  b=TbdPpMMdBCWAkA14PNZh1shlfdt6wln7SkdcoGDZ7M85wzU3tzrPUlXd
   unKWUKcM7VsCKoTnyx+zi1BvMyi2mh2xRCRpfe/yOqTVDNTJY70GVL+0E
   grf7Bw1QiytBAF8tZsYoei8FnTh8LY2371Oiu2gM642G2ZQm49ibmDs/x
   eXhX6OAv9XllJOWs6iNt8qXAjFuTDlBB8YudDBTQB3xlhkoDAn+X0gLPB
   q+VbJRYiEltvf+ZsCXWj/i7KsK0l/ki/WWP3BFPTbUDwH8nsg4rgf+5Mi
   NzCxC8X4cDjFG4gUv3vhycYjPxqdoP5l+1p8ADC3YzFOsv/cJNi39VOXe
   g==;
X-CSE-ConnectionGUID: FyTxbK2wRkOJlc/l6MwZgA==
X-CSE-MsgGUID: WdBN8aylS7m1wNS6HZR9Hg==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="35021683"
X-IronPort-AV: E=Sophos;i="6.12,253,1728975600"; 
   d="scan'208";a="35021683"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 22:31:20 -0800
X-CSE-ConnectionGUID: FqmhOvYtQ9qDZSnG5fpQfA==
X-CSE-MsgGUID: sW4j5HJ9Thqy3jUBe/uPvw==
X-Ironport-Invalid-End-Of-Message: True
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99184596"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa007.jf.intel.com with ESMTP; 20 Dec 2024 22:31:21 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
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
Subject: [PATCH v5 07/12] crypto: iaa - Re-organize the iaa_crypto driver code.
Date: Fri, 20 Dec 2024 22:31:14 -0800
Message-Id: <20241221063119.29140-8-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
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


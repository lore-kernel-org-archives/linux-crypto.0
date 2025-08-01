Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68B726ACB;
	Fri,  1 Aug 2025 04:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023007; cv=none; b=pSPnqubrc8NMD6HenrXKT7/MWVC2ALc68vGO/yF9hI7UR0D6rIp325ti+MApdcyGOVNEqR7UidLnG2tUze4qfAM9vVKo/HBRTMyoBKEFYY1wycr9S30gnQowVqUZmaPPP5WJ3smMN0zPnJKU8qD5rtKgMjvqfQXp+K2fj7vmtI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023007; c=relaxed/simple;
	bh=CYuNizBLF9iN6xWYMJDtHneeaOOS20GoAAA6zSvZMns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hy1rv+MypP8Swynfjkt7L6yjWvBh653xxjzj0TGh/g4BjMqBik5ECRyqc4W2nhGAjt4M/aCv/HaMw+uH4HglNv0w4Ed6Ye00pX0gYECMO8Mv/eVSsSD5PgQP76739yOn8A0FJfXka9woEc+SJQimfGhCC8en3H3Z7qnD3bbkg8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Odz03FXI; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Odz03FXI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023005; x=1785559005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CYuNizBLF9iN6xWYMJDtHneeaOOS20GoAAA6zSvZMns=;
  b=Odz03FXIhCBxIdrSsY5thmQHYHIPDbZy6pyd7B5WyAN4js/8N6D7WXJa
   2N4YyknAskXaADllniwM2Bi0tcn/PN68RyoOqToXgAKwxgZ9gtImTZGAc
   RXkzci1fTj+tkiZzHjZTgvtMOq5CAN5qfxpOgOm+1G6tgoc+OtM+HG7iZ
   iiQu93bqhQvpZ9yxqrb8uTLW2anSnhS+q+CCmmIvDsA5130JQDonx4M3K
   xsYB8JAV/smOcVTfv3MBbYu/syyMDRgvkh6o/zabeVawO1bPp4+bDzDTb
   uhyVYxv3sU/5+j2gxt/uak19P07m9kV3yTCU0nGFjyGPwvEozCfcBfMOo
   A==;
X-CSE-ConnectionGUID: xpv+pGfOR7WuXRptpdXemg==
X-CSE-MsgGUID: jbgbfl3VSRW5+v8Y2F277g==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820138"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820138"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:43 -0700
X-CSE-ConnectionGUID: RX6C/9qIQSSkA4CALe3Cyg==
X-CSE-MsgGUID: wG1x6ZZqTNSOu8H0/jyqZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796222"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:42 -0700
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
Subject: [PATCH v11 01/24] crypto: iaa - Reorganize the iaa_crypto driver code.
Date: Thu, 31 Jul 2025 21:36:19 -0700
Message-Id: <20250801043642.8103-2-kanchana.p.sridhar@intel.com>
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

This patch merely reorganizes the code in iaa_crypto_main.c, so that
the functions are consolidated into logically related sub-sections of
code, without requiring forward declarations.

This is expected to make the code more maintainable and for it to be
easier to replace functional layers and/or add new features.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 677 +++++++++++----------
 1 file changed, 350 insertions(+), 327 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 23f585219fb4b..760997eee8fe5 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -24,6 +24,10 @@
 
 #define IAA_ALG_PRIORITY               300
 
+/**************************************
+ * Driver internal global variables.
+ **************************************/
+
 /* number of iaa instances probed */
 static unsigned int nr_iaa;
 static unsigned int nr_cpus;
@@ -36,54 +40,6 @@ static unsigned int cpus_per_iaa;
 /* Per-cpu lookup table for balanced wqs */
 static struct wq_table_entry __percpu *wq_table;
 
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
-
-	kfree(entry->wqs);
-	memset(entry, 0, sizeof(*entry));
-}
-
-static void wq_table_clear_entry(int cpu)
-{
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
-
-	entry->n_wqs = 0;
-	entry->cur_wq = 0;
-	memset(entry->wqs, 0, entry->max_wqs * sizeof(struct idxd_wq *));
-}
-
 LIST_HEAD(iaa_devices);
 DEFINE_MUTEX(iaa_devices_lock);
 
@@ -91,36 +47,11 @@ DEFINE_MUTEX(iaa_devices_lock);
 static bool iaa_crypto_enabled;
 static bool iaa_crypto_registered;
 
+static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
+
 /* Verify results of IAA compress or not */
 static bool iaa_verify_compress = true;
 
-static ssize_t verify_compress_show(struct device_driver *driver, char *buf)
-{
-	return sprintf(buf, "%d\n", iaa_verify_compress);
-}
-
-static ssize_t verify_compress_store(struct device_driver *driver,
-				     const char *buf, size_t count)
-{
-	int ret = -EBUSY;
-
-	mutex_lock(&iaa_devices_lock);
-
-	if (iaa_crypto_enabled)
-		goto out;
-
-	ret = kstrtobool(buf, &iaa_verify_compress);
-	if (ret)
-		goto out;
-
-	ret = count;
-out:
-	mutex_unlock(&iaa_devices_lock);
-
-	return ret;
-}
-static DRIVER_ATTR_RW(verify_compress);
-
 /*
  * The iaa crypto driver supports three 'sync' methods determining how
  * compressions and decompressions are performed:
@@ -155,6 +86,37 @@ static bool async_mode;
 /* Use interrupts */
 static bool use_irq;
 
+/**************************************************
+ * Driver attributes along with get/set functions.
+ **************************************************/
+
+static ssize_t verify_compress_show(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%d\n", iaa_verify_compress);
+}
+
+static ssize_t verify_compress_store(struct device_driver *driver,
+				     const char *buf, size_t count)
+{
+	int ret = -EBUSY;
+
+	mutex_lock(&iaa_devices_lock);
+
+	if (iaa_crypto_enabled)
+		goto out;
+
+	ret = kstrtobool(buf, &iaa_verify_compress);
+	if (ret)
+		goto out;
+
+	ret = count;
+out:
+	mutex_unlock(&iaa_devices_lock);
+
+	return ret;
+}
+static DRIVER_ATTR_RW(verify_compress);
+
 /**
  * set_iaa_sync_mode - Set IAA sync mode
  * @name: The name of the sync mode
@@ -217,7 +179,9 @@ static ssize_t sync_mode_store(struct device_driver *driver,
 }
 static DRIVER_ATTR_RW(sync_mode);
 
-static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
+/****************************
+ * Driver compression modes.
+ ****************************/
 
 static int find_empty_iaa_compression_mode(void)
 {
@@ -409,11 +373,6 @@ static void free_device_compression_mode(struct iaa_device *iaa_device,
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
@@ -500,6 +459,11 @@ static void remove_device_compression_modes(struct iaa_device *iaa_device)
 	}
 }
 
+/***********************************************************
+ * Functions for use in crypto probe and remove interfaces:
+ * allocate/init/query/deallocate devices/wqs.
+ ***********************************************************/
+
 static struct iaa_device *iaa_device_alloc(void)
 {
 	struct iaa_device *iaa_device;
@@ -513,18 +477,6 @@ static struct iaa_device *iaa_device_alloc(void)
 	return iaa_device;
 }
 
-static bool iaa_has_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
-{
-	struct iaa_wq *iaa_wq;
-
-	list_for_each_entry(iaa_wq, &iaa_device->wqs, list) {
-		if (iaa_wq->wq == wq)
-			return true;
-	}
-
-	return false;
-}
-
 static struct iaa_device *add_iaa_device(struct idxd_device *idxd)
 {
 	struct iaa_device *iaa_device;
@@ -560,6 +512,27 @@ static void del_iaa_device(struct iaa_device *iaa_device)
 	nr_iaa--;
 }
 
+static void free_iaa_device(struct iaa_device *iaa_device)
+{
+	if (!iaa_device)
+		return;
+
+	remove_device_compression_modes(iaa_device);
+	kfree(iaa_device);
+}
+
+static bool iaa_has_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
+{
+	struct iaa_wq *iaa_wq;
+
+	list_for_each_entry(iaa_wq, &iaa_device->wqs, list) {
+		if (iaa_wq->wq == wq)
+			return true;
+	}
+
+	return false;
+}
+
 static int add_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq,
 		      struct iaa_wq **new_wq)
 {
@@ -612,23 +585,23 @@ static void del_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
 	}
 }
 
-static void clear_wq_table(void)
+static void remove_iaa_wq(struct idxd_wq *wq)
 {
-	int cpu;
-
-	for (cpu = 0; cpu < nr_cpus; cpu++)
-		wq_table_clear_entry(cpu);
-
-	pr_debug("cleared wq table\n");
-}
+	struct iaa_device *iaa_device;
 
-static void free_iaa_device(struct iaa_device *iaa_device)
-{
-	if (!iaa_device)
-		return;
+	list_for_each_entry(iaa_device, &iaa_devices, list) {
+		if (iaa_has_wq(iaa_device, wq)) {
+			del_iaa_wq(iaa_device, wq);
+			break;
+		}
+	}
 
-	remove_device_compression_modes(iaa_device);
-	kfree(iaa_device);
+	if (nr_iaa) {
+		cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
+		if (!cpus_per_iaa)
+			cpus_per_iaa = 1;
+	} else
+		cpus_per_iaa = 1;
 }
 
 static void __free_iaa_wq(struct iaa_wq *iaa_wq)
@@ -655,6 +628,75 @@ static void free_iaa_wq(struct iaa_wq *iaa_wq)
 	idxd_wq_set_private(wq, NULL);
 }
 
+static int save_iaa_wq(struct idxd_wq *wq)
+{
+	struct iaa_device *iaa_device, *found = NULL;
+	struct idxd_device *idxd;
+	struct pci_dev *pdev;
+	struct device *dev;
+	int ret = 0;
+
+	list_for_each_entry(iaa_device, &iaa_devices, list) {
+		if (iaa_device->idxd == wq->idxd) {
+			idxd = iaa_device->idxd;
+			pdev = idxd->pdev;
+			dev = &pdev->dev;
+			/*
+			 * Check to see that we don't already have this wq.
+			 * Shouldn't happen but we don't control probing.
+			 */
+			if (iaa_has_wq(iaa_device, wq)) {
+				dev_dbg(dev, "same wq probed multiple times for iaa_device %p\n",
+					iaa_device);
+				goto out;
+			}
+
+			found = iaa_device;
+
+			ret = add_iaa_wq(iaa_device, wq, NULL);
+			if (ret)
+				goto out;
+
+			break;
+		}
+	}
+
+	if (!found) {
+		struct iaa_device *new_device;
+		struct iaa_wq *new_wq;
+
+		new_device = add_iaa_device(wq->idxd);
+		if (!new_device) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = add_iaa_wq(new_device, wq, &new_wq);
+		if (ret) {
+			del_iaa_device(new_device);
+			free_iaa_device(new_device);
+			goto out;
+		}
+
+		ret = init_iaa_device(new_device, new_wq);
+		if (ret) {
+			del_iaa_wq(new_device, new_wq->wq);
+			del_iaa_device(new_device);
+			free_iaa_wq(new_wq);
+			goto out;
+		}
+	}
+
+	if (WARN_ON(nr_iaa == 0))
+		return -EINVAL;
+
+	cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
+	if (!cpus_per_iaa)
+		cpus_per_iaa = 1;
+out:
+	return 0;
+}
+
 static int iaa_wq_get(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
@@ -702,6 +744,37 @@ static int iaa_wq_put(struct idxd_wq *wq)
 	return ret;
 }
 
+/***************************************************************
+ * Mapping IAA devices and wqs to cores with per-cpu wq_tables.
+ ***************************************************************/
+
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
 static void free_wq_table(void)
 {
 	int cpu;
@@ -739,92 +812,18 @@ static int alloc_wq_table(int max_wqs)
 	return 0;
 }
 
-static int save_iaa_wq(struct idxd_wq *wq)
+static void wq_table_add(int cpu, struct idxd_wq *wq)
 {
-	struct iaa_device *iaa_device, *found = NULL;
-	struct idxd_device *idxd;
-	struct pci_dev *pdev;
-	struct device *dev;
-	int ret = 0;
-
-	list_for_each_entry(iaa_device, &iaa_devices, list) {
-		if (iaa_device->idxd == wq->idxd) {
-			idxd = iaa_device->idxd;
-			pdev = idxd->pdev;
-			dev = &pdev->dev;
-			/*
-			 * Check to see that we don't already have this wq.
-			 * Shouldn't happen but we don't control probing.
-			 */
-			if (iaa_has_wq(iaa_device, wq)) {
-				dev_dbg(dev, "same wq probed multiple times for iaa_device %p\n",
-					iaa_device);
-				goto out;
-			}
-
-			found = iaa_device;
-
-			ret = add_iaa_wq(iaa_device, wq, NULL);
-			if (ret)
-				goto out;
-
-			break;
-		}
-	}
-
-	if (!found) {
-		struct iaa_device *new_device;
-		struct iaa_wq *new_wq;
-
-		new_device = add_iaa_device(wq->idxd);
-		if (!new_device) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		ret = add_iaa_wq(new_device, wq, &new_wq);
-		if (ret) {
-			del_iaa_device(new_device);
-			free_iaa_device(new_device);
-			goto out;
-		}
-
-		ret = init_iaa_device(new_device, new_wq);
-		if (ret) {
-			del_iaa_wq(new_device, new_wq->wq);
-			del_iaa_device(new_device);
-			free_iaa_wq(new_wq);
-			goto out;
-		}
-	}
-
-	if (WARN_ON(nr_iaa == 0))
-		return -EINVAL;
-
-	cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
-	if (!cpus_per_iaa)
-		cpus_per_iaa = 1;
-out:
-	return 0;
-}
+	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
 
-static void remove_iaa_wq(struct idxd_wq *wq)
-{
-	struct iaa_device *iaa_device;
+	if (WARN_ON(entry->n_wqs == entry->max_wqs))
+		return;
 
-	list_for_each_entry(iaa_device, &iaa_devices, list) {
-		if (iaa_has_wq(iaa_device, wq)) {
-			del_iaa_wq(iaa_device, wq);
-			break;
-		}
-	}
+	entry->wqs[entry->n_wqs++] = wq;
 
-	if (nr_iaa) {
-		cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
-		if (!cpus_per_iaa)
-			cpus_per_iaa = 1;
-	} else
-		cpus_per_iaa = 1;
+	pr_debug("%s: added iaa wq %d.%d to idx %d of cpu %d\n", __func__,
+		 entry->wqs[entry->n_wqs - 1]->idxd->id,
+		 entry->wqs[entry->n_wqs - 1]->id, entry->n_wqs - 1, cpu);
 }
 
 static int wq_table_add_wqs(int iaa, int cpu)
@@ -930,6 +929,44 @@ static void rebalance_wq_table(void)
 	pr_debug("could not add any wqs for iaa %d to cpu %d!\n", iaa, cpu);
 }
 
+/***************************************************************
+ * Assign work-queues for driver ops using per-cpu wq_tables.
+ ***************************************************************/
+
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
+
+static int deflate_generic_decompress(struct acomp_req *req)
+{
+	ACOMP_FBREQ_ON_STACK(fbreq, req);
+	int ret;
+
+	ret = crypto_acomp_decompress(fbreq);
+	req->dlen = fbreq->dlen;
+
+	update_total_sw_decomp_calls();
+
+	return ret;
+}
+
 static inline int check_completion(struct device *dev,
 				   struct iax_completion_record *comp,
 				   bool compress,
@@ -990,27 +1027,132 @@ static inline int check_completion(struct device *dev,
 	return ret;
 }
 
-static int deflate_generic_decompress(struct acomp_req *req)
+static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
+				struct acomp_req *req,
+				dma_addr_t *src_addr, dma_addr_t *dst_addr)
 {
-	ACOMP_FBREQ_ON_STACK(fbreq, req);
-	int ret;
+	int ret = 0;
+	int nr_sgs;
 
-	ret = crypto_acomp_decompress(fbreq);
-	req->dlen = fbreq->dlen;
+	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 
-	update_total_sw_decomp_calls();
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
 	return ret;
 }
 
-static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
-				struct acomp_req *req,
-				dma_addr_t *src_addr, dma_addr_t *dst_addr);
-
 static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
-			       dma_addr_t dst_addr, unsigned int *dlen);
+			       dma_addr_t dst_addr, unsigned int *dlen)
+{
+	struct iaa_device_compression_mode *active_compression_mode;
+	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 *compression_crc = acomp_request_ctx(req);
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
+	if (*compression_crc != idxd_desc->iax_completion->crc) {
+		ret = -EINVAL;
+		dev_dbg(dev, "(verify) iaa comp/decomp crc mismatch:"
+			" comp=0x%x, decomp=0x%x\n", *compression_crc,
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
@@ -1226,133 +1368,6 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
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
-			       dma_addr_t dst_addr, unsigned int *dlen)
-{
-	struct iaa_device_compression_mode *active_compression_mode;
-	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *compression_crc = acomp_request_ctx(req);
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
-	if (*compression_crc != idxd_desc->iax_completion->crc) {
-		ret = -EINVAL;
-		dev_dbg(dev, "(verify) iaa comp/decomp crc mismatch:"
-			" comp=0x%x, decomp=0x%x\n", *compression_crc,
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
@@ -1662,6 +1677,10 @@ static void compression_ctx_init(struct iaa_compression_ctx *ctx)
 	ctx->use_irq = use_irq;
 }
 
+/*********************************************
+ * Interfaces to crypto_alg and crypto_acomp.
+ *********************************************/
+
 static int iaa_comp_init_fixed(struct crypto_acomp *acomp_tfm)
 {
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
@@ -1864,6 +1883,10 @@ static struct idxd_device_driver iaa_crypto_driver = {
 	.desc_complete = iaa_desc_complete,
 };
 
+/********************
+ * Module init/exit.
+ ********************/
+
 static int __init iaa_crypto_init_module(void)
 {
 	int ret = 0;
-- 
2.27.0


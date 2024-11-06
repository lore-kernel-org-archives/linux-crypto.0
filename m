Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1001E20BB26;
	Wed,  6 Nov 2024 19:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920875; cv=none; b=gUbXAyq85PyPD/XJWNqRmKNAOpj71o4YIhuz7kRITatl927bHFAGMGR8jJtmv7SaxWN4nNYDM1xZ77UNCNZUGwypEfbVITqpOeSKIHsnB89Nyw+HK73d4GSBJKvEihCV1gs9jLI2PR++QmX9Y5VDwLgZeeHtOyhcZs8m9rbWkC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920875; c=relaxed/simple;
	bh=xaKYi5UD1EXb+8QE17eRVa6qtYmQdKerYV4Ficq5ajk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j+hMCAFZdrD2tz6cWQAIQ7ahIgTa51APWsBqoV+AhsfcFJxo3uN9nWc+f9iN3QQ1Cdqm44Os6GU/0DTJOjGog1t1IGLzTicmTh2jdrMpLQumLmEb9gE0dDPdJ0MlljiSvJFQLOxhGHo7lnJczGxv/vQOPtPL576kwvSXmeR/dzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eyb0Hm9+; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eyb0Hm9+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730920873; x=1762456873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xaKYi5UD1EXb+8QE17eRVa6qtYmQdKerYV4Ficq5ajk=;
  b=Eyb0Hm9+yHvAbsMqQJFZ9RkjEBHqpRM5RdjGN02ECtuZSNA/f/di1SqJ
   RiQYVqXi+SnrSw/YVBIJrA5rcnr0DaJ6Y1IqB+tA4bble/XKRdfyDLBbb
   q8K63q5ogia6jDGDuAz5GpQuVflbQd0OYZZxyLm365hpBeCIEhaqf/bQE
   JhibLdBjwe9ET61Lh05Oq3vLtStIp+eogCnLyikeJbsvRZOfjKuREqShu
   KhsVPKe7lwxkkEdhEM4nFONURpGIiqv0FVTdNa67itV7YFtf4q8v6ZXKw
   RPz2qq6khxAPYdSy04DhMFqDxOXiGtZhPLOInrRxjZRdIxiaInKqD855R
   A==;
X-CSE-ConnectionGUID: 02UzsSerRKeYS1irH52ekw==
X-CSE-MsgGUID: ZSC9v337QDOgQ+AWfIaHow==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41292009"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41292009"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 11:21:11 -0800
X-CSE-ConnectionGUID: +Z5vOFvCTR6cWN9dNz77NQ==
X-CSE-MsgGUID: FoxFzadKSE+f4ae5fyvaeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="88695396"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 06 Nov 2024 11:21:10 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	ying.huang@intel.com,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	zanussi@kernel.org
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v3 07/13] crypto: iaa - Distribute compress jobs to all IAA devices on a NUMA node.
Date: Wed,  6 Nov 2024 11:20:59 -0800
Message-Id: <20241106192105.6731-8-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This change enables processes running on any logical core on a NUMA node to
use all the IAA devices enabled on that NUMA node for compress jobs. In
other words, compressions originating from any process in a node will be
distributed in round-robin manner to the available IAA devices on the same
socket. The main premise behind this change is to make sure that no
compress engines on any IAA device are left un-utilized/under-utilized. In
other words, the compress engines on all IAA devices are considered a
global resource for that socket.

This allows the use of all IAA devices present in a given NUMA node for
(batched) compressions originating from zswap/zram, from all cores
on this node.

A new per-cpu "global_wq_table" implements this in the iaa_crypto driver.
We can think of the global WQ per IAA as a WQ to which all cores on
that socket can submit compress jobs.

To avail of this feature, the user must configure 2 WQs per IAA in order to
enable distribution of compress jobs to multiple IAA devices.

Each IAA will have 2 WQs:
 wq.0 (local WQ):
   Used for decompress jobs from cores mapped by the cpu_to_iaa() "even
   balancing of logical cores to IAA devices" algorithm.

 wq.1 (global WQ):
   Used for compress jobs from *all* logical cores on that socket.

The iaa_crypto driver will place all global WQs from all same-socket IAA
devices in the global_wq_table per cpu on that socket. When the driver
receives a compress job, it will lookup the "next" global WQ in the cpu's
global_wq_table to submit the descriptor.

The starting wq in the global_wq_table for each cpu is the global wq
associated with the IAA nearest to it, so that we stagger the starting
global wq for each process. This results in very uniform usage of all IAAs
for compress jobs.

Two new driver module parameters are added for this feature:

g_wqs_per_iaa (default 1):

 /sys/bus/dsa/drivers/crypto/g_wqs_per_iaa

 This represents the number of global WQs that can be configured per IAA
 device. The default is 1, and is the recommended setting to enable the use
 of this feature once the user configures 2 WQs per IAA using higher level
 scripts as described in
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst.

g_consec_descs_per_gwq (default 1):

 /sys/bus/dsa/drivers/crypto/g_consec_descs_per_gwq

 This represents the number of consecutive compress jobs that will be
 submitted to the same global WQ (i.e. to the same IAA device) from a given
 core, before moving to the next global WQ. The default is 1, which is also
 the recommended setting to avail of this feature.

The decompress jobs from any core will be sent to the "local" IAA, namely
the one that the driver assigns with the cpu_to_iaa() mapping algorithm
that evenly balances the assignment of logical cores to IAA devices on a
NUMA node.

On a 2-socket Sapphire Rapids server where each socket has 56 cores and
4 IAA devices, this is how the compress/decompress jobs will be mapped
when the user configures 2 WQs per IAA device (which implies wq.1 will
be added to the global WQ table for each logical core on that NUMA node):

 lscpu|grep NUMA
 NUMA node(s):        2
 NUMA node0 CPU(s):   0-55,112-167
 NUMA node1 CPU(s):   56-111,168-223

 Compress jobs:
 --------------
 NUMA node 0:
 All cpus (0-55,112-167) can send compress jobs to all IAA devices on the
 socket (iax1/iax3/iax5/iax7) in round-robin manner:
 iaa   iax1           iax3           iax5           iax7

 NUMA node 1:
 All cpus (56-111,168-223) can send compress jobs to all IAA devices on the
 socket (iax9/iax11/iax13/iax15) in round-robin manner:
 iaa   iax9           iax11          iax13           iax15

 Decompress jobs:
 ----------------
 NUMA node 0:
 cpu   0-13,112-125   14-27,126-139  28-41,140-153  42-55,154-167
 iaa   iax1           iax3           iax5           iax7

 NUMA node 1:
 cpu   56-69,168-181  70-83,182-195  84-97,196-209   98-111,210-223
 iaa   iax9           iax11          iax13           iax15

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 305 ++++++++++++++++++++-
 1 file changed, 290 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index a12a8f9caa84..ca0a71b8f31d 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -29,14 +29,23 @@ static unsigned int nr_iaa;
 static unsigned int nr_cpus;
 static unsigned int nr_nodes;
 static unsigned int nr_cpus_per_node;
-
 /* Number of physical cpus sharing each iaa instance */
 static unsigned int cpus_per_iaa;
 
 static struct crypto_comp *deflate_generic_tfm;
 
 /* Per-cpu lookup table for balanced wqs */
-static struct wq_table_entry __percpu *wq_table;
+static struct wq_table_entry __percpu *wq_table = NULL;
+
+/* Per-cpu lookup table for global wqs shared by all cpus. */
+static struct wq_table_entry __percpu *global_wq_table = NULL;
+
+/*
+ * Per-cpu counter of consecutive descriptors allocated to
+ * the same wq in the global_wq_table, so that we know
+ * when to switch to the next wq in the global_wq_table.
+ */
+static int __percpu *num_consec_descs_per_wq = NULL;
 
 static struct idxd_wq *wq_table_next_wq(int cpu)
 {
@@ -104,26 +113,68 @@ static void wq_table_add(int cpu, struct idxd_wq *wq)
 
 	entry->wqs[entry->n_wqs++] = wq;
 
-	pr_debug("%s: added iaa wq %d.%d to idx %d of cpu %d\n", __func__,
-		 entry->wqs[entry->n_wqs - 1]->idxd->id,
-		 entry->wqs[entry->n_wqs - 1]->id, entry->n_wqs - 1, cpu);
+	pr_debug("%s: added iaa local wq %d.%d to idx %d of cpu %d\n", __func__,
+		entry->wqs[entry->n_wqs - 1]->idxd->id,
+		entry->wqs[entry->n_wqs - 1]->id, entry->n_wqs - 1, cpu);
+}
+
+static void global_wq_table_add(int cpu, struct idxd_wq *wq)
+{
+	struct wq_table_entry *entry = per_cpu_ptr(global_wq_table, cpu);
+
+	if (WARN_ON(entry->n_wqs == entry->max_wqs))
+		return;
+
+	entry->wqs[entry->n_wqs++] = wq;
+
+	pr_debug("%s: added iaa global wq %d.%d to idx %d of cpu %d\n", __func__,
+		entry->wqs[entry->n_wqs - 1]->idxd->id,
+		entry->wqs[entry->n_wqs - 1]->id, entry->n_wqs - 1, cpu);
+}
+
+static void global_wq_table_set_start_wq(int cpu)
+{
+	struct wq_table_entry *entry = per_cpu_ptr(global_wq_table, cpu);
+	int start_wq = (entry->n_wqs / nr_iaa) * cpu_to_iaa(cpu);
+
+	if ((start_wq >= 0) && (start_wq < entry->n_wqs))
+		entry->cur_wq = start_wq;
 }
 
 static void wq_table_free_entry(int cpu)
 {
 	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
 
-	kfree(entry->wqs);
-	memset(entry, 0, sizeof(*entry));
+	if (entry) {
+		kfree(entry->wqs);
+		memset(entry, 0, sizeof(*entry));
+	}
+
+	entry = per_cpu_ptr(global_wq_table, cpu);
+
+	if (entry) {
+		kfree(entry->wqs);
+		memset(entry, 0, sizeof(*entry));
+	}
 }
 
 static void wq_table_clear_entry(int cpu)
 {
 	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
 
-	entry->n_wqs = 0;
-	entry->cur_wq = 0;
-	memset(entry->wqs, 0, entry->max_wqs * sizeof(struct idxd_wq *));
+	if (entry) {
+		entry->n_wqs = 0;
+		entry->cur_wq = 0;
+		memset(entry->wqs, 0, entry->max_wqs * sizeof(struct idxd_wq *));
+	}
+
+	entry = per_cpu_ptr(global_wq_table, cpu);
+
+	if (entry) {
+		entry->n_wqs = 0;
+		entry->cur_wq = 0;
+		memset(entry->wqs, 0, entry->max_wqs * sizeof(struct idxd_wq *));
+	}
 }
 
 LIST_HEAD(iaa_devices);
@@ -163,6 +214,70 @@ static ssize_t verify_compress_store(struct device_driver *driver,
 }
 static DRIVER_ATTR_RW(verify_compress);
 
+/* Number of global wqs per iaa*/
+static int g_wqs_per_iaa = 1;
+
+static ssize_t g_wqs_per_iaa_show(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%d\n", g_wqs_per_iaa);
+}
+
+static ssize_t g_wqs_per_iaa_store(struct device_driver *driver,
+				     const char *buf, size_t count)
+{
+	int ret = -EBUSY;
+
+	mutex_lock(&iaa_devices_lock);
+
+	if (iaa_crypto_enabled)
+		goto out;
+
+	ret = kstrtoint(buf, 10, &g_wqs_per_iaa);
+	if (ret)
+		goto out;
+
+	ret = count;
+out:
+	mutex_unlock(&iaa_devices_lock);
+
+	return ret;
+}
+static DRIVER_ATTR_RW(g_wqs_per_iaa);
+
+/*
+ * Number of consecutive descriptors to allocate from a
+ * given global wq before switching to the next wq in
+ * the global_wq_table.
+ */
+static int g_consec_descs_per_gwq = 1;
+
+static ssize_t g_consec_descs_per_gwq_show(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%d\n", g_consec_descs_per_gwq);
+}
+
+static ssize_t g_consec_descs_per_gwq_store(struct device_driver *driver,
+				     const char *buf, size_t count)
+{
+	int ret = -EBUSY;
+
+	mutex_lock(&iaa_devices_lock);
+
+	if (iaa_crypto_enabled)
+		goto out;
+
+	ret = kstrtoint(buf, 10, &g_consec_descs_per_gwq);
+	if (ret)
+		goto out;
+
+	ret = count;
+out:
+	mutex_unlock(&iaa_devices_lock);
+
+	return ret;
+}
+static DRIVER_ATTR_RW(g_consec_descs_per_gwq);
+
 /*
  * The iaa crypto driver supports three 'sync' methods determining how
  * compressions and decompressions are performed:
@@ -751,7 +866,20 @@ static void free_wq_table(void)
 	for (cpu = 0; cpu < nr_cpus; cpu++)
 		wq_table_free_entry(cpu);
 
-	free_percpu(wq_table);
+	if (wq_table) {
+		free_percpu(wq_table);
+		wq_table = NULL;
+	}
+
+	if (global_wq_table) {
+		free_percpu(global_wq_table);
+		global_wq_table = NULL;
+	}
+
+	if (num_consec_descs_per_wq) {
+		free_percpu(num_consec_descs_per_wq);
+		num_consec_descs_per_wq = NULL;
+	}
 
 	pr_debug("freed wq table\n");
 }
@@ -774,6 +902,38 @@ static int alloc_wq_table(int max_wqs)
 		}
 
 		entry->max_wqs = max_wqs;
+		entry->n_wqs = 0;
+		entry->cur_wq = 0;
+	}
+
+	global_wq_table = alloc_percpu(struct wq_table_entry);
+	if (!global_wq_table) {
+		free_wq_table();
+		return -ENOMEM;
+	}
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		entry = per_cpu_ptr(global_wq_table, cpu);
+		entry->wqs = kzalloc(GFP_KERNEL, max_wqs * sizeof(struct wq *));
+		if (!entry->wqs) {
+			free_wq_table();
+			return -ENOMEM;
+		}
+
+		entry->max_wqs = max_wqs;
+		entry->n_wqs = 0;
+		entry->cur_wq = 0;
+	}
+
+	num_consec_descs_per_wq = alloc_percpu(int);
+	if (!num_consec_descs_per_wq) {
+		free_wq_table();
+		return -ENOMEM;
+	}
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		int *num_consec_descs = per_cpu_ptr(num_consec_descs_per_wq, cpu);
+		*num_consec_descs = 0;
 	}
 
 	pr_debug("initialized wq table\n");
@@ -912,9 +1072,14 @@ static int wq_table_add_wqs(int iaa, int cpu)
 	}
 
 	list_for_each_entry(iaa_wq, &found_device->wqs, list) {
-		wq_table_add(cpu, iaa_wq->wq);
+
+		if (((found_device->n_wq - g_wqs_per_iaa) < 1) ||
+			(n_wqs_added < (found_device->n_wq - g_wqs_per_iaa))) {
+			wq_table_add(cpu, iaa_wq->wq);
+		}
+
 		pr_debug("rebalance: added wq for cpu=%d: iaa wq %d.%d\n",
-			 cpu, iaa_wq->wq->idxd->id, iaa_wq->wq->id);
+			cpu, iaa_wq->wq->idxd->id, iaa_wq->wq->id);
 		n_wqs_added++;
 	}
 
@@ -927,6 +1092,63 @@ static int wq_table_add_wqs(int iaa, int cpu)
 	return ret;
 }
 
+static int global_wq_table_add_wqs(void)
+{
+	struct iaa_device *iaa_device;
+	int ret = 0, n_wqs_added;
+	struct idxd_device *idxd;
+	struct iaa_wq *iaa_wq;
+	struct pci_dev *pdev;
+	struct device *dev;
+	int cpu, node, node_of_cpu = -1;
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+
+#ifdef CONFIG_NUMA
+		node_of_cpu = -1;
+		for_each_online_node(node) {
+			const struct cpumask *node_cpus;
+			node_cpus = cpumask_of_node(node);
+			if (!cpumask_test_cpu(cpu, node_cpus))
+				continue;
+			node_of_cpu = node;
+			break;
+		}
+#endif
+		list_for_each_entry(iaa_device, &iaa_devices, list) {
+			idxd = iaa_device->idxd;
+			pdev = idxd->pdev;
+			dev = &pdev->dev;
+
+#ifdef CONFIG_NUMA
+			if (dev && (node_of_cpu != dev->numa_node))
+				continue;
+#endif
+
+			if (iaa_device->n_wq <= g_wqs_per_iaa)
+				continue;
+
+			n_wqs_added = 0;
+
+			list_for_each_entry(iaa_wq, &iaa_device->wqs, list) {
+
+				if (n_wqs_added < (iaa_device->n_wq - g_wqs_per_iaa)) {
+					n_wqs_added++;
+				}
+				else {
+					global_wq_table_add(cpu, iaa_wq->wq);
+					pr_debug("rebalance: added global wq for cpu=%d: iaa wq %d.%d\n",
+						cpu, iaa_wq->wq->idxd->id, iaa_wq->wq->id);
+				}
+			}
+		}
+
+		global_wq_table_set_start_wq(cpu);
+	}
+
+	return ret;
+}
+
 /*
  * Rebalance the wq table so that given a cpu, it's easy to find the
  * closest IAA instance.  The idea is to try to choose the most
@@ -961,6 +1183,7 @@ static void rebalance_wq_table(void)
 	}
 
 	pr_debug("Finished rebalance local wqs.");
+	global_wq_table_add_wqs();
 }
 
 static inline int check_completion(struct device *dev,
@@ -1509,6 +1732,27 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	goto out;
 }
 
+/*
+ * Caller should make sure to call only if the
+ * per_cpu_ptr "global_wq_table" is non-NULL
+ * and has at least one wq configured.
+ */
+static struct idxd_wq *global_wq_table_next_wq(int cpu)
+{
+	struct wq_table_entry *entry = per_cpu_ptr(global_wq_table, cpu);
+	int *num_consec_descs = per_cpu_ptr(num_consec_descs_per_wq, cpu);
+
+	if ((*num_consec_descs) == g_consec_descs_per_gwq) {
+		if (++entry->cur_wq >= entry->n_wqs)
+			entry->cur_wq = 0;
+		*num_consec_descs = 0;
+	}
+
+	++(*num_consec_descs);
+
+	return entry->wqs[entry->cur_wq];
+}
+
 static int iaa_comp_acompress(struct acomp_req *req)
 {
 	struct iaa_compression_ctx *compression_ctx;
@@ -1521,6 +1765,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	struct idxd_wq *wq;
 	struct device *dev;
 	int order = -1;
+	struct wq_table_entry *entry;
 
 	compression_ctx = crypto_tfm_ctx(tfm);
 
@@ -1539,8 +1784,15 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		disable_async = true;
 
 	cpu = get_cpu();
-	wq = wq_table_next_wq(cpu);
+	entry = per_cpu_ptr(global_wq_table, cpu);
+
+	if (!entry || entry->n_wqs == 0) {
+		wq = wq_table_next_wq(cpu);
+	} else {
+		wq = global_wq_table_next_wq(cpu);
+	}
 	put_cpu();
+
 	if (!wq) {
 		pr_debug("no wq configured for cpu=%d\n", cpu);
 		return -ENODEV;
@@ -2393,13 +2645,32 @@ static int __init iaa_crypto_init_module(void)
 		goto err_sync_attr_create;
 	}
 
+	ret = driver_create_file(&iaa_crypto_driver.drv,
+				&driver_attr_g_wqs_per_iaa);
+	if (ret) {
+		pr_debug("IAA g_wqs_per_iaa attr creation failed\n");
+		goto err_g_wqs_per_iaa_attr_create;
+	}
+
+	ret = driver_create_file(&iaa_crypto_driver.drv,
+				&driver_attr_g_consec_descs_per_gwq);
+	if (ret) {
+		pr_debug("IAA g_consec_descs_per_gwq attr creation failed\n");
+		goto err_g_consec_descs_per_gwq_attr_create;
+	}
+
 	if (iaa_crypto_debugfs_init())
 		pr_warn("debugfs init failed, stats not available\n");
 
 	pr_debug("initialized\n");
 out:
 	return ret;
-
+err_g_consec_descs_per_gwq_attr_create:
+	driver_remove_file(&iaa_crypto_driver.drv,
+			   &driver_attr_g_wqs_per_iaa);
+err_g_wqs_per_iaa_attr_create:
+	driver_remove_file(&iaa_crypto_driver.drv,
+			   &driver_attr_sync_mode);
 err_sync_attr_create:
 	driver_remove_file(&iaa_crypto_driver.drv,
 			   &driver_attr_verify_compress);
@@ -2423,6 +2694,10 @@ static void __exit iaa_crypto_cleanup_module(void)
 			   &driver_attr_sync_mode);
 	driver_remove_file(&iaa_crypto_driver.drv,
 			   &driver_attr_verify_compress);
+	driver_remove_file(&iaa_crypto_driver.drv,
+			   &driver_attr_g_wqs_per_iaa);
+	driver_remove_file(&iaa_crypto_driver.drv,
+			   &driver_attr_g_consec_descs_per_gwq);
 	idxd_driver_unregister(&iaa_crypto_driver);
 	iaa_aecs_cleanup_fixed();
 	crypto_free_comp(deflate_generic_tfm);
-- 
2.27.0


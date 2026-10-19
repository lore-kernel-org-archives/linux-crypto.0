Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792451200;
	b=Q1c9th0LNsof/mEqlmnPb0/+PkL9GDWE10oJ3mGTibmCI22F/8uhia/fJFfTJdfMyHdL
	 vNkaqnkQC7LnMByXEbnQdyyvpC1VV3ewvp7lMiFncOzc6TlQ5o7Hf3yJcgHi9mKXEwQNY
	 yF1VMsPMC5qpYzlYDLlKp0apI5N0aVfV5CpStsVto9RfZ4fJbUwitw6ODMcy7udhTIQlu
	 8peMhxh32KkOfExxGJxhiGGXwxsT89mPAdiocadWet0UZ5W3QtrAgxRe6YgIGCA6njCk+
	 ZHWVrmnLzUu8ALKTYGhKJC6/tqMhk99RWZL0yTvK6bedpmcdjZ+srdkYGjTC3UNyc4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451200;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=g3BdDHh3BTnPGM5B1ujdXaWp8U7UJ72Q8JuIicpJ3lI=;
	b=UXBQMHBUyt/wHYSyZDyJ2IMKPdrxhD4YoL9v6Z8BNodba7+zD9Y3xzIH3EPNdkKk6T9N
	 8Li9Izju0F12ZAHmofaCxrFSh/0EBDid2EtrmKPcXxjfdLxEr0pWk8+azfvf+lkFFJhDl
	 0zZBUoCh48vAChk6bhuDo/XMn6PdDsi+lxpVsDexfkhNbJuhbvjZiBLi9M1seaqpVLKy4
	 VohvI3MQ7XOnIRoX8Ybqg7Nrw7d2W4o4tuWMuypNKcHiq1kM7eAPWWYU8m205w0nUkiTo
	 aoV3DSxoxJA4Fy26Ccc7/UuI6bVBqx+v2508/UNWKHPXkV3Td4CcfguFcZs2C9TjdSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UCyFcR5T;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F98606A325;
	Mon, 19 Oct 2026 23:06:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16F98606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UCyFcR5T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792451199; x=1823987199;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=ZcxsgC3FtqRT5Y9f+1FkuBukMapXLAzW6yrIOrmLswg=;
  b=UCyFcR5Tb/C1LRxzgtqNwIFwAMoCDmMjl3isQDUCr32fcCqm8djeeC/V
   RvLMQavUNvo9sleVos4sIn+rQ5BZ7ch1NIZBp6BGVoOECS0oDBpux/7fS
   b/7zzY4Jcf/3uvPBmQlEM7Tw+4aqsDabI7Fl7Jif7vlXy/XZYwqhBFuUL
   skO5Sd2awVj6+iPQ/ufi9tUiDvw7FRvtYZClhNQZgOS5XF9fGdFo3EAKH
   f0tcKMYltYva3gntriz1cIw3oW8ENYhJoEhXEbI2f9nIPyE3Q3cHmHtXI
   x5KsrKlVQsk94UYa0MT9vSXqGeKufV4YZjZoBTx4Nzk5Dk151OcFwBlns
   w==;
X-CSE-ConnectionGUID: Af1ANgGGSECmNdQrqNY9lw==
X-CSE-MsgGUID: ANYBzSFqSlWOTAkxDH08qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1249180"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1249180"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:36 -0700
X-CSE-ConnectionGUID: t7thm46JTS66/MjI7ppQtw==
X-CSE-MsgGUID: I6Ke3skiQ3yRkWkOKl66/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2989977"
Received: from vcostago-desk1.jf.intel.com (HELO [10.98.24.84]) ([10.98.24.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:35 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Mon, 19 Oct 2026 16:06:22 -0700
Subject: [PATCH 3/4] crypto: iaa - use RCU per-package WQ tables
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-iaa-crypto-wq-tables-v1-3-fab67b2a1538@intel.com>
References: <20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538@intel.com>
In-Reply-To: <20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538@intel.com>
To: Kristen Accardi <kristen.c.accardi@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
X-Mailer: b4 0.17-dev-6be7c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792451190; l=16357;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=ZcxsgC3FtqRT5Y9f+1FkuBukMapXLAzW6yrIOrmLswg=;
 b=fQ2lmr9hcu2M3ylgnq+ZwlQyEgQv9EjXJCjpspUrjbShCR2PNmq+sjt/Ngc8wIWpDyetKGonY
 LZYTQVuOuY7CTIBbflcBGTeQOtt1jnRnGbjjxD9quKd58HgYllTPbCF
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

rebalance_wq_table() gives CPU n all the WQs of IAA device
n / cpus_per_iaa. The flat index ignores package boundaries, so a CPU
can be paired with a device on another package, and each CPU sends all
its requests to one device while the other devices of its package stay
idle. The table is also rebuilt in place, so a request issued during a
probe or remove can read a NULL WQ and fail with -ENODEV.

Replace it with one table per package, holding the WQs of every IAA
device on that package, and have each CPU round-robin over its package's
table. Rebalance builds the whole set of tables and publishes it with
rcu_replace_pointer(). The submit paths look the WQ up, and take their
reference on it, inside an RCU read-side section.

- A package without IAA devices gets a copy of another package's table,
  so the lookup needs no fallback.
- Every table has room for all the WQs, a few pointers more than it
  needs, so they can be sized without counting per package.
- If a rebalance fails, the current tables are kept. On removal they
  are cleared instead, because they still hold the removed WQ. Removal
  then waits for a grace period before returning, because the idxd_wq
  can be freed after that.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |   7 -
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 346 ++++++++++-------------------
 2 files changed, 117 insertions(+), 236 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 56985e395263..aece8af011c2 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -79,13 +79,6 @@ struct iaa_device {
 	atomic64_t			decomp_bytes;
 };
 
-struct wq_table_entry {
-	struct idxd_wq **wqs;
-	int	max_wqs;
-	int	n_wqs;
-	int	cur_wq;
-};
-
 #define IAA_AECS_ALIGN			32
 
 /*
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 7b02d3836623..2ce545e8df42 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -12,7 +12,9 @@
 #include <linux/mempool.h>
 #include <uapi/linux/idxd.h>
 #include <linux/highmem.h>
+#include <linux/numa.h>
 #include <linux/sched/smt.h>
+#include <linux/topology.h>
 #include <crypto/internal/acompress.h>
 
 #include "idxd.h"
@@ -29,62 +31,34 @@
 
 /* number of iaa instances probed */
 static unsigned int nr_iaa;
-static unsigned int nr_cpus;
-static unsigned int nr_nodes;
-static unsigned int nr_cpus_per_node;
 
-/* Number of physical cpus sharing each iaa instance */
-static unsigned int cpus_per_iaa;
-
-/* Per-cpu lookup table for balanced wqs */
-static struct wq_table_entry __percpu *wq_table;
-
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
+struct iaa_pkg_table {
+	struct rcu_head	rcu;
+	int		n_wqs;
+	struct idxd_wq	*wqs[];
+};
 
-	return entry->wqs[entry->cur_wq];
-}
+/* Indexed by logical package id, the count is fixed at boot */
+static struct iaa_pkg_table __rcu **iaa_pkg_tables;
+static DEFINE_PER_CPU(unsigned int, iaa_wq_idx);
 
-static void wq_table_add(int cpu, struct idxd_wq *wq)
+static int iaa_cpu_pkg(int cpu)
 {
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
-
-	if (WARN_ON(entry->n_wqs == entry->max_wqs))
-		return;
-
-	entry->wqs[entry->n_wqs++] = wq;
+	int pkg = (cpu < nr_cpu_ids) ? topology_logical_package_id(cpu) : 0;
 
-	pr_debug("%s: added iaa wq %d.%d to idx %d of cpu %d\n", __func__,
-		 entry->wqs[entry->n_wqs - 1]->idxd->id,
-		 entry->wqs[entry->n_wqs - 1]->id, entry->n_wqs - 1, cpu);
+	return (pkg >= 0 && pkg < topology_max_packages()) ? pkg : 0;
 }
 
-static void wq_table_free_entry(int cpu)
+/* Round-robins over the WQs of the caller's package */
+static struct idxd_wq *iaa_next_wq(void)
 {
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+	struct iaa_pkg_table *table;
 
-	kfree(entry->wqs);
-	memset(entry, 0, sizeof(*entry));
-}
-
-static void wq_table_clear_entry(int cpu)
-{
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+	table = rcu_dereference(iaa_pkg_tables[iaa_cpu_pkg(raw_smp_processor_id())]);
+	if (!table)
+		return NULL;
 
-	entry->n_wqs = 0;
-	entry->cur_wq = 0;
-	memset(entry->wqs, 0, entry->max_wqs * sizeof(struct idxd_wq *));
+	return table->wqs[this_cpu_inc_return(iaa_wq_idx) % table->n_wqs];
 }
 
 LIST_HEAD(iaa_devices);
@@ -618,16 +592,6 @@ static void del_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
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
@@ -708,41 +672,19 @@ static int iaa_wq_put(struct idxd_wq *wq)
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
+/* Publishes @tables, or empties every slot if NULL, and frees the old ones */
+static void publish_pkg_tables(struct iaa_pkg_table **tables)
 {
-	struct wq_table_entry *entry;
-	int cpu;
-
-	wq_table = alloc_percpu(struct wq_table_entry);
-	if (!wq_table)
-		return -ENOMEM;
+	struct iaa_pkg_table *old;
+	int pkg;
 
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		entry = per_cpu_ptr(wq_table, cpu);
-		entry->wqs = kzalloc_objs(*entry->wqs, max_wqs);
-		if (!entry->wqs) {
-			free_wq_table();
-			return -ENOMEM;
-		}
-
-		entry->max_wqs = max_wqs;
+	for (pkg = 0; pkg < topology_max_packages(); pkg++) {
+		old = rcu_replace_pointer(iaa_pkg_tables[pkg],
+					  tables ? tables[pkg] : NULL,
+					  lockdep_is_held(&iaa_devices_lock));
+		if (old)
+			kfree_rcu(old, rcu);
 	}
-
-	pr_debug("initialized wq table\n");
-
-	return 0;
 }
 
 static int save_iaa_wq(struct idxd_wq *wq)
@@ -806,10 +748,6 @@ static int save_iaa_wq(struct idxd_wq *wq)
 
 	if (WARN_ON(nr_iaa == 0))
 		return -EINVAL;
-
-	cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
-	if (!cpus_per_iaa)
-		cpus_per_iaa = 1;
 out:
 	return ret;
 }
@@ -824,116 +762,71 @@ static void remove_iaa_wq(struct idxd_wq *wq)
 			break;
 		}
 	}
-
-	if (nr_iaa) {
-		cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
-		if (!cpus_per_iaa)
-			cpus_per_iaa = 1;
-	} else
-		cpus_per_iaa = 1;
 }
 
-static int wq_table_add_wqs(int iaa, int cpu)
+static int iaa_device_pkg(struct iaa_device *iaa_device)
 {
-	struct iaa_device *iaa_device, *found_device = NULL;
-	int ret = 0, cur_iaa = 0, n_wqs_added = 0;
-	struct idxd_device *idxd;
-	struct iaa_wq *iaa_wq;
-	struct pci_dev *pdev;
-	struct device *dev;
-
-	list_for_each_entry(iaa_device, &iaa_devices, list) {
-		idxd = iaa_device->idxd;
-		pdev = idxd->pdev;
-		dev = &pdev->dev;
-
-		if (cur_iaa != iaa) {
-			cur_iaa++;
-			continue;
-		}
+	int node = dev_to_node(&iaa_device->idxd->pdev->dev);
 
-		found_device = iaa_device;
-		dev_dbg(dev, "getting wq from iaa_device %d, cur_iaa %d\n",
-			found_device->idxd->id, cur_iaa);
-		break;
-	}
+	if (node == NUMA_NO_NODE)
+		node = first_online_node;
 
-	if (!found_device) {
-		found_device = list_first_entry_or_null(&iaa_devices,
-							struct iaa_device, list);
-		if (!found_device) {
-			pr_debug("couldn't find any iaa devices with wqs!\n");
-			ret = -EINVAL;
-			goto out;
-		}
-		cur_iaa = 0;
-
-		idxd = found_device->idxd;
-		pdev = idxd->pdev;
-		dev = &pdev->dev;
-		dev_dbg(dev, "getting wq from only iaa_device %d, cur_iaa %d\n",
-			found_device->idxd->id, cur_iaa);
-	}
-
-	list_for_each_entry(iaa_wq, &found_device->wqs, list) {
-		wq_table_add(cpu, iaa_wq->wq);
-		pr_debug("rebalance: added wq for cpu=%d: iaa wq %d.%d\n",
-			 cpu, iaa_wq->wq->idxd->id, iaa_wq->wq->id);
-		n_wqs_added++;
-	}
-
-	if (!n_wqs_added) {
-		pr_debug("couldn't find any iaa wqs!\n");
-		ret = -EINVAL;
-		goto out;
-	}
-out:
-	return ret;
+	return iaa_cpu_pkg(cpumask_first(cpumask_of_node(node)));
 }
 
-/*
- * Rebalance the wq table so that given a cpu, it's easy to find the
- * closest IAA instance.  The idea is to try to choose the most
- * appropriate IAA instance for a caller and spread available
- * workqueues around to clients.
- */
-static void rebalance_wq_table(void)
+static int rebalance_pkg_tables(void)
 {
-	const struct cpumask *node_cpus;
-	int node_cpu, node, cpu, iaa = 0;
+	struct iaa_pkg_table **tables, *table, *first = NULL;
+	struct iaa_device *iaa_device;
+	struct iaa_wq *iaa_wq;
+	int pkg, n_wqs = 0;
 
-	if (nr_iaa == 0)
-		return;
+	if (nr_iaa == 0) {
+		publish_pkg_tables(NULL);
+		return 0;
+	}
 
-	pr_debug("rebalance: nr_nodes=%d, nr_cpus %d, nr_iaa %d, cpus_per_iaa %d\n",
-		 nr_nodes, nr_cpus, nr_iaa, cpus_per_iaa);
+	tables = kzalloc_objs(*tables, topology_max_packages());
+	if (!tables)
+		return -ENOMEM;
 
-	clear_wq_table();
+	list_for_each_entry(iaa_device, &iaa_devices, list)
+		n_wqs += iaa_device->n_wq;
 
-	if (nr_iaa == 1) {
-		for_each_possible_cpu(cpu) {
-			if (WARN_ON(wq_table_add_wqs(0, cpu)))
+	/* Every table has room for all the WQs, a few more than it needs */
+	list_for_each_entry(iaa_device, &iaa_devices, list) {
+		pkg = iaa_device_pkg(iaa_device);
+		if (!tables[pkg]) {
+			tables[pkg] = kzalloc_flex(*tables[pkg], wqs, n_wqs);
+			if (!tables[pkg])
 				goto err;
 		}
-
-		return;
+		table = tables[pkg];
+		first = first ?: table;
+		list_for_each_entry(iaa_wq, &iaa_device->wqs, list)
+			table->wqs[table->n_wqs++] = iaa_wq->wq;
 	}
 
-	cpu = 0;
-	for_each_node_with_cpus(node) {
-		node_cpus = cpumask_of_node(node);
-
-		for_each_cpu(node_cpu, node_cpus) {
-			iaa = cpu / cpus_per_iaa;
-			if (WARN_ON(wq_table_add_wqs(iaa, node_cpu)))
-				goto err;
-			cpu++;
-		}
+	/* A package without IAA devices gets a copy of another one's table */
+	for (pkg = 0; pkg < topology_max_packages(); pkg++) {
+		if (tables[pkg])
+			continue;
+		tables[pkg] = kmemdup(first, struct_size(first, wqs, n_wqs),
+				      GFP_KERNEL);
+		if (!tables[pkg])
+			goto err;
 	}
 
-	return;
+	publish_pkg_tables(tables);
+	kfree(tables);
+
+	return 0;
 err:
-	pr_debug("could not add any wqs for iaa %d to cpu %d!\n", iaa, cpu);
+	for (pkg = 0; pkg < topology_max_packages(); pkg++)
+		kfree(tables[pkg]);
+	kfree(tables);
+
+	return -ENOMEM;
 }
 
 static inline int check_completion(struct device *dev,
@@ -1519,7 +1412,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	struct iaa_compression_ctx *compression_ctx;
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
-	int cpu, ret = 0;
+	int ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct idxd_wq *wq;
 	struct device *dev;
@@ -1544,17 +1437,13 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	if (sg_nents(req->src) > 1 || sg_nents(req->dst) > 1)
 		return deflate_generic_compress(req);
 
-	cpu = get_cpu();
-	wq = wq_table_next_wq(cpu);
-	put_cpu();
-	if (!wq) {
-		pr_debug("no wq configured for cpu=%d\n", cpu);
-		return -ENODEV;
-	}
-
-	ret = iaa_wq_get(wq);
+	/* The table, and its WQs until iaa_wq_get() returns, need RCU */
+	rcu_read_lock();
+	wq = iaa_next_wq();
+	ret = wq ? iaa_wq_get(wq) : -ENODEV;
+	rcu_read_unlock();
 	if (ret) {
-		pr_debug("no wq available for cpu=%d\n", cpu);
+		pr_debug("no wq available\n");
 		return -ENODEV;
 	}
 
@@ -1623,7 +1512,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
 	bool use_bounce_src = false;
-	int cpu, ret = 0;
+	int ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct device *dev;
 	struct idxd_wq *wq;
@@ -1653,17 +1542,13 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		use_bounce_src = true;
 	}
 
-	cpu = get_cpu();
-	wq = wq_table_next_wq(cpu);
-	put_cpu();
-	if (!wq) {
-		pr_debug("no wq configured for cpu=%d\n", cpu);
-		return -ENODEV;
-	}
-
-	ret = iaa_wq_get(wq);
+	/* The table, and its WQs until iaa_wq_get() returns, need RCU */
+	rcu_read_lock();
+	wq = iaa_next_wq();
+	ret = wq ? iaa_wq_get(wq) : -ENODEV;
+	rcu_read_unlock();
 	if (ret) {
-		pr_debug("no wq available for cpu=%d\n", cpu);
+		pr_debug("no wq available\n");
 		return -ENODEV;
 	}
 
@@ -1799,7 +1684,7 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 	struct idxd_device *idxd = wq->idxd;
 	struct idxd_driver_data *data = idxd->data;
 	struct device *dev = &idxd_dev->conf_dev;
-	bool first_wq = false;
+	bool first_wq;
 	int ret = 0;
 
 	if (idxd->state != IDXD_DEV_ENABLED)
@@ -1835,18 +1720,15 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 
 	mutex_lock(&iaa_devices_lock);
 
-	if (list_empty(&iaa_devices)) {
-		ret = alloc_wq_table(wq->idxd->max_wqs);
-		if (ret)
-			goto err_alloc;
-		first_wq = true;
-	}
+	first_wq = list_empty(&iaa_devices);
 
 	ret = save_iaa_wq(wq);
 	if (ret)
 		goto err_save;
 
-	rebalance_wq_table();
+	ret = rebalance_pkg_tables();
+	if (ret)
+		goto err_remove;
 
 	if (first_wq) {
 		iaa_crypto_enabled = true;
@@ -1854,7 +1736,7 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 		if (ret != 0) {
 			iaa_crypto_enabled = false;
 			dev_dbg(dev, "IAA compression device registration failed\n");
-			goto err_register;
+			goto err_remove;
 		}
 		try_module_get(THIS_MODULE);
 
@@ -1867,13 +1749,11 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 
 	return ret;
 
-err_register:
+err_remove:
 	remove_iaa_wq(wq);
 	free_iaa_wq(idxd_wq_get_private(wq));
+	rebalance_pkg_tables();
 err_save:
-	if (first_wq)
-		free_wq_table();
-err_alloc:
 	mutex_unlock(&iaa_devices_lock);
 	idxd_drv_disable_wq(wq);
 err:
@@ -1918,11 +1798,15 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 	}
 
 	idxd_drv_disable_wq(wq);
-	rebalance_wq_table();
+
+	if (rebalance_pkg_tables()) {
+		/* The old tables still hold the removed WQ */
+		publish_pkg_tables(NULL);
+		pr_warn("%s: failed to rebalance the WQ tables\n", __func__);
+	}
 
 	if (nr_iaa == 0) {
 		iaa_crypto_enabled = false;
-		free_wq_table();
 		module_put(THIS_MODULE);
 
 		pr_info("iaa_crypto now DISABLED\n");
@@ -1930,6 +1814,9 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 out:
 	mutex_unlock(&iaa_devices_lock);
 	mutex_unlock(&wq->wq_lock);
+
+	/* The idxd_wq can be freed after this, so wait for old table readers */
+	synchronize_rcu();
 }
 
 static enum idxd_dev_type dev_types[] = {
@@ -1948,16 +1835,15 @@ static struct idxd_device_driver iaa_crypto_driver = {
 static int __init iaa_crypto_init_module(void)
 {
 	int ret = 0;
-	int node;
+	int cpu;
 
-	nr_cpus = num_possible_cpus();
-	for_each_node_with_cpus(node)
-		nr_nodes++;
-	if (!nr_nodes) {
-		pr_err("IAA couldn't find any nodes with cpus\n");
-		return -ENODEV;
-	}
-	nr_cpus_per_node = nr_cpus / nr_nodes;
+	iaa_pkg_tables = kzalloc_objs(*iaa_pkg_tables, topology_max_packages());
+	if (!iaa_pkg_tables)
+		return -ENOMEM;
+
+	/* Start each CPU on a different WQ */
+	for_each_possible_cpu(cpu)
+		per_cpu(iaa_wq_idx, cpu) = cpu;
 
 	ret = iaa_aecs_init_fixed();
 	if (ret < 0) {
@@ -2009,6 +1895,7 @@ static int __init iaa_crypto_init_module(void)
 err_bounce_pool:
 	iaa_aecs_cleanup_fixed();
 err_aecs_init:
+	kfree(iaa_pkg_tables);
 
 	goto out;
 }
@@ -2026,6 +1913,7 @@ static void __exit iaa_crypto_cleanup_module(void)
 	mempool_destroy(iaa_bounce_pool);
 	iaa_bounce_pool = NULL;
 	iaa_aecs_cleanup_fixed();
+	kfree(iaa_pkg_tables);
 
 	pr_debug("cleaned up\n");
 }

-- 
2.56.0


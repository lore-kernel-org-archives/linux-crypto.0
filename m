Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794FE20B215;
	Wed,  6 Nov 2024 19:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920875; cv=none; b=Q6NcNkdiSrUoE6QLUbusaVfMLlBl/VbYqGru4e5Z/DBLldqGiOOrWiu5RTN8nZrA48IpbACmsjuzdYDhQOH9XvXuzmkzrijf2AYobXBp2Q4XtILAzTNdkd7MalCnvYMmx28bX2OT/b82hBskkBngwUii3VmYMIjp0HC5aBDBLtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920875; c=relaxed/simple;
	bh=dsGJj+DqE0i7pg9VVqHrElSTuA3RtibV8w9INDbEh+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rHbHShpWLzgG3L3TZM98TJrBZK1YmzDWDqrHncGuuPkxy81sHjiJPPBBvrUmeNY3jOku3VvzhB3/OxZIzsD+9rLRxNkq+Xa3RFHFjcoWRvab5okLMk4n3ZvKeFcCvtL4DHnbCmQZnCneF+KgYuZ8vjweBZqB1WP8CzOUHObXtTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XO+YyNNi; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XO+YyNNi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730920873; x=1762456873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dsGJj+DqE0i7pg9VVqHrElSTuA3RtibV8w9INDbEh+Q=;
  b=XO+YyNNiQ0RvNADCKEmBzDHpHNKrJ7UX3aKVUe180rYckDBeJuk2a4DK
   TF+0Ym+HHyZjdVXdS67zRmMMxG9EJsOq2Ms74m+ANVV3QhuLhNLED75Kj
   Z68hJAlJqxuqLyzqTOmVME2LUVJEh823pftPv2d7lXIFceLKTTCoAA6P9
   lHjWasRlS+WQaavJxJ+CDmbLNHF+WWUxM1DrOarY3HsWJetcKu/9bhIzb
   aiOMav0LVm4Bmj44go6I02IsIsMidBB1D/79DFCzolb1in3L8H0JYfLit
   4lBrWNU1V54FyLEH92degiKLPtrD15PWr1K8HAU3tz61BCzKcmKHqnszY
   A==;
X-CSE-ConnectionGUID: tqeKeSb6S1mi/R/gFUrbjA==
X-CSE-MsgGUID: KS5l0Q5hQauDjHsvgp2tAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41291997"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41291997"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 11:21:10 -0800
X-CSE-ConnectionGUID: OWkevIq+QMWqgKgle/FXXA==
X-CSE-MsgGUID: mh/T3E6IR1CskRaqe4OZ8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="88695393"
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
Subject: [PATCH v3 06/13] crypto: iaa - Change cpu-to-iaa mappings to evenly balance cores to IAAs.
Date: Wed,  6 Nov 2024 11:20:58 -0800
Message-Id: <20241106192105.6731-7-kanchana.p.sridhar@intel.com>
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

This change distributes the cpus more evenly among the IAAs in each socket.

 Old algorithm to assign cpus to IAA:
 ------------------------------------
 If "nr_cpus" = nr_logical_cpus (includes hyper-threading), the current
 algorithm determines "nr_cpus_per_node" = nr_cpus / nr_nodes.

 Hence, on a 2-socket Sapphire Rapids server where each socket has 56 cores
 and 4 IAA devices, nr_cpus_per_node = 112.

 Further, cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa
 Hence, cpus_per_iaa = 224/8 = 28.

 The iaa_crypto driver then assigns 28 "logical" node cpus per IAA device
 on that node, that results in this cpu-to-iaa mapping:

 lscpu|grep NUMA
 NUMA node(s):        2
 NUMA node0 CPU(s):   0-55,112-167
 NUMA node1 CPU(s):   56-111,168-223

 NUMA node 0:
 cpu   0-27    28-55  112-139  140-167
 iaa   iax1    iax3   iax5     iax7

 NUMA node 1:
 cpu   56-83  84-111  168-195   196-223
 iaa   iax9   iax11   iax13     iax15

 This appears non-optimal for a few reasons:

 1) The 2 logical threads on a core will get assigned to different IAA
    devices. For e.g.:
      cpu 0:   iax1
      cpu 112: iax5
 2) One of the logical threads on a core is assigned to an IAA that is not
    closest to that core. For e.g. cpu 112.
 3) If numactl is used to start processes sequentially on the logical
    cores, some of the IAA devices on the socket could be over-subscribed,
    while some could be under-utilized.

This patch introduces a scheme to more evenly balance the logical cores to
IAA devices on a socket.

 New algorithm to assign cpus to IAA:
 ------------------------------------
 We introduce a function "cpu_to_iaa()" that takes a logical cpu and
 returns the IAA device closest to it.

 If "nr_cpus" = nr_logical_cpus (includes hyper-threading), the new
 algorithm determines "nr_cpus_per_node" = topology_num_cores_per_package().

 Hence, on a 2-socket Sapphire Rapids server where each socket has 56 cores
 and 4 IAA devices, nr_cpus_per_node = 56.

 Further, cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa
 Hence, cpus_per_iaa = 112/8 = 14.

 The iaa_crypto driver then assigns 14 "logical" node cpus per IAA device
 on that node, that results in this cpu-to-iaa mapping:

 NUMA node 0:
 cpu   0-13,112-125   14-27,126-139  28-41,140-153  42-55,154-167
 iaa   iax1           iax3           iax5           iax7

 NUMA node 1:
 cpu   56-69,168-181  70-83,182-195  84-97,196-209   98-111,210-223
 iaa   iax9           iax11          iax13           iax15

 This resolves the 3 issues with non-optimality of cpu-to-iaa mappings
 pointed out earlier with the existing approach.

Originally-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 84 ++++++++++++++--------
 1 file changed, 54 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index c4b143dd1ddd..a12a8f9caa84 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -55,6 +55,46 @@ static struct idxd_wq *wq_table_next_wq(int cpu)
 	return entry->wqs[entry->cur_wq];
 }
 
+/*
+ * Given a cpu, find the closest IAA instance.  The idea is to try to
+ * choose the most appropriate IAA instance for a caller and spread
+ * available workqueues around to clients.
+ */
+static inline int cpu_to_iaa(int cpu)
+{
+	int node, n_cpus = 0, test_cpu, iaa = 0;
+	int nr_iaa_per_node;
+	const struct cpumask *node_cpus;
+
+	if (!nr_nodes)
+		return 0;
+
+	nr_iaa_per_node = nr_iaa / nr_nodes;
+	if (!nr_iaa_per_node)
+		return 0;
+
+	for_each_online_node(node) {
+		node_cpus = cpumask_of_node(node);
+		if (!cpumask_test_cpu(cpu, node_cpus))
+			continue;
+
+		for_each_cpu(test_cpu, node_cpus) {
+			if ((n_cpus % nr_cpus_per_node) == 0)
+				iaa = node * nr_iaa_per_node;
+
+			if (test_cpu == cpu)
+				return iaa;
+
+			n_cpus++;
+
+			if ((n_cpus % cpus_per_iaa) == 0)
+				iaa++;
+		}
+	}
+
+	return -1;
+}
+
 static void wq_table_add(int cpu, struct idxd_wq *wq)
 {
 	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
@@ -895,8 +935,7 @@ static int wq_table_add_wqs(int iaa, int cpu)
  */
 static void rebalance_wq_table(void)
 {
-	const struct cpumask *node_cpus;
-	int node, cpu, iaa = -1;
+	int cpu, iaa;
 
 	if (nr_iaa == 0)
 		return;
@@ -906,37 +945,22 @@ static void rebalance_wq_table(void)
 
 	clear_wq_table();
 
-	if (nr_iaa == 1) {
-		for (cpu = 0; cpu < nr_cpus; cpu++) {
-			if (WARN_ON(wq_table_add_wqs(0, cpu))) {
-				pr_debug("could not add any wqs for iaa 0 to cpu %d!\n", cpu);
-				return;
-			}
-		}
-
-		return;
-	}
-
-	for_each_node_with_cpus(node) {
-		node_cpus = cpumask_of_node(node);
-
-		for (cpu = 0; cpu <  cpumask_weight(node_cpus); cpu++) {
-			int node_cpu = cpumask_nth(cpu, node_cpus);
-
-			if (WARN_ON(node_cpu >= nr_cpu_ids)) {
-				pr_debug("node_cpu %d doesn't exist!\n", node_cpu);
-				return;
-			}
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		iaa = cpu_to_iaa(cpu);
+		pr_debug("rebalance: cpu=%d iaa=%d\n", cpu, iaa);
 
-			if ((cpu % cpus_per_iaa) == 0)
-				iaa++;
+		if (WARN_ON(iaa == -1)) {
+			pr_debug("rebalance (cpu_to_iaa(%d)) failed!\n", cpu);
+			return;
+		}
 
-			if (WARN_ON(wq_table_add_wqs(iaa, node_cpu))) {
-				pr_debug("could not add any wqs for iaa %d to cpu %d!\n", iaa, cpu);
-				return;
-			}
+		if (WARN_ON(wq_table_add_wqs(iaa, cpu))) {
+			pr_debug("could not add any wqs for iaa %d to cpu %d!\n", iaa, cpu);
+			return;
 		}
 	}
+
+	pr_debug("Finished rebalance local wqs.");
 }
 
 static inline int check_completion(struct device *dev,
@@ -2332,7 +2356,7 @@ static int __init iaa_crypto_init_module(void)
 		pr_err("IAA couldn't find any nodes with cpus\n");
 		return -ENODEV;
 	}
-	nr_cpus_per_node = nr_cpus / nr_nodes;
+	nr_cpus_per_node = topology_num_cores_per_package();
 
 	if (crypto_has_comp("deflate-generic", 0, 0))
 		deflate_generic_tfm = crypto_alloc_comp("deflate-generic", 0, 0);
-- 
2.27.0


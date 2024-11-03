Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5F713C914;
	Sun,  3 Nov 2024 03:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730604082; cv=none; b=piGUQYVU+cbtbiy8WxzvgXaVA7AchW1xMi+X8Q11zmsozqQ21mF/fjKinyUZF7oN7TF2foPwkuFtSCv5KXBGlJ+L3otnNixQLQ3Kd3yr3gFbxgcDebYudflGcaoI/tA+lKUAwOFRHQE4uDP3h+F0T6T99zHFe0sLYVm6P1TikpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730604082; c=relaxed/simple;
	bh=dsGJj+DqE0i7pg9VVqHrElSTuA3RtibV8w9INDbEh+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZxYrLJ7Ck17eJT+Q1aYUiJ3LEvM/U10QpjlHUpGi+XUy8b/GGetlzwsLQz0ZgxxPvnI7KBzIiPGZ/0e02mkWq5+hAxTrKsCPNRAGBTJjuyu7U/4EN8eHwLqptGjOoYbv5P4YioBQNqQjFTyrOk3EWbFd2LN7KK8/pxpLwamxGno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iFuJIJ5F; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iFuJIJ5F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730604080; x=1762140080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dsGJj+DqE0i7pg9VVqHrElSTuA3RtibV8w9INDbEh+Q=;
  b=iFuJIJ5FiFXaf0MG4Qd0NZFBwLh8fV7JICB3nKpzXADRAk/bH/zdIfO9
   gUt2BRU2OY92w2NGeNHgs5lUonWSC/QQ8jrv2b7DZ1Dh98tLGDpUe7OjH
   Rsp+P7Aj+nfP5XOZvjJrMoi6cO3bOM8YnG55No5eqrhAg+cyxth7lPntx
   d7CTV/GFsi52YZz6xvLUPz8FHlyThcffYlug58cZpOFmUoL6rqUilC49L
   qzds90jO2FNY40NgimSkCokWFcRn1GFXT4l6jXt5cE5sDLXPbeDvgI1pb
   VBMrJ1t/TLpvakY04MXmAIXbmopYlWijFoqcchCTwjwJuEkum8Xgdgfne
   g==;
X-CSE-ConnectionGUID: pMBkbEcsTHKRDoSRPGJ4CQ==
X-CSE-MsgGUID: nCOjLvmfS/C+tvQy5WDxKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11244"; a="30548285"
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="30548285"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2024 20:21:13 -0700
X-CSE-ConnectionGUID: r4p/5N5kTQ6zqMjLh5lsKg==
X-CSE-MsgGUID: MBv2V3OuTLWdRXqpDMTzfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="83451885"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 02 Nov 2024 20:21:14 -0700
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
Subject: [PATCH v2 06/13] crypto: iaa - Change cpu-to-iaa mappings to evenly balance cores to IAAs.
Date: Sat,  2 Nov 2024 20:21:04 -0700
Message-Id: <20241103032111.333282-7-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
References: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
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


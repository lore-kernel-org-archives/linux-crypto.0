Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010053.outbound.protection.outlook.com [52.101.56.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56473BC680;
	Mon, 27 Jul 2026 19:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785179152; cv=fail; b=XBi0Lwsc/c1CquDgrSxRYXP7o750qH6vfjsKU9+yupGjxK7oFgkg+7f01T3v9bfiVn6u1ePakSu55b0Fk0CVRU6V/m9SqkclUm84gq1GOfjANKc2Qg3ZjDMT5BT5chkdTjBgPainaWjh6X28CCwZQvVYOXJN8eSEBs2G64ScAjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785179152; c=relaxed/simple;
	bh=vo6HbOYfMZbleaZUJ4hOg/CLvgHeg2fzHzn7gS7kFw4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EO7uTYiIkLcCSA76fmC/eRY9qtKFvCpMpJhz3qgK+LaJnAL0r79DWKtTh41Kflq10Fr9+iybQVk7g7ecjR1fF/WiTCpqm4z6rbzo3tyLyckAcjHdZzLF8fHXK5j3z/Xd0ihgOFz+Vx1DbxiKDoXw/L6KObvGqhd79wAVXUdj4KU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xaJKUNI9; arc=fail smtp.client-ip=52.101.56.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xaJKUNI9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PRtFEXiE4fpTGfq0E86uNcYz737d3ILDQ+GMlGjyo2RC4pLm1nL7W/OrMxQ6Vg3Ar1AhneRyA2VpeJyKx3kkFJkB4QCivd0qtcIX5LEkRKNBpWiF7sUKkZ84nw5m5ho/TrErgs7UJ+M+m7DQMrlypDkLTJqzhh2946gxf29vjR25Kw0gRWye/nvlCrvFdghGMxZjrNIdFP1nLOhseSQK2+89m0MwmqRhLUuHDfQTTnSeKlMyR668Sd6VD8modJlvVolVRQgvTeySFJE9cQ8QX/shDTRz4k+QtynphcSZVIJJEZuMlRVDKvUvYB96cZkVdJ+UTffNFOg5IVA6oGRaFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wXq+8sW9PFdvgrSmcG0DxRmLbgs7pEXf7wugdvljRA=;
 b=KlRH3/stdAgdMVxB3YBXpSRAVGkhz8mdttbziVzZPPPYHmU/xyNUzXLlO79o8Ect35J85/14yREOjU3/0KFEiTovahfdenYWxO3hg9MDqAkqZ0d8xMgrKEXDL8uKVvksnYb37XkPvWKGRVKczhKP4k8B3gr9P+qPY6w4d1CuAxw3BIbKS7xUeK9ka2lAYdHPZ44kn3CgNPGeD16gPpXVCdw/nmSwIy1Cwej/uzE4mF0ic/NCacokjiNoCHGQSSnzsddKabHUXhLJM/jdITkZXkmV+/e6nn6kwmS6n+r8ec3+tF2I4Sdj3KMH7djDb3XoL7o+GBQzgAzN4pTb0ukUSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wXq+8sW9PFdvgrSmcG0DxRmLbgs7pEXf7wugdvljRA=;
 b=xaJKUNI9Z4UYa4eqY42gw/Dc7dhx2yqsOZJEJPGMKY6vWQ6dIfVZlbbaZzKU8PslZjJMOD8dREtD4jdY2OHri5cPwLWFGWqtxCfFFPlfvTAWTaP/H1uMh3TbSEKVque44lGxjV6gp/lqMPu6OrgsxhIagtVI6fYk8a5is4UbNKw=
Received: from BY5PR03CA0007.namprd03.prod.outlook.com (2603:10b6:a03:1e0::17)
 by LV1PR12MB999330.namprd12.prod.outlook.com (2603:10b6:408:3f8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 19:05:44 +0000
Received: from CO1PEPF00012E81.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::7f) by BY5PR03CA0007.outlook.office365.com
 (2603:10b6:a03:1e0::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.12 via Frontend Transport; Mon,
 27 Jul 2026 19:05:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF00012E81.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Mon, 27 Jul 2026 19:05:44 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 14:05:44 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 12:05:42 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <ackerleytng@google.com>, <jackyli@google.com>,
	<pgonda@google.com>, <rientjes@google.com>, <jacobhxu@google.com>,
	<xin@zytor.com>, <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v11 4/6] x86/sev: Add support to perform RMP optimizations asynchronously
Date: Mon, 27 Jul 2026 19:05:29 +0000
Message-ID: <7f582569acea933c3045be604a81975e29b5ee2b.1784844080.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784844080.git.ashish.kalra@amd.com>
References: <cover.1784844080.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E81:EE_|LV1PR12MB999330:EE_
X-MS-Office365-Filtering-Correlation-Id: dde968d2-4044-4143-aac0-08deec120f6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|376014|7416014|1800799024|36860700016|921020|6133799003|11063799006|56012099006|18002099003|10067099003|22082099003|5023799004|3023799007;
X-Microsoft-Antispam-Message-Info:
	EriSgieNNs5sNKleHYDprobhrMx3vmTUvACmeFS4swqalrqBfGeOt0hCUpJ/sR1Oz5VKhlosu8kwGItoZ6bjqSfgjpYLb97csxaijPaelXcKogMhTPiTQecP2WLk0w4vBd7YjIjxUZkomyKVbjwKvwcD5kBB4CFu8fkTHkQmWO2KsR8JYrG3NfU7Zp/hpPJHBQzVxJIeW1T2U25HAswvs6/6Sf0oShplgWERd6+LcmdNVB3DO5hZza1jm62bHTPA6RLCwbzxDmSPke8VVPCuKHHKxXwaC8Tzvu/7fblfbgnPftxzrHF8Yb7/S9ApkyMF7GKbgSQXP3ecbSZRaO/6wmfiBW7he1Y1rBDI4rRCd1BHJ9wEm1HmauXzlOvmdNIFw3fSHElFCfVZJ8uyKOGfOJSZIL1saXvfPWN1C5gfxVcznThqqS95wv8ke+2iV9I56vuf2+ljqrTUeCSzT3p0td/oNPl5k9+LayXv/q1bIH+lLR2wxZ244zvRm90BgGRLiMeK/NrdDDWuMa9JSIzI2wk3rjXkpI4+y78nAO9QgmsOrh2aV7J+QIpn/7KoUpgJcFkWrCSlrugzcpIMa3Nko42bxqcrL1u17QAVN4HIDx5J8kBB+JRuRvU/YaLKwhnk3JHd6wHa+ezLHzH7hijdZpmuuo7xYqsutpcfMctjjS+ohB8UHo2jRt7FyVimnEI2VR//0aEK5WPOGaXdpZNVKhz3RSIv3MunPsvA0bxTVSlhXiiNAZzQbmfAr1ces77P
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(376014)(7416014)(1800799024)(36860700016)(921020)(6133799003)(11063799006)(56012099006)(18002099003)(10067099003)(22082099003)(5023799004)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GFE6dXXwN5myJhOLTqvi/DSP6spstRBeZkYgp7HZdl1pm1DJPPS9RQmoTNh7A+7A4OR8p6nYS7oCWQQkSS/WSMiohN6GgVYecUMmqsvBeP40BFaQq849gadmJaIBisCrYT+q7Vy8bDIb4He4dmyy0rRIR8UuB7+nVRZtryO8DkLDM8zxOQYY5C9tleDtXbeG/SmjYJioZbMd+Z76UBmxpdKhTs6mrFobKvGE8sk4MCBfCgY5wq4oZE8UpX07HzVWfPstR9chl57xXarthmRYuRak9G83ClbNgoKbqtisyb3Smu19qqXnPdh9fFzfNwH84aJf0MjYavYaogQef6G6P7b8a5PV0JcoUb01kaGgqhL2H1oYLeS1pfdmxZtyDWhT5cN+iSdZGcN4DdZCfmugbH1Se3U2rViKRHhCmT4fa7tJCnVLRSA756rqo8X+SAtX
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 19:05:44.4613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dde968d2-4044-4143-aac0-08deec120f6a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E81.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB999330

From: Ashish Kalra <ashish.kalra@amd.com>

When SEV-SNP is enabled, all writes to memory are checked to ensure
integrity of SNP guest memory. This imposes performance overhead on the
whole system.

RMPOPT is a new instruction that minimizes the performance overhead of
RMP checks on the hypervisor and on non-SNP guests by allowing RMP
checks to be skipped for 1GB regions of memory that are known not to
contain any SEV-SNP guest memory.

Add support for performing RMP optimizations asynchronously using a
dedicated workqueue.

Enable RMPOPT optimizations for up to 2TB of system RAM starting from
the lowest physical memory address aligned down to a 1GB boundary at
RMP initialization time. RMP checks can initially be skipped for 1GB
memory ranges that do not contain SEV-SNP guest memory (excluding
preassigned pages such as the RMP table and firmware pages). As SNP
guests are launched, RMPUPDATE will disable the corresponding RMPOPT
optimizations.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 160 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 158 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 8bfd80284836..04b19e64f832 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/iommu.h>
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
+#include <linux/workqueue.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -125,7 +126,18 @@ static void *rmp_bookkeeping __ro_after_init;
 static u64 probed_rmp_base, probed_rmp_size;
 
 static cpumask_var_t rmpopt_cpumask;
-static phys_addr_t rmpopt_pa_start;
+static phys_addr_t rmpopt_pa_start, rmpopt_pa_end;
+
+enum rmpopt_function {
+	RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS,
+	RMPOPT_FUNC_REPORT_STATUS
+};
+
+#define RMPOPT_WORK_TIMEOUT	10000
+
+static struct workqueue_struct *rmpopt_wq;
+static struct delayed_work rmpopt_delayed_work;
+static DEFINE_MUTEX(rmpopt_wq_mutex);
 
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
@@ -565,11 +577,20 @@ static void snp_cleanup_rmpopt(void)
 {
 	int cpu;
 
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	if (!rmpopt_wq)
+		return;
+
+	cancel_delayed_work_sync(&rmpopt_delayed_work);
+	destroy_workqueue(rmpopt_wq);
+
 	for_each_cpu(cpu, rmpopt_cpumask)
 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
 
 	free_cpumask_var(rmpopt_cpumask);
-	rmpopt_pa_start = 0;
+	rmpopt_pa_start = rmpopt_pa_end = 0;
+	rmpopt_wq = NULL;
 }
 
 void snp_shutdown(void)
@@ -599,6 +620,96 @@ static bool rmpopt_capable(void)
 	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
 }
 
+/*
+ * RMPOPT: F2 0F 01 FC
+ *   Input:  RAX = system physical address (1GB aligned)
+ *           RCX = operation type
+ *   Output: CF set if the range was optimized
+ */
+static inline bool __rmpopt(u64 pa_start, u64 op_type)
+{
+	bool optimized;
+
+	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
+		     : "=@ccc" (optimized)
+		     : "a" (pa_start), "c" (op_type)
+		     : "memory", "cc");
+
+	return optimized;
+}
+
+static void rmpopt(u64 pa)
+{
+	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
+	u64 op_type = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;
+
+	__rmpopt(pa_start, op_type);
+}
+
+/*
+ * 'val' is a system physical address.
+ */
+static void rmpopt_smp(void *val)
+{
+	rmpopt((u64)val);
+}
+
+/*
+ * RMPOPT optimizations skip RMP checks at 1GB granularity if this
+ * range of memory does not contain any SNP guest memory.
+ */
+static void rmpopt_work_handler(struct work_struct *work)
+{
+	cpumask_var_t follower_mask;
+	phys_addr_t pa;
+	int this_cpu;
+
+	pr_info("Attempt RMP optimizations on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
+		rmpopt_pa_start, rmpopt_pa_end);
+
+	if (!alloc_cpumask_var(&follower_mask, GFP_KERNEL)) {
+		pr_warn("RMP optimization pass skipped: cpumask allocation failed\n");
+		return;
+	}
+
+	/*
+	 * RMPOPT scans the RMP table, stores the result of the scan in the
+	 * reserved processor memory. The RMP scan is the most expensive
+	 * part. If a second RMPOPT occurs, it can skip the expensive scan
+	 * if they can see a cached result in the reserved processor memory.
+	 *
+	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
+	 * on every other primary thread. Followers are "designed to"
+	 * skip the scan if they see the "cached" scan results.
+	 *
+	 * Pin the worker to the current CPU for the leader loop so that
+	 * this_cpu remains valid and the RMPOPT instruction executes on
+	 * the correct CPU.  Use migrate_disable() rather than get_cpu() to
+	 * prevent migration while still allowing preemption.
+	 */
+	migrate_disable();
+	this_cpu = smp_processor_id();
+
+	cpumask_andnot(follower_mask, rmpopt_cpumask,
+		       topology_sibling_cpumask(this_cpu));
+
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
+		rmpopt(pa);
+
+	migrate_enable();
+
+	/*
+	 * Followers: run RMPOPT on the remaining cores.  cpus_read_lock() is
+	 * intentionally not held here: CPU hotplug is disabled for the entire
+	 * time SNP is active (see snp_prepare()), and this work only runs while
+	 * SNP is active, so the follower set stays valid across the whole scan.
+	 */
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
+		on_each_cpu_mask(follower_mask, rmpopt_smp, (void *)pa, true);
+
+	free_cpumask_var(follower_mask);
+}
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
@@ -607,8 +718,38 @@ void snp_setup_rmpopt(void)
 	if (!rmpopt_capable())
 		return;
 
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	/*
+	 * On re-initialization after a legacy SNP shutdown (SNP_SHUTDOWN_EX
+	 * with x86_snp_shutdown=0), snp_shutdown() and thus snp_cleanup_rmpopt()
+	 * are skipped, so the workqueue, delayed work, cpumask and per-CPU
+	 * RMPOPT_BASE MSRs are still set up and valid (SnpEn stayed set and
+	 * CPU hotplug stayed disabled).  Rather than re-doing the setup, which
+	 * would leak the existing state, just re-queue the optimization pass
+	 * to re-optimize any memory the previous SNP session de-optimized.
+	 */
+	if (rmpopt_wq) {
+		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
+		return;
+	}
+
+	/*
+	 * Create an RMPOPT-specific workqueue to avoid scheduling
+	 * RMPOPT workitem on the global system workqueue.
+	 */
+	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_UNBOUND, 1);
+	if (!rmpopt_wq) {
+		pr_err("Failed to allocate RMPOPT workqueue\n");
+		return;
+	}
+
+	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
+
 	if (!zalloc_cpumask_var(&rmpopt_cpumask, GFP_KERNEL)) {
 		pr_err("Failed to allocate RMPOPT cpumask\n");
+		destroy_workqueue(rmpopt_wq);
+		rmpopt_wq = NULL;
 		return;
 	}
 
@@ -630,6 +771,21 @@ void snp_setup_rmpopt(void)
 	 */
 	for_each_cpu(cpu, rmpopt_cpumask)
 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+
+	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
+
+	/* Limit memory scanning to 2TB of RAM */
+	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T) {
+		pr_info("RMPOPT coverage limited to 2TB; memory above 0x%llx not optimized\n",
+			rmpopt_pa_start + SZ_2T);
+		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
+	}
+
+	/*
+	 * Once all per-CPU RMPOPT tables have been configured, enable RMPOPT
+	 * optimizations on all physical memory.
+	 */
+	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
 
-- 
2.43.0


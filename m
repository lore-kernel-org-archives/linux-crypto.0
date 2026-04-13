Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011019.outbound.protection.outlook.com [40.107.208.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3CB2E9757;
	Mon, 13 Apr 2026 19:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109434; cv=fail; b=sQSuE9Gh9jdo4F4DM0c4fBR6rzOhJQG+NmSAOiS5vHVGmyeju/gb/h0X0GoyITrpEz4G7C1WROwV7CCqcF2KB96pW4sxiLp+Bx2I3GdY7iWU99lsjSAnAYUSlBEArQ1WWR7c6pfSMEEHvl0L14dH4grZ/39dFFEAm9Cm/MOBO48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109434; c=relaxed/simple;
	bh=ucVfFoIp2j1kwu8zgC9oBieam6I6atr8HtcLKO1PjqU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bb2hN1XoZk1QIsonKJGlGypSHlX2N9tB5sycA4JRlIg7tjNZo9d96k772t6axQYmCpEWu5a3GfpvmcA6t+jESYAUAGDHNUnZ+fUdEIYg54nQoZbarFNyUfinLFDlTdFRuYM/w3JQaWLBBVRf/byO6nPI9Cv6z38Rk8cX38xQoPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=snkVEec8; arc=fail smtp.client-ip=40.107.208.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="snkVEec8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ob0oVxTeAH48S/1FcjsF8sQ72RScDoRRDhCb3Co07LMVrl2erkQSJM24laVMIY2B63fdixFIQbnGS1dfoAJIT/Zq5m1NELXZGZMkY51Tv+iN9QCGFDcgOlq0FL+N6xdRIf2ZLDFcmdbq+8hn8cBEDUfm4D5PbDmLfvXvNuCokeB7/OTW81dK7GQd6ySJRZO+Op9huzvPchY40E/32UYsX5TejYQc+TZNsCjgT9S+F8hZ5/iQjKsiqXg/7EbfgcQG+YtH1F0eGWwpjXNFUTeodzUVPKyK1cUnPLqxSB9YgWVd0tsjfRTqOehCAjVoXM8LjIBDrz0h1n8AYxjK+N4XdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQz1nWQqrQc/IzXC8mfH7YiuR8//kdbVEy87OFJRcpw=;
 b=JYrFd6/rHhnRZKjLm63CzvnXd4wB+JJGtkRoE/WNBN368A4KtabrxDRSc9bELmLS6CmzKXC4xDx++nEi3cSQyqAlPisPucCE+7vHRqL+ezemQ4jb/9aZguDc+xjdtTzYPkS0bAp8J2qJg6bW4HnIOIhWe36Mcp5IkGwbXU8kiunZ5mB7muWstP0gzCLqH3O2qeu9dzIq+A1NpI4fA43x4D2Y9ZFggy5HQGw/qkzXouIIXBoB9kpRYG2yKt38OafYTQFjXtpa3eB0GrTh8aegewzSVu6oCyDPNt2WdknoB8GlXdQcVPCDja2HPo1mGbS4cegkdg43HF+CILkEqzPiFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQz1nWQqrQc/IzXC8mfH7YiuR8//kdbVEy87OFJRcpw=;
 b=snkVEec8BM7Src/UcOIaXku4EZ7nxgeXEzweB4ebZTf1OU5gGZ9KtoTO4adBpCBbsr3BwR8B5FIjG2nvMqzHyMsjUPIIbkQD6czXyv4Uk0S8yg7knG7UCiOsUfqrrcN0LsB72M+CCdk38YwJiKz01WOjS5DlmmoWMb6EKtp3sf4=
Received: from SJ0PR03CA0215.namprd03.prod.outlook.com (2603:10b6:a03:39f::10)
 by CH3PR12MB9078.namprd12.prod.outlook.com (2603:10b6:610:196::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 19:43:43 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:39f:cafe::26) by SJ0PR03CA0215.outlook.office365.com
 (2603:10b6:a03:39f::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Mon,
 13 Apr 2026 19:43:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Mon, 13 Apr 2026 19:43:43 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 13 Apr
 2026 14:43:41 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v4 4/7] x86/sev: Add support to perform RMP optimizations asynchronously
Date: Mon, 13 Apr 2026 19:43:32 +0000
Message-ID: <ad924b3fbe4154466195e0668604afe8e0b825ca.1775874970.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775874970.git.ashish.kalra@amd.com>
References: <cover.1775874970.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|CH3PR12MB9078:EE_
X-MS-Office365-Filtering-Correlation-Id: 0866f186-4435-40d0-4bed-08de9994f883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700016|30052699003|82310400026|921020|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	3gaNBhcwUKgXDiYNicsDePy/fQJcMe/08jT/Dbn5bsF0s3DzxIHJhvfrCJtEq7sWBtoO7cUsGYnO1IlA4sTp05GTFZetYUBycim5Z/lRiiHO+53ayEsA3BT1sz5zCT1DU30m8RrtGIykIa+hRZfnOQKXZVNLctsX2J6xO0D6ZGqec7keUuVVPVdL7alhQeU6Eita1IMABHpBZYcrz+TaoQgCpcf47OZugCVx8AWxCLIyTaEDBowNhJYs07EbbM7r259lATVMWV16A7torDOCkzlIj1ZgvWjk043Zli964AYYzfJw8nAi1b1lCXtvTRv4Ol1rBiNjYJaX8Cc3sTdlyvsj8ENFSn9OICpHaPRb3IA2ZO1SsR3SqoqrPuSTyscI8liBHRTISsumyc3VYTM06kraSKW3UOWMe9Q56AlMmAbRdBTuyp05p/B1/EfDOykZmtfPQeDzqROk9xVtwkCDW6CztleSrdd46a2ou3YGPA8WwKc8R3tBPhHHnRqOvTyjb2XxUOxvZod+4nmKL/YiAsrZ3pv+cSFMAdiXPjEvS82Kl+Wz2DYdAo3KcbW5aZh1VhGoFpn7ClSO42KAdd8RDeSbkPW6+mXJ1OkIjrAbjV77V4rGSLfDvGjrbEAWiCJS5pmKCKsTDJFeElL6HPLJhkzpNqSwLirt7D7U8l4PwVU73ro1T5h3QQb6audxqcGQXt2KgQWKr6CrS+E7lLAcJGdaTzSoTzLW2iqfnq4+opY+Nwypmm3SKI3aMyJWxKy0x33WSyvyLBR6BNfwqUfOr3hCu9CSZNhW7c73dadFSx1GmXFw+JoI8Wvo2Ls03XjI
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700016)(30052699003)(82310400026)(921020)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2rcgZyus/Jdsiy4LsNqOACtYkllCb1LXCVxvPoBnLanMiLnNs0O0pp7YJXZi2NesZ05lmaxuQ7wcsBOYcAdMEqZ4WueRJKCzRaubocGOEPhYaXFBnKlgAIWaQjBhhzuXt+es+3ggneSwLrEihea3bKx0bMy6rMES6BzczQklDCcDYNbQrUA+fyiBByPt+fKz8Vpn6/5N8oP/JvWr+zCj4QxgYSHdH06JbIZBaLyfnu9iXR7AOEGxa8b6RgBUf1WmmU2/KB7GfLdwD3qeQdHecgAYx0YxLuezRflBmX6lmMr3rZipIydgzZ85+CrTvXKp3VvFnKryyfrmF8UGijHUuwue84ATqKjMrBCOABwiIoXjZnypiyKdAC7AjyWBx7MpZMp5cAvyR56mAA893wQ/7MHs4M0gI9/jzD1KgnXKVHCArGqDcH/oicC0a+8R3nJq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:43:43.5960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0866f186-4435-40d0-4bed-08de9994f883
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9078

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

Enable RMPOPT optimizations globally for all system RAM up to 2TB at
RMP initialization time. RMP checks can initially be skipped for 1GB
memory ranges that do not contain SEV-SNP guest memory (excluding
preassigned pages such as the RMP table and firmware pages). As SNP
guests are launched, RMPUPDATE will disable the corresponding RMPOPT
optimizations.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 117 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 4f942abaf86e..56c9fc3fe53a 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/iommu.h>
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
+#include <linux/workqueue.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -125,7 +126,17 @@ static void *rmp_bookkeeping __ro_after_init;
 static u64 probed_rmp_base, probed_rmp_size;
 
 static cpumask_t rmpopt_cpumask;
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
 
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
@@ -560,6 +571,83 @@ void snp_shutdown(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
+static inline bool __rmpopt(u64 rax, u64 rcx)
+{
+	bool optimized;
+
+	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
+		     : "=@ccc" (optimized)
+		     : "a" (rax), "c" (rcx)
+		     : "memory", "cc");
+
+	return optimized;
+}
+
+/*
+ * 'val' is a system physical address.
+ */
+static void rmpopt_smp(void *val)
+{
+	u64 rax = ALIGN_DOWN((u64)val, SZ_1G);
+	u64 rcx = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;
+
+	__rmpopt(rax, rcx);
+}
+
+static void rmpopt(u64 pa)
+{
+	u64 rax = ALIGN_DOWN(pa, SZ_1G);
+	u64 rcx = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;
+
+	__rmpopt(rax, rcx);
+}
+
+/*
+ * RMPOPT optimizations skip RMP checks at 1GB granularity if this
+ * range of memory does not contain any SNP guest memory.
+ */
+static void rmpopt_work_handler(struct work_struct *work)
+{
+	bool current_cpu_cleared = false;
+	phys_addr_t pa;
+
+	pr_info("Attempt RMP optimizations on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
+		rmpopt_pa_start, rmpopt_pa_end);
+
+	/*
+	 * RMPOPT scans the RMP table, stores the result of the scan in the
+	 * reserved processor memory. The RMP scan is the most expensive
+	 * part. If a second RMPOPT occurs, it can skip the expensive scan
+	 * if they can see a cached result in the reserved processor memory.
+	 *
+	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
+	 * on every other primary thread. This potentially allows the
+	 * followers to use the "cached" scan results to avoid repeating
+	 * full scans.
+	 */
+
+	if (cpumask_test_cpu(smp_processor_id(), &rmpopt_cpumask)) {
+		cpumask_clear_cpu(smp_processor_id(), &rmpopt_cpumask);
+		current_cpu_cleared = true;
+	}
+
+	/* current CPU */
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
+		rmpopt(pa);
+
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
+		on_each_cpu_mask(&rmpopt_cpumask, rmpopt_smp,
+				 (void *)pa, true);
+
+		 /* Give a chance for other threads to run */
+		cond_resched();
+
+	}
+
+	if (current_cpu_cleared)
+		cpumask_set_cpu(smp_processor_id(), &rmpopt_cpumask);
+}
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
@@ -568,9 +656,20 @@ void snp_setup_rmpopt(void)
 	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
 		return;
 
+	/*
+	 * Create an RMPOPT-specific workqueue to avoid scheduling
+	 * RMPOPT workitem on the global system workqueue.
+	 */
+	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_UNBOUND, 1);
+	if (!rmpopt_wq) {
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
+		return;
+	}
+
 	/*
 	 * RMPOPT_BASE MSR is per-core, so only one thread per core needs to
-	 * setup RMPOPT_BASE MSR.
+	 * setup RMPOPT_BASE MSR. Additionally only one thread per core needs
+	 * to issue the RMPOPT instruction.
 	 */
 
 	for_each_online_cpu(cpu) {
@@ -590,6 +689,20 @@ void snp_setup_rmpopt(void)
 	 * up to 2 TB of system RAM on all CPUs.
 	 */
 	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+
+	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
+
+	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
+
+	/* Limit memory scanning to the first 2 TB of RAM */
+	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
+		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
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


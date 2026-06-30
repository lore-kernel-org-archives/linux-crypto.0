Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012047.outbound.protection.outlook.com [40.93.195.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7746D3E073D;
	Tue, 30 Jun 2026 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782843118; cv=fail; b=Q/49lrf5qeBWOR5cGsLtlNTEC7lT8cchqqQ+PWC+JeyydQtNYWuYMS0A7CrQEyCMQakffk+a+wKVTqn9AHD3QZctGdJWBrKUK1jVT0hcJs6V56yzMN7UCDxHTUfWfsIFMQR9kmOZEox3kFZrSXK5ffghDchI+pK2V+k8WiHLdXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782843118; c=relaxed/simple;
	bh=jYk3FgiLrffMDLqbm2UnDEpBEVVW6lEZrstO9gC8Dck=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BSDfmew7gkB5/+0mKiokMGFOqTQ0KT6p3uygwIt688zJ9uW8C2nQCfoTGQlsaVvgtVaaa6g097MEXa3aILIaFLOPSo2HnGHklNsok9fzZmNBhmDA5vPT1MXZNeCb60U0x8LWtwmFpbS6JQZrOoZGvvV7i3oAnCPQg3MDTHXlOLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C9n0sIUO; arc=fail smtp.client-ip=40.93.195.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C9n0sIUO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gd3M5I9ZSLcY6/Ib08tkBTmPmgh+S1qHjoBf1+VukrRBZEoc/LMByG/V/tj3np1h1CrtiPTRQOl3/U9SlI44GySf3rzjqkE5OGrBTEB+fozte51LXlpqD4+dLP2sU1jgyyz9KV9HGHirjfHJoqJbc6zRyO5P/ayt6R6tfCtmWWS+xqUlJh/twmWL+zh4OccmLVqXIMLMrr/fnq0Z9g0P6cN3Ud/QRCL6HTT6hesuCIDp+jJvmc45gM3nJMqZqIJyIuCUJ1ijdHDooygdz0eXhWuJZEdooZeE+3evQpioYDab+5LqVMV0NNN13AMFxJX8g4cMVp/8ICdjeY8IHXoikA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xYa5KUMWeemc6yF3AV1ElsvqQZ+qyGFldUWhL7Wvp50=;
 b=VZwoR4nolkwzrX9RF865yNUrcX89es0w8uVaeJbZrYLIOXAKgemGYaWd7L6zqHs1r75w+o8RHnZPb97ajIz4n5hzbiDBsUV0XTOTmZ8n+Rn64A7W68yhUh9OoMzf1I7Czpmk/g6EMPDYW2MTQf4D8CNod1ZlnAUj23r9buaWydZJSLLS6g/aPBixLIJU9j/nAb8hIV3dtuRFQVjiVKyXZC1nmcEQnxM0MbI+GDZYgSTwzjtOQQpZZ078evMQx0oQav/sMjAtJF15SDsbK48IuDSIUkse7hEpg/wPQFCBwJiIvH6IGQqRHJxqQD5989A3JI3IbxapAeUyU4sO1bZzsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYa5KUMWeemc6yF3AV1ElsvqQZ+qyGFldUWhL7Wvp50=;
 b=C9n0sIUOMbwjENtWRXfPZuKlg3F/Y5TAR9WGA4PEmyacgvTA9ljQGCNxrhHgpxDZ7XBx45nzvX1Pvx0lH5RjOuXnLP73V+FSqm8XAqT5Sm9991iuq+TPO4X6SNMT/jQLRDRym8jqHCj+ssYgnQNgVAaslFtIsiXPhc6MABAMzYQ=
Received: from MN2PR06CA0027.namprd06.prod.outlook.com (2603:10b6:208:23d::32)
 by LV8PR12MB9667.namprd12.prod.outlook.com (2603:10b6:408:297::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Tue, 30 Jun
 2026 18:11:50 +0000
Received: from MN1PEPF0000F0E4.namprd04.prod.outlook.com
 (2603:10b6:208:23d:cafe::31) by MN2PR06CA0027.outlook.office365.com
 (2603:10b6:208:23d::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Tue,
 30 Jun 2026 18:11:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MN1PEPF0000F0E4.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 18:11:50 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 13:11:45 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 11:11:37 -0700
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
Subject: [PATCH v10 4/6] x86/sev: Add support to perform RMP optimizations asynchronously
Date: Tue, 30 Jun 2026 18:11:25 +0000
Message-ID: <ada64cdc976b98a70687b3a347bca0c25c89eb09.1782841284.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1782841284.git.ashish.kalra@amd.com>
References: <cover.1782841284.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E4:EE_|LV8PR12MB9667:EE_
X-MS-Office365-Filtering-Correlation-Id: c47ca711-350a-43c2-af29-08ded6d30ebf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|82310400026|7416014|23010399003|3023799007|6133799003|11063799006|22082099003|5023799004|18002099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	is9TING+RQjjzPtl/BasYMxKPhCYRT7zwgecGCQxB6iCV+f3XBzt5oiVLNl1RGksEuzX/OXpAq83zdCSE0ooftxWftupAgyV/0v3CTHySs/AkG192E78bWi/exWmEnom/Ye4bfSRVOl1f6r9RiD7Y/+ErMF4qQiaSt0gVGNbFKLGWZUhJSw9q9lRlSu3RL3ZXG78xW7BhbG/jXV29ngVoxo6ONO2PjWE72p1MzjMmrCLCoPu6dlfNytmmQl4ZslP6TXpna3U5jM3oJyzjqrLPLywF224iWLfVBZ72TsLB970+9pLPL4BvtdK0iB3PEHKnuTTuZg95Jb+NKwTD7imL0LyznqHB585oxoJiFL5A+oU5J/k8T5PtZwrVoV2nLeYWA21bqQHZmChi7vI+dv9koLccFAC2rjYEFOpP/N3pP4X/fbwcW/rSRyPN/W4+y2yhUTJUu9nytJpHgxO+yMmt+RkuOXjNVJYuMVc0fqNndKDOisr27orP3Ejt95+kzoIiKbspflAnX07CzGi4p+Vfr2IByifKImJoypU7JnpnTnd5Pv2s+EFeZqdvGHB6iPu64SEW0SVjliRpaGTybTJodPot+bCD22Fynt7AzLqwv07lQEaFJG0Q99OQ640QKoooRCGq9OSUbcR68V64B5eiF4dGMY3KVjR7qaihUFgsGO1qCFWtaItAu7etHMMwi2mQ4DWNRrSnJzPfUakrtA+k4IVt1YjohMvz1JcfI6dMkAq88kjOnCBRaOsySEJ3wct
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(82310400026)(7416014)(23010399003)(3023799007)(6133799003)(11063799006)(22082099003)(5023799004)(18002099003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XlJY2gI679mY+rUtKT9dZqektMuUVffhznZDF4xiuddi+kFMQQGjFgcyHWQ6oY8xyFnYnMGb1ODsb9dfLHMAIcpkvsmpc72zsFmzXk+mKWwz+qTUvNtudnOyJAL+qrqhlC+IaWr4KJxZn5zVig3fXuAxTRUH6lGBBJLdST0zCSAPyvVaUOyWim6O4Tn+kZZI2RuMYz4BUooSpGTdcsk2+8IxaKDaO1YbC9ZZHTfTEQUbnJAHt15dQJRE27Y9Lwo8LwQ1umFX7eKKiFTklVfZ9DZdwclhVNS+OfPpmrpu3uj6o0FRIdR4HploXunwZooPD7W5nsygJsJ8jAbn1IFl5HkSDShWJhoo/rPfXkRkh6rBzEraLvS3DrauY6Tnexj4tqNFdU7WL6stK3CqXrLMt1cre63NLmWPzUHDpNG2Z8i00ekYmiL/S1zJe3W20vuQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 18:11:50.6807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c47ca711-350a-43c2-af29-08ded6d30ebf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9667

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
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 167 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 164 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 04a58ac4339c..40b06e959ee8 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/iommu.h>
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
+#include <linux/workqueue.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -125,9 +126,20 @@ static void *rmp_bookkeeping __ro_after_init;
 static u64 probed_rmp_base, probed_rmp_size;
 
 static cpumask_var_t rmpopt_cpumask;
-static phys_addr_t rmpopt_pa_start;
+static phys_addr_t rmpopt_pa_start, rmpopt_pa_end;
 static bool rmpopt_capable;
 
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
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -581,13 +593,22 @@ static void rmpopt_cleanup(void)
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
 	scoped_guard(cpus_read_lock) {
 		for_each_cpu(cpu, rmpopt_cpumask)
 			wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
 	}
 
 	free_cpumask_var(rmpopt_cpumask);
-	rmpopt_pa_start = 0;
+	rmpopt_pa_start = rmpopt_pa_end = 0;
+	rmpopt_wq = NULL;
 }
 
 void snp_shutdown(void)
@@ -617,6 +638,103 @@ void snp_clear_rmpopt_capable(void)
 	rmpopt_capable = false;
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
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
+		rmpopt(pa);
+		cond_resched();
+	}
+	migrate_enable();
+
+	/*
+	 * Followers: run RMPOPT on remaining cores.  CPUs cannot go offline
+	 * while SNP is active, so the follower set stays valid across the
+	 * scan and cpus_read_lock() is uncontended.
+	 */
+	scoped_guard(cpus_read_lock) {
+		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
+			on_each_cpu_mask(follower_mask, rmpopt_smp,
+					 (void *)pa, true);
+
+			/* Give a chance for other threads to run */
+			cond_resched();
+		}
+	}
+
+	free_cpumask_var(follower_mask);
+}
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
@@ -625,14 +743,42 @@ void snp_setup_rmpopt(void)
 	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT) || !rmpopt_capable)
 		return;
 
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	/*
+	 * Guard against re-initialization.  When SNP_SHUTDOWN_EX is issued
+	 * with x86_snp_shutdown=0, snp_shutdown() is not called and
+	 * rmpopt_cleanup() is skipped, but snp_initialized is still cleared.
+	 * A subsequent __sev_snp_init_locked() would call snp_setup_rmpopt()
+	 * again, leaking the existing workqueue, delayed work, and cpumask
+	 * state.
+	 */
+	if (rmpopt_wq)
+		return;
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
 
 	/*
 	 * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
-	 * to set up the RMPOPT_BASE MSR.
+	 * to set up the RMPOPT_BASE MSR. Likewise, only one thread per core
+	 * needs to issue the RMPOPT instruction.
 	 *
 	 * Note: only online primary threads are included.  If a core's
 	 * primary thread is offline, that core is not covered.  CPU hotplug
@@ -655,6 +801,21 @@ void snp_setup_rmpopt(void)
 		for_each_cpu(cpu, rmpopt_cpumask)
 			wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
 	}
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


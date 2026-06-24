Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012037.outbound.protection.outlook.com [40.93.195.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113B228D8D0;
	Wed, 24 Jun 2026 21:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782338294; cv=fail; b=oFXBXyvJUDB6sxXDHosyt9sdv3IJjlGaIj8eDr6gzUFBFlp8Sr6nXaprtJUO/tsgpabaCpVx2gic/KHCawnkJzYP4FItBpQvKzzVfa5hEzmDW/Kvdaw5grDuYCxRbzvp3lX2jCHS9XXHSyRHMGyMz0/8IrP35gzdGQMf4cv4iYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782338294; c=relaxed/simple;
	bh=p98JdYGX2COuv1AYEPOaPfwleSCdyX5kW7MTR3qE+xo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NaHGKTEmlY8leuPGQP5fWN5lt9uufk582WrTfJqNwxlxRNjf4YnOS/THjVrDFNQwKcZNCjKHY/bg3A2L1gUgGQiJb79+Mw6Durlwp+hU+5YiDgjH5uRz7xt27I0CXT9E13QtsnRSFa6/uSpK4XeagTx51iszuQAb76Utka8NKOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oEHkPYQ8; arc=fail smtp.client-ip=40.93.195.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oEHkPYQ8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSEWt8vBEjTXzWJ2R6mH4unhWAwZaser2b5Ci8nHLwNZpirp08x1SMrgrQ+fIcy/DjZ3pifMhP1X4tyG4FfWvQxeIQDk40SsYTURysiCPFx9j976QwnUpgtJY3e1VjmqCrMaHv2ZF45ccWtarAWbfj7VxLyuOtb/XVZcxNk4+dua4JsKxzBApFTPN9aT3dvwta4njpMDGPGalZibzae7TU7F4SaVJkg38Lft5VRQ2tLijfZ9IGwWpDE++hiTjV5awN40oOn3TMj6nWAYVzldtML+qdO/OS+8y9OqsVbtTOU5Xb+tQEsZ5+TEMNnszCWMePUNDnpjsYNKCgOGzpwaXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GAv6nRoMvLRjEOuPo2V6QOoVBxqZo8GRjOJxnz6uCtQ=;
 b=kWQAXElHn+3az789Z+WiENq5VmV2cyyftk4uwNnwOleSmtLUCHBd++XOD+RUM7TelAoi+z35YzG9zkSCVP8/eqt2bVoABNFF5VJAuGTyje6tnHmv9vD8wMcjv30bSw9lH7SBFnbhVhrpXNGLcYFt2Lw51z4PqnN/4BSHkyoZubv0BihclivboV8DrdqyGNwpwVmzMNnZH6NMwufPY8yjOpQ/TSXM8CV4KbcsDesQPlKgbUVoxJy0B3VZsoUebnxNP+ketzBLw1X0jdJndtBmZv8Hy4IOj+HkrgRIP3uUaSfG2NTvXN0QWv0+9W/8vZN5Ma0UnLbzYwJyYmd/lAaNKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GAv6nRoMvLRjEOuPo2V6QOoVBxqZo8GRjOJxnz6uCtQ=;
 b=oEHkPYQ80RpFGFGnWWddzN0i4KNAyJMOqLNIoBaKtrFEyIBnPUjvb0f6uE5+8ESIwTUng87kKI7s4Ylu72GbxeWiuC2nUDnLq4rVcY+3WEIB/c1n8h4Dd28BBZm+qdEH1bHg4tOlZGzLYv37seSDNeCWHRSpWNIQ1sVPoARO+3Y=
Received: from BN0PR02CA0046.namprd02.prod.outlook.com (2603:10b6:408:e5::21)
 by PH8PR12MB6724.namprd12.prod.outlook.com (2603:10b6:510:1cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Wed, 24 Jun
 2026 21:58:03 +0000
Received: from BN2PEPF000044A1.namprd02.prod.outlook.com
 (2603:10b6:408:e5:cafe::3c) by BN0PR02CA0046.outlook.office365.com
 (2603:10b6:408:e5::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.14 via Frontend Transport; Wed,
 24 Jun 2026 21:58:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A1.mail.protection.outlook.com (10.167.243.152) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 24 Jun 2026 21:58:02 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 24 Jun
 2026 16:58:00 -0500
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
Subject: [PATCH v9 4/6] x86/sev: Add support to perform RMP optimizations asynchronously
Date: Wed, 24 Jun 2026 21:57:49 +0000
Message-ID: <94105d8ebddf2c53344f5470ee307da51c8a63c3.1782336473.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1782336473.git.ashish.kalra@amd.com>
References: <cover.1782336473.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A1:EE_|PH8PR12MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 61103441-be5e-4cbc-618c-08ded23ba9b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|1800799024|23010399003|7416014|22082099003|18002099003|3023799007|5023799004|921020|6133799003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	6NwZ8oQoCewiHVR0h2Op+At5ZU87kLxEknJsq0jQ/YIb3tRX5IUwEJweRLP10swt+2Y5paS7Uc6KRmGqV+zUKsotxzAMXsFgWXfhyZelUqCJHmxILUxo5a/COIX7MQ22zuCkuhnap7LgeBSYD4bbJ6HPVVHFWzZ9xB429MwE/tgSSHuY+32ywCE0Czzt0l7sdx4z2eY3vIwtHzR88CSZrJboOlnGh4O6enQDJAOWZVXzN6gU2WQ1I15mbiWn+bz9GF5LmbjkFIfnGFg6xO6uHr/GANKRgxhkZyac0gDWfoFHtGTLfGRJC5qiSnQzDwnbBDKiegltyQmDkZDrPfUbN6FSyKU2DTo8ksRo4L+S5Q9SrCFh0zEVeoryocAufumKbaSXYDqY8xce21o5xXhnehStgvHAOh0aHE4HKbRqfSOYj4n5JrUMtVVLL61LVMpSuejNFxW6e9KRvwLPAWTgOFPKTFKkBj3Qhu0V5FAplHjavqidt8uIaLYm9rzz3iB3nJfaoExLZO8lWb/dE8FaQzIeY4AD/FnO8aw5Js5EDRQPUayZR59+XZD9RR2US9j0WlA5TfTstPXtuYqBtPtJgLo8xtWGsxKURiuMsq3qsMv9M3accYeNOH1hkL5LJTsE3a19sKwhbvS3xibx7jR5SdTf51wrULxR9DXkebyp8xaxGXejUpmZ9qtgun8HZLRrFX1Z8IwWDUQmQYTisRHmz5+lXuNuheKTvH+GNTCrpt6/d23eb1fLqlN7WFndnXIb
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(1800799024)(23010399003)(7416014)(22082099003)(18002099003)(3023799007)(5023799004)(921020)(6133799003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RHfvmhvA0Ihx+nzO6cNONuGtmREIaiqqcUgfrPAYb1CHr6mJM/IBE09bPyD5t+BphQlK6MT/FORgz5z2/LzGfxz6FvwTaGs+/v+YxUNmpbpoL5BdZ8tGiCioI2HV38C6xXmrymm54uzc+SmFQmDuvao1/jRW96isa70MnPYn3ifBJCExH6PpsiRil33Cvlr7uCuMC9aduImD7dpTZUP+VBHs4Bk2nhzasIUI/ZHklHOoy2/WvwjMgWeW8SPrSDzXVHKHv4MUxv9rwSGh9Xy4OIlEJiZMKLzrXhl1GZlD0E6MSuGXl+sb3hKjwpfLE69zmr3z5l/V1/L/R+oIwq2rYi2ZyPAzck5/56Ge/39rR2UHRdDL0ZnwI5xZv/4EqJrnK/nP7Bjl+EWT0YabLHwXbRkLG5sXqMh/Tn4XmEEvo7GykJCtFafySuOivuqCT5L2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 21:58:02.4761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61103441-be5e-4cbc-618c-08ded23ba9b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6724

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
 arch/x86/virt/svm/sev.c | 165 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 162 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 60984f76b4e9..5f99cbbc6cbd 100644
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
 
@@ -571,13 +583,22 @@ static void rmpopt_cleanup(void)
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
 
 /*
@@ -627,6 +648,101 @@ void snp_clear_rmpopt_capable(void)
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
+	if (!alloc_cpumask_var(&follower_mask, GFP_KERNEL))
+		return;
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
@@ -635,14 +751,42 @@ void snp_setup_rmpopt(void)
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
@@ -665,6 +809,21 @@ void snp_setup_rmpopt(void)
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


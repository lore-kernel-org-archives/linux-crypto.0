Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766BC383310;
	Wed, 16 Sep 2026 22:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789596948; cv=fail; b=JDURg1SHUh5y9+bMmVq9fQV604q9NQJn+rGN4QNUfb+i9IstxqsC0gcEC8kmTdSar20a89HKzbMGB5qRUt/doD3sRDfax/mDUyjfU/b3jT34kBhlbHlMb1t45Wp7T/oPk+CvhSPlW1PcefYspI2JfmbzSopxprZQympZVNCtRl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789596948; c=relaxed/simple;
	bh=d60IauYdODcsis9hhOrvOk+23qHiahnv0YYkp4GY5wQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NGcZJK4HVEfRq2B8fdZqQWWahy5WH3R8RpP7g2M8P2JONBjAmUoEcMmWyknFuxdpwRgLlTFq7tCx+1rGFWMRG6Pf4pLFA8JGi9RXItYFUQbtrfhOJtYkUjvTxiwyx0KEMQG4K3+MWTI7z0o0tmp37y5BlQLVepn0gifYcpF5CtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NY1gTw4Y; arc=fail smtp.client-ip=52.101.56.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NY1gTw4Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eVXdZItu7GElnr/SZRZFiU0IWrv5BkAR1tdkMPCt4KSopU6e/GUslSclBT7zCerxNt1kYsFu7SbnSSDeQinapTX5WCm0c1Dt5nqMsQjlKtXzVFSOWxcoZnnkqXKGAfaP7m9Y/zO6od47IgGyRCxdAdqPr0z2N+QfE5P+g+K0C/Ogwr6jkUqeCqtzuolzML6SoAKzbMwGzzf6W+6JAhXkv2aPIneHEIDZUTUS0c/ruOf5cP4W6okFbK4801YPjREvjKL54jHSaEi5ko0IHUkmHkdXGbvsiWQcVkiHkxIjECdH1uQRsBR1cWTxvizN4z+JI0/Um/ThmIFwDO4hLxhL8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8SWMy2t+AUZxijQA3o8GRGo5bDAXNNS4i3+xr6xK7Y=;
 b=wszBF6Qj0hwsZ2O7rcZSnLSGxkKT7gAtXih0/1yoN3wtrWauMcP5TmvGHfI925DX+pxdUF7tySPTzCbXKY5FcHI6Ove5lwnZvvzZZlupj2HhmltBK9SKIMsvLrs/fRgiEJ/V6jJ8IGYoDpDpuIPdmJyipxH9I6xaBAwkrlB+/gMXHZGRHDheQeB9mYBwOETuYYfmx1hw3dhDFqdZ9H6bLNBk4zhkoqlIZ/7VYISKxmHdeSAJ1455wDEL42lcvNQAgC94QQkOgiOuE6Kmd3th5RnNdtHp6wQnUPEL+JW2+d52YjzMSfVi0bytkN9qLfWHwU7VF8nd0mvL2iKj4NCNgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8SWMy2t+AUZxijQA3o8GRGo5bDAXNNS4i3+xr6xK7Y=;
 b=NY1gTw4YzQzLlv4dYu42ZUr8Zy+hyfWpexrEvElq1NdM0EydouV7NAtQrHnwmXIkn+owYPUdH5Ewlv9epZouvNr7+HPbJp3dKcx0L2kKV1LM52gOaNZ+YpEIi4UE5YFE2fL6u60L6V462YgVeo9JQapkuyqZwNjyOESl2ygszKA=
Received: from MW4PR03CA0221.namprd03.prod.outlook.com (2603:10b6:303:b9::16)
 by LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 22:15:33 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:303:b9:cafe::2d) by MW4PR03CA0221.outlook.office365.com
 (2603:10b6:303:b9::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Wed,
 16 Sep 2026 22:15:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 22:15:32 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 17:15:28 -0500
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
	<dyoung@redhat.com>, <nikunj@amd.com>, <darwi@linutronix.de>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v16 4/5] x86/sev: Perform RMP optimizations asynchronously
Date: Wed, 16 Sep 2026 22:15:14 +0000
Message-ID: <daa513fbe8f0672b00bc5e026e4399244be6dc72.1789594774.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789594774.git.ashish.kalra@amd.com>
References: <cover.1789594774.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|LV3PR12MB9356:EE_
X-MS-Office365-Filtering-Correlation-Id: ee3be194-e89d-4eba-2bf8-08df1440068f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|1800799024|23010399003|82310400026|921020|6133799003|3023799007|10067099003|11063799006|56012099006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Z/xdttY77EkHoFA3JdTM44zqW5YwlonICpV+eh74Ac8yrdimA7jjxfLPMcqD4WIZFX/iTVDNhBl95IAYoPfskWqh6UAgjfIRq16qKFwOMf/J4gYko0qldUthQDBwELkpGSN5mSZMKWsKqSLZ6vqBiG4cr/b28TeGC+Mblop0qpL1+egLylSi6ZQ/4rtBmx1uR1TvyHUSiKzRwXltyPeQIs01qajYSNEyUQ+VqaFDVuKzIAxLAWRcN04kC0BFfc+bTq3Dyn4Pa7eEzSk4O2tM468J6TCQR4I4yyoYs+/8RWzMTQ0AP0BCXRKCR2NBpbvZ5vLuf/DuvY23mkjpt8CUCJdIyHLYNTDsaDmdlnKmKiSN+4X7wyqVctPXVMXO3Eq5+5v9gjGHMLkqwVNTlx7cBW0d0nkady9gIlGyFamgGjftEn0ZJliiHI4DLjEX2/RzNBvjrJOksr/BCL5/so9Xodrue9lqga+FKFnmfkv6qa92wIIDvivizTocU2vIZDHWiNroPRwnks1n86kxzrZDkd3FxvWspaZHhaagymdVSvHj9UIE821Bji2hFzLALAfUbkpF8FkoDqMgByQScry97XcOklzXNeP/lUfq4I9bfY7zvzWvQ7I8a1a5LgEbwij+mWyJnk9BchZKR7fiJV4bb5bOydYY0lFXkLIUS1WOGvc/KAUUxgDa29FQsdspzzYyIWPN8OsmCSUS3HWvqPdwL922oYhUXnV9hLnSxUewIYzFMgtXl6FntHUdujXo46l4
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(921020)(6133799003)(3023799007)(10067099003)(11063799006)(56012099006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Uk3RrTgXARtB4Da0CHVmd8fLhdN+b5KGpvLv4WqxyLAhFO57C5tZSbitXERW0v9ELI18CVDa/0L4yciekgauVeY81MU+HpQmPTMFc2FwmxM66rUx8uDPhkd7bwxF+eeCZH9tl5r3CBAJDdLgOh9YZ70WMsMd42gIbirIThiUKzO2aE7ip5xh2kvlhpILwLtKr3yxZ0dfYBZSfnLkMdzkGvxH/cGZkEh6IXScIFo40kbUWD+NP61lC875hIMblBxGXzoN5WdFAd7XPjccskGZWH/sypPhrRU09ju/1rppHk657FX6WLaX3x5x1T3/6zBDcJ/cXFSdg8b3A1ptBAIcrUd9n5tBEII4ab/1ZsfAwpBBYGAlB87Ax2SWlFG0G5aSwW2UpFz5xpS73DGhcsFJ4/8gLlwKnZDmOMewFOTDAl4t/tJCvSsn720vHyZCuxE5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 22:15:32.9730
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee3be194-e89d-4eba-2bf8-08df1440068f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9356

From: Ashish Kalra <ashish.kalra@amd.com>

When SNP is enabled, all writes to memory are checked to ensure memory
integrity. This imposes performance overhead on the whole system.

RMPOPT is a new instruction that minimizes the performance overhead of
RMP checks on the hypervisor and on non-SNP guests by allowing RMP
checks to be skipped for 1GB regions of memory that are known not to
contain any SNP guest memory.

Add support for performing RMP optimizations asynchronously using a
dedicated per-CPU workqueue. The workqueue is allocated from an initcall,
and snp_enable_rmpopt() queues the optimization pass.

Shortly after SNP initialization, run an optimization pass over all
physical memory (up to 2TB of system RAM, starting from the lowest
physical memory address aligned down to a 1GB boundary), skipping RMP
checks for 1GB regions that do not contain SNP guest memory (excluding
preassigned pages such as the RMP table and firmware pages).

As SNP guests are launched, RMPUPDATE assigns their private pages to
guest-owned state; when such a page falls within an optimized 1GB
region, the hardware clears that region's RMPOPT optimization and RMP
checks resume there to protect the guest memory.

Since launching SNP guests clears these optimizations, perform them
again asynchronously using the dedicated workqueue.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
Changes in v15:
- Move the workqueue allocation and the (fixed) optimization range
  computation to an initcall; snp_enable_rmpopt() now only programs the
  RMPOPT_BASE MSRs and queues the optimization pass.
- Gate rmpopt_capable() on a static rmpopt_enabled bool set when the
  workqueue is allocated, instead of an if (rmpopt_wq) check, and drop
  rmpopt_wq_mutex.
- Queue both the initial and the teardown pass with mod_delayed_work().
 arch/x86/virt/svm/sev.c | 99 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 95 insertions(+), 4 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 25cb486ff61b..bd97135cacc2 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/iommu.h>
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
+#include <linux/workqueue.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -124,7 +125,25 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
-static phys_addr_t rmpopt_pa_start;
+static u64 rmpopt_pa_start, rmpopt_pa_end;
+
+enum rmpopt_op_type {
+	RMPOPT_OP_VERIFY_AND_REPORT_STATUS,
+	RMPOPT_OP_REPORT_STATUS
+};
+
+static struct workqueue_struct *rmpopt_wq;
+static struct delayed_work rmpopt_delayed_work;
+static bool rmpopt_enabled;
+
+/*
+ * Delay, in milliseconds, before the RMP re-optimization pass runs after an SNP
+ * guest is torn down, passed as the delay to mod_delayed_work().  This coalesces
+ * a burst of teardowns into a single scan and gives each guest's pages time to
+ * be converted back to the shared, hypervisor-owned state.  The 10 second value
+ * is a heuristic trading re-optimization latency against scanning too eagerly.
+ */
+#define RMPOPT_WORK_TIMEOUT	(10 * MSEC_PER_SEC)
 
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
@@ -557,6 +576,12 @@ int snp_prepare(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
+static void rmpopt_disable(void)
+{
+	if (rmpopt_wq)
+		cancel_delayed_work_sync(&rmpopt_delayed_work);
+}
+
 void snp_shutdown(void)
 {
 	u64 syscfg;
@@ -565,6 +590,8 @@ void snp_shutdown(void)
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
+	rmpopt_disable();
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
 
@@ -580,8 +607,69 @@ EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 static bool rmpopt_capable(void)
 {
 	return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
-	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
+	       cc_platform_has(CC_ATTR_HOST_SEV_SNP) && rmpopt_enabled;
+}
+
+/*
+ * RMPOPT optimizations skip RMP checks at 1GB granularity if this range of
+ * memory does not contain any SNP guest memory.
+ *
+ * @pa is a system physical address; RMPOPT operates on the containing 1GB.
+ */
+static void rmpopt(u64 pa)
+{
+	enum rmpopt_op_type op = RMPOPT_OP_VERIFY_AND_REPORT_STATUS;
+	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
+
+	/* Supported by binutils 2.48+ */
+	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
+		     :: "a" (pa_start), "c" (op)
+		     : "memory", "cc");
+}
+
+static void rmpopt_scan_range(void *arg)
+{
+	u64 pa;
+
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
+		rmpopt(pa);
+}
+
+static void do_rmpopt_work(struct work_struct *work)
+{
+	/*
+	 * Warm up the RMPOPT cache on this pinned per-CPU worker with interrupts
+	 * enabled, so the IRQ-disabled fan-out below only issues cache-hit RMPOPTs.
+	 */
+	rmpopt_scan_range(NULL);
+
+	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);
+}
+
+static int __init rmpopt_init(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+		return 0;
+
+	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_PERCPU, 1);
+	if (!rmpopt_wq) {
+		pr_err("Failed to allocate RMPOPT workqueue\n");
+		return 0;
+	}
+
+	INIT_DELAYED_WORK(&rmpopt_delayed_work, do_rmpopt_work);
+
+	/* The optimization range is fixed at boot; compute it once. */
+	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
+	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
+		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
+
+	rmpopt_enabled = true;
+
+	return 0;
 }
+device_initcall(rmpopt_init);
 
 void snp_enable_rmpopt(void)
 {
@@ -591,8 +679,6 @@ void snp_enable_rmpopt(void)
 	if (!rmpopt_capable())
 		return;
 
-	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
-
 	/*
 	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
 	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.  The MSR
@@ -610,6 +696,11 @@ void snp_enable_rmpopt(void)
 		for_each_cpu(cpu, cpu_primary_thread_mask)
 			wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE,
 				      rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE);
+
+	mod_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
+			 msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
+
+	pr_info_once("RMPOPT optimizations enabled\n");
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp");
 
-- 
2.43.0


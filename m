Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011036.outbound.protection.outlook.com [40.93.194.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B83D3AC0E5;
	Thu, 10 Sep 2026 22:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077638; cv=fail; b=Grq6YfcyOzD9N0w4+P0Du+jl8aPSF5L5fPj476+BCTVyHRZ4c5kWmoulI7ra4u2wX1XxzAh0G9zXTshAkKrdyBFMP87vEmQV7thm7H9RZjPJ9+Z+6z9D1GE2zlo3MKsD2VQCTWiH5SDe2c0eSEBndDd1syirlrcQZJKss08HXMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077638; c=relaxed/simple;
	bh=MExwv9kfhXWfLqRtrvTxmw36CwTAqewVa7y2ukD7R1I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZ78L+pMInJ8kuSa0uzS29CJtbUUr/xBpOvOxTIfc1i8mxywYXciO3qyktLs4q1iZ+k2WhBppdEdFVXLMu+TifXW70FI9JNtH4FC6OA58/YdtfHj0u1bilCl+pOS+BhiaSeliKWLjJMYvdHT8IyOnlP8G290XKOGtDxXFsqGANk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QNf0LEvD; arc=fail smtp.client-ip=40.93.194.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QNf0LEvD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DTmbyGL0kvxHWdomfpmfZUTLbg7ApljKQ/JWukKIXhEZdSUkdJy7fIQ8eEp3gHCe88BUt4mofOjBChdr7bb6/KnCdLtlMWO01av9ISlpnW19b5yukJ9N1GAjmzbM6Jx3MvMHjMe7GTGAxTi9l5B8BCmdW4KP4WUQAROkTK6Vnfp/fLTkasaWY8n68bWpHclFpz6S6QeNzAzicyMVHaEt7xS1I3b1lTpDbITaj0IUdkTtJduD8wLhYbsjY5MKclK0Dj2BU9+ht9MulPaAEA+GM+LKkMMgPuyjgh3dye42BdHOY0m3/ge3Lg4D/2okZYiE/vMTNfxBMHv0aac25YiFnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0i8QQWmNOUbzMnnzT7Fca4utAUp4HSX8gqVNKevPTA=;
 b=Z2RFDBXLMBG45vq2j494fuBUr4W2XWCjWqn1CM9m1LzWGn4SXdPXHW6tSBoFCigdpOJJ917zN9VNOo2meMmHHYyxkPXtO/3QjUzNbMTYtBKFvCcxHDSQo925y13ElE/OSHz0iBs14zmiHZFtXFC/T9Eop7l8M22Znb+iXXK0OmoXWF4fbdxUMq96VX8yuUPUCOMZBIic2a6LNBV8Ch40V6ahV3HqNCc6cBxrouckVd6+XIJDfBs4pBoBp7vnPWI7hUJJzbHp1ev0GSUPh50L6eyCDFUGrfKacRp6KPkc9q8jvwKEqd+zxIaga2O/WLntFbRNHTxwuxaAt4GudNKamg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0i8QQWmNOUbzMnnzT7Fca4utAUp4HSX8gqVNKevPTA=;
 b=QNf0LEvDXbmkkjNu2K38vNsTU1zxd/C20WibxKAmEM5I8d1q6xPRasiO0ntO9a425F30PZPegmQpcfHCUEJO/C9k1l9RI5EcOe+628dcoVUvWsVfxSwHHt9TLCkbHkmhLPizGzGnUT3+K8gVuNCbNOEvkWrz9iI/KE26Ew87AKs=
Received: from BN0PR02CA0016.namprd02.prod.outlook.com (2603:10b6:408:e4::21)
 by PH6PR12MB902451.namprd12.prod.outlook.com (2603:10b6:510:3df::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 22:00:25 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:408:e4:cafe::79) by BN0PR02CA0016.outlook.office365.com
 (2603:10b6:408:e4::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 22:00:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 22:00:24 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 17:00:17 -0500
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
Subject: [PATCH v14 4/5] x86/sev: Perform RMP optimizations asynchronously
Date: Thu, 10 Sep 2026 22:00:08 +0000
Message-ID: <1e3d0edb6b275e33fa6f76b0c31db9e999d9a270.1788984053.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788984053.git.ashish.kalra@amd.com>
References: <cover.1788984053.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|PH6PR12MB902451:EE_
X-MS-Office365-Filtering-Correlation-Id: c172c2b9-82b1-4b89-8803-08df0f86eaaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700016|23010399003|921020|6133799003|10067099003|5023799004|56012099006|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	N84jwhV+Knvj0WbJfrCznG76QpVWNXtFuPywbbVBwgYXRadvFAIYy6AaCCUUgkLtRWtauMIdJPRuRTpt2OYdYbqT1xFlWf29OmXvrKFjgUtZeilQrP17FjseHuHbEzjEdgX53/l0ZB7+6a6UF4WdtEICVXkQnDyUKBwQtSoue589a8ckERlOjVf+zABEWOWQI8CV6gtTNCx79XdNUWAxSVladrQRQYVuJ7b1cXLBJFYfUzra9EI2CDflq3b3Q5f+9msZoPrGocKSPWdgfF1q5Z+T5Ubtj8cv6T/g2XLgzvblJ7YwYBjx5thwy2m5eXTcxNelpGxJ06I9DCXUcS8bZ1K72F5L/KRSXFB5sQcjP3tB7mBGQjSoYfZ4xh70X/b6hDKuu/eEpVxtGlYGC/Kd3mMpx73qqqokSdI0DlTk6OjeEbKHUdsxMSr38n1G/JapdthhJAQeOBWjHE6iQHKf4wO8+B/vBCYA61QmX4QEEpZ1HnDqEJDucIf3+YCp+wRwWLFAGodKhNWg2dV/IN447XZAFngykOVB8hB1ZieOesa98n7aT0F6l6aSi1FKT/6rvGTMD7Xcrcif+098sJ3ZHFlHWxjVk42D1L43E0LTXe/XFrAjK0ZtslwJwLYCmzrBwgv/6tXqsU22o7xgyOfUuE0povFDImlq30i8FTIxkRQuI5/UVP5azQ9ZSg5oEYZlkjzuFs0i14HXBkw97NnJ7YK6O9GqZ3HAEzPJgd6Oo+MjWUrw/FDIIk9z+VlUa/TW
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700016)(23010399003)(921020)(6133799003)(10067099003)(5023799004)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V9ixO+yzuNztHKiMMPo8GROnIXQNZnWpUyZU2l5+NOibLXn0hCaGK8gwzQBMsxK8ZzYWFBah3bObkh5N4IKpbgWcXAqvQBjG2RcoMHe/QTecEgSi2TlrkUeNzWbJ6yAOS1wzIrD3d1T0qCJNvHrm+CPUw9vcu/AR0npYlqDR1Pr2N2ZezzgK5vaBq19gQ4dM/au/lM0N+fGHSGXxeMa8slF4Ge6bkFOTF1jdE2sp2ez6QQ3yBJa1R9LtvbNZWoyZvzpCNzHEpNzM7ioGjHwsOWB8/LpBuVC8Z2FUZCoWEfhhyqDVk45C23IGn1oZL3aaOAC5J4x5bOLbEclnZAZsRhRV1VoqkMKbCbH4gS+YatETD6fvtj5lOfTJumjhWkqVIXKP13E9TT847+tx54k6NJ+BBVADNG757lDTlqRgFkeEelV15Ux/P19J0ItqkBCA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 22:00:24.7046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c172c2b9-82b1-4b89-8803-08df0f86eaaf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH6PR12MB902451

From: Ashish Kalra <ashish.kalra@amd.com>

When SNP is enabled, all writes to memory are checked to ensure memory
integrity. This imposes performance overhead on the whole system.

RMPOPT is a new instruction that minimizes the performance overhead of
RMP checks on the hypervisor and on non-SNP guests by allowing RMP
checks to be skipped for 1GB regions of memory that are known not to
contain any SNP guest memory.

Add support for performing RMP optimizations asynchronously using a
dedicated workqueue.

At RMP initialization time, run an optimization pass over all physical
memory (up to 2TB of system RAM, starting from the lowest physical
memory address aligned down to a 1GB boundary), skipping RMP checks for
1GB regions that do not contain SNP guest memory (excluding preassigned
pages such as the RMP table and firmware pages).

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
v14: Reworked the setup/teardown - initialize once and do not tear it down;
     rmpopt_disable() now only cancels the pending pass.  Use a dedicated
     per-CPU workqueue (WQ_PERCPU) and drop the migrate_disable()/
     migrate_enable() around the local scan.  Added a binutils-version
     comment above the RMPOPT .byte and trimmed redundant comments and the
     2 TB pr_info().  Subject reworded from "Add support to perform RMP
     optimizations asynchronously".  Dropped Reviewed-by: Ackerley Tng and
     Tom Lendacky due to the rework (kept Suggested-by).

 arch/x86/virt/svm/sev.c | 92 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index a059327dc107..35678b1f535d 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/iommu.h>
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
+#include <linux/workqueue.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -124,7 +125,16 @@ static void *rmp_bookkeeping __ro_after_init;
 
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
+static DEFINE_MUTEX(rmpopt_wq_mutex);
 
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
@@ -557,6 +567,14 @@ int snp_prepare(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
+static void rmpopt_disable(void)
+{
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	if (rmpopt_wq)
+		cancel_delayed_work_sync(&rmpopt_delayed_work);
+}
+
 void snp_shutdown(void)
 {
 	u64 syscfg;
@@ -565,6 +583,8 @@ void snp_shutdown(void)
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
+	rmpopt_disable();
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
 
@@ -583,6 +603,43 @@ static bool rmpopt_capable(void)
 	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
 }
 
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
+/* on_each_cpu() callback: optimize the whole RMPOPT range on this CPU. */
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
+	 * on, so the IRQ-disabled fan-out below only issues cache-hit RMPOPTs.
+	 */
+	rmpopt_scan_range(NULL);
+
+	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);
+}
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
@@ -591,6 +648,30 @@ void snp_setup_rmpopt(void)
 	if (!rmpopt_capable())
 		return;
 
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	/*
+	 * Set up once: the workqueue and RMPOPT_BASE MSRs are left in place on
+	 * shutdown, so a later re-initialization just re-queues the optimization
+	 * pass rather than redoing the setup.
+	 */
+	if (rmpopt_wq) {
+		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
+		return;
+	}
+
+	/*
+	 * Use a dedicated per-CPU workqueue so the potentially lengthy warm-up
+	 * scan does not tie up a shared workqueue worker.
+	 */
+	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_PERCPU, 1);
+	if (!rmpopt_wq) {
+		pr_err("Failed to allocate RMPOPT workqueue\n");
+		return;
+	}
+
+	INIT_DELAYED_WORK(&rmpopt_delayed_work, do_rmpopt_work);
+
 	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
 	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
 
@@ -600,6 +681,15 @@ void snp_setup_rmpopt(void)
 	 */
 	for_each_cpu(cpu, cpu_primary_thread_mask)
 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+
+	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
+
+	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
+		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
+
+	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
+
+	pr_info("RMPOPT optimizations enabled\n");
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
 
-- 
2.43.0


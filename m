Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D50143F4D2;
	Wed, 16 Sep 2026 19:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789588443; cv=fail; b=VErSR3fTuBZV15irkNACCHWp9U10AQdAWYPEitXER0AOM1lhb/ofN2mHwb4G/GXlzrfvYtiyUVO+aEcVe1A222/avq4Q45PGdg7wuQkMeayxuH90WBEK3U7GjuXvIuqqe/u2pNW9cWCzGXOW+ZZX35i7v5pXlJyzu4SSb3XSesw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789588443; c=relaxed/simple;
	bh=NDqF2mRtpmi6hJ1e88fZC4+ONzdkLLoHbg1TKS3cUN8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TeosBTeiG9M+jLFizTKuAUAoybysJ8HE3i02scWOHVcOHZdKlBp5PCsU40Uq4LjXOuQqcUY3rc4y+aR4+QUezHlNy+I9QddGSsN+RnqHq95hCCYypJzt0NmzDdxObf4c26OtaV9h3lA+/dP3jNBHqVUUv2Nied4VWn2bCv1WDXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZxJRkWH6; arc=fail smtp.client-ip=40.93.198.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZxJRkWH6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y4mWsnz6L7D8G/DqyaK/2U+LK8W8KmEBnbUZu6mayg40DJzhVeSXVk9LdiChWSf5NVSaCHfbOtTVbtMjDFmTWilEkwcSVyy2AYDJNaWIaT+KmDI9PGzUViYPtSaFc69D3FlNXVGMcumBT8050BIBpdnkk/jj5relnUTghq6sOwKmGYjDuTI++fQf0H+7bg9fJOUz5KVQyfrWwk7C0v/8zQINoxiiLxnBS4444mBVsIaNxYMCb7NITMISlYSORyPNwBJp9cYZo1tcenqUNT9MEWq6iitbSvaE0fawQOHeuA4ywFpRNAsGgxuTopeC49eXi2qSDuYKDBvr2b0VoWR2nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nP6e2ChGZEmzoc1I0PropxuzVPAcw9J692AGiObLcdg=;
 b=QQ6Zwr78JG6Y0QqwU2LC4zTJ+XW2L82SUk8P8FhroEQGnVSecwhGHr0VNfp2M6SLNK/PA975iuJZZlzQVKZTP0PVK6RcbrCwtAlMt0M4MYIiMGl8aiiVe7X2A2rksNCZbSPQCz7lWqqeK4DnyYJM2HrNlQD3tmS7vnixvOeGzbQYqTDKSYZJ6qyFbvPsb8mFQbb8xcPrrKpWr+Ov7FBFm5CtsbmmJQtnZBy1XmBnZYuIm83VnGrK/SO9I6CoW+3/lslPw05KcNVtDySjbQb29QwN25y2+PrYi7kvQ744ilGLtVXsPZxEtTvsGRwzsb4tJeUkFZPV9uG8WGSxqZTirQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nP6e2ChGZEmzoc1I0PropxuzVPAcw9J692AGiObLcdg=;
 b=ZxJRkWH6PZ6HXJsK2KaTE2wyjj9t2e9xF1k1IcnZQFk7xST1xTYDJYcN6aH3Y9v4Ew1XcW3Z9N4PF0vAqLrdE3ATgNn7gLoN72ZSF79bYKbYMH4b1AjMom4il3DDG5f3f5eevShXH8/l3s/2K7JGUQOcojWm0GK83nfRks3Pr14=
Received: from CH0PR03CA0438.namprd03.prod.outlook.com (2603:10b6:610:10e::14)
 by DM6PR12MB4355.namprd12.prod.outlook.com (2603:10b6:5:2a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 19:53:40 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:10e:cafe::42) by CH0PR03CA0438.outlook.office365.com
 (2603:10b6:610:10e::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 19:53:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 19:53:39 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 14:53:37 -0500
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
Subject: [PATCH v15 4/5] x86/sev: Perform RMP optimizations asynchronously
Date: Wed, 16 Sep 2026 19:53:22 +0000
Message-ID: <4d6d44f7a6483670b3f7c7362b1ea528cfbf8144.1789586444.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789586444.git.ashish.kalra@amd.com>
References: <cover.1789586444.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|DM6PR12MB4355:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a6ee299-97cc-4efa-aaae-08df142c33ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|36860700016|82310400026|10067099003|11063799006|5023799004|6133799003|3023799007|22082099003|56012099006|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	IFDohgPvBwNcXpxYmNxWvXOTrhFiABdFjeXciAnuLlxGc17lNZkJQE/SyNOWrs2JtgbRhIB9jndkkdKO0mKSGu1SC0tdWP1z76dwC/UciHpXgss2z07mCamBkrCfPbfV4uNVvrfejUBfnr6Axo93axwIPazSV/tWadvTIL6K/Gc3u87htOubmFYLuhiQqoMnMBJHbXpARZEwb1W7xJVwu285gjsy9XjQ4YmRSNg9m+q++dT+AFP/khKHYaXao/AkC9QpSwyDnbOTERs8aymwtyPUQK3hfcAfsKq0udbm4JmhYTmws8b1/4IjV48rilglsCVql71Z9xCUtnAxJ3AENW+rxwGU2K2zCKc5k+vZeXFDidspZGSVEiOw6fqfySE/Le7WxqviaUtPUeioWyNm6CngKwx2MK5c2oDQGNOHaIOnQk/NqUA7kd9D1T0rvP3YoLUhs6EMCKO5+DwP3x52cFNgl1VPxOPdPdzGrph69MhInBJo0m9CpmZLiEdwhYSGnvB0TBT38N7E8aAoHduSE1lE/c3aecPuVpr3pG18owoayFI62VRz7vvDiBZECmk+wf2rt2y9dNhAQHriJDqpgkkGlf/2OMzEIUL5xX5qS2bj33WxrpT51eijov5Hei423ChGG2bwPOl6hzMy5P8tp8EunGqiJkadkKAVOjF6HM9bX64q9waDfRAjIQxiuzIXM9CrZz6Jq9DsK/rDh5+MDwGW7qcDUnx60RYomT6Fdtznndywbf4MgIzz3E1LHk8Q
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(36860700016)(82310400026)(10067099003)(11063799006)(5023799004)(6133799003)(3023799007)(22082099003)(56012099006)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YjtdWHwaT5+WQhyMPd+t+DiOxcKGhFJsnzg1xXfuh3dA9NXdnSBznKyf7z4kvS6ulrkWsUqGucm15PJXIRzgvl8zlG4M8Ujt+IUmVUAwuspWk+daDqzIoZvSWwzUX6rb5KUodwrkdy+CbNOU3SQRjMamYr6eTRSPRxLhJqUd5WlR5GcfxU+89TsfjVdkseYPUtq0lsEfpIeBNjH5+uILAtLa1QAdGH0X3XKg7fuLlNL9nRfuJq7IQnAgkP4ZPIxs0jZCVcD/gM43+Ej/14B9Nnf36cecVUCeF566HJ+KA6mt9/pi7D6csl06qV5zGk/W1OE8hXa5UmJgzpVVbhjQ9cTQJtPyGQvNYRCRo4PgsYXDpxNno2BDRJ487lDPs+GaJkz4H6BOxNbt92zZbNJtfBSPDRwxp2dV+b0AnT70PPakpWOFCvcsEYaXvgEgTOOq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 19:53:39.1562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6ee299-97cc-4efa-aaae-08df142c33ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4355

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
index f458128b9864..54520d4cf280 100644
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
 
 static void rmpopt_program_base(void *arg)
 {
@@ -599,8 +687,6 @@ void snp_enable_rmpopt(void)
 	if (!rmpopt_capable())
 		return;
 
-	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
-
 	/*
 	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
 	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.  The MSR
@@ -608,6 +694,11 @@ void snp_enable_rmpopt(void)
 	 * SNP init path (and again on guest teardown) rather than an initcall.
 	 */
 	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_program_base, NULL, 1);
+
+	mod_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
+			 msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
+
+	pr_info_once("RMPOPT optimizations enabled\n");
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp");
 
-- 
2.43.0


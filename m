Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012061.outbound.protection.outlook.com [52.101.53.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5E5384CD8;
	Mon,  8 Jun 2026 18:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780945048; cv=fail; b=Lt8GP8+tOnfvmwsJ+YXHQla34U/AVD8PYy3Jc87W5zZlUTEJ40YUjB9bH7OnjRCHk2qqLxj26DnbMYg1rSRjnom9KYfOCGb+w3zVLDwYr/tNgO05f17Pz03p9969fBaw/1sm8WLSz3cagHkeW83kyFdO4YAmggqmkYsDaFYJB2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780945048; c=relaxed/simple;
	bh=vSKBdbJMsSLqzzX6LG7fxqmtBHxKmaDC4H6+McoHa+M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DxDNbhN9ur/zqw3kaVTtFu7fYgMuutYOE9h/enUZUVehvM0bTusweOMS5DfLACtUR9bS460XcayE78SrcUQpQHIh7s8B08xD/MrM/qpPcY21t7U1kJ1P5zzfEiIULQppAw8E5WHFalvlrSDso8zMp/59WhOb5ByzReukFWLHjtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=X2fuCdpX; arc=fail smtp.client-ip=52.101.53.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="X2fuCdpX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IuyEutmMJ2GydLzuAqoTIbmaOIV/PeBBX4egMHzc9PeLTLR8I18OHi7e/7BcA5Z1OCQj/O7dxkzkawkIF6J/rGhji0yuxL4A1NEXFQ8s8yatMoSfy1fanGuwev4GMeY6yiXbVFwnEa00uYVw7hIZBvY5j41oMfTww4FWxmWvOIXPOpS/a8dFCtTh1daZdRoI141xfGgABtySOMNR6bKAaB0ql4yElGmk0DvJiYMfkQLrnEXyoOviuSfzoDNxnANHh9RE8MTNbkJySVF8CTjkZkBwvpYx2IZZYPSTF9iprJFR+CSexcBz/DfjnqRVbujP+0EK5NXDVb7vqw2IUOi/Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ErV2V9r8RMRYSFh3G/yQKK2ClO1Wd3UcJY/m1KrEA+k=;
 b=vI8cblauxWnuaq2fbxaSOingTxSnzv6Yhui1k2sqnroE/nUIPrfEfvB8r+JdUoaoEfd4wTjvPO4gi/WrqEPltUsM3cQobX74XEEb/shAVwfbjBbAqWJci9czs/onjDkmq4Fq+vsM7EMwbxiJy9h9oaXWarIdptDfQZWXdToqhlA8gfPjkk16aNg9Y8FFiHmwxL5IWpn1HdKel27f80Ob4uaezHUDTl7N22uMcv2ns5h2tBNcPyVIblUhCKcI1ipaSC6A4KCbnh5CY7aUKptTXvnUXJvyg3dlQdBBWM+PkgFs+6IR69MkY2QoaDgD+2thKn6bOvjWztElmleuc7EC4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErV2V9r8RMRYSFh3G/yQKK2ClO1Wd3UcJY/m1KrEA+k=;
 b=X2fuCdpXYI6l0jTXpEeGe2J24BvLPUOFkHUuIPO8yxFDouvkYiOptBal2SXpWfYiYUNPNb45LLvUPYZrIt1fA0ggRTk4ivaq7uoWUq/c4m7unt79eUwI7gindd/gcFH+ul3lwc1GSzuYOu3q5APd6YLW3SnUgsE0rrxYLnnv2e0=
Received: from SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6)
 by CH1PR12MB9621.namprd12.prod.outlook.com (2603:10b6:610:2b2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 18:57:17 +0000
Received: from SA2PEPF00003AE6.namprd02.prod.outlook.com
 (2603:10b6:806:120:cafe::3b) by SN7PR04CA0031.outlook.office365.com
 (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.13 via Frontend Transport; Mon, 8
 Jun 2026 18:57:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003AE6.mail.protection.outlook.com (10.167.248.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Mon, 8 Jun 2026 18:57:17 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 8 Jun
 2026 13:57:05 -0500
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
Subject: [PATCH v7 3/6] x86/sev: Add support to perform RMP optimizations asynchronously
Date: Mon, 8 Jun 2026 18:56:55 +0000
Message-ID: <fc14f6cb80c37d08d308460d2f13279bf3a32ccb.1780903370.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1780903370.git.ashish.kalra@amd.com>
References: <cover.1780903370.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE6:EE_|CH1PR12MB9621:EE_
X-MS-Office365-Filtering-Correlation-Id: b4da77ce-0a9d-4b5b-896e-08dec58fc2ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|82310400026|22082099003|18002099003|6133799003|921020|11063799006|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	Laf3EYpRRSnRid8a9yGVVjc8WF6jM6DHBLs6CIDozOBln/+JixSqoeDlS362Y+sqONOFp8xxLCGsaa3I+EsoIsZVmlMDcwnzPv4FBfOoO87kvKamk522y/KseCUCyUG/QVRAQoNK2mpTLjDSA221unZptQ2wNPgpxMaIjjkffKbuqXSCJjR6AgBYecVJHNCY/SqUpAaJHjrIVQ6x2RUzQvh/rHugedOn1soVCSH+7lu/KNhQRbAhJ2sWKcueZcDRA1SWdpvNJmDYXPsk44YIs5/hpnK6KJm+RhecNu92n/dOj8CAktQycEyYMu7OUsHQbMXCBNzr2RAVm5pKjcO61CLWThiAlHtELaXva/R/+KpPh40MoVvozNWrjEIK6H9VCgEj26kI7fGac+mDwxQG7v3u2DFRM8KMuFNqd6b66x3rwUtetKJTa5hTy6eq8jj2hWOS9eNtGgY1LgaPtr2nEkv5UB9qlG+7owXrF3Nx+MeBSqw+9u4uQ08/rcf1pMRNWmfwELdnurm8Xd27wqtwxeOGjK4F5rV7sZl6JRKQOUhbmjaAQXJVPYdSO/4QjlpSZAnaC4goDdX4Zq4pdbKEgXDh40iyGycrA/sCZl/HPckXRXhZK2w6CxfrPYcOvbu7SRjr1hkcGUsGX2iv+7Bah+0kRq1bSRmfptW/taD/xQiAyX9Em2szANecHJc8z/OQubdlkWnh/VMAlRHzKMJNxwIpUT1l0vvtMlCGYN/dXGH3K3itfaO9xIytc/qtreE2M5H7G+xum9o9c5hrxpf7/g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(82310400026)(22082099003)(18002099003)(6133799003)(921020)(11063799006)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CWNBJduHWb8bms6RHNEIberNkgjnc50sErotqPGUyauIhZU2pqo4rc+Nli7g6wfhDGNb9hxP8qUJtedBf9m4HmyM5SQwfHoHjveyuCfGyW/O2zP0ggCMjP88ZmbFRtm72RpW0HILZE1jmCceAEDxcW4S194JBm+sjuBs3JMPQlJt807QsLxfM/n3hLMIif1fWOwKlV9qw4lF8BGgOVErzfNBbsO2PvrCvPNhzH/iIFPjvpweMx3ccifDcIdWQ0X8yvx7v93ES3FKQ3dt/O09OUKuzW0dFfJH9gPFMyq4PE6XtnIpZtOVsJnM8jiORWLRjCpVSyRt7T8vXszwifUFTIY4NQqtFOX650oa4wb+CgBrFzR3H7k9qQzCRgzDHa45oXt+rBdAMxEp/GDAQQx0EQHST5LxI/2l9vjleBlSCfsNE2fIifCOELiWUXL4CzOG
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 18:57:17.3984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4da77ce-0a9d-4b5b-896e-08dec58fc2ee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9621

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
 arch/x86/virt/svm/sev.c | 208 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 205 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 482008bb07e4..b42788a66d40 100644
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
 
 static cpumask_t rmpopt_cpumask;
-static phys_addr_t rmpopt_pa_start;
+static phys_addr_t rmpopt_pa_start, rmpopt_pa_end;
 static bool rmpopt_configured;
 
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
 
@@ -568,6 +580,14 @@ static void rmpopt_cleanup(void)
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
 	cpus_read_lock();
 
 	for_each_cpu(cpu, &rmpopt_cpumask)
@@ -576,7 +596,8 @@ static void rmpopt_cleanup(void)
 	cpus_read_unlock();
 
 	cpumask_clear(&rmpopt_cpumask);
-	rmpopt_pa_start = 0;
+	rmpopt_pa_start = rmpopt_pa_end = 0;
+	rmpopt_wq = NULL;
 }
 
 void snp_shutdown(void)
@@ -599,6 +620,146 @@ void snp_clear_rmpopt_configured(void)
 	rmpopt_configured = false;
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
+	 */
+	cpumask_copy(follower_mask, &rmpopt_cpumask);
+
+	/*
+	 * Pin the worker to the current CPU for the leader loop so that
+	 * this_cpu remains valid and the RMPOPT instruction executes on
+	 * the correct CPU.
+	 *
+	 * Use migrate_disable() rather than get_cpu() to prevent
+	 * migration while still allowing preemption.
+	 */
+	migrate_disable();
+	this_cpu = smp_processor_id();
+
+	if (cpumask_test_cpu(this_cpu, follower_mask)) {
+		/*
+		 * Current CPU is a primary thread in rmpopt_cpumask.
+		 * Run leader locally and remove from follower mask.
+		 */
+		cpumask_clear_cpu(this_cpu, follower_mask);
+
+		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
+			rmpopt(pa);
+			cond_resched();
+		}
+	} else if (cpumask_intersects(topology_sibling_cpumask(this_cpu),
+				      follower_mask)) {
+		/*
+		 * Current CPU is a sibling thread whose primary is in
+		 * rmpopt_cpumask.  RMPOPT_BASE MSR is per-core, so it
+		 * is safe to run the leader locally.  Remove the sibling's
+		 * primary from the follower mask as this core is already
+		 * covered by the leader.
+		 */
+		cpumask_andnot(follower_mask, follower_mask,
+			       topology_sibling_cpumask(this_cpu));
+
+		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
+			rmpopt(pa);
+			cond_resched();
+		}
+	} else {
+		/*
+		 * Current CPU does not have RMPOPT_BASE MSR programmed.
+		 * Pick an explicit leader from the cpumask to avoid #UD.
+		 */
+		int leader_cpu = cpumask_first(follower_mask);
+
+		if (WARN_ON_ONCE(leader_cpu >= nr_cpu_ids)) {
+			migrate_enable();
+			goto out;
+		}
+
+		cpumask_clear_cpu(leader_cpu, follower_mask);
+
+		cpus_read_lock();
+		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
+			smp_call_function_single(leader_cpu, rmpopt_smp,
+						 (void *)pa, true);
+			cond_resched();
+		}
+		cpus_read_unlock();
+	}
+
+	migrate_enable();
+
+	/* Followers: run RMPOPT on remaining cores */
+	cpus_read_lock();
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
+		on_each_cpu_mask(follower_mask, rmpopt_smp,
+				 (void *)pa, true);
+
+		 /* Give a chance for other threads to run */
+		cond_resched();
+	}
+	cpus_read_unlock();
+
+out:
+	free_cpumask_var(follower_mask);
+}
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
@@ -607,11 +768,35 @@ void snp_setup_rmpopt(void)
 	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT) || !rmpopt_configured)
 		return;
 
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	/*
+	 * Guard against re-initialization.  When SNP_SHUTDOWN_EX is issued
+	 * with x86_snp_shutdown=0, snp_shutdown() is not called and
+	 * rmpopt_cleanup() is skipped, but snp_initialized is still cleared.
+	 * A subsequent __sev_snp_init_locked() would call snp_setup_rmpopt()
+	 * again, leaking the existing workqueue, delayed work, debugfs
+	 * entries, and cpumask state.
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
 	cpus_read_lock();
 
 	/*
 	 * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
-	 * to set up the RMPOPT_BASE MSR.
+	 * to set up the RMPOPT_BASE MSR. Likewise, only one thread per core
+	 * needs to issue the RMPOPT instruction.
 	 *
 	 * Note: only online primary threads are included.  If a core's
 	 * primary thread is offline, that core is not covered.  CPU hotplug
@@ -635,6 +820,23 @@ void snp_setup_rmpopt(void)
 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
 
 	cpus_read_unlock();
+
+	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
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


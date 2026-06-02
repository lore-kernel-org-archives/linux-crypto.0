Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013037.outbound.protection.outlook.com [40.107.201.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0435D25B088;
	Tue,  2 Jun 2026 20:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780430506; cv=fail; b=B0y1h0p3fwxzrrTqyzxo9b6H2+DdRfIX0qNsQXDVBattHGsGfaUXLN3/qFwNG6EGwGk+fmGNDM3WF1RPYjddSF/tGdUIf+V3nRLonpGGBroMIvrHVdWjst9NYOHqxG/HWFG6E8kk7Sd8COv3ELRzm5BUzaisiu0GqdCYVGvVm9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780430506; c=relaxed/simple;
	bh=76wyUAO5Yt9o3ibdWis6iI6xeckgWorxMh/mVHpj5l4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E3ryVrH3McphZTBVtWeCoLsXSxARkHYhTUGbXfnxr5KMzEN68a6IleDknjFMl1ULobymTyBqwC3PWbTJEaCTrtd3aYCnYO8bKy6TwOq35vvloWfKpQ0nLpT3TLSXydcm8epZ8ITDQZmefMEYe2v70zz8/vfrqaghDVpl2oc6/OE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L+JCHHGw; arc=fail smtp.client-ip=40.107.201.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L+JCHHGw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hSDo/oNyBycAOyxzoW8wIbM+BciWelU9f8VlyYQf46gkIXNH3uZTaqmwQPTfChb9o7RDWLmodArd0QecW0OIamfn07+BUlESbq4+eWB4KMOW5HDdZHQhm7LYzm51tH93+q5ySHCebx/NXyJmOFh1zVzyvk5f9tC4dIkRgiWwS9IlYn21V/xs8Dm+0MbPbSRA61fKbysut9gjpmCDQrRin94ZiY64SU/2oe27XlZEUKpzZ3kA9Brzwvc1v6nLQipjBH0pLZ/nYPw+Uh+H97lH4cTnb5lysJBqi97ZZ1JGv8JH0t9avI1Jp96Rk3+C7wtOro7CtHRSC63i7Sk4hIJCyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVE3nW1+AyLS5etEKcagC+UdBq7Qa0Y/SFYlPQ3MBF4=;
 b=J+ze8cE8HfNQfpxA+oFubAPIV8VSNouEKpuUcxrsQf1qxZJ/VrsdUNXtW8M7UEsIXU/Ail6DGJ+6cCmFRSjwbD8JzXRNWbwz7F2mOr8ksE3bNBPkJ7YGeON7I0ug/66QKoeKJ6t+BXoTPKF50VZt711uYJzEEIYZKD4QeXpDZhiXUrd5Z6mt5kJaZeRyCeoHNjnPCRyHG1UN9uhFmZmVvcSPeQmvN+7dqr3bsPn7yF96JcTny0gcwvKuoAXVgU/VCC4LJYVAo9LI387CcO+GghYbh42Lz1INCGbKMrgiBsO7wPXHLrj0H7K3rQ/0TEV1/U8NVVrYiiC31bZ8j3BUDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVE3nW1+AyLS5etEKcagC+UdBq7Qa0Y/SFYlPQ3MBF4=;
 b=L+JCHHGwz7qY0p/ne2vmustKmwb7klyi6Wb+5gM/dAxlT+nSgozyUJcJE8Wj+v2dFyauU+vR2Q8bzm1atp5YX0NA+V3JN4Se75YmrZ1GbthidtmD1vZfv8UyW1aPhaL7ORa3Ca1kI6+S7o8oGLXufK320m9+BbqKZch4AtbuawE=
Received: from BN9PR03CA0202.namprd03.prod.outlook.com (2603:10b6:408:f9::27)
 by MN0PR12MB5980.namprd12.prod.outlook.com (2603:10b6:208:37f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 20:01:38 +0000
Received: from BN1PEPF00006000.namprd05.prod.outlook.com
 (2603:10b6:408:f9:cafe::27) by BN9PR03CA0202.outlook.office365.com
 (2603:10b6:408:f9::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.7 via Frontend Transport; Tue, 2
 Jun 2026 20:01:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00006000.mail.protection.outlook.com (10.167.243.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Tue, 2 Jun 2026 20:01:38 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 2 Jun
 2026 15:01:37 -0500
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
Subject: [PATCH v6 3/6] x86/sev: Add support to perform RMP optimizations asynchronously
Date: Tue, 2 Jun 2026 20:01:28 +0000
Message-ID: <29adedba9e093ec0c9aaafa006f4e822ac872d8a.1780427587.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1780427587.git.ashish.kalra@amd.com>
References: <cover.1780427587.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00006000:EE_|MN0PR12MB5980:EE_
X-MS-Office365-Filtering-Correlation-Id: 1de2cf56-0655-44f0-f577-08dec0e1c1e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|82310400026|1800799024|921020|3023799007|22082099003|18002099003|6133799003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	cYgNgOTnZFyY8XXpPls20QydYcUDq3oytNGtPWVEAVBsbAcRb0mk+7dnXWk3d2P74I3a+KXl6SqCu40RrDjEM7REWYhbkirXufeDBSSrr0B39mA9sOnFOKMZemWLJ9wmRO6CIrKGMmcLU8LAKKxGYKOGO06zLbSoh+FjocK7guBUJ5aUGBTdjXgGn59kVfZmjb50uO70W8N2JT5EXsdn1mzbnJOdhnbkB5iLVPCvVGnx4TqCAUx/WgxSn7LIIagmxZPvQaiW/L6EKqcvaBWaH4O2C6pnULXbXmmlA0x7VztKRMaSpmuzlUbITy3r7YZVwV47wzWfxn7n19e7amjEVQYIFJgcdCZ0Ag7PBt/4NABXpzBdek8p+juirWbwyIyYH0biYTNOH4prUkwj4myJe9nUyoXMIH3HHW6mBodnsiBsY3aD98rpfe609vrP5aiaDHHUJuXatD2d4kJ64eYZwPq2YUdjWdbiE+Nq1ibLVQXKKd3wmKxOjkJ/q1yAJtCWYHssT4mgseDUQHoyzevW1h1ghOR3VZ2Lq8+jeo2m+qLm5bczSYINXib0PYwEraLkygfVYDS4s/WqsAa0vYeREHHxXXAQMzyGu67Jc6d1M3rh/JTwYeQI6EWDGXQUo/q7ocBCpL6C910iCVAklX8LD83HkMXXbrje6XM/RC12TroG+k4sKlWDo2BnkHIX/gXV/RwWYU1C7c/EL6YKuPQOsxmeHFfhKOf833GCUM1AscPo9pVLVF+r8rcNZc1qSVce2GjBmrHhY2SO00Tyvz+r7g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(82310400026)(1800799024)(921020)(3023799007)(22082099003)(18002099003)(6133799003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dJaKN5KmPtFvswn4W6S4rYko8VXb9que9wjZdRqFaPaS73ARu/TeFXrktN+87eIG7P09SKIpP8NsGVd12FJUcEjvgL+y7RqBf78DI+XukP70cX/80Ylxqj82dt60iilNl11jZRq0bw19DX16GYaJxrkXLo3Vbwmuj7yGVf8NZuxFd8CvhNA8FLo/oZNQIqjgnPuoAkmW3uRnAeZt+5vtVUOfmBaZXZIu2z6YV4OE+cusfm3mZbucvCzGGpM+2jzd1se0nagJo/Lu/ptssODPN27Zha8idDkbXlditFg2ZRCmP5jkh3EjGJDglAnSvKBv1WCBBYz2+ZSzb0C7nPkP/BnOCRy2s8w5WAPHyiMQp8FHqAksAH6m3Uet2HjNfS8ZvHdk68n+WhpSlzjIcxWq5TCA3JuA1cHGEfrTeqRzg3VcVkS8S7sKhfx2v6WpSwj6
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 20:01:38.6065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de2cf56-0655-44f0-f577-08dec0e1c1e4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006000.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5980

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
 arch/x86/virt/svm/sev.c | 196 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 193 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 089c9a14edc7..d7e40a5fe5ca 100644
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
+static DEFINE_MUTEX(rmpopt_wq_mutex);
 
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
@@ -566,6 +578,14 @@ static void rmpopt_cleanup(void)
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
@@ -574,7 +594,8 @@ static void rmpopt_cleanup(void)
 	cpus_read_unlock();
 
 	cpumask_clear(&rmpopt_cpumask);
-	rmpopt_pa_start = 0;
+	rmpopt_pa_start = rmpopt_pa_end = 0;
+	rmpopt_wq = NULL;
 }
 
 void snp_shutdown(void)
@@ -592,6 +613,134 @@ void snp_shutdown(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
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
+		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
+			rmpopt(pa);
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
+		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
+			rmpopt(pa);
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
+		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
+			smp_call_function_single(leader_cpu, rmpopt_smp,
+						 (void *)pa, true);
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
@@ -600,11 +749,35 @@ void snp_setup_rmpopt(void)
 	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
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
@@ -628,6 +801,23 @@ void snp_setup_rmpopt(void)
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


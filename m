Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011006.outbound.protection.outlook.com [52.101.52.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9C03AEB27;
	Mon, 15 Jun 2026 19:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781552993; cv=fail; b=uqGAY9DO1FrLSl8gPwYzSb/emeTH0KNodNa2tq4xzuRREkZTEw7eruWjE4Qdd53RNVwVbdzqkBXxqwqoQrjy3NNVGSAZ8S1hY6YHhQYZog8iLo19m9UksrnJ51p+fTqop4tQizjEkNZCyQFY0gDcq/33PgvhobvQQTi6lSqyoaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781552993; c=relaxed/simple;
	bh=nnA8z3k3H9Dk/obSrMhi2PiaRfqI/X4iY4t9v+YvVPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sthP8pN9hXF748gwR6fsQcMYwWaTBCxHzu/Y1DlDIxPiuoNMTotAJUl6oD431ihQ2jhOq9e5v2kTMAf8m2V7251EstTommJQtE8JDhiGlnT3JRqrZFBOOK6bkCOT/58L+SM9HBzOptDw41sdFX2KNhh6/eSv9uQLlz/EXvV3Mww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y62noqQL; arc=fail smtp.client-ip=52.101.52.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y62noqQL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oujcMTOD4Ftc5udx7+InIM9mBhbJfBU02HaMVrvneza6CQQUzeZ/7mteMjdrriJwhYk2YBxdbcFLoyjJuimlB9ADlajNs4p6mHPU7auFZxKmG9sVCBh9GoMxZ9c1IZaByo4WjdS9PkxPFbtLYY+w7YIU9ZpwVcnHp+A51VUc0T3K28F3n7BdGEwgbAOmm4EQK4gZH1jWQEvt5qr69WKorPV+j7o+dxRRcLFiHmtIGTOmXvTcxw4W8RElMoPrlDEKZ7GUfwoG/2l+AmBrvlNU/RcK23nvR1TSxxEekQ5O8THWp/1UZb4BO4lgOUTcfqRr/OFLktm8tEclHXkAnio1eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIGrHbEkwDuR3yqQiOrSFVBBWRs8Mar3pByF9PzeAnI=;
 b=EKXUv4SaDR+oJKpXQy2+56UNa8SX4gD0c73slmfsiMo/ygylhND3l1gBTS9x0GDCzRxzsqL+EDUF3biBBPxLBmxGtL0Yj/u6CZCfZF7lys3b7ycC3aOxEDEU/kH2y7qAL3Ns8gOzWOyRsk+QPLuY5vgNF3Y4qNAnnXAkAcqpGVntZ1LYk4YMMvbIQsaZ2xJD5XsT8K+uX3Wexu6ZitYPgjL3nU1kWjk2eDJQIf+wfYLq38RdUugsQjwO6vgUgOCaGEde9W1goJqs3uEoCMVNcwhooHE8Qr0V7hstvYEH071oR2KWyOLgjpD4VNxXgtBKODl9+Cwhd/s3HJ+cWebwlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIGrHbEkwDuR3yqQiOrSFVBBWRs8Mar3pByF9PzeAnI=;
 b=y62noqQLpHIUIUZadRqDTMb/aUeMy5Nh3weX2txtl7UJUb6P70ENlDgzoNcTxyo9V6vzg3MeWFHDacJDmyBX9RtsYR48h9nf9dy7Kb2tZ7R5ERp/vjIROhCjNNi2daXQBqYmvYdONorfBV4UBJTv9+G80f++6rVh0vFbz6DD3ow=
Received: from MN0P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::35)
 by LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 19:49:41 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:208:52e:cafe::66) by MN0P220CA0012.outlook.office365.com
 (2603:10b6:208:52e::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.18 via Frontend Transport; Mon,
 15 Jun 2026 19:49:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Mon, 15 Jun 2026 19:49:40 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 15 Jun
 2026 14:49:39 -0500
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
Subject: [PATCH v8 4/7] x86/sev: Add support to perform RMP optimizations asynchronously
Date: Mon, 15 Jun 2026 19:49:28 +0000
Message-ID: <de274c2fb3f794ff1f19f0c96184ee50d04d1282.1781419998.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781419998.git.ashish.kalra@amd.com>
References: <cover.1781419998.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|LV2PR12MB5797:EE_
X-MS-Office365-Filtering-Correlation-Id: 535153ea-879b-4a76-8471-08decb173d81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|376014|82310400026|23010399003|1800799024|56012099006|11063799006|22082099003|18002099003|3023799007|6133799003|921020;
X-Microsoft-Antispam-Message-Info:
	xLyy6sCpSgUioJBBvyHuUGDwYbihBS16xZkCBX/JK6ubWGcLYqXFcQhfKPn5rNbifX4vUldIk2Vx4quQZi3861rhZen//nr928jq1RM2vOvKlfSjLOqI/oWa78unC7S803hQxCBn3aMvN3Ssaf9oWEQ2DWiy447QlB6be7JEvjkRlLE/EQa64rxC1m5qRAd3rL2AmXwgmlpLxvIH69flVgz5ZoNrjlLoNwiVgxHfmyXXPSc4UYEZBjxItCK1XNzGm0Y6iJzyBfF+/pTRI93Pl4CwY9+uLU47baiJtTRWedRZTAJO08hRYm5sfi343EoqUqCwePn9oaGHqi3s0k6BpR6QL9gL3l3UG0dGIy508eRNlj4bvgTkGH9Qj1/3xnhaOClROf277wYN/MXnYftx6WG6S8ORQXpUFNhVgMOlG54cPkhRJxuQ1mSER4/GbV7NnM/557XT0qkqcb2ICIgZ0Jas6jQ00ZkQrihbZvdDjfgxrI4T47pU3UHD6pLQmGCAAl1b4Jtciyx0yTUAIcrjWXx4julgVcemBviYhvsY4qIA7qrcwUHIg1OHHIOvTZSo/KUTT5TnL1OEWbPPo8RKNwjgwvtpTXhos/HLr5VP5ZRiiz2AYxUuY/Ht05RlkPs6+TdmsGDv/ckms6ahZHgeWFmLRbix62ok5knGpfCS4raA3LBrAcOc08E5fcQDqWeTshuQvmYToeC03iNk7YbHsl2zChGvDyDJxc9FZnchkqI0H0VN0QFSGKenHNnbHHb+WQRcFnnFp3EnSa/R7ILYrA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(376014)(82310400026)(23010399003)(1800799024)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007)(6133799003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	p/+nhJxlxL8F6KU61izfWBl1xQCtskheG6+93fkl70V10/t3Ei/jJSIwVK4bIKizPrjwerZ1qraE1AE+HcSVTmoj0KLnQPiqE9tvcvpYkPKwagbUSnHsoRqrjkayLDz6OEwGHIIA9MHjTK+/bPtTVdRI5wRdBxuxz1NKe4/CEqtYBbIyvuTpbfZb4rrnIWHqCqr+0YlyXaJ0v5j+86C6NynwwS9Djpcfu2sabXgKIqPu5IFbiV/PhgHBmvtNWPO6Pec+ypqUy61PyGhTV2jQqhhBNRxtLl5S9yEmpzmJ6mo0dcvkiyIZeFqTjL8wJ6c4zi1XoY3RcVx877RVqmy1CEGmAvkNnIVJUYYHiTyrPK4hMAwI6EzglblfoSSF1SyN6f9hEUrzWd6chT64eMRpnd43zm+8sZOcnszWRl1f91Z0rGgGvE7z3eetHndzJOH+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 19:49:40.9327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 535153ea-879b-4a76-8471-08decb173d81
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797

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
 arch/x86/virt/svm/sev.c | 230 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 227 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 1b5c18408f0b..b63b639bfc30 100644
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
@@ -599,6 +620,168 @@ void snp_clear_rmpopt_configured(void)
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
+ * Leader function for work_on_cpu(): runs the full RMPOPT scan in
+ * process context on a CPU that has RMPOPT_BASE MSR programmed.
+ */
+static long rmpopt_leader_fn(void *arg)
+{
+	phys_addr_t pa;
+
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
+		rmpopt(pa);
+		cond_resched();
+	}
+	return 0;
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
+		 * Use work_on_cpu() to run in process context on the leader,
+		 * avoiding IPI latency.
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
+		/* Release migration pin before work_on_cpu(). */
+		migrate_enable();
+
+		work_on_cpu(leader_cpu, rmpopt_leader_fn, NULL);
+
+		goto followers;
+	}
+
+	migrate_enable();
+
+followers:
+	/*
+	 * Followers: run RMPOPT on remaining cores.
+	 * CPU hotplug is disabled while SNP is active
+	 * (cpu_hotplug_disable() in __sev_snp_init_locked()),
+	 * so cpus_read_lock() is uncontended.
+	 */
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
@@ -607,11 +790,37 @@ void snp_setup_rmpopt(void)
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
+	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
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
@@ -635,6 +844,21 @@ void snp_setup_rmpopt(void)
 		WARN_ON_ONCE(wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base));
 
 	cpus_read_unlock();
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


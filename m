Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011054.outbound.protection.outlook.com [40.107.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AF43E3D98;
	Mon, 30 Mar 2026 22:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774909626; cv=fail; b=Kfr+dAVzICPuRf9n1xha0kEuHKzMnWAVrr0vd/BkBWJldghFEUfGgTJpsrJESCFU1/K0AVfYpYETiSaJeTWf6qWsDP4/ASEczSp2EfBOE+YkeiTwkvsO26109zMPfCiwFUt5o8fIN39HGFsvOmhlZNfUTbatbd0U0JypXihKF0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774909626; c=relaxed/simple;
	bh=UA/Ul2JZl+vnzxvoIFxvrxlCp+O9P+bowu36YNBzFy4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VmzWVhs4AUDqIwR42hYJKc1eQu6XAV5EfH++vfCyl3+zQz+BV7iLvZ+dqDVoK4wTmz8WjKuWIasJ3028oKS8OZegB2HasTf4U/N1El4Nk3m6A0dtZetNx6zzr0GiszKEPqJHRxPunRUSpnxmNtvwcuShl1fGFncA2IDy8/tAogk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4xzOzsNG; arc=fail smtp.client-ip=40.107.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4xzOzsNG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QwT0Cqr7GPvVxnGgWwMgphtepSZDOABslg7Gqrn53zFUvA6gkS2JKLrooen3ostYSOYdPAxO+3zTO1EFhVS9T/reUyRxAu6SSVzZdwROuUsis9xlCKHy+E+85ueYh9Ek/KZMHTj3VU7uEij64pLmpR3aBsavmG5HKNVRryFkEb9+w0ko9kBQxDLhOSYhCrsvH04KjoNZkwRMQM2dHTz7qZaaVTonPaUZgfJiy+vBIOqQjtAHqDkEvlxVQiFAOf5N6u4qwkS9zPdlb+D54ljv4Tlu4jqByTb+ut74wqS8eze72B9otFDvp1hH6AGGNt+uBIY86DWwtxYeUaC9Aha3OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xy0/A+I9tTrow50Mj8C/CsKLIGbuOKHVFfcSnpCbuKM=;
 b=fq/C5F9ehvsUNrda2TC3OJ+uwYe7HuZuuurrVR2WxvSdT2FD7DXKMBGdm1bqCxp91PrjTI32omwZr7zqV0EiUvsqT9j/YUsyY7L9/aYCIjJxrIg6n58ln4/79c8hZ0bSkU4zyngRURFo9EZYpOlvvXaEBa54lQtjXK9kz1FPafAKCDmfLzuGzB1GuNQG0bPNCc80eUvekB7IMHenx56U162l09YVbnaBM+fwuc0MQFEMTih/7EcnJp/0A1KcPYEBOOrcNoyCoTE5GfHd4E8FqpGT1xEVl5oJEvUnQ7fI6RMXXE2pMWUF0rRmukNkduqBRl9BUWFdEVHncgAvm5ADQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xy0/A+I9tTrow50Mj8C/CsKLIGbuOKHVFfcSnpCbuKM=;
 b=4xzOzsNGaflvbHxlP5JlDSeZRJEK7fR5t8aSx62FQibd1keybFpwObdm8cuVCiqV19xZYIpL6yNk0LPxHxSigFLbT2cVDye1HZ6lGxCVEh8aKe0bITqTHsv0KA1XL96MNdEVhLJoNERfeG6tUh+yNnhRxbgtbaHsw0XtHCOxrJY=
Received: from BL1PR13CA0119.namprd13.prod.outlook.com (2603:10b6:208:2b9::34)
 by DS7PR12MB8202.namprd12.prod.outlook.com (2603:10b6:8:e1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 22:26:44 +0000
Received: from BL6PEPF00020E62.namprd04.prod.outlook.com
 (2603:10b6:208:2b9:cafe::7b) by BL1PR13CA0119.outlook.office365.com
 (2603:10b6:208:2b9::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Mon,
 30 Mar 2026 22:26:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E62.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Mon, 30 Mar 2026 22:26:44 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 30 Mar
 2026 17:26:43 -0500
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
Subject: [PATCH v3 3/6] x86/sev: Add support to perform RMP optimizations asynchronously
Date: Mon, 30 Mar 2026 22:26:33 +0000
Message-ID: <6345df31337125280f91ad8f37843aa865fd85fc.1774755884.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1774755884.git.ashish.kalra@amd.com>
References: <cover.1774755884.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E62:EE_|DS7PR12MB8202:EE_
X-MS-Office365-Filtering-Correlation-Id: 3810a73e-36c8-415e-e094-08de8eab6c98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|36860700016|7416014|376014|1800799024|82310400026|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	1g3WwfZxwEcETutzgMz4MGIe3ze+CCtgD2GjqBdcHl+xEtawzNfZdtBibK/WCuE/FfPkv3uZMsBlVkibntnRVDw9EJbz/binh65Ix5LvG5A4+RQhb5jkaMdzWFDpkwgpQizTOeIiwslRgyM03mI0DcG1ndOZGNXgk81cgW2hE82NDxl+4NhtWouGWBLdA8/8NcBckXuENBZ668ANHYU2fTW1l0Jno37XMnTZiVJBDFgwqCovigT8eFDdp8mZO9Mvow/c8PbaCqLjcP6/v1Uvh3jGpX07wLWMsTRGzHFxp78ts4qVv3MYNh89zmepV8oJkmOb7mMLjNAnoGVfjcekhoYLOXGwz+KQ3+HphEQ94MSyf3ssZXBmPT5icBTXgKFgjK3/A3eOpoks4/+XdR3XOwsDuB14zawgD1sOQb8lVSQiphrmh9uLAmq90f23yGdBV9Mndj6RTmSRTH2U6RJEWup7C3+haBKctmW3CugmRZQ8l3DRV9kgXNxJlRQjen7/6x7FWwjCU9iL/FWbYZ/vOKW98YT8N3H0wz4NKcrb9RPEwFj4MdnlXqIh5pV8tBNNOI2XsVirUrCb8VgsAvcdg2OD8Hzaj3C6BrWMMpLLAUEK612fpROgD4KziMxv/zPtlJWK8aSwfJ+GO/dROt/FNa1jWG2NNa6C+KKe1ekJX7sFHEf9ssthZlWESmNyLb5g/kGEvuUlurGLwOGx2uhc3Uu5UHaCpEj9ZGzTLr62uG6BdMWcKsU0Ll3fAGX1GtdwKVHyuApAsWdRWGORvMvUAS9+pZGrJwwVQI8Zi+KyNpIIUdw8beD4WtaUd2KMey69
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(30052699003)(36860700016)(7416014)(376014)(1800799024)(82310400026)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xiaCOaESp1fz8y7li4IMF/UT28VjB3wzsUj+zMX9Kb8AzkM548zg5cBW1d1fEUne1pHc7+ryMQBe32dhiansSGTWe2H2G6NnQ2zfG4xf9jPzJiHMQbjygbSuctRtacFIwFZktbUoSOz/Lm90NGCWjqrtVkUAlJww3pYVY3nRwKgSPdX/LjMWDZNTNYc9Jxyzx31mLvZorjNquyQ/cgfDLudNkcTLxPWmrSJQMwTCq/p9wZZO8z1/pvuDLYDfvLD0FlUA1amy91Y7D0RQv79zHqVDym0kGWDqTCpT29bMfaEWca51ob5GC/QLzR61kPO60CGs+z6W0fxJeBpX0TjCjTjf/AUGgNlJLPJJe07D0d5YuWx3Z3aqgJyKXtstRcF37bWLF54xu17fQOSXGSVS6JIGEiNZirLdQz6jRlQiXGwel8JsBbXElvuRIDGam+LY
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:26:44.5242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3810a73e-36c8-415e-e094-08de8eab6c98
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8202

From: Ashish Kalra <ashish.kalra@amd.com>

As SEV-SNP is enabled by default on boot when an RMP table is
allocated by BIOS, the hypervisor and non-SNP guests are subject to
RMP write checks to provide integrity of SNP guest memory.

RMPOPT is a new instruction that minimizes the performance overhead of
RMP checks on the hypervisor and on non-SNP guests by allowing RMP
checks to be skipped for 1GB regions of memory that are known not to
contain any SEV-SNP guest memory.

Add support for performing RMP optimizations asynchronously using a
dedicated workqueue, scheduling delayed work to perform RMP
optimizations every 10 seconds.

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
 arch/x86/virt/svm/sev.c | 114 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index dc6a8e102cdc..1644f8a9b2a2 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/iommu.h>
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
+#include <linux/workqueue.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -124,6 +125,19 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+enum rmpopt_function {
+	RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS,
+	RMPOPT_FUNC_REPORT_STATUS
+};
+
+#define RMPOPT_WORK_TIMEOUT	10000
+
+static struct workqueue_struct *rmpopt_wq;
+static struct delayed_work rmpopt_delayed_work;
+
+static cpumask_t primary_threads_cpumask;
+static phys_addr_t rmpopt_pa_start, rmpopt_pa_end;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -477,6 +491,75 @@ static bool __init setup_rmptable(void)
 	return true;
 }
 
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
+static void rmpopt(void *val)
+{
+	u64 rax = ALIGN_DOWN((u64)val, SZ_1G);
+	u64 rcx = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;
+
+	__rmpopt(rax, rcx);
+}
+
+static void rmpopt_work_handler(struct work_struct *work)
+{
+	phys_addr_t pa;
+
+	pr_info("Attempt RMP optimizations on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
+		rmpopt_pa_start, rmpopt_pa_end);
+
+	/*
+	 * RMPOPT optimizations skip RMP checks at 1GB granularity if this
+	 * range of memory does not contain any SNP guest memory. Optimize
+	 * each range on one CPU first, then let other CPUs execute RMPOPT
+	 * in parallel so they can skip most work as the range has already
+	 * been optimized.
+	 */
+
+	cpumask_clear_cpu(smp_processor_id(), &primary_threads_cpumask);
+
+	/* current CPU */
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
+		rmpopt((void *)pa);
+
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
+		on_each_cpu_mask(&primary_threads_cpumask, rmpopt,
+				 (void *)pa, true);
+
+		 /* Give a chance for other threads to run */
+		cond_resched();
+
+	}
+
+	cpumask_set_cpu(smp_processor_id(), &primary_threads_cpumask);
+}
+
+static void rmpopt_all_physmem(bool early)
+{
+	if (!rmpopt_wq)
+		return;
+
+	if (early)
+		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
+				   msecs_to_jiffies(1));
+	else
+		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
+				   msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
+}
+
 static __init void configure_and_enable_rmpopt(void)
 {
 	phys_addr_t pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
@@ -499,6 +582,37 @@ static __init void configure_and_enable_rmpopt(void)
 	 */
 	for_each_online_cpu(cpu)
 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+
+	/*
+	 * Create an RMPOPT-specific workqueue to avoid scheduling
+	 * RMPOPT workitem on the global system workqueue.
+	 */
+	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_UNBOUND, 1);
+	if (!rmpopt_wq)
+		return;
+
+	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
+
+	rmpopt_pa_start = pa_start;
+	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
+
+	/* Limit memory scanning to the first 2 TB of RAM */
+	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
+		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
+
+	/* Only one thread per core needs to issue RMPOPT instruction */
+	for_each_online_cpu(cpu) {
+		if (!topology_is_primary_thread(cpu))
+			continue;
+
+		cpumask_set_cpu(cpu, &primary_threads_cpumask);
+	}
+
+	/*
+	 * Once all per-CPU RMPOPT tables have been configured, enable RMPOPT
+	 * optimizations on all physical memory.
+	 */
+	rmpopt_all_physmem(TRUE);
 }
 
 /*
-- 
2.43.0


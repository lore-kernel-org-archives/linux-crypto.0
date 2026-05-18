Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5AF397E91;
	Mon, 18 May 2026 21:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140598; cv=fail; b=kAayiJdXijkDh8cOd4vHtTZYKjVSTh9BeUbEJhLGhDiR+W7peqIN6zLUNG+eChmgIr6jasB5cdQyy7hvbjD4KaJqg3JeHGT5e9Wrx3TXirF3Gba76GuIVi9qh25XVubfC4YuLSgGYM7Ov8w3WouAdmhcAtqeqfOur+TR/PXnr1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140598; c=relaxed/simple;
	bh=LyYJ0JnWHxYJYMjP9huKlwXs9Xq+3UqNYthnjWFpXuM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jJbXMPQ8ycyKdxvHvR1RgtedKBGNczXJDRCMUZL7kQelKwIZ8ipuiKRyjrQNrMESA5clrSdr9HP7YM9p4OnNGrVUvhTlaJVeecAVYXabyZ54WAsy3OVoaN4w3FXxCeeZAuYFN5UovssSSQOkhmGwbmPccx9xOg7A8hcRdeLuHRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jwC8LIxd; arc=fail smtp.client-ip=40.107.201.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jwC8LIxd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gw5OTXRknCexw2EVIB0HubEvq46qY/ibvLOSeooAyEUK183IhZGfuNFm0VnIGMiYdb8ixyf59Ts8J+aZT6Bkdl+14O0UkpUJWoWVQqVQiDZM1uKsvjge0E5OUSsuHE5et+8qmUHlrkGUDX2InX1Mx2UmpirP8B/OHmyIpgx62/c7kC9uXghV5/NdPW4HntkXpsAQ82GjMR+AILEkB7qemgwaiQBwcO9n7kBVkmCyOkBKhWeEB0ho3Z4X6TVDff1omLY6c2gdiSfJAV7gj+86GNd9dn76hacX3Wt5QP7PMjHakI5uRlcyDl/RkF5sb+6FIMRF1JJvYzQdGQqadSzbQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJxqCEMHYFEQRfe4mfGDAOSJOdTe1FyGoN1kEV0LuOo=;
 b=IS5tcJyvjx5qjfulsIM4H7xm/E/OIAxsrr9bEWtRWl4wbjy8RDweSWtPdjphWNlSm0app4i8aTTQd2VI4Kpbet+hwQkQyy5I0+/yfR+ymzULIzq6Nf1mgA7x44WzGt8an8K4djjZk+WowzsnF33KLD9RbEghLqN3VCdTaDPe2EYSW5tu/752MWEdYDnt+NHkNyqMZP34jt7JG0JUZM+pN99qf7JiR7bmrRdIt1evh94ROuRRtiiDfjZ7JTGoTm/uPDZCzREBy/FxviKC1lndX81u2l4K2UecYJ5xaavXtKYJbO4RvBLF2ivxWBIttLn1HEoOmWHoCv96yGtxcQvYVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJxqCEMHYFEQRfe4mfGDAOSJOdTe1FyGoN1kEV0LuOo=;
 b=jwC8LIxdxVZ9VRE6HzYBq3G9xxNxJmwhYA+5A/n3jjzwzXii+OEx4+0NGao3b5hZQNZzpw6ZknZZdjhlvof7vUDHI27VHWJMO0z9kRfwjoZUsaOf6isEoO4+fmqrvkRnqiSwDYuxtZAMfUao17K/1X1cx+xrkTOQont4m8DchCo=
Received: from CH0P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::12)
 by MW4PR12MB6682.namprd12.prod.outlook.com (2603:10b6:303:1e3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 21:43:07 +0000
Received: from CH2PEPF0000009C.namprd02.prod.outlook.com
 (2603:10b6:610:ef:cafe::b8) by CH0P220CA0010.outlook.office365.com
 (2603:10b6:610:ef::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.23 via Frontend Transport; Mon, 18
 May 2026 21:43:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009C.mail.protection.outlook.com (10.167.244.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 21:43:07 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 18 May
 2026 16:43:05 -0500
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
Subject: [PATCH v5 4/7] x86/sev: Add support to perform RMP optimizations asynchronously
Date: Mon, 18 May 2026 21:42:55 +0000
Message-ID: <6f1ec3d8ebcf3aaceccc099c07d0deb545dd4ab9.1779133590.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779133590.git.ashish.kalra@amd.com>
References: <cover.1779133590.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009C:EE_|MW4PR12MB6682:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d6777c7-46e2-4486-d7f8-08deb52672c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|7416014|376014|82310400026|3023799003|11063799003|22082099003|18002099003|56012099003|921020;
X-Microsoft-Antispam-Message-Info:
	0F5PBwGtrtofngejomI0Iq+1BVBB9f096pd60sjtbdw/nUvR166iSiorU46ss4/KRbIb1eMygxcbLQedWlG/ItsD5J1tVwjlqSOEuYUCbP0J3/9jrY6M6CKFEkiKBFcNDJMfNBGDsWWXO2nZnfWAzs1R3ZOgpQo7cq/jmxKqoVG76vO73IsVCCMkboqZxULxM4LRRummqG7DgYISfBeZWplWqWvyZuUMYfw7npN/H8L1OGthWoUp7hVSUslme54EncfrYgBQ+V2ExsDJ3UGuq4NU+eHdDBhoYtjwqkTVRkvXn+++heiUY1SlJVe+2Q2r1Q2pULoRP+mwTHGB2Rd1wzFCKt9bOOgKBrXp6fxeuPGCx0MTQe6pDF33VSv69pCbx2cIWCia5AefPRbfGpSGTR7cCAwHX7y8uSU9JZU8kejNgeFFIR6+8L8+mOtj9jUz52AQHPI6h2bPgqRkTQ/iflszjX2kXqphG5NOPLeJ6vOR0EveiYVAUrqyWiHNGOTsQHCWqjyNrOoxE6IbvCLs/RrW+OpLasZndex0rAhUD8tMO/dE42G1unglK2+ZbWnFkmfqXsVD6aYPagtKWeE9fixsbo8M0jEpbVFkSHJ8LJ18UnstXXGITNHY2hXWdyrHYz4m3pqybzrXI03AZqjuYs39cyc/xg8/Ue/yip5yFCtRqSKyCxYp+60jsn09vM4/0XsuKOjPlkViz7zzrsYaqPPu1EvsDle2I/DKaAlC3sqlukEL0MYEcZiP35p9bpLXrYiEh0PdBcTQzoBFLUhVKg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(7416014)(376014)(82310400026)(3023799003)(11063799003)(22082099003)(18002099003)(56012099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rQATZqbkzdJKEh/BVEP00w7m61Lw3aHat/I6k8G/iGVu2KFI8OZilwpVBRO9KzdSx9YowIRIy5KcfQN13RGX+dMn2Ktwm6OjJgo2f7pU8PTi5LKIJj9qgFObpFlPb5Rz1IRkHof6TtsX6dQHxZ5V3MTdcD0c8YwMarbt7fl3GcnwDwMPKdGY9MjsYtpY/SUSgCaW9r+D1xsxuR1x1HG4vDP/YZPCF7+de2vpB3WH8MsDp1RSZdGTCHUINM7X1ZJ1kLjqjUPWp6sP2eOVXINaCKIFScA8b8W+3dGqhc+b8J/BFko1T89ieslhWFOqdZ1RbpfvWi9yU9X5CsSKqJfqdY8e3TPOTWHVgWQB00iQmwp9nGheilXzU5d9LZEADXlJoYm5ddT9gdq8NCStyR8WFM59iuD6A/4HcEq1GckUGcrG3cAp5vTdq7FBc6xKKP43
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 21:43:07.1318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6777c7-46e2-4486-d7f8-08deb52672c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6682

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
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 167 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 164 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 82f9dc7a57c3..8876cac052d5 100644
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
@@ -564,12 +576,21 @@ EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
 static void rmpopt_cleanup(void)
 {
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	if (!rmpopt_wq)
+		return;
+
+	cancel_delayed_work_sync(&rmpopt_delayed_work);
+	destroy_workqueue(rmpopt_wq);
+
 	cpus_read_lock();
 	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, 0);
 	cpus_read_unlock();
 
 	cpumask_clear(&rmpopt_cpumask);
-	rmpopt_pa_start = 0;
+	rmpopt_pa_start = rmpopt_pa_end = 0;
+	rmpopt_wq = NULL;
 }
 
 void snp_shutdown(void)
@@ -587,6 +608,105 @@ void snp_shutdown(void)
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
+static void rmpopt(u64 pa)
+{
+	u64 rax = ALIGN_DOWN(pa, SZ_1G);
+	u64 rcx = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;
+
+	__rmpopt(rax, rcx);
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
+	bool current_cpu_cleared = false;
+	phys_addr_t pa;
+	int this_cpu;
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
+	/*
+	 * Pin the worker to the current CPU for the leader loop so that
+	 * this_cpu remains valid and the RMPOPT instruction executes on
+	 * the CPU that was cleared from the cpumask.  The workqueue is
+	 * WQ_UNBOUND, so without pinning, the scheduler could migrate
+	 * the worker between the cpumask manipulation and the leader
+	 * loop, causing the leader to run on a different CPU while
+	 * this_cpu's core is skipped entirely.
+	 *
+	 * Use migrate_disable() rather than get_cpu() to prevent
+	 * migration while still allowing preemption.
+	 *
+	 * Note: rmpopt_cpumask is modified here without holding
+	 * rmpopt_wq_mutex.  This is safe because the delayed_work
+	 * mechanism guarantees single-threaded execution of this
+	 * handler, and rmpopt_cleanup() calls cancel_delayed_work_sync()
+	 * to ensure handler completion before tearing down the cpumask.
+	 */
+	migrate_disable();
+	this_cpu = smp_processor_id();
+	if (cpumask_test_cpu(this_cpu, &rmpopt_cpumask)) {
+		cpumask_clear_cpu(this_cpu, &rmpopt_cpumask);
+		current_cpu_cleared = true;
+	}
+
+	/* Leader: prime the RMPOPT cache on this CPU */
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
+		rmpopt(pa);
+
+	migrate_enable();
+
+	/* Followers: run RMPOPT on all other cores */
+	cpus_read_lock();
+	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
+		on_each_cpu_mask(&rmpopt_cpumask, rmpopt_smp,
+				 (void *)pa, true);
+
+		 /* Give a chance for other threads to run */
+		cond_resched();
+	}
+	cpus_read_unlock();
+
+	if (current_cpu_cleared)
+		cpumask_set_cpu(this_cpu, &rmpopt_cpumask);
+}
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
@@ -595,11 +715,35 @@ void snp_setup_rmpopt(void)
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
@@ -622,6 +766,23 @@ void snp_setup_rmpopt(void)
 	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
 
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


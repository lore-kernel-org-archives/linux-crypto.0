Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012039.outbound.protection.outlook.com [52.101.43.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0570240A94A;
	Wed,  2 Sep 2026 21:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788384582; cv=fail; b=kvpTuygl2RwuVxtDsa7HHhstgN3MSwRb2+IfT67/7iAYqMHRYf0neNw0JNVJfVYOeS5ZvZornEUOjyaq1SV78pa034M68dcDkm4HQUGrkNU4hwCJr5wvS2RLR/HYZHP05zAe5rWFkNtlp1o5gXet5JsG0o7aL/fNbYHPg7UjhV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788384582; c=relaxed/simple;
	bh=CaDyHF/evx36vTyk6acsQ8g6AB+8GBWBJ7NF6QswM7Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DFAsF188tdbCo1Z/YPALYXQzqNPI7AKb3X9Lxud7zUH9125P/YivGsjRzNOvjqtXuQf/P3CfhF8Jba0q8X6tvMivfNgyVcVQIkhqdIOp5gRfP9yaWXqzweqi0IV5/F2DPa+r5suYRhw5/uyihL+MvA3HMOh+rtoSjI7qhxsAiGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DqYWJCz6; arc=fail smtp.client-ip=52.101.43.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DqYWJCz6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sp8T8H8Bh9F/N8f0CFQP0RTAZBpw3ehFIHBBhed5KaRh3Kxxc7efmB8oXyt61zQu/z66B65H6VZVZbUwc2E+OxDgyZVg8kHrrAehuXi548kAqMCw1YPr5HfxosB0PSFpaumQkd/PD89Lwr2xzbQMN2LdPm8T5XA+fMCcarxK2xWjmLJUmkrCdpQtflFBuKyoTfDypfkiDWdQh36uAz9ZYr4Mf3ETt49hGOCyKfFs0uNWioByS2ym8gEfUw8PnlaXOibnABRGdKgkWDgLsZiIYRmRsYCT5NFo5R+rqv9B0dT3hPeD7DxJK6aRqqCyx618Di360+xRvVpua13fpCZEWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=baPB6lxkVkel2ejUfVAFQrSuAnViItJWa6L/EtZq9+k=;
 b=Q56EIcJInmSKmXLErrQLMZ5w8En2JbNKDYitdFPx8IiR0CKmQhYouiHKaNMiSs4WQTLXWmxE5zCiGIfsnV+ed0W/9dDzewAMzdafIgMB6ka0n5d+54DvVKQJMXPo5JHeMnZop5Zo/KzajynUHtVBJf/ORp49vqdwgxPw+pEWW+xDuD1RUwXbk1YX4B9H93oqkep/wA7XzreJ9rbBRGKF03Rie/AHuQClVsNJKZvpQDcv3AmqSZldX319qL76rzocgP2eq/DLLZIvMQt7t87U1Rn2Ne5MeIIS6PxYpYRUWa8YTcU6KFPWXhlGobijCiyl/NnXAB2eKKtjU3AjjjjZ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=baPB6lxkVkel2ejUfVAFQrSuAnViItJWa6L/EtZq9+k=;
 b=DqYWJCz6twnOJRVbpEjwB1FgMI5uKaQRA19WLssFfVDnOjLNqTd7JMY3VaZT9ijL5fM1NuVB7go2gsy/w/QiqMq/dNqbBv2isK0VPUqLL8qzV//wIrUsLxz00lBiTLXBFS0kNIv1QyYIigycTBBxgYYt1qm8sHfQ2Y1/evUFH1s=
Received: from SA1P222CA0108.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::29)
 by PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Wed, 2 Sep
 2026 21:29:22 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:806:3c5:cafe::67) by SA1P222CA0108.outlook.office365.com
 (2603:10b6:806:3c5::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 21:29:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 21:29:16 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 16:29:12 -0500
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
Subject: [PATCH v13 4/5] x86/sev: Add support to perform RMP optimizations asynchronously
Date: Wed, 2 Sep 2026 21:28:57 +0000
Message-ID: <a31fc8c6d3f6c6bbe50dc4542c7091b0899d3e1b.1788296083.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788296083.git.ashish.kalra@amd.com>
References: <cover.1788296083.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|PH7PR12MB8178:EE_
X-MS-Office365-Filtering-Correlation-Id: 14f54595-c17c-4dba-fd65-08df09393dc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|82310400026|7416014|1800799024|22082099003|56012099006|11063799006|3023799007|18002099003|5023799004|10067099003|6133799003|921020;
X-Microsoft-Antispam-Message-Info:
	SrTZkf8onegucOasdGgGeRaa75DSq1UeqmeVMv0JbXpSaSfZT3KgZzkg82DgI7155CnN0zrZYkJf+pNvctRljdPq9P2O9amXS4wpKTEX6sQr+Kk+Flvw/K9rPwkXfd04o8HgAwliHuo8G5pLxU/f/MdVB0Vq3vavXqaBsy0kncDvmbZCMurN5lo2Jm3t82+BXOXtG0S4PsXcLPbCv7pR/XgHYbDGbY8rGGuZga3CWzNHeFYAojgNirqn1yMHEqvZz9Z5PE8Di3EWTKZLvdMmIAjZeiXKV+wAOhxGmQgv3q+Xb0jOeJMh117qrOQnv1RpZ0FVss35axN34JvDkFxQTVOSYMvu/PZn916ht6YoAPHFGszrNckd6yFaXgxfP4DWPmcH4dm2TNQ3x32W4SLLpWWe3yLbA1ODKPqhu1HxEiadOZxOpJYMFrlm5YibTiZl278MC9IY6BprU+3Pzl088ZRrFNN5TJno7AgcEqxSM5gRr9zWBL/u6qQuNIJvq1xJjU1RFTagfRRge+z5GlCU4RpOK4rZMQQ3hqctPUZbqvONaZgUmeS2ldOv4GfmyvaAhOvGU9dIxGRXKSN/+1M5lu2cog0b9zpLG+dM4zqXeVD1/DYDjJL2TXeX/0NEZX+QpeCVoZKvDmacDMMtVGgNwildZjgz+Y9PyvPEthkUhUOpU59WIpYLbbWv72aUlp9vcmtKWjdInofEovZw4UHZieLc1A6ZkD3LIvPM6J9U2U/8uye5tvMG3KW5RL0X5du3
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(82310400026)(7416014)(1800799024)(22082099003)(56012099006)(11063799006)(3023799007)(18002099003)(5023799004)(10067099003)(6133799003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QOfa3HyABrM/iSULJFUWk7yIyoj1+XbSFO69TwybgTAcylE5idvwG1DyWDfwFdOq7BIt5EVmmMXMX3tYHtohJHlqPvuA+gIoWhm6D10zckeSznQDC0pxEntTMKZPLgJcqJ+F0WTQE0gJDIF8xJfwdqYYh51V1mkdMHob2+Dp0LPlw7M4ZxCeP8dl6Ilg0mOtv0eAngfZ6EFAg667yJ1IuouLcaBTSS1/WoW5q4ENJh2Zbg6ivKCHMd5L5fDq12M3JK0YbwkqrXLdsgCfUDTPU6ctTOah9ZfFCRIvteG6zV5EvySbsR1+/9bH4cQyf2SSMw5B+9azU0zJ2l50ee9RJkUzrjDgl4yoUWRtloGlk1wIJBZGDBnc6Wdaw4OxxzkV9KiQLSEg6XWSlx14oI1ZKg0YfPeStNzq58sOfY0kvzXog6EH1lUYX0P9yV9F6M5U
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 21:29:16.3110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f54595-c17c-4dba-fd65-08df09393dc1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8178

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
Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 113 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 07f178eb76c7..a4c0fe49b9ec 100644
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
@@ -561,10 +571,26 @@ static void rmpopt_disable(void)
 {
 	int cpu;
 
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	/*
+	 * rmpopt_wq is non-NULL only after RMPOPT has been fully set up: the
+	 * workqueue is allocated and the RMPOPT_BASE MSRs are programmed.
+	 * snp_setup_rmpopt() resets it to NULL if any of those steps fail, so a
+	 * NULL rmpopt_wq means nothing was set up and there is nothing to tear
+	 * down.
+	 */
+	if (!rmpopt_wq)
+		return;
+
+	cancel_delayed_work_sync(&rmpopt_delayed_work);
+	destroy_workqueue(rmpopt_wq);
+
 	for_each_cpu(cpu, cpu_primary_thread_mask)
 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
 
-	rmpopt_pa_start = 0;
+	rmpopt_pa_start = rmpopt_pa_end = 0;
+	rmpopt_wq = NULL;
 }
 
 void snp_shutdown(void)
@@ -595,6 +621,44 @@ static bool rmpopt_capable(void)
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
+	 * RMPOPT caches the results of a RMP table scan in reserved processor
+	 * memory, allowing future invocations to skip such costly operations.
+	 */
+	migrate_disable();
+	rmpopt_scan_range(NULL);
+	migrate_enable();
+
+	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);
+}
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
@@ -603,6 +667,34 @@ void snp_setup_rmpopt(void)
 	if (!rmpopt_capable())
 		return;
 
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	/*
+	 * On re-initialization after a legacy SNP shutdown (SNP_SHUTDOWN_EX
+	 * with x86_snp_shutdown=0), snp_shutdown() and thus rmpopt_disable() are
+	 * skipped, so the workqueue, delayed work and per-CPU RMPOPT_BASE MSRs
+	 * are still set up and valid (SnpEn stayed set and CPU hotplug stayed
+	 * disabled).  Rather than re-doing the setup, which would leak the
+	 * existing state, just re-queue the optimization pass to re-optimize any
+	 * memory the previous SNP session de-optimized.
+	 */
+	if (rmpopt_wq) {
+		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
+		return;
+	}
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
+	INIT_DELAYED_WORK(&rmpopt_delayed_work, do_rmpopt_work);
+
 	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
 	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
 
@@ -612,6 +704,23 @@ void snp_setup_rmpopt(void)
 	 */
 	for_each_cpu(cpu, cpu_primary_thread_mask)
 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
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
+
+	pr_info("RMPOPT optimizations enabled\n");
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
 
-- 
2.43.0


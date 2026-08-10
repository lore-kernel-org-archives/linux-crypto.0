Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013054.outbound.protection.outlook.com [40.93.201.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942A343FD18;
	Mon, 10 Aug 2026 19:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786389766; cv=fail; b=VdQ2LGzW+oK7sle1Ds2YOmrrqgh08o0+HUqKPiVMt0LT0CDsXs/xrcFaX3yMJ7wdhlToMcY+HpOrgrygTqMVZIgCHEIJBC/VcCykXpwKTAEFBhxM22tWnVczjGwNKU4BbwkjpE+uXeoUAtwpotxQGL0KbWlKSEObVuim9W5ZsZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786389766; c=relaxed/simple;
	bh=y1wY5ohONIR7waG6vlY4dWszfChZAqCWOXSA8WhZC4U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2EDuqzQpBj0BXSAKbMm4ek8oUDy6LL0AgKS5vfoTfaC4zq5zuam1Dfc0IxrgkWDmOV+/TQ4CszHeKfz/5x7Gmv2fCEl1kUhUnNle+3AYXxGbdY8fAA9UXtdeSzqaESPEkcSZUCzWWluItasJrPHoDoiqwS7pUFeUSj/wQcppho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VFuCfUDk; arc=fail smtp.client-ip=40.93.201.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VFuCfUDk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pWajRPlRk4rbT3yGLV5xE7EnhcLMiX5oqnPMOqc5FXd0+WzmigCZ5xxCIvsDZcNZyPA7xAO/3k0BaRxX039Wcqqc2cVnC+fOOqPgbabr65UTBGXRPmHdzNwIBF+tcgwFvQ8/B5Ft5pjABafXJPtvaXIJOsqp5Jc1M73WIvyFxvEXqx1TTjJpx1E0bZ+KdFTfuq0cwYqpEzgQ0tYxBcl89LIoEuIPjgqrVfPy/lE3z6KAiBMTmCZgElDBPIz7i75tbaUn4P/vAHVCIwD/xPPrzsXQR1D4izlr0xddEEbcGdIU5sq5FwDmOi+oGveQA9xXIfZUhFkFJcu/J1Rb43P6GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BaL/FQkpwnouc3xiVR36RwGvWt6mCPBk3yl97bKctnc=;
 b=ebeA3Bd0HhbMRwPm/8FLpFT8OHCiVlYW2Rsolv/YK6yODZlXp+hEBr35iwXY1iQAManchuDBAnpNKvKC/Tp5lrbg6iJYLVIdGxVr21S9xVZi+pdtrkAuICChvPgmfwTMr8PwI9MsgJxla5hUysjBvvY1ilbgtJH+B9BnCS5vqyDMtCuQn3qPCQIzi1KD54uEvwZAUW5550cS/FSeMNpFrfFkmnyYNndInDgz2TLFrLJlZzXntAguehn19Wk8uTaCeXOqRCIKyPU1mwpEMs7y+VqkYfub+r6TfqZYpIFtH1BvbcRexl2kMq0v/3qaxsNbnyqnlmUBYn+vBeo+FJXN9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaL/FQkpwnouc3xiVR36RwGvWt6mCPBk3yl97bKctnc=;
 b=VFuCfUDkjgxLn3qf+6VTh+rI5eP7HPTJV7OmfLZuYB+qj8063kuwFgYYgWhRRcaqQDOGujlFynyYWyJfetJ6tAUbq57XNQ/mYwU/Nv72xJmBA4eFX5A6WXSgt5JYSce1fJgzuYA0GoBrzRPpMyNkj4RkXzQlvlS0+BGZ60VfbwE=
Received: from DS1P220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:44c::10) by
 PH7PR12MB6881.namprd12.prod.outlook.com (2603:10b6:510:1b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 19:22:28 +0000
Received: from DS1PEPF0001709D.namprd05.prod.outlook.com
 (2603:10b6:8:44c:cafe::93) by DS1P220CA0017.outlook.office365.com
 (2603:10b6:8:44c::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 19:22:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF0001709D.mail.protection.outlook.com (10.167.18.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 19:22:27 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 14:22:26 -0500
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
Subject: [PATCH v12 4/5] x86/sev: Add support to perform RMP optimizations asynchronously
Date: Mon, 10 Aug 2026 19:22:10 +0000
Message-ID: <9c9502278f68af9da19f0dd583ba303d0e6d66d2.1786389115.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786389115.git.ashish.kalra@amd.com>
References: <cover.1786389115.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709D:EE_|PH7PR12MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: f5a3ea00-575a-4ca5-32b8-08def714b74d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|36860700016|82310400026|1800799024|6133799003|921020|10067099003|56012099006|5023799004|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	EYdhKK3xruS1RZqHtlbLe3IDMpPj5rIT/sH6chELMqlI2IibCf2vpwZzvRsdRi/ySVWQPjrqPwdc59Y2RA8TMjazaN4uXVolW+WuxpJaVqWXukQGgzUoX4DX+SGDF29OMmcce9/4PC0JiJNQVqGqntLF7j5rW3vLkzKD0ahl4BDoMrLxjRSBzetEtx+4YMe8AF/pmhEpggBqCbzyHADP019bqpryD74ke6JeC4D1fi3bTWE4y0Lq/2h8soVMe82OlxC05jEIWApk7K0uI5ANkSbOxGg3JJ/VmWTpFAQMpLKFstUIhkjgDFp9r0/A+t6gjRtnF/VqC5KUvnUsspdBkaMsCsPAiEs3FM46NsKZQn5NyMyXahuxBy8ZV4Yq1fESDQtWVl178lpiHf8bJQPXSdRly4gxuAi8TjwACIhUDTn8ILVZVVdNIGtc0QHXLfj+KZanRIEupzSmPfvUTekBSoHjgkZ3BL8aijZh4iZnNp7apaO9Q6tn3ZR26DmzJbTYVQVexBLYd2+fTGX4sfxM4x8XVikJXh0I5IT+iI9rQQWDezdLzRxjk82o+wHt0DCQuxC8fOZvKxDQwUcqsQRrj4chtXYujzGCyLeJecqApDT0CHt2FKNBGQnskehjB5oT3fow8WPzrfRmtUe0kp0MMs37rZk/66T9J9J21GG9YSLk0YU32KZQ3RqjkSk20ZWQ0eOeVG84+XnvfIZmLQyYvcNw3CE5Dcjns4kpoSYdgash3NvPDI8Oi89cAeQeYMut
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(36860700016)(82310400026)(1800799024)(6133799003)(921020)(10067099003)(56012099006)(5023799004)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	A4tdqydfeCn5n1dPNrWY1iXzcMNNv5J+OkfSZQ0EoZddzVx0al9C4WXgKQkau/W7ytOTsR5vEz5kt87veAyZ7M3HeW+mcVUqNX350aVDhHWos5eC4Ezbyq0zCmg7AQ3CWgZakWAWipNG0JQOC7HDLGihKvn7XEZfWKpxlEC86WErdLDqM8t2vpTU5V0jFRgFe6/yMPs0ahJ6RJkZekhPqf/BES7KbEROCKkoIGUvb9mOJnK0HNHwulajQ3Kigzf3Ah3Ak34lu2+BU0BRYTpg/p20gZSRwbteJ02LbvjkI/8Gnx1r39pCoFlMmfMPoj7p4S163ADjJntT8udyei7crGt6C1djisEvjVBYkyCzVcgwcYC1RPeaGBQd028U+WLzk0ToUJbKlg0x09elOCd8hmMLfEnaVHi4z9N5y5HtiUoo94L6+yD3V8usMlsE8IUI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 19:22:27.9092
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a3ea00-575a-4ca5-32b8-08def714b74d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6881

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
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 159 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 156 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 923b7869acd1..b53a12baf4a3 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/iommu.h>
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
+#include <linux/workqueue.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -124,8 +125,17 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
-static cpumask_var_t rmpopt_cpumask;
-static phys_addr_t rmpopt_pa_start;
+static cpumask_var_t rmpopt_cpumask, rmpopt_follower_mask;
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
@@ -562,11 +572,28 @@ static void snp_cleanup_rmpopt(void)
 {
 	int cpu;
 
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	/*
+	 * rmpopt_wq is non-NULL only after RMPOPT has been fully set up: the
+	 * workqueue and cpumasks are allocated and the RMPOPT_BASE MSRs are
+	 * programmed.  snp_setup_rmpopt() resets it to NULL if any of those
+	 * steps fail, so a NULL rmpopt_wq means nothing was set up and there is
+	 * nothing to tear down.
+	 */
+	if (!rmpopt_wq)
+		return;
+
+	cancel_delayed_work_sync(&rmpopt_delayed_work);
+	destroy_workqueue(rmpopt_wq);
+
 	for_each_cpu(cpu, rmpopt_cpumask)
 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
 
 	free_cpumask_var(rmpopt_cpumask);
-	rmpopt_pa_start = 0;
+	free_cpumask_var(rmpopt_follower_mask);
+	rmpopt_pa_start = rmpopt_pa_end = 0;
+	rmpopt_wq = NULL;
 }
 
 void snp_shutdown(void)
@@ -598,6 +625,77 @@ static bool rmpopt_capable(void)
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
+	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
+	enum rmpopt_op_type op = RMPOPT_OP_VERIFY_AND_REPORT_STATUS;
+
+	/*
+	 * RMPOPT (F2 0F 01 FC): RAX = 1GB-aligned SPA, RCX = op type, CF set if
+	 * the range was optimized (result unused on this path).
+	 *
+	 * Binutils does not support the RMPOPT mnemonic yet, so the instruction
+	 * is encoded with .byte.
+	 */
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
+static void rmpopt_work_handler(struct work_struct *work)
+{
+	int this_cpu;
+
+	/*
+	 * RMPOPT scans the RMP table, stores the result of the scan in the
+	 * reserved processor memory. The RMP scan is the most expensive
+	 * part. If a second RMPOPT occurs, it can skip the expensive scan
+	 * if they can see a cached result in the reserved processor memory.
+	 *
+	 * Run RMPOPT on one CPU first (the leader), then on every other primary
+	 * thread (the followers).  A follower skips the expensive RMP scan by
+	 * reusing the cached scan results the leader produced.
+	 *
+	 * migrate_disable() pins this work to the current CPU so it stays the
+	 * leader for the whole leader loop: this_cpu remains valid and the
+	 * RMPOPT instruction runs on it.
+	 */
+	migrate_disable();
+	this_cpu = smp_processor_id();
+
+	cpumask_andnot(rmpopt_follower_mask, rmpopt_cpumask,
+		       topology_sibling_cpumask(this_cpu));
+
+	rmpopt_scan_range(NULL);
+
+	migrate_enable();
+
+	/*
+	 * Followers: one IPI per remaining core, each optimizing the whole
+	 * range.  Each runs with interrupts disabled, but only issues cache-hit
+	 * RMPOPTs (the leader populated the scan cache above), so the window is
+	 * short.  cpus_read_lock() is intentionally not held: CPU hotplug is
+	 * disabled the entire time SNP is active (see snp_prepare()), and this
+	 * work only runs while SNP is active, so the follower set stays valid.
+	 */
+	on_each_cpu_mask(rmpopt_follower_mask, rmpopt_scan_range, NULL, true);
+}
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
@@ -606,8 +704,46 @@ void snp_setup_rmpopt(void)
 	if (!rmpopt_capable())
 		return;
 
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	/*
+	 * On re-initialization after a legacy SNP shutdown (SNP_SHUTDOWN_EX
+	 * with x86_snp_shutdown=0), snp_shutdown() and thus snp_cleanup_rmpopt()
+	 * are skipped, so the workqueue, delayed work, cpumask and per-CPU
+	 * RMPOPT_BASE MSRs are still set up and valid (SnpEn stayed set and
+	 * CPU hotplug stayed disabled).  Rather than re-doing the setup, which
+	 * would leak the existing state, just re-queue the optimization pass
+	 * to re-optimize any memory the previous SNP session de-optimized.
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
+	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
+
 	if (!zalloc_cpumask_var(&rmpopt_cpumask, GFP_KERNEL)) {
 		pr_err("Failed to allocate RMPOPT cpumask\n");
+		destroy_workqueue(rmpopt_wq);
+		rmpopt_wq = NULL;
+		return;
+	}
+
+	if (!zalloc_cpumask_var(&rmpopt_follower_mask, GFP_KERNEL)) {
+		pr_err("Failed to allocate RMPOPT follower cpumask\n");
+		free_cpumask_var(rmpopt_cpumask);
+		destroy_workqueue(rmpopt_wq);
+		rmpopt_wq = NULL;
 		return;
 	}
 
@@ -629,6 +765,23 @@ void snp_setup_rmpopt(void)
 	 */
 	for_each_cpu(cpu, rmpopt_cpumask)
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


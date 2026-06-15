Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010049.outbound.protection.outlook.com [52.101.46.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5233B583B;
	Mon, 15 Jun 2026 19:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781553078; cv=fail; b=riLgKk8U6VMrvEf03foW1iGAks+dykB1Iokt6ZjVy3dFst+eB45l4/DnU1Nds9zddPkBHQkZ0BlZcfkn4t3xD3fBgT1BcHBXzgQXkTzGI8iAh2LqLIEkDukC8cIOvBDfumyWtN+a36gvIYIYuzCjAF6zPZ/fHRnGIg89S6DaTbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781553078; c=relaxed/simple;
	bh=KX4F+U/VbIyYjkexPQ0BcpgqKxX21sfp79z5Lhvz+M0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSiaWvKclQ5O/UP6r/0d7IUjXLMcwn4UWm+EmvJ31ZTkfwZX1pGUt+PJO9p8/c8CfYVx8/Y5gGaUWtRYCr5cPPVsZysJsMI71rfH61jBWzV4Agi+QCUQ1WKtX0A4hiGW5Ys+hRSo36BPofFHUq1NmxcNLCfOxDu39Lz4wloFtks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yEAk3N2H; arc=fail smtp.client-ip=52.101.46.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yEAk3N2H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+rhnaOBugX1UijyMUNKiKY6oHNaFyTEGyKtuVuok7Zyh81FLflvq/yLuMrDdSJo8tHroxKCK7uO/TkXgS19mFqSmAyenLS3gNa29q/dOEoWkM9n/F+/Q8PXPdXnhQNhtftPUq1fh+fORBEuOukjK6EqEyAPzVrKlrAHnz9oMY/bC+IEa5dHX4VjgbkSy+MTEYgilHMdxEr7Gh4hR0vm7Hetgzh0GSez+/ItsKwezNpWg7f1Xt0a5hV8ceEv2SrJI/027pocy97ArJvzAppS/nfTsqbPeI5Ei0//Q2SDr/U1AsTm6KyxlrjiOKRny72naFA/Vyb+8h+v7GLUhroVAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4AW0i1BVnsV6k6FvCGDuLnbVfd1jr4U7CDh+ralgEq8=;
 b=Ve7W8BAt1+cLlM2xiqtUVUwLbK3m5LhWuNPWBXtrfGqvMOXXjiyYTz8ESKH4pGX65zNpIocEIvsxu5CNS7H5itGlsVYGTzhEcbtPjW3puyT3kA/TpB6qMxs3mp35m9lZg+lSoe3SKvYeNW/nPVVykF8xJVovGahA4KoGyxzu9YQg2iYQMhcPqLHzLZ74KbDksMhcb0N3SlVy7RiGPGMUA+IkPajO+V+pYs1ckYe1uvzwUOsBpc7z/nyOUN0X5vBtkv4Klb29gbbHhXRwRhjCDZ8GlTVn5qzExTwfyX09ZOQyea9sa3HuEU7rjz93bx8kfNBzClN59ea+KotUK6ALyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AW0i1BVnsV6k6FvCGDuLnbVfd1jr4U7CDh+ralgEq8=;
 b=yEAk3N2H08qyBcDlp1OBjpJHzHfjJPc/iX6qVmyAHuRJBNY1lWno7y9fy87Ab18uk60b0Sq39rFq0NlqFTW0cNVFLWLh5LNj5VZx/ltepyiWPJsaNfy9LbA44EvT3DOAKfFbfKLnUWy0r3a8mIFBS6HvaHigKZTsRWcOJtxGRYo=
Received: from BL0PR05CA0020.namprd05.prod.outlook.com (2603:10b6:208:91::30)
 by IA1PR12MB9064.namprd12.prod.outlook.com (2603:10b6:208:3a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 19:51:07 +0000
Received: from BL6PEPF00020E60.namprd04.prod.outlook.com
 (2603:10b6:208:91:cafe::a0) by BL0PR05CA0020.outlook.office365.com
 (2603:10b6:208:91::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.11 via Frontend Transport; Mon,
 15 Jun 2026 19:51:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E60.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Mon, 15 Jun 2026 19:51:07 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 15 Jun
 2026 14:51:05 -0500
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
Subject: [PATCH v8 7/7] x86/sev: Add debugfs support for RMPOPT
Date: Mon, 15 Jun 2026 19:50:56 +0000
Message-ID: <cc9aa9b6cfa2ce826f2ad53f8a13d3b7bf0790b6.1781419998.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E60:EE_|IA1PR12MB9064:EE_
X-MS-Office365-Filtering-Correlation-Id: 51e6a910-0578-4fa3-f6b0-08decb177108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|23010399003|376014|7416014|36860700016|18002099003|22082099003|921020|6133799003|11063799006|3023799007|56012099006;
X-Microsoft-Antispam-Message-Info:
	lvIN8MudfZXQ03CHIqVhLP5MHD27kDRx6xMnuA9YCgbPRcdinu4ysUQIl3OU/DyZQAkp4+kqHclVAsPN4Jd+8mEgDUrx/dOSw2DdUaS5Q7kASgDMLaRz7dFN/a0dCkLIYFIE/LEpySSQxKi4/FH1nFU+yAzPBJZ8VfCbEXw2TOTM3xCru4A5EVM7Zxr5wDuLC1R3kJjiTz2zKrSOQXODTSdS7xuI9cbgCU62bAb5ZR8OY/3Hx2ppCjTyi1bMoBNTjtbNmZ/Kl6r7oueBxFRMRkCWZMTtu3IZgydHG41QDObbDsD71unovzTSAj5qTAwDXs2uNZrFcFN1S6mOWYtkPxuDUxWVyOjTIyPK4vHv3sjkY14voDSOPksDPAXWYrkYbOXXu9uiyMfNqOq/UAnqKN/5MnqJP0q3JnnPzW5oG0lK8hrTcQwe/PbRmq3ui8uIicADrPcldO/50ghLckjupUHJfx5NKGgKcrPn8sKjxfslOWh6TM5nqplmyvJDx3rJSOajYuJxyRjQ16ScNkPrzN2TYUMcG9MnMykU24fOatQJ1LpR2gNeDnRT1adFoy6nWoPSvXH80E5zCj5F8135NlUkFH0cZ+2n5ZejiGR88pIrpytBPG/cJkSooRADihJvCHTOPtv53TXm3aXqqvBk/i7nZUyzFpHtnQ2pNXEFTMmDW95FzdLMNeRvBZqvan9ZGwoTJvht5p0gJVaQpRpTeNUl1rpvzOlUXvXBRG93lzehpZu20H8hd/IIzbidq69wn82FdcAM4AjAuncBoGIY7Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(23010399003)(376014)(7416014)(36860700016)(18002099003)(22082099003)(921020)(6133799003)(11063799006)(3023799007)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	O3yaRFGPaRwrs2iPo7jrckMK31DU2ZicOsVLgYSAWe5fd7VPnwUibKR5CxWvu2h2/Xj6HjyDpxwmb7j76UY+mJEWg/eZXVCzGutq1/ZrRbZv8zMPckM5epCIYXV18jjKJ2Y0/2gzQ+jiEVgWExsblNvvFj9Ax46arXU7+9p98wBu74x+fMRoOHTjapwt/AcQGghtsjd9ERTs9M2y/N0qQL3Ga1gWGDjXhtwC+PyeqXPCRidrPwujE6wV4TesbtjdzyC0DlCoMxlU1mDqATrZMvyiF6GxkR9obRHZEDuUuu6vnrFub27JsPjtuM137BLVeTtkT6Ot4kGDAg8ya8q79RgaMqrlKgOqddL7lQR89X+LcczJ2wBaFlIZYDWoaHEf4VKkyKa3X9fmPl06SqotixOUEvQRdQ4mhB9VNXI7J/xGlGedHatAjz4Segc94g52
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 19:51:07.3842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e6a910-0578-4fa3-f6b0-08decb177108
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E60.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9064

From: Ashish Kalra <ashish.kalra@amd.com>

Add a debugfs interface to report per-CPU RMPOPT status across all
system RAM.

To dump the per-CPU RMPOPT status for all system RAM:

/sys/kernel/debug/rmpopt# cat rmpopt-table

Memory @  0GB: CPU(s): none
Memory @  1GB: CPU(s): none
Memory @  2GB: CPU(s): 0-1023
Memory @  3GB: CPU(s): 0-1023
Memory @  4GB: CPU(s): none
Memory @  5GB: CPU(s): 0-1023
Memory @  6GB: CPU(s): 0-1023
Memory @  7GB: CPU(s): 0-1023
...
Memory @1025GB: CPU(s): 0-1023
Memory @1026GB: CPU(s): 0-1023
Memory @1027GB: CPU(s): 0-1023
Memory @1028GB: CPU(s): 0-1023
Memory @1029GB: CPU(s): 0-1023
Memory @1030GB: CPU(s): 0-1023
Memory @1031GB: CPU(s): 0-1023
Memory @1032GB: CPU(s): 0-1023
Memory @1033GB: CPU(s): 0-1023
Memory @1034GB: CPU(s): 0-1023
Memory @1035GB: CPU(s): 0-1023
Memory @1036GB: CPU(s): 0-1023
Memory @1037GB: CPU(s): 0-1023
Memory @1038GB: CPU(s): none

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 128 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 253a534b9a0d..b8b00c50ce41 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -20,6 +20,8 @@
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
 #include <linux/workqueue.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -145,6 +147,15 @@ static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
 static unsigned long snp_nr_leaked_pages;
 
+/* All users of rmpopt_report_cpumask must hold rmpopt_show_mutex. */
+static cpumask_t rmpopt_report_cpumask;
+static struct dentry *rmpopt_debugfs;
+static DEFINE_MUTEX(rmpopt_show_mutex);
+
+struct seq_paddr {
+	phys_addr_t next_seq_paddr;
+};
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -587,6 +598,8 @@ static void rmpopt_cleanup(void)
 
 	cancel_delayed_work_sync(&rmpopt_delayed_work);
 	destroy_workqueue(rmpopt_wq);
+	debugfs_remove_recursive(rmpopt_debugfs);
+	rmpopt_debugfs = NULL;
 
 	cpus_read_lock();
 
@@ -635,6 +648,10 @@ static inline bool __rmpopt(u64 pa_start, u64 op_type)
 		     : "a" (pa_start), "c" (op_type)
 		     : "memory", "cc");
 
+	if (op_type == RMPOPT_FUNC_REPORT_STATUS)
+		assign_cpu(smp_processor_id(), &rmpopt_report_cpumask,
+			   optimized);
+
 	return optimized;
 }
 
@@ -669,6 +686,115 @@ static long rmpopt_leader_fn(void *arg)
 	return 0;
 }
 
+/*
+ * 'val' is a system physical address.
+ */
+static void rmpopt_report_status(void *val)
+{
+	u64 pa_start = ALIGN_DOWN((u64)val, SZ_1G);
+	u64 op_type = RMPOPT_FUNC_REPORT_STATUS;
+
+	__rmpopt(pa_start, op_type);
+}
+
+/*
+ * start() can be called multiple times if allocated buffer has overflowed
+ * and bigger buffer is allocated.
+ */
+static void *rmpopt_table_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	phys_addr_t end_paddr = rmpopt_pa_end;
+	struct seq_paddr *p = seq->private;
+
+	if (*pos == 0) {
+		p->next_seq_paddr = rmpopt_pa_start;
+		if (p->next_seq_paddr >= end_paddr)
+			return NULL;
+		return &p->next_seq_paddr;
+	}
+
+	if (p->next_seq_paddr >= end_paddr)
+		return NULL;
+
+	return &p->next_seq_paddr;
+}
+
+static void *rmpopt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	phys_addr_t end_paddr = rmpopt_pa_end;
+	phys_addr_t *curr_paddr = v;
+
+	(*pos)++;
+	*curr_paddr += SZ_1G;
+	if (*curr_paddr >= end_paddr)
+		return NULL;
+
+	return curr_paddr;
+}
+
+static void rmpopt_table_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int rmpopt_table_seq_show(struct seq_file *seq, void *v)
+{
+	phys_addr_t *curr_paddr = v;
+
+	guard(mutex)(&rmpopt_show_mutex);
+
+	seq_printf(seq, "Memory @%3lluGB: ",
+		   *curr_paddr >> (get_order(SZ_1G) + PAGE_SHIFT));
+
+	/*
+	 * Query all online CPUs rather than just rmpopt_cpumask (primary
+	 * threads only). The RMPOPT instruction only needs to run on one
+	 * thread per core for the optimization to take effect, but debugfs
+	 * reporting requires the RMPOPT status across all CPUs.
+	 * Performance is not a concern for this diagnostic interface.
+	 *
+	 * This is safe because RMPOPT_BASE MSR is per-core and
+	 * snp_prepare() ensures all CPUs are online when the MSR is
+	 * programmed during snp_setup_rmpopt().
+	 */
+	cpumask_clear(&rmpopt_report_cpumask);
+	on_each_cpu_mask(cpu_online_mask, rmpopt_report_status,
+			 (void *)*curr_paddr, true);
+
+	if (cpumask_empty(&rmpopt_report_cpumask))
+		seq_puts(seq, "CPU(s): none\n");
+	else
+		seq_printf(seq, "CPU(s): %*pbl\n", cpumask_pr_args(&rmpopt_report_cpumask));
+
+	return 0;
+}
+
+static const struct seq_operations rmpopt_table_seq_ops = {
+	.start = rmpopt_table_seq_start,
+	.next = rmpopt_table_seq_next,
+	.stop = rmpopt_table_seq_stop,
+	.show = rmpopt_table_seq_show
+};
+
+static int rmpopt_table_open(struct inode *inode, struct file *file)
+{
+	return seq_open_private(file, &rmpopt_table_seq_ops, sizeof(struct seq_paddr));
+}
+
+static const struct file_operations rmpopt_table_fops = {
+	.open = rmpopt_table_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release_private,
+};
+
+static void rmpopt_debugfs_setup(void)
+{
+	rmpopt_debugfs = debugfs_create_dir("rmpopt", arch_debugfs_dir);
+
+	debugfs_create_file("rmpopt-table", 0400, rmpopt_debugfs,
+			    NULL, &rmpopt_table_fops);
+}
+
 /*
  * RMPOPT optimizations skip RMP checks at 1GB granularity if this
  * range of memory does not contain any SNP guest memory.
@@ -874,6 +1000,8 @@ void snp_setup_rmpopt(void)
 	 * optimizations on all physical memory.
 	 */
 	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
+
+	rmpopt_debugfs_setup();
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
 
-- 
2.43.0


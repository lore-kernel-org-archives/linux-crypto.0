Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010025.outbound.protection.outlook.com [52.101.56.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F2B2ECD1D;
	Mon, 30 Mar 2026 22:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774909680; cv=fail; b=QpY83hYjVuz5w/oBk5Cr8Z3FSvI/gyQ46NVpMS3MbnFxO7o7J8S/LQRHv7wShNgx/nWfbDfD/oFldwNDlxNgRjjsC342PL7eSgVAwyBysocK5o006KBT3lpxCcEyRZ7prWvsbTLlUTeFTCinuL4CdFjpUohjbSBxVaYJpG/z/u0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774909680; c=relaxed/simple;
	bh=B08BzL4bUlZA479/ayP0vpa44usqAHD68UYyj4AZaIw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTs6VQ8FfKcreXFizq4yeR6KDQYZBLcE+Og/otg9HHpN8XwptT71prKHdycnfpvBzAE0fgA7flJd5H/FQXG9v0OeAj8S9XhdAV809oqrapcCdZJkWmZjQM3PChAkbMclSa3WYrJBK4ljFTuj+Z7DuQEcP6q0QH4KarQl2x9xL90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BnsOf1HN; arc=fail smtp.client-ip=52.101.56.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BnsOf1HN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XiJ6jbI9Yc2QpZGNDbQ5Tgf+jjsC/2FYHx3DCCE2pkoHvlv4DmaLBME+AkrqYHQjbGvKVvoz9WEFE/2MHOJEIKgY19oyDjXRmWgBGlDVpkzb+BYqFssvlCTBUwzIfbAghkF1ILrGNKLXFg8MA2Ie19i2TXrKWitoYW3GzyrGA+TIMu8gE710i3T5XyEsmCwiKL0KyKik5nsdJZ875cTqSbJRqWlDFLEiHWqpb0uOD7hoccysiKmiXuRKQffSSHkqUSGsICROLFYyS9dxhlkDpo/8L4bO9vSzcUJSjd/fX//KTfxpUpr/VySlk/Lm6yfCs/io6KlU+kY3nRQ8PiMmcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMySisFAIG5ncG9Qw6fAdUl7gZdelDGZNv0cJE/pflU=;
 b=q2awvA+ZRMI8mBeAg3LZ9femD78EWxQCDMaMfC8SJ7v0ZeYqqTKqsMB/7Bxfx/NcfgpQyBFEqUrtlqF5uJYW7VOKY/YAvTphrOOBxbWXNXlMXjGphBIwGWkS5XVjHhtBn0zQk8mBooWmougPGHpLbKDuLiK1jfn9uikIrEUmGecGYEyd2XaDgVfJjqIkrYnuC6KULWAMab9SXfxCUY6EVoMzcqaxjiJz7DNkHRRUhQQp98uJZ37K2BSoPLCPbKEmQ/Rpb0H+CgQ2FyVn116HODEsmLufY0+RAOnrobWRcco3oVsjpmETKDZj8Uc/l34e+bO0TgFdWRFB8SWbrgaF9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMySisFAIG5ncG9Qw6fAdUl7gZdelDGZNv0cJE/pflU=;
 b=BnsOf1HNWRnR+WFzI0Qjd2hpytjia/WFMM/LEg2zwJ77I75zSyOXCogQ2/sbx5cdYjX0MvlM/IqLSANJf1v1Do0Rpat9+s3vPLUTIacTalnqGL65UWeIBTHFAdpCslQnIugD9aOVmPx+Uo/IcDOIMQnwiZDF0V7Rnl6lAMUZjL4=
Received: from BN9PR03CA0535.namprd03.prod.outlook.com (2603:10b6:408:131::30)
 by PH7PR12MB8053.namprd12.prod.outlook.com (2603:10b6:510:279::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 22:27:35 +0000
Received: from BN1PEPF00004680.namprd03.prod.outlook.com
 (2603:10b6:408:131:cafe::ba) by BN9PR03CA0535.outlook.office365.com
 (2603:10b6:408:131::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Mon,
 30 Mar 2026 22:27:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00004680.mail.protection.outlook.com (10.167.243.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Mon, 30 Mar 2026 22:27:35 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 30 Mar
 2026 17:27:33 -0500
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
Subject: [PATCH v3 6/6] x86/sev: Add debugfs support for RMPOPT
Date: Mon, 30 Mar 2026 22:27:24 +0000
Message-ID: <3368b33065b45d14902ce8471ab8434d79446096.1774755884.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004680:EE_|PH7PR12MB8053:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ed5153-2096-45c2-095a-08de8eab8ab2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|376014|7416014|18002099003|22082099003|56012099003|921020;
X-Microsoft-Antispam-Message-Info:
	bmKocBsy1h1uzNxfkNG1ibCSEkByZoWqOnwTeE/P2NTOwM+4IYEPgCPJA7BvE0CJuycdiVQ4zvhbO14PSERmtewC0XTokJLyv9cnJOAnX0ojXML6/s6T9LjYYNOGggUPQlavSW4CgcQFzVaqz0dnu7CkU9l+0ZgjZ8S75fFY+og5iDxQLKXMnfVCilDdnEJE5JeDGUk0hikU6C8fl9WRtSKJBJvLFlpbNCseB7CA365I5BA/w9cu5/WXsAuag8GDlmLHfkWh4o8wyLcfid+Y6Ap3uGT3jAPRwIrzJORdaAX0yUd7UYsqOSudvWOrwslHAo8LQKCTM1+RshhHvOaF5wo7qM5VDeL8dlLNcEt+fHyZCvw4hS21vGc1bVIRZeh+0i99PPxcESHk7kShi9wJQV/mxfXYJpdRP8EtBJAkxihtx8Gjg3+JB6NmJancIDrUYvbTH/GaQGPZOI0tXzpaEE9WpfUxXRg9+DTyk4oy5I9FMQmvkrsiNZycvCnhg/l+cLcI0Rj2pTolzZRcyMz4qU+aInK3S0USHIvpBXRPaE0IUparKvPj90JwLp5wLqkzVcMak6EQVUzy0Jmy811XxZQxkNPGLKZZRDjAP794dZsalSr1CJGJIGOdyc++TXApq7ZpMOjNhFl3yZCbJg6N/gvXqdbkPT/sGpWgp8LADWua3aDu3tQWhnY5oia/AcgCcYyMLGPpXgYdMZxPiEbHyyY/wwplPiWVjFykMVGMdRwaAazI6V/Kn+inA6QrQO35z2pcKV4NwoKW+KK7dntmS8RHq+CDme888srCurwmNbn5z0E8TSzJJw5hNxkpTq5d
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(376014)(7416014)(18002099003)(22082099003)(56012099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wAyi6SrK5Ks6ZHn51PTPfF/N4VKeLND7obVDv9xTbx/7d7bw5jaXMCLEWo1FSe9jKAcaLX5Bqp/vedOo45HFd1mdYGUFGy+InsFp6UJySI7jeNINPUAczC0XamDdNzmXts8Ll8McKaKLejU/ldvSGDQFFS3YFpG2BHnrhy/rMkPSylyssdrwvx+5YH9jEMa9NDYvU0CyXoTvhYkk+v+iGOrqKxC+u1JdQ7WZlLb/cY5yMwudkc52xWGzNxpjmUQ1Y4i/QAc5dsCGmJ7R0DR9DFwhPWv2XOEOZ/vuW5zwqt3aZkO1trGywqtrFFzunr9trrIHxolYqhSOu9Po9pegdGOvWL8C2gmHJDzfvbSWjELtYSsB6rshHtk0qfm9twcEgwl4ZZiJCWxBTBv256QUM4HaV77mzGS+Sqk0HCupnA8tRWsd+Yp6rLvHMrDnsUl/
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:27:35.0249
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ed5153-2096-45c2-095a-08de8eab8ab2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004680.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8053

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
 arch/x86/virt/svm/sev.c | 107 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 784c0e79200e..04d905894408 100644
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
@@ -143,6 +145,13 @@ static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
 static unsigned long snp_nr_leaked_pages;
 
+static cpumask_t rmpopt_cpumask;
+static struct dentry *rmpopt_debugfs;
+
+struct seq_paddr {
+	phys_addr_t next_seq_paddr;
+};
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -500,6 +509,8 @@ static inline bool __rmpopt(u64 rax, u64 rcx)
 		     : "a" (rax), "c" (rcx)
 		     : "memory", "cc");
 
+	assign_cpu(smp_processor_id(), &rmpopt_cpumask, optimized);
+
 	return optimized;
 }
 
@@ -514,6 +525,17 @@ static void rmpopt(void *val)
 	__rmpopt(rax, rcx);
 }
 
+/*
+ * 'val' is a system physical address.
+ */
+static void rmpopt_report_status(void *val)
+{
+	u64 rax = ALIGN_DOWN((u64)val, SZ_1G);
+	u64 rcx = RMPOPT_FUNC_REPORT_STATUS;
+
+	__rmpopt(rax, rcx);
+}
+
 static void rmpopt_work_handler(struct work_struct *work)
 {
 	phys_addr_t pa;
@@ -560,6 +582,89 @@ static void rmpopt_all_physmem(bool early)
 				   msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
 }
 
+/*
+ * start() can be called multiple times if allocated buffer has overflowed
+ * and bigger buffer is allocated.
+ */
+static void *rmpopt_table_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	phys_addr_t end_paddr = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
+	struct seq_paddr *p = seq->private;
+
+	if (*pos == 0) {
+		p->next_seq_paddr = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+		return &p->next_seq_paddr;
+	}
+
+	if (p->next_seq_paddr == end_paddr)
+		return NULL;
+
+	return &p->next_seq_paddr;
+}
+
+static void *rmpopt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	phys_addr_t end_paddr = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
+	phys_addr_t *curr_paddr = v;
+
+	(*pos)++;
+	if (*curr_paddr == end_paddr)
+		return NULL;
+	*curr_paddr += SZ_1G;
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
+	seq_printf(seq, "Memory @%3lluGB: ",
+		   *curr_paddr >> (get_order(SZ_1G) + PAGE_SHIFT));
+
+	cpumask_clear(&rmpopt_cpumask);
+	on_each_cpu_mask(cpu_online_mask, rmpopt_report_status,
+			 (void *)*curr_paddr, true);
+
+	if (cpumask_empty(&rmpopt_cpumask))
+		seq_puts(seq, "CPU(s): none\n");
+	else
+		seq_printf(seq, "CPU(s): %*pbl\n", cpumask_pr_args(&rmpopt_cpumask));
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
+	debugfs_create_file("rmpopt-table", 0444, rmpopt_debugfs,
+			    NULL, &rmpopt_table_fops);
+}
+
 static __init void configure_and_enable_rmpopt(void)
 {
 	phys_addr_t pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
@@ -613,6 +718,8 @@ static __init void configure_and_enable_rmpopt(void)
 	 * optimizations on all physical memory.
 	 */
 	rmpopt_all_physmem(TRUE);
+
+	rmpopt_debugfs_setup();
 }
 
 /*
-- 
2.43.0


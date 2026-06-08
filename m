Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2895C3E4C84;
	Mon,  8 Jun 2026 18:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780945095; cv=fail; b=mNjiJ6xBT1DQheiPM4A/1BdrsJ0DiUo4T0uEtLMXnYsEgHBIQxVNlr10t/JOAt5ibQNQsed3iZtfxhiR32Rv7hHKsmtiim28Aq5VBHqZQbmfrKvohwGSAHxUfB/ypnBhWWI0IfWfAt7zUedfYEL10XHJRwz11lp4r02aEaSx5Zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780945095; c=relaxed/simple;
	bh=maiv7JAWrRHybF2n5CwfLjqGb9319FUSLfJgLOspm6Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bWo1ubWhp050sGW+lAYcKeFlZ6qZTqWG3a1KfSinA4IPqtBwOARYmRDfA+41qfbs+xPrnf1puGMiNdqvORsmjhKl2tP5EMtOMuN8RP5puDNwS0MWKMbx/FLivvQbS97UYztnMWdVyIXXxBVKCY78evYfbNJTzCLQSC8R0+vaJnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mKW/9YHA; arc=fail smtp.client-ip=40.93.196.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mKW/9YHA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mcY61kUSsWyu9ttk9cMjN5LPjtSCkLmwOguQvLKTe0VokP8OAM2H2Vlcvaf2rPf3BLogEp7uBJQ3+IK1RH9G4He+XWwgy7pL1DhQV2UBnG1uxSfJx+QKxF9jOzsghh4jIPz2HxWeKOxkBiynoLZ18sVyZ11cSvcgqC4xhT3Lxb2ZL8+Xa5aUXhsF1yMCK95hnGr4GjvMP9aeX+B4Q4wfXV+rty+5NFlIX3emhWXSxLlgMyn6hbJn0mOfmCp8+xunsktoD/HEOCwDhh2I4EAYfwI4wpScuSVdot4pQp31BdaWiaASjn4ycqLnw0UVaN9LKBupKG3L5msHcNJh+DYwxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mK8/reYyAaVbyrtrrSk/gxO+eojgGhRteZUBVz8FOs0=;
 b=ZmG8hA6veoV+qs/B79Wa2A/5jE3ouaO2r1pt/FM5PefC3fbTP6+obZ0X2ISWoRHjV4NGPpLLbn9a7c6A+zCuQ3y0n/7iD4Fb/OfvzIb2RSXN/8fdPagkbZKm4n3zqg8V0XvktoszBf6Q+LhJWOPMXJ8CUEbb2pjjFAffw7CWl13z1FpTCiiBUXebGEqLbQB2YHWwNPqcRsSDuRB3+Wp5jqO7xEmQGzPzUTjpSQNG7Qtkpc4tGGXio/PwnBQ35khTwAKUZQVHid3G11b5k7R804/+KvdKEZcTKxKU3j61Yna1XaJehQf0eOf7dyQ67PvXsHT3SY4AVoJmkF5iOSs+0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mK8/reYyAaVbyrtrrSk/gxO+eojgGhRteZUBVz8FOs0=;
 b=mKW/9YHAmUnIHfD0Xlp9iQuP3ZeOQ2uS5nIEte22bz/nZHSb5mn7zTJbsHL4jkTF8PCN7ONPSoF4WNkcg9vqOkM6XU1Ox+wYlU2ctIZxb/Cl0iyBGTSm+H0qbPb+ZaHG2BqSVmTPlFPFMHalr7p0qunx7AsBUKg4Fx3IobF9y44=
Received: from SA0PR12CA0011.namprd12.prod.outlook.com (2603:10b6:806:6f::16)
 by DM4PR12MB9070.namprd12.prod.outlook.com (2603:10b6:8:bc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 18:58:06 +0000
Received: from SA2PEPF00003AE5.namprd02.prod.outlook.com
 (2603:10b6:806:6f:cafe::20) by SA0PR12CA0011.outlook.office365.com
 (2603:10b6:806:6f::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.12 via Frontend Transport; Mon, 8
 Jun 2026 18:58:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003AE5.mail.protection.outlook.com (10.167.248.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Mon, 8 Jun 2026 18:58:05 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 8 Jun
 2026 13:58:03 -0500
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
Subject: [PATCH v7 6/6] x86/sev: Add debugfs support for RMPOPT
Date: Mon, 8 Jun 2026 18:57:52 +0000
Message-ID: <627f06076cf45336da7898282971b532c96c01e4.1780903370.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE5:EE_|DM4PR12MB9070:EE_
X-MS-Office365-Filtering-Correlation-Id: 02d8941e-63aa-4ab5-e220-08dec58fdfac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|376014|921020|6133799003|3023799007|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	5QxrCAL7L0jolqYoNTIjJGnVOh0wIfkj49e8KVAkjsr2Whh0FWR9F4jRiN+zFz60nEVV3CHmmLC8rXnhQFjWkfSzHIxUx9xen9/A5gmIMKzAUXeNeqvoaLpBelqqLafEcFv+d/KUVt3lpJqLN8DchjWo3daVolXtyuRdIQaWbsQT3DSz4qEuLICgFtWCXm0SZ/vcQb1cAXUSmK/YuDX+JbKxoSUIwh2UK9DVH9/Ro4/bIRB+jNMuuCXxT0WeOKDraqoy5Vs12w9nRBxBa58uw8DIxyypBcrMJUF5EkeJ7d5pV2qFS4lKHRlC2/mKMZj9JjgvbnpSryev4nNlMrm+zxyigopADu9DjORI2YEeoHwu07iTh/otYsZErlNs81s+ovXYGwZky0v/oH6T5kWdUEhQ4CCVMnLLMfJCGiBSLLzxXxNLzEVOvzmm8ekASioEfHSN4Ctn+kxXmq6yhphx/AcBqIwQ9wTfLJeS8zSh/mgHrVj4X3NPn0SlYhxYDDajjGq/sEzeCgBa4P1+mvfZNorflF9PbgYH/RoN4F5qvnv7PwBtXlGsJ2Y2qqxYWNg8M75yn9EIQXLC/x4OT/b1yEjioJP9sEnFpO0FLzIiYHI7wHk1f1TfYAdi5tzpwjO/OhubNAWg+t/VpB02FVFo/dAmpKL5zj+kuTCcPPTOSPYu4xYaQjHgBgQMGXiXtt4qLldXmABpbzQ/4u7bJfJF9kfHay1MSFhbaei4E/o2LimmzmApNyywHldCUFh8fdYgtZjq4BTVcieJ5it2zQoeFQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(376014)(921020)(6133799003)(3023799007)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	y/PdfOcMAy9ImYCt4co6IvDcay3ctuYIBKSj7b1bCz2dYPBBehIseCWumAlHDV3oQ3rsDwLOQzmKtxtzzF58gwiF4E/cvVznN4ha0xwyIasPHyoV1GSTW8XZ6E8+GY5wiCZVFqlDkbuLWDGFbNwEKYAl9BbCSeDlRlRZSG2typ9kLuDIviiBIEE9OE73osFLZeEysRUvpLWJPbkUaoCIwCqqQd7/qwM2ppnfBYudJ2FDJ04IK5/1SN3Yzx2VaGVUz9P/i46Yg2bNckWumOYIKvun/Jagy0bS6dvaWKMT8OZoH0et1ezVh17AKZojf02l6uoXCOJ+9UKXeH4htn7C9Xz1U8r8NxKK6N0NcgjPTyvokUWuVcLMERzGUKCobgF7ideNaxgzWZk+ONltFpa4o0y+wefNX+l4SM/Y0bB+1mOdzTP1Qa9bQHjgZ3DHr2/k
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 18:58:05.6211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d8941e-63aa-4ab5-e220-08dec58fdfac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9070

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
index db2d4c1f5dd7..fe45a333df92 100644
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
 
@@ -654,6 +671,115 @@ static void rmpopt_smp(void *val)
 	rmpopt((u64)val);
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
@@ -852,6 +978,8 @@ void snp_setup_rmpopt(void)
 	 * optimizations on all physical memory.
 	 */
 	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
+
+	rmpopt_debugfs_setup();
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
 
-- 
2.43.0


Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012055.outbound.protection.outlook.com [52.101.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B352CCB9;
	Tue,  2 Jun 2026 20:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780430592; cv=fail; b=sG78tw0cI6YArJ95ue8ge/4bMi6FMkn+u71t7fcLWNvhCz0KgPyGEeqzEWn7Cd6ZprgGxSwsddxup6DcALgQiRA81z9dO7AkINOr38iP6ZrsctUDowCZIePq3HChSsIySl9AmRWQmCmyf5grYSdi0MRSMjgXGmxJGRW2KhW8BYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780430592; c=relaxed/simple;
	bh=KSY2VL8R2wTxxdRA9GXA3nPzwGL7qkwMgJGiq9IQrNM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NnwMYQ1nzmer8wfNysoOFxmSsem/jUf0sB7IwjdTfmTWAESfWsm18KVOclXrLvKdrRCOG8sNRC5ra3Zw1xOjHbKHjXTcOrhEeHuN91mwLbOlWhsDj/eA4bJCdNaiCXlDLGB3c1jdXJsI85d3ssNFKpWqDgBkp9/FspZKLJDw3Ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5JRKJQau; arc=fail smtp.client-ip=52.101.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5JRKJQau"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nBoSvzyIVG/DQ//rkjkVrJg7jA5IAxZI5bD75fwEy0xGhhkvOCxyrlYedhMLWIlRk1ul2my8iBCSWXyupiBzwhqAhGAPvD6j6F6nrrF/VhRyOFbaqvzA8ayPrY58GK/czntIEDUSRTciPqW2UNz/1vhaTC9qh8o8SMSHYddTUranEwu6M7IG13F6JGP4RmQYPM4U9Um/qRKrFKd6Z6gbXkFRsVvdjVC3vq5nbGzuBf5OYgauVgVs3ZdG4HTWkKObAl2L/LxpE5pp8uTNW5UYN60VcNsLCBl3hXxZFNpgyGUekizeqKTdrJO0lV/kcoMt49R6loMEYDdexNIc9uFi8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hDsoHxLb3UP4QP2EFrbKgAYu8FmeYYAX1hQJkPDdNBY=;
 b=RLEIKhi/erdxbTgF4lXBjTz2bMybzuCTdLXrl1I6zJ3Ffg9z7oL3hvu53ErRjPsmYFY1Bz9+HV3jkPnzDOPp2kO8t7eFGfA8V3+z9L2s020Uo92NH1lmN83pvFBYbfDuT9X5gmgs3VS/6gGXbfHsE9jyZQFnOdkPLjjaVr7jt3MXiLXVywqu2jK2asFCnhwJkkjhYe1HqSHW4VRVIkurZuhJwu5nGBAR5r0kZ0uHz24ApaKn/Ls8DEYqSSSN2KPsEldN+KhNI6V5d7mGPJpUks/KUga1JRZjrlBweCxylzqR0sPCPq1qExj07GS6VCdBJ1q/W9gzopGvraPI3pkBWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDsoHxLb3UP4QP2EFrbKgAYu8FmeYYAX1hQJkPDdNBY=;
 b=5JRKJQauX7X6dmXc8akOtWQKEdw7HHaFz9LJ1yVz5LA/Xm51uB2RZHeW+LzubNW0UC1kuGbKzPHvGwZXy3P8LdYG60vOnDjslhnaquY4Co1tY6j4H0mQgglXixdTBJdn7wiHesEweT3s0rkzODhG08hLrd7+i1gu2JQA0lc6aF8=
Received: from PH0P220CA0004.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::22)
 by CY5PR12MB6455.namprd12.prod.outlook.com (2603:10b6:930:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 20:03:03 +0000
Received: from CY4PEPF0000EDD7.namprd03.prod.outlook.com
 (2603:10b6:510:d3:cafe::3a) by PH0P220CA0004.outlook.office365.com
 (2603:10b6:510:d3::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.7 via Frontend Transport; Tue, 2
 Jun 2026 20:03:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EDD7.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Tue, 2 Jun 2026 20:03:02 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 2 Jun
 2026 15:03:00 -0500
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
Subject: [PATCH v6 6/6] x86/sev: Add debugfs support for RMPOPT
Date: Tue, 2 Jun 2026 20:02:47 +0000
Message-ID: <0a956b779299d43f30d88c3a271c7f24cee22baf.1780427587.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD7:EE_|CY5PR12MB6455:EE_
X-MS-Office365-Filtering-Correlation-Id: a6a9e022-2797-4481-2bbe-08dec0e1f3d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|7416014|376014|3023799007|18002099003|22082099003|11063799006|6133799003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	AFbMIFuJd5v+pv4OlwQ2BeTkcwJHBOF2IV5aurofRqv6JQHwOhFD1H1AZ6d8XEnESkniPOUMp4wOV7m3+eaTYO0sN/2lrMMOS4R+L3ujIFtkCV7GmSWnsqPw/DTnfwn1v8xgwNWoPjtsKtZNnuO2Nvcr3matpdP57fjquwXEMmHwNf43a8LSLbf6rF9rzvz2P8R3xbXMt5haFYmr6CeFUZLv9mAhgMiIiQYN7SWpw9bus6TJnhe3vlnXCN1wWtfssni1bzpitQV6q6i6btbjM4bRUK+gTaaXvX89Gx+OgBWKPyRB0p1/Ehg9N2qh8gZdbw5RL6QyOIC1MSi1WJhTCmuMOnGzYL9W0N+kKJ26wgTXoiN+RX72ysbQRfltbgzyrf6Rrb+T/wz+qucDEOcRQoJjqlAB/dC+Wfl6CnWgOsAPgnzDaypuqgudGvCd7ylv7NS0akhVCoIIVWbOVWtg3ZpfW7CGRnNAC7AhLcoIP4gjYGAO+ns+hbFpa8U7ycT5/cvrWRT3YNs4J8a5rMI0donyQGHeMAvNViIjaf/DRWpJY4H7VmUhhb6JAU+HTxZNmL7BmNNSXG3fhyR2U6/oULUP2Rpm8cbHyi/3Vy+y+++d+nPvDIaDrSeh9Cz8z3KXjbWDU3oauVt205UNeiDvF24KFFsNdzOfVPSwwfMAVxCgojUbxvcQsZCHdCbh3dlHcA+HPI8rt5djHn3Fqv/1zvlYN78lb3V/Ixyq72LRHeHaxHvZkfY2THFhPaUygPQZ7SrFjg4StMpobT9f7KmXUA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(7416014)(376014)(3023799007)(18002099003)(22082099003)(11063799006)(6133799003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V0IkaNvewaueA8t/0Ioxh9HOC1jEvRqNF2kPeXvaviGkI4D2yJXeZeJefbP3e49rrche7845mqEtPOVyQC1taVLUJukGDMkoH/9gE+xDBMB/TdZ1J8p7Rz9nwMtqDymwvhwD+wwPcJzsu7/jJ+94Rwop79Llqbv0J6Y9/PK7HsueI4mKqtVUA5yaniU9RfgHVCsXYXZgsukDZAqjm63wTqLMsVKEjJFlmO+lKFqnVlwExL7PAJd1CLKzO9Gt2KtcnSLPikkFKVUxwigLpirQDC4wEaWMPCluW1+u/jty9viCBeecvbvW4Fjnuep/cuA6ssxEEhkiJ5r1XvroRf0kBQl1H7bEBwXUdU3MxCh17x3isDyEDh/MxBlWf2jr0VCGTKI/eBN7un9jswJtCqfogQP7yhb4MfQDnJdyF0GlES2m5NbU8whHHEONw4zXLVt0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 20:03:02.3766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a9e022-2797-4481-2bbe-08dec0e1f3d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6455

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
index 4442ecae3d18..29695bb18991 100644
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
@@ -144,6 +146,15 @@ static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
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
 
@@ -585,6 +596,8 @@ static void rmpopt_cleanup(void)
 
 	cancel_delayed_work_sync(&rmpopt_delayed_work);
 	destroy_workqueue(rmpopt_wq);
+	debugfs_remove_recursive(rmpopt_debugfs);
+	rmpopt_debugfs = NULL;
 
 	cpus_read_lock();
 
@@ -622,6 +635,10 @@ static inline bool __rmpopt(u64 pa_start, u64 op_type)
 		     : "a" (pa_start), "c" (op_type)
 		     : "memory", "cc");
 
+	if (op_type == RMPOPT_FUNC_REPORT_STATUS)
+		assign_cpu(smp_processor_id(), &rmpopt_report_cpumask,
+			   optimized);
+
 	return optimized;
 }
 
@@ -641,6 +658,115 @@ static void rmpopt_smp(void *val)
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
@@ -833,6 +959,8 @@ void snp_setup_rmpopt(void)
 	 * optimizations on all physical memory.
 	 */
 	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
+
+	rmpopt_debugfs_setup();
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
 
-- 
2.43.0


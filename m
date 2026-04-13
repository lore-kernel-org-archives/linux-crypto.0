Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011065.outbound.protection.outlook.com [40.107.208.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6103E3C47;
	Mon, 13 Apr 2026 19:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109507; cv=fail; b=TDLBUh88DMO15GFqGoeIY4dgRhTcOvxPNfuOahgshIErKeT6aIgprvpBfHMLRkkbkYI0k9tI4YwDBpKmfnFog3mdQN7Z2k534jftiwCCNNTgpCJVFi5GopZolhqxhUO+uTM31JIj/9FgeuJ2DkyhKMxnVqWLBve+ieAmsAJKNjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109507; c=relaxed/simple;
	bh=hFOC/1oaqbVVnhahYF1FATxdy6ZFiTBYGq2MRQR392U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXOhOJJiCqjPaf5a/ut95IVOCzstV1cUjrCepfoMypFcChYBIOjGC8Y+rUahd8qAYlv/dSzFcNNKycbb30VHiD99cGsrnZN/8EdfCcXvH06PtubnwJ6L+kckGbsWsLPOm3SKSzs/FCrebVBpRX4uXbjDpb8OAxMsMTu3gdQ7ofA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SrrZWlhi; arc=fail smtp.client-ip=40.107.208.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SrrZWlhi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QEP0OBijhlXmromfnmSLmoLD8kyz00JEj+jph1Uks1j38vbNoVjIxXXo9lUwDffjx3UZ9CaccJMEpthSaVe2uvV6B9C4ao5BsZKuBP6R3P+rpQoARloKM5z7hpcGbepfD7lO82go1tlORcgfdasGcGjcTfYOqMnrAd9VUb593p0vEbLBCquUMO9oTP2mQJpl/Ut5OcZF3aN8nmk/D1kmwQxSYLeaTigAyubQ1cAbmy2HP9CnEbizHRPTjLUTsXmlF0esXlNAGexjUI8QfSeUcpoLOmQXUb02RlyjkSM2SvMxEFj+W62MPrOmUH1SoLxkHp22Wvf65f31ZpQq9FCRrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rNwPEIhlz0pl/nIyIeCprBj8bNu7DpigBVKU1KzNBic=;
 b=NPoxEadrIaWXKPOJbL9rl6rI08u+q5m2F5o7Va/XhBeUcYaIA8eF+AzxnQBQPJ+MNy+o1ena7fD9Ut4ogu8WnYpu8z+GBNnAuIW+bhcrsgw9TTgSY54kLrHcnybc27nJAwDMXRKaskyhl2pWvCqlVgIy6IiGi6ex45EKrVDOBiAogBfgpQPnTd7BBxdWx96oV8gwZsVi+lROs34MKhW78v4zYgwMaXE6guGoAP2+4dMpgxL/SKQJr2WdnfL+jcUBvoM3zn8zE5hZ0QqPLM9m/y8NwpZou6OIescnBTuRhiHqkFeAVwZ59oaTxiyoUhRBcxOGXwH/BRjqTHSoavCDKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNwPEIhlz0pl/nIyIeCprBj8bNu7DpigBVKU1KzNBic=;
 b=SrrZWlhiZOkzILAccKsxGStcZ1lS+WesiOXoOxvDNN6vH8lukG9ucAYZvYoumDmvsiQ81hn32nFRSzTS6eL7TqHnREE9+4HxueyIsrHLfwjec6W8gKoztYoU9Lm32/GCmUijRCMT0H7ffAUriTeCPKO3UPAGCfP8K6YOjokpbFs=
Received: from SJ0PR03CA0193.namprd03.prod.outlook.com (2603:10b6:a03:2ef::18)
 by DS4PR12MB9636.namprd12.prod.outlook.com (2603:10b6:8:27f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 19:45:01 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::15) by SJ0PR03CA0193.outlook.office365.com
 (2603:10b6:a03:2ef::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Mon,
 13 Apr 2026 19:45:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Mon, 13 Apr 2026 19:45:01 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 13 Apr
 2026 14:44:59 -0500
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
Subject: [PATCH v4 7/7] x86/sev: Add debugfs support for RMPOPT
Date: Mon, 13 Apr 2026 19:44:37 +0000
Message-ID: <3be2faa018f06895b20b419cc3a06b9f91247151.1775874970.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775874970.git.ashish.kalra@amd.com>
References: <cover.1775874970.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|DS4PR12MB9636:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d799499-8c7b-4186-457e-08de999526ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700016|82310400026|921020|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CpR/j+2AwfBo/hq9IgBSkwyb9Z/oeKFzipYbc5ws+uVz6T+WHCD+WKxtkWoXlsZ6IFm7bSE0Y0Hq8wSy/2rnjpV2Bb58QEkyxSGOrv9dKuICyw3EwNb0Znr74gH14yvUyPtxn4Y0Fm9L+XsZthhj5nqBcoO70xokJXmYh07jJJWBCSnaDXZa4/S8JopHId0JtlabF2EzYJe0bW94uLdckqkKjSF7R0XF1pVpQ4QS8OedLPg15Wm9NkBvOQ9VGHjJAi6y85s4QClY/ikSk9werJQXsq06K8C30IDB8J1zMrnSB41sKan7HwB4WsiX0taH8e5GGVMG8wmU4qvKef/bshxeYOdYXHDpKXyZ9YoiLYHRNlMy9F5V9ZZHFdXdTlY6WP0T/jnB3AGh0+tI8ru4XsN4MV1x8zswqsG54/MZlomibWUjLj/72QZxglD02y1t1AoOx9G9H+pKSaVVLA27SXJPyY+eE6W3sIqQmQSg9JmsW6IaizH5PoD/C7jf5K3iusrKE2Ln2WR9i1XMI2ZjhSwwV/lrHrLSY851S+jV8V9/90bNb/Wq8F/gJZicQRowJ3OXPI6VWkSTv48HYgqKsxv2uQ+ctiVwJOCT2uPlCi1+Osm84wlv5XcUrgFQAFHCqTUBwF5+QBx2soTmzxy9g/ikWfuAYHVDKulcoNyphoCknOysigtQgxvLisKyGmcRF0g7cvJbTHqBtMyOpbOT3VwHePMOLC18yKo8wmHit/W/xSpCWKxoRPw3yihNt1isiKsZK3DGbvtA1SFYmbxMBWhipdrMJaA892fLrqzWaXr5ICItUVGVtlC6djrRL8Ij
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700016)(82310400026)(921020)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z7/ktjdhLPpQc/F86B3AWLVI3WAPUZA3N0Y8uNkGUfqZuK3oOrzc1uRWplpizFKjjuNUVYtuM6HG30n06ILmQRhNsYA911LsqT6OzMzUMo/RJaSBmqD4iv/oWwLmG4jxg6trhEMk0dD9bkf/6VIM+3NRO63XXL47ybfq91Jf02nKvxk+0mvh1ksy4MrqQ/oDsTPv/YFQepGeL2VpDQh86wC7Rw+EoLN30cXTen6YRnoAHYuSnkB4gHjf2+wL0hpIORYWPC3dK7d6Lu7UMOKdQnhTD1evXWN8UrAEJ2HrmL1S++s2kUXxXYrmtILBV8nT/kCvjvwDTzEub6HUQ1YIW+dKHj6ret5QnPR5QXtrSl5ojaehMU5yEqEuljVp5X4ffM0eUSQVBw1EsXplJdgYJPlJEw+UNxRig2cl3+JcP/U72MZHPQS6/D4uUanV0NKJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:45:01.0242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d799499-8c7b-4186-457e-08de999526ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9636

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
index 74ba8ec9de35..dee2e853b4ad 100644
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
 
+static cpumask_t rmpopt_report_cpumask;
+static struct dentry *rmpopt_debugfs;
+
+struct seq_paddr {
+	phys_addr_t next_seq_paddr;
+};
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -580,6 +589,8 @@ static inline bool __rmpopt(u64 rax, u64 rcx)
 		     : "a" (rax), "c" (rcx)
 		     : "memory", "cc");
 
+	assign_cpu(smp_processor_id(), &rmpopt_report_cpumask, optimized);
+
 	return optimized;
 }
 
@@ -602,6 +613,100 @@ static void rmpopt(u64 pa)
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
+	debugfs_create_file("rmpopt-table", 0444, rmpopt_debugfs,
+			    NULL, &rmpopt_table_fops);
+}
+
 /*
  * RMPOPT optimizations skip RMP checks at 1GB granularity if this
  * range of memory does not contain any SNP guest memory.
@@ -713,6 +818,8 @@ void snp_setup_rmpopt(void)
 	 * optimizations on all physical memory.
 	 */
 	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
+
+	rmpopt_debugfs_setup();
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
 
-- 
2.43.0


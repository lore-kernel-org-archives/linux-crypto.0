Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011038.outbound.protection.outlook.com [52.101.62.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A5239A072;
	Mon, 18 May 2026 21:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140651; cv=fail; b=qj5rDa0KD5TYRa28IJUUYMpEj4DiaPni+cH+wh4+OXPErmtaObpSkOa01cf70w/GVNRnT3IfmX4exQvPzLn2yntdJLNJV+GKEqtLq2SCMt3FDRBi3UZC6uhkLtJsio5pMh/Ey/RdWOo8UBoTDTkmxEK2Ir6t5iqmYjFn/j6zYOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140651; c=relaxed/simple;
	bh=jU6ySBvc1x9pPGB9Z+9RQR+yO4oIABXOmf9NjgppGg8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATfR5y3CGP+9HYiJ1FVvBnJ6RAwqGAFzFh0y6opcotyUMN7ycnQNWHnBNtn5E9BdEk/1Xceh80jQin9UYs9uJyvis5Ov1QfNWHbsMezyG5oniOAf/i4UJtM4Ty71zyUgp+z1J5k4rZ74su+x1ptHcl6UJX00V7VB2e70CPqinJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RPWXa+cf; arc=fail smtp.client-ip=52.101.62.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RPWXa+cf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GlIX7MtOSEDpEW0DDlPga3CK/3j3dzhykMW11f1aZvX6oof/42uo2d9WllLJAnpsA8Ph3qqXFptmpkoooNtlYKnm+TtfSs/hAuEGFDqPyWnKg+EvQkFw6dSOAgpGtqBY1a9l7bkgv0v3ajbC+qXlvzpxHL8mJ8/IJLv1RtElArSj1361eNbrj3XHWPSPX1Eg0Y4iCHkXDFadTSfVxehsbdoSmcAHQSwkFrRdNMiRKln8cl799Xwc8rQNezI1qCH5ycyavXZ05ut5Ayj/1YDFTXb2/avT+FDJj5QJUbqnuzI42zg2Os8/Mtgrgs1Gyfvaw0S5Oqs56hf5pt/ebkCxqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0eGlx4ZynLHtEwmiVPtxiIiMUHD9y8GF4XwtkTV/2oU=;
 b=WQYbEV5xy6FHnfCJeU8jre6iGbvU83KBr+24ULRyu3b3uhFeWpwS/qu1uXtzY+JRarOndDn5PzlvCFGxB8QhNbE6FQw30SI1bGeDUM/Vpm9aRK8ZxBqubnHEPxB3TQhg9/g88WrFsyiUcLtFxSTb/okJtkeNH1GMDA9ZcDlMUxICHv7PAPezqt4/HF6yvqcpTlYLiuzuysPJncRD9UQZaSFh5DUsEjqFWWTw6bIQ84FGe/o9y60XtXJGpjwXUHOp+SVeZAYd/e2mF7P+fhY2uudjzfhhR4pAwY3IZ0Jn9qjt6vbmlMwSWtXL9zKN23mv9k04AGml1Q0VS5Vlfwbfig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0eGlx4ZynLHtEwmiVPtxiIiMUHD9y8GF4XwtkTV/2oU=;
 b=RPWXa+cfAEX38hK+1ZBaCz/zbXAd9cMbZfzrbj0AgIDKj1YuNh7P6f5aEpCimQlXNxge+v+fwHSMCiaZUxIMl0eZDmdhb5vBDKHphNXRx4vUKiKKoz1Cdy27MaJ1C0kyV5VS61TTvOvLexaagv3xVdX2JzNU0M8B64KZn+9QoVI=
Received: from CH0PR03CA0415.namprd03.prod.outlook.com (2603:10b6:610:11b::26)
 by PH7PR12MB7891.namprd12.prod.outlook.com (2603:10b6:510:27a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 21:44:00 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:11b:cafe::7d) by CH0PR03CA0415.outlook.office365.com
 (2603:10b6:610:11b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.24 via Frontend Transport; Mon, 18
 May 2026 21:44:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 21:44:00 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 18 May
 2026 16:43:59 -0500
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
Subject: [PATCH v5 7/7] x86/sev: Add debugfs support for RMPOPT
Date: Mon, 18 May 2026 21:43:49 +0000
Message-ID: <e93f2253fad6a9c2edf393884bef2803a2430bef.1779133590.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|PH7PR12MB7891:EE_
X-MS-Office365-Filtering-Correlation-Id: c722dee3-b87e-402f-2600-08deb52692a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|7416014|376014|82310400026|56012099003|22082099003|18002099003|921020|3023799003|11063799003;
X-Microsoft-Antispam-Message-Info:
	tPkrIPCs4aw9ji7DAROPmT+bcwh2dhi3PZt/CPWgW0d/4sPEv5l+4j/7ktzzE3h/ODSYxE/1BA8rMTVNWg/tLui/FGruOhy/AvS8zSz7PH5UmhM7Vn0HAchaEBhUl0OSikKyvvYUNDwyYWrVVwZ4LPYd/wrclslPDhPOO5BoNLYws5WazdWamEUuvd7NHoZojcXrxVb2Y00IEZczMaZjqnKky32UHbo1gfOw7fpB/IiyMlkR5KhHMj9lFs+6t2N4IGBmHXmTBNiXJbrew+VnfJaNxSchI0QqLusncWsP0/t5V30LdroIpa0K4wlxmzlprMfx6MTA+oa61svgEW5rowAMbkn65YZhQ0O5+25AkX6m+kO68EgmHh1GrYYgba8edS8hfZmmLWF+RAeI9A8uExpU1DZJSssslL0nXrDYm/b5sKlSKN8esuSi6sk76vm5hsjgLpzEBF0oeOW4UCOWrsoPj9Y6BM4DxdmJNQ/ElEVYt9wK6ExHOXAlGAD5Jbh++EJsnLFNhl3FYIbmjpB8dHFs2xfiM2p5H1mrwWYgMTRBi1BHFsJ/QBUJkFtQJvGMuCxgMMgI5bRrEIMw1Ju9MwWOvhMCcXv7bZzs0tvCE8rO1ySWPWDFR8UlMF6lFBsVZM3ZJ09xmA3YoNnM+1bZqgyKeSJvRFn2e2aqZou95dv0nSV3IA2mzqzjix9575Y8/GM7lnNerXO33G1bEyU76wtQnYA07nbJF8iy/k9gt/H8hvysWsA2zXoWjUxRgJ9aMi/HbMlYZjVjB06VczMGug==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(7416014)(376014)(82310400026)(56012099003)(22082099003)(18002099003)(921020)(3023799003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IASqwDgpkRp0xoSxE/0qvwz+jm3MGkzM5JB33W78uedNR3VVPhJQdwRcHesSS1L8VAGIlcuasIF8ZLccHo9chp4Gc4AyzslZZdOtrzmMM0kltw/fMH7cyzjVUT2iWizFquJNFiIyqT5aI6VR0Po7xtClV+9t/8U0WCHkyniLpt+vbkGMUSvxn9M9PLVzpTu7Iy093huNikqBMcJaNKTnJvNAwkw82dOyl46y9HZlewCwTfoBcCcyTFRceYDs5OVDpjaGCoIuiSsPTsM+QSxossXfj3H480l6lnjjepFOJqAzkGpyOQfuFriJqQMspV6NQfMqIMiCXLpBSac1uIdL/08ZXFVidvfUnEdW9zbFWQNef676paeRdr3sO5WATCKeIPUgApmMg5dy3jmL42MAjUcMFw1B+B86jEcNv/dh7MCoUPrG0RKGGcF1my3pZVCb
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 21:44:00.6159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c722dee3-b87e-402f-2600-08deb52692a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7891

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
 arch/x86/virt/svm/sev.c | 121 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 7f8bb09844c1..ac414143feed 100644
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
 
@@ -583,6 +594,8 @@ static void rmpopt_cleanup(void)
 
 	cancel_delayed_work_sync(&rmpopt_delayed_work);
 	destroy_workqueue(rmpopt_wq);
+	debugfs_remove_recursive(rmpopt_debugfs);
+	rmpopt_debugfs = NULL;
 
 	cpus_read_lock();
 	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, 0);
@@ -617,6 +630,10 @@ static inline bool __rmpopt(u64 rax, u64 rcx)
 		     : "a" (rax), "c" (rcx)
 		     : "memory", "cc");
 
+	if (rcx == RMPOPT_FUNC_REPORT_STATUS)
+		assign_cpu(smp_processor_id(), &rmpopt_report_cpumask,
+			   optimized);
+
 	return optimized;
 }
 
@@ -636,6 +653,108 @@ static void rmpopt_smp(void *val)
 	rmpopt((u64)val);
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
+	phys_addr_t end_paddr = rmpopt_pa_end;
+	struct seq_paddr *p = seq->private;
+
+	if (*pos == 0) {
+		p->next_seq_paddr = rmpopt_pa_start;
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
@@ -798,6 +917,8 @@ void snp_setup_rmpopt(void)
 	 * optimizations on all physical memory.
 	 */
 	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
+
+	rmpopt_debugfs_setup();
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
 
-- 
2.43.0


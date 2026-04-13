Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010051.outbound.protection.outlook.com [40.93.198.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDC738F926;
	Mon, 13 Apr 2026 19:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109343; cv=fail; b=MWsKr48kTwJKcr+bd6WSHEXsDYE+YFX1qZjUX4IyftW01uLc533h0MxC11oFXDQZD3f+IarsjKqOj2NgwqM9KTMfeAfqOMFBHDC184DswcWJX8y8/uczRqtzoZwX9WUmLiK+bs4CY6xacedeZjx14B+SIkO5Vji8fjzLFvIFhhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109343; c=relaxed/simple;
	bh=icw+3ZaUmiLNu0PTSJmlMXevz5hXOTm/+uvt4TElOWU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cliKEmpcd4fe7wt6mkXVrBfJJ1eKKAZx12PHm/4C765/x5jALPeLT0lfat+EFbRkAVHEFcdgAQ8FUSxM4UA/WJ+y/XsPB7l3cFEsfQfX/C0pmaX71KnlBGqGaB/1dye8JX9AGW5068dpgJhLX6ObcmLbdvUvPpp4hovOjZB9Dbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=h+nnoQS/; arc=fail smtp.client-ip=40.93.198.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="h+nnoQS/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wM+xUYzOlWwS3Kbea7nBTvFKjDOJgiY7S5DYa5ZKuGIi7PNNEJnp9us0S1oRFIax7Cg4QX7pdGE1Z88X7PKgE25/gm8+fpdA5uPqmkIOvt6pCQY9vWO7lus0rzBrQAX/OmLMRkPakaZf+Xv4zK9eU4+Zjgq1FCOILFb0hXu4hDzmfcPkcgl1JZ2gfAf1LDT3pg5lNtdMAoYlIU8m1mKgbRCLvlHm9mNgApeHhSh6ok0khXe7mVDypqd0FMWJQGhCtoMc41KJCN+ZAP/byok+a5wrgDLfQ87HGgR3x2Uqa+TRkRJji0OzCgCWKJVuJqKD0ssNVzXuRd4P6CEynkN9Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c504uU2ejCaPmOihqPXmnPhjlzOjhBHaH2Y24b7El5M=;
 b=UV23PbbSpvl+OJsN20FqawCMc4i2690eqMkxL96Voa1oO+TRdq6TqtAxPZoeoal1IoSLYIbDdv6qW3EujpO2h5gu7aVGOqS+DVLUfbknHyyILRl5Uq/3jrP8WX9UQBM+DmF6psuNZg3BQ1a4eyR0WLyhCzEMqmGZMFfSJEhGEapgQRYVVVugF2Ud3h8sD+UJu+WI2/LJJGxvOrzJk4H7QXd+8edzLTKYS9LLr8tMu/4FDPTKv81UW3eHbj+p2d29K5qM+1b/qws18rIWuT4T8V3ehiQscVlcP7jhLhxEd7FEDds01hLN8ukWIxBrtCfGBjguTUT5Gkt2EY404URX4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c504uU2ejCaPmOihqPXmnPhjlzOjhBHaH2Y24b7El5M=;
 b=h+nnoQS/O97Vs4GiqOxRfu0KGaX7EafpD1QzAD4Hr+CrHQzf+mx7kcmBy83IIMGZtFVqp3UfBVbfAy+lOAkILntTFMwMSzvNgCj1BG6YR02Zhne3pA2GNvlLtfjEjFDIGrCyyQ3O9I4udjdZv7zp32OpCA8NSbj6vnaLsJDF1NM=
Received: from PH7P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::17)
 by DM4PR12MB7552.namprd12.prod.outlook.com (2603:10b6:8:10c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 19:42:16 +0000
Received: from SN1PEPF00036F3C.namprd05.prod.outlook.com
 (2603:10b6:510:33a:cafe::e7) by PH7P222CA0012.outlook.office365.com
 (2603:10b6:510:33a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Mon,
 13 Apr 2026 19:42:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00036F3C.mail.protection.outlook.com (10.167.248.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Mon, 13 Apr 2026 19:42:15 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 13 Apr
 2026 14:42:13 -0500
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
Subject: [PATCH v4 0/7] Add RMPOPT support.
Date: Mon, 13 Apr 2026 19:42:03 +0000
Message-ID: <cover.1775874970.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3C:EE_|DM4PR12MB7552:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f6ae0f3-1901-4040-ffe4-08de9994c425
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|82310400026|921020|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	VS0r/0cmBhwXG7zQJtSzEhJBF57nswpcLd5vNCkWobDEDdK1NgerKGMUOemZlNEhZHVp+317MSERqwzfIXi4CeJro6UVwgoAyhezHGzflpy1J/MLo/pUUid0CnH2S74PQaDVy2M+HbAt1gFNIlDT0u6U8f70Btg9zglgsw0jmffRctPNwarmF9vcZy98E+0e8FuiDDXL2E1O7AxZHwFtK5aQ4pQqs1fZIoGCFMfsTiwjx/Oo0pv4njp0uV61t1tnT+2J83lvtDEdRni2Wb02WpYbX+N49sGBk9+4BtAzo1fka6ax+vV4XPT09Vre7B7nn0k4HFtB75NlOcOpk0DrWi9S4t4L4yy6m4Aij59IkSWss+nMzbri5jQxWlw0kQnWkzYDBca1aD8F2k4DbxurNsR9cImP+ArmcYfpvTDIF8l84pVAEwxr1foBXkqYOGWq+pCXL51yaeM9oiAmuiP16XiG0B1REjhW6EzukIwHKa/cJTJTmB4v7av723SLcqppCiTbrY2DEgcikCDbNpJNwlYif99UmiadwWdU0y56kCzbdurjzpUPRFl7yShjuh1DCd9q6MjPrmhIFpEv6mZ0q8QrNhNo3k7Sdd5Co29Yc9V+vyOjI15S12cYojz8YRL/STqXrbq1QcSRvAcxe9YDYST4nGSxWo/6mJeVNYw2bQgA1JzrXzpL6/tuI3PFXX3o7O9GcD3igA/O0H8lM2AQiLLtw168IPIDnbPzAaDjsVIVhnJL+UGBNjQGNpBXWd0/7BCHmYhxyq6teJsYxI0wq57UWrRbRPufNab5TZvPlAWhNA83J86CMrpO6qPJjt9L
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(82310400026)(921020)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Xs+yRA+vmCZDdy+AdOaW2Zpee285tRViwNJ4arviPmlCHZSdy54kD8+TkimhMhItLERBSzwhAwwB8KSc2bmj7bXAvvX6rt0eQ8XOuTp7JOK9+k//FyRLtNAPpFWUY3zLwS/nMoGHWNcFs7VIWAFWpNr/KYn11UVig9aFUn9FQTRTxcW3W0qaz6kjRdHTglqP+re91mUZmD4xv9v4Do1nbRpnBHaoFvY6n1Dx7rX7xVzTgQH/SgpnBoA5a1aRjgXuyzrr7k5AXyKCtsF4AFHh8prA3+avv1tunkbjhlIi/n5U8m4pPy83mRk6vuhQybQnbne8HJL3Uq1CDHdWmOX+44NgeVd9cWpH8ShepM8PI+mDzjIp7iX7Q27cb+4Y58v5Vc4n8PASw8dlr5EQccbUz5b6AIrMOx68RVMhaaQoeOZ5Iva8tKbl1iHS4tz7Hdcb
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:42:15.7566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6ae0f3-1901-4040-ffe4-08de9994c425
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7552

From: Ashish Kalra <ashish.kalra@amd.com>

In the SEV-SNP architecture, hypervisor and non-SNP guests are subject
to RMP checks on writes to provide integrity of SEV-SNP guest memory.

The RMPOPT architecture enables optimizations whereby the RMP checks
can be skipped if 1GB regions of memory are known to not contain any
SNP guest memory.

RMPOPT is a new instruction designed to minimize the performance
overhead of RMP checks for the hypervisor and non-SNP guests.

RMPOPT instruction currently supports two functions. In case of the
verify and report status function the CPU will read the RMP contents,
verify the entire 1GB region starting at the provided SPA is HV-owned.
For the entire 1GB region it checks that all RMP entries in this region
are HV-owned (i.e, not in assigned state) and then accordingly updates
the RMPOPT table to indicate if optimization has been enabled and
provide indication to software if the optimization was successful.

In case of report status function, the CPU returns the optimization
status for the 1GB region.

The RMPOPT table is managed by a combination of software and hardware.
Software uses the RMPOPT instruction to set bits in the table,
indicating that regions of memory are entirely HV-owned.  Hardware
automatically clears bits in the RMPOPT table when RMP contents are
changed during RMPUPDATE instruction.

For more information on the RMPOPT instruction, see the AMD64 RMPOPT
technical documentation.

As SNP is enabled by default the hypervisor and non-SNP guests are
subject to RMP write checks to provide integrity of SNP guest memory.

This patch-series adds support to enable RMP optimizations for up to
2TB of system RAM across the system and allow RMPUPDATE to disable
those optimizations as SNP guests are launched.

Support for RAM larger than 2 TB will be added in follow-on series.

This series also introduces support to re-enable RMP optimizations
during SNP guest termination, after guest pages have been converted
back to shared.

RMP optimizations are performed asynchronously by queuing work on a
dedicated workqueue after a 10 second delay.

Delaying work allows batching of multiple SNP guest terminations.

Once 1GB hugetlb guest_memfd support is merged, support for
re-enabling RMPOPT optimizations during 1GB page cleanup will be added
in follow-on series.

Additionally add debugfs interface to report per-CPU RMPOPT status
across all system RAM.

v4:
- Add new wrmsrq_on_cpus() helper to write same u64 value to a
  per-CPU MSR across a cpumask without per-cpu struct allocation
  overhead. 
- Rename configure_and_enable_rmpopt() to snp_setup_rmpopt().
- Use wrmsrq_on_cpus() instead of wrmsrq_on_cpu() loop for
  programming RMPOPT_BASE MSRs.
- Add setup_clear_cpu_cap(X86_FEATURE_RMPOPT) if segmented RMP
  setup fails or workqueue allocation fails.
- Add X86_FEATURE_RMPOPT feature clear logic in amd_cc_platform_clear()
  for CC_ATTR_HOST_SEV_SNP.
- All of the above allow checking for only X86_FEATURE_RMPOPT for both
  RMPOPT setup/enable and RMP re-optimizations.
- Rename snp_perform_rmp_optimization() to snp_rmpopt_all_physmem().
- Split rmpopt() into rmpopt() and rmpopt_smp() for SMP callback use.
- Introduce separate rmpopt_report_cpumask for debugfs reporting,
  distinct from rmpopt_cpumask used for primary thread tracking.
- Remove snp_perform_rmp_optimization() call from __sev_snp_init_locked() 
  and instead setup and enable RMPOPT after SNP is enabled and 
  initialized.

v3:
- Drop all RMPOPT kthread support and introduce adding custom and
  dedicated workqueue to schedule delayed and asynchronous RMPOPT work.
- Drop the guest_memfd inode cleanup interface and add support to
  re-enable RMP optimizations during guest shutdown using the
  asynchronous and delayed workqueue interface.
- Introduce new __rmpopt() helper and rmpopt() and
  rmpopt_report_status() wrappers on top which use rax and rcx
  parameters to closely match RMPOPT specs.
- Use new optimized RMPOPT loop to issue RMPOPT instructions on all
  system RAM upto 2TB and all CPUs, by optimizing each range on one CPU
  first, then let other CPUs execute RMPOPT in parallel so they can skip
  most work as the range has already been optimized.
- Also add support for running the optimized RMPOPT loop only on
  one thread per core.
- Replace all PUD_SIZE references with SZ_1G to conform to 1GB regions
  as specified by RMPOPT specifications and not be dependent on PUD_SIZE
  which makes the RMPOPT patch-set independent of x86 page table sizes.
- Use wrmsrq_on_cpu() to program the RMPOPT_BASE MSR registers on
  all CPUs that removes all ugly casting to use on_each_cpu_mask().
- Fix inline commits and patch commit messages


v2:
- Drop all NUMA and Socket configuration and enablement support and
  enable RMPOPT support for up to 2TB of system RAM.
- Drop get_cpumask_of_primary_threads() and enable per-core RMPOPT
  base MSRs and issue RMPOPT instruction on all CPUs.
- Drop the configfs interface to manually re-enable RMP optimizations.
- Add new guest_memfd cleanup interface to automatically re-enable
  RMP optimizations during guest shutdown.
- Include references to the public RMPOPT documentation.
- Move debugfs directory for RMPOPT under architecuture specific
  parent directory.

Ashish Kalra (7):
  x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
  x86/msr: add wrmsrq_on_cpus helper
  x86/sev: Initialize RMPOPT configuration MSRs
  x86/sev: Add support to perform RMP optimizations asynchronously
  x86/sev: Add interface to re-enable RMP optimizations.
  KVM: SEV: Perform RMP optimizations on SNP guest shutdown
  x86/sev: Add debugfs support for RMPOPT

 arch/x86/coco/core.c               |   1 +
 arch/x86/include/asm/cpufeatures.h |   2 +-
 arch/x86/include/asm/msr-index.h   |   3 +
 arch/x86/include/asm/msr.h         |   5 +
 arch/x86/include/asm/sev.h         |   4 +
 arch/x86/kernel/cpu/scattered.c    |   1 +
 arch/x86/kvm/svm/sev.c             |   2 +
 arch/x86/lib/msr-smp.c             |  20 +++
 arch/x86/virt/svm/sev.c            | 271 ++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.c       |   3 +
 10 files changed, 310 insertions(+), 2 deletions(-)

--
2.43.0


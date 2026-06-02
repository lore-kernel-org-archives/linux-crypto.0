Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012069.outbound.protection.outlook.com [40.93.195.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C39725B0B1;
	Tue,  2 Jun 2026 20:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780430442; cv=fail; b=TZ3EuSwUwWnqvquZ/8wxK4UKSecqk4is0qAsFt5xwqD1MsuTiTxoQL0L60mM8xKPg2PLaKVbdvp27OMJNVqY2DMGYt9VjpM2FZzilj7ZARtyyk5/ZSItes9DILphl8+Fb0ps+GsgGGHafs+4a5vfreHIWGCk8qi45/VhwAzrbk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780430442; c=relaxed/simple;
	bh=bUHQ3VkekoIAyVoC0TlyRSK+MzwidFjKqiaJlrfowUU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=M6V7HCmTfJIOoSQftMhwa5JqDm3LAUtdZIXYFfqUvjNDt+4WxWsqUg5CnyZK3lBBvjXytWfty8w2OM+zNzD1m+ksLdwMt+vrmkt/GSUPZzjlWRSA7r9E9WwDU1BNQzViY5AVZQAaRdxuHqv5bO7OYLB5bXn7LS9ZeGwqojz9//A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vLUZi/vc; arc=fail smtp.client-ip=40.93.195.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vLUZi/vc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvPSKZqbGD2a9p79GoljgNHKpGissfLrWX7mo0RFtni9SiBB6H2W87kWei1StntXr8leTibhEkOH1dBbxZZ06pFMvh3PmtWLs9Txf3BWcrEj2cgFxI+PKtr0LX3HCU12A+37VeY+izi/m5K5tAhbrgEW+/j28EDSb+cOX2f6ZTvw9iIExPgwz15QItSRyxvrvNYOLO/ck1gGPq8E2MuX//VrTv4WRLvLwwJF11YLJFaahXZ0+OnBJbsJ+XFZRORkIESN8VuG4O7zZ//Biu4cGaYFufgW1/KRIi1Zlhk8PCSejZWSDs6bgL5tt8xaZHrxSL0fOCIAIgOxRQHClRARkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jlYajxkDm0qhOHAis6+/rgoMFl81J7BHBWAdsjkv/UI=;
 b=IopT0YfObFUl4bFFCCFmsBo5TzuHvNjhdR7MrcMhkRWs6S+fdyE08ck7TJgIq/kU3E6pO20BlM8/TMEzxE2iUBjomG5B/Ni10b9FLptBXp6scUMOzde4KKjV4c2NGqUmnHrGNd1szv9Jevce7TMQVDyUKaX5B8KAAHmKz/zUAF3+jiVjURwnz6JwGE1T2UeGu6LKfo5LFmf41uKXjTO2Twqg8LMWiFvO/RZmncpPxG/FQD/brJhI3SNt4f3HCZXakSXDcQazXhNXjUxHKt7y/zZhv71zAdFNtIF0p+sVLZO5F89LDvhZfjvNZe66FCQdZOsKBxax2sJ/GhYr+ZIJMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlYajxkDm0qhOHAis6+/rgoMFl81J7BHBWAdsjkv/UI=;
 b=vLUZi/vcJZ/9lH9OPK2UvwoLIusdMb0Jn4WxVKapUJEpf6yU7ZC9LgQNMceALH/DJS8EnCNMYQnlYeXOpoRFl9lE6740uPiykny/xPHE2IE1AP8qNUKgmuqyxTtBRec/FsSODZEjg57Kd9itdmYXDg7aSpWE1vkxZ8NUqxlb4lY=
Received: from BN9PR03CA0188.namprd03.prod.outlook.com (2603:10b6:408:f9::13)
 by DS0PR12MB6440.namprd12.prod.outlook.com (2603:10b6:8:c8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 20:00:34 +0000
Received: from BN1PEPF00006000.namprd05.prod.outlook.com
 (2603:10b6:408:f9:cafe::13) by BN9PR03CA0188.outlook.office365.com
 (2603:10b6:408:f9::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.16 via Frontend Transport; Tue, 2
 Jun 2026 20:00:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00006000.mail.protection.outlook.com (10.167.243.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Tue, 2 Jun 2026 20:00:34 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 2 Jun
 2026 15:00:32 -0500
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
Subject: [PATCH v6 0/6] Add RMPOPT support.
Date: Tue, 2 Jun 2026 20:00:23 +0000
Message-ID: <cover.1780427587.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00006000:EE_|DS0PR12MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ff5263e-088d-4208-6fc2-08dec0e19b96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|82310400026|1800799024|921020|6133799003|18002099003|11063799006|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	vDeRNnJevHtQ/rpKK/rsHr9Vibl0p+rvulqMjLxNaNgqcfbc4hngnLnD0c0aYAtTejnSK7XWoi+8Jw7mmDi50cUXGEX7HN7gr8VYOLUDMuQx6aNrYF+ObsFPnrl4chyVbsRP2r18CDzF1/q5BxlEsSwFrGoOe+8K2lJ0ADrljxM+PggoJ6ozWWYPoyzdmKmS5iBTtm0HnFsDka/guuPbe/1gJeGkVtvVBgCVOqc2vuaknInT+/RnR4v+e3r53Jxc+Bsokd/1tfiy4Rdt+WyNOsd6omijE082ithy/sv0++XHhn8sm7E2iPg26vVZzXRnGX81uJU0qZT3E3jIi879oovgKegsjiwgqc2vDjDm3ZFMIzM1n8knIlR8b38A5DrCHgxOzdsdBNk2h1aVuSEbLANrq46fZ6bam/o6oV/euZXdU3ez8dL629l0qm4HRPp535CyRsdWoCBnIhY0ksYSQW+arEnd9F4EIjTfJ4KteT/hdusBT2paO4cuIZm44nKjucUPXiNO5IJ2FP5PNJm+7VQN5mIYbV+zEZ3hTg5JgHRmzeYq3LvvSYUpNjxvIGnz85Y1x+m4Gza2AzvyhGbFoLdx+fsFD/cB5olDU19pax5jI0NVR/kQF58aWpiBXyzU1PPE9a2zcdXNXOjvxisLDH4yB2K/6zGzkSXhHlSbnaW126IhYKoiK3vf4sTVuv0j6xtUhH7ISYOfFYb9j7mPecMfTZVyWFvM9luyhZQoRMGXV7b+xMxXOXiVJwWOGonxk0lg6Hml/Fl5tPwrGtqwng==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(82310400026)(1800799024)(921020)(6133799003)(18002099003)(11063799006)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3R+tjFZR8BmhwdOtQRc+HOyyH0Z0nAR+29wjKMxjhJZ0DEIrk7HpMxYLQ82KDCJlSd/8N852qoTPDH6S600FvEuM0H7vVyXPb4IY3RofhVz9XHIfRDJ0a2yMZnsc1Mo/2nn5xS1X8cYgUlhLUWvmTUr5KHlkwjuvWS/qkmB7ruRAXZUHs4i2QWwIGxKErlhqohvThbQCv1Tue1U8apuxw+5Xt4JGxl4+Ktn7apC7iBrRy1vRwO/dFN8sI1nxP2rWgZK9puGqJeDzeUBu23yPIeMiXB3wFZu7EC1E/4i+tkc9GasDpqp1DFTzD14R3VYa5CsrCQRiCu8q9znUDi5tBKEbUZ15+DDX60W6lZXHV17W3/C5JUAvAyudZKvAH0XUEhBw4viey2diynruludjbL5p86iZUpyAa312VGrr3x3VjsY9Nm6VnsW47gxcH0ee
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 20:00:34.3227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff5263e-088d-4208-6fc2-08dec0e19b96
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006000.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6440

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

v6:
- Drop wrmsrq_on_cpus() helper; use for_each_cpu() with wrmsrq_on_cpu()
  instead, as RMPOPT_BASE MSR programming is not performance-critical.
- Rewrite rmpopt_work_handler() leader selection to use a local
  follower_mask copy instead of modifying the global rmpopt_cpumask.
  This eliminates the current_cpu_cleared tracking and the restore at
  the end, and removes the need for synchronization comments about
  transient cpumask inconsistency.
- Add three-way leader selection in rmpopt_work_handler():
  1. Current CPU is a primary thread in cpumask: run leader locally.
  2. Current CPU is a sibling thread whose primary is in cpumask:
     run leader locally (RMPOPT_BASE MSR is per-core), remove the
     primary from followers via cpumask_andnot(topology_sibling_cpumask).
  3. Current CPU's core has no RMPOPT_BASE MSR programmed: pick an
     explicit leader via cpumask_first() + smp_call_function_single()
     to avoid #UD, with cpus_read_lock() around the IPI loop.
- Add WARN_ON_ONCE guard for empty cpumask in the explicit leader
  fallback path, with migrate_enable() before goto out.
- Add .llseek = seq_lseek to rmpopt_table_fops for consistency with
  other seq_file-based debugfs files and to support tools like "less".
- Change debugfs file permissions from 0444 to 0400 to restrict access
  to root only.
- Add comment in rmpopt_table_seq_show() explaining why cpu_online_mask
  is safe: RMPOPT_BASE MSR is per-core and snp_prepare() ensures all
  CPUs are online when the MSR is programmed.

  Sashiko AI code review identified several of the above issues.

v5:
- Introduce rmpopt_cleanup() to tear down workqueue, debugfs, cpumask,
  and MSR state, called from snp_shutdown().
- Introduce rmpopt_wq_mutex to serialize snp_setup_rmpopt(),
  snp_rmpopt_all_physmem(), and rmpopt_cleanup().
- Introduce rmpopt_show_mutex to serialize debugfs reporting of
  rmpopt_report_cpumask.
- Move snp_rmpopt_all_physmem() call after SNP DECOMMISSION during
  guest shutdown.
- Use migrate_disable()/migrate_enable() for CPU pinning in the
  rmpopt_work_handler() leader loop to maintain CPU affinity without
  disabling preemption for the entire RMPOPT scan.
- Add cpus_read_lock()/cpus_read_unlock() around the follower
  on_each_cpu_mask() loop in rmpopt_work_handler().
- Guard snp_setup_rmpopt() against re-initialization when
  SNP_SHUTDOWN_EX with x86_snp_shutdown=0 skips rmpopt_cleanup()
  but clears snp_initialized, preventing workqueue and resource
  leaks on repeated init/shutdown cycles.
- Replace setup_clear_cpu_cap() with pr_err() on alloc_workqueue()
  failure in snp_setup_rmpopt(), as setup_clear_cpu_cap() cannot be
  used after alternatives are patched; callers check rmpopt_wq != NULL
  as the runtime guard instead.
- Add pr_info() when RMPOPT coverage is capped at 2TB.
- Add comments noting CPU hotplug is not supported with SNP enabled
  and only online primary threads are covered by rmpopt_cpumask.
- Add comment in setup_rmptable() noting Segmented RMP must be
  enabled to enable RMPOPT.
- Simplify cpumask setup loop to set if primary thread rather than
  skip if not primary.
- Improve grammar and clarity in snp_setup_rmpopt() comments.
- Added Reviewed-by's.

  Sashiko AI code review identified several of the above issues.

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

Ashish Kalra (6):
  x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
  x86/sev: Initialize RMPOPT configuration MSRs
  x86/sev: Add support to perform RMP optimizations asynchronously
  x86/sev: Add interface to re-enable RMP optimizations.
  KVM: SEV: Perform RMP optimizations on SNP guest shutdown
  x86/sev: Add debugfs support for RMPOPT

 arch/x86/coco/core.c               |   1 +
 arch/x86/include/asm/cpufeatures.h |   2 +-
 arch/x86/include/asm/msr-index.h   |   3 +
 arch/x86/include/asm/sev.h         |   4 +
 arch/x86/kernel/cpu/scattered.c    |   1 +
 arch/x86/kvm/svm/sev.c             |   2 +
 arch/x86/virt/svm/sev.c            | 398 ++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.c       |   3 +
 8 files changed, 412 insertions(+), 2 deletions(-)

-- 
2.43.0


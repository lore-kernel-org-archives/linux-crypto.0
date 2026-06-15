Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012054.outbound.protection.outlook.com [40.93.195.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2033A783D;
	Mon, 15 Jun 2026 19:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781552876; cv=fail; b=GWAUV4og5pPFMlvqKhRnAYuLU4g/dLIslGmxOGSOsoHgr3ljPIsGtoAcxBDy9cLt6gYJGAUGn0gCQfitTByVJawP9bU4Cc/uUqoKO+/9t59zTCyjlfuShRp7AzCbb7OMdI90+Yo0L72LgE/iTGtLKCQobBYOArXidm2BubcChlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781552876; c=relaxed/simple;
	bh=Bs0x8MdLsSw7nabgwdIL67i5tIbibAwlMkOXFXeIDiQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hx68OF5x5EMcjQvv2rUtrdfJddYWO3PjOlhtTxcOjckg/tWzRp3wtZQ2BIOD71vKdYne1NpA+y8IzAPTM7eAvyA2mYjnHf06hlxlvyboZF39zKC6u8GUeudDQIWYRr+R7eB6YQ0ZZrF3gJISGbBsiY+/u58wLrVMlYWs5EgoH8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rHSctB9M; arc=fail smtp.client-ip=40.93.195.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rHSctB9M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cCEl9WPtsPCeaRUpjAydZ24/QJn/auy4ZmaRQzNnX0VsBU+ec+3Qlf/cYb+JUw9FU1lopYQLs9viKxnBnyoSPAPBkVmmRnw+ib8ysaKpam04d/MWOoYFk4jj8L5hFIm1Dc3MajQh3Qk1kWaa5NicyJpZ2J7TOgh5Tvy5qejyb5FwWywPX90qGZT1+cagAxs8HWlXXWE7aM87LyRoRXPepi1kmYqfdPZMSsgn1uRI9e32hqJcUZOCp7/jfli1JgUwtA6dcxmEQYwQj35NAH2+CI975uy9yoHy/8u8Zn8F7CUdndR4xEBUBxy9n+LtGHwI1t3QcogBmfIsGFeL2YheLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5kZVxqC76XTwBaZ9PiZBTqh9WqG8fUHPFzKvsr94kU=;
 b=UgUrGHpTzA2+CbK6U/2RDruYvawFKoYjkjll7g6bz/gC6cTzHb54Z0ziSEHjvXegP3yRIeAuQK7WfYucQraeRMM9xM0Md2xHppZJLixS6ef1c18HABVV17hNz6LGiRi1MnmdW1HdSQjAPekGFVdESvytnxkLikXZ3wR0a3KnqbbRHQDcu3w/Pj95kvY1ewHGGTVonVCR2zjE0i/M4j3J2tpNc1DOjybsTA5nizEN+kTrnxf+fBM+xFjFveKV1SXuAV63slj7nENuw5e7pRSpiVbzbr4ypjfBBgzVjTErRcYNgvBuOdSLIL2vqDAFG0WX5JXKUh5oj7gcyC4sHjZtRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5kZVxqC76XTwBaZ9PiZBTqh9WqG8fUHPFzKvsr94kU=;
 b=rHSctB9MJwOCC4JutHnHrKROfgUc4PA419cqmVN8D2Q38huI+BW8iY+FPsR0WxS1xIK/cXXHddBUz5Fyv6ijeQZgo8EbMdw68bhbtzkDVDQ8D17w9l1UqkikSzjZjtTFYI2tkqf5Vu9GObtrCsdLTzFpqcaG2ZY8vXhMkNqq/p8=
Received: from MN2PR06CA0015.namprd06.prod.outlook.com (2603:10b6:208:23d::20)
 by PH7PR12MB7869.namprd12.prod.outlook.com (2603:10b6:510:27e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 19:47:46 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:208:23d:cafe::53) by MN2PR06CA0015.outlook.office365.com
 (2603:10b6:208:23d::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.18 via Frontend Transport; Mon,
 15 Jun 2026 19:47:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Mon, 15 Jun 2026 19:47:43 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 15 Jun
 2026 14:47:42 -0500
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
Subject: [PATCH v8 0/7] Add RMPOPT support.
Date: Mon, 15 Jun 2026 19:47:31 +0000
Message-ID: <cover.1781294296.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|PH7PR12MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: cf0c81b8-177c-4c90-1644-08decb16f7b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700016|82310400026|376014|23010399003|921020|3023799007|18002099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	2jtGbp+PiU/hBTegy+/3V6r0TrM9wgB8wpxPQQruOCprqBy8i3302xF8ebkd33JGvGps2u42kLMbyG9RJIDPQGLRerMGZ3rKx6sTMAdIbajV1dFAkvGZKYjCe8Ica9ROjknOiVamPuxYNnOsC3SeJWQpF/IGOUWsf9/NnMQa4zbcbLHf6z1zxHJna+CWJ8Y8Nf5mzlWRyPhIZnKOgsPZjf2KpOrDtx4wn+pIEewzBp5ooPFUgy23oKjqBz3daKLhNZd8QnqT3UJZouIxYgapfP5y1XJjDvb5tu1W6hZ5O25Pfd+SRFdaPl05N5TdXAPzXnEGejIFreRHf/fqX1OmVLSbqYlPYh77PAETOMnFSDyBJ8v9kV/mpRhCD2Wx3TDE3cp0kaHiTGZD7jz58cgoE9ykwaxRY6T2LIZfZlvT4viHAC2B0hDQ1p5L0ax+50y128MYeAWvATqE7/nvmZ11MWDjbTeIkhYai6CNqQyCbK+fix37i7hnghPCZUp6Mxa9YAV0lcuq8XIGUItzGd5oD8plL/sYl22ucii4ALX9TfcEoSi1SqZZDmETiU7nrLWlgGgnDK6KQdmfJ0gxbOKFF/Bg1r6Hs4yx33eLT9ONCezBVp+2OuTnsVw8R2shzstM8m6Ue86dk3CHlXWkuRKIrrDEYvl3/Ll4Y/pdU/TrWG92OltyK1gvvxsCWZC4IQ1C0YcVpUkk7dpYCImoMRN8e7akGe3UX+dNe+fUNhclSRgxMQ8dsqidO3nCmHtnHtcD9UtdMmqbpmpUwW0FjtP9yQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700016)(82310400026)(376014)(23010399003)(921020)(3023799007)(18002099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PPHpBACXWre0geahhGa/lbNih+ka96blCWz2EG/jDOx5KoxTTgiFGIbJ57UPzVu7GE1WDXyPLHIewzDkJg970IwC+KtUBsvw6GeGgX43G9ji3mPrthJPbniLfzFLdCChJl8jUuvJMV/zLaIvyaEzQAIba6I8f8MnGXqjO4RDtioC3m7jMFAxvArStoB/87JgS0hbLhYe4p3BRKdF61r2/xuhya87E0RYwpcm+uy+V0DBpKjOIeDzC5GHfWMzmhCv3IhRnVQJzilYSnTE98kVJuiKVgGH+y5xV9+0aYSn8hOxiwjXsewom9t/1b6Jwzt2aurvb9+DKS85M+2IuZ8BYP6Ij9rp8X/RH/de7DUoyWLmMZE4emKvWE4qbNVwiXVOPin0mWt82oblEq3AoJBbIoAqzwSEynEV5Unp9PtVVbiG7Czp26MCqUzhYEVMdIcA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 19:47:43.8296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf0c81b8-177c-4c90-1644-08decb16f7b6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7869

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

This series also adds support to disable CPU hotplug while SNP is
active, as the SEV firmware enumerates CPUs at SNP initialization and is
not aware of the OS bringing CPUs online or offline afterwards.  This
also keeps the set of CPUs stable for the asynchronous RMPOPT scan, so
the per-core RMPOPT_BASE MSRs programmed during setup remain valid.

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

v8:
- Add a new patch to disable CPU hotplug while SNP is active, keeping
  the CPU set stable for the RMPOPT work handler.
- Drop the setup_clear_cpu_cap(X86_FEATURE_RMPOPT) calls; the
  rmpopt_configured bool is the runtime guard.
- WARN_ON_ONCE() on the RMPOPT_BASE MSR writes that previously ignored
  their return value.
- Run the RMPOPT leader scan via work_on_cpu() instead of
  smp_call_function_single() so it executes in process context.  This
  fixes the AB-BA deadlock between migrate_disable() and cpus_read_lock()
  and avoids running the long RMP scan in IPI context with interrupts
  disabled.
- Use mod_delayed_work() in snp_rmpopt_all_physmem() so the batching
  delay tracks the last SNP guest termination.

  Sashiko AI code review identified several of the above issues.

v7:
- Sync tools/arch/x86/include/asm/cpufeatures.h to mirror the kernel
  header for X86_FEATURE_RMPOPT.
- Fix commit title to use X86_FEATURE_RMPOPT to match the code
  (was X86_FEATURE_AMD_RMPOPT).
- Add static bool rmpopt_configured, set only when segmented RMP setup
  succeeds in setup_rmptable().  Check rmpopt_configured alongside
  cpu_feature_enabled(X86_FEATURE_RMPOPT) in snp_setup_rmpopt() and
  snp_rmpopt_all_physmem(), because setup_clear_cpu_cap() is unreliable
  after alternatives are patched.  Add snp_clear_rmpopt_configured()
  called from amd_cc_platform_clear() when CC_ATTR_HOST_SEV_SNP is
  cleared.  Do not use __ro_after_init on rmpopt_configured since the
  writer snp_clear_rmpopt_configured() is not __init.
- Add cond_resched() to all three leader loops in rmpopt_work_handler()
  to prevent soft lockups on systems with up to 2TB of RAM.
- Add comment above __rmpopt() documenting the RMPOPT instruction
  encoding (F2 0F 01 FC) and register interface (RAX = system physical
  address input, RCX = operation type input, RFLAGS.CF = output).
  Note: RMPOPT does not modify RAX unlike PVALIDATE/RMPUPDATE, so
  the existing "a" (input-only) constraint is correct.

  Sashiko AI code review identified several of the above issues.

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

Ashish Kalra (7):
  x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
  x86/sev: Initialize RMPOPT configuration MSRs
  crypto/ccp: Disable CPU hotplug while SNP is active
  x86/sev: Add support to perform RMP optimizations asynchronously
  x86/sev: Add interface to re-enable RMP optimizations.
  KVM: SEV: Perform RMP optimizations on SNP guest shutdown
  x86/sev: Add debugfs support for RMPOPT

 arch/x86/coco/core.c                     |   2 +
 arch/x86/include/asm/cpufeatures.h       |   2 +-
 arch/x86/include/asm/msr-index.h         |   3 +
 arch/x86/include/asm/sev.h               |   6 +
 arch/x86/kernel/cpu/scattered.c          |   1 +
 arch/x86/kvm/svm/sev.c                   |   2 +
 arch/x86/virt/svm/sev.c                  | 437 +++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c             |  32 +-
 tools/arch/x86/include/asm/cpufeatures.h |   2 +-
 9 files changed, 484 insertions(+), 3 deletions(-)

-- 
2.43.0


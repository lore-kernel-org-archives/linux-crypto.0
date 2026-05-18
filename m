Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011007.outbound.protection.outlook.com [40.107.208.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77451396572;
	Mon, 18 May 2026 21:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140514; cv=fail; b=VoCnP+AMffwATD4G6Tsmsn7DUFofnJnOf4LoD+ooWIVFEpKzBkahmpUetB7Hcw+oLJ6RvRTva3CGn1KVR79q+HEZKhoDy/Nafj9/qAAfXPrpk2bg5+ZohDQsh3A7xmNrYZzLRaw3OSDAWe198fUzQH/uv+HMqxGSd/StVPH1kHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140514; c=relaxed/simple;
	bh=RnelbY8s5xLbtNLQumvnBW+sAL2B9F6AYKT4j72Q9E4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h6zsE7rygfdyCTWRN5foq/Y2ZU79km6xkNrQLlBQRWApGXHBUSrQsu4qpvWmUwhDH7/9DhifHO36vh7luTOK2uhhH+6kmfzIqy424/UGZvXmsWv+aSY8CVFdKyroDkT6Z8RGfVkltPLoglTDEaS8lewhHVIwnOkdUZK04P66ilM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AzZE0SDf; arc=fail smtp.client-ip=40.107.208.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AzZE0SDf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HoXDosAbtSHq4pN/KD/TbSuuKw548ODRd549Wrix1zmDBHKFedvL+Jg+YiAQfSJBIiiO84IOkYE+fnBa5GBJSCrXhNJTkgt1uqw+BuEshJ0LMw/B3r+FYfzKEKPp8OQeSGWMlDl5Ch0Jz60pvt8O3ejMnF1klrq0ncG8pWSrojBrX/2y0OjXEuTJOBJKNSPO1IGz99jVJpY9PdsbIJRL9/R160dRcWC33XSWfvwXo+xReCR8VeYKhiKhIH5vFIeYAik/pXHUNSS0BUxPkGkHYRXKUHD+dHqAF//3dq/qBmEJeWWS/zN+fyETRrYgXYtEJPN2skUaX12/WXoQsXXIUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DO8byeqKzl/Qf08PLEWob+YXrpTqBb9L/V8K0qpNX3I=;
 b=h4zzyKpHWTTBnizkbD/d1jGPNK0P8TPLkExoJqHyUIx8itRn+Fj5XqoBAdXylOS/wOpw5+LXLJcZyyy0vnn60RZVFJNsBkmaGqhwRSlr/bxWCWTekkODmd66x1fYkbfttItJg7iDtt6etnMgYWjIwJYWwm/l4o4lcZD8BGKqHXPHitXU1jOssyKI+UcIFikwep9qfZGKnOqmn0rlJdEWfj3t4+wNHo9BKcYyh24I6chNRqDro0oxtqowSTiaCgQzPLP9RRyrF3ojxBnOOZ94q9uMZs5nLaPf1o42GYhm2iaQewlshWv4T20oMVn5bsKl2wmLPcKa+FitDS6/PIXtAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DO8byeqKzl/Qf08PLEWob+YXrpTqBb9L/V8K0qpNX3I=;
 b=AzZE0SDfPQ4yjMO+Vu/U1uMhQ4yDzml1aug5xBstMsydFg34azfYfmrEk7lMLcVbT+0QyCsKLkfeSOJrUWShfOtREMZ20t8Npmod8UL7burL0GGGEqrWwmZlrGbsOazAJY9Brh2aY9qZGTBjiQQu1I42NlrygaPzbzysxDjHYrI=
Received: from CY8P220CA0033.NAMP220.PROD.OUTLOOK.COM (2603:10b6:930:47::23)
 by PH8PR12MB7206.namprd12.prod.outlook.com (2603:10b6:510:226::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.16; Mon, 18 May
 2026 21:41:44 +0000
Received: from CH2PEPF0000009A.namprd02.prod.outlook.com
 (2603:10b6:930:47:cafe::7) by CY8P220CA0033.outlook.office365.com
 (2603:10b6:930:47::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.24 via Frontend Transport; Mon, 18
 May 2026 21:41:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009A.mail.protection.outlook.com (10.167.244.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 21:41:44 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 18 May
 2026 16:41:42 -0500
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
Subject: [PATCH v5 0/7] Add RMPOPT support.
Date: Mon, 18 May 2026 21:41:33 +0000
Message-ID: <cover.1779133590.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009A:EE_|PH8PR12MB7206:EE_
X-MS-Office365-Filtering-Correlation-Id: b951beee-273f-4d4f-59a5-08deb526416d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|376014|7416014|921020|18002099003|56012099003|3023799003|11063799003;
X-Microsoft-Antispam-Message-Info:
	KJvLUNGDWfU2xSmL5s3nnfvJIZfefHJgM8pHdGtlzckNfGM65rTfBJ+1r23rD0P1xZedWfJYq/qixad0L6aFvrNq4XrK5b+Z01ouZGqU6D8iKcgcpRbsajUCBD1kMbmXc91EpAxtFIt3Og1+ObwFbdLFmli7po4/6tV783cwXgT1FRIaAPflHzASnVUc6xR9caxdjsJneTL7S1KpxIcE8l8eDRpvj02u5DKghQWzJfZfCVa9jS4BvB6ApSGp9/nIpaCh0j0T4kv0xlO5K5VsXFtWQ7JQB8qcFkBtKmhGsWaPkoOMvhlEoWGtQXJ9FzqaV34b8ho5ZPWs5gwDuif5lX6aWy3LjZxEPdjg4Pp//b9ePDEnqZK1EK5ofm0BMsu422PrkBsZ2jHIdWfCSHet8LtvumEhw3omBYwZKNaloi/n43FbOnYmWzHt+9rUQrj4KiSxyO0wCb18f0JLsBpRjZME3YCaW7L7DUJM35GRhlrAN/D26VrKcAT3zx5fK2N6pYDYon1VaMdjn4b+mbsTKpGPMRY6leksFPfTmHROpcbBUnR0xK3qvM1heuwxQXoeDdBlXlyXdJVrIbLS3OCjoeHIka0FbXzoQSae1eTOrqfwj8TRfnHlnVmAia48uOhmTCfK5X01ROUwkMushK0r77i3K7U5aIkJK+CyiILiKwM2an3NiMastu4/W+ttThapoc/TARmdBRGrQ0z0JSRGFv/QM+YWX6J0Id2giTGw5XUeGxEd/PzipBZqtLuDqQWcsIELvLXu0pCB0BR/HEFNZg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(376014)(7416014)(921020)(18002099003)(56012099003)(3023799003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0JYi/C+cLBjePnDaZbUoKYdP8Xxg/pOzZee8gdMcdPbVD7jU9gR6y2140VJwCSyOvzr6xGgai3R43vW0qJc9CtpKcktyhqShJZ6ISH4thrJRipwTQtbjPjMkT6fEMDchCNRs+t9+XNnHuyCAFmsaVkkeLRtel3Y+o0ZL0y3lHTZS8bG98t9zbWmukqXzBYQwQuQc2t9E6Kk+hb7Ipjg04PQhk8/oPklhAhod5C/53eXO+VCyhpsm083eNfYC5IdvjMQvjcUQzmQBB8aPALpZXLx6Rfm8jLw7uH8ZdaNF7mcaWGLv5KVGJ9rEbvbBKwsVB/JkBmv/d7CkuYSRYDT/wF+43DkPAHDB6HmHIsXaLI7jxrsuxHSVwxZr++B2ws8UeSrHGDCn8zm3G8kl4NbOPP/YFd9f6nYaBo8eN6qYyfxDWk4/68UHif5FeVyl2hfy
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 21:41:44.3715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b951beee-273f-4d4f-59a5-08deb526416d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7206

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
 arch/x86/lib/msr-smp.c             |  20 ++
 arch/x86/virt/svm/sev.c            | 356 ++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.c       |   3 +
 10 files changed, 395 insertions(+), 2 deletions(-)

-- 
2.43.0


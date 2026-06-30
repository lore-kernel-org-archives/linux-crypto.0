Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013047.outbound.protection.outlook.com [40.93.201.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A297512CDBE;
	Tue, 30 Jun 2026 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782842953; cv=fail; b=JG/+Xbcvd2IiqrcshtuflklTN9cHB0h4WgaQRt2KsNujEjBNNsiq0saZvN/R+pQjgcw6I0BiX0USe42TTv6d2yJksCpRCiZHtNjeLeUCF3nHbt63qYoSn6NvCWfHn4Se4UoLMhnBLUNjN3FZz6ce4sESgxE0BJG8+I0BFDNxQ2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782842953; c=relaxed/simple;
	bh=r9LjNMJUU6eeW68Btd99C210GZKHcf0tN2wUhALjGvk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZeEkQgEzToPhemNg/D7TbWDz/DZZMk54vIgqGT1Pg/RyNeVngv4kCU48IupiXe9TaS4m2RgWSmHCyQMO4pzo1RDPkc7GUbJlUa/o88mzYcGmrqwVRbk4RMs1Yk3Lde3tcHoBngBULvtUD5E1hHvjjHw396U5QRHUAcbnIwYpJqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=H/UMc+gg; arc=fail smtp.client-ip=40.93.201.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="H/UMc+gg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nj1QYQenRJey5lGm0bl/Bx21hv1djAY9SScXP5Ig17CEnGz2jF03ThIqVZRebHDjZ/IRowgTiLDyymOMGrPoHiJbca9IqlBOEERRbRy6JlK43dg8mVvsbMX1eHwzNjskx4Nr/pEzHiHpqNr0YlYObDYpVzZOtRBm09dDqlrw/71fF0WvRitGmY4p02oNdpn1o3aIGozORoXk6ydMh9lKySQSeybViqr578c9KHL4F9CpME7vLTPG+5P3A9A0g3/HbRBFr+vIob6SIFK0wnRpIyRDp62NOgK48rh4zIxuIL2ztWcv/MMlJ9GYHgg/BKE0FH7rMY14vjob+Y76la35Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/O5m2nTqoZBS7wxGTJQBA7iLLeUhTDcS891J9TkEZbA=;
 b=Fc3BJG9HyxMek7D+61TpqclJrDKWyt89AkN7+I9WN5ul160xpD2Uh/a7b5DLeu9I9jZr6QUZJP1oW1iRAA8KE4PavwSLd1xyQHxZC+7lMD9yqSszuYolIiQ/zV6rBIksk3lnawa3zBWbQdIwrvEjc5yWo/Jhn+3I0tnKiIPZvHRetCbh/NlE5L8Yj2axnmyAS3dfaNjVoOyo61uFcI+cHw3vbhXH+M+SPqZLXo3/lGM1/elb1J406MSwECupax2gRzmtHYlic+tH84FEH/gV8+HUQavUD3xtYeCvHcJEvvCjj/4mg7okEYmyaDs6prRcHWRBqr2LSYb3Cj8IZ9UxsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/O5m2nTqoZBS7wxGTJQBA7iLLeUhTDcS891J9TkEZbA=;
 b=H/UMc+ggJmlS/d2EQYGYMlLBS+nCK5b3GlIEqYsaYKid0heCCYobM03Ki5eJ/ipoEMpgWh4yDD+VLV5lPzf/Ozf8WxlnV8ir8lUCNBlAjPEYtQYPByLcrVcXcGLwlwaaiK+hFMg0AmlpjqlT36NMC/oBBIBi7EFicQYkN9e2FTY=
Received: from BN9PR03CA0726.namprd03.prod.outlook.com (2603:10b6:408:110::11)
 by IA1PR12MB9498.namprd12.prod.outlook.com (2603:10b6:208:594::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 18:09:00 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:408:110:cafe::8e) by BN9PR03CA0726.outlook.office365.com
 (2603:10b6:408:110::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.18 via Frontend Transport; Tue,
 30 Jun 2026 18:09:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 18:09:00 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 13:09:00 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 11:08:58 -0700
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
Subject: [PATCH v10 0/6] Add RMPOPT support.
Date: Tue, 30 Jun 2026 18:08:37 +0000
Message-ID: <cover.1782841284.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|IA1PR12MB9498:EE_
X-MS-Office365-Filtering-Correlation-Id: a7940975-b691-4e4d-a847-08ded6d2a92b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|23010399003|1800799024|82310400026|6133799003|921020|5023799004|56012099006|11063799006|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	XWwvK6v4Dkk4oCTWl8b/UevevRJLFRsJ5Hruaz7Om6ay6aDXpAru3RoSrOdojYJ/46z5SNBrS9ppukKCy4a2bev16vPL7nMSz/8yZRt55xRK0nhiW0NGfjc3Ut2G/mYgQ3P3qXWFXb3DR04AOHz6WdZm6BR3hV56VoQ60uv6YQmCkPyBsliPvlyvliHN8p3j29KuDmm9NNsR1RhCganlF5iY1mEY9m8UKZ4FHITDM5EG8F9Nil+Fgtyp9HjApVE0IFnMku87O4crj6kobVMCxl1dAErq6dkNZbN/Scv+qaOLWxJpFUct3HO8T8dqHKl8DWIcgaZdQJXXT5NzmszgLrTpgGBEjrhAAvSmtlNhA7k3mBav97UEUfJeUUaJ+fld/BfyJsyRr7PjYALaLXFXzyIkOtKAYWAjXuofCbMYUeY5Q8l2ysxQk5WcFCDtntUcG0gxGVKdwUWH147J/vstHnS2yM4k9dgrB3Wna8ZQBYZY2pG82daB0IOEnJN51G2+0wc0Y0OX0P+nUm2sO+E+eRZbb+mfahqRxC7UmUR69T2RIJ0B3mcMusOJOIx25G5AXpQhdF604JHjN0IXH9jo8Qrcabt9hgzWzU2n452meXqMogHopPNv3N50RScUznclPv9+DbGKV+dwpcu6VSxB9oGUvuzAagLqrABxy7e+pxfOTUoWIZeK1A75LUsYqFuAKA+PudK9ZitquLoswT0lxIWagckW9y0u/QMSbdoch0jjjWTIIwDheHvgJ/8soEaL
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(23010399003)(1800799024)(82310400026)(6133799003)(921020)(5023799004)(56012099006)(11063799006)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	k0ZsFdUft6sw5LJKxzppA3MwHS9YcQEOB1sFRA2jMnx8dPWHlutcae6vBv1Nt7MzvWhxYDBL0rQZhbQr+YXzvgaEIx4+qtZ1mwwQlHjyjmhrFaAhs0NA/pElxmgKLzf846nTDEXXN3yZFHWnxzYZfflAbOjW2czpw5/ia1Shq9TqBIL7N4goSm7R4GkRj3DlEuJ/smNFlEsecFZZ8qGJnPs61aMprllmjVVZ+wH0HFn2B0uPqFMYmrq/CkEbM5xelqDAKogKckiAZ6LiBgNeevMDRJE9Pit6sn9kzg4jnpiV2Uqc769AUHV3NvO6uOVMVPG0lVITHZUIWhQhM4RtDiUSXJYfqR78BnlZVBeompHNMbL2jWDdS//72m67d9DRF060el2SpXYDLkptkRb+h3yBcq4gOT5PXXbRG7CceR7mraE38w4QW7gsVTjJ59Fw
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 18:09:00.2594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7940975-b691-4e4d-a847-08ded6d2a92b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9498

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

v10:
- Rework the CPU-hotplug patch (3/6): disable CPU hotplug in
  snp_prepare(), before SnpEn is set, instead of late in
  __sev_snp_init_locked(), so no CPU can come online without SnpEn during
  SNP initialization (per upstream review).  Tie hotplug to SnpEn: it
  stays disabled while SnpEn is set -- including across a failed SNP_INIT
  and across the legacy SNP_SHUTDOWN_EX path -- and is re-enabled only
  once the firmware clears SnpEn on the x86_snp_shutdown path.  Drop the
  separate idempotent flag: snp_prepare() re-enables hotplug on its own
  early failure, and a kexec target that boots with SnpEn already set
  disables hotplug once in snp_rmptable_init().  Reword the commit log and
  comments accordingly.
- Emit a pr_warn() in rmpopt_work_handler() (4/6) when the follower
  cpumask allocation fails, instead of silently skipping the optimization
  pass.

  Sashiko AI upstream review identified several of the above issues.

v9:
- Rename rmpopt_configured to rmpopt_capable.
- Make rmpopt_cpumask a cpumask_var_t (allocated/freed at setup/cleanup)
  instead of a static cpumask_t.
- Drop the v8 WARN_ON_ONCE() on the RMPOPT_BASE writes; use a plain
  wrmsrq_on_cpu(), matching the SNP MSR-write convention in this file.
- Disable CPU hotplug with cpu_hotplug_disable()/cpu_hotplug_enable()
  (per tglx); re-enable only on the full x86_snp_shutdown path.
- Simplify rmpopt_work_handler() to a single leader-then-followers path:
  with CPU hotplug disabled while SNP is active and snp_prepare()
  requiring all CPUs online when RMPOPT_BASE is programmed, every core is
  always programmed, so the explicit-leader fallback is now unreachable.
  Drop it along with the v8 work_on_cpu()/rmpopt_leader_fn() helper.
- Drop the debugfs interface (was patch 7/7) and its report-only
  plumbing; observability will be revisited after this series is merged.
- Restrict snp_rmpopt_all_physmem()'s export to the kvm-amd module.
- Use scoped_guard(cpus_read_lock) for the per-CPU MSR and follower
  loops.

  Sashiko AI upstream review identified several of the above issues.

v8:
- Add a new patch to disable CPU hotplug while SNP is active, keeping
  the CPU set stable for the RMPOPT work handler.
- Drop the setup_clear_cpu_cap(X86_FEATURE_RMPOPT) calls; the
  rmpopt_configured bool is the runtime guard.
- WARN_ON_ONCE() on the RMPOPT_BASE MSR writes that previously ignored
  their return value.
- Simplify rmpopt_work_handler() by removing the explicit-leader
  fallback: with CPU hotplug disabled while SNP is active and
  snp_prepare() requiring all CPUs online when RMPOPT_BASE is programmed,
  every core is always programmed, so the running CPU can always be the
  leader.  This drops the smp_call_function_single() fallback (and with
  it the AB-BA deadlock and IRQ-latency concerns) and collapses the
  leader selection into a single leader-then-followers path.
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

Ashish Kalra (6):
  x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
  x86/sev: Initialize RMPOPT configuration MSRs
  x86/sev: Disable CPU hotplug while SNP is active
  x86/sev: Add support to perform RMP optimizations asynchronously
  x86/sev: Add interface to re-enable RMP optimizations.
  KVM: SEV: Perform RMP optimizations on SNP guest shutdown

 arch/x86/coco/core.c                     |   2 +
 arch/x86/include/asm/cpufeatures.h       |   2 +-
 arch/x86/include/asm/msr-index.h         |   3 +
 arch/x86/include/asm/sev.h               |   6 +
 arch/x86/kernel/cpu/scattered.c          |   1 +
 arch/x86/kvm/svm/sev.c                   |  10 +
 arch/x86/virt/svm/sev.c                  | 277 +++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c             |   3 +
 tools/arch/x86/include/asm/cpufeatures.h |   2 +-
 9 files changed, 304 insertions(+), 2 deletions(-)

-- 
2.43.0


Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013042.outbound.protection.outlook.com [40.93.201.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2729282F06;
	Mon, 10 Aug 2026 19:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786389680; cv=fail; b=Um+JX6Frzt+1YvMR3KljAm5Gq36r5/eMrzgh4EWJmuM6bkCCa1kmj53rNh8L2e9qH+A/xce0H8y3IeflFd/WYTyZaL6rixV/3kS5IOjtQve0A+AmUrGqUclUIayjv4C9rZ8p/t7natWoGcKhAuJsoN/Fxg0bBZ0pILbl6aaTpUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786389680; c=relaxed/simple;
	bh=hIlKTNKRbfZ8b7HI8+bgBTPUlxjAdKyY3ovk1Pf8I1s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bpbjp3MCjxF7UC6RuYbp64w1AAeQbehf1ns+RkuT5buHrrn0aQTEq1TnRyaWnkEUwTNzeKzD/10LhwFpsnPGmwe4CjDULMTs4xj3xUNHVvgb3ZDgNk0629iDAfzCW5XTf8MV7vl6fpt/nH7NQwhNR7BsFspWUJlSfPFURozmEv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ALSrhrDS; arc=fail smtp.client-ip=40.93.201.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ALSrhrDS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rU1dXRMAHZslU9kHU8rbPC7Y1dsiJp5Xk/CyyZ5EmomTDAcLNui+b/2dQSnWoeBUxv0wNih47X1JSNorDK0W5QVw1Mn21SUGlYvZ5WguIMOfTwhJQ7e0LCO+32/erqUzT67h0gjU70GUiije2Qsb31K0vyaw3armVdjf7jQCQeLnGS5pDU/rkezaGBN8fdrVXOn/lTZPgPA1zmw8LIvhBAYDwgvMXoS3iEfi3MCTdSRs1QXY1laqysq33gEy2cZu4KIRO59szFxqRWjETzR9paG6NQDz9oEcKDom1flmVYbWFGlTKdWagt5yoQ9DRCr/1AzGC6R2e34l109Q8cMPlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vyeLaDzXxChJGKjTDeCV8xvnEKYpmzvi7dua0Usa8WI=;
 b=mKVkyNWG4GuPtYHj4FwnDLAIuhsQl2Hcbi7L/XXAPE+DsJbY7WiWaJOczIWvAWElfCUrRkTw8cMKW1XCTXFPydV6dLJOd0FgK2ScmYZ4LtD35fZaVWHlWtyOoI6qUxn7l1knu4FcCyeOsM4DZ8b3yHdxuDYvvm2zI489ub8s3Jn2byAn4KeNk4u+5ONP7uT5htm5WiSNjGV0kcxTnkVx10HXuZrrTB9J1idwOKuhlIaJ4OygxqNKlOSoxXhENKa1gCQMBT8+i5NXcPE8tB0Snz2/4thtPZ/VUjW8dQqQX2LxRuX0nng5qK88eHk5a2z4/iptprbdMWVYnX6vUdJTUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vyeLaDzXxChJGKjTDeCV8xvnEKYpmzvi7dua0Usa8WI=;
 b=ALSrhrDSrwZMjm6VFri9Rrijkj4LDflqGjrQUtRxu789/Ub/g7Qy2dGyp0P5dU8nWnpIOXsnZG6PFsUlfBXu/WBGgtkG1FNr+RuZ7jyvMHZj0ZSGRaIQQy2Hhg7mmsPz6uaWC7VIkIyLm5Lx1j/EMQKcGIvW5A3STYNcAAn7jBI=
Received: from DS7PR03CA0076.namprd03.prod.outlook.com (2603:10b6:5:3bb::21)
 by SAWPR12MB999267.namprd12.prod.outlook.com (2603:10b6:806:55f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 19:21:11 +0000
Received: from DS1PEPF0001709A.namprd05.prod.outlook.com
 (2603:10b6:5:3bb:cafe::2e) by DS7PR03CA0076.outlook.office365.com
 (2603:10b6:5:3bb::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 19:21:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF0001709A.mail.protection.outlook.com (10.167.18.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 19:21:11 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 14:21:09 -0500
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
Subject: [PATCH v12 0/5] Add RMPOPT support.
Date: Mon, 10 Aug 2026 19:20:58 +0000
Message-ID: <cover.1786389115.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709A:EE_|SAWPR12MB999267:EE_
X-MS-Office365-Filtering-Correlation-Id: ac9d940e-ed7f-4d7d-758b-08def7148989
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|36860700016|82310400026|18002099003|56012099006|5023799004|11063799006|3023799007|6133799003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	dHnCynhA8YnGpMyeG9SGkZyH9vzEpHbkQ1vK7AoC1dobBnodFxL26Z9sqgt5BsBqwj5XUQkhceAkaBSLoLUX7o8DaiLpNLHh11tG/sJHghVvn6c8a1H8nM7h1uDO17EpKoKG6enB3MKO52OAAfVEaDmRQpQy1TB+6TGKm9Lqy2p5Jw+apm/zXGSwqDVH60Xf2/+bjmNkh9cYoJEq199xw/wxL644z1Nq/FGf0Kk9rQZ4CZxTPIauiW1tZ/pGWifeaSqx6our3veVR9Rts1riSwM6iD7R7JAdS1HX8gI1jAENXcXBw/xVHEmQ1ZSx9fpLZ+snWMm/UucyfYp+JTi0aNxW9a0l7MX8sTfcHlnppeQy4OP0Fz5W1XuhCDrnSeLuNtjB4JfvPV0mHohpj/J8SBj+GO0z/F7zICWm/8fnroi5PXAGrBmmKDS+BX5msjCM60/70OYQCPGA3eEb5Ih6+AKwdEdfcTyt9Tf7bZB3SrAm+N4qOl6ZltAsQR9jmodbd/GgZp2V0EmGtv3dhjWlsgkWOOlW4Ntqw9NTE2oB2iwiEI5WRXiRY43Mt5c61IZOIPqE7zqKVVHvjjCQY0zoEJ/9FZNr1poOfPmd2/0frn9D9h/7uN5sIMEq+K2bWpBkoOyv7Oz0GmDg87DyzHCMcop4O3VFXF1d8uF4qgtotgNxNNu41K6bWV+FDzuqLsBB8QmEQoSynqEtMfk63v/NyYC7liTsjsSRHJXDJkQr7NJYeMELSxib7gcZCPNyizwt
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(36860700016)(82310400026)(18002099003)(56012099006)(5023799004)(11063799006)(3023799007)(6133799003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5YlATkdZMUBkKTRU4EFcXqWIaZY+spDeQFz62r8kl727RljxDCcWHk24YBZlZcP87/SI6pJTtZOh+6vpXzOwrdQP6Qgs1vYZq4K2Yi3mCmi7dnyHSOqQqD+i6G+aVrTxwf7C/6+KecTu2TxKhgl5ICHGOGh6oPubzjK7km/DJCGteuq9qO7hdfhFT1rSW/jeVNF2uz+VuQUmKr1TUDQHDMRyTKVF7ePRf4JYgk4O/ZEfR/5jprs71Za8g3jUWcdDhr8yVihH6bI85SzcMYscUzRBPjz4ucrb8A7kwHJTpzKcEA3Kpzcc5a0/2caP/AsYGsdNkXJBFoL/c+8MajUvVWrUt3DVaKrF2jUHlbHr6ORQfufzfixKV5P7z+mMYhlYo6eOqMq1ZZVG5VMuqjgqye63awFavSscdYkfH5q2kyg6cFUMJhL2Jpaj44xsGuZI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 19:21:11.1358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9d940e-ed7f-4d7d-758b-08def7148989
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999267

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

v12:
- Merged the former "Add interface to re-enable RMP optimizations" and
  "KVM: SEV: Perform RMP optimizations on SNP guest shutdown" patches into a
  single patch (now 5/5), since the interface has no user without the KVM
  caller.  The series is now 5 patches.
- 2/5 (Disable CPU hotplug): drop a stray reference to later patches from the
  commit message and trim the snp_prepare() comment.  Move cpu_hotplug_enable()
  to the end of snp_shutdown(), after clear_rmp() and the mfd_reconfigure() IPI,
  so no all-CPU operation runs after hotplug is re-enabled.
- 3/5 (Initialize RMPOPT MSRs): restructure snp_probe_rmptable_info() so the
  contiguous probe (which clears X86_FEATURE_RMPOPT) is the common fall-through,
  also covering X86_FEATURE_SEGMENTED_RMP advertised but disabled by firmware.
  Move snp_setup_rmpopt() to the end of __sev_snp_init_locked().  Give
  snp_cleanup_rmpopt() its own short comment in snp_shutdown().
- 4/5 (async RMPOPT): document the optimization trigger points in the commit
  message.  Rename enum rmpopt_function to rmpopt_op_type.  Merge __rmpopt() into
  rmpopt() and replace rmpopt_smp() with a new rmpopt_scan_range() that loops as
  the on_each_cpu() callback, so the follower scan issues one IPI per core rather
  than one per 1GB.  Use u64 for physical addresses.  Allocate the follower
  cpumask once at setup.  Document rmpopt_wq as the setup sentinel.  Move the
  RMPOPT_WORK_TIMEOUT define to the guest-shutdown patch (its only user) as
  (10 * MSEC_PER_SEC).  Remove a spammy pr_info() and reword comments.
- 5/5 (Re-enable RMP optimizations on SNP guest shutdown): document why
  re-optimization is driven by guest teardown (the only event that returns
  guest memory to hypervisor ownership); reword the commit message
  (s/clear/disable/ for optimizations, drop "Conversely").

  Review feedback from Borislav Petkov.

v11:
- Reordered so "Disable CPU hotplug while SNP is active" (2/6) precedes
  "Initialize RMPOPT configuration MSRs" (3/6): the RMPOPT setup/cleanup code is
  then introduced with CPU hotplug already disabled and never takes
  cpus_read_lock().
- 1/6 (cpufeatures): drop the tools/arch/x86/include/asm/cpufeatures.h change and
  adopt the commit message as applied by Boris.
- 2/6 (Disable CPU hotplug): reword the commit message.  Drop the redundant
  cpus_read_lock()/cpus_read_unlock() in snp_prepare() in this same patch -- with
  hotplug disabled the online CPU mask is stable, so the read lock is not needed
  and hotplug handling has no hole when bisecting.
- 3/6 (Initialize RMPOPT MSRs): replace the rmpopt_capable bool with a small
  helper local to arch/x86/virt/svm/sev.c --
  cpu_feature_enabled(X86_FEATURE_RMPOPT) && cc_platform_has(CC_ATTR_HOST_SEV_SNP)
  -- clearing X86_FEATURE_RMPOPT for a contiguous (non-segmented) RMP in
  snp_probe_rmptable_info() (runs at BSP init, before alternatives).  Rename
  rmpopt_cleanup() to snp_cleanup_rmpopt() to match snp_setup_rmpopt().  Both are
  introduced without cpus_read_lock() (hotplug is already disabled by 2/6).
  Simplify the RMPOPT_BASE comments.  Drop the now-unused <asm/sev.h> include from
  core.c.
- 4/6 (async RMPOPT): the follower scan is likewise introduced without
  cpus_read_lock().  Drop the cond_resched() calls (nops on x86).  On
  re-initialization after a legacy SNP shutdown, re-queue the optimization pass
  instead of skipping it.  pr_warn() on cpumask allocation failure.

  Review feedback from Borislav Petkov and K Prateek Nayak.

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

Ashish Kalra (5):
  x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
  x86/sev: Disable CPU hotplug while SNP is active
  x86/sev: Initialize RMPOPT configuration MSRs
  x86/sev: Add support to perform RMP optimizations asynchronously
  x86/sev: Re-enable RMP optimizations on SNP guest shutdown

 arch/x86/include/asm/cpufeatures.h |   2 +-
 arch/x86/include/asm/msr-index.h   |   3 +
 arch/x86/include/asm/sev.h         |   4 +
 arch/x86/kernel/cpu/scattered.c    |   1 +
 arch/x86/kvm/svm/sev.c             |  10 +
 arch/x86/virt/svm/sev.c            | 289 +++++++++++++++++++++++++++--
 drivers/crypto/ccp/sev-dev.c       |   2 +
 7 files changed, 296 insertions(+), 15 deletions(-)

-- 
2.43.0


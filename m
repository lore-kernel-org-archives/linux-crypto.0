Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013068.outbound.protection.outlook.com [40.93.196.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E2F43B490;
	Mon, 10 Aug 2026 19:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786389714; cv=fail; b=P96G7ZIYSlYLcWSX0SDX6c7TtQdlswO0YWYKzEqZeZBO1UvBI/S904fSWZBT/hRWEjEMdIjHmRduWTf5H7kCKWXPMjaZAAssTo7Ztxnr5C6zuN3zwtO4/7rsM+LBICBlFyApBsGVUQshzkAZy+K6Api3iQsV1/J0cuFFCh8xACw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786389714; c=relaxed/simple;
	bh=jY3z40DjVJLZ4CePW95d/uhm/n+gkobXq77QBuJ+ybo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmI6kWL8rxcQ2ZhUxfpuBGzXnsNis+TUPTPBYr/C8UAMDdHweAKXtk3/BMvsw3tmQO9Mxcu2XsMOXvWZilQIgkyPZ/DCBTfOPX8ZiLII3seHWw5POjRy/mnSblpG2//vgNracZx2v+7dZJfbc13WJC6cm6Ie9JYbZuj69+TypN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MJ1DVxvJ; arc=fail smtp.client-ip=40.93.196.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MJ1DVxvJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iTcApr2ooUT34mbmkIZ4EYaWfqLTTFh/2U/1UcU+RgjUU5ZHkEFh/gNUG4k0tm8myKsVUyq0QWDtopgOGATmRe9aFTrL58ruriNveA3LmfSBLwghH6iBPT2EAEHbVr27OlZd/dDb4j167Z7acvhbTfQ+EJkC+O4l1VVcqJExmSmkse7rce13ebg/tYLLfAl9rgxUrV0lLc0LSxMZ6xKKNqFnoJ8vnTHPtDfIYKi1VMG/8PXGZSsUpDwR4J8v2qaZv8nfm+nMz0Lah6lGK6DUcOnnUuXZWfFbNU1GQ2r2PY1kwnutxfAPFOVCXoIrmb5oatxfCNEn2kf5ieX9v9/p/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOHf6KY+l18R/AQnkUt27zNklO6hC7Yd+Mepub+RNME=;
 b=eTF6nMLf6feiQOwaa8A/Sno3BTcSsLs/XilfRWUYf1bgKHLMQvXPTNogO27m/WJlevbPTj/6GCPxbc7o6pjd0nBik+G1d2rKK17Ig9HArftYdlI9+Ouspbd2e7MEcd1TtBO1Da2zz9WhqZlJtHFzSgBMEMNFLVd0K2QB6AIU5ju/r9AzclQJUyruiPFWIVXCf2wFDdSBcXCCWYetZLyCpINCC5L4LGPuUpyRa2MGqNXfsRzAKzFrFym4ZDrfTmUGE05wpWW74BUIdKQNzjcBQnUeUGcWJoI2M8EO6GWpDSHWDIHedTEIC7wnZCtN07p9C63LvsETohdnahBEW0ljJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOHf6KY+l18R/AQnkUt27zNklO6hC7Yd+Mepub+RNME=;
 b=MJ1DVxvJkLYBNHNuaykCyCIhj2Bgvh/JdTya76EmdcHP5w0Rvs+p/KR5qKJBqDFaSTaQlmndricsQHvG4w6cIa+o3VjhtED5x4hPCqhp++wTjDzb/26kf6mouThu80/KQIVMfaOBI9HWlkrEPua47FEug0uJqXNs2iHEtEKSOA4=
Received: from DM6PR21CA0023.namprd21.prod.outlook.com (2603:10b6:5:174::33)
 by SA3PR12MB7832.namprd12.prod.outlook.com (2603:10b6:806:31f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 19:21:47 +0000
Received: from DS1PEPF0001709C.namprd05.prod.outlook.com
 (2603:10b6:5:174:cafe::1a) by DM6PR21CA0023.outlook.office365.com
 (2603:10b6:5:174::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.1 via Frontend Transport; Mon, 10
 Aug 2026 19:21:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF0001709C.mail.protection.outlook.com (10.167.18.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 19:21:46 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 14:21:45 -0500
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
Subject: [PATCH v12 2/5] x86/sev: Disable CPU hotplug while SNP is active
Date: Mon, 10 Aug 2026 19:21:34 +0000
Message-ID: <a56493497e76e0048c8f205e266ea8f2f3abe156.1786389115.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786389115.git.ashish.kalra@amd.com>
References: <cover.1786389115.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709C:EE_|SA3PR12MB7832:EE_
X-MS-Office365-Filtering-Correlation-Id: 4314a8eb-f73e-4186-5341-08def7149ee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700016|23010399003|18002099003|22082099003|11063799006|56012099006|5023799004|3023799007|6133799003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	H13fpb1WTyOv7AT7pF7ltN7mpWORNZX02fZARDB/LDEXoYNpS94AIwanLvzMVZApTvBn3Vm0lqGPpAdohQKVCFH5SLu8aBdN3gFb5egnQL1koZzpA240zIrfWsIJ61O9g/EvoeMa16XzGa34dxRJLTZp/WEkQK9dqXYc527TCxvtB01qoawca0iBz/xvkvKuX8BPD0WlLgefsw9k/Pr0ElrHQ2ZF5nl3L7vRB9ozIp+rHsSnVRfH0TtOvyd5H22jdLNidJD+z7xWc+qNcLR8TR18oJDfpiJJLuGR8E9k9t+WBhQlIzgsGl/YdAQY+8sFU7x5yF10rJ0tuuOWk/LAubtThvt4owz1RA3uhEnjvtjHeeEjvrZx5VixA2ZqlLJhgobY8/JK+JnF10gm28T4CB662z8ZumaKH8uQM2inl/jiHlW4btr03uvFAzejMz2aIKFqFjkdbvFF8ZIWQV8udAWdlLT4kFsSK00FuCMPXRQ3rlFlhfYNC2gUNjDDysA7lwkScyzMTh5zVVlbpufvRHnyP4tYeUxQtf6+dthEcageqje9mnKGdOcEJbwkiVhxW8R7Nm6Q9BahboCeAcdBqClxlHpyfy6XBLLSYy8I92p6I6HvrPNfhOF9nsGYzBc27zMIA3FIVLSW5P8aRG1iQHFBi6UYA/5y4F1X6SCrL1l+rjZpT31PRdFAd/CbECPtIa8vboXJ2mwmqnsVCtUsQbR3kElQ9qOP+hg83S1d2eCt/TjJwZrBmllfo6xdvqDa
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700016)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(5023799004)(3023799007)(6133799003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IR7Hbvu/Su/p5n/94AnKs5pREyvz8Lz321M+UY5aJLW5rIJfcm8boin1v2JE7kTSjPh9mesugVrSb//VKxMK3qGmwrQh8zCtO3gMqoN1+WFlzd9czpnNNH0WKLzFubpQ17w/YyxQnSyXqY5fbqLVGhIzCgPL2X9Q91oFeasAit9XEzTqMOkHM3cbUiG9xqp0Vif0m7K+lttjuP3I6RkF16jztVr8tyCmacSx97TzUp9b4Ve/3Gzlt2eXMYEyhyyQBCktU3+jLiuuRDK8YzrzLpM2GkgJ5iFQ64p1evTBsdgjLecOrUoXoCc7CZo+kUS2pI1F5FD3nBuhMod9D7pldh7gAWr3DgYJoZfGXb5DQMtacP+NsGic9Uy9QXYg7wRzgoDkXDmHNi8FUK+E18D0tPT/yQUUSanYm81Hp3+4T7jTQNHfjjVwwSSaBg5/6sBn
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 19:21:46.9552
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4314a8eb-f73e-4186-5341-08def7149ee4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7832

From: Ashish Kalra <ashish.kalra@amd.com>

While SNP is active, every memory write is checked against the RMP to
protect SNP guest memory.  A core performs these RMP checks only once
SNP has been initialized via SNP_INIT and the SNP-enable bit in SYSCFG is
set on that core; the firmware requires the SNP-enable bit to be set on
every present CPU before SNP initialization.

A core that is not SNP-enabled and not SNP-initialized performs no RMP
checks at all, so there is no valid configuration with SNP active and any
CPU exempt from RMP checks.

The firmware determines which CPUs are present from the processor and the
BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates
them at SNP init; it is not aware of the OS bringing CPUs online or
offline afterwards.

SNP_INIT fails unless SnpEn is set on all CPUs, so a CPU that is offline
when SNP_INIT is issued, does not have SnpEn set, SNP_INIT fails, and
there can be no SNP guest memory.  OS CPU hotplug can thus diverge from
the firmware's expectations and break SNP.

Tie CPU hotplug to the SNP-enable bit: disable it in snp_prepare() before
SNP is enabled, and re-enable it in snp_shutdown() once the firmware has
disabled SNP.

If snp_prepare() fails before enabling SNP it re-enables hotplug itself;
once SNP is enabled hotplug stays disabled, including across a failed
SNP_INIT and across the legacy SNP_SHUTDOWN_EX path, both of which leave
SNP enabled.

A kexec target that boots with SNP already enabled, disables hotplug once
in snp_rmptable_init(), since snp_prepare() bails when SNP is already
enabled.

With CPU hotplug now disabled while SNP is active, the online CPU mask is
stable, so the cpus_read_lock() previously taken in snp_prepare() to
iterate it is redundant.  Drop cpus_read_lock()/cpus_read_unlock() here.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index cff285d8ad8e..558f7924a3f8 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -513,7 +513,6 @@ static void clear_hsave_pa(void *arg)
 
 int snp_prepare(void)
 {
-	int ret;
 	u64 val;
 
 	/*
@@ -526,14 +525,18 @@ int snp_prepare(void)
 
 	clear_rmp();
 
-	cpus_read_lock();
+	/*
+	 * No CPU may come online without SnpEn while SNP is active; disable
+	 * hotplug here and re-enable it in snp_shutdown().
+	 */
+	cpu_hotplug_disable();
 
 	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
-		ret = -EOPNOTSUPP;
+		cpu_hotplug_enable();
 		pr_warn("SNP init failed: not all CPUs online. (%*pbl online <-> %*pbl present masks).\n",
 			cpumask_pr_args(cpu_online_mask),
 			cpumask_pr_args(cpu_present_mask));
-		goto unlock;
+		return -EOPNOTSUPP;
 	}
 
 	wbinvd_on_all_cpus();
@@ -548,12 +551,7 @@ int snp_prepare(void)
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
 	on_each_cpu(clear_hsave_pa, NULL, 1);
 
-	ret = 0;
-
-unlock:
-	cpus_read_unlock();
-
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
@@ -567,6 +565,13 @@ void snp_shutdown(void)
 
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
+
+	/*
+	 * The firmware has disabled SNP (SnpEn is clear), so re-enable CPU
+	 * hotplug.  A legacy SNP shutdown returns above with SnpEn still set and
+	 * leaves hotplug disabled.
+	 */
+	cpu_hotplug_enable();
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
@@ -577,6 +582,8 @@ EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
  */
 int __init snp_rmptable_init(void)
 {
+	u64 val;
+
 	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
 		return -ENOSYS;
 
@@ -586,6 +593,15 @@ int __init snp_rmptable_init(void)
 	if (!setup_rmptable())
 		return -ENOSYS;
 
+	/*
+	 * On a kexec boot SNP may already be enabled (legacy firmware leaves
+	 * SnpEn set across shutdown), in which case snp_prepare() bails without
+	 * disabling CPU hotplug, so disable it here.
+	 */
+	rdmsrq(MSR_AMD64_SYSCFG, val);
+	if (val & MSR_AMD64_SYSCFG_SNP_EN)
+		cpu_hotplug_disable();
+
 	/*
 	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
 	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
-- 
2.43.0


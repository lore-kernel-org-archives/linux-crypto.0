Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0EF456E00;
	Wed, 16 Sep 2026 19:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789588404; cv=fail; b=MZZOcNgZYUKoB5SZg0GX7dnOPH1H3zNohHIPL1ZDzdIRKhav7GG3ia5sQV4BVzZPoNz+eKn34pJW+Gxzqjz2ZlRg2j4T3/0GpgTTULazFLr9QwXdj0TTd2ARs7sgTKQuCbNbgIbVWOw+CqwmqTprAwTAgeicw5d208mn0ihtjkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789588404; c=relaxed/simple;
	bh=3I0/vYIJULo4zq1i/nNzduS+ukIwREO6ln2wFgrs3Ik=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T1nVL5m9Ll2PMVIjBOfoSSBkACBZLm7Tz0fzieXsMS60zfXJcb/1VQ0G3F00pzpfhxt+tC0DdOPFbdSOCLsM0lq9zzqVq1FuHK5qtyFojWLnlN3Fh/yau7ba609K1GXCKZ5NultiDe6IeU9weiGhZWwil4uDEo3jAJAVWTTz3q8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Epl6k4od; arc=fail smtp.client-ip=40.107.209.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Epl6k4od"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FFrbKYaZGi8/Mx+WOEK+IKQeTxKEnEUfkMgqRDJR8NP88I5VLCMLk11kMa3C3PIos3FTnogFBUVdIpr804oMLwMBBDaa6QN12x0l5XgF3lLHRRjWDvdHzdiabLr6nMgiEqzgInvlc30QuVP6Y1hH3pQ3SxGKmnZeMZF1ZtR8UZxiXzR73CFY4IeA1KNJMXZQpHPGotKxEX/n5mb3UIs/03AYXTCVXdr4hQofGpTAC+GXNVsgAvPdV020uXThvNYj37tfWgBh3GoLXLmM8ZYUBoAWRmAPkJwwA6bWfCS9KWFmOm7Mk8X0Px8a0GDxj3M00aRf36tZUrPYvIqu5ejlxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLHDYBoTAlysx8a2PQHWLBnWRAAJiPAV+MsXE0qTwps=;
 b=xi/PnRzoE/Z+MAC4Z8Q4hLXR/X5k9vevDCF6Xf4pI2wevwK7n6e2uQ+TG+QncpipNN07fOifM0YKqDKz5xulZX+tO2HpYUbAFSQkRIL6076bzk0Bb0kAyFAKnVWVhk7QG7E3LuHAK7gbwCDmo5SnhsH1IhorGGzM78V2G9xgzvxX8TcUFKBxA7nuQqOObvbiH2v5JOgqpth8kghjCVcjqefb4YldYJNmgxpQXCNsxYg6KMv3Nrqe0FsKEauD21Td+rG7xt0pBbu9IyiirYiMOp/AWnhYGr4MWytUZ2x5Z260l7VVcHJevAtN3yrLY78pGabGNy+j5DKJpJiXs5enxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLHDYBoTAlysx8a2PQHWLBnWRAAJiPAV+MsXE0qTwps=;
 b=Epl6k4odoq4ze4rD5qw+Gxr2viuOVZSed/LbJjosQb4tF5neu8OGTRcIG3odJnDlwX/7MXZiLO41jJrR1C464qLahiYnkAgHf6+hpTZCecUCY3l4E5EdPBiUNmQueum721haO0e0ZYpBTE0h5JmMxVkkjisYCdr8CsQ0bbQAYI8=
Received: from CH0PR03CA0120.namprd03.prod.outlook.com (2603:10b6:610:cd::35)
 by DS8PR12MB540605.namprd12.prod.outlook.com (2603:10b6:8:447::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 19:53:01 +0000
Received: from CH2PEPF0000009E.namprd02.prod.outlook.com
 (2603:10b6:610:cd:cafe::6c) by CH0PR03CA0120.outlook.office365.com
 (2603:10b6:610:cd::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Wed,
 16 Sep 2026 19:53:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009E.mail.protection.outlook.com (10.167.244.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 19:53:01 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 14:52:59 -0500
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
	<dyoung@redhat.com>, <nikunj@amd.com>, <darwi@linutronix.de>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v15 2/5] x86/sev: Disable CPU hotplug while SNP is active
Date: Wed, 16 Sep 2026 19:52:45 +0000
Message-ID: <cd6962a88d691a020c2bf40fe77a6a3f3852fdfc.1789586444.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789586444.git.ashish.kalra@amd.com>
References: <cover.1789586444.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009E:EE_|DS8PR12MB540605:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fe4e1a6-708d-44c2-6c99-08df142c1d7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|82310400026|23010399003|36860700016|921020|6133799003|3023799007|10067099003|11063799006|56012099006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eqq7ljxpv1SCieuNk6gGRZPRcqWe4Zbhs9WppdTEiCvpAODmDiags/gGqaHuJxYypH6L9UvsrDRqAyibMEnzJm4Z3KYtE6AjAyreKcC3U8sfhrz/kozjrlpmp/lij6BHrHSCTtr4H+pEbbwghSbfYXmvzLg1273CqEqzQ+DYwI5RLMq7XZbrvGP+aLFzOnaQ7kmjSOQ0QxOLVszF8qTOdzo6xG3zH7fuG43dMh9K42IVFn2f0JoGSQMcEIrXBrZz5EtBmu4UumEffwO6kfOfDaaPmb0BMubVQmGbiMt4MjIXE16vQUZqQ5cXRVQLR1EZFBrsaTrW8naqLsRZWacXY1ZTH3STHDmyWtsNNYkNp7VyEJ98PCvCdR86GmBvT8b6n0wOqO04jinw1IGVeLgwnTTpdOKZJQGWdCP3yskc7JOoICPEuISBOWI9u0MBbZUlDd4y8ZOlzHcGN6iE9LumsOUWInQk4QreT+09nObjH7yznHM3GDipHAlEb/txb/cYHwPYOxJlj//DmyIa2kU2vZcSBGTi2mzJsPUZq3cicHrmFUwvaU6dN1AomrZuiRDLHlRcICnRx1uEHKb+b9ZAgBzknfEHBynrAHFx0+/Wz2FxQ9Qn8/kHBBymrf8TPBTAdiMfKGO7L2yYWD6CsekpPMtBBQp5K66Yau3MVi4045JHHCC50Gsn1bgBfIp+hSgFJoWt/NxVYw3BJPx7HBLtvdV88gmhA26jzc1QmjpPVzotqbpMrhRFORV+Tp93NKPP
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(82310400026)(23010399003)(36860700016)(921020)(6133799003)(3023799007)(10067099003)(11063799006)(56012099006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uMc91R4B+hH/UJ/tGMFnLsZyreWEx/C+5y1gZJ8HcLbPTpXAssyRnvFRqj8FfHFHSdY/mN0s9geZqbVdyZK6GkKp4CZHv1uxCHsXegxqY6ICXmMDsazx/gV3seIHmDq2i7pl/ofSHwJnqfALPL5bUQ366eM5Ubls0HzjAf3in52POhmYNoQC76n6hx91yChAsODfZ82R4RCeBTIM+E3H8ppu4jPReFk/zZ9+BEqC8DW56MDZy+Uo9VmCjU7SdB08hjtRdWDUva8TP+yPmEJn+DdlWowtB1OyzObqfJi2STeRrKQtiK6A0Ps4Wte+f+8EZiHwsYJI3HJ2gVZX2e+TfUQPhpQlOfApsr3/opVHBWsnWCkrK5obmpXir6S2AaB6SOB6u0abm3+86xd0b08OgVdpVEYvgzZcb0snKSgrB0YzXv9NmnWLdN8SqmjJomls
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 19:53:01.5289
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe4e1a6-708d-44c2-6c99-08df142c1d7e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS8PR12MB540605

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
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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


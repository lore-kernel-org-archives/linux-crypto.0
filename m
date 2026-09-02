Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012012.outbound.protection.outlook.com [52.101.43.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9522C411FB1;
	Wed,  2 Sep 2026 21:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788384523; cv=fail; b=ar5AY/8CDngShoV3RXXTXcexNqRaz9yWx1C8LYdYHJ7hepSdYOaULPDq7IJ+yPAI5IabcNDL0HCFkfqT1EM9PiBijf8k+9T1Au3llAROfR0Tr3RhATGXeIEFx0mwCFnPuWbAoPjsf6WOb9p1jQBtaio7J3qL38nkeHoCscyHqBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788384523; c=relaxed/simple;
	bh=CdeLy2V0jfY7e11WjRHifrMYdlC9iYaxbRfDU/EdAeg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eOOGndmJpE0oudG7mNzJ4fx/4x45/4P42VN1xZwm16Mw1nvyF/Q2T1o0yAi1+wBMCBMkZckI7J0uQn7eRNdMiSJcnKs1fZosCP3CpRQfxfgUL35f9TdMMql7aN94zHRpldIVKef4W/gMUBuU3SuQNbcnZVYJXZlm6qOPCqPB028=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wz3z4TJ9; arc=fail smtp.client-ip=52.101.43.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wz3z4TJ9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jebLI+KSyY9NJTQbW9rgkNfnbDvOZ8C2SXIaFzdaU12O4gETrZQbqfoN256mztwQcK4BIZsX9Z2z07lguesOP2KVW28hdGgMqgeS8jVJt6y7P9PEayoiaDIbdonygQi2WyMYsb2aJ0BzAVL022Faju4mA+o8Ufn6YWV1ktHty5nl0/12fLsV2g2Qp+S7vLp86W2wGSfjaILgYWXSg/NODz3QfHwPXfr7Spf6YoZwEWykaEMGnHJDn0/4Y9Z1DWtvf6DmBrAo/8TYw0ERKogXhXZeDK+DMUvbIeEvkKUTSWkadUNM9JYC+VkaKHxlKbU+tpJyqMEaDtvu+FkT575f0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IpctsL6CQ/SnwxUQQrXwE2fg3evd0gYdXZvyUJtCCrs=;
 b=hUrtXFUxImSMZQaaVeQmkrYrYQIlyfdG8X0nOhAfm6bNB/ul4JKKL5WGq4jGZAGaIr1ElFEItZvm+UqjPKR8lwfi4VUBOke/hDqCLP9xEPplEvqcKzWgrFCkYNh/GdRKlFObnBOoZHE3Nx7jMzLme4v9bs+zjAe4+RSaDNRsZBB9xDeWtU4Ndfdxq/pVrH5ZUCH/ID5nXDZmJjNr3HpIOrfUg2pAX1DsuzNxd4KXR1yxEfPX1JUyEise58EtEsw4SdAI9OWiDOiRSHOYaPQSLEuI7yfg1o+syaX4AwcbyNpY0S8nkLuAH/X+3nqL9i9IzFTriNJ01ykGK/bvBZlf2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpctsL6CQ/SnwxUQQrXwE2fg3evd0gYdXZvyUJtCCrs=;
 b=wz3z4TJ9XYgsc5nbC+fWC3RLQF3Ds8Bm7mhc9uwCszQ+zLapNceD3zTUbGJluGHF7PqYWXC5pGhlhiGnNyo0caLMkZ0O9ioFUIxsdFUm0PGKNa/g+4uMbgd6CNZxdSMXpSu6qkTOxm5HFblITAK4OhcBomi5y1WhEM/OZ2037bE=
Received: from SA9PR13CA0099.namprd13.prod.outlook.com (2603:10b6:806:24::14)
 by CY8PR12MB8216.namprd12.prod.outlook.com (2603:10b6:930:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 21:28:28 +0000
Received: from SA2PEPF00003F61.namprd04.prod.outlook.com
 (2603:10b6:806:24:cafe::14) by SA9PR13CA0099.outlook.office365.com
 (2603:10b6:806:24::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.9 via Frontend Transport; Wed, 2
 Sep 2026 21:28:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F61.mail.protection.outlook.com (10.167.248.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 21:28:28 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 16:28:26 -0500
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
Subject: [PATCH v13 2/5] x86/sev: Disable CPU hotplug while SNP is active
Date: Wed, 2 Sep 2026 21:28:11 +0000
Message-ID: <2c97a61a22a4808d422367e50db7ee0103a49860.1788296083.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788296083.git.ashish.kalra@amd.com>
References: <cover.1788296083.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F61:EE_|CY8PR12MB8216:EE_
X-MS-Office365-Filtering-Correlation-Id: fbc0ccd1-a067-4a5b-e8c2-08df09392107
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|23010399003|376014|7416014|18002099003|22082099003|56012099006|3023799007|10067099003|6133799003|5023799004|921020|11063799006;
X-Microsoft-Antispam-Message-Info:
	x4c+A4xiOyHOAxUznpkk8TzqTzdMOBeO9wBgn9PFz+Ct0wpw2OaILdoCw9xkKVr5eLDWIONpbqYH5MHQQdy3AOPebzuX7Tgk1jDhNEhr/8ogeL+Ld7Hy7OjcDCz1xYFYp26nSjVmPQAOXJBgk9WgGSoVtUs34g/0jPl4psNGVIGHfj8CnwIt+cLGFKgcKWyBj7RbaZ597YAzm+c3R8lsAZi9YPpAe+iIkRAgkeLjT+FnMZNR9Io7qq7EtDWrWVSCmBB6t41h+5Si/xMLPuAD5OcxAGFxE77H8q6jAcVR+dOCgoIHC1eiSrc4ypcm86olRDYW2vcJvldjKTgqLXV+w7SY9MT12P78HqyRenTCr8wbsdf6LfYH6HUwQTiuKy3ipKisbxTfjbPR3mKCd3JKx/Go6UvSOt68+sqv60RUygi9brk5brHz0/47bkGVoikbUQ/bQVy9K4yut7JFj+mVSIy2eN9hhT03K1V3kCg91vawON9UIJvSNDEioCdl+8njZGpqMHZsJf1M4UCmG/LeI0Zh2EWl5pjBXQOGnqSeq8KRB4YZChGKYZn+wL0U6vPNVzTOOBXB/7Jo+O86C5ZA0rz3fahL7F+oYSvIPvpkDW0Vhbvh39fIJmCKJeYjKpwX0t2Lm6gpcGD4ZdNTc3WRsKfVuNcwPCcvVwQqbUE6GQbtggKYK3kMHGZwSP3yVCz3AkTFcqmntbi7nWhVE/kPvXwOVyIL21jbtNVTdRVFnKCpk42LkPAxQMkgWXZh8wWL
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(56012099006)(3023799007)(10067099003)(6133799003)(5023799004)(921020)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2H/zHQZxKTGpC4z68HgPC2WrjOkSS2eomMS8iF/qM0k+gaqWz/O2h8kLvdlTYS6W5bWT12Yqrc3b5xJxOhVkfaByekI89/2aD5ExlBgIyHFa843Jg6V2Ui1lJx/JP9O6wXKTyWFDBAlRgaokecNMRRzBBPiDMEfGPZaoxSUzJx+uxi+S5Wqvjfb/bsMOHcrfyEp4c+X4Pe60ajmxM6kwQzUsTo6diGRVQgCNJ2M/4oTbgM0cGy8exORWYooEmOid1d96EKkRK/5O1ZfwrxaMzNGtuE17VjCikYmPffpHDejLJG/zl0xBrOMTJUEQjFqWlPg4vH1GamHZbxoa3efgpLOUEsZAkhp0iVkng9NKzPk52OlHrSPJwigT81zFUs3EmDpi1zoHUDXnqH/ayTBviSew62X6UQgHn0MHohSaGmiEmzwTVVWSwyA2mo6G0dnf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 21:28:28.1245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc0ccd1-a067-4a5b-e8c2-08df09392107
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8216

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


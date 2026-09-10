Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010066.outbound.protection.outlook.com [40.93.198.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EF149B5BB;
	Thu, 10 Sep 2026 21:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077596; cv=fail; b=Y3oFif4q2awZVXSJ7u4KJydOEw+RbKHrHESpyNnM80g0qtuh+BzCoBKZJlG3nJItC14XWCU7tJnyxyHSceKEze/BgiXpE+eGlKnK4KYi6G45fFVh/440PsBV1c4ZkgDmvfQutZX9fkgW4CxxTIKVLSYs3uvkbXGA3dpS1XICRoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077596; c=relaxed/simple;
	bh=3I0/vYIJULo4zq1i/nNzduS+ukIwREO6ln2wFgrs3Ik=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DKCIM/OVVgq6Z/3Qvdoel2sVXk0kCdmDsLxX3gi10CpY0y7a43sSUnaGf02b8+oFOUoSfsuNHtq/1iawtAXIQn/O6cDLvpM3wmh57CGh8liiaXv7ycOUqJDGyPtc4GKdoA1WSPOWQ4/9LdGk1FDqko5GN8LrhgnWBb0aZnCFhho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0GtF3p9N; arc=fail smtp.client-ip=40.93.198.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0GtF3p9N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UpwGI0WS9tD5bY8MSFRwePARG7rMb867enL4L/+5eTmQepiT/vxXWlXr2uUznRRqt9HjZ5WsLgOCOctmiTzkvtOxZzIQBxJiyztAzH3LcgIM1OKkFy8mgO7YOfrEpriJFNkssLbkm6B8Caum40CqOvLpyj/pEHmoD3FfA8FIpF/D9KrLcsQyGHjBwmDd7ccGpNqZTClJ9MvedsIcHdqHi1b7IWurVkn3yxmBy2eDv3DSVkINJ6O1E0EeZCpofldmT/FhEXD1eszckyoIWf2Awk+/xoVKU2f7qFQVgQ0Z5TRv3Dz8H/3NUCKXp2MTJcS98ucPHTNIFTsv9QTjNkcR7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLHDYBoTAlysx8a2PQHWLBnWRAAJiPAV+MsXE0qTwps=;
 b=sGzkxv2pVt5y6wD7/BIniBpkix4gqFC8Ubl+daXB1rFO3xL1l83jHBhtKtWrKoYycQZqFpullh6Bv9Resf/tyZBAWrNXA/zop7CXkGEnWVwSwRh/qPmX8EiWG675iYUyn8R5jrYhDyGUrvmIKCO+ytaIEuUIS01fOe6Not4gR7Ryf3l7o4Mfq/e2rNjdg1QFIWoSgbVh1HkF7un0cDFbxm0CMC41+W54I/AJx03m93Pf8AbeFXcu6IlYeDKLKuCzDAI48smU/47Wlr51tTHsy8GmgKJjdmISrq+0xp8BSoGRpkbtu1sXXPS2JXY30ck5DohlJUbA8lX6M+CKTardSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLHDYBoTAlysx8a2PQHWLBnWRAAJiPAV+MsXE0qTwps=;
 b=0GtF3p9NwMiFik5pZG0AEZ5MaRHVLC32/QxWk/i5r2E7uInp6bnGwbjxAg71JcasAgNGbZqfr42DcVfeICgGToDS60K8/kVHpU/wt2ZXCRbiJJrNuujaZrHEgcFmbcrn4M9+Rc7tVOme+rkI45+NYb+Fkh9Q2O3FadOSThayzNY=
Received: from BN1PR10CA0019.namprd10.prod.outlook.com (2603:10b6:408:e0::24)
 by DS3PR12MB442436.namprd12.prod.outlook.com (2603:10b6:8:547::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 21:59:48 +0000
Received: from BN1PEPF00004687.namprd05.prod.outlook.com
 (2603:10b6:408:e0:cafe::2) by BN1PR10CA0019.outlook.office365.com
 (2603:10b6:408:e0::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 21:59:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00004687.mail.protection.outlook.com (10.167.243.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 21:59:48 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 16:59:46 -0500
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
Subject: [PATCH v14 2/5] x86/sev: Disable CPU hotplug while SNP is active
Date: Thu, 10 Sep 2026 21:59:36 +0000
Message-ID: <cd6962a88d691a020c2bf40fe77a6a3f3852fdfc.1788984053.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788984053.git.ashish.kalra@amd.com>
References: <cover.1788984053.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004687:EE_|DS3PR12MB442436:EE_
X-MS-Office365-Filtering-Correlation-Id: 302cc517-40ce-417d-f824-08df0f86d507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|23010399003|36860700016|6133799003|18002099003|22082099003|3023799007|10067099003|921020|5023799004|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	KMKXq/3PjAYgxDUkbyBcboD8qLIDBNIi8zPx1HCeL6qL1qp/v6CcgNzeo6tQlC/izGkBOV5R290mxAaST5TvUkQP2u7ntEGcP07azUtvLl+VR96jbmioxQE27nPFs7uCLm6+b2h4U0hhgGhXpdkrsoiJ0MbyTMlhRf1gjD1Vl3ywRy/lZIav7cdYs/035wS2SCVszeK61hEjIF+Zy5ug8JGk9jreB4Anu1ngHzw8l9Fh4yu2fry/SEZXcCy1wo+9fAT0GSjWKJVk9BDCVwesbKhHVg5CatIZPYwcbU4wH+gaLraaSxb1jqALOInBrtFrjIG25X766+ELRWl3PjwhJuoGav6nyQSZfAQ5z7j8UacoQoRdel07t/xuojr5ty+dDwlhVXBMbbBJmyXeV1rrSUTqs+nalOa0Kv41u6E3H9RCE3hMiDcJWFGBSivjvsHwMMdmqkZZOVFLGpJXrM2Db8Af3UfQI0VwMD7FO76J2yVaLDTBn61WhrkD0d/xNoN6BeSIsNJ0UUiFrj8g2kb/zjf0xJCuLcfIiluBDh2q9SzPpsOUZx6RTiiV+lnSGO5JOlzXVyOKGZgX2VUAHM8BoeGwvzo4qnLGq6ObuW4XAYJTZtk5AtnjgkT08D+yi/KqVWSikUvu4o75JgHl2DnvL8uOQVQ5X7ipvGuAvidj0B09GAu0UgqKgkj3ipeuvxmLUgZvlfT8xgRyf28vCtRdRNtWbEqrVrVF8kW9A/a2isQEaQAmoOO7Dsk33dho/8uV
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(23010399003)(36860700016)(6133799003)(18002099003)(22082099003)(3023799007)(10067099003)(921020)(5023799004)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nHiNbGxkR07VQMU7Y9RxOF/Quilri+hHARbaxu8yGdpEat6WSHsN2UokCmaj7KH4JgXvF3dX/h93oIufubpo9/p6hNHAImJdV1g9ZiFr5a+vmyJdm1tNkeY5fxyU502cqzQ/3oVA4jQf/RROENQfYxIzM5ZE20B2y/TctVa9+EFO5dNWSBxaaqZix+voSr4bKtKL3wQ80LbX6sJ34iR4qQGC+Lx0LRo4unnoVn5z+XcOz82MLr5GJHE9AzN6g2YCygHHqwHOKXQPRGuQfWlWMDqFOcBczBZIHxkeCHQ6NQxqUWbhEfHtoS1/uRKw+omMucH91t6HeuCtLcMr3MGX1RtQXIdOXpgvl1JX1+/982RwSVN/PsYsWbGFvKeTvotPUSLlabFvR4OW4rk29R2eiW12cpJYp7jupJnl6WTr2+267IcaxMKyMdOwE8nPMVyZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 21:59:48.3574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 302cc517-40ce-417d-f824-08df0f86d507
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004687.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB442436

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


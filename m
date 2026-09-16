Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012056.outbound.protection.outlook.com [52.101.48.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE404AEBE4;
	Wed, 16 Sep 2026 22:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789596908; cv=fail; b=G9cablUQgbN1CVA0qg8uSipZn28mCKdkbV4v9PPBmyTT/7V4sM1UytXnrIXQbDVbPuJrM+3noclcTV8F6uNX+8/kmtS9/HDAwuTS/126kK9grHbTD2prHoTkgT3sU4Ysfbpl/GYKFhJpohH5DJ7Uh95LxqjARVAG5xGVmMrLCwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789596908; c=relaxed/simple;
	bh=3I0/vYIJULo4zq1i/nNzduS+ukIwREO6ln2wFgrs3Ik=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=trppOaO2eF98FKlnBKzWxrAkYXXPdgcev8VFt9dVospqONsQJcNUVOy3buzNttiFMfo6VE8dn6l+lZuyqKNXqQ6APYTP0dLJ0QiIoS3zBzbMyrDGa+GhovQhhxI2Ys6eNIBslBLATZ07Cz09sEBaNAfpFon63sdqVJ/pUZKe3Qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BIg1vUSh; arc=fail smtp.client-ip=52.101.48.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BIg1vUSh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3Zwg5qO1YtPu77JP71hT6GtDVuo7rjqeRQ8hJ4irpPY7AenGO4yuJqjBp8pRSLh5LT8R5EspBXrz1jqdS69CIHqfzhJaWbykvTTmnFreY7Y4S1p5Hu3+HtwyLLYo09GexQU9ri7JAfaDu6mDInepCjd/a2Oi+JfX3nWGUVciV6UvFmPhIYDsbCyreThYcTFFvQV9vCB8cp3azW4f+8WjlhMNriizszwfzX8O7NGji6M5IH3DEMU22Sj9kDtgfFYaFrHLHZWEqpJCGLMvf0fJa13MS71n2REnwdxm9H9Nv41mstoqfzKBs7vEwNyTeCYj0UWqUROY3buB55vMZMH0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLHDYBoTAlysx8a2PQHWLBnWRAAJiPAV+MsXE0qTwps=;
 b=nmXEk4iZ8mfoIrPeA32/ef0SgH3x3yGwsNN0969N2Bpd0h3IkSNz5SqweMRRq9HBYFZwjeoaaUb5rdPsu+bh7ai2xSTnyEVCuxri7txWrvdsGallJVGGZPjlCyvZm1VAF7mht9IBxIcogeUPRtJ/Y0/nd3WIDbdv6oNSte1l4an9LfmYrxhftevTXcCk88WgY23TvA0DQ6uhqAhL3MWtZeOC6uuGs/AozjCEnieNKBkSSZMN8EW7a+ir4YBNTUQ2gt3/ccQNOikBCOFT9jVtQYNqMCI3sDoYxCGJFBfs67qMSq4jaeIAWHotrMd01Nf5sjMdwhFx1Au0ZGUmQNrUzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLHDYBoTAlysx8a2PQHWLBnWRAAJiPAV+MsXE0qTwps=;
 b=BIg1vUShOla4eWzFI/el3T7/vNkIKalDlrt2URovSgic23J0iKYjd/R4+9IOtRCQf5l6C2eubiLJJneuFRrl9yotn2RpjNa2Lr12JP9nkTreSrWY1xGbokmOOVlWpMIprrdJux/ioIaCSjsY1OJeShj9hZoJHm47aroegAb3xuc=
Received: from YQZPR01CA0046.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:86::25)
 by SJ0PR12MB5674.namprd12.prod.outlook.com (2603:10b6:a03:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Wed, 16 Sep
 2026 22:14:48 +0000
Received: from SJ5PEPF0000020A.namprd05.prod.outlook.com
 (2603:10b6:c01:86:cafe::ab) by YQZPR01CA0046.outlook.office365.com
 (2603:10b6:c01:86::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 22:14:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF0000020A.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 22:14:47 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 17:14:45 -0500
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
Subject: [PATCH v16 2/5] x86/sev: Disable CPU hotplug while SNP is active
Date: Wed, 16 Sep 2026 22:14:35 +0000
Message-ID: <cd6962a88d691a020c2bf40fe77a6a3f3852fdfc.1789594774.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789594774.git.ashish.kalra@amd.com>
References: <cover.1789594774.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF0000020A:EE_|SJ0PR12MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: d700f2d5-8d1b-435a-122e-08df143feba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|7416014|1800799024|82310400026|22082099003|10067099003|6133799003|3023799007|11063799006|18002099003|56012099006|5023799004|921020;
X-Microsoft-Antispam-Message-Info:
	wLAg+H8SbidZpbZxN6fUNi9iTnIT5v2aQXb95aBQOVikNsqPqZU5gea3eX1swXkxZLGvcKqGSGnYwtDWIbF9VjGA57kKuhf9VN2in00QF2Dn4gXj1MC9TBoFtZG/LfcOpYdAV08LJcLJnO0vNbtjUWna6pKrWMylFM2Agdnjt1E8HEmLsDJkH0R8CJ83o4eGRF8XlW5qvX7Gc5GJl4Ijv9SXJGbT5Kc9cF1Agh8yD8UEyCOwSmUnQPb+EPl2cXAzjF03HQR4Cb9FFoVOIy9p7Lmr2H3lA+hg8X1tj0s+ilai3qwSjriJ10mSFuS9KxERzpV5cfqL0iD6O7U0WCm1iDKI7C0RqJHsbxXP9JG3y1YrKj8ngwtkkYs+i8PbqZtrb1XU7y6MvRaaozcsLecP3NmBR1FaA4zrJoQxRATbp8shnGX7hMK1pUHbPa4RIlJlPktKHuQ65XH+ZT0krw42YrsPgLkY8gx+zqpso/mnrQhN27X1san1tXyHKQB6jA5G4Cypfi7AOBQV4h9Krpl0AI/hQlZRV0/A+fVJz7ZEurdGuJzdH2vFXBCn2R+Rr//RkvEHRscGYK4UgBvBdGZwyqBcaFuD5XNix+1Qe92GQNRJuffGo+DguBZSFPxZJB1QfIsQAjLFCSTZA6UMkWJC6JmJLm10m5JXsHd7zJ5ePu73BzHU4wozTKcCBV3O7I88+FDMTHAJMM5Ir5/JBxNiYHaQ2GfHam5Gbk60BumSH1Dm+8T5XdiYV9i4SjkEKGvW
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(7416014)(1800799024)(82310400026)(22082099003)(10067099003)(6133799003)(3023799007)(11063799006)(18002099003)(56012099006)(5023799004)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	L3yBp96a42pEblrz+5/LrZVwEK3LUC/hyNMJ7Xp6nsZu8n9NaK40VFDJ8wcdzD6eQlHte1fA/iKvCu5hYJUA4fIhfzNVjFGrDqYVDRi8crEyfIx1mNfJCy9HLWruBLMX4GAiXzt/2tBzEtO90qGozaaIdrQ9bYhALoGif+LP/Gq59K7fyih1KRRkAyUw24moB+hskI932QrDQGm3sZ3Zx22gP2awdhQQEwFrnOiJVBDDNw83179CHJISIYxIylNL9AFUg+5cqhjDOP5BLvIlsqtP5e2/v4z95AQpbUbuAjl5PLYP021cAbkUCFEUfPFDcq74wsy9494DhhyPBxR81GwG8P+7ZEZKeQXQCFLE1vytEw8KoVN+431AnmnS6yXE/i+QiWE1HhBliUzVE6Z3yG9d6GV2JrCMHBDTbH4/eHPxmwwsMO6/BDrdVPeBhmTI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 22:14:47.8254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d700f2d5-8d1b-435a-122e-08df143feba6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF0000020A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5674

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


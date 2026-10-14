Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012046.outbound.protection.outlook.com [52.101.53.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12DF4DE700;
	Wed, 14 Oct 2026 23:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792019264; cv=fail; b=oRZ2k2Iwg5s9wqMQ9pORVwmfJ1Y3+av8yNc4qVmtgJuxc5hFkWp5W0O46LjVMwDkjYI2nsJBKftyGSgiwaOD1cqmFWdFlhXl9zqWqFxS8+T+yRiHSXzyEJfe41wNxUWg+p+IoyHtpmZS/ljrSFAMqkGh/qHg2rcnGyR/uyx9mT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792019264; c=relaxed/simple;
	bh=nq3KMJ+dTEPeDUCdp8kTiHPWiFzxfsDkcYQRnOvgYpU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G2oZ17ibl9V06SqSGCuk82TWXoewOMIT/08UcjJKAa4xPiWSRvloS+LZnmn7+FOGgVtvRCqhuly8HPTwvVcfWYHNHYVRFyUdkWQc+vqiMg3PM/kQzBnGeFveHdehTSRvzNgtQqgjgdKkzQHY9fDskohYx+aVuMC6A3HE+CcX+zA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V4H7BqnW; arc=fail smtp.client-ip=52.101.53.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V4H7BqnW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gBe/APw1xwkh+oEhS9GBuTO5IzRHnjsuvUaJZEyh5YieWeXYuUuvpA4ckAqop4Ma48mzhqfdqYpF5ZU6ncZxp21fH/s4vmf1ucmqnmBMADkE3j07q9mtaGp+rZV1Q+6DEjNVhCFPX3By2rnVHhqLQzGzG9b5xZyQ6YHyNgVj94HVaNTcrdUHieYCilV4t43PEdm+mz2UG9++Ab7JVIczwD2KQSJWeGEGO695JIL8PhAplteQc6WybMNQRSfNp0Uh3rWv1RmBluZJIWbIN7LiFogLUC0/9zx0mu8YjbgIyZ1wSou6TgFcB1sBOj9gYrZR0/9e/egDO2wXiF/S2ta46Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YMFrjD0uGhWDdx2lMpVT5JUBMge1OddG0L19mwdSx0=;
 b=OGQ+pzL0ggf/ZkFSlIVcCgJ2m+E3K75UMPZygOsmp+GAXfgBXnsHaKT9w6cdz18H6w7DRQpFEzR62PZpw/rjQWxyQlgiVWZkBMnXW4OyLeKoZFs9nGFbqmhRJODQESMH3FxNYfWjoifhg9O6EgfA0BKMWUS3bM9ky+kaOfTiDfw8hN76kAZ7WcHydkGfSVJ8+lZN+Rbc/MJQlINGsJPwCeOawd55BRPRV310nX+ictYALyGCb86HVT4O/9dG8u5402U+PD5sklzgVoyBKXQo6PKDPj9ob8ZNtco/MX+cgtjX+yegZChaOx7369mn96iX3b/v+R7U006ski1PRIBcXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YMFrjD0uGhWDdx2lMpVT5JUBMge1OddG0L19mwdSx0=;
 b=V4H7BqnWnpvJj5JIHyU+ZzAaj18ztJyPRZG1aaSlySj+w+FJkbuulCtUq11GMk39OJ65C6gnW1JMssF9zE1vX6bGsJAOnQ9GPrQJqnrHrq4R1FppiYvNydTs4/9/Ww60xHkRMyuY/aqQZe6pFnVJIn3830ap7SsJFsMs9AzYR9A=
Received: from BY1P220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::6)
 by MW4PR12MB5625.namprd12.prod.outlook.com (2603:10b6:303:168::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 23:07:38 +0000
Received: from MW2PEPF00014675.namprd04.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::30) by BY1P220CA0017.outlook.office365.com
 (2603:10b6:a03:5c3::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Wed, 14
 Oct 2026 23:07:38 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MW2PEPF00014675.mail.protection.outlook.com (10.167.249.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 23:07:37 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 18:07:30 -0500
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
	<nikunj@amd.com>, <darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 1/2] x86/sev: Clear RMPOPT when segmented RMP is disabled by firmware
Date: Wed, 14 Oct 2026 23:07:26 +0000
Message-ID: <c8f9022fab27f4adc73ad09a9eb84257621c60a2.1792018839.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1792018839.git.ashish.kalra@amd.com>
References: <cover.1792018839.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MW2PEPF00014675:EE_|MW4PR12MB5625:EE_
X-MS-Office365-Filtering-Correlation-Id: 6592e4bb-d1a7-4f03-a11f-08df2a47f0bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|82310400026|376014|7416014|261009223027099003|10067099003|3023799007|921020|11063799006|22082099003|6133799003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	Qc45E/uW0GOG2+ynWCynTOlmKxp+9lf4GMrryMnIqEaXMgDMdk75jVnxrjDo6xAfYmrC3WU2zTwZLwUut4Q782dfPq0GUxOuv39jybT48rHKLBIzLwXRTnCngVgWUMKlNVEXDOmCoOgkbl1LyjyHnbQo1AU7WdArGshWuFrUSeF92CwFUVUf+2FI5fz27e47Fncs0GSbYjxj3wfbzeM/zNjJqN966jfbW+DeuJatCnrasUcOYQVf1ST5bFmZ47NA5lnfy2+SiMuFyTFUmuXf0w8BDKUc+RWiOfPP8rcNAo7Lb9/oiu70hyLnQv1DlXYJoZAsfHrBonXfmVsuBBzWCPFsnAoZezuW14z2EL3yKxCUmYopVRrhhgBsMFi3Dpp939YwZrRIfMmw2N+6LnzuO748NMuwE+yE5uRD7ydOsmS2QgGg3AepkF60yjjdbSL+OyCjOKlI+yuuNxYO710qHjV6I9W2ujE46e61dyEQjrcffTgNnl5XFmNF0suPitYmwNhZBj6gk9wFAQwLk+Z4TPNypk0jr8YXyw1ErWDOxJ2Ua7rVdpWi3iCAqWjhcjip2LRxySs0NM8CeXZpfoiqd8kpb8/AhSF9sCxoXOoLGxf4fa8FZcAIUHOeXHjWw5JwqIpMaxozwxjfhNFE+YU3M4pk0Udhf1S2nGll0KMD5305J59ZuOHD6msRACR7lTYz7J6lz5ddZeH6mZlIzSph9ZsNRFtVC/1r39UPMniw3g2z/DB/JIdGmmfRdWFEKpas
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(82310400026)(376014)(7416014)(261009223027099003)(10067099003)(3023799007)(921020)(11063799006)(22082099003)(6133799003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wOKl68rirvGnIa+fEqo2tiYPzRQZQeWJgHoSXPGVIju+TyoHP8DfepuRI17mLbYk/g+Y2Rutov1aHgesWY13jbF0FqekJj5P5Jh/bTWgI3p04qVZ6HXGLbGt5uKtfeH/CVMsvo3sWd9Oik/iBAP8mO/uqi2dkcjKasuO+CZDWfiSv0vDOYyU78VcYNEQE+BIDucxiw3eUv5xvBX/72ymRRWLQg4RvnbWNDkrwvEMryesXuzyojiyY7kG1fRSRDLW/IVd1E1qFfsMsJCaeXJJo41/BAMakZEbRCZoUpmgxaLpPLEYrYhSYQNVn0mFlWHHDIZIHQU7FdDAxsRB5OpSnLd8emH5wmxCdgRAA0/THDHyjCmcpHsnn5TVVjPchkJg7rdWZY14bP4uMcJXsIeSuyO+7kOB2QNaTtVGG2TIMQKhDbcCq/7D1HqRnrzxVBgd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 23:07:37.9017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6592e4bb-d1a7-4f03-a11f-08df2a47f0bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW2PEPF00014675.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5625

From: Ashish Kalra <ashish.kalra@amd.com>

Segmented RMP has two independent states: the CPU *advertises* support via
the X86_FEATURE_SEGMENTED_RMP CPUID bit, and the firmware *enables* it via
MSR_AMD64_RMP_CFG[SEG_RMP_ENABLED].  A platform can advertise segmented RMP
(CPUID bit set) while the firmware leaves it disabled (SEG_RMP_ENABLED
clear) -- e.g. through a BIOS option to disable Segmented RMP -- in which
case the system runs with a contiguous RMP.

snp_probe_rmptable_info() clears X86_FEATURE_RMPOPT only when the CPU does
not advertise segmented RMP, or when the segmented RMP table probe fails.
It misses the advertised-but-firmware-disabled case: that path falls
through to the contiguous probe with X86_FEATURE_RMPOPT still set.

X86_FEATURE_RMPOPT is a CPUID bit advertised independently of whether
segmented RMP is enabled, but RMPOPT requires an enabled segmented RMP.
With the capability left set, the RMPOPT initcall programs RMPOPT_BASE and
issues the RMPOPT instruction, both of which #GP on a contiguous RMP:

  unchecked MSR access error: WRMSR to 0xc0010139 ...
  general protection fault ... snp_enable_rmpopt

Clear X86_FEATURE_RMPOPT on the common contiguous fall-through so it covers
both "segmented RMP not supported" and "segmented RMP supported but
disabled by firmware".

Fixes: 15d974be0a3b ("x86/sev: Initialize RMPOPT configuration MSRs")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---

Note: 15d974be0a3b as applied narrowed the contiguous fall-through clear
into an else branch, dropping the "SEGMENTED_RMP advertised but disabled by
firmware" case the posted series (v16 3/5) covered; this restores it.
 arch/x86/virt/svm/sev.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index bd70c4d0b774..43e4945e6cdf 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -827,10 +827,16 @@ bool snp_probe_rmptable_info(void)
 			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 			return false;
 		}
-	} else {
-		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 	}
 
+	/*
+	 * Segmented RMP is either not supported on the platform or is
+	 * disabled by the firmware.  RMPOPT is not supported without
+	 * segmented RMP, so drop the capability before it reaches the
+	 * initcall and faults programming RMPOPT_BASE / issuing RMPOPT.
+	 */
+	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
+
 	return probe_contiguous_rmptable_info();
 }
 
-- 
2.43.0


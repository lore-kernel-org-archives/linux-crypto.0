Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010029.outbound.protection.outlook.com [52.101.201.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E54F3A3E78;
	Mon, 30 Mar 2026 22:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774909584; cv=fail; b=lYRMDw16vUcWV7x4sKf6i/oSFmaD1OVcilnaFdCWNHMRqjdSJRnuMt3zMREJs+wbu63GbKUmVgFdV6uyiiQSNdDb74aYSBXCXpPMDu+lizM6fRdKX+aymlACORE88C4jHKKEH1XyNndNACE6zOQhx4K+3bXJjkRb8i4HErENFdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774909584; c=relaxed/simple;
	bh=8b/jjFw6SpLIqb006o5CmcoFRMrDZBBo3/ALAdH4N9o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6qxU5gUVaDY4KMDxDuTFfoKvIvmHNPQgAhBklmwt2eHW+J4EJxdG6N6FlbRxMN3PESQSprFPX3pK273Us2HCUhaORdTypYh38VYPBhJ+XbvoUnCA7jcYJDGIx2qN0s6QFyhFSkPg6JWaAfRBQYdE+DsQa9pUQMSteMKzv5SGcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oDgAyJUm; arc=fail smtp.client-ip=52.101.201.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oDgAyJUm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qaSQ1WPehMzG544RTZOy2YSloYAPehc1yFUfY+b/l1z/GKGnEce5TKB4XazPlwDVdyTvsUlAodisF7h9TnkgH3h1w5Bshwvh8hoEW8pX/UTuqD9tr3sICPAhGU1KePz7AjL4HlEypC5A/GB2PmYVpa6805doO7fEucDT+TmtGLX1jOrqRnL7Awtc2GD2y7HmaAMQz/T2R5eb3qakhC3iiGlRUQywrTy46sC5FF3sgZQ3aavsw+40EaELnE9qh6WpyDsgcxjaYL+6uJ8Y2sYqhquZwFcFMPPcYugs3MH5qmsB4YholGSUVGKcLlq/p0Fwcyz4g69JJ4Hp1no1jMlUZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2n/rRCilq0+K/jH2g8IfataLFBbceu9Fy4OgIsKFl8=;
 b=eCjfuC3rRgZilhq1C1WQ4YoQTgiV3vv1wgi2YmFC1EPh4COl+xrnQ9bwznWZAQjb43dXwOj9mgbCEuOnJwa6+6VTvPl6fbnGmpyM7TpSWgQ6jlIAsqDKnZz29cG6CXcs7ewuS9a34kOTPGGrlqA1lFd3uB4dw6lISa+6hPNYhjyAPTPTHA2w9AKwwD8yfFoleg7lCFACI9ZHWaReVv47cpTgSBm1H7TlEXkSFgB6GWNMmIikeQrNC17QqEMmwAaxHuK5d7fxG1jKYtyeFOwlSJFZhKyBoS6R72SMw9Zo+nSm31wAOdV4fqF4mnTigL5CAiSGd7pLUcd32VCYsHgmxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2n/rRCilq0+K/jH2g8IfataLFBbceu9Fy4OgIsKFl8=;
 b=oDgAyJUmt8ZQc09qecoDIZmR6DyWIsjLJvoBIaigUkbnB2ja7jWwLSdb4rvZgHcAsWLhhMuu1Ku4KnNoArx2BMPSa8lnO2OlyvdJtplxjRZFbV7qrcgUgeB8FaidIz+XFzWM/AlgS7gbo2ojoqNEWCxMP4eSUb8oVNsZesv8+/g=
Received: from BL1P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::18)
 by DS2PR12MB9614.namprd12.prod.outlook.com (2603:10b6:8:276::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 22:26:00 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:208:2c7:cafe::bd) by BL1P222CA0013.outlook.office365.com
 (2603:10b6:208:2c7::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Mon,
 30 Mar 2026 22:25:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Mon, 30 Mar 2026 22:26:00 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 30 Mar
 2026 17:25:58 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 1/6] x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
Date: Mon, 30 Mar 2026 22:25:41 +0000
Message-ID: <94d98fb3d479a2551d393f91710e8ccbe5c21e8a.1774755884.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1774755884.git.ashish.kalra@amd.com>
References: <cover.1774755884.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|DS2PR12MB9614:EE_
X-MS-Office365-Filtering-Correlation-Id: b25abb7c-f4b6-4da9-c366-08de8eab5284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|82310400026|1800799024|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	WdS6cjKvx0LTFgd60TO5VZAsnHkqns9wkMsu8XzX76wLkH1HqJeIXb6l85SRPy3BZMvELdPobF2Htxy7XJ6zpstWL8JA5qXHAewiIudfI7T/iCfAN5/cJkEa5S2aRRD4SVX4/g9rMkXt+oWvNVQoaGHdlj3gHqJZbdxLIctAb/waONaM8ODt7eHfbuuCY53em7lj9xS8x4mBQjgzGDI4XlNR4uiU+ZsT5pV2yyB4ilBG3zJ0OM9b7+5sIZzi4rg1ZyUEglvI6/k+kKKdbtqTwD+ul86rz7/0L+IXwv6qdtmgox2EJv9Ud4ek4oiDcwAYADjPQ0FLVhwF5xG2TAb3nZyQ5YCTvURLSRgqgzZ/vOfowTdtRaKoQz4eyzbwLh/Syb5j0Esh8ulsZQjLUZUM1XNl1yoJNHGDcrpSFBb1nwWgbx+/JCg+mSu/Iqw0BIxyaSKGSTdzcaAHaY/l76Uc46CKchbG26+ddAwUhZubTt+we3uxeq+/qYLT0HE/pVEDO4UAhDqn3EKQpGUt//HpAaf1jEvSHCwLyIIIE+paT3xq6wbG3sNEBKm+GLHjJw/r27acOw3+lMsPs4kPwqdMrIjBqKmcbWRU4pTKs30gPx1PBH4X2oyu3dhxKhky3009RoXGHSdw7yCy67OJK/ZujnX9vRlAtZjzUEVK7HP1v2S38fsrRwUbyTNaPzLsndky1hrbWKFEHgiEubQd+/lx3ccazm2sIwaj53uzo4ev+UxAX1pnsP+2vFiE9I0OPoMCOVXesPaucG7LCbPK0v/Q3K6rtCSB4szs2IGNgGGN62crzJl3JRvL4+jXWJioG76q
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(82310400026)(1800799024)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	M1fyoecU9XbtmhFJJXk3DlNAGrEY++2GcKrbZP6sRxsNJ+51vJY4mOxH/IIVmqdKsXbx6jhVVglo8z0tJjkb2O9Tb5UYyXJ8NMpQiiVkR+/V+s40pJ6GR4znu2kbXPil2xTXrQozbmzDV3eY8n4SMOoln+LxgFjL0h6pI9aIMjy5FKjznX2afk5MflBvRxPZ0n6lWeoOAqvpSIOlpoAG5dFVTJup5DatOMmJKWoY+d+jlb8rwauPi9fIlEKijtzN40XSyNUfDnxY4ENYd0I69XC683JCVG1u2fSYdsZmgedOUytUWwrQd27UlLldvduoUcmfN5HDsva73qm2ckt2KJ9UjuAcJpoHMpCpnaXGHu2uhKNHKiwD7J9YfC/bc0nlgZIokwCB0ClNutpyOjT2xrv2Pn+8HI9qxsmfOUvtY/pw6Wu491NBZucSlpyEtqAV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:26:00.7655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b25abb7c-f4b6-4da9-c366-08de8eab5284
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9614

From: Ashish Kalra <ashish.kalra@amd.com>

Add a flag indicating whether RMPOPT instruction is supported.

RMPOPT is a new instruction designed to minimize the performance
overhead of RMP checks on the hypervisor and on non-SNP guests by
allowing RMP checks to be skipped when 1G regions of memory are known
not to contain any SEV-SNP guest memory.

For more information on the RMPOPT instruction, see the AMD64 RMPOPT
technical documentation.

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 +-
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dbe104df339b..bce1b2e2a35c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -76,7 +76,7 @@
 #define X86_FEATURE_K8			( 3*32+ 4) /* Opteron, Athlon64 */
 #define X86_FEATURE_ZEN5		( 3*32+ 5) /* CPU based on Zen5 microarchitecture */
 #define X86_FEATURE_ZEN6		( 3*32+ 6) /* CPU based on Zen6 microarchitecture */
-/* Free                                 ( 3*32+ 7) */
+#define X86_FEATURE_RMPOPT		( 3*32+ 7) /* Support for AMD RMPOPT instruction */
 #define X86_FEATURE_CONSTANT_TSC	( 3*32+ 8) /* "constant_tsc" TSC ticks at a constant rate */
 #define X86_FEATURE_UP			( 3*32+ 9) /* "up" SMP kernel running on UP */
 #define X86_FEATURE_ART			( 3*32+10) /* "art" Always running timer (ART) */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 42c7eac0c387..7ac3818c4502 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -65,6 +65,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PERFMON_V2,		CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,		CPUID_EAX,  1, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_PMC_FREEZE,	CPUID_EAX,  2, 0x80000022, 0 },
+	{ X86_FEATURE_RMPOPT,			CPUID_EDX,  0, 0x80000025, 0 },
 	{ X86_FEATURE_AMD_HTR_CORES,		CPUID_EAX, 30, 0x80000026, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
-- 
2.43.0


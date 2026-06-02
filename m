Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011028.outbound.protection.outlook.com [52.101.52.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF60625B0B1;
	Tue,  2 Jun 2026 20:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780430454; cv=fail; b=agDGa7g3pGaD3zv9MhkgXcWM0m3hKAtrf3ZgiLEMq7e6dsbOSa/PoWOV3ol4ZLCtgeRQ+vLG9EB1naffUbrTpu5e/3qgjI829ImGxupxmRHEIKyC8eJx+NR01tetmlrCq9b+mxk3cBTbZdvg1IPXNIwvY+M+kQy0mzQtIweod7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780430454; c=relaxed/simple;
	bh=qNne5VMGQOD/O3+Cd6I+LIBLef+3u6k7e8k60/RiBvs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YGNTGfXTKTpzHRGjti/3UWfy8OkhTSvI2R8zvs5gUN/tyKUCRMM4g02Zuz6AK6iuDUtN7do9bq8PjAWs0DwpBnCq/8IWHomjONypfpdV5NUr874gv00uNY1biw7vdTeOF6h/T5aCc6VLg5tUtpYPyIZyEMKKQpowMgE8xdIyeR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=izqsbHZx; arc=fail smtp.client-ip=52.101.52.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="izqsbHZx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M3ypDD+CplXoBFSO+b3eRRkNwLC9/mcFrHaqUzsN69l2oeQxOZ95TL0xr9qh+t5fkNZPGIS0oLhvRSzYj6P6uPV95sg7SJBMk94g47VRjx5txrBls0zBHDGsNSgjwMuSsRlefUEqvTPltjiOGBC13HbISUR+cJd0qI1cRdlSahnGFwQbHCiR800huF8JCgPTciKRVDA8n78SMFXZraBqeBitrxmu9kFWUIo26Ivw2l0eWkPE/sFClBRxTzS+MFs/831vZe88sUc9pmVTdEUSnoWockHREP8gNFNjFIHCBM3Baj9vx7+Hsd6tCP5somwKnVKXlCs59MOz2ClBQHgnHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCDOnhB1r84DFebnA0uIqT7RVcTpPgdZ+0ZSZTF7ZMY=;
 b=odESz0XzxKH1Ve+2blyl5pD/K5nZwns7SY4zsCDLwuuUGd8f/pbr2GY9jVnqkASuZ3t6TqeiZeChHfVNWsR/2e413K4apoetMe0Q1+LYQkrO52MbuzMFUWhy4szioCM7AOBT6ADtarh7KrjNHRDtdyEs/44deD0fxMW7KHEH82SCnPsTJNwHjWRVy3tPJ8b8xvNiUbm8omVCnUAh+gLfzuC9GosEnc6R74XAU0dTLfsPK4EtA4FwlVFhRWd8+Gzn86FpF/fUqh4AP+nsME8fJOQF+yFHz0Wp8gyXGurXO1XCIKeQFK+z4WU8MgTuLsb4TPYHEuxZ7/NLEUcUBISzTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCDOnhB1r84DFebnA0uIqT7RVcTpPgdZ+0ZSZTF7ZMY=;
 b=izqsbHZxve9BDkD0VT6P/7KMrDECMbUa3NaqTGYCa06RURpv9lwrcLo3yZ1tK5MW33H6yRVnFa4fRSwp37UOd9j6EZH3K5Nl7UpJIw25TUuB46nxcfzZ+prKV5nMalOzOeoE0R6MP7p1ECATkWkVfZabzDDHITkwOXxBIVoIG8U=
Received: from BN9PR03CA0635.namprd03.prod.outlook.com (2603:10b6:408:13b::10)
 by LV9PR12MB9832.namprd12.prod.outlook.com (2603:10b6:408:2f3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 20:00:50 +0000
Received: from BN1PEPF00006002.namprd05.prod.outlook.com
 (2603:10b6:408:13b:cafe::c) by BN9PR03CA0635.outlook.office365.com
 (2603:10b6:408:13b::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.7 via Frontend Transport; Tue, 2
 Jun 2026 20:00:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00006002.mail.protection.outlook.com (10.167.243.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Tue, 2 Jun 2026 20:00:49 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 2 Jun
 2026 15:00:48 -0500
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
Subject: [PATCH v6 1/6] x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
Date: Tue, 2 Jun 2026 20:00:38 +0000
Message-ID: <5f587ed487c037ce6a1174fa8cdf25112d2c8eac.1780427587.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1780427587.git.ashish.kalra@amd.com>
References: <cover.1780427587.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00006002:EE_|LV9PR12MB9832:EE_
X-MS-Office365-Filtering-Correlation-Id: e1cf1bbb-bf7b-4695-03cf-08dec0e1a4e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|7416014|36860700016|921020|3023799007|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	fUKWtnabKenVcL46OOPy1jnNfbrQPdr5ykNqhoJxgOfas4B7aiF3rYQLO4CKKxbF3uHxdvKMCgNf9zZlnSapasGrnVKiDcxyUQgw1a+kHC1gm4b+nQz41Ouc/E6mcXZCNx0kpEyLSXr/723C/JUtkiHMkiyOqV6Wa1wDZBb10jIVlEyaT6sYelu1OYXoPznDgf92mFn+PHh6/M88hkHmbuJwTjtYGfSdDOMi6XPO2t1lW5FJ9B4LZVuVNq4JajhuKVyCAnSYSxfMcwLrsWCL5LH5n1gKj4L96P1vOSzJK4LNkMKBfLaRZpposzV1PONR6crAoYaLMZYotI/fnucc9TH8l6EC86EyDtEAAK4YhjPaNzYr8uTBj/ItY3d20fMN9KduBBaBsmVpsLdqAPuUqE16gQdwspJ0iiX5qGuKzMpwQ6SBZCd6GFXrgoIcpEzkZffETebKOMTab8xj5tBN/to2UrRP48yK5Rsyc0dPF6i6FvuuCrLtwC8q46oYrZCLJdfD3fT7N/AT1vcFFF7psUX0Q9wHbljVY0bRED45TX0vQhuV7u49/jyLJSJhMkxooFLs9rsXftySO2hKPpfSWMp0oRpCgLMLSZh+vqwvtk3LYyefznJ688qCNYlMeDfEz41FAt9qXCg9Bu3Y16KDZIZpB8NK13lYnMeVJY6aak1MUA0tCh6FqN5DNI2BJdV5hfTx4oBENAxai3XHPcaDT9PLmiLq/EcZekotI5qmhfBA96gAuoMDm7iZDV78Ka8FlxJO90TtjcSD63LVHripKg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(7416014)(36860700016)(921020)(3023799007)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qBJnVQcIkpkxfjL64dwIm85ftGA2dUyM47hUHWrLJUZDMbgDwt0WePeNo8GlXtDVpSXItE6Y7t0byGKBACQ9wgygnsnEJ3SrZpKIg8ZgJH03RgrCljwdBkXcyQ1fVaVKr3YXVo0/SKIV6VDgtu7u5tyOAzohioyscplNaSAV3BCU+VEVcYIouJ/qwIPZjnofdLB9CBOVaejdygqC9Tk7GsxwTqflY6uFHhjNvhodFl6DtzMYMGgYABSCkvnjmgORS3Zy+jyi6XGEZjsjlXnENTCsP6nE2/Zp/dI9aZXtyG4ayItfyfZClUd01sQHJr1ZvabrEoq/aALMMlmWYwToSWsHlnSh4ISA9gPvxtaeN/zle8PtK6OfprQ7UDAQkIQFQp5AiP2f4oRE8WFza3vXNBZzQ3Pl9WPy8n+WuMbEX1L4Cu25BYeGFb7Um06SviUb
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 20:00:49.9343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1cf1bbb-bf7b-4695-03cf-08dec0e1a4e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9832

From: Ashish Kalra <ashish.kalra@amd.com>

Add a flag indicating whether RMPOPT instruction is supported.

RMPOPT is a new instruction that reduces the performance overhead of
RMP checks for the hypervisor and non-SNP guests by allowing those
checks to be skipped when 1-GB memory regions are known to contain no
SEV-SNP guest memory.

For more information on the RMPOPT instruction, see the AMD64 RMPOPT
technical documentation.

Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 +-
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 1d506e5d6f46..794cc96b8493 100644
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
index 937129ce6a96..021c0bf22de2 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -67,6 +67,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PERFMON_V2,		CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,		CPUID_EAX,  1, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_PMC_FREEZE,	CPUID_EAX,  2, 0x80000022, 0 },
+	{ X86_FEATURE_RMPOPT,			CPUID_EDX,  0, 0x80000025, 0 },
 	{ X86_FEATURE_AMD_HTR_CORES,		CPUID_EAX, 30, 0x80000026, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
-- 
2.43.0


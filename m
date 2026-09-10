Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010020.outbound.protection.outlook.com [52.101.201.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A13749B5C8;
	Thu, 10 Sep 2026 21:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077578; cv=fail; b=oKfg5Uedk9rwyb0nBRMNBL/aQb6RYyYu5EpoiHS0ldYBcZwjOqCyzHN42J1D/5LKZDRsox4nl7o8CpIX/3O2y4pb78OJeF0Ykr0CCEA9SEXB73C0MacecYT2OJNednM53ujUK0M4QfjgRWfi4vjeuIVy92tLqpwIuST2IbnoR9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077578; c=relaxed/simple;
	bh=9JkAwJ6pMSnB7ov8awr/g1JBp44NzTda1sHLW2w7RaU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rr+xFptX0WPfYCjXk4lAC9fb0voUM5meWp9UmLd1AtCyiYXgtyk0acKcTrr7vcjE+K8fLQ5pZQhQc+7Ii1KLSdJk4Hexl3se6VtzPJ3eapsnqIgmV1RwTz9c8StIkqPtOiyfP/n+TDDc16dtqprjV48Tam/Zy9kDYEq+zYujmA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ttJUU/9k; arc=fail smtp.client-ip=52.101.201.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ttJUU/9k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ERWbEubA4Fc7wVZaNm6qFUmwfYXonz24B4R17ESvcAryNDZc/c26AQzM1yOzr5MnB1ahhZuvnD6tcopznZJlMtQ4stcex2+n+z2R9CiKTmO99gUcaSDgR+3lbEmzMbovDmcJVQEbg2asTbaq2L8kz18FUHUshmjZNJZ4aPt2Pjzzg32aBAm3lco4o7tfeonpho/d8kMpRXigMDKVArIGwg4W/w0G2DeXxFj2ZcLLeGVPjCgdt8XTqLSVjFrBGoYFFRV9u+U0mHUDphicvVho6bgocHQm+jp5fKFnPSDy09qxJDN+hSPWwKzFccDA1NBkeddQ2jYLFmX3N8TO0w5L3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMhbL123iO1Z2WBPQXbvbmYl8SN1+d4H+AT0bA6j95Q=;
 b=gXkt5rHKiqBY13veRKlO8uN3PkelRPszFPCdTmqtyajhXn98hsp+4obz+6gimD622IOECVKtJvuLT7nLCgf18No7MBqaDmecMk9NHlWxzxNy7h0BebLogcNJblgJsaeQgz/EZ9ZAYHk4omUNiX8hI3amGpIiMnoxhje+LCaVL43/duPRAzw/uzq/NuoyCbd//pXzoRKlekkWThtJH8JyaE94+AD3f2B3YQxUwFCYkiM6zHmfPWHKDZw7r1XJqr20aMCl6P3AhwjO7Bxsn8HhPNyRiDv8Q5oUw0iOwJvrustkfG0N364eiYmtdxeyojiDvQ+PvQQJ2Z0597NFKj9HAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMhbL123iO1Z2WBPQXbvbmYl8SN1+d4H+AT0bA6j95Q=;
 b=ttJUU/9kykb3yj3ehKky1sShFhExOWWUUF5eK74Z3b92EtyyFTfyiOgO0GbVYvLVzYTcStrsVKaSaFA2W2n6cJkdG88Lzvd3TTsQJDF7ZVP7qesYOvsbNQSOwsxElbm87V7BhT/EvTDH7n8s1w93wX5ppadCXPnVNPElLvi//tA=
Received: from BN9PR03CA0936.namprd03.prod.outlook.com (2603:10b6:408:108::11)
 by IA1PR12MB6066.namprd12.prod.outlook.com (2603:10b6:208:3ee::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Thu, 10 Sep
 2026 21:59:32 +0000
Received: from BN1PEPF0000468C.namprd05.prod.outlook.com
 (2603:10b6:408:108:cafe::9d) by BN9PR03CA0936.outlook.office365.com
 (2603:10b6:408:108::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.6 via Frontend Transport; Thu, 10
 Sep 2026 21:59:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0000468C.mail.protection.outlook.com (10.167.243.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 21:59:31 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 16:59:30 -0500
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
Subject: [PATCH v14 1/5] x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
Date: Thu, 10 Sep 2026 21:59:19 +0000
Message-ID: <40510457d85846fd9138b622a01bebc360e4f72e.1788984053.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468C:EE_|IA1PR12MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: ff831ec5-fab3-448c-e3f1-08df0f86cb12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|36860700016|7416014|376014|10067099003|6133799003|3023799007|11063799006|56012099006|22082099003|18002099003|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	dLz3Y13oO402KsgnPAwHmETGbPxwZcc9FBWAyb65zv8O2FI+ZcYfKBF/hFfccVjctKwjW25U/q9kw3ngMZvl1rf/spNh7qOLjw+8ZF4tevz3mhiwgsGnGiK/VkKTPBkafNgTKVrkhsg4VL1qfISEMz4cFPj016VTZp3ppkR6cShQJvjY6CdOLbJNoPxadR0fcTDATto7E0MVnEBuwNqCny7RIrZ1VdqbOg5vhq5Cf7/2gtyX9qHWxuv5iq/u5VLlga1Css8VTQg5N84ckM3Fnwl6Osp13quZtUQg2XX3aXVOSyD/TfxSv29b5ZFIYDUemHRlf45juiPRDXzAUHHAfE49SaeT3xp86JM0yq6v5Mk4hNLI3yozbEuQLDNioE9+f7aFPfETeuOUfZJi9nVCEUY+VDE1hmTyFzUzlhnp/f4JKC9e1VCZld1hzLxNAeXbJruTl9LnKKaiFVw5gWg23fYBAUuhfqb4fnnwfP4gMJRWVMcCoq/uhfNkx8fSKvF7qRY/BBKlRnvDaQGnG6xFVQSPrCFSa0NYQuNGHUo57EbxZUKHpE/k5vyFVlYO6zPyMg67/YISSzgudqo5EAYVHaONW2dG2mkn6IG7oLDIIyQriSQL/9IS6dnXPX9Oxt1BgubJJc1+4pvM/HUJ8+femctiCTlnQwoCKZYUQ13oXFTSWWZWgMNBb9x2viFYgfyrKJEZknHIpeSwh1CbcEQK+w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(36860700016)(7416014)(376014)(10067099003)(6133799003)(3023799007)(11063799006)(56012099006)(22082099003)(18002099003)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	v40u9eHpBWOcWckWjzlcrcmwX+Px6i60NCZw+jCIkAKEhC2XFAkLnYX9h/knqrHT6zkejSO3c0f+YesBjTO4UD2WBqXqkS4lGCJrV9fLxX1ork4Sj0wksou+0rSUifEPbz5smj5nNXFLeKijHaEK7jIv6qFQms6Cq6ahU2G2JhDo5IWKvfAo2aqsVLCGecJywChbn8DemfS6wqX7htA0l5DbH6wwOHuGN0BqwoTzzU5+6pSegl3LSsJlrhLaJzHwMkyv3ChvO097AN/oPNpafUu6dzLWaRYxwsfWKpMLUYZabjkDwMgOy+bsAu+dYSIPrhPwbZk9uLK4Nn7RyAwD5biUvqT1czcjorVIZqujXcqhpv3Eko+kx3DxJ7RUlgW2YH+2ZkxgHYjL15WPooFyP4x92Iial/s5viHfYofbgHUZfJmpk/+J8UmHlWVD+c3I
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 21:59:31.6490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff831ec5-fab3-448c-e3f1-08df0f86cb12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6066

From: Ashish Kalra <ashish.kalra@amd.com>

Add a flag indicating whether RMPOPT instruction is supported.

RMPOPT is a new instruction that reduces the performance overhead of RMP
checks for the hypervisor and non-SNP guests by allowing those checks to be
skipped when 1-GB memory regions are known to contain no SEV-SNP guest memory.

For more information on the RMPOPT instruction, see the AMD64 RMPOPT
technical documentation.

  [ bp: Zap respective tools/ change. ]

Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Link: https://patch.msgid.link/39e9ee269a572c516a3f4e937bfe12d00697d5e6.1782841284.git.ashish.kalra@amd.com
---
 arch/x86/include/asm/cpufeatures.h | 2 +-
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index f70ee74b5f92..3b5b32d3391b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -76,7 +76,7 @@
 #define X86_FEATURE_K8			( 3*32+ 4) /* Opteron, Athlon64 */
 #define X86_FEATURE_ZEN5		( 3*32+ 5) /* CPU based on Zen5 microarchitecture */
 #define X86_FEATURE_ZEN6		( 3*32+ 6) /* CPU based on Zen6 microarchitecture */
-/* Free                                 ( 3*32+ 7) */
+#define X86_FEATURE_RMPOPT		( 3*32+ 7) /* Support for AMD RMPOPT instruction */
 #define X86_FEATURE_CONSTANT_TSC	( 3*32+ 8) /* "constant_tsc" TSC ticks at a constant rate */
 /* free: was #define X86_FEATURE_UP	( 3*32+ 9) * "up" SMP kernel running on UP */
 #define X86_FEATURE_ART			( 3*32+10) /* "art" Always running timer (ART) */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 8665a6474806..d1795ce219da 100644
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


Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011040.outbound.protection.outlook.com [40.107.208.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7125939657D;
	Mon, 18 May 2026 21:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140536; cv=fail; b=P9/rp5bbHSuCQTue4TssRmFI2qUCHr2M8lzyIwUa+qZBVf3Bz8TynsW7b5VxXiptTbTsF+gWSUejp8EJmjeFLajO+4MU69PNb7N3OkUkhEdGYhIshpHlyeZibH43SLU1+jgCzZIMunCwzbJkEtDaoswVNBF0dYlgsmN55plaOpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140536; c=relaxed/simple;
	bh=sLN5AmOajVJaGH5CIEGmacfAvxKRgFVGv7NYWOfd7AY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aDP/QZxfgben0w+EjVIiIYrWtzBMwp/NT2ah2SnnOByWIZcvtA2OgKt27f8TWjDbIxsafXvRylOwI7YrZ1anSHyAfQwZKCfQrJMbal9uJQD6BkJ59McyB2MseWZ12PI4Y1ADRO1ZQ+Sk89vnlRoD1h2QQsBFyUH3PEGMV6c5uGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=J/2X9ki8; arc=fail smtp.client-ip=40.107.208.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="J/2X9ki8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XCpLcP+7wv0ZGjvQK2rVc9CEs9JmYtbYOS/sy5J8Tf3SS0uS5J5oSlRV9PPgdvUFjrOi4optCoA40ERq8MzMfLlnZOHxvwYtK188Tl/B+RJsF+bi3Jw6zi/nDZB1k6W/L7/71kUB/IPhrqf1yNygHv43xtjCzPMhsxuxu6BcMtdblEs5xJXmeT1iIP6HmFPrCil2Rv/nuaGrvjbNmW85mNYBG2jc/OG99mNXJjwS3tiL8RT0GoFh9nDdpz1lhqJ1f+s0f56v4NhecXBmyIOSDiAAvV8v+wcvtfiF/gTsRch3fmi7sQFsF4qMfP/J5x/nLHsvceCj9LY9zJ7IUgnl5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOPZ6AuKEzThiVFV+sWlKZLoRw4NSQECVUsoQ5th06A=;
 b=hUSg8IHh1WAK3FhtTYObA3TeBVKVJj/C0Dt597h4i/kfD+DwKEm+Jh0KzT0kAvPICyyKmN9x6G2NS7HZKgz7ynkvElCOI+8rdQjKxFV2Whn8pjobzwwo65sOnyXHoDOVQXI0HcSb65kX5NV6UQ0EFiJAu1jVO62mYnMK8+c0flphGVGm/fPTWgSJpLW4r+B4pvEHWn2KkGrMqIHWfjf9ngkdmKtBlrME2ahi1Cqrj7O8iV6p5fMh+/MvkSlzaVKyACG9J4I6EZoNZnOhfR5QDxcTcBCaLfDOd/nWWW4FVqLaO952vWCGZVbTil6l1KdvyRqccWNSXJMl0E3QpvbkyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOPZ6AuKEzThiVFV+sWlKZLoRw4NSQECVUsoQ5th06A=;
 b=J/2X9ki8zoIeYRE5Tn5PGRKNGKKwolV46ohMrJ+/GNn/snP1v6N+07W4dQuToswAL13pIW4XqkHFPL7lyzEg6fW/aGAKJwsXXubqN+NVN0aAKdPfC0SvSgpWguX9OU5OExPTq7FsBrMbF6iu2gbbRLulTJFZmO5d0izCLVKn4xU=
Received: from CH0PR03CA0046.namprd03.prod.outlook.com (2603:10b6:610:b3::21)
 by DS0PR12MB7828.namprd12.prod.outlook.com (2603:10b6:8:14b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Mon, 18 May
 2026 21:42:10 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:b3:cafe::36) by CH0PR03CA0046.outlook.office365.com
 (2603:10b6:610:b3::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.23 via Frontend Transport; Mon, 18
 May 2026 21:42:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 21:42:10 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 18 May
 2026 16:42:08 -0500
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
Subject: [PATCH v5 1/7] x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
Date: Mon, 18 May 2026 21:41:53 +0000
Message-ID: <305b625c0528f16a95542001c66e643fbd3a2622.1779133590.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779133590.git.ashish.kalra@amd.com>
References: <cover.1779133590.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|DS0PR12MB7828:EE_
X-MS-Office365-Filtering-Correlation-Id: 8151e459-2686-4150-e05f-08deb52650e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700016|11063799003|22082099003|56012099003|18002099003|3023799003|921020;
X-Microsoft-Antispam-Message-Info:
	X6Zo3dqiy2fjT5oEgrhxc2xhVb/Q6Zn5xFGMKQKG2zDJndzsEMGDkOtgIjysxnIb+28z3JrB6OmKFWCsu1TEVSZgzhKe8HUKG1GtLsV7TsBHFR3hBisQvT6Jln05QuS8GeHU62M7LmGaI0vabQFOh4QxFBLoKxYuOrxBJe4TJUYhiMht8Tc3KrQxudRWQjAdAF7568r+OTx4LH+MYqNOp9SBIG8ikZSnnOwR1u+ObAzA5LZ2lEPxc0nI0orLONPYA635yr21pCyGy//fB7l8YCwGbw8GWyy0fR6uVqn90v5T5LZDIYVstAZvnb5J27mkotSCZZ9E/84+KDMxr1fagHx0xk22xqXo51GJIY3VX9qHL2tIb1aM15t+HyWkE1NGX13wk/t0NL3ASCu0/RuJlg0PZ11lh8KRhJGeD8ejYpjlnzdtZsGqpjm/2loV2lt8L+hJVkFlsYGfbDbcAL2Ua84iQszXU6FUSSgfm+BPWzgKkJZA6ye1VUf3fLXp39X4EQ+gfVQxfHoATFtgUhyC61YpVSX9/k4N3CLj1QpjXlkwfdpOiwbL4HwqoqqTCpLsvO3Z0fepnIQPjJLrc4zIBn7artoifSISodrqC7EeHLg4kZcMSKWE8tWNl8INf5n157uxIyTAWFu4/JTEDGaxsSdiuiKG3acW1wOcSNFnd/Dvkx1bt+bziDJ09SxubTBOLtHsgGSt1XiYxEeRwe6ctj2DlgQkhx6ebD9vK4IMdi+hWI/dQbCMTdlXCAzoShHaycQfOgGY/puSGcGReqRYzA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700016)(11063799003)(22082099003)(56012099003)(18002099003)(3023799003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iQjRZgZZWBCR0kg8nrtGiP6sR2YBzI+6xYATbac1W/AuC7z2vX8ui5ab8mLrHqaprdPsdOPzokvawtkwDpyKwQwo+fJjiWUjBTxBqmYJHI63PxwuxFd5ALcr1nxUsaG5PoetDgh2Cr/xcdRCkU8Moxx9LRqhxCPSYIDJ4NDsDYJNL5RpgYq+hUPVTvp6cf1Rchty6XHZeHSYgc8Dh9AoPc+MYTne+b/Zf+03B9RJ7TkcNj58u6eRfsTumFx/kxV1GiaLFrNLwBFDsCxezUYOqJkj7xtrUBu8XI1TXd8kLax32zBlwJ1IIgE4JZ3D6uII4Hog1A3Tep259rBRTnX5poTPIdDsgQzy+WwDgrOK9gVQ+9JzfbewI4mr8OEs4CLKsmLhZ9nlUz2NxUiWpL0XBTiGE39naubIkjXQHTeNLrx3CW5ir3w4icL9JvOQCcjF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 21:42:10.3217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8151e459-2686-4150-e05f-08deb52650e4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7828

From: Ashish Kalra <ashish.kalra@amd.com>

Add a flag indicating whether RMPOPT instruction is supported.

RMPOPT is a new instruction designed to minimize the performance
overhead of RMP checks on the hypervisor and on non-SNP guests by
allowing RMP checks to be skipped when 1G regions of memory are known
not to contain any SEV-SNP guest memory.

For more information on the RMPOPT instruction, see the AMD64 RMPOPT
technical documentation.

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


Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010041.outbound.protection.outlook.com [52.101.46.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A71F2D6E44;
	Mon, 15 Jun 2026 19:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781552921; cv=fail; b=j8u843z0Pygwtul3g82qnNUgT5SjN1SdoSAzd4jo0BwqoRR/sUI/ycNfIOtiExjce583emtBde2TkAQLhYzlp1K/maVqffyTwOoXXO5R4o3iTaEZV9YybCnppeAmoKACKXDCIyDj6CJqmB5M/XBZptVOJmfVuowKAYqNYxL4i/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781552921; c=relaxed/simple;
	bh=cfE+5BkroTlDquQX9s43a4CDQP/ryxiN4Maswqs8IJ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IOyjSdG+FLjFba4eAcdqWe7iFmBDaYuSJsIHg+jllfbz5fpB4CwtseWZNazkjdhGib8E3C5uaJjuc+PHyDtbyvKRspBwuKcTO9E+4KkmAP6WUJ5HFv9HYX3zuvLHdELc9pFoAxjtvORA7Mt4e5zVVyosxxmb+87zy9nHtGW5bHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jZTpcivw; arc=fail smtp.client-ip=52.101.46.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jZTpcivw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yrDSK0bqw+AaQUclOhZKQ7Fv2p0RGnCWu+HmSXmRMDqjrgGkmBdWGILqS+nXVyAtQbEzTF2TUJFEoUL8bQrfapSv7H9W8ao0n/VxKj1q08AhMR8cENN8AbI2df3v6z4fIuw60bLozV80+cjxtZFyLu+hxJP588+Nzu3WdNi0zVFYeq/xZobuPTHOG2SJa0AWlTxEvHf83GlG0MizfftWKD89viluyLHtoIl6MOvCsDlRNyL1cYGb0XvYSm+OF/9LIN62MmA5o9W0aOtDgKxKPXSQtdcFPnPtUlq1fYUjwCN4vh5pBpN9o0QfKRmE6zLcnZYuOiGnrn1UTaeiMRfo9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xAQ2hA7W3Xj3xmfiLBDjKhOXSiQ91BB7DkXwb4X9yc=;
 b=m5K0rSevL8mGZkQF8mBUxxUwH+sknRtwgAXRzZIraZT6BOuhl0p9WaJcLXnwml6y53/J/scpSLxEAWFWO8WDSB2oLf4XK/1LUHBcTJaY890j7HCc7uHCDgQ6l3qCyCO1rIHNFiPKzhNsAxlhjc/ERfHWTPxUA+09heYPLKub+XbPjSLnE2Spmp4adEvikX3gYDFkS6CaCKIRDCXbwlkS9lM5fCryxVicCLFQtocMk0rHFDRkHX399Eb6pCOoo/AZQggLjifm9ECLM6mdrvDAu3NlCO//pmZuKw/Jw/2hluIlglAWtvQiQXSvuLTv6B6qnU/6do1/T6nuO4fE/e13wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xAQ2hA7W3Xj3xmfiLBDjKhOXSiQ91BB7DkXwb4X9yc=;
 b=jZTpcivwSNZwzrtHuF1WOYKtJlhm3SgDTwfd4KjFdZMnmJdJth9J/pPtBBiqkMcSkJfX+/ESwjBaBtzOTsIuk4QFHqdJyjXk9PCgr7rD1aScd684r7eefaHzuaM0nbQAU30apsgTo143lzh903FN7rQenqgcZA0hRoi8PaX291E=
Received: from MN0PR02CA0020.namprd02.prod.outlook.com (2603:10b6:208:530::31)
 by CYXPR12MB9428.namprd12.prod.outlook.com (2603:10b6:930:d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 19:48:35 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:208:530:cafe::81) by MN0PR02CA0020.outlook.office365.com
 (2603:10b6:208:530::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.18 via Frontend Transport; Mon,
 15 Jun 2026 19:48:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Mon, 15 Jun 2026 19:48:34 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 15 Jun
 2026 14:48:32 -0500
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
Subject: [PATCH v8 1/7] x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
Date: Mon, 15 Jun 2026 19:48:22 +0000
Message-ID: <47ef32931e5dc8783d2cb88eb4ebe8fdd92fdfa8.1781419998.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781419998.git.ashish.kalra@amd.com>
References: <cover.1781419998.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|CYXPR12MB9428:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b2c72cc-9252-4890-e683-08decb17160c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|23010399003|376014|7416014|36860700016|22082099003|18002099003|921020|11063799006|3023799007|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	CfleLT6SJ+dBm3TmlJKTmfg1mwUes6HbR8vkJqkOHcTazUyEIS4wUgfcXfBdLyHsTPmQ7gvUN4sROQLGTiCPpAVgYeZp99BhslTSlsKogn73li/oK2iKO8mutPZvrVq1o6/yOiijW9c7aT3FrqZpSS16WNXqWpgUl5MYZPBRICVqyQIAtVkI28VGRGA6zKt8rQXOaxrNQ/vnRO2XKtEY/nHenELK/BIiDf0+4+DsZG4AbDuIjXxIT+/OkV7a9jFDr8cQgbbc15tty8Sxr7iOCHj7c5n7ymn3hV9Arx4NUBgKCgskV5pVGK+34dH/3bSX/hYTJ2nwfEC8PkpEAv7PcCnMvDX2IBNqXD8CtMwEm2WNm8cF0UZhYPc3QadwqXSx4LIaeU4Kxw181SCHXzT2xUP0SOM0//Y4CusIAohJAVe7WS/GC25Czk6ZXlstj5hcxa8k62dnjCk4mdiue31pF6pLD8z9DNc6N3bTovq9O4SZTCBwBcOo17Y6E1pzXdEvzHDiDuzS4lY7A70vvWyTUNodzmNP6IA3Dnnc6MZPIovAynokNBuIzO6Ip/9dUz7OLK/r7EGjExo09LHnF73gcpbtUP5R4Aj+KMc1BBL5MJAGqQwr5f5ujplDv6Q/9MSGId+lEPlGR+20v8hHRBpIKDr0DfpINKcdB6F4xVqMO0vuLdtI5cwiNjSFaJEjmtiaeIQPx7jH/8Um9p1JHgrWmwZe7H4kDywy+HwLSa1BeTYkZo4upzZYDudmpkomnqcMqTXnxlsoQTkn1nSLrgd8nw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(23010399003)(376014)(7416014)(36860700016)(22082099003)(18002099003)(921020)(11063799006)(3023799007)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CmulqFgO3c3PJ0RaRhMNbHgnUuEIoZXK6+6SfYGla2FjzQ0XrSKx6nbkvGIU45CC4juPZI3nLni9FUWroRb3N0dGvaG0artRy5BINojZkfTUO19hNc0DOZ0Z1NfyxrwNq671JaBM04LhV+rk/YNyg/EvWsNUNG/FnUS8oQlP8zvzIhmpwHWWUT0h9nCazPF3N0RjHW5ldwa8axfXRSZPkNsVGEqZru66OGTw4gwMLLPhpdqVDtlPOz4QsIm6fkIJKqH5A2EOEv36umzfGxMGVPES3yKbOH1p0pNOwQXOTGKuflcaTf1+lhQdHb28v8yIQ0P0LEwx53IpE58c4Rq3xUmVH7ejE7f7wT1Sik7hgAmxSIhmR9ChIUe/dmIJX26zxN3aRAYloQhQhv210E8u/4haKmf5veCzWkvznYlrKUy6j77x8xBU0+gPVsoJZRxd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 19:48:34.7363
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2c72cc-9252-4890-e683-08decb17160c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9428

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
 arch/x86/include/asm/cpufeatures.h       | 2 +-
 arch/x86/kernel/cpu/scattered.c          | 1 +
 tools/arch/x86/include/asm/cpufeatures.h | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

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
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 86d17b195e79..7ce681af1dd7 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -76,7 +76,7 @@
 #define X86_FEATURE_K8			( 3*32+ 4) /* Opteron, Athlon64 */
 #define X86_FEATURE_ZEN5		( 3*32+ 5) /* CPU based on Zen5 microarchitecture */
 #define X86_FEATURE_ZEN6		( 3*32+ 6) /* CPU based on Zen6 microarchitecture */
-/* Free                                 ( 3*32+ 7) */
+#define X86_FEATURE_RMPOPT		( 3*32+ 7) /* Support for AMD RMPOPT instruction */
 #define X86_FEATURE_CONSTANT_TSC	( 3*32+ 8) /* "constant_tsc" TSC ticks at a constant rate */
 #define X86_FEATURE_UP			( 3*32+ 9) /* "up" SMP kernel running on UP */
 #define X86_FEATURE_ART			( 3*32+10) /* "art" Always running timer (ART) */
-- 
2.43.0


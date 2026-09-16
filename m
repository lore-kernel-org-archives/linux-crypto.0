Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013003.outbound.protection.outlook.com [40.93.201.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516D34418F2;
	Wed, 16 Sep 2026 19:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789588381; cv=fail; b=EiV7sHIDQ/MiCk0LIkdDDFBtNak37skkoiE89iYuJYQ8t6LHn7qBl42IkyK03WBZDXAtfTo/g7PaDCZz5cQsvcd2/HMPJuzSez4quqtWUB4MrxAOfVUvvnp2rmx9OO1mB12YJtTfo90lJYNfqA8oKnWhEMaqmDjjdTwcdMqf4GI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789588381; c=relaxed/simple;
	bh=9JkAwJ6pMSnB7ov8awr/g1JBp44NzTda1sHLW2w7RaU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OvWd3v/8b2878bVaUA5te5UuHAQwtczwDECl5hOFx5KutFZqfqag/CHFBK7DlNMkF/q50JLyXW5oNC1ie6qxbd0TfIjwwt0BEsR8rp5VT6a60R292pZ12Qk4KiidjO2uB1dP74Js+XFvXAqWLRi7t0CtyoPpmA8FRTpWeVk+MPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mXFwoUFH; arc=fail smtp.client-ip=40.93.201.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mXFwoUFH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m7SN9ia0+V+qbgTaYgNZWSso+IrnmZ++X3TLQdEW3iWmITMey74El377VXncxEOk6sxwmwHxK2e7z9lVNKUVBtD5J67LmfBcfY26bEAsd7d8sTnMH5BuXx9Q//5j+GAYJyEgw7tQxRVhk667xITlkOitFalK0kO2bI8YxFLAUNe6cCe6r4MXVUZW7RV8nnyTUhJ4Q26JIgiZQ52T+zXAFH3Ix1b4xIlI30zbgf48bsVtffX/jwmcepz8m/adU46R/eCvB9Sf3NG7vTHV8U5FQDa4aUY7liH2BCSGuE9vl9jX2xopon2E4c2VhUBhP0JBJRQtSYa5zAOPHS9g/9o6Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMhbL123iO1Z2WBPQXbvbmYl8SN1+d4H+AT0bA6j95Q=;
 b=ZLsQv7j6sKlphwBqPhpuWDAbnxXX2A4PSOvRK2iuZ8R3hXVIa47lAUn9EMbtbQLLmz2LoKtcLW6BKRLaIK7EgLinjB6/SH3+Erih7+H8CtDugSAySPPzAose4sc97KgcZpn8wOStHApiG+OXdvAtwjisjPGQ7UauBmuKsDUffCvTuUkHBVahT5nF/ngUeTyd2gFTUDXCdGwb1Dx4uE6l4tE8HNLwfOE7Sj/kofE3HJYbciDPCF2znvtZ12Sbp4MtKJvo09BoSkm8q5dDtpSw6aIHNAvw4aqopcSakfP6NKit+kp+ko9mNnO9CV+5uxUoyfuWEzoWCX3kVKBn+pDVpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMhbL123iO1Z2WBPQXbvbmYl8SN1+d4H+AT0bA6j95Q=;
 b=mXFwoUFHTJ8WVvwTpLSlMdWz3/MFKq7YfjtpvubUFeLylwkuCZz4yNXW0A0UFZqMrbiSGo08sWItezIl3UemJ7OmDm9Y3VkTW4yHOYMUarx0Y9KRxmJhR8HerOZqxEnX6wtbDqLDj+8w7e7jwF7eZgYhIxR09r3cfDGsPwGGviM=
Received: from CH0P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Wed, 16 Sep
 2026 19:52:40 +0000
Received: from CH2PEPF0000009A.namprd02.prod.outlook.com
 (2603:10b6:610:11c:cafe::93) by CH0P221CA0012.outlook.office365.com
 (2603:10b6:610:11c::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 19:52:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009A.mail.protection.outlook.com (10.167.244.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 19:52:40 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 14:52:38 -0500
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
Subject: [PATCH v15 1/5] x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
Date: Wed, 16 Sep 2026 19:52:28 +0000
Message-ID: <40510457d85846fd9138b622a01bebc360e4f72e.1789586444.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009A:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: 277e8553-3cdc-4f94-2580-08df142c10b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|7416014|36860700016|1800799024|921020|11063799006|56012099006|6133799003|18002099003|22082099003|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	WOOW7ZyuvKASUZdl/dFcQ7ZIp3n7B4kG1LumTvFwcw/bkWuhDdS3SJ4IvAUNF9/IXnDMPowXz3SNfuDiIXVoUUtjPoJUm5H/eRfMoOhzUMndsvKLCxI0VeI7725AJS9KVYl2aIZ693nb5plto9pytUcUhQuv+3AeZU4flm1MJDaZfQ7fKc4e0K11GwwH+8X5VhdjXhvk0EYQ/ysr7pqEzobd4bu9ljSu1t4NFsKrvV8oKmFlaa1i5UtsSF983rdNoU9LVJ30SbHdJBHbKIsYMIFpYQqddm6tg9PFlVVjIExmaNCPbIic5iGcykVz8C0BeI+eZHRrOJ23dJtJmwHhYp7kIJKReNfnpSYyeAJ0U0peMrzlBxZsuD6uIBraY4FXnjUjz3+bvyNJL31wGvSLG9VL0jAnrYIAMFSOAIodQ73pc8efcVE/pvblec7gtHbdm1BL0RMOvFz6hh5I9ozRwm1MWtcphRUA58fWH/+eVEqJlLWLcVf9sF9He1Ji8XoUz0amrlze9dlejJOGxSF4GTI37wYCkfgisgAR3Us2U/TFOkq9rx053YOHPCoK/u2Saqw3j+hDA0vbuVXhV0HBS7Nu1X8FTchDd/72wCuTwk2q+KHnt1g7dypcW0rW57PEt5Df6g3YAOVxmW3/X9m15tDx7+4Tp0IWDOqiv0yjekjZF+kEHyMlSfdqD6gZV33TjTgs8EtQY81e5FAUcau8rw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(7416014)(36860700016)(1800799024)(921020)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GL0O4z++HH5xryTb4im7u1pgVWAmdHOeVmPPhmsGN1/gfgd5N5VVq1J25JU/DRcdbhurAKCmFRT7j7GgIqBVKdK/5QNc0tECFbAl3zAtLO3WbOIuiIZjuxuA2Mqjz1d/maVADwcoA//HALqbzGq+ls4lsnGYqRJNvv/MEl2rJpLgWGPAhk+C/pxREI1iz8bO7d4hz9+jgNTNS+bUsoTsbeZy/dQTKxJjRlLODqUCDFoyo9KAIv9kzCvqtD5IGlKbuKc1v0WG7USE2Y9oEUnJ2e0bHkuuxpb8Z02PiCXdxshjIlIHB6/f5Dgzp6tGCRKqVMzw3KaC5lXcjL3Zjv/mRAVVJY0snMxOeP3NZtfkmM44OmnwQsoaRVXBv1ttZmnHuuWNCY9Vq0lMFOkkGnUL3hVaLjrvA3JAwGXTRf5SC5D4AnKFaOcFVwroFZBEGA9C
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 19:52:40.0458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 277e8553-3cdc-4f94-2580-08df142c10b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059

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


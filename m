Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011041.outbound.protection.outlook.com [52.101.62.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B83F313E21;
	Mon, 13 Apr 2026 19:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109361; cv=fail; b=FoDA2sCms0ibUyvIBewzJ5r1tHO6h+EzyNgroGPP7OFFxZRUWigoI3hYlavgY9AfFMETEkd2/CIm4voChxl6B+l0AYRXoKHKvVdzOTa+Ik9kk5kkV/L18QWte2WZtAGNgHIml3VBF0z+FeYFfWeW2zN84qid5APCrjtF7ozdjLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109361; c=relaxed/simple;
	bh=8b/jjFw6SpLIqb006o5CmcoFRMrDZBBo3/ALAdH4N9o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WmxwX4zdBBYhQMIu82EIsinj55ONQVWl+ZW5qMZ58ptYFXXRj42w4W8aV0XEYdqHH6niwMyRgPL2ZUMCosu23T3mVKXlJCJ7of9VeONuDFVp7+jJ1ieIpfM8detxABJ07bQYkwTWIPuAh1iJ/7Dnq3Ge5vBs8YqdePJdFRC24+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1WAzx7SC; arc=fail smtp.client-ip=52.101.62.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1WAzx7SC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVzQAncXhLuuamqHCW7+DtkgdafrreMQiVlzPsolJS9san9ghBp94CZiIodiOwCCNYNe/MejiTRKrs1Tt03uqDVHKYY2xrW+9aZ3jwkdgeU+yWQExb8yTt9UDzApn0DsGqVaVj9aZLRsMlwMhWo5a7Uc1P4rFKZtavqCjbIQ5FGt6EveCgWSRkR9Xx0ZOAtwDjmw8JhqYel+d3vg3m+kSKErl2qINoc8WKLREGts4GBSrsWfMCL0VHGluqmXirGjy+uTYU3b1vjjpRsBORv5uDMBk7Z0i3DLbSozz/wnrtIWzevZI4v2/JjXnvShge9HD8dteK3GDptdke4DVkEVsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2n/rRCilq0+K/jH2g8IfataLFBbceu9Fy4OgIsKFl8=;
 b=ZauHdluib/1iapxnMY3d64lBX1KO22Sq90pQxYUfFLArXLTC7xnU/uW2v4uZMSuPzWvFYAFpUe1nSxwaUAr5V0sNvrAe+qjiuucvKDGLWxRl01GT5bWY2SDgp65umo4tMOX3liiy9KxneQJhgHZ4fzlRFhyybRlGHOw2SpZ37n8hVVx0Sj8qWrEEht/5+Y0EjkdgSKRIqw9qzydyDRyUL/Atf/BBqkRFihYPyXBxEwLxB6lGhYua2Ql+71FVikWkBRUi9m5sbFtPVWe5fiTCLvRlEh1NQiKMubA4ytzfMex7NBUAhdFJ0254aNJl06/4Un8Ni2VvOf7x1aYMFfqL2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2n/rRCilq0+K/jH2g8IfataLFBbceu9Fy4OgIsKFl8=;
 b=1WAzx7SCL5hEiAk2APa+7gWm6699CTNu0mTuVXdez0k02/Fc8PkNw/vlbNOdIE8LJEpPuUTkUmaQ4/6i5BwSQpeXmvWNONXv/ZZaOId/GGP3jZ0CAn39nT0xsXpKBwIDtW/rR5FSN12hN3LiGc/KnF+5wXiPXIppLOftSOy2Soc=
Received: from PH7P223CA0023.NAMP223.PROD.OUTLOOK.COM (2603:10b6:510:338::21)
 by IA1PR12MB6161.namprd12.prod.outlook.com (2603:10b6:208:3eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 19:42:33 +0000
Received: from SN1PEPF00036F3D.namprd05.prod.outlook.com
 (2603:10b6:510:338:cafe::a8) by PH7P223CA0023.outlook.office365.com
 (2603:10b6:510:338::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Mon,
 13 Apr 2026 19:42:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00036F3D.mail.protection.outlook.com (10.167.248.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Mon, 13 Apr 2026 19:42:32 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 13 Apr
 2026 14:42:30 -0500
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
Subject: [PATCH v4 1/7] x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
Date: Mon, 13 Apr 2026 19:42:20 +0000
Message-ID: <77153c889934972efcfc3d210251564f29abcf51.1775874970.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775874970.git.ashish.kalra@amd.com>
References: <cover.1775874970.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3D:EE_|IA1PR12MB6161:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e15fe4-b10e-4ece-eb09-08de9994cde0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|82310400026|1800799024|921020|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Zkoq46pE2UkbqylsZNublahZWzs4L0XJAC0q4GvqWAj2zZi2FIf0oufX29E6/DxPEMfVr6n7CFg1HahhXiDFg/PmJCgJtKkM1UA1vdPhiDC7WTkVrW8+5fcx8feG2JPyGsZT97T9FR9PK4bDeEZkaXBhlaUoCn1cBcY/h0fRbnASt23lHLIZZIhOrDgQaGwem3tp40Qy7ZUNeg/Ii/xlLL0nf/tIA96S6QLf/E6Ec0K7q0PiBnpjO+6WWvGjG/y8DQmqSfmhw099Dx9i8SQ2QcbfWFUeyzfecHq5QsuhGO7KCCxk12V9A5MsyUB3mAYmZyW3YVS0KFHowqan7wBRkCWh9VU7E+D5Zin95biLF3Bj/PqIwCJJ6tH2XLwNpGCU1DP0oIgWYZMWnQlyPW5lB6mbyPd9Tt9RudcafAI39j4YZ1hD7HWSaSMBKadggizvDmXG9SWSxkgu95IAnzklcbFjG68WebwynCNs/+3zp8OMQVSulRZk/V8H2ErUs9G/dYOPi3BfSWGXXMlTMcOH49QqSaTVbX2PaU86OlU8XBHynVtjVjFgjaBY9TlGpxGZTiWXJQ4RgLZTTjve3knOi9gb4GbIxsISFSNVzHE+sILj0cpmYS/tpYcNkd+MD4QB2lhndV8qFj6eEDyoVdMQCYkY//Ome55vJdV76rk2D0ozEcQSgk1DWzNG7G3WZ52E58zKFolmUc/q7aIHW/ioGHYsJLJakijukiA1OX7rbmQy5wYJyZOh0p73LnatqwQPUyzVeFnQbAV6NBeNL1NfJB0I2DdLsszVoVsw4UG1S4VaI0vSXaDIZzT8Cwjuqslk
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(82310400026)(1800799024)(921020)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	c7zOvxOdxSI4JOfzT89OFhKzbu+lQEjT39a5N4hksOxEwbGfNSJ9nMgBcCvnNJ1OaYWl5ZCvkfzJh03kWjC4gnzzvKRKD9QE7iPrKmBdVoIeA9ptvIi7pltzLfAWCI5cyHBLM6WcfyKiru1oRbaYcNupQFGd362mRSqfHb4tmkPOMMbQS5FV/NpgsbGzKt/xJdcKFdxBFvFd79WJyvaFZgGDBqkg0VxupeRpbzYALMiazlcUa3Y11paAOmfcRZaMc9f/TiknwRgQ/A3tPwP7UTxovj8i8O4Ii81KqOfNu91TlnG3OpXF3WmxWjDgoVNyo5GkeJvf15Kr0tG3/fwLq5OhinvitPEcT4F5SVOQSe7pfXzPvYPYOfiI4kJ8ykEV3I+XDRw2f2XPdwAJhQD9CkzcplokHVALUce44ANoQSYWt9sY4MWL08aYQFMKhhH4
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:42:32.0830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e15fe4-b10e-4ece-eb09-08de9994cde0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6161

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


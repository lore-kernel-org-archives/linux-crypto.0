Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011060.outbound.protection.outlook.com [40.93.194.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DD1282F18;
	Wed, 24 Jun 2026 21:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782338192; cv=fail; b=n8t9G91FivfETigHfOh76IbJeW/i9+mU1GMPaw8O1F1/Bnx5ggV6LR64KVw9Ezg5BMoc4Te2Yfh0sLGWyEk/rJFsESc4a2wR2xY5AlR7z+EAck5riHG7g7pq1J91ukXPPU8dXtm/wk4IGIQWdSsBe97u2h43Z9tlNOP1FjJ1oCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782338192; c=relaxed/simple;
	bh=cfE+5BkroTlDquQX9s43a4CDQP/ryxiN4Maswqs8IJ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sZ4YWKvoEWByN4bFtb3TtJOx1uVo9/nzQKC4R2aaSD7gl+xnCFtAbNiiSq3Vzi1qkmnUqPqEAoS4LX/VKt7+4UC4nwYI/FwZBdg5IWhJTlYejhL50IDYTN2YJP9kLUAdLvdV/La8w72Ut2/T9dalwGUew8Kv+I0Pe60CZpyqg4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kWpKrPPv; arc=fail smtp.client-ip=40.93.194.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kWpKrPPv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pzEAvzNsb0gCoIWWunwLt4upm0myiwr5/04tNm4HS7spusErdl42M+DcdbS+uIeN3iRnXTr+cmMHhXe+1eDqoLU5/cOmBArYkBA40REQMt5eShRYk56M31a9/t+254s6bBsht+U/z3o8v+XqoaQcpqXhiPlsPaEScuvGZujcQo/N7M6J8LYwsuzzAR6+zJNvKPHN3Vp3DnfXbUGRvKtdqg7TYoLo00qV6x19YXFvUM9qyHEcDVL369h3fxD3QdkLCTXfuxLfKq3Y0Azhf9Mn9TVwyWfp78J15ttZ97S676VN4F6ytYroX9zLBV2frO/kdDs8JkBFsUSvvqmkT8X6KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xAQ2hA7W3Xj3xmfiLBDjKhOXSiQ91BB7DkXwb4X9yc=;
 b=UWHc9smybzERQc3loogBg98OZYcBUcNMI1hp0pwQ6+Vpx5TOy79aOyZHAWh1V+RUoI5jTxa2v0EroA0MvJbIB1Rl7fPjrMaI0+wE83UVBnt4RTr3aItlSeuYMowNAhaU+cgzOwLGSkRq55n6x57+k3PN8f2vfdi14jYuXrtomJcGQFMz2uKYmbx1LGyrbtXe23ULJuH6lCWmo1HUroVyY7tkKNetwCztRqPTTAMg5tlf9ab42Ld0pEpYPWGfy2mBuEbz91ShBhH5hzCtbuxf4f9eiPnIdHa5YCu4aTLHFxf8wQUFcP++T4HT+QExL1wx032TaovBjEPciRHbrIEYQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xAQ2hA7W3Xj3xmfiLBDjKhOXSiQ91BB7DkXwb4X9yc=;
 b=kWpKrPPvPkEZ1ZH3eZGPsViozS5+BEoxsmZ+uGe38MdgZLxkimxEjJV+x1TqjjcEg2CTW+3wglK3I8ngJG7yDl+xgdCAjk7HYMBtlmNinawjBJP27ScITEkiBDbeVB1pHzUn3vY4j9BPKuQRV6PqfA84iYejXIii5Cep8+8xifk=
Received: from BN0PR02CA0058.namprd02.prod.outlook.com (2603:10b6:408:e5::33)
 by BL1PR12MB5897.namprd12.prod.outlook.com (2603:10b6:208:395::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 24 Jun
 2026 21:56:23 +0000
Received: from BN2PEPF000044A1.namprd02.prod.outlook.com
 (2603:10b6:408:e5:cafe::68) by BN0PR02CA0058.outlook.office365.com
 (2603:10b6:408:e5::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.13 via Frontend Transport; Wed,
 24 Jun 2026 21:56:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A1.mail.protection.outlook.com (10.167.243.152) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 24 Jun 2026 21:56:23 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 24 Jun
 2026 16:56:18 -0500
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
Subject: [PATCH v9 1/6] x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
Date: Wed, 24 Jun 2026 21:56:08 +0000
Message-ID: <3e4e32543d36b08a211919f85074dcbd7df9c94b.1782336473.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1782336473.git.ashish.kalra@amd.com>
References: <cover.1782336473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A1:EE_|BL1PR12MB5897:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ec87115-db5e-4e1e-8e61-08ded23b6e75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|23010399003|82310400026|7416014|376014|921020|6133799003|3023799007|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	XiZNCEBZAhN22uSSA4kBkSA56tkSb2LTLdQg5uYjBzqgiuL6DQabOUBrlHzXbE+0WiloilxP2JY6Oou9itrrYHuJtQlRCFwtXpQ7HhOwJ5Vj7m+l9q7GEWSGKTlPFH3xs2rT/bSr0sH7YxTH3FBQ2M7PquR7/5Ll6RYbqb6DNWJafPsWxiMSFWQP1gIX8S9xEShsm1ZmVKP/Nj3BwcfFj6o8ssgvwvjcL+5gWn9kEcL3tqgvRGs0Sux4d6zoX0o9admhRSZbTZS+7ITw1l4csWuRk7iHhU503HX+V/OrL5W/vrXRtgeoodLrOeWFZ+MJXzXZavxk+igjHJhupQt0bvIlNJhPpngcjHTPXEvTR1VN94ARi/xQFJ9E9DanRJ2sPFpLokxtCDH1PwbKIZ2e/QDNA9Mgb79lW2VyrSpZSqMDZ1sOz4+gbL/9MiLsBjl+1nF4w0JenBWFp+S5bjVAyJ+7uyY1doIFVMLenYkKsm8sqjseB4l5a8S/JkB88xD2VaUelp+oiQHUhtL1vHmKdldOc0rsybKSqrbmCgSjNgMzj4PldVhxsutyKat/1EIyps7/dA5RFV4xyT444CiemTKRPWOUC8BO74dV24UlVQvQzkSwdpWVurCDNzh6xvZsVZcleay9Gw5YmdiLld1QPR0T3ORqUzSC9DguBNcoih3HEiupDXC7BRG3ypCWL5vLMnI3sI+cTd2vNoZ+RManiySjFP9ZE7I8j+kX8+g8HCYRieFLeja9iTATeMAbyf5C
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(23010399003)(82310400026)(7416014)(376014)(921020)(6133799003)(3023799007)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/93Esti9CWQTMLDAhBRo6gW1ld0MrcRvAuR+SDoIFp0dgfKXjnmFotJ5YQRiaWi7lcyvqxFz5FWTRkBU6TpF4B3FCuS4rKVXwV6ox4A9U4ZvAM4LrlQkaVC/QDomHgxkE+glyhM45PR9c6lCOyDmpWdwVu755/mEkZQTvCcweJTDMVQRJo/rlfzX0MrUqqluTH6t0ej0Oka+dlwTKEHnjnI0OCRWGR7AqjbmNzLvB+yIVYflbfNoPpaCL+78/aEXXKRxDQ4sygp3rFysGzqzJrZ7Dg8GWwnSoEOwVW3PH63vcZL/c/badO0HIa20dcKniNLs3r6V/2wVmBqJuzdMdFq5p/nR31YCm5k2Gds96lT/dUMBa3eKMAPXlJahGKZJeDEi2pjKCB2NXliw3yyqaZnW0b1urlvZPjzE75nhf1vaRHyqKzA2E6jPeVjt1eFR
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 21:56:23.0862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec87115-db5e-4e1e-8e61-08ded23b6e75
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5897

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


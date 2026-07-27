Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011062.outbound.protection.outlook.com [40.93.194.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884213C060F;
	Mon, 27 Jul 2026 19:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785179076; cv=fail; b=Pepl7hYilpASQmmX8mnxMsw6yUToGUgspWIC2pjEH4LlsHZSmBqEksRiDJ+MOB9GvJw59aopSwXC3r4356WWJxKl5Ap8HgO0jNFsZazmalRey9MIoJroOr+wakPPyMiBATExVST+FevTdnwo5u26ixJqeTiHQy9wA3HlwT/IgYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785179076; c=relaxed/simple;
	bh=qvWNai0ES7mTf7ZvjBPYqi8697xHSnfL4pgSt/GPAbs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=my85BV07nDdbvxluQPeL8SF1vNixfOPQkdJ9QN2uBXmmsLODA90jRvAlx9ztBmK1XwlmsSvlXQhZE5Hy6bgNB61ptkxn7Zi4OD4iCkyIJGrGiEFOsx5iPANfasenBZGzhRGDtoZ73YyH3Ja7I/18X3kTTZ4etMmfchlwXGPACs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FU6Bkg2W; arc=fail smtp.client-ip=40.93.194.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FU6Bkg2W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HvM7q/hAFUtjKtcAxopkA+e3SYLR6qGuUsUYHZakAdet5dVStNwITnZo0ulcyZma+vEIdYvCIhScLpoKUpbXBRNz0y4F6SRA6/7C8fVp4+3WISrGmqd5S89d33ArX6ryVX8pvWXNYeLF2w8fGZOfA1HlwuZGkTlX9SIHnRI3W0MBQdM6mEebXpoQwXks9UOtvCWeM6XcsIoGj+WhNFLfwhuzE61UkEXoTK6CfVsVJw39ESCXna5doStnDR4BerYZ9ectVVqsATYzfJMP/KhGR6p9ucuKTzOmgcvWJK+y0MG72FsHp+8m9104Lgb6B36pTa9QmR7Wbktexcnwzu5dpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45qC+C/BLdjKkN1+fwWDM9N7hCT53EoYkRbcO57HcZM=;
 b=kIg+Lpr5sqk7sWzWvOvC2i/UIq6rz+RlzR9dLjz3J2WWopv7ATh+YK5xPjALn0ulj46O2IF44FT1ndZOV1BvIxL9K1QFcMNcWwgx4fUvmkhPOpGJNcw90Iggdsp0lbZf4V0Se4Y5B9IVqeveeLxHG0ZPsLgwqSshq3vddnlwjrg7cjmNuw+g96IPuGHIrc5vS586R0OfL8xdzLiJR5bngDI/bLiJdvy1n1QdwqF7D83xNTJX8/LUmY0c52+Z6TrBjFaFftBGHG5ia6tQ15ri/Sy1Ea0ddgpvhTSi/LJdONDqAfJhOgw+cB+Uf0fsWQ5Btjb3oCOba7pDTBtSFF1PFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45qC+C/BLdjKkN1+fwWDM9N7hCT53EoYkRbcO57HcZM=;
 b=FU6Bkg2WSHPqDUkJ70qtm62zCnqg3UGKMaRO12jP7b2adSrrAEftqupqEYXtQv3OxuzSMMKeyIX0Ozyn/4ruSDEZVhHrR2rE36/RNWkVDxLeRXm0oWA1P00bAKo1Kmvh9XjS85yQJX4N6+lwe2Osju8oXYRe81HtvHgqDcgynMI=
Received: from SJ0PR03CA0102.namprd03.prod.outlook.com (2603:10b6:a03:333::17)
 by LV5PR12MB9754.namprd12.prod.outlook.com (2603:10b6:408:305::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 19:04:30 +0000
Received: from CO1PEPF00012E83.namprd03.prod.outlook.com
 (2603:10b6:a03:333:cafe::9f) by SJ0PR03CA0102.outlook.office365.com
 (2603:10b6:a03:333::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Mon,
 27 Jul 2026 19:04:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF00012E83.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Mon, 27 Jul 2026 19:04:30 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 14:04:30 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 12:03:50 -0700
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
Subject: [PATCH v11 1/6] x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
Date: Mon, 27 Jul 2026 19:03:33 +0000
Message-ID: <780266f690d89e32f911296b9b88d9f84d8c1796.1784844080.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784844080.git.ashish.kalra@amd.com>
References: <cover.1784844080.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E83:EE_|LV5PR12MB9754:EE_
X-MS-Office365-Filtering-Correlation-Id: c371faea-a4b8-469a-1e22-08deec11e34d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700016|23010399003|7416014|13003099007|921020|6133799003|56012099006|11063799006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	FPaX/9bwC4pyvJUW4hkrWHCxgc1IutWe69kVGXZaUXYlX0gE7b2IRenqbP+lbv02cDfr7m5zOApahcRNmysZ4YInPXin5diQHA4OshkK4kijWWkD2WwmFDl63ey1zp5k9FyS6bAWA/oGASbIJVqHdq0MqMMsYwXhqPt1km4hnmcwNR4ixkCCrFhbkfHhw0ltrPhQkSdn8TYg9mEv3SRSgbfyrMTx0fucDD0+vpHd6Ky4sLzblTVhPkxDBRnkCV93OPUmCG9tvCTGxuudZWz5MnHN7Km7rgfqY2PNVKl9xJ2s9MKkZCoJB4OAMgFi030p66dHCuyPxv4HqJmOJG0CxqdCUuJ9aPXL9zbRb9qphjbPsZO9Ox7G0YRJGK/g1kGXWXaCp2+6VGu/oUyL06dbCxriVeVhmFIuQgczyTL8V4zYq54v6iymnlucIZeBrqmSnDx4U6i1GWE/6ukT89LwIh1HDBREyS37YP/wll9KZBcwbgwWUtSVF/zf5PSlsH3MIbF3o0txJpxr6J2p8gmWsd3Gz9jddWWDKImr1MnD1XFHHwZIvhcIJygbZ+1IJ7zsPuS/XW0HtO0QHiH8x91HbgPqoHVpYyzukmsXLyTSTpzJ6+9d6wr7Kr3yQp3JTpqFB37GMiGsD4gL6a3kRndQQEXVOdAeyInnZsf/KC34UQmldBXNovQrnLcr85hRw8gf8nKhhStKRFH+1ALSIPGhrQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700016)(23010399003)(7416014)(13003099007)(921020)(6133799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jpID8NzMLCRqDiFJ1/76/j45zqiX0f0ijiFLxDQv4rtc+WaTPKW/23BlB/EFEJ7jKMFN3xjGQ9HOm01ZpfSVygnGIMvvYOzdmliOHBJ937rSWkh8wD1zF3BVO1C+2AV1KPGFcgvxBm7ZXJ3zxzDLG+oKmT62bB8nF/pHFYRGj6E4rbYF+HAz2PD3rvIfJJlwPSzUK60zrk6pOy2ktRxqMm1shri5x+wonb47vY2gMduvc6az7ibsYiuT2RTtOzoEBHLVOMZQ0DSTRgwWx6IY10gWTG2o23MvqJUVl/Eq9UegpzwmxWx9fldYiWtDcL7gMrJEqY/M+eZRxeawbkjMve7Rju3kwA5XEfbNy9erfiD7Hsktjup+ioOLIixaWAgROHIXu8Z18wSUR6ZQSeydHJ63cDqcVNHG9IS4QueuO4ri36RH1B61VMJHy6spFhy7
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 19:04:30.4396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c371faea-a4b8-469a-1e22-08deec11e34d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E83.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9754

From: Ashish Kalra <ashish.kalra@amd.com>

Add a flag indicating whether RMPOPT instruction is supported.

RMPOPT is a new instruction that reduces the performance overhead of RMP
checks for the hypervisor and non-SNP guests by allowing those checks to be
skipped when 1-GB memory regions are known to contain no SEV-SNP guest memory.

For more information on the RMPOPT instruction, see the AMD64 RMPOPT
technical documentation.

  [ bp: Zap respective tools/ change. ]

Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
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
index 3d0940a3b9f3..dbccde9ee5cd 100644
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


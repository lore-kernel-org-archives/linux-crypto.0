Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010057.outbound.protection.outlook.com [52.101.201.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB86C245020;
	Mon, 27 Jul 2026 19:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785179348; cv=fail; b=rP26EP/E9iHXft/wPW4siZUKkHCQCIfFBpZiNF7VXt0PsoMw4NuF8FTYHcBaPKM2DZaER7zLb2TZs52hleLjhzxrIbVEQhI3BF1RNsaOYyqK7RDTYYyq2U2KWl06N2i9rE28JkMDhLMcqBnO/6pytCF7kMHWW1MGHyD2VjbcseQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785179348; c=relaxed/simple;
	bh=qvWNai0ES7mTf7ZvjBPYqi8697xHSnfL4pgSt/GPAbs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bf1jS1F2gpRsjPAR1H1z5sy0/glLUeowQjSV07m1qJDLtt7EeCzaP3GyuUPATvH7YUA6GyjL7ru1mHXagGp8enf4DQLDBfcvPZ1CTEblnotMX6diWyzWg/mXJ450V7Dx0l+SyalfW3crUmXs6AmKKUJUkjbcQfOx+9IPj9IPO3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ItzsE41+; arc=fail smtp.client-ip=52.101.201.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ItzsE41+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JDg+6G+H73LN0p3IH5RUetez/rukSJicpsp2xRT6AAulPVCGe8RqVsVJETJhCeeu93tZqyAvkdXpSwWVebOH9G9fHwL7ea5nUT42RxYtLDEeDk7NN9c7dETfweQ8uL8IffWS5Fwtrjk9uBTrfZv5dnwDkrlOpmtz7uk4w8OrHPYFdo+cOr2cf+klVc5Uo3r7ral/Uni9ieLgpoi6akW+9IMdZPMOP8k5ITZG3ZIYOrWNbuGqD7CO5RG05rX0VCMU6iBQYMXrdhaamWe+ZR7X2uNmeFAMhGnCsg/MjYE/E9kYbUzPPZbpU3isgYUSGc9VlB+gNS8o/haydLcEoGYqjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45qC+C/BLdjKkN1+fwWDM9N7hCT53EoYkRbcO57HcZM=;
 b=cJjMHty2ItvlB2ADhHVzUvddvHqv/844O2qHWelg4J/t+NM4OlsKWIxJMRUyqu46IPJsix7Npmy8MckmFYcZOtFkp0mRc6nFpEJxz5LDKcPcUe3aPZughiUS+Zwz4HIa9qP/dblyFYE1Z5OhRO4HAl0CenZcm2B7g6a7lx45VzfjGwCl7kd0Y+Yxnke2uSGhZG5hWJO7rR0VCj6R88s0h4viEqwdYlP36aExk0hoyd7zl+a6Qdxf07xRHb5+dn/2UL9h5rHvGxhZ7nlJwoWGTPTBOVAK0AZeu+0axVuzrXevEpxDLhEEN3w87RaK5jh9MkJOvmPKPHYm6YZZjO9SLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45qC+C/BLdjKkN1+fwWDM9N7hCT53EoYkRbcO57HcZM=;
 b=ItzsE41+3hs67D3hZozRE9zxNrTuKY2xu9FqqE00aFbmSJCtouHssKGOFb/Y89WIWPRDWIfjCWeoetcfgxLuTc+/ixKTtQzAHhnO7qq0s6m+hvilUI0tjR/TsQkghbXPKO8TU1EewfqkfQC3xl4qNkHgjpcSSb0fCiuK0B357zk=
Received: from BN9PR03CA0708.namprd03.prod.outlook.com (2603:10b6:408:ef::23)
 by MW4PR12MB7143.namprd12.prod.outlook.com (2603:10b6:303:222::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 19:08:58 +0000
Received: from BN2PEPF00004FBE.namprd04.prod.outlook.com
 (2603:10b6:408:ef:cafe::6f) by BN9PR03CA0708.outlook.office365.com
 (2603:10b6:408:ef::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Mon,
 27 Jul 2026 19:08:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBE.mail.protection.outlook.com (10.167.243.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Mon, 27 Jul 2026 19:08:57 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 14:01:13 -0500
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
Date: Mon, 27 Jul 2026 19:01:02 +0000
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
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBE:EE_|MW4PR12MB7143:EE_
X-MS-Office365-Filtering-Correlation-Id: 63657654-d0aa-4443-25c1-08deec12826d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|376014|7416014|82310400026|11063799006|56012099006|10067099003|6133799003|3023799007|22082099003|18002099003|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	UytF3ROJ6cbAEcUtqWbdaDf6qEx5MCjvh7X/oQbQTIE5Cw3Zl1FlSxniAJnUGYeJOc+LQKuJEiAucb88bQQRkgaWTRaRXSp0YyfNSNhljrR/hKitrfvJKmenJTgT4syr43kiiL6t3ucpG55dyfOw69bXhhR7wBOS+/SQDl74beboD2N4Z/cFg9evEBi2S/8nyspT0+ndAZy/zXT41Jtb/ztc0sV/1/14oNdhvS3zVUq1OsPFIacMoN8uHIn9sEr9L1hIlH3ZQqmtaqskGAb6KomMbtHrsiwmMvmsBIx0ym7C2VA5II5luYgF84P8oN2s2bCS/1M2XcXIJHqDImYmzs0Zlsemmt1bFmwq1FolWOD0XMyjo0Tf8xdJjhT3jWGXNmeYk2CCTIyNpKGUtIzG38UFLbdDiD/TxPvM2Zht5ZAa0h0HBgozxUym/SG8nDRj3jtNKQZOpXUhk1Dhu/P36gF5toc5cQgOOuZGe4rmzTTeAoV5lc9iPTCBP5zPgxGxZUtkmrb00za/aDL5C7Z/5y6ycJD5I0m8z+TvFaWST4RWHjZapH8VV04VcI6sScHcHqdR96fmRuRhtuMj+9UcgNQafKhnnCAJvDEKoE8VTXcy8czu8dECyfrf1F7A9/6DGbKYi6zbsO+r5RPky059/9ZUyZyyQSBNTtzleq2HWRc9Lp9Qm6n4j/18EqmL3GxywOjsZcLesmh0Jdi4+m29xA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(376014)(7416014)(82310400026)(11063799006)(56012099006)(10067099003)(6133799003)(3023799007)(22082099003)(18002099003)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	R3GWQ6m0A9mK2yLdey0uvw7b0U2eikN/4r5KY0QBRBycGf38NBIfGbObiUNZOKqm3FFVKnNpT7dDI+744B8YARvilLOoFPjF5MaOXwfZgJZeNnCkGBqd2suGQAqv9Dr7ymulgY1gIFngSIxJcUZOsxnFiskeyUq+qA17yf3/2/bUrm9DHVFKBmzrOVYqK+U7Hli+Gktw6Yh9zwvbGWI8gtINStUao/56uHKptPwCXJWLYbImbqQP4MJL/1NTwLSI0+tNe530HWAu9mVS7PZ7PIKbTR62IFVpP9pcqt1Aa6Fl6oxWJ0OiLBnU2gPC/PTlZZPlhWJj2nzLTvK24HRC7u++vH5MursKooQ6u+Zmd9KDhH1oZ49W6s0oEQZX02S2qI4zVEwnWdD25Fk6kSQ9H8GGZnXDfMal9JLO8pVbYo8MqquxOyuSI9mngGMB/tzJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 19:08:57.2869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63657654-d0aa-4443-25c1-08deec12826d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7143
Message-ID: <20260727190102.IzD1zQOOW_-NidZ9_l6SBzfwJmltm7rvbcHYM1QbbeI@z>

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


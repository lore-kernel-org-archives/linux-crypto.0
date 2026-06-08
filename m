Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012026.outbound.protection.outlook.com [40.93.195.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713F5384CD8;
	Mon,  8 Jun 2026 18:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780944999; cv=fail; b=oFEx38avA/DK8fPZQq2E1v1U6k0wDy5mS4WhNG0XSiSFZ5bU9J4mesPwhxjQFH/2Emdnbliju62BP2+nLzRA0jPyIKLXefXHEFesXV/l/AbiTM5ppEznJrAu4OCJ1ZxP18Y8/0dj9xAZFR/fq4HNe0iUwNwXQR9VOcqdstxTOfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780944999; c=relaxed/simple;
	bh=cfE+5BkroTlDquQX9s43a4CDQP/ryxiN4Maswqs8IJ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cfjmUdXWxIOfOyho24jNGQru0J+sZ5wKVhcKOnEKx0oFzR0ixm7SWv5XLkLdwZsYK8Mb+pc9IwVjO4j89rFOklo9Z3ToGNdC3TtID8XvkQpWeZiTgWbtMAjZ74tcsv1X7l6hOCV/fClrIQf0H+jUUsWi4Nec1tV8Bej8YPxQ5Fc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OaGx/D5/; arc=fail smtp.client-ip=40.93.195.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OaGx/D5/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYDBUu8uclVWWq6a+vjRwNVFuP7ipN5MSkuBx0FK9jDhhiSISBj+ktqfWdbjgIbcEOWWXlIsf0HEkdwzbeEIZBMbIiXSMOTs9PQxSqe1yXTxP1zX7Rg8gbXEX5zRMfGMZbEptDaI+KDhJ+eyvu9Wz3/5KAHiIirAKSZ/+zALtgQ7b6VQUpL/17xM4m1o6M3BwOsRY9GZMzDCCiA6bIspCDrH8pUPv5bPrlajtLS97HtpJbvOpRd3ixUHQ0ZkGOymmRSfJyxuL64cmwag/0eHbkBWDof3HvPHH2Wx+UO0YtYjwNC46OUTu2F3qczn7+r2Sq/+1QuJTOWoKZTjNaPE4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xAQ2hA7W3Xj3xmfiLBDjKhOXSiQ91BB7DkXwb4X9yc=;
 b=yA1qh2An0S38DimJiLv26WaPriQTwsJbPfdSVETTlbIFeceyvwQlSCwViQeXwhabStckHP0b8tGglc9iBIvN7JqMK9lt4QJ4NyzsFGnuYLiDayj+NQ6pfRlgEAHALi42N4J5oGtSSyoV83Xlfvc+MjwVeP+zSfEoBDKy1QZbrDna4+WZH8T+zqFPaIGGlYs5doTl31DHY1DQtM0lrZ8lmDXBg8VBEqIsnRbeZjP/3b3NN0IBttwxkHWyFRnD83qQOqzAxv9/bK9s0MAVIltyX2drimZP4vx3rRmofPquN8Q+B2qKd6/QcgLP5plukKFD7T5zN/wJ5Ni20ioysQaRpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xAQ2hA7W3Xj3xmfiLBDjKhOXSiQ91BB7DkXwb4X9yc=;
 b=OaGx/D5/OGgpr39eCEx6XxF/NonzPI6jjW08DQHZgTOqxASWOtRolHKJb1wnGY7t2E5ZMWBK43bNllRYKUg1ev9WKJ3fuvOwy8Z2re5NF9QDilQbAZ+5WoyheZFwYjxr1CRJhT8E/p7iEV9lLCL2qCZyqW9SX4ZxQ1Pm8q6siYY=
Received: from MW4PR02CA0018.namprd02.prod.outlook.com (2603:10b6:303:16d::17)
 by IA1PR12MB6531.namprd12.prod.outlook.com (2603:10b6:208:3a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Mon, 8 Jun 2026
 18:56:32 +0000
Received: from MWH0EPF000C618B.namprd02.prod.outlook.com
 (2603:10b6:303:16d:cafe::af) by MW4PR02CA0018.outlook.office365.com
 (2603:10b6:303:16d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.13 via Frontend Transport; Mon, 8
 Jun 2026 18:56:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C618B.mail.protection.outlook.com (10.167.249.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Mon, 8 Jun 2026 18:56:31 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 8 Jun
 2026 13:56:29 -0500
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
Subject: [PATCH v7 1/6] x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
Date: Mon, 8 Jun 2026 18:56:20 +0000
Message-ID: <77c1ae57e02d7d19b97d655047e4300db227e352.1780903370.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1780903370.git.ashish.kalra@amd.com>
References: <cover.1780903370.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C618B:EE_|IA1PR12MB6531:EE_
X-MS-Office365-Filtering-Correlation-Id: 380d1e47-0d1d-40f5-33df-08dec58fa7da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|1800799024|376014|82310400026|6133799003|22082099003|3023799007|18002099003|56012099006|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	Sn8yhWv/3nFSMv3t8EOCNYTxi+dJC7Pq1TOJh1fBadd9th/MuSxS1A4xt0cM4q5SSuyTDblynU7UxmDzULxeiyw54K6k3Rw38GeRvAfMmDZSfEuhXEV8mRUFgRQiRRWvuZREUFqBsu2XXO/Yuel84gtUEkFxSH8toxeQEkJL1XjooMYxA8bDr6XKMel+dgL1plzqfctwjKxt+D4kC8uIhf5dDkCNA2wFu9mCeDDajpXgVubmHZE11zywRg/RugD1GP2ZbCwV4mHtfZsgbcO2iW8mCQImOHkPG51stiKizxb2d/GDWHNcAqar/x0Eo+AERjVXroHZnn7cikautvAG4S6wLiBrKHMtELWJBPPUfx+btqUuO8Q0TF1Ngu8dCiydzrqvOoamJggd4p1gqkXNkbBowoD6qQY8sIRN0kFdkpErGovWDmgdIBsx02h6V1ydXty/rUEmep4P4r0Jirx1LNxTDSfvVFyLCvQzw3lPPqmpKZYyurhOCSSPL9cJyIEIikeGu3Wdlrla0wG/Gd0/M8xEXkN/t1CFXSlGgKNNhcyUo41OFTthudU0jZRggcFjKAzVHMWDZOqregGxJJuzeD3rIGq4DhQ6Bqm45PN67QwXnMYgH9ffyBI7NHP+e/fUbr/K+3ZD4x5WLieZJ1w7jwrvxDwdL22sDjSSiexmaE5XPhVu/R5EKgSZdJWKzV7qcCrxEKS/nRxmXL4kGl5foJllbF5Q8EWaeT8MC/H0bZMj5Vb53vMj63dYz6xWGisHrN3wvkoH/pSq/DPcga+JEg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(1800799024)(376014)(82310400026)(6133799003)(22082099003)(3023799007)(18002099003)(56012099006)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ev1jtk0JSrPfiF7boE6Qae8VcIFewDOcN6awhjn2PGAB6m3D4RIdSosh/Sgls3KFI10XNQRWg8efRQLlHDOgoVFIWwNSSTEDI9+ThgPz/KXyRB/yu9XSYko4414WevCxa+PhKurj2P1qsWHXoD+rnt0d5UMSdSoXy8ZGzLvQYaM1n+1UVtr4+KPLA+AJxA5qoT+ChhqlYoIEPwGhnOnEUmDE58ZdTbwxrjwiUu5INy6Kc5CiWm0Bfw7sJDPd+8wsKYIPOADiWFY3fVgk39MS8plNNWGcHbOjT1B9K3eGWYf7irEX8kDoZMFBpXmPcijzUWVcE4U4WR1PUZPmDrYrERlztCmfvT9lhcsEN4C8tGaHZ++kWVbsYO9RQFjT/0rX810ue2vX5Jor5AwZLixcVPzvP2TdlNiDwtAFvDfknHDCY5Da9ngiJZ8Zwp6YAYQa
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 18:56:31.8892
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 380d1e47-0d1d-40f5-33df-08dec58fa7da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C618B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6531

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


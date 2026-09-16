Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010058.outbound.protection.outlook.com [52.101.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224BA4BA1C7;
	Wed, 16 Sep 2026 22:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789596887; cv=fail; b=tQLsFvMABqNKu7TsNCYUqoEalyUYjqgWan0ZMFt7Z43IOlzHvcv46eaMXwilWfob3UQZoOjQyY3aOxRKgZpNTjKN7fzwtPgrhK8ysMRcyZqajQtlS2Ag66u1XDxpjDXVrgxG1tquSkfMEhzVw3Hs+NuE6yuTNbaa19mcs/GCoxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789596887; c=relaxed/simple;
	bh=9JkAwJ6pMSnB7ov8awr/g1JBp44NzTda1sHLW2w7RaU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lnn2m+/PMU39YEN516gVgKio178l22c+pOuS1CUOGGPd/Pns8C06Zmg9qIWwizDz/pEvsxdVFSON1L3vhbrzUk1ZowO11Rw/ft50RU0Zu4JZ3EciQ3Wdy2VS9Nr/LA3R+6O/jQfVND79O3eiM85sucjH0XSrW3oJR554ItdNqqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=42K1RuMN; arc=fail smtp.client-ip=52.101.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="42K1RuMN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mADQqJsSpt61ZqhyZI6Nb3EU4Ls/UPJPhRu0qZ4QNZu2xYTo+XZwOybOEduDw0kzhO+4xcTUcy/8Ks33ZccwFO9FQr+st+dzhZnCBKiiYV9a/Pmu88NsIkQuoSslO9BlctsAQV5JCMKvuevGQQkdQcSshLtk2PnUlI73MYiwcTaULOrLRqjUHWm1WLgo374yswTzbeJGLWWQgy0N5/mdMYYK274j8gEO0jD4GpzhX1RCVcsttLEbIutS9zGQ3YcSkmG3qMeNVa1mhgr/iJ4fzZUibOyZlmWpzUk/lvfCfDXJN91G+oWMspW1B6Mr2kYAtsvt59jgX9g19OFfPlrZGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMhbL123iO1Z2WBPQXbvbmYl8SN1+d4H+AT0bA6j95Q=;
 b=sdT69lijMDU6bcWOGbY4B0jC5Y07xJjekoMVcJLrTaIZkGyvCGJobtxzI0wgU6YquM6mu5MVI7faZV+vHLpWH2DgProRgVhrq8LScFHl9LWQnL7vQFYsrhPhJ4BgeIrxbFcDrSJ+1uyZP+2O5fIjqUM9yStOLjG+oXcJTHJu8TyFItvaEDGV8rJnOP+k/0BoFiWv37vgvGQr9ILuC0yXKHpflhm+e0l7/QnJqeg+srGLHMZgs3cNiWC9OMe84If3hJ5EoJnL23X7oLKtYqidiEJ1n846TlfdBerVSAArRDEdmP1rEU5LLzNnl1QIFMHBq69upzY3YoXc7U45u1O4uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMhbL123iO1Z2WBPQXbvbmYl8SN1+d4H+AT0bA6j95Q=;
 b=42K1RuMNAefjE6aMHS0VMnSmMuBxhToyyJQXOdfeQiLX4ja3mz3adRGfVSIyRrUX1mvWb9w0mApHXfzxjoCJgfRuvI64WhmNIfDOL1yr7/RfGf7Qgk7jXLPSQg9vbsZXKFAJ3V/xRFBjzmnAf1ZC4k/8rF+YW83KE0glPqzKT5U=
Received: from SJ0PR13CA0186.namprd13.prod.outlook.com (2603:10b6:a03:2c3::11)
 by DSVPR12MB999284.namprd12.prod.outlook.com (2603:10b6:8:41d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 22:14:27 +0000
Received: from SJ5PEPF00000203.namprd05.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::40) by SJ0PR13CA0186.outlook.office365.com
 (2603:10b6:a03:2c3::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Wed, 16
 Sep 2026 22:14:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000203.mail.protection.outlook.com (10.167.244.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 22:14:26 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 17:14:24 -0500
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
Subject: [PATCH v16 1/5] x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
Date: Wed, 16 Sep 2026 22:14:14 +0000
Message-ID: <40510457d85846fd9138b622a01bebc360e4f72e.1789594774.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789594774.git.ashish.kalra@amd.com>
References: <cover.1789594774.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000203:EE_|DSVPR12MB999284:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d889f17-7b26-470d-168d-08df143fdf3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|7416014|23010399003|1800799024|10067099003|3023799007|6133799003|18002099003|22082099003|11063799006|56012099006|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	XZbg482hdYk1NWsXBNCoHpMG3NxCzhhWLuZwuP+sKMMbYSBvWYnwtvQF93ueHfL37NHaOz7gKr0t6Iz7Hj5nSWu5ylv2UTTE8/4eCA75r47oRebV2et1j8bYclG3R0hz4U8FCQlvYrow7bb5Ok4pxM5App6BWClV+x53CV5ZW+MP9kiIonttEQ7wGix2psZPcCcwydg/vjv//VkpyaHQKbvB8uSX1AffcQvHH+bidlQ7x9+51QcAvgmRCGYNVHwcnv/AGgmvTlZUGGPdIXOdYGtkQvAAQVB6JPEkBc6dILOFaBemINlmjteuvsrAETOFxCwwX9Q4pPYimEPh9QZhpPzjZB2bw0YEwchOdPVzwYhGOCXKEA3EoyaqIwyAtJ0v5OegdnJ3lodESuAS3cfRV4Au2nM00wic9R0v12pPAbfqYOmipx+wlMcLkEQ6E8R4ot/pO3WPexvD7NlpyN+x+ipWRJHh6ot3mpF/gTC9I4zW+PMrcfcTA1mHZLtkMYWWg+u0uWBiUCf+S0nU7HuExpXMqmUMF/i5eo7HxZqrItfIYl+aA1PT7Zdntx3ZWglmGd7mtEkOBRQU+zCU9pymRz1Advyx73x6UFpuHFWxCCKFzT/BP6hT9yphtvKSLTIt1y6RMwEVah8splY9N/O+qLvqNVI7g6B8gpQBkxdYyBxRhIgCZ3iyBUGzvIDfOK0e5FaWpxFfdbCd60l+xgATGA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(7416014)(23010399003)(1800799024)(10067099003)(3023799007)(6133799003)(18002099003)(22082099003)(11063799006)(56012099006)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sw6CLrDgALUQj6jUs/PZ32rOCaLb7XgPTas3QApSco3OqO+DqSCbfFT57qyqMzz8eVoybvsvqecigyaeoHb/Vnf7FY8Xpv6Slu9wcZw7i3bXPrRvRL5pycGD7psa7tA0uVt4Xe9zX3Q4NxTDie72zFIKHKKcEKuwzFia8l56wPLc1W8/WYUA979c8uWe8GD9moQsUGA+YpDxjmYL0BK6+5kS43YfJYUu654f/uvpKwA63APaUddtevjvW9VT7fidhhZf6Kn3YciKW+AiBxuJ8O8Qn0kCuJ/4W3p2Wwr9N3/u8HgPpcNeY8soo/6zWn7PFXql7/k6c95UieIY8TQlel3CHdw+iAeb3gEBijGPvcLoLWjIuYNprqnMUSYcV2jXhprpZqdOLjkP8KLJulPfuNon0A/FfYUmf6mzrcN+X0/Si/dg1swcuM0LGtgjvL0X
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 22:14:26.9567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d889f17-7b26-470d-168d-08df143fdf3f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000203.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999284

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


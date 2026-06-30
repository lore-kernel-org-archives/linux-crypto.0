Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011055.outbound.protection.outlook.com [52.101.57.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF75B3E0223;
	Tue, 30 Jun 2026 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782843110; cv=fail; b=a2Vn1zbkp8F22lcghwXzfolG5jOGJ4gkErSccFTnw0MX9eCD7uWHpKN3kBVAIw2maj17/Oxz23s3iixoyz+8iBKsGo2ZsqCZy8sE3/eSRk+atkWS9jWI0P9v7Zvw3wPukr0ZTsS0wEKCBjzSCTPKH2hefE5APnwvn2GObqZdz8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782843110; c=relaxed/simple;
	bh=GSn8eIxPT6Ik8dpxsjOUbahaqvWZ7pcuy6GLmYHNTsE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AglVtNx7G0DhQ17GsaMMQAIUOmpYTHyr/oziM1Slc24gLcV+dUv394BC4GowLBxFeenUkdJcdEv51/c4AyRbUw1IM82vUlsQH52uFjn0b9B0d3QJpkyRZTbrsbnyLKWFYoiI11zrwyt7QKbK/tLVTNS2qexgvDvlOGMEKdZ69UA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5uVPeMyt; arc=fail smtp.client-ip=52.101.57.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5uVPeMyt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+ZM+nMB28jAHGWtd5Jp1gIJzbMILr+kVThWqvzc4RqLcF+x8bXpNj/c7JPBOOKl+0kKP+ZbH+ZpRruchg2Kfecxppy8hV6dgSH2VTe8eFJSsN3qal1GisDeJNCB7hnJzFr+moogItt0oISs8XMiMCz710vT+AC5II3YftTL1LdtaaOxyEjbdICYKWm/HdmJn9/ZTmsRHlublyMTqIrUCCIK3fK67PcjXUjIEbUJ0SE+j0hOJ47i2pVXuQlUiroiikoiWTGtLkk/q4tQanYuvgj57gCFvB41X6hNkrGoUsnNnnJOs2wYK776r6/vmu/JlTuBQZtrfJNlD+HjZ4NC/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trUeLjaJPI2jMZ0BTNCBqqH+VSCtluDIoZ8SMrcLkps=;
 b=TcEHRQ7IT2zudeLbsO0fgfhSM8RsJRzQa4V5jZJzFBOyNK28lIOocFaUu56iO2jKg5yHP8wyUraPcSfOo0fkYrqAi7ZIyXcYFTKioOIoqpRDhlv+3z+NWlSWNg1REu7fuvzx+8W+z0EvBOU49CjXNHPAhpIjXJ8dwy5tUHRAX0qeHTEXWETB12VOK0z4M2fnAer8cAJfiLOvCs0L1JsUocaJy+td6odH8Isw1Ma0ALSzYmGYQjidxu0eOHTAoWAZQlh2vRshxuMx8FO7Rr/gECq/lOR6tf5knTmZ3A3j3QvJx4iBPnThSsHxE20yjHR9RF7AVZZtWzUsamunSZhFwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trUeLjaJPI2jMZ0BTNCBqqH+VSCtluDIoZ8SMrcLkps=;
 b=5uVPeMytiK7HQyffarx1ccJrKdVrRSk+2BNodqE5im81nYXcYdPM5lXC3Bsf33Cs/9pvT6XakK1yuFAqqRtzUQX9KcDQ7I2oU5k/lVqRSUr4POtAmFv6QYtTIp81MZfuowbyLZU8iEGx3N5V3PVpklFDJJig0FGaJxk0GhgSVMI=
Received: from BN9P222CA0007.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::12)
 by CH3PR12MB8995.namprd12.prod.outlook.com (2603:10b6:610:17e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 18:11:45 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:408:10c:cafe::a1) by BN9P222CA0007.outlook.office365.com
 (2603:10b6:408:10c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Tue,
 30 Jun 2026 18:11:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 18:11:45 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 13:11:41 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 11:10:03 -0700
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
Subject: [PATCH v10 1/6] x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
Date: Tue, 30 Jun 2026 18:09:44 +0000
Message-ID: <39e9ee269a572c516a3f4e937bfe12d00697d5e6.1782841284.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1782841284.git.ashish.kalra@amd.com>
References: <cover.1782841284.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|CH3PR12MB8995:EE_
X-MS-Office365-Filtering-Correlation-Id: d29053ea-151a-4ffa-ef72-08ded6d30b77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700016|23010399003|22082099003|18002099003|3023799007|921020|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	LhOGJHwXBh1QZl/54E3xw4g572WUk6RqlslQBflpsRGNshrK7hmJmBP/UmWJAeRaoQkBqdESwgwoNOapf0OYQpZOjxeuTX0lx0TAW1yb7s4ahiJmr//T7qJqT8VbUOh4qjPyyGtUK6qGW+VB27lABwzyBqmonHsO4OkxrIZB8CWqikKk7Y2k3hBap3tAlVWqC6oORmQCEeUJsqcA8XJpVEXKVF6gR4UDROO4ksb9JophvIP+v+9DebrF7ALqPM0eyp1htXt52IJAw6ZDNyjUv518PppK+SOElT4olUNqyRKh7YN2gq/TbJ11J2UrteK9EloQILaUo/LO+X1RGdpIcpX6Gb1+ZdMwh/nRrGRjysuwMgxsYMfLRBe2jCUnRuMeb4LMFUCzsJjCih26k1XjngNEjzhsT7tVm260YXX1TGqQ/qEhO5Z1KzWCp+/uyKqchwK/cbrHu6DRgvrxEkzWuvAJzgWUW+Bi15r8FKtVDXCxVw2ot1BhAMr0t9R4kZPiMNebfQ5I6sPtOyDyqEzMz6ZCUCb2NumRkHXOIDpLlUqouWsM1w+XKAScrYlGiFarJq8J+pIUy4XZnshur3bJ8eFN/BUzn2nw4eSuh5g9kf+DNj66q/bCldKKSKV5El8HaBMMydfMRW6yhSqqMbEjBiOufq9TGN8W5cYcPLp8frLf5r8YF+JO2wQE/HkaIwZIIihPLdUPqih+/3VM9/gDoPla9IJXXc5fsVzT3v0R6v66XTqR9qaGw/dBf5DFf+ng
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700016)(23010399003)(22082099003)(18002099003)(3023799007)(921020)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MbFVCKJCXq3JqAP++cqnpYCBogY55NvwPGv25RQVnaFBm5zVyMcpajFD5dQRD7pwD73/UM7OPDvJLqCyRbWMzqe2ZEWy0nbIlidHnb7d8AF1w3sp9hRYVCaY3yun1HW7hvjp/FdRWZC4gFbjU/95bcVC2FyxLpdQxaFh4/HuYMqHAIDYvKWUUWmeXfCaS2yarXqpWxJDID6DQ1QcYSj2rYPKFnOxf65BSzcckfcStpxujvVCnImbmyvYDc8c1aRGhwJi60s3wPV5TyhNoO/6/goTyYY55BIJhSIrVGnK5PiGV4YXpixUdEUy4VIEHPJx4rIE3WEJGrWMndalfY1vWgb3NnwqE1gwD7yPw81cE9z3pkN5n3Bhz6rAXJVESxmKgZIuBYX5ZVoZ7kyjuJ0lSEgm0ao8mK00iADIA9gowlgb3t8HLxs8/vsiqyzvNlZ8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 18:11:45.1588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d29053ea-151a-4ffa-ef72-08ded6d30b77
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8995

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
index 1b4a48bff18f..14f23d19d864 100644
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


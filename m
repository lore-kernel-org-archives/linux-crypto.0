Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012019.outbound.protection.outlook.com [40.93.195.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C97A411A0C;
	Wed,  2 Sep 2026 21:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788384498; cv=fail; b=fQm7X7+5NNa+sbEV/8OPfazSilCmkKakSQ8qiZPZ5GjBjNtbbxi/RIduP/ntCG8EPph0na2AAtBYbIaFGV9V9FrRQMtDCS5euVIS7wb32OH/Ex65ZqH5Zam5ow0a4O9RxdlvHtUuo6FdhTbxt5Y6eKwX1t2jEcaVeJJ4yy9SbF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788384498; c=relaxed/simple;
	bh=9JkAwJ6pMSnB7ov8awr/g1JBp44NzTda1sHLW2w7RaU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mOna5ceM/LSRMBoJSeg1BOgFxY0XFvN9x9CRsBCPMgVqAEQI0vvhcfHBF8j6FJX8QIqtscrieMs0irrrQ1MTzR0tSE8ZDRsTwaJo83tFUS7p5yqXLdu4WRGnkxMJYke6YlpuX2x5dHbGQEkGL9Zsc5KlXUbRJftpRxT6LWfrPxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=msR7AUxo; arc=fail smtp.client-ip=40.93.195.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="msR7AUxo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j0PP9b4LCtvX7a7mM3G1Y/235UmPmmoRxYIRHVltV6z2UcEONV6kC8TqRnnBLqy08W2UJZHRjYmg0vDapEbzzj/6BS5vZSk+UYAZ07k6F9EqPHZpeQt8luKAwCx+WlUk26d3NeBHs7nxNNzztjHntrMhdQ3tv4E+fOGgYHD10f8j8p/u1/bj0D+sGTVWc2F7Z8GKLXzZtgBTUmC2LwQtiHjezOtx8CS1hiKUbpofmIgRzC2ZRqnXylr/HKDihngcgIqtGo+P/7TDqgkp/E1MoNCJ0jv8zSa8d2heqgpLnmGdeuKnnhW730sptc5RuRLHq5ARWpumkdpIefG5il40QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMhbL123iO1Z2WBPQXbvbmYl8SN1+d4H+AT0bA6j95Q=;
 b=fi+AzadYs6tb5W7wHhzjaBXUIB4WEzXt71y+TA1IDKo1vTc5AJk9TrPh7vCTwQ8XQgb3DHmizp1omucwNOLUTg2MgWNX0AedUfpbVYoVnt3y9wJnUvtars9p+apT4keKtmmzvbgZ2by2oRuFybqrI88B81oI4CKRbuEbjHXW/SrlClK33fX3OwdU+nvj40wj9ytJX0Mequ46OipEN6t9b20PmFeI3kW0RPADEOPLUmvBaIx2S8elAV/q3Ma0RjqgIOQiu1nDEodZcDzU9YyfKWxhARylMnJrg4rf24cfk/ocDHJsMByXvBbxbulrKc0prQAT2vWaldracD2J2iHEkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMhbL123iO1Z2WBPQXbvbmYl8SN1+d4H+AT0bA6j95Q=;
 b=msR7AUxonIILDdHBDbi/koxdv8HfT5p7HRX1wijCh8P6yaBrCzcWIPAvISktr0HawZhG+7NX5M1a0j8kFQfELflGBvLf5AO2a1U5E5BdMx/Hhsy/iroL7e/VAbmV0DPTxCCaBqYeyhdFn+ZEDstsaYk6Z/AT2gRbPjnI+VX6a9w=
Received: from SN7P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:806:123::17)
 by BL1PR12MB5850.namprd12.prod.outlook.com (2603:10b6:208:395::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 21:28:05 +0000
Received: from SA2PEPF00003F65.namprd04.prod.outlook.com
 (2603:10b6:806:123:cafe::af) by SN7P220CA0012.outlook.office365.com
 (2603:10b6:806:123::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 21:28:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F65.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 21:28:04 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 16:28:02 -0500
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
Subject: [PATCH v13 1/5] x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
Date: Wed, 2 Sep 2026 21:27:52 +0000
Message-ID: <40510457d85846fd9138b622a01bebc360e4f72e.1788296083.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788296083.git.ashish.kalra@amd.com>
References: <cover.1788296083.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F65:EE_|BL1PR12MB5850:EE_
X-MS-Office365-Filtering-Correlation-Id: 579f6d13-7ede-4f5a-5d59-08df0939132c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|7416014|23010399003|376014|6133799003|22082099003|18002099003|13003099007|3023799007|56012099006|11063799006|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	+8HB7czkzeEAQ+63YL2q9HPNpWL3LGMi/rFYVF4wEto7c5NsQLxDGYsL6aIxMb0nSclY9NJXGbozj7bphMiIWeDOaI4kvahrCW2b7kud2UBWUAKlOEt0Hr8/p3MtgRhwD/6lOH++OZE6rc/Ta16x1ir5a1O5Z1yNGP4oV598+cdTihfXv34Ck8QG7zk0U0eL7sXtw7Kk+rL0LZd7BwvYOBcZ8NAdxKHPhh6idMpwqjTj/8gigC5WyxUS+XPzAcyz1iv/Wrd3XbOdgKTThzecMrJorf8B6NKYfTOwOOBa/gp+sL7lOrPCDXy4nlBnHpSbdZX2xQhxsoaH26mHi+ClfWCFyxSXRP0S3TJQF/CqWC5KvHQPRa5NiNJc8HapaXW76PmUeENN+w9bbLj/OFnHjHeDZISutY6FYChY9FBnpf/BClLBN5W8JU1qmnK5MQ/pxrusLlLrihrM72ZvH4opYcPZefosvmDEH097fQBYLK1X1CzU0LXx2szV49uqSWUiBapyCVcd0bjgu+xNw9CAP+6T5cWUxftdCVusnYQa0LHXY9mUTs8aGQk2HD33l+eFwjsayeFb3okmjsAf9L8PAhJDULiTeCMkmdTTaWy4p5oUOd4H3O1UxE7gvfr5nQ4DLPt+1hdueInhSSDI2l8w+mAYwqe5Zs7PlfNw0FRPdSNd2lqP1z9UlVUSQJXW7Z5ZmhsP4c1+vJrlqn7bZavROg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(7416014)(23010399003)(376014)(6133799003)(22082099003)(18002099003)(13003099007)(3023799007)(56012099006)(11063799006)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	v5kXo26PbaSIT0FUIIOiqmxAu5tfWxMA4fgc9bw3N23c5BMbI+2ZiCIPI9mBa7RuBGeECIplNeo1RXyItMaH7WfgkSseEY7FRN9BWK0O/D7EiCO4m4FQujO42YN5QOJY/zXXrKETBox2lhrJ5mzN3WnmbUI4T65aMW0Xe2+4TTfjBlptG6NeQ4gd3VUnCK8NGvqNsc/yh5ibwj200u5t+nh4V7hQC3J3DKthnnPJTMwaY7Fv2DGUzXHX35+i0dnA7RZ9iHInYEwDVstJIFYxPvYGGgEGCcvuNP2fpKQatVquwm03/LQhq2JhZ3FCXnTgII3shBkPjsEU6+LUs21RtTemeiRPakx1HYhcMOYLIUrb4VUxj70o1a86J461PFmzV6yhp9Mxkr+UieN7FqPt/yqqK3Ms0sb5H5qz8OmMOyAhio2VR2qVT5ERDlTRhV1D
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 21:28:04.8615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 579f6d13-7ede-4f5a-5d59-08df0939132c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5850

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


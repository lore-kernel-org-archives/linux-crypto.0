Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013029.outbound.protection.outlook.com [40.93.196.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F4A3F0AA9;
	Wed,  2 Sep 2026 21:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788384549; cv=fail; b=kWxdcFbfyLex0k3uvROyBbEmdGfZhr9YhT2B4tCkIfSekyouTUN38bFnM6Cl4XFOf6LES5uFz3XRWdXxvR9CoSAA2EBtLs7l+UveCe+hFcSpzK7RCv+3subqUKrP/AXaxqj7fPrOB9Wpq84POMPi4Hvz46g4N4vYedZKI9FO9WI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788384549; c=relaxed/simple;
	bh=igMJ95UxfI/BVwEwVk6LTxKkhDHz2WBGmnLRCCCmQSY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJP3ch39QqD99fJwpY0KVcDBwD7ahpYVzs1IOjJC1X16LKmBF2yzB22K3XcX6rPWZvXofJ/DNmpOr6k/MCI7qDRpmbvd2Qs7q9QwOJhB/gXIPK2z9z/A3bre8wP9vhBNzJOb1G72IjsS6lkYpoffUBsakHU+KeEF4AmzD4TVwW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a9ZIHY+D; arc=fail smtp.client-ip=40.93.196.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a9ZIHY+D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8j3LyZ2rKBtA31yde0BwII+m2zZ6AQenJ5WtHT0Vrms0hpYF08CR/GJgjJb2hH+AFqnW0tSW9X+FWgLY5BQtHnU41m2RkmolmpWa3TFaXybUMpxlYncSzhps/ytD6Hx6YoLYZiM9LMorSlazTCfLvsDNAXIwPpAuGC0QK1BHi9Iu20AmL2ldQhm5VakZ/VHuyz2dJWjskKUE02ZWavd+JAkI9EAfh7uKPHmYAFAQAIkWIPNv8MkmaLW/ttVQHvUOnfxTV3/MDA3bFoFlg1tPTfPBRCxNl48akm6YtuAlXqyaU6pc/2bLIjcgZ8JFhDeTIF9PMK3qgh4OHr+MZmFiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trKRshwybxiyanXiA+gkbzwNTfq1WHtKe80sMPHtT1M=;
 b=Hgz3cICo67L0QAxBXAveXjKN+x8arU+CuGqN0Vz9k2IezcwkL7gp97ubImHbJlMXwRGJs915/6WXVJPfuTZ2y7clhEr6P5GKS0ndp22ZbOMyU5KHb5bSwbzHcb2CcAxZ5uEjEaSOGAYIDflc3Gi7nHjBZjE0DMOMzefrwwlFHJ4HjlDX2ixJ1eJ/FIHoGs6rtgyyR5YwEQaZbb4qnH68sroCKGUteK12LjgHj5vQVaHLVQwS4lEg3ELy4tRuPfTWtKUiRZv9iDAlptxYro8e2ykJhdpbEZWraJCajevVEEmCsNEMp47lOXAxWD1uiwTFGky9gC5zz2qipVR22xb5AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trKRshwybxiyanXiA+gkbzwNTfq1WHtKe80sMPHtT1M=;
 b=a9ZIHY+DmLu3onz/57kpMAmIIlM6q7sphjfI5DVFKrDbCz6LvOgrANptG5MOsAl2NdAzrJpEJ529oTQK4qAYa5N7ApUHRKezNMuWhs4UJ1zU3b8zCBPP4i4YA/FILJEWjF4+cQ7dNR922E6k0xdJndW4Q7yOVKuWABRSxigcUW8=
Received: from SN6PR2101CA0001.namprd21.prod.outlook.com
 (2603:10b6:805:106::11) by DS7PR12MB9525.namprd12.prod.outlook.com
 (2603:10b6:8:251::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 21:28:48 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:805:106:cafe::99) by SN6PR2101CA0001.outlook.office365.com
 (2603:10b6:805:106::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.3 via Frontend Transport; Wed, 2
 Sep 2026 21:28:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 21:28:48 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 16:28:46 -0500
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
Subject: [PATCH v13 3/5] x86/sev: Initialize RMPOPT configuration MSRs
Date: Wed, 2 Sep 2026 21:28:34 +0000
Message-ID: <3ee20e3956ab0529aa7bf526b6a743fe970089a3.1788296083.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|DS7PR12MB9525:EE_
X-MS-Office365-Filtering-Correlation-Id: fc625a0d-5172-40de-afeb-08df09392d1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|82310400026|36860700016|22082099003|56012099006|10067099003|5023799004|11063799006|6133799003|3023799007|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	H0DZYG/91dx1nJ1Gxtm6vOFbPPZayixCdcn2AkXt60WlZMTp/D8xSetw8eAkcjez190yfgZZISW7+Ts6/+M0tDplRk+nvC8dEY7M2ye8UiFG3GBD10+IXFC4nNXowqqGPfkWZvLfwQjck9+8aZjPhGXcn+TGllpoTRNqAM7LuUdVnLB07ZHAWXE5x5JQLRSZwe+9YXo0P3q/bi7y+NFfKNJhVEMhThXPcCdKpzZzetiHPC1xLsZYD00pVXpsEgdmw2jJASSjGg+YDg+X+sg6KtILwzQW3a9OTey+CH9JvKAtGzGnXX4scCAQ77oJDn1afJkCFZpDzHDrs+VMXBysXyhVVa3lnXWIHmJSGqk1Ttsqzd4TyIm+HHurHsLLm5/mQW0iZdVNvOTWl8fqt0h++r+V+hzUTID3PXw/uS+6wVoYHpqkVOpiHX/Km4uHAkznKEOznk0Y4HRKXQkZ6VNLDVouU/pVeImcWX/EPLx6xHLkBuhE3EPdF7RDT2yYiBYMnSs3a7BXf66GcSitS3NkHEaNPVTHF+5MRBkL8Z2Jev45bjKuB88SbLmlHEwaO6BtJN9FiCLZPAKWSN8jXDXYX3KC3/4EGOvP4mUO1zdUSSaB4zdtT6HSudaskqAM6PO8J+oA/xhd0JfNCSUf2WtMJ3wyXgH4kfGAd1H2GlP2RbnXYTqoxKkQUREMjaRMPiXmK3DEeBJRBW8Fogiv0XW0VUaqqAOJ2TNXMTmwMAsKXZ9js73rmGtzmi7GO9P8sdTc
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(82310400026)(36860700016)(22082099003)(56012099006)(10067099003)(5023799004)(11063799006)(6133799003)(3023799007)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DYb8FaZ+5/L2rfokmQ1W5p58FGxF76WwA+jIh3ukBuyxB/3G23Px+BSliIwVlXnPDUsOCNisd1RuRN+OSgvHCVNKCXPTarvaqnxxIq0rZ8cGXJ7u5Ap1V2ksnZUAKn3Nhb/KULE+2HZvCINHheQoaL1Q2hPxx8a5dKwu2iZuuyYjXe0hs7c6faPvc7iXJkBsa1jBNrSVVtPPXcCHX8IunwJUsYlRYhDKIMIDHCU7FcRuOJxJEO3tSfvA4KyViB7+SmV1XsaZiis1tcqUArdoAsK5T3UdsDjFRjVczmF4i8zIszztxp+H39p1V2ZmpccvHnA9zZy7OsmTSwhfJZ1qFan2uVoJwQ7FiaboUi5hucdaAY8rOTqylZPNIf2ODhZpFZlC6F3hUjCk3ypArvxt9PF87SMBI4iVJSUlhsL7c4ZO3jbUsNYSx2Xb19vAMLBh
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 21:28:48.3984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc625a0d-5172-40de-afeb-08df09392d1d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9525

From: Ashish Kalra <ashish.kalra@amd.com>

The new RMPOPT instruction helps manage per-CPU RMP optimization
structures inside the CPU. It takes a 1GB-aligned physical address
and either returns the status of the optimizations or tries to enable
the optimizations.

Per-CPU RMPOPT tables support at most 2 TB of addressable memory for
RMP optimizations.

Initialize the per-CPU RMPOPT table base to the starting physical
address. This enables RMP optimization for up to 2 TB of system RAM on
all CPUs.

Additionally, add support to setup and enable RMPOPT once SNP is
enabled and initialized.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/msr-index.h |  3 ++
 arch/x86/include/asm/sev.h       |  2 ++
 arch/x86/virt/svm/sev.c          | 58 +++++++++++++++++++++++++++++---
 drivers/crypto/ccp/sev-dev.c     |  2 ++
 4 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3a8e51a0c9e8..1635e2e1c576 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -761,6 +761,9 @@
 #define MSR_AMD64_SEG_RMP_ENABLED_BIT	0
 #define MSR_AMD64_SEG_RMP_ENABLED	BIT_ULL(MSR_AMD64_SEG_RMP_ENABLED_BIT)
 #define MSR_AMD64_RMP_SEGMENT_SHIFT(x)	(((x) & GENMASK_ULL(13, 8)) >> 8)
+#define MSR_AMD64_RMPOPT_BASE		0xc0010139
+#define MSR_AMD64_RMPOPT_ENABLE_BIT	0
+#define MSR_AMD64_RMPOPT_ENABLE		BIT_ULL(MSR_AMD64_RMPOPT_ENABLE_BIT)
 
 #define MSR_SVSM_CAA			0xc001f000
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9e7a077c445d..5638d09b5132 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 int snp_prepare(void);
+void snp_setup_rmpopt(void);
 void snp_shutdown(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
@@ -680,6 +681,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline int snp_prepare(void) { return -ENODEV; }
+static inline void snp_setup_rmpopt(void) {}
 static inline void snp_shutdown(void) {}
 #endif
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 558f7924a3f8..07f178eb76c7 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,8 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static phys_addr_t rmpopt_pa_start;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -555,6 +557,16 @@ int snp_prepare(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
+static void rmpopt_disable(void)
+{
+	int cpu;
+
+	for_each_cpu(cpu, cpu_primary_thread_mask)
+		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
+
+	rmpopt_pa_start = 0;
+}
+
 void snp_shutdown(void)
 {
 	u64 syscfg;
@@ -563,6 +575,8 @@ void snp_shutdown(void)
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
+	rmpopt_disable();
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
 
@@ -575,6 +589,32 @@ void snp_shutdown(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
+static bool rmpopt_capable(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
+	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
+}
+
+void snp_setup_rmpopt(void)
+{
+	u64 rmpopt_base;
+	int cpu;
+
+	if (!rmpopt_capable())
+		return;
+
+	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
+
+	/*
+	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
+	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.
+	 */
+	for_each_cpu(cpu, cpu_primary_thread_mask)
+		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
@@ -699,13 +739,21 @@ static bool probe_segmented_rmptable_info(void)
 
 bool snp_probe_rmptable_info(void)
 {
-	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
+	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
 		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
 
-	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
-		return probe_segmented_rmptable_info();
-	else
-		return probe_contiguous_rmptable_info();
+		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
+			return probe_segmented_rmptable_info();
+	}
+
+	/*
+	 * Segmented RMP is either not supported on the platform or is
+	 * disabled by the firmware.  RMPOPT is not supported without
+	 * segmented RMP.
+	 */
+	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
+
+	return probe_contiguous_rmptable_info();
 }
 
 /*
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f833cb7e4da3..287a8345854b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1663,6 +1663,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
+	snp_setup_rmpopt();
+
 	return 0;
 }
 
-- 
2.43.0


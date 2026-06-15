Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010064.outbound.protection.outlook.com [52.101.46.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614C43AFAEA;
	Mon, 15 Jun 2026 19:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781552948; cv=fail; b=ixkmd+3wfMey25MINRT/F4tuF7f8/2ghxF7LDXcmHTgVLCZmzDoVM6ca72AstILconz/0ZqqogeT1b5vl11n3jrTjqxC/ELqbYiVl0HuyBGsYNBrtZ6xhSBlPFrYU3qGD8DOve35iB7cgU5d9TDopvtHdoRkqr+z9JOJjqPjJBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781552948; c=relaxed/simple;
	bh=gdAIdB/6kPQ4+QVHDES7HDl5JmOpwXtZVH9rckdvWpg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PkZzhd8QABqljR4bwHDVcckaBf0ckXpp8+VAUN2j7+QqSvix1t4HO+mTKQ96D0rcDco9KhvdIlPxR6tiPdtMwx19f+N3Ivom7TVgGiDXaLM2IVtPunewpZ5C9Bgi7p/7M+GsB2kCe088Hcq3CXwA6U4uZge5K9hwhqudVTkXYNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FrBe8se1; arc=fail smtp.client-ip=52.101.46.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FrBe8se1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eYtryNtC2pqKsvpsp5mu1ZTDrgOAlZJUpb5cdqw4mwddZPXRY1u9UK2OVAuxkfx0K0vtOyHLXmmISye34jxoqYBJ2ss7Z+6brew0qjv8bvSGmob5HP4bVqSXQNEB2s5HWUu46qqiKaOl1k2AFlYvofNISaVTU2K4+hwLUIBQsgnHWv8NoLqPXvu+pi4KjdTO6uUB0X/aw6vjO8UY+JYfvLPamtLLUcLvgRYYU9vr+hfhBuv7i9FOtGlhChCISDLfgQon/7/L7HBcyZKnD7Op48R0NSEoczbUraysQgsEq7/SgC7y7h+lgAVaPOOtXh9bV9plPZl+qV27z9dDX/hNkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R87mAoYWa5ovQK2vpn+8bU/PE62qaHOxYuoBWyQKgjY=;
 b=fWrdxQrsTzgphUq3Ox7hVJWVm3efq48LtvH8LHWx0TWLM5uq29j+qLG3j+PzONUZatTjlv+ZFxAOgaEGvd5Omd5CeaVPOPfhCVLOXW+utGcGEPft8o/ANnpQFvjxG1noT6wfyvoqf20z98PnP+fZQJiaJJN+eddHxszAGPjYDk3LO1whv05TJWHKc2AfqZ+LpoFnLVT7U94FeSBcYiS8+6fbispzIuuwGK773XA3RKp99adpj3DyJY+NcI0YW7GMSkM8ZqF9gc+DPjvqywcD14l0CBz8jahlGvPVWwh0gik4E7I/D2uyft/tVSCX822r2Bxe0fxv4bHDuyW9oU95aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R87mAoYWa5ovQK2vpn+8bU/PE62qaHOxYuoBWyQKgjY=;
 b=FrBe8se17NO4SnCcy7mfh223zo2LaxaXYlSYsIeoD3DP4UOkwKtNAgnUUFxltcT93IAGQ4+FPApb8hJHA5JJaEhawLS4FODS0A27d5Yc+zO87XU0sTUCMpAYdOoFYLHo7HQ8a+mgbpCS8EwxWDYYWFp8cMAFXLijpnzDLUT6C0g=
Received: from MN2PR06CA0003.namprd06.prod.outlook.com (2603:10b6:208:23d::8)
 by CYYPR12MB9016.namprd12.prod.outlook.com (2603:10b6:930:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 19:49:02 +0000
Received: from BL02EPF00021F6E.namprd02.prod.outlook.com
 (2603:10b6:208:23d:cafe::26) by MN2PR06CA0003.outlook.office365.com
 (2603:10b6:208:23d::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.18 via Frontend Transport; Mon,
 15 Jun 2026 19:49:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00021F6E.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Mon, 15 Jun 2026 19:49:02 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 15 Jun
 2026 14:49:00 -0500
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
Subject: [PATCH v8 2/7] x86/sev: Initialize RMPOPT configuration MSRs
Date: Mon, 15 Jun 2026 19:48:44 +0000
Message-ID: <6a4d0ec9e037d91c0fdba9c525942ca288e1b1b2.1781419998.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781419998.git.ashish.kalra@amd.com>
References: <cover.1781419998.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6E:EE_|CYYPR12MB9016:EE_
X-MS-Office365-Filtering-Correlation-Id: 13ede7d5-1af9-4bad-d33a-08decb172651
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700016|23010399003|1800799024|6133799003|921020|56012099006|3023799007|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FBb/MsSdAq086hFe0LWDmtcG3gKofbBKaFQlib1DO3ryxAxHzoWVCwydZEONBBHXKcPyKlC0/PtmqVPu7DIct9R2m7W8L316d7f+OAix21s/n5YV7ws5NZlxRQxch+P9HclPN7JKpzpns4YWNoxmxBrR/BpCayCmeT11nPxieqPWqBpH2jDdZOM7ghXVx6zWpcNYQsITacYJNlZAQPAazsQjwaP6TMlBMAOmJY839yt6HjzE8rP6vYZVgk3JAHr/A/s11scl0ZgAzJpbfNMDBYP3uQmXZi0amKDq1ipwR82SwJm8criuRAnMHXVmlmZIeWk3thv0Ha9kPQ+mIVV/2qQz/HjRyaQujPnPP08XMipWtqH2N5CeM5/lPAsQzbHIv8BuVV1h3wUyR+a+QNYCRJ8iywH5KaUU0A3SOgiKqSC5wswA1k2GrigeDTiPduIGyp7l8/0x5bHRGZtluWbTfojKqu69XebSTqixZ+Yll24pZnJVT4OKAQy+3k/aCQNxFcTV/xt26uWIEy7gIQC0YjQ3Nxxv0AO7YRfHF+pfxXsT1hpav02Ir37QcrB8fENkazC419/EzrawY8EzU/Jz82diglZa8jFMZfSahrpusULFEn3Fhr7fJIGFK1sYsS8otnWPDqFMB/UyBtXhBudyYIWtS4Mqb0WhxV/v7phSlErjfg+NqPRNlA+YTilSDNF2+c0dIdMR8DNizwcn1gZ5iUtYIR+jOr6BV1lTN+QLpg+e9OT72SxX8DVqWpKDrFC2sNwHlaeGIyRWK1kFx8JMig==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700016)(23010399003)(1800799024)(6133799003)(921020)(56012099006)(3023799007)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	g2eHpD8i8hAWofB9l3vcsUeubqyKmHoqN+8xnB8GU5aoIqF2W9VEJ7PFcwpRXIL4JDUvEvgbZjKhUjfIWhOI/VWZeL4VSj+tVJHf9Ok5ZPgt+S8cFxWa//jqrlN3Jhkmk9oK2JK4Wm/F2FBvFrv01GMegzX2i2Go44tXrHwm6bqgH894/YnEEwA0cc3hHYroigZCG+2JGUeBroUp8AJnq4609wTWubYWMzcLc1/YxYzH5wZSu8QWj6sAZM998OwF+9y2oojm8pnIafDOVNDsgWxPfvTvxio82mIP3EuGF+Ax0+mSZywm0tT0Vp6kC49vsQaJyS5TDlbgoKiJhHTeUxiD+IubnWNkZDIwzYMIPT+UGo1Bu0akwNoZ07VhweFte67gvFG3oE7MwUQDxPcvucM1tsZ2Zr7xzUdotn/5LQ9pCJhxTlFcNjS6+c/KpgzM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 19:49:02.0489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ede7d5-1af9-4bad-d33a-08decb172651
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9016

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
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/coco/core.c             |  2 +
 arch/x86/include/asm/msr-index.h |  3 ++
 arch/x86/include/asm/sev.h       |  4 ++
 arch/x86/virt/svm/sev.c          | 70 ++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c     |  3 ++
 5 files changed, 82 insertions(+)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 989ca9f72ba3..8c1393ddc5df 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -16,6 +16,7 @@
 #include <asm/archrandom.h>
 #include <asm/coco.h>
 #include <asm/processor.h>
+#include <asm/sev.h>
 
 enum cc_vendor cc_vendor __ro_after_init = CC_VENDOR_NONE;
 SYM_PIC_ALIAS(cc_vendor);
@@ -172,6 +173,7 @@ static void amd_cc_platform_clear(enum cc_attr attr)
 	switch (attr) {
 	case CC_ATTR_HOST_SEV_SNP:
 		cc_flags.host_sev_snp = 0;
+		snp_clear_rmpopt_configured();
 		break;
 	default:
 		break;
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 86554de9a3f5..28540744f1eb 100644
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
index 594cfa19cbd4..0d662221615a 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,8 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 int snp_prepare(void);
+void snp_setup_rmpopt(void);
+void snp_clear_rmpopt_configured(void);
 void snp_shutdown(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
@@ -680,6 +682,8 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline int snp_prepare(void) { return -ENODEV; }
+static inline void snp_setup_rmpopt(void) {}
+static inline void snp_clear_rmpopt_configured(void) {}
 static inline void snp_shutdown(void) {}
 #endif
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 8bcdce98f6dc..1b5c18408f0b 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,10 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static cpumask_t rmpopt_cpumask;
+static phys_addr_t rmpopt_pa_start;
+static bool rmpopt_configured;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -490,7 +494,12 @@ static bool __init setup_rmptable(void)
 	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
 		if (!setup_segmented_rmptable())
 			return false;
+		rmpopt_configured = true;
 	} else {
+		/*
+		 * RMPOPT requires a segmented RMP table, so leave
+		 * rmpopt_configured clear on contiguous RMP systems.
+		 */
 		if (!setup_contiguous_rmptable())
 			return false;
 	}
@@ -555,6 +564,21 @@ int snp_prepare(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
+static void rmpopt_cleanup(void)
+{
+	int cpu;
+
+	cpus_read_lock();
+
+	for_each_cpu(cpu, &rmpopt_cpumask)
+		WARN_ON_ONCE(wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0));
+
+	cpus_read_unlock();
+
+	cpumask_clear(&rmpopt_cpumask);
+	rmpopt_pa_start = 0;
+}
+
 void snp_shutdown(void)
 {
 	u64 syscfg;
@@ -563,11 +587,57 @@ void snp_shutdown(void)
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
+	rmpopt_cleanup();
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
+void snp_clear_rmpopt_configured(void)
+{
+	rmpopt_configured = false;
+}
+
+void snp_setup_rmpopt(void)
+{
+	u64 rmpopt_base;
+	int cpu;
+
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT) || !rmpopt_configured)
+		return;
+
+	cpus_read_lock();
+
+	/*
+	 * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
+	 * to set up the RMPOPT_BASE MSR.
+	 *
+	 * Note: only online primary threads are included.  If a core's
+	 * primary thread is offline, that core is not covered.  CPU hotplug
+	 * is not currently supported with SNP enabled.
+	 */
+
+	for_each_online_cpu(cpu)
+		if (topology_is_primary_thread(cpu))
+			cpumask_set_cpu(cpu, &rmpopt_cpumask);
+
+	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
+
+	/*
+	 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory
+	 * for RMP optimizations. Initialize the per-CPU RMPOPT table base
+	 * to the starting physical address to enable RMP optimizations for
+	 * up to 2 TB of system RAM on all CPUs.
+	 */
+	for_each_cpu(cpu, &rmpopt_cpumask)
+		WARN_ON_ONCE(wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base));
+
+	cpus_read_unlock();
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 78f98aee7a66..217b6b19802e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1478,6 +1478,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 	}
 
 	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
+
+	snp_setup_rmpopt();
+
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
 		data.tio_en ? "enabled" : "disabled");
-- 
2.43.0


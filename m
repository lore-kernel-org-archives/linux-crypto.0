Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011065.outbound.protection.outlook.com [40.107.208.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED4C390987;
	Mon, 13 Apr 2026 19:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109417; cv=fail; b=ivLaNs4O1hRnL0aSc5tLhuvo+WvyjEEU4Fygk7u0cFR1beXrweTWRTF5QFUN6xcn68PSj2/h0d7yY1t3HU08F2vZ5bu3BW/rYQT98s4BUlYQsYTYmg4us9yo1ke2eyqtNGywCSevcu4ghFU+sJBC63YYyPDEuB8b5qewGAYJemg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109417; c=relaxed/simple;
	bh=LAMtcPTU7UuyL1B6w2yDMLl7+Xe/2IwljhGWFlzhL30=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KXSxmfaUhVzOl6d9SmGK48JeGzo2SCDp6kX/LCAfaR4wd68+cnMeuNCFCv2M07x8QtexKdRS4ByciCNi54/aZd6xdiUFWHH+uHEKd1nDS+ih4QVP/xfnJa6H1tZP4Ks1DbUTl/lwx0M/3SPXkYl4A3ErUBMs289qcZwQklvSlxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1nrfJQEc; arc=fail smtp.client-ip=40.107.208.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1nrfJQEc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mf6pNAmNpHD9zCAg3uj8Ag4llMyqwxmF/G/DMWhCy+nVJYHwGG1hsAfzlKGmc2KE4B1fmSICKk8n1TFXNzyUwde2eadqkcE0R/PRXlQ8OF39Q5TiAdpqQPQ4kax8x1tLCEeXfn39D75aGbRya+BeLLs9f1bsv0LXXedfvMQ+RxIHySz0q7YdxXMlukXQzQfAD37CZR8cjPMpuive9aRft7GIbzpnqN6n89wfx2IhPWgkZSoSc7LPeg8Zf/8IVoVJiwXYrQR03ibVM9VYTsgS22V+7RryU6ohvcA9xuNiB00LJfADlu2VruHdjdD1chxwBzGEf1pX6Bq5B2hCNx8Dww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bF5JIu06kXpuk9ayaKJjdKjjMdUiLY3hWITC765YEmI=;
 b=iU/4hx6+nVn/whCiEM+v7lsw84OPXZpnt3sVg5R/Te1lo/Fpxt2Sr2+mMkLv5Z+CldgCCjSXwPujNuVpvDPy0GGQrh4Nm/rv87X6ihv/ewpUBUJgzg17YTiWmDzm/oF9zrBTEtFqEnrHmEOaM88JrF7oc5uSFuyKB6hejnow8AS5yyqhNife2psEQjpfKz/UEXPl0Gfc2Yvy9jSMIgOmJCTYQa/f159FD9o6CP1sIQbCzWpSYYOfz9t5SBNCsCeyyzyMIq9An0hyDPAaoUKOLatBmaJwtC9m4vmRDtgj82g6pwhVV02/+mkFLRXuLUavvnpVcmOcDPCwIggXDwNHgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bF5JIu06kXpuk9ayaKJjdKjjMdUiLY3hWITC765YEmI=;
 b=1nrfJQEclxEo3dZwCWxBWYOtDft0CDgz32fpujC5CVTRSsOK/t3ZRxY7QZd6ZvxsFTCCUsnLN0AXTB0o/hxCNAP8jfSqJDfkofUWaego9yGWRF/WXJkBw51qZsYofLK9u7H09VPmK9z6D5AUoX0PNMUyQSl/andco7oMouLQowo=
Received: from BY5PR13CA0004.namprd13.prod.outlook.com (2603:10b6:a03:180::17)
 by DM3PR12MB9433.namprd12.prod.outlook.com (2603:10b6:0:47::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 19:43:29 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a03:180::4) by BY5PR13CA0004.outlook.office365.com
 (2603:10b6:a03:180::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Mon,
 13 Apr 2026 19:43:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Mon, 13 Apr 2026 19:43:29 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 13 Apr
 2026 14:43:25 -0500
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
Subject: [PATCH v4 3/7] x86/sev: Initialize RMPOPT configuration MSRs
Date: Mon, 13 Apr 2026 19:43:13 +0000
Message-ID: <846263383f9b6a08fc87ce6edb931c912f68c60d.1775874970.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|DM3PR12MB9433:EE_
X-MS-Office365-Filtering-Correlation-Id: 73a6f103-c534-4f8f-66d5-08de9994efe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|7416014|376014|921020|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	91vU2ylzYZ4GvpPRuqicADx+r78weuljdD3065fVYyEIqv3Yl/bl9b6IMvOqJalgGIJnMqiIRFkGc6Nqo2snzw0YXvaOM6BCyJ/NpVLGJmyUZMU5CGuUnzoY4It8fkasJK45WWF1Rym5VlcbGcugdvKz/+n3xi2IoYTgm9n1t8y+7n2BJIB0JO+Ap/lzeiUfqKHdP0ZGNL8WDLdqAM7ot+lL9z+Jv1VVA9LZ0jeNFjydJP31bF37l3BcmFSoG0AzCZSIVJ1gUOY+7SKv6v1jBfBDsCUhDB9/vcvuZ0hK2GcJ4OHRtROU6aFzwphy7Kaw3AgMNcVwsakJcj1WnIB6s1EI1r9t0F9wLKn0a7dwkj03DSOtj40rhExAtmXKlpiWh0jnfhmENi5AzNDVW+TTdZXkW6Ql+t92mkD0Ey5LkPc8mf/9DoO/GLp1XQ+aFfbHKKmSl19LKUKNj9Q/zLpe55HSKyHpPJyJPzDlih1UUhZxnKO7VY8DToXxbX4QZTS4KUxWf2SEGlq1O3T1WP1PTVDIodUY0jdKtEKKWCeH7VCKeX8Hz3t09jM8tLdZKxEz1us07P9I7tqa3Tli3VrvnCyTM7kPC66PzXhIRhBADedJHx1gtqSLDqq2ZuPw0BHImtHjdNPtL8FPlVElkjY7XNAPSXq2VC8OLjNtTmcLJv8g+byUtfVqEy66lpZLJ7vTSgjJR0Bf1SExLTcjtBVpCNBqXsPKkQl/nAAfLP2GDiKMhCLxBxff78UsWntmliSLbziO/ZjKRtrT54rJz04BNNkSLXCdzbGtFK7KtClpWXPmaChByuxOkyq6UWKqgmmh
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(7416014)(376014)(921020)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Jl952cntpYgAm+waA+Gdj+NYV2BVgf34H/H0LRViMN+Y8MPOkjW+sDUSLU9mDAKpNVjuU/j9OkkiKDv4d2svCI4bDF4zKgZ4xJrl3aoBJJSbsj8lyqG0o6ZOnVVCYbXCFz95GWxp2oeGJnoGSAn64LXG04pMyX7q6yZrg1481CBc1/TaKFk6gYzkNaeDgwtXLhpHOo5lFiwavgqucqe9Cxetv3qSIctYwbMrXHD398nmHzQLWEKtErEOwvcUWaQPtJdtMeB/yazCwBfUTWx7PbTv+vZ81kk/Pkn02okWx2Vk5xplYuw4P+/KtqiVud+dgWXZcKjOgNs8O2LqEN7kfVR95H0WxqKSFNqTOZPNb9WRfuj0AE/oVSM7WqjvrDbmpnaI2ioyq6I2TOiTFQJYl+QOFcQLFp3Jm7fVqK7LvThuWsDTefAhxJK/t0SLYhd0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:43:29.0712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a6f103-c534-4f8f-66d5-08de9994efe3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9433

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
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/coco/core.c             |  1 +
 arch/x86/include/asm/msr-index.h |  3 +++
 arch/x86/include/asm/sev.h       |  2 ++
 arch/x86/virt/svm/sev.c          | 41 +++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.c     |  3 +++
 5 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 989ca9f72ba3..7fdef00ca8f2 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -172,6 +172,7 @@ static void amd_cc_platform_clear(enum cc_attr attr)
 	switch (attr) {
 	case CC_ATTR_HOST_SEV_SNP:
 		cc_flags.host_sev_snp = 0;
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 		break;
 	default:
 		break;
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index be3e3cc963b2..9c8a6dfd7891 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -758,6 +758,9 @@
 #define MSR_AMD64_SEG_RMP_ENABLED_BIT	0
 #define MSR_AMD64_SEG_RMP_ENABLED	BIT_ULL(MSR_AMD64_SEG_RMP_ENABLED_BIT)
 #define MSR_AMD64_RMP_SEGMENT_SHIFT(x)	(((x) & GENMASK_ULL(13, 8)) >> 8)
+#define MSR_AMD64_RMPOPT_BASE		0xc0010139
+#define MSR_AMD64_RMPOPT_ENABLE_BIT	0
+#define MSR_AMD64_RMPOPT_ENABLE		BIT_ULL(MSR_AMD64_RMPOPT_ENABLE_BIT)
 
 #define MSR_SVSM_CAA			0xc001f000
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 09e605c85de4..409ab3372f7c 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 void snp_prepare(void);
+void snp_setup_rmpopt(void);
 void snp_shutdown(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
@@ -680,6 +681,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline void snp_prepare(void) {}
+static inline void snp_setup_rmpopt(void) {}
 static inline void snp_shutdown(void) {}
 #endif
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 41f76f15caa1..4f942abaf86e 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,9 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static cpumask_t rmpopt_cpumask;
+static phys_addr_t rmpopt_pa_start;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -488,9 +491,12 @@ static bool __init setup_segmented_rmptable(void)
 static bool __init setup_rmptable(void)
 {
 	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
-		if (!setup_segmented_rmptable())
+		if (!setup_segmented_rmptable()) {
+			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 			return false;
+		}
 	} else {
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 		if (!setup_contiguous_rmptable())
 			return false;
 	}
@@ -554,6 +560,39 @@ void snp_shutdown(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
 
+void snp_setup_rmpopt(void)
+{
+	u64 rmpopt_base;
+	int cpu;
+
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+		return;
+
+	/*
+	 * RMPOPT_BASE MSR is per-core, so only one thread per core needs to
+	 * setup RMPOPT_BASE MSR.
+	 */
+
+	for_each_online_cpu(cpu) {
+		if (!topology_is_primary_thread(cpu))
+			continue;
+
+		cpumask_set_cpu(cpu, &rmpopt_cpumask);
+	}
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
+	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 939fa8aa155c..901395ad7d51 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1476,6 +1476,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
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


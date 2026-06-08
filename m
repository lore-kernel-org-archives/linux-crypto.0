Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011016.outbound.protection.outlook.com [40.93.194.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7469296BAF;
	Mon,  8 Jun 2026 18:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780945020; cv=fail; b=kL1Ymg5Qy2uZuuRO1uLrOcKR1EFGuYaMak7TmWhUXxa8Iv30ksp3Kk5bFEuMJ2hY7iPwHU6cOgKauoKKysiv2RrnbNiQ3LOMwiWDqrd76JfGpfHOSZ0KJOFhSV5M2mwW+PEVL3ec8xBr1S7loHX79I3D7fJrg0B+cvC2hXHYQEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780945020; c=relaxed/simple;
	bh=A5tU5N/YiZBIEl+Xt7XJSAf9jz5IwGOKscv7gT+PwOM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pqQ6gNIqgpr+fd8hcFYXaEqqrS9+2WrI4sMzOkcH2kjJOb6YNSp8M8QrMFTwtMVKZ27G4Ckttfsj7nz0pxDh6pCB0oJceLjdPBDYbdYT3e0qKek2cmLEIkXJcKWCR32EL+Wf9Xcr2ViUpECpel2ey7vbLV5U+a3R/dXfgnMFS2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DhbK9nTs; arc=fail smtp.client-ip=40.93.194.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DhbK9nTs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rJQTGElw15tBTsWgUjLpRCmIqHJhXStKnIpBNhSHetwXaoXRuwlXqohwIUVaK+YNY7Dh0Kg45HUWEcDRecXKun48lfqfp2PrPHZe2LjG34n6ncXXniZtHUIn8jAm2t4p0oQkwEA3v1gb5EPiN2aHFIN188GE9+POG8T39GYHrJMFIfsHUR9TTgA0pdNE1gzv6SfwISlelr88lJdU6h+f+6+NdNp4uBhpdK5OXWKWBJO0/sceuXD6YZlkPum+iJnewlnItIC7z1r48oXKnJ2pTJIta+7ZuXKCqBX52AUHrmAUxUBWDUIQCB/Q0HWHy6E/2Eis5ZM2j51+2UwDKuhMTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8+JdLQCcS1jhbU5Ri6AY0Y1te/IbcPnusBOoaMMVDc=;
 b=czRaHySqKTVOBkoQRA1nAsUihV5x/2IVT9YZlhqO8supntVWwy9ArgQBSZ1BTG7c36VPXHcz6pHex5r+FRb+4jvEpnnBMmlvtXM2TG2Bdb7LEP3rsAI1V55REi0zYCS0IDnIWmQz3ttRl/2lxftAXmNxs9SC+UaX3pjmWkmDDXObcDvST01WeTDoJuIVctTNXyT4ngIne64SKWc6A/j6s9YBNNkayTz243nx2WvBsx0TOtTE1Nw9jCLse2zAvQi04gA4kYSr/JAhQ+6WPaeaqAsDwGpQo37ayHxN7RwWM3wIXMQugC0jx35zmXDoSMTt0ezDoOHeuCDeuZeoJIjO9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8+JdLQCcS1jhbU5Ri6AY0Y1te/IbcPnusBOoaMMVDc=;
 b=DhbK9nTsYsOjFxTQ2N8jG+9IM9KRo0Ca+CD02IJmh77F7d5G5O9eLNCOy2GZ/vqcSCleU82qcwTk8oKGoVuQ2PInJzJ8lqz59pUrfG3GgO9QclS5FAEgiqgQIOGTkLU/qeo+XoZxJgCK4QMhuZwBaK9SgPb0kUaTTMwmzeFFEyA=
Received: from BYAPR21CA0008.namprd21.prod.outlook.com (2603:10b6:a03:114::18)
 by PH7PR12MB7259.namprd12.prod.outlook.com (2603:10b6:510:207::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 18:56:50 +0000
Received: from MWH0EPF000C6184.namprd02.prod.outlook.com
 (2603:10b6:a03:114:cafe::5a) by BYAPR21CA0008.outlook.office365.com
 (2603:10b6:a03:114::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.8 via Frontend Transport; Mon, 8
 Jun 2026 18:56:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6184.mail.protection.outlook.com (10.167.249.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Mon, 8 Jun 2026 18:56:50 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 8 Jun
 2026 13:56:48 -0500
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
Subject: [PATCH v7 2/6] x86/sev: Initialize RMPOPT configuration MSRs
Date: Mon, 8 Jun 2026 18:56:38 +0000
Message-ID: <2c2ef36f9dfc5eebb719bf45457b48712ce7e821.1780903370.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6184:EE_|PH7PR12MB7259:EE_
X-MS-Office365-Filtering-Correlation-Id: f0d60ac1-0416-46a0-0b67-08dec58fb2c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700016|6133799003|22082099003|18002099003|921020|3023799007|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	cKmDK+qezORrvFddlxIPlWUwLSJad/+h0eIfM8N5mw97+TGNdoSHEBhKiljBDUvLg+Edk7W3V1B5TU9u6DPZJ35wxu65tAyVFfeuRzTI6/UaFETsbYK/rbYOs2LiTCIEXjfClg3bcrG2sHKDSiWJJg+UAh/XX6l2JCU2x0LYzxVhEtzwgEcNQysQLKeQf0P7VUvbZPuARdPj/iZFM+zLHBXebLKt06zeLmd89/5P6IIG62Re582xqBJNrSCl3XsXrOIg030iKTfF2gVd1lmzd7zkN+lPrhlzV5jy4kcwghCYr82zyxK4VGs12PwSgGQqZ1JufGwnZcVFBid33aerKhKeXhR6MLRNvsQN8ofpwtbIdNVArrNy0tsvuPuGtXyr1ZFFOlP704B+S4UlcQ50tv17d9DAuIb3keczZ2ad1WwJ399DKJtMRwNGVhhjH+4sa33fx9FXlkYHo+gHBSRftGMuqFAplv5eeAsnwGZo2UDjrazLFU+l2QbcE0ldii32zJKFgNOsfLlq+caD9eE3JH9+WIBxw4MVr0pK0gE+onetV2KW3Fp1D84MfHWgCh2KGs4S3ArHXiJoYURTRwF+QbP4qsQRL6N36krByjR8sc9mH2x17NvXJ+1QincarA1Rs+2ImzaQsJm/gWYcJZdSBmiUlyOTuBFiEbrsZfseuiZ1NGRNSfGylH/SIiA7bNjT24qR1rflQCLU9NXQkKGFkqyvZPs5/XoyWIyjOB0PgnJH+ni47Bpu5ZhSr1WAuWoK72e9ys0CsSxZrlEfCPf4QQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700016)(6133799003)(22082099003)(18002099003)(921020)(3023799007)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZYaFaDpRsR9IWhflpy65b2ved5Io2WaNMhmCsCo/u4FfolHrjCabKYKdnCp7ve3aWIv9LuqkIQnxy9BZa9CJq3xKvP8Lc+XVdtXEh/LAQYRQnrWzDRLGK4BmrX1c20k38PKcnT+FrE8bED0lrC3uc2nb9jM55QsrSEqEJfGbMI9i7q/wRplFY3iEjj+j7wZrhf+tpPbaHO6K67smABjaeL6MHAnm7MRiu02ZWeh31JJhJdf0EUexRK674aWk4iBcMFXHba3CxN/FMrxcvbSZCKfZmTQZHHEhi/cy1w9KXpvai17PmGkbs3ekaraGKj/ltQ5JE0ss9ia2ujjeZKzF8mVaK50AH2IcVA9dhOUsH3fHcBSi2PnDJNPjkLZFp+hguvFl1iBi7NXZ4WfgQTV+4X2CdMu00hU3jn4XYLtImRo6z0RFbKbJdje8EDXrN7jf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 18:56:50.2451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d60ac1-0416-46a0-0b67-08dec58fb2c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6184.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7259

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
 arch/x86/coco/core.c             |  3 ++
 arch/x86/include/asm/msr-index.h |  3 ++
 arch/x86/include/asm/sev.h       |  4 ++
 arch/x86/virt/svm/sev.c          | 72 +++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.c     |  3 ++
 5 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 989ca9f72ba3..a8fc2ae50298 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -16,6 +16,7 @@
 #include <asm/archrandom.h>
 #include <asm/coco.h>
 #include <asm/processor.h>
+#include <asm/sev.h>
 
 enum cc_vendor cc_vendor __ro_after_init = CC_VENDOR_NONE;
 SYM_PIC_ALIAS(cc_vendor);
@@ -172,6 +173,8 @@ static void amd_cc_platform_clear(enum cc_attr attr)
 	switch (attr) {
 	case CC_ATTR_HOST_SEV_SNP:
 		cc_flags.host_sev_snp = 0;
+		snp_clear_rmpopt_configured();
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
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
index 8bcdce98f6dc..482008bb07e4 100644
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
 
@@ -488,9 +492,14 @@ static bool __init setup_segmented_rmptable(void)
 static bool __init setup_rmptable(void)
 {
 	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
-		if (!setup_segmented_rmptable())
+		if (!setup_segmented_rmptable()) {
+			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 			return false;
+		}
+		rmpopt_configured = true;
 	} else {
+		/* Note that Segmented RMP must be enabled to enable RMPOPT. */
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
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
+		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
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
+		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
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


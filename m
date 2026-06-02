Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012038.outbound.protection.outlook.com [52.101.43.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4BB19E839;
	Tue,  2 Jun 2026 20:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780430490; cv=fail; b=qvpX1kgIHsozclnfXmUZ2fvq39uQs7LOq/Eg2LyP7eYNJVKSiy2syYWenUy8tiq6AOG4I9AX3FkHkuF3YT5qQa8P2F8DUpyjhMCrd24neawqjqZ8p+kKywe89+Ss4257DTuvZLpownzy6p8A68+rOWN2toPQ19QuYUPDiNYiDwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780430490; c=relaxed/simple;
	bh=SSOOG1LVHQGHMUKKbg9XodfzeBIF57QChs1b/WWG14k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H4pHoGV486AlFQLWKlzXmBNzTBKsnSUWms5tnsgOmkXxZ9QKtIq4vv3kXpALqevMmHsE8Kt1mxLX4s1th0BchhQAIFCLc/Jcs3FVQh4Hw7UDh5TKAHCYeRgS/bpOSaZMyVrcH7bpmREAXlLygZtmdsCDcFKwC4eVewq8glKyuLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YxjLe9/v; arc=fail smtp.client-ip=52.101.43.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YxjLe9/v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pakVE84Ek4+v9D8yD80zz68Cz4JwrNPbfF4HjcJ0347p0wCC3KUzQcc62V4XLL/IPsm0tZKBN9qI2f1iUEQISlorgNmJJjcQtiMIMECM/C9INEX5h11eb2XmfLbPZCM6FHJKunU7UWEWgch4y3os5weiDGWmla7pYPwffuI6JTMQXFFRMDqX8qbk0jGE60xbeEJPSkAsFQVcw2JNssTnnMAob83HIt2gpFs7GKNjT1Vb390lWFUSwrdI7s+zD24U3kKQou5Eu8xSVmmyJedklTDke1uBuRpOnepFPPWXKSrLHjPcI29JCR6oZa1jJ+FiO/FubZcoikBcImHNuhbF5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rXhOIvLRwypTDA/L/Bw3+MgcaxELs/Iu5LxXfvmdeY=;
 b=eOYmqiSDO67So3z9BLeLKGkRH2fRczOAgmQ5W2knlW58LuDvGMmNMHZEypP9n+Oc5Yj7KdKklz9ucGsGnWW06yGlzPxFDD7iIgjJ0qktWwMrqLOjMAUZr73CE/6UrKR3aKDKpxdklSTLBNhe6YLCi0GzkktgqJaqWo8Gjz2z3FoZ8XLeXqkvkVexvktcH1DuEH4ygVbfUWQcebq8yCX4SymeDP6lORl4xIh6yEkeDzowOwnoGC4Sz7trDVPV2bQZW6F0nPoNAXfVzqesE+aPBA4XSF2wLTgW9nEa0Z56Y0y3KZ4NgV3BoxRmuejUxt+znxBzjrgFmB7oKViSRa7e1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rXhOIvLRwypTDA/L/Bw3+MgcaxELs/Iu5LxXfvmdeY=;
 b=YxjLe9/vbTBOnhSJJAgbo2GBpMuVhsI/y9XHN6yp2rQJlu3aO0p77d5ruFgn+5hexuZGTsrWz+iQVLFi0CZFpvPM1st6M92ENSJrpXse+pouDC7ByCxa7kirKaHtTGtGFbv2YiCRT26ELyVhQNBOTJf2jND004dNnMgUB0YZeO0=
Received: from BN9PR03CA0646.namprd03.prod.outlook.com (2603:10b6:408:13b::21)
 by SA5PPF0EB7D076B.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8c5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 20:01:21 +0000
Received: from BN1PEPF00006002.namprd05.prod.outlook.com
 (2603:10b6:408:13b:cafe::7c) by BN9PR03CA0646.outlook.office365.com
 (2603:10b6:408:13b::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.16 via Frontend Transport; Tue, 2
 Jun 2026 20:01:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00006002.mail.protection.outlook.com (10.167.243.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Tue, 2 Jun 2026 20:01:19 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 2 Jun
 2026 15:01:12 -0500
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
Subject: [PATCH v6 2/6] x86/sev: Initialize RMPOPT configuration MSRs
Date: Tue, 2 Jun 2026 20:01:03 +0000
Message-ID: <87d473d05c26458773b7957fb96e9b2948641753.1780427587.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1780427587.git.ashish.kalra@amd.com>
References: <cover.1780427587.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00006002:EE_|SA5PPF0EB7D076B:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bf7d7fe-c448-4d90-fbd6-08dec0e1b6b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|7416014|1800799024|921020|6133799003|56012099006|11063799006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	M+qlEg3qK8rkU6u0Zudbm94VMIihPxvDdNO1oGkI8+w9GUZo+t21LipoQkPUdrM6WaqNVsRouybEmfXcLBDuHfidqramv1u8BNtEyxmRqzFYIVgfKoAoEPfoFgqHzVwzj2YE3Q6N5xWlytTUrV+8rxkGFL09U+Htjma6ODNVlruRlJC79PQtiG4PgK3IIHOfeYfeiMTLERuXwZNPxNGzVC9JBuXwtvm81JrQ1DP5w+GFKu85ry+jHD6DvY8Skp3f3wE866xP1WnWwPoS1IyAVIlhPY6YqDKIYx1nvQZoNpodhV203HD3qN+2fO0rUPazZjXGnY7oi7g9dn7SJJtRrwwLn9Ug/WX7axlmfyFSHx1d0YZa5IuFkg0w1czUNOD7Kj8Hba65/ePGvkrZWeyL7REiY7CBfLyJfmfo7BjEqikmTeBl0nkkHiQOddJRYLHXT7NjYEuno4ACTXQhBUbl5x7v9rArrIfvy/R1k8zRfkENEoux6omhHZxTaetNbXcA3eItk8TErGzF7ZVgmwuVfLzOugWKVirdzdv+mTghcbn4uAmL19Pzs716ebS37/Kz/Rel7hn2DdsAbC3HSnokZ0dVfE9pMrmtj4nrRVZsEzeyQy7ZYiemOfj0UbASHZL2h4T0IyElRC3os9Zt+R8tHiiNQOU1EoMUd9INrD+rtVFP2TZVZPBxFl8uVpWGjnuEsnXT7+pC8I3WE3gragQMRj+X0P0urOooLKpKSB3Oz6OFYvroTdY0yJ1dH+tSCIMBVdzhgiR147cCzdoXwGDJZg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(7416014)(1800799024)(921020)(6133799003)(56012099006)(11063799006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aYhsUCXu0RCH2+pTA325kgJO/pynYwgMyfxB/wAjZkfCFoEAaoqjDA4YfN/ik49YXPNZfCAOYgToWOS30QnNBbSTg+MCvI8js+vd5CR8uK+Xq1k3n0GPLlWm6GUwxB5duaOPNiEr6RENC3jgpAverDzSu2SEjiMlTJa9aIgXnW/E/eXlWQTg4FaDzM6S4Y6uz6IskPOLZ+9n/CVj+UzUZYoqMEeahTHvIDS3coW0UUa1zsZ7KXEJVUJowZ0Aq5fLq9FGaV61Wqt5pZvP8p2aNrYoCwzav1BPPetsQaxwvBDnolUxBEtJyQjBTK1g8MCQx+UZ6rj1k0gzwq1vQC3o4B7mNN1+ycVSDB4HGYLm3XhfPczmMMAjvjGLALDNCFSlXFSB/4KWi1KGuKur4dbAwG7beAz6SM5+XB+CWC9pU1OHvNU9F2yXRR1rJUxc7FLA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 20:01:19.8496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf7d7fe-c448-4d90-fbd6-08dec0e1b6b6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF0EB7D076B

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
 arch/x86/coco/core.c             |  1 +
 arch/x86/include/asm/msr-index.h |  3 ++
 arch/x86/include/asm/sev.h       |  2 +
 arch/x86/virt/svm/sev.c          | 65 +++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.c     |  3 ++
 5 files changed, 73 insertions(+), 1 deletion(-)

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
index 594cfa19cbd4..6fd72a44a51e 100644
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
index 8bcdce98f6dc..089c9a14edc7 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -124,6 +124,9 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+static cpumask_t rmpopt_cpumask;
+static phys_addr_t rmpopt_pa_start;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -488,9 +491,13 @@ static bool __init setup_segmented_rmptable(void)
 static bool __init setup_rmptable(void)
 {
 	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
-		if (!setup_segmented_rmptable())
+		if (!setup_segmented_rmptable()) {
+			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 			return false;
+		}
 	} else {
+		/* Note that Segmented RMP must be enabled to enable RMPOPT. */
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 		if (!setup_contiguous_rmptable())
 			return false;
 	}
@@ -555,6 +562,21 @@ int snp_prepare(void)
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
@@ -563,11 +585,52 @@ void snp_shutdown(void)
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
+	rmpopt_cleanup();
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
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


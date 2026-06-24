Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011019.outbound.protection.outlook.com [52.101.57.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650141A5B8C;
	Wed, 24 Jun 2026 21:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782338241; cv=fail; b=Y6RF1yJyZLqaVJw5XSLdfr1z6kRk5YOxH3Mq+RnL04iGR8J46jqsP+68zWiWdx+fNPGp6JirUtGScEMSIxH/IO+V3toR8fO0QlVxq5kWTp1cnlIYwSOda4n4XWAqhSj8ucJU058rl2D3qfePn7W5jAzxxryNpZaU4VtQeXxHG1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782338241; c=relaxed/simple;
	bh=9VPTTmZYmmkii4sXgYlhVM+a56Ik6mHREKQCT6ufdDM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U/4AtJWGsBfr5NE5A3LtEbCYJlaxkr2K1pFeykP1bXUoJooTzz2+QN1OJrbGL2XE75kHKu034sDhEnAwmc7zb5SMrBV8ATTaTxqiWH4NHhCyHsYkyd1XWIH5NO3Aj+u7Xu4t0u6PvaxH9eiU4xES29+Sc7nfw1xRkigWUz2QXvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bqkn0OV5; arc=fail smtp.client-ip=52.101.57.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bqkn0OV5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FRPXxFisUG1BSgB9bwb092wP2jbSj4O2RUXIVCrM9HXEqFigvYb0isKg6pggnpXUBh70iI7BglYgD6r5t7J/QlqWZsLDLMAZ9/soDdWF/bA/UyKmodROH/3lEYlVS5CpmTFIbIaLgau1YxzejDueHE/1CpexS/jP1GF+Qy+zRy3N6pEKR6xFD9powTY7voQCBBFRI2ObkeMQicJShzDrlE5usE2vu2B0wl7fpd+3J4x40d6sVDy0AJh4cL5zslW3WLIZ/kaJBhxCArEJB/bd6MXQ33G9Kje4FKjJNhRlqJRddCP5GJ312ZIIGAgDrvrXRJbpcCnsUW5HP5Eq/kyMJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WwA1LWN5uX87gLVivwhq7iNg4qLxIioJYeD4CtGDYJ8=;
 b=YchYYoeS31pYEUYlN6ZGC5TMBr0ULF+pV9aIh3O9u+Yy0wisqD/XcNcR/lJ+9j6MCFfYHo7bDmb2zHox538XCydLeCsJOJmr0yiDoRFucJUNQueaCYUKFfMohhmQ4hJ4S1KZxJR9iqesfjuO8uPN7giUkUhWJycucMkiueoPiNZoikM5OQN9XwmaUxuyd4frhP3qUFIWCCxS/bhaOlJ3/s+6Sfnd9Bpbn65PKHDaRFjUAMJuXzsKXmBp33bHdv5zxr+SE4QzeNt9K8/qUomphEhcfPkvFKcrY+fkRyTBZfa4/YQjlPTzS+8myuI4PK4wE70Y8KqNJPmhirg9VhS7dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WwA1LWN5uX87gLVivwhq7iNg4qLxIioJYeD4CtGDYJ8=;
 b=bqkn0OV5mCsz/Mpta3IDVA186WoQHDFkql2PwjnwX3kP+ZdW7O8tcwKsMObk5OYehqATlee6RhqPo1vcnnj7t5G2Kjp00lmZopzoBZKNpU6JjQRIr8FkZm0ywPusox4mgPevnvdZHtJ5v+IiuU4RIU2xoAI1Mx4inIoj8jWABbI=
Received: from BN9PR03CA0125.namprd03.prod.outlook.com (2603:10b6:408:fe::10)
 by CH3PR12MB7716.namprd12.prod.outlook.com (2603:10b6:610:145::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 24 Jun
 2026 21:57:01 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:408:fe:cafe::31) by BN9PR03CA0125.outlook.office365.com
 (2603:10b6:408:fe::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.12 via Frontend Transport; Wed,
 24 Jun 2026 21:57:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.10 via Frontend Transport; Wed, 24 Jun 2026 21:57:01 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 24 Jun
 2026 16:56:59 -0500
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
Subject: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
Date: Wed, 24 Jun 2026 21:56:49 +0000
Message-ID: <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1782336473.git.ashish.kalra@amd.com>
References: <cover.1782336473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|CH3PR12MB7716:EE_
X-MS-Office365-Filtering-Correlation-Id: ee648fdb-cb3d-41f0-9edc-08ded23b8513
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|23010399003|7416014|376014|22082099003|18002099003|6133799003|3023799007|5023799004|11063799006|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	DPoGv+FwfEzeEAV8MEYN8OG7l2mGZZAua1EKLyBROk5e0I2EnGdZxTFRDChOysvWYz2Dyti6jJJE8oR8TVsPI7wPo/LtFtVLNVJVSxSJHqQqzj+DN8PHi6Xsl2GCWGP4Bz29W1jh8Id5q5Xuqbg1EAOvQ2elX4kjDXCopaYx+1tbkp2CbcmcMbbZNU4Ypb6AyoltMIS4i7TjhLcdo3g4br35bqChUhr5NBdK6zU5uTM5KaMsa4btP+1JdSM2LMQljlnF1F7swSjBK4j/Cg66ccOCt/L8y6PI4lccCiw1l9EiSpYl7ZSIJsoeIBA0gOGXMn6fX3mlFkjBiwymjpSjcQkur5tu752d1/9rhwEaijWH99GDv9J9p4gYgdOAy+QZoUqBse33Ld8bYIfKIqS24qHAKhd9J4nlBX4ORbPAJCaR6KDRDPscmqsffNL2R+UwtSV5cj/n1vXlYZmR7c2wA9Yv79Tux/l3dXDHOvcJJC0JoXWWnB+edxqjZzm5hMiObhczk3bA0QYrm7KnrbqlJbrzGgYAbxfrowZDQI62q/yLtZtTCACSvhPii+04YQQX6WTEVFwMFH+JBjC3E1IaIpY6L6KqiDbxcsVHPD/2XJtLRaMSsSMvdJ6rAM1MBXUCuUkW4LI8MEujEQ2udft/DjHRJkUBUA2ZOCDMUZ2VC6ooNnB0cdzfSK2PgrgSjkjYgHaB2yq9mm7dOLWNd/79EUftA3DVriTJi2eH5wM9irTgnUM71FBBvHrdCrC69LJ7
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(23010399003)(7416014)(376014)(22082099003)(18002099003)(6133799003)(3023799007)(5023799004)(11063799006)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	szduNpR5BF4YtIzeLDZex3D3o98QqebDcXjzRo9RkqenjkLJnylwqIADqpsH7QPwFu2Mf3681WbooACX01VhcalRIm/1NCgNuqeFmAv03aR3tlT4+3RtK/Kgq2DPuNunrYjQliN6rGtM3aTvaGfAJ081d/MFJYmhzszirdOEJnFSZJnHN1FsAO4w8/0ElkyxIq6ao21R4NydQ0gfDfG6WvkVkJVmrlXOpcW2NJtG+7gXDwRHTiWWgxuZXHAMfn4TOMN77vYm0JkuJfixZfiQQ6j+VOZC9w5pWJAoVqkSZ7bQtXcX1fakORUYygZYT0oV+zNjvFBTKbXqk6UsKsgxawlhKblXtCa2T9ng871Nv2fsE7DfcIKT4Pvvx9RsjhjyHHXw3hzJTSIw2/AoDbND23WsIq0qgmdoVV8ibxBcneKL3PISGqI/YpRQHgfXINV9
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 21:57:01.0315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee648fdb-cb3d-41f0-9edc-08ded23b8513
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7716

From: Ashish Kalra <ashish.kalra@amd.com>

While SNP is active, every memory write is checked against the RMP to
protect the integrity of SEV-SNP guest memory.  By the SNP architecture
these checks cannot be disabled on a subset of CPUs: they are gated
per-core by SYSCFG[SNP_EN], which the SEV firmware requires to be set on
every present CPU before SNP initialization.  A CPU that does not have
SNP_EN set and was not initialized via SNP_INIT performs no RMP checks at
all, so there is no valid configuration with SNP active and any CPU exempt
from RMP checks.

The firmware determines which CPUs are present from the processor and the
BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates
them at SNP init; it is not aware of the OS bringing CPUs online or
offline afterwards.  A CPU brought online after SNP init was not
enumerated at SNP_INIT and does not have SNP_EN set, so writes from it are
not RMP-checked and could corrupt SEV-SNP guest memory, and there is no
way to keep work off such a CPU once it is online.  OS CPU hotplug can thus
diverge from the firmware's expectations and break SNP.  Disable CPU
hotplug while SNP is active.

Use cpu_hotplug_disable() at SNP init and cpu_hotplug_enable() only on the
full x86_snp_shutdown path; the legacy SNP_SHUTDOWN_EX path leaves SNP
active and must keep hotplug disabled.  A flag in built-in SNP code keeps
the disable balanced across the teardown paths, re-init and kexec, and
survives a ccp module reload.

This also keeps the CPU set stable for the asynchronous RMPOPT scan added
later in this series, and ensures cpus_read_lock() in the scan is
uncontended.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h   |  2 ++
 arch/x86/virt/svm/sev.c      | 30 ++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c |  3 +++
 3 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0243989f229b..440c813fedde 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -664,6 +664,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 int snp_prepare(void);
 void snp_setup_rmpopt(void);
 void snp_clear_rmpopt_capable(void);
+void snp_disable_cpu_hotplug(void);
 void snp_shutdown(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
@@ -684,6 +685,7 @@ static inline void snp_fixup_e820_tables(void) {}
 static inline int snp_prepare(void) { return -ENODEV; }
 static inline void snp_setup_rmpopt(void) {}
 static inline void snp_clear_rmpopt_capable(void) {}
+static inline void snp_disable_cpu_hotplug(void) {}
 static inline void snp_shutdown(void) {}
 #endif
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index dab6e1c290bc..60984f76b4e9 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -133,6 +133,9 @@ static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
 static unsigned long snp_nr_leaked_pages;
 
+/* Set while SNP has CPU hotplug disabled (kernel-lifetime; survives ccp reload). */
+static bool snp_cpu_hotplug_disabled;
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -577,6 +580,22 @@ static void rmpopt_cleanup(void)
 	rmpopt_pa_start = 0;
 }
 
+/*
+ * Disable CPU hotplug while SNP is active. Applied once per SNP-active
+ * window and balanced by cpu_hotplug_enable() in snp_shutdown().
+ * The legacy SNP_SHUTDOWN_EX path leaves SNP enabled without re-enabling
+ * hotplug, so a re-init while SNP is still active must not stack the
+ * disable count.
+ */
+void snp_disable_cpu_hotplug(void)
+{
+	if (!snp_cpu_hotplug_disabled) {
+		cpu_hotplug_disable();
+		snp_cpu_hotplug_disabled = true;
+	}
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_disable_cpu_hotplug, "ccp");
+
 void snp_shutdown(void)
 {
 	u64 syscfg;
@@ -587,6 +606,17 @@ void snp_shutdown(void)
 
 	rmpopt_cleanup();
 
+	/*
+	 * Re-enable CPU hotplug now that SNP is fully shut down.  Done here
+	 * (x86_snp_shutdown path) only -- the legacy path leaves SNP active
+	 * and must keep hotplug disabled.  After rmpopt_cleanup() so the
+	 * per-core RMPOPT_BASE MSRs are cleared with hotplug still disabled.
+	 */
+	if (snp_cpu_hotplug_disabled) {
+		cpu_hotplug_enable();
+		snp_cpu_hotplug_disabled = false;
+	}
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
 }
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 217b6b19802e..66475145b3fa 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1479,6 +1479,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 
 	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
 
+	/* Disable CPU hotplug while SNP is active (see snp_disable_cpu_hotplug). */
+	snp_disable_cpu_hotplug();
+
 	snp_setup_rmpopt();
 
 	sev->snp_initialized = true;
-- 
2.43.0


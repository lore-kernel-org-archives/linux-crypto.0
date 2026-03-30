Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010023.outbound.protection.outlook.com [52.101.56.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE72D3E1228;
	Mon, 30 Mar 2026 22:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774909596; cv=fail; b=sgn8bAuRfdGOxScUKizC2cSB1mCbwNaWeB/uoT2faFNzYBaTJ5KNhGmu6XkjWcZrjy0P3QpEo/ZePSwh6SAdofNeqyOvTREx3oSZEpfTDN53VeQENY6W8cjc3zYpP21odswTjJXotUbwLU3RBLvDrXMq7+5EidMfdg76CijKa9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774909596; c=relaxed/simple;
	bh=lQitSYQ1t3FUUbw7R0a1lvaEGY4YJRJm333oAO8BuBI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SO8dUeERkuB4dwfGG8ubiA3u+OPzPvV3/zTnC46mjfkSwpy7Tktc+BkvwqQiQ2VM0+qDN8fQcDbNQxXPjXxjwlOZberVoqJNGOcjDWHTUy/UU7Ag9rztjHUPZ6rMJ5ZK14AmvHiJxW5+veVGt+7jPbn+eaDADEv/r9NGciLAp1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HsQgc77A; arc=fail smtp.client-ip=52.101.56.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HsQgc77A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fy2ENSHg/MJuHzLlsb3EP+3d3XwsNBj/FU/HI5vTdKWylCOq64GIsRv7S/+r2vSBwsQY0MjyuuQApd9jslPvYTMx8t8/7/2CeFrwS2NAL/Fw0UmGQ/ftRELJHENKhcYR12/g0cJFiZEOrYH54Qf985sDr+C0z5jZg58eipRo4waHuzF0HBy1DazAtm/hiXu1fGXnbYYCqLBP880gpq6OywcWd/dR8Kjs1PFJ1o2TfxGmMGHRfuuw5hZO8nhvOg2uW8GqLweA3MoMSBWP+wl9PNjhiBVLcakeLxHAC9fNuSiCG0HjgZVo77tp6UiSCfRoHj4pGunRUe2buH+E+SE5Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjgRAQXhyBCcu+JX53z30DzFIvQeCzp/HqPV6EI3B4Q=;
 b=M0wN42G5oPHBrtyJA7qB7kVky+TuDHx5tYcXoIqHToJ6CxNeCoITGs/Cu8B2yNYYB2sOh0zSpty546fuBehZlNq4y4xRVVFZgP5Z/fxvkhoTo7lkiZk8VZYm0ucNEn0heMSMUjcj0cowzIlZS6bTg1Q3Gw1ID6nq+zZfUFVXwAmMYnNKFmVC8723ZBya6E8/cVQB3G/OrJ1FOfo1xYJfLiAeOyde5EsC5F6cXXvRTmOF1aEDe0l2ih8i1LOaL0PEkPFQIZSZk7alSik0mhXOedRCw1iv83V/mb/dh3oH0Den7eehyiaBhH/9U6Q314SYlFRkrqOf6f8VvohymwE6dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjgRAQXhyBCcu+JX53z30DzFIvQeCzp/HqPV6EI3B4Q=;
 b=HsQgc77AeGFtoOdq2LDv1ggA3qpaPJjDHTSCoDna8SkMIm+r1rY15s4ZQ1mlRfNcpWeLHudcVrW//l6woF1jj64UNYoiC3vY7LvABBIFh4eRLsELwI3YJuSCwvESzrFB397p3hx8cJnD+n7Zwc2s6QAw0o10vswEKJmHLVJtCzM=
Received: from BLAP220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::23)
 by CH3PR12MB9100.namprd12.prod.outlook.com (2603:10b6:610:1a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 22:26:18 +0000
Received: from BL6PEPF00020E65.namprd04.prod.outlook.com
 (2603:10b6:208:32c:cafe::fb) by BLAP220CA0018.outlook.office365.com
 (2603:10b6:208:32c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Mon,
 30 Mar 2026 22:25:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E65.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Mon, 30 Mar 2026 22:26:17 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 30 Mar
 2026 17:26:16 -0500
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
Subject: [PATCH v3 2/6] x86/sev: Add support for enabling RMPOPT
Date: Mon, 30 Mar 2026 22:26:06 +0000
Message-ID: <0f6539b8fd4c4e7d40fb19e6b3255a120664bfb4.1774755884.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1774755884.git.ashish.kalra@amd.com>
References: <cover.1774755884.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E65:EE_|CH3PR12MB9100:EE_
X-MS-Office365-Filtering-Correlation-Id: d76f86e4-6df3-426e-3dc8-08de8eab5c98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|7416014|376014|22082099003|18002099003|56012099003|921020;
X-Microsoft-Antispam-Message-Info:
	NZWZIp6Pqh6Vyt3V1nxBE74vjf1ITMBjz1O0QK0wcC9WINdOyjS5l06Ul9H2QnjSUC5r0fkwLuily6VJW1Ga5VXY1+bwh+r3LksF8Mv4eug4FTBEabzBUBJUER5Y/AotWsBCOzzY/NyTp8bP/NUDWrCoFOHJoAU1CelKmMgaEm+FDdN4PibHTBqfvH/59P51W+jEvfGQL49IPVjYd5xoOK0ffFY0oLtpJ54Jm4nlaz4ZxzZqkPbdJ5WGUAobZ1vUCtEhOH3HDXb9eoDms14y3lsczgPkxA9EqCSCKnafKx8sCo+9d+0UXcwczCHCU34TCK3DiQpxYP6pEudv3vYQeldEgmF+fcCTZPMtbb+FLNTDuj24zQ1dSVmwf+8ffIAHZNy1EKj/PyK5nvqcr/1pI9xTU7GxegXF+Q/cArxxmdrRCgJTS6mww8wwOTwnjguXrFHh/D971IgUyBvQEVA8t+oj092+DFa/ZeVPkNSIR4TIKmdsTbjtX7oxYiAP/DlFnCr3LLBFU613Usba0ZxmDxX7fVWf6LnYi1s3eB0PDch4VW9foTEGIr09UabaueeNw9RhMQIX0HYAYdoLpShPp6tzU7QmYgGU0aJ+olge0ybn9JtN4aXULg0eUo7zV/GKoSA8WoF8RJpz588LxJjOaIB0f6vZrvC347gSCJDYs6C1CzqSwh61KozMiweDyQWqM9a1dm44PsTKBlfbtRdQwpRpKXBf68rYCW5RQK6iyWYtNwJCFcBZa7mP3IIpa52F5JrRe+RQgNXEvTRaYBFjpXIG+G+PNKIYTlL39sfvq/LlykyirCfvAE5ZqCRRjXrw
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(7416014)(376014)(22082099003)(18002099003)(56012099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Sq8ksmTVA37FZpv92TM+Wv0QPLY3x4V2B7N4toQhUtK7w9KhaHPlreFT8Mts4GS/ekyDklRoNJ4TgfV/rO4GRqKWVTEt+HFzlpDuDPQncMKSluS1tpu0gYA0yjhUjMLFk5KN3+akCSF7HtDkC+sFzzMJUw0B12CvXG1Bo+M3C493+QKulhCA6/d1qVUM3+joI032jwPknscASDbp6anGJixerBBX0ROa4ZZkqk6pF3FhiDgUcICOcjCJC3bAQL9TNzSbHpSmJJDJHv+i/FwM7KxBDHDMleB26pR6W56KWIxyrJZE4NWNR7D34Ui6fUwdNFQ7I9liyXoez8+QTEQYGgSgUr3QDUKik5pRMtP+aI8dn1kqyu5kpeGjC0Asox/WOdgs19qhwp+aVJHPaTuFYxS67A3RZ0SZNfhsbaWdUCp4g5cCPZnEQnNwyT6/u6Hp
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:26:17.6784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d76f86e4-6df3-426e-3dc8-08de8eab5c98
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9100

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

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/msr-index.h |  3 +++
 arch/x86/virt/svm/sev.c          | 26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

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
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index e35fac0a8a3d..dc6a8e102cdc 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -477,6 +477,30 @@ static bool __init setup_rmptable(void)
 	return true;
 }
 
+static __init void configure_and_enable_rmpopt(void)
+{
+	phys_addr_t pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
+	u64 rmpopt_base = pa_start | MSR_AMD64_RMPOPT_ENABLE;
+	int cpu;
+
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+		return;
+
+	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)) {
+		pr_notice("RMPOPT optimizations not enabled, segmented RMP required\n");
+		return;
+	}
+
+	/*
+	 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory
+	 * for RMP optimizations. Initialize the per-CPU RMPOPT table base
+	 * to the starting physical address to enable RMP optimizations for
+	 * up to 2 TB of system RAM on all CPUs.
+	 */
+	for_each_online_cpu(cpu)
+		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+}
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
@@ -530,6 +554,8 @@ int __init snp_rmptable_init(void)
 	 */
 	crash_kexec_post_notifiers = true;
 
+	configure_and_enable_rmpopt();
+
 	return 0;
 }
 
-- 
2.43.0


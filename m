Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011028.outbound.protection.outlook.com [52.101.62.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEBC3BFE4C;
	Mon, 27 Jul 2026 19:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785179095; cv=fail; b=rg1lu4Uk5LKfZeCs97xZPbopm0B7zP2lLjnePrT07jaaPLKPPAbZmXmjAG8noeLX5sFJ3kA//y55tTRc40+IThpvb98n1ZXmqakLOz80dH/JFckW8YYsDXvTqT4oZ/bGxA5QyLoc9RxTNgb4l1qhD0s+Oo0IaEQfZ4oP7Dg1DQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785179095; c=relaxed/simple;
	bh=tI72hb9GSuMty26a6qQewGpQhvEVaYwZv7fH5SfWb2k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NfKncrwh4cb56sSQsnKUhnhgrmgUj9qVyNDz3BSEbKgCSiTyX6mHA/Xn8sf1+oEJHXut4qfCCabEQAOBnDGnjPR6eOqb319ajflp336aD7DItcsua9X057A5V5XEKGoem6oQ+oIfiAdKlAw+YmhIZ6FNYUF0R1gclSo4YkP6FjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tJhGS1oE; arc=fail smtp.client-ip=52.101.62.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tJhGS1oE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7hzHuX2YA1dBQC1+15ucg2JwJUzBnsaNQjnAB4EOVZUIui2DOBSOv5DhAtlsK5v/OCHODb4KuW9wIiok6SUbGobMdtzlVwcgfUJmQmvy49Kz0jC5CZuplyHn4qfBF2HpLeMhTEYVk3+//DeQRoqOlx28jXfL7s4V/7tWZ6QPjfs9cGwtfvpscsFoggD/fa+8Hnynrt/VGBY/fifOl5IPLtKihWaVsiNRWdDFGd6XDape5RB+JdusAhnC0B/P/QHXr0rGFCLL8tzXBOnmBAaC3VoBVXkIjngkY7DhU3REGsVFhsRTBUIFhasdtPv5y2d9YafacnQc9m9tmqT6oYYRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhlECls1UApvE9lDaJ4TR9yTgh/ky8oIVLl5KbjcBDY=;
 b=Ul9Cb7VQ5eyuAqTNvXYX5GuF5M6LUSpEYFUvj9urT+DYo369pf/22U++uItZV0ie/AWQIYHNQIFmUb0PGC5k1CGqckvAE7FhgE5N7GRLKObpiRK6GDbgs+/u5NJF6ZIcvlXlKmFoXlhBBZ4WpCkjXI62Bs1JmF7CL7LnmWW6IJJhomSMM0sHpEsn8X6EuOHO9ARu59YKs08CEQYjnRw4wtQrmvmzZgI2aYh2zAS3T5L67ic5CqGI0lNblFg+3pNIsFgnFNoZUtL7DKiI69Y2arnFBVmrhWdR60zWqsK5E1bDUeKXnmVR8e+IfOEb9EwUHTerQzz5x1J9XAaqhqwrPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhlECls1UApvE9lDaJ4TR9yTgh/ky8oIVLl5KbjcBDY=;
 b=tJhGS1oEm4PMvwH/uTqe2sy8MpBr9sbxiFa9r36mxoj1XyxX7ObEZUg5+WI5n6A+gLGqQfg3GvHqGdXxROWh8SPLICcI+T9DT9twIUx6lVPeRU/NX3IDkt1YzwhfRKlAip402XnW0FiDrbBdK1qWSf+jT9CGrD86aFhMif1UgT0=
Received: from SJ0PR05CA0169.namprd05.prod.outlook.com (2603:10b6:a03:339::24)
 by MW9PR12MB999210.namprd12.prod.outlook.com (2603:10b6:303:301::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 27 Jul
 2026 19:04:49 +0000
Received: from CO1PEPF00012E7E.namprd03.prod.outlook.com
 (2603:10b6:a03:339:cafe::65) by SJ0PR05CA0169.outlook.office365.com
 (2603:10b6:a03:339::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.9 via Frontend Transport; Mon, 27
 Jul 2026 19:04:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF00012E7E.mail.protection.outlook.com (10.167.249.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Mon, 27 Jul 2026 19:04:49 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 14:04:49 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 12:04:47 -0700
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
Subject: [PATCH v11 2/6] x86/sev: Disable CPU hotplug while SNP is active
Date: Mon, 27 Jul 2026 19:04:31 +0000
Message-ID: <e1631971b3862bcd6043199feba3df51f3ba336c.1784844080.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784844080.git.ashish.kalra@amd.com>
References: <cover.1784844080.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E7E:EE_|MW9PR12MB999210:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b25bde7-d68b-4c76-9b44-08deec11ee7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|7416014|376014|23010399003|11063799006|5023799004|56012099006|10067099003|6133799003|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	k+l8VYAXBzM6rt9Hr43y4qxUy19f08OUlNEbMQYSZp1oh64hjF5wzRRcVUVwfg6OEEz42zjKlIlwcSEVvfpOz/I2K3F2L57F+QGOCSOqJv0twjBIIwigACpXwyBebMcjhdWc3+g6Hlc3gdZHBOWgnM1RUdaFhwslToeRdEdy+9QYBVNsxjz8Mj9gXJ+6mX/f8OigSedjTtVVZ26IkORMEQ/8b4ENz1ZnngIh1St1o787e9wtZwsq7QQVvKglu6sbks18M4J7D4O0G8Q2frWf8UFYXRBTZ53u3mu5kW07HecKPKmob4ZkvlpOqwI2rn8XQACX1tMdprbDxN4ZvkjT/XxqZbvs/5w7EGVQhXjw7Vy7NbvvwMlN6S4jqaODxTXli66FhA9LUwWSGtzERo9PW6+z9Jsczb5WJ5MAUOgNzuEr7G83AgOq+1Rvscl83LPbtuo1R5nZwgrV1fg9YtaQtIfwNNCxD0b+F/Y9p++eDCjrM7Gr9tceJCd+jIwOxgipVVxn6+C/q1+2Ubp6aLnCSw5DXwe9GXIpqwPcBmlT/YgnY+Fg9SFeEBQEzr1lZRsje3Hiar7w3DrVEz3XAanKSaatTu5U/G5Dyfylz7qmz9BSgI52XeY3gobbmopUjx35I9U166eLcQIutn0Hep1QTuKbqSXZEda4+oBtxpWtFOWQV2SAU8G8/uI8BVm7Ifi9NdReghAK7m1ULLDUHRHsKxhj/UL6wP4+rSPztxVZUXUMTwoxUweEEftiMFkWXATm
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(7416014)(376014)(23010399003)(11063799006)(5023799004)(56012099006)(10067099003)(6133799003)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cDp01PHSJFho2U9UJvP8ionL1TrNg82WIqUPNQy0tkXFsQ7gCGYQWm6bWqvSjKLRkYc+i2VPetqHm2blJtfQPItXjr9r+ghkva3X6UxvfzN8At4dXjsxbJ6FMPWvl1rVcj+uhmuM74bRUC2mlLaC3PzidWMXyTdzLzF3TxmVb6N5nQfgamFx5NGPK9WLUvZf8VxCuvidTli9/EFZ7BZP9WF4yjArOHPygi6sFGI9EYrc5d6qwA+nI2R0c8f/G9BKUH4SkBY5kU+qrbarQOHCygQ7NCGEE4Krp8eHcV2u3ihCXkP8lz3d0gF4EuFNT7QkzeXpDAtVxO92XshjDIXVcpI6esrK2T1FoDn7nuDFrRPfZ28JnZpztZaf46GkHEx5kN0fFIpFyDRpt6oNOnLdbLNi88/X7haisPJSX5ihxeFbo4ZclpuQGsmKCHQ+HBRE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 19:04:49.2418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b25bde7-d68b-4c76-9b44-08deec11ee7f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E7E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW9PR12MB999210

From: Ashish Kalra <ashish.kalra@amd.com>

While SNP is active, every memory write is checked against the RMP to
protect SEV-SNP guest memory.  A core performs these RMP checks only once
SNP has been initialized via SNP_INIT and the SNP-enable bit in SYSCFG is
set on that core; the firmware requires the SNP-enable bit to be set on
every present CPU before SNP initialization.

A core that is not SNP-enabled and not SNP-initialized performs no RMP
checks at all, so there is no valid configuration with SNP active and any
CPU exempt from RMP checks.

The firmware determines which CPUs are present from the processor and the
BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates
them at SNP init; it is not aware of the OS bringing CPUs online or
offline afterwards.

SNP_INIT fails unless SnpEn is set on all CPUs, so a CPU that is offline
when SNP_INIT is issued, does not have SnpEn set, SNP_INIT fails, and
there can be no SNP guest memory.  OS CPU hotplug can thus diverge from
the firmware's expectations and break SNP.

Tie CPU hotplug to the SNP-enable bit: disable it in snp_prepare() before
SNP is enabled, and re-enable it in snp_shutdown() once the firmware has
disabled SNP.

If snp_prepare() fails before enabling SNP it re-enables hotplug itself;
once SNP is enabled hotplug stays disabled, including across a failed
SNP_INIT and across the legacy SNP_SHUTDOWN_EX path, both of which leave
SNP enabled.

A kexec target that boots with SNP already enabled, disables hotplug once
in snp_rmptable_init(), since snp_prepare() bails when SNP is already
enabled.

With CPU hotplug now disabled while SNP is active, the online CPU mask is
stable, so the cpus_read_lock() previously taken in snp_prepare() to
iterate it is redundant.  Drop cpus_read_lock()/cpus_read_unlock() here.
The RMPOPT setup and cleanup added later are introduced after this patch
and never take the lock for the same reason.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index cff285d8ad8e..e2f69fba0938 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -513,7 +513,6 @@ static void clear_hsave_pa(void *arg)
 
 int snp_prepare(void)
 {
-	int ret;
 	u64 val;
 
 	/*
@@ -526,14 +525,21 @@ int snp_prepare(void)
 
 	clear_rmp();
 
-	cpus_read_lock();
+	/*
+	 * Disable CPU hotplug before enabling SNP: no CPU may come online
+	 * without SnpEn while SNP is active, and none may go offline during
+	 * enable.  This keeps cpu_online_mask stable for the check and the
+	 * on_each_cpu() calls below, so cpus_read_lock() is not needed.  It is
+	 * re-enabled in snp_shutdown() once the firmware disables SNP.
+	 */
+	cpu_hotplug_disable();
 
 	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
-		ret = -EOPNOTSUPP;
+		cpu_hotplug_enable();
 		pr_warn("SNP init failed: not all CPUs online. (%*pbl online <-> %*pbl present masks).\n",
 			cpumask_pr_args(cpu_online_mask),
 			cpumask_pr_args(cpu_present_mask));
-		goto unlock;
+		return -EOPNOTSUPP;
 	}
 
 	wbinvd_on_all_cpus();
@@ -548,12 +554,7 @@ int snp_prepare(void)
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
 	on_each_cpu(clear_hsave_pa, NULL, 1);
 
-	ret = 0;
-
-unlock:
-	cpus_read_unlock();
-
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
@@ -565,6 +566,13 @@ void snp_shutdown(void)
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
+	/*
+	 * The firmware has disabled SNP (SnpEn is clear), so re-enable CPU
+	 * hotplug.  A legacy SNP shutdown returns above with SnpEn still set and
+	 * leaves hotplug disabled.
+	 */
+	cpu_hotplug_enable();
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
 }
@@ -577,6 +585,8 @@ EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
  */
 int __init snp_rmptable_init(void)
 {
+	u64 val;
+
 	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
 		return -ENOSYS;
 
@@ -586,6 +596,15 @@ int __init snp_rmptable_init(void)
 	if (!setup_rmptable())
 		return -ENOSYS;
 
+	/*
+	 * On a kexec boot SNP may already be enabled (legacy firmware leaves
+	 * SnpEn set across shutdown), in which case snp_prepare() bails without
+	 * disabling CPU hotplug, so disable it here.
+	 */
+	rdmsrq(MSR_AMD64_SYSCFG, val);
+	if (val & MSR_AMD64_SYSCFG_SNP_EN)
+		cpu_hotplug_disable();
+
 	/*
 	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
 	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
-- 
2.43.0


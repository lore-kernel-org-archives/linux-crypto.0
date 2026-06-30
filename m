Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012025.outbound.protection.outlook.com [40.93.195.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FD13E1CF0;
	Tue, 30 Jun 2026 18:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782843120; cv=fail; b=WLo0yOy1B7jJS/2buakVf7nHLPTe4mcRjDGf/ck4idsltpHqUcD5UqyTmUNzIjjrtz+jrgm+7dw+m0jehA7VIQE69kzmRmZAsIvvNyi1Jilbps93ZyYK+C9aXQ7WtTepzJtv4lW/+FfRtSHi/lL01s2Vzprt9iF/v4Mb/06pi90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782843120; c=relaxed/simple;
	bh=BX6/r8VSdg7fsOkOxB+wh3rXF7W5IqrZBz5yxDhhTTw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dZv7Ebl3Xy8Mu0OiQh3uaH3/6IR59CRHrFtWAYiEvcLu/suhLYyExQq6Addd2tkO7iEC1zVoftvb9e/xsixzId03EO98oEMFTXRXMD3yIb0wrp4mvGGKTA9tBjyF4Y7vmP7Qiqyejnsw+kTjvkESAPwbsIqf/gDy+6PtZTVV7LQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sNmeYv+9; arc=fail smtp.client-ip=40.93.195.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sNmeYv+9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qx5ixHjBizMAnvO+6CEyPwU9vU0u3u1CVjK6zpGqe/Sc/9m49UZlmpgfCdSSrMXFhtU12YHKS+2J4t7o20b0tZdvQv3vRnhVb5KoLhjrvM4jPuXDZvcNLtuSZW9lVZu2aKnREyoXuIRnrJSiRljA+hOOXCMPZQ0GemgKc6zNQsp195dWNCUIAPmxJwIQdrGi0mX425GnpRy4nnYGwa+5zmWCH6tAMoGY+vYFOTU6Mctd56SwU/jXw4Yu8MVy6CAykWoL/n2YlVJmhnnHHcQ6pShN3tQYslX9npClfyaaJY+Km9u0jX9FkqdZdNkiUMDF4adI7JU5s6TaTIDiM9w86Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqPM+GqlR/vtlo2RSW35pzWdBm3vAe2ixPY7rebs93s=;
 b=D9lfeAJLoXWhfDbiUvH2lWwYEx0G2TpHdWLbb6RqjHMmRTrIousoMLCHzJtqLa2PjOv+UpVqgPWprrdVY9JkT48AJHsZVd30k9z7AWobIrrW4IkT5IMVKCEbReqeFcacvlW67wj5rcoEhGXH6r28VzokfTnxa6EIAvrfDdtWRXi2bb/672ap+P2uRl9E18Z+ppVBHgzVI6U8x+KxvI8bLGqhjL03iOC+sXf4TNTKMwg1bMYiYF++6NPzGYvCv2/yUNHg1aOaCPd7PlH4OZeXr+cDapRWE4O16xlb24pfKxQDyWVMZwX0WSp1h9yI2qCuyr3E2d1EEW9LSc5UIey3xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqPM+GqlR/vtlo2RSW35pzWdBm3vAe2ixPY7rebs93s=;
 b=sNmeYv+9TNng2f22DWkc1N91Ec2u06g45qnuXebypFW7+JrMVIF/B87mcmixlrgtj39AmKX4YIr/Y1PPSV7ZqjEYyFJXeEDI4KHC0hAbB2N+/FhhIVr20dZBhGiyvm+1NSj2qwOKHRwkAF1gU0xrYpUmcy4cbzaiB/0DkazhSu8=
Received: from DS1PR02CA0009.namprd02.prod.outlook.com (2603:10b6:8:452::13)
 by MW6PR12MB8952.namprd12.prod.outlook.com (2603:10b6:303:246::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 18:11:50 +0000
Received: from DM2PEPF00003FC2.namprd04.prod.outlook.com (2603:10b6:8:452::4)
 by DS1PR02CA0009.outlook.office365.com (2603:10b6:8:452::13) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8
 via Frontend Transport; Tue, 30 Jun 2026 18:11:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 DM2PEPF00003FC2.mail.protection.outlook.com (10.167.23.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 18:11:50 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 13:11:44 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 11:11:16 -0700
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
Subject: [PATCH v10 3/6] x86/sev: Disable CPU hotplug while SNP is active
Date: Tue, 30 Jun 2026 18:11:03 +0000
Message-ID: <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM2PEPF00003FC2:EE_|MW6PR12MB8952:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c59d2fa-a160-456d-32c1-08ded6d30e73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700016|1800799024|23010399003|6133799003|3023799007|22082099003|5023799004|11063799006|56012099006|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	x4z7pGNMdK7mfGEUTcvLd56+Jiv1JyRV3X9O5F/0o/AaYAf9eIjOPAcVJmuR/mBaQLZ+Wx4Iu25w3TyimkfbAvYsH/UXUI9jfkXcVv32MB9xR/KTKDfFnB8x2Dh0JEffflBkSt0UBjOgpVvN7U+QIYpIGrICh4Djo7/6XMfsTLBsGUWcd+fwlHFifACf3K6tLHPXZsPp82BdBkuHYtUJS8qC/Hmk45vcGMn1crJbRK5sZbhPnNE76JgbYLCPH3f89o/KfIZBZUF17yO70HeaGUG529PZSKh7AbTNf4d9RD17pwpejSKmoaeO77ZErNIcw/OEjJDaSJodukpl8W4ZTUn4L1q4+dNgdz7YBHaP9ZQhf1o4SLemC2415iaXergB6LmAo9ul04J0AiZUv3iEh9nEI8+8uC3yS4FOD5YhUOsT7DI9XCiJBeoceXJHo7rXd2VX1m8ylvON4tQyn9PIDAGmwE2/DYmO51JPVKxOR+eUoJafefKpcry1lE/qo5yeT9j2Cl5o/f9Cl0fIaWESfj5tskP2vI1DsLmMVcrSsJlSDBv1FjrhbIHZIplAeLF0C/y8zeembM8veYsnLNdFWkqsvHdbcITy+8vvG+FRlrvBAx39waJCQ5u9rr4bqQ4ATcIeYh3R1rnZnyrpSW5Ed5dlzaSTcR42f27MaWR8+cqps30NAjz+lIukIL7oAKc3foKt+rTvAVtcYZF4d7R1j7/+WFj9mR+H3q+o800pC1V6gYCziMT3gh3zk8qUx3tr
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700016)(1800799024)(23010399003)(6133799003)(3023799007)(22082099003)(5023799004)(11063799006)(56012099006)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z7+f07VVdaNFBGFHkFdj73B96V0ogO9JW41H1chK4ZhEfpfxJMk/wb5UnBngHj+e1cGy7jN5yVXBe5TRZpI/80l2Q779X3AWmBbT7kxkRRU9/x7MnO0Gc9jneYvVykR+uCf9J87XWCOSO/CeqTlg1GH1ktbdSbFGJxzrEcIoYX9z8lgIFYCSaH/O6SvJf/s643nC4sqKfjOM1zPw6M6AVzeNQigEu1pOARlftrAX2euwiwylfr99gXEKIhsfUWQOURF3RJzSyP8IAkDHG7FB5ZX6F6TB98XlE97r9Wm2rJGrjCxBviiPvC+I4bg0IneqKccv32uhFDYFwM1K0gEJOiArneTpnZrZJGs2xaDsT9NrJo2f5gCe6zgTaG5AwDdjHsj6GAyoKTxM4cBg3IRVp6U6U+3fPEiBTK+kVUGkcAAxvVTCQjjvQrUEI3hbTvtM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 18:11:50.1196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c59d2fa-a160-456d-32c1-08ded6d30e73
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM2PEPF00003FC2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8952

From: Ashish Kalra <ashish.kalra@amd.com>

While SNP is active, every memory write is checked against the RMP to
protect SEV-SNP guest memory.  A core performs these RMP checks only once
SNP has been initialized via SNP_INIT and the SNP-enable bit in SYSCFG is
set on that core; the firmware requires the SNP-enable bit to be set on
every present CPU before SNP initialization.  A core that is not
SNP-enabled and not SNP-initialized performs no RMP checks at all, so
there is no valid configuration with SNP active and any CPU exempt from
RMP checks.

The firmware determines which CPUs are present from the processor and the
BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates
them at SNP init; it is not aware of the OS bringing CPUs online or
offline afterwards.  SNP_INIT fails unless SnpEn is set on all CPUs, so a
CPU that is offline at SNP init does not have SnpEn set, SNP_INIT fails,
and there can be no SNP guest memory.  OS CPU hotplug can thus diverge
from the firmware's expectations and break SNP.

Tie CPU hotplug to the SNP-enable bit: disable it in snp_prepare() before
SNP is enabled, and re-enable it in snp_shutdown() once the firmware has
disabled SNP.  If snp_prepare() fails before enabling SNP it re-enables
hotplug itself; once SNP is enabled hotplug stays disabled, including
across a failed SNP_INIT and across the legacy SNP_SHUTDOWN_EX path, both
of which leave SNP enabled.  A kexec target that boots with SNP already
enabled disables hotplug once in snp_rmptable_init(), since snp_prepare()
bails when SNP is already enabled.

This also keeps the CPU set stable for the asynchronous RMPOPT scan added
later in this series, and ensures cpus_read_lock() in the scan is
uncontended.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index dab6e1c290bc..04a58ac4339c 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -535,6 +535,15 @@ int snp_prepare(void)
 
 	clear_rmp();
 
+	/*
+	 * Disable CPU hotplug before enabling SNP, so no CPU can come online
+	 * without SnpEn while SNP is enabled; it is re-enabled in snp_shutdown()
+	 * once SNP is disabled.  Must be before cpus_read_lock():
+	 * cpu_hotplug_disable() takes cpu_add_remove_lock, which nests above
+	 * cpu_hotplug_lock.
+	 */
+	cpu_hotplug_disable();
+
 	cpus_read_lock();
 
 	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
@@ -560,6 +569,10 @@ int snp_prepare(void)
 unlock:
 	cpus_read_unlock();
 
+	/* Re-enable CPU hotplug; SnpEn was never set. */
+	if (ret)
+		cpu_hotplug_enable();
+
 	return ret;
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
@@ -587,6 +600,13 @@ void snp_shutdown(void)
 
 	rmpopt_cleanup();
 
+	/*
+	 * Re-enable CPU hotplug now that the firmware has disabled SNP; CPU
+	 * hotplug is not re-enabled for a legacy SNP shutdown.  After
+	 * rmpopt_cleanup() so RMPOPT_BASE is cleared with hotplug still disabled.
+	 */
+	cpu_hotplug_enable();
+
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
 }
@@ -645,6 +665,8 @@ EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
  */
 int __init snp_rmptable_init(void)
 {
+	u64 val;
+
 	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
 		return -ENOSYS;
 
@@ -654,6 +676,15 @@ int __init snp_rmptable_init(void)
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


Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013008.outbound.protection.outlook.com [40.93.201.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7E331D72E;
	Wed, 14 Oct 2026 23:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792019290; cv=fail; b=BkoVOkGlKO/ugCQ9xp6cyIF6K9sBLmKtXYAVV+r6eWe4EeY0XIyguSvXHbRN6ETaEpJeSZ1e5I2JyNlu8yVy9mQLo5+NexFal6m3noIVZgQmwBHuT6eExNcCntKcDPnj2ISwuFOvuTl0x/yxY+Llx0a46QczqNOMnCH6Ta71Qhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792019290; c=relaxed/simple;
	bh=mOxThAzn7fPrcLyHlVBy6F/eLy3mzfAUCc6zi+Ij5Gc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COeV6Ie4Ux5p5nExXkBV0PCkRJKjuDR/8J+ovV5O+l/HIDhRdbgT6chjA1SndjSCP/REOTJ57vgbBh0vMlDN2d7J/RXF7PnV3p4dmmOCd8zkxFG+kRhZLdDyWF8Ta6Yu55cqjO/sgGxwp/uftqyfrhF87vDKM4x63r+lwRi3we0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iCkMKXTB; arc=fail smtp.client-ip=40.93.201.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iCkMKXTB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bf6k3qGOBLQYWo0vS4plNDXvjqP+YrTB0W4dkoPnVIvUAV7cBAd+VEeDrouLRj+TgCCe7Kwp9Br49EFeYJ35ya2D3kBw6tqDFdOabhkj97Xnn11HsFZNlfAHRokwc4G6Xh+FsiFjZLnLFW49z+BhtMp1NOOa246DnzBdl+lSMGqJyn6J42+vc9Tu+V0HUOpRiArfYCqAYFlCVp4+Au+XbR04nBedczDJJovipay9nyhaFDzAR2TQncGb91snXOAytk2E1FBXXz9pCdXO4j0TTIzsb7yIS9rWv4oOQrws+GdApeGygmWQof3k6D+DPrQV1Ry2Np9HX873+QWqnbf8Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7KIRszDLhEDPKL7DVaMra7Nh3i05He2vGr4ARLJTkQ=;
 b=HuJc7+WkTLjPzHP/u8Yv0gEzlYt/acIbWKzzj2Db9KWqTsBbopSD3SvbvA5SuVdUkM65Vmc3YRGZix9+bm6tAIPXd2boyUyPl0/JX7conRzUpYTtJ5zAzaDeCfKX7znE9ZGL0HSv1dgAmDJ7fvgxfXyoM2PQP9UuzmduuSpN1AzrVMrw/y5itH1hftyGmQHi3rFA6s62rezhZOoEXPwk2kzwTpqt5hg23e39jqSEfSL/LfZu2wgoBZY8mF0KRIApa6BEHi18UoIV1rsLo22Q6RjxjzhK/A/WwuCwZo8haSKtOoXMGcNpDSwfrTSEaGebwKxfAcc/cO9jwnyssGTLdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7KIRszDLhEDPKL7DVaMra7Nh3i05He2vGr4ARLJTkQ=;
 b=iCkMKXTBaSvF3eYay1KYacbgBkyLM8OMGmaC67qqW/eSFddjA54adY+TWVo5dKAyX1ac3rlE4owx97c9VTQQTlYW+RH6/dXjazSvucQLN6VsGUU6HmTmXYWb3sSDtMWS0nM5GFl/T8WrJBJUl+NHM6mia5v0QfruROpSVypOp4w=
Received: from MW4PR04CA0044.namprd04.prod.outlook.com (2603:10b6:303:6a::19)
 by SA1PR12MB5657.namprd12.prod.outlook.com (2603:10b6:806:234::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 23:07:58 +0000
Received: from MW2PEPF0001467A.namprd04.prod.outlook.com
 (2603:10b6:303:6a:cafe::74) by MW4PR04CA0044.outlook.office365.com
 (2603:10b6:303:6a::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Wed, 14
 Oct 2026 23:07:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MW2PEPF0001467A.mail.protection.outlook.com (10.167.249.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 23:07:58 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 18:07:50 -0500
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
	<nikunj@amd.com>, <darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 2/2] x86/sev: Only announce RMPOPT optimizations when SNP is enabled
Date: Wed, 14 Oct 2026 23:07:42 +0000
Message-ID: <4dd96d8c5f066f63f2cbc826695087d25ddb4223.1792018839.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1792018839.git.ashish.kalra@amd.com>
References: <cover.1792018839.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MW2PEPF0001467A:EE_|SA1PR12MB5657:EE_
X-MS-Office365-Filtering-Correlation-Id: 44a23698-cd95-46de-77a2-08df2a47fcbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|1800799024|7416014|376014|6133799003|10067099003|18002099003|22082099003|921020|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	nx7WE0wFGBq0xmGUvLWTcrsQFUdJNKNlWgq/yQnpppujTmlSesDzNHgCPCzalyZIPsGODb8NkE9Era54ofyVsMoxOStAlH/xZojRRGn1ziP99nOhEYPHResliXscNGGfCxJ1TzZHRBSOI/Nob1Dt1DzfVDCoPMdy8MZJ03fW9zPcHbhIbZzAT2macXoqzp9nOvylbqKM0UBptUk+NQSXgMFU9a/x9lI3n5ie+NjzeWk/rYkIY3UbFRphJXQyxWj+nhShmmgJIrPcVAbMTRwI/PPf2FjCKiUFhGxu5E22hF+nWaZJ8+aF+JeuYDNiRiffWDjbTs7KmrzrGVgKr/F9EOF01zytiEFJd79okpjB8L7wDVEKBsiy3WnC1nKk93TLOJkZNMdQbxkN1u48FkU1fFB6gmiKbraPfaKE5kj3pxffoMejSHQmOLexKBN1pr8fkqHUKjHPxyD1WcMzlORM98yzu+fe6pV7KAy3UlZ5DPYpFJe89gb1aMeG74jbXgSaTMmLYEKpGgnligpebucmIcwqUsqBK5kPDVSNm8lYDsfkYv+Eb3ITwOY12/QBH/qBVSBuQPVQdbNKIfQgTAC4LiJD67NcX8kk87kLcjXWfV3/7aYcFvsZh0LSZrJ7e3yw7xa9PcAX7MIBoFKTeLAOV2DSLV1i7q+T7cve+L/1KDOv5tqxckrYrhTGleTNpvwjDPvyPyQA17qIcKmmQJKX0g7YSgtAppU0FMf2Y7lzr5IZk9rJiJVekRnOEq0p2oA3
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(1800799024)(7416014)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(921020)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uVKPl1vA3+jbktRdzs496uxPYpqxG8NiDpjyLllSSS+GqttRdr90thtoMYDvaDR6IzmmOv8FUibWz03UeRXOJA8ZZCXWp11V/FaeCfk/0VHjDBRMYBZGw2rZD2hD7dGr3yuT7biGvG/qG9uSeqlssTEY3XuG/IfjVECVUjofiOMj55qOCQWnvJkx6A4s/V8xd4oWRrka5vpTukISUQeVvtItxNrOcdW5njIvYmatqV34ZNIRZPmlSTvIdT76+k9wAWMgB7aQcmILPx2h9HnsVGsbpU9BtAVbcLjFisgcbHUpTfx4tJDO2v5vWX4dBrCwKzQNDNpCFMDqknRxK31aQmJF2PcbodrjdMI1prNh419iX9rOU3oweDDT+EibQYeaPFgoHS7aarBh1FZ6BFYJBk6+zNSHMkHFWCLZQGbsP2zr+l+LDSi2DDS24efwzHFI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 23:07:58.0030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44a23698-cd95-46de-77a2-08df2a47fcbc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW2PEPF0001467A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5657

From: Ashish Kalra <ashish.kalra@amd.com>

rmpopt_init() sets up the RMPOPT workqueue and prints "RMPOPT
optimizations enabled" gated only on X86_FEATURE_RMPOPT, which is a CPUID
bit advertised independently of whether SNP is active.  On a system where
SNP is not enabled the workqueue is allocated and the message is printed at
boot even though RMPOPT is never used (snp_enable_rmpopt() bails out on a
non-SNP host).

Gate rmpopt_init() on an active SNP host as well, using
cc_platform_has(CC_ATTR_HOST_SEV_SNP).  This reflects the final host SNP
state: it is set at BSP initialization and cleared whenever SNP cannot be
brought up, whether disabled in the BIOS or when AMD IOMMU initialization
fails to enable SNP (which clears CC_ATTR_HOST_SEV_SNP but leaves the
X86_FEATURE_SEV_SNP CPUID bit set).  It is settled before this
device_initcall runs and matches the gate used in snp_enable_rmpopt().

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Fixes: c6c6f156d192 ("x86/sev: Perform RMP optimizations asynchronously")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 43e4945e6cdf..fe78f512e7aa 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -639,7 +639,8 @@ static void do_rmpopt_work(struct work_struct *work)
 
 static int __init rmpopt_init(void)
 {
-	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP) ||
+	    !cpu_feature_enabled(X86_FEATURE_RMPOPT))
 		return -ENODEV;
 
 	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_PERCPU, 1);
-- 
2.43.0


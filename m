Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010044.outbound.protection.outlook.com [52.101.46.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A099516163;
	Tue, 13 Oct 2026 15:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791906301; cv=fail; b=QdqLK3ftnUFXDrL4R+nJHW/9czoQ7wnY5aDtXhk551S06dHzIEJceDXGRcJnicRM6eAxuf9oN7Xmt+bB0it3KQ+ltzBp+ILquJS3O1eXjsguVDcXFduMjjQ+TYTgPsBFxpz61YEgl7kvdQzyZNCH6M6/Yb7bFYREJJ3/OainmO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791906301; c=relaxed/simple;
	bh=OoEivq4C1JK7fYN6B5EzehKtjd78BPFVnXYYqHXq9pA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R7XLCT5UdONP2dZ4EuLDZhPDrvtzLByQEmrAVjjiRFieGabEZfBiNRKSnAXg2LMjQN95wIb19+9r7VIIPdYHIzBiMp8E23+EVx52e92mGhHFIGuHt/mL/oDAXseh3ODPyQQLK69dLrGvjs61jD5SfpZf1lpjxJSFwJgaLe1BReQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XemN82VC; arc=fail smtp.client-ip=52.101.46.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XemN82VC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GY9VVnbU/hbSmZkrMqwbxEcLxs+PJkLV7poUrNHHZ/3OvooQ4cT/uASfZlMtcKbhpPGEiz/BpN3iaJs88Nm+AiG+S1xJY2We2j1O4NQpz6XfGq+k9atuMCBgjsS90lahfaoXBfH9TXNItadzcR093tXy38Y+pVxIY0BK4KCBxOvpFzVkTBAd5uRkv43dA6IL1yRM3eMbNH6EPMKN52YchzA4JgXgV4G6awXFpM3ky1dt9RzR4ZxdKgHUbIpIfi5ZUVkCvtOEDmcZrcF18kIy4O3nN5Mn3kP6aTQPTAqFfxLPbHmgsuqSmLC13WKhXQkexmc0q2UNb5HBgritaUU2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJKu1mF0C1nnPqqUd4KueXmp7zQ9hHSqjIQpV24elMM=;
 b=ADSwsVEN79zuhvOqoXoEe63rS8NHBQAE+8ExZbGfyKv+i81L2dYrdqWrPxnKN+Zhe0x737hr+Z746hTvXbGfZBCheHUPBG3GsHdQhQNE2yfb8PfpPY7/QGuts4SZOWBYdPN1Iety62nAHsSmPw9XJAtWL9lncGd1eccHTo1Mew6JR0F2ukv8po81d5qFZIZeFDT1JXS2OHx/lvtySs0bdcjJRBR88GRIgXRIXSEqC/HVMxGszyQN/qvoHwM25Qv9pu8D19BR6Avf0XxudkRYS8C4T/cGveJZ7S7is9M/ts5FIV6/npyqk51CXYD5bpdLc0MHL5m6hKUJ2iybUYIkRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJKu1mF0C1nnPqqUd4KueXmp7zQ9hHSqjIQpV24elMM=;
 b=XemN82VCSLANrIgUHp4tdRwH2RzaptFqHgB0GTuMYBe3OpXwditTKaukUdZ0Z32PYGr7UFRONbGCYBSORleqinAbg42wLbBICY1/+WGZ7LbNFcdk8RgTKduvHwETblWNWKAMvSBw8aORUcCGvjZzsCLb1i3MYa2iXXYbGPdxmrA=
Received: from CH0PR03CA0263.namprd03.prod.outlook.com (2603:10b6:610:e5::28)
 by DS2PR12MB9687.namprd12.prod.outlook.com (2603:10b6:8:27b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 15:44:47 +0000
Received: from DS8PEPF000000E0.namprd05.prod.outlook.com
 (2603:10b6:610:e5:cafe::13) by CH0PR03CA0263.outlook.office365.com
 (2603:10b6:610:e5::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Tue, 13
 Oct 2026 15:44:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS8PEPF000000E0.mail.protection.outlook.com (10.167.23.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Tue, 13 Oct 2026 15:44:46 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 13 Oct
 2026 10:44:39 -0500
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
Subject: [PATCH 2/2] x86/sev: Only announce RMPOPT optimizations when SNP is enabled
Date: Tue, 13 Oct 2026 15:44:35 +0000
Message-ID: <11df35266257afcad3825a8e89c965bb0cf7cf34.1791905953.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791905953.git.ashish.kalra@amd.com>
References: <cover.1791905953.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS8PEPF000000E0:EE_|DS2PR12MB9687:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c597694-751a-47fb-0499-08df2940e8ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700016|1800799024|23010399003|6133799003|18002099003|22082099003|10067099003|11063799006|261009223027099003|921020|56012099006;
X-Microsoft-Antispam-Message-Info:
	LOss5pIeRC7BE6/LuWE8SG+XTaz7NxL+0PtxtuMB2VHf1cKMoUxfXkbKT7tItRkyef2NjgSivKygxGPDsSY/TuZxfAbNSHnHVDOs+W96ex3FVSktJDgaODi0zdQjHYBsOJmxUkiYWUbHTILad+nyuatmE1NEadrxUBK3S9EO4TSA5a5+692Kc6c8lXmw280IBVFd1BuZqiP+woeewL+Vwm92xYZLNyjsSWt8eUP5wIurzfew+l3ObhscR9CNQ7tmIR8kKtWgQ9FklrPHbxOCSVaFaHWusFQZpt0sTxU51DtXF1dsUAhYugxP+B2dZKjDLaBLTv3isbT7qebBOl29YLmTi5CvC2Kln268T2Rs27zQoHaljVZ7F2Wv4RynQWHbnW3gYeDVdOWBpbNHZAhsuDaOze0mlZ7D4gBFJZe+o9sY+bPgm3sK7O7xMy1SqE/fhY80+7Hz1Og2JuIej5o2eiL5XTTioF51v5XhK/KagcSEyAblkyb28eVR7AqqYo79HnT0H5n5Y3PuG8/FfQg00072/x5HPi7jDgq/0yLXIOnzt4b6nh9PaEAgwvWNrh2CbNTbIKZuaKIzXniACdpTbxNZBOUP6CERw4LNgGmXemf6+fJbOQZhIPaiCtUh4b+QHVgwPcbpAKhNg7mgjQXyU75WnXbCakKzL1E9sIUEetR0Uo+OME/Utsm6M24RDUOpp1S/J2acN72fB7TxPkKM/C6J+2bTTTCYn4BYjl2iJSIMVpMmw1WHi8GJgQfE8OFS
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(6133799003)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(921020)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ak8XThhVbqzl109nGylndLkIgsWMG1rG5FTKxyHemyWuSXu8PDLkkX/Gny02uFRPIhgp6W5emd32NrHXkGAqmcR4X0ahQYbVIlIpsvdMnWQ6tMXU57kEp/tVOr7LgvPt2+LRn94qwsgBuXoPXVdiKY+CJO+IIAfXBWYfW1txvbkSSJdgYFWTK1yPMQMc6le2472Mf+hAe3u33FIDc/SW2zhcpH97v3p+awntHbQoD7vo55iNEeVc6pIOADterpOM6cQYCyMG3ElLXN2vOzgwzU9Xz6MjTBH7idvAlPjuA+61m/FAY3EFm/6TeFn8nQMm9/es54QXMQU8GdzjSEoju0M/XLb+LNfTTY7gw1PaupzzXSUubXH+pN7ZjddNI8gZBrn0aDEJfNusA5VpkBmjWkLI+Vy25SaJCouw3XM2JCkT7aMkV2MAk5EM0g6MGdTz
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 15:44:46.9571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c597694-751a-47fb-0499-08df2940e8ce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS8PEPF000000E0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9687

From: Ashish Kalra <ashish.kalra@amd.com>

rmpopt_init() prints "RMPOPT optimizations enabled" gated only on
X86_FEATURE_RMPOPT, which is a CPUID bit advertised independently of
whether SNP is active.  On a system where SNP is disabled in the BIOS the
message is still printed at boot even though RMPOPT is never actually used
(snp_enable_rmpopt() bails out on !CC_ATTR_HOST_SEV_SNP), which is
misleading.

rmpopt_init() is only the software setup (workqueue and the delayed work);
the capability that matters for the message - an active SNP host - is
checked in snp_enable_rmpopt().  Move the announcement there, as a
pr_info_once(), so it is emitted only when RMPOPT is actually enabled on an
SNP host.

Fixes: c6c6f156d192 ("x86/sev: Perform RMP optimizations asynchronously")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---

Note: in the posted series the pr_info_once() lived in
snp_enable_rmpopt() (SNP-gated); when applied, c6c6f156d192 moved it to
rmpopt_init() (feature-only-gated) as a plain pr_info().  This restores the
original placement.
 arch/x86/virt/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 43e4945e6cdf..6f5f4ee821d0 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -656,8 +656,6 @@ static int __init rmpopt_init(void)
 	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
 		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
 
-	pr_info("RMPOPT optimizations enabled\n");
-
 	rmpopt_soft_init = true;
 
 	return 0;
@@ -690,6 +688,8 @@ void snp_enable_rmpopt(void)
 
 	mod_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
 			 msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
+
+	pr_info_once("RMPOPT optimizations enabled\n");
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp,kvm-amd");
 
-- 
2.43.0


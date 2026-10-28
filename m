Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793216997;
	b=jYjaDjEg2gU0UxuQ0Tqil0LlEyccbS8EHfMNXZB5/mQkr6ktaU0vXZWpIBIVVaVv8yiN
	 CQ62B0NSOFgiTlijYnSAv/3m+BtnRNolh5eToipGpfe3qs0SfwyVGga7v4d8oxRq9QuYO
	 1L4s3g9Ar+3Pv5GrNzVtJsRVw2V/dYBGsoVxcEEQ6vZiWP5BICgA4Fkq5REX5Up1xqnvr
	 OIusllj8lPG3BSq527uTY8DPtKEpWOrvsq3KCUuI916qyM1gPv29XpVgw2MH0Q0mVGvqE
	 DBKLTakrH224XKlRLA0TjIpnciKx12IbdezCEt/h3DSg0qZPWEyNp81/7dPA4IirIiQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216997;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=QEK/2GoKahT9YKdkjHOfvE3phQokPojmkyxfKy4rb/k=;
	b=Lq4bJZJy9j55r3Ifso+GkzC4UNPQXFS1F9M44MxxnwGeU+M716Vt3cHZSIhhciKPQnzy
	 qAE3+i6woIY1G9lsQWl19OOL+WBQ8L/j0Cx7fzmYOaJ/o+917PYzXv8sGSSp808ZfmRRU
	 uy+BrYeaHmuX8WDDAWFSF/snL/yEm4dNSapd25+NNC0VNOefUnJuemsVejK0+NEampm0t
	 l97rtcfLrvS+43T1nC9zHkw1b0m+geNdBAUO0TsqUGf7lmsMLgUVvv9csaCQ3h4Yvd3ab
	 xlPH2qYs+thTQjLxTlqWObvOr58j8VUp9A5JHw5VMnTmNobQ3dcB5l9uWw5y8bvmxEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=aemMJswK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.6
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011006.outbound.protection.outlook.com [40.107.208.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED909606A321;
	Wed, 28 Oct 2026 19:49:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED909606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=aemMJswK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z2GfM+xc/SwaooS01mL45ozLi8t5fcj1nIZgTmeJHcFMCds1/L8QhLhU0o35rNw4lDPOtrH1vIbykwvNsS84CeTjy5fgWzBAABv6NBhpd8zsF30qf/kfoQ3wQi7NRQ9gDpnOwhjxoVpam4wyJmkfcGr9qK+hOU9sEByrY/IkgXDiBHmcHqFSz6ycD+Twx1vCoCGdIGRPpuDUQn5iIxgLAcONfVTJuUguIUBeC1UKpwLP0XoZmsE2n0T3iAXrsEpecY9DJn/OYPBKxxKReCTchLFj15tNctrhpbys7B1Yp5EV9zw6gLvrx5uPQ373hNEE4JETyitM8omix1rshq3ppQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEK/2GoKahT9YKdkjHOfvE3phQokPojmkyxfKy4rb/k=;
 b=rFV7TY48oBWdMJthoGgYMByDpLtw2abrZu5ywnGWadDcCpKpW88OVAJ5YTW4DbaXyVGQ69tyhd/9v6KCPSL66K+JiLBrMryl1SH4QfnYFb4HE4R8DlYXGOqNW64Ppc6+rgTpIc0c4h9kHpwIal+zFEWLCTClg7Bl8h5lykS944197lk4PXDVKl53i3+jlA0Kig+1kgl0uwXKdF0mgrcOgWDBBRijapgds7U+SYTf3qWTQA/UrnWT78+NTWYtLTsZOWM9Lef2PQUCr9Eiakl0ZymjQCCRhO/t5S1GcF1M6P4uJI7B7FPP2/lVIFEIow+/FdW3y0I6UF5cQEBwp7wWTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEK/2GoKahT9YKdkjHOfvE3phQokPojmkyxfKy4rb/k=;
 b=aemMJswKMGRoiZxACoG+leTb9Pldg7MOh45VlVqxXhoD85kiHl70k60K4yfGaTg5YgfW8oF6w8I/BSJZeHD/g01QLXTb4Zg2q6Uc+cVlzOILEmdG6Srj9l3fwnH0LLP6e8qePeE6zdLyyjjpcMiyeKVUwq9ckSb0xFTl8aExt9Y=
Received: from DS7PR05CA0023.namprd05.prod.outlook.com (2603:10b6:5:3b9::28)
 by DM4PR12MB6637.namprd12.prod.outlook.com (2603:10b6:8:bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 19:49:49 +0000
Received: from CH3PEPF00024581.namprd04.prod.outlook.com
 (2603:10b6:5:3b9:cafe::62) by DS7PR05CA0023.outlook.office365.com
 (2603:10b6:5:3b9::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.3 via Frontend Transport; Wed, 28
 Oct 2026 19:49:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF00024581.mail.protection.outlook.com (10.167.252.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Wed, 28 Oct 2026 19:49:49 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 28 Oct
 2026 14:49:48 -0500
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
Subject: [PATCH v4 2/2] x86/sev: Set up RMPOPT only on an active SNP host
Date: Wed, 28 Oct 2026 19:49:38 +0000
Message-ID: <331aeb2f29710865ec064bacf9edacaadde2b094.1793216372.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1793216372.git.ashish.kalra@amd.com>
References: <cover.1793216372.git.ashish.kalra@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00024581:EE_|DM4PR12MB6637:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b392125-cd10-4e5c-38ba-08df352ca078
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|36860700016|82310400026|921020|261026140227099003|56012099006|11063799006|261021123027099003|261022105027099003|261021121427099003|261009223027099003|10067099003|261028144727099003|22082099003|18002099003|261026121527099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	H7Hnca+jlFHQESRxSp7LzsAL7RcYA0VRQYRMFy2xbuott6FOiOEh2VKKLpxXqW8HNwzaQGKNi6anAGmBxSBLFyK7b2it6hG1MdPKrcueNtr0J9ngZGcZ7MWAdcDWXAX6sYPQpBUjZyjnVK8tMVw8usP546DJpYI7jelRwWKSONh2AHGG2WkzRp9lkyBnU2AB/gP+BrorCMJstqJfsO1uLsTYIHC3WSgicMWsBP95xQ6kKY3M1DkedJVavnT3RmeM8tjakLhOKQXewdvy3Ok0zQ8VHXbMayMfqLT7a6EExb1h1uH4epaBJB8BKe1zDRLH+AImY/1JsR5uJv3R4nOMPtVWoSd9j6CA/RlvjaC5mS1HehoWArF6pGyo7pSHJ/yLFjA7m+lZ2/QvtWC16WvkDc+39PrvpDiEHPb8hUWXRB5Eqf7r4nHvciopzyvJojNDYnu5tG2G6Ke7YnvI0D12rbbUoWhyZ0vkPROUSbEsht6V6Yjhkl1Bub8f4tOLjegU5zp6QQ0vrcManeBRHm1XNv0Doi8Yj8iEx83copOE3vnBIWbuZCLmVLGTq4KFrS1iQyYghnf+KjYuyD4mOgMrl89facE/EkqL/5spQIcWhA+YGqkwu7l4hhkI5trhyBxCJDYU3MriCHiYVwjPSFXaXdkCNOYPtNwiyqziWdKz7bcGdy5G/ATFXGypyF2li46lrCRgbV7mCI3/txlF958CJK8vfhzh1okSouuYTkAF5r1B9PcgGVQAqL3dLppNTlhG
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(36860700016)(82310400026)(921020)(261026140227099003)(56012099006)(11063799006)(261021123027099003)(261022105027099003)(261021121427099003)(261009223027099003)(10067099003)(261028144727099003)(22082099003)(18002099003)(261026121527099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Sw/8pmYXqb4zb3hyhZh4npgp+lo4G98skCGmyYQGk7P7wxotfyNsQOcNshHdFUGkBBdJw6F7gxQhbEci6IliRxaezzMKRctL3xiKPEKVD6/9nGdhCOHjBovTUACi10SR89a4VPPLJTPkyzty5woU5vkjQVaYd79+U24QidCN6DLTdOMEJu0I1EBpcy5Ef8ggVokFR0OSjyBfJORSeEiHV8hfvfaX4MNseEBN78Pzyt/5iLw3qe95uuIW90R80XJkLKLWSLmUmRI/fIQg7YGrL6Y1DrYLJHol0Ic8D3OfTU1rbkJ+eOUBbiifvrlXvUbN8AnffyxdWeqG+qhp9M8NWz+rlX4o3tRtjuGIeYHkY8Mci3krdBL8ss/qhL4wdHbaL0BKVsdffkjKReWhYzIGi9+seB90H45PBCoCxEziI4jw5lIcd2Avl99iurk3kamh
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 19:49:49.6419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b392125-cd10-4e5c-38ba-08df352ca078
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00024581.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6637

From: Ashish Kalra <ashish.kalra@amd.com>

rmpopt_init() allocates the RMPOPT workqueue and prints "RMPOPT
optimizations enabled", gated only on X86_FEATURE_RMPOPT - a CPUID bit
advertised independently of whether SNP is active.  As a device_initcall
it runs on every system with that bit, so on a host where SNP is not
enabled (disabled in the BIOS, or AMD IOMMU initialization fails to bring
it up) the workqueue is allocated and the message is printed at boot even
though RMPOPT is never used: snp_enable_rmpopt() bails out on a non-SNP
host.

Rather than add an explicit SNP-host gate to the initcall, set RMPOPT up
where the host SNP state is established.  Call rmpopt_init() from the tail
of snp_rmptable_init(), which runs only once the host RMP table has been
set up and CC_ATTR_HOST_SEV_SNP is guaranteed (it WARN_ON_ONCE()s
otherwise), and drop the device_initcall.  rmpopt_init() keeps its
original X86_FEATURE_RMPOPT-only gate and no longer needs a separate
SNP-host check.

This is soft initialization only - the workqueue and the announcement; the
actual RMPOPT_BASE programming is still done later by snp_enable_rmpopt(),
which re-checks X86_FEATURE_RMPOPT, CC_ATTR_HOST_SEV_SNP and
rmpopt_soft_init.  An rmpopt_init() failure is non-fatal to SNP and is
intentionally ignored by snp_rmptable_init().

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Fixes: c6c6f156d192 ("x86/sev: Perform RMP optimizations asynchronously")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index cd0412b9d251..39d3943cdc49 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -662,7 +662,6 @@ static int __init rmpopt_init(void)
 
 	return 0;
 }
-device_initcall(rmpopt_init);
 
 void snp_enable_rmpopt(void)
 {
@@ -726,6 +725,8 @@ int __init snp_rmptable_init(void)
 	 */
 	crash_kexec_post_notifiers = true;
 
+	rmpopt_init();
+
 	return 0;
 }
 
-- 
2.43.0


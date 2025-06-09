Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E771A3167;
	Mon,  9 Jun 2025 04:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749444704; cv=fail; b=S7hDtSlW74NeFU7ayoKkISARmAnovH4jGw8t1eGyDLEXGbcHZ20PWzkXRD/ChOoSMbwkZeihH3sl0FqAe77dvBP45ld8Eq9ckAOSEFFPNzac+JeSHMLc+sy6fznfZ0NP4EXpdRMAfLmRH2UmZODupQSUjjKG7q+A2hSacIx81T4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749444704; c=relaxed/simple;
	bh=/MxiJ8Fhkz/5h9QQVo5VjyWcwckk6spSP0uUy6xNxmU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iqd3uA3yHvmHtj2XQdUtg//iP1l2gwdnmM9cbPhUsyV5O5CZnKsvW0tP1AJ1FHuYOBAV5aHbaxrumU+bekHcl8YEzR15QjXveGDs/n06qzwq3DynxMCCefVmtKCW3ffqOXl+k5r2sEROavNPtC48ZoU9Shvh4wda5juP90CRF4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3nYejP5C; arc=fail smtp.client-ip=40.107.223.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3nYejP5C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kR3JhFT58uQkkmAxa69NfP1N//OxbAYQIj/kXFkY6MIUs3PDTAtlIWe38nzvEuEXnn7WtRkgeqIeWwE6N0GyJOD2Ap2saHCyXNAo+pNEIVNRAwNGsqZJ9zj0Z/4Vf2i9dNDT/xw2gVV4wrFzH874/3R8H8kB4uPQFJ9yctywR1qWplwSm6H93lFhUJjAKs8HSJ46P+e0lx+0H3lxvz8dBsxct+S97jfxMb8dDBBbZtYnY0q32Us88eLbRj9FIwdmjXo+yA0lMk/BNd4VibaebJkcG2QwElsZbo/cyAiTU0DM/DZIunq8fk+wwJMt1vs3AldyXFJgae8irdN1NsjrqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZTRdPwyosdLWFDu4OPGv1BY5ICA8J5E8TXEk5j7wu8=;
 b=Vt+bd4OJ/OiRUeEBaLQYaWXCEhoFZajME9DjRa2tnirY/4uE908CjXzeOrLTEupr99rQ/hLDoIHeBnxR9XgArJEBzkwoNubKNilts43yDRTGqvLon0E7zdlKPvUDd+fZVzBCiciZGahocUx8FvvyY2eKdjexc9Aq5DhPSq4EVcMc4QNp+iYJgoBuT5+WbcKpIBVbXtWLrbRJAFLJD5JatiPSO5/R7BOWhbLomdMceKJJq3q5dlE/9UGSDxVfshhkJuxSTutEMWKFQSMrO+TVqeIXXAJr1no6NEb0rgHFZe9cZKS2zdayTP2U3KCK6M2bhRbw03V4hACg32GqmQLmzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZTRdPwyosdLWFDu4OPGv1BY5ICA8J5E8TXEk5j7wu8=;
 b=3nYejP5CyVmGldVAHYNASHFRuXgavfK+zmxac4hp0G96psPBX1OGpSsIM1eL9cuBjEExguyC93uaDn4d0LSix63pxpp1pBejCZSLzupu9pHG8oMnxwPV7DEoAmIkuN2Wa5H8YyjkXoDGTbWFV0xFmMBo5J0KpZ/apyxVw+VJvPg=
Received: from BN0PR04CA0194.namprd04.prod.outlook.com (2603:10b6:408:e9::19)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.41; Mon, 9 Jun
 2025 04:51:40 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:408:e9:cafe::13) by BN0PR04CA0194.outlook.office365.com
 (2603:10b6:408:e9::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.34 via Frontend Transport; Mon,
 9 Jun 2025 04:51:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 04:51:38 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:38 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:37 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 8 Jun 2025 23:51:34 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>, kernel test robot <lkp@intel.com>, "Dan
 Carpenter" <dan.carpenter@linaro.org>
Subject: [PATCH v2 5/6] crypto: xilinx: Fix missing goto in probe
Date: Mon, 9 Jun 2025 10:21:09 +0530
Message-ID: <20250609045110.1786634-6-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250609045110.1786634-1-h.jain@amd.com>
References: <20250609045110.1786634-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|DM6PR12MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f2bbd05-4f09-4421-4336-08dda71151dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?30qEfkI99RmiX7WWwHPcBrExf5p/S/Zmf2PCDPZGF8DclIwaFna+L/AYjbNt?=
 =?us-ascii?Q?+gf4Lwec4nTh2Q0Q6KSfNBwSWS/WWINOuX9ene3uFhcceg17EENyEdASsY0J?=
 =?us-ascii?Q?YTNDH7xl9aVPr0DZTP+D/UCwtQn3TIeIPu2H9YbG1XXHq98n0bYb/3vlt/Kl?=
 =?us-ascii?Q?Ihun5GjxD3JZ75/14xP1W5AcYCHWsSdzjzINx0M0O7xPDj5WK+Jwf5R8t3dt?=
 =?us-ascii?Q?9Vc/fYCCY2xnCmrJ/yUpHUL145mFoOxcXHiCxNlMgRajxKwFlITnizHOYuhW?=
 =?us-ascii?Q?Z+LQf84SQjs9QEt71MFBSQqf3599J5eutlyIT07gkXzzfPa3P7v5Y7XPELMO?=
 =?us-ascii?Q?aqYl64MDMv5FaqhG6K7r0qcZcxEM1d4U1QvI4lG+aB1IdF7zl+1GTiwodYgW?=
 =?us-ascii?Q?UZs91dF7Lw5+hashXuoAIFsXWCKWpH47EIxDCQXiq2d8VlFrRnYxvHU6RwnK?=
 =?us-ascii?Q?oMnZE16ALcNStbtTPwf0sDDarQaM3AxlhBFszQWQk9XX8DP5XaUTtBBA+4XN?=
 =?us-ascii?Q?hDocy5RRhWk1SZqILF5BxvwdCZE+1A/TMmi+Sp8EYx1C33zgKovVlKpS5dqA?=
 =?us-ascii?Q?7dnZucrN2VUBSHUx9+iFN7j5DNGi6ui5RNpCX1/45+RJtK5L8cxoR7Td6tLV?=
 =?us-ascii?Q?o9E9HGFWD/s5Ev0jO6r0jPfRxmhlsg0Ta/z/+1s4jwVSPDEGeRaWqqmOj76o?=
 =?us-ascii?Q?dWJ+3owfM09KD8SWq9nw0s8XXMS3YQeSBa6xqvAgRRjLqVzeNMWIlMEbm9OM?=
 =?us-ascii?Q?d2tRVA6QaVnDaSHb71rgVpm/zLeCNWeP6yfZxTwc5NuoLDduxUko9cKalNRF?=
 =?us-ascii?Q?9WO0k0QLJeqFnYzf5L4YqL1KKAQCj+fF3JGlqevrq6DTyYwHocj75kyXapus?=
 =?us-ascii?Q?s889w3Baq35HLYGyvNdGSls7AY46WoTY0SGlVPd9/jBXhjqTSAedusqu8MS6?=
 =?us-ascii?Q?/N+XSwJCZKrANwpVUOIbq4YEvIvHlRskT+xJn2pN1xdPLbcTR9r9sbeH/Ql2?=
 =?us-ascii?Q?nyr72F+uan0/vHWkglHn4yIDqOjuYD3UMIRkjyH0fKaFSejh1dGYafSa3Zld?=
 =?us-ascii?Q?DzOEvxlD3sH5hUzqKpgsPfHUBoUl8C6NIle66Q4ZBwBbhxez/QUxC5T4ioiW?=
 =?us-ascii?Q?a3JBXs3xfeAEg09qKSQpL1kXLd/vzY6XkGbS8DJ41K/3PnA5GaTGCTe+WUB3?=
 =?us-ascii?Q?157lICgJLLJ9/pKcnmVWaFpSPad+ABBR1u3RErhogwl3JFnpxCaI+iUsdt3a?=
 =?us-ascii?Q?b8IL9ud4MnzpqqFujfRNtEpqg8/YFCBnyVnROgYiVrxSTi/JcfGsIgFo49Xz?=
 =?us-ascii?Q?cBCXB5Qh8x2l8FIs2GjYphul1LXjK4DQXr8sZPT5WCL+ZhdYfpsg1T5s/DJu?=
 =?us-ascii?Q?tFmLagbK2WjSmmekVG8tTng03SLiIFYZ44wfpqQaOmzr7zMPqh/gl8tz16NY?=
 =?us-ascii?Q?9h7giPjQiXJb2a2uK5nSQpU5HBGOAer3QCpxBmWXANZ3nu3khhIE2UIBfLiY?=
 =?us-ascii?Q?KVjUdL3DpH0ERlYq1vDMUY02f/8qEqKiqMCC5FJaOa1SYw9QxKzRiyvDVw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 04:51:38.5708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f2bbd05-4f09-4421-4336-08dda71151dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433

Add goto to clean up allocated cipher on reseed failure.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202505311325.22fIOcCt-lkp@intel.com/
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/xilinx-trng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index adaf69c58647..8ec0f83b53f1 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -365,7 +365,7 @@ static int xtrng_probe(struct platform_device *pdev)
 	ret = xtrng_reseed_internal(rng);
 	if (ret) {
 		dev_err(&pdev->dev, "TRNG Seed fail\n");
-		return ret;
+		goto cipher_cleanup;
 	}
 
 	xilinx_rng_dev = rng;
-- 
2.34.1


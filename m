Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2961C1D2B11;
	Tue, 17 Dec 2024 16:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734452076; cv=fail; b=HYQCWoVAGhSr3dDlaH1cUlNUv+3w8yqC7WqJoiZaNOGFpYbIHARQtgIpRBHZgknXoYy593p8P8xgMAE+rCiDpzMSQ3kRRc+pPG4ci89f+2S/2Wp3Lohz6T/e5lE6FK2sFHCoU4ToSue7InuPCXXy6iKsilbcOOlexzX3qKjyZs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734452076; c=relaxed/simple;
	bh=lipR2YYnMbMn24w0rEE1Badwi8zxVF8UaYWgnmFtlC4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTcOB3l1GyYZmZSo9JLa/JzaGxckNTP4CmmGZ0FdLEYjbUF1F/AJMRPLXl7hIu62EBTYT2c22iDK3vSCmbZJLMmpEEYb0AkB8RusHHSNtFbbcZoNpBqSEtuugItvR9epiyyIbN1DdOIu5IqYjU+Gge9lOF+BuLC0bymkggFi80M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wy9uZJrE; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wy9uZJrE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F4XGMm7VBj45ZhBnjORul1C1oouLQfXtyRA/Hdx7nUHkXKX2w96et3yvSNPwuFGu044f8PzSHFiRGR7I5JjvuWkSMymkQCF8oXh35Xib5jNey35DCMp4VGNW97mVlVMDClfmKVtHus7p1gD03I/WUKUSlDI8QoOQQW7GVL79JFidbzLZQPAMBSuAtXMJPPcvqECb1MeQYnABr7hMNGsWZvYpEHIj5U7eCOhbMOY+hKolGtOR/M1WiOUkD0mUfrzoJlJAXVuRXaYIEY8UU4LuXxHp8scMPKlYEMUnYszWF7NYj9ENbKvOXH0FqdNzMYckQ3Y1PTxdNez/zKZS03D30A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOkb09vVWMVHiFl38HhltQe1f+1ho2iBTENP5uyq8Xg=;
 b=QcIw+VeoSvhlquHRZc96MUqS/coO2aL9XVtmJSI9mA5WUDVWlBfIG+FyOJ7/MUgSoQwv1LoMiOqZTwFII0LXU2CZ95gBSSuytUj4pQCghpo12potWQoFHlWeFAwJPW8CKyrG/BJfX+qYNHVAjc5P0iysRUJdcf+kofajwJIT2lMFh2FEVPaxpJpNBCOpbHi572Hn7KxTIw8A6COkQNC/9cxcOQ2O33eWLolcaQzJ5ef88xG+bfrNOIk5j+e/shv4RwWdWlfLdIRT/zB94zwKRaoozuJpF7RIKis4RVd4ENfUaC0V3mgc/btDJEEj9ZzA2SjPNIh1CqbdubW0tahY6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOkb09vVWMVHiFl38HhltQe1f+1ho2iBTENP5uyq8Xg=;
 b=Wy9uZJrE4drt/Cxkv/85YTBgcuThkEJB5yg5UmMv+4CiOcFBFEfejIGlB1gqydGK2qNSLfkkfgXwcOY4KnkHogukDwvLzLagFHXUfrcaGPByfJchiYmphdKaXsgKbh5a/hX5SQ/zo9Iy/muu8brNF7iGl20wkQpczQsdYrlZbSZe3RjrQjwOgsipIwtJGqNXTtzPfnrlc/0yk0/sp3oje9NWG66lk57y7EcnbLltCqfARxs5AuI/mtDxpeHV9ZqQ3+BG5en+55GqaKH00aE/kNVjJJT+5teHi9uUn/dPgd6agR/j4C5Neb3i0SHcxf+jkXRviWM+NxWzakpq+HnzNw==
Received: from SJ0PR03CA0185.namprd03.prod.outlook.com (2603:10b6:a03:2ef::10)
 by PH7PR12MB5758.namprd12.prod.outlook.com (2603:10b6:510:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.20; Tue, 17 Dec
 2024 16:14:31 +0000
Received: from SJ5PEPF00000203.namprd05.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::4b) by SJ0PR03CA0185.outlook.office365.com
 (2603:10b6:a03:2ef::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.17 via Frontend Transport; Tue,
 17 Dec 2024 16:14:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF00000203.mail.protection.outlook.com (10.167.244.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Tue, 17 Dec 2024 16:14:30 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:14:06 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:14:05 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 17 Dec 2024 08:14:03 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <akhilrajeev@nvidia.com>
Subject: [PATCH 6/7] crypto: tegra: Fix CMAC intermediate result handling
Date: Tue, 17 Dec 2024 21:42:06 +0530
Message-ID: <20241217161207.72921-7-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241217161207.72921-1-akhilrajeev@nvidia.com>
References: <20241217161207.72921-1-akhilrajeev@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000203:EE_|PH7PR12MB5758:EE_
X-MS-Office365-Filtering-Correlation-Id: c3cd31f3-da1d-49bc-a158-08dd1eb5e2f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NpdXZ+HrXzF4B5ZvMltEogOLSDmr5VFxBGBK8LfhL9kdecRDAM5PIAqAaEUB?=
 =?us-ascii?Q?lAshP2RCQ0ftoRGATOq6kRTNSgfX8HbaS6emgRG5INJPwfdbzAwlauqL8GdZ?=
 =?us-ascii?Q?d2KBfRCFqH1juQg4tJgWrkCIn9KlQJ8FoH89ge2dqzro4GGv7UTKm7fp/Rde?=
 =?us-ascii?Q?/R3Nm4HPvOKin8LBWRzGske7F4viCO281GXyGKTqt6vJEXBWlNC7S9TkVOOx?=
 =?us-ascii?Q?fvGlLeNtPNUad9b5tgwGFVUaaa9NEqQbgikGmcckB1GaRcY7TDdT4S4mdakI?=
 =?us-ascii?Q?9gdHK41FG6hAXasTCA4v4xnKyxx5NtFbikDVOVgv19milWmaI43HKOs6xoQb?=
 =?us-ascii?Q?VL9470cQ0lUR1CGEXWToo6ilN5tkQ8e2Sm8Wb3jNffoHaT8LZpHNiRxDCL/Y?=
 =?us-ascii?Q?/IhfIzsde2HgkpGfrHaC3Qo1tUB+ITOdfwvzPnwhuDucspWPepCNY1qTJZru?=
 =?us-ascii?Q?620gWTzDLrewF4E9ZcGZM3yJwiH9sfcfipjx2CNbxO76UrjISt87WR5cIXj3?=
 =?us-ascii?Q?0s27aZF8bA4wPgEruauMwt1LbdvMgW0uTuU8+Xpkb0w+Imsh9qK5ck5nMWXU?=
 =?us-ascii?Q?4miqXTRvDSge7y4PiHSLaWiwLslvBZnknde1yyYaKtOvEbIvBzJqeZBWWNU4?=
 =?us-ascii?Q?22qd0ed3ptDX4w/XTGQVMZKXuYO2uEdrFrPvbcUWWNp1IUkh7/IVhoyOM30m?=
 =?us-ascii?Q?fKw216JZm3RUkJ0op0c19UTT4Iq3Xw3cU+6hItPkDbuBp5WcI3Ifngvp3Czu?=
 =?us-ascii?Q?CZKQWKKfMdZexh4FjvmGRCQVoyeFk2Q1xQDJVKTVq3HC2vVWJ7lCeplWopnb?=
 =?us-ascii?Q?bpOkWXz2VJ1grcwV3ZdER3w9QFEOA/wxURHdrp+JiDzS+eLY2zvREGWjbXFP?=
 =?us-ascii?Q?fKDyXBaPzWWBn41UOGjLLuTJt+/NFm1vtwG9NIdoAbM8skTpvfdGopwgvDMc?=
 =?us-ascii?Q?Tg3FvievEEXVwBdMBjnzCEEE0YPuLcrpuOQoU1xPTfc0Z9qd0X7240/nTY4z?=
 =?us-ascii?Q?OSomdvnOqsbLUZVXBcVAtO3WD/FsXmck6JEn9fWgyBMUwaKDzxSYdnkvK9m7?=
 =?us-ascii?Q?KzBpBZ9ijapBLZpVFvWVqHgOc1pZsUWNv17nl0cr4BWgSaT2zNcEW22vAk8W?=
 =?us-ascii?Q?2qoaHCalrV3h8nfjK3S7PC4ffpeoDtYWpthgkHBbEYNGHISVTp6NlmoaX7SP?=
 =?us-ascii?Q?R1gfE9AJiNBAbc+S4CtFW9t6Qw6HR4SL/JVQ6vJYLRoEGgjxSw//tVbeQvfm?=
 =?us-ascii?Q?xcqQ0rPOkzK4C67N9NAHAgPpn7Lv5YKNcNd381jgr8PiUgMMWvh9o2Wf61EP?=
 =?us-ascii?Q?/yXx2pJwWSDOX3OuZXAhiKc6sqpIbXe6voor4ZLbQLEobVLTDssa4hpNCLJQ?=
 =?us-ascii?Q?ZmwDVmmNBr+GWOIMMks+uyl9Mv6RQ+8q4JpRxunTCzQjpSpVoQYrpM/o7voo?=
 =?us-ascii?Q?0Kisv473ZQUH86ToYisMeJAwMijoPL+xoPrqoaz9e+wfZm/7VgCoWQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 16:14:30.1450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3cd31f3-da1d-49bc-a158-08dd1eb5e2f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000203.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5758

Saving and restoring of the intermediate results are needed if there is
context switch caused by another ongoing request on the same engine.
This is therefore not only to support import/export functionality.
Hence, save and restore the intermediate result for every non-first task.

Fixes:  0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 5d8237cda58f..cdcf05e235ca 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1541,9 +1541,8 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 	rctx->residue.size = nresidue;
 
 	/*
-	 * If this is not the first 'update' call, paste the previous copied
+	 * If this is not the first task, paste the previous copied
 	 * intermediate results to the registers so that it gets picked up.
-	 * This is to support the import/export functionality.
 	 */
 	if (!(rctx->task & SHA_FIRST))
 		tegra_cmac_paste_result(ctx->se, rctx);
@@ -1551,13 +1550,7 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 	cmdlen = tegra_cmac_prep_cmd(ctx, rctx);
 	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 
-	/*
-	 * If this is not the final update, copy the intermediate results
-	 * from the registers so that it can be used in the next 'update'
-	 * call. This is to support the import/export functionality.
-	 */
-	if (!(rctx->task & SHA_FINAL))
-		tegra_cmac_copy_result(ctx->se, rctx);
+	tegra_cmac_copy_result(ctx->se, rctx);
 
 	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
 			  rctx->datbuf.buf, rctx->datbuf.addr);
@@ -1594,6 +1587,13 @@ static int tegra_cmac_do_final(struct ahash_request *req)
 	rctx->total_len += rctx->residue.size;
 	rctx->config = tegra234_aes_cfg(SE_ALG_CMAC, 0);
 
+	/*
+	 * If this is not the first task, paste the previous copied
+	 * intermediate results to the registers so that it gets picked up.
+	 */
+	if (!(rctx->task & SHA_FIRST))
+		tegra_cmac_paste_result(ctx->se, rctx);
+
 	/* Prepare command and submit */
 	cmdlen = tegra_cmac_prep_cmd(ctx, rctx);
 	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
-- 
2.43.2


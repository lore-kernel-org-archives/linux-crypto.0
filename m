Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309DB253B61;
	Tue, 11 Feb 2025 17:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294438; cv=fail; b=C1Y5l2op0MGuClUASQ0J87peqb8u2TQ1ofE7QQr2DHFYtIgtJPDKp01jAQPJUgmKDcqTr7u99sXaVAOO6/8CemBM03czOXl0gnD2h7ixevWdQfcuti5QhzuEkVIXxNAOKLsRO2KEAQPFRpDxL9CLZZ5t0OBLYcBYNFMCZqynDqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294438; c=relaxed/simple;
	bh=/pzXCbzTL3g3xJo9CpIxcnZCC4zBPvXsDWnmPI2wesE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cp0cTi3pjJY3pgsiAgBLMGBUguEz2PjENooaBcVt+gntdgKdy55ekiaKFnHLQPBONATcllLpWJatDXPJnJzyNaw3l9tZG+UC20ILcjnc5g8f8G8wWQI3+zk0CJ2TKBgnSogx6akpI9/pAN/LNaLK1FIiYqNZ7TGZfyz9+cepMPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KN9gXX9g; arc=fail smtp.client-ip=40.107.236.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KN9gXX9g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZexdOzezXX5H0oWA2kH8cOgCCwcwrisStCsl62BnUN5QCJEkKSAZpEnsxxgtpGYS2Qx2bL07ufu4VlGnupk/wEdn1ZpX6XFOPEUb2pmFAMKIy6XmLvvuPjeLSKXzg5fHaPq9dzA5kXCANVfW9++zABbboSiBH+lTmyxEWhSjkmJxbZqbmz5XM209Ik9e7odnmaNm3H75/e/NoY3ZuZjgIQpEf2PZFq+w47d24AsPP/Xpy90hM+TxJUXW6o9cTqKjfvrPIn/LptsOA3EoMAPk0/VlzNHpZ7MZSL8oihXanE8BsD3YbQCyE5Eevda6IGVvfl+hfU/72/dAcuGnVivUNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/5IBQDQSYiTRC2/2/MhdH3GNxBWs233RDiKmJgt/xs=;
 b=bwg52CtgdQfbJldf5CkH3mAKNbDlCUPB7yBtRDyvsG9UBz3VC7tG6zCOP8J0X/HguSmIettX7L1CugKahWoy0euS+97u+KxHVjAN92Hi4TSGhiAbb6qS34zKaZv8cT3yZyL/KtXe0AG8HEpYe5x87km4srTXy7lw7p+3zbxWt6Sy1JpdrQiqaqhc2B8/olF6acgzE4j9NnWH5TFRqjXObwHsgXhFyUjETmkexXHtxWctragtMP/UkSZvh4S33OqcwWmjl2TRzn1eOLcW7fxLhXMZur7RU2IjF1Qv+Q9OQU01U9j8KBI96zM1etWZEkww1uoyTIbaC3J8f5MWhL5E7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/5IBQDQSYiTRC2/2/MhdH3GNxBWs233RDiKmJgt/xs=;
 b=KN9gXX9guBnC+mc4WO8+cMobju/B0Ggb85CnVhscD+e/yW/mhu4mU3lVJz4/mbTUwT1Q+s4Qqte31u2NCKuz6p9rYkqsLAtW63zaKYQiB9ZmuM2KQqLoCMmcGOi+ipTLmBnmEmygCqam8LKqmoeZ3dAV/gTPkUbMGCTvuyH9fNxLkkM3NOax0EibEvVauDvQtt1Uq2gSQ6PydbM5TdNx5kXlCIOxiLTFq9stntqxXCtGbQqGGZmMy1acsmUlgtgSqfxhIro0D1AKxKv7RryjVbGXXnvTDP7J5kbYKcSgu0FJmCX7g8OJiYdmcfYtbGdM5zn4+ljKykcER2l1LWrBQQ==
Received: from MW4PR04CA0234.namprd04.prod.outlook.com (2603:10b6:303:87::29)
 by PH0PR12MB5677.namprd12.prod.outlook.com (2603:10b6:510:14d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.17; Tue, 11 Feb
 2025 17:20:34 +0000
Received: from MWH0EPF000989E9.namprd02.prod.outlook.com
 (2603:10b6:303:87:cafe::29) by MW4PR04CA0234.outlook.office365.com
 (2603:10b6:303:87::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.12 via Frontend Transport; Tue,
 11 Feb 2025 17:20:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989E9.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 17:20:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Feb
 2025 09:20:10 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Feb
 2025 09:20:09 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Feb 2025 09:20:07 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v2 07/10] crypto: tegra: Fix CMAC intermediate result handling
Date: Tue, 11 Feb 2025 22:47:10 +0530
Message-ID: <20250211171713.65770-8-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250211171713.65770-1-akhilrajeev@nvidia.com>
References: <20250211171713.65770-1-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E9:EE_|PH0PR12MB5677:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c19b814-9ca7-4271-514a-08dd4ac063d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MCENGzBg1u7kDjFg0osuqQe3aiKXAGwaUE2u92YNhc6F21A6rs9TipKkrP/j?=
 =?us-ascii?Q?uyuLhF9U+4Zpl2RWvD2e+rbzQ7cT0/YhFmK6R742se4omw/qprFUXNTMaqN6?=
 =?us-ascii?Q?4VTguj9HTekW5bnnnOi/K0rZ5kwr1YxBCEgS6xOy4VGMgJcFyu+MNc6O9J2W?=
 =?us-ascii?Q?TEUSfDePYBdn53BHR0o0G7CXbObNzxwAI/9QSwJx6g09mslmg2mO+swoTqFI?=
 =?us-ascii?Q?T99nlhp9XEiN0X4A2ECOSX7qgrqO39WM8fIbWcQG/aU6XlbGELJs8y86QqrZ?=
 =?us-ascii?Q?pWmeQw8GlrHQNB1onZW8MF33SE0jG/UsqTIN1sSUDroIiLNnAoZLFlncIH6j?=
 =?us-ascii?Q?pHUW9JrOdCEATKVy1smiLtRBMcgcinLXbvca6xn6tL8R98E2lYvtJTf19n4U?=
 =?us-ascii?Q?tJxquIJQ3A8EBVZmkXVn/t+2qEp2dROJJnYmiDpXL5hrB0Jgn01u5+ftp9v7?=
 =?us-ascii?Q?kwPPXULywopg4bmjDM6otAPjY+OT17c2vqeOabEzzLlqiztPaR6HsKjAZBbs?=
 =?us-ascii?Q?UtjojWNmK+TIv5zTLAya4KRIR1aksUdtV/HcMRdy1Atyb2FAYz0TSAhePGro?=
 =?us-ascii?Q?f0ka39o8k2mWZBTi0kbBi3C3We1JxSWIQwTxEN+VQ+FDm1yiuPaZRIyUzL8z?=
 =?us-ascii?Q?09ykYZnQq+yij79AhAcamSVwFrt+e5MoXAoLpxC7yV3mUXwRl6Z7rjsiLE9F?=
 =?us-ascii?Q?ETUZ13aTFMq9OJFmHVRLgHs5bBzlR5Wgkof/v+dibNyGm+KsaVe+i5+fL6as?=
 =?us-ascii?Q?tzn0bettqlGpX6FECbbzzqiamCErtXXoSH+kptqr9Sl8CrKq6gcvfv8QKllj?=
 =?us-ascii?Q?t2OO9DN63SBP6CyfWjNLLMFUH+FHMwxk4TwTHzC2HIv4aVBNX3bb5dz5LKFD?=
 =?us-ascii?Q?0C8LjnCqE5vrnIyA5u0uTsgr5aqAkVKajkNA0xooOxD4hhuaWZGcjCQzigTT?=
 =?us-ascii?Q?GRZ9yCMYUdcumTG3SsVncMs9BGp9t0XUFoSRYYoF9Z74/wG7nvPqANQg+O9L?=
 =?us-ascii?Q?9GIKA2684beZQ7FudjnIMGKip4hctX2utZaD/5YLdZhZ3ftegOj1Pm9upksP?=
 =?us-ascii?Q?emhstP1mJi/3l8bR6h4YLEqxlPtGy+BsYtKhjbZESkAmq3COCVXM6EqjrQIW?=
 =?us-ascii?Q?cRwLqr9oEbsRdfQCQVPCQcMheMLZ0xasLeFBLl1KMltXUnm/JvGana2pAmMU?=
 =?us-ascii?Q?vHVEzDC2ZH/2Eltp7qIyLqXQQAl8vZhjiKJL8IIScvbj1NkBHvJ3/W+7NFZf?=
 =?us-ascii?Q?hvTmODrg09LLoCsEaHzKwaYZikolUs9a5CnlvFMaMRo0j8ac8YPI+1xMQL0M?=
 =?us-ascii?Q?EQi91ZP5DQ29aQBT5w9YnO//oCVeVOTt7qi9io7U3D6uKabkAgv7TYdXTn7F?=
 =?us-ascii?Q?PE35a0P97muv36oZq9znuNGOw3EkK8J3Zfrhnmf5nBN2woLDJt4Q9pCIPAgL?=
 =?us-ascii?Q?2mydEYtjTs7GgXh0VCvGPTRF9IMrLbUSVvWarAEwohgN9x70tY/AniaCYTYP?=
 =?us-ascii?Q?NF4MlcT7cYEib5k=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 17:20:32.4576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c19b814-9ca7-4271-514a-08dd4ac063d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5677

Saving and restoring of the intermediate results are needed if there is
context switch caused by another ongoing request on the same engine.
This is therefore not only to support import/export functionality.
Hence, save and restore the intermediate result for every non-first task.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 2d5a59f0b249..c97dc2043b3d 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1547,9 +1547,8 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 	rctx->residue.size = nresidue;
 
 	/*
-	 * If this is not the first 'update' call, paste the previous copied
+	 * If this is not the first task, paste the previous copied
 	 * intermediate results to the registers so that it gets picked up.
-	 * This is to support the import/export functionality.
 	 */
 	if (!(rctx->task & SHA_FIRST))
 		tegra_cmac_paste_result(ctx->se, rctx);
@@ -1557,13 +1556,7 @@ static int tegra_cmac_do_update(struct ahash_request *req)
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
@@ -1600,6 +1593,13 @@ static int tegra_cmac_do_final(struct ahash_request *req)
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


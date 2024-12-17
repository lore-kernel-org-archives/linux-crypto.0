Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502F71F63F5;
	Tue, 17 Dec 2024 16:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734451993; cv=fail; b=SLYbY8Da1EpKcg9s4n0S8bTz2ADuqXHCmhFL/kO+RnW1ESEjDewR2qUzRIvAVZK2l6zhjEGX2rEMJpirWLpQbM2FD4zD9GfWH19AlbMbO9WmWZ04TmEcCoqpZjYWoMwhnp/JpTzhaflnmMLs7cKuufuVt1EMSo8f5eACKuoaWb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734451993; c=relaxed/simple;
	bh=CuX1xd6/01ZLKn9toseoMF4Y2gidmKAekxJrIfmBMes=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iTa0jSxuM3ffomImq2gbET3bXKF9XeNs7HcSAiGRpgln3J/Eh+NRieK0Rc0asQadnOlrjIHLnIwiA3b36X1JdBaYPyl9vPo2au6ImDr6d597nW8kmlw6dSIX/91bKUbhdGcIYhdaQzpZOYMMUCzU6a7DhfELiwe6HyWk/m7Dq18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qk8Vmkb/; arc=fail smtp.client-ip=40.107.223.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qk8Vmkb/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IMdzbsUsakXLlNYQlnauI1wdeYI1TyBoj47J6VlMW/xbxMJW4iBtuQJlylm2WaBi/kplcCgTJstTTPXGn2lTsRDBk+BZSebuQLWcs+8xXocj45180CFprukZTUuMUf00GDhHhAbL19GzdX6YG4/Puf8UISCKSAXCOlMiSTKU0nX5FVoZR4Uzu3t4kTkfYcju8IDv5kwZFwcFiCFGLfjEX65NXmaj123/Kfg1U25BK4YeIwWd5rOe2YoF6tjCPXOhhsLgB9dBY9kurTxc8NcV6bVRbfZEGUGPYvtA2G5l3iqF0nXSrreZIQzLnyyXWQthDuY7MPPZW3dUCEf5611O4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+AYiwCXPqp8tvlNfH/KfypMvI6eUDYPB1FKwjXs7Dk=;
 b=J2VoI1/KRqO96gpXcm7WVqZJGKN4DAQZGkdnD2tecCgfmIvSISIxvcUe0iTncTeGYFwrl057PqZyXtVu6K+33TVGRWOeV39wbExwqdKHfZr32PS686o45830rWWhqNxKBUnRchrKljsorEr3Gvrc9H7PCYV1Gpse1ZXwGjdUcZvwELxzZrBpthVHsDhfjfK8RvRAUx96iLYqm2IRpzpX0Pg/or5e75A9mWA7Al8mUq6X3zulHdn0zPdL1ZBdIY7id3f5Rd9eBW+XheZcAfhm06yQvDsvXboNqqayf3TLeWb49eBcdPOE0k7GT4bFjWa8DZuqEWKVGHZHKjlDf3y0tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+AYiwCXPqp8tvlNfH/KfypMvI6eUDYPB1FKwjXs7Dk=;
 b=Qk8Vmkb/seDB5xOtu3t1qctbD2pih55VdanV8OD2o3KGRLWPtDX8Mf61XSdE2wYtJHAdRhuGxex2QK8VafXILdOH/EMDcvM6IAzH7QNLQBSXr1ZdiGcPEnQvxWSMwW+3ROygrqAqyWMKUrL8QnmcsEZdxxi9CO+x2vYCcy+teJQbyemd4R8Kd2LgiwROiBhVaKvEQxFv+BZp45dM3vVQCduKS23qFVjer4s1vvquWzLhK8pdtakU5Nzcmmwd4XPUeqctQQxYVXtz5aihmdGe9XfCw6QW++w48ADmb9RGHLoaZiCw6/6ZV2nSMxsSkNXskBTiIweXEICRbb255aUMgw==
Received: from BN0PR04CA0192.namprd04.prod.outlook.com (2603:10b6:408:e9::17)
 by CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Tue, 17 Dec
 2024 16:13:06 +0000
Received: from BN1PEPF00004680.namprd03.prod.outlook.com
 (2603:10b6:408:e9:cafe::3a) by BN0PR04CA0192.outlook.office365.com
 (2603:10b6:408:e9::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.21 via Frontend Transport; Tue,
 17 Dec 2024 16:13:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00004680.mail.protection.outlook.com (10.167.243.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Tue, 17 Dec 2024 16:13:05 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:12:48 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:12:48 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 17 Dec 2024 08:12:45 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <akhilrajeev@nvidia.com>
Subject: [PATCH 1/7] crypto: tegra: Use separate buffer for setkey
Date: Tue, 17 Dec 2024 21:42:01 +0530
Message-ID: <20241217161207.72921-2-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004680:EE_|CY8PR12MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 047861ed-93eb-49d9-a990-08dd1eb5b05d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uDwxg6KwON6OuZ6WHlOSPmXlm0saO6THHK1iil9PdiDEYqeWfiOopbLs/Vli?=
 =?us-ascii?Q?18P2vWjC+M54QWEL22zeev1V/mQudMb/8AMTPcJFoPrS3TFPLJBhllsXUr6A?=
 =?us-ascii?Q?+ZwiH0RhyiF2DHyyJhK2v0gaSOuy5uDoCXP6XB/wjSdH91GFuxTeLSmAVRYr?=
 =?us-ascii?Q?9VYDpdqC7SX37hIedMRURBlD/IL+gjgvcsI5lxRk1k4dCY4Z6jT9dLvCLxMm?=
 =?us-ascii?Q?GGH5xCJwObsLpoS0QaVCj+iidBdjhtGUJprOTaQKOLNVGGfsHNtt3UIouYmS?=
 =?us-ascii?Q?NgUh+aXaNOsLMLtBtTNMwJhDTGT4aWy4GY9A0CdHmCIEbzUHNO+WE5D6h0ld?=
 =?us-ascii?Q?xWEakO5gXMGO5fCfuou/6VroERseH2C6yf1DZcOIkCcfSQzT4+Ey0sI6gvrZ?=
 =?us-ascii?Q?MY1lPM1A9Vi5vSQlCTiUdAKxPYAuQXBbXYa8n/GFLqTxCTY41+DOkI+Sj1Yc?=
 =?us-ascii?Q?03vZRketDbNnbFA1sNS/STV1KU568GFhqCG+Lun/mULrkKVLWEE4PUNSThgF?=
 =?us-ascii?Q?lSoW47K0SJA+p57RCr89DH/oV66IPdsmi3yAuqPNm/19YJUG2UegzBWNoK4X?=
 =?us-ascii?Q?NNboyVjNZ1W5lIJhry8nZnYjl9MbGmyynzY3+btWsUwdJDdh4f2hSGw7XDBE?=
 =?us-ascii?Q?KHmaZTLPKFjlK1GeyQbrzV7nDTrDtI7mC+8NZdT40gEVn08hhX2ErafSatiD?=
 =?us-ascii?Q?+06wnuhENkCKXZObQM5H1E8VonuaOsHzU9KBO3vIob2MV0NEeLcgsdO0X6qZ?=
 =?us-ascii?Q?uMFLGkVcuwr0nZsH0RkmLVPZFqgIAGejK8mqPtzOdDa/tBGJaLu+cqia2JyX?=
 =?us-ascii?Q?RiOy8Lb+MA7ssK+ku5RRUcEZCwECdczVAZbnZP9SAdikGaA655uT1EfFVjcx?=
 =?us-ascii?Q?cV7+zKAxQILbhCuEdRs1aNb4K2934LAGeSGFuFzGR/tPVjleGMhearwmXyCl?=
 =?us-ascii?Q?4NrhHRuhEFlyOJw4zIailufAG/UejFdcHUHhJUoXTX2fwv7pI3gX1MXNDhXL?=
 =?us-ascii?Q?O9aJICRWnrvQSaMpAVor06MjlN2dIr3JBOG7NmWt+zBPRqBdiN2JygoxFiET?=
 =?us-ascii?Q?O0AFlT5WTIGzg22esE8bEW5Q8G9asui2Zj4TGCfRMMHTED1AHC5U6VPb5FBx?=
 =?us-ascii?Q?/Rca3NIAjSFtFfPditJTWXvCoQjLJf6yVInm0o8AacqcSizlbjj8is8X9JjI?=
 =?us-ascii?Q?X9DapnkoBQ7MWw9WxbR6LlpngBLeGDZUP4KsE/+SojtVGPKtCRoSxQvQMQ1i?=
 =?us-ascii?Q?fuv/ENwJmWb3+zy3D5txTIujh6Gmx0EVW3loGFriJHZm2aXy6bUcNwH26yeF?=
 =?us-ascii?Q?hHUCNbx6XpUJwv88v/aQYinwGKOvYzmYcM2nXRjlKIAfF6Dnnipo7yJH9pvI?=
 =?us-ascii?Q?l3tHU+Ar4JmRf6Vf15e2XBJJ2DjUrc/TNSjETY1FclKUMfDgi9/BeeMrdorr?=
 =?us-ascii?Q?PSnuIcu0V6Yw/eUnRdoQHi7fWShE2/1EXJkGdysOcVEjfS6O1MV5+tlBvTEC?=
 =?us-ascii?Q?0ShaOBF0HiPn4Ew=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 16:13:05.1133
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 047861ed-93eb-49d9-a990-08dd1eb5b05d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004680.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8215

The buffer which sends the commands to host1x was shared for all tasks
in the engine. This causes a problem with the setkey() function as it
gets called asynchronous to the crypto engine queue. Modifying the same
cmdbuf in setkey() will corrupt the ongoing host1x task and in turn
break the encryption/decryption operation. Hence use a separate cmdbuf
for setkey().

Fixes:  0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 16 ++++++++--------
 drivers/crypto/tegra/tegra-se-hash.c | 13 +++++++------
 drivers/crypto/tegra/tegra-se-key.c  | 10 ++++++++--
 drivers/crypto/tegra/tegra-se-main.c | 16 ++++++++++++----
 drivers/crypto/tegra/tegra-se.h      |  3 ++-
 5 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 9d130592cc0a..5fc7e19b8ab8 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -282,7 +282,7 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 
 	/* Prepare the command and submit for execution */
 	cmdlen = tegra_aes_prep_cmd(ctx, rctx);
-	ret = tegra_se_host1x_submit(se, cmdlen);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 
 	/* Copy the result */
 	tegra_aes_update_iv(req, ctx);
@@ -719,7 +719,7 @@ static int tegra_gcm_do_gmac(struct tegra_aead_ctx *ctx, struct tegra_aead_reqct
 
 	cmdlen = tegra_gmac_prep_cmd(ctx, rctx);
 
-	return tegra_se_host1x_submit(se, cmdlen);
+	return tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 }
 
 static int tegra_gcm_do_crypt(struct tegra_aead_ctx *ctx, struct tegra_aead_reqctx *rctx)
@@ -736,7 +736,7 @@ static int tegra_gcm_do_crypt(struct tegra_aead_ctx *ctx, struct tegra_aead_reqc
 
 	/* Prepare command and submit */
 	cmdlen = tegra_gcm_crypt_prep_cmd(ctx, rctx);
-	ret = tegra_se_host1x_submit(se, cmdlen);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 	if (ret)
 		return ret;
 
@@ -759,7 +759,7 @@ static int tegra_gcm_do_final(struct tegra_aead_ctx *ctx, struct tegra_aead_reqc
 
 	/* Prepare command and submit */
 	cmdlen = tegra_gcm_prep_final_cmd(se, cpuvaddr, rctx);
-	ret = tegra_se_host1x_submit(se, cmdlen);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 	if (ret)
 		return ret;
 
@@ -891,7 +891,7 @@ static int tegra_ccm_do_cbcmac(struct tegra_aead_ctx *ctx, struct tegra_aead_req
 	/* Prepare command and submit */
 	cmdlen = tegra_cbcmac_prep_cmd(ctx, rctx);
 
-	return tegra_se_host1x_submit(se, cmdlen);
+	return tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 }
 
 static int tegra_ccm_set_msg_len(u8 *block, unsigned int msglen, int csize)
@@ -1098,7 +1098,7 @@ static int tegra_ccm_do_ctr(struct tegra_aead_ctx *ctx, struct tegra_aead_reqctx
 
 	/* Prepare command and submit */
 	cmdlen = tegra_ctr_prep_cmd(ctx, rctx);
-	ret = tegra_se_host1x_submit(se, cmdlen);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 	if (ret)
 		return ret;
 
@@ -1519,8 +1519,8 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 		tegra_cmac_paste_result(ctx->se, rctx);
 
 	cmdlen = tegra_cmac_prep_cmd(ctx, rctx);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 
-	ret = tegra_se_host1x_submit(se, cmdlen);
 	/*
 	 * If this is not the final update, copy the intermediate results
 	 * from the registers so that it can be used in the next 'update'
@@ -1553,7 +1553,7 @@ static int tegra_cmac_do_final(struct ahash_request *req)
 
 	/* Prepare command and submit */
 	cmdlen = tegra_cmac_prep_cmd(ctx, rctx);
-	ret = tegra_se_host1x_submit(se, cmdlen);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 	if (ret)
 		goto out;
 
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 4d4bd727f498..a0460e624523 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -300,8 +300,9 @@ static int tegra_sha_do_update(struct ahash_request *req)
 {
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct tegra_se *se = ctx->se;
 	unsigned int nblks, nresidue, size, ret;
-	u32 *cpuvaddr = ctx->se->cmdbuf->addr;
+	u32 *cpuvaddr = se->cmdbuf->addr;
 
 	nresidue = (req->nbytes + rctx->residue.size) % rctx->blk_size;
 	nblks = (req->nbytes + rctx->residue.size) / rctx->blk_size;
@@ -353,11 +354,11 @@ static int tegra_sha_do_update(struct ahash_request *req)
 	 * This is to support the import/export functionality.
 	 */
 	if (!(rctx->task & SHA_FIRST))
-		tegra_sha_paste_hash_result(ctx->se, rctx);
+		tegra_sha_paste_hash_result(se, rctx);
 
-	size = tegra_sha_prep_cmd(ctx->se, cpuvaddr, rctx);
+	size = tegra_sha_prep_cmd(se, cpuvaddr, rctx);
 
-	ret = tegra_se_host1x_submit(ctx->se, size);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, size);
 
 	/*
 	 * If this is not the final update, copy the intermediate results
@@ -365,7 +366,7 @@ static int tegra_sha_do_update(struct ahash_request *req)
 	 * call. This is to support the import/export functionality.
 	 */
 	if (!(rctx->task & SHA_FINAL))
-		tegra_sha_copy_hash_result(ctx->se, rctx);
+		tegra_sha_copy_hash_result(se, rctx);
 
 	return ret;
 }
@@ -388,7 +389,7 @@ static int tegra_sha_do_final(struct ahash_request *req)
 
 	size = tegra_sha_prep_cmd(se, cpuvaddr, rctx);
 
-	ret = tegra_se_host1x_submit(se, size);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, size);
 	if (ret)
 		goto out;
 
diff --git a/drivers/crypto/tegra/tegra-se-key.c b/drivers/crypto/tegra/tegra-se-key.c
index ac14678dbd30..276b261fb6df 100644
--- a/drivers/crypto/tegra/tegra-se-key.c
+++ b/drivers/crypto/tegra/tegra-se-key.c
@@ -115,11 +115,17 @@ static int tegra_key_insert(struct tegra_se *se, const u8 *key,
 			    u32 keylen, u16 slot, u32 alg)
 {
 	const u32 *keyval = (u32 *)key;
-	u32 *addr = se->cmdbuf->addr, size;
+	u32 *addr = se->keybuf->addr, size;
+	int ret;
+
+	mutex_lock(&kslt_lock);
 
 	size = tegra_key_prep_ins_cmd(se, addr, keyval, keylen, slot, alg);
+	ret = tegra_se_host1x_submit(se, se->keybuf, size);
 
-	return tegra_se_host1x_submit(se, size);
+	mutex_unlock(&kslt_lock);
+
+	return ret;
 }
 
 void tegra_key_invalidate(struct tegra_se *se, u32 keyid, u32 alg)
diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index 918c0b10614d..1c94f1de0546 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -141,7 +141,7 @@ static struct tegra_se_cmdbuf *tegra_se_host1x_bo_alloc(struct tegra_se *se, ssi
 	return cmdbuf;
 }
 
-int tegra_se_host1x_submit(struct tegra_se *se, u32 size)
+int tegra_se_host1x_submit(struct tegra_se *se, struct tegra_se_cmdbuf *cmdbuf, u32 size)
 {
 	struct host1x_job *job;
 	int ret;
@@ -160,9 +160,9 @@ int tegra_se_host1x_submit(struct tegra_se *se, u32 size)
 	job->engine_fallback_streamid = se->stream_id;
 	job->engine_streamid_offset = SE_STREAM_ID;
 
-	se->cmdbuf->words = size;
+	cmdbuf->words = size;
 
-	host1x_job_add_gather(job, &se->cmdbuf->bo, size, 0);
+	host1x_job_add_gather(job, &cmdbuf->bo, size, 0);
 
 	ret = host1x_job_pin(job, se->dev);
 	if (ret) {
@@ -220,14 +220,22 @@ static int tegra_se_client_init(struct host1x_client *client)
 		goto syncpt_put;
 	}
 
+	se->keybuf = tegra_se_host1x_bo_alloc(se, SZ_4K);
+	if (!se->keybuf) {
+		ret = -ENOMEM;
+		goto cmdbuf_put;
+	}
+
 	ret = se->hw->init_alg(se);
 	if (ret) {
 		dev_err(se->dev, "failed to register algorithms\n");
-		goto cmdbuf_put;
+		goto keybuf_put;
 	}
 
 	return 0;
 
+keybuf_put:
+	tegra_se_cmdbuf_put(&se->keybuf->bo);
 cmdbuf_put:
 	tegra_se_cmdbuf_put(&se->cmdbuf->bo);
 syncpt_put:
diff --git a/drivers/crypto/tegra/tegra-se.h b/drivers/crypto/tegra/tegra-se.h
index b9dd7ceb8783..b54aefe717a1 100644
--- a/drivers/crypto/tegra/tegra-se.h
+++ b/drivers/crypto/tegra/tegra-se.h
@@ -420,6 +420,7 @@ struct tegra_se {
 	struct host1x_client client;
 	struct host1x_channel *channel;
 	struct tegra_se_cmdbuf *cmdbuf;
+	struct tegra_se_cmdbuf *keybuf;
 	struct crypto_engine *engine;
 	struct host1x_syncpt *syncpt;
 	struct device *dev;
@@ -502,7 +503,7 @@ void tegra_deinit_hash(struct tegra_se *se);
 int tegra_key_submit(struct tegra_se *se, const u8 *key,
 		     u32 keylen, u32 alg, u32 *keyid);
 void tegra_key_invalidate(struct tegra_se *se, u32 keyid, u32 alg);
-int tegra_se_host1x_submit(struct tegra_se *se, u32 size);
+int tegra_se_host1x_submit(struct tegra_se *se, struct tegra_se_cmdbuf *cmdbuf, u32 size);
 
 /* HOST1x OPCODES */
 static inline u32 host1x_opcode_setpayload(unsigned int payload)
-- 
2.43.2


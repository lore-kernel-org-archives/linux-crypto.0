Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905201FDA9C;
	Tue, 11 Feb 2025 17:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294333; cv=fail; b=JaLAFZjcJ9DV5XlhAhBtrP1z3wTn4QHv/2NZzc7DZKZOPkWtaTWMZrL8v5FolG7OkVztuWVVkRYmOLchpbwbMugw1JwIo0wgs5omKfOcucqK0WDwNRi5HKbRJk3LZAbIcZe4hjU+sCOtrhPacxpEicRpmIY/dqgcr/0pEX5kHGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294333; c=relaxed/simple;
	bh=EghS1WrlwWZJJ/9uUfDljH4LueQ00VL5uBOQTSPvioc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aN/6QCtuEwyFrwgE27ifLxiqYvt+jd22G0qzLSJ7QnlOcfCASdbFB/dZk++9VCtuewPbTvLqYVi+8yLcJXgojlaVU6I3FLmQsNEvqggQfSBVju2mHh0uYUEXwLOdN2C12LY2XPum4i0ol4VEoSRcEIDTdlRepEyHIQFeAnkGlkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VxQ9SpDZ; arc=fail smtp.client-ip=40.107.244.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VxQ9SpDZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sXjXXitOAiTZFKiUP9FvIeAB3X8x42iNkWQSGZN5Opnlp/JJIjgDMSL68w5eO3pimsVeP2tRkgz02S3/4LOKNMXDr5vVzei5ERLbmunAQP/YeZYPYVFTHZknYhNlskRfrf3KD+lsC1EB+FcLHhPvKIX0ZiLHCL4r1ukdsklCLbvEG5Fb/FeJSme5PjnhIyz902wxO7nVHoo4GPbWumvUDfkA54Zgy+x6I6UJZUJ0eO28lXhruEkTJ3Xo7Y4iK9kjyeB4EaYoiWHoUN88zGuxHqcJVEkIPMgg+6K8fMhS/Wq+s2grsLRIW5bye6RzovH0qhMFyRBy8Zr5OP2WYz/row==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1QNPFNalffrpy7n/7n2LHku3aH7z5nJyZB1jgrOEqU=;
 b=Tl9ClJwVxI2WjvxScKLVs0mWtxFkIfCLVUWR1Rn6SggqXcr3wRa3wttywAxJGP5aRN4r95+31damtnKNMm86TWV625vhc9RewAEyca5NiLZurvzKcnROkEL3lyMb+eFqmUW5lmnMIqSPampcYaj0JWiPoM263bVj88YQepW2A6iPTsugsob9hfhcCdQ0bn+KF06KkCGPVLchD9Nhnt1v3xwbXQtPEQKLUYMhmmSJGLU3w+j03ha8yDQ1Xbepzo/0gxYVZ7cL/bc3K9FcyvG1apzF+RYJPWulLwUGL7PzcrcUA+JbhXFTUsoM7LBiNmELZhyCvSJybu4BOPdOlr+FGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1QNPFNalffrpy7n/7n2LHku3aH7z5nJyZB1jgrOEqU=;
 b=VxQ9SpDZgoD9LIbh6dpsDXD+RYBOe71OmYHfy9EQY09l+zLRjFRB8/X35r9NOdecNhF+8aw+WJGXsV9eo7BdEmQCc0Hya9pV9m9ymqvA5MIoKACNylHvcKn+v7PA4uaoRh3eYBdE6kWTEsZLpo4Vm7DQvORY6+q5BtO6CtcUWnwlySOr+dzYu5Vb6cbsCiLOXB6Q8EzzTFwvHLZeNAWYBNeueTJ0Us+jzJq52ech6zxWb1b/sg0d3S//DsmxyPZ+3+B24pl3NpL/BdFBoordhVc00koRUsXfedNEHpSFsML0czAKYd1cdgz73bFDdVJeUvsUqWnjI8EVQRP6v2SuaQ==
Received: from BYAPR08CA0063.namprd08.prod.outlook.com (2603:10b6:a03:117::40)
 by SN7PR12MB7811.namprd12.prod.outlook.com (2603:10b6:806:34f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Tue, 11 Feb
 2025 17:18:45 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:a03:117:cafe::ac) by BYAPR08CA0063.outlook.office365.com
 (2603:10b6:a03:117::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Tue,
 11 Feb 2025 17:18:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 17:18:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Feb
 2025 09:18:26 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Feb
 2025 09:18:26 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Feb 2025 09:18:23 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v2 01/10] crypto: tegra: Use separate buffer for setkey
Date: Tue, 11 Feb 2025 22:47:04 +0530
Message-ID: <20250211171713.65770-2-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|SN7PR12MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: 269d3623-f37d-4371-d246-08dd4ac02318
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DUi56MiROtyG7MIKJID/2pXlZYzJtQ8NBdzGbPg/g2tBqGvUhWiXfvodKR6L?=
 =?us-ascii?Q?4sGyRIzCe55VO031uj2RlEwHl6rZ4Jqq4cFnnzwMkyJiTv6D2m8SS49YwUys?=
 =?us-ascii?Q?HXMPOUYkl5FYSykJSUgtGCLEgCQGnV0sTEeIEoXV49RuKKtgN1z0Anlz98Uv?=
 =?us-ascii?Q?bytA/iNFtKNDdqKMhjgkgxwIyZtOxyagye8xwIN53gCGtzdXB7cnetAHQeOR?=
 =?us-ascii?Q?UfxxmRL7x0n9RlxiXcVDyawS81DzMm+FdroBbfNNGOWMy3coN2gSNkHmozP8?=
 =?us-ascii?Q?IrRFervJqoDUP6tx/gys9HKJ6YOPCOdr+T5BIo9l3vTsSWyg/Bb788p+kRG2?=
 =?us-ascii?Q?IZ56GW7HdLzedm/+tlv4Nrytlsfoz6i2iPICaZhGmlJlOhs26Ok+s10SnXkE?=
 =?us-ascii?Q?b0lZOjYK6IHjRDcZQkgvxu+hvCFDRMHV1JtGm/oE+9ADY9I1R2dH3HZPIlv3?=
 =?us-ascii?Q?487X2dCtx6SSAfFKZh2U+dDW0db3QgXPMn0uZS4alhgTKU8lSrPQ3Veps2yz?=
 =?us-ascii?Q?BumFEwa18g5c5B8ssJ19vrXiea2D3Rv7ej0ZT60SVtbM5GtsqSaCzbpdbae6?=
 =?us-ascii?Q?Bi+7cDQD7CiFTDl90VjiAxBN6AgE9vaH7dCpr1COOB23lVghyktaYjz1E9hk?=
 =?us-ascii?Q?TqfUi4ChlsUiWOCkcMKUu3gY7MB5IUiqM9DFK4E5/P6TFZkB6S2sMdp6KmRQ?=
 =?us-ascii?Q?LIsvENsmNr1ZeBAIPe/W494tZwZx9G579cSDaaTFveCA+BAKaWimtIN4RYlC?=
 =?us-ascii?Q?V2iQG8o+K9p2TfhmHrJCEQD5Wgjw83z49erdsmMdumhDjxH8F6zBaAa5JmZz?=
 =?us-ascii?Q?SDVPH8gb43Yi8SjOxS9BjIKwAUMNj/3Sre12OSx/ochmUPIXXCIs23+FAbxu?=
 =?us-ascii?Q?zgXiLvhNbwjUTSSowGmeYaQjbnv/Q1XetRb1pQ71ZP3gbo4E8oRZt2O3nvVs?=
 =?us-ascii?Q?h6b+hF6CksOz4u4oGB6P1tt5MfX1dK9QZOOfWkfU6ts9pK/NKvfSDqfuM5vQ?=
 =?us-ascii?Q?kQ1Z1MnS7yOVs6v7fbdiAB8ZKOJ6gfRmUNo8zoyx7Dh7hgscrqC41r0gQmWT?=
 =?us-ascii?Q?97Hnm1rm9EO6OEADtHuUUIw+VVPS0HYYckiXIAB6YwG6qoIca3O+yR52oN+Z?=
 =?us-ascii?Q?XzYDrevAQAajeVlOTWpkO2MXKkDcmgrn3pUA9c60G6oiaY+O3MQtoW+GM8zH?=
 =?us-ascii?Q?jE5YLRiSbvYqj+O4XPBetN2WECtTtEjm9XZxT9856bhpHKGcGi9vfuBATnRc?=
 =?us-ascii?Q?NaOGKZJa0dYoJPAn7kvrSQWYsVA3ofA0Mqyvm7H9pCMm3XslbXb03t34b1jS?=
 =?us-ascii?Q?rtEgFlFvpJT7NssL+TFWmfS/GyzdplVoqO9FiAnUh1pxWQKcPHZFdms9ajIO?=
 =?us-ascii?Q?4ZsC6gtLYhwulk3Q5+sxIaPeENJ5kKs3JpDmyAZV2XgUII6Hdrdc2lcWsHLU?=
 =?us-ascii?Q?vvpcZKPmFO6l18qBzu6Ck+32fzGx9MjrpyOZQZmaW4IILAzlQj9j1Kj5e1v6?=
 =?us-ascii?Q?shRX2uzwaHGkdaI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 17:18:43.8546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 269d3623-f37d-4371-d246-08dd4ac02318
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7811

The buffer which sends the commands to host1x was shared for all tasks
in the engine. This causes a problem with the setkey() function as it
gets called asynchronous to the crypto engine queue. Modifying the same
cmdbuf in setkey() will corrupt the ongoing host1x task and in turn
break the encryption/decryption operation. Hence use a separate cmdbuf
for setkey().

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 16 ++++++++--------
 drivers/crypto/tegra/tegra-se-hash.c | 13 +++++++------
 drivers/crypto/tegra/tegra-se-key.c  | 10 ++++++++--
 drivers/crypto/tegra/tegra-se-main.c | 16 ++++++++++++----
 drivers/crypto/tegra/tegra-se.h      |  3 ++-
 5 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index d734c9a56786..7da7e169a314 100644
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
index 0b5cdd5676b1..c7b2a062a03c 100644
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


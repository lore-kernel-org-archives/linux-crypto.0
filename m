Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93D7254B1D;
	Mon, 24 Feb 2025 09:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388616; cv=fail; b=B8xd2ujp4XSePbahW+I5zmoNrn/g/hwc2P58U7c6nqYK7vZuPNu1IPzYrFegrBfDWsMueWfDX5maG0QA5y34dnb3IhV2fOV9deWvbkYs++HWFqGa2I1OdA+qJaVLZ8XTPF0NcMMsBeH4T2e8Ybg455Z57aZNVLfz4hJkRfCpglc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388616; c=relaxed/simple;
	bh=EghS1WrlwWZJJ/9uUfDljH4LueQ00VL5uBOQTSPvioc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Idj9LKufiVu5V/0ekwHOXUeqEYXA3FHtFdsbNYTkUfzrtTGOcFhlV5yTkuA2JPxiUFolw7X4B9xfb4VuRaNn3QSaR5PItA73M9m8zW1Iuhm2WMGWCcNWSvG7meyQWKQKetgj1+I+7Jy79Qa9BZdFwwm1Xwal+6yXEMLc7wGFkYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cUF+lEyV; arc=fail smtp.client-ip=40.107.220.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cUF+lEyV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gVK2gk+c4qVER6EJVeuAvtH08ZQXD0t864Wkj7OGiupZRD2EkxDpkTRKKuRTc+wFnI3t+/jDxcOuza8F0h/aVlJdGehvkkiyrhgcl1YD99g1IjhgLFjve6xGdFii/pFgrXrSEDj13EjgHhJOW1fW/LbKp8oDJsKz9Hyk/0xyd8LFEOwcaOKG/80eYntRRn/ojafTGSfXquQMsXZaY/EMQc8AD1TBtNpdqEjvi611tDjpizSYakV72NZ2NSZGDLgJzdCcZVUiNGnJXxkifmtIrCbz+cGi1ljafVfUXdMD6/NKISa9IDlgqb1K+2akGYV9kY+yvICAZC/gOdwCrBRljw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1QNPFNalffrpy7n/7n2LHku3aH7z5nJyZB1jgrOEqU=;
 b=GXTrlf5nT0wSU1iw0/iRDlENP/hthGEf+bwpSiYTx8zVDBFcnC137sKeUL2CWy9jdpLzQrRz8nxpjJWXdkstslbqza+WmHP2nmp+DMbsoqnQvFRPtaS09V9ISEyLba6WitNS1nDhrZD1hFz6Y2/OhYs07z5tZ4NhiaYc+czXcdZUKgip8Jk1wwajgcfCvVhKlzBdxrq7k1sHB6REvJ3XpUvu3PJtmb2SUVxI5tIO2EgCwmd2HUUYdVlUOUzi6F5lokA5S1Faxb7crSEMVhhaSq3saQQ4vw7yBk+vQs79+DolI2bMS9njv6V4gclIjfwcODwErXByrZV2sLnRfPj6Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1QNPFNalffrpy7n/7n2LHku3aH7z5nJyZB1jgrOEqU=;
 b=cUF+lEyVpnLJv4P9ui+Mj0nWj+D0C90/FtzXKjrkFEEa6BFSRWzgItVJ+NMDjfGBJ53/sO/8t7OUeKuUrF/jRY83Ck8hxkjMAsZDmGc6dIawNNjCrZKQj4JgzwjzwYi8qVdOC4Z9XqgcLgvjM13c788ysds0jc9YpdR2a0v04QmdD1NpCbsLMuRl1pjxjqWKo2ZfVLvgTDgPn75LrKMP57kXdt/yasJKZdB+wKMrb/LQmdzun+q10WFv77uxLcGsF90bavL8aIY6XOT7/MzGuFEWsvsiu306oOgM30TINSC9RX7CdHRYku2aviU8ROK2LxUZOKP1ZWbvQMyf/MLf6g==
Received: from MN0P222CA0004.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:531::11)
 by SA1PR12MB6824.namprd12.prod.outlook.com (2603:10b6:806:25f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 09:16:50 +0000
Received: from BL02EPF00029929.namprd02.prod.outlook.com
 (2603:10b6:208:531:cafe::21) by MN0P222CA0004.outlook.office365.com
 (2603:10b6:208:531::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Mon,
 24 Feb 2025 09:16:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00029929.mail.protection.outlook.com (10.167.249.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Mon, 24 Feb 2025 09:16:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 01:16:34 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 01:16:33 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 01:16:31 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v3 01/10] crypto: tegra: Use separate buffer for setkey
Date: Mon, 24 Feb 2025 14:46:01 +0530
Message-ID: <20250224091610.49683-2-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250224091610.49683-1-akhilrajeev@nvidia.com>
References: <20250224091610.49683-1-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029929:EE_|SA1PR12MB6824:EE_
X-MS-Office365-Filtering-Correlation-Id: 8727a398-417c-4dac-4586-08dd54b3f7cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0p+IzJo7+YMcaBtfkgKOpYnYSuojoWmDRStafZvjJXyjVURaZ6kSpTGH0axY?=
 =?us-ascii?Q?3qzdh+DKkWeOOlkBZwp8us+CyHpPH+3bsNG6V31PE2DrPyVbmSoClU0X372y?=
 =?us-ascii?Q?sQS/Vy4F/gVsQHxPtB+jg8yPpxJTwsbNhA+YwVpXpPq/XtTny9TyTvQxvnB8?=
 =?us-ascii?Q?azTKjhkTNGkx4ahBIzQnm7NueLXW0jz6fmunrrDxUyhDcJy74pYa/XZzeCJ+?=
 =?us-ascii?Q?siaKx2NmXoodHzc9hh2wl85SDNSuMu+0YEcndeyBNEMWhVl6rAKNhKZOMIkl?=
 =?us-ascii?Q?igcsPixbkR5nKIdJS2IgXSUPQTIKr+XL3v8nEA8VZOlbu0a+BQZIjOW35AMT?=
 =?us-ascii?Q?hiIiD0G1pnktcUnpePatOlASuMpEapjy8Tms4biaJLKYoLqSGRHIG/HfeW3L?=
 =?us-ascii?Q?iYcR7A3ObWHwYWNOsojZ0wT7fX3NZcLPztKPzC6C4VUpYgOPFI+XFn9VACs8?=
 =?us-ascii?Q?RZTwZ7WBtWKMqDFGAO4500ZaZj/mBT7aM1MZP/3u5aAG2NI/IS7/2KqEDf2b?=
 =?us-ascii?Q?/yj3J3VaXw35wmk3mK8zzSxh3kVrgCBvF/3T5TFDtBxmNPvOuXVqX59JrqC3?=
 =?us-ascii?Q?qWIg3vzetIvgqPEr2ZOIkZQvxvZ4u1Unm+vtlXTzF6so+1B7yeN2YH8zpUKG?=
 =?us-ascii?Q?8HxBn8lTPq5jXxVtDiULY0VnQvSKhoFioUf7HFuoQKeZ0ME+1XKqYXGpKvnN?=
 =?us-ascii?Q?6m8M1SFs6j2ws3VyqHc1XCOG29+O0iw7JIEEhnzwCtj5Wj49edKqeSjI9Tpi?=
 =?us-ascii?Q?K+cG+OBuaoja9PmpHRLe1sF4amy7NIBOiTCqgfIvmtmR/0iy08u8fSZI+dIE?=
 =?us-ascii?Q?kouYa9UHPiPrvrXyntTKtn9chWame/FIHzHH49mej1KcNdoG1v7BN+2pif18?=
 =?us-ascii?Q?jV5JNya260HtkRxkDrHk+7js04ITfDUNWQrqEk1akpJM3jHqvfaGL+FuAWgw?=
 =?us-ascii?Q?eJPWq7WVrRfBlY62uvaXNv/hVVRManc7NvVG65wHEZIYbfjhiG0rQAYZu4yd?=
 =?us-ascii?Q?gtI2PGrjXsCJSouaH5ly8K8IwLvHTiL2xwEw7IOawaxoZ3bp6rWy+R7GA4wq?=
 =?us-ascii?Q?kGTdSl36IFZy5DQTvSDxyJfd1/WEpQ4aTj8tiXGnJ9amFxHDbbNhLx+ACYW/?=
 =?us-ascii?Q?K2DmU3JplbdzPZL7kWgCElxyB9uuiU/GO3mrAHdLIdVB+4zJn8Ru384E5pwa?=
 =?us-ascii?Q?4DvG6ydJUeHCPSqsjoaQHMbusANavdqOp72Tmg7kapxuNAfzN8aYUq3kySAr?=
 =?us-ascii?Q?fnK5T3gBqRjw/Z3+KB2mrLvx71cIXotBQbDe9gVFxK303Hm/xKdbdEkP7n0j?=
 =?us-ascii?Q?TTXjvc9A7qZwwa+3oIbKt7ExniJkQ+B7vqNhfN/86aR0U6Xa09oDqqdnNlI7?=
 =?us-ascii?Q?pkCAcwUpMsVel/RXQwi/VtcE+fkrgj9XJnFtFxvHBQ7XWynmYC2O0hsnEgaZ?=
 =?us-ascii?Q?m5nFsnbVUvs7GD1p/bMgYoxPMZMB0xdjNaHlvhLCmvNlK/4nWsGbLEDFrlKd?=
 =?us-ascii?Q?UEtY1/sN7IToMQg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 09:16:48.7907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8727a398-417c-4dac-4586-08dd54b3f7cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029929.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6824

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


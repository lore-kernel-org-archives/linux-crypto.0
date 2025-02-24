Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B2724BBE1;
	Mon, 24 Feb 2025 09:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388717; cv=fail; b=WcSmxxasOvuC89/HgUgMQqHgFFIlckhdgHmBc54oS0vsF08bFfU7iWMuw89NQkFefYoE4/L6ZHPa/wTUvAkAla92iiX1w+3duqyEai6wt72iJBDdEDjLSZAY3XFFQ6BfkETnPjYTkKKsMYGvHSFSPh4Zk67d5z/bCBvhHhQ2SSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388717; c=relaxed/simple;
	bh=Mftcss/FqQfGLKtcGgo5SXM8LBB7b5i7tW0tnL1/ldw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HvsFNPoM4hl1BZ51aWJ9HNSYlQ5ww1EanraohU4Fvvs4dyD087xujOppix+JIaj4clYsaWnID+lXr8ik4R4HoVKVSlvxCH1tRZ6TQzUd+PmBQQuGW7xy+vee+6WHlXlfIXrc1d122Iq/pn1rtidDp/hOOh0xrA24S4txmjxiJ0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mZgcAJj5; arc=fail smtp.client-ip=40.107.237.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mZgcAJj5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gxeb5ZtBSaW3AU+aqK1oeRVOf5bKQ4QsumZ3wQYoygmjTytJ4RaqXm60b1Qk2M8oFDSykHHWYDbXfXs9uNIemZe03AFolJdxnADtCcA6YCOZB07/5CZtSE5H6vViPdn9u2zXBnU7FuXCNgxwa55TUxx6/PgGkiXthyTvnc7xCJdi1FBpiIxt6nUE477c6vacWpItr8JHft3FthwGLcL7Xk9rMzjNHCrQKQJ3YmuhHncJUCxVrV+FhBlnfLyUeGQeG/e9FsTRYWO2R8Xf0BKpSsJs3rn+EbiRwu3HzwuCx23pvt+w9WZPY4w/m8qG62GJ7Iwzzz9O7+DewTmDCtQtGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7p5uACi4DAiKAn/tNn/+x8AJQF8Oaps/+l0VkxOINQ=;
 b=irpkccSjPXyZq5rEF5fgO0ydxf91jlSYbEBYe8RY4g9mUpfOkha5EQbVgSvm3h7YGBXpway81LnRZBRbjxOkaL2SVKd2QXkE+t+612SL2IkiOx/nbqAnS9T4HOrtwa++Sg45YwzZzIPfOL1iK3G6VGDkZUn/ug+fiZ3bnLoOcFWQg03WE7jLANlKKuOoG59CXZwxn1Wq5F9hURT5RbhHcajyc1iddYpUbT1A9lRNClMzI2rKv9V6Rsb2oGKXR4uy97h6kZEy8UVIu53XXms4XQs6709A2vX37TvsbhOW3WJ3IS8KaqVlPIY4ayObValwJAs0eaQXeTmqEfhMN0tmwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7p5uACi4DAiKAn/tNn/+x8AJQF8Oaps/+l0VkxOINQ=;
 b=mZgcAJj5BUnqP/9JF8nZBtJXjoBpiKOl06Hh0AsF9zjo/o/c+AoTt9/uod4JRCad7tq7icJW9Y/KGNyG+PDR7g42m7motoaRPcWO9xCRNUnfpA2fZXYFkvhQECrea51fVDLTMwC98zrEC3bnXx3XeRGHP26ijIdXioMGYbCFyD59uxi1fBD+qXZcK/E+ayBvGxgXR8XwFojtHqn/Adq5SsmVvnO7Wi5NCPXLCDZidesDnHQBpZkAftwBIHeY0rFZyP1gQ9l2qh6OVA28WN9x7YBCNItSSMSYTdGR6W2MWMEIsjLftOMvAEtPJDlzMbIlDzk7BXV7NlGZ9URu/Op9IA==
Received: from DM6PR18CA0011.namprd18.prod.outlook.com (2603:10b6:5:15b::24)
 by LV3PR12MB9234.namprd12.prod.outlook.com (2603:10b6:408:1a0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Mon, 24 Feb
 2025 09:18:31 +0000
Received: from CH3PEPF00000016.namprd21.prod.outlook.com
 (2603:10b6:5:15b:cafe::e5) by DM6PR18CA0011.outlook.office365.com
 (2603:10b6:5:15b::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Mon,
 24 Feb 2025 09:18:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000016.mail.protection.outlook.com (10.167.244.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.0 via Frontend Transport; Mon, 24 Feb 2025 09:18:31 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 01:18:22 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 01:18:22 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 01:18:19 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v3 07/10] crypto: tegra: Fix CMAC intermediate result handling
Date: Mon, 24 Feb 2025 14:46:07 +0530
Message-ID: <20250224091610.49683-8-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000016:EE_|LV3PR12MB9234:EE_
X-MS-Office365-Filtering-Correlation-Id: 01948040-24b1-4fec-9eec-08dd54b434df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jjrGvOo8placmXih+vkCLYSivq0aa0gXjjiuk+1Tzb82MqMq845Pv0xIbWFg?=
 =?us-ascii?Q?9ZMR5XDsmB0r6thYTLRc/8im6s/eUGk6ocsyO69GtYcR2rw98KZbTW2atGml?=
 =?us-ascii?Q?Pt6Y0wdEBZdagVBwsP8i7MnIKzsWVRQb1lWVfpPV51X1KNgk06os91p+/No8?=
 =?us-ascii?Q?L3li39ieupjx5TzvFAfCO7PaNMTRM1TyE+wxCDKDW4mscN4tjUKxpbqhWSEZ?=
 =?us-ascii?Q?cJWC1ttG7twzx8WdA/lSt/j6MG8pWpAo2dvi4VRlb/bJWUU7lnKn3Mr0E6Qb?=
 =?us-ascii?Q?TG8nbhsnLemHyBnHopHjioHNOayb+wcJF9j/XoFHSMhEHzeYHm1y649PHkYD?=
 =?us-ascii?Q?aIJrEVV25mCv5GS/ufszz7zuvW0cNLbej05fKy2uT+ujznV6bidvBO/JkWCT?=
 =?us-ascii?Q?VsRZ71y+kUFF0MvcwQTiLzu/ov3seTzfM3155cB3sWm2ivi8dEWW1bVpB2p1?=
 =?us-ascii?Q?oTbu4uLA9NmKT6R6w3Rl86frmwoll3qCsBlJD514YZtD1f87/8+YyrGzysX0?=
 =?us-ascii?Q?UAVv0bvbKgOzVcnUXsxqtC+QkzOU/cUkuSIrXCxp5TbwFSYmsoAwPO0KNDBK?=
 =?us-ascii?Q?4glnYcf4br9fQifeoqlxUjHVIH9q6MLNs8X5PNN6ipT09kyQDJOcvD8Nt/WH?=
 =?us-ascii?Q?3a7Lm8/eOsXFbGwzhv+CSRk2pvCgk7P5j+H3yZypozphchsCpCt1trBJVjLo?=
 =?us-ascii?Q?C4Jci+n5/fm/rp4+P49IAkY7IxqXZZ/ZSSc/c/7i6OTQZIuxIQ8ln5SqOSVQ?=
 =?us-ascii?Q?UboMtftT/z/es3Mw7L1FCSV33xVwB8jd4w6W2hlCxFFlHmlmmu6ItGnCmyWC?=
 =?us-ascii?Q?Bi9SG+7J5vpjuPZlhJDyPw4g49CQ3XTfEmwYDTXLHhMq0YI36EDJM+QlBDwo?=
 =?us-ascii?Q?V6ATtt9NyN5OfESKmWEmHVzEIFb1ur/l8vzH7PQbMDhI1XbqYpZ30/1ulvAF?=
 =?us-ascii?Q?zrkiHnluscvz1QlEv0MVKOe4JKBrAS2QiNJeSZStZc7dRsPu5vFLuJqfD0iA?=
 =?us-ascii?Q?ji6krbutpJaOqtGRBu58EI3mnJqzbOrU/5KaZSvh5Tu/6kk+AQt/ZyXx8yr6?=
 =?us-ascii?Q?6PWlktLXv0mw+YXV7EgOQUS+2hs+ZWZ+bTMggTRJOxl4YWS+mDBQiQCMJnT/?=
 =?us-ascii?Q?rmzIdSPKYIOtPeeAlltpxpZL5yG9WVbX1Z4RnNb3rSoLh9Vh4Cj/AOQGeVZp?=
 =?us-ascii?Q?U8LzfPHbX9gJmPCwm+m24PoexK2xlscjHJmdnDXXJhttpRFM3PG+6GdR5iNn?=
 =?us-ascii?Q?miJ9/vFCDvgyYn1BjnVrlz5SdPhAvzxVhCrQQmha5nt5d+2oOSj0Y9iKIYVT?=
 =?us-ascii?Q?M7BrjaDx+FD28yMbYB5+Ypr9ZYl5j7vLCSY+FpdN4CcEj5K66b4chsEO7Zl+?=
 =?us-ascii?Q?COVHF2ps05Pbpm2GaC5yjKps+ZFSlnrb4fQFiVTWFOScBfFzPcWHxeMyrmEm?=
 =?us-ascii?Q?YX6PNxQQbapiGeevqdXjTr8NWXuJ14gGrTWpsJ4jiklKNERGzoY/WRnOx/uF?=
 =?us-ascii?Q?OkKr9LTxwpimw6w=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 09:18:31.2989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01948040-24b1-4fec-9eec-08dd54b434df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000016.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9234

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
index 13d76de2bc81..c3afa8344e4a 100644
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


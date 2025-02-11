Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC91B262D0F;
	Tue, 11 Feb 2025 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294386; cv=fail; b=ZKuLzoo90rK5ezaOAhBAw0tCM+iRKD+nbIWbSntwLSr8XlbrIv/Ma829NNYY7bz4HLZ2q2LNv9/33ImlM+nGO9ugej/qqhF72SgX+vKrIff1Gr46MvPjmgcfRxx3BFUrAlxTorqKfUX+hhTFlMUXFdWfRiS5fqsUEo0KuMl0DSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294386; c=relaxed/simple;
	bh=QVIU8ZQVwEJ2SYofVJT7+zK6AqJFqDg+Ghiesgd3rR4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=We3c1H3+XfDfWCJm7SVY65Wzk21kduvxZDgZtKFGswj8PKgo02ZM3Ubd1sHSIjzjY6WessNmJ14xQ2gAwCsERZuUCT9QfXswNfvNBnk2T2D88MnrRoW8IwV2SXjfiv3h4kjjjCPWuA5obmSE6eSFx7UlCC6ZOTzgRiyHMyeb/2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QUCkHUZs; arc=fail smtp.client-ip=40.107.243.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QUCkHUZs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PyzuV5EER96TsR2RKA4pzAEXJW/7rSJLyRbDiZMgNRVJnbiU1MvYbhnR4Zc4YFrR8OQo2DvwK6O+ZadJ3FdOydVW24tvS8bbLvLBZ93OwQ0z2Yp6yLB9jrY3vPcLKyO07239WSEazl/8MTXBXJncgy+5GA5bHpAsY9M5A9A7A3Am61lJKaIE1I+jFOND5nwPvuewtuTSl3k/3B0eFCFIl5CC9H4ArZLl/+F1ADMrp9CpxZ5i8iCMdrzSlIK+W06OnPiYhoeR1mzk01R8QLCEZNWXCeCxoHfISP1hOdJVQLNiXt+ZmRkygkSpRhhe6VZmhpuCqXTvwL7PjCoCEhAOgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfPPImK93HA+wWqmE1Ne8rO+ehd7fzo7dbpyKwQmxO8=;
 b=wnx0jGo7fhct7wR4YS88TWv24uvAfsq82kfiVx2/u2rx6EDWkQ+4ejnrNxrJYNzl8vlOZlVQb9AglEalfmnB6b9QkeBIi8fl/+mG5/JnjbLcv9eQP7RCFZdPP+s+O7IH3z03v9NHTe5B8scT1l8d0oY3zm8+89JJgs6wstSBTFCGLm04HTtRKRQlUZUsO/u9TjdU6VLu2fmyfEoTrWUCcfKkIH8FoAMPlyfxJqHZivjSPa26ps1Z6GIpZOnR0YcKYotSB14VFJPhIu3Gsi502yUWH9nHlLp3XUhyBiFfOZQXYLCmnYRYDQisvb2G+1KrxzCcwfCn1NtBsFnMKOgwWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfPPImK93HA+wWqmE1Ne8rO+ehd7fzo7dbpyKwQmxO8=;
 b=QUCkHUZsJcUyod1NosKN90Uo1JZx43xF5gS4gL7sU7T9LE+NPu4Kq4I5jAyPczNpPfAmXaJMSMUmAqEQkNCdv0j442Ub/RrpBuk2yo1cdVvbw9ZaFwPTRW5VQy4gqHZ/MQUTvETUiOE9Xf4b62C1V8EN7MNoOp+7PlX7hWyeH2Qoj6waEupDjgwd8pKd7mT/SFBHNXiVcs10Z6c+NTCgdJeroTJwf3/EKoMtCkT2K6ZVORSrWcGy7EQj7ct89BM2WiNOa1gqC1CUXsriihKBLJaSJwBPxwy0en/qFrctzs2f0RRQ1HggiCfnIEf/rnNJRuQTc3JpVVm0YEE3DPfBaw==
Received: from DS7PR03CA0119.namprd03.prod.outlook.com (2603:10b6:5:3b7::34)
 by DS7PR12MB5984.namprd12.prod.outlook.com (2603:10b6:8:7f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Tue, 11 Feb
 2025 17:19:41 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:5:3b7:cafe::5d) by DS7PR03CA0119.outlook.office365.com
 (2603:10b6:5:3b7::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Tue,
 11 Feb 2025 17:19:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 17:19:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Feb
 2025 09:19:24 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Feb
 2025 09:19:23 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Feb 2025 09:19:21 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v2 03/10] crypto: tegra: finalize crypto req on error
Date: Tue, 11 Feb 2025 22:47:06 +0530
Message-ID: <20250211171713.65770-4-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|DS7PR12MB5984:EE_
X-MS-Office365-Filtering-Correlation-Id: f1ebe516-b3be-4917-72cf-08dd4ac04515
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PCoPhxAtOS/DPCG13WoEB6p1c7Il22W9lYyeqwCjEiOMsW/rdbo5MtW+aWI9?=
 =?us-ascii?Q?yJQoNk9R5646ZDnZ9C1B/BpoJc1KBi/J3MB9dLja7OXI+aBkFuypLJKzSPTe?=
 =?us-ascii?Q?6uQBpZ/ufOSZdOwLVSsIRDi9fsMhjRezllW45ktUxdna8FMQb0bZDMWDjuhW?=
 =?us-ascii?Q?E7zStQ1R33EM4TN6jHEhEWXlogh1Psb04abHpFNx5jRS2YupZuVsHbD0f8Gz?=
 =?us-ascii?Q?KFSZqhZJiAFV33v+CqCx9YViY8Bf5ec/r6LhXzqdJhn8ciaAjt+UnhtOT34g?=
 =?us-ascii?Q?6NxKu7PGwJWVfheD3xj0dMS7MzaLCl0K3I/0NITSlxHbcQf8KmxhOyyxyVkf?=
 =?us-ascii?Q?WwJKe1u02ZlxWbXX1J7Z2BUCLPJSjrJzTxdCCoIdHlkIEyGfmyK3T+z/KgXN?=
 =?us-ascii?Q?ZGijsOw2wNOrs6g6pf4LE+JlAeks9LVDWQ+zGPVhxOgdXG7e1OjsIA3v+01a?=
 =?us-ascii?Q?VXXtH59pybLNk8FG3xM2mOhGLALl2BI2EmtK9m92eMKvgwAS0zunDWHY6P3K?=
 =?us-ascii?Q?rnTtMh8nezWURfs+4chemjVEbSASdml2dhR16Y4Grz0ihSxn/GjFSGMbWPCR?=
 =?us-ascii?Q?J0uD/fWkriKCvaZyaFJ9TRyHfZDeihC6vdE5vFhEbSkC23cyNVB+cPMnOJ1a?=
 =?us-ascii?Q?P8TO2+PNQVqC5QU+jQmm+Ww1R6pJaDVUGehw1r1eFTKG/dgwLl9Bq+GZht57?=
 =?us-ascii?Q?iveMCvv9H5vMxbpHPmnwndibEy4b2UIWVVYGX6VHnmKzb0l0AbGLKJSnyBtZ?=
 =?us-ascii?Q?YJKn+8HfLUCoYI//7m+dF2Czed5bCKydVxUmhJuERgqollu11k6WiJhILX1l?=
 =?us-ascii?Q?PYjSXYM1TNXif5/NpEJxbPDb9drYqLTEGe7gcaDtQ8daoiu+ni/lJKhSLWtK?=
 =?us-ascii?Q?YJBYoB+P/LLDxJohDgfv94qDydpIQNjnMh7grMFUkNQ7xtyzkH5bhOJEZpQ0?=
 =?us-ascii?Q?s8LUO3Qei4a4KbnX6HiPxurYlKXRPMlyO6SHdk6nceMB7+zdudsfXjeHEwVT?=
 =?us-ascii?Q?cpPG+TKHJeBO87eqzIQP1U9culA3u46mGAyvtmL+x/4Gt2VqWjNqhvFSz4Ks?=
 =?us-ascii?Q?Kf+t0bCu8+WXCO9nFi8WA5PkYhIO7Jlh6cwai/ShBpNDBYQx/hTbdWJ44NDi?=
 =?us-ascii?Q?PFfaFh2/pcj0tps7VG+Hq79CATxIVfHT2A9YptWcnFBZ5OODyzRSGIBf7tQQ?=
 =?us-ascii?Q?tVKx+wSwFUV+OC3s4mrX018d/jAaSR9vsbwY4nEjOg2/Z2uHmxPjz9xZ5qDc?=
 =?us-ascii?Q?fmq8PJkvJTuz1ILF9QAMhJHJpMJXv0650PgIo/Y1bESUuNX40u9LZT7q+8Vp?=
 =?us-ascii?Q?ay5ihUEor3dFCS+1DQGXRMkIGChjL3HlN2dbxbHKWkQiN5hAmH+F1mL3EOMQ?=
 =?us-ascii?Q?MGM4FjioadMJh/kSfEPHvlV8yjoKfQU3EjScGOdIcxlEbVytAbG9bgMGy8r4?=
 =?us-ascii?Q?ylzBWMpn04VpS5uGd3iOqpm838lKhGe28cL1glY9PwanpREEd0Ufeo/cXYPz?=
 =?us-ascii?Q?CR2QX/9xNCpNNF8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 17:19:40.8125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ebe516-b3be-4917-72cf-08dd4ac04515
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5984

Call the crypto finalize function before exiting *do_one_req() functions.
This allows the driver to take up further requests even if the previous
one fails.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index c2b8891a905d..c7bb6f951a84 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -275,8 +275,10 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	rctx->datbuf.size = rctx->len;
 	rctx->datbuf.buf = dma_alloc_coherent(se->dev, rctx->datbuf.size,
 					      &rctx->datbuf.addr, GFP_KERNEL);
-	if (!rctx->datbuf.buf)
-		return -ENOMEM;
+	if (!rctx->datbuf.buf) {
+		ret = -ENOMEM;
+		goto out_finalize;
+	}
 
 	scatterwalk_map_and_copy(rctx->datbuf.buf, req->src, 0, req->cryptlen, 0);
 
@@ -292,6 +294,7 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
 			  rctx->datbuf.buf, rctx->datbuf.addr);
 
+out_finalize:
 	crypto_finalize_skcipher_request(se->engine, req, ret);
 
 	return 0;
@@ -1152,21 +1155,21 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 
 	ret = tegra_ccm_crypt_init(req, se, rctx);
 	if (ret)
-		return ret;
+		goto out_finalize;
 
 	/* Allocate buffers required */
 	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
 	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
 					     &rctx->inbuf.addr, GFP_KERNEL);
 	if (!rctx->inbuf.buf)
-		return -ENOMEM;
+		goto out_finalize;
 
 	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
 	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
 					      &rctx->outbuf.addr, GFP_KERNEL);
 	if (!rctx->outbuf.buf) {
 		ret = -ENOMEM;
-		goto outbuf_err;
+		goto out_free_inbuf;
 	}
 
 	if (rctx->encrypt) {
@@ -1195,10 +1198,11 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
-outbuf_err:
+out_free_inbuf:
 	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
+out_finalize:
 	crypto_finalize_aead_request(ctx->se->engine, req, ret);
 
 	return 0;
@@ -1229,15 +1233,17 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
 	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
 					     &rctx->inbuf.addr, GFP_KERNEL);
-	if (!rctx->inbuf.buf)
-		return -ENOMEM;
+	if (!rctx->inbuf.buf) {
+		ret = -ENOMEM;
+		goto out_finalize;
+	}
 
 	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
 	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
 					      &rctx->outbuf.addr, GFP_KERNEL);
 	if (!rctx->outbuf.buf) {
 		ret = -ENOMEM;
-		goto outbuf_err;
+		goto out_free_inbuf;
 	}
 
 	/* If there is associated data perform GMAC operation */
@@ -1266,11 +1272,11 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
-outbuf_err:
+out_free_inbuf:
 	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
-	/* Finalize the request if there are no errors */
+out_finalize:
 	crypto_finalize_aead_request(ctx->se->engine, req, ret);
 
 	return 0;
-- 
2.43.2


Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50AD255E36;
	Mon, 24 Feb 2025 09:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388630; cv=fail; b=rfi93lacj91bz5m0JPdWAzpPjw7IKZOIylzNAYQQYp9lCH4aiFYFXOvmsHGxzlV9slyxNn0kQa5yNe4ifI+oQhvQME3cIiJkYIB7t+jkps4Yky1L2qOI1h/SzjaHmBcBEnSlC/F8uQycWM85XxpkeVDogIAmN0hLhMubqZSztbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388630; c=relaxed/simple;
	bh=C13nHlWGDhRnknGErb+juqd1bNzkxuWT3lPQrCXy9Dw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N33yncQ9QwA9PSChis+KE/Go8vI1DyA3bzCiSBAhW6FRMeeQ8NbNiA+oe7A4yoZoyD0b99geafqfHIuyaOsmEAPFcqQx/CFZG/PMMEix+xmgHvzFXZin1iqbuImGyJAkGrUdPCz0iWqPdMoOHHqtLU8NoHD+WGcTm6m9KVO0ELQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Yx0bNR3b; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Yx0bNR3b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q9/AwcNnOuwDNFrlFUGuuRtXmpfU2bgypItVbKUGhm3d8QwdQS11pwhG+zIAU9Zp3Vvyhv4yVpIKrsYsddt0GUriAsoInet51w/NUZGW9JMZAhYbvzq+XYkkNon5weLXovQN22kSlTb1E4uUNhK+Uvkurkwy0Oot+APb+ngYUJX4MpqgDoWmT2aFmLRG47y2408OmZq0lhOXZ3EswaoZXmc9VomP/YxBMVUSe5iTSUU6V+3dP61EZuV35YWgxhFsevGpSxp2xgeSkDo+vYYjiVRMj1uSJGNDzwYsu5xzj3IEb/IJS/vk31qh8y9OLoq/nV/KjvT2Xh3CfHMH2/mbkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mGdE+U/E8Rs1AsJN7w0cdGZu0mLVKXmjBjADszgu4M=;
 b=KV+YKS1kk0cT/S9dWgK/5OQDLQmvyf1Qux7o1FREkn9yTkxjPmar/utd/D7V//gePoUKIdPxgqbE+ZyK1G9IOOd6DwZZ+1rrCbqAsoqEKxM6ZxIvKtInL2PdOkd7q8ttk9ZHYEuScjsiJrlOpLID86c2wW9gGVBElUd3I2XrybMTtO7V5LzEUTCs4xQl24J0HTrJ17G1qw+LGFzhCRFKgEdbgFSNMHn4EUVLRJiVawc+QjvYWpdxSzhuGXECOTe755jq9SjKU0rI703PRmk3rMaEl9B2+AvW1WO/8d1w6re2jT7za8qlo2ksfU9DorfaaIF3lqtPTfSiZue4BZ5XJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mGdE+U/E8Rs1AsJN7w0cdGZu0mLVKXmjBjADszgu4M=;
 b=Yx0bNR3bfMxlYQ/A593uGx3OhSf1pg2AxTgt5XoIp2dzJPrkFGRbVaDHa7ZX8Qn+b2OITSXCVjF/E7BU8LNjKULwUC7CS9gHOOeO3Bav32+oAkwVenEbTiZ7n2hNWe54uwdWg+HoR4GjPrNzmtTp2VIkFJhUuh7MqEHUpyQZhHqdS2GzPUTUi4I2u9Yz3e0ibHfCUpYqIN6LwsKZm0KyElIbstNL9DfeHit8XNXbMkB6smdVIiFEUGSvq+sTsP269LSpSQa+vpgj/ForTVZikeBqGlUlA0lkoCTuvD8JPgR7g9wRwGHCcwwGV5B4HMTJmDg/2MImDHvja/dO7Bbyrg==
Received: from BN9PR03CA0211.namprd03.prod.outlook.com (2603:10b6:408:f8::6)
 by CH2PR12MB4055.namprd12.prod.outlook.com (2603:10b6:610:78::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Mon, 24 Feb
 2025 09:17:04 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:408:f8:cafe::7c) by BN9PR03CA0211.outlook.office365.com
 (2603:10b6:408:f8::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Mon,
 24 Feb 2025 09:17:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Mon, 24 Feb 2025 09:17:02 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 01:16:50 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 01:16:50 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 01:16:47 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v3 02/10] crypto: tegra: Do not use fixed size buffers
Date: Mon, 24 Feb 2025 14:46:02 +0530
Message-ID: <20250224091610.49683-3-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|CH2PR12MB4055:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e2668c-464a-47e7-fd66-08dd54b40042
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h5t2mwegcomiX0V4yiUV1Rzahg/xT3Ms1gZuY5vBbRFnyZGoAm0BuVhRMg2S?=
 =?us-ascii?Q?TmRe/P4yt0ZialKmhhuLk5Aaoxgi4cgivw1paVI6L0+iRAFkfX/FaAxzg1My?=
 =?us-ascii?Q?YvuCdRtTmVs05DX6nKA3UZqaKONBucmG0Cg9bGM0aUrtP1krE2VQI6ITda0b?=
 =?us-ascii?Q?oWno3QIjp8Cr6FMxS3iifjuf0oxArVs2BzxDDizM/78LBFbkAhm0mL6TMdUq?=
 =?us-ascii?Q?XhVq9POvcqYhAB/BOY8ujYTpS/8tziPK6i6jiiHWxbQdTxybm4km7WeH8P4L?=
 =?us-ascii?Q?ce9FbEnFtvEbVa8s2LG+vXo95Gv26yTlO25OAaL6laoejSmXZWllPhRzsGS3?=
 =?us-ascii?Q?9yywuP1yfevUncRNB+3q8XMzJidBcl52QZAKD5l5C8LKI5CSHK9CN8sYKK6u?=
 =?us-ascii?Q?H3I8qcNtERbze8Yd5UoGlikAr9AT1pV44EqKRMeo0oRmO7+RWo9QyAdE0kyW?=
 =?us-ascii?Q?WOz4rH5CVtQOgCH9O3okVzkjYwP7WUXD+xwdTfutoFpV37HfKcaFSRrzat5V?=
 =?us-ascii?Q?nTz0NPOaLOyPjSsOMHZZsL2f0OvBREfN3+td5H4iQWVXMwvn/tNvYuse4ppr?=
 =?us-ascii?Q?XEqhvhwlZUmODXzC9n0JQmDLgRFRDlJc/A2GanopOE97AXqmOjatnXa9mfe8?=
 =?us-ascii?Q?YDRQMsQAWAIi9Qp6Cbi8ojWX3/ZU2nr1p45Xl7ww8OFnmDq4id00OPJAzPNL?=
 =?us-ascii?Q?uxvrnWgqegJ8+BltUI3fGQ5YGYNnbGMxr/GyIjAo56Xlm2wdc0Pqt1GXHiKR?=
 =?us-ascii?Q?u+h6tuN6ls74cWIc+7/Gv+pM131uANgwqCmGavTYcPeyQWhhqS9fYxyjy2Kj?=
 =?us-ascii?Q?y3audRPC14BBLo9ohzV/sTXSXsh6q5P7Xat+5atieZKYofavG3DbT+716AVd?=
 =?us-ascii?Q?GOAg6qOyG1zneRiOnb+h+JNaJqhGO5fNb1Q77GlsSIgpYJN9Q3djiAoKnKVw?=
 =?us-ascii?Q?aAw4zfJcFdTSIoOSW5VZFy/dbNa7yNy92IOaIiHBuEFwFcYswCRwQlPqmbSF?=
 =?us-ascii?Q?d4nb34JAXl0VtZpZ5Jmw8ggE88Z6ebBjExZ21+WEdz5YWO0o76hHxj28eOu/?=
 =?us-ascii?Q?pEUnE+MTEY/ifrGYDKJMba77FBmrKwgeaUQ75YOoFAId20E5VfGwnZg3mP5n?=
 =?us-ascii?Q?ey7RaASMUoja08A0PX3Ym/yfVGJXzybDvuYSYa1bwvVE3jpgy7RTqY+rva9A?=
 =?us-ascii?Q?UbAoIEC4PXowaNoF1TyAAmld7GESgf6xz42nY2vJPafd9LC8J30PbDJM5VaB?=
 =?us-ascii?Q?7SzGqllp8j52oE9V2CAiZZcmnaFmVVjdPA+DM7KLUyGD2xWIJ6flgyF3X5T5?=
 =?us-ascii?Q?M7FlIIp1cwyCGkm95Ll72bgPgt6iJ0lsXoTx8OT6ZVOWgBXAMTw0F7835P3D?=
 =?us-ascii?Q?yuMHCIpda9QuDLyquXtO+t1Z188ov6uKvBVnmnRXX97J1i3WrHMY8PEQQcYB?=
 =?us-ascii?Q?dgbmqyzMXqUj4ZLYPIY/zqXAztdYLydeW78V3JCYFSWtHELBA5NXd+I5WCiq?=
 =?us-ascii?Q?qW5pMeMEnXzL3t4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 09:17:02.9840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e2668c-464a-47e7-fd66-08dd54b40042
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4055

Allocate the buffer based on the request instead of a fixed buffer
length. In operations which may require larger buffer size, a fixed
buffer may fail.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 124 ++++++++++++++-------------
 drivers/crypto/tegra/tegra-se-hash.c |  38 +++++---
 drivers/crypto/tegra/tegra-se.h      |   2 -
 3 files changed, 89 insertions(+), 75 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 7da7e169a314..c2b8891a905d 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -263,12 +263,6 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	unsigned int cmdlen;
 	int ret;
 
-	rctx->datbuf.buf = dma_alloc_coherent(se->dev, SE_AES_BUFLEN,
-					      &rctx->datbuf.addr, GFP_KERNEL);
-	if (!rctx->datbuf.buf)
-		return -ENOMEM;
-
-	rctx->datbuf.size = SE_AES_BUFLEN;
 	rctx->iv = (u32 *)req->iv;
 	rctx->len = req->cryptlen;
 
@@ -278,6 +272,12 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 			rctx->len += AES_BLOCK_SIZE - (rctx->len % AES_BLOCK_SIZE);
 	}
 
+	rctx->datbuf.size = rctx->len;
+	rctx->datbuf.buf = dma_alloc_coherent(se->dev, rctx->datbuf.size,
+					      &rctx->datbuf.addr, GFP_KERNEL);
+	if (!rctx->datbuf.buf)
+		return -ENOMEM;
+
 	scatterwalk_map_and_copy(rctx->datbuf.buf, req->src, 0, req->cryptlen, 0);
 
 	/* Prepare the command and submit for execution */
@@ -289,7 +289,7 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	scatterwalk_map_and_copy(rctx->datbuf.buf, req->dst, 0, req->cryptlen, 1);
 
 	/* Free the buffer */
-	dma_free_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
 			  rctx->datbuf.buf, rctx->datbuf.addr);
 
 	crypto_finalize_skcipher_request(se->engine, req, ret);
@@ -1117,6 +1117,11 @@ static int tegra_ccm_crypt_init(struct aead_request *req, struct tegra_se *se,
 	rctx->assoclen = req->assoclen;
 	rctx->authsize = crypto_aead_authsize(tfm);
 
+	if (rctx->encrypt)
+		rctx->cryptlen = req->cryptlen;
+	else
+		rctx->cryptlen = req->cryptlen - rctx->authsize;
+
 	memcpy(iv, req->iv, 16);
 
 	ret = tegra_ccm_check_iv(iv);
@@ -1145,30 +1150,26 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	struct tegra_se *se = ctx->se;
 	int ret;
 
+	ret = tegra_ccm_crypt_init(req, se, rctx);
+	if (ret)
+		return ret;
+
 	/* Allocate buffers required */
-	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
+	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
 					     &rctx->inbuf.addr, GFP_KERNEL);
 	if (!rctx->inbuf.buf)
 		return -ENOMEM;
 
-	rctx->inbuf.size = SE_AES_BUFLEN;
-
-	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
+	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
 					      &rctx->outbuf.addr, GFP_KERNEL);
 	if (!rctx->outbuf.buf) {
 		ret = -ENOMEM;
 		goto outbuf_err;
 	}
 
-	rctx->outbuf.size = SE_AES_BUFLEN;
-
-	ret = tegra_ccm_crypt_init(req, se, rctx);
-	if (ret)
-		goto out;
-
 	if (rctx->encrypt) {
-		rctx->cryptlen = req->cryptlen;
-
 		/* CBC MAC Operation */
 		ret = tegra_ccm_compute_auth(ctx, rctx);
 		if (ret)
@@ -1179,8 +1180,6 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 		if (ret)
 			goto out;
 	} else {
-		rctx->cryptlen = req->cryptlen - ctx->authsize;
-
 		/* CTR operation */
 		ret = tegra_ccm_do_ctr(ctx, rctx);
 		if (ret)
@@ -1193,11 +1192,11 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	}
 
 out:
-	dma_free_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
 outbuf_err:
-	dma_free_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
 	crypto_finalize_aead_request(ctx->se->engine, req, ret);
@@ -1213,23 +1212,6 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	struct tegra_aead_reqctx *rctx = aead_request_ctx(req);
 	int ret;
 
-	/* Allocate buffers required */
-	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, SE_AES_BUFLEN,
-					     &rctx->inbuf.addr, GFP_KERNEL);
-	if (!rctx->inbuf.buf)
-		return -ENOMEM;
-
-	rctx->inbuf.size = SE_AES_BUFLEN;
-
-	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, SE_AES_BUFLEN,
-					      &rctx->outbuf.addr, GFP_KERNEL);
-	if (!rctx->outbuf.buf) {
-		ret = -ENOMEM;
-		goto outbuf_err;
-	}
-
-	rctx->outbuf.size = SE_AES_BUFLEN;
-
 	rctx->src_sg = req->src;
 	rctx->dst_sg = req->dst;
 	rctx->assoclen = req->assoclen;
@@ -1243,6 +1225,21 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	memcpy(rctx->iv, req->iv, GCM_AES_IV_SIZE);
 	rctx->iv[3] = (1 << 24);
 
+	/* Allocate buffers required */
+	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
+	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
+					     &rctx->inbuf.addr, GFP_KERNEL);
+	if (!rctx->inbuf.buf)
+		return -ENOMEM;
+
+	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
+	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
+					      &rctx->outbuf.addr, GFP_KERNEL);
+	if (!rctx->outbuf.buf) {
+		ret = -ENOMEM;
+		goto outbuf_err;
+	}
+
 	/* If there is associated data perform GMAC operation */
 	if (rctx->assoclen) {
 		ret = tegra_gcm_do_gmac(ctx, rctx);
@@ -1266,11 +1263,11 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 		ret = tegra_gcm_do_verify(ctx->se, rctx);
 
 out:
-	dma_free_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
 outbuf_err:
-	dma_free_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
 	/* Finalize the request if there are no errors */
@@ -1497,6 +1494,11 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 		return 0;
 	}
 
+	rctx->datbuf.buf = dma_alloc_coherent(se->dev, rctx->datbuf.size,
+					      &rctx->datbuf.addr, GFP_KERNEL);
+	if (!rctx->datbuf.buf)
+		return -ENOMEM;
+
 	/* Copy the previous residue first */
 	if (rctx->residue.size)
 		memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
@@ -1529,6 +1531,9 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 	if (!(rctx->task & SHA_FINAL))
 		tegra_cmac_copy_result(ctx->se, rctx);
 
+	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
+			  rctx->datbuf.buf, rctx->datbuf.addr);
+
 	return ret;
 }
 
@@ -1543,10 +1548,20 @@ static int tegra_cmac_do_final(struct ahash_request *req)
 
 	if (!req->nbytes && !rctx->total_len && ctx->fallback_tfm) {
 		return crypto_shash_tfm_digest(ctx->fallback_tfm,
-					rctx->datbuf.buf, 0, req->result);
+					NULL, 0, req->result);
+	}
+
+	if (rctx->residue.size) {
+		rctx->datbuf.buf = dma_alloc_coherent(se->dev, rctx->residue.size,
+						      &rctx->datbuf.addr, GFP_KERNEL);
+		if (!rctx->datbuf.buf) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+
+		memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
 	}
 
-	memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
 	rctx->datbuf.size = rctx->residue.size;
 	rctx->total_len += rctx->residue.size;
 	rctx->config = tegra234_aes_cfg(SE_ALG_CMAC, 0);
@@ -1565,8 +1580,10 @@ static int tegra_cmac_do_final(struct ahash_request *req)
 		writel(0, se->base + se->hw->regs->result + (i * 4));
 
 out:
-	dma_free_coherent(se->dev, SE_SHA_BUFLEN,
-			  rctx->datbuf.buf, rctx->datbuf.addr);
+	if (rctx->residue.size)
+		dma_free_coherent(se->dev, rctx->datbuf.size,
+				  rctx->datbuf.buf, rctx->datbuf.addr);
+out_free:
 	dma_free_coherent(se->dev, crypto_ahash_blocksize(tfm) * 2,
 			  rctx->residue.buf, rctx->residue.addr);
 	return ret;
@@ -1672,28 +1689,15 @@ static int tegra_cmac_init(struct ahash_request *req)
 	rctx->residue.buf = dma_alloc_coherent(se->dev, rctx->blk_size * 2,
 					       &rctx->residue.addr, GFP_KERNEL);
 	if (!rctx->residue.buf)
-		goto resbuf_fail;
+		return -ENOMEM;
 
 	rctx->residue.size = 0;
 
-	rctx->datbuf.buf = dma_alloc_coherent(se->dev, SE_SHA_BUFLEN,
-					      &rctx->datbuf.addr, GFP_KERNEL);
-	if (!rctx->datbuf.buf)
-		goto datbuf_fail;
-
-	rctx->datbuf.size = 0;
-
 	/* Clear any previous result */
 	for (i = 0; i < CMAC_RESULT_REG_COUNT; i++)
 		writel(0, se->base + se->hw->regs->result + (i * 4));
 
 	return 0;
-
-datbuf_fail:
-	dma_free_coherent(se->dev, rctx->blk_size, rctx->residue.buf,
-			  rctx->residue.addr);
-resbuf_fail:
-	return -ENOMEM;
 }
 
 static int tegra_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index c7b2a062a03c..b4a179a8febd 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -332,6 +332,11 @@ static int tegra_sha_do_update(struct ahash_request *req)
 		return 0;
 	}
 
+	rctx->datbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->datbuf.size,
+					      &rctx->datbuf.addr, GFP_KERNEL);
+	if (!rctx->datbuf.buf)
+		return -ENOMEM;
+
 	/* Copy the previous residue first */
 	if (rctx->residue.size)
 		memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
@@ -368,6 +373,9 @@ static int tegra_sha_do_update(struct ahash_request *req)
 	if (!(rctx->task & SHA_FINAL))
 		tegra_sha_copy_hash_result(se, rctx);
 
+	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
+			  rctx->datbuf.buf, rctx->datbuf.addr);
+
 	return ret;
 }
 
@@ -380,7 +388,17 @@ static int tegra_sha_do_final(struct ahash_request *req)
 	u32 *cpuvaddr = se->cmdbuf->addr;
 	int size, ret = 0;
 
-	memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
+	if (rctx->residue.size) {
+		rctx->datbuf.buf = dma_alloc_coherent(se->dev, rctx->residue.size,
+						      &rctx->datbuf.addr, GFP_KERNEL);
+		if (!rctx->datbuf.buf) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+
+		memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
+	}
+
 	rctx->datbuf.size = rctx->residue.size;
 	rctx->total_len += rctx->residue.size;
 
@@ -397,8 +415,10 @@ static int tegra_sha_do_final(struct ahash_request *req)
 	memcpy(req->result, rctx->digest.buf, rctx->digest.size);
 
 out:
-	dma_free_coherent(se->dev, SE_SHA_BUFLEN,
-			  rctx->datbuf.buf, rctx->datbuf.addr);
+	if (rctx->residue.size)
+		dma_free_coherent(se->dev, rctx->datbuf.size,
+				  rctx->datbuf.buf, rctx->datbuf.addr);
+out_free:
 	dma_free_coherent(se->dev, crypto_ahash_blocksize(tfm),
 			  rctx->residue.buf, rctx->residue.addr);
 	dma_free_coherent(se->dev, rctx->digest.size, rctx->digest.buf,
@@ -527,19 +547,11 @@ static int tegra_sha_init(struct ahash_request *req)
 	if (!rctx->residue.buf)
 		goto resbuf_fail;
 
-	rctx->datbuf.buf = dma_alloc_coherent(se->dev, SE_SHA_BUFLEN,
-					      &rctx->datbuf.addr, GFP_KERNEL);
-	if (!rctx->datbuf.buf)
-		goto datbuf_fail;
-
 	return 0;
 
-datbuf_fail:
-	dma_free_coherent(se->dev, rctx->blk_size, rctx->residue.buf,
-			  rctx->residue.addr);
 resbuf_fail:
-	dma_free_coherent(se->dev, SE_SHA_BUFLEN, rctx->datbuf.buf,
-			  rctx->datbuf.addr);
+	dma_free_coherent(se->dev, rctx->digest.size, rctx->digest.buf,
+			  rctx->digest.addr);
 digbuf_fail:
 	return -ENOMEM;
 }
diff --git a/drivers/crypto/tegra/tegra-se.h b/drivers/crypto/tegra/tegra-se.h
index b54aefe717a1..e196a90eedb9 100644
--- a/drivers/crypto/tegra/tegra-se.h
+++ b/drivers/crypto/tegra/tegra-se.h
@@ -340,8 +340,6 @@
 #define SE_CRYPTO_CTR_REG_COUNT			4
 #define SE_MAX_KEYSLOT				15
 #define SE_MAX_MEM_ALLOC			SZ_4M
-#define SE_AES_BUFLEN				0x8000
-#define SE_SHA_BUFLEN				0x2000
 
 #define SHA_FIRST	BIT(0)
 #define SHA_UPDATE	BIT(1)
-- 
2.43.2


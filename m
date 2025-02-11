Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5592A262172;
	Tue, 11 Feb 2025 17:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294384; cv=fail; b=UammDJDfqIEubfUkmfc4mb/Ntpx4aGlGawKONga8lvOT8OyVNavVSLFg94tqg3vK+b2d3wVn2SBWtsgWuQq8+jr069Y6f4dhZ6k+9e6H/MwGTPmInRnr42MnNtz9PDizaQqDcM5GuwhCTuREovlhoMJDuqX/Cn9ODSwPz6Cbf5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294384; c=relaxed/simple;
	bh=C13nHlWGDhRnknGErb+juqd1bNzkxuWT3lPQrCXy9Dw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cgt5r2QvGtAL5dXucLZoyPCjZnvZtsrL65b/RrhWB8fGcdroe4aaBX7MNzRP4oQCO/bgr9zD53EFIKx/3SFrcETfm3qxWF2tR3YOH8wdu9/wIpX1b2sph7y622tXfULEfg6KRb5hJSNQuxc7yYq8bogquN+uFw2rv31YmFm4q1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jNi7Rx+7; arc=fail smtp.client-ip=40.107.244.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jNi7Rx+7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5neT/0v0u/CWpeA19ciIObENRadp5WK2BqXJNVEOcGtEWjh7prk93bVmQgBl3sf95iJmdkBz2P6VOlhvf13KrDvLoXWZPJ3mfCe1Zmm7Lk3iYx9W5O1SUPkzfVPoj77tN1Sx8hBeUTtsuopmj8lM3AEGj4NlYGz3m4uYFN97R6yzrky9UcQWQzJRm7ndN/sfSktZZpA+2T47NKDvhmh7s/ye/8NcObllUgcgOWnKdcOU1yjWEm//hG/Z54AImXzeQdKWaar3sg37hNFblc/BALgy8MyW2zhxi45Zebi2xr2iAsLbqT6zuDUQBYOlDmmJEl/XMIK3vie8Jg+XnEMdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mGdE+U/E8Rs1AsJN7w0cdGZu0mLVKXmjBjADszgu4M=;
 b=ff0VwDK5gr0AtvpRcxrgOLQcCoLIRiA1RyWq85kfU2auLfe2G5pM3wvGJoaEUWS4kn75yD5QvJuG/4MnTc5XLrpuakzDlFxCXlEOjoWggI3f+waN+14jmKAF5UIIFTdXiA/B6sqF8/0Cof+fHMIssIYwZqL4V6n2bqVJ7u4oMfdLrE3cnBNU/CWxKPZtrBYZ6y5fuPaM6ucdEOxjVjfnULYTFCtlOHS6JE9mssyFcigH0yf9aA9U8VpB1yY6RTFtCideAnpPgBPTt1m9ny1Dku+Y5WWmr7/tYHvmjXqgSXSBT1q2opJx9CWKQ9jZVotF/hgs1I57FnbxfAFBL96E8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mGdE+U/E8Rs1AsJN7w0cdGZu0mLVKXmjBjADszgu4M=;
 b=jNi7Rx+7G2fdsrvhoXMc0eA+U0u6Ou0eJDVBXXddH1vm+1xRfmsuUwfIs8E9lER2Md2QohATBuhA+KJ/C8nxdnVP6gIR61nkg0OW1b141naaU3AAos1G9hr72G5z4vbDXhPGYIdJLqASiko1b3dyNj3dfRIl6pgw6DPU0AIuA9MSEfjAA6MpgqLUdQ3R2tcYGQQSJ/rU/ch74oNHLxdHIA+WYSeMmymcp+sGQY6p4gxBG/gkgMM9plUvbI9Ad318oQbgv7I+7w/Leqqql1uOiCKI/a6UYbOJsWEMFWjUXX21kux9EfsZ6JCqdDUn7MZgjgOZA+TfElHeu/iNJ1waJA==
Received: from DM6PR03CA0069.namprd03.prod.outlook.com (2603:10b6:5:100::46)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.11; Tue, 11 Feb
 2025 17:19:33 +0000
Received: from DS1PEPF00017093.namprd03.prod.outlook.com
 (2603:10b6:5:100:cafe::8e) by DM6PR03CA0069.outlook.office365.com
 (2603:10b6:5:100::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Tue,
 11 Feb 2025 17:19:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017093.mail.protection.outlook.com (10.167.17.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 17:19:32 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Feb
 2025 09:19:18 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Feb
 2025 09:19:17 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Feb 2025 09:19:15 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v2 02/10] crypto: tegra: Do not use fixed size buffers
Date: Tue, 11 Feb 2025 22:47:05 +0530
Message-ID: <20250211171713.65770-3-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017093:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: 56e810af-d85a-4921-06ae-08dd4ac04004
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vSwCfuNqolYToYl50kjlnZECj/QzwxxanwWnzFUkDrWxYXCyiL0GzZzHevX6?=
 =?us-ascii?Q?+mEXTzHzh2TeUunf9Wh+qdWoGcew1CY34iskGshhAs+xzPsGPWXVchk1Khch?=
 =?us-ascii?Q?pU4C7yhrtGzuRrAxgrMtBziMVAethprYqelui4UCY94pCkn6Za8Ay+AuVM+H?=
 =?us-ascii?Q?UnGvSA1XLHPzM4NKHjiHS1pYnGl9BZvy8/5wYL5HufmllI9jJqfygHJ7kelr?=
 =?us-ascii?Q?1ZoVa43gewSZzDFvX586LYkSBX8rbFwsL9RTOdW6XuLndZu7wdYf6SbJ823v?=
 =?us-ascii?Q?ZeOwjHROiA1TdsyDeeu9gg2ha9wralK3oeAcxDNozSFw3/oHkMVqVKES5iRP?=
 =?us-ascii?Q?QI579+RdLxhPkV80jPYa4H/BzCYYFqHnAqvl84gsjQIqdO1CBArWqtcIRBMi?=
 =?us-ascii?Q?JtHfpRSz17ykyQBJ9nUoSAA0VWDEvpMGFUsVTfTen32pd4hEWlxXbSGPywLL?=
 =?us-ascii?Q?b5A9mQdCMB3uYlBzph0wvridyU81LHRVlChfia7hFu876t4RTKu2r6kIfE6C?=
 =?us-ascii?Q?C2Zjbe05fgXBrrq5VN+OVBQjjUh670uobFBJfMPhyRT3biaW2IRRh5jghDQI?=
 =?us-ascii?Q?zSzFlRSfLiYQ3D6OTdZLsaC6PacvmtYZKbFm4m7dx+5KnxBk9ai+NQrAALv4?=
 =?us-ascii?Q?sP9POA4UONBzr+vEbLKskl0WXYGGMlDETwYIqbyWI08C4WYnivZmT41Sx+9O?=
 =?us-ascii?Q?MnEfH2uuw67EOCR43bABmh8cFRuUFevmFXqRWYzzMqHZpw5Q1g0R8b+dxpRE?=
 =?us-ascii?Q?iFAH4in/GBq5hRaVlyC6es8lI6IynFPrI56OerD6VabpaJ8t4idnhNou24Fd?=
 =?us-ascii?Q?Zin4Z9DQIPIPa6Pg/4ftUKz8mV1sjhGd+OwWRpRlXOjsx4hgQCBPCOHfVutA?=
 =?us-ascii?Q?f7aVQR24pz7926s12iOf2eAJu5RXCP8t9Ynzik+CBELdQQVQT/tuRyjmuADU?=
 =?us-ascii?Q?uKt/HmV/55QsWCJiqCBL+bw48g1ubyP9mLN46nCz9QLjQLvqD0wOgeL5f3Hb?=
 =?us-ascii?Q?AnhJx9K/aKmLsfHxVL7ErjjhtaHNXpvLF7PMOk9/oGVptoDpFYh1OSTHCIO5?=
 =?us-ascii?Q?ClN1EeHne6i8gGZDIqTPuZNcBQtH1zUk92y317BDowHgxLKr9TTtJB9Sn6D0?=
 =?us-ascii?Q?a4a9tClnirzZcl/OCN5T1NuDRGZqyeWqcfyoWRyX+P8YlhSPOsbM3t9kDrnS?=
 =?us-ascii?Q?3AqCjP1Ikd/4zdCmAm6vFWqoDdm/TT3AQ8EJtip6oCBU771qkUBcEaf7dDFt?=
 =?us-ascii?Q?iPJgF0j4FtcxWZKE2ZWVUp2k/pSssjQBcVFInzW2y2gRg0ygAheb1EXqrDW1?=
 =?us-ascii?Q?h1xsMzgDOkx3mBreDuEEny+oAgvqnRrdAAlBKmbGjZP8nAwDbkt+maZlDcrd?=
 =?us-ascii?Q?znYOkdtTiCluRleGFF0iLgaWrYCN+e3N8D6QXzpQVC3Hj1VqWccaEIzt7PGm?=
 =?us-ascii?Q?Y8Wovke/87sh83kSlap0agHN2dsOByRFEOiL/HLfOkklXTi2jZro81tjXSCH?=
 =?us-ascii?Q?J9dAVPkB+LLK5Z8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 17:19:32.3097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56e810af-d85a-4921-06ae-08dd4ac04004
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017093.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

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


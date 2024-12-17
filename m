Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C731F76D8;
	Tue, 17 Dec 2024 16:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734452010; cv=fail; b=IeuuRqkX3VPHKTCcDpLTdCWJKxh8FuifSlwHziV8WMy4pLVb6vTtXNLzpB3XFwcqeD3VZiCVQ0ZUWVeRZzekamArnScThsS0ufdE4yM1zCAOrKpWxZWREbRqEMloPDiqqpZyV8EVZWsyx2lvAM8w6Ng07ZuSqHBnRC/NAIpCGp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734452010; c=relaxed/simple;
	bh=T5epUuw+8FkOc8wUogLFD2nTsh1MrKOEuPElb1iHKDY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DTdvCOWayQBVjBcCXHqJRCrPbFCnHKzdONft6nitVOesh4kkSCb8mQVHIGjfedEAdRdTdYq6lbWTZSUZuYNfKr/y2duN2NriGsnWiOvnzgN03GAy39WOXsMwBbSVqzwgc8ydAE4Z5AkeM57SlqCenkpSHqsdGc1rVBklJyc0d00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j4DHnxbK; arc=fail smtp.client-ip=40.107.92.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j4DHnxbK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KXVpGXpzH0hKfZdrrCDBBeJfZgfmlJZo/AcO24vdQPbcs67gb3gfkiU3lRhz4LAhZ0Jfpqix5f/WFNN+892xzTDvVjV+oVldus9hyiZmfs7oAZjdxMxhW0LRxkeWevqPTTronP1MvwHgDNheSc88d/rIH8Wut9l/UTOhWNWnQpz8tyvKxsddoKCKD0wUGU0dDRNtD/bsQDO+6bboeMxY97u5qWvDrrbTynVX2ntDOe4gWMtY4fvNyWbOH5P3KY5e0kohvPTrTqTeooevjlruhUajUsv3WBuEOzrzuWDe3SD3Llfw1sDLqHu+qljIKgQHbgHSYu+N7Npjt2/NdGpGGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4H6NF9ogiSy+PyD+GTEn9k2j4RtKTz2czbWy279HCuM=;
 b=VAtWtafpeGOMHrPcJSrAFkxF+0XKcjF9zdivGJ9tD88KFhflWHlwfPsFeD32GGVIh5wQ909jjeYBhcNJa4Y1XnSgQlbHeHYWOer1o0RWlkPDzGARYgS8whUDmGRxR/bpfdvaM6RNK9Tl3Vtwvgxz3xffypPyab9UtkAWojMtWpHIT8yFi0967OIubndUGA4usv98VWTRFbpwZmYTi34xs12F1aLMf6OrXGO/ideloDTYDwBLdu0HzibWcD4kO4NPLcINbMpNH6npmvvnObJBRCm9LeSDE3r9zFKbtxqP8lX0OFxt6ok21dK78nQL/lX86msmS220sSNUOVuJM0J5lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4H6NF9ogiSy+PyD+GTEn9k2j4RtKTz2czbWy279HCuM=;
 b=j4DHnxbKODyORGyq0aGQ7fuGLf1grZ31IBLQC3y8xQmJts5+PY+KEeEFl1+yUqM2IFAsDHTE4zWDNZQPcD5sf3Zps4WhfL1r5AGJA8M0rF5xeXjK+WC3fclclmbGVYwBlZ6mo69KAHfHgNDF3SVS1LklfMXDVYxrFaZKndfKjEMGfRhzKUo3NrIYtjiBeMZ05GVJpFMcYQ0XOvmkbirkcHG01WDstVD86i5ohPevOoTCT40TUG4S16CG1xfAZ8rFNqBxohzxPXmbg2MCYfsLuqoms8KcbTKthL9m/0nrjnkBGv9oJjW7xlElOCaZrATLoKpqiOkgJqh41RTVmgjZtg==
Received: from BL0PR0102CA0053.prod.exchangelabs.com (2603:10b6:208:25::30) by
 MN2PR12MB4176.namprd12.prod.outlook.com (2603:10b6:208:1d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Tue, 17 Dec
 2024 16:13:23 +0000
Received: from BL02EPF0001A106.namprd05.prod.outlook.com
 (2603:10b6:208:25:cafe::97) by BL0PR0102CA0053.outlook.office365.com
 (2603:10b6:208:25::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.21 via Frontend Transport; Tue,
 17 Dec 2024 16:13:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A106.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Tue, 17 Dec 2024 16:13:22 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:13:01 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:13:01 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 17 Dec 2024 08:12:58 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <akhilrajeev@nvidia.com>
Subject: [PATCH 2/7] crypto: tegra: Do not use fixed size buffers
Date: Tue, 17 Dec 2024 21:42:02 +0530
Message-ID: <20241217161207.72921-3-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A106:EE_|MN2PR12MB4176:EE_
X-MS-Office365-Filtering-Correlation-Id: 887b4cae-12e5-4644-5d87-08dd1eb5ba9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K9xWzjCbVZKnxZOWf0f+LbdsQVgzAquCAKOriIYh9ocq1zEGt2VQnwMheW1h?=
 =?us-ascii?Q?VoWvqVF/0uPPtZxF5BRjy+e3HEtnWBxPGylyc9zaDPmm5ZfyS/1tsZsph8TK?=
 =?us-ascii?Q?zQ5ICHcp+pMso1SCRXfsf/YMSI3WEMU1NFCc4wmn4LCe4E+cHJsdSRWmjdAV?=
 =?us-ascii?Q?+pugpDhXJFfOm4zSFfx1obxJr95z2v3O3hENd6KlPH+8bVjUgSHMUNomZ47P?=
 =?us-ascii?Q?+eG6TZLbLqBKZ+qfjw+aRkDv/uNvaPx2pVIirNCU9WSD/j6JI8wEBIgzQHsS?=
 =?us-ascii?Q?tYCGzHtE6I38PfL543YKe8/qlsXnaOp9s4/ms7nOYfOKGMCDsv53nCbDb35O?=
 =?us-ascii?Q?4PFb+s7CO7f0tVDYcPrAsitpBfRrrCbnZbu274edeCIK55RYCJ50GYGpfZGh?=
 =?us-ascii?Q?rH5Xwi5xu3I9/Yrf/6PScf1MQdqCKp8omWTKZPzldaKI5TThMeeohXCDuaqe?=
 =?us-ascii?Q?e6H4FbUrTuG0mVnF47qMvrhnTMfHdYwhKC4T1OPhhOdS51SjLng1022i9KTS?=
 =?us-ascii?Q?vYIps0geqY7nP578+X5qIKfXGpRclAuTX+OArskoo1d/4PT+5tQYAccgQ0Fy?=
 =?us-ascii?Q?vz5bja1Kq0iyR9lsy80l7ny6T3Wji7pE4h0wp2b/md7ytJ3k/upi0UfQV39R?=
 =?us-ascii?Q?1FT+jjhoSlhoQo8jKJh1wFmzfRNsrRKpOtKxKAnbFcncvViGVOGIx/zAkZOy?=
 =?us-ascii?Q?ncPy+vOPkWcSBudvFXgq3x/1F1qg96ZfNhasHJzzpC9dSm8MRnP8r+Ds10oo?=
 =?us-ascii?Q?yGYmozmqS+XuP0OCAdvFN+WYAEJu7Oh9mBzm0kivuhHwo9mCd4CagmQ3279I?=
 =?us-ascii?Q?OJzMXPNgAZv9q010A/yl4n9o6y3L/6ZFEkKvGu+OYP7OBMfY1Qb3A93DGXIM?=
 =?us-ascii?Q?HUEQxRBqhUiZoven5uT9CYyboTYQ5Tj53V9ofjkQKsDqSzMi/xybEBg+xWTe?=
 =?us-ascii?Q?6snln6GsBpD0zzAj7rVaX7epfQa+5JfV3VkNQBYj1XgK1UZSUnXDStY0liOK?=
 =?us-ascii?Q?EeGkEJSerKQYjulcTsjTgyOMq2sftbG1DZkN173s6bVulSoc2n6KEac9Iil4?=
 =?us-ascii?Q?ID23oMO9NMLqbW5E33Unh5bV1xJHRpT8E5nYb7wmSDzZ9agoIlny5gT1svDg?=
 =?us-ascii?Q?yDzsjUKqKeUVMiLd0aLNxnVifSzeLs2+YiDEVTCtGPjlYx96j47CQVmVc7nb?=
 =?us-ascii?Q?uywFBtbGhJi2q5fotjnskXJ0ZczMps1V7vh7n/tl2iaJD2HduV9v58CyNfhA?=
 =?us-ascii?Q?XLD5EXgi6zviKB8bcTKIdJxr/UgqEEuuu5cU6NzOZJC4ImMlQeUGI9Exmj1G?=
 =?us-ascii?Q?bVAlkhbedAHtlaS+d3WbCBoWmnXeW1D5vpTjn9ndzOJtOo89a6+W5TRNYEzt?=
 =?us-ascii?Q?mN+NSGxlwpwoogAFbJGIW2LjszcysXNnrLxQG77FPyfSPmSV+PM6MT419s74?=
 =?us-ascii?Q?JFXlORav1c4J39R2pkw7vm4DrM5MZ28UkN+gh7ecytxbQvFwbzXivDiekYW3?=
 =?us-ascii?Q?b1Y+Q0xDKk0rC1Y=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 16:13:22.3171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 887b4cae-12e5-4644-5d87-08dd1eb5ba9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A106.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4176

Allocate the buffer based on the request instead of a fixed buffer
length. In operations which may require larger buffer size, a fixed
buffer may fail.

Fixes:  0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 124 ++++++++++++++-------------
 drivers/crypto/tegra/tegra-se-hash.c |  38 +++++---
 drivers/crypto/tegra/tegra-se.h      |   2 -
 3 files changed, 89 insertions(+), 75 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 5fc7e19b8ab8..b80786c5e4fd 100644
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
index a0460e624523..aed82d82b5fb 100644
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


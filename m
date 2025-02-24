Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2051.outbound.protection.outlook.com [40.107.102.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923C7244EA1;
	Mon, 24 Feb 2025 09:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388664; cv=fail; b=SLUgDDdIYm6kZkYWoih/U4SgTP58hV/IL+jBaEhE+L44vKxrzdcI2Eg0A/sD2bZGDq/LUQosVEDxShR0q0XvctiaC2Fa8lGIeqeYn0gGJSA8jDlUmC8QWKioDjpsv8xlei+wNRHZumVP10n/3JlsNV6ZIohS3ben6PS+imW7lAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388664; c=relaxed/simple;
	bh=QVIU8ZQVwEJ2SYofVJT7+zK6AqJFqDg+Ghiesgd3rR4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IpQB11C+exQDFkKu2Z6Wq5orYz1M3wRk0tsdvsujSpiwoJ/teEzYw6LxGfCqEPcsJQWJh5a42ukW9NWmFDxcYzwZtzqiPPKZmqlKBHrY9/K04O9QmW3yZgDfPVVjcnXTIKngXSQlf3XurwxJNyBbaNXRHmWGGw6F6Ecm0lJnhAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V+52gSzq; arc=fail smtp.client-ip=40.107.102.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V+52gSzq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A8ob23L1v0b95jwWN6sJOqrPPZBzSILYlEsgxZ9Pc6aOrrQb9HHa7o8hhl6/qQZ3wmqC4Ub2bNhDEqiqmS7nBKqmUSF4jBZQZsICnlTzsjK5u/pa9GmgcuyGlEgUiywDoywwv2ToGLOuuUK44Q/DgE3yj91KRY2zK9NCNIagIXz4gDji93/VCgkmz3y5B6Tw1aFoN76/t8NazfBE6fPwL0RV+ESsdpT62RaKfMq6NH9qLw3I1P1XybkQzW63JCFVd5Z4cSWVs126AAAv3AXNAx2wuN9whSsGRJvDu3BSpdDRbJ3Tww9mghtkDTSiShnkSTfIN9zNouX5Frssn4hZPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfPPImK93HA+wWqmE1Ne8rO+ehd7fzo7dbpyKwQmxO8=;
 b=FBVP2C/biKEzsa99/ULPbS5KeYiZqsUva1dNJO9G2EFFrSbk4JtPdD9AbEsgKjNhxqaj50CvRKVogLCPhTdDy2zCG5xME8KuMmwbdTBYsgwmqD8SbSTmcJjkZW84xDmRBXxGRHeNI/QMc+F1DnAx2zlUxx3DrN7/sCzF1MsPq6rw25EXdDG8iplZwf0N0StvS3FgzeAof5g8/VHY/Rh6tb82IFROsM18vk8DLqeJaMBAyE7IQn/GJb0wJBiCitbBNKDqMUGkKQWyLX5moxgJhjZFjiisyIriLDpqEaYojYrjwxheyBcVbXMuQ7CAamHdSThRtx4+sdaFzU4ODuL1Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfPPImK93HA+wWqmE1Ne8rO+ehd7fzo7dbpyKwQmxO8=;
 b=V+52gSzqUpu80R6FgclePsrG2IxrJRQHcVh3DI/ocrdKJaU5HL/wvE1QGSXsrvCEiuaXaEX5o5MwUsKuP8Cd61reEaV3ws6OT/udDe3eUQzaB4gEcOJqzGKoiLAi7rOIT6ws22VWuEpNs58ogStYiP1orZKoxUomKGVLr5UWw70CIJS74sZ3t3y6LwmOq4Irm+2X2oOscKK7fpL2xtGYlXzHQJpbtrvn3WqNwVTlBlNoi9BzJxWg0Y64L/+ChJOqdBN0jAGmVPfUpslomQkaeeCWE0g3rS1eYQkFuLgTu9jkGCvQna3pVAOPqkbvNqAksObtBtwOQ9+MzI3zA0xCeQ==
Received: from BLAPR03CA0043.namprd03.prod.outlook.com (2603:10b6:208:32d::18)
 by BL3PR12MB6644.namprd12.prod.outlook.com (2603:10b6:208:3b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Mon, 24 Feb
 2025 09:17:31 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:208:32d:cafe::3d) by BLAPR03CA0043.outlook.office365.com
 (2603:10b6:208:32d::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Mon,
 24 Feb 2025 09:17:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Mon, 24 Feb 2025 09:17:30 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 01:17:11 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 01:17:11 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 01:17:08 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v3 03/10] crypto: tegra: finalize crypto req on error
Date: Mon, 24 Feb 2025 14:46:03 +0530
Message-ID: <20250224091610.49683-4-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|BL3PR12MB6644:EE_
X-MS-Office365-Filtering-Correlation-Id: d544f421-cfab-4c75-2951-08dd54b410a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WFbJPgkWXCM0nhP3oP1JeZ7D//Rt/FXd6mjRwhqClyRCmMvyBeqenHVO2FqX?=
 =?us-ascii?Q?8hePt5YU0hcFpypi4VyXd39j5QUxVh3gkE3kYnvHNCyvdSwXjd0YEUTym++Z?=
 =?us-ascii?Q?BFOfykwHooFfwmc65GaL+IbvD/IoR5UkhITfn0apb7aLUo27NVaX/u7202la?=
 =?us-ascii?Q?Q64bGg1x+5Gnj4tukIX1V2IvEJJNH5P5t/ZVBU+ufOmsIik6XX0wXFtwI5iZ?=
 =?us-ascii?Q?N8nf2YkjVk3J6fsnb5RkpRIII1sEqGAVYe35UHo+CSufSxqkreHnwro+TZjd?=
 =?us-ascii?Q?RLWKqWc2LiDV1i6XcsY5aawxBjMTLxp2XiBLEvo+e1qFZ3XQDeUq8/2pwFmY?=
 =?us-ascii?Q?ZYhVCfNtlc2dPt5gItb4V/MtJKFkSpNMi6YojSngHBsGKuT9a8AiQLNkqKAN?=
 =?us-ascii?Q?1k5sNoyKJEFgt5hK+6Ce5DzkDEaALResx7pe64jMrXPUuG01KxAEaRzDbI2D?=
 =?us-ascii?Q?6kOYfw3yrsIh+cVILxJLtG42PFjoYd6TlBtwouyGezmriWr6d3fYeLaT+SVH?=
 =?us-ascii?Q?99hiIW9x7E9ngM4OYMh1juB5xctaTI3AuGwfFwN0V632oR1M0Euocz9nhLci?=
 =?us-ascii?Q?T9mLpEYJNkbj7jDvAbumfRtw8MtjlqeEZcMDujKsRi8EFqL++h0nZ+GVAXaF?=
 =?us-ascii?Q?4vQDenudBf50UVqtSaoS5QyMo1sjhmQIC5ebBuCB7lcvUjv9zM8bQ1ja0IhR?=
 =?us-ascii?Q?DOo0/TutWrtMzde7Ly9sl9pWnnwMF2S3yZKx1Ip40Gts1pzRVV20xh02Gzjz?=
 =?us-ascii?Q?UL/lCzvvfGcd9T2PcEEHwDrvnSJOf15Qvn5jdsH2UlgI/v+wGZfrI+wXFftj?=
 =?us-ascii?Q?gHNVnj7uqg5Ag6Y6dYWxcsievFbnjbTXuSmF/Hyh6+w3Ddgh5yhKP9NuWjyl?=
 =?us-ascii?Q?fG3wJhwIduLwV+V17A9s5t/QkZgX47798mHhaI615tHzOoDyeEaPXf9qC8fS?=
 =?us-ascii?Q?wMJ5DVQWdEw7qdDKrx/0hdWF1cw5xdJkUl5ukrDgAlhFtI3vhEFMEUqO0WKg?=
 =?us-ascii?Q?/2tS2zxnqTFXyuL3Y6H0oW1AFRxtAO/4z0WH8M/7z9r/bqr0+NYYS/BBkrYf?=
 =?us-ascii?Q?TNgidcuO3pSYdiP8Ruo9uLvG+KLVYgqPhxAd5ziimDqzF/DHN22fJChx2IAR?=
 =?us-ascii?Q?5H5XJmVnW38wNQppihGxnb/3ayUzq22QojFCmE44YPY8LtwvIqY7y8T8WcFB?=
 =?us-ascii?Q?mSIhedeaz6rpdsGmhtjgw236iMOxY+2xd6cEH7M3+smhj3KSQ4b3usBexTRr?=
 =?us-ascii?Q?x0gPgfXZXuANnR3bUSOwkUejSyAZ2UDtmMSwhpb5bJR6GTpF3HMEPJmVO7tg?=
 =?us-ascii?Q?f9+OsEvy5KM1W/ti/Ww5Nrfmf3FmioWq2n316Vh1171KYVMqk17lTuaPDZmA?=
 =?us-ascii?Q?LzbRBK0t/4W2BCkKE4jMuw5PO0b8i8MY22v9ylFsHmXdzqq7yVDIL1NlRStH?=
 =?us-ascii?Q?TnAyPPwtHAxT/Rnu8nIBi1FnYgIMeLmHQu50PdNuaPA12bI79W5DlZM4gPJP?=
 =?us-ascii?Q?FUhkUkydFPoTlw4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 09:17:30.4684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d544f421-cfab-4c75-2951-08dd54b410a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6644

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


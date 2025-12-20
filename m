Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010059.outbound.protection.outlook.com [52.101.193.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F1E2C11ED;
	Sat, 20 Dec 2025 15:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246382; cv=fail; b=oTC41dXvW5wgJCvntDLLXZbZm3H0f1r/kbe+wnX13QQxM3PQ4EpBwRiYJOG5ysbtlw2n5zhqxp9ky68PBhiqYUTcYxffEbyu/nD+LxysKpjQVwsuMtj9dqQk1rb5/7NSigGR7iCfq+x+eTuXag8kwEnlWCvsRjo6ynvwYO+Th6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246382; c=relaxed/simple;
	bh=10kRaqs2fsS/WiDUyhRcsgNgohjatwuylhvtEbwbWU0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HO/1r+8dBHC/ZVQrBPOq4AC8KAymBtd6U6B5hbSsXNdJV8n565BpWKOYBBtNffzAkovMjs+8WWjjq9X1Y1HeqCQfiN/2N8ylM01Okp7fVu5OYR3b0HEm7uXlsfC1q5yP1tmM6FR+oBNYAWqPZ56/fvszF/fKCrzvR22a3ExKJIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d3/sD1Oi; arc=fail smtp.client-ip=52.101.193.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d3/sD1Oi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QuyKXt9VdF0dVnz+TkbrRMwppo/QUQVYTmlLKakZNPBfes9aax2MJtzZEk31ANI7cyOmtAE45E76Zwml3HaoNZLnRsKICUb8Ie5ILfdxF06BRlb3wHxpTWQPBGoFWBDIoyHqtetvQmQkfiGqbSMf3oB6VkxhMVnaxI7YC/bwvFU4mpTtdXQ7/CzHJturIzv6IOugkAnNz7sU59UrCD7OmwlvxroU1MEvsegyQuNdo/E+0/Vek6I4BGVBwZsbNXruZ8nQiQzvTPQloiQn/vZiiEugMHxLhG7V/fTV2/wwn8J5h8A94xaYDri4YtpkFaqjsrXN0KGZrS8PPUAOIPNJqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NWMNnbEGzYOm1zfhzgwhb54fQbaXZ1zvEy/txL90oDQ=;
 b=KOvWef0GQY/+YdbimMMecYynds5oh/GTpjCgi+OGb2ok5Vtx/EZpAv2IR5YhnuOcO/G6nlClfEf0di6JdqEKHv78PNVdcLt3UfWhONV5A1lJN64V8c6bioUyYp4YecVRo92SvJYDEu3z1Zs5N2ZGa8Vds1GQtEe/1Fyf/3NqaOqO4UItusGpvkJlCO/CCpBBVRZp5md9jilyX0BBg5MMiNhN0+00yw+8kJgdh1BKPqt2qPiV3vrqVHQyYgwo0wBxFSfMSK1v51QgdR/pKjeuOdVsXE7BepR5PyR0/Ocz7zZIVe/WYMMJYfnnNqDPuMch++jMSTh4Te4ICWIMFIJ8Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWMNnbEGzYOm1zfhzgwhb54fQbaXZ1zvEy/txL90oDQ=;
 b=d3/sD1OiFTkci172wh9adA+aqesWND8G5KnBSkDEOCc3R2PgRNZHcnQqxcSglymuIJyOpodSDLuvU2Z5XNv8Cy5a58Z5WH5LrSJBMP36jNlZN6clo1/+UZlf15m4oWArtfKw2YjU+10p4I9f2Xu2XDqVNMl6pKu75NaQY7IrSWY=
Received: from SA0PR13CA0003.namprd13.prod.outlook.com (2603:10b6:806:130::8)
 by DS0PR12MB8069.namprd12.prod.outlook.com (2603:10b6:8:f0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.9; Sat, 20 Dec 2025 15:59:36 +0000
Received: from SA2PEPF00003F61.namprd04.prod.outlook.com
 (2603:10b6:806:130:cafe::f4) by SA0PR13CA0003.outlook.office365.com
 (2603:10b6:806:130::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9456.8 via Frontend Transport; Sat,
 20 Dec 2025 15:59:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F61.mail.protection.outlook.com (10.167.248.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Sat, 20 Dec 2025 15:59:36 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:35 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:35 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sat, 20 Dec 2025 07:59:32 -0800
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 05/14] crypto: zynqmp-aes-gcm: Update probe to self discover the device
Date: Sat, 20 Dec 2025 21:28:56 +0530
Message-ID: <20251220155905.346790-6-h.jain@amd.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251220155905.346790-1-h.jain@amd.com>
References: <20251220155905.346790-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F61:EE_|DS0PR12MB8069:EE_
X-MS-Office365-Filtering-Correlation-Id: 03256c83-5f2c-4fc4-c682-08de3fe0c633
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Swj5Bv3Jirqm46HYWUNcduIgYtzvKBeiRe4uZo3fk5ND3g96xR0Pur6RiKra?=
 =?us-ascii?Q?fKGgHGmNpdEukLGlpewFP6IMe1NGlLE6kg4H5Q51PkjYHanXBJ8Y7Tjk9Jao?=
 =?us-ascii?Q?uJpE1CuMO9wOOIrCZkAVcXw38cu87Y/tKq/leGPncdLnPeCG0Q1bf8oahAmd?=
 =?us-ascii?Q?hSLCi0uHzqi4k5jiGe9xXGKT754UVc6PQh/Wh3qf1CavzJIdVRwlIPdytXaU?=
 =?us-ascii?Q?+idFsbDxIQp8DHbvH4R4astcTNWWLp2S3eo+Sa/6cGEpTxW7Q0qr6J63GhYv?=
 =?us-ascii?Q?fx6/e50KqOw8lv28e4vGY6VBCVOcNiQM7IbmBuYQRtN9bX1TmxPueRgY4/mu?=
 =?us-ascii?Q?+iZvF5QkQQF8XKKz2MQON+8wv7XdtdjmMOGG0hE8OISUkV90xWbWX1EDVqq6?=
 =?us-ascii?Q?KEGobxLNdqef9BxJy264aXWflRvZI1h3lPzodgpYxmUk92SAoQwwbmL7zHp8?=
 =?us-ascii?Q?73az1MyhHyy9Xdajfvd22N6tYUub3sB0TlI04ZwD+KX5bVEx/Kct2kE/BJtl?=
 =?us-ascii?Q?O0J8R+b7kxd/FAPd3w7BQGIKyEWYEkV5DgEYFaduOaYD93LlW+Nem87zUwg2?=
 =?us-ascii?Q?ulCYH3OhZ+a8TEWe9ECkeXy7QqljTAEQ3OxECVTJ1pOaGdxKHzPIaBNzJTW3?=
 =?us-ascii?Q?435FKlOWtmjkIRWzE3f56wGOoznjjsN0PQPJu31w2+fQ+FXjGUqWs9Tb/MhC?=
 =?us-ascii?Q?LfbiXUwapFGU/29sbTTa8DJTWCV4q0HJ2Y9gQzNkw1uP5nIZqfHQ8215bhIl?=
 =?us-ascii?Q?OKK0Z9UstP6IRC4ouOjm2puidOdiNqykjnBtsEh4643b5opp6nyssqf6SL6B?=
 =?us-ascii?Q?8Nm/Q+ZdNDxgQJz0MSq4vTd/qCj9pKNi9C7uWlLVhovzPYSyU19lzChC/xmF?=
 =?us-ascii?Q?ZEtCgGyTHbI79izOkItMWvRTeM3xw6E8vr8aa3jQZ3VyjYGHXyU5Kp33TV9+?=
 =?us-ascii?Q?a2xiaUCGfHco10aKtGXEsjSLDpOi+/fHsniKS1ovgPy1W/itXU9cBlLsGEbR?=
 =?us-ascii?Q?Q0kRQqILeVnBdOPj2IVHKl0ls4pu9G6HxvtL7Q16rhfSsXr4nS/lzMb18DoC?=
 =?us-ascii?Q?rrgpoF+weSNU9/tCDGGlhb9+n6h67rFynC3bBjQX2dz9W6ON/qdOnPTZTy6R?=
 =?us-ascii?Q?PSl/lfSaTg/WV9tHWeoL6ROjd/DhgH2IGcyaaxaUlIgzOVO6l0qCyMcsEvzG?=
 =?us-ascii?Q?RkvsQgPA6cplTPRPs0XLvfDJOVgkQF3Hl0Nz7T5vmYJ+liiWBzaT28oPP92C?=
 =?us-ascii?Q?UrB2RYoGNRXep335oVKpJL2MmohsVbCNNhKWkzMVN3cMF2gxB4PG/kpbOdb3?=
 =?us-ascii?Q?nR/hz+dXP1AU1eFWEq082tToMcWXQ+ABS1CLHWuJh/Xa7Dviz0gpkohTSVUg?=
 =?us-ascii?Q?kWIQ5BI5BNTFoxi0z6ZOOsmDEFZ+Nj6ykahackKNrhDC8UVJcfWGMmhq5zaP?=
 =?us-ascii?Q?+PD3LllVLkucgMEgqS4CFjM96SnxUT9aKic6fAt1fec4Ow67LOYmy+68nIe/?=
 =?us-ascii?Q?OKYQcfmHT3fNr7FtAo07T+NgU1+7n4hkh3EYnvnMzGFzpDJ1DBain6dVkTss?=
 =?us-ascii?Q?57B+AY5hHCMNBDUnFExtSUweNQxH087tKU0i12oy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2025 15:59:36.3079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03256c83-5f2c-4fc4-c682-08de3fe0c633
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8069

Update driver to self discover the device.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 86 +++++++++++++++++++-------
 1 file changed, 62 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 3ce1319d1a1a..04473ed9f08d 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -346,7 +346,7 @@ static void zynqmp_aes_aead_exit(struct crypto_aead *aead)
 	memzero_explicit(tfm_ctx, sizeof(struct zynqmp_aead_tfm_ctx));
 }
 
-static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
+static struct zynqmp_aead_drv_ctx zynqmp_aes_drv_ctx = {
 	.aead.base = {
 		.setkey		= zynqmp_aes_aead_setkey,
 		.setauthsize	= zynqmp_aes_aead_setauthsize,
@@ -375,74 +375,112 @@ static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
 	},
 };
 
+static struct xlnx_feature aes_feature_map[] = {
+	{
+		.family = PM_ZYNQMP_FAMILY_CODE,
+		.feature_id = PM_SECURE_AES,
+		.data = &zynqmp_aes_drv_ctx,
+	},
+	{ /* sentinel */ }
+};
+
 static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 {
+	struct zynqmp_aead_drv_ctx *aes_drv_ctx;
 	struct device *dev = &pdev->dev;
 	int err;
 
+	/* Verify the hardware is present */
+	aes_drv_ctx = xlnx_get_crypto_dev_data(aes_feature_map);
+	if (IS_ERR(aes_drv_ctx)) {
+		dev_err(dev, "AES is not supported on the platform\n");
+		return PTR_ERR(aes_drv_ctx);
+	}
+
 	/* ZynqMP AES driver supports only one instance */
-	if (!aes_drv_ctx.dev)
-		aes_drv_ctx.dev = dev;
+	if (!aes_drv_ctx->dev)
+		aes_drv_ctx->dev = dev;
 	else
 		return -ENODEV;
 
+	platform_set_drvdata(pdev, aes_drv_ctx);
 	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(ZYNQMP_DMA_BIT_MASK));
 	if (err < 0) {
 		dev_err(dev, "No usable DMA configuration\n");
 		return err;
 	}
 
-	aes_drv_ctx.engine = crypto_engine_alloc_init(dev, 1);
-	if (!aes_drv_ctx.engine) {
+	aes_drv_ctx->engine = crypto_engine_alloc_init(dev, 1);
+	if (!aes_drv_ctx->engine) {
 		dev_err(dev, "Cannot alloc AES engine\n");
 		err = -ENOMEM;
 		goto err_engine;
 	}
 
-	err = crypto_engine_start(aes_drv_ctx.engine);
+	err = crypto_engine_start(aes_drv_ctx->engine);
 	if (err) {
 		dev_err(dev, "Cannot start AES engine\n");
 		goto err_engine;
 	}
 
-	err = crypto_engine_register_aead(&aes_drv_ctx.aead);
+	err = crypto_engine_register_aead(&aes_drv_ctx->aead);
 	if (err < 0) {
 		dev_err(dev, "Failed to register AEAD alg.\n");
-		goto err_aead;
+		goto err_engine;
 	}
 	return 0;
 
-err_aead:
-	crypto_engine_unregister_aead(&aes_drv_ctx.aead);
-
 err_engine:
-	if (aes_drv_ctx.engine)
-		crypto_engine_exit(aes_drv_ctx.engine);
+	if (aes_drv_ctx->engine)
+		crypto_engine_exit(aes_drv_ctx->engine);
 
 	return err;
 }
 
 static void zynqmp_aes_aead_remove(struct platform_device *pdev)
 {
-	crypto_engine_exit(aes_drv_ctx.engine);
-	crypto_engine_unregister_aead(&aes_drv_ctx.aead);
-}
+	struct zynqmp_aead_drv_ctx *aes_drv_ctx;
 
-static const struct of_device_id zynqmp_aes_dt_ids[] = {
-	{ .compatible = "xlnx,zynqmp-aes" },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, zynqmp_aes_dt_ids);
+	aes_drv_ctx = platform_get_drvdata(pdev);
+	crypto_engine_exit(aes_drv_ctx->engine);
+	crypto_engine_unregister_aead(&aes_drv_ctx->aead);
+}
 
 static struct platform_driver zynqmp_aes_driver = {
 	.probe	= zynqmp_aes_aead_probe,
 	.remove = zynqmp_aes_aead_remove,
 	.driver = {
 		.name		= "zynqmp-aes",
-		.of_match_table = zynqmp_aes_dt_ids,
 	},
 };
 
-module_platform_driver(zynqmp_aes_driver);
-MODULE_DESCRIPTION("Xilinx ZynqMP AES Driver");
+static struct platform_device *platform_dev;
+
+static int __init aes_driver_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&zynqmp_aes_driver);
+	if (ret)
+		return ret;
+
+	platform_dev = platform_device_register_simple(zynqmp_aes_driver.driver.name,
+						       0, NULL, 0);
+	if (IS_ERR(platform_dev)) {
+		ret = PTR_ERR(platform_dev);
+		platform_driver_unregister(&zynqmp_aes_driver);
+	}
+
+	return ret;
+}
+
+static void __exit aes_driver_exit(void)
+{
+	platform_device_unregister(platform_dev);
+	platform_driver_unregister(&zynqmp_aes_driver);
+}
+
+module_init(aes_driver_init);
+module_exit(aes_driver_exit);
+MODULE_DESCRIPTION("zynqmp aes-gcm hardware acceleration support.");
 MODULE_LICENSE("GPL");
-- 
2.49.1


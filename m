Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010046.outbound.protection.outlook.com [52.101.85.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC3E375F9E
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522443; cv=fail; b=SxNtdY/ucTTg+3QnoM5Qgb86HDbMvSqlYcRHvkc+9PPcqyfkRnOX+9UOHHRi7LnSEGUY694NqL8I056mQ0G7JLIJAaR5jNPvLc7Ry9S9wth0YqwzvbQm3y5bQLuE98o3RrschthyomjIEFlMxDEk0zUqenq9+eoSoCInEdlyq/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522443; c=relaxed/simple;
	bh=vMAHSdjqCPiM6q3fjsHx4pWYJ+Mhhts0ZgjczAR5PTk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSsfEwtMkwD59ZZTCGarUr9Q27AnsnIvGp87Q+GGNYC/6UxUo7Ok+ZNat9sBdy4pcUhfeP06gFiatyF2vQ32aLlo3sSVorp4+af8ellHpA1byWzol5rZ/Y7HaX86NkV70gpLOZ4IrU4xLVflt97iQThee7k3mLAIWGlxElh8MVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Gme96Uy; arc=fail smtp.client-ip=52.101.85.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Gme96Uy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ituJ2iUy4Hi1ehmbyUqYCpEhYyldG5TYQP9GFZbaMj4dDpbs39IikoNFbixEPxa5HS7S7WyS3fKZMcG9EcWFGE2CusGizZ9XW9/TyThG2TC4QoMVhBf6aAPd5OWeeKqGzi7rzTcyTAETtnEd2unzGvoox6bGDuWiy2/GYEpThxsl7CtKc+bfIZak8kKP9INzmTUdAwArWaQO4O+TPcQfgFg8C8BZiIHq7/m+H7LwyPERy7KR0JL+m0+CEFeFt/sG0r2FxxJFnmyiwGLN9fNhPpWFgWZuK4fxbJabVIhH/w7gPMsPP1WCXO/48+RubJsbbEFpuel5gphlZ9sPbTk8LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6PbFoxTMZ2NeSDdY4OpFvajrNTXS0bmuhx4Z6lzjtQ=;
 b=RSxXOGWXbzPtSRT2aZGpqckGuyfj52mIe9S+q16cVNvaa9YD8ipDyNYpoDGKyyNqRIdDr0xKGWOWbaa5n4bnP/8f/MVDnjLYtMm4WXPfUjps3jvXz2mVYvvh7oGSncVXq8pWwgmlpmErEylKNn8hjbjOnf2Hf/1dj+GWHgCZnPZSb8uzkQyUJSl0uuOKGp2etpSWL2ZsjsdGVMp+8bYsF8xY01U8PbwHEk7VlQ55j2CL5ZuY6l4at2wr375+yGCK4wTq7h0MK8w7DNHR79OHUztEbRvxruI3ViiMhf5GmD3m2kfMxMyV1a+qVyj8h52kCHGVuDeeuz5l5QWR0i4MzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6PbFoxTMZ2NeSDdY4OpFvajrNTXS0bmuhx4Z6lzjtQ=;
 b=4Gme96UyZYE77yIKSsPWd3W/T7pYEE4Nhva/iLc9aY6hg3mucrzkPUnzUvQuYUJlawAXc+KNqpGrTzIVTa7EUyVlhLPFajmDSnI45o33nJCCvp7mbal1lDFcFSTdRqrD25p7FayfQe8v5uACh4ytunMwju1rYpIvdSW567pvUUM=
Received: from BL1PR13CA0412.namprd13.prod.outlook.com (2603:10b6:208:2c2::27)
 by DS0PR12MB6462.namprd12.prod.outlook.com (2603:10b6:8:c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 07:20:38 +0000
Received: from BN3PEPF0000B36E.namprd21.prod.outlook.com
 (2603:10b6:208:2c2:cafe::53) by BL1PR13CA0412.outlook.office365.com
 (2603:10b6:208:2c2::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.22 via Frontend Transport; Tue,
 3 Mar 2026 07:20:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B36E.mail.protection.outlook.com (10.167.243.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.0 via Frontend Transport; Tue, 3 Mar 2026 07:20:37 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 01:20:37 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 01:20:37 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 3 Mar 2026 01:20:35 -0600
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 1/6] crypto: xilinx: zynamp-sha: Update the driver to make it as self discoverable
Date: Tue, 3 Mar 2026 12:49:48 +0530
Message-ID: <20260303071953.149252-2-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303071953.149252-1-h.jain@amd.com>
References: <20260303071953.149252-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36E:EE_|DS0PR12MB6462:EE_
X-MS-Office365-Filtering-Correlation-Id: 24fa984e-4f52-4f8c-27ba-08de78f55e59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	3E/2RlUte4MAFPsOAU+/p2GihGU8p0K3tcrRGEnKa6MiXlf26L6gnDcxwM8RsFAwQcmys44/coMVTdiMzB7ril58TyUMygZhtsQ7AnK6X3ZgEEamy69/Wbehmm2S1YaRUAbfDjN1cBd7ELuOXTD6hRH5NLExVGvSafts+MszcoQlKx+uomTRAmhdO3Ooj4SBorBft1iRhuopt7+PiIvRoYhCBvClK7i9PSDjKCsnHibqBkaA2XbcFUXAYQ+gAZfU+XfGuFjCxJIKN4lnvbpOgYrbd2Nv3eNRt3TUDgWDikTHnBH9nHq/lAflVC+lkUBMm/BwQAcHkWLfnOw5woxbcF0eefcbesQ6xF09Hw9ZXZfbP4EGuu4hvXkdIDsS2kaja/O95jWYPgdNf1wtEAoDpMDduiyLKtLfimVx/4NOrC4W6pQsBOvpJVK3TmW8VXijT5p6Zz05K4R4ypDioOYWWo4j/sdR785F+L2L8BPZ7LdXym2m3Rm/bx+O3++Ap+icV2t8LkxP7RFLnqygzOa01z3SX5Zzw3zv4l6DDO6TmQABWgIiaeRJpbArDnPuiFtcH8Id6uZP0cOq8mfz9mOT7d4bthduERN9b8fXIAvA7WJ9QX+9lMQ4DX+108v8+Fr8I8AEXt1JYnn7I7AZtH5izIiS8bCeHvLHAmTd6v7vq2KR5ALnOfsy3dAhNNP49hU/empfVNQSx/7jP7JQgwY6LqYlwiH7IswNKPC5HKaXrg0J6aDlSrzp6Su5sBVq/gAre24yvuK6u/lZNND1LkX9BqL8Cti9oXReWo4J1Zp+h588Hu5f0uRIyn5VqgFx5WTRjGjLgCJA4tL/qhvUv0tBow==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	440m1k2Exo+1hqCO1z/fgBKr5Y3ZqDXeu9fX43oapPfZJjqkQl+SX18hYBfApF0+VUcMuDBSHEJSIdZUG7yGr9doSYeoOhMDsyuIxr8KRghvlPGE2k1qYmVjRcHjje8pH4MHpvgH7giJoifY6JRLgqQ0dqrSkARFhi8Yxox8+VfuDBm28oezsT8bjxGf8mAxNx8b/3GmtMx23ENMtZOrJX9AuW2tNUg5C97n4YLgUL7hVMg69DWeYGF9YeTPI8YIGYEUd51Bby4rXwKWy16nHBFDbbe5gyQBewNaeAIMgOcyusVc3GCwSFbBIBmxVoNOFRxOU6faNAMLNUzQmC+WGERNFNth2hiXHTsMgjgKEH9vxojBFCN1WjFerptdQaJQ3EF1jOchqOPqbXKfbdKaip2yJUubzx9zTaz2nxFdFnoxRoZDKVNVwPLcqvYzbo9G
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 07:20:37.7980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24fa984e-4f52-4f8c-27ba-08de78f55e59
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6462

From: Mounika Botcha <mounika.botcha@amd.com>

Update driver to self discover the device.

Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 85 +++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 5813017b6b79..1d6b7f971111 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -162,7 +162,7 @@ static int zynqmp_sha_digest(struct shash_desc *desc, const u8 *data, unsigned i
 		return __zynqmp_sha_digest(desc, data, len, out);
 }
 
-static struct zynqmp_sha_drv_ctx sha3_drv_ctx = {
+static struct zynqmp_sha_drv_ctx zynqmp_sha3_drv_ctx = {
 	.sha3_384 = {
 		.init = zynqmp_sha_init,
 		.update = zynqmp_sha_update,
@@ -185,17 +185,26 @@ static struct zynqmp_sha_drv_ctx sha3_drv_ctx = {
 	}
 };
 
+static struct xlnx_feature sha_feature_map[] = {
+	{
+		.family = PM_ZYNQMP_FAMILY_CODE,
+		.feature_id = PM_SECURE_SHA,
+		.data = &zynqmp_sha3_drv_ctx,
+	},
+};
+
 static int zynqmp_sha_probe(struct platform_device *pdev)
 {
+	struct zynqmp_sha_drv_ctx *sha3_drv_ctx;
 	struct device *dev = &pdev->dev;
 	int err;
-	u32 v;
 
 	/* Verify the hardware is present */
-	err = zynqmp_pm_get_api_version(&v);
-	if (err)
-		return err;
-
+	sha3_drv_ctx = xlnx_get_crypto_dev_data(sha_feature_map);
+	if (IS_ERR(sha3_drv_ctx)) {
+		dev_err(dev, "SHA is not supported on the platform\n");
+		return PTR_ERR(sha3_drv_ctx);
+	}
 
 	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(ZYNQMP_DMA_BIT_MASK));
 	if (err < 0) {
@@ -203,19 +212,13 @@ static int zynqmp_sha_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	err = crypto_register_shash(&sha3_drv_ctx.sha3_384);
-	if (err < 0) {
-		dev_err(dev, "Failed to register shash alg.\n");
-		return err;
-	}
-
-	sha3_drv_ctx.dev = dev;
-	platform_set_drvdata(pdev, &sha3_drv_ctx);
+	sha3_drv_ctx->dev = dev;
+	platform_set_drvdata(pdev, sha3_drv_ctx);
 
 	ubuf = dma_alloc_coherent(dev, ZYNQMP_DMA_ALLOC_FIXED_SIZE, &update_dma_addr, GFP_KERNEL);
 	if (!ubuf) {
 		err = -ENOMEM;
-		goto err_shash;
+		return err;
 	}
 
 	fbuf = dma_alloc_coherent(dev, SHA3_384_DIGEST_SIZE, &final_dma_addr, GFP_KERNEL);
@@ -224,24 +227,30 @@ static int zynqmp_sha_probe(struct platform_device *pdev)
 		goto err_mem;
 	}
 
+	err = crypto_register_shash(&sha3_drv_ctx->sha3_384);
+	if (err < 0) {
+		dev_err(dev, "Failed to register shash alg.\n");
+		goto err_mem1;
+	}
 	return 0;
 
-err_mem:
-	dma_free_coherent(sha3_drv_ctx.dev, ZYNQMP_DMA_ALLOC_FIXED_SIZE, ubuf, update_dma_addr);
+err_mem1:
+	dma_free_coherent(dev, SHA3_384_DIGEST_SIZE, fbuf, final_dma_addr);
 
-err_shash:
-	crypto_unregister_shash(&sha3_drv_ctx.sha3_384);
+err_mem:
+	dma_free_coherent(dev, ZYNQMP_DMA_ALLOC_FIXED_SIZE, ubuf, update_dma_addr);
 
 	return err;
 }
 
 static void zynqmp_sha_remove(struct platform_device *pdev)
 {
-	sha3_drv_ctx.dev = platform_get_drvdata(pdev);
+	struct zynqmp_sha_drv_ctx *sha3_drv_ctx;
 
-	dma_free_coherent(sha3_drv_ctx.dev, ZYNQMP_DMA_ALLOC_FIXED_SIZE, ubuf, update_dma_addr);
-	dma_free_coherent(sha3_drv_ctx.dev, SHA3_384_DIGEST_SIZE, fbuf, final_dma_addr);
-	crypto_unregister_shash(&sha3_drv_ctx.sha3_384);
+	sha3_drv_ctx = platform_get_drvdata(pdev);
+	dma_free_coherent(sha3_drv_ctx->dev, ZYNQMP_DMA_ALLOC_FIXED_SIZE, ubuf, update_dma_addr);
+	dma_free_coherent(sha3_drv_ctx->dev, SHA3_384_DIGEST_SIZE, fbuf, final_dma_addr);
+	crypto_unregister_shash(&sha3_drv_ctx->sha3_384);
 }
 
 static struct platform_driver zynqmp_sha_driver = {
@@ -252,7 +261,35 @@ static struct platform_driver zynqmp_sha_driver = {
 	},
 };
 
-module_platform_driver(zynqmp_sha_driver);
+static struct platform_device *platform_dev;
+
+static int __init sha_driver_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&zynqmp_sha_driver);
+	if (ret)
+		return ret;
+
+	platform_dev = platform_device_register_simple(zynqmp_sha_driver.driver.name,
+						       0, NULL, 0);
+	if (IS_ERR(platform_dev)) {
+		ret = PTR_ERR(platform_dev);
+		platform_driver_unregister(&zynqmp_sha_driver);
+	}
+
+	return ret;
+}
+
+static void __exit sha_driver_exit(void)
+{
+	platform_device_unregister(platform_dev);
+	platform_driver_unregister(&zynqmp_sha_driver);
+}
+
+module_init(sha_driver_init);
+module_exit(sha_driver_exit);
+
 MODULE_DESCRIPTION("ZynqMP SHA3 hardware acceleration support.");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Harsha <harsha.harsha@xilinx.com>");
-- 
2.34.1


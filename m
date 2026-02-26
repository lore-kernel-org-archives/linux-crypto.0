Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011029.outbound.protection.outlook.com [52.101.62.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6672D238F;
	Thu, 26 Feb 2026 12:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110567; cv=fail; b=Od+inYhvx3xeBCexhxVQtn4V/5b+qeCP3ZMv/LF/Tsh9fOjncVfgoZ90G31HunJ5fv13YpQC2WZgLXNMoucTLNX64g9skM7V21nFlLXUoUF35zj0e3+Y8M/3BagsNUD4fR/7Yd/fXGbB+3MDtXUGdbLFahP1xL77s6yxbGEGhpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110567; c=relaxed/simple;
	bh=FOxd+iQ3tjF5gbT7Sku9yEZtPtfSG9jyextzPg84iBs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2yyRrxmSM9evBxgvmOFjKxsGYG5SBrE2JbVBTm8atrFRzXHC4RwxOnCt1QZ6vIBoCM9Gr4DxC+gMZtdmNE4U57s3xyduk91dk665Qq8hzQX+3d1c0V5+LTGJAtJeEvVqJbT4UkgjVlIql6+I7H/yk2UVApPr7S+Wjt2OLK923A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=W7bT1/iX; arc=fail smtp.client-ip=52.101.62.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="W7bT1/iX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gema66TErzPu7Wcs/sK9Lj5o6Nr/NM/voUf7DvpAdo5mlgklGHYzJF4xt3QZkDkf0sIx8SzWEf7l8dZz66PsU7m2wYqM/SbjK3FHNGqYH/9J2aLt4EiByjntbVEZAbv7YhgwJQ4xHGRhoHb//U+WjmTswKYnSmSUXSEl/tZyYvWDmPepSbyznoFR9gBfp8/nDu2Bo2Ppkqosmns/T+iEbilpLWC6ec26Y+dYH5N6VnwTKbubFc9y/Oq2dOS+xoRgsd+SyANXJUbFZ9QOx0BuQmhVCBNXoR7wXx9RgRXZOiWzWF/5qgjYISYf86qEHHwLKvUlNoX+0CbuMO4MSkmlwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSLUlNvoKDlbECKoXQT9E3i4g3zKGxrRKEh+QTHRPEk=;
 b=WA84PXEvkih/ZUI1wGw1cnrI0Q/Q1rZAN7unemiaDtaX9C9+IRksECKpLPFtV8f1/NriHUHjAJvLqUcSXXXN6lOaE/J73MVWFafmqRUFJySbwCUYsIwr1GRy3RIfeNBez5WNGBXYtderHZTXD/YcdJI5nPs3oJ6meQNiXsxQfEtqXib4mVqfgWlGDfhbDPpVZU054zq9IDaNps6xZ0NbYQ+aRWgJ2BrPtJ4YLqb94bHCskXQ9gU2r6vFE2+8gv4UHAOQGI7iXYAsIuK8GrSKTA4CVN2TQu9/+oPHy/NE+TWyyGAYPLLJzKA58SN2wR16XE2X+oEBG1uL4ujM++Dn1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSLUlNvoKDlbECKoXQT9E3i4g3zKGxrRKEh+QTHRPEk=;
 b=W7bT1/iX3Ojc/zIao6W+10qBR5Ne9cjmF1M8sGprxuB0v71ZdXhhBynbOfcQ3AaSKDrGMHQSghK3Nz6FaxTwReg5fQDgvsWbISLOHZdpG/46Z+O1WWK1iOLbe3UmDMS+GuAiVZ00BF2ds45ReumBy1UjaVHbXeuxwiyMWSW9kQo=
Received: from BLAPR03CA0049.namprd03.prod.outlook.com (2603:10b6:208:32d::24)
 by DM4PR10MB7528.namprd10.prod.outlook.com (2603:10b6:8:184::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 12:56:03 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:208:32d:cafe::cc) by BLAPR03CA0049.outlook.office365.com
 (2603:10b6:208:32d::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 12:55:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 26 Feb 2026 12:56:02 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 06:56:01 -0600
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 06:56:01 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 26 Feb 2026 06:56:01 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61QCtxt01898090;
	Thu, 26 Feb 2026 06:56:00 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v10 1/3] crypto: ti - Add support for AES-CTR in DTHEv2 driver
Date: Thu, 26 Feb 2026 18:24:39 +0530
Message-ID: <20260226125441.3559664-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260226125441.3559664-1-t-pratham@ti.com>
References: <20260226125441.3559664-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|DM4PR10MB7528:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e573840-3b95-4443-11f0-08de75366562
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|34020700016|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	O+0xYEW/81NrnyGoB8mq8xIOAi7DPNQiKBQ1k11MOMJZ0EYZMkx/ephXGx2/58AfJqSr5MdK81/GwhYXZ0M2atjEifsmZIwSWj7/ilYdFhMsv9Dgkju3byMeQLKSKQPueNn0afdsppAWCII/hGscuwg6mUc33ySEN5Xnaqvi1V1UAsIK2rRzNTBs/Ys3nPIFeBeYRmS7xq/Vivad53fO3mEpa/L4yXYtz7jHnS0LfzDhKp+55wtTcHjGvMFD3NQF0/aQY7jA2gvppz3ZM4EA9ri2IzQFsvO3U3tF26INmlCYL6HLz3qBqVWhsi2NV6SthRiVhAw27cSehEeKG4ByHU0fQIvUx+UUihXuoEChk8XU4K1zNKQtj05pUTMJwShdZV4GsGITj5oL1S2NORHP12Ph7lNpqPWvKm1PRo2XjBYv/lVpHBwIzL6JQQUT7fgRXq+tn6fjsa9irACJpoeuDRTGBcACEGVxefsKsVbx/9SnITKd+3v8W3OuKRBIpY/7MXmhB1vNP3BxyeUqS+uypjFuKmunRuMTVcM2xLZq8qoseAnLptWc/4HzImmHzyCC8WtxKudzZN4oiM+2Ve9RwptE+x4MHRbBTpOaETyYQFwuIPsymNmEmJ7astrFuZ3LJYpVcuG92eaM8R65jGQsOV1yiIkoLXmZ71j29/a/3vCfM8MotEH9/w6m5jjdqLIGc7Qfe9SEyq2jz5MYSYVrymtNW/yMRluew5Tmn7IXsF7peDPXftaz7iQRIvUYB7ThYPXa4WkWQK2kr52IpTpIuEWGLmQ35mtdN/IA/2Yl8jYScfzzbVMJUWmeLOuBFmNYK+oSLw+zDtVJRImOKzJOVw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(34020700016)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PrtYcirwf0PXCsw28bmd8VDeLvqBnliN29NYZnbP5bOF8zeTyuNrSksh8+r6wDkplnuie0KekXsmhTO/LFnwJgsZOYkhSehF5E58BWc2Q4Ambqffg0S/cfvBbLqsClC03S5M8M4fVZBP3KYb6VaCEzgAYXsGey/lwFQIIyQXiqjq/B4BpCDcnDYMpA/ETrS6RdmVBvzWFPHmRXnpHzylGXvBAtJvh0ng2oExLeRye2vHyKz7mb5QFoGq8KEN38ip8m5s0xA7tIBvbmMEfY6bjtUMdNVB4J49pKVywTfVFAd5IYoF/xL0Gwgx7Tz4xFp730oYg5t6tN9eK7Oy6u80hIJ3/1QyvoONv5rvT4kf8AXlXTopZvd/Uv7IRlg4uRTltX3VhtP9OAPA5e02brRi3Yn8jkAwb9RhU/PGjF6nayiPO5AJdRFqpC8Znsh0S3wo
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 12:56:02.1581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e573840-3b95-4443-11f0-08de75366562
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7528

Add support for CTR mode of operation for AES algorithm in the AES
Engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 173 ++++++++++++++++++++++++------
 drivers/crypto/ti/dthev2-common.c |  19 ++++
 drivers/crypto/ti/dthev2-common.h |  17 +++
 4 files changed, 180 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index a3692ceec49bc..6027e12de279d 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -6,6 +6,7 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ECB
 	select CRYPTO_CBC
+	select CRYPTO_CTR
 	select CRYPTO_XTS
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 156729ccc50ec..bf7d4dcb4cd7d 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -63,6 +63,7 @@
 enum aes_ctrl_mode_masks {
 	AES_CTRL_ECB_MASK = 0x00,
 	AES_CTRL_CBC_MASK = BIT(5),
+	AES_CTRL_CTR_MASK = BIT(6),
 	AES_CTRL_XTS_MASK = BIT(12) | BIT(11),
 };
 
@@ -74,6 +75,8 @@ enum aes_ctrl_mode_masks {
 #define DTHE_AES_CTRL_KEYSIZE_24B		BIT(4)
 #define DTHE_AES_CTRL_KEYSIZE_32B		(BIT(3) | BIT(4))
 
+#define DTHE_AES_CTRL_CTR_WIDTH_128B		(BIT(7) | BIT(8))
+
 #define DTHE_AES_CTRL_SAVE_CTX_SET		BIT(29)
 
 #define DTHE_AES_CTRL_OUTPUT_READY		BIT_MASK(0)
@@ -100,25 +103,27 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	return 0;
 }
 
-static int dthe_cipher_xts_init_tfm(struct crypto_skcipher *tfm)
+static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
-	ctx->skcipher_fb = crypto_alloc_sync_skcipher("xts(aes)", 0,
+	ctx->skcipher_fb = crypto_alloc_sync_skcipher(alg_name, 0,
 						      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->skcipher_fb)) {
-		dev_err(dev_data->dev, "fallback driver xts(aes) couldn't be loaded\n");
+		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+			alg_name);
 		return PTR_ERR(ctx->skcipher_fb);
 	}
 
 	return 0;
 }
 
-static void dthe_cipher_xts_exit_tfm(struct crypto_skcipher *tfm)
+static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
@@ -156,6 +161,24 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 	return dthe_aes_setkey(tfm, key, keylen);
 }
 
+static int dthe_aes_ctr_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret = dthe_aes_setkey(tfm, key, keylen);
+
+	if (ret)
+		return ret;
+
+	ctx->aes_mode = DTHE_AES_CTR;
+
+	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
+				       crypto_skcipher_get_flags(tfm) &
+				       CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+}
+
 static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -171,8 +194,8 @@ static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 
 	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
 	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
-				  crypto_skcipher_get_flags(tfm) &
-				  CRYPTO_TFM_REQ_MASK);
+				       crypto_skcipher_get_flags(tfm) &
+				       CRYPTO_TFM_REQ_MASK);
 
 	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
 }
@@ -236,6 +259,10 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 	case DTHE_AES_CBC:
 		ctrl_val |= AES_CTRL_CBC_MASK;
 		break;
+	case DTHE_AES_CTR:
+		ctrl_val |= AES_CTRL_CTR_MASK;
+		ctrl_val |= DTHE_AES_CTRL_CTR_WIDTH_128B;
+		break;
 	case DTHE_AES_XTS:
 		ctrl_val |= AES_CTRL_XTS_MASK;
 		break;
@@ -251,6 +278,22 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 	writel_relaxed(ctrl_val, aes_base_reg + DTHE_P_AES_CTRL);
 }
 
+static int dthe_aes_do_fallback(struct skcipher_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->skcipher_fb);
+
+	skcipher_request_set_callback(subreq, skcipher_request_flags(req),
+				      req->base.complete, req->base.data);
+	skcipher_request_set_crypt(subreq, req->src, req->dst,
+				   req->cryptlen, req->iv);
+
+	return rctx->enc ? crypto_skcipher_encrypt(subreq) :
+		crypto_skcipher_decrypt(subreq);
+}
+
 static void dthe_aes_dma_in_callback(void *data)
 {
 	struct skcipher_request *req = (struct skcipher_request *)data;
@@ -271,7 +314,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct scatterlist *dst = req->dst;
 
 	int src_nents = sg_nents_for_len(src, len);
-	int dst_nents;
+	int dst_nents = sg_nents_for_len(dst, len);
 
 	int src_mapped_nents;
 	int dst_mapped_nents;
@@ -305,25 +348,62 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 		dst_dir  = DMA_FROM_DEVICE;
 	}
 
+	/*
+	 * CTR mode can operate on any input length, but the hardware
+	 * requires input length to be a multiple of the block size.
+	 * We need to handle the padding in the driver.
+	 */
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+		unsigned int pad_size = AES_BLOCK_SIZE - (req->cryptlen % AES_BLOCK_SIZE);
+		u8 *pad_buf = rctx->padding;
+		struct scatterlist *sg;
+
+		len += pad_size;
+		src_nents++;
+		dst_nents++;
+
+		src = kmalloc_array(src_nents, sizeof(*src), GFP_ATOMIC);
+		if (!src) {
+			ret = -ENOMEM;
+			goto aes_ctr_src_alloc_err;
+		}
+
+		sg_init_table(src, src_nents);
+		sg = dthe_copy_sg(src, req->src, req->cryptlen);
+		memzero_explicit(pad_buf, AES_BLOCK_SIZE);
+		sg_set_buf(sg, pad_buf, pad_size);
+
+		if (diff_dst) {
+			dst = kmalloc_array(dst_nents, sizeof(*dst), GFP_ATOMIC);
+			if (!dst) {
+				ret = -ENOMEM;
+				goto aes_ctr_dst_alloc_err;
+			}
+
+			sg_init_table(dst, dst_nents);
+			sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
+			sg_set_buf(sg, pad_buf, pad_size);
+		} else {
+			dst = src;
+		}
+	}
+
 	tx_dev = dmaengine_get_dma_device(dev_data->dma_aes_tx);
 	rx_dev = dmaengine_get_dma_device(dev_data->dma_aes_rx);
 
 	src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 	if (src_mapped_nents == 0) {
 		ret = -EINVAL;
-		goto aes_err;
+		goto aes_map_src_err;
 	}
 
 	if (!diff_dst) {
-		dst_nents = src_nents;
 		dst_mapped_nents = src_mapped_nents;
 	} else {
-		dst_nents = sg_nents_for_len(dst, len);
 		dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 		if (dst_mapped_nents == 0) {
-			dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 			ret = -EINVAL;
-			goto aes_err;
+			goto aes_map_dst_err;
 		}
 	}
 
@@ -353,8 +433,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	else
 		dthe_aes_set_ctrl_key(ctx, rctx, (u32 *)req->iv);
 
-	writel_relaxed(lower_32_bits(req->cryptlen), aes_base_reg + DTHE_P_AES_C_LENGTH_0);
-	writel_relaxed(upper_32_bits(req->cryptlen), aes_base_reg + DTHE_P_AES_C_LENGTH_1);
+	writel_relaxed(lower_32_bits(len), aes_base_reg + DTHE_P_AES_C_LENGTH_0);
+	writel_relaxed(upper_32_bits(len), aes_base_reg + DTHE_P_AES_C_LENGTH_1);
 
 	dmaengine_submit(desc_in);
 	dmaengine_submit(desc_out);
@@ -386,11 +466,26 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	}
 
 aes_prep_err:
-	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 	if (dst_dir != DMA_BIDIRECTIONAL)
 		dma_unmap_sg(rx_dev, dst, dst_nents, dst_dir);
+aes_map_dst_err:
+	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+
+aes_map_src_err:
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+		if (diff_dst)
+			kfree(dst);
+aes_ctr_dst_alloc_err:
+		kfree(src);
+aes_ctr_src_alloc_err:
+		/*
+		 * Fallback to software if ENOMEM
+		 */
+		if (ret == -ENOMEM)
+			ret = dthe_aes_do_fallback(req);
+	}
 
-aes_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
@@ -400,7 +495,6 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct crypto_engine *engine;
 
@@ -408,20 +502,14 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 	 * If data is not a multiple of AES_BLOCK_SIZE:
 	 * - need to return -EINVAL for ECB, CBC as they are block ciphers
 	 * - need to fallback to software as H/W doesn't support Ciphertext Stealing for XTS
+	 * - do nothing for CTR
 	 */
 	if (req->cryptlen % AES_BLOCK_SIZE) {
-		if (ctx->aes_mode == DTHE_AES_XTS) {
-			SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->skcipher_fb);
-
-			skcipher_request_set_callback(subreq, skcipher_request_flags(req),
-						      req->base.complete, req->base.data);
-			skcipher_request_set_crypt(subreq, req->src, req->dst,
-						   req->cryptlen, req->iv);
+		if (ctx->aes_mode == DTHE_AES_XTS)
+			return dthe_aes_do_fallback(req);
 
-			return rctx->enc ? crypto_skcipher_encrypt(subreq) :
-				crypto_skcipher_decrypt(subreq);
-		}
-		return -EINVAL;
+		if (ctx->aes_mode != DTHE_AES_CTR)
+			return -EINVAL;
 	}
 
 	/*
@@ -501,8 +589,33 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		.op.do_one_request = dthe_aes_run,
 	}, /* CBC AES */
 	{
-		.base.init			= dthe_cipher_xts_init_tfm,
-		.base.exit			= dthe_cipher_xts_exit_tfm,
+		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.exit			= dthe_cipher_exit_tfm,
+		.base.setkey			= dthe_aes_ctr_setkey,
+		.base.encrypt			= dthe_aes_encrypt,
+		.base.decrypt			= dthe_aes_decrypt,
+		.base.min_keysize		= AES_MIN_KEY_SIZE,
+		.base.max_keysize		= AES_MAX_KEY_SIZE,
+		.base.ivsize			= AES_IV_SIZE,
+		.base.chunksize			= AES_BLOCK_SIZE,
+		.base.base = {
+			.cra_name		= "ctr(aes)",
+			.cra_driver_name	= "ctr-aes-dthev2",
+			.cra_priority		= 299,
+			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_module		= THIS_MODULE,
+		},
+		.op.do_one_request = dthe_aes_run,
+	}, /* CTR AES */
+	{
+		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_xts_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index c39d37933b9ee..a2ad79bec105a 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -48,6 +48,25 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 	return dev_data;
 }
 
+struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
+				 struct scatterlist *src,
+				 int buflen)
+{
+	struct scatterlist *from_sg, *to_sg;
+	int sglen;
+
+	for (to_sg = dst, from_sg = src; buflen && from_sg; buflen -= sglen) {
+		sglen = from_sg->length;
+		if (sglen > buflen)
+			sglen = buflen;
+		sg_set_buf(to_sg, sg_virt(from_sg), sglen);
+		from_sg = sg_next(from_sg);
+		to_sg = sg_next(to_sg);
+	}
+
+	return to_sg;
+}
+
 static int dthe_dma_init(struct dthe_data *dev_data)
 {
 	int ret;
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index c7a06a4c353ff..5239ee93c9442 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -36,6 +36,7 @@
 enum dthe_aes_mode {
 	DTHE_AES_ECB = 0,
 	DTHE_AES_CBC,
+	DTHE_AES_CTR,
 	DTHE_AES_XTS,
 };
 
@@ -92,10 +93,12 @@ struct dthe_tfm_ctx {
 /**
  * struct dthe_aes_req_ctx - AES engine req ctx struct
  * @enc: flag indicating encryption or decryption operation
+ * @padding: padding buffer for handling unaligned data
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
  */
 struct dthe_aes_req_ctx {
 	int enc;
+	u8 padding[AES_BLOCK_SIZE];
 	struct completion aes_compl;
 };
 
@@ -103,6 +106,20 @@ struct dthe_aes_req_ctx {
 
 struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
 
+/**
+ * dthe_copy_sg - Copy sg entries from src to dst
+ * @dst: Destination sg to be filled
+ * @src: Source sg to be copied from
+ * @buflen: Number of bytes to be copied
+ *
+ * Description:
+ *   Copy buflen bytes of data from src to dst.
+ *
+ **/
+struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
+				 struct scatterlist *src,
+				 int buflen);
+
 int dthe_register_aes_algs(void);
 void dthe_unregister_aes_algs(void);
 
-- 
2.34.1


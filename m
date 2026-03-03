Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012004.outbound.protection.outlook.com [52.101.43.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D46738643B
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522451; cv=fail; b=IxFBjkPr3BppPk2mR1mM2Cpsjk6YnJa8zA0z8/8R34nRnx2rPz0GnW3bJNelIVlrz+6tIQWcqXW3woDQquYsKrhsSNPZA7XZ/7J748VgsOlxqbigwi63sTxx6kOsfFbY0sa+axC2fejgcXJIH/q9PqVd/CS0TC8JgsAISuzs+rI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522451; c=relaxed/simple;
	bh=NYOo7463AV9snGGm+8sq7o8jCXvZDDSbuHLpWEr/a78=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gSVBfF7URYovZI/ZOj82oT/pRCI/ulOVSscHJeyljdacIZ3jgOsxCVWi2G35kw3k9Tc0eHLdCoeGBaphsTdfTxLE5PznmKmAjeHA8+Mp83SW9t9SDsdqpkMAeMsuCvi7nR3+xIXeQa68m1QsuTZTJlaj9Yr9LOqNFF2to0Tmxzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rpLAAFUm; arc=fail smtp.client-ip=52.101.43.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rpLAAFUm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d1530tJV5pO/UqdN8UbBXSelhlyEL/JIiIEsz7246U2c8C91kmI8YZ9w6l6t6Ow/HifBMN/slgERY9BNGTNfg8fYDlhmR4TXIjP2PURMegdoW5qxePw4WAMDgVglC9f4R5SVrm+tA74ZXngh/ZzZWnilqZg0qa6Vxgrm51F3YIGaS114Z6htoS5+pOHLsLbvq8xi+yLRG4B8ILNs5gejctKVHKFMOcg1sb/KlOIs4o+1gm7CeMJ4WehrYkDBNAox2oMN+bDkBnDrHcVOxymJq1nVMs+kUz/I36zZhJnkxmLF1KUpVVzieWUBHL6dfv2lh9FiW1F7iA9ynu6OL0rahg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6fATKdjtVLC8XUq92pEWy6GY+xdcAjZD0OVI0hizjs=;
 b=W/P5IYIpESUr4aHFkGngNf9HBiK+CpyvI7NeMuFWz9FJJ/Jp9UBDBZSZ62/XQVHB62iaVqHDznL4uIINp4iqn/KeuZHBqmDBrkYJBDoESdj+Y4pVigCEe9avpk8zxsNbOB268cqtW8H4cHy/64mPp3oY3XP173XYVah8ayjBIs+hqmfvxWTGPGx53OA9nK8MRH9CDKg3HDbFxhrKyqhX3JlUV8padTEXJrNxSNygEb63eRR3NWTqtK7NaPWMXfv5Nb23+zASuO/aT40JZbWljsNJDDwkLcnsEdnECDmLTeqOne321lFzbrjQBzlA+7mW/wS0PSAv20LIMXMLL7+QuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6fATKdjtVLC8XUq92pEWy6GY+xdcAjZD0OVI0hizjs=;
 b=rpLAAFUmxRmkHDFOYLl1niWvxmIlfP7WRJ6Bxti47P5CrW+r022AscLNlzjlKlXOJsAqWMwmdcUbqfZSLDdFX7VyqkoVTyjVCYcA8S6yY9ylaaGqU9xZDWv4yaQxMvxKo51YVEd2snPfKUPNPUraBnH32GEbPbMzhb6/AB9YZpY=
Received: from BYAPR08CA0007.namprd08.prod.outlook.com (2603:10b6:a03:100::20)
 by IA0PR12MB7626.namprd12.prod.outlook.com (2603:10b6:208:438::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 07:20:42 +0000
Received: from MWH0EPF000C6185.namprd02.prod.outlook.com
 (2603:10b6:a03:100:cafe::f) by BYAPR08CA0007.outlook.office365.com
 (2603:10b6:a03:100::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.18 via Frontend Transport; Tue,
 3 Mar 2026 07:20:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000C6185.mail.protection.outlook.com (10.167.249.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 07:20:41 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 01:20:39 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 01:20:39 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 3 Mar 2026 01:20:37 -0600
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 2/6] crypto: zynqmp-sha: Change algo type from shash to ahash
Date: Tue, 3 Mar 2026 12:49:49 +0530
Message-ID: <20260303071953.149252-3-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6185:EE_|IA0PR12MB7626:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dadfc04-0840-41c4-7b7b-08de78f56085
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|7142099003;
X-Microsoft-Antispam-Message-Info:
	jzm2s0t8YKd3dceWYDF03iOhrPWrx+wylKD0Zsvupo4+Hx9G/HVZXH+oHRPcFNotcVHCqMDW3KQQX2okPieWGD04qHYttLNFpu/NahZYO3wpZ87tMNlP3WNE1pGNR4zjZ/aDnahLFaPAnwSOHEe9B2pplCb6QspQBRiiH6EiOZOjQg2LUZZi5cxjjyAh5OmHh2f+wFSOlFPuRGsCvOZhBI/yqwKEsQ+PBFSsm2QyiVoLeI4KTOJnYJdZwAa7/VxCvhAdF4zG1eXSQxBPB0jCy2T1ply9opmfAe+QZ7VzOo3TavHx0vdcFnR8QXfXLT2o3Z0CfPXPU/Vu+EZ9viHa+KL9as+S6RomEaXUwGwwsD4JF/vDSRg9MRNxdcvCatXfpKoiuDqgVThXSN+9CL+uKcifpMUqwHJJLudcmUluKNZoMK5x5RTrG68lCuXs+JGEUFSUIIvk5g4tf5c5vS+Sxc8teMbKIj4ZBan0phy3/DfvgUg0F2yaxAiqJQ/scEeKHD9erHaN7PI1pydd/Gmito+RfpBE5yV5FXWRC0uL+SFqLKclpgtC6z7Hk4rrZAVT41CVyV8+94LWXAdWcHjlw3oTkbS1Ls0nQNSOWsvUfbFDcH8sfpttCd0KB3LfzeJx/x2xwLHrJ4sFIUfBJB2e0NwfSSWc/QwuT5PoP1BJhh71x8QiYN1nuFo+0F5WHVX6+tqWASeUFHwFypQtgC1sQyNISHFTm1Q2vQH1EwrQRjhC6GcfJHDWECu4SgDMzoX6MItO2NSaij7Xj83UGrQavyEnYcxSUV6duBMDfNeQkIp3aJds7NGZZ57q0vL9VKUN2xgC1Jq6zEyHw+OT7ZDUbQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tYWX6oKjeEBJwAwfwOeE1n6emogFB4K4FQ7jfRYyeaol4fMorR9zY5Vflsl1mY9RYwRTlEXcNj7jUC3ApTPAftb6TAcPjbeQvh0UXWBjtNea9ZhtRvVX7XTrU8IUT1WTvEBlgGm7ZOt3w1QUDMiEgtpjRfyaj4bVWkUn/EZVUz6KW1JDSRWQxgswgTleUPkU8+s/cIHLbE4zXB/+vY7W7vHTap8dpparQI2n4h+fFe+u5JQ89uy6fg6FUtcuH/gcRpwaa+aQ7740wDlwYq3WJlgfs6Qp79qTiIfRZ/v58FcLXSIE2nYucOSzhqBpLkl20EJnxO/pJ92DaNJ5qhf7Xn1imxK1dscdrEEcguIx6o0i3MLpKzRT3rsQKTq/qxJiZUn1P2QS1QjBWs6B2uy+KQ4eUOEvRv582ooDR+KLCRx6ObCERTpM33Kd/OV+bWmd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 07:20:41.3535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dadfc04-0840-41c4-7b7b-08de78f56085
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6185.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7626

descsize in shash type has size limit, For driver which fallback does
not fit in shash type. Change the algo type from shash to ahash.
Also adds crypto engine support to serialize the requests.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 258 +++++++++++++++++++----------
 1 file changed, 171 insertions(+), 87 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 1d6b7f971111..cd951e692dd9 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -2,8 +2,10 @@
 /*
  * Xilinx ZynqMP SHA Driver.
  * Copyright (c) 2022 Xilinx Inc.
+ * Copyright (C) 2022-2026, Advanced Micro Devices, Inc.
  */
 #include <crypto/internal/hash.h>
+#include <crypto/engine.h>
 #include <crypto/sha3.h>
 #include <linux/cacheflush.h>
 #include <linux/cleanup.h>
@@ -14,7 +16,6 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/spinlock.h>
 #include <linux/platform_device.h>
 
 #define ZYNQMP_DMA_BIT_MASK		32U
@@ -27,164 +28,230 @@ enum zynqmp_sha_op {
 };
 
 struct zynqmp_sha_drv_ctx {
-	struct shash_alg sha3_384;
+	struct ahash_engine_alg sha3_384;
+	struct crypto_engine *engine;
 	struct device *dev;
 };
 
 struct zynqmp_sha_tfm_ctx {
 	struct device *dev;
-	struct crypto_shash *fbk_tfm;
+	struct crypto_ahash *fbk_tfm;
+};
+
+struct zynqmp_sha_desc_ctx {
+	struct ahash_request fallback_req;
 };
 
 static dma_addr_t update_dma_addr, final_dma_addr;
 static char *ubuf, *fbuf;
 
-static DEFINE_SPINLOCK(zynqmp_sha_lock);
-
-static int zynqmp_sha_init_tfm(struct crypto_shash *hash)
+static int zynqmp_sha_init_tfm(struct crypto_tfm *tfm)
 {
-	const char *fallback_driver_name = crypto_shash_alg_name(hash);
-	struct zynqmp_sha_tfm_ctx *tfm_ctx = crypto_shash_ctx(hash);
-	struct shash_alg *alg = crypto_shash_alg(hash);
-	struct crypto_shash *fallback_tfm;
+	const char *fallback_driver_name = crypto_tfm_alg_name(tfm);
+	struct zynqmp_sha_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct hash_alg_common *alg = crypto_hash_alg_common(__crypto_ahash_cast(tfm));
+	struct crypto_ahash *fallback_tfm;
 	struct zynqmp_sha_drv_ctx *drv_ctx;
 
-	drv_ctx = container_of(alg, struct zynqmp_sha_drv_ctx, sha3_384);
+	drv_ctx = container_of(alg, struct zynqmp_sha_drv_ctx, sha3_384.base.halg);
 	tfm_ctx->dev = drv_ctx->dev;
 
 	/* Allocate a fallback and abort if it failed. */
-	fallback_tfm = crypto_alloc_shash(fallback_driver_name, 0,
+	fallback_tfm = crypto_alloc_ahash(fallback_driver_name, CRYPTO_ALG_TYPE_SHASH,
 					  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm))
 		return PTR_ERR(fallback_tfm);
 
-	if (crypto_shash_descsize(hash) <
-	    crypto_shash_statesize(tfm_ctx->fbk_tfm)) {
-		crypto_free_shash(fallback_tfm);
-		return -EINVAL;
-	}
-
 	tfm_ctx->fbk_tfm = fallback_tfm;
+	crypto_ahash_set_statesize(__crypto_ahash_cast(tfm),
+				   crypto_ahash_statesize(fallback_tfm));
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 crypto_ahash_reqsize(tfm_ctx->fbk_tfm) +
+				 sizeof(struct zynqmp_sha_desc_ctx));
 
 	return 0;
 }
 
-static void zynqmp_sha_exit_tfm(struct crypto_shash *hash)
+static void zynqmp_sha_exit_tfm(struct crypto_tfm *tfm)
 {
-	struct zynqmp_sha_tfm_ctx *tfm_ctx = crypto_shash_ctx(hash);
+	struct zynqmp_sha_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_shash(tfm_ctx->fbk_tfm);
+	if (tfm_ctx->fbk_tfm) {
+		crypto_free_ahash(tfm_ctx->fbk_tfm);
+		tfm_ctx->fbk_tfm = NULL;
+	}
+
+	memzero_explicit(tfm_ctx, sizeof(struct zynqmp_sha_tfm_ctx));
 }
 
-static int zynqmp_sha_continue(struct shash_desc *desc,
-			       struct shash_desc *fbdesc, int err)
+static int zynqmp_sha_init(struct ahash_request *req)
 {
-	err = err ?: crypto_shash_export(fbdesc, shash_desc_ctx(desc));
-	shash_desc_zero(fbdesc);
-	return err;
+	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
+	dctx->fallback_req.base.flags = req->base.flags &
+		CRYPTO_TFM_REQ_MAY_SLEEP;
+	return crypto_ahash_init(&dctx->fallback_req);
 }
 
-static int zynqmp_sha_init(struct shash_desc *desc)
+static int zynqmp_sha_update(struct ahash_request *req)
 {
-	struct zynqmp_sha_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct crypto_shash *fbtfm = tctx->fbk_tfm;
-	SHASH_DESC_ON_STACK(fbdesc, fbtfm);
-	int err;
+	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
+	dctx->fallback_req.base.flags = req->base.flags &
+		CRYPTO_TFM_REQ_MAY_SLEEP;
+	dctx->fallback_req.nbytes = req->nbytes;
+	dctx->fallback_req.src = req->src;
+	return crypto_ahash_update(&dctx->fallback_req);
+}
 
-	fbdesc->tfm = fbtfm;
-	err = crypto_shash_init(fbdesc);
-	return zynqmp_sha_continue(desc, fbdesc, err);
+static int zynqmp_sha_final(struct ahash_request *req)
+{
+	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
+	dctx->fallback_req.base.flags = req->base.flags &
+		CRYPTO_TFM_REQ_MAY_SLEEP;
+	dctx->fallback_req.result = req->result;
+	return crypto_ahash_final(&dctx->fallback_req);
 }
 
-static int zynqmp_sha_update(struct shash_desc *desc, const u8 *data, unsigned int length)
+static int zynqmp_sha_finup(struct ahash_request *req)
 {
-	struct zynqmp_sha_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct crypto_shash *fbtfm = tctx->fbk_tfm;
-	SHASH_DESC_ON_STACK(fbdesc, fbtfm);
-	int err;
+	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
+	dctx->fallback_req.base.flags = req->base.flags &
+		CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	fbdesc->tfm = fbtfm;
-	err = crypto_shash_import(fbdesc, shash_desc_ctx(desc)) ?:
-	      crypto_shash_update(fbdesc, data, length);
-	return zynqmp_sha_continue(desc, fbdesc, err);
+	dctx->fallback_req.nbytes = req->nbytes;
+	dctx->fallback_req.src = req->src;
+	dctx->fallback_req.result = req->result;
+
+	return crypto_ahash_finup(&dctx->fallback_req);
 }
 
-static int zynqmp_sha_finup(struct shash_desc *desc, const u8 *data, unsigned int length, u8 *out)
+static int zynqmp_sha_import(struct ahash_request *req, const void *in)
 {
-	struct zynqmp_sha_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct crypto_shash *fbtfm = tctx->fbk_tfm;
-	SHASH_DESC_ON_STACK(fbdesc, fbtfm);
+	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
+	dctx->fallback_req.base.flags = req->base.flags &
+		CRYPTO_TFM_REQ_MAY_SLEEP;
+	return crypto_ahash_import(&dctx->fallback_req, in);
+}
 
-	fbdesc->tfm = fbtfm;
-	return crypto_shash_import(fbdesc, shash_desc_ctx(desc)) ?:
-	       crypto_shash_finup(fbdesc, data, length, out);
+static int zynqmp_sha_export(struct ahash_request *req, void *out)
+{
+	struct zynqmp_sha_desc_ctx *dctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct zynqmp_sha_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&dctx->fallback_req, tctx->fbk_tfm);
+	dctx->fallback_req.base.flags = req->base.flags &
+		CRYPTO_TFM_REQ_MAY_SLEEP;
+	return crypto_ahash_export(&dctx->fallback_req, out);
 }
 
-static int __zynqmp_sha_digest(struct shash_desc *desc, const u8 *data,
-			       unsigned int len, u8 *out)
+static int sha_digest(struct ahash_request *req)
 {
-	unsigned int remaining_len = len;
+	struct crypto_tfm *tfm = crypto_ahash_tfm(crypto_ahash_reqtfm(req));
+	struct hash_alg_common *alg = crypto_hash_alg_common(__crypto_ahash_cast(tfm));
+	struct zynqmp_sha_drv_ctx *drv_ctx;
+
+	drv_ctx = container_of(alg, struct zynqmp_sha_drv_ctx, sha3_384.base.halg);
+	return crypto_transfer_hash_request_to_engine(drv_ctx->engine, req);
+}
+
+static int zynqmp_sha_digest(struct ahash_request *req)
+{
+	unsigned int processed = 0;
+	unsigned int remaining_len;
 	int update_size;
 	int ret;
 
+	remaining_len = req->nbytes;
 	ret = zynqmp_pm_sha_hash(0, 0, ZYNQMP_SHA3_INIT);
 	if (ret)
 		return ret;
 
-	while (remaining_len != 0) {
-		memzero_explicit(ubuf, ZYNQMP_DMA_ALLOC_FIXED_SIZE);
-		if (remaining_len >= ZYNQMP_DMA_ALLOC_FIXED_SIZE) {
+	while (remaining_len) {
+		if (remaining_len >= ZYNQMP_DMA_ALLOC_FIXED_SIZE)
 			update_size = ZYNQMP_DMA_ALLOC_FIXED_SIZE;
-			remaining_len -= ZYNQMP_DMA_ALLOC_FIXED_SIZE;
-		} else {
+		else
 			update_size = remaining_len;
-			remaining_len = 0;
-		}
-		memcpy(ubuf, data, update_size);
+		sg_pcopy_to_buffer(req->src, sg_nents(req->src), ubuf, update_size, processed);
 		flush_icache_range((unsigned long)ubuf, (unsigned long)ubuf + update_size);
 		ret = zynqmp_pm_sha_hash(update_dma_addr, update_size, ZYNQMP_SHA3_UPDATE);
 		if (ret)
 			return ret;
 
-		data += update_size;
+		remaining_len -= update_size;
+		processed += update_size;
 	}
 
 	ret = zynqmp_pm_sha_hash(final_dma_addr, SHA3_384_DIGEST_SIZE, ZYNQMP_SHA3_FINAL);
-	memcpy(out, fbuf, SHA3_384_DIGEST_SIZE);
+	memcpy(req->result, fbuf, SHA3_384_DIGEST_SIZE);
 	memzero_explicit(fbuf, SHA3_384_DIGEST_SIZE);
 
 	return ret;
 }
 
-static int zynqmp_sha_digest(struct shash_desc *desc, const u8 *data, unsigned int len, u8 *out)
+static int handle_zynqmp_sha_engine_req(struct crypto_engine *engine, void *req)
 {
-	scoped_guard(spinlock_bh, &zynqmp_sha_lock)
-		return __zynqmp_sha_digest(desc, data, len, out);
+	int err;
+
+	err = zynqmp_sha_digest(req);
+	local_bh_disable();
+	crypto_finalize_hash_request(engine, req, err);
+	local_bh_enable();
+
+	return 0;
 }
 
 static struct zynqmp_sha_drv_ctx zynqmp_sha3_drv_ctx = {
-	.sha3_384 = {
+	.sha3_384.base = {
 		.init = zynqmp_sha_init,
 		.update = zynqmp_sha_update,
+		.final = zynqmp_sha_final,
 		.finup = zynqmp_sha_finup,
-		.digest = zynqmp_sha_digest,
-		.init_tfm = zynqmp_sha_init_tfm,
-		.exit_tfm = zynqmp_sha_exit_tfm,
-		.descsize = SHA3_384_EXPORT_SIZE,
-		.digestsize = SHA3_384_DIGEST_SIZE,
-		.base = {
-			.cra_name = "sha3-384",
-			.cra_driver_name = "zynqmp-sha3-384",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-				     CRYPTO_ALG_NEED_FALLBACK,
-			.cra_blocksize = SHA3_384_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct zynqmp_sha_tfm_ctx),
-			.cra_module = THIS_MODULE,
+		.digest = sha_digest,
+		.export = zynqmp_sha_export,
+		.import = zynqmp_sha_import,
+		.halg = {
+			.digestsize = SHA3_384_DIGEST_SIZE,
+			.statesize = sizeof(struct sha3_state),
+			.base.cra_init = zynqmp_sha_init_tfm,
+			.base.cra_exit = zynqmp_sha_exit_tfm,
+			.base.cra_name = "sha3-384",
+			.base.cra_driver_name = "zynqmp-sha3-384",
+			.base.cra_priority = 300,
+			.base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+				CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
+			.base.cra_blocksize = SHA3_384_BLOCK_SIZE,
+			.base.cra_ctxsize = sizeof(struct zynqmp_sha_tfm_ctx),
+			.base.cra_module = THIS_MODULE,
 		}
-	}
+	},
+	.sha3_384.op = {
+		.do_one_request = handle_zynqmp_sha_engine_req,
+	},
 };
 
+
+
 static struct xlnx_feature sha_feature_map[] = {
 	{
 		.family = PM_ZYNQMP_FAMILY_CODE,
@@ -227,14 +294,30 @@ static int zynqmp_sha_probe(struct platform_device *pdev)
 		goto err_mem;
 	}
 
-	err = crypto_register_shash(&sha3_drv_ctx->sha3_384);
+	sha3_drv_ctx->engine = crypto_engine_alloc_init(dev, 1);
+	if (!sha3_drv_ctx->engine) {
+		dev_err(dev, "Cannot alloc Crypto engine\n");
+		err = -ENOMEM;
+		goto err_engine;
+	}
+
+	err = crypto_engine_start(sha3_drv_ctx->engine);
+	if (err) {
+		dev_err(dev, "Cannot start AES engine\n");
+		goto err_start;
+	}
+
+	err = crypto_engine_register_ahash(&sha3_drv_ctx->sha3_384);
 	if (err < 0) {
-		dev_err(dev, "Failed to register shash alg.\n");
-		goto err_mem1;
+		dev_err(dev, "Failed to register sha3 alg.\n");
+		goto err_start;
 	}
+
 	return 0;
 
-err_mem1:
+err_start:
+	crypto_engine_exit(sha3_drv_ctx->engine);
+err_engine:
 	dma_free_coherent(dev, SHA3_384_DIGEST_SIZE, fbuf, final_dma_addr);
 
 err_mem:
@@ -248,9 +331,10 @@ static void zynqmp_sha_remove(struct platform_device *pdev)
 	struct zynqmp_sha_drv_ctx *sha3_drv_ctx;
 
 	sha3_drv_ctx = platform_get_drvdata(pdev);
+	crypto_engine_unregister_ahash(&sha3_drv_ctx->sha3_384);
+	crypto_engine_exit(sha3_drv_ctx->engine);
 	dma_free_coherent(sha3_drv_ctx->dev, ZYNQMP_DMA_ALLOC_FIXED_SIZE, ubuf, update_dma_addr);
 	dma_free_coherent(sha3_drv_ctx->dev, SHA3_384_DIGEST_SIZE, fbuf, final_dma_addr);
-	crypto_unregister_shash(&sha3_drv_ctx->sha3_384);
 }
 
 static struct platform_driver zynqmp_sha_driver = {
-- 
2.34.1


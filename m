Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010069.outbound.protection.outlook.com [40.93.198.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B990043D50B;
	Tue, 20 Jan 2026 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920277; cv=fail; b=XCBlycu5dSo2iezah8oFGbhf1HSVccVqI8hQWV/fh1cMv6UOONBa+0PW8wO1fkUppjcZHe7+tR4qrK3qgtRP1oPwch7m80Idg2az19jacpTeFc3kIfTpbaOdenUEZZf5nIKFlGUtBVYqDZCHe49bVCbMDqxKrNsBJCzmuwcDnsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920277; c=relaxed/simple;
	bh=j227GCe2n6AEtFVV7qZuZKF5lZ7jZCAwxage7IFq1Ts=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QNMr9AdZ3n9JP+tVnO2tFkIRABz4TqoLLhLPM91U+F8Rw0GW7J9xM3HibowLVZApD7XwH4ik+in5qw3mkUhDNzOIp/lnjitXPostDnnUqeqadhh1i8YXBAr1cAdymdywME5uuR0okD6ogcdnXGECvD9cG0l/TiQOBtE6LsbcPWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=jn3L09QK; arc=fail smtp.client-ip=40.93.198.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="jn3L09QK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yzRMZMe9Jq3nK9aYGQz8pfK+6KMhjz7DZ5Cr0cri6cRqaHsBW3gOVHzHirzyiGStqfXQsSIKIp39uJHKxj9eGpoMOAQVwMrlE3kzyF0J0rCEodVTtW8YV17yPuPcHQo/udoAsqazAIdhGzsGKTwnxtllMALYSVhUJF02gAi0DkL4AKaQlz2kc4Aw0lyTBvolZhIlODKiuq5xtwh+vCya8702ztEROUdq3Xw2aMk1c55PkInSBxauS2vrqLqDAnoyRSZiGstUUJtUX1XvjB2pYESd8dgo+lIqVZOMrBKIt70twILWKx6IIgGCec3wyk66MB5piXu5FZl5JdMHkwc0NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8r3uEX+ISY/4GLECM8KfuMtZzvRCRXYu1FkftA8psg0=;
 b=MbtCO5ZXNZxF2NJCE9QS/EF8lfokXk7u8t1p9sLwPouEuvqwBYusUIBwmYrYQEfIzZPmSDh3JrjwNuCl109yvabp5a2HqJlLYXYQo4AvHiCL40mhPx/Dgx7i2GQyidxd5qEChe9U/hIWcfzcMtVf++7oF8NKL/zrQwFjEC6Yjlea0RECz0WWAuDCKA4HlV2PfERQRvI9lO3FchxluHdAcBMF2CMcRsaUt6JIo0TtWqewior1BwQuEdWFWfdRqS1w04OwpdUtCxcO/ezMJv1BSE4Fy7hDJp4PmsidMf8s1K+DPC6szogl8djDxVqV/ZsnouuYIEBgV1j9RGdV/WZeuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8r3uEX+ISY/4GLECM8KfuMtZzvRCRXYu1FkftA8psg0=;
 b=jn3L09QK0GdfZh11/IOi8iNkglYtfTJje+HmLewLqVwTs8L1ozwQe3o6majvzwW48rspCE73UAgNGATLG0L+i7KEYn8fpIb2zV3SRXuY5SW+H7jYOTqH5CqjxbWOSjbEAxJfWpQRwmVRE574jNoISNZDTSOGflpJNSsvH5Zg4ZA=
Received: from MN0PR02CA0009.namprd02.prod.outlook.com (2603:10b6:208:530::12)
 by PH7PR10MB6967.namprd10.prod.outlook.com (2603:10b6:510:271::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 14:44:29 +0000
Received: from BL02EPF0002992E.namprd02.prod.outlook.com
 (2603:10b6:208:530:cafe::3) by MN0PR02CA0009.outlook.office365.com
 (2603:10b6:208:530::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Tue,
 20 Jan 2026 14:44:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BL02EPF0002992E.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Tue, 20 Jan 2026 14:44:26 +0000
Received: from DFLE207.ent.ti.com (10.64.6.65) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 20 Jan
 2026 08:44:26 -0600
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 20 Jan
 2026 08:44:25 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 20 Jan 2026 08:44:25 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 60KEiOhb1223165;
	Tue, 20 Jan 2026 08:44:25 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v8 1/3] crypto: ti - Add support for AES-CTR in DTHEv2 driver
Date: Tue, 20 Jan 2026 20:14:06 +0530
Message-ID: <20260120144408.606911-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260120144408.606911-1-t-pratham@ti.com>
References: <20260120144408.606911-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992E:EE_|PH7PR10MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c870c2d-fa51-40d7-3dbf-08de583268fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R0cFenrgqhQy+bZFdgsHZgkDoC5jRxGH8FUudXhKflbAawfOCovimQ9zFVhw?=
 =?us-ascii?Q?iRq1NTueL7n0PD1Eyfxa9COZ80F5ZT/AMcWsWecjQx1myIFkBgA6cC9r5ZnL?=
 =?us-ascii?Q?gf63Gafnnw8fT2b49B/2ZOCTaPiqfKWhU77uLA6YoxNp6ewYigJCw90wX5Wl?=
 =?us-ascii?Q?6me05g12ysbFR6V2X6pOIe/+Zc8pFN79irdfzah4Nu21NNEXyieq+CWXgBJ9?=
 =?us-ascii?Q?W1vOZ7+Vjuwn9sY/HMAMYJJ8CXbT9nlp07K8lg94/8585VlVOfOreNICvp2D?=
 =?us-ascii?Q?GXtq/AfXfEhgepbMgrXPlCj2dkS3Z1EyvKZhImwl89tMHQenTzqCH8gb7Wtx?=
 =?us-ascii?Q?uSXuUB4qk9S1Y0R8Wo8N4mzPUH7nej/l8rLbmiRhpBb2FICTp/JK0jX1r64J?=
 =?us-ascii?Q?prm+/wkoZSPiIVFggF1+TS9fZwBQjDupAGDahyyaw9RlXm2IqjsCOs2s2oRW?=
 =?us-ascii?Q?a0mNW/0PUzt7smlvlYOcWxdScBusrwd9X2uheMHeusEUCaGKLhDWBZX+G7FG?=
 =?us-ascii?Q?eb5tNlWTSxlbNFNF2kqwqTkKfCDo5LFkCXI2SPWkWX0QwkRWlc2lhUio+UUt?=
 =?us-ascii?Q?Ma12NySRtUe55ROeMCDjq0rz/XA6XYRi9oWdK1vlROIKNypYgCABn/infgys?=
 =?us-ascii?Q?ELuR/7pZHWXY+5zXgfZJEFHVF1tbmga/MfcJK5ALQ9PYCuGTv2Hs+qPIKVvc?=
 =?us-ascii?Q?t8G2dZRWNY1xPOMmAkfUAjivGZq383k0tF9I+VbtTfsv5/wjPYnfj9S83NI3?=
 =?us-ascii?Q?lKLFnaVjlrq1qfyu0g60+dl2NZMgENUPxDhgOF+GKI6vOe9DDYtj8Mnx6wuc?=
 =?us-ascii?Q?71/R1NYae6edlyGZVDsIWd/lcHB0vLxIEmGX4hGPPYYyMAuuxk2VuKFRMubM?=
 =?us-ascii?Q?hNeMYJ0+B4wsqH+j+/1V8WZaGUqyN/24ykBTq9h0OBKxi3GbL6mJ+QfczUiz?=
 =?us-ascii?Q?ZWdYKau/IgGS9pZmO/6zP578q4M9ZdQXHNQ6RRoBWILPyZplBiwN+DUVv0ZE?=
 =?us-ascii?Q?pjj/Ei5YGjkRUmhJkrXVCmlMVyIqmF5KWwE7RmxMCWkqYriN0qg3FTWY0Nnr?=
 =?us-ascii?Q?QTWo7wmhs4jGtyRfsMiEoFvFxb4zVdEFbddf+GGmP3+KrDZ2URn398hgXtdm?=
 =?us-ascii?Q?3wzT4mGts6v8T0FA777MeRX2Q7Tq2fKwIo7tZpTb3IPuHGaucs3NSe7dUKfS?=
 =?us-ascii?Q?o0WkodtU1IofSb3JWAxlJ1R9FPAsWgUBlpXNNnz4BlRBObVWAobTmOUGdI9c?=
 =?us-ascii?Q?iNPgq0g3A7VEjIR4pZOBm7MRQUHkVw7HF1KgfkoDBD+deztAJF4vZTcefMB/?=
 =?us-ascii?Q?ba4R3CjKT9+WQvk5FNOmikMkjpdpVL/UkEuHq5ATBzu1Md7qx6I4ahT7o/q8?=
 =?us-ascii?Q?dy01fIA6TXKEguUrzPjE1wB/WAWU2ZGaewsypEv9FXXrVU0KArfDmlEPNcsG?=
 =?us-ascii?Q?d80hmsETeF6aqeX77Q+By2x75R8Mz4dyPWwtTp6tDcThaCHNwc6RmegFmQ8G?=
 =?us-ascii?Q?X3BjdNkvBedKmolEJUlt0axA85wE8OJc2MHpQM8qZnqW1vJ2rB3wt/Atjj2z?=
 =?us-ascii?Q?Nu715xp6xSJ/cBA0YjZerN1EWJ90JuYKer64YGzxwPagDV89DmLGrjt+mDvy?=
 =?us-ascii?Q?W0wRYcBPDGlALsIwhdxOUlZr+UEJKh9fXkd8Hrqmgk9aSwZuuogUniBiMeJR?=
 =?us-ascii?Q?/enWgQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 14:44:26.5036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c870c2d-fa51-40d7-3dbf-08de583268fd
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6967

Add support for CTR mode of operation for AES algorithm in the AES
Engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 168 ++++++++++++++++++++++++++----
 drivers/crypto/ti/dthev2-common.h |   3 +
 3 files changed, 153 insertions(+), 19 deletions(-)

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
index 156729ccc50ec..5533805309f08 100644
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
@@ -271,11 +298,14 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct scatterlist *dst = req->dst;
 
 	int src_nents = sg_nents_for_len(src, len);
-	int dst_nents;
+	int dst_nents = sg_nents_for_len(dst, len);
 
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	int src_bkup_len;
+	int dst_bkup_len;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -305,25 +335,61 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 		dst_dir  = DMA_FROM_DEVICE;
 	}
 
+	/*
+	 * CTR mode can operate on any input length, but the hardware
+	 * requires input length to be a multiple of the block size.
+	 * We need to handle the padding in the driver.
+	 */
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+		struct scatterlist *sg;
+		int i = 0;
+		unsigned int curr_len = 0;
+
+		len -= req->cryptlen % AES_BLOCK_SIZE;
+		src_nents = sg_nents_for_len(req->src, len);
+		dst_nents = sg_nents_for_len(req->dst, len);
+
+		/*
+		 * Need to truncate the src and dst to len, else DMA complains.
+		 * Lengths restored at end
+		 */
+		for_each_sg(req->src, sg, src_nents - 1, i) {
+			curr_len += sg->length;
+		}
+		curr_len += sg->length;
+		src_bkup_len = sg->length;
+		sg->length -= curr_len % AES_BLOCK_SIZE;
+
+		if (diff_dst) {
+			curr_len = 0;
+			for_each_sg(req->dst, sg, dst_nents - 1, i) {
+				curr_len += sg->length;
+			}
+			curr_len += sg->length;
+			dst_bkup_len = sg->length;
+			sg->length -= curr_len % AES_BLOCK_SIZE;
+		}
+
+		if (len == 0)
+			goto aes_ctr_partial_block;
+	}
+
 	tx_dev = dmaengine_get_dma_device(dev_data->dma_aes_tx);
 	rx_dev = dmaengine_get_dma_device(dev_data->dma_aes_rx);
 
 	src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 	if (src_mapped_nents == 0) {
 		ret = -EINVAL;
-		goto aes_err;
+		goto aes_ctr_partial_block;
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
 
@@ -353,8 +419,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	else
 		dthe_aes_set_ctrl_key(ctx, rctx, (u32 *)req->iv);
 
-	writel_relaxed(lower_32_bits(req->cryptlen), aes_base_reg + DTHE_P_AES_C_LENGTH_0);
-	writel_relaxed(upper_32_bits(req->cryptlen), aes_base_reg + DTHE_P_AES_C_LENGTH_1);
+	writel_relaxed(lower_32_bits(len), aes_base_reg + DTHE_P_AES_C_LENGTH_0);
+	writel_relaxed(upper_32_bits(len), aes_base_reg + DTHE_P_AES_C_LENGTH_1);
 
 	dmaengine_submit(desc_in);
 	dmaengine_submit(desc_out);
@@ -386,11 +452,48 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	}
 
 aes_prep_err:
-	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 	if (dst_dir != DMA_BIDIRECTIONAL)
 		dma_unmap_sg(rx_dev, dst, dst_nents, dst_dir);
+aes_map_dst_err:
+	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+
+aes_ctr_partial_block:
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+		/*
+		 * Handle the remaining bytes that were not processed by hardware
+		 */
+		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->skcipher_fb);
+		struct scatterlist rem_src;
+		u8 *rem_buf = rctx->padding;
+		unsigned int rem_len = req->cryptlen % AES_BLOCK_SIZE;
+
+		/* Restore original sg lengths */
+		struct scatterlist *sg;
+		int i;
+
+		if (diff_dst) {
+			for_each_sg(req->dst, sg, dst_nents - 1, i);
+			sg->length = dst_bkup_len;
+		}
+		for_each_sg(req->src, sg, src_nents - 1, i);
+		sg->length = src_bkup_len;
+
+		src_nents = sg_nents_for_len(req->src, req->cryptlen);
+		dst_nents = sg_nents_for_len(req->dst, req->cryptlen);
+
+		sg_pcopy_to_buffer(req->src, src_nents, rem_buf, rem_len, len);
+		sg_init_one(&rem_src, rem_buf, rem_len);
+
+		skcipher_request_set_callback(subreq, skcipher_request_flags(req),
+					      req->base.complete, req->base.data);
+		skcipher_request_set_crypt(subreq, &rem_src, &rem_src,
+					   rem_len, req->iv);
+
+		ret = rctx->enc ? crypto_skcipher_encrypt(subreq) :
+			crypto_skcipher_decrypt(subreq);
+		sg_pcopy_from_buffer(req->dst, dst_nents, rem_buf, rem_len, len);
+	}
 
-aes_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
@@ -408,6 +511,7 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 	 * If data is not a multiple of AES_BLOCK_SIZE:
 	 * - need to return -EINVAL for ECB, CBC as they are block ciphers
 	 * - need to fallback to software as H/W doesn't support Ciphertext Stealing for XTS
+	 * - do nothing for CTR
 	 */
 	if (req->cryptlen % AES_BLOCK_SIZE) {
 		if (ctx->aes_mode == DTHE_AES_XTS) {
@@ -421,7 +525,8 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 			return rctx->enc ? crypto_skcipher_encrypt(subreq) :
 				crypto_skcipher_decrypt(subreq);
 		}
-		return -EINVAL;
+		if (ctx->aes_mode != DTHE_AES_CTR)
+			return -EINVAL;
 	}
 
 	/*
@@ -501,8 +606,33 @@ static struct skcipher_engine_alg cipher_algs[] = {
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
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index c7a06a4c353ff..efbcbbb741a14 100644
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
 
-- 
2.34.1


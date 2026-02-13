Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010014.outbound.protection.outlook.com [52.101.56.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A930031D372;
	Fri, 13 Feb 2026 13:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770987767; cv=fail; b=taoU1deD0ZH9/VMAfq/VWBYkfbaQ9YKEA4/qQcwZOhZnXwtl9zzaMs8zBUBvnTrfxI75kpYZs/0FSrpFXR5ZgEpHGQDp0FdHvpD1zqQ1rojDvcmssYPNgERVWc17U1ut/Au5jIyr2ar5aixjGzKkoymHKN/Zx2vLtJQ0/J8TidQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770987767; c=relaxed/simple;
	bh=u0jPLuwEnxS0g/hrLdPD+NVY5iCOCZ+OdUExg+JSHKU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gOsSSgD6bv70odgv9OIpLhB4hLBZTfejUJV9gD4ZOXWypsBQ4dJenlXTIJ4fg4kZxItKdDf08MqLXgzBrIZi1bL+z7LpC2JH6jy9T2eib+4lQvLaU9zCmfpeWOcc2Qs+Ys9OSvtwMaDM8mCtptmGhT6OfeaM/zrsmZ+4faBantk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=bvSlrC4a; arc=fail smtp.client-ip=52.101.56.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="bvSlrC4a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QpXHQ5O51ambL/vxclGkP83L2nvdfSL4FCALY9h3BKRW/iUb1rwfTzTJDJfKgdqjUUGGXXaQavcFqoMLQCyQVIHxVokFcmbsUdJ1QLqhdX5xi+IzMsqPYT4O5kOX+xeEJQEmrKOWrkzMr3b2bvOWI4+P+ZMW0y48Okp7tpLFDvqqR6nIE75Gl4gXHSN9udorEd02F8asKLKLHasEuivSF6ifJDxGec9SqrA2Vs8zofLluUkMDIl67d2SPUmgdxlmTSYZwxu+PqMmZQGDDRMIXm7bR7tWfNyXRAOGI6mwUxHqqPW3GpDqTa0m084C7IYy+D+E881ybE8ggdovMzn4WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jE73LBprdJ4c3c7H0zSJkZWK0AImkhoZcNSbuyJjacg=;
 b=nNrDfu2GA7HYotd2voFtYO2koCP6Hii6jnt3YN0aYg9NQbk0ng7EVYYtD2lKuZ3p8vlrjLOd1YRkMk/XZBkK6Cg6MYJWHnzF2lRBYZXsAmwVxf+x4v9GJFHKJcDOntVCJi0a+csxTr/YzfZRLeFDkZ0aB/Sk4QQ3F1qfh7aPEiPg+VF7NbWEr8R0hGGGST1PfcyqKeglGBhU2Jlw0OsYw9pVMVtFBrkPtinI43MEaNWeSo++SZj4BpedjJUAYihPnIqr4Zgs6gLC5S3gcmSL6GXvLJe+FcSDklZAAPC4yv7BMXZyVi6Qit9k+4gieFuJpkICvpGWApUUgM+5TEeVdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jE73LBprdJ4c3c7H0zSJkZWK0AImkhoZcNSbuyJjacg=;
 b=bvSlrC4aAIIuIGOlTkkDWp/bfnhTWKS5rSNom4mpVddlnCKgX6mo1aHHGjwHsQuB/Q5SuAgcohr/6QjEk0Atv06nes7+HX+sluY1Fy3KXMoWOU367kXouYK4nWQsQMp488yIrUB5XXIOSEG6FdNJ+Gdks2MLVVo75/sPRvWZ28Y=
Received: from BN9PR03CA0355.namprd03.prod.outlook.com (2603:10b6:408:f6::30)
 by CH2PR10MB4296.namprd10.prod.outlook.com (2603:10b6:610:7a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 13:02:43 +0000
Received: from BN2PEPF00004FC0.namprd04.prod.outlook.com
 (2603:10b6:408:f6:cafe::ca) by BN9PR03CA0355.outlook.office365.com
 (2603:10b6:408:f6::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.13 via Frontend Transport; Fri,
 13 Feb 2026 13:02:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN2PEPF00004FC0.mail.protection.outlook.com (10.167.243.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Fri, 13 Feb 2026 13:02:41 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Feb
 2026 07:02:37 -0600
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Feb
 2026 07:02:37 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 13 Feb 2026 07:02:37 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61DD2Z7E781789;
	Fri, 13 Feb 2026 07:02:36 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v9 1/3] crypto: ti - Add support for AES-CTR in DTHEv2 driver
Date: Fri, 13 Feb 2026 18:32:05 +0530
Message-ID: <20260213130207.209336-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260213130207.209336-1-t-pratham@ti.com>
References: <20260213130207.209336-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC0:EE_|CH2PR10MB4296:EE_
X-MS-Office365-Filtering-Correlation-Id: 37370b3c-4827-4e84-6a75-08de6b002c4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fEp3pmtSbxnHT7KiK1eoOTsjY72FOXkPwFjfglmRFFTzECSLWTgGdLLGwXAQ?=
 =?us-ascii?Q?oykI/etDXXNcSJ8NVLp6SdRlxgU5ft9Sq24P6yOQjPyF30ufV28lq1D+Objz?=
 =?us-ascii?Q?8mw6UY5ygG/l54zDzgk2JUD1qj40fSs+ae4eelt2T9kHCWDM33lr6YQ7D7Ah?=
 =?us-ascii?Q?efEU4Ynz5BK1Uy3V6CjclNTAupw0rwOr6duSVOQC2r+6fAPLGaEXjx0DCYAT?=
 =?us-ascii?Q?0LUm9iJnZ1ZvB3tjqrd5D5inNXGqIjYRYlxJpKyybYfh6ubp4m9AqDl6Ry49?=
 =?us-ascii?Q?lgATuhNk/IDmTrm3q6goYiLbt0wewfX3JbdAdYDIDO8dQxmvwwns4tkPVPFQ?=
 =?us-ascii?Q?uUF8xmUufGbCP5a1XDohgNcnOPna00qNDVhH7Gp8VSpHjjVJ+umwfQEyqHyo?=
 =?us-ascii?Q?5648TCUCPkJs/ehMWxC37f/YWN3h6GtDDoK9GjoSCdssqYwZThZ1tsN8sjwa?=
 =?us-ascii?Q?6opBcSzlExhXmX99AvUqVYrf+Jt4rQQgQb7HV1+dBOlEG2ACmf8E688SujTF?=
 =?us-ascii?Q?jM7tZsE34U8H0nbyxfRoOgokze1RI60oTcippBS2g8Gp1NU7NDDuKQXxv4pR?=
 =?us-ascii?Q?jBGtYzq5cIdyAKHGOOScFoAaVwqtlGFzuGgemqXOFYOzvubFCrU/07Dd11Tu?=
 =?us-ascii?Q?wEaegeQ4zDP661ikLP7pCnKU3LBWvlMg7Mu8ZZJIHAb93bmPits0ayi8NnSW?=
 =?us-ascii?Q?qSK9akCZB34Voij3YDsHdUXGmJmVCO9l2abBv7ECGtpxSA/GMHq3Ht8GZiPO?=
 =?us-ascii?Q?CpLlTjCHIiS/RyEUbp9cPYgu9IwKaHmPInZO0Y2oR/PFS/baUWCbnbeayEpJ?=
 =?us-ascii?Q?eaOyv3E3hg3eWNxDvxMj4kSqfzPAq5ezatQmYNZNDgNYWhUvjxnYBdhn3pMh?=
 =?us-ascii?Q?8F0dTtANHBPl8CKd4dk8onWBPV3V3i8S8CrBp8nGrx/Nu2d/V9Yl5mxzLskt?=
 =?us-ascii?Q?w3jcS4tT9HUw+CvNdMhGZufdYwGnTO60BDPOUCc98w5dfo6ssa5xEJTOQ3jp?=
 =?us-ascii?Q?IRaQ7hkWxQFJ950S5yZaMc98bUkuQKe8eKukGwZahiu5eqg8cdsA+/SeJvON?=
 =?us-ascii?Q?SWwjIi0sokCu7arDV6sra8OGEDpw3HctjdiQVS1VFpfT9pceQIOpB5AVk8Ql?=
 =?us-ascii?Q?Fzjf+UqEIdf3f1inutIMy+jh0v9fMB/3tlyEDUljFMlMAgGFeqG6GSmEoIEr?=
 =?us-ascii?Q?/geJIVWxeZTpUaTI/nskvCj7oUbw8JoeEkPvPlVVaFytPVpSDTPhNDjtZnrh?=
 =?us-ascii?Q?b89D15Ciz9dvwkED4/9YReFMTCAVQmQBN4tDnbRgNv702gpDyiTtq8Lq+l0j?=
 =?us-ascii?Q?4jz/F6uDg7NFQbaG8AfVqXUYDey2ncpWDw4ldMNZvejZ5pigr6CC18neDyoo?=
 =?us-ascii?Q?ZWtPJMrrgpG8j0c/TDcDCGPL2eAD7QUANeVXf5A6OW69kzExTEfmThyV8hNy?=
 =?us-ascii?Q?+5eU3l3bdUBq8d180fY+eGumdg3GVX+AJQ545kRA+FkSGk9PPyInk0aMQ/T3?=
 =?us-ascii?Q?vv8qbYOplZedh//ufvFMi0sSoQOHTIH+hwfaGy5N3ozelzQf63ljTvEItNtj?=
 =?us-ascii?Q?Hd9Cu/ojsXmuX49AhR1i0u/hf2lUl2fkSphoulKKXWb+QsCMCL0f3ZPeO+XN?=
 =?us-ascii?Q?WE5DrKTGuIq5DXHFE3v0+6iApOlagEq2VOLz/X9qLeuVHEP2tHBs22ohJCNh?=
 =?us-ascii?Q?EPY3bg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6o5GozLKgEOCGJdYmjr+0rwRTD1NmF3irETPRYaJ/inktOFAp2ixOqtwxYuBLH405Z0vK/sEt87GFRJLpuLEaHbnJaibvhtG2D5FSCDLn6Rgrwg3MA5vbuFiLBzt/2d8lpWlFEDSkdDd3g2pLQUmJS2GQHN3jP46Y0p8335K6VU3N2E98wVy7hybdYWIOP7GyG3+E5UkO8WmOsk1cLzSSbRFcA/bKQwYvT74AppfGu5eixALRW4JGkrl9cpvzVCJfwycTQKlC7aRRWz0h8AB+SZtphGuKhjw8xDw+pLIPHDyUTVPhEs9YC23r0w70L0gaez7uoD7r/hUlQhDu0NY/v68EsDv0d43DYiO0pUCDB461BYpS9iW2Q3OHlWEUMO1A66FPUjMl70bkQ93joBW3zxdM9MFi8Z5HlC272U8yZbXwahy2uBkXYolT2sWfCVH
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 13:02:41.9384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37370b3c-4827-4e84-6a75-08de6b002c4b
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4296

Add support for CTR mode of operation for AES algorithm in the AES
Engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 173 ++++++++++++++++++++++++------
 drivers/crypto/ti/dthev2-common.h |   3 +
 3 files changed, 147 insertions(+), 30 deletions(-)

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


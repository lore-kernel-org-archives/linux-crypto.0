Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA18122E3E9;
	Thu, 26 Feb 2026 12:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110595; cv=fail; b=D3xDaP6hdJYJgtwAsXCXmRHg/0YXJ61ixeP1gmUS839lJWwZgV6GQozhxwF28e+Z1BLdRuUoY4KTx6RpeJSORB8OxhA5JcmFQUAXVG6eecSGJBmpxbx6yxkcfdiXahGoS8X9lgv4VkqhFnlYvbnFWL2jk0XOEhXMwHK3HREFLww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110595; c=relaxed/simple;
	bh=vYn2n82thyL6tJl2ghjSHHRGCHnemITu7RXPDFJ9f/w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O1i0MEXf+upWaQuoPOS8LtQ+6PIo/1NEkjVf4Mx0Sf/1AaT0ruLrfb9lPY96Rd+LiDGDnEVKZCGhYjvhQ7svOa1jalNq07QofVYdlc1pGxR+ZmOV58vNt4sAXEMQMSB/8XjTqM9Lu0pQZP65PczOnKkUnU4T/c2zxoT3UkTAtMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=vL3qXMIf; arc=fail smtp.client-ip=40.93.194.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="vL3qXMIf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NNWgnpsFFlekeRcFnQ13Ik097To6u0ddcWOBzT3ob68Ud7chtG7eiCkqNzM9hjEBcrzorqwunaotSbm3scO72mTZSBF5aKJqIKBKyR818m8mxjKFLA2HIUH0XF98NoOvnwzBx+9wM9JrhMZxBNo0hM7Pr5QvhEjHgHE7u80D6f4re+A4CTJ6IcYZ2aTB1JcnAOoP2neBS1qq7poQoiV9lSm1vS3DalxpACBAKt/TsqsTcEEgZk2n8wd1oiCXaJlLRd/fUk7Onf4GmbHioFaMVKvGDtJ/nkOwYztYW+1UXoR0XiiZXZCvHtuLIr5u5qB9qkV8PHn/UaB2uez+DjHbMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u77JQJh/LDFvQ5SMn6Tr7M1Qe6LqrMQsDdiXKNrnoIc=;
 b=bXOw49/WlLI3e7nfEjq4RzyDyR8BX0+9J6OBdzVEgBx1MgmOAsKh8HpAJNVexazcLT6naDYWFG/mGULmM6K40WjI4X9cYJ14yRCzSShN2BWnmxFZATrcyhUvkPpwwOGzoH4/cikocree/OkN+coCD09huIJF7WIxSrPnwc2nK7kbHalA0yHgmQBVuBdMPSghQB/pjuwlWydSkUWyu4f3VHtmQ7FIMWl9x8Wt8L+iDaYSal1+o5nWdCEc9Qk4Bw9VYRg2ZY1Ye+NrSurEm/+2Z7NoORrC7369tBaMMV0wyizFRjr4RUQ2h5BxWM+PuPxa6/VCK+7eKGknYEOCK/xsYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u77JQJh/LDFvQ5SMn6Tr7M1Qe6LqrMQsDdiXKNrnoIc=;
 b=vL3qXMIf45qqY8/iOmXsPgrnIfbIltbrGK3pR0iI8LRjdGx8Q6o6YUdZLXzQ3QgqUVfOHHCLJmWaJ9n323m/ROKfRv2X4CN8AP7ZXMBobxzPw7hshQDoDMcQEYdQJRjJCvtk+e2PBoY7gSM0gQ7wp3URb2tJz5i+/5J7fgbdJwM=
Received: from BL1PR13CA0186.namprd13.prod.outlook.com (2603:10b6:208:2be::11)
 by DS3PR10MB997726.namprd10.prod.outlook.com (2603:10b6:8:345::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 12:56:11 +0000
Received: from BL02EPF0001A103.namprd05.prod.outlook.com
 (2603:10b6:208:2be:cafe::72) by BL1PR13CA0186.outlook.office365.com
 (2603:10b6:208:2be::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Thu,
 26 Feb 2026 12:56:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BL02EPF0001A103.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 26 Feb 2026 12:56:10 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 06:56:09 -0600
Received: from DFLE213.ent.ti.com (10.64.6.71) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 06:56:09 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 26 Feb 2026 06:56:09 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61QCu7821898320;
	Thu, 26 Feb 2026 06:56:08 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v10 3/3] crypto: ti - Add support for AES-CCM in DTHEv2 driver
Date: Thu, 26 Feb 2026 18:24:41 +0530
Message-ID: <20260226125441.3559664-4-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A103:EE_|DS3PR10MB997726:EE_
X-MS-Office365-Filtering-Correlation-Id: e9600178-6b4a-478f-aecb-08de75366a0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|34020700016|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	ottudccH1Krp17L4VcwsMr8av7Z2Ew+MVJ2yDPklqrnbZMgrqCY/g1INeQsP5ogWQ/GzmqU4nXZ98LEJSJpyudg1vysCkol9x1pedCQDPBASf1ht6OOsq3oWqCkrqj/8BdyJZXeMUlPmF9NNur3MtnISJDOxyjIPQXXPDHEl3x3/mAPpxTzC+OZ+EdmzCRed4FPtOnr0O1sEqwh2uTthXrRawtOpzwh08XnGnsEepf7+gqLijgLEyjt5jOIZT3S1R2HLwGhIUnqfQJR9qValgCPZ23JBVXCHieZXhCAhs3vgrdL2IcMnH/vVWKyJpj0DomhChaxpVQZFQpQAB5HK8luwvsv26WyhByWhMZs9WE4Ry11DclxTl/51C4I/GciookThEOrTfS3loo7ctjD+AzJUs3/2rKyKx94R21keTpxqz/zQ9TzNzKi8QAeOsixYg+WbJWdVHwAd86qZQZ06rycktoc0XzUrJHD/j5HhKbgfDHlOPScP1Uwznl0QoVXAbsAsNh/JK50fiPQYxGx0zrYw0leF6DKGgFh+P/fIBSF438WdpoKNcsBHOIGX1uXR84cFvwJeoLlLO+NpBodJmKvP2KG2eaHJtlnABxaL8w3eFB4Lm2wILTpSDuf4jNw4MNx7ygiyz/SE5ullybu8fHefuTW+HDXCwCC1wJMxO0cOxgZtRd1Ky9IFlwN2L0TtMFbhunXPlPGRZIx9ya1bD6aJhYaCMBiAUwAu2qhRztr+0EXtCJja4h58Xk3p4EsZzNPrr/UNLCZk+kqdizrrsacGSCmKSlMDuLIVd9JqvlD2Gben9OxKdszfEqECycVKvLPvgiy/8hNL39dxcMGmMQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(34020700016)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	is2t0vywxHqAEneF9mU5Q4iRyPKKF34kYFkB8/BFnh2JHGseAaHSQwg/VyI+2zVGtVjwxiAn+H0hKC/zGJt8yhPRJBqRUAB5qcjxo1OksIMx46VytgUgaLQjvf8gqMl/jguxTvp5A3H97CI0MD8+6cQl8OREsrt0HI1xG8j6fWF1ssH7sVrmKRyWj6Qm3n4JHrYVZKbQwvgbQCqc1h2oFaFq9siprTwuQ1HeR9cFz2y+pIT3q0bfQo6J7vVEF5DASOGW7F4EnYuPaVCV9f/y9xXvUDaSi2W1w+BxSB2jA9joBggM1WT5THrl+16soZo6km9/bV++ulYm8cvbxHPss6xFQmq3EMi3QNd4PMRU7wMGPpZH8yYPyv6NtMO9/GZf4XGdYrIIw24XBbcSsAHabKef1/sHqyk/G73AWdf9E6o3tHNHEqknIuZpfnhSDM/A
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 12:56:10.0045
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9600178-6b4a-478f-aecb-08de75366a0e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A103.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB997726

AES-CCM is an AEAD algorithm supporting both encryption and
authentication of data. This patch introduces support for AES-CCM AEAD
algorithm in the DTHEv2 driver.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 139 ++++++++++++++++++++++++++----
 drivers/crypto/ti/dthev2-common.h |   1 +
 3 files changed, 125 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 221e483737439..1a3a571ac8cef 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -9,6 +9,7 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_CTR
 	select CRYPTO_XTS
 	select CRYPTO_GCM
+	select CRYPTO_CCM
 	select SG_SPLIT
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index df5caafe1caf6..d00ccefd0a493 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -16,6 +16,7 @@
 
 #include "dthev2-common.h"
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
@@ -69,6 +70,7 @@ enum aes_ctrl_mode_masks {
 	AES_CTRL_CTR_MASK = BIT(6),
 	AES_CTRL_XTS_MASK = BIT(12) | BIT(11),
 	AES_CTRL_GCM_MASK = BIT(17) | BIT(16) | BIT(6),
+	AES_CTRL_CCM_MASK = BIT(18) | BIT(6),
 };
 
 #define DTHE_AES_CTRL_MODE_CLEAR_MASK		~GENMASK(28, 5)
@@ -81,6 +83,11 @@ enum aes_ctrl_mode_masks {
 
 #define DTHE_AES_CTRL_CTR_WIDTH_128B		(BIT(7) | BIT(8))
 
+#define DTHE_AES_CCM_L_FROM_IV_MASK		GENMASK(2, 0)
+#define DTHE_AES_CCM_M_BITS			GENMASK(2, 0)
+#define DTHE_AES_CTRL_CCM_L_FIELD_MASK		GENMASK(21, 19)
+#define DTHE_AES_CTRL_CCM_M_FIELD_MASK		GENMASK(24, 22)
+
 #define DTHE_AES_CTRL_SAVE_CTX_SET		BIT(29)
 
 #define DTHE_AES_CTRL_OUTPUT_READY		BIT_MASK(0)
@@ -96,6 +103,8 @@ enum aes_ctrl_mode_masks {
 #define AES_BLOCK_WORDS				(AES_BLOCK_SIZE / sizeof(u32))
 #define AES_IV_WORDS				AES_BLOCK_WORDS
 #define DTHE_AES_GCM_AAD_MAXLEN			(BIT_ULL(32) - 1)
+#define DTHE_AES_CCM_AAD_MAXLEN			(BIT(16) - BIT(8))
+#define DTHE_AES_CCM_CRYPT_MAXLEN		(BIT_ULL(61) - 1)
 #define POLL_TIMEOUT_INTERVAL			HZ
 
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
@@ -275,6 +284,13 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 	case DTHE_AES_GCM:
 		ctrl_val |= AES_CTRL_GCM_MASK;
 		break;
+	case DTHE_AES_CCM:
+		ctrl_val |= AES_CTRL_CCM_MASK;
+		ctrl_val |= FIELD_PREP(DTHE_AES_CTRL_CCM_L_FIELD_MASK,
+				       (iv_in[0] & DTHE_AES_CCM_L_FROM_IV_MASK));
+		ctrl_val |= FIELD_PREP(DTHE_AES_CTRL_CCM_M_FIELD_MASK,
+				       ((ctx->authsize - 2) >> 1) & DTHE_AES_CCM_M_BITS);
+		break;
 	}
 
 	if (iv_in) {
@@ -814,10 +830,6 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
 		return -EINVAL;
 
-	ctx->aes_mode = DTHE_AES_GCM;
-	ctx->keylen = keylen;
-	memcpy(ctx->key, key, keylen);
-
 	crypto_sync_aead_clear_flags(ctx->aead_fb, CRYPTO_TFM_REQ_MASK);
 	crypto_sync_aead_set_flags(ctx->aead_fb,
 				   crypto_aead_get_flags(tfm) &
@@ -826,6 +838,38 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	return crypto_sync_aead_setkey(ctx->aead_fb, key, keylen);
 }
 
+static int dthe_gcm_aes_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+	int ret;
+
+	ret = dthe_aead_setkey(tfm, key, keylen);
+	if (ret)
+		return ret;
+
+	ctx->aes_mode = DTHE_AES_GCM;
+	ctx->keylen = keylen;
+	memcpy(ctx->key, key, keylen);
+
+	return ret;
+}
+
+static int dthe_ccm_aes_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+	int ret;
+
+	ret = dthe_aead_setkey(tfm, key, keylen);
+	if (ret)
+		return ret;
+
+	ctx->aes_mode = DTHE_AES_CCM;
+	ctx->keylen = keylen;
+	memcpy(ctx->key, key, keylen);
+
+	return ret;
+}
+
 static int dthe_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
@@ -989,14 +1033,18 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		writel_relaxed(1, aes_base_reg + DTHE_P_AES_AUTH_LENGTH);
 	}
 
-	if (req->iv) {
-		memcpy(iv_in, req->iv, GCM_AES_IV_SIZE);
+	if (ctx->aes_mode == DTHE_AES_GCM) {
+		if (req->iv) {
+			memcpy(iv_in, req->iv, GCM_AES_IV_SIZE);
+		} else {
+			iv_in[0] = 0;
+			iv_in[1] = 0;
+			iv_in[2] = 0;
+		}
+		iv_in[3] = 0x01000000;
 	} else {
-		iv_in[0] = 0;
-		iv_in[1] = 0;
-		iv_in[2] = 0;
+		memcpy(iv_in, req->iv, AES_IV_SIZE);
 	}
-	iv_in[3] = 0x01000000;
 
 	/* Clear key2 to reset previous GHASH intermediate data */
 	for (int i = 0; i < AES_KEYSIZE_256 / sizeof(u32); ++i)
@@ -1069,20 +1117,54 @@ static int dthe_aead_crypt(struct aead_request *req)
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
+	bool is_zero_ctr = true;
 
 	/* In decryption, last authsize bytes are the TAG */
 	if (!rctx->enc)
 		cryptlen -= ctx->authsize;
 
+	if (ctx->aes_mode == DTHE_AES_CCM) {
+		/*
+		 * For CCM Mode, the 128-bit IV contains the following:
+		 * | 0 .. 2 | 3 .. 7 | 8 .. (127-8*L) | (128-8*L) .. 127 |
+		 * |   L-1  |  Zero  |     Nonce      |      Counter     |
+		 * L needs to be between 2-8 (inclusive), i.e. 1 <= (L-1) <= 7
+		 * and the next 5 bits need to be zeroes. Else return -EINVAL
+		 */
+		u8 *iv = req->iv;
+		u8 L = iv[0];
+
+		if (L < 1 || L > 7)
+			return -EINVAL;
+		/*
+		 * DTHEv2 HW can only work with zero initial counter in CCM mode.
+		 * Check if the initial counter value is zero or not
+		 */
+		for (int i = 0; i < L + 1; ++i) {
+			if (iv[AES_IV_SIZE - 1 - i] != 0) {
+				is_zero_ctr = false;
+				break;
+			}
+		}
+	}
+
 	/*
 	 * Need to fallback to software in the following cases due to HW restrictions:
 	 * - Both AAD and plaintext/ciphertext are zero length
-	 * - AAD length is more than 2^32 - 1 bytes
-	 * PS: req->cryptlen is currently unsigned int type, which causes the above condition
-	 * tautologically false. If req->cryptlen were to be changed to a 64-bit type,
-	 * the check for this would need to be added below.
+	 * - For AES-GCM, AAD length is more than 2^32 - 1 bytes
+	 * - For AES-CCM, AAD length is more than 2^16 - 2^8 bytes
+	 * - For AES-CCM, plaintext/ciphertext length is more than 2^61 - 1 bytes
+	 * - For AES-CCM, AAD length is non-zero but plaintext/ciphertext length is zero
+	 * - For AES-CCM, the initial counter (last L+1 bytes of IV) is not all zeroes
+	 *
+	 * PS: req->cryptlen is currently unsigned int type, which causes the second and fourth
+	 * cases above tautologically false. If req->cryptlen is to be changed to a 64-bit
+	 * type, the check for these would also need to be added below.
 	 */
-	if (req->assoclen == 0 && cryptlen == 0)
+	if ((req->assoclen == 0 && cryptlen == 0) ||
+	    (ctx->aes_mode == DTHE_AES_CCM && req->assoclen > DTHE_AES_CCM_AAD_MAXLEN) ||
+	    (ctx->aes_mode == DTHE_AES_CCM && cryptlen == 0) ||
+	    (ctx->aes_mode == DTHE_AES_CCM && !is_zero_ctr))
 		return dthe_aead_do_fallback(req);
 
 	engine = dev_data->engine;
@@ -1207,7 +1289,7 @@ static struct aead_engine_alg aead_algs[] = {
 	{
 		.base.init			= dthe_aead_init_tfm,
 		.base.exit			= dthe_aead_exit_tfm,
-		.base.setkey			= dthe_aead_setkey,
+		.base.setkey			= dthe_gcm_aes_setkey,
 		.base.setauthsize		= dthe_aead_setauthsize,
 		.base.maxauthsize		= AES_BLOCK_SIZE,
 		.base.encrypt			= dthe_aead_encrypt,
@@ -1229,6 +1311,31 @@ static struct aead_engine_alg aead_algs[] = {
 		},
 		.op.do_one_request = dthe_aead_run,
 	}, /* GCM AES */
+	{
+		.base.init			= dthe_aead_init_tfm,
+		.base.exit			= dthe_aead_exit_tfm,
+		.base.setkey			= dthe_ccm_aes_setkey,
+		.base.setauthsize		= dthe_aead_setauthsize,
+		.base.maxauthsize		= AES_BLOCK_SIZE,
+		.base.encrypt			= dthe_aead_encrypt,
+		.base.decrypt			= dthe_aead_decrypt,
+		.base.chunksize			= AES_BLOCK_SIZE,
+		.base.ivsize			= AES_IV_SIZE,
+		.base.base = {
+			.cra_name		= "ccm(aes)",
+			.cra_driver_name	= "ccm-aes-dthev2",
+			.cra_priority		= 299,
+			.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_module		= THIS_MODULE,
+		},
+		.op.do_one_request = dthe_aead_run,
+	}, /* CCM AES */
 };
 
 int dthe_register_aes_algs(void)
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 8514f0df8ac3d..d4a3b9c18bbc1 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -39,6 +39,7 @@ enum dthe_aes_mode {
 	DTHE_AES_CTR,
 	DTHE_AES_XTS,
 	DTHE_AES_GCM,
+	DTHE_AES_CCM,
 };
 
 /* Driver specific struct definitions */
-- 
2.34.1


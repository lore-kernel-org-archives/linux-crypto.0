Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012005.outbound.protection.outlook.com [40.107.209.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6616A36826B;
	Fri, 20 Mar 2026 10:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774003881; cv=fail; b=NFkBhRwiuclqmUbIfDvYIZnGvwFNi75TfB5iQmiBaHY/ksuX2lVa5M7KE202aYHnQ0HB1AJC7+2dgG/EPNk4UhA8weriAE4rwuhnHY669Z0XaVq+g1oT+4Ejdd/gY35d9DZZzF2WHxqX28Jxkztue/aWy4KXzZ2FHxmH0IzvpQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774003881; c=relaxed/simple;
	bh=eP4Da17reIjcVzMCsJLSbBGsPWbA0+QPd7lK5mNrojg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VgnYUykj3GaMGLbStJ+uVjETZmaD1JaME4NTDlwG4OpZhGhbULqKXhKiLbYbCUIUeIKOdRK/k3jrARjk51nZQlD5TnDyjkb0qE0LlJY/eDBbNc4WXRuBBegrIKPKaanatPZEuzBrQ4Ilz2XrRE6YjIQqAMO/q75uyQql1ebKfPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=QWmD7QEw; arc=fail smtp.client-ip=40.107.209.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="QWmD7QEw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z0qtq529cAaNwMD/2ok/r4hYKOzfuouGqzigtq7thy1XuIJjg12bPnsLcwAFLQVE96Fk2qNRJ6uU8MLG+kfV3bW9FDMU16nUA07tMxvp5HN/3/IRCh/Nhkosy5igxx1WkGMxWcSlRevp9tOy9oAL7EnwH7Oc/LhrN0bztmCBslU7B7v7WZDgZOXsgeWUB88X4OPrcyfp1Uq0fJ2DHtnVqWE7MfBZRNvLFsoL3XuHYOC8+zH+/Y2lQstkTJagadEPi1sKFZ257P98Qbvu3oHdfQmxZ3P4xxOpINJEGkhmItJxrgncs99VZQkJX0+HdW8gtO1tqYCDGS5bAxyEQnfcog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VD3pxF2vP5WAg6PFiXFypNF/Ffeyb/gsNuq4Hm00pkk=;
 b=Oir1icsBAn8eYc852fXJ4qHf+lRdorSQfKMVU/TBp+1d5lxflD/ibreAnStouaa+C5ljmu5D7xdlkHfnp0LbBFza0LMBbad0LLaZ//JJ/EpOWO8se3XgMLZOZ9fb3yXWLfbrSrsnYVvdhNbuLQxuOgGo2dMisXQ4rKc7bGeFxr+RILjAhTpyGT/VAIEIRMU5KFr/3OEoCfgmX+gkgDdSW7nhsX1vwTd/JH67pzpJB2jR6hEWbqGBMz1GzYLGwrEZwfbnfe4xRciZuCjykExV3JAmzN01i/myphgZcrfJrv6INXxXat+1iNL0/JuVRK3scgtkrL7qIdGycHt6jdTxLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VD3pxF2vP5WAg6PFiXFypNF/Ffeyb/gsNuq4Hm00pkk=;
 b=QWmD7QEwWjMe7R2mNeu1LHScf9pkxTOVQYl2U6KvxDeB+mRZYKadKgI9waRRk9XF0HPAkaG90xpiQ7sMfxc6RqJtlMG2l2+6TIX95PCBulPCij/PV8FZ1fYgcRYt6T5GixzVk82AbDAkj2JvtLhB4ZxyhZGpbFjfOm196+oszOM=
Received: from BY3PR05CA0006.namprd05.prod.outlook.com (2603:10b6:a03:254::11)
 by PH3PPF0A29BA37B.namprd10.prod.outlook.com (2603:10b6:518:1::787) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.18; Fri, 20 Mar
 2026 10:51:17 +0000
Received: from SJ1PEPF00001CE9.namprd03.prod.outlook.com
 (2603:10b6:a03:254::4) by BY3PR05CA0006.outlook.office365.com
 (2603:10b6:a03:254::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.23 via Frontend Transport; Fri,
 20 Mar 2026 10:51:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 SJ1PEPF00001CE9.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Fri, 20 Mar 2026 10:51:16 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 20 Mar
 2026 05:51:15 -0500
Received: from DLEE214.ent.ti.com (157.170.170.117) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 20 Mar
 2026 05:51:15 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 20 Mar 2026 05:51:15 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 62KApEO24191043;
	Fri, 20 Mar 2026 05:51:14 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v11 2/2] crypto: ti - Add support for AES-CCM in DTHEv2 driver
Date: Fri, 20 Mar 2026 16:20:52 +0530
Message-ID: <20260320105052.3931552-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260320105052.3931552-1-t-pratham@ti.com>
References: <20260320105052.3931552-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE9:EE_|PH3PPF0A29BA37B:EE_
X-MS-Office365-Filtering-Correlation-Id: 45b99707-8b87-4e89-0c38-08de866e9c90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	nJg9SyMda1RzHNK0eWDNHjlljLeyQzEjHNCVG1PZPUMf/bYV8kHsi5EYe7W71LWa/cm2yX1AuE/qWnWRzIUfJ5QafpZrIhBxvQb1F5/E1PjRzZu+ccYAUnPQWLhfcG9j7KXx513arEIOmVqQZK3J9hkMsQpOOerjMGRY4BifdKJhZfPAwA4dbEYkV4aWlWrpdcq0M9UYtl3kynQl48hPc0697lCju+gz4TNn28OXQnz/VhY7VD/2EJlF99b6XfviNNHyr1gfi2WnENPFfbhM37NNevjLFNKE4Lnv5CgvUzZ1BmJeRv9+/UVc6dYZEIwwSUesYAoUui3GmlLua0sFkaRoex82Af/rIVDT7btsFFyRh3YPgCuAwiCjULyOVCNA0g/YHLSvSGHxZ1Fh5j7fs2RXK2SBkah0mhbHD6UE8doEhXfQJkGG5z85uYo1Eo+W1J02gdAkEBLPUxy9l8lwLQY+5pJlzS50gllwtaUk7aybGbiSGtVi8Etggw94H43PRw2xHDJohFzSKfg1JTBfvz81KfjYNsMhxHYAwKPJWRzCudbDwmZeu1sdTA3Y+Wu1Tu+nsjzX0G7rWLEhd+GkzCIsDrgtGHprRKOwByqOom5W8BweRnd656oUyr45gdhGc+2Hl3Tai5nUP8D0qoyM69DnE/sKhIAyTTKPb3oK6quflQVK8SuzSkXGYAHzcsNjVMUc4fvo2U4azV4sgUE9R5+WmrmnDaz4EV5hB04yjFPzrs8aB6nv7XPWGRWDSfbEduDHlQ2wQ/5pGlNGU8WA+g==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oAZP+qv6ivYhaMYw1JB5LcNGqySYufmuEKUhRJ4Bv8orMC1+oCT8awZ1WeD2zGYlxNpXpIvfI3AarTu4s29zaoFK+HFNlV73UHdnDdbR/E+UooFfOHV1k7bWwEfy9Ji0zpYlgqwdWEGjqB4Yplq8X9DkecE2LgqpHYhMqdHvc8/xnXW8oIvDsm5oJQyF8irDr1AFWF+FdLkYekajwVW4fDOitdYHlnMDU3Vk6IH1bvFx5F3T068bRcb5yDLb6w71DZjQLIHX8V8uV86iwB/NYeCeWxCM6SOPWY+yF3yE/O66Hf6uWrxPrRlFrqDQ0gQ1uXU4qZHEhMJdzaH2FXzrVPQ2d40FCkahjKLvCIzoW1nbboBaNWhrD/p9gsj4sst+D/NnFMLVQ3EuHWFUoVdxX63KkfUE66QNPdeMXIEJG2+YCeSNzA359k1U2msIsjXk
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 10:51:16.3167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b99707-8b87-4e89-0c38-08de866e9c90
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF0A29BA37B

AES-CCM is an AEAD algorithm supporting both encryption and
authentication of data. This patch introduces support for AES-CCM AEAD
algorithm in the DTHEv2 driver.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 140 ++++++++++++++++++++++++++----
 drivers/crypto/ti/dthev2-common.h |   1 +
 3 files changed, 126 insertions(+), 16 deletions(-)

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
index 5583386decbef..eb5cd902dfb59 100644
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
@@ -756,10 +772,6 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
 		return -EINVAL;
 
-	ctx->aes_mode = DTHE_AES_GCM;
-	ctx->keylen = keylen;
-	memcpy(ctx->key, key, keylen);
-
 	crypto_sync_aead_clear_flags(ctx->aead_fb, CRYPTO_TFM_REQ_MASK);
 	crypto_sync_aead_set_flags(ctx->aead_fb,
 				   crypto_aead_get_flags(tfm) &
@@ -768,6 +780,38 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
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
@@ -990,14 +1034,18 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -1084,20 +1132,55 @@ static int dthe_aead_crypt(struct aead_request *req)
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
+		/* variable L stores L-1 here */
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
@@ -1222,7 +1305,7 @@ static struct aead_engine_alg aead_algs[] = {
 	{
 		.base.init			= dthe_aead_init_tfm,
 		.base.exit			= dthe_aead_exit_tfm,
-		.base.setkey			= dthe_aead_setkey,
+		.base.setkey			= dthe_gcm_aes_setkey,
 		.base.setauthsize		= dthe_aead_setauthsize,
 		.base.maxauthsize		= AES_BLOCK_SIZE,
 		.base.encrypt			= dthe_aead_encrypt,
@@ -1244,6 +1327,31 @@ static struct aead_engine_alg aead_algs[] = {
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


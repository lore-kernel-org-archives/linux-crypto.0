Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011000.outbound.protection.outlook.com [52.101.52.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE40E31D390;
	Wed, 26 Nov 2025 11:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764156198; cv=fail; b=EDo5P5U9A//zgr+lv9Gaz1rXfwlBbzWOMu5DKN0Agj09F1t34uxbSTP3GQDcXiU0iqye5viY1wTTAGCMNmwArZnE18cE3PwUsZCMZRUlA4VkvQ4/rtgBrH33yHr2Gj2agfjMHLR/dbC3S2+YWNLggpHGILvjurm47ZLlyuICz1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764156198; c=relaxed/simple;
	bh=zK0dbJDBtQNfTPI7wZ3sSri4Q9jWGowpuChwfvq/siw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uXd+a2GoYy5pxFWzDc3Zsv6mo7Vc1uvPWLwnZkJObc0DCqMoBISx2TbCJov5zmh68yCG1487pMXilpPJr9bCJLeUg2elHdC4aD7I7WFo8QA1haN8xfoKDH3roUdiVNrR4GiXdY0sgHblT32KAFCNit0TkFgbuvxyYMJ0tqvJdSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=sxoc6q9/; arc=fail smtp.client-ip=52.101.52.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="sxoc6q9/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z+deM1SIIDb4Uc63x362qhwAoSAysCIUWWKX01bHsVPhBiVplDoW+yxtOR+G0tpsNtEAEQgdF+DVl5NICk6ACnilHznhh5NaiZKG28oNYGRBai5rS4UDxGvShFbYd16bKSeb1P8FZMPlo/7kiui98gVvm3G5Gsg2oDR0/z7/wnZJM9D4lUtVKhoJDHcogWjImoHWw8MwXdYlS9BekmAfLxTuLVIBcj3Ue2seNXYWkCPU00ZVW2CqLXScqnkouGXf50mKgqN/iTh/U34Tmj/0NjFEFbJLo1D7O1LWnLmLWOiCNYUXoT8SHd3zg/mwUHiBWWqgPfX9Zax+POtuQ77ybw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FqE5uL9cQE8p1FQ1ecDzKLfTefZKaMLn/x0UPDO3uU=;
 b=BMYW0nJVAZ4rc0XZKH5EMxAT1f7GhzDwl3JDJAD7lJXXic3qrvE9b+juJ9Mo8z+B/+IqYolBSVKEi4y7twcVqiyO6VyD/8ac6/8vHUk16jG0l0KVtIMQwRYbnSwsuys7of991CmhIHWCIq+qI1UzcO8wElD/65q8EiX9QkHKsRNMjnBP7qgI3GQhC85+bwn/EKHZjj2CaFdSdp3UAj6ZXUl+Icw+N7gGE1Z0xDOibs4LJDDf6K7kOKL57fu/LlHUobcRPatb9seZQJMuIEEQ49BonXkCsspjLjR08sPr392WdkKHpXQfWMoSNWFE06rEwmb2YIAX2/fMK54XZJT3Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FqE5uL9cQE8p1FQ1ecDzKLfTefZKaMLn/x0UPDO3uU=;
 b=sxoc6q9/CacDSN5IIwa1S4VBCiMtjZEMo1c7O5TDz+JOkvSfM4wLlO8wK81oPVTzhwnyB7GVhXzO5M+144AroOrmUbREHSmSDBznJzzl7pJdA8yo9y7VjeJotndkYVBQGzesJPhl3gyUTtKhwiHYcpGUxlrRXtfn6vj3mCoO11M=
Received: from PH7P221CA0008.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::26)
 by LV3PR10MB8130.namprd10.prod.outlook.com (2603:10b6:408:28d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 11:23:12 +0000
Received: from SN1PEPF000397B4.namprd05.prod.outlook.com
 (2603:10b6:510:32a:cafe::e0) by PH7P221CA0008.outlook.office365.com
 (2603:10b6:510:32a::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.13 via Frontend Transport; Wed,
 26 Nov 2025 11:23:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SN1PEPF000397B4.mail.protection.outlook.com (10.167.248.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 11:23:11 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 05:23:10 -0600
Received: from DFLE202.ent.ti.com (10.64.6.60) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 05:23:10 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 26 Nov 2025 05:23:10 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5AQBN9cQ1141447;
	Wed, 26 Nov 2025 05:23:09 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v7 3/3] crypto: ti - Add support for AES-CCM in DTHEv2 driver
Date: Wed, 26 Nov 2025 16:46:17 +0530
Message-ID: <20251126112207.4033971-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251126112207.4033971-1-t-pratham@ti.com>
References: <20251126112207.4033971-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B4:EE_|LV3PR10MB8130:EE_
X-MS-Office365-Filtering-Correlation-Id: 61266128-44fb-471b-feb0-08de2cde2ed3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rc+S/ySX964eGNC8plws6ugLngqiVc4RLxapWyeB51lFtFMg373oEbU75o7W?=
 =?us-ascii?Q?yLqBSnuuC/VtOlBb6IanTx15otwh2pQ2bKNz0agPs3cJ19UUDWQcUhAB8lUZ?=
 =?us-ascii?Q?kcluPr9NiA6Ye5qZuZy2UdvfJUeFwoZYtVpaGtsgA60/YLwXwtHv62G4gX2m?=
 =?us-ascii?Q?ZjtngE//E4Ty/WqumJElkNTmRgmDo8zrAlB0JhrFNhPV56C3z9miIMOlAKAo?=
 =?us-ascii?Q?WyE+emN6P2adjOeWZuElxQGwhG1xHgNRpGyPAWzH/fbax/G3Duhz8P7LcGDb?=
 =?us-ascii?Q?8taH1mYPckkW/f06xlcQtL+iXuPPLV3jUIH55AGskmMFatryW24Z6jgWHuOP?=
 =?us-ascii?Q?GfnE86fv0S1FV5uhtvjM1682FYX6035L+scQz3g1fRCzmSJemPePhVEK5uoE?=
 =?us-ascii?Q?twU6K4F6wbhsSK2ZbP+gyvR8buffw2yb1OHgW2NlyAwmsRgF5roMw7UmHU3p?=
 =?us-ascii?Q?4i0gr9X1kbgBs0dtdGhroEW3nl8PeEXd9UzJkrjd7LkWkKMPv4aLjzxr6qt1?=
 =?us-ascii?Q?h5uNNCjzCXYTLGtLNdwIXdzQ6Fbw5ZB4r7Uz35bGPbr7soczBA/ko/nG5egX?=
 =?us-ascii?Q?Sk98YcIgvEj/i9hgh92jP7nnHw/dDweMLBgE/PnYkiuLL3a+BpmdYE4Q1/jo?=
 =?us-ascii?Q?/+sZwYa+057hoUmn9zq/aeFfBE2Xte/2Vqcu9NbmdB0tGn+L+k76/Sm8kjnC?=
 =?us-ascii?Q?t559BPKUWTUzVd/MXpIJwlAFwt/gdmRpBReyzuJXnBE/1b1o8TNXtyBt1MXw?=
 =?us-ascii?Q?W9KqFEtMgyKwqXlVeTeO4E+/T7Co7ZUU21VNKXUqSAyGOilWKNwJUQHRES3n?=
 =?us-ascii?Q?RFPtlTw9Xx7OWgBMyYcNeSncQM5mu9TVg6XnUq6vWw7a8m7nJVb/zXtKIRY3?=
 =?us-ascii?Q?DRrd32MTz5ZhkUGmyNGmMQbE9GEWoHU8Sa+PZ3yQM1wCjWdbCb7mdNFshmjp?=
 =?us-ascii?Q?/clsRo1SXzJf9+wmNbGITGZRvC6d0j2gG49asUrLKK7lQqncpRjA0H+NqCx6?=
 =?us-ascii?Q?SVlnBFsyWdxOHKr8C/lW9s9Tnr1YLv3oKpPeC78p4G7LxDmYDnFC8bGaOAxe?=
 =?us-ascii?Q?l+2jK40fLgw+FgQv79TiVK2p19L0DM8J3WSWOeMf7rwt5RK4HFBT8pC+ClVK?=
 =?us-ascii?Q?WlDuUF+dNmnd2wkFCN+aXjHTzv26b1OW6U+1ywidmjQ2zw7M4m91+n5jy8Re?=
 =?us-ascii?Q?+VFs9fJyv8s8uwB91F50w/Zbas3ZJHpLIYQAWKAM1IwzWL1+3h302dHvedrD?=
 =?us-ascii?Q?zS/FSR0pYnORU6OwJ8qWQpy5zZXPtQyItaFv9UUhzCFgrNBFSe7WJRmTIBL4?=
 =?us-ascii?Q?3tb0Y0Lwsv6cvDObI1JFzFWoA9uctWHLjsoogkkDoHufxC4jNrqdXegPsYrJ?=
 =?us-ascii?Q?V8ifpoYJTiCRf6UIfU+ydxSL7tCCYOe9eIn0Kgt83hiyBJIpI/KdwLlafGKS?=
 =?us-ascii?Q?Sl3mfu6o21YX1aVh3WRDOFT7o2YLNVXGfuarPc/Wp8jCTSHr8nLceoToHENY?=
 =?us-ascii?Q?6ktbG3sQ+dqyf6p8PE6sZGohtR5ov27T5ZjSu9DexhMxElNrKbH92p7vAovH?=
 =?us-ascii?Q?1I3fwqd0ahvpgCnxcJg=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 11:23:11.2491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61266128-44fb-471b-feb0-08de2cde2ed3
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8130

AES-CCM is an AEAD algorithm supporting both encryption and
authentication of data. This patch introduces support for AES-CCM AEAD
algorithm in the DTHEv2 driver.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 129 ++++++++++++++++++++++++++----
 drivers/crypto/ti/dthev2-common.h |   1 +
 3 files changed, 115 insertions(+), 16 deletions(-)

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
index 2521e73740e79..769227329760a 100644
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
 
 static struct scatterlist *dthe_chain_pad_sg(struct scatterlist *sg,
@@ -304,6 +313,13 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
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
@@ -825,10 +841,6 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
 		return -EINVAL;
 
-	ctx->aes_mode = DTHE_AES_GCM;
-	ctx->keylen = keylen;
-	memcpy(ctx->key, key, keylen);
-
 	crypto_sync_aead_clear_flags(ctx->aead_fb, CRYPTO_TFM_REQ_MASK);
 	crypto_sync_aead_set_flags(ctx->aead_fb,
 				   crypto_aead_get_flags(tfm) &
@@ -837,6 +849,28 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	return crypto_sync_aead_setkey(ctx->aead_fb, key, keylen);
 }
 
+static int dthe_gcm_aes_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->aes_mode = DTHE_AES_GCM;
+	ctx->keylen = keylen;
+	memcpy(ctx->key, key, keylen);
+
+	return dthe_aead_setkey(tfm, key, keylen);
+}
+
+static int dthe_ccm_aes_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->aes_mode = DTHE_AES_CCM;
+	ctx->keylen = keylen;
+	memcpy(ctx->key, key, keylen);
+
+	return dthe_aead_setkey(tfm, key, keylen);
+}
+
 static int dthe_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
@@ -999,14 +1033,18 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -1076,20 +1114,54 @@ static int dthe_aead_crypt(struct aead_request *req)
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
@@ -1212,7 +1284,7 @@ static struct aead_engine_alg aead_algs[] = {
 	{
 		.base.init			= dthe_aead_init_tfm,
 		.base.exit			= dthe_aead_exit_tfm,
-		.base.setkey			= dthe_aead_setkey,
+		.base.setkey			= dthe_gcm_aes_setkey,
 		.base.setauthsize		= dthe_aead_setauthsize,
 		.base.maxauthsize		= AES_BLOCK_SIZE,
 		.base.encrypt			= dthe_aead_encrypt,
@@ -1234,6 +1306,31 @@ static struct aead_engine_alg aead_algs[] = {
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
index 6a08061f382fe..6ce1225a0a61e 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -40,6 +40,7 @@ enum dthe_aes_mode {
 	DTHE_AES_CTR,
 	DTHE_AES_XTS,
 	DTHE_AES_GCM,
+	DTHE_AES_CCM,
 };
 
 /* Driver specific struct definitions */
-- 
2.43.0


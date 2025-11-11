Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA293502A6;
	Tue, 11 Nov 2025 11:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762860126; cv=fail; b=k5615MELB1VAKLMoqXX2pGMQDF3igIStlEvKvOreP5SGetmSdU14ajTpf4wLVHCf9gxK7X9mxsRkk/3rlIvD1jKbe9/NO77RTFPMwfixzN2604VrLkYyvpALL7PraPduuw06e6Tn3NgQ/W5dVZ7yinKzMTppOBz5/wYdszkt7pY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762860126; c=relaxed/simple;
	bh=BnRhr1yAKF8YTfF2TBoTKGiFYPSnPANfyQxHfAFXBic=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DdDV7A4n/dKOlAr7+f00fyag8iQbZoZ4D51lmgq5ufXyBhK93PSP6/COVARbwaG3ZKhaoAbz2sAtrmUnNYB4+XwRWuI01pvlmrTI0rVIXVERPrDDDDtEfyv7LzPiO5Up8JuvWWQdFFAh4GG3UEUG2X/msVHMAwsG6U8xuRxBYGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=G+T/GfFd; arc=fail smtp.client-ip=52.101.56.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="G+T/GfFd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q0FN/gK6XYcvwXoNIPEXEjlkgnZFCc8EbzBE+gY/4yIXbBUCLFfxzOWc6MQDyL604MJPeNrO9faVZShKFWg+VvOp9dLV7cP4D6jVE2nyrfFXpnWIfAQNytmSrC1ZG0vSfIld/AoYb+Cqkl13bxfknqhNGncjoWGhiIqak8k3hTBIYzuUrxJ964Z8OHk16RmYjNBo3F9LFzNK4BFlK0vngfPxOPBimr2GY5HfpGZr8Yz9lQ2xBhcsYOr55/0BlOh/MTo43fMbYC1Wso7546ozbuF2MuQO90eFsLtl1fLgfty9V7nO2bsv+D3MEg4w1IqAG+u+Mdq6/TjyUnAoXfWzTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sk9ntpMnsnJzphDT4iZPd+9W3IQFv2EGnTbW0Awtq2Y=;
 b=n6AMv5DRLpun7N9uRPShURtkNFaO74EfLAGVKEFYQR+dYiO9hatabXf34YPEC7bH4QNa0soMtTLxZrF9mXSVfAXSQCRZW8J2CVXdNDWc4FIb4s/pZK950gsnPAQ7xd5JMHGWOMkt4OIG2nDodQCWquhEQislomwmsCGhvy6hMfpi57iAul447HHKA67e/XuyDdKbwXf4FBCuHE9bdGsYTe1cXV4WZlnELpZAUba2ooph3TxNB9rhz1RGbe96WFkNaecHGqI+7WnGJODhTh755h9Z2GOfSoHr0FKnVJraoWDX0Vhhgz1jWrXfKl9qJ87h8pAFL0oRG2Ft8yZtelv0zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sk9ntpMnsnJzphDT4iZPd+9W3IQFv2EGnTbW0Awtq2Y=;
 b=G+T/GfFdoKtUSdj/VA5oI6Z1t7Ri6aM7Hu/IEDUmk3aDBGUN/onSKjuF55VdZOH8P2qQYYZh60DLLL4D3IL6zWfM4pjw29nH0t1F+XLfTL6KHzeXMg5WjyyBtHSeh/51a/8kIT7UkGaKeP+Cuql4iCYn95KEaiVLpAE8yFNej10=
Received: from SJ0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:2c0::32)
 by IA4PR10MB8753.namprd10.prod.outlook.com (2603:10b6:208:55c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 11:22:00 +0000
Received: from SJ1PEPF00002315.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::64) by SJ0PR13CA0027.outlook.office365.com
 (2603:10b6:a03:2c0::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Tue,
 11 Nov 2025 11:21:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 SJ1PEPF00002315.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Tue, 11 Nov 2025 11:21:59 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:21:54 -0600
Received: from DLEE210.ent.ti.com (157.170.170.112) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:21:53 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 11 Nov 2025 05:21:53 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5ABBLq3i828340;
	Tue, 11 Nov 2025 05:21:53 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 1/4] crypto: ti - Add support for AES-XTS in DTHEv2 driver
Date: Tue, 11 Nov 2025 16:38:30 +0530
Message-ID: <20251111112137.976121-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251111112137.976121-1-t-pratham@ti.com>
References: <20251111112137.976121-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002315:EE_|IA4PR10MB8753:EE_
X-MS-Office365-Filtering-Correlation-Id: 149e7ea3-88df-4ce6-78ef-08de211487ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F9QdfNhByGbUJOievzYSl5PtChbZsLV0fBrZXtr5Oc6KEC0l8vfnW+A7dxHd?=
 =?us-ascii?Q?61tToExssCatuNM2aTAB1ZpspNcmczkovZ06tzCLOlN5vcXY+BdLztpv6tDZ?=
 =?us-ascii?Q?7QbU4gHNORdwvq8ZaEjSIpHo0rXVgE095JKKtkLHP/Jyea852SjZromT3UwB?=
 =?us-ascii?Q?YY42Hzy9EoUjKQK7rgN6CORab3PHPaTQ+WAox9OORiGzHGY8ACovw30hRxCs?=
 =?us-ascii?Q?mMFxOpRO7YYOvKI1NAl1yvRR7g5/BXcrMHM/GkugFdzL57Y/OFUIz5YhL5ky?=
 =?us-ascii?Q?ADtADSnYKQgdNAo82UDr93kKkq+ozmqN0aD33ivbdODHRYJt5P/FjVVANZfh?=
 =?us-ascii?Q?otVQjDeiBnMQto4nAXMdYowKpvNC4GgqU5LfDdwbQUTWUx01miY3ZPkMkU/k?=
 =?us-ascii?Q?qUxiGcx34JnbMBqics4OpDursZqAuSlWv9EVSBdsymCdeeBrAPitLNVNUkZc?=
 =?us-ascii?Q?vIsbCkRiQvIR2djDKZ81sVxYDkFphBl8kYWv4N0j6zNGHjC0I0sfJ2RbvKVp?=
 =?us-ascii?Q?aWHVExs1izT8vpGL2ACeT+VSFBA766eyn8BFwWlRyXHSmqV/4JU0qnhhKO4b?=
 =?us-ascii?Q?VPVbotqIIciqbug5oNMwX8y1tYZWWRE9B1O4O2wYc6TJ6GtaWpmTDfibgqIj?=
 =?us-ascii?Q?Bewd04zcanfJdi1oZ6cL7u2/v0d0GPI7UI/5OOsOfUqrWFDaSAiZTEqq/l+N?=
 =?us-ascii?Q?v9ehzVaIX/oUWF3D1VvqMEjv3MHYwPxdukKID/Nox9kXtX1JNH/0LqLXF9RP?=
 =?us-ascii?Q?DzrN8dAY3yfAqVYc5pSMsWgH3nA0Wsv4E30EqN1iABJ+f7EpDE3ANDmFoseB?=
 =?us-ascii?Q?3n2tdrdjxoEsqdkuIn5x3s8AQdCROUgpGL4jMUAprCRpq2euPeSn9UGs6vYw?=
 =?us-ascii?Q?Sl5zTMzYC05cX3rn0zRMhWMVyROtjychek5d3s9Yd9K0NkB1CbhGkOIlTVlJ?=
 =?us-ascii?Q?K0Tdw/Yu6za2w/nSHAJkcxvRCi+gN+ysamBvq8TTZOFyX+Z7Fc6jI7rhVxlq?=
 =?us-ascii?Q?F5FLmQVTy5J40mG287imO3Pp1/eZsJVE7w9TQbkPJ4tV9AvC4T46UPPM8eik?=
 =?us-ascii?Q?Zpsei5DVvjtDnCapVyKv9byIoxWeioI7/Q1OhtfjH1g8fVeD+yZFuMQQMLhX?=
 =?us-ascii?Q?VYMxbVaD1wzudmaD8/xNWVRhe5JMP/HSIk8u8YxX0lqxMpJom6inHhzlxXk5?=
 =?us-ascii?Q?pFhAHGRxS6ZvKALj2vfDz0yIQKqlyNgZol+vhoDtJ4bUyUUpYAfFko4iotVh?=
 =?us-ascii?Q?TF4vjxh785QH+YJCE9HaG1sK0NCeeB8jV1eBYyt8jRU8XyJBKM8cEcGxGF1n?=
 =?us-ascii?Q?bV9DVx2CQjDhES/HuLsAKR+5DXZ8qxUneZlBjSTo7liqaWAs5ZfNV0Px3Nai?=
 =?us-ascii?Q?0AwFSlyIAkr2QVlqbakml2DwWbdF0fquK8nxvO87+MlKtJpwWtMqtm+FgZT/?=
 =?us-ascii?Q?SOvOvNiCrajBCvRGAhLnDEAxM516X+G5uhYOvx/Q/UdyGoSVsd9DC4Qfndw6?=
 =?us-ascii?Q?cPrGjg7SQviJRI3B2aUu9O9Kqm15tY+1pLWSUIdEBkmCXLMfJTL080uqmmfY?=
 =?us-ascii?Q?eHGWizfQMzDvffEq3SE=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 11:21:59.5814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 149e7ea3-88df-4ce6-78ef-08de211487ea
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002315.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8753

Add support for XTS mode of operation for AES algorithm in the AES
Engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 137 ++++++++++++++++++++++++++++--
 drivers/crypto/ti/dthev2-common.h |  10 ++-
 3 files changed, 141 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index d4f91c1e0cb55..a3692ceec49bc 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -6,6 +6,7 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ECB
 	select CRYPTO_CBC
+	select CRYPTO_XTS
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
 	  which can be found on TI K3 SOCs. Selecting this enables use
diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 3547c41fa4ed3..7d8123984c1eb 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -25,6 +25,7 @@
 
 // AES Engine
 #define DTHE_P_AES_BASE		0x7000
+
 #define DTHE_P_AES_KEY1_0	0x0038
 #define DTHE_P_AES_KEY1_1	0x003C
 #define DTHE_P_AES_KEY1_2	0x0030
@@ -33,6 +34,16 @@
 #define DTHE_P_AES_KEY1_5	0x002C
 #define DTHE_P_AES_KEY1_6	0x0020
 #define DTHE_P_AES_KEY1_7	0x0024
+
+#define DTHE_P_AES_KEY2_0	0x0018
+#define DTHE_P_AES_KEY2_1	0x001C
+#define DTHE_P_AES_KEY2_2	0x0010
+#define DTHE_P_AES_KEY2_3	0x0014
+#define DTHE_P_AES_KEY2_4	0x0008
+#define DTHE_P_AES_KEY2_5	0x000C
+#define DTHE_P_AES_KEY2_6	0x0000
+#define DTHE_P_AES_KEY2_7	0x0004
+
 #define DTHE_P_AES_IV_IN_0	0x0040
 #define DTHE_P_AES_IV_IN_1	0x0044
 #define DTHE_P_AES_IV_IN_2	0x0048
@@ -52,6 +63,7 @@
 enum aes_ctrl_mode_masks {
 	AES_CTRL_ECB_MASK = 0x00,
 	AES_CTRL_CBC_MASK = BIT(5),
+	AES_CTRL_XTS_MASK = BIT(12) | BIT(11),
 };
 
 #define DTHE_AES_CTRL_MODE_CLEAR_MASK		~GENMASK(28, 5)
@@ -88,6 +100,31 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	return 0;
 }
 
+static int dthe_cipher_xts_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	ctx->dev_data = dev_data;
+	ctx->keylen = 0;
+
+	ctx->skcipher_fb = crypto_alloc_sync_skcipher("xts(aes)", 0,
+						      CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->skcipher_fb)) {
+		dev_err(dev_data->dev, "fallback driver xts(aes) couldn't be loaded\n");
+		return PTR_ERR(ctx->skcipher_fb);
+	}
+
+	return 0;
+}
+
+static void dthe_cipher_xts_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_sync_skcipher(ctx->skcipher_fb);
+}
+
 static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -119,6 +156,27 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 	return dthe_aes_setkey(tfm, key, keylen);
 }
 
+static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (keylen != 2 * AES_KEYSIZE_128 &&
+	    keylen != 2 * AES_KEYSIZE_192 &&
+	    keylen != 2 * AES_KEYSIZE_256)
+		return -EINVAL;
+
+	ctx->aes_mode = DTHE_AES_XTS;
+	ctx->keylen = keylen / 2;
+	memcpy(ctx->key, key, keylen);
+
+	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
+				       crypto_skcipher_get_flags(tfm) &
+				       CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+}
+
 static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 				  struct dthe_aes_req_ctx *rctx,
 				  u32 *iv_in)
@@ -141,6 +199,24 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 		writel_relaxed(ctx->key[7], aes_base_reg + DTHE_P_AES_KEY1_7);
 	}
 
+	if (ctx->aes_mode == DTHE_AES_XTS) {
+		size_t key2_offset = ctx->keylen / sizeof(u32);
+
+		writel_relaxed(ctx->key[key2_offset + 0], aes_base_reg + DTHE_P_AES_KEY2_0);
+		writel_relaxed(ctx->key[key2_offset + 1], aes_base_reg + DTHE_P_AES_KEY2_1);
+		writel_relaxed(ctx->key[key2_offset + 2], aes_base_reg + DTHE_P_AES_KEY2_2);
+		writel_relaxed(ctx->key[key2_offset + 3], aes_base_reg + DTHE_P_AES_KEY2_3);
+
+		if (ctx->keylen > AES_KEYSIZE_128) {
+			writel_relaxed(ctx->key[key2_offset + 4], aes_base_reg + DTHE_P_AES_KEY2_4);
+			writel_relaxed(ctx->key[key2_offset + 5], aes_base_reg + DTHE_P_AES_KEY2_5);
+		}
+		if (ctx->keylen == AES_KEYSIZE_256) {
+			writel_relaxed(ctx->key[key2_offset + 6], aes_base_reg + DTHE_P_AES_KEY2_6);
+			writel_relaxed(ctx->key[key2_offset + 7], aes_base_reg + DTHE_P_AES_KEY2_7);
+		}
+	}
+
 	if (rctx->enc)
 		ctrl_val |= DTHE_AES_CTRL_DIR_ENC;
 
@@ -160,6 +236,9 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 	case DTHE_AES_CBC:
 		ctrl_val |= AES_CTRL_CBC_MASK;
 		break;
+	case DTHE_AES_XTS:
+		ctrl_val |= AES_CTRL_XTS_MASK;
+		break;
 	}
 
 	if (iv_in) {
@@ -315,24 +394,45 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-	return ret;
+	return 0;
 }
 
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct crypto_engine *engine;
 
 	/*
-	 * If data is not a multiple of AES_BLOCK_SIZE, need to return -EINVAL
-	 * If data length input is zero, no need to do any operation.
+	 * If data is not a multiple of AES_BLOCK_SIZE:
+	 * - need to return -EINVAL for ECB, CBC as they are block ciphers
+	 * - need to fallback to software as H/W doesn't support Ciphertext Stealing for XTS
 	 */
-	if (req->cryptlen % AES_BLOCK_SIZE)
+	if (req->cryptlen % AES_BLOCK_SIZE) {
+		if (ctx->aes_mode == DTHE_AES_XTS) {
+			SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->skcipher_fb);
+
+			skcipher_request_set_callback(subreq, skcipher_request_flags(req),
+						      req->base.complete, req->base.data);
+			skcipher_request_set_crypt(subreq, req->src, req->dst,
+						   req->cryptlen, req->iv);
+
+			return rctx->enc ? crypto_skcipher_encrypt(subreq) :
+				crypto_skcipher_decrypt(subreq);
+		}
 		return -EINVAL;
+	}
 
-	if (req->cryptlen == 0)
+	/*
+	 * If data length input is zero, no need to do any operation.
+	 * Except for XTS mode, where data length should be non-zero.
+	 */
+	if (req->cryptlen == 0) {
+		if (ctx->aes_mode == DTHE_AES_XTS)
+			return -EINVAL;
 		return 0;
+	}
 
 	engine = dev_data->engine;
 	return crypto_transfer_skcipher_request_to_engine(engine, req);
@@ -399,7 +499,32 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
-	} /* CBC AES */
+	}, /* CBC AES */
+	{
+		.base.init			= dthe_cipher_xts_init_tfm,
+		.base.exit			= dthe_cipher_xts_exit_tfm,
+		.base.setkey			= dthe_aes_xts_setkey,
+		.base.encrypt			= dthe_aes_encrypt,
+		.base.decrypt			= dthe_aes_decrypt,
+		.base.min_keysize		= AES_MIN_KEY_SIZE * 2,
+		.base.max_keysize		= AES_MAX_KEY_SIZE * 2,
+		.base.ivsize			= AES_IV_SIZE,
+		.base.base = {
+			.cra_name		= "xts(aes)",
+			.cra_driver_name	= "xts-aes-dthev2",
+			.cra_priority		= 299,
+			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
+			.cra_alignmask		= AES_BLOCK_SIZE - 1,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_module		= THIS_MODULE,
+		},
+		.op.do_one_request = dthe_aes_run,
+	}, /* XTS AES */
 };
 
 int dthe_register_aes_algs(void)
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 68c94acda8aaa..c7a06a4c353ff 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -27,10 +27,16 @@
 
 #define DTHE_REG_SIZE		4
 #define DTHE_DMA_TIMEOUT_MS	2000
+/*
+ * Size of largest possible key (of all algorithms) to be stored in dthe_tfm_ctx
+ * This is currently the keysize of XTS-AES-256 which is 512 bits (64 bytes)
+ */
+#define DTHE_MAX_KEYSIZE	(AES_MAX_KEY_SIZE * 2)
 
 enum dthe_aes_mode {
 	DTHE_AES_ECB = 0,
 	DTHE_AES_CBC,
+	DTHE_AES_XTS,
 };
 
 /* Driver specific struct definitions */
@@ -73,12 +79,14 @@ struct dthe_list {
  * @keylen: AES key length
  * @key: AES key
  * @aes_mode: AES mode
+ * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
 struct dthe_tfm_ctx {
 	struct dthe_data *dev_data;
 	unsigned int keylen;
-	u32 key[AES_KEYSIZE_256 / sizeof(u32)];
+	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
 	enum dthe_aes_mode aes_mode;
+	struct crypto_sync_skcipher *skcipher_fb;
 };
 
 /**
-- 
2.43.0


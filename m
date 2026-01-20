Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012007.outbound.protection.outlook.com [52.101.48.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD0A4611C8;
	Tue, 20 Jan 2026 14:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920314; cv=fail; b=A0tW+Omi3SOBbrvHH59soJLe8FxpGTSfN5TUtxDanVLqRU+UZyU5DIvpwq93Wz18LLoEs0+kNx7W6dVydeR+3xj7fsyBZHgmxkrmZ4XkkxUrXaEWHtLoX8OQkDePkV4ISfslp57AkRfAcH+o24g8OtlUxcAxuuE0j4XKG1TSKOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920314; c=relaxed/simple;
	bh=auBMRtItXLwAFlbEze7kGtoL2nTUwV4HKU3yg9xJVig=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pSFdK9PUvNRNoIqWmlhOquJCO4xgXfUGCivkx6SKw7Pht9JC/taRMPI8LgzglI4Xu8pwKkRnrfQ2kyeHI9Onndt6R6BUPJC2OuhWtf4C8IACq9XRlo7SRogHshiC4oUki2rE8ZGth9WwhtIdIVIptylmrx5Wy4DS31RslVXrCjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=n+HMS5o+; arc=fail smtp.client-ip=52.101.48.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="n+HMS5o+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KT+edhw8kcbh49OcKouMiz2xddP2St9BqVwSc1UbI5I7lfjgXS4b5e1FWpHJyOxCla8ET1mblAWHfLmGA/uxnW/ypCtTGjY/ZuiAfsp1xao9dZ6rCyDI6v9J3fmOoIvMVNd6us+z63wBneDsLGbKEZ+fQ371BsgjAFH47Xto4q+TvFLuxfMz54lYZ6dJLzz1jDzwMHPZ2djB0Q1PxLWaPq5YzF+s74FhVY9HxClwn7yN0KJbV5N8Jiulg1D0fLlPw55TpQ967WfEP2ORC6EYKWDc1LhXUVRsoRv0Qa6OVu7XMDRc5cHD1W3Qo9sx2jGOEmK67AqlsZDCd93D+aJE7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yP4ujI587vC9nN6M0gKlE+ubBJ61cT2WnaM0a94yhBg=;
 b=oT7G580f+FMECh4V3DWTYMXcl+PltrxBi4x15cWc3ZhWrPMeCgEi4LQkOdKZ1vw+uj90uVsGsC46IUeg18BhZoZ0qg9a/F8pb4fBFNVKKb4YibT9BpUvHSczH/3dsQysnjjftCphr25+qMU4ak+viwuWEsi4Hs0E5dqiuWBZfn5sEmelr8vxZ2nkC9Sze+aCW5OB1DgLt0/E3x+ZUPrZDRV6GDoI5BYCZsvCVPS1BuC4kmOWBKT67MMMw9BCltFGKMu9yp3598DC9ZVn8BOFYBFEw4DI9q3S0kLVKnZbOMj1ZCFH4PXToJ9vyJXHTWqJL2mQW8aexFykTPTbQetdRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yP4ujI587vC9nN6M0gKlE+ubBJ61cT2WnaM0a94yhBg=;
 b=n+HMS5o+qjyuI9kv7IiQudlETfVQlkDo1Z2JJrOawPGo5JZNpHDCQAaDHVdCI/YzZzRt5g5yjFnhyJDqV2iyZhl3jasfOnhlt6yZ2asH0Ua7FEa3U1ORph9HoqhJmQhG4+IL/TH/fRgaDu0X1wS0qHVLKUnCEBCOmnIA93T9oXk=
Received: from MN0PR02CA0029.namprd02.prod.outlook.com (2603:10b6:208:530::32)
 by IA4PR10MB8568.namprd10.prod.outlook.com (2603:10b6:208:565::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Tue, 20 Jan
 2026 14:45:09 +0000
Received: from BL02EPF0002992E.namprd02.prod.outlook.com
 (2603:10b6:208:530:cafe::68) by MN0PR02CA0029.outlook.office365.com
 (2603:10b6:208:530::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Tue,
 20 Jan 2026 14:45:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BL02EPF0002992E.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Tue, 20 Jan 2026 14:45:08 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 20 Jan
 2026 08:44:37 -0600
Received: from DFLE201.ent.ti.com (10.64.6.59) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 20 Jan
 2026 08:44:36 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 20 Jan 2026 08:44:36 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 60KEiZXQ1223381;
	Tue, 20 Jan 2026 08:44:36 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v8 3/3] crypto: ti - Add support for AES-CCM in DTHEv2 driver
Date: Tue, 20 Jan 2026 20:14:08 +0530
Message-ID: <20260120144408.606911-4-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992E:EE_|IA4PR10MB8568:EE_
X-MS-Office365-Filtering-Correlation-Id: cc4e2e76-fb71-4db6-c4b4-08de58328247
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZQXVvAQi+84IDn8EBgAyyUv2DEe7ubdeUppvtFlFZ5flwo9YEHgW8Qb3hr1r?=
 =?us-ascii?Q?yVxlHCjYc/pS3inuEE5t4RdYXF0TaRmvdq6PzOrhhRCxyY+XXX7woXbz1HsP?=
 =?us-ascii?Q?1g5xJRT3A/VU9SboncPbP++cpe46yAPpHioZ3hoyfQU89ONXnFTNMJEqQzld?=
 =?us-ascii?Q?ZwdkUYxv1bUpq2K8FqbOcljXRj4SGy6rHJGvsmDBviSUGDxKA6+blSKNqt0c?=
 =?us-ascii?Q?b71PS/NYjkZAzj2mkXocAzVA7ZxhhF9BodsG1yZ/yY5yumypC07rBeHgY+YQ?=
 =?us-ascii?Q?MXm80ZpdSoFyhPV+f0tVheExZ97OUWzv5Z0h6oNbEykP31LMqshJl3ZbbNje?=
 =?us-ascii?Q?8ACH3VXb3JtwUOqvWmik/sIBgrHVEvViwFyrPa7do2pj44wVVzZlAy7x7d2K?=
 =?us-ascii?Q?8Vl2vmT8QwsA1IHhHcZds2womtd2f7/Ft1dJGerXoncmo9p6IhR4VWyOxYPF?=
 =?us-ascii?Q?mkri81WEA8XXK+/sDBYlxtd9Z8ZhZmFmlYu/HcZ0GnjjU1HViL19MHof9OTj?=
 =?us-ascii?Q?wUODwUTxUyAn75N64RuK7W0Th8XbIMps7Vtu3zAFhtkWqfTDyoxLqDuDvqrL?=
 =?us-ascii?Q?ae+4LMS7JzWnsZOTKY9I5883H8ukRjaz1AcYQ8LAUs5of/2l2pKb12jaDLFF?=
 =?us-ascii?Q?xzW4COlaMVWo1i1t+6JISwxczg0Ki+KfyHYKFZ2AAAao4BbYcer0QzH1zALI?=
 =?us-ascii?Q?fAPcNJekjUoe6LA4J157uSoG5kbTPViAatFKYuD4h05pexRBToS+8NGoPtsO?=
 =?us-ascii?Q?wwex3HzCBLdiwatZ/E4IBcceU7SR/7Z/UjBE8/ZrLRyM65tdfWlP3rNrHiZg?=
 =?us-ascii?Q?pPqZ1HIFfoEEDd3/xAX+BHMjWIQFb1lygxV654I6MB7y1Du3jMO7XcidWiWQ?=
 =?us-ascii?Q?Iu/ArItjM9IVwJrLOAPOFjoa4ynFfO3fQ7WrlUULI22FUa2Hmh7ZkEWF2wXW?=
 =?us-ascii?Q?i5MW3Zs8CcTUijig3KT0cbuBIGQKkW32rwYr5O0/GMO0/Rez8Rzk2nYL4gOY?=
 =?us-ascii?Q?WabCyLcfjOp1qFeXAHs8nW5OUwrlQ1r49jakzpO04lEA5p3o0fipLgf6iFDh?=
 =?us-ascii?Q?lLHwM33r4WKqjN8pxM4UgSWseFTLq181PJiV0IN26ljIj3Yo4ieA7VLXNXJ7?=
 =?us-ascii?Q?PGFY1CAICcieLL4ypjdVJMR2dtBam6YsTpaheQ+fX1KjBJxJNcePW2fdeW/o?=
 =?us-ascii?Q?unNjZ+RPvp2GnmV5ZNzLOZlWer4d17Y4Kt/UYfSTykbW1XWxs37XT232zkx+?=
 =?us-ascii?Q?WaSFrc3ZuWIfJzFD51BKj1NwuMO4jtag9j/HU5BAKwOhwwdm6byGHEh6vmI/?=
 =?us-ascii?Q?eZrAIAs+QOx2jjto5VzL4H0SYjmUttXXlErqEdLhBTprDLSEdO9bF97j3WWu?=
 =?us-ascii?Q?6pNfhcL+WiALe9VcCMvtLNMjy/IRIpGMQRbLzbKo+3QAsjSBCWhsyWvG4Sns?=
 =?us-ascii?Q?Yl3YGtjeo0zLb8trvBGflRdTma2SDkAkBbA3Kc4cs+xSvAzyJ6WJjik0UuH8?=
 =?us-ascii?Q?uMzrPQuTmqhhVBXCXTGaHfis8/NrQbghHBylyyj/9uEdcAMiL62e2JijFw1b?=
 =?us-ascii?Q?ddFjtBPNOCNwYMshRFosgLouitVA4mF0gkVrsqp2Kc1l0ig7U7C9MEw0RI+w?=
 =?us-ascii?Q?vobq2NXZVRzFLnnYeukw1eP0yUdvcXEzvcF4osJRjpymh8NCQjt7jFLvwMJz?=
 =?us-ascii?Q?FnSZMQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 14:45:08.9280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4e2e76-fb71-4db6-c4b4-08de58328247
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8568

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
index a87b4fe723452..c1f4170cbb558 100644
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
@@ -831,10 +847,6 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
 		return -EINVAL;
 
-	ctx->aes_mode = DTHE_AES_GCM;
-	ctx->keylen = keylen;
-	memcpy(ctx->key, key, keylen);
-
 	crypto_sync_aead_clear_flags(ctx->aead_fb, CRYPTO_TFM_REQ_MASK);
 	crypto_sync_aead_set_flags(ctx->aead_fb,
 				   crypto_aead_get_flags(tfm) &
@@ -843,6 +855,28 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
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
@@ -1005,14 +1039,18 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -1082,20 +1120,54 @@ static int dthe_aead_crypt(struct aead_request *req)
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
@@ -1220,7 +1292,7 @@ static struct aead_engine_alg aead_algs[] = {
 	{
 		.base.init			= dthe_aead_init_tfm,
 		.base.exit			= dthe_aead_exit_tfm,
-		.base.setkey			= dthe_aead_setkey,
+		.base.setkey			= dthe_gcm_aes_setkey,
 		.base.setauthsize		= dthe_aead_setauthsize,
 		.base.maxauthsize		= AES_BLOCK_SIZE,
 		.base.encrypt			= dthe_aead_encrypt,
@@ -1242,6 +1314,31 @@ static struct aead_engine_alg aead_algs[] = {
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
index 0aaecf02258e0..3b6f97356e1b3 100644
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


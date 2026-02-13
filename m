Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012028.outbound.protection.outlook.com [52.101.48.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281CC35F8CF;
	Fri, 13 Feb 2026 13:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770987774; cv=fail; b=RML9/cH09dqH2qjeXRtRcAe/Av9odneM4k+LVMeR/90E2/vMhubSIQrCyTTI84jhbOMF/sFh/4vpYUzWwUSUy4jlDABQ6q42FL5yia4vC71lHWA2xYmKXyKlTDn9slA+/sikDfhk9nRX+kUyJ05Xqno4ZbsNM6t8GbjkMXwX8Z0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770987774; c=relaxed/simple;
	bh=ms3zbeZFFawifCoaVgGUjt7OPkeXRm9DSMgozRstm0U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d1O/OGwfHIUrMIe+ODT5IxqaeoDuJjjwXYWAnUAUMvQP3O5suy4iWOAe6E+h7tR5eVZm+UCwy5J0jRHzszDOV/jWpDe02WZCcPQxG0Ahdx4vzYQRXDOY7VP1rnqPNXqqobyWkWutom8Pbnzf+1KuokgUJld2SKjckvptk/UAi7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=N/9WcIT5; arc=fail smtp.client-ip=52.101.48.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="N/9WcIT5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZyfz7tX9UdW4zZ7wPT36d9Wy6ziKEcfC4f2+WapA/XY0ligupeVhJIPw69EcWdKJs5ZN2r3NY9njOT+YurmDUxeKTS2aLDwH1I+OnBWZa2SXlwn9XD1AQaFTEVuYRr73e0oPTPLrEORNW3oNXTacsg5Il8pLtU/GDKJnT5hpnp7nrkv6v9yUM81EGoXFjvK6oeL1A1erOzwlauciRNhYYEMK+g2TQXaAHFyW9tb2EW3f+fcXUmPv8Vg87nZinCYrRoOiJS3Coa6ofFkmhzj3z0yhKWc7ytL5LP/7ZqkLnsOcc/MjBrBMEbnNBvzF7c7NHYHKc3yDnVm13Il5NZRCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWK5/9pkOcFTYzmVo3/QJ9jsy7jIaoJvta8+PCi3Bx4=;
 b=E2aCUDTCQ1DRqITU0fllx8ZDUqdTeZrDrzaJ5k/OeubMl9ErjXbG9Mb8nQYAfx5nytp7PEsNDVP1iKzgtligN9qeEdTom7RhTzRBM2FZsX96QXj5WzLTHd02KMWlmLpWROKBgUb6/Ujvq6LVWCAJ043GO1kTrZICvvPOC4B+EzoEuuhgNu/2U/9wIX648+qPyY2WQOQ/VYZquCUre/ZOY2VDbClBzX9rV3uFfExTMMrsD0BhixoDU11ibSHEHFLZqOSpPEOWJ0qX7/zJdiTMsz3LwKigZFP24hZSGmy6llfnNHCFzN+TuSAgYt6zd5L7G4xBLO1F7RE6FBDVm1j+/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWK5/9pkOcFTYzmVo3/QJ9jsy7jIaoJvta8+PCi3Bx4=;
 b=N/9WcIT5UwK40MqyKTQAQzzn4GkOTuRav8iHmC56eK5gUMEHXbC3WpF0tIN5zVbdV1/9/zGS6wJ11KvElD+pIekCr4cPgywVhH+QwtuqZXVGD2mcCHmhmLhB2YiLpqUHUd7AqmdfPWyHGjXcQSUF/boDJbXNHMidUHBW0DsndME=
Received: from BN9P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::29)
 by CY8PR10MB7340.namprd10.prod.outlook.com (2603:10b6:930:7f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.11; Fri, 13 Feb
 2026 13:02:51 +0000
Received: from BN2PEPF00004FBF.namprd04.prod.outlook.com
 (2603:10b6:408:10c:cafe::96) by BN9P222CA0024.outlook.office365.com
 (2603:10b6:408:10c::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.13 via Frontend Transport; Fri,
 13 Feb 2026 13:02:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN2PEPF00004FBF.mail.protection.outlook.com (10.167.243.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Fri, 13 Feb 2026 13:02:50 +0000
Received: from DFLE211.ent.ti.com (10.64.6.69) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Feb
 2026 07:02:48 -0600
Received: from DFLE205.ent.ti.com (10.64.6.63) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Feb
 2026 07:02:48 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 13 Feb 2026 07:02:48 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61DD2k1V781914;
	Fri, 13 Feb 2026 07:02:47 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v9 3/3] crypto: ti - Add support for AES-CCM in DTHEv2 driver
Date: Fri, 13 Feb 2026 18:32:07 +0530
Message-ID: <20260213130207.209336-4-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBF:EE_|CY8PR10MB7340:EE_
X-MS-Office365-Filtering-Correlation-Id: f33fd99d-1012-4012-90ee-08de6b003125
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GqYaoJis233WXIag6nSh9InCazBTAdrkSRH3mGxJ/LPgX7SEaTACsP6ZnbzB?=
 =?us-ascii?Q?fTL/4rHUgHRaYnLcPIe6bYu2JTiEfrHBw9nI3ZJMxE8XbDSMXdltrg14kidr?=
 =?us-ascii?Q?uyyDWare3gjLgbl8xGW5/BnRuz5KXi4VbXbnd7R8ToaMMNcjFhzYKVZh0R3O?=
 =?us-ascii?Q?b1HQ8KznJ5hNn5e7Ft7xh1y7Md51jrNKmbNLNG0Tju3OeNZzsy8BUE6B15ic?=
 =?us-ascii?Q?qvbLjAG3GNq1T2IruqJAiUtMuxFOl1jGPyL89eFDVqorU5XhRoiZilNoW8xb?=
 =?us-ascii?Q?EAD6NeHGi1UAGnESyB0GC10IOlYNjSHdYFzsxZUhBMHlS1a6kYeX/xbisccl?=
 =?us-ascii?Q?7CUDmJMz9qMYFe7tR9Hk/IR3stu6lymEUWmZprs3CkxNKcQRDN9JQmfLeaUu?=
 =?us-ascii?Q?FXgQxRMKgqQZPkNAaiW+q8cXZ3REMtu8WOLpIdFrIceLZXiKwpPQKw4Kp0Wn?=
 =?us-ascii?Q?HAwI5Z4Mf1KUoDRgADo+tjXyjIvbE6HR1rc+H1klM1jB8z2ZYdNH7W6KBv+o?=
 =?us-ascii?Q?GPCcai5dng8WThZ0DNnPSGlRV7y21oKmt3Aiu/IKVzqxu4nWlga6fEa6c2fH?=
 =?us-ascii?Q?Gy2iCk+YZRB2714wfxpKLvRq1TDzJt7BdulGRV/RagegfZ6cr0HSKueQqVtn?=
 =?us-ascii?Q?vEVax+PA+uC4GOSUnJPqPLCKpr/oS2qF5UjG279t73ysFEoZCAYY3ZG+cf6g?=
 =?us-ascii?Q?+4ILi0Av0j5iPaKdPpAEBBqFDrE+0yGU3VG+zrOr/i1NhAWmZt0RXRkVDQC/?=
 =?us-ascii?Q?iOCNo500U6Sc0MkvDxh2SMSuEa/X93gT1HEEfVzN3w7sCJ1I7hWi5n0LPd3+?=
 =?us-ascii?Q?lxCPtRTrDppEJXdzeq6U+qrCoCH/69lfVm5ZuC7q2BeBJyIiCY5LTGJd1Tlj?=
 =?us-ascii?Q?OAGyci3HiiM4+Uq+M4j+BxH29wQfn3/8X9GG/Bqb1aOX2c0xLwBrEHL6DPZq?=
 =?us-ascii?Q?hhoVcBNWtzcBzDRrSSYuSnTQnHx/k3JXdt06K3rdKjB5pF0U14ggPQyOLGZZ?=
 =?us-ascii?Q?NSDAgoyuP4R/Sc+UbBTVUP/vWi+eTXqoDZxj+Zh+LLAL+O+ItvmeT8/vvZMI?=
 =?us-ascii?Q?au8Xr/QW7q6jjHDVMfAHFq6qMzoG2uwf1Bw92U2wftGO3BRefSuvlp6qHwyE?=
 =?us-ascii?Q?4WQzENMw4TXNBmm/dO4ynhAqesJWEsVu0d2kWgpILT4yyTqcUBaqkdnE/0qY?=
 =?us-ascii?Q?CEoURbJr/ThtZLhAROgvF6VER0vLylXRrvWd+UcEyGXHtBUIAVVdv82c8wdQ?=
 =?us-ascii?Q?jmti7IVZJn72JAvWOdYcVOUEGMGyr1cB1h4BVI0o2MxF6MABaWvCloLE+fCR?=
 =?us-ascii?Q?kjO3M/drTJdOLEnLfXKKj7LnnMugQ6hwbihArOFPm8fQyd15ZoBAjUv7p/Gu?=
 =?us-ascii?Q?kqUnvm0i/ibC2YgKrqNZw/O/GV5ITa4NcMnwqYrBBOXnhJf6hzmQWsBsdIov?=
 =?us-ascii?Q?0RdRu5Qcy/fxYslaDsclokPoBMkZL2DorxDezBLVJpryZbm1+ogArOXOWHDS?=
 =?us-ascii?Q?xB9nA5hLH6xYyRrSZ81dMZPxtIguk1VT4IzrNaDzWLks7aO0LkAS3BPiAbM5?=
 =?us-ascii?Q?DEvYKgWOGthJHuQJSLBOa2HECoXuQdIasSMRlHEUKeV1g2hPQHmRYUb4l6/B?=
 =?us-ascii?Q?UnofIEsP10iTnK7q42qEmzwjwXMyognXZCgeqHY7p/Ba2VFoUm67EG5GVico?=
 =?us-ascii?Q?AoE3dQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5NK5Ncvbutf80WLZeF82iCsrx6+p+x4KkzUFvpWgMvtc1PKdRfGatb/KWZbQHvhjVzJfRYSb9CEUbuLw6vAxq+9tOt/1rxafoKv6lkBJKQBIXFSMtznRQwhjyTKrFINHVmCGRPiitkUqL/vc/kaWlbKVQJIdkpcq3eU02Y+sOq2++MyD787w75E9R7xU/KDpiD6oGwPi8xWxYWV92pfRMN3INvao33s76h2hORQWMfrMj5ZdGgd4pX3BRv6Mi0f5FUFh1TkMqrEv3Dl4GdQONNVPVSQ6pmepORC6L8K1deNkXaJMnCPtr7OyLq9M78DWIb30Mo2min1UwCkFCwryOx7IvkGoD3DBr2sqAROcQUFcuKfNul52REvaoHJQ3wyDJfSUjiOkA1/UqNwdLj1py8R/HOL7VOcCsYAfRvlxqWyi+WXcnJaBq13coSTsAwvS
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 13:02:50.0789
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f33fd99d-1012-4012-90ee-08de6b003125
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7340

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
index 90cdd7c431149..06098d6768eb3 100644
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
@@ -826,6 +838,28 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
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
@@ -988,14 +1022,18 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -1065,20 +1103,54 @@ static int dthe_aead_crypt(struct aead_request *req)
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
@@ -1203,7 +1275,7 @@ static struct aead_engine_alg aead_algs[] = {
 	{
 		.base.init			= dthe_aead_init_tfm,
 		.base.exit			= dthe_aead_exit_tfm,
-		.base.setkey			= dthe_aead_setkey,
+		.base.setkey			= dthe_gcm_aes_setkey,
 		.base.setauthsize		= dthe_aead_setauthsize,
 		.base.maxauthsize		= AES_BLOCK_SIZE,
 		.base.encrypt			= dthe_aead_encrypt,
@@ -1225,6 +1297,31 @@ static struct aead_engine_alg aead_algs[] = {
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


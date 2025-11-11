Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010056.outbound.protection.outlook.com [52.101.56.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B629B3559EB;
	Tue, 11 Nov 2025 11:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762860130; cv=fail; b=nGWiZfRxY31sCNrXZMFl2lSfQtwcaaJXP1MTVWRDCZbYLh1KuHgxqwuv/UjhlYNjCPPGtex7/GG3mO7CkWzLJnD4s/PbxLVMHETehso45saV12rmcBzTZQK2cb2wNgaRcm5pWs0glktMLkplXjmZTWZdUcr6b101ITGvcAgVdDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762860130; c=relaxed/simple;
	bh=gAdux+MO5oIVboxexijWcBcT7Gz8UZ2uCW+g+B9bMro=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d0AOC1Ut9B3vSQFnwWtABYpS5ptk9Dq+IuPzxVoEmOHgT/ucAjai1eke793QCc2Hu8hyOv26TSJtIVdyQoQaPcd9Xm4/R5BEa/AK/qJpkrCfmaa73oUr/UG3Sq1mseoLT/n6ZIQe2jTnUZZr/DVbRUkuTjVwgPdzb+ogVo+a3Xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=jAY0JCdg; arc=fail smtp.client-ip=52.101.56.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="jAY0JCdg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=auMBIxyLyIR07Ml9r9WMRMjJaMRDdVZ9pp5G7uBiG6xNDngD35XWq2fcOJwRcIS6mFEViJxQZR9LwDD3EmwRld34LcRD4Eg9HnQSTeeo2jrc47QpPpI2ATF+hB295vzwhuP0t2kMt60Edy5k7RoYzupM9CL/iySSK4dAyxBLeMva4n7ixEsNrv6xzTKLDkmeXAuAe2QRGtTTFY+wVx4M3E0DM80pGMkx+XZ2kpIgqi79hAs831tIFNS/z5kTvywYWI/Xf9vZA2hgLBR4y0jxL9EbxGobDU39LLLkRAY7FepA6+siyq5bw2BfWhllxaQCJCUFbSojejKo0+qVkSmscA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZYs8JMLnhobHEhiFzVBfDnKMS/7IYckffjCajtOv+0=;
 b=rcg9fiEJ9uRdwm42F7xUjORDQcfqynFtxy7uoxRNizqzilZAbeZ3jo949X6CooWrKGJVTUraPPuSTcWTqOwjFdbRdYNH+CTHQZdUQ9scP+01ZF0ya3f0d9dsctO5DGVHFx+8WVnEtvGXbeNqKWlfIkmzS4MqeuYuILbcWfo3/mgHGJT4uoSn1z1RurH2fYW1bR3VPcfE/yZYuFQoqAtroki/QwvjnE5XKi5yewp6uYLrRAbqN4QKyDiIe9FI/SY7NLQdfc3N/zSdvPeQen5kZew9kNdZv0lesAw+deS0YMJI2loDqn8PYiTVTz6RMbtUMU3ETXiWGBep13TKW7msag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZYs8JMLnhobHEhiFzVBfDnKMS/7IYckffjCajtOv+0=;
 b=jAY0JCdgIRLaklFbE8sB7wZDYL9JmwALlTWN0kxoqyABpyisesQmDXFn1C6aZ/ltEZxE5SHaWVfO9cFrlmccXYTJslDxzVTOuObI5EK8Tbx5cVj9lCSoUHjoQwHz/DTPTbcTeN5MQ/blAKwYGfmt9SRygFeHuS/jErCJsVRWumQ=
Received: from PH8P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:345::15)
 by BLAPR10MB4881.namprd10.prod.outlook.com (2603:10b6:208:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 11:22:04 +0000
Received: from SN1PEPF000252A1.namprd05.prod.outlook.com
 (2603:10b6:510:345:cafe::1d) by PH8P220CA0009.outlook.office365.com
 (2603:10b6:510:345::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Tue,
 11 Nov 2025 11:22:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SN1PEPF000252A1.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Tue, 11 Nov 2025 11:22:03 +0000
Received: from DFLE215.ent.ti.com (10.64.6.73) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:22:00 -0600
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:22:00 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 11 Nov 2025 05:22:00 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5ABBLxUk828452;
	Tue, 11 Nov 2025 05:21:59 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 3/4] crypto: ti - Add support for AES-GCM in DTHEv2 driver
Date: Tue, 11 Nov 2025 16:38:32 +0530
Message-ID: <20251111112137.976121-4-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A1:EE_|BLAPR10MB4881:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a7a789b-28a3-45b7-38ab-08de21148a0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lRX89cKVqQql/Yt4NChvnuvNTFzP+6iZhw29NmiDuYcsbDTt+5KPc44NvmO8?=
 =?us-ascii?Q?RYbFOXmd0I5iVD0CS0DixwjNoA4FE+mQtvm1gyRAkr5mHZarLS0bmSqm8NbO?=
 =?us-ascii?Q?J+MfmO/w9p0YHzBSOa8eG9FRiUiejHiKuqvY/aaTBzfjhOv17ErK3XKhG//l?=
 =?us-ascii?Q?jFLoky+6mgXaZY4zy16ur6QV4tshjexav8qxtJQlGqbfRQ5DGt/nr6LS3f+2?=
 =?us-ascii?Q?iwcLMB/W/HsYP2b6KMDOz6ie1A86QdCI32fFq6z7ICiHlaNwNONq5j5EiyOV?=
 =?us-ascii?Q?a1bZiDjCzsTQqX+I0mg8IW4beoR5eJA7H1xCuqhksv/qLPtp+YgegUFF2/9q?=
 =?us-ascii?Q?kUIP5cRl29LykheS8qgsRzB/b47jtBebgPW98jSuB9iGnubZ2NfeyP63KrgH?=
 =?us-ascii?Q?ZbJXxnyEaRyYbsnw9M1G8oFTzzLK7eB8oF7ZCq2GsuPvL6L7m9BcOPDcLcq3?=
 =?us-ascii?Q?WpZGLnweJLUxuCkh9xnKBebqo8CMcAuPRbQed0KGNlZx2/D/xTNX3OaSfFPh?=
 =?us-ascii?Q?ZQuWBB5bSSysNEHRc5WYBEFNNeXkfyH9OJ6fYco/Mbxdh+icb3aGteIDCWWi?=
 =?us-ascii?Q?b4nowjf3rSbksy1+ykjea2tIdIY7nuO5QKpFKemC/mn+SW0f3Te9lea0D5Kc?=
 =?us-ascii?Q?LgbdDEDSphCYuDCy9OyismuqzCEZkJKHkH8j/+Gm6ojjDiPPMa0rEUD1elto?=
 =?us-ascii?Q?A5f9NdBqOkXsRamkh2tQyKhep6vo8lze+X7Vambf6IJrDYxWpngOd7nXERg/?=
 =?us-ascii?Q?J/hvVTz+ROwRNZiKhNu+iU47+aHkO6RnYmTdL/tSh5g5uXDppoK/tooSOYnR?=
 =?us-ascii?Q?dJC2BSd4Jons/WwNLTUDo0C+hxi25G9x/LHkF8eClpVBuK/o5P+2908JvXbZ?=
 =?us-ascii?Q?U+CPj6Ej1j2ypLdiF1RjcgkT40KEhnBgU893bozlkBhBy8akA1wEaUJXAFdG?=
 =?us-ascii?Q?KgMBN+0+vVAUziSWxqkyYBaGRZuq81iMB7E8sA4LdT/NIN8xf2PlNB2QhCNe?=
 =?us-ascii?Q?v63OBc0dztPozxA20YFq1QNh07iPfShCIjcqAUkiVpBXTUxOEAPk8zI0zYaA?=
 =?us-ascii?Q?HI2a8DhBZSrKPuh59gJ7xeW1A78Em+rrfj1O/TiwmKcixHlqYFygygCuxSRg?=
 =?us-ascii?Q?uTzdpfCZmuBmIp/DdxTM3GnxneRupWv/MPJETzh3fq5bFvuYHUw+xIEt2OJn?=
 =?us-ascii?Q?SR2vbAW0z0hkWOw51QTuXusl9XX5JO0VpN/3uHlUS3XtiyzqX07qv7rhcQwu?=
 =?us-ascii?Q?XaXAYEnXxhepjDm0JEMAPp9B8a13kMrZ2BbC1O0I/RTnPEUWYWw58gMkTlZK?=
 =?us-ascii?Q?emKJdC73hHpe98q8pfk9b9Du31/NdMJ95VOEfe7mQin/gkzUmCCq+RVS2mN8?=
 =?us-ascii?Q?5/nsvA1JawjxMryt2IZ1Kj1ATpPx0n4QDp/C8eaSVR0GlPY3OMxlwAQOOKvS?=
 =?us-ascii?Q?g07irHyAi5+l7FdKoW4IKD+JAmgdnUFk8qlC/srcXEDbzjW03wbuO2jjKzSy?=
 =?us-ascii?Q?w4AJSakuB3qH4ygvdH2llg/enxachetYYv9DIyl5Ex+dd0UqUMddgjGLDKxQ?=
 =?us-ascii?Q?gPw1tYpEzBNKeJ7L45M=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 11:22:03.2046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a7a789b-28a3-45b7-38ab-08de21148a0f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4881

AES-GCM is an AEAD algorithm supporting both encryption and
authentication of data. This patch introduces support for AES-GCM as the
first AEAD algorithm supported by the DTHEv2 driver.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   2 +
 drivers/crypto/ti/dthev2-aes.c    | 591 +++++++++++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.h |   9 +-
 3 files changed, 600 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 6027e12de279d..221e483737439 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -8,6 +8,8 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_CBC
 	select CRYPTO_CTR
 	select CRYPTO_XTS
+	select CRYPTO_GCM
+	select SG_SPLIT
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
 	  which can be found on TI K3 SOCs. Selecting this enables use
diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 1f4a953c6e2a0..f52e888cc7bd9 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -10,6 +10,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/engine.h>
+#include <crypto/gcm.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 
@@ -19,6 +20,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/scatterlist.h>
 
 /* Registers */
@@ -53,6 +55,7 @@
 #define DTHE_P_AES_C_LENGTH_1	0x0058
 #define DTHE_P_AES_AUTH_LENGTH	0x005C
 #define DTHE_P_AES_DATA_IN_OUT	0x0060
+#define DTHE_P_AES_TAG_OUT	0x0070
 
 #define DTHE_P_AES_SYSCONFIG	0x0084
 #define DTHE_P_AES_IRQSTATUS	0x008C
@@ -65,6 +68,7 @@ enum aes_ctrl_mode_masks {
 	AES_CTRL_CBC_MASK = BIT(5),
 	AES_CTRL_CTR_MASK = BIT(6),
 	AES_CTRL_XTS_MASK = BIT(12) | BIT(11),
+	AES_CTRL_GCM_MASK = BIT(17) | BIT(16) | BIT(6),
 };
 
 #define DTHE_AES_CTRL_MODE_CLEAR_MASK		~GENMASK(28, 5)
@@ -91,6 +95,8 @@ enum aes_ctrl_mode_masks {
 #define AES_IV_SIZE				AES_BLOCK_SIZE
 #define AES_BLOCK_WORDS				(AES_BLOCK_SIZE / sizeof(u32))
 #define AES_IV_WORDS				AES_BLOCK_WORDS
+#define DTHE_AES_GCM_AAD_MAXLEN			(BIT_ULL(32) - 1)
+#define POLL_TIMEOUT_INTERVAL			HZ
 
 static struct scatterlist *dthe_chain_pad_sg(struct scatterlist *sg,
 					     unsigned int nents,
@@ -295,6 +301,9 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 	case DTHE_AES_XTS:
 		ctrl_val |= AES_CTRL_XTS_MASK;
 		break;
+	case DTHE_AES_GCM:
+		ctrl_val |= AES_CTRL_GCM_MASK;
+		break;
 	}
 
 	if (iv_in) {
@@ -552,6 +561,552 @@ static int dthe_aes_decrypt(struct skcipher_request *req)
 	return dthe_aes_crypt(req);
 }
 
+static int dthe_aead_init_tfm(struct crypto_aead *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	ctx->dev_data = dev_data;
+
+	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
+
+	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
+					      CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->aead_fb)) {
+		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+			alg_name);
+		return PTR_ERR(ctx->aead_fb);
+	}
+
+	return 0;
+}
+
+static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	crypto_free_sync_aead(ctx->aead_fb);
+}
+
+/**
+ * dthe_aead_prep_src - Prepare source scatterlist for AEAD from input req->src
+ * @sg: Input req->src scatterlist
+ * @assoclen: Input req->assoclen
+ * @cryptlen: Input req->cryptlen (minus the size of TAG in decryption)
+ * @assoc_pad_buf: Buffer to hold AAD padding if needed
+ * @crypt_pad_buf: Buffer to hold ciphertext/plaintext padding if needed
+ *
+ * Description:
+ *   For modes with authentication, DTHEv2 hardware requires the input AAD and
+ *   plaintext/ciphertext to be individually aligned to AES_BLOCK_SIZE. If either is not
+ *   aligned, it needs to be padded with zeros by the software before passing the data to
+ *   the hardware. However, linux crypto's aead_request provides the input with AAD and
+ *   plaintext/ciphertext contiguously appended together in a single scatterlist.
+ *
+ *   This helper function takes the input scatterlist and splits it into separate
+ *   scatterlists for AAD and plaintext/ciphertext, ensuring each is aligned to
+ *   AES_BLOCK_SIZE by adding necessary padding, and then merges the aligned scatterlists
+ *   back into a single scatterlist for processing.
+ *
+ * Return:
+ *   Pointer to the merged scatterlist, or ERR_PTR(error) on failure.
+ *   The calling function needs to free the returned scatterlist when done.
+ **/
+static struct scatterlist *dthe_aead_prep_src(struct scatterlist *sg,
+					      unsigned int assoclen,
+					      unsigned int cryptlen,
+					      u8 *assoc_pad_buf,
+					      u8 *crypt_pad_buf)
+{
+	struct scatterlist *in_sg[2];
+	struct scatterlist *to_sg;
+	struct scatterlist *src;
+	size_t split_sizes[2] = {assoclen, cryptlen};
+	int out_mapped_nents[2];
+	int crypt_nents = 0, assoc_nents = 0, src_nents = 0;
+	int err = 0;
+
+	/* sg_split does not work properly if one of the split_sizes is 0 */
+	if (cryptlen == 0 || assoclen == 0) {
+		/*
+		 * Assigning both to sg does not matter as assoclen = 0 or cryptlen = 0
+		 * being passed to dthe_copy_sg will take care to copy the sg correctly
+		 */
+		in_sg[0] = sg;
+		in_sg[1] = sg;
+
+		src_nents = sg_nents_for_len(sg, assoclen + cryptlen);
+	} else {
+		err = sg_split(sg, 0, 0, 2, split_sizes, in_sg, out_mapped_nents, GFP_ATOMIC);
+		if (err)
+			goto dthe_aead_prep_src_split_err;
+		assoc_nents = sg_nents_for_len(in_sg[0], assoclen);
+		crypt_nents = sg_nents_for_len(in_sg[1], cryptlen);
+
+		src_nents = assoc_nents + crypt_nents;
+	}
+
+	if (assoclen % AES_BLOCK_SIZE)
+		src_nents++;
+	if (cryptlen % AES_BLOCK_SIZE)
+		src_nents++;
+
+	src = kmalloc_array(src_nents, sizeof(struct scatterlist), GFP_ATOMIC);
+	if (!src) {
+		err = -ENOMEM;
+		goto dthe_aead_prep_src_mem_err;
+	}
+
+	sg_init_table(src, src_nents);
+	to_sg = src;
+
+	to_sg = dthe_copy_sg(to_sg, in_sg[0], assoclen);
+	if (assoclen % AES_BLOCK_SIZE) {
+		unsigned int pad_len = AES_BLOCK_SIZE - (assoclen % AES_BLOCK_SIZE);
+
+		sg_set_buf(to_sg, assoc_pad_buf, pad_len);
+		to_sg = sg_next(to_sg);
+	}
+
+	to_sg = dthe_copy_sg(to_sg, in_sg[1], cryptlen);
+	if (cryptlen % AES_BLOCK_SIZE) {
+		unsigned int pad_len = AES_BLOCK_SIZE - (cryptlen % AES_BLOCK_SIZE);
+
+		sg_set_buf(to_sg, crypt_pad_buf, pad_len);
+		to_sg = sg_next(to_sg);
+	}
+
+dthe_aead_prep_src_mem_err:
+	if (cryptlen != 0 && assoclen != 0) {
+		kfree(in_sg[0]);
+		kfree(in_sg[1]);
+	}
+
+dthe_aead_prep_src_split_err:
+	if (err)
+		return ERR_PTR(err);
+	return src;
+}
+
+/**
+ * dthe_aead_prep_dst - Prepare destination scatterlist for AEAD from input req->dst
+ * @sg: Input req->dst scatterlist
+ * @assoclen: Input req->assoclen
+ * @cryptlen: Input req->cryptlen (minus the size of TAG in decryption)
+ * @pad_buf: Buffer to hold ciphertext/plaintext padding if needed
+ *
+ * Description:
+ *   For modes with authentication, DTHEv2 hardware returns encrypted ciphertext/decrypted
+ *   plaintext through DMA and TAG through MMRs. However, the dst scatterlist in linux
+ *   crypto's aead_request is allocated same as input req->src scatterlist. That is, it
+ *   contains space for AAD in the beginning and ciphertext/plaintext at the end, with no
+ *   alignment padding. This causes issues with DMA engine and DTHEv2 hardware.
+ *
+ *   This helper function takes the output scatterlist and maps the part of the buffer
+ *   which holds only the ciphertext/plaintext to a new scatterlist. It also adds a padding
+ *   to align it with AES_BLOCK_SIZE.
+ *
+ * Return:
+ *   Pointer to the trimmed scatterlist, or ERR_PTR(error) on failure.
+ *   The calling function needs to free the returned scatterlist when done.
+ **/
+static struct scatterlist *dthe_aead_prep_dst(struct scatterlist *sg,
+					      unsigned int assoclen,
+					      unsigned int cryptlen,
+					      u8 *pad_buf)
+{
+	struct scatterlist *out_sg[1];
+	struct scatterlist *dst;
+	struct scatterlist *to_sg;
+	size_t split_sizes[1] = {cryptlen};
+	int out_mapped_nents[1];
+	int dst_nents = 0;
+	int err = 0;
+
+	err = sg_split(sg, 0, assoclen, 1, split_sizes, out_sg, out_mapped_nents, GFP_ATOMIC);
+	if (err)
+		goto dthe_aead_prep_dst_split_err;
+
+	dst_nents = sg_nents_for_len(out_sg[0], cryptlen);
+	if (cryptlen % AES_BLOCK_SIZE)
+		dst_nents++;
+
+	dst = kmalloc_array(dst_nents, sizeof(struct scatterlist), GFP_ATOMIC);
+	if (!dst) {
+		err = -ENOMEM;
+		goto dthe_aead_prep_dst_mem_err;
+	}
+	sg_init_table(dst, dst_nents);
+
+	to_sg = dthe_copy_sg(dst, out_sg[0], cryptlen);
+	if (cryptlen % AES_BLOCK_SIZE) {
+		unsigned int pad_len = AES_BLOCK_SIZE - (cryptlen % AES_BLOCK_SIZE);
+
+		sg_set_buf(to_sg, pad_buf, pad_len);
+		to_sg = sg_next(to_sg);
+	}
+
+dthe_aead_prep_dst_mem_err:
+	kfree(out_sg[0]);
+
+dthe_aead_prep_dst_split_err:
+	if (err)
+		return ERR_PTR(err);
+	return dst;
+}
+
+static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
+{
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
+	u32 val;
+	int ret;
+
+	ret = readl_relaxed_poll_timeout(aes_base_reg + DTHE_P_AES_CTRL, val,
+					 (val & DTHE_AES_CTRL_SAVED_CTX_READY),
+					 0, POLL_TIMEOUT_INTERVAL);
+	if (ret)
+		return ret;
+
+	for (int i = 0; i < AES_BLOCK_WORDS; ++i)
+		tag[i] = readl_relaxed(aes_base_reg +
+				       DTHE_P_AES_TAG_OUT +
+				       DTHE_REG_SIZE * i);
+	return 0;
+}
+
+static int dthe_aead_enc_get_tag(struct aead_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	u32 tag[AES_BLOCK_WORDS];
+	int nents;
+	int ret;
+
+	ret = dthe_aead_read_tag(ctx, tag);
+	if (ret)
+		return ret;
+
+	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+
+	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
+			     req->assoclen + req->cryptlen);
+
+	return 0;
+}
+
+static int dthe_aead_dec_verify_tag(struct aead_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	u32 tag_out[AES_BLOCK_WORDS];
+	u32 tag_in[AES_BLOCK_WORDS];
+	int nents;
+	int ret;
+
+	ret = dthe_aead_read_tag(ctx, tag_out);
+	if (ret)
+		return ret;
+
+	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+
+	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
+			   req->assoclen + req->cryptlen - ctx->authsize);
+
+	if (memcmp(tag_in, tag_out, ctx->authsize))
+		return -EBADMSG;
+	else
+		return 0;
+}
+
+static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
+	ctx->aes_mode = DTHE_AES_GCM;
+	ctx->keylen = keylen;
+	memcpy(ctx->key, key, keylen);
+
+	crypto_sync_aead_clear_flags(ctx->aead_fb, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_aead_set_flags(ctx->aead_fb,
+				   crypto_aead_get_flags(tfm) &
+				   CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_aead_setkey(ctx->aead_fb, key, keylen);
+}
+
+static int dthe_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	/* Invalid auth size will be handled by crypto_aead_setauthsize() */
+	ctx->authsize = authsize;
+
+	return crypto_sync_aead_setauthsize(ctx->aead_fb, authsize);
+}
+
+static int dthe_aead_do_fallback(struct aead_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+
+	SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
+
+	aead_request_set_callback(subreq, req->base.flags,
+				  req->base.complete, req->base.data);
+	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen, req->iv);
+	aead_request_set_ad(subreq, req->assoclen);
+
+	return rctx->enc ? crypto_aead_encrypt(subreq) :
+		crypto_aead_decrypt(subreq);
+}
+
+static void dthe_aead_dma_in_callback(void *data)
+{
+	struct aead_request *req = (struct aead_request *)data;
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+
+	complete(&rctx->aes_compl);
+}
+
+static int dthe_aead_run(struct crypto_engine *engine, void *areq)
+{
+	struct aead_request *req = container_of(areq, struct aead_request, base);
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	unsigned int cryptlen = req->cryptlen;
+	unsigned int assoclen = req->assoclen;
+	unsigned int authsize = ctx->authsize;
+	unsigned int unpadded_cryptlen;
+	struct scatterlist *src = req->src;
+	struct scatterlist *dst = req->dst;
+	u32 iv_in[AES_IV_WORDS];
+
+	int src_nents;
+	int dst_nents;
+	int src_mapped_nents, dst_mapped_nents;
+
+	u8 src_assoc_padbuf[AES_BLOCK_SIZE] = {0};
+	u8 src_crypt_padbuf[AES_BLOCK_SIZE] = {0};
+	u8 dst_crypt_padbuf[AES_BLOCK_SIZE] = {0};
+
+	enum dma_data_direction src_dir, dst_dir;
+
+	struct device *tx_dev, *rx_dev;
+	struct dma_async_tx_descriptor *desc_in, *desc_out;
+
+	int ret;
+
+	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
+
+	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
+	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
+
+	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
+	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
+
+	aes_irqenable_val |= DTHE_AES_IRQENABLE_EN_ALL;
+	writel_relaxed(aes_irqenable_val, aes_base_reg + DTHE_P_AES_IRQENABLE);
+
+	/* In decryption, the last authsize bytes are the TAG */
+	if (!rctx->enc)
+		cryptlen -= authsize;
+	unpadded_cryptlen = cryptlen;
+
+	/* Prep src and dst scatterlists */
+	src = dthe_aead_prep_src(req->src, req->assoclen, cryptlen,
+				 src_assoc_padbuf, src_crypt_padbuf);
+	if (IS_ERR(src)) {
+		ret = PTR_ERR(src);
+		goto aead_prep_src_err;
+	}
+
+	if (req->assoclen % AES_BLOCK_SIZE)
+		assoclen += AES_BLOCK_SIZE - (req->assoclen % AES_BLOCK_SIZE);
+	if (cryptlen % AES_BLOCK_SIZE)
+		cryptlen += AES_BLOCK_SIZE - (cryptlen % AES_BLOCK_SIZE);
+
+	src_nents = sg_nents_for_len(src, assoclen + cryptlen);
+
+	if (cryptlen != 0) {
+		dst = dthe_aead_prep_dst(req->dst, req->assoclen, unpadded_cryptlen,
+					 dst_crypt_padbuf);
+		if (IS_ERR(dst)) {
+			ret = PTR_ERR(dst);
+			goto aead_prep_dst_err;
+		}
+
+		dst_nents = sg_nents_for_len(dst, cryptlen);
+	}
+	/* Prep finished */
+
+	src_dir = DMA_TO_DEVICE;
+	dst_dir = DMA_FROM_DEVICE;
+
+	tx_dev = dmaengine_get_dma_device(dev_data->dma_aes_tx);
+	rx_dev = dmaengine_get_dma_device(dev_data->dma_aes_rx);
+
+	src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
+	if (src_mapped_nents == 0) {
+		ret = -EINVAL;
+		goto aead_dma_map_src_err;
+	}
+
+	desc_out = dmaengine_prep_slave_sg(dev_data->dma_aes_tx, src, src_mapped_nents,
+					   DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc_out) {
+		ret = -EINVAL;
+		goto aead_dma_prep_src_err;
+	}
+
+	desc_out->callback = dthe_aead_dma_in_callback;
+	desc_out->callback_param = req;
+
+	if (cryptlen != 0) {
+		dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
+		if (dst_mapped_nents == 0) {
+			ret = -EINVAL;
+			goto aead_dma_prep_src_err;
+		}
+
+		desc_in = dmaengine_prep_slave_sg(dev_data->dma_aes_rx, dst,
+						  dst_mapped_nents, DMA_DEV_TO_MEM,
+						  DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		if (!desc_in) {
+			ret = -EINVAL;
+			goto aead_dma_prep_dst_err;
+		}
+	}
+
+	init_completion(&rctx->aes_compl);
+
+	/*
+	 * HACK: There is an unknown hw issue where if the previous operation had alen = 0 and
+	 * plen != 0, the current operation's tag calculation is incorrect in the case where
+	 * plen = 0 and alen != 0 currently. This is a workaround for now which somehow works;
+	 * by resetting the context by writing a 1 to the C_LENGTH_0 and AUTH_LENGTH registers.
+	 */
+	if (cryptlen == 0) {
+		writel_relaxed(1, aes_base_reg + DTHE_P_AES_C_LENGTH_0);
+		writel_relaxed(1, aes_base_reg + DTHE_P_AES_AUTH_LENGTH);
+	}
+
+	if (req->iv) {
+		memcpy(iv_in, req->iv, GCM_AES_IV_SIZE);
+	} else {
+		iv_in[0] = 0;
+		iv_in[1] = 0;
+		iv_in[2] = 0;
+	}
+	iv_in[3] = 0x01000000;
+
+	/* Clear key2 to reset previous GHASH intermediate data */
+	for (int i = 0; i < AES_KEYSIZE_256 / sizeof(u32); ++i)
+		writel_relaxed(0, aes_base_reg + DTHE_P_AES_KEY2_6 + DTHE_REG_SIZE * i);
+
+	dthe_aes_set_ctrl_key(ctx, rctx, iv_in);
+
+	writel_relaxed(lower_32_bits(unpadded_cryptlen), aes_base_reg + DTHE_P_AES_C_LENGTH_0);
+	writel_relaxed(upper_32_bits(unpadded_cryptlen), aes_base_reg + DTHE_P_AES_C_LENGTH_1);
+	writel_relaxed(req->assoclen, aes_base_reg + DTHE_P_AES_AUTH_LENGTH);
+
+	if (cryptlen != 0)
+		dmaengine_submit(desc_in);
+	dmaengine_submit(desc_out);
+
+	if (cryptlen != 0)
+		dma_async_issue_pending(dev_data->dma_aes_rx);
+	dma_async_issue_pending(dev_data->dma_aes_tx);
+
+	/* Need to do timeout to ensure finalise gets called if DMA callback fails for any reason */
+	ret = wait_for_completion_timeout(&rctx->aes_compl, msecs_to_jiffies(DTHE_DMA_TIMEOUT_MS));
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		if (cryptlen != 0)
+			dmaengine_terminate_sync(dev_data->dma_aes_rx);
+		dmaengine_terminate_sync(dev_data->dma_aes_tx);
+
+		for (int i = 0; i < AES_BLOCK_WORDS; ++i)
+			readl_relaxed(aes_base_reg + DTHE_P_AES_DATA_IN_OUT + DTHE_REG_SIZE * i);
+	} else {
+		ret = 0;
+	}
+
+	if (cryptlen != 0)
+		dma_sync_sg_for_cpu(rx_dev, dst, dst_nents, dst_dir);
+	if (rctx->enc)
+		ret = dthe_aead_enc_get_tag(req);
+	else
+		ret = dthe_aead_dec_verify_tag(req);
+
+aead_dma_prep_dst_err:
+	if (cryptlen != 0)
+		dma_unmap_sg(rx_dev, dst, dst_nents, dst_dir);
+aead_dma_prep_src_err:
+	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+
+aead_dma_map_src_err:
+	if (cryptlen != 0)
+		kfree(dst);
+
+aead_prep_dst_err:
+	kfree(src);
+
+aead_prep_src_err:
+	if (ret)
+		ret = dthe_aead_do_fallback(req);
+	local_bh_disable();
+	crypto_finalize_aead_request(engine, req, ret);
+	local_bh_enable();
+	return 0;
+}
+
+static int dthe_aead_crypt(struct aead_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct crypto_engine *engine;
+	unsigned int cryptlen = req->cryptlen;
+
+	/* In decryption, last authsize bytes are the TAG */
+	if (!rctx->enc)
+		cryptlen -= ctx->authsize;
+
+	/*
+	 * Need to fallback to software in the following cases due to HW restrictions:
+	 * - Both AAD and plaintext/ciphertext are zero length
+	 * - AAD length is more than 2^32 - 1 bytes
+	 * PS: req->cryptlen is currently unsigned int type, which causes the above condition
+	 * tautologically false. If req->cryptlen were to be changed to a 64-bit type,
+	 * the check for this would need to be added below.
+	 */
+	if (req->assoclen == 0 && cryptlen == 0)
+		return dthe_aead_do_fallback(req);
+
+	engine = dev_data->engine;
+	return crypto_transfer_aead_request_to_engine(engine, req);
+}
+
+static int dthe_aead_encrypt(struct aead_request *req)
+{
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+
+	rctx->enc = 1;
+	return dthe_aead_crypt(req);
+}
+
+static int dthe_aead_decrypt(struct aead_request *req)
+{
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+
+	rctx->enc = 0;
+	return dthe_aead_crypt(req);
+}
+
 static struct skcipher_engine_alg cipher_algs[] = {
 	{
 		.base.init			= dthe_cipher_init_tfm,
@@ -648,12 +1203,46 @@ static struct skcipher_engine_alg cipher_algs[] = {
 	}, /* XTS AES */
 };
 
+static struct aead_engine_alg aead_algs[] = {
+	{
+		.base.init			= dthe_aead_init_tfm,
+		.base.exit			= dthe_aead_exit_tfm,
+		.base.setkey			= dthe_aead_setkey,
+		.base.setauthsize		= dthe_aead_setauthsize,
+		.base.maxauthsize		= AES_BLOCK_SIZE,
+		.base.encrypt			= dthe_aead_encrypt,
+		.base.decrypt			= dthe_aead_decrypt,
+		.base.chunksize			= AES_BLOCK_SIZE,
+		.base.ivsize			= GCM_AES_IV_SIZE,
+		.base.base = {
+			.cra_name		= "gcm(aes)",
+			.cra_driver_name	= "gcm-aes-dthev2",
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
+	}, /* GCM AES */
+};
+
 int dthe_register_aes_algs(void)
 {
-	return crypto_engine_register_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));
+	int ret = 0;
+
+	ret |= crypto_engine_register_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));
+	ret |= crypto_engine_register_aeads(aead_algs, ARRAY_SIZE(aead_algs));
+
+	return ret;
 }
 
 void dthe_unregister_aes_algs(void)
 {
 	crypto_engine_unregister_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));
+	crypto_engine_unregister_aeads(aead_algs, ARRAY_SIZE(aead_algs));
 }
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index f12b94d64e134..7c54291359bf5 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -38,6 +38,7 @@ enum dthe_aes_mode {
 	DTHE_AES_CBC,
 	DTHE_AES_CTR,
 	DTHE_AES_XTS,
+	DTHE_AES_GCM,
 };
 
 /* Driver specific struct definitions */
@@ -78,16 +79,22 @@ struct dthe_list {
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
  * @dev_data: Device data struct pointer
  * @keylen: AES key length
+ * @authsize: Authentication size for modes with authentication
  * @key: AES key
  * @aes_mode: AES mode
+ * @aead_fb: Fallback crypto aead handle
  * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
 struct dthe_tfm_ctx {
 	struct dthe_data *dev_data;
 	unsigned int keylen;
+	unsigned int authsize;
 	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
 	enum dthe_aes_mode aes_mode;
-	struct crypto_sync_skcipher *skcipher_fb;
+	union {
+		struct crypto_sync_aead *aead_fb;
+		struct crypto_sync_skcipher *skcipher_fb;
+	};
 };
 
 /**
-- 
2.43.0


Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010054.outbound.protection.outlook.com [52.101.46.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E38731B122;
	Wed, 26 Nov 2025 11:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764156197; cv=fail; b=S20sj1RLBtv8hfQBPLuZI2UqSu7VULYGLYCB2tv0V9UUf4M1HoLV/fHImQ+088qCh9PTbjKudCWlbX4xyDpCWlhS6TPdG4Ko2z9kZi30eDcj9mrNHevi0lTqs+I/PGzgfXITknza77DwC3UvoAe4ERyk7ZPi2GG+CDGlabinHTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764156197; c=relaxed/simple;
	bh=ZpIoaWmpymHNjnFVeHpIyKpei3YRYpjFdz53dZZAx2Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZCfNXCVhHgauFP/3YYPxjblXWu19lZah8L3Dv8ULtymUsonH4T/zg7p7h5I4/im9NlLXr7v2OpPxKLc677Ow73KVjgPj98Ac8oP0aS4hJoXgtoQFLgiuojIvYyt9DHeDL94du0Cj7eT+l60AcaoC6/4bCooSMI3vwcZEtp4QsAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=vqZGw+d2; arc=fail smtp.client-ip=52.101.46.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="vqZGw+d2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kc+MS27xrz0gANtZl+xojHKRNVctTeI+d4f+MAuuE4J2WNF/xlmX3pxTpf98rDmzmUI7W/M+G4tRCPa3HSakMkEzIQllJDGveVAZUgZNpqRru3gkSAA+0WBMKPcfrCJXR2JxIQHhkMhAmclDigVLvYKsBnHsQ5N+beyOBWU3xvZxVe3FNdcc+RAMCLdYnlwKGcY5BvhQsPoG2MMBJ1whNJq06PnasgSCWz9XK1D6LbWQpKAlLnoo+/8okqudqt8HPJaHH6EvFcUtB8u5dZMC3/cO2MI03zkPK0Ix57cJQdViIIiG7eIenOLmKZuYmqpznY19mBzlTRBIfFcQZGQnDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gCQK3i/rjFah/r64aMB5OlR2hBqCsOLxkTwoZrv3rQ=;
 b=FdAy0KCzL1pCyYi4X2rl13nWBB5B3T1KgRaVbkiCggp++k2CGaZekZxGxdiiP5cLFxkaL8J2J+kDjm3m8iimcGdmP0rXgc0m40hjqKWHIrQnx0Ym08Vqj33iUC8UU30jHs4e4ybvVizNNGre/sdy3J5PXWtH4WEn5E4Zp+uMi287Y2jp04TpPvgr1Bw73jbFJvxGYCABzuqALK1rnGbcn/IugJG4mQaUJv6sQJCadedKt04HvqWeU4hJJe3ULhADMVKtvv/O3Pirn/+b4/pVa0P6fEG12n21pX2Xt48UJLLRv8ZDHIgpRQAPRTMf/U+JMp2OEg93DJxLtz4NLLILGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gCQK3i/rjFah/r64aMB5OlR2hBqCsOLxkTwoZrv3rQ=;
 b=vqZGw+d2lJT7hHb0UuOuYO26HhR+q4Hy85H58b7uBAI/+cdOFXE4cieoLC+ACRGuKyjpVCRHASR/X7X8cOCsWs/XOryzXJ6Ieo7XsRStPK8HqIjcLbaO3mcN9g99NtYgfnuSkqCgXB1Mpu2JL+81OFMxmjwXcwt8hGjO4D78Wls=
Received: from BYAPR06CA0043.namprd06.prod.outlook.com (2603:10b6:a03:14b::20)
 by SJ2PR10MB7785.namprd10.prod.outlook.com (2603:10b6:a03:56b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 11:23:09 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:14b:cafe::5d) by BYAPR06CA0043.outlook.office365.com
 (2603:10b6:a03:14b::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Wed,
 26 Nov 2025 11:23:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 11:23:07 +0000
Received: from DFLE209.ent.ti.com (10.64.6.67) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 05:23:03 -0600
Received: from DFLE208.ent.ti.com (10.64.6.66) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 05:23:03 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 26 Nov 2025 05:23:03 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5AQBN1UV1141216;
	Wed, 26 Nov 2025 05:23:02 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v7 1/3] crypto: ti - Add support for AES-CTR in DTHEv2 driver
Date: Wed, 26 Nov 2025 16:46:15 +0530
Message-ID: <20251126112207.4033971-2-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|SJ2PR10MB7785:EE_
X-MS-Office365-Filtering-Correlation-Id: 1edd20bb-37e0-4e98-cc0d-08de2cde2cae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v//XSAhLI1Z/kHseIlfpJMLWVTiM+YerT4By4Fym7mwn7v/uHce3CpITIsLa?=
 =?us-ascii?Q?tl2wyGaIlk4c//FeEIV4p5B4Yn9ouj06ANHjgB8+6d5Vz8G/IUAioJaDNgYy?=
 =?us-ascii?Q?HVQUm546MR8tVKO1X7mBrtf5+L8Q4VHbir2nNVVfVebx4UfuFNUj2kjlzZdX?=
 =?us-ascii?Q?4OS8Dd7CyzX2v7xmlMlk9U7eYcGxfk60hPfbHQQ/0d6+5b+gdryWfI+R7L8J?=
 =?us-ascii?Q?EfB8kShexRRzKXhKhuUnXFFrBkbHXXkSak/xwEpc33AoR8l9elrNU7QkADyq?=
 =?us-ascii?Q?P3RqCDikQJ6x+F45dm9nCsgr1XaifJ3Cpg8qxp0Re7k4GDmi4v7IdBMYh/zV?=
 =?us-ascii?Q?gIpqE3RhE2Na9fM5FRL4yao9BbN5sEd5ySsxccH0sDViXlFfW2mVWQgwV/r7?=
 =?us-ascii?Q?aP04gypShJFIzxH0jskvr4mmnDRJ9UQ2MnA2UaloxS92+VkA8BdHrmwgaaMU?=
 =?us-ascii?Q?BED/d2wRaJjrgs0GBSjJ5m7SRdki9l4GcqM8MowYqtoNLKJR6+b6+wO03I1M?=
 =?us-ascii?Q?vJsguNLWLzTUgygO88vwhmdhrjlBpqTjgHhQ42LOn+zNSs+QrSg9JbdL1/VI?=
 =?us-ascii?Q?WGBpCmrcq4if9aWaW4Yc1j7hvI+KeKIyO6rsEXBsEM8p/Nby6XEuv514SgDK?=
 =?us-ascii?Q?RZKtSbq3ct5DiyZoDpslwZUMz/PuOVvsm5mSDrIH2BlzWtiE+Uu/OByH4n+r?=
 =?us-ascii?Q?TxqEufpoCn2nt3qS+ibyTejhFF1i3xIhOePf7Sx4wW87J5wUnnR5FiJCZFNB?=
 =?us-ascii?Q?pHzEGAOv1V3smCPbtltRDVgyZKBiQPoNB4rH4NuQPgOht88RDI9+VS1WuyLb?=
 =?us-ascii?Q?mpOsl1+1zw9CmTI7Lwq/T/IgqwrhJ+B1LjSZT66h+RJGx4pJkR7Yj4WHOw0K?=
 =?us-ascii?Q?/8eoeFvRiLOZZTr2If8yIlIypbGjUcTUNsr9QW9Uc669JE9ExaQOa4e2fP34?=
 =?us-ascii?Q?EuqyAx3hiWzaAYEmov7H8WS9UQbzsCp+sL8NKIeeL0mTenSvJ83SkOuDepiU?=
 =?us-ascii?Q?3lJyJArfSDwH9U8QPr+F8SpQyJTkPOpsytT7LEZ4zln27OofIV9T3qtKBrC7?=
 =?us-ascii?Q?9DreyIO1H8VyYpZ2l+Os8/RoXVLGnGVRq7kW/Joz/+v9XvnBj1Y8jKkgLh4J?=
 =?us-ascii?Q?h4l5mcIBZY11aCjklyYEmg43fqW075IPkMLetWCpPbS8yF/f9spE5LVS2sGU?=
 =?us-ascii?Q?e+JCoIxe+LuSO3DmaMZUhzr5tzzajN+NGYgjfH+Iufizv09iQmMDGCBQA8KC?=
 =?us-ascii?Q?27bU989F6UO16MR4/o1NNFlQFiK5OWXMEs7p0/ihlFYJBpcA72XnQGC/kD3J?=
 =?us-ascii?Q?CRJmVWodrQyJwOoRpxtfR+nhi7GrH/NmWz1w9/PR7eZyI1I1QcOfNO4Fjs9e?=
 =?us-ascii?Q?aelAvWPMymnDKayk9GcoA086MmlXPMUHJCK82SKbg1+Ndk21nReSgc2X6BYi?=
 =?us-ascii?Q?bDtchAq3bYgqpCPBGEf86mbDrEiFj//gtiqu5F7ewITQpE3wl29KHF6+SD9g?=
 =?us-ascii?Q?I7xK6VZosyCP3Fff6x3YBfzCKAci7qpMJ0ADNAHymoZbJr0F0wgiAV3XsgdG?=
 =?us-ascii?Q?6eJqgRNI7p5iAaWVE2M=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 11:23:07.6425
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1edd20bb-37e0-4e98-cc0d-08de2cde2cae
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7785

Add support for CTR mode of operation for AES algorithm in the AES
Engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 140 ++++++++++++++++++++++++++++--
 drivers/crypto/ti/dthev2-common.h |   4 +
 3 files changed, 136 insertions(+), 9 deletions(-)

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
index 156729ccc50ec..3cffd6b1d33e1 100644
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
@@ -89,6 +92,46 @@ enum aes_ctrl_mode_masks {
 #define AES_BLOCK_WORDS				(AES_BLOCK_SIZE / sizeof(u32))
 #define AES_IV_WORDS				AES_BLOCK_WORDS
 
+static struct scatterlist *dthe_chain_pad_sg(struct scatterlist *sg,
+					     unsigned int nents,
+					     struct scatterlist pad_sg[2],
+					     u8 *pad_buf, unsigned int pad_len)
+{
+	struct scatterlist *sgl;
+
+	sg_init_table(pad_sg, 2);
+	sgl = sg_last(sg, nents);
+	sg_set_page(&pad_sg[0], sg_page(sgl), sgl->length, sgl->offset);
+	sg_set_buf(&pad_sg[1], pad_buf, pad_len);
+
+	/* First nent can't be an empty chain nent */
+	if (nents == 1)
+		return pad_sg;
+
+	sg_chain(sgl, 1, pad_sg);
+	return sg;
+}
+
+static void dthe_unchain_padded_sg(struct scatterlist *sg,
+				   struct scatterlist pad_sg[2],
+				   unsigned int nents)
+{
+	struct scatterlist *sgl;
+	unsigned int i;
+
+	/*
+	 * The last 2 nents are from our {src,dst}_padded sg.
+	 * Go to the (n-3)th nent. Then the next in memory is
+	 * the chain sg pointing to our {src,dst}_padded sg.
+	 */
+	for (i = 0, sgl = sg; i < nents - 3; ++i)
+		sgl = sg_next(sgl);
+	sgl++;
+	sgl->page_link &= ~SG_CHAIN;
+	sg_set_page(sgl, sg_page(&pad_sg[0]), pad_sg[0].length, pad_sg[0].offset);
+	sg_mark_end(sgl);
+}
+
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -156,6 +199,15 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 	return dthe_aes_setkey(tfm, key, keylen);
 }
 
+static int dthe_aes_ctr_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	ctx->aes_mode = DTHE_AES_CTR;
+
+	return dthe_aes_setkey(tfm, key, keylen);
+}
+
 static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -236,6 +288,10 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
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
@@ -270,12 +326,17 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 
+	struct scatterlist src_pad[2], dst_pad[2];
+
 	int src_nents = sg_nents_for_len(src, len);
-	int dst_nents;
+	int dst_nents = sg_nents_for_len(dst, len);
 
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	u8 *pad_buf = rctx->padding;
+	int pad_len = 0;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -295,6 +356,32 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	aes_irqenable_val |= DTHE_AES_IRQENABLE_EN_ALL;
 	writel_relaxed(aes_irqenable_val, aes_base_reg + DTHE_P_AES_IRQENABLE);
 
+	if (ctx->aes_mode == DTHE_AES_CTR) {
+		/*
+		 * CTR mode can operate on any input length, but the hardware
+		 * requires input length to be a multiple of the block size.
+		 * We need to handle the padding in the driver.
+		 */
+		if (req->cryptlen % AES_BLOCK_SIZE) {
+			/* Need to create a new SG list with padding */
+			pad_len = ALIGN(req->cryptlen, AES_BLOCK_SIZE) - req->cryptlen;
+			memset(pad_buf, 0, pad_len);
+
+			src = dthe_chain_pad_sg(req->src, src_nents, src_pad, pad_buf, pad_len);
+			src_nents++;
+
+			if (req->src == req->dst) {
+				/* In-place operation, use same SG for dst */
+				dst = src;
+				dst_nents = src_nents;
+			} else {
+				dst = dthe_chain_pad_sg(req->dst, dst_nents, dst_pad,
+							pad_buf, pad_len);
+				dst_nents++;
+			}
+		}
+	}
+
 	if (src == dst) {
 		diff_dst = false;
 		src_dir = DMA_BIDIRECTIONAL;
@@ -311,19 +398,16 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
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
 
@@ -386,11 +470,24 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
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
+		/*
+		 * Last nent in original sglist is converted to a chain sg.
+		 * Need to revert that to keep the original sglist intact.
+		 */
+		if (src_nents > 2)
+			dthe_unchain_padded_sg(req->src, src_pad, src_nents);
+
+		if (req->src != req->dst && dst_nents > 2)
+			dthe_unchain_padded_sg(req->dst, dst_pad, dst_nents);
+	}
 
-aes_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
@@ -408,6 +505,7 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 	 * If data is not a multiple of AES_BLOCK_SIZE:
 	 * - need to return -EINVAL for ECB, CBC as they are block ciphers
 	 * - need to fallback to software as H/W doesn't support Ciphertext Stealing for XTS
+	 * - do nothing for CTR
 	 */
 	if (req->cryptlen % AES_BLOCK_SIZE) {
 		if (ctx->aes_mode == DTHE_AES_XTS) {
@@ -421,7 +519,8 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 			return rctx->enc ? crypto_skcipher_encrypt(subreq) :
 				crypto_skcipher_decrypt(subreq);
 		}
-		return -EINVAL;
+		if (ctx->aes_mode != DTHE_AES_CTR)
+			return -EINVAL;
 	}
 
 	/*
@@ -500,6 +599,29 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		},
 		.op.do_one_request = dthe_aes_run,
 	}, /* CBC AES */
+	{
+		.base.init			= dthe_cipher_init_tfm,
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
+						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_module		= THIS_MODULE,
+		},
+		.op.do_one_request = dthe_aes_run,
+	}, /* CTR AES */
 	{
 		.base.init			= dthe_cipher_xts_init_tfm,
 		.base.exit			= dthe_cipher_xts_exit_tfm,
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index c7a06a4c353ff..e8841fda9a46f 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -32,10 +32,12 @@
  * This is currently the keysize of XTS-AES-256 which is 512 bits (64 bytes)
  */
 #define DTHE_MAX_KEYSIZE	(AES_MAX_KEY_SIZE * 2)
+#define DTHE_MAX_PADSIZE	(AES_BLOCK_SIZE)
 
 enum dthe_aes_mode {
 	DTHE_AES_ECB = 0,
 	DTHE_AES_CBC,
+	DTHE_AES_CTR,
 	DTHE_AES_XTS,
 };
 
@@ -92,10 +94,12 @@ struct dthe_tfm_ctx {
 /**
  * struct dthe_aes_req_ctx - AES engine req ctx struct
  * @enc: flag indicating encryption or decryption operation
+ * @padding: padding buffer for handling unaligned data
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
  */
 struct dthe_aes_req_ctx {
 	int enc;
+	u8 padding[DTHE_MAX_PADSIZE];
 	struct completion aes_compl;
 };
 
-- 
2.43.0


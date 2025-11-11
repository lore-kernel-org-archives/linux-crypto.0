Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012055.outbound.protection.outlook.com [52.101.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3F435581D;
	Tue, 11 Nov 2025 11:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762860128; cv=fail; b=B1kBSeSkw5S1f5EF5rnM/dV1UQQqzEvqy3P6C/kornAFIe7WYJwiDuwwuQVR2GPRIIyzXTuUTiMCnExcXhHIF+FS8KIMobAX6AxaqBU0fqXrO+dgGlZ0EF2PJ+y3M1hSSWy7CQ3CMYTSFEh8AGxinxKkPlhP0QhJSbhmwvefL30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762860128; c=relaxed/simple;
	bh=Oq4yY7DOrd9bjjq4S/jpwSlYLvtP+T+E3kqLoxTnd08=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jQP6/faebSX0giiOvF/awFqqLYHub2LcwF8/844ZN8344m0InWD9uuzb8HR5E6Geo7ln7r6o9SLMWn8vr6czwt7fIDLOHyYVeRM6w9vqttOOUzPwMebKYb+9tlafUZNe/i5qLBLNGetu3+OWg+o4AO66Ebgpl+3qPGstbyx+EyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=aQv03cCB; arc=fail smtp.client-ip=52.101.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="aQv03cCB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OR+Dx2/2I1sp8QJwCLNx1Yf7bbbHUyVT5fDcYKxwITsGqCPAweUlUnzStB6prheU1Mm8DEP4pB3QMQue4gShFesatWRJVMpL49P6ANP8ItHsNJq1yCHPb97X+/wb5QxX5qXbiMPwRmr+9bbhkaM6+DciFKLqUKkJJQ5VdBdFw7wQgAJ/ZTbVzu3TKsIabvB8X+zdc0nwKNEN+ZyuVQOKeNcNh1/zivlY2XdTnSH6aTI+9sDzBnMBhhnHADU6ISrDAERoBT7/XP0G1UR/4hzZB/+5o9XTUQN/HcotyOfRQ6xhhpGV7+CuoN2NSXpJpqf1jcy6lz4eLzKBavkwEzegYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVrc7ta9SwmUd4CLFd0QkzOJcbe7LwqGpkOEvfVvcgM=;
 b=MMNScpe3Vvb5Hvmfyym0/g2yhTmph2ndwM9S1sAsRtfOgX2zCG2B0/LAOT6k0AioeWucRDBQVJ1oDhx8BKXYRJLhAUc63wys2UpFqRT/jikagfUrR7G/WqEFBBqBiArxha6Nx0gfRjFaUDtOwdMsvXrdN5dqx6cfoLknnoCI1U9dgJcrQY9L/PsQPSOVDLWNEyWgkcA3I5/0d9irrvVjPVEJKPFRyHfRyZB2hW8f/bREZoOb/scbd2U0/wN1du0LI6reB2mP6EqCrRa9Umoz5bagAJhQ5qqJ1/jBWUy4/6MsEZJoAAQMWCsisqB/y4ckepJKnB+9B5AkTWa8IyBtwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVrc7ta9SwmUd4CLFd0QkzOJcbe7LwqGpkOEvfVvcgM=;
 b=aQv03cCBx/Qjf/uo5l6JWDX/dy2liQtYgEG2RlEPXVLL34S14W0PWBl5k7oDcXPVm+pyjRj3yb/eT/E8JMj5m1vJnhIv4LahGW+CZfMj5H2JYjTz2BMqYVHUEyTrFIv+NSBTjzlIoWqYmRr42pSpNsFru3XTkNBxf0U/HzJcxZw=
Received: from SJ0PR13CA0021.namprd13.prod.outlook.com (2603:10b6:a03:2c0::26)
 by PH7PR10MB5880.namprd10.prod.outlook.com (2603:10b6:510:127::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 11:22:03 +0000
Received: from SJ1PEPF00002315.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::84) by SJ0PR13CA0021.outlook.office365.com
 (2603:10b6:a03:2c0::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Tue,
 11 Nov 2025 11:21:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 SJ1PEPF00002315.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Tue, 11 Nov 2025 11:22:03 +0000
Received: from DLEE206.ent.ti.com (157.170.170.90) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:21:57 -0600
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:21:57 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 11 Nov 2025 05:21:57 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5ABBLtmf861380;
	Tue, 11 Nov 2025 05:21:56 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 2/4] crypto: ti - Add support for AES-CTR in DTHEv2 driver
Date: Tue, 11 Nov 2025 16:38:31 +0530
Message-ID: <20251111112137.976121-3-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002315:EE_|PH7PR10MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: acccc942-23d8-4e61-deac-08de21148a0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nbYjojY9QLPbsUZnSy5HBAte7NnN1gm/3rFAQgL6Sjqlje7+MgLa1bcarCxC?=
 =?us-ascii?Q?WiUC4JZCY9c6QBg3VVZWdRec2wDnPCYlZ+NJwhGx3BkaIHJ9UhBn8ZEotGal?=
 =?us-ascii?Q?B0i2K0WDGOsQl02oBZBjeZdQd0Eq6N6WI3xh3VllADEgpKfkFMKVtO3gagKJ?=
 =?us-ascii?Q?QzHR1nfwF1sF4frDNGEPetOjvux/VoZAI2HUJsBNK8tdvGwqbnR0jKfX95HE?=
 =?us-ascii?Q?qP3zqP4l/x+T+ozc3c5XWCDxXFLx5uK55VQcW6k51vPfTdGJ7pCGspElqSs5?=
 =?us-ascii?Q?vanyz2n2CZs4F/IDDHvt6K+eYImHc1vvJUvX1B+nJqOo+WltmUqPEKBZW1gD?=
 =?us-ascii?Q?J6/v8sSbBRMoIDOC21CSie8DCBBrcjwH8Qk+7eVRGnWdbbz63VZrRwv9n2Zl?=
 =?us-ascii?Q?ZFKZxzPcXdz6tj8T1sdCgZc/7kKOY5dDSBPlqa5NvY61X+42LHAQIy0MatkU?=
 =?us-ascii?Q?ABhzw0i285TtVh7MAPbWRkzfHyx8g+6s0qNmbFvuZ0jhnoseJWIWwTrP6bjb?=
 =?us-ascii?Q?Eys+RJqKvcdLW8kZpdu7ceVa0RaXwO7WNHNrJODy8ObrSE9l6J5Psq/dPUz8?=
 =?us-ascii?Q?WbLvqe8pOxQ+nJwuhh/YcH0zeaqAy2mqKaGJCT+bqqiogcoJmK1J/jjwwjVg?=
 =?us-ascii?Q?/fDkoRyyN/nTL9cH9p6BCx/Ij2REcRxQpLQWg+uGya48QaetFffgIn11a+w/?=
 =?us-ascii?Q?/lOTSxkEHcxN4FI9aHHAM7ZqONGO6arYKZx3HP+XEcwkEBhm6ZPimmbkXACc?=
 =?us-ascii?Q?VK2hROOPT3QCZwxY3ntHnSXNDgIfYwVgod5o55AOJ8GVhMcMOJdbnYdWOCoQ?=
 =?us-ascii?Q?KVZqyOviFuEARuzOwYZrCXY8Ha4cElcVNGH21anRvIcAT5Jpu84iWDg+PFSI?=
 =?us-ascii?Q?iOtZjS2M9jTxYnBIKdE0ebEejxl2o0WDpk0vpgOtoz6m8mk6IBax6FNK90W2?=
 =?us-ascii?Q?9XKoueOqcL1ml5G4V37pJ/Gg6tR7mpKop9nS5GZmYDPM5MqxorPX9GGbEteM?=
 =?us-ascii?Q?cXlFosX+yYtiQC1/gBX62i3NP4hHtpYoC2zpxvQtkKt8DBlEF3XlbEFazb6C?=
 =?us-ascii?Q?yJz4ET1f50C/FQssrR5U1JWlqk6t3FBMJMgQUBBhrfSuWPL80dnXPPJjFdtI?=
 =?us-ascii?Q?h8PD3jA0DRNP1iWg5tvGZCsALpDSkGLJHJ6xRgLIDitD8KS/BalAB0lKXmgH?=
 =?us-ascii?Q?V7yTsJOWYzcRCNWhLIcquamrrv6glxqk+dqruofv5RK0tUu67DChL23xOehT?=
 =?us-ascii?Q?iUZyJzmOgX2/gSlkonYB49e5rwkE+ibEsaxDBZX1NqQvVbEePkunmF7yGMlB?=
 =?us-ascii?Q?fpO9z3aPonGPIYVEZ2tpJnVVpzjCW1rUurVnFxF5ljadTkCHAM/nJg9aCfOk?=
 =?us-ascii?Q?yVtxPixXIAbd5UHt7XzJtxDGpcUoz32bEiQSJp9Pi6LIZPPcWqLOaBW02aNU?=
 =?us-ascii?Q?FNRDVy1R+HK0buBXg0RFf6sT71km9I9f4qtTMcIxiZtIiuT8lnoipRF/3xJZ?=
 =?us-ascii?Q?tnKUdFnGbsZPbmcCQcL42ORPojnqTsVDS2IAFSfRPs4M3PlyDc/Wzsam0AYB?=
 =?us-ascii?Q?2oZW8V2qPYPSV+wJeSg=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 11:22:03.1752
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acccc942-23d8-4e61-deac-08de21148a0e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002315.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5880

Add support for CTR mode of operation for AES algorithm in the AES
Engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 139 ++++++++++++++++++++++++++++--
 drivers/crypto/ti/dthev2-common.c |  19 ++++
 drivers/crypto/ti/dthev2-common.h |  15 ++++
 4 files changed, 165 insertions(+), 9 deletions(-)

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
index 7d8123984c1eb..1f4a953c6e2a0 100644
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
 
+	u8 pad_buf[AES_BLOCK_SIZE] = {0};
+	int pad_len = 0;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -295,6 +356,31 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
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
@@ -311,19 +397,16 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
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
 
@@ -386,11 +469,24 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
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
@@ -408,6 +504,7 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 	 * If data is not a multiple of AES_BLOCK_SIZE:
 	 * - need to return -EINVAL for ECB, CBC as they are block ciphers
 	 * - need to fallback to software as H/W doesn't support Ciphertext Stealing for XTS
+	 * - do nothing for CTR
 	 */
 	if (req->cryptlen % AES_BLOCK_SIZE) {
 		if (ctx->aes_mode == DTHE_AES_XTS) {
@@ -421,7 +518,8 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 			return rctx->enc ? crypto_skcipher_encrypt(subreq) :
 				crypto_skcipher_decrypt(subreq);
 		}
-		return -EINVAL;
+		if (ctx->aes_mode != DTHE_AES_CTR)
+			return -EINVAL;
 	}
 
 	/*
@@ -500,6 +598,29 @@ static struct skcipher_engine_alg cipher_algs[] = {
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
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index c39d37933b9ee..a2ad79bec105a 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -48,6 +48,25 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 	return dev_data;
 }
 
+struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
+				 struct scatterlist *src,
+				 int buflen)
+{
+	struct scatterlist *from_sg, *to_sg;
+	int sglen;
+
+	for (to_sg = dst, from_sg = src; buflen && from_sg; buflen -= sglen) {
+		sglen = from_sg->length;
+		if (sglen > buflen)
+			sglen = buflen;
+		sg_set_buf(to_sg, sg_virt(from_sg), sglen);
+		from_sg = sg_next(from_sg);
+		to_sg = sg_next(to_sg);
+	}
+
+	return to_sg;
+}
+
 static int dthe_dma_init(struct dthe_data *dev_data)
 {
 	int ret;
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index c7a06a4c353ff..f12b94d64e134 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -36,6 +36,7 @@
 enum dthe_aes_mode {
 	DTHE_AES_ECB = 0,
 	DTHE_AES_CBC,
+	DTHE_AES_CTR,
 	DTHE_AES_XTS,
 };
 
@@ -103,6 +104,20 @@ struct dthe_aes_req_ctx {
 
 struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
 
+/**
+ * dthe_copy_sg - Copy sg entries from src to dst
+ * @dst: Destination sg to be filled
+ * @src: Source sg to be copied from
+ * @buflen: Number of bytes to be copied
+ *
+ * Description:
+ *   Copy buflen bytes of data from src to dst.
+ *
+ **/
+struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
+				 struct scatterlist *src,
+				 int buflen);
+
 int dthe_register_aes_algs(void);
 void dthe_unregister_aes_algs(void);
 
-- 
2.43.0


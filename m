Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013071.outbound.protection.outlook.com [52.101.83.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7463C1984;
	Wed, 14 Oct 2026 19:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792004632; cv=fail; b=aQPeL7JP5oTolwiZFrvwa2KhJ7dbzsxkmqkiqMG8mjEbYnc14FTb8LtBv1fVsamwACdKVuUpp81E2GxDXHVTC/pKugc7syoDajxdJ7/wZmUroZvPK7rEkHIoxyqRh5cFMKrC5p/keFPLmDgIv9Z/CNIt7HIjs/IKgrh+meO838g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792004632; c=relaxed/simple;
	bh=GGFSU3faEEg65D68Ku4NlJe+PqS7CWvw94rfp3iYRAk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=W3OTan38XvwfWpZdTZl4aah69d8n4vf/zq5Eh802/rl3RUBPeSDZmjmAg1/crVNZkupoiZpVjBZ170wqIsd/d0ZJmTc4xxUJMdnuPgNTCa6Px6mEWbF91MdW+I3mlVioSmiqgOqVC5pCc04ln1vL5jWbCBgndIZnF28TevlcX7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=I62izhux; arc=fail smtp.client-ip=52.101.83.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="I62izhux"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a8Ep+zUoE3snmgkBXrGi6EkRr8lQmGNvNQSBICprXxWOblMAMPAZ76wstVscV8Xxa846VK1uNRjsPa53px/hxazQdGFcCtVug1TY1hM/dT044k+91OAb+/axil+oxobb/320ax6apBQkqJNtIE87YY4TsHjcMxjvJQmNQm5i830SKfAfQ0HIWXrYY3i6DJzeUWb5RnK8ZNFBYvb9oJuoQuW0g1Sm1KzmswO5oIuaoUZ5hY8yY9egKHDjfPUZvEnztzKGFj+R5L5gi8p9SU5BJzhnyO4wStkEbadyUvpwOX2IcjKTi+hesRfMI8vHhZlqJ66061WgZm74SdX2plnh3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0zN63vbOmDx5ET2iHdtl7Bw1EF9pF0okqQc+kGba3I=;
 b=fzjMk5LO/p9CB50YLSnYsLLKg6Dw9CUb3Hqwi98rKFb1WQJ9DNXfuqeMqQ97H7NAU7oX3+bg2zmdoJwYQ2RJ1WyZYL/URmD9I3CtBuJoZKVqOmdyttKJTfWKvfLiToCfIBHuayWGVmSXso7+G/F5K/oM6lgkC6OxsrZyBusSDD/dDhvPOGN+qo0HOSPK6xXMJlTWchqz6aouhzH20bl6TCgVLhx6rhGLrLes1EcEQ5sSta26C5u9rNwOJwHyT6xG9Xtv7PDx5sdq3xjgG3UfwrUphs3Ue3i4/ZgbVtn0FnmcXmmgXvtS1hlqRwfASayP+UyiVCDO0qLdoi6VN8pwww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0zN63vbOmDx5ET2iHdtl7Bw1EF9pF0okqQc+kGba3I=;
 b=I62izhux5g0uAouzufQiEaDtaLJwV5hqoYpO2wvBp68mb/XQlIpAfHuReQHfyvUzNNT1vsqbJTy3eEXwDW2Bw+yKxJdlKsEARIgDdDcRbU48cm1FEuvdJEd4vueATw4AxiCEQy/tncbtB4Q8sw5ggQ1Oj4QJ1kPKRFjRzpAzFRuz6xq2nhpRN8USFaYq2UvOm3wyqf0Zjv907IdIHLhwu3NbJR0ZcfoiZDWk/jP9oE2VA7IEOOqiB4P3zDozADOqlEV9tuM4DU5f43iKz8JDRi0GVth77rCDkb6WGbuU9N4FvFHsUiqL7KeZo9JTm2yruuObNjT1BD3BXeq3y6e6wA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by VI2PR04MB10764.eurprd04.prod.outlook.com (2603:10a6:800:271::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 19:03:45 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 19:03:45 +0000
From: Frank.Li@oss.nxp.com
To: Dan Williams <djbw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Jon Mason <jdmason@kudzu.us>,
	Dave Jiang <dave.jiang@intel.com>,
	Allen Hubbe <allenbh@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-kernel@vger.kernel.org (open list),
	dmaengine@vger.kernel.org (open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM),
	ntb@lists.linux.dev (open list:NTB DRIVER CORE)
Cc: imx@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH v3 1/2] dmaengine: change dmaengine_get_unmap_data() first arg to dma_chan
Date: Wed, 14 Oct 2026 15:03:24 -0400
Message-ID: <20261014190337.1718622-1-Frank.Li@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0147.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::32) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|VI2PR04MB10764:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f77133c-797a-49d2-2b27-08df2a25deb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|366016|1800799024|376014|7416014|18002099003|10067099003|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	vi0vZWKljCcg6OHgmPICk2Lrg/x5TrEBujmSSMQ9qHpJ2080yYDn7zqZNDiu+ltwNP6xwfpzfgY0wgKBh8eHOHOfXY83GwFWXOjFu5Es44P/zRORVc1DODUw/wqplyF9OYazpiL0rRi5QcVtZ+iYMsNcM+NDcO90Quctpszb3LuYBCFxjSgygqiO8YXerESUJ9khCYNAIfk8N4Z/flnN42A5VYG3SW+b4hTMEfVVyfiLckdaYJPk54mVXDswYF2IC46kF19Z+BDu6IRssRKUfeEMpDpL0bbjhBpOmB31h+3X7j1N8Ihw0/gLl2xkcbtSjEqLPmfiaoJUH8iUifCI9MvnBS9zQPsq8424KvXZjrJ3L+qIylKY4z7kxHrRWYiSvL+gUtc6sFk5sVaaJ28PnOSLiAJ/gWTjhlBDCx4Wkr9wqg7b6Wv6bN+OCVI/hHOZGjWg+MxggaLRgU6/DQdd+28WbDyvDm0YSIz8ZiquR7tVHS48LTjdx/T+LHevlnh5HDDHCQLoaD+HUCeckWhg4mYbtpd3K4k47wSO5dHPE5+8FYbrtShNub/WgJgQVIRIIBCPi/0uW44cpSnqKoYqi9WyJGrCRYjKsgKF51s2WMPqryDMCaSja7FXVRtRQCYgOuv44SwfzzRoOl8FQc+rjOYXnJVIAMhK/PTima/XQ7o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(1800799024)(376014)(7416014)(18002099003)(10067099003)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DOql8M2y099eGhlH4XrT6JLjjNqlHfxivVDX5KTszy0zzun4lCTOu6przF2r?=
 =?us-ascii?Q?kjQyi4iLPJ07BCaWl26fdaRLpahVbHTKZW1a+HVuHssjZVOf65fjMnfhOiyq?=
 =?us-ascii?Q?fB5J2mkJ6niMvcpQfE20IW8RQKgSzehP6VsbBh0LIz1newmpijG1i58hFVAU?=
 =?us-ascii?Q?HMYKeiNrCOaqbbv4uAwW3XIAWoxw62T+h1f+SZLqD9axG1xFaK0/+4jvkBuP?=
 =?us-ascii?Q?fYKD2IaIso4FN4L5k+iSAQIlDNWtUqtLy4K2T1FEr/CS04lWZhAiC+LTkaY1?=
 =?us-ascii?Q?SB8rFTAk6KYJqNRH1e7TYJfCdW9kfcdXYyRHHgvwf43vRMhNVzLee7ImmNyY?=
 =?us-ascii?Q?0FOtG88VXQ+OAnXSXUjrHYGiRgpsMwqRBKpxmFK0U8vipnFz7/F7lZDFEnL4?=
 =?us-ascii?Q?lHRtfADeZCuevnhHW/Ehlcr7QpRW0fuVS5qfleLZg+1420s2hRiJuLntiLKP?=
 =?us-ascii?Q?pj3AkvHemQQqdI/mTLfvJ5dFzeIWwNCuHvLgtNvuw5bcmU8GwZ1VdUpfoEPb?=
 =?us-ascii?Q?wy6hxv80AQRZ8EYA2Mo7FKndv7RqGklhSxyT0cOskUEB91Bt1H/2tV915tAi?=
 =?us-ascii?Q?p3wH4zrywn+pkOBawx/0ucpmfn6qR4op+cR9u0wZ1F2O7+RrdELHxQio2vsB?=
 =?us-ascii?Q?p3U7x/+BUATe2AppQ9kmrlpJi2TypkU2S2EBkybrDvUlpY4Vb+Od++9K92RY?=
 =?us-ascii?Q?yhxm30RKJ3qbWjrvoNgMgIZ5zbjQawEDhc0uoKk9nQuIr7JK2wnfnn+T/Xcn?=
 =?us-ascii?Q?Rvzy/pBqzwYlo0TekwkzPVkrmesh5+z56V0WiyMQieIOqD139xkWUUOC4foW?=
 =?us-ascii?Q?Vm+jm02fwjBISj4eujvVPORir6lPgaIjqdEh77Jd7D46J5TsqJReaeleyBCO?=
 =?us-ascii?Q?huv1Sig6Z/l8iINpB32Off4B3qsaeQKyL6Z43Xi5IlPqnA/51YT7VkfimQ/b?=
 =?us-ascii?Q?BQUmXBWufnBlzSJPg0M2R/p3n5j3c/ZgoW0jsUvU1x8ikRoqurqj4yBM1bP1?=
 =?us-ascii?Q?HW8skuMwS8Y2Qyp+uRUskVWoWZIkau6rlUhYSNjEkteYvlslTuqTubi81Pmx?=
 =?us-ascii?Q?PKpfUk98QvwQP24SRi0likfPHgse/VnZHQxq5D67SXfvVpK9h/Tg3tni9F9M?=
 =?us-ascii?Q?gWFtjmNxJcQGXFeLBZTNJfmms2xjniUr/P5gMdxs7ZKZ1xvq4y8rD873iqsH?=
 =?us-ascii?Q?66/xwmF2QtYpVRCWMvVEGPozWNRH367ucsBqITet3owTbW2xp0T39FmMlxBg?=
 =?us-ascii?Q?bsTUDCW1GiFtCx3efUMyPynEtxSBUwLP2VQtRHkMAbYv8HsU2sWR1RpI/P74?=
 =?us-ascii?Q?/cRr0z9vaP5OHmP226/qKStcvp8gsoJNvoF6VsrY81TPtaBlnqZxn1PKSpNf?=
 =?us-ascii?Q?1j9X7/F70nYvbL6ZRBCgxd17xSX6QT1QqIA7fedkLLE/j9sQMWKDloT7xESW?=
 =?us-ascii?Q?4HvP/ebzte/6BpYkQ9ovGnWE9M0BOPpaKAtrwfadcbTQFjxY9IM5aJTd1nGl?=
 =?us-ascii?Q?wSkbob/wXwC1JwMSPEySQXVL9AFFcqPDcJ3K9fzx4Nt86roS8sP4f/wpf6KA?=
 =?us-ascii?Q?noDnYar0rIqoJZU/lgouyVRf35ZHg8Pj2qkkQzVlwzbHZrqcs+0byL6ftM4N?=
 =?us-ascii?Q?ryOY92GpSTk7SE/iZjx6HebsxUt/J/6HAAydh4hc5hC//2SvdbymP+DTFwOf?=
 =?us-ascii?Q?26Tt8WLTbGqAyzzw6R2W7OnquznMK407k3l9t+bL1JPTH5mKFey4g5mSD+Bv?=
 =?us-ascii?Q?p5xcvBr+FDCgdz7ZXgNG8tIMN+XNwhj3oX2Pg7FzmW5Tyx6rLaxN?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f77133c-797a-49d2-2b27-08df2a25deb9
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 19:03:45.0195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /tC+2qwbvrOElWU5Bu2ULgj5fWIuxlnLLqnnM4+Dfz4kQAblUckQX1lIZn+Ithi15wctgRqUbGo2rnBB3tdu4epld9pcTV2vMtaB090ihgQnxceLm/VD1ZCsDG5gheWW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10764

From: Frank Li <Frank.Li@nxp.com>

Replace the struct device *dev argument with struct dma_chan *chan so
callers do not need to reach into the dma_device internals to obtain
the device pointer.  The implementation now derives the device via
dmaengine_get_dma_device(chan), which correctly handles the per-channel
IOMMU mapping case.

Prepare to make dma_device private and make dmaengine API consistent.

Acked-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
V3 split from origianl thread
https://lore.kernel.org/dmaengine/20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com/
V2 change collect Dave Jiang ack tags
v1 version at
https://lore.kernel.org/imx/b40fa0d7-fbd0-4ee8-b99c-781d08c18838@intel.com/T/#t
---
 crypto/async_tx/async_memcpy.c      | 4 ++--
 crypto/async_tx/async_pq.c          | 8 ++++----
 crypto/async_tx/async_raid6_recov.c | 8 ++++----
 crypto/async_tx/async_xor.c         | 8 ++++----
 drivers/dma/dmaengine.c             | 4 ++--
 drivers/dma/dmatest.c               | 2 +-
 drivers/dma/mv_xor.c                | 4 ++--
 drivers/ntb/ntb_transport.c         | 4 ++--
 drivers/ntb/test/ntb_perf.c         | 2 +-
 include/linux/dmaengine.h           | 4 ++--
 10 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index c538e30e99094..893e7e17f1f61 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -39,8 +39,8 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
-	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, 2, GFP_NOWAIT);
 
 	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
 		unsigned long dma_prep_flags = 0;
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 27f99349e310b..733af24a2762b 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -187,8 +187,8 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 
 	BUG_ON(disks > MAX_DISKS || !(P(blocks, disks) || Q(blocks, disks)));
 
-	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
 
 	/* XORing P/Q is only implemented in software */
 	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
@@ -309,8 +309,8 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 
 	BUG_ON(disks < 4 || disks > MAX_DISKS);
 
-	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
 
 	if (unmap && disks <= dma_maxpq(device, 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index e53870d84bc55..306448c47aa00 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -28,8 +28,8 @@ async_sum_product(struct page *dest, unsigned int d_off,
 	u8 ax, bx;
 	u8 *a, *b, *c;
 
-	if (dma)
-		unmap = dmaengine_get_unmap_data(dma->dev, 3, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, 3, GFP_NOWAIT);
 
 	if (unmap) {
 		struct device *dev = dma->dev;
@@ -96,8 +96,8 @@ async_mult(struct page *dest, unsigned int d_off, struct page *src,
 	const u8 *qmul; /* Q multiplier table */
 	u8 *d, *s;
 
-	if (dma)
-		unmap = dmaengine_get_unmap_data(dma->dev, 3, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, 3, GFP_NOWAIT);
 
 	if (unmap) {
 		dma_addr_t dma_dest[2];
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 84458375b202b..40caee262a4ab 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -178,8 +178,8 @@ async_xor_offs(struct page *dest, unsigned int offset,
 
 	BUG_ON(src_cnt <= 1);
 
-	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, src_cnt+1, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, src_cnt + 1, GFP_NOWAIT);
 
 	if (unmap && dma_xor_aligned_offsets(device, offset,
 				src_offs, src_cnt, len)) {
@@ -310,8 +310,8 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 
 	BUG_ON(src_cnt <= 1);
 
-	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, src_cnt, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, src_cnt, GFP_NOWAIT);
 
 	if (unmap && src_cnt <= device->max_xor &&
 	    dma_xor_aligned_offsets(device, offset, src_offs, src_cnt, len)) {
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 34be53487a21d..52e7dcc4e5822 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1477,7 +1477,7 @@ static int __init dmaengine_init_unmap_pool(void)
 }
 
 struct dmaengine_unmap_data *
-dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
+dmaengine_get_unmap_data(struct dma_chan *chan, int nr, gfp_t flags)
 {
 	struct dmaengine_unmap_data *unmap;
 
@@ -1487,7 +1487,7 @@ dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
 
 	memset(unmap, 0, sizeof(*unmap));
 	kref_init(&unmap->kref);
-	unmap->dev = dev;
+	unmap->dev = dmaengine_get_dma_device(chan);
 	unmap->map_cnt = nr;
 
 	return unmap;
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 2ae3469397f37..043bb065dd68a 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -748,7 +748,7 @@ static int dmatest_func(void *data)
 			filltime = ktime_add(filltime, diff);
 		}
 
-		um = dmaengine_get_unmap_data(dma_dev, src->cnt + dst->cnt,
+		um = dmaengine_get_unmap_data(chan, src->cnt + dst->cnt,
 					      GFP_KERNEL);
 		if (!um) {
 			failed_tests++;
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index c4e0dce3ca64e..dec01b6264d7a 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -794,7 +794,7 @@ static int mv_chan_memcpy_self_test(struct mv_xor_chan *mv_chan)
 		goto out;
 	}
 
-	unmap = dmaengine_get_unmap_data(dma_chan->device->dev, 2, GFP_KERNEL);
+	unmap = dmaengine_get_unmap_data(dma_chan, 2, GFP_KERNEL);
 	if (!unmap) {
 		err = -ENOMEM;
 		goto free_resources;
@@ -927,7 +927,7 @@ mv_chan_xor_self_test(struct mv_xor_chan *mv_chan)
 		goto out;
 	}
 
-	unmap = dmaengine_get_unmap_data(dma_chan->device->dev, src_count + 1,
+	unmap = dmaengine_get_unmap_data(dma_chan, src_count + 1,
 					 GFP_KERNEL);
 	if (!unmap) {
 		err = -ENOMEM;
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index f9caa1a653c5b..e1cb55890d72b 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1532,7 +1532,7 @@ static int ntb_async_rx_submit(struct ntb_queue_entry *entry, void *offset)
 	if (!is_dma_copy_aligned(device, pay_off, buff_off, len))
 		goto err;
 
-	unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOWAIT);
+	unmap = dmaengine_get_unmap_data(chan, 2, GFP_NOWAIT);
 	if (!unmap)
 		goto err;
 
@@ -1872,7 +1872,7 @@ static int ntb_async_tx_submit(struct ntb_transport_qp *qp,
 	if (!is_dma_copy_aligned(device, buff_off, dest_off, len))
 		goto err;
 
-	unmap = dmaengine_get_unmap_data(device->dev, 1, GFP_NOWAIT);
+	unmap = dmaengine_get_unmap_data(chan, 1, GFP_NOWAIT);
 	if (!unmap)
 		goto err;
 
diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
index dfd175f79e8f0..5fea36432ba92 100644
--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -809,7 +809,7 @@ static int perf_copy_chunk(struct perf_thread *pthr,
 	dst_vaddr = dst;
 	dst_dma_addr = peer->dma_dst_addr + (dst_vaddr - vbase);
 
-	unmap = dmaengine_get_unmap_data(dma_dev, 1, GFP_NOWAIT);
+	unmap = dmaengine_get_unmap_data(pthr->dma_chan, 1, GFP_NOWAIT);
 	if (!unmap)
 		return -ENOMEM;
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 805668fbe4376..6d918ccf852f9 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -676,7 +676,7 @@ static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
 }
 
 struct dmaengine_unmap_data *
-dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags);
+dmaengine_get_unmap_data(struct dma_chan *chan, int nr, gfp_t flags);
 void dmaengine_unmap_put(struct dmaengine_unmap_data *unmap);
 #else
 static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
@@ -684,7 +684,7 @@ static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
 {
 }
 static inline struct dmaengine_unmap_data *
-dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
+dmaengine_get_unmap_data(struct dma_chan *chan, int nr, gfp_t flags)
 {
 	return NULL;
 }
-- 
2.43.0


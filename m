Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012037.outbound.protection.outlook.com [52.101.66.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DF0302767;
	Tue, 22 Sep 2026 18:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790102763; cv=fail; b=lJMtUH5Qu2v6my0tOJRu8WLwI39R7zacofzhO4q3eXNgd0a3wULLconwGuF1e3jSw/Im7bO1FlrBPSxxc6Z1m00UrFDVSo4AU+dCrh1dZqEs5iJbrEpAG8DS+/x0OQLP8pzI5hIy2jfmbV5wYDp+2EICeuA/QpAAG2oZsU5k+xA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790102763; c=relaxed/simple;
	bh=OnPXQPzkz9yINld35cOLUw/QVHLPUlOD1KCz0MX/dCU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=EYbCJg6fHOPuUpTJ78b5NKE+Y23zGffRv8qwxK0idzEn67GtvQnoHT38fLSGSrgGVqCdfErcpuJvmSRCktwxN8+tw+Orm5czhiVhnVmjF7qNLnrleuAYCYGe70aJo7cyeSYpswtQQpoNwIkdk+qmxThbZviSjArxO0e4YvG6334=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=pB+cmDCw; arc=fail smtp.client-ip=52.101.66.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="pB+cmDCw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LAPZm/ON5iJCt4HQhJEZtjwP8wtGInp25pjzlBv2Y1wlsGM7zfPuf9Smi/EspIArYa9fFzx53K83kic2uonl3H9JF8vyMMTLpBTNBhSMy7s+9BRK6DMRUVjhYgw0j4POZEJGAP2XawKy9SQaZpaYIAMd5k2yUru9f45Jd0t+gC5bj0HNLVc7IUQ+BgPoO6ZhTT/2gV7ZFZ4Zv0anreSVMZWgx72IDJs3RXTjaL2CquBxuXW2k5WpTClxieMprLcg+WoHuICceYjqpsn3zPomxP3c/KpN9r4riiyH/Evhdr5kFQKixY0jn3ovdd8i71lQcJfaCXrBEnO9FuZLByb3KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cttidQ8EpQJUnHCRcHDujwyH/mJigb3EwOPhtodni8w=;
 b=CcAMdbiGrMI4jp+DV1vI8Kc74e5p0i7Rtd9LHzO6kXW+psFdYMKBSCHWlKuo5BgBWyLO8jB/dZaFR4SnO4TEX8wZFBfI08O6sbAL3KQVkOVmqAfTs15zyJDPJ+Cb0lF64hqeI+7DuCeqrTy5KziHkdTxNK4syzcL6Z1vCyM+IznA8/YZ2bKRqAS1KXZYMRBzzEYRauW/mYs5WOHZIzImo1oaKIsDZgNIkKjxQmH5HQYmhhOuDeIAMsVqlT56OV0K99zTEf0NeB//Vxn79I5nTo/NQ3xWzT1NixAqItARiwkydb7H3v83XJeyWcjLWxY5ENFiHxKh+G2E1jZIkQvtCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cttidQ8EpQJUnHCRcHDujwyH/mJigb3EwOPhtodni8w=;
 b=pB+cmDCwarb94EPW8dAM4TacSozVxaXNA1TAaOrNt92PhP2ShRbyDiSvqtEeySOw2kLYjCyFEzRd/4twe0Pf/mM8abHaFOK/qzv5xFozFy2pELb6tUUxR+BZkzg4u+lYU1f/St+x2/kmf+qx5rZTeyqU1QMYvchb77MJxT1+xhVGCSzPMFexj47jEwrOOsnJ2T1nYFd7NleXuZONxGhS6ykMqNJMXWvVS9XvUoF8SDu/NiWhCAOUUWQYedWEujmZHmjbqwR21xASKiRYio83S2NGyf80dO0K+/kZuKyUH2InYqNfThJRxc3bHzDzoYCZxV6ZUc46NCHmoHmO3WZX2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by GVXPR04MB9757.eurprd04.prod.outlook.com (2603:10a6:150:115::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Tue, 22 Sep
 2026 18:45:36 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 18:45:35 +0000
From: Frank.Li@oss.nxp.com
To: Dan Williams <djbw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Jon Mason <jdmason@kudzu.us>,
	Dave Jiang <dave.jiang@intel.com>,
	Allen Hubbe <allenbh@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-kernel@vger.kernel.org (open list),
	dmaengine@vger.kernel.org (open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM),
	ntb@lists.linux.dev (open list:NTB DRIVER CORE)
Cc: imx@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 1/1] dmaengine: change dmaengine_get_unmap_data() first arg to dma_chan
Date: Tue, 22 Sep 2026 14:45:16 -0400
Message-ID: <20260922184527.2414043-1-Frank.Li@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:510:339::23) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|GVXPR04MB9757:EE_
X-MS-Office365-Filtering-Correlation-Id: 77117b94-e7ae-47a3-9857-08df18d9b032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|7416014|23010399003|376014|1800799024|921020|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	cLbMDJ/3vPQFm3ZUqMa6HBVri+tjUx0U0TNmzDxQI+9qxDVZJzwZVDCp+dkfEyBGtCiVuc2pqq3UlwRb4gT7xfNfOwjzvM8jdeaHL4oadxwgVAGiBFqEo9Se/WaMFDV9haPu/r5WtMMLMHsXogV3VlJYi2oGUYQ+iJsAKS/qJiKMV6KSh47yK/dxo55iVEPb34eYeMDQAZKfNkJv44U5SF9mx6WGXf3gn/Dj3xBKGuqdwe4uVQDJOuMM2u6sgz3KLBialvK8GMy0Pl3RZCnMywC4MWc5ZPLjw5A34YDXO2Sr11FzsiFtU3dticAAvPDf7DZ4cltAQ7Ti250gh2b89qQR9z5s7IHCsyO7AyqQ6FX+5B+/7TQVwd9dRIKM1C8X/g/DLzHBFrn4HWoLYygDxLYYFiG3lTyXaulzn6Lcwlqyvn/VY8k4Zca0K5ehtei97qPxscXhSi/OeGo0o7H8relac5r6I6FBf/BSe/rbWNd5dLE9tnL4Hr0/18UMrBLrgUcZW2cZly4AG4VxBz30wZDfsALOlzh86OlenKjSzVyO/mrlOAFmRwMLWN0oIaGFRt5QA2fXOxs52hg+cFpSMGAcaFcjvs/9q28FOiWzo98J5Tb6x8VdZ/vdwd7jv97A/is00IRzj1HlzJgbVy9f3hXJJ0Tdt/bkt7trnd2gpEWlv4a6Ch2yvqwl9sqIHkytCMb7mxNRYOcCEmJJVNbCSA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(7416014)(23010399003)(376014)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jfbOvAza74/VrmqhjojVrhd3dMcFjo7qu8IhrfgqUJWJB+8Q8Vm8abhKQ+vZ?=
 =?us-ascii?Q?GQJFrhcJdqpBQcUbhPwQ+vmTzSo6VJzTxWLmtKG/XOve60etpVXXCyYMVj6d?=
 =?us-ascii?Q?WviWT6zICc0TdEbIA44UZFjV7hpEcZLsd9JuUZiBmp/vGouQHpqjy41aPRyh?=
 =?us-ascii?Q?9MBMdYwk4pt8jScB1d69B/FLWF4OYpfrzfzXbEo3u/VdFhQYZ/Ivuvqi4xbd?=
 =?us-ascii?Q?wxUVjBQPPFU5+ebTBfZWiLBvDEVwpjVhBes+oGixmX+enW0I/sRGHZXarhzM?=
 =?us-ascii?Q?UsxZX2BKzLZTW8Od5b+MYOwR9GUqog5sfXoC1qB/Hc+Ns8EZFLcS7ln2CT1q?=
 =?us-ascii?Q?QTXLaNDuYq+SyJKpK5877BnYcO0eWuaX1aehpiz/NkMXiB2+FZwxa2+p5NA0?=
 =?us-ascii?Q?kqKr3Jb3P5GPwAd+RtQR1YnnM6/l4mHikfhcFUV7jHrHaUju7kQD+z5AnnPw?=
 =?us-ascii?Q?v37Kz4tiO93M7e9TNPRTYEzknLJmtHfZrmljlwgcxjT8NMLwdFytlNLYdi9i?=
 =?us-ascii?Q?jGFhs+Q775fS5HwzUx2yi3LUz+9TZ363BG4Z1uXJAW6zypJRcgDW1+5jdTD1?=
 =?us-ascii?Q?ICs1luLYzfa9heD6EFJMz6B4RiDpEWbHxQyga6XWd+oJcyFCF/o8z2UHslhq?=
 =?us-ascii?Q?FcFoc0fheggP27VL6RUldGgnvYUkfnsopGQk6otwRfa7otUQLK4hOie03DZI?=
 =?us-ascii?Q?9hafZ5Tj4/1bmC3t43x4l+0/yKpXnb0APpgDeBrZ4L571Vef99tr5+gzdho2?=
 =?us-ascii?Q?6XhLgQcEw6AJiNXcPuTlCSy/0WPOrt6+mjaZPo5A0XGOCnChHDsSi8WnSnoa?=
 =?us-ascii?Q?XjCJu9AG5P6vOEMibmXb0PdOP3uTAhIub4VrAZgIyXEPASmZ35MKJ2+1JCu/?=
 =?us-ascii?Q?gQu/KYOLTU8HTjBKr2a5A8hQhR/NXfs8V3fCLyUM5q5dB1tCWr4hgW0P6F58?=
 =?us-ascii?Q?moSj5kR457nA+42Z4o9w60hlLokEULsuTzAizJhuVyN8jgeeO4yp3ZwJCdC+?=
 =?us-ascii?Q?Td05eapqMBs+PUC0jZorUwbRaLxnuvl0MkJJqzOjgYXaEksv45GoG2yj8EdY?=
 =?us-ascii?Q?6ImmG58vJ3pzyn8gB9Z53XxR7XKPDvMOSE3CkXL69GyZpiAyj92OmbPgCqJ1?=
 =?us-ascii?Q?fcDzEci1ucE9VPGKs9s5mR9aQRHP/Le2QkmN18d6306+MJp3LoN5lpd/gu2f?=
 =?us-ascii?Q?GYF3KaqCXTv5X3DrlLMZ0/1BFS5ut9IMTqD3IL5pB4sAzuBq622L2+Tu39Pr?=
 =?us-ascii?Q?6c9UjQcoVeb9uXuSKvg1Bp3FKysFJvqk9kM6z7EJ25jMpaYmXwwZD7ThYiyd?=
 =?us-ascii?Q?KSLSmnsKpk1rjNYDeS7H//Z6emwb+sjOy+B8jveS3iCD1qx/sglIH3OTCdci?=
 =?us-ascii?Q?AAPyojcTd8vKA130E6XwF3fjVzOqnmsFuRJO2qehVjI5xomGgUtjVou22El2?=
 =?us-ascii?Q?y816tBo/rKUKMktP2kiM/ImFagV9el8lBsP7desYX3rAn5T9x2ipUdXw+QRE?=
 =?us-ascii?Q?58tBfWYXN/dgzto8b/NZCOng2C3pTX/uGi3XrEZnNdOw63aDcGR4Tv4lkSQ5?=
 =?us-ascii?Q?eqzkUGKw8B7mIAf5q1Lf4Tg1kITq8geQyTaZjHqZnZD7fC3w+gP9GwR1O6wT?=
 =?us-ascii?Q?E+ZlhXUBimxg2XRJFF9mOpZ6qSFBjq9EuCwm1cnxw2QT7hfHjSDa8YkN9FF7?=
 =?us-ascii?Q?F7ZsGOJNXoQArUnvmukOOOwU3Ibx014fMg4Y44krMoTBFJYN7u7iWBpABJ1A?=
 =?us-ascii?Q?1cHeiZiua0oOtA2u8vHDMojxllWSIMcTyQ0D1rNusChDM6d5Ko6O?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77117b94-e7ae-47a3-9857-08df18d9b032
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 18:45:35.5319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bp2wJLHy3bwZvG/NKDTkmWK5cyxYPz22DwszcE6fhe76QID89A5zKaxsPeA/E53GR1tuyGSvDrVKo+3ZfQQbAsA62BNOz6m24TpGCAYlFftaEl+XR5fbNUmIwCcY/lLG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB9757

From: Frank Li <Frank.Li@nxp.com>

Replace the struct device *dev argument with struct dma_chan *chan so
callers do not need to reach into the dma_device internals to obtain
the device pointer.  The implementation now derives the device via
dmaengine_get_dma_device(chan), which correctly handles the per-channel
IOMMU mapping case.

Prepare to make dma_device private and make dmaengine API consistent.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_memcpy.c      | 4 ++--
 crypto/async_tx/async_pq.c          | 4 ++--
 crypto/async_tx/async_raid6_recov.c | 4 ++--
 crypto/async_tx/async_xor.c         | 8 ++++----
 drivers/dma/dmaengine.c             | 4 ++--
 drivers/dma/dmatest.c               | 2 +-
 drivers/dma/mv_xor.c                | 4 ++--
 drivers/ntb/ntb_transport.c         | 4 ++--
 drivers/ntb/test/ntb_perf.c         | 2 +-
 include/linux/dmaengine.h           | 4 ++--
 10 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 323152c89b3a1..d03e9a9bc1e2d 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -39,8 +39,8 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
-	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, 2, GFP_NOWAIT);
 
 	if (unmap && dmaengine_is_copy_aligned(chan, src_offset, dest_offset, len)) {
 		unsigned long dma_prep_flags = 0;
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index fcc8d9ebc0fec..6a31271852cd4 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -188,7 +188,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 	BUG_ON(disks > MAX_DISKS || !(P(blocks, disks) || Q(blocks, disks)));
 
 	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
+		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
 
 	/* XORing P/Q is only implemented in software */
 	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
@@ -310,7 +310,7 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 	BUG_ON(disks < 4 || disks > MAX_DISKS);
 
 	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
+		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
 
 	if (unmap && disks <= dma_maxpq(device, 0) &&
 	    is_dma_pq_aligned_offs(chan, offsets, disks, len)) {
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 27909afda694a..5055531145bd2 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -29,7 +29,7 @@ async_sum_product(struct page *dest, unsigned int d_off,
 	u8 *a, *b, *c;
 
 	if (dma)
-		unmap = dmaengine_get_unmap_data(dma->dev, 3, GFP_NOWAIT);
+		unmap = dmaengine_get_unmap_data(chan, 3, GFP_NOWAIT);
 
 	if (unmap) {
 		struct device *dev = dma->dev;
@@ -97,7 +97,7 @@ async_mult(struct page *dest, unsigned int d_off, struct page *src,
 	u8 *d, *s;
 
 	if (dma)
-		unmap = dmaengine_get_unmap_data(dma->dev, 3, GFP_NOWAIT);
+		unmap = dmaengine_get_unmap_data(chan, 3, GFP_NOWAIT);
 
 	if (unmap) {
 		dma_addr_t dma_dest[2];
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 4ed9d3196fc46..9ed331d9b8e64 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -178,8 +178,8 @@ async_xor_offs(struct page *dest, unsigned int offset,
 
 	BUG_ON(src_cnt <= 1);
 
-	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, src_cnt+1, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, src_cnt + 1, GFP_NOWAIT);
 
 	if (unmap && dma_xor_aligned_offsets(chan, offset, src_offs,
 					     src_cnt, len)) {
@@ -310,8 +310,8 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 
 	BUG_ON(src_cnt <= 1);
 
-	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, src_cnt, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, src_cnt, GFP_NOWAIT);
 
 	if (unmap && src_cnt <= device->max_xor &&
 	    dma_xor_aligned_offsets(chan, offset, src_offs, src_cnt, len)) {
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index cc1c0a7c9f33d..4585ebcd2e8cd 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1474,7 +1474,7 @@ static int __init dmaengine_init_unmap_pool(void)
 }
 
 struct dmaengine_unmap_data *
-dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
+dmaengine_get_unmap_data(struct dma_chan *chan, int nr, gfp_t flags)
 {
 	struct dmaengine_unmap_data *unmap;
 
@@ -1484,7 +1484,7 @@ dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
 
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
index b8f8b333b89eb..e9e1506df71d6 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1532,7 +1532,7 @@ static int ntb_async_rx_submit(struct ntb_queue_entry *entry, void *offset)
 	if (!dmaengine_is_copy_aligned(chan, pay_off, buff_off, len))
 		goto err;
 
-	unmap = dmaengine_get_unmap_data(dma_dev, 2, GFP_NOWAIT);
+	unmap = dmaengine_get_unmap_data(chan, 2, GFP_NOWAIT);
 	if (!unmap)
 		goto err;
 
@@ -1871,7 +1871,7 @@ static int ntb_async_tx_submit(struct ntb_transport_qp *qp,
 	if (!dmaengine_is_copy_aligned(chan, buff_off, dest_off, len))
 		goto err;
 
-	unmap = dmaengine_get_unmap_data(dma_dev, 1, GFP_NOWAIT);
+	unmap = dmaengine_get_unmap_data(chan, 1, GFP_NOWAIT);
 	if (!unmap)
 		goto err;
 
diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
index 774e643c9f4c6..1cb991e2f0cf7 100644
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
index fc661e76de84d..c8ecf80288f13 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -656,7 +656,7 @@ static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
 }
 
 struct dmaengine_unmap_data *
-dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags);
+dmaengine_get_unmap_data(struct dma_chan *chan, int nr, gfp_t flags);
 void dmaengine_unmap_put(struct dmaengine_unmap_data *unmap);
 #else
 static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
@@ -664,7 +664,7 @@ static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
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


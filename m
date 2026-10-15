Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011027.outbound.protection.outlook.com [40.107.130.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E4A4E36D6;
	Thu, 15 Oct 2026 15:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792079521; cv=fail; b=GgkRJZkv3MA6pQ69hykjzZPtgaaEChDe54S+K5zx4gtEdbhHuZgKnWN5W90bosXyeDSTXRCotBOeRc8Z10/8F0JSzw56cuFTzE3iVrC6q6LOuuwwOAdmQ+bjPRzQwYWuVlEY8NX9I3ZX+JxY1x53f9wz8s3UdBnR4cy3t3hCSoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792079521; c=relaxed/simple;
	bh=f6IEGuhFvo1BZe81ftp+KMqccyOM8UvV8N1XtPjBvPw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mj40YS0I7twOCgh2Iqp3J10y1yjxrnuOApJCPpQgJkdMiGt8tZ0j86hHpvXuz5XquGHlkZKVdxTzku61Ur1z6AeAcJkKYenQ5ovM6OE3zG2M129zEkalnu/QSFcZj2Sr1HYMFwnA9Kd5lGjp6UANFyOb+zJnXBK0BtzL7ZJlBS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=XA95L2ZY; arc=fail smtp.client-ip=40.107.130.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="XA95L2ZY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K3xtp6gOzuZ28z0w2qjpSDAnTN6ecgfRan7GD7MdgEsdgLIS/L49VTkKt6L5eA5bVnJNApL2/ZiZK1MxByrr8fS6MmI5LExehHWgDNlKhRC5p5JoCuO8xzEHSAg9kPUKhIKXASfKOMAMlQVczFJDxV4ro5dIL89ZPZ5ywPlOgazLLSdiOdL8tqS52FIGtsuuO9kRv5hca4eOVkBiW4li47qFyw8+I45IcIRRkIHo7dEv72Ab/1bba/ZxJ9JVEXVhYpvlzC1i9Pm7w/5NR4VUAz6WYaVqHzySpUzsilMvBdg1KbcOmrMAHWlaDOUatti88NgbIgHyPM2UyNc33VBIhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CrS/8F8sFRpsmHDBEr2rgrhFRj7OATF7NJ/9TauNxR8=;
 b=oKENd1w16QcUAzf/yQsJw+zrdpEV8x1QK/gtPNj8YGxBGhsdfhl6/SNsCsyhpp5VBkxTbMUDvWlVBVx0gvYk0l+0mnXeMhB4MbcMWXHAKaQlozxSL0QTVQdcDROnhZVIh9+rG+g2UGqeDcLttdTbpT5CiRec2gapjzF4PHh4Xw3NXl+PrgsH1NaEDpTx3Qpic5v1/eOH5p8EExKYI/IzjNw0bbogcxpyTTSnWU4NS6RUxFX3JF7nV1LIAdxn42ZnN8u2Pb9ZIyNlgGZjZo9SL5OJDRULVnxYbKVIf+OC88fzaJ55CpdVuFVkyVkJXKBzbTjWKIAxmmU+Yw2nF2pjAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrS/8F8sFRpsmHDBEr2rgrhFRj7OATF7NJ/9TauNxR8=;
 b=XA95L2ZYGVOv3AE2Xfy4tiWYkDtCFtvvGPeEarO2FMNeknXqvwSeiVevOq+n61XkKasDDvUtQmn55aeSCPWP/YOKKtkXRm/m33kB9MiXozepsuBxauUNvOCHcXLd6duDC33naQL1xdAJyaJV3zBprgUp2tG6JziBXbiWKniZZyuYor7n3Os9OaX6+RflbHBbSYDoXNwzXlRgAXRe+Z7HiCALwjKRIt5lx7zwUWUUsdNwE+bJRmT65Y/DH6xSzegIs6KfVbGn407joK41AqdvOdQSnPqySDFdEP7OmXhV+f8JBLmeFrN4u0HKbO2j9/E09tVrdjqyiQ+OO3vGvV6viQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AM9PR04MB8472.eurprd04.prod.outlook.com (2603:10a6:20b:417::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 15:51:45 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 15:51:45 +0000
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
Subject: [PATCH v4 1/2] dmaengine: change dmaengine_get_unmap_data() first arg to dma_chan
Date: Thu, 15 Oct 2026 11:51:05 -0400
Message-ID: <20261015155118.3063149-1-Frank.Li@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH3PEPF0000409E.namprd05.prod.outlook.com
 (2603:10b6:518:1::4e) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AM9PR04MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: c2f948c9-2dca-45fc-1066-08df2ad43695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|19092799006|366016|921020|56012099006|11063799006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fJ3Dkos6kHfKYThXwvK0ACCQOGGw32oiXtbueulDCrYNLZt6zJ+VJI/XJxuSshnykYXoWuFnwQiW5M7g0gcuPssKVlJ9gg9eaM424dgnFeD4DXVUy3TRVZvSCXjAHdweRN0KMXmeAsKbTcwjPj8gxPDSGup4/DCrEw5PMVbn+eOHaKqE5Zf7uhjYPX4bq7+rx1G0rydGS+cqpdFf0mygLgahCycJU+sibwPc3MgwAvAMeIYA4/QqIcWeMab4KG50N/pq/qLqR1EaAgjPXxaFlyBhPi3g3AdHzIgFmt0oFK3Ji1UDiYVeSrZtb5b7SXBnt9Rj2r0IgFrtgNrqpOpkJkzm49KDT6dzBzP5prBEvZlt2lpV+n3lRpfC4QhS9SYtawsZALHUJGqImZW+jhLUDExkApJtd7WNKqSLg0wyQjVPIHtUI1q+m8aT3D+eydyMG83noUjqeN4EIpa0qjYtoKqRNl4E+jf5mvbTPWDYcX/bYz3qJe8ryhdn9tnmz1VpfTLkHRWuyMItA9O+V4DdXKu4qWL6e04nOxewGdJMv6S6JE3eZPHPSXDmxnvcWtE5trK2RX4Tl/aTUoPzrpz59MnOapqWx8jVQFhBbWW320WgVKnSyjzo+uCdo6TKSsy2G94iMCKpT2xWwJemr7xzhfAJItug+ZJSLavMe5waEME=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(19092799006)(366016)(921020)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YYg3A23jIvkh8EKWHMAr4IOCURqorRT72owF/cziAalRC6+o45VL7JzW4Jed?=
 =?us-ascii?Q?eYbN34RTF7+PghuBfd2CNuW4Ks48+GfrVuVWBk0eDqnQVB8MFOEkiAKKeE/o?=
 =?us-ascii?Q?lFN0ZXOqBEHasc91zSwFcnSQn1QgYBawydtpVUE9lPDbVJJD7khlo3htG3Qe?=
 =?us-ascii?Q?I87giv1cZ1W0rVZmzmpkhIO+FbyXism0a5q0zF254xafn9ZoY7q3QSDPsxdT?=
 =?us-ascii?Q?QfkmhbMDUGx1ZlJ6khn24WQnEARCnPb5xZV5u93syEDS79b22boFIbpHJ/Ld?=
 =?us-ascii?Q?DFDRhS5leTm3Tm+Ey+b+aKkiWmAG3cWge/ovN2AcgUnFAO7p9M0n8PWmxTkQ?=
 =?us-ascii?Q?Eupk9Af/qYD+zagYcmD9Jg6Vdy8qD4uLmRKJvvHIpq8OcBX796CsGLEckJd9?=
 =?us-ascii?Q?F1NQNks8gXxGi8ezxKdeOMXD9/0CYYAqdwGWUPI5xjRaOyc5aTigbofwAF1S?=
 =?us-ascii?Q?0pmJQpSKJVeB+9uUqhOk2PHl+mv7fX+d40ZzJl087GvMSRa0JPNUZycnPbBD?=
 =?us-ascii?Q?C71l1Qh3KXyLZ4nBaVdAMqLb/g+tk2Hj2BlzpdwQNDDVgkMivYKwdOIhVoGt?=
 =?us-ascii?Q?gbjeNxwu8zB+r89+p5XBE6Pbz4u57ODxeuAba/1EsD+pwBFqPoeJkIZOl0Ae?=
 =?us-ascii?Q?CnmiAZJ85hU7Bw46sd+VYQjujujiEHD64yVsCLfn17gk0yhLd6c6nPsZf1Gr?=
 =?us-ascii?Q?JH9z0ny8eYpEyBhQO1f29bHUqTqOQXgMyHEEFrx/yiBl35In4tPG1SG8Z7Xc?=
 =?us-ascii?Q?TFYNcP9nMC7gdl4wo9myC9VBtwCmXZ5EJWpj/Anbg49YOpW4IXsXSyiBcxg6?=
 =?us-ascii?Q?XSdzj+Dc8KTps/G8sJBR8Ukcr+V0R9tEESESx+dV+DwZuFHpFU6LcvG9J8vp?=
 =?us-ascii?Q?v/tGarbQDVi9gGqaVybcmKC2Iq3j1k4xj0kNh07avsLRr0NI/VCIRyMJNZp0?=
 =?us-ascii?Q?ygseM6eQyhpUccmu/nOxgiRbV8x6AYy2oXx+J3+lED8Z0W+4JiXs6JJr1KmK?=
 =?us-ascii?Q?BgeurIsgtEoHeqFwOEbhvWFxrZZpTIsWpuIbnW+Fm9qb+e6yT92DmtoJhg2h?=
 =?us-ascii?Q?uJO4ReSkE1bX4/p8CZc7xaII98YYIGysxtexkXPLffcoTwz5KBhQtc692chs?=
 =?us-ascii?Q?qTIg+bSmdp0FmxclaSJInXbUbE42tzyEgVmWFgyIi1MWoZL+VA2gnpKhfopC?=
 =?us-ascii?Q?JCWsGGlBFj//tNB+Avd4p7XWIrw32EkO7T38Rv7IHRadqvDjOqfeOuBCmZNH?=
 =?us-ascii?Q?A3yFoTLoOml7g3OpMW1Mqk0cTnhnz6IGC9VUiJ5RucPemB6U969sRhWcJQbd?=
 =?us-ascii?Q?CWw+Yby25Eb/WiUgdtmMqcXoX0OIaiHtxChubI3GlGhKPHtSKN6Ipvty3hZs?=
 =?us-ascii?Q?CS4dsrUvVqM5IkfhVQuj5n/ayrTCXWNh9rSgfD3D7egfrypVOEgpIaJRrOoO?=
 =?us-ascii?Q?9LjHqYN/hp1XrnCnnpanSyGlG4Aj2g/VqKm0LM0Pw1Sk6c4gvq2KZufXzjMS?=
 =?us-ascii?Q?iX5o+DaecQLVUpNkyTzxJyhSRsPENpPbCn9UVIHqrs34pilwsez9FH8hYa/s?=
 =?us-ascii?Q?dzr8wERadJ81RHD66gK46Vgk0TSsJYn9ULAwQm+z4MzSlecMNuh5IiNnPz9x?=
 =?us-ascii?Q?Z0rwgdbQpMLxoMr3VzuNLMYQtfkraEfsu/zgIdOLNngB5BLKrnymS7M1JBOa?=
 =?us-ascii?Q?IRYGrQP5x/SpSQmAxqd9zxrucLalYqcDEH8VSP9nTESqvjqfGENbhYt3tqHY?=
 =?us-ascii?Q?4vDp1F8PaqqaQsJC2sYyHiHyphZzMWwxaAWRLKNOEa+IBjYRKKge?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f948c9-2dca-45fc-1066-08df2ad43695
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 15:51:45.0108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TfubjXeylG9udQOioqdObJ9jGYm6PhUKNru7uyJL1pW7N1WVeSZnyue8zKc8P/9GGAh9G1oSoP0x8aT1ZUVO22m4jQsNdFiD9K4yqmYjVcg7lyPDYZe1P7P5WTLXHM5o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8472

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
V4: none, just respin to miss patch2
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


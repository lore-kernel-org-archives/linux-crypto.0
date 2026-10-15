Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011027.outbound.protection.outlook.com [40.107.130.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E278534443;
	Thu, 15 Oct 2026 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792079537; cv=fail; b=I/mS10DOQe0CoDVY5P9z41SQvtz/u50aTMQPPxLyqOxhvVC1NgZaSR6LVq57qTZGZneW31hTnlSitr2BZFdCys8n8uJ3YRrGiWDXpZLQQKjgssiyO7ZcX8taKWB0Il9mcTgEKfn36XEUL+jnEkJ9hVJh9H73XzFFV9dOiMOiepQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792079537; c=relaxed/simple;
	bh=DDuYHT/KVvZ0ZyxpFXQtXYCPGMJ0cpBasHyjwXaHb7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vttct6g3/hOvdTBSh6dYPltD4Vy+uIGjGeMd+08DmzpeMEjcfnFzyupWrUoamW/gfawDEqTb5L0Z1HDHMyW7kpvmheLEnQ31R0LIbxSPaJginV6KrGu9N5RUXvId5HcRZl7A92spYeDGwQ2+/3FvwT68HwkLdKi10OG998Lj8Qc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=rYX4D9g9; arc=fail smtp.client-ip=40.107.130.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="rYX4D9g9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=szrjS/fblsBve9UISgb20ViZCC/UXteM9SUL1uqSwWP1qVSbEwCqn/DO+ac7Pm8xlvUJtqxS54SAU4PMIneCZYSkFnsqaa/hPYbA2WzJN3btRVjc4j3Uwxz2DRNb7+kUWpQBFNwnWFBSQAwWOZ/lYXaZCn8TquMsAqwA7C/OOA/INTWREdLDAqvGRZ6MXDjan7UPT0bPBWbiuu1MDl4LRRLH4YGHnsEgq97EiiDt5CNTDnUIl+oYdzXwXho9KyK4Xqul06IrwDc2YWIcMRwI4GKVbNQrVMMhzl1EJ9vHDx9fhNrki3qs8xAfwoL/UPKgZFuMRZzK4EmezbEzV7lJXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RjIhwYBVPXzSaoHhRosy5gf2ME7a7EmH4pXhuCR1nNg=;
 b=vClhMZqy3/UaUIa4hR96T4fuHaVKRDaTTrSP/Y5alaD5xT/PIOgmT1P3dWEVbVh0iCQmoVVLIybnt3hEYV91My6ox/cLal9L+ZJm1jRYnU13VoVa4G6Y9bD3Zgy+5fvE8UC/oXe/5LZi2vPgbWRKblh5j+Js+7bopvKrBHPLUiLRP1a2xgP8GWiaQ/Ri9OkJRNE+4ukhTqgbu4F/dozKsbE5R4x5Ug6ED7TAOZGS73zFbVB+B5JLpYfEIKqq+0llRlMWlBUUkvqkSJmgb16RfNgPzpkucnXZWDRHQsxIOjhq8Wn7ePO8HFXBmVv4XjoRjsbYwuuiE7ztwM+mbJH1Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RjIhwYBVPXzSaoHhRosy5gf2ME7a7EmH4pXhuCR1nNg=;
 b=rYX4D9g9z1cc70dzxZWW3gzNtWppH3vdNj3IdVFWtXs+r3fEkxjgeR1Ju0/kZuF71llJGsUZYkgn2rRxC8kbpoEtd+9tEZ8wIBKxJvrR92TsSUMRZQ+26EspxYkJK2wlX/DfhRL0EUaVwbqOoDQm0rrhhPYQsN67Rjd9KIyoE9YZGoB3A6J5C0gUWp/WvJoNoiUzTl8zBjXNSqylgQEsM+u1IwZ74zqgKqcqIpK3iGZUKz5+Uumiylm9RncxOvwfS6LykyqHVHORyTMuYyKnrcTaTLjlXVtqGu3aRa9nZdcoglj4HawM06f/5jGNhKMeR9m7m5pC6fbzyyZuZtI4Zw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AM9PR04MB8472.eurprd04.prod.outlook.com (2603:10a6:20b:417::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 15:51:57 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 15:51:56 +0000
From: Frank.Li@oss.nxp.com
To: Dan Williams <djbw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Jiang <dave.jiang@intel.com>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-kernel@vger.kernel.org (open list),
	dmaengine@vger.kernel.org (open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM)
Cc: imx@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH v4 2/2] dmaengine: replace dma_maxqp() with dmaengine_maxpq() taking struct dma_chan *
Date: Thu, 15 Oct 2026 11:51:06 -0400
Message-ID: <20261015155118.3063149-2-Frank.Li@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015155118.3063149-1-Frank.Li@oss.nxp.com>
References: <20261015155118.3063149-1-Frank.Li@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0092.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::7) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AM9PR04MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: 98c12483-75df-48e6-bece-08df2ad43d44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|19092799006|366016|921020|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	+e4MAVp5dO5v/SD6DEaYt7mCsaETaNzip/MrD+xZO8vUh8LXMSI+uNAwVsUaoTC32HhaCldOQKZLsFVKUwRYsN3niEMizBG67FDBZkF23o+eLBjO0NFk9OSS88/gYDxBIiQRKdka4mkdKCkvHRCf4L0Q4UA5JYulI+h+P6yWasXc1Obl1ITUbucITI4ukWX6TyjzM3ndASHQ7VJze9Y603WwNexev6p7XTIUpY7DLZMMkJQj7Rba+gTrZDJjGvseI2oCPj/IJ0zgE4HQNTw8HSV/ZgVQFE2Gr72Lu0i9VITxzGdO8T5QO+0dfGZOOAsmeAFjmWzU3xQf2serbj+RaI8OV3u9S6vpuBOGYm9Vgdsh2VNDNmohZU5G7bChCLJ/m0HuJXBS99Qjmd897Aiw3Dsk+8A4cutgwCUI1J/rE1QcOATgK9zO3x3AyPMc6KdquW9XQH2JxZnTfsphoLe2nwnxpwUuHFWmcaBPF8daPdDxHNKVaazCh0/lbvGdmsVeVZ5giE0zIIznP5a1TBghYfdoO+PZ2BPSQ8wQuca0ar74moVGb+WQ9qI75qUMKwMsyEcSvyqvuAlyv4f0cEsokIOtxokoodaKGt3MVj7oJMPODoor4pi2VYbHtN7NxUzhmpCfn5kOGGZog+OMArkxh72zMkHanCz5P7VDCU10a/E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(19092799006)(366016)(921020)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A4Z5DILw8KulC2gd4yPBu1UEGravR1ZgZ1ULg/C84Jjp9Avg/etGLDYv0PL6?=
 =?us-ascii?Q?a+n1jRh1AuA1SnT234i3r2bUtF9rub/VgW5prZ7R/tVyC/kNVyqecQy/Jhtg?=
 =?us-ascii?Q?Vc8G7NVx2iwk7TuCJ+xkN0xN1ZEeGumgrl1yMuul+ALKze0oyj4Lux3WcXTi?=
 =?us-ascii?Q?/k0bhAIH8ltLvlHrqMt1vd6Oyo5bhDHJrOgUZVwkLXJ0DP0EMCv56fiCMXsR?=
 =?us-ascii?Q?QFhParmZZPsELz/mw8eM+mUkaVvHDNvCCUIomNjke21Vk953y2iEVyZ5mVdR?=
 =?us-ascii?Q?M7HI1w+bqt3LORkzuE+4r9Y24aeOUn5aFiDW2lYZ722yN2AWvUrAVpDmyVa5?=
 =?us-ascii?Q?vDBBRWF8WKlyMS0Ki/J6DFls15KJaducDfLWl7hLawhpqCtK5XgmSmYbTBw4?=
 =?us-ascii?Q?0Q+gHSG4FBfstp4mbZI7SFmrvHjEFwHmglzf2UdYOwx4NX19LF1pb0eTQwMo?=
 =?us-ascii?Q?ADetAC1Pb5jHvkwFKNb2ZdXPp4tX8SPFQOq/MSoECC8f4X8oJmhpbiXcOnFz?=
 =?us-ascii?Q?AWTy0tKGA8BYAj0lEKON4qFuS3WLONzwwL054r9+W3UJA3D30MpPCC7Z5QAZ?=
 =?us-ascii?Q?qtzTbexLCyruKx752g1sjBhCF6eA7oLLdfmhGLx6j8Bo68D7ICT33MY6FIbM?=
 =?us-ascii?Q?9KibPvgyM4nDHgXhPRCn8p7uLrkNL1thOkbM8Dvo+U7OtO1eUeagScXawUTk?=
 =?us-ascii?Q?af1pYbtqLbLrYJbvYeO0oZPIe6aRlhLPiMSgnffXbT8cqpcBFTqU83XR0qxQ?=
 =?us-ascii?Q?MkPXAyVVSG/ANNbo8zE6d5uhV2Jo0y9V/HEVGU3j71we8G25+duwXftNcneX?=
 =?us-ascii?Q?JEx00qfVChWDSu0u5Qqf3h0Engh3DTzW/QkVZ/cgWv4ITPPJqgtUOJqGx8dZ?=
 =?us-ascii?Q?C7hITZqMRIusCLq0BnvnmvZJUmV93S2sd37iSKybydrzsYMT2FhFcurY3XxD?=
 =?us-ascii?Q?0H6LvhoCWSCeygOdSLOeQY24oeRY19+T6Y4VJWIt6Y/kxUslEPN7XBlUxbrB?=
 =?us-ascii?Q?JRQ1RCV5AY/WDHMewJuGRw6C6KkY7mTJ9dYjKBmMhjn0CueWZPP8rKCVpdgG?=
 =?us-ascii?Q?PJ+AOJn3/6QCPWbZPvM9bwCBVfNMpfvX1nMKOr545YcjFEx+dsNYRa+eSMj4?=
 =?us-ascii?Q?J96XpcUAmhhMI7qvFRgt2MJVAVZPEI8SCiBnD5cSGjHpkbRpLJo9/HmYsRTW?=
 =?us-ascii?Q?YM1NO73kXJ+qepwK+ayR+0VsoJsSVslvhnYnw20F6rFjmo/NDh5G0ksCqkjA?=
 =?us-ascii?Q?CihD8hfN6gNfk2o5lkS4p63kQhcIQLiHj8yTXw1ldpbwJT6JYkpQosR8DDe4?=
 =?us-ascii?Q?r2UhtJ++Z11zcezkyBuKXfui1nrMQN5VOLPiQ67c71FaZZe84Yx/1MYRGGaP?=
 =?us-ascii?Q?UQsj/8xtrHtbb5TeVP2+i8p0PpMV8xzwse7V3Cxi5GmWZRDxnguUy2eKETCL?=
 =?us-ascii?Q?IlJK5m/Hnf5DpD3tqQsQJTkeqpp1Pcv+EXYHAkjbp6JoSPsfhaYhDFNy4aHY?=
 =?us-ascii?Q?RM58db3KlXNv5TftgN5dz4a58qzRahnJ3bvl0oHcYy4fIeKXTrRiuK9WZ3K9?=
 =?us-ascii?Q?2mwu6lEISLuGQyImEKWc7ZjbF2Ogwgrs9oB8wxF/D6tQoHHzeQGJbxAhlvKv?=
 =?us-ascii?Q?O7cptzbvL3KkYNCddsFLrGmQunTRmq95lSjXKpO2fQzdOVQxke3lYHFBQfQB?=
 =?us-ascii?Q?fQYoxqWEeYuKy5i1e+QwFjN1EVTQFP1G8YuACv2+mPMtlTMluS2HdzF0INU6?=
 =?us-ascii?Q?Waxm59mQjlIytjwZ0LE3kMA7istx0rg5KpiCsA6sPAfK2IwU/1DW?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98c12483-75df-48e6-bece-08df2ad43d44
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 15:51:56.0575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhWnxNZr/GHVhWkfraIvHtxX1SsM6pxCt6zTFXWMwFuH1F0WBT/2o8npSG++oSGneGIVTHd3IT4BY5xc401PWNVFcCx892zetC/eucnBRafGZQ106v3mDWvzO5+cj9qH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8472

From: Frank Li <Frank.Li@nxp.com>

Replace dma_maxpq() with  dmaengine_maxpq(chan, flags) as a channel-based
API, consistent with the convention of other dmaengine_*() helpers that
take struct dma_chan * rather than struct dma_device *.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
change in v4: none, just respin because missed patch 2
Change in v3
split from original thread
https://lore.kernel.org/dmaengine/20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com/
---
 crypto/async_tx/async_pq.c | 8 ++++----
 drivers/dma/dmatest.c      | 2 +-
 include/linux/dmaengine.h  | 6 ++++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 733af24a2762b..37bc48bbda821 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -51,7 +51,7 @@ do_async_gen_syndrome(struct dma_chan *chan,
 
 	while (src_cnt > 0) {
 		submit->flags = flags_orig;
-		pq_src_cnt = min(src_cnt, dma_maxpq(dma, dma_flags));
+		pq_src_cnt = min(src_cnt, dmaengine_maxpq(chan, dma_flags));
 		/* if we are submitting additional pqs, leave the chain open,
 		 * clear the callback parameters, and leave the destination
 		 * buffers mapped
@@ -192,8 +192,8 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 
 	/* XORing P/Q is only implemented in software */
 	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
-	    (src_cnt <= dma_maxpq(device, 0) ||
-	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
+	    (src_cnt <= dmaengine_maxpq(chan, 0) ||
+	     dmaengine_maxpq(chan, DMA_PREP_CONTINUE) > 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = 0;
@@ -312,7 +312,7 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 	if (chan)
 		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
 
-	if (unmap && disks <= dma_maxpq(device, 0) &&
+	if (unmap && disks <= dmaengine_maxpq(chan, 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
 		struct device *dev = device->dev;
 		dma_addr_t pq[2];
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 043bb065dd68a..01ab33580da81 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -636,7 +636,7 @@ static int dmatest_func(void *data)
 						params->alignment;
 	} else if (thread->type == DMA_PQ) {
 		/* force odd to ensure dst = src */
-		src->cnt = min_odd(params->pq_sources | 1, dma_maxpq(dev, 0));
+		src->cnt = min_odd(params->pq_sources | 1, dmaengine_maxpq(chan, 0));
 		dst->cnt = 2;
 		align = params->alignment < 0 ? dev->pq_align :
 						params->alignment;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 6d918ccf852f9..ef141892651d6 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1720,7 +1720,7 @@ static inline unsigned short dma_dev_to_maxpq(struct dma_device *dma)
 	return dma->max_pq & ~DMA_HAS_PQ_CONTINUE;
 }
 
-/* dma_maxpq - reduce maxpq in the face of continued operations
+/* dmaengine_maxpq - reduce maxpq in the face of continued operations
  * @dma - dma device with PQ capability
  * @flags - to check if DMA_PREP_CONTINUE and DMA_PREP_PQ_DISABLE_P are set
  *
@@ -1733,8 +1733,10 @@ static inline unsigned short dma_dev_to_maxpq(struct dma_device *dma)
  * In the case where P is disabled we only need 1 extra source:
  * 1/ {01} * Q : use Q to continue Q' calculation
  */
-static inline int dma_maxpq(struct dma_device *dma, enum dma_ctrl_flags flags)
+static inline int dmaengine_maxpq(struct dma_chan *chan, enum dma_ctrl_flags flags)
 {
+	struct dma_device *dma = chan->device;
+
 	if (dma_dev_has_pq_continue(dma) || !dmaf_continue(flags))
 		return dma_dev_to_maxpq(dma);
 	if (dmaf_p_disabled_continue(flags))
-- 
2.43.0


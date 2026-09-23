Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011048.outbound.protection.outlook.com [52.101.65.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAC324468C;
	Wed, 23 Sep 2026 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180426; cv=fail; b=aNvJveZV3/s6tkt1n3kcJRecMdh4gK89p+2gyB6lgikvG05a7zi6Nb/FKp/bQWC367yPwwoEDAuFanQkYqIHrOJPmBgX6bJE97Cz1c5Qw/jpT5c0bNen7d+KaB2WQjH0ysWGAl6ZgkONrleZ+9K+ZHnQN5I5mT0lo7b+57vmWCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180426; c=relaxed/simple;
	bh=+oG4cvy8b1liucyyY5sVexOeTvzgE4qX32ozTkX/vsA=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=C/XfVCwoaDSPVdDEzI3dDMbG9TS4V5ELQH+uJXltmEafmCS30I5L7zmikU/8CQkhxv5rZ8aZZ2/c2uQVC435BF+t9LYMtfozDhKaURDtez6WCw8toRz0wSoFNOYO0ccbzLFKeFGqZESrKHdw8x9SB01kV0gwYXvdnQqMHgGkaUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=WkRWTmUI; arc=fail smtp.client-ip=52.101.65.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="WkRWTmUI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XFMtqj/jrNU3jba745am8GgPBGJno1UXd9rWNyZO0YIYAvG9sJd5Hoqj43HBslx2cn0mdO9j5lZLiJvXorkSKTlP65ekz8GM6BKospk585h7fDf7NIdGRCdWLzrjc8p4QdRtiF4dSI2BW9w207tMnGADMktqp/j1Xny21iEMVT1NngmJmZmIPqV7PzuXowYnarTrOYV+IYTMO24JmwinUrl/ls9/KcpY2ugalu0u2yY6YqTYdzBMwK4FbX95ZE7xJW3hMlC2LCFON0BvW2y0GBOzjZkjXR8A8XPE66H0aq8x9fiKKofJL4shV4UMkmPxOBLobU+Dhg+byfpNhmS+aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WcmjIwTO2Lr14eR8Q9YwpWPDSklhnTJzPvrSRgt6BQ=;
 b=SW7TuXl39Vr5oQcCI7mjcaBHCmOn1vS2OL53ClDIBBpbOloMRblKdvqUemCOPE3AdYZVSZE6ydaq4Y3TRNNkZ0Aq81t0SMXBmsOLTT5QTcaMFu/lpmBB904tN/n2wiSxQPZKHqH5q0RwZzGkMmKGBghC2UtuWeTldTo1UbO8inJl8bdM3ZJmuBjx9SYbDBtq3WLJIgV0F9DiA1u/EW3wQQ2PjChlD3s1tJw7KNiN7hZtoAW1fLUuRNJk4uYSJ8mK4b0rL9fgGx581gq+4XCUd8e4pZvbagKTD/XxlwbhaZDMG5Xuvz548pC3jE21lFThEp6vGkWURgJjmeKWgFJ2Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WcmjIwTO2Lr14eR8Q9YwpWPDSklhnTJzPvrSRgt6BQ=;
 b=WkRWTmUIfqGpacfc3/LQLXhyEtaTdksPW6sDn7OQaJyzp5V60gJm4t1zbGWBPIep6ouJobc2Qo1HLJAtkhe9JLMVq4QL3yI6gpiGK8ioLCbYcNdakFG9MdF554++GAU2siplcHYol0Oen0vBLO84jK4dWeGKj2oHkVk2R8K5d5FWxZjCNf7mI7nggsN2yNnagvEMQfv2Ygimu8ZbouPNkw0JLv2sMc3Mnwc/C457JttdLySxy2emkBMus+PLJElVUeBfh+TalWkV1yww4VXkGktt0ws+9mjYAjYSQbpt1ht50f9JPtHhLk7fD3clSduvc35lm9ktjcVghdwNVqNlVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DU4PR04MB10433.eurprd04.prod.outlook.com (2603:10a6:10:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 16:20:20 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:20:20 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:37 -0400
Subject: [PATCH v2 08/12] dmaengine: change dmaengine_get_unmap_data()
 first arg to dma_chan
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-8-32ed65b8a9b4@nxp.com>
References: <20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com>
In-Reply-To: <20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Dan Williams <djbw@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Jon Mason <jdmason@kudzu.us>, 
 Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>, ntb@lists.linux.dev
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180376; l=8898;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=fRO/zAbN0HV4i2hgLUM9a6WbjcLqW1TTykcDIsJLio0=;
 b=r89fRIZej7kdUbIiTrWKVf173SfOv80yMxCAC4hmNxofKscnqtffIvaIxYrPkA9urfJ3xnmni
 Y4ywiabPnNfC9zXVV58few7NrVA7qcIRuiHhow5tO5cYrPdbUz4P9vT
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CY5PR15CA0243.namprd15.prod.outlook.com
 (2603:10b6:930:66::14) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DU4PR04MB10433:EE_
X-MS-Office365-Filtering-Correlation-Id: c0e4cefe-d1cb-4e29-d953-08df198e902e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19092799006|23010399003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	IrzBxKaFLNNgLs0Dt5I9re238xeoU9lc/wijBMgy/VtJMPKCtWcCC76+CKk9SnsDBCSqKJSr3B4QNwoCCvMnmP66V/Ldaxrrxi1r3EAfLxJtX11TL2LeJrdngJ9e6pNCPToCCfhaIWBHb0aZQvjZ9tVYM2b7uaiV1RVk8EydOKwsMu29NywNZXhhekOTumEvEetSGxwzkaxTUnbe8nGpwiP2erNjTFhRPLY4SsGXmwQyaystnxcJA43PIOpDfeaO4MwYvwgEHvAFzT52K7giPhU+GHXLWovfwoaQz9kLoYjZ+ajpXzTEhmA2e8ACzClvxeyiPtV7Km6PdTV/z3JPLmLW7qpy9D1TPkkhZwcVEL9a6ibeRAQFv34Q/wWE4DWjIox3coZAQEkTk6wyin8o0VMqVVcao8Eu/ohjhEro/+NjgXm7mzI689hTYMas1ID3PLfSq/8QE4oBXsK5KwzE8oVUPRVzny/CzbOeOkBoTZlqZfa+hukWgJQBLgsLJkq98vy5CmYjG0kNl43BeF6UD68cksyGqSDdpJJCs7CM4xjAEVd9eBUgHscVzqFJpgZUkKrIb23XSptJVuXwYLFpecQVg4eEzMarf0gVQapBY0aUhR1MG8L/8aOFFf/4TMxg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19092799006)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OCtZenVOVkYrZTluSUVDZXRURVkwY0pURVNwcjVjazJMRnhmSlJGSXBab253?=
 =?utf-8?B?UDlZRGk5MnYzTEViNEQ5d3FuL3dxdEJJSTQrcXV2T05tbmg0UTJhWFpCU2cv?=
 =?utf-8?B?VnpDeDk2R0d5TUlEblFGSXRxTlNqQ2x5N1N3SnE4amxtQ0xhaitpWU1tVFhX?=
 =?utf-8?B?YnVBSkx3NUcvS3FLaHhDNmMzUTRYSS9GS0JqY1R2NGU3MjJEUGNVd3lhTWF6?=
 =?utf-8?B?dmkyVk9sVHFYUFNuZVNROE9Sc3d1elpmWkNVL3M2ZDBHeUtjMm00QThJVlc5?=
 =?utf-8?B?cFBkZTNOUEVzd3NQc0JHVTBFbEhiU1dwRTNYWVFVZzRueDJFeDZrTFMxTHhD?=
 =?utf-8?B?SXd0NlhhK2tqS2lRMmN5SHN2TkEvbXFCa0thNE02YzArbDV5SFNKTW10L3Bk?=
 =?utf-8?B?aFA0Z0h3UUJma3dYN3hINGZ5MllldWI3Qllidnl0SlU0bmJKVThPYis5WXps?=
 =?utf-8?B?dEVMUHRWb0RPSkpiR1lxVEd2YzczbVJWZUxQM3BFOTRrak8xTm1TRFhOdTR4?=
 =?utf-8?B?dHhVNllEdTJ4VSt5d2ZpREg3NElta2paM0QxL0tmTGt3cTBBUjgva2ljWW8z?=
 =?utf-8?B?NWVWeXVKNVF5MDNpSzlpUmxWNW1sOUxtbTdvQTNWTE5NWVVJVFo5aWVJTDZk?=
 =?utf-8?B?bENKRUg2eGUyampTNTFpZ01pd29Nekc2cXgzSVBMUkZrcDhUTlJlSUVOYnhQ?=
 =?utf-8?B?Rm9zL1hNMDZmNnJMVzU0bFBMTmJ4cGJXWUdLMWJvZHlzcGdteDZrQjlhank5?=
 =?utf-8?B?Ni9aZTlPaEVwUm5EckMwN1VjU0RJWEtmMDE5U2kyMHFLOHFhVDVHbWxvSEx4?=
 =?utf-8?B?R0k1eVk1UDZBanljK1ZaS296NjRkeDZRRmVTV1RNQUt4QUEwTW1FQzB1VUxV?=
 =?utf-8?B?WUpQVzQ2U29UUXRSVGNXV1gxKzgwbnY2RHNUWVhrMmRRL3EvcVgzU1orclBZ?=
 =?utf-8?B?b1lRNzBsZjVKQzhtd05sNWFGWS96S2xLdFZ4Mnh3Um5FNjFUVXVJQkQralNO?=
 =?utf-8?B?MUVQTUNhRVJ6RTZDeFF6TDE3V2xOeUtrMHh6MlpmYXZ6N3UrRVBxRUZSVm9Z?=
 =?utf-8?B?NHZvanVsMEZQcUpaQU1TN0IzWFdIWkx2Ymlac0t2WUtiQjN3dlM4Q3gxQnBw?=
 =?utf-8?B?U0NyM0xuTTlWK04zamh3bjR5b2U3NXdhL2cvTzZYZkhKNDJTWFhoby9uL2ZE?=
 =?utf-8?B?YmZURkFORXJsMHJQbGR4ZXhEU2JTNk1SdEU0V016aThZSUlOT0xrT05Dei9S?=
 =?utf-8?B?enFEY2MrQnVHbkJCd2IxY250REdXSFdUbVlDVmw1cU44YzBkZHpud05rSXNl?=
 =?utf-8?B?Um1LSFJQeTY2Y1pSNUxrRi80dGtxM2hxeWlHOGxURlB5V05oTkpoOWdDK3Aw?=
 =?utf-8?B?a0RYa2pTMWtodTEwTlkwd3pHcTg1NmJsc2xkbnZ0Sy9jdmtqR3JFVzEzRzI4?=
 =?utf-8?B?QzBGbkhiWDU5enA0YXBwbDF6eGlFb3BsZ1dyTGlDcEdMTzEwck93SGk2eGpq?=
 =?utf-8?B?V012L3QwV1JLS2RXNldReisyTzJxYWdMSEExSncrTUNpVTRIbWlSUVA1NVV4?=
 =?utf-8?B?clpXZjRYZTlNK3pmenVRZnpySVAwNk83UFFQYlFPZ24wbTQ2Z05lbjlnNGRZ?=
 =?utf-8?B?NjBMNkFoRStQdnBGYXg3dnY2a2RVQ3FrMTQyQjFIM2QvZ3lTM1FUdDNNM0k2?=
 =?utf-8?B?dnBzb0E0aDVmVjdrRUlOeDBBWUtsZE5SRmZDK2Y3a0JaeENXU1JlaEk3bUIr?=
 =?utf-8?B?OE52U0VpV1RMOXJ5RGhqN3ZZTVRhbWwwRWF4OXBHaHhFc3c2dUZXSzI0VUV4?=
 =?utf-8?B?Sk9ZOGFFZ2cwWWFwV05IMVJZZkRCSDBDUS9ydU1lOWlVOEFhaTRDN3lobEll?=
 =?utf-8?B?Ly82YVFkOVdwWVFaUnJpL0gyd292SkJ6MnNKVml5VmV1OXhWd1Q4eTJjSDZh?=
 =?utf-8?B?d3RSUGNFQk4rVjQyUGlUaU45MmpiNksvSmJQYmxpd2d0ZGoybUdrM1NyTkpC?=
 =?utf-8?B?aS9qVGNNRHhnSFdsVXlrc2FFa2MwVTl1c2x4cXQ0ZDkzQW5QZmdoakM3TTU4?=
 =?utf-8?B?ZFBBOXlCazNiK1JSZ1puWU1LYmRWM3E5VlFFK1BJcFM3MmI5YWNXaVlKekxR?=
 =?utf-8?B?SGYrVDVWVlJSRXNITnpwTDRwcjBIejA0QVprVnZiUnBhbnFnSldZampOQS9r?=
 =?utf-8?B?ZnBUbGlkc1pCZUhuNS9UaU5SWjlmUHp4Y2pubmVxQkhnSUNKV0NkYzBrNjB6?=
 =?utf-8?B?T3lobkExSGhUYUIrS3NzTk5KcXByeFNLcUhQSDlxaWt2R2hJZ21NVmhqWVhG?=
 =?utf-8?B?dklhKzVKUkl1ZEMwNUxadDFNWkJBOWtaZEFUUnpQK0dSdVRPekY5R2JSV1Ri?=
 =?utf-8?Q?/8e+gPYRBdgBQTTbeeXGGGJPq1cu6VxRt7mvG?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e4cefe-d1cb-4e29-d953-08df198e902e
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:20:20.7644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cvtMthAJEFIJ2h4v/7ZVIULVHBXTBcwnCfHOO1lMiuMZkYiUbcBoUCoOZvyZTlrLVGWaPE4jYvUhhmK+/gnwpTZMXgb7et/kBV9P2Flqv9siUzgVTDOq1QF5nHwrtD1h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10433

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
index 53277271f063a..49ee66759c7e9 100644
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
index 3a7fd90556501..580936eecba1b 100644
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
@@ -310,8 +310,8 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 
 	BUG_ON(disks < 4 || disks > MAX_DISKS);
 
-	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
 
 	if (unmap && disks <= dma_maxpq(device, 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index ed5c5eb126990..4f223fa36c706 100644
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
 		struct device *dev = dmaengine_get_dma_device(chan);
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
index 06c48e8cce834..0fb29da2235cd 100644
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
@@ -311,8 +311,8 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 
 	BUG_ON(src_cnt <= 1);
 
-	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, src_cnt, GFP_NOWAIT);
+	if (chan)
+		unmap = dmaengine_get_unmap_data(chan, src_cnt, GFP_NOWAIT);
 
 	if (unmap && src_cnt <= device->max_xor &&
 	    dma_xor_aligned_offsets(device, offset, src_offs, src_cnt, len)) {
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
index a4c9eef369cb4..63f40b8fd3009 100644
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


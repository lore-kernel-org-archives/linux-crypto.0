Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011037.outbound.protection.outlook.com [52.101.65.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E969542EF6;
	Wed, 23 Sep 2026 16:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180416; cv=fail; b=gCLhjs4/ai3duZ6rya3p6r6mzRUAm2UcL37zAg9g0zx4rLN6Yv11TSbddVEfSFb1ZLDbxDIOIP/fa0dS8tBO2uP0SxYx6nsamPZr+4T92l4gL67XZ3yDmq+kqi60dhh+5dCeWO6zP6Vn4zFsG0/ExF4bA8T5fJeNLQKzBg1k/7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180416; c=relaxed/simple;
	bh=a0xue6OoCIO8/zIzQAMwwkWyuYPmfqtxyYqP25yquLQ=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=tex1rvZa6viwTNMv2NcVWYLrxhVZe4PKccBv9uzU4ZMskUX4y+6lk19oGf9SDKPpRqZWJr+lCeEjM4u/0aoJ2fjQ9NYsfB5+VdNG3sDH/4XHM/CgB8/6gIbQg0IROowftXs15XXAVQo0Z57xgG2AuM8hLRY3NEvTQ2RPrQx5mQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=GGD/9gqa; arc=fail smtp.client-ip=52.101.65.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="GGD/9gqa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sb33sAQ28vX+fGCqJJAGBrrVxpkIfqXFvWAAW2JefUmAXrNPwLTkbHjQWrrmpThY7unQ193iU/nYEhoNYz/fEPpHFe1U1dpNd0dVmBX0cCqHsUtDR3Tev2pSnw9TAxVNsUnhrxTwWNkWu6KBwtBsPpKZReaL19D5tcMBPRK2xdTRNkBsBB9CTgxRhv5GaKC3xEXnn92LfLTtS9lH23iNp1AChghr0nWp7EuxK/jhuAkKl/Kxvdk1a4u96cH2zFNxwR2RKvP096fePxsfjJsbXVwG3Q579+9oPDAnaxwnpT1NU+UsKTegtZZS9cCMYgkqc76Z19hJtMADLEMn3iQcRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qgQkaR7thcFRVfki6O6oLICs7w6DcVT8prsTtcWgnS0=;
 b=hVzFCAbEaD9REen3RkHv4DedU3Cdh5XCB86JkKybf7hdHhGM4UXL7rH/ZwXf/rx5diAtyC6xKBGBdEiqHeDCythsZj9/SM8uGtcQxDpVZ54stTLaZ0cz0IFBRRRPL5oL0ff5SJwHhODMH8JyPjlP9z99JwKFMFo+fLBdY9QuyVMfn8An1n4xP5eG7XKJxDEE4ISywg338qwmVcuOhk5NMP/vOu5puiaeOUHAp37ZtcUMQjghwKa1lRoNY948MHvY+nku8v4hpMTXQFXh10xai5JaHhkrtDANlnszVqvYeR3swLgdVEHggyRXFl9F7iIxm0EcSqSWgmHPDXhonJ/mbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgQkaR7thcFRVfki6O6oLICs7w6DcVT8prsTtcWgnS0=;
 b=GGD/9gqaeyVtDSFPZAjulLTF3MjZMLtmEoJswhNx9iXHuphWHMGQrzPVl29K796fPi2Q6haPy9DVQVQ+fuXCwkyLVz58ueuXrpCo9PtlZTjw9j7qzfn3DE2pTeetbaiIsQ7+hKmlH/SE43mME8g1QamqnwqgTI0m5mrdaf1Q75w60sEWOEYRbnIbJ3VqbjeCXuSvUpFedcXK14gWjKwxSizJkkIbmw4mygDB9TWgDZMff024a/2+xBlwEOX3b4jTWvceMCWFKn+2immN+MiDnu4kE13ZDxfYGQWPW/Q5Oe7mndCVxvoNAGXNx9yyBvITLOXIYm99gXkCKkuh15+bqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DU4PR04MB10433.eurprd04.prod.outlook.com (2603:10a6:10:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 16:20:10 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:20:10 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:35 -0400
Subject: [PATCH v2 06/12] dmaengine: add dmaengine_get_cap_mask() and
 dmaengine_has_cap() helpers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-6-32ed65b8a9b4@nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180376; l=1948;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=LbTWPRWs0wkYYm3bvRVBKMHG0+6GV/m6lMVJZtyllFY=;
 b=MD1wOZuiz35P3kOZwXGcedRfkICTHDIKLpOgBV4pqfisaua0o292+ecm7yIpgx/+L0XNqlXtt
 vXhBZudl7iZBhble1xtdIMMWOZd10D9xo1E2hnmK5zkRzWvys/iaA4S
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CY5PR22CA0042.namprd22.prod.outlook.com
 (2603:10b6:930:1d::35) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DU4PR04MB10433:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b473ee-9094-49a4-09e0-08df198e8a48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19092799006|23010399003|6133799003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Krhixxl/xNlii+YkOo4jjKIt7dkUW+W46nIyPvbPIvAAt+hFu5JH1IAWQfNQ/Ea60nIVjpbyxXomBXJmiN6EA3RmQVLR7FZGz5KUuyusYjyErqSqciBgScfJnYTrpTliHaDL5ThTBM41maxpDsGYzrepEIAhUm1O371ymNtvF54Sa6aGwa05qSdR4lTdiu1eYxhbtDqPP76mTduX/lcVOv5BKtaZ+6SvEwmCTDHg2+cJfw9OJKnu1CCoBPQopIG42qQ35U6SoDOSc/6UO7LkfH/ntdDD1Qa8irYYrYFmVGW+EbYUuMs44hibIQCW/hUSb4eUq2vZZHzJEHXUxXQ/4OXUNkVpc0ISGUVacJ0v1EvPQUWNcbAi8YMf2EwlKEf/DlX3AkY5//F24vn8cblyBQ1uF3NyfrFa0FF9U92G8/4I2580uiZR5ZqlEWOFarPXvJpV3S0ykE7u/C1Mx1ze2+35QCffyRwMcJsl9TYDeifDX1eMQHUs+E5Z27jtDKvaATvChZWr+FbqQORD6lhw7c/4svo5H+14sUx7Q7vHjodcRNhj97pjRTSFxvylqn4N3m+jr6gFR3L3SAcs2OmuDHe53JPRf8LocxTjLEPqwe7FHoCx0wlUKbNPWyJOdshxRm6PF/u+k2xgGbh5FTMiAkxJCUGtOxZDPMxz1Ne9n3Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19092799006)(23010399003)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1IwQkpMa3dWOEtmaTlFTWhndE15a21BanlRTFdtWjcxTExCbmJtM1VLdFJH?=
 =?utf-8?B?cEwzZVV4UlhIaFVJZHI0RitkZEs4bmFrQnFMQUFqbytVSlpSWTRmWlNURFVi?=
 =?utf-8?B?TzZwQkhRUXhmcHF6S3RhcHJoOWVHOGhyMW10c1VLTUlaY0o0VkEwYUkwMGtF?=
 =?utf-8?B?UVlyREFLUHowRlFXSGk0aHlyKzYwT2t2eEJKZFJFNm9pcTlpZkpkejVaVGMz?=
 =?utf-8?B?djNPaXZxcklpbTlNNFMweExQYlo4Q044YlF4ZkxrWGJUUXZFOXZDRWpMdEQx?=
 =?utf-8?B?VFlRNUNwYkhKUzdNa1BydE1nVUxTZGNvUVFjbHVnSk1Ua1kyeHVOYzhtN1p5?=
 =?utf-8?B?YW1ZUTROR1ozaEM0VVVhb0w0Um9lVDZoSzIycXl0VHUwR0pQdDJiVU9oQTBv?=
 =?utf-8?B?eWkyekQ4RWVBdEx1NlhMZzNlN3lOQ000Rmh1Wkp0bXRwdGN5c2o5dzcwK3Y4?=
 =?utf-8?B?YllaOGF0bDFYbW1QclpjL2xyUkdkMmdzZ0FuUzFYelVTcU9mMm5raXFhcGpL?=
 =?utf-8?B?dkdma2gxYXNlMzh1a3ZiQzdqbDl6emx3NytJMFpsbzgrQW85d2JHRDYwNkwv?=
 =?utf-8?B?NXErY1hBY1B0bDBCdUUvcTdYd1o4czBlck9vVFdJcVRTNjZaWkpidDdoQjNv?=
 =?utf-8?B?L0IvZTRJYkxhajk2UWlFWHQ1NDdpamozUXdTQ2gvMFFqWjRnazNmMDBpT1Nk?=
 =?utf-8?B?WlJWK2FXaVhLUUovc2w4ckVJQkgxQjlHNURrOWhNb2VBTytxbzV5dThxclVB?=
 =?utf-8?B?L3Q4ZDZCRWtEbWZFVnQxbFJIclhSOTd2QUlsSlpWVXkyS0padFMwams5N0ZM?=
 =?utf-8?B?TmcwSHZDa0tuRFpMKzcvYTJpcUNBMDNQUlBDci9vNC80bGVUamdNNHFpL0Ix?=
 =?utf-8?B?VkMvRW15OWh5NEtPRk1VS3FhbTlnaW5OTXgxbXNKVFBjNzRTUE92NytNQkpn?=
 =?utf-8?B?WVdJVmI2ZVQvVE9QaVQvV1RrVGRHd1VucmlCRm9JRVRERGxJMVJCVFB2MzMx?=
 =?utf-8?B?dW5NZDBxd1FVNnhrUVBNNU45c0hoTU9JR0dib091QUQ1RUdUdm8wMDRISVNn?=
 =?utf-8?B?L0ZCOGVJaDgvaG5KWmlNc0VGbjNldWg5K1cva2JnZERHeFd3U2ttOWlhM1RN?=
 =?utf-8?B?SGxmVGd4U2xLM2NaZW4vREExZFhPcTJtRHc5aldXZWdOd0NJNmZXKzhYaEph?=
 =?utf-8?B?clJKVWd0WTNBRk9wQkJmVERBbjluZHRaWURLTjdJRVhJV05lOXM4RzZmc2xs?=
 =?utf-8?B?RG1SeWZzTkdwN2VJSTUxcTlNdEh2ckdUY2tJajdmRWZxalZWeVE5cXRaTlk2?=
 =?utf-8?B?MnoxbVIzY1VodXdFWkp2T0ZBYzhzQkJiWjRxMjhiRjRWSTZxSTUySHR3TkZU?=
 =?utf-8?B?MEIwRFpJa0VZLzI5TlFmM1krYWFqK0hKb1RaampzaHZPM0FaSkxoWWRvb3lD?=
 =?utf-8?B?UHZnU1pSSmQ4K052dVV1VHp1TXVablp4ZTkyT0daZ3hHckV0ckpZc0NqWHow?=
 =?utf-8?B?aUltOTNaTFJ1SG1HZWNLZjdjdzBPemRGRWFiVHNBYVg0ak5iOE1SWmVFakNa?=
 =?utf-8?B?M2REL0VteWJVa1NPKzNRTnhJMXh6VjdXT2piNFE3NllCY1dEYmlzMG95dmZ3?=
 =?utf-8?B?aDVDemNoeE9HNjI4V2NlRkMzNXpmSVE3a3VPZkordktUM0NXa25MUVg4RDdB?=
 =?utf-8?B?MHlZRy8rUVczNnVkZXFVcHBLVkNBN0Y3OVZubGQyQ3ZCUHBESUIrNktzNTNT?=
 =?utf-8?B?QXVjWEU0bTBDci9OemdGRk8xN0FUVWNiSnB2VzlVSmRreUVQVnpWLzhqaDBU?=
 =?utf-8?B?OFA4YVEyZCtYc0UvT0dyTjVkVmhSQmgxQW5QMDZ5UVdQd3BwbElaRmkxSTFY?=
 =?utf-8?B?cnA2RXF0eUhCU0djQjNFbVN3L0krS2lDWExid2dvMFZnc0FzWndZU2NvRjVX?=
 =?utf-8?B?WlZST1UxNmIzTDBKLzYvallGWVBMb200a3M5bTNYNWd6bTA5WFJQQ2NJWDdw?=
 =?utf-8?B?YTBPcEVNN20zNElrWDg4VGxRLzVnMVNGUlEyNXFqcmVuSkhEWWdqVmx4cmhr?=
 =?utf-8?B?cE9LdGY3cnc5dkhlNUtHTTdtL1NNNEU1bi9SUExGclpSY1F5M3VaTy82aWFY?=
 =?utf-8?B?akYwZDVPTS9QWWE5TFpvaVVwZThlNXdDWEp1SHc3UUxUdGovb0s4VURYRzc2?=
 =?utf-8?B?aDlneXBwdUpoaE1oWUZRM29pQXFyK0JZRVFMelJJNUpIWWxMZERQUzRhZEpt?=
 =?utf-8?B?U29MVzI4aVdXemFIV0t3Zy93dGZmOEdzcVNnbVB4ZFBFcnRnUUwwQndCTWxs?=
 =?utf-8?B?S3Y0SE95QVo5T2VpUS9RTXZxdjluMUNWQkRJSnZ6YW1hWVIrKzRoQmxOa0o2?=
 =?utf-8?Q?7+OOmuSY0xWUmmNFfyQr6GrPA3dJ/JsFGnlaW?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b473ee-9094-49a4-09e0-08df198e8a48
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:20:10.7509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 59l1n6ML9fBP/DunaWpY4mlStMVaKaUMOnrBk/RSBcK1yOEq7tBxqqcZ4cTb2X6Nu5zDWVcCiFOgb3WGvlA0QV5+kcgKnPn8ELxskfy+Nr/zyMSoj6iGty53Do0PC94x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10433

From: Frank Li <Frank.Li@nxp.com>

Add two new inline helpers to query DMA channel capabilities without
directly accessing the internal dma_device pointer:

  dmaengine_get_cap_mask(chan) - returns a const pointer to the
    capability mask of the DMA device backing the channel.

  dmaengine_has_cap(chan, tx_type) - returns true if the channel
    supports the given transaction type.

These complement the existing dma_has_cap() macro which operates on
a dma_cap_mask_t directly.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/dmaengine.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 615eeb708dcda..7fce44bd7c049 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1585,6 +1585,18 @@ dmaengine_get_fill_align(struct dma_chan *chan)
 	return chan->device->fill_align;
 }
 
+/**
+ * dmaengine_get_cap_mask - get capability mask of a DMA channel
+ * @chan: DMA channel
+ *
+ * Return a pointer to the capability mask of the DMA device backing @chan.
+ */
+static inline const dma_cap_mask_t *
+dmaengine_get_cap_mask(struct dma_chan *chan)
+{
+	return &chan->device->cap_mask;
+}
+
 /**
  * dmaengine_is_copy_aligned - test copy alignment
  * @chan: DMA channel
@@ -1810,6 +1822,19 @@ __dma_has_cap(enum dma_transaction_type tx_type, dma_cap_mask_t *srcp)
 	return test_bit(tx_type, srcp->bits);
 }
 
+/**
+ * dmaengine_has_cap - test whether a DMA channel supports a transaction type
+ * @chan: DMA channel
+ * @tx_type: transaction type to test
+ *
+ * Return true if @chan supports @tx_type, false otherwise.
+ */
+static inline bool
+dmaengine_has_cap(struct dma_chan *chan, enum dma_transaction_type tx_type)
+{
+	return dma_has_cap(tx_type, chan->device->cap_mask);
+}
+
 #define for_each_dma_cap_mask(cap, mask) \
 	for_each_set_bit(cap, mask.bits, DMA_TX_TYPE_END)
 

-- 
2.43.0


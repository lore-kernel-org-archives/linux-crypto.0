Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013046.outbound.protection.outlook.com [40.107.159.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE433F3294;
	Mon, 21 Sep 2026 23:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032168; cv=fail; b=WN95Yyl9I2oTO8XGiG8Uc5+uUSy/b3Mtm1A25+Zmr9yo51D+0x3pwNU4ilYpsEZi70yt4Xc1kB731YqzSnpC+ANAhJulMKtgBGyc3kcD+c5AdxWTP97ZmmLvWuvcRAANzhUB1WDLK9GF2yE+zWMeFZxh4ytovDv6lCcPnuZD7tA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032168; c=relaxed/simple;
	bh=edOPyJf68QzYHOZh//HsAaXWLDmxmh3nahtwmRunLq4=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=JSrBkBj2OJHie0RyqEGsWY5/djlRsZb5/XqmVUvr1T5jCBcdZQKF0VLWf+7C1nDDXp6cVKR8D2jJjot+95CyD2snz93sB32evUX3CGTfvj99WldRt0rdbiyNISsuvQnCbbYGcQ2V5D7HMNL21BUi5Y1jsCgaczlLcPhv+t727fA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=E5snihvB; arc=fail smtp.client-ip=40.107.159.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="E5snihvB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lIC7YAU080rpou4wZbYZBOcBwYR4hqosPT2FLhcVs+sk95waXZMvv+wayiWHM8rm2LV2yD2yVnO9kksq0rETq8leG5SqAjx+P4pYndW5x941hErtZ9XoB8IBc9mNuXaUIYsacoJPPoQezeqUFXRh7rN1CPDJNiQ1B7xBykrQfSzlM6xwFbDMufMcMHVzWiKi2A3Oc70xLA4OEsxhGSuShhfBb329Akn6fL1WCcv6l91rNFCry6Fci79wWzpXmDkS3Y+7y1OXpoZWqf1L1JydOZdRG7SstkAVH41g2KhLW44eHnNhSlFL2j/cIXp7LEVjk3C7hkgINJo39NT6/903Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HdzILpTxOlP03LCh8rt8wp1Tg+Y9i+pYgPOPOv62U8E=;
 b=AwpoXTDaz68JwOVY/NWKNE7AiagzbVbPch7tLrqpqz1SiceyTLqOEb6gw7jt8eCQ/BqM8HUFoPQcPRxlIwX1KeOTBLEdN55SNsnzWLTQurp82HBgSXKZa0n1VsAMfKcHUtQ2oKfJ1hyhoaV6GL8yFuYCTQB7QUOpeCa1W6CXDWDwce93AkJrsg3Ez/RS+Je/TUPB9lzqXjjJwMZJfacmTyVuDX2VnjklIoIa8xChkGbOD8BY/22OCvbtfDLC2HnLHjy8/w0hO/BsNx6skJORAI7BWEIRUKcvUR57NW12F9/eJj53ZycO7dGkQIRsZdwfAywk7Xj1bMLeJLyawnw69g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdzILpTxOlP03LCh8rt8wp1Tg+Y9i+pYgPOPOv62U8E=;
 b=E5snihvB5wFBbelnZOS9yjdwqjbMS3/gCa9SUi7aKE0hIOR+rRYgqmvQvdaZ0+B4nkOKYtxSXrgGhwaK97eKKpxKte0gwMyDffbw9S0NdM7M1qjEpmrqklnwdR4vUuIub9PWzxFlSYT0/Sh1wLyDTP0SOMeBjrvzuTjuWxVf/mH0/NJnyaskBiMJMVSh9239hg3TMaXIpiYx67ciWkeqc6YGh8wbJEiRGZNjedZ28TiinF4GaxbYubQRAgVhLzX3FziEAapzVQJ7KADbulO6fsA5JqiuEtCNuKJ/L47D0dmLm0FUN6MYaa/fRSpwGiwgyKztguk/1pYZcGCukKfuew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DBAPR04MB7352.eurprd04.prod.outlook.com (2603:10a6:10:1a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 23:09:22 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:09:22 +0000
From: Frank.Li@oss.nxp.com
Date: Mon, 21 Sep 2026 19:09:04 -0400
Subject: [PATCH 2/3] async_tx: use dmaengine_prep_dma_pq(_val)() instead of
 direct callback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dmaengine_prep_dma_pq-v1-2-9563ed448260@nxp.com>
References: <20260921-dmaengine_prep_dma_pq-v1-0-9563ed448260@nxp.com>
In-Reply-To: <20260921-dmaengine_prep_dma_pq-v1-0-9563ed448260@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Dan Williams <djbw@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>, Frank Li <frank.li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790032148; l=2926;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=J02hKEzWlyjwJDQ/5gRMCfoS6aF8gH85aYAceOoyjPk=;
 b=r3r/QWzFgTZ9GwLqSjh2IPQGvuCOAklt3uvjFprPauKoT+m5c9xMCJ6OLWrL2nLx1FkiOwXo7
 ZJhSz8gmh9UAuauMi7xSR+ndx9gmcEpCImGTKBm5lkHWdUvurF26nZl
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CYZPR19CA0021.namprd19.prod.outlook.com
 (2603:10b6:930:8e::22) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DBAPR04MB7352:EE_
X-MS-Office365-Filtering-Correlation-Id: 58aac6d2-0b80-442c-7ceb-08df18355fa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|23010399003|376014|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4LSebxmmRbvhW8oLT/zU6dT0si1G8FMWOK3+l0Eyk5ednvub/zfgUp1P1111/6GfRHi+XccFnyUcTsCDPj/o5FiJBdF1eKZpSUMYroic0RspDNxxgZFRgwh5tW2i8kzHDMh2BJS/9poKNVB4kkey/Eqs033cSJiKZWY3gZQvyam32PiYVOgRypf/AC7pPUD1LtCGKnETwo5Qgg7EBMS36ey7NdTUDaqsiBzHoBLyQeSln2o00HeEVMIcMcSdxEUXvZzxzpWfAL20pa0GUbaWEYiFPkiX/DthqOwj5wJMcqLorcm9BD5tXQCZmrGq7VsnpTP0oLvfPm6q6pihFM+nbwqHInfDzpIUO/glvIAst5ST/YrIF6OoYOgh7gBNtF4AKimEMCe6+U7szLPr7aan0as8gZlHhX/n8nBjFLa/lrs5M4Klbqr+NXibiX0eIJIlRQPNe9MEP+iO3W1g4I8d7ZrSYHkFz19F7rimZn30/ykwgbylttdu+SCx2jEgoeqqR2UtPB8ZA6OaWNnuzbD8ZVZWMq5F261v49C6gYJiLfwViCIPZ2aKmM+rHJt7PnwEd5au3QFwIKrTgZEX3AhkoYFhAE7FvkOED/cJjgzD1Q2hjfVV3VVA2mAYl1m+0OYmOKZaRJaKzv7TlVGj7Cgle9gh/Sb6ytEfUCsixjiWes0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(23010399003)(376014)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OVpyazVoQXpqVFlGckIzRXlYR2NFQzBKVUhkQytQSW1oOEwrUDZpMWpwTXBK?=
 =?utf-8?B?Vk80bk1leTFBckZ6WkxVMVY3V09sRmFDNTlJbEZMaFVoaHEwMThJQS9tNk1S?=
 =?utf-8?B?M2djSTByWWZNTHY1aCtqSEl0R21VSklxR0lLdnlyMVNSOWhJQ25SRE1TaFpq?=
 =?utf-8?B?NlJOQlBsd1hjTFY3VEtyZzVORk1qMlZUUkhNSXJKVlpWZ0l2b0pBYXZoOG1O?=
 =?utf-8?B?QXdVdGM5VDJxaEdENUhCVWRSUVFsM3BlZk1MTUFuQzFweGVHd3J3cDNZcjlo?=
 =?utf-8?B?ZE5keFlnOWFEUmp2SHE1MzlWMzRoV2ZyZlNKV2tFZTYrZmxkZ3A3MnNjRUVz?=
 =?utf-8?B?cG1JNFN5OC9CVGpOTjBxb2RndEFzeHIwUE4yR0ZUdG1LY0pmNkJicVJhRHVL?=
 =?utf-8?B?bUNWQjVFSDg5VWZhcUpxWjRYQkY5MGUrNkxORjMyb0NUdHkyWDczaFo5bC9Z?=
 =?utf-8?B?cVl2eGVWN1hZNlZRaDdhYmFxcjlnWWFkMis4VjNOVlJOZTVZL1BLbTR6aGZY?=
 =?utf-8?B?NnZGdGtGSzYyZFpuU3htYVgxZGIxTTZZMDkvRVA5Y09QQ3hDanV3Um0zWnJ1?=
 =?utf-8?B?S1RCbWVRVWFJTVVQL2U5eng5cENQb01WdHBjVmt3Qmc3Zk9tTCtrQzRsOGZF?=
 =?utf-8?B?alBoMHZnZDZmd1JLUytyWjJoYkgvQkYzcTRSN1RBNHQ1NVNERi9jY2tzS1Zl?=
 =?utf-8?B?bWRFVWFQaXZuUlVkWlo4T2RMOU9nbWtLanFTQ3F6eDc1QlR3TGRia3E5OU5P?=
 =?utf-8?B?WmNXSjZqSjNZU2FtS01hRUpnYzdIbHYwMGNMY0hHaHhVdi83QlRxMEpScW9y?=
 =?utf-8?B?cmJMRWRjR0xtbFhMTXgvQUZNQ3hoRXRkcndxWUtObExrQS9CeVJiV0FWMkNh?=
 =?utf-8?B?WVRRazFxUkhPSmlBSzFNTVgyUTZnczZHUEpGMHdaNnFBckk2YlJON1JPY1dB?=
 =?utf-8?B?MWJiMVBNVndqVXJFZld0V1M5NUxYSXJuSXY5SXk0K3VvUXJzdzI2K0pIRCtV?=
 =?utf-8?B?eWFtb0lqbFFIRE9CU0pKb0Z2YmhaY2UvdG5aVXFIQ0duekI5ZWhSeXU2Q0ZD?=
 =?utf-8?B?ZEVhWVhLcHoxeER1bkk2am1KWG01aDEvV3FnMEk5QXVxYm1lZVdBRElVbkZk?=
 =?utf-8?B?Ym9YNTlueFFUd21XSVRPYVo5cUliRU9mY2dLU2dVakZtb2c3cU0yUEtvcVJw?=
 =?utf-8?B?SWNSOXU5S1ByODZneExSUTFnOHoxWXlRb3gyWTU0L25qa1VZRXdDclpnZFZV?=
 =?utf-8?B?M2QwN0t4S1dwdCtGQ2Jydm5DWjZhdGU3amduNnBhNEZ3S3NpcWo0TW0rMGFY?=
 =?utf-8?B?bUduam03L2ZvUldTQncrSzY1TDhGTzhxTFRodU1ldFNJTG1UYWVwd21yUjdU?=
 =?utf-8?B?RjdYWC9QUjN0V2h4V0hxM3BrWHZIRzl3Y1NSVnBya3p6ZlRoNW05bFViTEp6?=
 =?utf-8?B?dkFYTEJ5YXRWcDdiYVNLTUk3REN4L2p6TnNhOEZ4ZGVPUldGL2RVM2h1NnFB?=
 =?utf-8?B?YlVobVpFSEx6clVreU4xMGZsRUwrd2g2L3h2VXQ0NWhURCs2KzMyaHAxK0tM?=
 =?utf-8?B?QXhma1VSSW82em5VK1V0YWpKQlZMUzU3S3NIdjNnOFFpVFVUU1oxSHFnRk42?=
 =?utf-8?B?L003Y2tzYnpXOFlVWmt1S0VEL1JqNGJyU2hMNGo4ZmpYWGRsZGVBNlBoMVdm?=
 =?utf-8?B?KzB0MTJBZVc0aGJ3eC9UbXZZZHEyZHBtd3pOM1Q5SkQ0MXhJVXJSRkNLd3dJ?=
 =?utf-8?B?SFlPYUhqZnpRMGtORGRraHdHNFFNSndqdXkzNE1XR2dNUllmRXpWZXdySGFH?=
 =?utf-8?B?WThOcUNUMHhRT3QvaFZzQ1IwRCt0WDc0ZVB3L3QrMXhjV1V4Wjd5ek1qeWF5?=
 =?utf-8?B?cnNjdWpCZ2dPSEtrMkNQNFJ0ckl0WE0vU0VTc2pnUzVBVTdabHVIRVFWKzJF?=
 =?utf-8?B?dzFqK0xZYTdXUHNJZElwZFByd3phOXBLK3dLVnhHOG5EMnJjN1RPYUJPcEpq?=
 =?utf-8?B?M3I3TFlXOUV1N3UxU0c4NWxJSFlHaThuZGpXYituSXFoc0N6V1hFOEo0NkJU?=
 =?utf-8?B?eFVmR2trajFiZ3JxTis1TEt5SDEzM2JUUHJMQnNpcTg1WlFhK2RHM2lhV3JS?=
 =?utf-8?B?dTg1Mlcvelp2SWEzWFBpcGtJdndRZlIyd1FRZ0p6dmtnakdlTnNDalR3WlVN?=
 =?utf-8?B?RER4b29oQ3h0QkdzVnBkMnpHY2xTYklLMURkRWhDaWhDbGIxOGhhK1ljcjhX?=
 =?utf-8?B?YkdIcUx5cy9PVUdJYnlMYlFDSmdzZkNGU09kUGxTN1FSekQvVEt4a0xiZUNF?=
 =?utf-8?B?K2UwZjRWYjJMaDVsa2IvQm5wM0JaQTIvYmdjR0RGZ2RTOFVyS2IwQ1N0QmE2?=
 =?utf-8?Q?CpecBausmA6e4PezB4prcdI2V5Gz1HuUfuRKf?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58aac6d2-0b80-442c-7ceb-08df18355fa6
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:09:22.8620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tKC16WokXo3npjeNPwJBY6cooFMUAduWQx0QT/wUFK8KMfLKU2rVtyr0stAP+7Bismm8nJ7lU2Jys0tiJAuIUMwhF5HGdgsLcmtPWZqiUpD8hcxeu+0CJLxpyEROieY8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7352

From: Frank Li <Frank.Li@nxp.com>

Replace direct device_prep_dma_pq() and device_prep_dma_pq_val() callback
invocations with the new dmaengine_prep_dma_pq() and
dmaengine_prep_dma_pq_val() wrapper API, consistent with how other
dmaengine operations use their wrapper helpers.

Assisted-by: LLM
Signed-off-by: Frank Li <frank.li@nxp.com>
---
 crypto/async_tx/async_pq.c          | 22 +++++++++++-----------
 crypto/async_tx/async_raid6_recov.c |  8 ++++----
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 27f99349e310b..1087a478447ce 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -76,11 +76,11 @@ do_async_gen_syndrome(struct dma_chan *chan,
 		for (;;) {
 			dma_dest[0] = unmap->addr[disks - 2];
 			dma_dest[1] = unmap->addr[disks - 1];
-			tx = dma->device_prep_dma_pq(chan, dma_dest,
-						     &unmap->addr[src_off],
-						     pq_src_cnt,
-						     &scfs[src_off], unmap->len,
-						     dma_flags);
+			tx = dmaengine_prep_dma_pq(chan, dma_dest,
+						   &unmap->addr[src_off],
+						   pq_src_cnt,
+						   &scfs[src_off], unmap->len,
+						   dma_flags);
 			if (likely(tx))
 				break;
 			async_tx_quiesce(&submit->depend_tx);
@@ -357,12 +357,12 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
 		for (;;) {
-			tx = device->device_prep_dma_pq_val(chan, pq,
-							    unmap->addr,
-							    src_cnt,
-							    coefs,
-							    len, pqres,
-							    dma_flags);
+			tx = dmaengine_prep_dma_pq_val(chan, pq,
+						       unmap->addr,
+						       src_cnt,
+						       coefs,
+						       len, pqres,
+						       dma_flags);
 			if (likely(tx))
 				break;
 			async_tx_quiesce(&submit->depend_tx);
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index e53870d84bc55..27909afda694a 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -52,8 +52,8 @@ async_sum_product(struct page *dest, unsigned int d_off,
 		pq[1] = unmap->addr[2];
 
 		unmap->len = len;
-		tx = dma->device_prep_dma_pq(chan, pq, unmap->addr, 2, coef,
-					     len, dma_flags);
+		tx = dmaengine_prep_dma_pq(chan, pq, unmap->addr, 2, coef,
+					   len, dma_flags);
 		if (tx) {
 			dma_set_unmap(tx, unmap);
 			async_tx_submit(chan, tx, submit);
@@ -120,8 +120,8 @@ async_mult(struct page *dest, unsigned int d_off, struct page *src,
 		 * dma_dest[1] and ignores dma_dest[0] as a dest
 		 * due to DMA_PREP_PQ_DISABLE_P
 		 */
-		tx = dma->device_prep_dma_pq(chan, dma_dest, unmap->addr,
-					     1, &coef, len, dma_flags);
+		tx = dmaengine_prep_dma_pq(chan, dma_dest, unmap->addr,
+					   1, &coef, len, dma_flags);
 
 		if (tx) {
 			dma_set_unmap(tx, unmap);

-- 
2.43.0


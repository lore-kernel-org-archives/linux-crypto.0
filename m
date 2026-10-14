Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010030.outbound.protection.outlook.com [52.101.69.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3D2568FC7;
	Wed, 14 Oct 2026 19:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792007055; cv=fail; b=lQMX/9PJzowvJGelKG+fFSZoFaL0XyjzPR79NK8IIpqBhTr/eNZdCO166NKvA5oA3r/21DjBB//BlXQIIxC0h2otMZVLgkgaLkJfokPn93W+tl0nFiLeIJJwSvGSMqIRQnoOnZor6Acgy+kuxUuoMg3gDk9JeR55xyR9QWiB43w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792007055; c=relaxed/simple;
	bh=+cjtSJMaVWC4Uj1kEdLRUmhBklojOKrfvTIMIIhCvAE=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=XjvjMl73+mKmOXHUPwtwL/RSCBEG2zNA5q7ao+azs3+LT3hUzYzjpd9gkOrN/iIQHGjaL0EFjFdCskciQydI5Y1G5rrZQhLlqDEoJL7QT5X/yYC1cQtId6HzPXj26hFoxQXd231QVF391t6xol7NhbMDjL36D/EskHFnrWpAbbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=H+DV68pG; arc=fail smtp.client-ip=52.101.69.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="H+DV68pG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kg+nikYkBNpUapsWWu9CCClwTbmlAsWHkAKFHTW6zIG8DEKEMDh8ulImkxQw6TiJjqEFivZ+89BFiSvUkzPA9TYdG0VunyMdV83n+Y4CvmKrzgqDlUMzvtjP6wfiEzwwznx/9+2J1Tf3k9UhgrQUpmgXOTB5Ke4xl+xrW1vycR+eNSV3Vgo6aw4KxD457RQAXkY01zx/GAnOx0Eelzb4U5dxWdnQigekMwiYAYMPP2oG3wPy2SRGqRZoSLx3IUwQScYEVf9Key6JIenJ4beW6rsGmNGR99cPjFLwIelpcOk2lNlPOlKz9MKbOJI361NWg+4fDii0SUq7jCxSUkXLfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tn1KY9tC/gG+JW4a5aQB1++WlTOSlx9IYNf1ZDqYgpU=;
 b=jZHlNjKyNjWkcQynAfi8U7SARQJTUJlPRR2jrNhrHgAh5+i8pyJkCT39SKw1V5pwqAOuyQUWIaEOngZqgYgCQUQGgAdsw3X0KbtlVr0iKdCQILtf3WTcUUHR65S/Lx0gUFFMktyFHLeov2HuON1TWX0i2rQwRj1M7jGU6RWm1v4GD3BBW67WRlqDjfLKpJ7XJTVNWzHvr2GedbE4KyQQo6a/h9jXUvB93qibVYH/SQB+qUVeQPTpF4m2sk8GXjeAdZgOSl3R/Ihg6lz3V9/ARUkuh7FL3l2UOqvp4JfW8rmjMtJqCihMQrKqduPgKCEBzPhOHXs+6w2NYrt2cyXJGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tn1KY9tC/gG+JW4a5aQB1++WlTOSlx9IYNf1ZDqYgpU=;
 b=H+DV68pGHNuSK3/LMIM5en0vQbIvWYxtXT3bLcdBT1tUT3Jo2RiNC7A/8CGPzyjhxM4Lha9If+7EKzfK8Iqx6NSiTSrlloqgtFtdvMrX8+/Ras74JERYKKVOklZhLKI6znGBbWt9/IRo+ACL+63zRF2/v0MgFoAy/lHYpR48PlkBiyywBocmBXkIIJXmcNWm4PU7gNOzQ8MUz3IjqrQ02bUJu4SwVM903hcG6PUAmAMJemrrn5sXG1ZS5YuGFetozuHiGqrTTTmBfCwQR4NwjFpYSL3X5MRsXhbmxN0yZoevCLosC84mdfMcuCc+3vnXaAMIIFiuYdYU2xSzLKHZqQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB9PR04MB8361.eurprd04.prod.outlook.com (2603:10a6:10:24d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Wed, 14 Oct
 2026 19:44:11 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 19:44:11 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 14 Oct 2026 15:43:46 -0400
Subject: [PATCH 2/6] async_tx: use dmaengine_get_dma_device() instead of
 chan->device->dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-async_tx_dma-v1-2-35790d01e190@nxp.com>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
In-Reply-To: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792007035; l=6660;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=JD5PBbZEx560embwsVFjV1gz0K4Z3/+q5oA++goDCCI=;
 b=5/aRUAECmrLRY9AvhWtNWEx+mRLf8XV1Ri4pIdXVihN62J0b1g+HACzv1l1ziDJ4d+inXi5DO
 qYmUcyRc1cLC2jMxpw3CY1KAv/LSDdPVY5ZVUVbhCCV0+Q6lxLxY0qd
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH7P220CA0102.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32d::12) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB9PR04MB8361:EE_
X-MS-Office365-Filtering-Correlation-Id: c84eb4f5-da5e-438a-2986-08df2a2b84d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|19092799006|56012099006|10067099003|11063799006|22082099003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	3y3ydkpTDaMrUgAn8pZjaxMS/lTYlXY4HIJgpbEWFoBeFMbCkR/zT6bmU02eXs1TSHZI2qdTblVjKS752uS2SI0Q8ZnsctSkud/5c2wzOOTKnDZQipqOPiBYkrK/Fu8l/1oZUpXX3ukJBM9emUzjfWNcLRtDLtpMe0+83Q7jlUDsZh0quIsV++R7TT9Zb/aqGIVNYAPhq+5zIi0KU171YCW+hRleunV2uqq0dkp+5BYdDqlfdTzbubvYoQpFmt+1GZ/5WPmo/NUl4ZJT8+Y7L6DtrawzM5/e17CqZHIjvj7vvCoBcQqd0mw4Y06QOUpwMbJCUPqoAy9N/r71yKJDTQPj08n8FFO4gSWpxCUs3N0pVln5A/gF1EQpim4LQ1EOztjL471hmm7FVhcvA0skivKDoOuvq/f0GH/BmlYGUHd+VRblSTM00DLbixDX7+TV0vGSJw4ODlz0mO9JsCPhE556HboAX+u77WCZj1E5pMo2qMyxXlfBwV7oSbwLdZtdpTxFm0Ywx+PKIgDz70++ziaFiXNLmO6WWMeoBsoao1FucFIjLZjVtFRgOdbIuosP1QZ3OUNByqD68HQpfJazugb8/FjGf3yW3Zma4T10BdHANJxaK+ujvdpgTekpNtSeK6uJnRWJL6sD5XseCorg4txxN0Z518BCeJmLJGhNUIw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(19092799006)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUpPU3ZNdlM5SW5xTGc3elNyZEdBQ2pJMFY4WTJadHVPMkxLNytKWU1qMDFn?=
 =?utf-8?B?dXFaYlo2SXpQaGYvOXNCTTk0ZFAwbklWYWFaWFFRd1pzYnpUUkdzNGUyM1NS?=
 =?utf-8?B?aEo3WmxUNEhOeXpLVGlnRk1WYUN0VktUWG1aNnhFanFJeHdvYnZWVFV5OS9z?=
 =?utf-8?B?dzBQSEM0Z3Q3VjhsMTJYRmFTK0VKMFc3a0h4RFA1WEVTdVRBenRsSmVmMW5r?=
 =?utf-8?B?SHplaEMvZGVGN3BMTzlWZGc2RzNzcUZQWFhNWnZwYy9YVUo5eTcyc2ZsVWNk?=
 =?utf-8?B?VkVqdlVpSGVKaWxlMVBQRnZnRjBSRzB0Y0FaY01yTFJuVWZ4cURlV0RkTHpx?=
 =?utf-8?B?a1VxQnZqdnVFdGhaRmpkQlF5UHQ2eFNwSVRGNC9GYjQ1VW5LU3hwZHc4YnpS?=
 =?utf-8?B?UnZLYk4zUEdVQ0RMQzJsckFLTTY5c3NEUHZQMDN3Ym1BdmQwKy9vaERzYVlX?=
 =?utf-8?B?L1FsYkgzcVZoUHZ0QTdrZVJGckFvTnBQcm1vdy9CVzBiaUJranZtVWQ2WDBP?=
 =?utf-8?B?em1weFNuUDh4TmF0REFQNVZSQ2d3VllJZWFmNzUwOGhabUxjY0hLZGp3RGpO?=
 =?utf-8?B?azYxZ2JaSXdPMk9wQ3Y5NWhQaUkwWFl4MEMzbllRaFhiQTdqUnpyVVBvcWM5?=
 =?utf-8?B?R0tWajBTdkV0NkxrWlNLMUJISEVKZzRIQXg1Tmt4ZlVsYjZsMXozbkoxRkxL?=
 =?utf-8?B?anZlSjZKM1I3WkhFQnlKa1JseStwL0wvTUorYS94eGtocDZrcFRWVnE1dHRL?=
 =?utf-8?B?cUszWkdyWE1TWGhTOG5rd2daSnRabHBEQjBXclgyS0M3TytYSHFWZXBqTzFm?=
 =?utf-8?B?a3djZDJhQ2FjUC9mUUFOVHVZeVdEOG5rMGcxeVFFRDFpempIN2lqRWswSFhV?=
 =?utf-8?B?ZFJ5dDFDMm1RZldLSWcxaEQyLytvejg0djFzajJUc3E3WGltMDlpZi9sKzhn?=
 =?utf-8?B?UFRYV3ZUWUlEQ28yN0cwWERCVEVZM3VpNmQ3SzVzeFI3SnJ4OGp2MkVhV2No?=
 =?utf-8?B?YXdmM3R3SnIxeHZzS1M2TFJUL3I1bmFpYUltaExrcmU4RjI5LzQ3eGNDc1lw?=
 =?utf-8?B?dE16OXE2Rzk1M2t0U3JpaFFTMEdKU00yblRPUUxQbzJDR2ZZSU5oMmhNUmNm?=
 =?utf-8?B?NnhXT2ZmN0hBejdkMTFheGlUSEo1UUV5cVVxQmtkY3dldCsxZlphdkF6djFN?=
 =?utf-8?B?K0Z0NkxlcVRUTitRUDhvcGtONzhUb1RZVEtQek5DNEozZTh5QmFlSGhncWMy?=
 =?utf-8?B?bEJRa3FIUlF6L1A3SU0zV05uVEpMSHRjV25XQlFad3JYSWRjSXhDNG11MlV2?=
 =?utf-8?B?Qi96bTM0c0JJR3puZTNoNTFVeFpKaUd6ZmcxWWN5dncvY01QNzgrTHBtWXdN?=
 =?utf-8?B?RS9UQzhYYlAzU1ZQM3UzYjJTa3hHZUlGYlN6Z2d2dCs4R0VFdmJ3SlVDenJj?=
 =?utf-8?B?VW40d3pFRlVqb0Via004RERaNWVLVXVOSTU4VU96c2hRL2ZMMHc4ckZaZGFT?=
 =?utf-8?B?RjZSZ2NsRnVXNzlobnA1SzlGa0QvMW81Y1NYbXJrUlZZZlV0Y3BIblJYMjR1?=
 =?utf-8?B?ZTNvNGhneENVUS8xdFJRMkwvNEllazkvQ3U1d1hVZjd1M2EwTFVhdTI2VU13?=
 =?utf-8?B?K3N5cDBCeWRHbVNEQ2sxc2RXaXlqUWd4Um1xMmUrMGZaUWlmei9aVHRUVFM1?=
 =?utf-8?B?U2RZMGVZY3VSZ29ENXMzZmlRMU9ERDJrczdrZlVKZmdWamF6RVpxaEhmRjFD?=
 =?utf-8?B?aVF6dHROTFNzY0JVbmhINUthTG90bmloWFZWWU82M2lZS2RqSHBxQUtHQkpz?=
 =?utf-8?B?Q01jcnVrL3pUZUtOMFVaRWQ0NGhkbzdlSHYzSitDWlpjalN2R0l1RzJHbENO?=
 =?utf-8?B?OGMvK2NUWnVIeEptSzEzd2YxRkkwQkh5M2cvdnRLRGFLTk1oOTdCd2w2UVR4?=
 =?utf-8?B?OC9TNHloUFV1dmNJS2ZjdjJvS3d1NjFtc3F4NCsyUFRlM05RRU5YTVZ3dXA0?=
 =?utf-8?B?aWxpVE16RXkwY0drbDRVRCt3R1htanY2YTNHQ1Y3QlBreXFJTlhFME1nbm9P?=
 =?utf-8?B?KzhXTVZ5bWZSaHRsLzZQS1hpOUk3eUJwalJtWDljVGQxdDZJWHl0dE5iNjh0?=
 =?utf-8?B?N3MyeWlTR2U5WmpNaW1zaFM4YWRLSGpaY00xbzRwWFV0dGJySmQwdFJoS1hz?=
 =?utf-8?B?clZIcE5sRVJuZ2theWhBUU5zeEdyZ0lPbGljT3UrT2pSak1HUWQ0UTZWYVoy?=
 =?utf-8?B?Wmg2eHdHc1Z1MVVQSEJSemwveUFkWmFkdE5YTkYzTjJKazZjM01GTGU1L2Fu?=
 =?utf-8?B?bGJKanFrcXVqVDVpZXRvekl5aVE3am1Jb0FTaFQrREgwY3JBVHIwU2FuQlZz?=
 =?utf-8?Q?kdBEbwLS64VSY1+73JdjiIrn/051R4l2E69rc?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c84eb4f5-da5e-438a-2986-08df2a2b84d8
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 19:44:11.1843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrd1eI4oUoiQnMJlhlQZs6JpHlJUJqNkF4CzeQwVZm3vOngvG/6kGkm6j22WAQBIczALFzm+SMfESrNUsDpki9wFQL/RtuMNPtFbkO4bh1uifQCCQ1zEL2xivY1RkimP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8361

From: Frank Li <Frank.Li@nxp.com>

Replace direct dma_chan::device::dev access with the proper
dmaengine_get_dma_device() for consumer API.

chan->device->dev is not always the device used for DMA mapping. Some DMA
engines support per-channel IOMMU mappings, so different channels may use
different DMA devices.  dmaengine_get_dma_device() returns the correct
device for each channel.

Prepare for making the DMA engine provider data structures private. DMA
consumers should not access DMA engine internals directly.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_memcpy.c      | 5 +++--
 crypto/async_tx/async_pq.c          | 9 +++++----
 crypto/async_tx/async_raid6_recov.c | 4 ++--
 crypto/async_tx/async_xor.c         | 8 +++++---
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 538bb83df841c..49ee66759c7e9 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -44,6 +44,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 
 	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
 		unsigned long dma_prep_flags = 0;
+		struct device *dma_dev =  dmaengine_get_dma_device(chan);
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
@@ -51,10 +52,10 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 			dma_prep_flags |= DMA_PREP_FENCE;
 
 		unmap->to_cnt = 1;
-		unmap->addr[0] = dma_map_page(device->dev, src, src_offset, len,
+		unmap->addr[0] = dma_map_page(dma_dev, src, src_offset, len,
 					      DMA_TO_DEVICE);
 		unmap->from_cnt = 1;
-		unmap->addr[1] = dma_map_page(device->dev, dest, dest_offset, len,
+		unmap->addr[1] = dma_map_page(dma_dev, dest, dest_offset, len,
 					      DMA_FROM_DEVICE);
 		unmap->len = len;
 
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 37bc48bbda821..5f62f2edefe58 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -196,6 +196,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 	     dmaengine_maxpq(chan, DMA_PREP_CONTINUE) > 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
 		struct dma_async_tx_descriptor *tx;
+		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		enum dma_ctrl_flags dma_flags = 0;
 		unsigned char coefs[MAX_DISKS];
 		int i, j;
@@ -211,7 +212,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 		for (i = 0, j = 0; i < src_cnt; i++) {
 			if (blocks[i] == NULL)
 				continue;
-			unmap->addr[j] = dma_map_page(device->dev, blocks[i],
+			unmap->addr[j] = dma_map_page(dma_dev, blocks[i],
 						offsets[i], len, DMA_TO_DEVICE);
 			coefs[j] = raid6_gfexp[i];
 			unmap->to_cnt++;
@@ -224,7 +225,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 		 */
 		unmap->bidi_cnt++;
 		if (P(blocks, disks))
-			unmap->addr[j++] = dma_map_page(device->dev, P(blocks, disks),
+			unmap->addr[j++] = dma_map_page(dma_dev, P(blocks, disks),
 							P(offsets, disks),
 							len, DMA_BIDIRECTIONAL);
 		else {
@@ -234,7 +235,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 
 		unmap->bidi_cnt++;
 		if (Q(blocks, disks))
-			unmap->addr[j++] = dma_map_page(device->dev, Q(blocks, disks),
+			unmap->addr[j++] = dma_map_page(dma_dev, Q(blocks, disks),
 							Q(offsets, disks),
 							len, DMA_BIDIRECTIONAL);
 		else {
@@ -314,7 +315,7 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 
 	if (unmap && disks <= dmaengine_maxpq(chan, 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
-		struct device *dev = device->dev;
+		struct device *dev = dmaengine_get_dma_device(chan);
 		dma_addr_t pq[2];
 		int i, j = 0, src_cnt = 0;
 
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 306448c47aa00..4f223fa36c706 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -32,7 +32,7 @@ async_sum_product(struct page *dest, unsigned int d_off,
 		unmap = dmaengine_get_unmap_data(chan, 3, GFP_NOWAIT);
 
 	if (unmap) {
-		struct device *dev = dma->dev;
+		struct device *dev = dmaengine_get_dma_device(chan);
 		dma_addr_t pq[2];
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
@@ -101,7 +101,7 @@ async_mult(struct page *dest, unsigned int d_off, struct page *src,
 
 	if (unmap) {
 		dma_addr_t dma_dest[2];
-		struct device *dev = dma->dev;
+		struct device *dev = dmaengine_get_dma_device(chan);
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 40caee262a4ab..0fb29da2235cd 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -183,6 +183,7 @@ async_xor_offs(struct page *dest, unsigned int offset,
 
 	if (unmap && dma_xor_aligned_offsets(device, offset,
 				src_offs, src_cnt, len)) {
+		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		struct dma_async_tx_descriptor *tx;
 		int i, j;
 
@@ -194,13 +195,13 @@ async_xor_offs(struct page *dest, unsigned int offset,
 			if (!src_list[i])
 				continue;
 			unmap->to_cnt++;
-			unmap->addr[j++] = dma_map_page(device->dev, src_list[i],
+			unmap->addr[j++] = dma_map_page(dma_dev, src_list[i],
 					src_offs ? src_offs[i] : offset,
 					len, DMA_TO_DEVICE);
 		}
 
 		/* map it bidirectional as it may be re-used as a source */
-		unmap->addr[j] = dma_map_page(device->dev, dest, offset, len,
+		unmap->addr[j] = dma_map_page(dma_dev, dest, offset, len,
 					      DMA_BIDIRECTIONAL);
 		unmap->bidi_cnt = 1;
 
@@ -316,6 +317,7 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 	if (unmap && src_cnt <= device->max_xor &&
 	    dma_xor_aligned_offsets(device, offset, src_offs, src_cnt, len)) {
 		unsigned long dma_prep_flags = 0;
+		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
@@ -326,7 +328,7 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 			dma_prep_flags |= DMA_PREP_FENCE;
 
 		for (i = 0; i < src_cnt; i++) {
-			unmap->addr[i] = dma_map_page(device->dev, src_list[i],
+			unmap->addr[i] = dma_map_page(dma_dev, src_list[i],
 					src_offs ? src_offs[i] : offset,
 					len, DMA_TO_DEVICE);
 			unmap->to_cnt++;

-- 
2.43.0


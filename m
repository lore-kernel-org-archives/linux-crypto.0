Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010060.outbound.protection.outlook.com [52.101.84.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F29568FB8;
	Wed, 14 Oct 2026 19:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792007050; cv=fail; b=isb5eusmp5a9cyyij5zlXhlvltrXgs9I9kVQ+8bgqa7xrvNB3a5CR0Vip4H/tWsUqxkdcK3mbbkapMor4Mq1S2HU4PkXHR292n2SgPgY/PwFwofDQ37g/6QcV1MnUwc/RlO7S50sZQZxUAiyr0rNGuIYosUt00qs8gcmMCVZ3d8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792007050; c=relaxed/simple;
	bh=t/Kh7hX6HsRrFg6VdFKmiuI1UqrHa3o4a7iTV9JsIns=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=lJ8D5Qfd0DFw1KN+iRQuQJ+I8aumWNDs5aCZQ230ETSbe+Uf9cDs3vepBuv2J0yJpHv45axwV/6PAqUbx0IaiOo7MmyXmkG5P6tFiAKhAJp6kIoAOQkezWnh0JCTVMNSI/WZObhM4MlsFx3w29puECMA8+44o6odh1QP/wc8CN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=TsaH5Kd3; arc=fail smtp.client-ip=52.101.84.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="TsaH5Kd3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hya1MxK8l9d+Xih83/CIkftQ0SDbgXdWPS1mIUdYq92FY9fX0hwhCC70PeX5IluhxeeK0P8PTd9ZuprtUa+3PUMXvJMka5og9rPmohF0NgRpSZ7e3jexlMy/WkvEGazbhRIxpK6Gpvgh7hmmtChBP9JgLVAcu9ZKITLNH96kuzwQI3BgS1/mJ6AGGwHhkIrJl4nMLHLs44k1/fqcVejBKlcSfS0ixTDpGXpc1Ylha8OUKfPmr/knwnaWnuGv9pK8xJphKxtnS6ya4ZWkVuSlv9+LsQ/X2gQkJfBDUBrBpZJq8qPD5xf5XcAHOO7aLCriLXQWtxLSdspaS+JKtKXV8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+swIC9+PJkSAj+SCm5qi2BxsaQlqNd8yeFsC3hSRHM=;
 b=XiqgXSW53b0Tysp0WhkBPJHHtEZ5O+RgM+nGHrqIfYHdFaXergam+AXVjoxy8NIYwGrijd/j54zBLxr9Q1LsMA3LQg+xobsNFwbJg1scm3KppAuMpX/MANzARJfrekGb9UwpQxkZmhaGlt57/AhDlHbcrsIEkjPV/LuPTKBeG6nIIRhkbaYLaT69zj0Zw1JgE9a9yodWM6jJ2kRgB5XmkrNH97jZbhproVA936DQVncRs7E7D7sriV87UHmVIOjee8TQNcjOW7MWMNMGvCJlSP7rLHr8GFpFHTnushD8wRMoq5HdcU0pmvuUvi63ie83N47Gzvn3caLizts88tkkcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+swIC9+PJkSAj+SCm5qi2BxsaQlqNd8yeFsC3hSRHM=;
 b=TsaH5Kd3z6/k1rpaazOcITZrtUfQhS72OY/anENZUVTdShVCYoh8XNEtlUURDRLyZjJvOV/yO7MJyiVUfZRcrCRZqNRxdz81ydFlmHHTGAzg5aPtpoTMz0Q6GJibBxuTH3cDG/TiSnoYKNt26zwZZ2qfgGgHBWzU9DDiYfwsuzgpRbl8KIjK4Xqj3y8tRjKJ6SuXRbdaInSEdvnffJIrGaYbcpkjRmhz1cB9S4uWGBbgK73LqQq5Ovy08j/I2M/Evxrc3ftLXIgeSM3+IFHGfPerrO9/Lc3O3mb6tl1dNsTh91YcZsM984LWdCxjC6vH4xMs/8+0rbjXD8eHcOFO+g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB9PR04MB8361.eurprd04.prod.outlook.com (2603:10a6:10:24d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Wed, 14 Oct
 2026 19:44:05 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 19:44:05 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 14 Oct 2026 15:43:45 -0400
Subject: [PATCH 1/6] async_tx: replace direct ->device_prep*() calls with
 standard DMA engine API
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-async_tx_dma-v1-1-35790d01e190@nxp.com>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
In-Reply-To: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792007035; l=2415;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=O8WggK8Td/m/Sisr8HMJgTk4jYJexgnJq1Lem3+S1SU=;
 b=lOXugun1k99H1+imU3+7N2vnTA2rYOYEQqc3uQrAPFqXMh1eY+oZRCClwtnCjh6GCzxq7jSaz
 uUmSFRaPMy8BENdccOb3gZACRUeKH6VSZU4fnnUd62id8yXTMhLeGyj
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH8PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::24) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB9PR04MB8361:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b2e9f6c-0a8a-4509-b3aa-08df2a2b819e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|19092799006|56012099006|10067099003|11063799006|6133799003|22082099003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	H3kqRCHyBMLr67HR7PYj+YCEl+e9Eir/YkXF3/J7r/R594ufDG2vYGNO31nuXWqmBTIk80SJixMpFC7jEQby6/olY70SSCDTZZ0ftUIdkV0hPNt7MaiN2mcMDd3UUCeT7uGwtrAqKwUQgvx6gDjcBQnSxp2twlhP8gkJdbtGsLJaSpx6F15xSv05nQ8uwTZ+/6OoNaY3Iecv3qiJWsMJiRqsh0S9OYgjM8gNHF+LyAJOYf79o4/kjgq4CgVsdk3EKAyXAzMitb1tpqu0kXSOrlNfG3+IMpVbzYZDK+oMhPbBL5/+gvsdvOAHoCqwWqBqgRDYslrWEbS5H7AbNIAh4YczZzLsvH2FGsyiY1h/xZTGN2EzGzxEEJjDwWqPS/uzbZfRx2euDaMOKAN6VxsKJCB+tTxxTqNm8I1rCY0XedCUL6ic8uNaoAA0QxDnmRwue6XdDPozF/P1rsNZ7dRzGX5DEudozROpyFA4KyldoAqarRKoqzDxcn2XRebbeiena2FhMDpdoY5uZOSCbiQwwEnZK6wJdJmselNCP7msSr0cbcge/c/uFDDxSuPDtx8JRoR5N2a3mpouaWi81jykvyr/NtNaez8uZedSMgQxghvbnehTKPO4k19g3uJjs+g6V2HN17gJ7VWPd0aXPrxcO889/QA5mJhyoNKyp+gEAeE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(19092799006)(56012099006)(10067099003)(11063799006)(6133799003)(22082099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YnRxNlcyRVRVTzJvWVcxVko1RGluZFBuNXp0b3BYcit3b3c3Z3lzajFrKzVr?=
 =?utf-8?B?bjFOY0hpU2Y5VXYzVDJqU0p3RjFQczVaZW5uMHo2STdCTWtHUUU2SjlWSWU4?=
 =?utf-8?B?QTBYaGUvWXVkdGxGRXhaaFl0bm1aTWRBaXJFWUREbmR4ajMxNjc0WEtFRC9K?=
 =?utf-8?B?a1BBakI1cityUVJQaFk0REx6V25oN3dmM2NRU0lvN3diV2F6L0Q0V2puNDNt?=
 =?utf-8?B?TGw1aVV4RUR6T0ppSk9mRWZKeU1KeE12ZDlQcE85WU80THl4TXkxVFRtU29p?=
 =?utf-8?B?cWdwek1IemwveE91c2wwZUVZaTFocy83MkliQS9uczNtMFlmSVcweVRrR1Jp?=
 =?utf-8?B?TnQyencxWVkyWTlYVWFyN0J6Qzh6NjBScUJ4L28rRDZZYldJaEhXelcrd1NU?=
 =?utf-8?B?aUpvWWU5YUdrK285Q1V6dHlmKzJIb2ZwUkcwK2c2MDQ5TWh2YUdDRG9RRXoy?=
 =?utf-8?B?RTBoMExNQXdjVG9SRWFjSm9zL3JVdFZvWjlDM0F0cHFWbkVJdGp0c0xXeVpZ?=
 =?utf-8?B?SVUycHJpdVJzVXpoNGI1U1NhT3Z1NGF3Z2ZXc284eDE1TnNBcGVHeVRlN0pY?=
 =?utf-8?B?VWp0ZDlDRmtmYjYyTlhiMTMxdDNiRlMyWjdXLzd1aVZvOE5mUmpIQ092c0pC?=
 =?utf-8?B?N1hERDNjM1p0RXFSYm5wTnJacmEyZk1tRUc1OXdtMUY5NFEvRkNXRlkxdGRM?=
 =?utf-8?B?aDUwSGhtd3cxa29jVmxsUm5FdU1lL3RWYUZiNk4wMHM5YnlzbStuSys1L0E1?=
 =?utf-8?B?Q3RmTzJ0d3BiTHR4aXV2SS94bGFHZkFjbnVpNnpLSEtzQUg0Q1AwMTBvOWFh?=
 =?utf-8?B?djdrbGJOalAyeWJnUDlKNWlTc2JLbUs0VDYxUDh0cDArMTZUblovY2NwcGR6?=
 =?utf-8?B?ZnJsb2FybkJHcHM4QXRkQVJxYmJ4MEFGLzhOTEo5TERFUGI3akZqWUorZGl6?=
 =?utf-8?B?NHlzTCsrUGlzZnJWRjNiY1NDNWgzMWkwNVNPQmM0UHoxK0xNcWFmZlA0ZnRK?=
 =?utf-8?B?STBQVTVnMFFSejB2SzdsTU1xSHhZZWI2T0NYcTUvYys2RDhReDk0YWJodDhq?=
 =?utf-8?B?amU1QTkxK0phaGVML21JVWMyZGhBNyswSVpUK1hVcVlGMFgzNHFTNFVHQkl5?=
 =?utf-8?B?VXJxVUZ2U0plUmROTDh1L3ZKRzVpOGd4bCt4VHZRVStLM21HN3RqWGdlUmJ2?=
 =?utf-8?B?eFRxdTlPL1hqTzhsdUp0cG5pN2R5MzBaR3VPZnVCeGJLeWEreXhqWmlGK0VX?=
 =?utf-8?B?TW96emxUYURYbnlzQzMwNzV0aC8wblg4dTNSNkQxRlNWTHZsQ0VPZURQdVdh?=
 =?utf-8?B?SmlGTDlNa2hZbmtDbjExWjVET2ppTUhrSDdGV1cvN1NabTNFOUFKOG54bFZ1?=
 =?utf-8?B?VW1zKzhzQk9ncjA0RFNRZWkzZ0ZTMUtMVEpiZDRadHFuVTVzOEJWZmt2QURi?=
 =?utf-8?B?UzVQcWRZbzRUVk1xRmY5TEtOclRrNVVzdEx2VStWQWo0SkFGL2tBdzYrSXN5?=
 =?utf-8?B?QzYwQnhOei8zaWlFcHBSNjV5VllxNlBaSEZIbERKSVM4Y3pZUURCcHY4UGsr?=
 =?utf-8?B?b2MxOUZZUGZob0w0U3p0MTQxUVZmR3puVFo1a0ZtUUV0cE01Nlk5RHVWZFVq?=
 =?utf-8?B?R3loNFgxWXhtakdJVVhheGNMenZLZlpJYUpPVThGcnJzMXBtTHNlM002aEV1?=
 =?utf-8?B?SnBpa2NDSldHSmZrOTRTbm1lbmRoK2N1bStHalBjMitjdGdvaC9XWXN0cmFG?=
 =?utf-8?B?eTdTdmorQTFTRVpKK3B0OEo1eGk1Mlk0Q2dKc1RpQmZCTjlaOHRFVDBQaWJL?=
 =?utf-8?B?bGRWNWRjb2VlUFBRckV6SjdheC80WHg4Y283Qm4vWjJNbUpTQ2IwOEV1bU9S?=
 =?utf-8?B?aHBSRXBHdG9waDBXbG9VL1M0TmdFdDNtem5SaDMrb3hvYTQ0VEdRUnFjVE45?=
 =?utf-8?B?WXNSbnpjVEcyRExGWEhhN05IZlBnL2drQ1RpK1krSHZQRnN4eGRTSEtIMy9L?=
 =?utf-8?B?a1F5KzRwaElJYWl2MmRJeDNzeUVDSGE5M21EVVRuY2htYm10WGlCUnRXUzhP?=
 =?utf-8?B?aUdIdnhDcWZYY3dwYzZWTEFrZXBGNVJCbnBzMVVZcjN2SjFUUGtpbHR5RlR2?=
 =?utf-8?B?czBFVXp5MDFlTU1XVDRnTEtBU1Y5SlRJOXBWTEd5R1hvei9iVHF1MURVU1lB?=
 =?utf-8?B?UTdYSWhaeFJkMWp2L0VQczlmRWJhbVlocW5md0R2d0xmY3E3bU1QdnM4OU9z?=
 =?utf-8?B?NC9aZmh6Zk1wbzdrdFk1SDVCSldqOCtldUpmWElmUHlvaUErdmFnK0RVaU9h?=
 =?utf-8?B?ZGhzRGlnbUUrenp3a0xsYmRadThpdGd0bEltbURSNUVZZlFrZVduWWRLcDZY?=
 =?utf-8?Q?F4AIqNE2LlEet5lyTd4h/FVToqFRNgsg/xsYU?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b2e9f6c-0a8a-4509-b3aa-08df2a2b819e
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 19:44:05.7755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZTJl0qEwGNimbaesnb5+7XUmcuznvfYxcyLA0+F+GjJ2pIXapnwVjNQINDXWyNKGCUrTnC0SlDt2ItH0lqd2u908BggEUe2QMiIAz/sHItxHHaPznm91/z55vT7LYEU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8361

From: Frank Li <Frank.Li@nxp.com>

DMA engine consumers must not call the channel's device_prep_*() function
pointers directly. Use the standard dmaengine wrapper APIs instead.

Assisted-by: LLM
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_memcpy.c | 6 +++---
 crypto/async_tx/async_tx.c     | 4 ++--
 include/linux/async_tx.h       | 8 ++------
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 893e7e17f1f61..538bb83df841c 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -58,9 +58,9 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 					      DMA_FROM_DEVICE);
 		unmap->len = len;
 
-		tx = device->device_prep_dma_memcpy(chan, unmap->addr[1],
-						    unmap->addr[0], len,
-						    dma_prep_flags);
+		tx = dmaengine_prep_dma_memcpy(chan, unmap->addr[1],
+					       unmap->addr[0], len,
+					       dma_prep_flags);
 	}
 
 	if (tx) {
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index ad72057a5e0d7..01ef830675574 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -79,7 +79,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 
 	/* attached dependency, flush the parent channel */
 	if (!intr_tx) {
-		device->device_issue_pending(chan);
+		dma_async_issue_pending(chan);
 		return;
 	}
 
@@ -113,7 +113,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 			intr_tx->tx_submit(intr_tx);
 			async_tx_ack(intr_tx);
 		}
-		device->device_issue_pending(chan);
+		dma_async_issue_pending(chan);
 	} else {
 		if (dma_wait_for_async_tx(depend_tx) != DMA_COMPLETE)
 			panic("%s: DMA error waiting for depend_tx\n",
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 1ca9f9e05f4f1..9f7fef19f2142 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -87,12 +87,8 @@ struct async_submit_ctl {
  */
 static inline void async_tx_issue_pending(struct dma_async_tx_descriptor *tx)
 {
-	if (likely(tx)) {
-		struct dma_chan *chan = tx->chan;
-		struct dma_device *dma = chan->device;
-
-		dma->device_issue_pending(chan);
-	}
+	if (likely(tx))
+		dma_async_issue_pending(tx->chan);
 }
 #ifdef CONFIG_ARCH_HAS_ASYNC_TX_FIND_CHANNEL
 #include <asm/async_tx.h>

-- 
2.43.0


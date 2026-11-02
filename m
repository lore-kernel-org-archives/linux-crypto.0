Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.65.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793637972;
	b=q6+dbQtJvTKr7CLL6G9CI7P+e15/NN2RChigvY87CX0z60P+v4EMUvFYFDMYOJfNO0hN
	 MD8NZuBQfwod+NLqzU87gU3rk3fzond1XBKctEzbSxbGsm0cX2CXfxc4D5axI+VTKTJVg
	 X2WNL+WmeSwyj2tdFQzIhyzn75JBfHqzdHavW1wQD42Gyq/LetMKMix+SaGPZSLCJBeAd
	 ikxfHkPBBOhDHTS8mBM7PZ34wnYJmsBI3hHRnPH8G2h8l+i9pas1Bj64WoqJHlBx7t3vW
	 5H8mbOC+WOA9K+V0mCPYAcl8ozQv/xORCY7mYKFqUzSqxdO3PO90XRuNMX37QqIOSmQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637972;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=g0LvanIAcOvseeugAOnmxma4SKw9Qmkgb1g8F6kaSt0=;
	b=gJ3qugx0ptpdpT0m4o3WlnyHCFddFezl9ioQfqkrmc8zjNvGByZrOBgoaj4BUEJ4Uqla
	 Bd2DmLv3fApuPO+/2Nq5+KSibwrHUNUIVV75SwFoMudEHxrodIr+kdBqXjMyMD4HZZyLc
	 O1AzTNYb31vHG5BVUB/f3v0bdF/rQqstvhCkz4CyuvinF8igUwqSeg5l1/cT3SrvkP7lv
	 EF07bXoqxm00ft/pYiUsuCehyRqfQrMmChmXkWqS6xwgEB3yJFKDhceJ4KEC/jI2GIkB5
	 oAGGTsbNRbI+3p6FXyHm31Cx3losBQ6G5MM7BUOaPhrJ1eJYMXpC6Fwvy+1Rjsti0/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=XRuvwZDY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.65.40
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011040.outbound.protection.outlook.com [52.101.65.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C038606B0E7;
	Mon,  2 Nov 2026 16:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C038606B0E7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=XRuvwZDY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IO6qQoCX3gz2qvkJOp2kQqVD1xmtMdJDbtJ9BxMCaCS35zRXafcC3IZweD1bIsGnWr83+zJjNHzdyessJCjqK7l8J3PhKsU2mWUsAwPVevF3cQ9pOJHpJ2CQwOF1QS4NuCdAwAEbcjEF/BUu61HIUSC6M0/L6dSnTMOcuKQySLm6YGd5yvr5+kRg312mgP4Iy31xPpaznbfhkZSDBhh7L2iK/NsrO4OSe59Svg1FyZLkUqBJSRxU93rq9YroezcwGATxxTvCZIOt94XsVuNQRm299+A2m5XK29CcME4c5gPd6B5apIlgN45sXe7EMpfWv8QZuwluijv+nYHkyoApFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0LvanIAcOvseeugAOnmxma4SKw9Qmkgb1g8F6kaSt0=;
 b=tTEmAuOnAcUfzMzjwxGJIJ6PwBKXIPwK9u+5JvBI9FV5uTVUboOh51fQgdKZQOd63dJ8dW9nWyYn3hk5yrh9OaasAYle+GVgzxR6BurPoDgmYsh8b4zqKDfcfRDsGLJHnpCfECw62nUAiSExmMrTTmmMc77J3qo+6ojTuz+Y7YnQ787C9t8Y6XuuX9gZYLz+QzLKkkD0oF9t60nLhdyRLsskp6Go2VbjtT9mpzjaZZ1YKEFiE0cNE4VJ+gupkmLzMSbaMvv6nXlxHGvz7rUpep63cg9Bsibt7QDf7GwLI6r6/7nI9QIXYpXYoFhui8swFtDeUTMqOCtEyrhJ/6SfnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0LvanIAcOvseeugAOnmxma4SKw9Qmkgb1g8F6kaSt0=;
 b=XRuvwZDY5rYvb3M5bbkIEwl/Y/Eh4PwZZTzlE1WQfB+NdTF21gGG7OyIrNdlAXB3drztBkkL/W1RNhzQSXaQTu7xM1m2hJBgUUN5965SgnyCA9pYeOfl7+apBqrsifCNvRDt0Pzqx6dh4b358dvf68vLxOIiqdgCYQJPwg/4H8Mr5jprolZ/YtcKWq7PV8TJNr019qORdd4aI91jAag5Jt8KWghHE35/wW62UzVe5DrvZxFb6g47yOLGifOwwXwSom+wLLiPEGH5esMlNvmOwqNqoJftV0xwSSb54OxXbiSq225KwSpm/xrGN7z90A+a/Iycd8VdgXXiLfQySeECyQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by PAXPR04MB8685.eurprd04.prod.outlook.com (2603:10a6:102:21c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 16:46:08 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 16:46:08 +0000
From: Frank.Li@oss.nxp.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	T Pratham <t-pratham@ti.com>,
	Thorsten Blum <blum@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Pan Chuang <panchuang@vivo.com>,
	=?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Microchip (AT91) SoC support),
	linux-kernel@vger.kernel.org (open list),
	linux-arm-msm@vger.kernel.org (open list:QUALCOMM CRYPTO DRIVERS),
	linux-stm32@st-md-mailman.stormreply.com (moderated list:ARM/STM32 ARCHITECTURE)
Cc: imx@lists.linux.dev,
	vkoul@kernel.org
Subject: [PATCH 1/1] crypto: use dmaengine_desc_set_callback()
Date: Mon,  2 Nov 2026 11:45:30 -0500
Message-ID: <20261102164538.3834039-1-Frank.Li@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0022.namprd07.prod.outlook.com
 (2603:10b6:510:5::27) To MI3PR04MB12438.eurprd04.prod.outlook.com
 (2603:10a6:290:76::14)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MI3PR04MB12438:EE_|PAXPR04MB8685:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b3b117c-010e-424b-efbb-08df3900cb49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|19092799006|366016|1800799024|23010399003|10067099003|18002099003|261102123227099003|921020|56012099006|11063799006|261021121427099003|261026121527099003|261009223027099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	lmP9RZmAa1cCPA/TbqEABOlksxtmUhFo/iV22Q4qOe75qFx+Rw8WiVrGVtN83ZjWvlxVIfpngkdI38ezLFIyWdK8iIg4EkvsQFEr++CrC7B2yXexxe9KUweODqHYYwpL941vsu0GSV3Wk3HNIGVqQhJIAZii/2kBVVtx37U/6SqrEVoM/91LqxTPJnfVwxxIstTiiGZl2U7iM44a0/KxiIcdbK3RX+wckAL4N+HuNk7vSh/kA1T+SgE4oEzltLOD3f10xbyBGSFtM7Na5B0HXtrfOMPqQRT1Qz/B//D+DqbBz5tOrsXrEzpc8BhLrkoypYTguP5RJSHAG3w2M0t3fA2twAsR8NZqOIU+QtVCa32zXhbE4vcm0cUH1vMSWoVHmLo0pT4JIYLUwSLRe+zG2US34GZta+0AUi8FJ0B0kh1ryxDE47Q6YHNelb5tgPDTy0WA5Wua+M9UV58i1xhgmhUtuC3HMxTi5tTxQYu9Loust+6G6IES1F61asic5jIZT3MZR76r2eyBPCo+ZIjIF/ayAPaF6dON/2Wu+Y2vzTYfB/iV5plUcs4i5aJi91uJWv+ujryxjQ7IH71hxvesx4FNCU/n4EP5VX+JL8qog0L6LXE98/6LjB+6M+//KI7kRVTJEKyC5IwJsN/y/XFxLEkCbQgR+PK+8X+KHw+9Se01AtGMNqU2QH7LHCTp09KEgUaVO9F46B9T9GkYzSbE1Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(19092799006)(366016)(1800799024)(23010399003)(10067099003)(18002099003)(261102123227099003)(921020)(56012099006)(11063799006)(261021121427099003)(261026121527099003)(261009223027099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?az2k4rleFpNK5ncmeRD9L4zS3ipbyq6B1/10mbCuEeAr6naGsraKxVe5bUC9?=
 =?us-ascii?Q?IGIXg+MOzmwdfWxx9ZZsLxQK6f61ofSjxKHNjEQz7UZ6DG02WK+2E9Fyh7wl?=
 =?us-ascii?Q?JXmRMqoF9Oy/h47R7vUXFtispQYqwGvmgjcGkmGjJ/ilU6H7GsgRYlGyZh9p?=
 =?us-ascii?Q?crwm3rEjF3IwKDf6HVqCMfCylvVO5+Msnmv6zz2WPELDfGOooetOTQDzUQC/?=
 =?us-ascii?Q?Pg23/Pm4SOHkx+9jIreYVIB+OD7Tkgd1ImcB9LoZa4Y9pOf46k6QPZxw2j4U?=
 =?us-ascii?Q?ODfWkVqDhSkLNug5kOuj3cZWTox2epcZYCwRQ5jrPXZOn1r5wPz6ccyxHF8m?=
 =?us-ascii?Q?z831PTZc9Mkoy9LkhDwIAPYLCCaep4iTOegZ4nuczwGz1yGRuRzToA+IFddx?=
 =?us-ascii?Q?v0JBsYQ7m6ioS89PaHJ6fHcvCS90Ts4sfjeO43nMDiyVmrjG4dR/mqWyG6TE?=
 =?us-ascii?Q?b9rUvgGtgA1mgLx/VsgE6g2+rp519EWWQiGat+ZQ+Rz1uU7aMoitxGr2nSXS?=
 =?us-ascii?Q?JQOyrmVasuHIYs5IiNuXRMCWf+cze4bUe9PdMNYIGyLE5flxVo5zVTJ7akSr?=
 =?us-ascii?Q?Af7vHjHGJuqoua5605jHElwbR21iW4LjXJBjRIpOO0qVojvMmWdcpmCxIXLO?=
 =?us-ascii?Q?akXPrPRtMjeZ8rnJlSX1NCzEXkJzGmgIH/i8CAc38iafvUicgOy2DwtJmYnh?=
 =?us-ascii?Q?2kddXst3sG9Ao7Zw4Q1FRNT7eEiPxIqtfHNi2a2ugRD8y+v1WubZwp391xDU?=
 =?us-ascii?Q?KXLLuHMVI+ci/G3dyCaMms/isthVL4vzAsf6yRt80zFfPbYnM2KfZ4uvsXER?=
 =?us-ascii?Q?078BqX/y4IbjnieWcgK/acCFDGPyRYDda6hycic7uhB8M5B6MdxxEAcmdg9g?=
 =?us-ascii?Q?uVWWQyNAWbtIX3c7SfsmenTClo3EaKRTYhqDWwhxfsp94CxUKbwwVcV7Oc1J?=
 =?us-ascii?Q?++3bV0ltChBpf/CM0FtMqzMt6UYlm9ebgSv4LNtC1UMxMg4GCmbWb6y5kYw9?=
 =?us-ascii?Q?6VTsmXuRpQ6TiAQRfGl16ZgJojNnKYL/RatAGVyrqGpgvHxkySclV0o1cEtU?=
 =?us-ascii?Q?81d1gmAejmpXktdqjHr+8TcwX8M9qUKleEwssi0baujg11tQnJ+EpIva3CmC?=
 =?us-ascii?Q?ZlDJP7QHmArfQi1ivLuEG0r84x6pVN7dwl3xIvcWnx16b4E202SdsGrXscXB?=
 =?us-ascii?Q?WhlN8oAXPzoGCzzkQ39z99vSok5usJe09eKUnc41wSI8+XxxlgaiWcTGDkxU?=
 =?us-ascii?Q?3gxOQnDeEbSNV/mxVhnS7lRUBdpZj16KjvzRgGjeQkEZKtwzuU9VD1cNbbp1?=
 =?us-ascii?Q?OCuZN2/qUR/NIOXmT+lWcM84uAXDC1YlVjrZMnfS/0K5SFaciUpZrHWIOcDs?=
 =?us-ascii?Q?ZdeieYIEwbBTX+ukVimsEYm6imAaS0Fnzkibu7rCwYIrlfKWhe8PWyE4vUtC?=
 =?us-ascii?Q?vmVx0Dg53WMXORW5rdb06Jn7g+5NLLImaS0uILlAydXhq9FLyHKRaYQ5qJwH?=
 =?us-ascii?Q?vHLr7hSVCc6pmj8B4Z7dFUdjouwO41/OfebTKsP4y2RREE9AVGqkZibzkE2v?=
 =?us-ascii?Q?6sj32g4tv4YRXk/+s6i2qcsbpcGboeXDfxLGUs8evI1CBrssBwEna91nVp0z?=
 =?us-ascii?Q?zaZmeTAIWrTNFw9oFwXGXk5pZL4+GZO52I5UmcQc6gmXtPEWVK0RCTGBKp8B?=
 =?us-ascii?Q?8CNk6cT5BaA49qs4CnELB9gOyyFTOWhpHo0NI+YSBPqGYXZr022+55U4r6Av?=
 =?us-ascii?Q?xYBEvEajfRu6mET7uxgbykAyyfBCo/qIa7uQ/2wusjRE2aobHiFH?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b3b117c-010e-424b-efbb-08df3900cb49
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 16:46:08.4000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ceM7NvDDD9QsHP9HV/2mtnA5sIcOx8XMiWyueuOjCNqS7I4JZ2I5dDgAScmo+NGNPu4/cL2+EvuGm0kUT4Nj5dHGdCCm0Poh8l9Ff/yQwybAJ1koT+2aMyytu8ecJ0P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8685

From: Frank Li <Frank.Li@nxp.com>

Replace open-coded assignments to callback and callback_param fields
of struct dma_async_tx_descriptor with calls to the
dmaengine_desc_set_callback() helper across various crypto drivers.

No functional change intended. Prepare make to struct
dma_async_tx_descriptor private to the DMA engine.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/crypto/atmel-aes.c            | 3 +--
 drivers/crypto/atmel-sha.c            | 6 ++----
 drivers/crypto/atmel-tdes.c           | 3 +--
 drivers/crypto/img-hash.c             | 3 +--
 drivers/crypto/omap-aes.c             | 8 +++-----
 drivers/crypto/omap-des.c             | 5 ++---
 drivers/crypto/omap-sham.c            | 3 +--
 drivers/crypto/qce/dma.c              | 3 +--
 drivers/crypto/sa2ul.c                | 3 +--
 drivers/crypto/starfive/jh7110-aes.c  | 3 +--
 drivers/crypto/starfive/jh7110-hash.c | 3 +--
 drivers/crypto/stm32/stm32-cryp.c     | 9 +++------
 drivers/crypto/stm32/stm32-hash.c     | 3 +--
 drivers/crypto/ti/dthev2-aes.c        | 9 +++------
 14 files changed, 22 insertions(+), 42 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 84392411b98d8..49f1bf19747d8 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -824,8 +824,7 @@ static int atmel_aes_dma_transfer_start(struct atmel_aes_dev *dd,
 	if (!desc)
 		return -ENOMEM;
 
-	desc->callback = callback;
-	desc->callback_param = dd;
+	dmaengine_desc_set_callback(desc, callback, NULL, dd);
 	dmaengine_submit(desc);
 	dma_async_issue_pending(dma->chan);
 
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 4b883a8dcf301..3e4557a9fc8f7 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -662,8 +662,7 @@ static int atmel_sha_xmit_dma(struct atmel_sha_dev *dd, dma_addr_t dma_addr1,
 	if (!in_desc)
 		return atmel_sha_complete(dd, -EINVAL);
 
-	in_desc->callback = atmel_sha_dma_callback;
-	in_desc->callback_param = dd;
+	dmaengine_desc_set_callback(in_desc, atmel_sha_dma_callback, NULL, dd);
 
 	atmel_sha_write_ctrl(dd, 1);
 
@@ -1472,8 +1471,7 @@ static int atmel_sha_dma_start(struct atmel_sha_dev *dd,
 		goto unmap_sg;
 	}
 
-	desc->callback = atmel_sha_dma_callback2;
-	desc->callback_param = dd;
+	dmaengine_desc_set_callback(desc, atmel_sha_dma_callback2, NULL, dd);
 	cookie = dmaengine_submit(desc);
 	err = dma_submit_error(cookie);
 	if (err)
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 6b561b333ac6a..8d2f41abb238a 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -401,8 +401,7 @@ static int atmel_tdes_crypt_dma(struct atmel_tdes_dev *dd,
 	if (!out_desc)
 		return -EINVAL;
 
-	out_desc->callback = atmel_tdes_dma_callback;
-	out_desc->callback_param = dd;
+	dmaengine_desc_set_callback(out_desc, atmel_tdes_dma_callback, NULL, dd);
 
 	dmaengine_submit(out_desc);
 	dma_async_issue_pending(dd->dma_lch_out.chan);
diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 1ccfc0eccc737..fef0d09066add 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -242,8 +242,7 @@ static int img_hash_xmit_dma(struct img_hash_dev *hdev, struct scatterlist *sg)
 		dma_unmap_sg(hdev->dev, sg, 1, DMA_TO_DEVICE);
 		return -EINVAL;
 	}
-	desc->callback = img_hash_dma_callback;
-	desc->callback_param = hdev;
+	dmaengine_desc_set_callback(desc, img_hash_dma_callback, NULL, hdev);
 	dmaengine_submit(desc);
 	dma_async_issue_pending(hdev->dma_lch);
 
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index d40074e5a1427..c34ae8945eca4 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -310,8 +310,7 @@ static int omap_aes_crypt_dma(struct omap_aes_dev *dd,
 	}
 
 	/* No callback necessary */
-	tx_in->callback_param = dd;
-	tx_in->callback = NULL;
+	dmaengine_desc_set_callback(tx_in, NULL, NULL, dd);
 
 	/* OUT */
 	if (out_sg_len) {
@@ -337,10 +336,9 @@ static int omap_aes_crypt_dma(struct omap_aes_dev *dd,
 	}
 
 	if (dd->flags & FLAGS_GCM)
-		cb_desc->callback = omap_aes_gcm_dma_out_callback;
+		dmaengine_desc_set_callback(cb_desc, omap_aes_gcm_dma_out_callback, NULL, dd);
 	else
-		cb_desc->callback = omap_aes_dma_out_callback;
-	cb_desc->callback_param = dd;
+		dmaengine_desc_set_callback(cb_desc, omap_aes_dma_out_callback, NULL, dd);
 
 
 	dmaengine_submit(tx_in);
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 4b5a8d13f505e..d366689835175 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -414,7 +414,7 @@ static int omap_des_crypt_dma(struct crypto_tfm *tfm,
 	}
 
 	/* No callback necessary */
-	tx_in->callback_param = dd;
+	dmaengine_desc_set_callback(tx_in, NULL, NULL, dd);
 
 	/* OUT */
 	ret = dmaengine_slave_config(dd->dma_lch_out, &cfg);
@@ -432,8 +432,7 @@ static int omap_des_crypt_dma(struct crypto_tfm *tfm,
 		return -EINVAL;
 	}
 
-	tx_out->callback = omap_des_dma_out_callback;
-	tx_out->callback_param = dd;
+	dmaengine_desc_set_callback(tx_out, omap_des_dma_out_callback, NULL, dd);
 
 	dmaengine_submit(tx_in);
 	dmaengine_submit(tx_out);
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 5e739415a0102..ef9fd1fcef228 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -600,8 +600,7 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, size_t length,
 		return -EINVAL;
 	}
 
-	tx->callback = omap_sham_dma_callback;
-	tx->callback_param = dd;
+	dmaengine_desc_set_callback(tx, omap_sham_dma_callback, NULL, dd);
 
 	dd->pdata->write_ctrl(dd, length, final, 1);
 
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 68cafd4741ad3..620cb1bcf61a9 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -95,8 +95,7 @@ static int qce_dma_prep_sg(struct dma_chan *chan, struct scatterlist *sg,
 	if (!desc)
 		return -EINVAL;
 
-	desc->callback = cb;
-	desc->callback_param = cb_param;
+	dmaengine_desc_set_callback(desc, cb, NULL, cb_param);
 	cookie = dmaengine_submit(desc);
 
 	return dma_submit_error(cookie);
diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 4557eae941648..b0bb474239bbd 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1200,8 +1200,7 @@ static int sa_run(struct sa_req *req)
 	rxd->enc = req->enc;
 	rxd->iv_idx = req->ctx->iv_idx;
 	rxd->enc_iv_size = sa_ctx->cmdl_upd_info.enc_iv.size;
-	rxd->tx_in->callback = req->callback;
-	rxd->tx_in->callback_param = rxd;
+	dmaengine_desc_set_callback(rxd->tx_in, req->callback, NULL, rxd);
 
 	tx_out = dmaengine_prep_slave_sg(pdata->dma_tx, src,
 					 src_nents, DMA_MEM_TO_DEV,
diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
index f59adb2a56510..1746caf8caed4 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -464,8 +464,7 @@ static int starfive_aes_dma_xfer(struct starfive_cryp_dev *cryp,
 		goto dma_err;
 	}
 
-	out_desc->callback = starfive_aes_dma_done;
-	out_desc->callback_param = cryp;
+	dmaengine_desc_set_callback(out_desc, starfive_aes_dma_done, NULL, cryp);
 
 	reinit_completion(&cryp->dma_done);
 	dmaengine_submit(out_desc);
diff --git a/drivers/crypto/starfive/jh7110-hash.c b/drivers/crypto/starfive/jh7110-hash.c
index 008a47baa1657..d49fb9ac7dd8e 100644
--- a/drivers/crypto/starfive/jh7110-hash.c
+++ b/drivers/crypto/starfive/jh7110-hash.c
@@ -144,8 +144,7 @@ static int starfive_hash_dma_xfer(struct starfive_cryp_dev *cryp,
 	}
 
 	reinit_completion(&cryp->dma_done);
-	in_desc->callback = starfive_hash_dma_callback;
-	in_desc->callback_param = cryp;
+	dmaengine_desc_set_callback(in_desc, starfive_hash_dma_callback, NULL, cryp);
 
 	dmaengine_submit(in_desc);
 	dma_async_issue_pending(cryp->tx);
diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 3fc2db290b0f4..d03d674e019cd 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -982,8 +982,7 @@ static int stm32_cryp_header_dma_start(struct stm32_cryp *cryp)
 		return -EINVAL;
 	}
 
-	tx_in->callback_param = cryp;
-	tx_in->callback = stm32_cryp_header_dma_callback;
+	dmaengine_desc_set_callback(tx_in, stm32_cryp_header_dma_callback, NULL, cryp);
 
 	/* Advance scatterwalk to not DMA'ed data */
 	align_size = ALIGN_DOWN(cryp->header_in, cryp->hw_blocksize);
@@ -1034,8 +1033,7 @@ static int stm32_cryp_dma_start(struct stm32_cryp *cryp)
 	}
 
 	/* No callback necessary */
-	tx_in->callback_param = cryp;
-	tx_in->callback = NULL;
+	dmaengine_desc_set_callback(tx_in, NULL, NULL, cryp);
 
 	tx_out = dmaengine_prep_slave_sg(cryp->dma_lch_out, cryp->out_sg, cryp->out_sg_len,
 					 DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
@@ -1045,8 +1043,7 @@ static int stm32_cryp_dma_start(struct stm32_cryp *cryp)
 	}
 
 	reinit_completion(&cryp->dma_completion);
-	tx_out->callback = stm32_cryp_dma_callback;
-	tx_out->callback_param = cryp;
+	dmaengine_desc_set_callback(tx_out, stm32_cryp_dma_callback, NULL, cryp);
 
 	/* Advance scatterwalk to not DMA'ed data */
 	align_size = ALIGN_DOWN(cryp->payload_in, cryp->hw_blocksize);
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index e6a1e9b9f88d5..cf790b8992f75 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -539,8 +539,7 @@ static int stm32_hash_xmit_dma(struct stm32_hash_dev *hdev,
 	}
 
 	reinit_completion(&hdev->dma_completion);
-	in_desc->callback = stm32_hash_dma_callback;
-	in_desc->callback_param = hdev;
+	dmaengine_desc_set_callback(in_desc, stm32_hash_dma_callback, NULL, hdev);
 
 	hdev->flags |= HASH_FLAGS_DMA_ACTIVE;
 
diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index a3c069ca2baf2..2474bebcf2b4f 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -448,8 +448,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 		goto aes_prep_err;
 	}
 
-	desc_in->callback = dthe_aes_dma_in_callback;
-	desc_in->callback_param = req;
+	dmaengine_desc_set_callback(desc_in, dthe_aes_dma_in_callback, NULL, req);
 
 	init_completion(&rctx->aes_compl);
 
@@ -1013,12 +1012,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 			goto aead_dma_prep_dst_err;
 		}
 
-		desc_in->callback = dthe_aead_dma_in_callback;
-		desc_in->callback_param = req;
+		dmaengine_desc_set_callback(desc_in, dthe_aead_dma_in_callback, NULL, req);
 	} else if (assoclen != 0) {
 		/* AAD-only operation */
-		desc_aad_out->callback = dthe_aead_dma_in_callback;
-		desc_aad_out->callback_param = req;
+		dmaengine_desc_set_callback(desc_aad_out, dthe_aead_dma_in_callback, NULL, req);
 	}
 
 	init_completion(&rctx->aes_compl);
-- 
2.43.0


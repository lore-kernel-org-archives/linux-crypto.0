Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2103.outbound.protection.partner.outlook.cn [139.219.17.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B46035F180;
	Mon, 18 May 2026 06:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779087192; cv=fail; b=stL5miz1iEDlIVvLOC7X2nIAFpHPfzOq2evaPSC22x9JYFO0H58/xmAhpYmEYkechA2S6ZJ5u/nc30ec+cYA1D9yByUXKRKyHUcbKnu1+5hEKVaHdzzu2Dp1pCKS2BvY+5Cb5kj2Xbnls2oxjewFyOtjhnvUbMn/VVD84d8pSCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779087192; c=relaxed/simple;
	bh=UlkaM82UI6GeLkKYqSNL06yyuxU4kB3/nf0HHmxfef8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MWNsIs09Tf1BMHOg+6CSXWEcLSHBWQcsIXDAfTok9iVASvRmjc1R72ViFDTKHE15vpNgWTEpu9KW/2ySZCN/h3CPX8H+U/uHxhOH2FtUjGqdU6TySgdxABtlfFTON86SOTYe3mW3v+spEF+wsgi7b4DK2UKtNagpHMVNsLR69/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKtTg+ttzaKPu8gH13oRkCTXOzGi/VNV+1wZVz6Zj2X+/yOLCKHpkxIlFcgM7JtB057ZLa98iVlO5stD9RAZFfCjCb0efvQ4+AY2KOTuEdSWm1HLQ5WE3oXyFZbUGAqQCn2G9OP6dmsF5eSZ6oFLxfgiWr1nsnQeEoWiH2ZEOfXZjEFBASjPYpJ/RF4sY1HK37RvUvi6pUSdSdkovqM1VqnZfsmV/MiJ9UWF+H3LgXjnKTioOPehZkD8hgZv2LdbUr0Pb2LfU7acEXFxHRxXCOYAiYZpp2C7SjZjrj/7JWx1tH3iQzsoI5vhV9SgxXAi2dquosqT/96kdRaQ392nTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFle16gLaf0RRQIwvXtdFnYl5FieT89s80lSW86PT5E=;
 b=iOoTfOme1Q103TmjPil8C39pZf8uXnIJ3waAy1//uzxOov0xeC3QgnFvHURDA989P6+1noV/rq1FihSI5oBp3C9kcRee60VyBCI8AFj7fNAkSRM0RkDhXDNuNg3Lyw+9o9WBHQ3CEaHxG+NV+i8U08ooHt/9rXBHY5l5Al9XRDfDURS7Gw3Z7GtWDcajJaf7m+6hmp199v29N5c4ju/pdg/Fo2YPUhDzNqUrEqnEuCoLxDjUyqfJFLqNOD5Q6/eF75+yMLnuvjoiiTph5QfmGwIDVOk2Iu2sOlPFilhAlsfhNeoRkuezt9ntLg1OQJdk5wyX3txJ0fSeodrVmxaJCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1015.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.16; Mon, 18 May
 2026 06:52:51 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.20.9913.017; Mon, 18 May 2026
 06:52:51 +0000
From: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
Subject: [PATCH v2 1/2] dt-bindings: Add bindings for StarFive JHB100 SoC trng controller
Date: Mon, 18 May 2026 14:52:42 +0800
Message-Id: <20260518065243.20865-2-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518065243.20865-1-lianfeng.ouyang@starfivetech.com>
References: <20260518065243.20865-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0036.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:c::13) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1015:EE_
X-MS-Office365-Filtering-Correlation-Id: ca6fc0a4-7774-46ef-2fb1-08deb4aa1455
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014|56012099003|18002099003|22082099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	D7fSOJcoRNy21faz10c1cN+f/rV4mWLjZGh2Etxlg+6j6RWgueH6erKDNUUskNX10cnLfak9EcPCCxILkyVPrZxvoQCoXq8hV5XKv5D2+dfN9xk2NWqrVk382XNLNgn/RW73zhsMd6yJ/n1ipQZTngcOBjB7yNkgQylqWJ8T+Kkn4BRyKYjcsCya92L0YOuXs1TkC/9DClkzpmToam7aJINtjkPu23T+BCu+jjKWE28dfu9fPmK8Qhzb8w5yXPJ4Qa82W0b/OL1Hep5AIIqyoAEqVsD96CSadAixPAQsgTHxlP/vQYfPbUTUgpBzkjqpydkr+M96fPObyZFNunPcAXjnhW1OcOBacc3n7wQBpo8RVudKkRP3SsxGndl+FdoCJ00Q9BztUNs1lMjUDMVDMvEBmy4aEyJR6cpearyTmhm3IKC3lE8RvQeo0BH/uE0E31a+njelZcFKcvG98BHLd1be5Y/w/+lO7NHGyUxZi9vGsgMgUBSQXZc6xmwiBa3E6nPlaZE6qvXWxCg6e1oxRjfQ9WY8kIR7vi/GvH3Jp5k0dXC6zNucHIZ3ZCW/hTNv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014)(56012099003)(18002099003)(22082099003)(3023799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lNd/gQzcOb2jsKcvurbDbCZpDsgX9Ku5PdmM8n/R5ubmBKs8LoG25+Cannte?=
 =?us-ascii?Q?1N1IuKbMa/5UVLGUjWuABsQNjYOzIz4HMOp8zJKpQhZRZWea24V+yIau7B3A?=
 =?us-ascii?Q?f19rdScXb2xYQw3ONAWQ33tp5OGkcYn3WEdaBndOQKwBDCYhvEBhAft4f60G?=
 =?us-ascii?Q?Y72v6zTTLetN9s11RPTilNyC4AD0M8D4gU2G1v/uW1rj5Owk2RAvWZemHbrD?=
 =?us-ascii?Q?PDwK5RT3bPVV/bJbE+4zBSlItqApLWdAHRb5jHrwthUgj+w9GpX4oTpCydBh?=
 =?us-ascii?Q?ENSMiwPGN0EQejZtiDr9oobLnI9z6FkI00o6zd1j6iOFRN/8Z67I8Fxo/xpy?=
 =?us-ascii?Q?tvk6hJBlxIZIfdtZ3CHeshTTvAGlYS8PM3H8W6GYB0KtRDuwyK31LpB8sKrJ?=
 =?us-ascii?Q?7FQvxyTIHN/MXl0pWmv/+1LrVWOEoyK83+zreon9ivjL8EOyLLaCx2IBQkKZ?=
 =?us-ascii?Q?oms0NqKngBqX+OABdPQdBcrQXy/7zwoPcrePbE/buGOGtq5SC2jBu1cNpBha?=
 =?us-ascii?Q?ntzW7q5Hec1JFYzFAUITuv9fNltPzZcuVkapux7e1Q5qSge87D6V5ubSkrO8?=
 =?us-ascii?Q?a5m1qUWbvfJxmTFV2/Cxm2xM4OmhAIvfEiTcCmvUVWIV4FHjsBcKrCd0oU3b?=
 =?us-ascii?Q?0jB1pZnif0zkX1wa7PHMdixImmFH1hMPkB4scGUUf5MVfPZn13XEyiB4D2Up?=
 =?us-ascii?Q?1xIlF7Vzt73ZIlSn3nBN0U9FIfErxYOCRaOuxACY1emdW3kNCY2dH+HWw3md?=
 =?us-ascii?Q?HwC5K6bibTmHSxa5xkOOi56U/4e6ra0sG9SD1cUgGlimkaxmreTp9HGYvqtj?=
 =?us-ascii?Q?+q4GwuuDI/+JiTfdixec+EJp9IPUKsTyc8/BzNIWWh2FuZyPWJi2iW8b003r?=
 =?us-ascii?Q?Ngp8RWMOS55Wt/4iVKIZnZ28MNujqm7XHF/w84LjhwTSV2X5qkdVgY0jE6jR?=
 =?us-ascii?Q?Ol9CTypHMdN83jtJmloKjqY74bdR/p5So2ICfCLUkbbHRMFVOERu4Wp05Cun?=
 =?us-ascii?Q?5YQnEazr8Mt8j5sooNAjkB4/hpRShX1E1wA9pQoULbShPM9irN9imsIUOMl8?=
 =?us-ascii?Q?HHJCKvdnilziWfd5QwFLbyY3cb50+GofnZXdJ6bd47nZ8UMYekgHrMBrzqs4?=
 =?us-ascii?Q?x4X7yh5+U8bXYx8mePz2tRv1DyFC0C/wu9NuI5y5NTja8CZtlpzhmCbzBi4S?=
 =?us-ascii?Q?713YCFLADAoiueu4VrgbnQkEbwnrTyo8OfJioXcGyTTP9I2E4XRa1s4B812x?=
 =?us-ascii?Q?E1sVGewquvIqZYcBhsF5P2vOxVCYGCaXS6E7z4BNj1OcX0O+HLPLS2+KWgAg?=
 =?us-ascii?Q?wq2ESeDABo7riUdoWSbAudBEm+/0mApZMXWf5VEAn5BoYz/zqznk90kwRfoO?=
 =?us-ascii?Q?Df0xOzfcbP8PJ6Xse8sqeE2OzvBGALpcuVqtF4iXx0+N408IBA2Ck+dLIzrx?=
 =?us-ascii?Q?UIaKnpYbaKpGuF2fqpwcpshu3mHUpPVs6EteqhEPEMOAEsibp+4D796F801W?=
 =?us-ascii?Q?pFL/nk1dithO8dZvH/mRVE13E2HozhuAD/GsvNhrPShQtv3ZUWcdvFjWdllz?=
 =?us-ascii?Q?7nLVGqa/CbLRiIi9vOKKuE4KuLL4JU+mtkeHlsxc+dxIhpz+Xk9vjb7QLMnN?=
 =?us-ascii?Q?USwqp+uUseBmOZyNmDtcHNLD23hjUUixQaA236T1dyMAVG95Ww/ePD4IUKlh?=
 =?us-ascii?Q?dc0NKmn8jAsx4bYptKvK2TZyMJpPA581sCVPvk43c2XEC0VY9prJ27p5l2iz?=
 =?us-ascii?Q?zV7Fg4AioDFwtbCDPZ15TJVUDg8MpHG2QJg0pFWJUuQQrclC/iGW?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6fc0a4-7774-46ef-2fb1-08deb4aa1455
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 06:52:51.3400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9AZebnIttvt/sYG1+QT5hBrBmfrWJHplfVOWqBS1KFSl3JBtn7ABTazHC1Nnjr6RJhqhCA2benxccP7NIPhzOpcK+BZxWNHDXMeBiQon2gGvwW1Yh7DUufe9kkorsMyp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1015

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

jh8100 is no longer supported
Jia Jie Ho has resigned

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 .../devicetree/bindings/rng/starfive,jh7110-trng.yaml  | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
index 4639247e9e51..d21769b7d54e 100644
--- a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
+++ b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
@@ -7,15 +7,13 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: StarFive SoC TRNG Module

 maintainers:
-  - Jia Jie Ho <jiajie.ho@starfivetech.com>
+  - Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

 properties:
   compatible:
-    oneOf:
-      - items:
-          - const: starfive,jh8100-trng
-          - const: starfive,jh7110-trng
-      - const: starfive,jh7110-trng
+    enum:
+      - starfive,jh7110-trng
+      - starfive,jhb100-trng

   reg:
     maxItems: 1
--
2.43.0


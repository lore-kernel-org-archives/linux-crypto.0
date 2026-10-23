Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.121
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792721593;
	b=lCSYEbM6hLXtcSArVIHVKaWDsAfVrRSjYFY5JBLRdqpaTRiKzRJ4LspMVdvOYRfEfhnE
	 VPi/PTOu2wgIZN5kjbPfkx6FHFnWH+jEkNR1UEWeYJEkjyLmA8Wgr31TMfm0tGBA2u8IG
	 uDKNT8iPrdCt+22ZbtlrPCAul5pttwS5ftcjuMtD7/y9AdASlKtRXjA72ynDJtRFeVWdn
	 JGKkHLDRC0i+PRtWdsm+F63uCdTDM2YtCMlLhJmDAmk8DH74DCixUembDBLVWz49JzPWW
	 Z5iLhqXQxkg7Z0o2ohTqdVqUMuLK79+58goxQ2jz1GJ87Y3iPa7k8zptyJ5yswChk4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792721593;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=BYeiqVioAvu2AAjmCUZfwu6UVT2OJxDF97usFNixLAQ=;
	b=RSl64KcWWikC4Q+2oiqlMYk3cGGBFL9RAo7G2ffc6Q7DlFRN4sTDeClZHCXPF43uespp
	 emVfMZMD8VCjiHmx3vYV6oUjy7Ca7yWGHtkwTAP8hYLEm4oIJfCe6c+WcwTfaigfjrQk/
	 V4CGSjer7wqLScNkLJ0dNCXV/rfeyvxbdt3OjtG6+tKJhoegBrtgaRWLbFlF07i21Il7G
	 aJtXstpHD3LKHl0bDzNOZemZsrRHKYgqSpSJBHq/8VccNuWBahSaWHXe2h2JgjlMUGi2r
	 TKg0F10TbWYe7ixgn960OY22pcChc9yvJZbdhCJgZMgciIfxCZyeN7WVJw9KzoJadAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.121
Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2121.outbound.protection.partner.outlook.cn [139.219.17.121])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6E6606A323;
	Fri, 23 Oct 2026 02:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B6E6606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOhs77X5ioYIB8zY/MYSYtgZ3vV+MRkcbRA8iZ3Vo07nbfUgpCPn320dxP1fcGCh1F5mQDarKNaa0U9wyozg0YYhlJujxXgBXIO26oEYOwGMk/C1VTvoeY6a+Bj7S1pF8IeqhGvOGB7MuvYMWz9ea/jQNi4US8f0KsjI4zBZSTuDKfwvyYiNvFwZjJ5c/m1SwmN+LBCC6tAUBuJghyiVduPPBuZLd9OMj9nZM+h7MiaQOtfO92XZN4ijHMhr346yRL9cNh6WuY5+e6mEre6nWQkACB2xqAc59EuyKhqBGarQjgSO9nyJFxel11rcO0wSCKC1LXQZ20RTsuKDZLu+GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYeiqVioAvu2AAjmCUZfwu6UVT2OJxDF97usFNixLAQ=;
 b=RZLhgq3c7aR5/iOHAz4sT1N7s2PXJCA+aeqzUoscIZNGpV/tlGKyoO3o6VYIWtXVBJ2Q32+LIZflMsmYQ7SOhci5OHIWLGfZQA5izECXrFFA8GVaabkDHw91ICC6YLT3DkfkMn1vbtbgHb57F9X+En79BZGl1RHxqdE5uNggPLryTMcX9FDDswhyGSvVg0rpwKniXFokBqsuNAQZ5RXxf6Rkse2GCqEnYypzO9dyVlgCumJq4M9F6aVCBBk0B8j/hoM/OX15VcSD40E7MWlwTtpxJ9xwSWPJVxHbTVtYlz5SeSgm05fZQCIgZf2GYXQZJdoccZ2wleJo/KWzWPa+tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1303.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 02:12:57 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 02:12:56 +0000
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
Subject: [PATCH v10 1/6] dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
Date: Fri, 23 Oct 2026 10:12:43 +0800
Message-Id: <20261023021248.3763-2-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261023021248.3763-1-lianfeng.ouyang@starfivetech.com>
References: <20261023021248.3763-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0008.CHNPR01.prod.partner.outlook.cn
 (10.43.109.84) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn (10.2.3.134)
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
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1303:EE_
X-MS-Office365-Filtering-Correlation-Id: 46d7bd3e-5fc4-40eb-11f2-08df30ab2706
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|23010399003|261022105027099003|261022075727099003|38350700014|56012099006|261021121427099003|261021123027099003|261009223027099003|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OETF+2EpgXn222QbGBAamRXiSnSJin8XMSpEnifHxuI5BBUOQh/bxYaskQNPfQf6rmN+f8cRNVNNXY1C17vkHvq3YkYZqXRm4PLqf6SsWSOf7zskT4Wue+ATOQ75Ze2zJWhI1RD0ZlL7mspMgj5V1gjO/e2/hkSVHAAOEoFyIvGmd2ibmF1quU+PDYYyABd1DVUXSnt/o94TVqAEpl6B0SAA0URzAut0eQZePr3eeCgUOSRWZkalK6+ppM33K9IuK4FhIxQMCcPbnsRfUprBsPipdsY8iL6DLdoXrJ37Lu0UkgXf/hqvxXIfNUkeO733Vp1m25vwj7UE5MBIefR5Q4wXcjwjrtKeDGIX0SvwhJG0KsPFUEomjD5nZ8Oec0iTakL1VN+m01FO8DwExqUQyNlEX6a2otsLF6Ysa3LksixlA/l91TP16i+Cgno/NzponfiJ5bZstJxLMildbVR959dv/OEJFy6kvKVigsRT9q8N9TaDqhxDK/R1p0OI2+QgF2zl7FM+CQ4E331wedsBDarmz4HyyItbXSwoxjse6gzE9cE8qpkXfT3n56gpR3Pq
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(23010399003)(261022105027099003)(261022075727099003)(38350700014)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RCodadUwb6i9ULUTXFjIHwLHJhVZHxPSp7xXwf3bA6HJaGkwDG4HQMv6CNKH?=
 =?us-ascii?Q?iQumWWzVZJX/ulmBSFxTSHNNoub3DBgqL+43/0s8x7E7NEAgTnWV+HMu4uqj?=
 =?us-ascii?Q?qj3tcrxKuYmNAAuRIUWno0rabkPyaGADyIBSV2yPcdTyQO8aKS7IGCC6Cw+E?=
 =?us-ascii?Q?3Ku12zuDX9v7icOR+kauGHatFzTAcTVVDS+n8q82+9JG/aCY1YTiluIpY+ZK?=
 =?us-ascii?Q?aw8G0eQp9MCYNh7mqu/xgQpu3eWwYA4vYBqXLJOiDtzwTkpazzDwepPflWgu?=
 =?us-ascii?Q?ZAjSrVWoeOGYV2X0Ts8ekD1nmFyK0TPKNBX9kxSmAZTay6Ad5rWKKmx8Et4q?=
 =?us-ascii?Q?eZ+P7BNorFl5Irx7ZlW3q4Ufzu8C68bwG+JtwhzzE4HuoPeznELbAL83QVCA?=
 =?us-ascii?Q?4k+bfMqWkFq4V601sTEEXUL6aHMEM8jdMTr7c3dYl7YwRNfQmp6Tw9wN3tzd?=
 =?us-ascii?Q?BlNxNRnq2AAh6XhFw+gn2Ed6HC1XQ2mLGxMOYOIdoJFEBSRTM/gtdKyWBNic?=
 =?us-ascii?Q?ZsorFYSMqc5HdP7WIjwPxz9ra8xZu2rOED4HLn0ecybiuFBQBlcTJAh1WRMH?=
 =?us-ascii?Q?0qpPVDxVoVUNZZdIPOjbDO9rFUmi4IFkbQBbUg/kE2Lm1W4fYE8wuHOUbdEx?=
 =?us-ascii?Q?Fb/VNkCB+f0DW3cxl8joc5Tbx7OJxfobFpQDOU1A0bE5bCRaowsMSqI9N6MI?=
 =?us-ascii?Q?L0V8lc2EgVP3EQK6XOLhR+dIpH1JCiQcKe1r6Ji4vqX2oiAHw17m28VccjCK?=
 =?us-ascii?Q?e99rGKO6Pyo9V5qtxvNnQQD1tMJWRZikB3R91020HxP5Rfdhpa+JtO6yWjKD?=
 =?us-ascii?Q?3wX2qTXusQFNRZGRHnhbl7U+4hUjGGovCXORLIzmRvmijO8dyFerIpwnot6W?=
 =?us-ascii?Q?nzOdUz0uyCx43+sSxIoc73sxgc1ieAVG0VnhFw+dv6etE7aPGi2mESBaNKZ9?=
 =?us-ascii?Q?2Oy3Kfg+DO3DoQz5yHTE7yPp5sbtv7I52TXjY2PmegOR/MQm2IQZ/QFnOpH7?=
 =?us-ascii?Q?/cB1TtIwO8+G99mQQ/I7irba9bAZqXjlnKAfADvzQq4EkL9AHcNU6zC1YFYa?=
 =?us-ascii?Q?f8c0mviETA4DElnZUoDHsl/a3M7kHyN9H13tOicJdO5zi+9ZxWbm++WWd3wT?=
 =?us-ascii?Q?sC+sYCS0/rtTz0/HEnf6lL+G4vepmtP4E2j7cIVnqIh+iNf4Xppn3K8KEi2K?=
 =?us-ascii?Q?A4i51qya6epn+QR31qv4tA3bvlcN90eUD9UE6iE6TdXyzLpXgHw16+FwJpJp?=
 =?us-ascii?Q?vUs3ubumExo/HHbF8rmA2MmqKWVTKuKvSDFKGGLpouMGI3vNp7bKgb9dBxqV?=
 =?us-ascii?Q?fjqJZRUo2f42FkzXmx/7IR/t4bfk+mSHmecWTcGxwYGBCETd2Yz7Zuw80caL?=
 =?us-ascii?Q?p3J06/OX/Gfpms8phg+bywr81/gvwvzoW9ByRhXcFvMlwoBBIA6BsM3eF+cx?=
 =?us-ascii?Q?DXs0e4M0pPcR7n28BBoaDUqwoKAOuAfH4ayIsyJxLGF1FoKjYZKCKYn31YrG?=
 =?us-ascii?Q?BMlrqt9AtsPoXpLOSqmU12JlGvBfVqfbi92wu4C/WEZFp1jO+ITi4S00eup6?=
 =?us-ascii?Q?xY//x+VkSOf516jt16OTXZBUP5y+aJva501bvuVPCC29/cbC6JEFGB/jCf3R?=
 =?us-ascii?Q?Dole8upASeYMtoOZbx9pZmg0aB+Hiv5+acHttbrbcsrxaLHH+DxLecJn31yD?=
 =?us-ascii?Q?DmnReaHyBemMQDaBSPz3dTWI4UsSmbbJWCEkbuZ5zI2Smr11SMLT8lailY5G?=
 =?us-ascii?Q?uDG0d0G+Z4EL7Ii7Bid5+369Q9Yxi39b4yopXScvCK8C8ouH24jN?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d7bd3e-5fc4-40eb-11f2-08df30ab2706
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 02:12:56.2978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLjZfWRBAFSBmYpQURT69jXyiM8WH+e5Amhcq5dVn01bFB14imcJ3+r1xLT4inU1rjXNe0XJ3fWPlmn7whGN3PpouFyTVBiMYWNPArkzTs97p5NWl4JSADTzSg6gu3NJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1303

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

Update the StarFive TRNG DT bindings to reflect current SoC support.

The obsolete "starfive,jh8100-trng" compatible string is removed since
  JH8100 SoC is no longer supported. A new "starfive,jhb100-trng"
  compatible string is added for JHB100 SoC TRNG support.

The maintainer entry is also updated to reflect current ownership as the
  previous maintainer has resigned.

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
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


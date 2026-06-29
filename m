Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2090.outbound.protection.partner.outlook.cn [139.219.17.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C06F3F5BCB;
	Mon, 29 Jun 2026 08:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782722238; cv=fail; b=sJm3INj13uQb6Px40LzpfgiClsSrYPPKDow/qFjeir7cRjgrQP/aJFXShnG2KJKQuHkT/1H8ZZiKksDTSaYY/BxebNHe4B5/uhRMlIfrhXuwBBgBBD0fsth2ppTZPQQ9xrpM42qdGbtjglmR9VcQj1Jl1f4DI30rqzdAWDMfsDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782722238; c=relaxed/simple;
	bh=NuOTTd1pkRIKOlKjxkzpMJUfODdvxOMIsJNZjG4ejkY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MpZkiz7GG4hgeQWPtw3kbmDmYQzS1YQh2YpK/VtX5scRlPplTrOWrWWWPrWlVXqZCh0fabY5Rlt0d3UhBHPvh/7OkLfXg8ytwUiYnCM9A3wAD66JQZE7YCtmLSJYbZgE+LvZixBlDrOrwf6oL5l1CfgbkEUeJBMh4tc0HbnsZ0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVI317QAbxKg6g6dZOhzluZlIFBZOEsbOw+qV2IJy0k7PJgDurRjzy3QLJNPj0+37Y9Lia54CwxQOUa7JOTB2oydkMzpSpL/y6i+qeFKkbT2h85SM3H9ZbcRDPHiXj1zO4CGQZ4C3q0sStKjyYOJU0c7BD6ezYSqDJtDxSViMwi17s2+IBOBkBEGp4OjubPqDfR63punfg9nL5wTbx76V3JawTNvLuNN2FIOUfxwTBnsz06jq8KQwwyASAwUIP15p+73MjQIzv/R4UzfPi3f1mmyDAtmN7xe3PPCtbCdcvUF3Un9odDUHlRUm+6qx6p7mHHfPAVR3T7kRGrcLujDNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYeiqVioAvu2AAjmCUZfwu6UVT2OJxDF97usFNixLAQ=;
 b=UPri1l8Ke1hShNvOYCnZA9IhrzGuLuasUpDrNeAZ6D4m0hz/SfG9h83hQI/pvQKssvSvNE/j75I4Lq8cRJS56rbcxswT42fcmUWxBiyW31WPObvPApKJg68hwDCBHbC+wE9mfGFoKCXxShsOVUIPC11X3zzl0xPE01GiNCZmk77C1+LoLO8U4igyNR4QtNchxWaO+0nBbVdtfeqWX88PGcZGreomv2pFyihGPk5sktKHV0lk3N2paAM+BuZAsGqgoHnchfpcGPW33ujjNGSGDD4xFy0mGImZO2+oeNqPA7OrF9oy1ovNSx4EMGgraxiTsyDUGywrAO0z4u4SCivoJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1029.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.23; Mon, 29 Jun
 2026 08:37:06 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%5]) with mapi id 15.21.0113.021; Mon, 29 Jun 2026
 08:37:06 +0000
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
Subject: [PATCH v5 1/2] dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
Date: Mon, 29 Jun 2026 16:36:57 +0800
Message-Id: <20260629083658.300191-2-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629083658.300191-1-lianfeng.ouyang@starfivetech.com>
References: <20260629083658.300191-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0022.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:5::34) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1029:EE_
X-MS-Office365-Filtering-Correlation-Id: 712a7a26-aa32-4152-3779-08ded5b999e4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|23010399003|376014|366016|1800799024|38350700014|3023799007|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	xJrXjjZZSOBGCXwV+6X6j1vbsYjbcWnYb8SS4obllyJ6PkGP4AmR5Q77SRqCdlIPmnkYXr8FTwa1NSmk6+8j9mDCzxTdaQSEWGEv3c0TfSSn42YT4YSGb34S2L8H5fdhZvIK1k2S7cr9y19G26oStznXPWp8W5yp73RWlyxLeFETkPWrM7w4KjnbsdO8hvKjhjt7W9GyCqOb7vcbaHh7QxHTnABs4apyh3hkI9WwV4XuGYUsh/qAKfGMpouOY8W+9KjE75IT/XeF+SaMt9BsoNPgGx0I4xHhcTwRJcCfhNz13Xj68jB9WfxX4wVIBFV8TvY7xdWejyVkqpNrUzlPqUq0Hx7aykqa0+Ky0fWhI6c1/unZVYc/2ie/dvs0yaO2eHN3EFzqGdxx3FIconID64QsQz91vIu4hdmzepeux7S1FirSMnWfmx2Je8gLK3NKsoO+dvM+KjeykdeC0KiQxj2XdqZp2ddGEcrHFOor+Y9g1QxiT/Vup2dDMS3p0Cz/GK4rbs9yYaMU15lb7gyO/U5kbQ5yGiPPEhLScW+FyGYxbaOv91y6QyAknIHRHf2C
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(52116014)(23010399003)(376014)(366016)(1800799024)(38350700014)(3023799007)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q8uudan5avTZSIRxBTD7N0SjNqDh3bbLo8F7G4DR8zPG5JtaY21BgAKZbmMp?=
 =?us-ascii?Q?GKQu0Ci2ldpr6ddH9LJOMMShaAFZUJESUkrIyckJPy2zjIGmfPNxm/34StSo?=
 =?us-ascii?Q?CqkMOvIfqF/RjHz7jWvvciMXXYm715lAKGNjKaGxOcbfP0IFqhbALhui4656?=
 =?us-ascii?Q?J09TVeBuhdAj0YBy+SSbBFJvH2PKJA4ynEIuM9th1GVPqAr8lqvzcErE49so?=
 =?us-ascii?Q?mNeYc1D3ddlznYC/HOoAZEuJw+nxMkzYXtBOfbNNfnl1u5xDpK1IYlnxkWPD?=
 =?us-ascii?Q?EV1fzatJq9lqdaubBtVnh/y2URGE5aBhmBTsu/cf/5RsWXlZ7s/foJn23yCN?=
 =?us-ascii?Q?NXYg3T9PQBX024V8teZ9ysclsYgWpjnTEa8ORxvxaek6zqL/zR30eO9cJBgK?=
 =?us-ascii?Q?L4VEZWcAHHNmh9eya6Eh7S1ixP61vWgTem5LjIq1yMhYW+XaNC2270XabaNa?=
 =?us-ascii?Q?MPl5oOmLxSlvsOqnKjl8BMybWNeJ/ABQgQ17i3t6zPYwcFLw23JeCFf64C0U?=
 =?us-ascii?Q?s092LMa8ia+8DrjZBwVn5sP2oyBU7Sx+1zNyEe4Xuiv6hWZqCcdufSxeTj8L?=
 =?us-ascii?Q?qZ+QADqkLl8KOaZBEqjUxjs2G5o85vB7+eJTkArtRpwHk1rgjRAREqy3tEYE?=
 =?us-ascii?Q?v4ldHBV5MEUW7HeEdtsrVXUoFm4ogtnLDLdRkwGssIMrnNTWkV34G5ocOiWr?=
 =?us-ascii?Q?W6+O6qpxtg/N4Tw66VtkYy9vJQrNv5xrsFXY8vsTStv980y5s68xjvDYwbqL?=
 =?us-ascii?Q?dw+2LntYXrSq+H+ET4E/s30uZBR5gA87svoMY2qV0F3MNg6UbVf7nMN/2SXf?=
 =?us-ascii?Q?6TiuEfJPDbbx90yC8NxuvQkP+JAYeUaxKq3D+LdWYDKmGraKOC1b1SGSqxtL?=
 =?us-ascii?Q?nuJm59BGmZ6iHaFyUdD8s8VWAyJd6vHZQh56LvLdc2P3aS7ViNvcwJVnQK6b?=
 =?us-ascii?Q?hSuseepIebK2z2tGqS5ynWaDBm8n2GNs8MIFa/mOjbap1eC30fcctn7gnzZK?=
 =?us-ascii?Q?tZ/33vtx/8kGxAeTaZEHuwQlC9L36MlXvWrSX3FYJN/xLsQcRmxkoFwpYAKd?=
 =?us-ascii?Q?JxIeKu7KPw9VvGGUFcKyTU6hWDRJCWGjujDm/AWsYT/IKGUw0Z4WYylsgseX?=
 =?us-ascii?Q?7bEqae0OZQ41FYp4ePrFuFgeGnH8HWaFPTGNqPt/rqUy4TDoU53jNv11RAK9?=
 =?us-ascii?Q?OmLzMoenBjjn6rXPk75PfFBXGJXomr/KukmGEdG2hu9vnIVLfckMcBUeRu0c?=
 =?us-ascii?Q?4J28CrCvu3MoC1JA7YMF64eESs5hzd6XVeiTcoUitV1A35GLMXefgnQWgPIe?=
 =?us-ascii?Q?d8VQOZtU0YslNi8CpQBGeALHqnYdkuHL4fGRDuPVh5rsk1YSdA6Lpq96ERHX?=
 =?us-ascii?Q?BbdSiSTXsu+ZnuC2S6WxyftBJsf2QZzth8P4tEdbkXgivpUQkoFZ+FsNmbYv?=
 =?us-ascii?Q?VIxzNeHXA8s1ElsFxyopVd7iuK0TOwwixKcvML+aQEpwIjfzXDuAvdfhsesm?=
 =?us-ascii?Q?R2Y555L3s4vVE/pgH3hk/0VTzo5spXhpzmE+52xeJ0aY4Kj53HmOl3KWpG0b?=
 =?us-ascii?Q?/ye8wjNDTlcRMVQSrbVYgJWZPv2g+S7vvTHL0BBV2on0onSslPbeImCWviqh?=
 =?us-ascii?Q?RPZpaxAHYA/H17ywa4qKNF6U4BS87aK69QN3YpvBlQrZLCdzLD75zzWVQS9a?=
 =?us-ascii?Q?3jpRIYrnh0va6T1O0D1x2Zzz6P9HZwtCFSTDFPERa9691tIZZns6AlugHmTB?=
 =?us-ascii?Q?R0Ge1MQ9H0dn9Srlhv1smuKKzNmaDJCBUvhz5/mFSZc2WPjJSo6i?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 712a7a26-aa32-4152-3779-08ded5b999e4
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 08:37:06.1278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZxDAuqaOc759NwtEHFjbLAEFrL8P6HWa9nKiqE/cvYt+RJEpmfVYgVdW2m+piVBONZzwq21Am3uMjH/pM344yHgNOR6MC5Jr5RrwhW3JhAXaJ3qOlS+d3igQMKMrSkv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1029

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


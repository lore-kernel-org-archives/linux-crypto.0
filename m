Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2132.outbound.protection.partner.outlook.cn [139.219.17.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444743EC833;
	Mon,  7 Sep 2026 03:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788752931; cv=fail; b=XaRg0EdxvE4pNQhoOEFS/g8mNHvKQI2Osl6o2aGSk4t7e37IiOczqL2Xxb1N0suXzcc0H/b2XdRrwlI6Ff2KaDzKSNnKnDyoTqOIr9otKI4QYAJHPUWYsvNgSP6Lhw+bMB4rDxptHi6bI73jkZ03OddtWkzrbhuB9t47UWLGqfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788752931; c=relaxed/simple;
	bh=NuOTTd1pkRIKOlKjxkzpMJUfODdvxOMIsJNZjG4ejkY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FVGvs96FHS+eD76UqiiKelibg+ewes85sQMPA5Mw+JV+ooJgot440GZViWgPQIUEzSp4ks3H4nvF5PvD0Dd5RscscQseWsA0EmtT30Yf3lHcL6saEFlOgrVuiUJ2S8yhCNdgWIehtYOONXUJTTPw1UswKrDSxR92SyFjSDjUVTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJ2j6Id4Ijoveq3QRYKzjL8LrpqZ6UJ4EoTn2q2kSJ8lWeqV7OYyz1TkhPOpcvGFOpymH9EY/eOcILOcHkBk/a5fo/PhDYUTvYhoaR1JO84E6VNPyYmo2BChBDFRYoMygbpIyimaa9b8QiXDz3qep/8sYTr8EiqUHHWMvQx//8K75859BrPM1dhETWGKGlVoAjOK5oIqRWk3EfMjXFn9J6+YbQ/Nw/VnK/A3pFIQQ0oMLVaFrmW9uPw2DjM2fxArKXI8WYos7Dt3kZVHo+XCO8dlr9gegQzreSjIQKVO51Jm+P6MBVOOTex2C6lZDfhoxqCvjPwq0k1Mcg40nV3lBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYeiqVioAvu2AAjmCUZfwu6UVT2OJxDF97usFNixLAQ=;
 b=PspXckre8xIwxLKkyr+dZufvwKm7/3koBeOUESdhAaIP7+RyRENZ7H8DSg/Ca6uQ60z7nQFAsRwY8xy6RAIIeUzUV4JX9BDR7bup59irSa61mqjY4MspngF3sf8TStnDoVzhxOFTxMIioNuQF2jGz5+YXO4Sx2pXjO+fUZpZCcSDXp636xydLF14xl0jSq9f29m6ahtUPJt84qWNOaUxF5JQiBwHg7voJkiXY6cZR6OiC2V97EG1zvYChuW6B4lqzLxDyi3yxJZC4I6yJGCvQ1CgJNDXfeiEFoYoM7upvhhLA7UfgX7r9057j9I8U3wEHHo8MfvULzpUoP6xfCr5IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1320.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:19::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.18; Mon, 7 Sep
 2026 03:16:12 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0339.017; Mon, 7 Sep 2026
 03:16:12 +0000
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
Subject: [PATCH v8 1/2] dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
Date: Mon,  7 Sep 2026 11:16:02 +0800
Message-Id: <20260907031603.188483-2-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907031603.188483-1-lianfeng.ouyang@starfivetech.com>
References: <20260907031603.188483-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0033.CHNPR01.prod.partner.outlook.cn (10.2.8.10)
 To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn (10.2.3.134)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1320:EE_
X-MS-Office365-Filtering-Correlation-Id: f3853f96-111e-4082-20df-08df0c8e5eb5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|52116014|10067099003|3023799007|22082099003|18002099003|56012099006|38350700014;
X-Microsoft-Antispam-Message-Info:
	xIiuv81l+6y8Zv/dLhn7LhOsJ4Sga7KWEQQDddQc2YbiJ0dA/ocXbQ75CPGAtnyD1AsCtl15LV9gXxoCRjK2cqXZtVcDU7OBreHBBTiWTJ7V/DuL10trzQ4wUmZNsNMc//sXJv0AfeHn8sZQz3pO/jnbNJ+uxLMqNgDNOLY98/y1Bzu/7M5wYtwIwzS7NRJjiKEehwpZqvcXaSzVN1MFqUOMA4aFJCu2eRqfHkqXqjQS4B+3CJJnpyvf/3nlbEvLWtyBoB5mFxwQ6rUCp5r5fYeRuw5kmNIYj4OEui4QZrQ82MJBRTuZWQYNJpawRFkqHfuXUW3toxTJkazcvgXu0Jh4B8isZOOO0EM+035y/BHlrWyOmdB0yeEqvXJxCQrN2bxze5elzAq4Ah8WKj2ILiSHQ+u8E0q2JbctTH8/fnqCEeodZbOP6nMvZDHILIWj+/cZVQwN+qWYhHdJKYH5YuggygPA/JiS8D54G64NukRNMGfZHIGrK5kDWZDG91jJIrwpRvDUwaBkfOgYg+yu5TPbSTBgi6vofIu5l/oEc86oKTnNzee31k4LcslTxYnb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(52116014)(10067099003)(3023799007)(22082099003)(18002099003)(56012099006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ddn8X56p/eY6hBtbAkH+NXo5DjPw+g2ZLczoUcB0NVuEy3vsiMOeyMD7wtUn?=
 =?us-ascii?Q?iOfPI+0qxzA8yI7qU4SdTklKlF4E4H2a1vzR0/+E9zJ1bd5xTfwyCx1bmg0M?=
 =?us-ascii?Q?H82//BgpvlPoEeGw0of+M3ceQSoUwbav+bLMM3ya9toCq1bE99WAYyTXUz1Y?=
 =?us-ascii?Q?cJxJv9NxSwBVRzyN2Ky9ZksMwPeEXS96mwd2eIiShB+Y8hcfdd8LueZ+iwqC?=
 =?us-ascii?Q?2G/JREsdS1l88WfkmujPCZ6PHHsSmi4udyso+Q8T6r6XxthmTz+myr9bpeVx?=
 =?us-ascii?Q?RZrVfFRM7biBBu0pzovJkR03FZBFkZo+ckzINepd0bD2zC2Oj+MAi8Bm+03Q?=
 =?us-ascii?Q?mtywZHD9+antt2FyofQv325gfoaTvkr563r5/mGVuWFdJExBif63E0VKsGkk?=
 =?us-ascii?Q?6fq4mSPhj2KnOhz0GS/ATNuvLuogm6NgaFgDcdA0PX1JlP8brHO0EnmOYxlY?=
 =?us-ascii?Q?eYKdmKl05PWRVaciowqRxCML/8AitHExdk4f3LeRNoAiY1M6lYUvKZQsLmbG?=
 =?us-ascii?Q?D1iiDuesgNmN0/TN1HdE8ly4h9ZBq9CwOD73Hbu4iFq552E0c9bkZi+cW9y9?=
 =?us-ascii?Q?lwozk2hHeqSrzRfZIe9QAgLTYnjoMSGtsjWUNeabHLmJz5Z/R7JrSdDGTH6l?=
 =?us-ascii?Q?KaMEdlroaG2EJahGHtwTSYm3RGcamn5oQ5eYRIfhZm2ITjQ9HjEYY3bs5Ea+?=
 =?us-ascii?Q?n+uMFkuyKzbi0rD7jR4T/ZaiKZNQ5ujsNBh3QJNXij7yXKEOxvUqbCFe/iGE?=
 =?us-ascii?Q?Oz7noNFpVvX98RimeR+htfJlFzzCiETHphX6faFY12uLRRxByRo3rWW3ZfQ2?=
 =?us-ascii?Q?A3LrpHfGFv/TaW2YBhdBsFIdzLyrAflgjHaDkE5gBZlgI0RMBdsL9jbQX+uj?=
 =?us-ascii?Q?VYn9pU6O6G3Kj7VHNOGM4eGolCsjU1ETW839etW4Do8xTdwqWvpR83jn9Vl0?=
 =?us-ascii?Q?8FOkfmPm82RdduCHk5WuIS2zGAZ5fgl0qLHvc6Lw+81Afi+4Luysehz9fdQY?=
 =?us-ascii?Q?6TzKcEzsRRrkWYpu2z4H3wjxDEzDs8qs98GcGSzvikQNZoZB11TtxS6tAgH5?=
 =?us-ascii?Q?K99ZwtTxX2jQQN29ulqqUz1N2KhqcZF7ApU58vpfuBmlLH17FS0he1DlNpXU?=
 =?us-ascii?Q?ORH9ieqBMfE+4YtsA4TXRBxbgPTuZZW4uy6Guv1HhHlK6F9m9IX9nc5AEvMU?=
 =?us-ascii?Q?Gnf7fzpEEKGSATJRh9RjAmany2yd6OvM3RVkVkSWQn/6Oin1tWYoMAxuzj/o?=
 =?us-ascii?Q?wmhzQ9BMiHHr12ljKl+3dc4ENfPh89cbhYHbvaZp6v7P9uzlVZsQEMAZ6J4S?=
 =?us-ascii?Q?oxjxBXemyvzOiYfQuSRuuz4R6F3wESDLOxiFaCPdF4uWSih8RZucLijS9Hb0?=
 =?us-ascii?Q?EXIO8GTPRYMJV5u8Ib6Ly+eFmi0Pit1PLCzJEcOtTQ/kZNE/XtFquUzHoRK5?=
 =?us-ascii?Q?1IGWl/1Ugu4Q2FizJKU4bCHwbqPEpCPJ+UWcGbpoxs83oecplhlvp9JfOQMd?=
 =?us-ascii?Q?xP3msYRKH4GOz4YurvIDQ8jQI0UG7yAfTJCj0nM8SiWyg2HIg/AknDxHQR1S?=
 =?us-ascii?Q?aQ/hH90g29ZB9P3HY2Ji2sWFP+ocdIGkHtGxQGDTEybJIngD9tdNyM97x7VF?=
 =?us-ascii?Q?SwouFE0Lxgj0+L11hKbdm9b38T1QIpY4+Bi6pHXkR1CVVyPrbx8vVvT1PuVk?=
 =?us-ascii?Q?3Jo7HvJ07/GqMBQtF/BaHF33diHVPeo6WYEpCxucM0QykW5uD1OYdGTV+Nje?=
 =?us-ascii?Q?41UgoFnJesWkeYAggSV7UR104qj7DnOKtqi0BcdsF5fAeh6FKYln?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3853f96-111e-4082-20df-08df0c8e5eb5
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 03:16:12.4865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gy0SzarVHlPwvPRsNzFP7gcJYINZrljeVvMtzxthjE3hks1BquGHSkpijqpGsiE9gLR/ytpTJhZrzVwgJJ6BvYOMXoVl4E91mSZ5OVtSO4jldLn4oZkNtepItJfc1auR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1320

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


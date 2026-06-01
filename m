Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2116.outbound.protection.partner.outlook.cn [139.219.17.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD803A48E9;
	Mon,  1 Jun 2026 09:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780307650; cv=fail; b=iloFv1TYxKouTNm9Dx8iKMTbpX+tP+/jYbXZx3bJCF64raZRQkmBZKnB/XZbqh1GYAsRD/++pGcopS7Wsvx8Yo8Cjzo/u/QJu6HkQfrAAyinYEp0cNuL1Z8zsL6bVyXflpOX9zdTasw6cwLkMcuGTvHn4odQ1jv7ihLbVukByqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780307650; c=relaxed/simple;
	bh=uROYCZjqUOPMJeouu5r5SMM2Y61ah0Lnh+pazlcCgmE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eXFRe7AOGQoEkNU4t0JKju5+jicUahEN1gLtoLSToA9eCSpiDydVxBP5HsflzPmfJLBZ/QGFGYx+5SPrYTpu4CU3r0if5vzUhoB7v6RpXmHc1n1u9Eft1kR+3Z4uQKKclfyK3kmf65/C7xPcUpkAib3/frQg/TUCWjafyNnXTiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3y1Prg7ss6jQqWevRCYS0sSJTwvPO2Ee3dXxlZY7RpGUlnrnuClnEalhLb10rfx4GzLrzAvJvoez5vmCY4TpuiwKj02QBOLHuLC35pks06umbKM1xf+hTOciO1tUuHVE6hyaOTmHRAmE4Shfens/JvJoVqh4i+KOjwAhsjzjeqoBE6XFpjcouf+tBb0qx79JDXn7nycz9Eqd6nv9dM6C+Jz00Fn+Hc2DiOkY4Ix8ZO+mUGZFK800RsRm1ZjotEiUI+Ec3uZTkU/lzimttB2lgMpjxuEOIC90iVg1Z2WUHBXPyA5JIgFmyrnQMmP4IxfuWlZ2BwfsUZAMm+vfx1uRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CrTrilHq+cttg+FT7m4OzPDPWgBhSg8j5UgPVMCHFA=;
 b=oOkq6ByBDqUmIrlduqFTKcADp6YAH8aTydOLEdhr72Z+RhSbjmzAXJE1dNXnI64X0ILBjy5orKrym4fBXSe8zJjkZhi75dtecgslL1nVmNv9ugBOYi/e6F3oUeX/i5QsY4bQLwH8Q8/H2WvHZAWVfDSPg9AsnfpUL2GzDz3zyD7WynpLkmCkaFMP0LwexyAusqZMHYl3qyESfRvYrfnVouflR5vYQPJA3NtLMkC+Hh3fyitX1WWwDKTymFBPfC6vv+hl9K6orUy4gspE2hQH/lBWTFBDwKTWKK6FogjGj35YQ5/i6M3UoFjQcRJrKGox9Ov9TdrXXYZ8eR/mU0oJLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB0982.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Mon, 1 Jun 2026
 09:37:53 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.21.0071.017; Mon, 1 Jun 2026
 09:37:53 +0000
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
Subject: [PATCH v3 1/2] dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
Date: Mon,  1 Jun 2026 17:37:43 +0800
Message-Id: <20260601093744.84210-2-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260601093744.84210-1-lianfeng.ouyang@starfivetech.com>
References: <20260601093744.84210-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0009.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:5::21) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB0982:EE_
X-MS-Office365-Filtering-Correlation-Id: 865022a0-2bdd-4ad9-ff55-08debfc17426
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|3023799007|56012099006|18002099003|22082099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	YUxcACTHebs4fHr7hI+3R+3EUXe/KWeaRvldUJ1hw9jEnzq2dXviqbkqrkOrRpJH9FGt69lgQhIXKLL64s3ky6DEUfNstcnvcho4cOmGFZbbA9vOLeGgLf9pXWsP2EJvqpjrFvJGDWDETzzMNT6+Dfzt1lNzWJEdnHkkh42otpl7f8gNOv+SEjK4qLPWa9mDAyGLM+vs/pQm949B90YCTlOYALhrFsdGdZmay1lAO8z3XktkeLeEciJpEaK3+d+HxkC0rJ+5v/FbVdEXc2gO+GeNwm2mE/CT48iIARb3SPGZM9GCDPNb9tQ54+P48DV6IzEyfEyE6k8sqtU6zdJ55AplOk/eWTRu/0iqr5sHRMOsxr6U2iK4zj2zg4qXC+ntY80TspUA5VlyhCXeBTi2iN05IHx1QiRKod1huMQPhzB+lssXE1h4SdMjqNnAHyC7gVJa/ELMxxH2/quw8HgjhcJtkJ+BSopxnw2Q44GDlke7tiTXELSg1s8MyTIydiwUbGnCuVemI4MNy1+RW7E3YQelecyK5BERTaKWdvwXl+T/vOmDld3+s5Ypv4LfVqsj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(3023799007)(56012099006)(18002099003)(22082099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UAgMy7dBvCAGyKYUvNNFtKB6ESGulhXKxugfFfM3oVyc+i6SHSTNrkHw1rj3?=
 =?us-ascii?Q?r+eIaXWILHaU1dTQDFZYHcvBzDOYZnT1j9CwcgoQ1+sq/K8g2OadV9bArlrk?=
 =?us-ascii?Q?VzjDMH/CpZShsfhh5cheWFpyGfKWyzXABRVazRwAxvq4Kep1WpT9OjG87G9c?=
 =?us-ascii?Q?6Zvu+7HJuGvgC8/v7r0NhPFqiFDNZ5Ghbk89owHKpNrD4xf3k3qdbO7ndwVX?=
 =?us-ascii?Q?gHHpCJXy5xLIAwBXUcNLvijXP9yE4eTLqD0FpDYB+yJApWMhUzMkxXc0+uQm?=
 =?us-ascii?Q?sik2hhRv7iUe5c93qGoLvFIYaJxjR/L+K7FrUJoadKbd0g7xAmfE3npeBfhf?=
 =?us-ascii?Q?lW6BKKAMp+JGXcQAEhG9g730/l4Omv1XHR72I68BQGT1L20sMtL7kDp5SX9j?=
 =?us-ascii?Q?P4bWfO8AvS0Bb/1vK51R3DK9IdqtyMrTaxYt4WmOngagrvZyEuhgVMQsI3qZ?=
 =?us-ascii?Q?ElU1PG64pQ3bUTI9AabKCFIwlGLqEKBlaYTp54EqLwFm2foFamUrAmYBwYvi?=
 =?us-ascii?Q?2I/Iio3NHLQpuB4zummA4XPT0uymTRELJxs+evDI6DhHgSFas07hJ0lHM5Up?=
 =?us-ascii?Q?G1C2BaqoCReZTfAjwNXgBhbHIBHRALsMlUpsli3dn3Y9xVTvt7ck8Vr00FbQ?=
 =?us-ascii?Q?AW/SUbRtiMnvFlwRb2XT1bmHKOTgOH9iN+A5yexi6XGvIPjSlT1whFny9nPY?=
 =?us-ascii?Q?RvXbNIi9MHXmW7p8B1iys3hSefEhCudB4DDRVr0NwxeLD9XlaYBM1mdJ+Fg1?=
 =?us-ascii?Q?91v5cJI1yIQGnF+bDhJywcR0+Z8+K5SHP6GVjuuu8+m1UYp3ICA6cEib9a9U?=
 =?us-ascii?Q?RJDBr3vhqwKx/rJ9n7zmSEmi/c4ad+ogpbf7A/mD8LJmUhhgfcc6DwK5AOEa?=
 =?us-ascii?Q?/S/XrEUjRaJ/dVzXOj80BKUBfFxJF+gO9hAEaRrCz89IWrE6KVy1vMql7ovt?=
 =?us-ascii?Q?uDe3fPFCUrKdNdHLywuTJGPkdDvW2ZYiMJa1uT35gP+x6SoyXdOdLoiWIFKv?=
 =?us-ascii?Q?knU9KUzIezS7Bd+2oihqCPjD5qSFirGmf1NSpQONFLyrrbxBFDT4aC0OotwQ?=
 =?us-ascii?Q?4ZiY0JB7YtXjYIPnUA/RHjWBNISFMKorqTdITt2SNG8H0P5jq/pq34GeKLT0?=
 =?us-ascii?Q?xhaJSLraGsw7um02AoMTWnMHXuBTy+pfZjNYJNth/opsGQiQAdy/57zbgmFC?=
 =?us-ascii?Q?E1RyM2NDYQ3n72ilPs/qZn6nxOGzF3BVm3fWr46LJNgghf18K3kZsdIQ5onc?=
 =?us-ascii?Q?YL+K1hBKIPbBjqwENbtGDMSjaWC7Rnl22Ip8qga5n0nbzP6xpNgNDdi586tu?=
 =?us-ascii?Q?dsi7PqfpDaKWdSVSTCFRRborACMQVdKnIZKIxyUNCn8y4k6nmiSXm8OKaTlP?=
 =?us-ascii?Q?55VH4PU8k1imZrLLPTUIkgfyhWVlXVG3tqVFGlqZO5s8UTu+DI5SnhOg4ZSn?=
 =?us-ascii?Q?OZtliSCThX7I3es7q0y0AC3Q7rtsLDbi981yry7JvyL9aFAuN3ReV3jbRFc9?=
 =?us-ascii?Q?rtLdvHqP1VurYH9LU1Y7V20g4Iv0Vh7Ai1PENI4LTOlGjoH9AjVORUvvrKxK?=
 =?us-ascii?Q?RHbe+Z5JNw8+rKgDzm86QidAW5usiiGy8o78fStJ3/AfB8bfDi/QexZ+p3ul?=
 =?us-ascii?Q?1a9caMf25geM/iQClxotCA8GjoqwtncuNXrYXGapjBvoV5qJWvlo7iSHWhxv?=
 =?us-ascii?Q?hXW5JNQbhxqov8EUKfy/3iPZzTi5l2j2HRbPF403hxP26FJ1mtMOQKVtepH8?=
 =?us-ascii?Q?9lrsAu0ZUSPYy4kD75oHdv8sAvUWZS+/tfogXhqaFW5Z25CdLNXH?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 865022a0-2bdd-4ad9-ff55-08debfc17426
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 09:37:53.2813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJ7l/E6xGyKe/T65zM/aHihdsM+h5q75tXolDCTFuzvmAKKIJBode6m4z1hkf68Z2KRYg/bA8KCTwAKEX+F36h2boCEjKGrfLrc1Pk5ZcrG8x1/wxg/1sojxe1UbCJQA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0982

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

- Drop "starfive,jh8100-trng" since JH8100 SoC is no longer
  supported
- Add "starfive,jhb100-trng" for the JHB100 SoC TRNG.
- Update maintainer to current owner

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


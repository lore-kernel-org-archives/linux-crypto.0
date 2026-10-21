Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.113
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792571852;
	b=i0OlCsdfZnG7WWMq5FfW2bncrMbwsLAcby8LbMtBH0b2MKUeTu0E7L2U0We8nH43FbSH
	 kTRgWZ9DG7IOdLMwtEqTDQ4I0rU9t8U0lJTt/HG53+yiRMaR+4bAXScZTv6SwHI3id6Zl
	 i7eYPfs/IW8IZvlWrpMPE+m+OfYQxEe/FWoPOs3wzeCyIf4IXrBITQ3NYJwadNKUInuS1
	 lr0j/gSoTfFbMVQ/WErotysolEIxyh+L1rOwvEbZ1Y9HK7EyMC4mpIJIGGNiPky0JdlJ4
	 Veb+rtlC5j9MBsHy9M+OeX6HwRgwOXmwgHQk+K0kBeKRzhQ3Yy9sDYDaqGSrLFyhHKQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571852;
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
	b=KOzUiM58DTLv3cfa1n0SSuWTvuWgjBSF/0msD37rGC/4ypTt4lOdkjSEI8ImvI4Y0OzX
	 t3avbIpnyVE2Klq7IYPSYBTfuSU4+B+Xq6mbv/h8JOfyAYAuF20JSUE0z0opgE5Sp+FBd
	 bCx5TCd+mfcJlaMynpwhbysuajxntENb4geuDQeBiNS+MqFbx9drYtSy/glcJHzkF8epO
	 Ir2R6Zj2Fv80rKnqmzA9NxgPckfaaC1/j6BDQK0lfbs8QlD5fyMRlr0Q3Yc5MwkRXbInD
	 /OHlxNFtR+eg0C12VrHdjRbhYnVNgqdII1UdmzlOrs8l4XwPZN2KHtoiRB3D0rSi5wA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.113
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2113.outbound.protection.partner.outlook.cn [139.219.146.113])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4F2606A31C;
	Wed, 21 Oct 2026 08:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F4F2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n770tkNACWQlUU+OIYRdrWtsBXGkJTvUQ/TUiIm96B/MULVvdOVHjvZBQy9VobqRlbRmheCd+S4R6CyacRF8Q5UbVwgQRDRo42r5vZAFZcjnh4OBpRoEMhISkosfxNc1WjujGGX2CWAno3KC6XRj/yRR/E9Qt9hc5AVe6iNjV6/3u/GWkfkZK7z9DP2VGGc93Niolp293QDCrLp4cMQvXQQPLIOzex9DkOlVnHjVniB1TiJXvrX6hHGuwI17d+/Y4XEUSL88cRkRSmJKB7nLgE5ADItB3vBOXIPUOwRepGMPJ6IejsP9/BWkHvsbsQMk7n/SicWCjvwRHrDV+4N9sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYeiqVioAvu2AAjmCUZfwu6UVT2OJxDF97usFNixLAQ=;
 b=Ep1fVwL02RN+ixPgnhfJl04LAjYBoidF5+b7nXuPnzuhISD1C0ukdcep6ouGqcd8R7Z5xKZhfmoOaf4ogDS4EpOilDO/Dwkqu1tmUUsBQmfMLiwJyX9JQQlGT5ng6i2pvWQjylmA/XPr1bqa9ZhM3XNrOX7g5YDGrodLAx3WPLgS5wIsdHcOMHwY0A69p7HUtrcTSrsD9tOyfxRj8Kk5pFMAMjI4k652LxzKYpNqJsStpRsVPdqETlq6PmmvLCmBfoH/qk0Bpovur0sZNWM1c/oz/blacqmalLmxas4eBtt2I62ZYEhM1BoiXkY3qvGqj0M4BE0a1ljMD7SXqFRU1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1047.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 08:37:20 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 08:37:20 +0000
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
Subject: [PATCH v9 1/2] dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
Date: Wed, 21 Oct 2026 16:37:11 +0800
Message-Id: <20261021083712.3032-2-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261021083712.3032-1-lianfeng.ouyang@starfivetech.com>
References: <20261021083712.3032-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0008.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:5::13) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
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
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1047:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ed4d2e5-ab3b-4910-784b-08df2f4e8585
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|23010399003|1800799024|261009223027099003|56012099006|10067099003|3023799007|22082099003|18002099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	nIVttFC+KiZCfZcL6a/CzlJ9QHcwd2x9l1FMW4JuDeVtD3BxgHfVkYhg183EKVsVLja+ReommXg/0FPL3ZbvEE2zXzWexJrM5FUtq+dR9Dr6NrlkJAFAUmiblCeHSRnHvDq0ZS6YUk89vyVYE7NdHXhSCZHjXPK1w44WCq5DMM6y4TqhUlDUhlyAxx57X+Oy9hLdXTzr9R1gLjIFT+cbvJA6AK1zp1h6cGaf+vmD0L5zSGj/4TwMbKCfCdU9YCOrRcgpjqd0YUTkkClyYvL0KpWxdo9G+84R57dqgQP322+qpYxO3lLhGjRhU6eFCMmiaOm+3QObxmGIwVKZhGOFH2t0Eubtsz6vBPzjPYishVGOGklagA5c2hBNkySQN8uzk3EhXLmBFQKn1enigX3R+ZkNWWJFzeUqS+XVJfmiAAG7gY03Vp9uMi9DNsbN0LecISL7mn/hFo/FSe7j/zyM4w4EAh98ZYTED6WLEiA3q2J1zFB1yhXNqcVC9dIo/fYHh8mi/s23TxCgHdBIQBBkaadJQ5V+2ZXAjVppDgcnr96b4tH++3BKEM6QtOn6O5kU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(23010399003)(1800799024)(261009223027099003)(56012099006)(10067099003)(3023799007)(22082099003)(18002099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7BNYRV4W/6vDnymSiYsDs/7K/tYbHf7AX1hoLpYiH6MFWBTIfPak2NY3jcO4?=
 =?us-ascii?Q?nm0GsvyaqOw0iLIjT3IobtkYpWTVppQ1N8dOFWQWHd5jiueWyPaEYpQFGjMy?=
 =?us-ascii?Q?fkP4oe0dqgqh4Z1H/qavWHJosWvGwqD7uepsyOqoeHQ6O92/gD62LZbFbbEJ?=
 =?us-ascii?Q?JcJwmyxVU4Z9snHyu3nqIkVdCRI+nFzVWhaN4PwrpDGCUloc5w0DU5wC0OMJ?=
 =?us-ascii?Q?rW9Ra1ZzeRs6lbG9z2MDy9OpKxSpunZuohl2nRvueDwIT04+U6hNoAePoI42?=
 =?us-ascii?Q?C+dD9rIc8kYAvp7hxqptWUfHD+PQ7U9xiZWbykca8e1qznDaFakUBwzJ2yw4?=
 =?us-ascii?Q?ML1cn7kHPtZD3DI6hMROfOy13F+0IhD1JhsR+A5iz4oBnrpZ5pXb1WzPkJJs?=
 =?us-ascii?Q?vRBWJ4ebhX0CNUVAg17RCO+y8Vprx569jLLH4RvggBEUsGO8PZYaI+rKVcwv?=
 =?us-ascii?Q?z+2pfPMX6D6XFxclqpH3m0DGLxgDBK56ooLwpPmZZaFeUK+JBQRrgIn6FACU?=
 =?us-ascii?Q?tNgQIhpot+2eJooqWZgth3BY7UNnp2d07vtVbtd5iaoPGyQSDQz/xS74/EYk?=
 =?us-ascii?Q?CqmU33h5Zx4uTDTYAJMaCXGqjKCL+chbmypjtqwBSe5+e78ZPtH8HixMlPQ3?=
 =?us-ascii?Q?5WXbww7lmOwmiloi6ePlKJsKDMqt5dBEuyshAIqIIBFaqw4x0HFxrbvzCttL?=
 =?us-ascii?Q?0p8AahQg9mDqJqhmQ2gv+g4V2GlJTW3pinsAsNZnsJCxq3/qCITItkYa8spw?=
 =?us-ascii?Q?t5kh4HGB9Xbmet2FXlcGeCNy/9aVx2s1Ko7LYhp5T4766x4SMJYtvfVBBKJH?=
 =?us-ascii?Q?DDg8oE4FR/Qqd2FM+rGyO4Goe+DI2q1pHxjWIgzKqj9cwhZRtGSGyXPQAMbD?=
 =?us-ascii?Q?jJgRB1OkyekM80g9bLQ1BiKJreoRr+i+o2dCn+rsD9uuGVgdWgo7rScb0FS+?=
 =?us-ascii?Q?zjDdbMMyDwZoqF/gYM+ff3JfbMGcjjE0fkk0R+S8FiJe18282xQMKzfohKHs?=
 =?us-ascii?Q?vTqsZ42GZE7Y4mHQiJHLN3ihQLJ+M18n1d/njmMTA2fUYeBwyWz62cFcRztd?=
 =?us-ascii?Q?WuCisNHAkBPtShWHejDUuk4235tztVxvlvFJph3U3Xxw2DBosSssgygbdTiK?=
 =?us-ascii?Q?mOlnbu6R9V8rHkFB7CmWMOIbm/dMZ0qn8YgJmo05hJxNLDBh8H2ZRoFjqJm2?=
 =?us-ascii?Q?5I2RjD2I7eB4FUSNuT54GYwJE4dWMwdGSPpw1elga3IH+ZzWgSfRol0/E3OS?=
 =?us-ascii?Q?vTf6vIXVbfcYjCgX+ihgWsQEuWM4QMPvoZS5Fd7FJgCxxpk9IPCukcgUW0jK?=
 =?us-ascii?Q?sTAiKUPKdQLmsyt0ijF0h0r6K5pz4NOWboTRAwi1431+QcMDC71PlaQHnEM8?=
 =?us-ascii?Q?3APsufIbfLjoSJ7/ERm0F8ULQ7xNSBMJJk8XksvGbohopnQ9SBDO3R0+V7GV?=
 =?us-ascii?Q?aJBZsmGJV+505Kn/syWLrQkG9gl1Qzs6idWW1k2XmjPT/s/pJxtfDzSSjPlR?=
 =?us-ascii?Q?OcH/HldG2Yaathb9L8Fk8OdWvl18oVG8Upiyz7LBhXRskk0WwLhH4ii6WLfL?=
 =?us-ascii?Q?jWKvUl/sK5DFv7vXU21Huo3/ZdJk7r2CFrvVyduONhutyLM3WTulPqehvamw?=
 =?us-ascii?Q?B9rvSDp5zO6XjIycb8KzCiCvZbAxL42xJbBaKzhF8/ofT6LytzWH7iLezMJ9?=
 =?us-ascii?Q?uwgtrNQusSQihJ3mF5lJ3gjf1E7fYtgl1UB/Sh0dvf2Y9Web9dDaJi5N2Ki3?=
 =?us-ascii?Q?DCMUGhrCs2/yXOOwc5iT+tnYdenlQrOgHnoFQfJqyqoFbDb/NXzS?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed4d2e5-ab3b-4910-784b-08df2f4e8585
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 08:37:20.4898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fne8mAzXMIOsKZlLMVLGFaiLVKdpBGese/sePwq68My6nWF8uPmcE5uSMqihKaozOtANkuW0je7Js7w0NrDVytJnORwFHmq/1CHmOHPEunNfewdm/1tAlYcxbSHXJD3s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1047

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


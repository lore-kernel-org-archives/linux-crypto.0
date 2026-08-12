Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2136.outbound.protection.partner.outlook.cn [139.219.146.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2968937F745;
	Wed, 12 Aug 2026 02:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786502061; cv=fail; b=ifoME1nPrdVZdtQzfKZVgD+CGzUi3eOtEev+nGdXXd+LU+WoG2MvS1e6nRoNYrsiHx0s2+K2hdyw5rwgyBbibu1KMSFq0Miosg1oH78O2lqPoWb9slLHI2ubu5qcnNb0gUBYCtx/58tCQHpzvXSTvyJZLTnBmR2uRVKODniCgws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786502061; c=relaxed/simple;
	bh=NuOTTd1pkRIKOlKjxkzpMJUfODdvxOMIsJNZjG4ejkY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tI5ZFT6Ywh7FiTfOO+3kG0Gpwrha7bT5BYQM7FD9SEH9UgdeWlICa9jCGeIjhqsaq53ayvtqy5fS7XY40AceMR0GcJ0ME/3YmLAffLtTeXSz+/2nvx5+hTKRrkt3EC+A99NHFJ/96gttosxM37TepEAXyL303GrhltZfH0G+MUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZwIEEUlJR4sq+De3cGPXAhBmuV2DculCsL1p8hUaebcX9mZ+xSjZeghZHbqOfAKwaB3cWXy7y3RBpWF1A4ZD3gbziG1OuqxhljbmlreJPKsbMp0fuRu0bvib3GevLsfC/OgJILWWbNNB5BqJj56KUK5Y9ur1UZ2xVK/XcL4U/2yzE4wKU0xPEeqdQ9KBSF4O0UOm6Er7j37lDvBOPU5KVCCyYjbOEoF9KOSVy6hy+ENdbaHMpTbaCqlm+Av1y4WWNUSCpPLdMKgzoQ57U+r9DQeRKAU4DyS3uTL5c+DAIK+LzZGd7tC/yesNAJo0Wlwv+Vl+81DXk/QJGnOqVl5VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYeiqVioAvu2AAjmCUZfwu6UVT2OJxDF97usFNixLAQ=;
 b=E5sp85e229/wWXYFKUEoGcWD+srLREsBVKPK9SMC9ypM8F6gHMl70PnuC/3T+xZoc/vk8iFgPdcHdHpBkzvge+3Sa9pwH0fWNVsOP77s9van06ZEOv2GaVHtLOWdWgxMcA8gH3t3W0liRYrl/cpWH/YhgTFqOaptPuMBA5T5h0AinC6T3yjf+0nGSA5T7C7W06+leuX5M6ARcna4RgiBeXD3/zuSAc/Ds+IGmpjHS84GAs+ZM8cTmIYrXAkQoiYPSptvfReGa0px5HZV9Kl26Lc6cX5up0+yd9rxU3eDaiBHtq4tHLZwBc/wuFq4pX+HaWUJcNoXGSwUhjPVDDXPfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB0998.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 12 Aug
 2026 02:34:10 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0292.024; Wed, 12 Aug 2026
 02:34:10 +0000
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
Subject: [PATCH v7 1/2] dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
Date: Wed, 12 Aug 2026 10:34:00 +0800
Message-Id: <20260812023401.44149-2-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260812023401.44149-1-lianfeng.ouyang@starfivetech.com>
References: <20260812023401.44149-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0011.CHNPR01.prod.partner.outlook.cn
 (10.43.109.87) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn (10.2.3.134)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB0998:EE_
X-MS-Office365-Filtering-Correlation-Id: fe8c33ef-235d-4aa0-2915-08def81a307d
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|52116014|1800799024|366016|38350700014|10067099003|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	oNcl31DmB5GW6h4jdalpL5loYmDnwsjAhNE+pJVJVx+S5FC1gyBo/xm+KQI2DNs4G3pm2o+uAk5kA2aPrWL9ORul9QW7dsQ/G6YhSdUoFt5gqMY0OhIBhXHy7HgzEiaT4yJVIelH5Sq+1g/9YkIxmDtUwUeJajhJUvAgN6ugVJSAYjBIHgdlOSwMJq0/QoI56/gPPlDVWVn+PwMZ1kA28XoZtmLFqf/0jElhAzoePnuWHDEn14hxXIj3PeIaUILjBEiZ5ZJdrNzaQgUo1P1eB9wh5zNnWhanSL/LuYJlWazFxK/yopo/bKI5c0G0VVqaX4Ut8N9GXaKHT7HHRAAB/yoGriH5YwUp6wgnHbOyBWCFz80THGbrOzOli/13V6MCpA0WY/XMNHscmvfKWRQrmny0nU/OJi8eZxc7DutC5K1Q1gJRGHTpP2MC1CXeGJOTr0QezskHpLSU9Cm0jpvtjo9qQrxmYZM+dF6x+mLbcsN8As2L7Q4x7hIcm0MBX8U5zCphfPQaIDTrzqymmURRs+jlK4xiEQQxaZR/0pb8FYyS0x0BgZ7EfO+a1duDBYhY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(52116014)(1800799024)(366016)(38350700014)(10067099003)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y2mA2oNNBSJCB17it8MWCjsw2NBXfvy7ZBXVnwftNEucbXL/ngCsSd430KdR?=
 =?us-ascii?Q?wChp0A3jF8KO4tnWPWJSCTRX8I+FzzcnAv0dqcEmpwMbyFx50iPP+Fen8aUt?=
 =?us-ascii?Q?21o0u4XixXmLOJKQxQR2Vi7zmtaK2HVffZPCFC5kZFTjb/FijResg2OiuT1a?=
 =?us-ascii?Q?ATtY3QLTszulOgPwNt7EeiIs4I3rjtTA3fOdYuAsc+IhAhbChPJMMp404JA3?=
 =?us-ascii?Q?PCeVF+4vTgeiOd+HczNFTcQ3zOhYuF6ABaq6xRdkK4oWoopHXW2m1oh2HG8h?=
 =?us-ascii?Q?CnHjOJHd0XmROOnfHjsMmSW4kBHoAP+xamSLADeLRlQhqB6HgN52ZLcOmQAb?=
 =?us-ascii?Q?xrBqveGE3JjhBHIS2ZZPFMENTkeCfAvTfO4HO8hdkIMp9jyS0C8NFywzYJy3?=
 =?us-ascii?Q?ozsnyMMy364lxgF9BIHLaBj/UW9vgzFYcCE4n5g7hkhPUKahHvOIjgpPTKmb?=
 =?us-ascii?Q?4hXk3BS+RlAc8pOwVSwv5BwDWMfNssrbsVuN089sF/+1yJyWj+/9D76cRxTY?=
 =?us-ascii?Q?AX02Z6zxndl52uTzCRPUiNLHyD8mTGn8hLBajMWDzjHYcfSji0EpDvPNAYgx?=
 =?us-ascii?Q?nedRx0sZjFbr/YgQt1cEe/DFdLP95H6m6A+JXRF2gwp2lH6ocXwSV/KSQ0LR?=
 =?us-ascii?Q?lKI2r06embOq1+4yfRGjjvOHjs7tE2zVvF+zVJzv1kkm2//N46pSbRTn8G+L?=
 =?us-ascii?Q?IU/hNb5iUbalBrh/b1fzTDCrP+xnT1ZDQGl9pJJpHSe2xk0Qy6VTEX6O1UEj?=
 =?us-ascii?Q?Nb3wyRZKzjyW3CpwBbm1z7VYnKgoK7w88CdN5VFcIsKwiqlndNU7Z1TaS8jp?=
 =?us-ascii?Q?/qMGOFGcBGaOnqEWv4l+ezqYBI3bQpm56SmOOREor5eHsfxLoKnzrSHlJPjt?=
 =?us-ascii?Q?GgPmaN/DobpVfikkUncii8dtfU8w/j5X9LydrvdeX/dl1uQ8mRfDcyAXoYje?=
 =?us-ascii?Q?eEd8Osp2CnhTdhF8SwF+FUYu3ZT6pLaxPa6agNaWpjCa/NoeHAmzVVPKvF66?=
 =?us-ascii?Q?s+wNnrGgRzzfqBlBGs82UmviKnoTp3bJMhTER5waIO30zxeA9a3+65z8MWgS?=
 =?us-ascii?Q?OnrfnLS+X5xSu1K1ycxjUreiwATrDiB8rz0pypC4FWMQAzNuE8HnB9SnFZjk?=
 =?us-ascii?Q?fjWxrJPbwWDKUGDCtdmzMFK1eQ736QHpwx64j+45tVzjBOc1UyzBfq6uFGZX?=
 =?us-ascii?Q?PhVqF9KE3LjyFaznbnLj7em1U7mnc8kW7DBvGSzpw3zWLmRbKjLM08QZQ2Bc?=
 =?us-ascii?Q?u71ZJstHhxV5rNOBBCmiUojFFMbeAZWNR9t7c2U0oBT2yDfBD2snsNkiZwM+?=
 =?us-ascii?Q?3gaIbu6LH6EvYrFAOQtGfmtoUtKeSCcQ+kFqWlWCGsh8OOX/kUM1cGZC5vNS?=
 =?us-ascii?Q?kcI2//BNtL9Zb+se4U50mKIMgmhhH56T58hv6EtKxB1O/VdQh/UAcBKACHs6?=
 =?us-ascii?Q?ThgirLEtxf2f9ffzBGg5uqmX3FIJ+nry2S0m6hNSHVA14Y1dzvHTGGZf+KET?=
 =?us-ascii?Q?dDXF/X72cWZ20Dv3rbUGuKvDQfZ9BuVL0iOFXSOndITX+1Px+ENdlCeOvBZD?=
 =?us-ascii?Q?9zC58lOQo+Bm3FEv7ifdG05w/qYQmvGEAG/ZzxoBMWiUONLMuzU4akbzJYmP?=
 =?us-ascii?Q?8EuN5h3jbM5j8JC+s1xYxfb/K8QMVLl6qHfnIK0yX1V8JWfUxSBsX7is42Xg?=
 =?us-ascii?Q?xezY1KIhYnLrmPJQaYVTHWkFga0ovKzdEEfy8dfD3u52uHDFMJG844rYIaKG?=
 =?us-ascii?Q?lNH3lF5X8BmRtpJoMlSQ1puYZ3DNc7w=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8c33ef-235d-4aa0-2915-08def81a307d
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 02:34:10.0529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q+sezqQRwK5JC4i/tmLIFr5weHZZmWcZYZADW92pOd+zJdpFViuRlkUrMPr3hiuLPdllPWjZeCw499yN8dIxqvLzfS6Z1/0QZpGyrQATTTc8v73sTm7tD8UM7pP6wcn7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0998

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


Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2121.outbound.protection.partner.outlook.cn [139.219.146.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2E03EFFD4;
	Thu, 23 Jul 2026 07:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784793154; cv=fail; b=dfr+0yBpSIIS3aMSl3+rKwx1Bo5DMTDYNvDmoH2Edyc0o+X+fO49JZb8DkQ7hMOt6kPuxePJkDwpFeG5iks/sJMzQM4m6GjJk22QZLcY/uN8DJ1O5My8gsCYJKQftiDU696FsExKBXC3Ny1sTD07oJE6SR1plq5/b4gKQR0nmM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784793154; c=relaxed/simple;
	bh=NuOTTd1pkRIKOlKjxkzpMJUfODdvxOMIsJNZjG4ejkY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WXsF1FngcaeV+pyaPMRVZ8qPBVwtzPV9bo3ZhJPAnrNFRzy1cv2HJ2T8GM0Hy8Ak0s3AzJq+Bsr+DZrday4lQAofGzX2TGNpyckaxyzb2x7gQ7aam1QnC2Oy+Xp5JOy6O3Q0WyKECpPtXlgqrjlR7hraFv2C5v00lT3t+YHILFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apVOLBROtn/5sqAOO1rvBBBZ/4vozaDPvCmyXne5LFWfRw087csmG50twihTQFxMn015otJ5WaiiqHaoSmSWVkQsIOXHDPCCp481tVaK9cPGWVFCy4ugQqGuKJ4w+GeKp79jlVu9e/N7YW/5U4SkTQb0mRxFv9noisCJpNRYfYm9mB+modBzJtRlijwAteVkh7UvQIRQaIjUOMIf3fLvasMrY45Dhsa2Im5jyMX8epp0kisPKc8vxK3UtHdIynIkz751nYB+8whMY6pSKC7J1NXaHqmqdHpUPrWNx6pq1D17BnOG+Iaccac8GvqkhVXg9Mx5Ui9kGYiFliNmHmnfAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYeiqVioAvu2AAjmCUZfwu6UVT2OJxDF97usFNixLAQ=;
 b=OMapQb9Iu0SfPIZIY1wyTVPFwlCo6GT+h3zA8lFZSfOyFDC2//YXrPmlFUvzabnDSsJqNKOAMV5Jlo06RckPjaOCE7IsfT8ki+uHZLlS4ev9YiK0LwAwD+JtkpNAS8x6ravvZ5ZHT5wlH4DJFF7zo8D4jO74OTdWeDWWsl43DJRjDjrH4iiM9GtihJXtyvA/tjmIZSUUxAF7WMI0oNjcWg6ptVitM93BUGY7//qP9q2u3U30xOUO561VUubYgtyGN7XQZT0Qq/cnZzz5W0QvHytDUdbWeNnF5ZsebsztMjWA/gaEGlvtHTpazzOPykPSQpsNc+pMwxxiwhiD91DXjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1126.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 07:52:15 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 07:52:15 +0000
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
Subject: [PATCH v6 1/2] dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
Date: Thu, 23 Jul 2026 15:52:05 +0800
Message-Id: <20260723075206.3032-2-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260723075206.3032-1-lianfeng.ouyang@starfivetech.com>
References: <20260723075206.3032-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0013.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:5::8) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1126:EE_
X-MS-Office365-Filtering-Correlation-Id: e452ede5-1925-464e-fc6a-08dee88f5036
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|23010399003|38350700014|22082099003|18002099003|3023799007|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	hywejKreJSlVlMC4JxRToE9+sz3JgMbxxlm4FeIsjZfGCnuHThkF7tPB41a9jgsBVMfkypxNB7MTaFgn5q9uUIIRpuDwTt3fgALyzX5r9iLJtGefUk3WuI2C8OtXUhbFzeUVgVkrRzIiB1UsCnb1uaqNLY+fHwWP7jjFdF11iLgGfv9myO6PBLkVNIb8/2KGMFTqPa3sJed3lLLS7qW7bzexrxHaWPOGJ2HJfZBF9vvC48TiSL/FHV/NCacXpXv6X6lax2+uFtISmPSmnGY7vo6QMy5h6kNFs+NgamZkW2aLwGfWchmdmnIuDFcdtZT/U0urEPSr7DR4Dc500V/RJUQNWb57U8iDPgAMKkEdJDxytZHQ6M2uqTDOjiWZQPdPsfpQSueoD7TGkVM8ujTQbLXqI1DSH3z/XLwbNTn6GTWLhhbvzmhu9rmKK1TUnitjzufq4rUB6YpAjij/Gu7E1NykSG/MyyaKXQxn9si80JT93B0ejcRExVlO+0r/aRMB18XQNn2cbmaUz0fIG/d1bj9tb4uuRk4AHWt8Fp8TJzow5my2j1HjeJoDGUXCUGTs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(23010399003)(38350700014)(22082099003)(18002099003)(3023799007)(10067099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rQ5CukNSFsa4us7wif0lMySKsGGb2alfFkJWWJUo3Eu1qKkg22D/E5RN3T0G?=
 =?us-ascii?Q?1MT4x4QpRAUflT23F5Cd2mdZj88H0M5wFsjAUUsSqRGNOSoArRLwLqwVG0Sr?=
 =?us-ascii?Q?7WZKoUnlCS4pHBbeW1+Yswri1slxBQvXiOAGIscWybpuoydfqIWvuS1p/DtF?=
 =?us-ascii?Q?TjDlEeoqbxgvN1cl4obB6Rz4m7wOk1ae+E3kKdnbFyxajsv3GXDQLWA2GC1Z?=
 =?us-ascii?Q?9FxNHb3zGhPe2vaR8VJTA3ScWtvtcwVq2AdqjJlOVpCGPEXfJSJaE92j8Z2T?=
 =?us-ascii?Q?AXvXkuK4YPAgdlY/hbgIVqC7EkXNHXzik7OBCPszxu0ueJY+o45AWQinVJ3v?=
 =?us-ascii?Q?9RAzFg7OOBn5c6F0orTghAAwA/9+RtiMDnY9f0XiTS2WkqmB8xo9lLSQ+brL?=
 =?us-ascii?Q?5r5CXUe1RcOtWh6chFke0O36fMdPn5pgkKJNn/rvQmKQd3aQIPPo0JGqR3/h?=
 =?us-ascii?Q?W4jGpmWOEjAOYJHFFKXyhLQfq60UU1OOXVnGsA76nEkCBGtJKi+fA7+y9Bwm?=
 =?us-ascii?Q?wulHn3OzpE062EkikEepVk3ePzSEItTrfPo5VLREy6/fQvBTwQfbCBruiO2a?=
 =?us-ascii?Q?0AkSiG+HOR0YSFSQrKqhoHZ0WC7BikjhXe73X0Bn4Xk5BDcpz0z4KRNnVTEh?=
 =?us-ascii?Q?HOLLa7HWAHneDj+SyLHJ5JaptKD/1fyoKxF1VnHGcyJZy7OieRFKO0IKuVy/?=
 =?us-ascii?Q?+puMRU3fBozfWSDkh2qTeskn0rlKYqfNhUUoqjBDgFu8Aw9Pb6nPT7E1GfLX?=
 =?us-ascii?Q?3DQPoLngfoxTY0w+HOcMmANDIsLFfaXQkW34j9WFIRACpmGsZugsQc8F07vB?=
 =?us-ascii?Q?Ki9iDinZsTzHxiUmvDUX72tunj6hwZuE26Mfhp4MozyYPFGso3ywvU0g7Zbj?=
 =?us-ascii?Q?pooSzjoAe97ly16vhipYV4zH0dzii+Vle91Y7MQnGVYzz1Osa1iScuG2W0C0?=
 =?us-ascii?Q?ttbQFufGEEdudBVAdxRZONWxKlQeXNXIhjuuv+D9izT6LsXJcf2yN3B2S/9t?=
 =?us-ascii?Q?scJPf93VJ4No22I68Ij82D4qyVPi7REAKhextvddayw5QHSbM4Pi3P423kl4?=
 =?us-ascii?Q?h1dX6XM+gCGqfIL9jjCDAhdKucQNlAfft8wisn8Tw0EYOLDocF2uBBCXXf1T?=
 =?us-ascii?Q?WjRiA7WiuwSz9heLGV7mLBueYdAp2PBTVElHLQB0uMRDvNn6Zuzm/qDLxA2l?=
 =?us-ascii?Q?n6CjNg08IUadLWrEYeEDruvSf3Cv4G7zVSPJBNw9dNHzg8H4ManUolbPOmau?=
 =?us-ascii?Q?O45Jqx1anBqxyrcBWF/CFWA3x9IY62pw/Cft9qxloSmZ4dvEkVVDyj3Bswia?=
 =?us-ascii?Q?FRotOgCWbUBsvin1jReTVQvrrIDLbPrinXBcI2nObLuZE7+0aV6gcs4SOeXn?=
 =?us-ascii?Q?I41c9WWN37AlEgHKuJYWTa7pYXbDUZTh6nErI8tQA4pDQ8S+rSFH5zlN2HIm?=
 =?us-ascii?Q?FpElygMyfWFA1oZMftzgzAVOfprlsIOoCYQh8lGpqnpgsrfRSTnTJE9xlBLP?=
 =?us-ascii?Q?mo0gzShmkKimS4oeTgYdDWIzNqxSx+v52Ny+8DL7VebF+kU1a320p2Q/07WU?=
 =?us-ascii?Q?OXUfVlptIDHLTzuWVN6QKKiFeAaCZy6FtCcnc85EC8m7CEol3kujVxJWxQ5n?=
 =?us-ascii?Q?MXtlMntexavMjHqZobmE8HXT8Kxwi+ygtjXEwALEt96/K3gPvx8ZK/qOSKdP?=
 =?us-ascii?Q?eyAldHm2CN9k0C/xzznye7TJcbUgp8EjAiSWuflmuu94A8vHfox+PF3tkRHv?=
 =?us-ascii?Q?H+DN9MC6bKJ6saxtkOpv249zaz612YOtOGia9/mSAf0BonycDuSQ?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e452ede5-1925-464e-fc6a-08dee88f5036
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 07:52:15.7501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tEiceIrsYL9cKh35DBZYyO44vONZzYgdSpzw3VB6fiXKoutNwvfkRvSrofgPhTfxbYUd1PSMRmp0Nsyx4AmVLWuDztjCgI6qvdzbvR+wt8nIs0+I0XGktPt/M7IXX9dn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1126

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


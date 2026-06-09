Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2102.outbound.protection.partner.outlook.cn [139.219.146.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF503F4DDC;
	Tue,  9 Jun 2026 10:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780999931; cv=fail; b=MqHORe/w3YFspO0zeEkooc6xNx4NOuXl5pEwLx5+Yxqwp7R8oajRpTAsYeEbU1SOVv2+D0m3cVnaV/3x3dE3+JpXyww807yfTx2fNantPBRBCHSvmy+DBdl6Mbr8CYDm5imkADTA5+tZxZUvasLnZISJQ9OBs93bsmlzV9+PEPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780999931; c=relaxed/simple;
	bh=bLKDl4hOIjZ+2DCzE5uEv6KviWLTWSYGdlUyjh/j3cU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hfCo0JZnL1CXSFFRU2N98dxB6GpmzcfSBFAko5nD9vLF5qzAc1/4dYkJDjL2R0qyu1itOlm9VAhuvKdOOqZRL9m6/FvmyXW05mK9C/dC9ddqHrfRcS0VXc3vw/8bCILMhyTsOqMpNDUWxBIbmTVZnQRMFKPs8ICAt+vHf/StHPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7OhvLuZLbJsCdVJHdLkGlByJduico3i20Z3hCeX6257Mz+C3GYljeW3VelQzJuYP3+Jf/yyWSpqPwzJiS3jZMPJiJw1Zngami2z9pA2bxnsRtTkHz5nMbDfB1psem4ikVvg7pgvO/afZT5Pzu9YWroLEpPNJpKbHg9aEwlvPApZzY5lFyceJQ0Nu4rEYRdENEbiyiX0SVGWOa2yx64Br0XtmgVzC0XcxKOCbD/3CQ15X4oJy5n7S84CY3h8FMmF9F9oleBXos3UQt19CXWGjOY92yND/s45+l/Q76Qnfr9orFm7lPaWrV0CDFxgpLc2gM1k1sv797nQyctbf0MrTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7HFMTat3DNjBYwsw9dVyZ+UJisheWEO+vL2B7KEgpA=;
 b=hkLq55uJI159Wozd/8+Ha7fVkM+sgJuXVDaKVJWbKWlDKnBNA49o+RRVVW9FqpdXfwYWHDtyupZuyVIvBrjk+4p4xF3xD1lQAX8WiNfpX9X9Ge5msHDAaJTFAAyHbef5SdYZ9TEjePlh3A1HU2s9n4L1cLo5bQuECq+ihfhR8Q5vG0PqtFKkT6kpZVns0E1PRQPwNtxJ9uXtI5YNO93Ox+A4ETjSfWtpjJx1HL5iNn59QJz/gvU1PjRzHjldhwtSci1k6E1wkoAZZr/0SggIjgjk/UH0e6u1b8UEUWNHoY3D5bGLKD1AmwnVrQCayHit5XJUVgm2sEAT3X6ZZuiUSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1094.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.15; Tue, 9 Jun 2026
 09:57:34 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.21.0092.014; Tue, 9 Jun 2026
 09:57:34 +0000
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
Subject: [PATCH v4 1/2] dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
Date: Tue,  9 Jun 2026 17:57:25 +0800
Message-Id: <20260609095726.160559-2-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260609095726.160559-1-lianfeng.ouyang@starfivetech.com>
References: <20260609095726.160559-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0013.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:5::25) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1094:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a9b50f4-ce6d-4911-c8b5-08dec60d8787
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|3023799007|18002099003|22082099003|56012099006|38350700014;
X-Microsoft-Antispam-Message-Info:
	ZjS/+SZwpoxCDMSn65Koe5fN9hDq3imXpqZ6SLLqQzXCyk6YRrLxeSlr7l/Zcu3vS/SImcOFN8RpAGIlawq3bmEnQyW0ASkYJ+idxBngVsoZJTSUBWfkPaQWXJeV2QQ+voPz1LmpA/lCvktleIBgu6m1kwc9sAkAeQl8D8PW2zNRTzNpd9dgDbBaDqIFg4E7Rqbiag33PiNR00M8RpbtbQ8zxGKx1h+t3TOhNxqHBwOLP2ST3r9s9JvkbhlbeDJvLUXzMsCcBxsH1aZpDeVlTUGw0ZlZfRb5GGDUiX/qZPp+tUCmXOvQjOWpwuGGPqfIrOPOMBEdDIYgf55+kzLMzTemHzU7kH9LRXDDvL0xC21rL0XU9oMhJXEL8Fdi3KTkqjTu/VwAK9gORPRF7R8xW1dnNoD6aPVrbu/d9zEWvAA53PTCXDVmEP2bLflDCIRQBE6OficOrokRmcHsLMcwfVTZrGItOCogLEKge/g7/D8WrWaEtUiFapVhQ2IPCEPzo0IZgpEogYDKTZZV0DqFFDvletzHH63yG9aVGBk/mlU7FM+6ZfrdA9wSnqtKCZCf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(3023799007)(18002099003)(22082099003)(56012099006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6HQfi+/w2bZfcC+JphKuKWzNrx5wJp8NZePHoonuouFWsTvfI4hFLd6Bgb9Q?=
 =?us-ascii?Q?epXuNGKA8mZRbD973FhvWbZ5nxMQj7qatSmdfb7Rg1rV8muzm5OaLQM8oUua?=
 =?us-ascii?Q?74e94pZy+cZa1DRgMu7LUzCQ20KNAaeqYCJgNhg6Bx/ABzSGNzY9AH8/8NJU?=
 =?us-ascii?Q?S6jOq+xjyFPUHR8BGvabe09xZHS+4bMKzx+lypmjk1vVuRRvSV0sE6T23Xw8?=
 =?us-ascii?Q?n2fjJcs1SrsRklGXCsriyDNQFg2ynQFt4uVK5QLLuz+37rqY3cq8O4NRb+iS?=
 =?us-ascii?Q?SIMPM5x2ZsBp/h7ZlSRZwR6ewUFP4I78kb5FqL/6BCjbz6sjmJrdB1OkXRMO?=
 =?us-ascii?Q?FJPHlSzdSlYgOKpPfPxqOYiSguPW1u9RfSBa43o46ClgN7cT61dxqB5hU7p6?=
 =?us-ascii?Q?rRc64V1rUypreemUoVfsPqfHjovCIwdVSCvpM4As5w91ZK4UoIpSr59h4ScW?=
 =?us-ascii?Q?dSySI736TXDOWKDZ/ZpJc0CliO9Nyuialn+ZuoNt1Bo4cTEPZjtJManzUSHc?=
 =?us-ascii?Q?FPND+c+I14wHQGPrWhJ2jYXQpYBchrpzFiP6WKEYz6g0bsL1FDRUNni7ZD3s?=
 =?us-ascii?Q?NR/NcWH1Ns1uKXWx1icyvm6fXTW9Pe0R5NTTDz0TO+XrN3kjGJ3K8U7B5NHk?=
 =?us-ascii?Q?bxFF620nlqOqvHvXN2b1fn7J3AKDoC4lSAXHzz6HRUAU2F2CyoqUaAQ9FKow?=
 =?us-ascii?Q?XyJVQtf80Dyd5tCeRzMQC0oTSA9mBhf4CLMjwauHSchTz/AwSii1jQOoJmVJ?=
 =?us-ascii?Q?amMhx/RkFBosxq37DNGJxEnwQ9vFXTfcGxsGiU3sIBrQ88hsu2ZuakZQhenH?=
 =?us-ascii?Q?akLW2nIN1SiyIHmE+n4VDNyLR/YzqzZ4uEx0l7sQtSpWSpiZWuIBfSACHXGM?=
 =?us-ascii?Q?hbIXcYMXvSDXOhabrxcsxQ720Pmiom4qISgdfECyRMbWr2ooEaQ5ZEhIaInR?=
 =?us-ascii?Q?pHB2tOa9zTWfCzFr8HisTGtX3GSDNeXV8+wz+1aC/NYUcyCNacF3kK15TnT+?=
 =?us-ascii?Q?YddmJJQ1bd/gndC2Jxg/JWVRu3oj+hKrvqub8qVlJaM/HIRILXV6iCtUK+3b?=
 =?us-ascii?Q?i3gsq6d6Boi2MsRWGtqghZs0laM50g3PomYMMCHRZZPXpPw8igSEBTKVUGGA?=
 =?us-ascii?Q?1/m1jgLF5eba2IqvU2DeiGQ0bJhI00Opic1paggAGXnqy8nKlsXFYZDabKa9?=
 =?us-ascii?Q?qIWcI+sE+QTQuvL07pc+DmdeTGGzqpjaGqhwjlaH5qCHLv/R2PSrsZ00leHn?=
 =?us-ascii?Q?OT8h0SQ/KWN3eon6HacYms4KZHGqB73UcX7Lw2YdoiLIOK9pjl/nKUfH/ayB?=
 =?us-ascii?Q?k516VEh/ABuJgQKLFUR0Jz22bcQO6kF5MAZrKvTDlirzo3YWDAApnbi/xZ3O?=
 =?us-ascii?Q?kCqxQlDdxMxrxZ5AdRIRCU696EHUJ5IdJki71c9fyMEYfHNG109Iw7YznZ+O?=
 =?us-ascii?Q?uuG+SXXYOsTpvA2OgHqQvvu8W6tq2KFcAjdOmpeSIzJ3csb3a1W6ZR9TjYLN?=
 =?us-ascii?Q?YHYkijU+dwIK8uc/gN+WCXMWammoFZLUMIRIq+aGCFIgCKA0C2L6fJSTnTfl?=
 =?us-ascii?Q?2A4DQpEpPwz/Ox/vyk6/QnZMLy9q8KaOxqVZBbpe4j4kd6PkidfAVpEoT6SS?=
 =?us-ascii?Q?FaisNKP/cQfOgT6u1PeYS4GyLPFSUnOvOqfpIiC6hDXYi4NE5YTd2aaKRqVw?=
 =?us-ascii?Q?hTZVEMOZUO/A3vwhCU5c1btX0s+iBMO4iMJ9NoA/sElXHBahe2u+/In0Sfvf?=
 =?us-ascii?Q?gHktMLGFZltkBXJtR9HBg1hSl0kR6IkeQNCw1ob4u6e//m8u3pYA?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9b50f4-ce6d-4911-c8b5-08dec60d8787
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 09:57:34.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ykybUV21s31mEyPqO09iaxN0eq7+lJpZ748Ye2DE2C4ELKBqP8sMTI0pjEzxEQ+3kyJSEmfItHPJlEWT/kvyixkP57LhTTVFREGPvo4PjopLi+selm3p0iP1zNm9YXQa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1094

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

Update the StarFive TRNG DT bindings to reflect current SoC support.

The obsolete "starfive,jh8100-trng" compatible string is removed since
  JH8100 SoC is no longer supported. A new "starfive,jhb100-trng"
  compatible string is added for JHB100 SoC TRNG support.

The maintainer entry is also updated to reflect current ownership as the
  previous maintainer has resigned.

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


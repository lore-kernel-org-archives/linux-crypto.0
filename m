Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.128
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792721594;
	b=4o7lWFrJKEywUVEbVmHaXL7i+QiK9CM2uCM6dWo7XWoPPQ4FtWCSK3wpcHQGwdVZHQHa
	 P+WbSEAOqTGq8moejSTeZRjR527SzdFFkeujbw+2c8RE6z63zZkV660sTy277Do5smiQB
	 9Lv8+St2AWvXIo8tO87zM4/xU+tpLzh+uDO55WDk3Q3OTelSv40D4ZK/fJ3oJMF2UN87q
	 K/g96OGZsf9fCVty/dbb4I77jOY2JP6N8XdCQIS7Zu3y061WbxoE+K2JPR+2T+U+gHqBZ
	 FIzjbcJg0etd8Zyzzzs0snnjqBnoqF1V5nVjPG2YgGuBc3Qh3odNxE1ea9LVHiB9ZCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792721594;
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
	bh=5FWWhitQ6kVzJmpYX2BPmy3aYChlp2fajuiKwsxjcZ4=;
	b=NjRGmF4sVSt78C3wsgZHnuLTO/GnlsztxnYy96QbpU/PHwcK7Di5lTRq0JGw9fEP0F0V
	 ihpIQstVuGA6wqT2Yl6YMyEJLj+PiVf4QRVXR9+jHSTzXBJd3GEAS8e16Bw1TaRNdCPf7
	 E+kMcbgs8VR+I7gP1dsoLiJToLK9ZODM1eho0qh3EsmYAiuDIszrR0tg+zBXqXtOvfDyR
	 jJA6I3vAWjuhTg71Urvbb6lJNd9jwlUyYIAnfi8mKRpok0I7g27ls0R7UhC6HiRaH5xXG
	 AytTOngz6XjvnE8pmnEOzxTwp5K1Tba8YzSO+ymK7Zt4hwg+eTIOZQWBDUBRycY53SQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.128
Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2128.outbound.protection.partner.outlook.cn [139.219.17.128])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752F3606A33A;
	Fri, 23 Oct 2026 02:13:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 752F3606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3Hwpz8Ld5U14Wu9gk/NPO4AsQbU+TSiC9ICP6wT6ClNxKkmCrKId3fUuCTwGgUcEw/lXEOmpQbDh0XD+BaaQ71G4uWGGqZwvzxZV9RqoHoMpaATVdpIFsTyMIvFUayoWttaUTjXVVxrBzpDH/C0pbnCsObYiVXzSZEYIubV07BTJx3hAM06k4IjtcVbgFNaMSuTt+UdGAOWtnXskkT144NuVc83rLD5cHm2AmKSCBEpSpQcMEGeAghMjNUDscXJigG6FzPNRQkxqcA1AI2rAPIxXLFHhFPdTPczoDi+0DXzAmMhqldV5sGDFoJsNxrePNf1v0VhQJo9dD5Yshe9TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FWWhitQ6kVzJmpYX2BPmy3aYChlp2fajuiKwsxjcZ4=;
 b=gvB9P9dNxaO7P8/j2u8rZqb67MovKA2g3z3jkeD9ZkpPANEnLCgdf3BzdVMqnya4qcFc0N8UAWuJhIkZEvAz5GXarzGSi/FCeGo+iN7x4ISYxeaEvFWwctKhrFojPb01tEaWvLjWkQ3J9Ya2gj9IEQ0NZBBCDNB//vPJdOyU5b3z+f97LbI1ltYp7XWqkan4TV8NZTryvH6kP6xnpbhwGBINVh6jCX1+b/4L2Gw+97qT/hUc6JbAHbAxUNTX9OuDGSCt+YQ56XXN55u2/6ZRraKvmL0O07C+g5hClsWu+n1D1FwnaFMV1cds3/gTWnwVnR+isI3T6EhpQO3ICodNBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1303.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 02:13:02 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 02:13:01 +0000
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
Subject: [PATCH v10 6/6] MAINTAINERS: update the StarFive TRNG driver maintainer
Date: Fri, 23 Oct 2026 10:12:48 +0800
Message-Id: <20261023021248.3763-7-lianfeng.ouyang@starfivetech.com>
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
X-MS-Office365-Filtering-Correlation-Id: 59b2c0b8-6b5b-4e20-8127-08df30ab29e1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|23010399003|261022105027099003|38350700014|56012099006|261021121427099003|261021123027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2u0VNsjr+o7iEtHcDUuDnjYaoV8N58/B0nazd6dzBGjUlpBZva3ArMwmTyG2u9xPM7wP6qai+BCHYCqJKe/R56K6XwU7pF1kQkulOXzxUi55cvLQ8HkaWEqrwNnJfGhta4qlh4P6pddMsbs/JdepbCLYK8b9ntNqtaK8A20wSk7rGpHEgwMEH4X3Y3uHxz74eJCWj1+1wzubafmBmufE/4qKtm6QB1u+d0mUZeqzNK0N3TM+U9//bOlT5ufZyGWKoll5K6PNzwn9ixJztEMY4dLD0nmE06KVt5VOwumhsSz3veGO+MjcByYY2sx5heTrYJYM85t9uz21VspEK3ajtAdfesh3uoGGnDQdMhzSoz2Mr1flJPzNd4MEWQRWQlYm1ryoXcd15rousdUA27rRNo/ZFMOqN2kpOQdHRw7NGi8JAQPDoJx01Qcb7IAwVYKCrIPLjvgmwLsC4ujlpeQt8QEzg+XHAbIt//YG0AjTHi/LJKB8oridGr/viKJZvXrnYh56ocYed+BDjIA+2+JPeLr6KNXtyYMsRNL6mnnfnUBZ4amvoeT3T+zRCdOyxVtz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(23010399003)(261022105027099003)(38350700014)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gxtEmnK9SVB8zziEaevh6pXAoA6dDPEppbicq2zV2my0krKZdWCaIsE3JKPp?=
 =?us-ascii?Q?HKjM1LZg1qEzJcrifKrjC2hqf2mjubMJtdO3Qaegvp8z1g+yqbhJFofu9j6r?=
 =?us-ascii?Q?pxHe7fANs1crO4nvfUSUWWNSp7HFGOASnwKhAX3ElT7EY03jtHxcPOGMYv6/?=
 =?us-ascii?Q?sYLR2n1flBqEAYfgW0aLdage7b2UL6vo5FL0AZnyc2wJQ+FZb35Q3zgaNeP2?=
 =?us-ascii?Q?G79sWBrTXyL4SExgrTYiN4wIG1mzfbwfwGw53/Ym2QPeugCfn2zjiql8SWEn?=
 =?us-ascii?Q?tpyte/eZev2glpYQq2Kufp76Nhmjzzsv2o1r3mxdSI1QlsBRPaWxn1TFLV5q?=
 =?us-ascii?Q?h3G71e1MGETvdVZPymbQj/KTnRywgOVdoZ9Vese3QCnL4lhwSdchi2hYWSly?=
 =?us-ascii?Q?E62szmiyjDcRrluYzDwAanT4AWU5AyrbP+c7xURuhwQgjNPNMlcYucLoU6XK?=
 =?us-ascii?Q?maX9ld1CpbDjobjGrP0PfdP9kbDb5mQgPR2qg5Uq4bN4XksO37UxV0l9azdb?=
 =?us-ascii?Q?vBl+7e0w11uKC1kqXmpBOVf2FEwlRqO0v4RqvcjfOr4uKzkR3yvkXXUVGfjH?=
 =?us-ascii?Q?Ff/NhEkxGQ1mc3T2tmVqrdmYor77jPz59jRB93LhmKxQumFPF2V4OfT0URFv?=
 =?us-ascii?Q?M6q7qbewynkcEQTDLuyrcWnhS4sd9zPT0jt+VlAoW8q2jaYaKE6MHHLbnzfT?=
 =?us-ascii?Q?ISX0CERdRDyzGU1/cSJzkVc++7g25jH06kYEGPv10bKflEavgfJHqA6zrj0a?=
 =?us-ascii?Q?qJsWW4QT88yTuib9CJGZJS6aKjaMiE2WbB3GPix37NRNwEzO0QKoO7bUyX8G?=
 =?us-ascii?Q?llm+L47XQ3fW1dQAQf3EP/92sJodZtMBlT5T1U3xCQK2sG9g9RX5XAUmFjhz?=
 =?us-ascii?Q?NiJ3QWCcX4Y+6ib2dKCApW4MhrKJ/ArRva7vLqa97zJEW7onPFsS/CDaahjN?=
 =?us-ascii?Q?Wrt8tUaq5NSPpwpLjt49WrXi3xAJK5ImFKf4IaTacwvg1rR84JbVeHq5aJnG?=
 =?us-ascii?Q?IOMdB5xq1bgoaFWWJpuQyKQ9h60R2hhiIqv/VqQwRXK1cyQnYnAiOi4krbzV?=
 =?us-ascii?Q?X9Tbyhwnxg3heYA+rwRd2+IE45ein8iRu2SjjZwrwKOzZcZ577qn7TyhJcgR?=
 =?us-ascii?Q?E15yyI5hkEv4dik7oRZG6HGmY2gQfjFK1PxFDHX7l9mrsnPOTAaMPAT7t4hX?=
 =?us-ascii?Q?+15kbbkkR1QxxCLb9HY8zY0CC10UIGDQZjTU/iv2O8nQ29qmfhxZYxoMJ63u?=
 =?us-ascii?Q?aGCM6k7vxdvoNt3l2XfZ4Rjm8QetyV7h6eYfLYOVxKZoXxliw4nBPqYYarCH?=
 =?us-ascii?Q?LpntCn/ZWInIdnBvfjxuurSW9cMeLvKlUmwwefiVq11SNh8XhZpTIsPjMTue?=
 =?us-ascii?Q?tMJu3Tw1nm7rSDv8k+stKIiXx4HVlfpMSHVixrvmbRQ5fJQcUDhewcz+zuF4?=
 =?us-ascii?Q?16S3YdU5oA6Yqj21uJGmezf1FESB/ABUMlqTlTnshod/25/CIun0nCxwUGLA?=
 =?us-ascii?Q?npH1TgEIoxFqf/eBPCmZAqUbcLoUyhJNw3Yjfbjfbdx9PJwJ3AEGbOwKV3RA?=
 =?us-ascii?Q?e+zMiBiRNFWQlLZ1GYlW6sR8FMG5LOSUTjXXcO00MP9sQVzm//nXdbav+QCp?=
 =?us-ascii?Q?wa0FwMEZ4q8gsntVfx1X1sjXuawKYKWZxfXw1h0h2S5Tsy6bCnZZ5f3hxmRK?=
 =?us-ascii?Q?BCENek7LyAHQPdfSFJb8x/BXZ46hPzTHRbXZj28Pj+bSyCKRGgYJrZSzC1WX?=
 =?us-ascii?Q?W/jcc6CDZENHfUvQgkUrws9Vpnom2Ws=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59b2c0b8-6b5b-4e20-8127-08df30ab29e1
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 02:13:01.1657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZbvtN1qVCNbI2hXMqtaFstSwU9T4UEhnjuJ9b6zAdBxi9MNYae1ZhuZJZnFqBFPmoOBMX0/axunYd9z8ID9Kp7WHCecri1Glnhr9sPF1iKfC1qiwoJOd0eWkh6cWumx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1303

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

Take over maintenance of the StarFive TRNG driver from Jia Jie Ho.

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d998ed051a8..5211aa88048f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26239,7 +26239,7 @@ F:	Documentation/devicetree/bindings/perf/starfive,jh8100-starlink-pmu.yaml
 F:	drivers/perf/starfive_starlink_pmu.c
 
 STARFIVE TRNG DRIVER
-M:	Jia Jie Ho <jiajie.ho@starfivetech.com>
+M:	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/rng/starfive*
 F:	drivers/char/hw_random/jh7110-trng.c
-- 
2.43.0


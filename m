Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.95
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793691196;
	b=Cnsw/OvsvVAyLn1tKET0V9P2Yb9vpB8UQzdA48Ocdr451pF+RnnlxuuF5/KuNl6xYWE+
	 wFXx26hl2/WS9RMQkh06UlDpaGh1jCDNBxQvgfTud2mi0cB7g4yvjHuPo9aYsI8kpnQBQ
	 56MEqy4bTzkMz3G3b9JSSP+GIQDAApymhIaoGVVGJaLChwdZIvutWenEwTLWTlUgv1keI
	 4e8sNfe86lGoQg9/R77VvZSkHmT6mCqJOPazf6+TjW1kkyGrZMkyUnWWGGgdjUnoTctWt
	 t/t5uwEoQ4RZ1qNZR8BRVwsyhJmPrPeeH3BoArZgI7fowKcSn9rIKPC3FT5D5e9VB0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793691196;
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
	b=UcQjdK+TGpUVKGKEV2oIxZj79iWmwdur7DqVBgkgwmGc+RZeL+2uJmoqKD5smkPpXcc3
	 j/IdC1zrpMLE6w9vK7P3fUFmA5YS+nHxJoRI7EEEG+tUvcSXHpNKZVhZ3IVp8uVWlKNGf
	 kPsTKg1Nw8XHe43XDgJCMzku8jcX68M8/ms+OOJ9lAKHRqdpFB1ONxWJpkhkfz4kW6V5c
	 bBps/XDfxpej5uNshDUTd1dE+wVeF+DDua7lmYx/y3gwv8r2nv9JAAZefLajRIcZpzI8k
	 vyvlSvwe4QEMQGB5J7PQMYtTTtMauE5GYhBZ4QBoy+Nr3ibvYlcJNc/v3DrdgQJNIJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.95
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2095.outbound.protection.partner.outlook.cn [139.219.146.95])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3347606A338;
	Tue,  3 Nov 2026 07:33:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3347606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fS2cPxvjmgwKlvq3o/8HpTqieyd920Kb/9dCdnt7vW+2C+VDJ4uNdMS3e3JGZV9MtxFd4vRlUwHZwfgs22qAtCTvvgSGr/ZS02HaYBN/lrIC1rRaJixZ1emTSr9JYdYLo7M55i7szFfYxvO1S4SY0yRQgvprCnRZluQ6u6RqNo+0GaxRn8NFNRcAHxjEX3A0fPX91xQsTESgAbh28XIZQGmf/ptiwT/TOpUn5Rq9ifB4i1t1RRdbYTKOWvyAemDcptcN5uFYhCNpfV0YfUuzJhlPBpoo8stAzv4HkBi3hWwM3JMnSZL0AOmkDtc81SUd4v/a6kNxomiOmmil5Y62sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FWWhitQ6kVzJmpYX2BPmy3aYChlp2fajuiKwsxjcZ4=;
 b=FydtSIbEVSF9XNPCD0uYKpyjOFS+rYDTH0vIuR3fmx/U6xxmtS7+YxhQ1zSQiud3lZDSPp769I48eNkVAaQEUyQQh/Zcjx5/2V+7yQd+OfqsC1nFz3rqKUVcDYjvQZZZk6+7AcXiKHMWaz8eLeLa6YE3RmDtrHngoglwY151+6deN4heCfWIGi4PIGo/UruQHOTni3drvpqEBRoY30L18URxRtsx6dOxt5UF69JDO8HvhuVsm8DDkK/v2MQUhpgr704GEbuyXCtQKZGc7LM97qnB5IGldsdvVH6JIaSjLEZp6rhqfdeSaUX4RNPkPtkZUE0nlQ+IfugLs6LtjiZb3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB0999.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 07:33:04 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 07:33:04 +0000
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
Subject: [PATCH v11 6/6] MAINTAINERS: update the StarFive TRNG driver maintainer
Date: Tue,  3 Nov 2026 15:32:52 +0800
Message-Id: <20261103073252.3028-7-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103073252.3028-1-lianfeng.ouyang@starfivetech.com>
References: <20261103073252.3028-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0008.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510::13) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
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
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB0999:EE_
X-MS-Office365-Filtering-Correlation-Id: f63711d3-39bf-4f53-cc3a-08df397cb27c
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|23010399003|366016|10067099003|18002099003|261102123227099003|22082099003|56012099006|261026121527099003|261022105027099003|261026140227099003|261009223027099003|261028144727099003|38350700014|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	ZwHSj4se27l+qUnKuAuRGXwqsKPbK4VRBVApdOJnK9FXic3WaK6E5BxOqNm5A782jKsH8uE4uYmytPGeAV9+O9dWHMIg4oycBNGpvHU5aHBA5UW/JKg93ichzeDDDg2zKSfGuhaEgXqZAoH/0qpWTWWz/PSFx/0bwA1ESQ8pbucLom3fx3XxQ4A+byd4W7OEIYAthw/i/+0cFdje5d5wZO9erR/OcJb9Jh6PDt03A8F2JpGLbAywVevfrP8Do3zn3eUNsEpR6YkZP4ittNKHQu22DPW64lDZkw9i8rzxAwYQWTbU7RRHqVEYInXt2lJAK8QmSgTPfAQKfvJUx0rjHKlwW3H0fPI+bf4c6qIcKnfuTzrZpCfP/vpXoPT7EB/U0pJCVnwNIdJDGyR3AR1FifDmEj0o1lV3g35T3myi6smrHWCZPR2ZXk5E95Y6zgdig3yGxs5Uap6VrAk7jbKKjq8Fu0CQs0e0jM63Yw6XMdGqtX8dvzCom1fAsFeuhsi1M32p23inoT7PD3dWMLsZuvkFhdpgbZe3Tt4YGH28+pW/A/Br5GjkRXr1FAPWVslN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(23010399003)(366016)(10067099003)(18002099003)(261102123227099003)(22082099003)(56012099006)(261026121527099003)(261022105027099003)(261026140227099003)(261009223027099003)(261028144727099003)(38350700014)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZFuP2Re57bevAWQNsD+ivAxEuBEyw9nF31SuuJH8lR5k3vRdWR2YFAs3KU8g?=
 =?us-ascii?Q?9a1ixVb1uUjstOXAKWvCWKgGBeCR0ZhlmW8v7TFe5SI7XkViq/O50QR4QIwZ?=
 =?us-ascii?Q?CUQLe5p6m42a2q90ixBI0XyhTh8JfEsmPCTqX18UPVejSaYsZMDo7xFkYlwR?=
 =?us-ascii?Q?s7NL5MFUD44qfd+vDxyeuJEfjub5AC0yV/5Y/TgJg7A5q/vF+jDu9m0qjEh/?=
 =?us-ascii?Q?RwTpJXi3D5vXgy0jN3mxkHiBW534GWro/bq8A2ey4/0iA/mu5FHhTWIAXx58?=
 =?us-ascii?Q?Hc4YAEfAxLGTS0vXGbj4Q6OW0JyThioa0lzgXKidVo18rmO3YzA++jOiXx42?=
 =?us-ascii?Q?gm/vrqXmzDfhtyaGqSIYrXv4mr8014X6b/iOk0DJB+hcDXUjMR36n+BtFqxp?=
 =?us-ascii?Q?3DF1nSy+vSU+4Y2scFDxkNX4u1MlrlwIdXaJ2RXNOLw5bWBmusb7DbhJPoSG?=
 =?us-ascii?Q?ifTf10catQTsH4MXrLXPMdOxM4wzic18VtQcG3jzB06c2ZUDBckBi6H5smJl?=
 =?us-ascii?Q?oIgEvPmAxahOdIlUy6xEPwduFT814Xfpu12n3T5IyAMgFsXmBOwcm/kCspDy?=
 =?us-ascii?Q?PXREQavXF9OfrgqnCN2UgAPcXEbkQpHQA8egHNu6vUilzngYq4SCPRS/VxbB?=
 =?us-ascii?Q?tQEaR1auuqYBbH+gcmyw+KC2hfc9qKeBHslD5gSnaFV8eEJ0WQ6o84uUBXMa?=
 =?us-ascii?Q?FZwEkoM6PpPfcDekQEs2GhWdoqlrNEHBJUjuew1hKBFaL/9qWIzBHYz09ljY?=
 =?us-ascii?Q?h34mwD3pLSPk7pUdQB/jDl/NHxZJp81gId633UomT6S7X7kNT+N9N5FKrBx+?=
 =?us-ascii?Q?fV/zmUE31HV+lMIJG4VcghPO1fXmpgmivrwxDeZT7XwdzwUsW2w2PZ/viFJ5?=
 =?us-ascii?Q?t8VgE7ewDiUgAouBTIbm9f5Z3NtEo1hET4XTd6d7uNUl7k7SQnk3QVWJiI4Q?=
 =?us-ascii?Q?16CCmoV38KdDOjp0cGDkZ6zKZLHZ5o1SLkbeETWJXc9T3up0YAMr/j9wpXsB?=
 =?us-ascii?Q?FZMwOA+7RsYdvUhzeop1JqC6W2+gY7IXeUrlZF5YCrKI4tGRt8smOx3glmkW?=
 =?us-ascii?Q?DU0UIqQ4Ctq94IrVbHxWj5gpLc93CVYxT4dBCSt3JoUigDFSGSl7vuXusnBp?=
 =?us-ascii?Q?8KkK6evWE193r5u45B9nM7Bm0MiHfEif5v0+7vnZV/5/biRyzsCLzwOKJYx+?=
 =?us-ascii?Q?Ftz4/gpuboU1cEfqvMR7da3/I817zu+8vSo5JSGLxk2UyXC8rGy0PHiGN/Ym?=
 =?us-ascii?Q?9VgX3CyYItGBuVJdEUnlokPRzDpkL8Cb9mwlBYvEeCD5IkcBvNg811QcKkgW?=
 =?us-ascii?Q?4guoDw7fQ2AJ3AJ5+TYA5DXZjXqXWGIIujD3NOEPR4sJt7QD2Khq75I2emKu?=
 =?us-ascii?Q?oNPxz/8Uk25dCQqKTt9zGT0LvcS51YD3qmILJ6MOvh2SthkD2lKuZPV02VMk?=
 =?us-ascii?Q?5krfHMRFimyJ05jeVMFCnS+ooUSAU67Nx2PIyL9fcvX8Simo2nfMOfRxgaz+?=
 =?us-ascii?Q?2MLxGf9nezgFO/z7c7IU0FO488ku72FLWPPIChzqXdxvY7NfWiPoyL//VtKo?=
 =?us-ascii?Q?GoSf74oe1VSHhE5F5vquzRSx/bvkF0BJhA39mYauc05gav5mnL8gILI/d7ty?=
 =?us-ascii?Q?DG4ksAesjkroGrnXoBiY/RIblHQRBh1jS8OceCVJLi9r8QY129ixZ89uOsUI?=
 =?us-ascii?Q?X6IfdiCi6N1YgKhiq4IPM3Uew+d+u0HaybCmg+dVEgaXScKvbtUD96QuMnmq?=
 =?us-ascii?Q?/4ezrUVA2/ZNigt9dcIDgRl97h1I7i0=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f63711d3-39bf-4f53-cc3a-08df397cb27c
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 07:33:04.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZeTm7I+qBap8qqjnsspSqgrzmiHpFF1tayDBI7NGuSTMJFuh7e7/PYDt0I3j1urrAEJnmSFrwUKWKZI7b8RzldifwM0KyBHoOLwKWeFD0awzm9dcgeJ8UTpb6QH492mq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0999

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


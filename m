Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.121
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792721594;
	b=Lsddli3/s2KJU/muyLspVmXq8CNovYWs57pB2ouHx771T8eRsmtiFIG1hXa07KnIvwe5
	 w5P86h3C4l3bBhAgNUZLAbkSmx8F6cJrAMdGGdjRVhwN2QSk+kIQLpxipMxx1TOaWtnU8
	 uXS+ruL9+IjxwKpNg2eocp2wZ7+xJk5iKW6a/ZwSA7WwFYLfGpwxFwTOY3ti3yrW3gXZT
	 UmTrItnXccH7CFanvbE/yJbwWZ+Y+Wvuyy9GbRscEZWkp/J1rLsYS9tF8RNKwtN9EnSQK
	 1dzSoO5JH0tKTA7MG8Hv+UaTbzgZlx3unLdib3NRqZSAgfaLvPnC7Yy2CTpLaxGC0Qw==
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
	bh=7W3B2TsYykKDQp00DvO4PfqV/nxgOiDtiBHqiLwkqk0=;
	b=daRqbkyTvaKDjo5K1kb+Rq7VJJrY7h37MIiRXQvdtxRZS23D0h5JofeFW9gKnfH9qdQH
	 HWdyX2uuz3L2ChQIn5m+QSjHujxTQqzLXbKk6jBKdkVbmejXqXywDhRPt6Xq4YxLlqqr4
	 s8x+zT453YCxq28Ok8qlkUd2vRBkJfzkm6u1nC4/VTNkFY4haPtG8UgZkuUnLWa0wA8K/
	 dSp/gOlN567RWqFmxOtBQUzBcPrGgiBqkkR4trEJjcm7nIa8yTOVaWIvoShRnjncZQPr2
	 yLxJsG9wSdZ+hVfRxgCmpdj6QYMms7WXpFoQ+bi/0k9bov82XnCYG2MagtKdfCr4+Wg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.121
Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2121.outbound.protection.partner.outlook.cn [139.219.17.121])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F399606A330;
	Fri, 23 Oct 2026 02:13:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F399606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=conR1iVJAKUS1susVwiaJuREw6nEYOy8cshuZuQoqngapQBMgCRobTUBQUbv5UBvA4+j3U9YP+G1EpIZr0D5+3iWflud+kBSJLLkKJHO/91eoSxxk7+vxk0S2YT++ILRQdtIvDqYiDgf0esDkpsSYBoVWL5Rk7UeUVxvegQS2yLDLKwX6+oyjeMSL4WrGYzN4w+mA26RAcY98WDO34tK3tIfGqa0+bx2O6/cOhf94mpe0oLM1wGVnAiWwYFdID+/tNDag2pMbKlqg3JlJWHwjYGqdLhlKYVnVPHhJoQjnxJ5q79CexOW7CuFgy5y9nAWSBlEccqvyWgaZVkTMOioZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7W3B2TsYykKDQp00DvO4PfqV/nxgOiDtiBHqiLwkqk0=;
 b=jrxh1U4mwcSqnmeaAC7drWDyNw/W5LURnwSIWlYUu4YJ3nSUS2+SO6GlnkGduI+Lx/UJAdN+iOJWlqnpcrVmvcQvVt5bmLTbVL5/JY8sFjk3xnLuLg4J2UcweISMVXotjt4cqSOwkwQaFlZYYjhO5YZYrZgxSr6A1Nj356CC9DJRjdAnz1emjqzVF/BuFGj1Exba+ucViQHJMW+FVjb1fckPfp/BuAmxQwk2x/FhSHp/V2kN2ay25KNI3d+Ek3DyALrjnZOw70uA9sonUoBu/gg2OzJv0f12Rj6L0CPE967zK1xB8tqBr6OC7HKX9mKf20IG8PcpXhphimIMRpmsOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1303.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 02:13:01 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 02:13:00 +0000
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
Subject: [PATCH v10 5/6] hwrng: starfive - add JHB100 support
Date: Fri, 23 Oct 2026 10:12:47 +0800
Message-Id: <20261023021248.3763-6-lianfeng.ouyang@starfivetech.com>
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
X-MS-Office365-Filtering-Correlation-Id: d2794b37-9d84-4d8c-92f1-08df30ab293d
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|23010399003|261022105027099003|261022075727099003|38350700014|56012099006|261021121427099003|261021123027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YdPWYVsOAtc23XiM9lHLJyddbQtF/0PyMqnxTWDiaKgvMaZA1SbKmzyMd2kw8DAgfqQtn7fLlX4/+wnVRwzRbfDw/aie/q8V6AvUCqGlsDhbAdRXYOFZyA4n6ihWzK1XV6Rjn4B7vQlshhOAo0lJHxP3IaxWO6PrpcLXl8otJTCjqNRWh2sfFmnyEu5jVVAO+6whbWb9nd2cEmo3G3idlnMS1B2gTuHRB0n4zfwLaH0J/DtjyD7rku/qoLFV7rayxiuWr0Y0rXyxnOkgGG0shMjh/+RVGZOxq8Lj2A1g1mYXfB3I8qVX7Ps/8lNV2kH3Q7kmbZJJG8YI2FipGbtAGxth7ZrYJKGCG/ZVsdIYZqPjijTwI8zPzMCrCktuwhqSpPIDIltQdr7AL+OAPOpehaHP6KDdVOC5V++530M/1hbvkJ9GBIl2JfzJqjyINNhg7Trx1rq8wRli+gsSxhkut1ZrhZA85KQZtqAO+bmdrt9xFwCVRQnFkInCTPyvchQx21Vr0XIsyidDIz7/1LLrgvTSK2fn1QYnvZIkGJltYKP2DNw73Y6RwULBBgorNNaH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(23010399003)(261022105027099003)(261022075727099003)(38350700014)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zvENLPiPwJiBhxuoh+gwhKkzkIGsSwsj4PJatz1c+Gl65FmbODhbPzlOWe0W?=
 =?us-ascii?Q?5ijB9XgR/MPP9mTW9mupaDElUn2BFPEIuS8RRuqvtVqmYf25W/oKwX0uUCNw?=
 =?us-ascii?Q?N7ILUr91ix8ODlO/Fcy2m/7cSkKWnt+Ymrv1kg7P+XFMAmRyIM1X/Rr85sSK?=
 =?us-ascii?Q?GUtXpl6sAP60xMgte48KEYSBTQmwBWDaA6b+2HcJBaSslahRMvcxYUaLyRrX?=
 =?us-ascii?Q?9GjK/FoxqIDjwonYMkYsNrQMfcmg7AL56EWz9ojFqZqRYGBxn0UvfE/9eitP?=
 =?us-ascii?Q?q9nASbkd+/8TUmoT/4GM7LvK3lPaX4WuZ9nv2OFt04dGW/nsdOq0lHHzUfZQ?=
 =?us-ascii?Q?PIHkjF0dCHHprPrXEjBiOf/ND8DShEwkSsDQ+f8dhHwHH5LTyWBBH9tSMkk9?=
 =?us-ascii?Q?c+UVXjI59pi4qR7o369IF5/cJ3XXGlH7kxP6q3P0oK3agsXkQC3btIcHXT+p?=
 =?us-ascii?Q?NVUw5Sf3A+gDEMPxnmxhc9j+BzF9w9BKeQhuglPD/S6epnhbr3FItQDrUxD2?=
 =?us-ascii?Q?KfEZlMixjGogbheN2exEJQ/FgIQ7ta5UfaNCBFJjUY/PD+gyyUMZmp3IK4ok?=
 =?us-ascii?Q?iV5whZvBYpFOGVssm/CqoqUcRl6MyPXaZpYe097YK17mJIySUI515zfYpGHg?=
 =?us-ascii?Q?U07IYBlyug55L203P6Je0vsYjxDQ/HFXTxDIkvLJO7qgztyQopWk8b8Fm/Ge?=
 =?us-ascii?Q?DeXROD6Dkup9IYZQJ7BldYECvfN0ddY4fVEa3IQ9x01IaJJUvk/EBB4PRCqq?=
 =?us-ascii?Q?GfxQSkTqFqktpbRT74SYMhDGc6rfPOh+as+eWetanCrxFjeYdtJuE0J0e2ZU?=
 =?us-ascii?Q?ABhkut6R3UrwuXx9NDzQniWBdyYb+EAaU+Xty/7x1xlidr/BrfpVIrbRSoFn?=
 =?us-ascii?Q?92vMzC7kyVWpZy9HNRG4lMnrvV4Zglqc+03vu4RledRJe4RVltNQ9cDJ2OHy?=
 =?us-ascii?Q?IWmZjcO1o4FOTeWJNAfeJpmqx0Rz10t36xZrrgyAiAbMt3trJg82hWIx550G?=
 =?us-ascii?Q?/QWJc3urrzXBCoUEQEcg1ELMrUKzA/GilCRyz6gOX4sJ4p3+Lsw4fN4jua+F?=
 =?us-ascii?Q?XqUbMqhfBPAId5sgegS79ML1fZ0SCTN/NdwMQbbVW0t+i7LsQS1/9dhzHm12?=
 =?us-ascii?Q?O9Y040hGrnLPIhrb8bc21+sNh9uvhI95Gbm00ueTvK8m7zbX+IwBhbIRK/Nj?=
 =?us-ascii?Q?1W6xenAp3i0ZqZ+nbUMlAYtnzomADOtGSrXXSXym07XPCuTKglOFZ5FguCts?=
 =?us-ascii?Q?4mnOppCaoJP+l9yqUXFC/qyGS5d0zBk5kpxwB8jqQpQBatyWI7MvCVuhhAXt?=
 =?us-ascii?Q?xbODavffIIVaIRWf1k3RCArIg7oS3otyVApcZseRvrA7XoEfk5oVIawBBI3D?=
 =?us-ascii?Q?6eEXXZiH0iamq5+rIh0y2m5BVApzvo2GczzbBIOnvK59YBEwojNA8L/8V9Cp?=
 =?us-ascii?Q?BvktC3p7FdaEGTpLX8DwPf6DLDdaxjhz+gT1bu4cJQtKzYagFkMaE7wxWVfO?=
 =?us-ascii?Q?DXH7MCS1e/drQc17P+Ktt++GiSrzz60nLIBn9Heii3Ud9cqNJqvUoh35AEOQ?=
 =?us-ascii?Q?bsnWis5r029XjrIE4gtoCW9e81kPCWny4aKbJQEkv6HPt/PWaP31AA0DqOcF?=
 =?us-ascii?Q?aGU1Ah8/BhOikfgYmtnRLNw+EqB7dfUjMJ0dGHUTevYoZW+Qw2mkERAwKOi8?=
 =?us-ascii?Q?5/5AzgqwpdEENx3ADX/zolXgItkrA+85pwQXaiWhXxYUi33yv6u9tJtDS5E9?=
 =?us-ascii?Q?vdRsDuHNOOtEOIL8RH8Ku+XqAASmhu0=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2794b37-9d84-4d8c-92f1-08df30ab293d
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 02:13:00.0945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6KEtb5q4miTecDDNGz35aTeqs5M3e5hozB7yLF7Dxg4hv7x+3qNzLCaK+6CY29rdw6je8zjxSx8PYJYf8w45xq2C8jevOsfHNhDdwqQhWzfdqbz/Q3Gzgl9QPBKF3lE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1303

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

The JHB100 SoC has the same TRNG as the JH7110, but asserting its reset
while the clocks are still running causes reset-domain-crossing
glitches that can affect downstream IPs. It needs the clocks gated
before the reset is asserted, whereas the JH7110 keeps the original
reset-first order.

Describe the power-down ordering in per-compatible match data, select
it with device_get_match_data(), and add the "starfive,jhb100-trng"
compatible.

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 drivers/char/hw_random/jh7110-trng.c | 45 ++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 3bec7b53770e..1018a28f291d 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * TRNG driver for the StarFive JH7110 SoC
+ * TRNG driver for the StarFive JH7110/JHB100 SoCs
  *
  * Copyright (C) 2022 StarFive Technology Co.
  */
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/property.h>
 #include <linux/reset.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
@@ -101,6 +102,22 @@ enum starfive_trng_mode {
 	PRNG_256BIT,
 };
 
+/*
+ * Power-down ordering of reset assertion vs. clock gating:
+ * SEQ_RST_FIRST - assert reset, then gate the clocks (JH7110).
+ * SEQ_CLK_FIRST - gate the clocks, then assert reset (JHB100). Asserting
+ *                 reset with the clocks running causes reset-domain-crossing
+ *                 glitches that can affect downstream IPs.
+ */
+enum seq_rst_clk {
+	SEQ_RST_FIRST,
+	SEQ_CLK_FIRST,
+};
+
+struct starfive_trng_data {
+	enum seq_rst_clk	seq_rst_clk;
+};
+
 struct starfive_trng {
 	struct device		*dev;
 	void __iomem		*base;
@@ -112,6 +129,7 @@ struct starfive_trng {
 	struct completion	random_done;
 	struct completion	reseed_done;
 	struct work_struct	work;
+	const struct starfive_trng_data *data;
 	u32			mode;
 	u32			mission;
 	bool			need_reseed;
@@ -209,7 +227,10 @@ static int starfive_trng_power_on(struct starfive_trng *trng)
 
 static void starfive_trng_power_off(struct starfive_trng *trng, bool assert_rst)
 {
-	if (assert_rst && trng->rst_deassert) {
+	bool clk_first = trng->data->seq_rst_clk == SEQ_CLK_FIRST;
+	bool do_rst = assert_rst && trng->rst_deassert;
+
+	if (do_rst && !clk_first) {
 		reset_control_assert(trng->rst);
 		trng->rst_deassert = false;
 	}
@@ -219,6 +240,11 @@ static void starfive_trng_power_off(struct starfive_trng *trng, bool assert_rst)
 		clk_disable_unprepare(trng->hclk);
 		trng->clk_on = false;
 	}
+
+	if (do_rst && clk_first) {
+		reset_control_assert(trng->rst);
+		trng->rst_deassert = false;
+	}
 }
 
 static void starfive_trng_power_off_action(void *data)
@@ -507,7 +533,11 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, trng);
+
 	trng->dev = dev;
+	trng->data = device_get_match_data(dev);
+	if (!trng->data)
+		return dev_err_probe(dev, -ENODEV, "No match data\n");
 
 	trng->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(trng->base))
@@ -617,8 +647,17 @@ static int starfive_trng_resume(struct device *dev)
 	return 0;
 }
 
+static const struct starfive_trng_data jh7110_data = {
+	.seq_rst_clk = SEQ_RST_FIRST,
+};
+
+static const struct starfive_trng_data jhb100_data = {
+	.seq_rst_clk = SEQ_CLK_FIRST,
+};
+
 static const struct of_device_id trng_dt_ids[] = {
-	{ .compatible = "starfive,jh7110-trng" },
+	{ .compatible = "starfive,jh7110-trng", .data = &jh7110_data },
+	{ .compatible = "starfive,jhb100-trng", .data = &jhb100_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, trng_dt_ids);
-- 
2.43.0


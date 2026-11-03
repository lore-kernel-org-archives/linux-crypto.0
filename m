Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.132
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793691201;
	b=To3Ujuq4kiJc04qdoKnHOf0M+DsOdf59vz58DgpYzf1w7H7TVCMHfMCKpkj+yVskC2d2
	 hWMLwutFGo5o8/ctyeIECo1hgh4YuvXTgsIeIOqu27B8G6fNiMOQdsddRpD78li2qEI+I
	 kedUC4z4pjFUVM3O0tZlI+TdrEGIpfV8g5Xxfiko/jygvVJuD2mOC5HVYbCT6DblxVBJE
	 muF0AnkU5tCpkO69NqU1r0OhguvSGK5xtpP/FayFjr/qJxP8Ty/2ztjw1VnNkP1mDk9gL
	 iTT+T2hyGro1L1QsjiDNylP7sQmO/C7kzyWpM7leHPiw0QmdLZTel6qDWt9CSE/7hag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793691201;
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
	bh=GXMJBHSwlX8uiMSjDREwtcxA3HOLQ8cQ0IhdduFuhgE=;
	b=0BL8xHfyOR7iyUIZ+cBb+u/BBG4vZKY1og48xewwvgWMUgddqcHEf+kc2q8I2/wTekSf
	 uUpbOtet3v1lyvGT2BTlB+fU0jPFIvzMPTBI2BvAlc9p/R5AN3R9Ap115JTpiaBk7AKfF
	 X/gd1pxZRPjxQObmagVpqnJemH4aaUHXyxCDF0LKEtXfT01HIqYfYFA3sokdDv83Xz3t6
	 NNhqp7avusswll0NFWwo/nKXO51RALdwNSIYkjdmBUkXVqqwpwwygysdRFGAagLeC2J2w
	 jNgRi71XDcr7R8NN4pNoq5voLLu/+GTU3StEzYhvmb7cWFVlfdpZdn9znw8o9LBNyBA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.132
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2132.outbound.protection.partner.outlook.cn [139.219.146.132])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4127606A336;
	Tue,  3 Nov 2026 07:33:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4127606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lht+pb0hUutSLtbagb395BdMfZnlqoHDT5dXk4zGvXMJfXZiobrOLMLEDWoG3Lqs/Rl42EX50ZwJmtRSEjnEFSYrPd1wJeiSmU0/eohvEn9IFN1Reqi3Q+dW1mOh6EU4odUlHO1twWnmrAeAVb0e/m8eajten6qN2+YIS8zYJhBzbnUSxgH/fQ7AxVmd8d9e13ts5W7cJ/TWaKffP7Oe8mC2RkmhNaBOE+/pEXRwp87YjpUP5C6oVrrMkWcuvE1CZnKHulXgCF5KLjg2pcDoXYYguhNW+bZ9nYkf1q1u9G+3AgiGnsoW2iUB9OsfcpZyTOUHxQ10NWN7hW7fWaxWDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXMJBHSwlX8uiMSjDREwtcxA3HOLQ8cQ0IhdduFuhgE=;
 b=WjR7kiUioHun9npM0Pe2OJQSpy/7ZT0IT1qX0G3/E6PLhFwDMzAKUbaeibV85xy60AMe/QsHC8bEuSs7qYTzhKrpKWIf4vnu9AKFQFHctaOejCI0D+I+kYIevNzvmIcyMPArtVIisuvwdgemQ4X7nOkZIxmY05SwE6hqydKYL4cJlNKPUbAMzaDYpwAdE06CFzQAjoAtcdMz/BsAB5ZXdhgTp8c/yyRWk+aCnaU1RlpD6WV4YK/bzo7QDQb+vH/UUrL2FEQnbjlGBhuN1kFpuTWDx6KYLyma5x1pPXNSH1kLi4vAkUoJhg09DQoGEUfJjTZvmpJiP9WPI8cEKjTPvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1032.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 07:33:03 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 07:33:03 +0000
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
Subject: [PATCH v11 5/6] hwrng: starfive - add JHB100 support
Date: Tue,  3 Nov 2026 15:32:51 +0800
Message-Id: <20261103073252.3028-6-lianfeng.ouyang@starfivetech.com>
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
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1032:EE_
X-MS-Office365-Filtering-Correlation-Id: ef0774f1-d6c8-4d41-4bd5-08df397cb1fb
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|52116014|38350700014|261021123027099003|56012099006|261009223027099003|261028144727099003|261022075727099003|261026121527099003|261021121427099003|261026140227099003|261022105027099003|10067099003|18002099003|22082099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	MOIhNEMt1fAoxzSCHTs1IV4cVm0PUJ0vlU390O57HN21vUHsASvyLnWILsOH6s+fedH57XEzlV4kRIBZngbTZ9oXJZIymF6lFf6JYtArXv99CqwPMVC2pRocKaSVfoSGm8K7oAgjLyqq4TVIIB2D9PNaJE0LUwC0lltlR1P8xT/CtzMcBxil0PuYy2i4/vPgKpShxTYjZXpMlxFiWMfQfvtQCgWaFyQ4Ez2DVOoLxNTuaSpzqXmxbwJL6AGd76lMYW83VeK8ugPSKDZtFFVwuwhwMx2qktZtjwiiN9DnmWGptn729hPCWpR8FZKuLOlnvXcozkw6+4gjY5X+z+BavKXhUs8sGjj0TzdCRsMfeS9PdDB50DrXWVLmknC+/aeTgQDkO/m+lcNVxeJMO0oR5vxp+j3ilWAL46k1xJYNR8uYaKBnX8xdo+Dv1issIbXdkcauEYRlQaQZXvKIcGPmnfctTLyJ/rgad0vf+vSPOUPW1NZLHj1nfNQqvs8mXNM4H3N4QP3heesiXyJjbEe89qeVhvl/yi4TnuAz2sUrMsg5XTXlhYQEH5C7j+/6lzNw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(52116014)(38350700014)(261021123027099003)(56012099006)(261009223027099003)(261028144727099003)(261022075727099003)(261026121527099003)(261021121427099003)(261026140227099003)(261022105027099003)(10067099003)(18002099003)(22082099003)(261102123227099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Epf21P/xwpCjAE7cs7IzOnApfPasYSVg/Ls4gjapcT+CW+LdcPK+nZ+jOyVl?=
 =?us-ascii?Q?eUUrdAHJZ/hcWp+dSD1amH3iPYFFtAMjyKLQWyqzjGUzZB1L3TKoUUupyV0k?=
 =?us-ascii?Q?bhlrm9848OVsCSt9FO2AQRJ1hHCxjXHhdeq5yKj4AmZkp3HAuzTnh6Kai/m+?=
 =?us-ascii?Q?AILzDV+O9peIaJJg0KEBjIOXohA9yorGeXyuXkXFEIjSmG7usWVlvIgyCqvV?=
 =?us-ascii?Q?zzQv2Cq3u/KvTv1ishBDKpX04Qm3w4Tk5Xv0V7E7cN0bMAw9qNDy0rgp+iaG?=
 =?us-ascii?Q?DRA4lGiEeMmyIjNJ0FNxfEdwlXv4iw605tSm72ZOsSCizCUmUQ5U8AeKP/PM?=
 =?us-ascii?Q?KC6e6QERiFZxlKmrJ2WPBozJmbxQGAfLsqJELQ2C6Vi/F513yD8KccAN100u?=
 =?us-ascii?Q?mgM1Q1y2b2BZth20oQuFsPOalPDdVX5QuhAPLkzhhUxC9FpWcHjcyocwSWFk?=
 =?us-ascii?Q?AiDEtIXPzrc29WeljiCIDg9MjPpKhJ+ZczeS/u2gzrkSVfXM6aqHbgmE1YDf?=
 =?us-ascii?Q?P4iIQkj3nuegGd8/l5njaichly+VQ9PPesVSTiPBkASTDBjlgUSkIzowQYhN?=
 =?us-ascii?Q?+RALlGiYnU2E+k58Ym1FPpILg3WdFZSK37D10NC4FZR7I21GB/wRrgmkqw4c?=
 =?us-ascii?Q?bGMtRB3FdB7wInaZU94JLpGKZlbEiMDI2b+4GRhXjFFj1okIvMRbkQw5/jKB?=
 =?us-ascii?Q?JlddSIPMxPY2IRTrG2twqBUjXe7LEc7tg+rgS6oLI3oHvX5JMiTNXjr+aYAU?=
 =?us-ascii?Q?ynkPFo/Jc/fuQxS+QL9lcxD5ujQORPcR3ZSvrrGALcge6f/iezTmMoOF597k?=
 =?us-ascii?Q?DoCzxRJw7Ic7zs7nW/Y0rQ7+kfaRsmxa4I7vVUxqKYJVdQ8w5aBurBm2Nlsi?=
 =?us-ascii?Q?+S3AI0mYkO2pQeL71xWg0rAEuwsKQi6CCJNSuf4iMtaQSl96QiTuM50foHRc?=
 =?us-ascii?Q?w6IszDO2NSSkYpce6s94IxuiZ2spfM9NYSYNExg9HXjWWorf5ZSWEp3+pfNJ?=
 =?us-ascii?Q?As4M4V3gJGb+iVcL3LNIk2ATeGqOGeQCIO7EDZy6JJ+JG3DpwuRILZ2GkSat?=
 =?us-ascii?Q?7VS5pNbla2Mz6LLVYyH4UHMqWGm3zWISYGh4MYwyNvp+Vy+CqZjxvb5BOMhF?=
 =?us-ascii?Q?GQU7eYxejX8rz99SK4QzeSBYNGB7PtO7bQJ9vSTgrAh3OScFJQ3Z3jLWRFBb?=
 =?us-ascii?Q?LTX9nJJ8Cucl3Ho7r9J+WqlAnBqTaEQOEPuL1TnaIIHJY9YlUsnq3qG92dNt?=
 =?us-ascii?Q?N/ZfVLVfwBjLRbLcOmqyYMsesFRT3XX4zaSZTwBKGTBe8EYxVTZchEvsJ0m3?=
 =?us-ascii?Q?igwG4zDQ5z7c36ejFop6LC14ZZtc6wl5fKNtHA7Oryspi+93zdnzz2ycVRHP?=
 =?us-ascii?Q?5Zhg+zRAmcdBZ6k2uKkrwfya33X+2QwCRF8DbBrQ6tBCR9HUKGUQxGW6739r?=
 =?us-ascii?Q?QhudP78Lu6zDHDjLp83zhASHzDf3TAYbwqL5Pstzfbmtx/VfkaEQRSYEM3me?=
 =?us-ascii?Q?QS2PJAlqzLhk0YmtrPrQlwgl+2MV+fg28EI4Ypu8ZCtDyP1aH0ifXzR0pGVq?=
 =?us-ascii?Q?94OphOCVngfpoAmS4rPaeKhq2feuJdZB2D51DFqDMVoOv7ntRhaJ/vY0upJZ?=
 =?us-ascii?Q?fSf/jZbgOmpqKCrw5j+JTO5NSvZqlXQEpmvz3DbEFZgKrKtNAV7GR5KoFHb5?=
 =?us-ascii?Q?YLLjMyzVFe0zvogprWp9koz4uDi0Us0JD09MMlr4uKyQVNDNWHQ4R5mXhl8h?=
 =?us-ascii?Q?Z9G6EamGyMOza77Tdb/HKxRzci0GVuI=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef0774f1-d6c8-4d41-4bd5-08df397cb1fb
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 07:33:03.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FVZs5IE+jBTtEMyk68hNRTd4MydmrMdKX3yTfiJAqY8Shq6KXVqmHOFXWGG4qD5CWVBqWaM319jMbz/oc0VDcMOk3fkVaZwnMNlOal204EHsgKqxbpn+ceWslzCVdpop
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1032

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
index 82c5d1491912..763aacf7dfac 100644
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
@@ -516,7 +542,11 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, trng);
+
 	trng->dev = dev;
+	trng->data = device_get_match_data(dev);
+	if (!trng->data)
+		return dev_err_probe(dev, -ENODEV, "No match data\n");
 
 	trng->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(trng->base))
@@ -626,8 +656,17 @@ static int starfive_trng_resume(struct device *dev)
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


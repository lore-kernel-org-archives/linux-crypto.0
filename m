Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.128
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792721594;
	b=0TWXLIihDOMRYm8pcLVD+xNETGbvPa1DP8Y8rkRC1+VVEdmotDCdgUgVKPxoYe1ycift
	 qjFV9VMK6MI32QQdJRku0+x/KWS/tQRUt2exsRYuQtVP80Xd4Z4d/Ql73fc6ziOA97H+0
	 VI7xLUl8W0MwhHLBD7UadoTpdqXVvI98HBjCOnmqkGOY9W9OGk25j6UskIa7UVUHKd6ZD
	 9WimOuoBNsjM66oIYIJGrbNplnkYjCP60DPY3OZ2s8rp4gDyQWnmt9zjioYsmzx7rii0N
	 ud675OUCWI6ZmSxphKiBo8IjoneVhjrZ6f4xnwdgmvcoQR7i1N0wLtwohUeA0S571WA==
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
	bh=J+wbIvMG9EBK1SsFtX9ZFKi3ZFdETFD2cKHZYgo2dvY=;
	b=tQO7/HXkVdfonDlrv0qVLQBe3wqV+z81R9VsPJ/kvY9fwItjPw9iWKKjmnFzjdGdx0vr
	 0Co8kFRt/PrxZuqcp3K6PbuqckDL+5wiDbQt7nF/lBdJhZhMaK5RKgU8BJeUjh3KyX8nu
	 HMt3WQHKDw2tw+G2I1/Zk2Z8aqaAoQRW1QOS9ucGBQPV0u9RTqpVbW8mbmoC0E7e6q6+e
	 nFNwsur/RVZ012BufMC43h5gqNZeH9TiKnY1HL4zwLU3eem4jWqX60KrNVFsrAObGGuyA
	 XCDABJEQgcSbfSdozEwN2xPQ4QpgOgsdPoo0Y0uUkbs6G7laeZU3penIiNPjhRxfOwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.128
Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2128.outbound.protection.partner.outlook.cn [139.219.17.128])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C3E606A32F;
	Fri, 23 Oct 2026 02:13:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86C3E606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXAdkpt1HQB23JKJhCSSUkiZUWm3lUQiI2O953dUvIDocVYTVgNRNQTEL0jISUayMBcsbOw/LvgZQ2Jf0Vhw814P7JLUBPLUFtiU5RZCkQ9bxtCSbbe0/he955wDskDRlKC/Na8pJ2bskMneWZc3O/ogLUEWecU0R8GIboEkKaBiizW0EP7W1SOKg8yqeee8ZfizhMHMsOoLhsM3l3PaeFRAp/mcbXM2ctvUju3DpjDJxD2Rc2ajKWKh+ieMpc+hTDqmbJC6TXV2rS1kVUc/mHyGYjzj1wPSVNHFM7wnW+/oTWw+5pikQOoMfb3pCgskteBxdruppF7Ad3OdkYCvRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+wbIvMG9EBK1SsFtX9ZFKi3ZFdETFD2cKHZYgo2dvY=;
 b=SJZvVR9Dk+hrcYfRTM2HopdopiO26651m7/WNEP0Lv6d/hTTk4+DC1ta1ekH0EgjOghm7QBdisFPz1kntzh4zqv3Yn0ZQIRnp6OXDSFz1Q0UDMDt5qrNECVUip64iANjo1pfBDdXaJZkRN2WXi3AftKpZhLYR3CpWJXkKxwEZnDX+H/GP5RCJ+MUcd0sg0YzpF4W645pnZQBNYDi5Lj0csf4vx7TXUuhHr6Pt1LWSjGnCqgvowDi0Gp4HaJFvnhIvov9mlG9cQaHPci+BFRke3k3uyZSr2rYxbE6ekcBDHbnQUZsR2TP+U3850m84PsiaDpDSbGJdwOmT3R6TA2JQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1303.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 02:13:00 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 02:12:59 +0000
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
Subject: [PATCH v10 4/6] hwrng: starfive - tidy up includes and drop unused code
Date: Fri, 23 Oct 2026 10:12:46 +0800
Message-Id: <20261023021248.3763-5-lianfeng.ouyang@starfivetech.com>
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
X-MS-Office365-Filtering-Correlation-Id: 414db054-e09e-4844-bf42-08df30ab28a7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|23010399003|261022105027099003|261022075727099003|38350700014|56012099006|261009223327099003|5023799004|261021130227099003|261021121427099003|261009221227099003|261009221727099003|261009220027099003|261021123027099003|261021135927099003|261021133027099003|261009223027099003|10067099003|18002099003|22082099003|261022115727099003|261022113327099003;
X-Microsoft-Antispam-Message-Info:
	S+SlqX3Qkv4ey+Oi3wIT6vr8Ul+jrPTzyy38wTRGx2lnKIMQi7jW5NJ7T5WbeAu6i1Vedx51jLtw2qe1QRThDY1/C8aM/Mp2yk7uNrh4/4bO8l8FRzq1nLMvMyM7OI6EYCgLlAR4xBhLle7NdyciGgouIR2KAkYW/qeha1B922a+YRme3sK9UEPXRXNLQumrjQ5a168upUk9wyky5CVb7o+sup04ZqsDfVWKF+p4PCq55OsUkqwtLRdyYEmQOBIxi8V048WYSRV+AER9hKg3mKjvU5xZOOhnQ2fZiEN0L1yWBj78a3EQpchNTIP5KNoIOKQ8S9e5/Wo9CnsBWQTuYlJbTi9T3sAkwYw8vn2iECZSYYcNIB/WMZjbBDi9APKuD3ciH+45l77hNouJ6mM5w9HIMdTMSYg9mTIXnSDrY1Uu2Hq2POcP4kadKpam7dvGhKWI083oyAsdn/Kn+/h/3M0RQyV0hSPMgrO4wWVonwdzcanIVXBoSsy9va9yqw2mOoIq6CgR+22ay4sOk+EAp0iXGaB75hYGm39Eehtk38rJ5JVoOMpdFDCN1Qo5SDZz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(23010399003)(261022105027099003)(261022075727099003)(38350700014)(56012099006)(261009223327099003)(5023799004)(261021130227099003)(261021121427099003)(261009221227099003)(261009221727099003)(261009220027099003)(261021123027099003)(261021135927099003)(261021133027099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(261022115727099003)(261022113327099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rztiprQho2U0bPFq7yANjbxy+XJoXWJAiWL29T/A5N5hB5smmxS2Agu8IXm7?=
 =?us-ascii?Q?EGO+2cqvc4V0OSJMFagKrq9L87VFuWvpo5pT1OFsbng26/TevIXtHEBKvhdK?=
 =?us-ascii?Q?h1b+6bJ6FCBJg7uJ8g7nc3Yb1OTo++hQpmovbPjifb4PnCIP6i1gH3lj9vR7?=
 =?us-ascii?Q?4J06zxAnqyWq+Kgfe4N6SgeZSU1QVV8Teg9Zbfen9ydM22A2M9/4Dc/dQph9?=
 =?us-ascii?Q?7bUbxblsdWkJz6eQoifVvvrlmdmtvzBqoocaHXk65yG6D/63l0j8DQCuI2gS?=
 =?us-ascii?Q?TTB8gr/qcHBPOm4Q2IGXpJYsN8Bp+qR3Xb8H/tYHMLx28aAxqmDH+SXf5432?=
 =?us-ascii?Q?ddxIn2o2NOioBvrh+RRmBVvzBL+Bc3qblY6iie6rat3D4mcPO/+EF0dm1g2V?=
 =?us-ascii?Q?XL++wTlpX/cgtmI96j9IblMevwsnaXqZH2xZPRYKDD9fDYi/L4+JayFy7pzm?=
 =?us-ascii?Q?m2sRycONnGuUOXULniSEw+57vrbzbouKySFeDbGNdQ43Wk9N84GRNy7ysrL0?=
 =?us-ascii?Q?uv1IGmmARh9Siffixnr86ZzEgvTSLbOxv5JlVTUbuAKJ3Yiy1Tjsu1RimmMH?=
 =?us-ascii?Q?dpRH9hdG/6FI0PAvWL5ri5CmHbhejIG4xjPiet79ccMWg8ZMUbYxEvr+sRfK?=
 =?us-ascii?Q?Eq8xu4xU/JGNq9MZ1XIodc9K/MdzHcajzmFZK42eEcONx1Z6epy7TCz9o824?=
 =?us-ascii?Q?+RxUpwrGTNmP69rPPUUpbel0JOscUfgTmwr6WgAbcOzCW8f+ePfR0vfc3LQx?=
 =?us-ascii?Q?3ynqbP8XvwKboRvS8Cj6FkzgAbBmJDfMTDTIvQpOxhkWineuS6puQXZE6IqN?=
 =?us-ascii?Q?A2qGgV2tbkLHM8hPfgmeQZrBx3ungvlXML3f4QLATTL89l6/VSJAqdAi0Dj7?=
 =?us-ascii?Q?Nas+IW+MDtDs+HHnDRn/ETqH3hTT/O7LGgq2dk4Q6fLLGa6kUmZqHALRJVmv?=
 =?us-ascii?Q?klina8UrrjeoDBRKid22w2/9uEI6Yikvdfbk/AViWMAmFzTxBUmr0ppZLglS?=
 =?us-ascii?Q?nMX7P0yZKDGgo2krlkbbN/lleBkLoDiWhgHysgbyDhyW11VWVV6hp7K7lb80?=
 =?us-ascii?Q?ZWSMlQCm4LmZXhawrg0q0OgOqaMmrT10YOHfqGCLXlX4GaMlqRVRW+1feZrw?=
 =?us-ascii?Q?Y3luCk3WTgUBlDZtpZ+7MunLh/P6dY/j0GvNTFyacOxXZvYguhIttyK5fBH8?=
 =?us-ascii?Q?8RkXZAwszQE1uCMpB56akIDi6t2JP2q3xL3yqI6iBgcKY2JPyruY6FLhskXB?=
 =?us-ascii?Q?hRCQY6GX70Bo5yBH5bnJx+z4DTMy0UXIacC4U9xgHo+6RWzmfm+8mg1KFY7h?=
 =?us-ascii?Q?8m8CHTvRTFEOv6AnZTKMq6s2dGdd2lOnM0PLP/A+nYmzntXcsxjPRbt7djfF?=
 =?us-ascii?Q?Hg0plsu29IJdMbe9g1ugqvGV7PhT8ohftOiPLLIrSE6stJuJ8zHUqV9hRYaC?=
 =?us-ascii?Q?T78YRKkDixODZXTlSIa3FmonUqxFE0MHymV6VM6XAiQhK+CMOg3L3/IjpTwz?=
 =?us-ascii?Q?8HgxYWxnIZeAWV+EHQcAxoV/XL+zCaoUBY5mvML9XFO0MPy28diwH+Z+SrUJ?=
 =?us-ascii?Q?BxVGc1rOXiSSjGRIWTQ8+LQQqNZrTw3eFUaMQ2oICt+8TC7VJsh59MR4mlin?=
 =?us-ascii?Q?zq7HVRAPEEc2VuEoV0ut9vyOTpOT424LpVy9PNXFeJmG1e0BuQqeQhC32zpl?=
 =?us-ascii?Q?c158YYHHEDKesKUCUlaRIfhGCWpxAJ4c7KWuTATgPrk4+nII4639Xh3JJmw4?=
 =?us-ascii?Q?gN7ewnSA6q2T5EYV3CSBzpDwAbaUHfeCTDHREhnDkZ7/s0WJITho?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 414db054-e09e-4844-bf42-08df30ab28a7
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 02:12:59.1352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNhq1IgbRlMnIMuM85jHOQxWH8hETAUX488QSxNZJzcN0JInmECjv/vIq0oL1T+MYTTnVJRcC7SH84uIaIduE631jD53zytyFXIQm0+FyqcWgbbKBOwkn8MkQyblZ/rd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1303

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

Make the driver include what it uses: add <linux/bits.h>,
<linux/container_of.h>, <linux/device.h>, <linux/errno.h>,
<linux/jiffies.h>, <linux/minmax.h> and <linux/types.h>, and drop
<linux/delay.h>, <linux/kernel.h>, <linux/of.h> and <linux/random.h>,
which nothing in the driver needs. struct of_device_id is already
provided through <linux/platform_device.h>, so <linux/mod_devicetable.h>
is not needed either.

With <linux/of.h> gone, stop wrapping the match table in of_match_ptr()
and drop its __maybe_unused annotation.

Also drop the unused reseed enum and struct member, name the mode enum
after the driver, use a local struct device pointer in probe, name the
interrupt after the device and replace min_t() with min().

No functional change.

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 drivers/char/hw_random/jh7110-trng.c | 81 ++++++++++++++--------------
 1 file changed, 39 insertions(+), 42 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 8e0e7865453b..3bec7b53770e 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -5,24 +5,27 @@
  * Copyright (C) 2022 StarFive Technology Co.
  */
 
+#include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
-#include <linux/delay.h>
+#include <linux/container_of.h>
+#include <linux/device.h>
 #include <linux/devm-helpers.h>
 #include <linux/err.h>
+#include <linux/errno.h>
 #include <linux/hw_random.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
-#include <linux/kernel.h>
+#include <linux/jiffies.h>
 #include <linux/lockdep.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-#include <linux/random.h>
 #include <linux/reset.h>
+#include <linux/types.h>
 #include <linux/workqueue.h>
 
 /* trng register offset */
@@ -93,12 +96,7 @@
 
 #define to_trng(p)			container_of(p, struct starfive_trng, rng)
 
-enum reseed {
-	RANDOM_RESEED,
-	NONCE_RESEED,
-};
-
-enum mode {
+enum starfive_trng_mode {
 	PRNG_128BIT,
 	PRNG_256BIT,
 };
@@ -116,7 +114,6 @@ struct starfive_trng {
 	struct work_struct	work;
 	u32			mode;
 	u32			mission;
-	u32			reseed;
 	bool			need_reseed;
 	bool			initialized;
 	bool			clk_on;
@@ -363,7 +360,7 @@ static void starfive_trng_reseed_work(struct work_struct *work)
 static irqreturn_t starfive_trng_irq(int irq, void *priv)
 {
 	u32 status;
-	struct starfive_trng *trng = (struct starfive_trng *)priv;
+	struct starfive_trng *trng = priv;
 
 	status = readl(trng->base + STARFIVE_ISTAT) & STARFIVE_ISTAT_ALL;
 	if (!status)
@@ -482,9 +479,9 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	}
 
 	if (trng->mode == PRNG_256BIT)
-		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
+		max = min(max, STARFIVE_RAND_LEN * 8);
 	else
-		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 4));
+		max = min(max, STARFIVE_RAND_LEN * 4);
 
 	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);
 
@@ -501,20 +498,21 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 
 static int starfive_trng_probe(struct platform_device *pdev)
 {
-	int ret;
+	struct device *dev = &pdev->dev;
 	struct starfive_trng *trng;
+	int ret;
 
-	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
+	trng = devm_kzalloc(dev, sizeof(*trng), GFP_KERNEL);
 	if (!trng)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, trng);
-	trng->dev = &pdev->dev;
+	trng->dev = dev;
 
 	trng->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(trng->base))
-		return dev_err_probe(&pdev->dev, PTR_ERR(trng->base),
-				     "Error remapping memory for platform device.\n");
+		return dev_err_probe(dev, PTR_ERR(trng->base),
+				     "Error remapping memory for platform device\n");
 
 	trng->irq = platform_get_irq(pdev, 0);
 	if (trng->irq < 0)
@@ -523,63 +521,62 @@ static int starfive_trng_probe(struct platform_device *pdev)
 	init_completion(&trng->random_done);
 	init_completion(&trng->reseed_done);
 
-	ret = devm_mutex_init(&pdev->dev, &trng->lock);
+	ret = devm_mutex_init(dev, &trng->lock);
 	if (ret)
 		return ret;
 
-	trng->hclk = devm_clk_get(&pdev->dev, "hclk");
+	trng->hclk = devm_clk_get(dev, "hclk");
 	if (IS_ERR(trng->hclk))
-		return dev_err_probe(&pdev->dev, PTR_ERR(trng->hclk),
+		return dev_err_probe(dev, PTR_ERR(trng->hclk),
 				     "Error getting hardware reference clock\n");
 
-	trng->ahb = devm_clk_get(&pdev->dev, "ahb");
+	trng->ahb = devm_clk_get(dev, "ahb");
 	if (IS_ERR(trng->ahb))
-		return dev_err_probe(&pdev->dev, PTR_ERR(trng->ahb),
+		return dev_err_probe(dev, PTR_ERR(trng->ahb),
 				     "Error getting ahb reference clock\n");
 
-	trng->rst = devm_reset_control_get_shared(&pdev->dev, NULL);
+	trng->rst = devm_reset_control_get_shared(dev, NULL);
 	if (IS_ERR(trng->rst))
-		return dev_err_probe(&pdev->dev, PTR_ERR(trng->rst),
+		return dev_err_probe(dev, PTR_ERR(trng->rst),
 				     "Error getting hardware reset line\n");
 
 	ret = starfive_trng_power_on(trng);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "Failed to power on\n");
+		return dev_err_probe(dev, ret, "Failed to power on\n");
 
-	ret = devm_add_action_or_reset(&pdev->dev, starfive_trng_power_off_action, trng);
+	ret = devm_add_action_or_reset(dev, starfive_trng_power_off_action, trng);
 	if (ret)
 		return ret;
 
-	trng->rng.name = dev_driver_string(&pdev->dev);
+	trng->rng.name = dev_driver_string(dev);
 	trng->rng.init = starfive_trng_init;
 	trng->rng.cleanup = starfive_trng_cleanup;
 	trng->rng.read = starfive_trng_read;
 
 	trng->mode = PRNG_256BIT;
 	trng->mission = 1;
-	trng->reseed = RANDOM_RESEED;
 
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_autosuspend_delay(dev, 100);
 
-	ret = devm_pm_runtime_set_active_enabled(&pdev->dev);
+	ret = devm_pm_runtime_set_active_enabled(dev);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "Failed to enable runtime PM\n");
+		return dev_err_probe(dev, ret, "Failed to enable runtime PM\n");
 
-	ret = devm_work_autocancel(&pdev->dev, &trng->work, starfive_trng_reseed_work);
+	ret = devm_work_autocancel(dev, &trng->work, starfive_trng_reseed_work);
 	if (ret)
 		return ret;
 
-	ret = devm_request_irq(&pdev->dev, trng->irq, starfive_trng_irq, IRQF_NO_AUTOEN,
-			       pdev->name, (void *)trng);
+	ret = devm_request_irq(dev, trng->irq, starfive_trng_irq, IRQF_NO_AUTOEN,
+			       dev_name(dev), trng);
 	if (ret)
 		return ret;
 
-	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
+	ret = devm_hwrng_register(dev, &trng->rng);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+		return dev_err_probe(dev, ret, "Failed to register hwrng\n");
 
-	pm_runtime_idle(&pdev->dev);
+	pm_runtime_idle(dev);
 
 	return 0;
 }
@@ -620,7 +617,7 @@ static int starfive_trng_resume(struct device *dev)
 	return 0;
 }
 
-static const struct of_device_id trng_dt_ids[] __maybe_unused = {
+static const struct of_device_id trng_dt_ids[] = {
 	{ .compatible = "starfive,jh7110-trng" },
 	{ }
 };
@@ -634,7 +631,7 @@ static struct platform_driver starfive_trng_driver = {
 	.driver	= {
 		.name		= "jh7110-trng",
 		.pm		= pm_ptr(&starfive_trng_pm_ops),
-		.of_match_table	= of_match_ptr(trng_dt_ids),
+		.of_match_table	= trng_dt_ids,
 	},
 };
 
-- 
2.43.0


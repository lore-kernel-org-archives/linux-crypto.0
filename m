Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.113
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792571855;
	b=vy8yZU2M6d1D2qIeumpimn9EwlpeCYmwlR03m9oWMx4rFPSGqsyhthq7OasEvvQFCNm/
	 48KrGJPJ9Vu5prmbn8gtVvxudq+efdcfOqosXVZflQ1BjD565nXvna7VrEQLZR8ElO2hY
	 wD5jzufn9wlcL89gB7MwQsJb/ImsdvNM9EKZVcuAZX/sx0LkXRkqgCuiJmJQqU/8/F9iZ
	 Hc1F55QxLUo8XFrtNsjy/V+Hhx2bg6arODpSH0TFtXIRSsKrbAJ5S5P+EATJxlF8Emrky
	 GmVh8dI81iG9MfGzqMbWn04kOqShyLTwonzg0nvB+gsAaYgksmSwt6nwexygIZvTldQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571855;
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
	bh=dRYjDd8Miua00euBGfhbdXu7eceDsLUtgk83uk/X6QM=;
	b=baC8D1VszvlrlJVNsMD+fDaX5aJLZ4SY8XcVbc0Zjd8BfY4PopxxQjNa0eJtDiIHGjps
	 LvkVTLWKZMjIZ7nK3GzEQS+FUMLKqMUHrEUeVDFsFAeXVUfRsDqtFFj3gJfMKT+uYwYup
	 Wbr1ezzb9mNGiQ2Uxs1hJEn6NGe/R1oCAlMibZ1rQPEuVpOUGKW+Prq0mEZ2oZPY2umcn
	 d0wHsXQF/VbM9Qrj3StfSrzJL/y4aFw+j985NpLEgau802hetCgHQVkvFV4jGLqxJaZAZ
	 y5+WZ+EYXFQ9QrU71fAsmvnSBHCEQ0JIX9qfKtu+ki6gbHgvv6WZp7g/k5h1Joworaw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.113
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2113.outbound.protection.partner.outlook.cn [139.219.146.113])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE667606A31E;
	Wed, 21 Oct 2026 08:37:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE667606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RE2O2WyrN1u9rw5vTi49a1V+ZrMrYim8mPP4DpxCvZMembc12v6FVy0ogf3QU5pGgl2kAKCImtgIZxcHtRSWz5d7mE7ZQtvQbVy8KhzVWwXx2CSXkFXfi6scmyyaFiRg6BgHSHtoV44RoZ7QbRcsFQgEcTMV7sOfZRHFyENL0l2KU35WykiV9spynT5DzmfSJT9GzPqQP8daUM3Ff3+o2M6Bq5oJmNVP7zY1KyE50W4aC5RyUeQE5Xwj370MG8u0fNiV6EpOfBQc6Kbko4ylWIWUIoPTYWcnTu5wuh1/y8trjdFEbiuxXAroUoM7gB3FjW0f7yM8CrtA68itkkix6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRYjDd8Miua00euBGfhbdXu7eceDsLUtgk83uk/X6QM=;
 b=VWqNX3HBB6MCYhaTW69TzhBkbxZBczmZMp/r2V07WgV/BzcQ1GsAYmTzboMeaxjVGByHuycwiT7nFkWIx43LYBjaoWC8VrYkCwNOlf3UoVIOQUAJELo0yuQrgNV8/L2sk+TTRDe3F89ulS1IHesSJhHIeOw3OXJOh2UtvfMMAUwJ1R4rnSCT5NbYPgWdcXd8UxooLSsRwDA8WiFRjOXi4vCa/ysh7N02fSxJdA03FasVHxXqkdwI+86VzGvU80xrHVkcoc3T2Zc6wqeetgkj7sbp/KoWauDoJg04dDU/HRZGz61T77DGQc5hsYMHgt6BP7ZOQ6Y/9DI/LczH3/ICTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1047.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 08:37:21 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 08:37:21 +0000
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
Subject: [PATCH v9 2/2] hwrng: starfive: rework clk/reset teardown order for JHB100
Date: Wed, 21 Oct 2026 16:37:12 +0800
Message-Id: <20261021083712.3032-3-lianfeng.ouyang@starfivetech.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4e0d9042-5ba4-4a87-c0f4-08df2f4e85fa
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|23010399003|1800799024|261009221727099003|261009220027099003|261009223327099003|261009223027099003|261009221227099003|56012099006|10067099003|6133799003|22082099003|18002099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	gYkD5+bg6nzgCMtdFDjUrV5AV/CU4WKpZqqhwKjyCazY+eYK6ji17eGymQRT9eICWGEaTcYgibrp6u6+7UenZRj+W68bRYAynW5PNaMZAURTglhsEsjSMgWCQlctdThRusFiFtf97isyNRmZIPFPzk2MjEhHfmGeycyKpis98i/Mhl1i2iJABQ21GvYDHi8TAW3lgpxDMSXdLShCK3YerYzD/T+U+BqxqO1rpQ/1Ea14dijRz13taMS4fVnDd9wF3AoHyHofslsqTKZFQkuHw3NpjptCb95+cUUbTLUFRNM/FIKDzSCUuQua/Et0vwjFEgpQZWE1vWJ3zMjUDjilRhCtrVJ35+lmMX4G5bHIBwPjaSpS/OxUaPD7UsAlxxyfrUHpFR7WsY1J7H9qDYdJZ9WlJyDELX8Z3iz0FaVk5ygjTORTFMUM5UBqbX1vEv2ygtxgzm6g7x11+k0BteJDdNZxGZ276vl9m3h4o4O/TYtdlu48lj9C8dOlc4zruGOrzhx2+GFyt8nu93cjGmLPaP50GtgKJH7A7ck9kGnZ+YZY60Q5jUYsDJiWNiWt5MER
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(23010399003)(1800799024)(261009221727099003)(261009220027099003)(261009223327099003)(261009223027099003)(261009221227099003)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qPbROJtUw8jg9lw8f/EOdWNtCsT+mNbAh/V18xmXNA0yNBWk6TrWPhS6MIjc?=
 =?us-ascii?Q?NNr85EPxnSMMuGLHgXh6wSg3tU7tWK+g9dee+4f+9G4+qvZ6skQu519ZOODc?=
 =?us-ascii?Q?DjpK5UQ3yd0DFkMT1grT+2FEGJ854fy8PC27GX5Nwy+zAzcYBfNTbJLzL1t5?=
 =?us-ascii?Q?3i7lHF43WW8rupObjnIUApVbvEe7XaQQIcEwVA2s0z5+bgmzGZwY+vWWO+8N?=
 =?us-ascii?Q?g2DNATWDu993H8D31x0a7ZAQSr20sxo2n5H+dIDdxVJKl7qKMdexGVP7aD7T?=
 =?us-ascii?Q?NAbW+1oH43/Id0wMupkiRQxEeM3L/bkJyw1Hl3h65GHE349s9fmrsPpb2XXz?=
 =?us-ascii?Q?RuBlEfk8kJ+18h65lwyXmigUUe1q3BQ1Mc8L1kJfjiBOwITP7wiLu19OdWxO?=
 =?us-ascii?Q?dSrWJGi4KAbTD7WEp+5c4GFU8l+VXU9Z3H9C4lF5UiARpmLuG9zQ/ygQu561?=
 =?us-ascii?Q?X9owAaXXj/hg1fquA4BGg/vr/OSlJU55E6ymYgZgi8CZN8B5dwGvLJmWeZSa?=
 =?us-ascii?Q?1b09bxye9s/CyhBTk9aey1gxUknsOe7YThwG8zN2NfdJm+sKgO11dDzY58un?=
 =?us-ascii?Q?FI4IqhePJSItLdjlehr3JJwpHQBaoTq1aLRT9q0fp+FVG8Jn1rebWVmyaUu7?=
 =?us-ascii?Q?YYQpdWZ/2qC/rF1Q/PWZuC2ptYiBmSxnnV1hA/OTQNxPE1QjF8DmGQW3FFCV?=
 =?us-ascii?Q?XbBxlJWQuboyb3iKYp7MSsI7Qx10GtK9JsV1Fds5lQPb5L6aWV3tonlYjA3h?=
 =?us-ascii?Q?6wir6lYSL68k2MvHYK133sKKNi6uRH0BcbEMr151WraFCEaN3r8W/kHgKv6q?=
 =?us-ascii?Q?6cnQXKz2b3Xc8Fp7N5jEK5irloqVOS+j5OFi67otnuH/01IoiFo5MF3Ju13E?=
 =?us-ascii?Q?m7VEmqh9fdnpL0kXBHuyMQ25E96Psws43oLpLhR2aFjgF85CBNZhJqqPecOz?=
 =?us-ascii?Q?QIONAZSyNDj4+Dsn3SL4wJUaiN2A2at63Cq4TYK4sgiRJ2HEyqnkJL91x2Jb?=
 =?us-ascii?Q?olJUNli6X3KOcflzcW3xmGYt2iYb8jn8EYgKlTKb21GLHj4CCTp1g3uIoYdy?=
 =?us-ascii?Q?cNKCD5bvMoaHG04h0Rw8LV6hotL5eSjVZMCtoeFuMlAJ5XIo+JNXY4HiRa5v?=
 =?us-ascii?Q?+mmSi0hjUQmedZfbo0ENnkgzsfpKdI7vsdaKQ8+u5RlHUgwWOAvzvvDs620R?=
 =?us-ascii?Q?n7ZQ5AixsdAHGW7lPasM5o07Ai59mhyN7jYJsFHTome4AXCfVCzOLAptJUW/?=
 =?us-ascii?Q?TikPocoszVbRyw8QVrpTf1mOZJqafIIIszTXPxlaJVilgE3jWGkWxffUKmGC?=
 =?us-ascii?Q?zpNjpu7oL/+ZGCRdTQINArL+nYsifCA3N7GcvAXlZWFtAmCQbSIS/IsvzS05?=
 =?us-ascii?Q?iqPRuWs1RS6JbmU+hom35JVljccigrA0OaFxhergY0DREbCcDA2kb9wxz9v6?=
 =?us-ascii?Q?mEcwCvN3VrbCjgBZNl3kJJ6GJ6iiqx0223xbrohKSNpP+BkH0QQMnYae3Yrb?=
 =?us-ascii?Q?9xkx0iUhS2QzRQEp5HbpReEmhtkcc1MSV1g2j04trMi7CAmR8AGiQyYIRkOa?=
 =?us-ascii?Q?Cheu5zIhlgPKKxWuTKBWwKGL+ImZx1FCeLwleTiiP2XESbdB4GSq9BYsRn/5?=
 =?us-ascii?Q?J87nrAPqpxGm0kM36kCAZtz58fSTcjpRWb4Fk/1q0ttrgmBAbSINPDeqo5cE?=
 =?us-ascii?Q?7IaYjc1Qtl8i1ywbP9iNWWmgsM/lcXVSnm2M3fYuCGxoEDgMGpGU/lAkgYyp?=
 =?us-ascii?Q?gLNM1lz7Bfx0Emd8vKn0NjYBAXc7XEY7zthmzk/BjSK5q7RCMXwL?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0d9042-5ba4-4a87-c0f4-08df2f4e85fa
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 08:37:21.3262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R64WbKRIiB8F5XsZP5DBKbfKKYEJ7hYNjgl9bMy+DhAWXkZ3C4Z3RqIikjH7XA2iFhgELmfF+0NE0vFKyIIyN3FLadlJEw1k5EzB5s8lsTfUkNJySyn5rG1PKpHu/nXi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1047

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

Rework the StarFive TRNG driver to address hardware-specific requirements
  for JHB100 SoC. To avoid reset-domain crossing glitches, the driver now
  ensures clocks are gated before asserting reset during teardown for
  JHB100, while JH7110 retains the original reset-first sequence.

Add per-compatible match data (struct starfive_trng_data) describing the
  clock/reset teardown order, a new "starfive,jhb100-trng" compatible, and
  select the ordering from it.

Fix the runtime-PM get/put balancing across the init/read/reseed/cleanup
  paths, manage PM and the clk/reset teardown via devm so all error paths
  unwind correctly, run the SEU-triggered reseed from a workqueue instead
  of hard IRQ, and serialise the command sequences with a mutex.

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 MAINTAINERS                          |   2 +-
 drivers/char/hw_random/jh7110-trng.c | 559 +++++++++++++++++++--------
 2 files changed, 409 insertions(+), 152 deletions(-)

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
diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index aee12caab578..8678b35ecd4a 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -1,25 +1,34 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * TRNG driver for the StarFive JH7110 SoC
+ * TRNG driver for the StarFive JH7110/JHB100 SoCs
  *
  * Copyright (C) 2022 StarFive Technology Co.
  */
 
+#include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
-#include <linux/delay.h>
+#include <linux/container_of.h>
+#include <linux/device.h>
+#include <linux/devm-helpers.h>
 #include <linux/err.h>
+#include <linux/errno.h>
 #include <linux/hw_random.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
-#include <linux/kernel.h>
+#include <linux/jiffies.h>
+#include <linux/lockdep.h>
+#include <linux/minmax.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
-#include <linux/of.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-#include <linux/random.h>
+#include <linux/property.h>
 #include <linux/reset.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
 
 /* trng register offset */
 #define STARFIVE_CTRL			0x00
@@ -78,36 +87,64 @@
 #define STARFIVE_ISTAT_SEED_DONE	BIT(1)
 #define STARFIVE_ISTAT_LFSR_LOCKUP	BIT(4)
 
+#define STARFIVE_ISTAT_ALL		(STARFIVE_ISTAT_RAND_RDY | \
+					 STARFIVE_ISTAT_SEED_DONE | \
+					 STARFIVE_ISTAT_LFSR_LOCKUP)
+
 #define STARFIVE_RAND_LEN		sizeof(u32)
+#define STARFIVE_RANDRESEED_TIMEOUT_MS	50
+#define STARFIVE_RANDGEN_TIMEOUT_MS	20
+#define STARFIVE_RANDGEN_NOWAIT_TIMEOUT	1
 
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
+	int			irq;
 	struct clk		*hclk;
 	struct clk		*ahb;
 	struct reset_control	*rst;
 	struct hwrng		rng;
 	struct completion	random_done;
 	struct completion	reseed_done;
+	struct work_struct	work;
+	const struct starfive_trng_data *data;
 	u32			mode;
 	u32			mission;
-	u32			reseed;
-	/* protects against concurrent write to ctrl register */
-	spinlock_t		write_lock;
+	bool			need_reseed;
+	bool			initialized;
+	bool			clk_on;
+	bool			rst_deassert;
+	struct mutex		lock; /* protect trng cmd seq */
 };
 
+static inline struct starfive_trng *work_to_trng(struct work_struct *work)
+{
+	return container_of(work, struct starfive_trng, work);
+}
+
 static u16 autoreq;
 module_param(autoreq, ushort, 0);
 MODULE_PARM_DESC(autoreq, "Auto-reseeding after random number requests by host reaches specified counter:\n"
@@ -120,276 +157,496 @@ MODULE_PARM_DESC(autoage, "Auto-reseeding after specified timer countdowns to 0:
 				" 0 - disable timer\n"
 				" other - reload value for internal timer");
 
-static inline int starfive_trng_wait_idle(struct starfive_trng *trng)
+static bool starfive_trng_idle(struct starfive_trng *trng, bool wait)
 {
-	u32 stat;
+	u32 stat, busy = STARFIVE_STAT_RAND_GENERATING | STARFIVE_STAT_RAND_SEEDING;
 
-	return readl_relaxed_poll_timeout(trng->base + STARFIVE_STAT, stat,
-					  !(stat & (STARFIVE_STAT_RAND_GENERATING |
-						    STARFIVE_STAT_RAND_SEEDING)),
-					  10, 100000);
+	if (!wait)
+		return !(readl_relaxed(trng->base + STARFIVE_STAT) & busy);
+
+	return !readl_relaxed_poll_timeout(trng->base + STARFIVE_STAT, stat,
+					   !(stat & busy),
+					   10, 100000);
 }
 
-static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
+static void starfive_trng_irq_clear(struct starfive_trng *trng)
 {
-	/* clear register: ISTAT */
-	u32 data = readl(trng->base + STARFIVE_ISTAT);
+	u32 istat = readl(trng->base + STARFIVE_ISTAT);
+
+	/* Do not lose an LFSR lockup that has not been serviced yet. */
+	if (istat & STARFIVE_ISTAT_LFSR_LOCKUP)
+		WRITE_ONCE(trng->need_reseed, true);
 
-	writel(data, trng->base + STARFIVE_ISTAT);
+	writel(istat, trng->base + STARFIVE_ISTAT);
 }
 
-static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, bool wait)
+static int starfive_trng_power_on(struct starfive_trng *trng)
 {
-	int wait_time = 1000;
+	int ret;
 
-	/* allow up to 40 us for wait == 0 */
-	if (!wait)
-		wait_time = 40;
+	if (!trng->clk_on) {
+		ret = clk_prepare_enable(trng->hclk);
+		if (ret)
+			goto err_hclk;
+
+		ret = clk_prepare_enable(trng->ahb);
+		if (ret)
+			goto err_ahb;
+
+		trng->clk_on = true;
+	}
+
+	if (!trng->rst_deassert) {
+		ret = reset_control_deassert(trng->rst);
+		if (ret)
+			goto err_rst;
+
+		trng->rst_deassert = true;
+	}
+
+	return 0;
+
+err_rst:
+	clk_disable_unprepare(trng->ahb);
+err_ahb:
+	clk_disable_unprepare(trng->hclk);
+	trng->clk_on = false;
+err_hclk:
+	return ret;
+}
+
+static void starfive_trng_power_off(struct starfive_trng *trng, bool assert_rst)
+{
+	bool clk_first = trng->data->seq_rst_clk == SEQ_CLK_FIRST;
+	bool do_rst = assert_rst && trng->rst_deassert;
+
+	if (do_rst && !clk_first) {
+		reset_control_assert(trng->rst);
+		trng->rst_deassert = false;
+	}
+
+	if (trng->clk_on) {
+		clk_disable_unprepare(trng->ahb);
+		clk_disable_unprepare(trng->hclk);
+		trng->clk_on = false;
+	}
+
+	if (do_rst && clk_first) {
+		reset_control_assert(trng->rst);
+		trng->rst_deassert = false;
+	}
+}
+
+static void starfive_trng_power_off_action(void *data)
+{
+	starfive_trng_power_off(data, true);
+}
+
+static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, unsigned long timeout, bool wait)
+{
+	struct completion *done;
+
+	lockdep_assert_held(&trng->lock);
+
+	if (!starfive_trng_idle(trng, wait))
+		return wait ? -ETIMEDOUT : -EBUSY;
 
 	switch (cmd) {
 	case STARFIVE_CTRL_GENE_RANDNUM:
-		reinit_completion(&trng->random_done);
-		spin_lock_irq(&trng->write_lock);
-		writel(cmd, trng->base + STARFIVE_CTRL);
-		spin_unlock_irq(&trng->write_lock);
-		if (!wait_for_completion_timeout(&trng->random_done, usecs_to_jiffies(wait_time)))
-			return -ETIMEDOUT;
+		done = &trng->random_done;
 		break;
 	case STARFIVE_CTRL_EXEC_RANDRESEED:
-		reinit_completion(&trng->reseed_done);
-		spin_lock_irq(&trng->write_lock);
-		writel(cmd, trng->base + STARFIVE_CTRL);
-		spin_unlock_irq(&trng->write_lock);
-		if (!wait_for_completion_timeout(&trng->reseed_done, usecs_to_jiffies(wait_time)))
-			return -ETIMEDOUT;
+		done = &trng->reseed_done;
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	reinit_completion(done);
+	writel(cmd, trng->base + STARFIVE_CTRL);
+	if (!wait_for_completion_timeout(done, timeout)) {
+		synchronize_irq(trng->irq);
+		if (!try_wait_for_completion(done))
+			return -ETIMEDOUT;
+	}
+
 	return 0;
 }
 
-static int starfive_trng_init(struct hwrng *rng)
+static int starfive_trng_reseed(struct starfive_trng *trng)
 {
-	struct starfive_trng *trng = to_trng(rng);
-	u32 mode, intr = 0;
+	int ret;
+
+	lockdep_assert_held(&trng->lock);
+
+	WRITE_ONCE(trng->need_reseed, false);
+	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED,
+				msecs_to_jiffies(STARFIVE_RANDRESEED_TIMEOUT_MS), true);
+	if (ret)
+		WRITE_ONCE(trng->need_reseed, true);
+
+	return ret;
+}
+
+static void starfive_trng_hw_setup(struct starfive_trng *trng)
+{
+	u32 mode;
 
 	/* setup Auto Request/Age register */
 	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
 	writel(autoreq, trng->base + STARFIVE_AUTO_RQSTS);
 
-	/* clear register: ISTAT */
-	starfive_trng_irq_mask_clear(trng);
+	mode = readl(trng->base + STARFIVE_MODE);
+	if (trng->mode == PRNG_128BIT)
+		mode &= ~STARFIVE_MODE_R256;
+	else
+		mode |= STARFIVE_MODE_R256;
+	writel(mode, trng->base + STARFIVE_MODE);
+}
 
-	intr |= STARFIVE_IE_ALL;
-	writel(intr, trng->base + STARFIVE_IE);
+static int starfive_trng_init(struct hwrng *rng)
+{
+	struct starfive_trng *trng = to_trng(rng);
+	int ret;
 
-	mode  = readl(trng->base + STARFIVE_MODE);
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_err(trng->dev, "Failed to wake device for init: %d\n", ret);
+		return ret;
+	}
 
-	switch (trng->mode) {
-	case PRNG_128BIT:
-		mode &= ~STARFIVE_MODE_R256;
-		break;
-	case PRNG_256BIT:
-		mode |= STARFIVE_MODE_R256;
-		break;
-	default:
-		mode |= STARFIVE_MODE_R256;
-		break;
+	mutex_lock(&trng->lock);
+
+	starfive_trng_irq_clear(trng);
+	starfive_trng_hw_setup(trng);
+
+	enable_irq(trng->irq);
+	writel(STARFIVE_IE_ALL, trng->base + STARFIVE_IE);
+
+	ret = starfive_trng_reseed(trng);
+	if (ret) {
+		writel(0, trng->base + STARFIVE_IE);
+		disable_irq(trng->irq);
+		starfive_trng_irq_clear(trng);
+	} else {
+		trng->initialized = true;
 	}
 
-	writel(mode, trng->base + STARFIVE_MODE);
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_autosuspend(trng->dev);
+
+	return ret;
+}
+
+static void starfive_trng_reseed_work(struct work_struct *work)
+{
+	struct starfive_trng *trng = work_to_trng(work);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_err(trng->dev, "Failed to wake device for reseed: %d\n", ret);
+		return;
+	}
+
+	mutex_lock(&trng->lock);
+
+	if (!READ_ONCE(trng->need_reseed) || !trng->initialized)
+		goto unlock;
 
-	return starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+	ret = starfive_trng_reseed(trng);
+	if (ret)
+		dev_err(trng->dev, "Reseed after LFSR lockup failed: %d\n", ret);
+
+unlock:
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_autosuspend(trng->dev);
 }
 
 static irqreturn_t starfive_trng_irq(int irq, void *priv)
 {
 	u32 status;
-	struct starfive_trng *trng = (struct starfive_trng *)priv;
+	struct starfive_trng *trng = priv;
 
-	status = readl(trng->base + STARFIVE_ISTAT);
-	if (status & STARFIVE_ISTAT_RAND_RDY) {
-		writel(STARFIVE_ISTAT_RAND_RDY, trng->base + STARFIVE_ISTAT);
-		complete(&trng->random_done);
-	}
+	status = readl(trng->base + STARFIVE_ISTAT) & STARFIVE_ISTAT_ALL;
+	if (!status)
+		return IRQ_NONE;
 
-	if (status & STARFIVE_ISTAT_SEED_DONE) {
-		writel(STARFIVE_ISTAT_SEED_DONE, trng->base + STARFIVE_ISTAT);
-		complete(&trng->reseed_done);
-	}
+	writel(status, trng->base + STARFIVE_ISTAT);
 
+	/* SEU occurred, reseeding required */
 	if (status & STARFIVE_ISTAT_LFSR_LOCKUP) {
-		writel(STARFIVE_ISTAT_LFSR_LOCKUP, trng->base + STARFIVE_ISTAT);
-		/* SEU occurred, reseeding required*/
-		spin_lock(&trng->write_lock);
-		writel(STARFIVE_CTRL_EXEC_RANDRESEED, trng->base + STARFIVE_CTRL);
-		spin_unlock(&trng->write_lock);
+		WRITE_ONCE(trng->need_reseed, true);
+		queue_work(system_freezable_wq, &trng->work);
 	}
 
+	if (status & STARFIVE_ISTAT_RAND_RDY)
+		complete(&trng->random_done);
+
+	if (status & STARFIVE_ISTAT_SEED_DONE)
+		complete(&trng->reseed_done);
+
 	return IRQ_HANDLED;
 }
 
 static void starfive_trng_cleanup(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
+	int ret;
 
-	writel(0, trng->base + STARFIVE_CTRL);
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_err(trng->dev, "Failed to wake device for cleanup: %d\n", ret);
+		mutex_lock(&trng->lock);
+		trng->initialized = false;
+		mutex_unlock(&trng->lock);
+		disable_irq(trng->irq);
+		cancel_work_sync(&trng->work);
+		return;
+	}
 
-	reset_control_assert(trng->rst);
-	clk_disable_unprepare(trng->hclk);
-	clk_disable_unprepare(trng->ahb);
+	mutex_lock(&trng->lock);
+	trng->initialized = false;
+	writel(0, trng->base + STARFIVE_IE);
+	starfive_trng_irq_clear(trng);
+	mutex_unlock(&trng->lock);
+
+	disable_irq(trng->irq);
+	cancel_work_sync(&trng->work);
+
+	mutex_lock(&trng->lock);
+	writel(STARFIVE_CTRL_EXEC_NOP, trng->base + STARFIVE_CTRL);
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_sync_suspend(trng->dev);
 }
 
 static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
 	struct starfive_trng *trng = to_trng(rng);
-	int ret;
-
-	pm_runtime_get_sync(trng->dev);
+	unsigned long timeout;
+	int ret, retry = 1;
 
-	if (trng->mode == PRNG_256BIT)
-		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
-	else
-		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 4));
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_warn_ratelimited(trng->dev, "Failed to wake device for read: %d\n", ret);
+		return ret;
+	}
 
 	if (wait) {
-		ret = starfive_trng_wait_idle(trng);
-		if (ret) {
-			ret = -ETIMEDOUT;
+		mutex_lock(&trng->lock);
+		timeout = msecs_to_jiffies(STARFIVE_RANDGEN_TIMEOUT_MS);
+	} else {
+		/* allow up to 1 jiffy for wait == 0 */
+		if (!mutex_trylock(&trng->lock)) {
+			ret = 0;
 			goto out_put;
 		}
+		timeout = STARFIVE_RANDGEN_NOWAIT_TIMEOUT;
 	}
 
-	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, wait);
-	if (ret)
-		goto out_put;
+	for (;;) {
+		/*
+		 * A pending LFSR lockup taints the next sample. Blocking
+		 * callers reseed here; non-blocking callers return no data,
+		 * the reseed work is already queued.
+		 */
+		if (READ_ONCE(trng->need_reseed)) {
+			if (!wait) {
+				ret = 0;
+				goto out_unlock;
+			}
+			ret = starfive_trng_reseed(trng);
+			if (ret)
+				goto out_unlock;
+		}
+
+		ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, timeout, wait);
+		if (ret) {
+			if (!wait && (ret == -EBUSY || ret == -ETIMEDOUT))
+				ret = 0;
+			goto out_unlock;
+		}
+
+		/* Lockup reported together with RAND_RDY: reseed and retry once */
+		if (!READ_ONCE(trng->need_reseed))
+			break;
+
+		if (!wait || !retry--) {
+			ret = 0;
+			goto out_unlock;
+		}
+	}
+
+	if (trng->mode == PRNG_256BIT)
+		max = min(max, STARFIVE_RAND_LEN * 8);
+	else
+		max = min(max, STARFIVE_RAND_LEN * 4);
 
 	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);
+
 	ret = max;
 
+out_unlock:
+	mutex_unlock(&trng->lock);
+
 out_put:
-	pm_runtime_put_sync_autosuspend(trng->dev);
+	pm_runtime_put_autosuspend(trng->dev);
+
 	return ret;
 }
 
 static int starfive_trng_probe(struct platform_device *pdev)
 {
-	int ret;
-	int irq;
+	struct device *dev = &pdev->dev;
 	struct starfive_trng *trng;
+	int ret;
 
-	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
+	trng = devm_kzalloc(dev, sizeof(*trng), GFP_KERNEL);
 	if (!trng)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, trng);
-	trng->dev = &pdev->dev;
+
+	trng->dev = dev;
+	trng->data = device_get_match_data(dev);
+	if (!trng->data)
+		return dev_err_probe(dev, -ENODEV, "No match data\n");
 
 	trng->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(trng->base))
-		return dev_err_probe(&pdev->dev, PTR_ERR(trng->base),
-				     "Error remapping memory for platform device.\n");
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
-	init_completion(&trng->random_done);
-	init_completion(&trng->reseed_done);
-	spin_lock_init(&trng->write_lock);
+		return dev_err_probe(dev, PTR_ERR(trng->base),
+				     "Error remapping memory for platform device\n");
 
-	ret = devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->name,
-			       (void *)trng);
-	if (ret)
-		return ret;
-
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
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
-	reset_control_deassert(trng->rst);
+	trng->irq = platform_get_irq(pdev, 0);
+	if (trng->irq < 0)
+		return trng->irq;
 
-	trng->rng.name = dev_driver_string(&pdev->dev);
+	trng->rng.name = dev_driver_string(dev);
 	trng->rng.init = starfive_trng_init;
 	trng->rng.cleanup = starfive_trng_cleanup;
 	trng->rng.read = starfive_trng_read;
 
-	trng->mode = PRNG_256BIT;
 	trng->mission = 1;
-	trng->reseed = RANDOM_RESEED;
+	trng->mode = PRNG_256BIT;
+
+	init_completion(&trng->random_done);
+	init_completion(&trng->reseed_done);
 
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
-	pm_runtime_enable(&pdev->dev);
+	ret = devm_mutex_init(dev, &trng->lock);
+	if (ret)
+		return ret;
 
-	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
-	if (ret) {
-		pm_runtime_disable(&pdev->dev);
+	ret = starfive_trng_power_on(trng);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to power on\n");
 
-		reset_control_assert(trng->rst);
-		clk_disable_unprepare(trng->ahb);
-		clk_disable_unprepare(trng->hclk);
+	ret = devm_add_action_or_reset(dev, starfive_trng_power_off_action, trng);
+	if (ret)
+		return ret;
 
-		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
-	}
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_autosuspend_delay(dev, 100);
+
+	ret = devm_pm_runtime_set_active_enabled(dev);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to enable runtime PM\n");
+
+	ret = devm_work_autocancel(dev, &trng->work, starfive_trng_reseed_work);
+	if (ret)
+		return ret;
+
+	ret = devm_request_irq(dev, trng->irq, starfive_trng_irq, IRQF_NO_AUTOEN,
+			       dev_name(dev), trng);
+	if (ret)
+		return ret;
+
+	ret = devm_hwrng_register(dev, &trng->rng);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to register hwrng\n");
+
+	pm_runtime_idle(dev);
 
 	return 0;
 }
 
-static int __maybe_unused starfive_trng_suspend(struct device *dev)
+static int starfive_trng_suspend(struct device *dev)
 {
 	struct starfive_trng *trng = dev_get_drvdata(dev);
+	bool assert_rst;
 
-	clk_disable_unprepare(trng->hclk);
-	clk_disable_unprepare(trng->ahb);
+	mutex_lock(&trng->lock);
+	assert_rst = !trng->initialized;
+	writel(0, trng->base + STARFIVE_IE);
+	starfive_trng_irq_clear(trng);
+	mutex_unlock(&trng->lock);
+
+	synchronize_irq(trng->irq);
+	starfive_trng_power_off(trng, assert_rst);
 
 	return 0;
 }
 
-static int __maybe_unused starfive_trng_resume(struct device *dev)
+static int starfive_trng_resume(struct device *dev)
 {
 	struct starfive_trng *trng = dev_get_drvdata(dev);
+	int ret;
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
+	ret = starfive_trng_power_on(trng);
+	if (ret) {
+		dev_err(dev, "Failed to power on: %d\n", ret);
+		return ret;
+	}
+
+	if (trng->initialized) {
+		starfive_trng_irq_clear(trng);
+		writel(STARFIVE_IE_ALL, trng->base + STARFIVE_IE);
+	}
 
 	return 0;
 }
 
-static const struct dev_pm_ops starfive_trng_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(starfive_trng_suspend,
-				starfive_trng_resume)
-	SET_RUNTIME_PM_OPS(starfive_trng_suspend,
-			   starfive_trng_resume, NULL)
+static const struct starfive_trng_data jh7110_data = {
+	.seq_rst_clk = SEQ_RST_FIRST,
 };
 
-static const struct of_device_id trng_dt_ids[] __maybe_unused = {
-	{ .compatible = "starfive,jh7110-trng" },
+static const struct starfive_trng_data jhb100_data = {
+	.seq_rst_clk = SEQ_CLK_FIRST,
+};
+
+static const struct of_device_id trng_dt_ids[] = {
+	{ .compatible = "starfive,jh7110-trng", .data = &jh7110_data },
+	{ .compatible = "starfive,jhb100-trng", .data = &jhb100_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, trng_dt_ids);
 
+static DEFINE_RUNTIME_DEV_PM_OPS(starfive_trng_pm_ops,
+				 starfive_trng_suspend, starfive_trng_resume, NULL);
+
 static struct platform_driver starfive_trng_driver = {
 	.probe	= starfive_trng_probe,
 	.driver	= {
 		.name		= "jh7110-trng",
-		.pm		= &starfive_trng_pm_ops,
-		.of_match_table	= of_match_ptr(trng_dt_ids),
+		.pm		= pm_ptr(&starfive_trng_pm_ops),
+		.of_match_table	= trng_dt_ids,
 	},
 };
 
-- 
2.43.0


Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2098.outbound.protection.partner.outlook.cn [139.219.17.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF07E377A8E;
	Mon,  7 Sep 2026 04:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756658; cv=fail; b=VPqmRFapbaJ6xXCqHpB91IxR2oii11e/udMfGBofdddhUGgjIJG7Yp804IFdb36A6puLN5BBFnUh8p9ln4pG8yu9fjmKOK1q02w67+gqxkCmxBlrYZzx1e1v05sMtq7juiIafrJhos0/NhgKMYgWChuZHkLb4DxJOcyN37B+DkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756658; c=relaxed/simple;
	bh=269JVTYurMzcVlxQ6ir4eL0tDY1mZ9uL3MOeRPc9Ww0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ckf9JZB1sEWBcR6G1Jzuiqy52yFy890UsFSbhOioGGZ90l+bUvq5OTW+Sm0KKNSQq5p6kVzbn9JtA6xiqSdYbqvv9O6b39259160Hf91SHT6vh9i9xTPdzJ8tVGu4IEhJ85Od8C/4654MTvM7jfz2jPmby2idVyG+7Tz3yiqAWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wt0hi9U9aizUT9riJNRYUcZw7DY4kNQfgtoxQPxHOUTb9nim8/1MRVuLmJkuj+Hku5n1N74Zl1MtWmqLuU6H/Hs37q2e1oz3JCAhsIREB5sPNFW+b7zukJudhNUE+OMhHH/NUeDBwW2K5hzr8WZC5u+yGK8k1Y79qymieQQUVdd0sOsOYRR7y7apRG8iyKSTa5IDwH9k8v1o0L8bqbDBtEmfQ682k+Jz3JD7VM5NY4IlvGM7EmmQrNE4prT3Uoz60Qqw+ixWszdBpYXabuWX3wgtvA01HCEb6FNDCnIgR1lkP8aZgymIxIQYi8R9xi6kIl5qkkQcgI3pRJRg3mw55g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i1MNcZm62LUm+9TBBCHtVsaDxbbWAlDv4K3HB/rJAx8=;
 b=jSxwGGb1c/Qzr4C71rWB1kcnG13kK6jABxYe2DNOWk5NQiOPlggAM1P9CLSK/+6aWJexAQvqkIyAC7aVkSetl7wAYPMcrywzIxcVudh6NI1PQVzA+3jkcfWpTx9B0UiJz1mXmS1rZHL0wlEpjQIAGI4eqrwcmWr73H7uw/PNXnjwjDJ/d5TfHqXFDG6GCokOewHnWwGQFVn5vkNQGy0nqqhlLtn9VYPS0o8kaKW+MMbNBpaB5/UnGuQTS35Qdd4f7kdnQngo5Z0yoDdKL8YzlTfaOCeVYUdPDYETn8I0TS4yNjgjjwZ//NTrAOBUPKIHWVJkHtTD/OMW4i/b9ziT7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1320.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:19::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.18; Mon, 7 Sep
 2026 03:16:13 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0339.017; Mon, 7 Sep 2026
 03:16:13 +0000
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
Subject: [PATCH v8 2/2] hwrng: starfive: rework clk/reset teardown order for JHB100
Date: Mon,  7 Sep 2026 11:16:03 +0800
Message-Id: <20260907031603.188483-3-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907031603.188483-1-lianfeng.ouyang@starfivetech.com>
References: <20260907031603.188483-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0033.CHNPR01.prod.partner.outlook.cn (10.2.8.10)
 To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn (10.2.3.134)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1320:EE_
X-MS-Office365-Filtering-Correlation-Id: 1de7c392-b88d-4f8a-ed53-08df0c8e5f73
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|52116014|10067099003|6133799003|22082099003|18002099003|56012099006|38350700014;
X-Microsoft-Antispam-Message-Info:
	DCnjtSRfFXsLM5okghf7BMfrqHvLYD0nmE0Ia9JfgDh0C3Tl8mdIEfzPJaSzbeDvVO3NxF6+8UzjunuAQP3WjyMwqIdmiykUele3PSO0GQ8n2eC6Cg2v0KZOQE1f4OV1FmMM9JMsVNvB6del+qmNCIZyfdqWczIfarlRbOpXzMsQM0zEZK16FN4x64e22jMJa9KuhFnkk6bjltZFy0eC8hT2NaeD/p2tQ9CtVC929lRoeWAsWqNV5QmawD5W+5WWsQpsE3CAF+Z7bczUBs2QZ9UHB4VoaqHA8WR7u8UEql+9rffumDpUOFmO9iylV+m4fRZdEPZHLIS6AjFNoPtap/rJ2onasLCah574bWPkkAv8Jf1WOEoZYSI4qGm+/6mrujdz8lKfoNMALtyYB1vlKfejzzLV322ABpZ4uxwfgP8zlRh8zyquV30u2zDhrmc+u1iEoDwlMO8kPVRXmKJEPcwWGE1lxXyOk7FDtXGDnrAGQISv87K1VIjKc+w+13NpVGh3DEjhowIn0f6p+UMmRXJGs5H56yFrLqmNlgLqUydGNHz4oH1HZTnPi+b2+ctc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(52116014)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h82T3dTNRo9yrS5ZUpWhHp5qw0zNx4XUKYkuJ2zZfFl2LEmiYy/sgRXEsMtf?=
 =?us-ascii?Q?7ka9JDgtWriyG6+jNqmdFrukeCD5lBHUtPZbI+FHHX6o7xNzpQxQ8TO38y9y?=
 =?us-ascii?Q?Kx7zO5/lFPsSD5lQj6qxUoGJWkh5MXsFAZP8n1PS4RBYqrCvWKx9qLYc3U6G?=
 =?us-ascii?Q?+InPRAw4MHZf+JGFZADQVSxo/6vfKbRlHbQ9SEGedmoRdfViAXrP3k0GDIEg?=
 =?us-ascii?Q?32J1I8zUEF4wfVaL++3IwlkowoRjXEYJ1Fkljvwc3LdP8r7t+nIWOKlwCUt/?=
 =?us-ascii?Q?0RN64pEEfOI2dWJyVwCi29v5CUBnXnweVl5a28StnDWUnS7KSaiOg4Rg8Ntq?=
 =?us-ascii?Q?xzgCEZ2/yQnH1i9q9x+GU/xfZnJ8mRmbdoPAymBBBLhBW1ZzCqlBoTRqXqSr?=
 =?us-ascii?Q?feOqIHPnKTFwJZQv5C/lSlOcGHNGL/m9jrhK8QpZ94JbRijN+NwYrFkKvqff?=
 =?us-ascii?Q?p7c15m4pEcCwgFsFhnpJu1faA5gut1r4xSP5GIoZwMSy/dzsvySsNEFPWAiq?=
 =?us-ascii?Q?mt9/Ad1Vi7Y8As8Y3cDAfQmXoqU0BE3rsTE1uw2ZzX5LZcc5nZvee1J7mMFX?=
 =?us-ascii?Q?u15hUT1dbSiTEbsSzfyDAI02xMHyoD2FLwB2k8aI9lj7OBOipEBAmi0+SmZP?=
 =?us-ascii?Q?fJ9TmxGE9AN2MBtHe7pgSRzwOnV0+/8Eg6wEnAdrO8+vVmbm6SNm3pzPhaEX?=
 =?us-ascii?Q?z6lPFdaxBhQCDhl5TyZgosvKvL9Ihx1H5ZXuDkg2VAuv3ccHxgfnEiUWQS1l?=
 =?us-ascii?Q?MSgbVr5dW1vN1oWSgufg1u5KDZzCYFMMYZHrU4OOXJpyfIpbWeAI6g+91EQp?=
 =?us-ascii?Q?Li30IhNifGq9cJyFWJYRi5YCIddKRucnYaknRz2mO4LDoUoFBf9t/bEvRlUB?=
 =?us-ascii?Q?HTXxZ4h4ld1I9t2wWGnyBtKpccVIOul+e/+CRMkPk4eRTz198UV+y7SIp2Pe?=
 =?us-ascii?Q?TobWXqvSA2r3gvXFe8KRzU3UrPfv8ND6IE4Rlat49opTq+jwfRJY9FrKKfxj?=
 =?us-ascii?Q?9IDngbD4b0bkUJc3BzuP3FRiDG/BTmy9qby8mYRB3WrXrrwkcqyTT9hY+BgJ?=
 =?us-ascii?Q?D6oz8UUZEnPvNBqA3nsKD/BHatihiJ+ccersQWkzNbNPvldvTieX5X4XE1bZ?=
 =?us-ascii?Q?RGLtPx9MCr/F1ovik7IRakATxDjee496+WoMJR1A0robT9RjaZMDDsJ5Z0Lj?=
 =?us-ascii?Q?GadWiuUcAUlVd3hD/Uh3TzadxQIZykC+vsOMz5jiYStpFNeuUPd9sjd6Tcbu?=
 =?us-ascii?Q?ombnlYKUnVNd3DfBFZpFf4OiE1mdTZ3tDUT4BOnTEGyOnYnUwRUQcDMixiHD?=
 =?us-ascii?Q?/nCU/bkNEO1kAU07bELUtQOCxVg2ZUivan8M/uHurQX19c8NqWtBvQqv54YU?=
 =?us-ascii?Q?c9QYVc7aWOsWs7APEV10PgeQGZKdphszgBR0HiuJNUSftsCxpYebpF+F0NNL?=
 =?us-ascii?Q?GpXGKykFkhkZNTUrZe+LdmYjuF+r3PJr7H5kMCk6drzBBphxoRDlIFLKL4yU?=
 =?us-ascii?Q?JiuXhkmPSCkXbPaedeHQuzDIIlH6NkNcLK1wVvAvv7ttTmNqUaEHz2T9zGvc?=
 =?us-ascii?Q?Y4n5SSmJpPOCLUPllV1f8Q6Tt02Ept8Wh/D3DYMmzmQxcYdlHGhRm/lc6HSQ?=
 =?us-ascii?Q?f6klZMtIwGb76/1BlUFTHwh1giFoWwUHULSPl9S+9t7VLixFOw6HnLwzieim?=
 =?us-ascii?Q?9jvmM6aBA21720UjDlJsmxOfW0wZqM+Cz7Y1EULIdbVvhz2atDkZNZru2tEo?=
 =?us-ascii?Q?lpXYSEC4n2VXRdb+BPK8bNzvEidfKhj07Y4Twy6e9dg2WBNntsSn?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de7c392-b88d-4f8a-ed53-08df0c8e5f73
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 03:16:13.7579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nz/PX58C+KTJUR6nd+q7EJuz8TShGatGzxYeuoUZ1EeppRG8mVnkCzpLJcT/4aHR8pyStU30UJpJEjf8s/kj2YIV296MSFHSQxn+4/Ba3WM4eJF1VKBlTzQz/1PDwedX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1320

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
 drivers/char/hw_random/jh7110-trng.c | 297 +++++++++++++++++++++------
 2 files changed, 239 insertions(+), 60 deletions(-)

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
index aee12caab578..ecc7d5bd7bf5 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -92,22 +92,44 @@ enum mode {
 	PRNG_256BIT,
 };
 
+/*
+ * For JHB100, assert reset after disabling clocks to avoid
+ * reset-domain crossing (RDC) induced glitches that can affect
+ * downstream IPs.
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
+	u32			cleanup;
 	u32			mission;
 	u32			reseed;
-	/* protects against concurrent write to ctrl register */
-	spinlock_t		write_lock;
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
@@ -130,7 +152,7 @@ static inline int starfive_trng_wait_idle(struct starfive_trng *trng)
 					  10, 100000);
 }
 
-static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
+static inline void starfive_trng_irq_clear(struct starfive_trng *trng)
 {
 	/* clear register: ISTAT */
 	u32 data = readl(trng->base + STARFIVE_ISTAT);
@@ -138,6 +160,28 @@ static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
 	writel(data, trng->base + STARFIVE_ISTAT);
 }
 
+static void starfive_trng_release(void *data)
+{
+	struct starfive_trng *trng = data;
+
+	if (!pm_runtime_status_suspended(trng->dev)) {
+		writel(0, trng->base + STARFIVE_IE);
+		starfive_trng_irq_clear(trng);
+
+		if (trng->irq >= 0)
+			synchronize_irq(trng->irq);
+
+		if (trng->data->seq_rst_clk == SEQ_RST_FIRST)
+			reset_control_assert(trng->rst);
+
+		clk_disable_unprepare(trng->ahb);
+		clk_disable_unprepare(trng->hclk);
+
+		if (trng->data->seq_rst_clk == SEQ_CLK_FIRST)
+			reset_control_assert(trng->rst);
+	}
+}
+
 static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, bool wait)
 {
 	int wait_time = 1000;
@@ -149,17 +193,13 @@ static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, bool wait)
 	switch (cmd) {
 	case STARFIVE_CTRL_GENE_RANDNUM:
 		reinit_completion(&trng->random_done);
-		spin_lock_irq(&trng->write_lock);
 		writel(cmd, trng->base + STARFIVE_CTRL);
-		spin_unlock_irq(&trng->write_lock);
 		if (!wait_for_completion_timeout(&trng->random_done, usecs_to_jiffies(wait_time)))
 			return -ETIMEDOUT;
 		break;
 	case STARFIVE_CTRL_EXEC_RANDRESEED:
 		reinit_completion(&trng->reseed_done);
-		spin_lock_irq(&trng->write_lock);
 		writel(cmd, trng->base + STARFIVE_CTRL);
-		spin_unlock_irq(&trng->write_lock);
 		if (!wait_for_completion_timeout(&trng->reseed_done, usecs_to_jiffies(wait_time)))
 			return -ETIMEDOUT;
 		break;
@@ -174,13 +214,24 @@ static int starfive_trng_init(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
 	u32 mode, intr = 0;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_warn(trng->dev, "Failed to wake device for init: %d\n", ret);
+		return ret;
+	}
+
+	mutex_lock(&trng->lock);
+
+	WRITE_ONCE(trng->cleanup, 0);
 
 	/* setup Auto Request/Age register */
 	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
 	writel(autoreq, trng->base + STARFIVE_AUTO_RQSTS);
 
 	/* clear register: ISTAT */
-	starfive_trng_irq_mask_clear(trng);
+	starfive_trng_irq_clear(trng);
 
 	intr |= STARFIVE_IE_ALL;
 	writel(intr, trng->base + STARFIVE_IE);
@@ -201,45 +252,105 @@ static int starfive_trng_init(struct hwrng *rng)
 
 	writel(mode, trng->base + STARFIVE_MODE);
 
-	return starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_autosuspend(trng->dev);
+
+	return ret;
+}
+
+static void starfive_trng_randreseed_work(struct work_struct *work)
+{
+	struct starfive_trng *trng = work_to_trng(work);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_warn(trng->dev, "Failed to wake device for reseed: %d\n", ret);
+		return;
+	}
+
+	mutex_lock(&trng->lock);
+
+	if (READ_ONCE(trng->cleanup))
+		goto unlock;
+
+	reinit_completion(&trng->reseed_done);
+	writel(STARFIVE_CTRL_EXEC_RANDRESEED, trng->base + STARFIVE_CTRL);
+
+unlock:
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_autosuspend(trng->dev);
 }
 
 static irqreturn_t starfive_trng_irq(int irq, void *priv)
 {
+	int ret;
 	u32 status;
 	struct starfive_trng *trng = (struct starfive_trng *)priv;
 
+	ret = pm_runtime_get_if_active(trng->dev);
+	if (ret <= 0) {
+		dev_err_ratelimited(trng->dev, "pm is inactive in irq\n");
+		return IRQ_NONE;
+	}
+
 	status = readl(trng->base + STARFIVE_ISTAT);
-	if (status & STARFIVE_ISTAT_RAND_RDY) {
+	if (status & STARFIVE_ISTAT_RAND_RDY)
 		writel(STARFIVE_ISTAT_RAND_RDY, trng->base + STARFIVE_ISTAT);
-		complete(&trng->random_done);
-	}
 
-	if (status & STARFIVE_ISTAT_SEED_DONE) {
+	if (status & STARFIVE_ISTAT_SEED_DONE)
 		writel(STARFIVE_ISTAT_SEED_DONE, trng->base + STARFIVE_ISTAT);
-		complete(&trng->reseed_done);
-	}
 
 	if (status & STARFIVE_ISTAT_LFSR_LOCKUP) {
 		writel(STARFIVE_ISTAT_LFSR_LOCKUP, trng->base + STARFIVE_ISTAT);
 		/* SEU occurred, reseeding required*/
-		spin_lock(&trng->write_lock);
-		writel(STARFIVE_CTRL_EXEC_RANDRESEED, trng->base + STARFIVE_CTRL);
-		spin_unlock(&trng->write_lock);
+		schedule_work(&trng->work);
 	}
 
+	if (status & STARFIVE_ISTAT_RAND_RDY)
+		complete(&trng->random_done);
+
+	if (status & STARFIVE_ISTAT_SEED_DONE)
+		complete(&trng->reseed_done);
+
+	pm_runtime_put_noidle(trng->dev);
+
 	return IRQ_HANDLED;
 }
 
 static void starfive_trng_cleanup(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_warn(trng->dev, "Failed to wake device for cleanup: %d\n", ret);
+		goto end;
+	}
+
+	mutex_lock(&trng->lock);
+
+	writel(0, trng->base + STARFIVE_IE);
+	starfive_trng_irq_clear(trng);
+
+	if (trng->irq >= 0)
+		synchronize_irq(trng->irq);
 
 	writel(0, trng->base + STARFIVE_CTRL);
 
-	reset_control_assert(trng->rst);
-	clk_disable_unprepare(trng->hclk);
-	clk_disable_unprepare(trng->ahb);
+	WRITE_ONCE(trng->cleanup, 1);
+
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_sync(trng->dev);
+
+end:
+	cancel_work_sync(&trng->work);
 }
 
 static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -247,7 +358,18 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	struct starfive_trng *trng = to_trng(rng);
 	int ret;
 
-	pm_runtime_get_sync(trng->dev);
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_warn(trng->dev, "Failed to wake device for read: %d\n", ret);
+		return ret;
+	}
+
+	if (wait) {
+		mutex_lock(&trng->lock);
+	} else {
+		if (!mutex_trylock(&trng->lock))
+			return -EAGAIN;
+	}
 
 	if (trng->mode == PRNG_256BIT)
 		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
@@ -256,28 +378,29 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 
 	if (wait) {
 		ret = starfive_trng_wait_idle(trng);
-		if (ret) {
-			ret = -ETIMEDOUT;
-			goto out_put;
-		}
+		if (ret)
+			goto end;
 	}
 
 	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, wait);
 	if (ret)
-		goto out_put;
+		goto end;
 
 	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);
+
 	ret = max;
 
-out_put:
-	pm_runtime_put_sync_autosuspend(trng->dev);
+end:
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_autosuspend(trng->dev);
+
 	return ret;
 }
 
 static int starfive_trng_probe(struct platform_device *pdev)
 {
 	int ret;
-	int irq;
 	struct starfive_trng *trng;
 
 	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
@@ -285,26 +408,22 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, trng);
+
 	trng->dev = &pdev->dev;
+	trng->data = of_device_get_match_data(&pdev->dev);
+	if (!trng->data)
+		return -EINVAL;
+
+	if (trng->data->seq_rst_clk != SEQ_RST_FIRST && trng->data->seq_rst_clk != SEQ_CLK_FIRST) {
+		dev_err(&pdev->dev, "Unknown seq_rst_clk value\n");
+		return -EINVAL;
+	}
 
 	trng->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(trng->base))
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->base),
 				     "Error remapping memory for platform device.\n");
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
-	init_completion(&trng->random_done);
-	init_completion(&trng->reseed_done);
-	spin_lock_init(&trng->write_lock);
-
-	ret = devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->name,
-			       (void *)trng);
-	if (ret)
-		return ret;
-
 	trng->hclk = devm_clk_get(&pdev->dev, "hclk");
 	if (IS_ERR(trng->hclk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->hclk),
@@ -320,9 +439,14 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->rst),
 				     "Error getting hardware reset line\n");
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
-	reset_control_deassert(trng->rst);
+	init_completion(&trng->random_done);
+	init_completion(&trng->reseed_done);
+	mutex_init(&trng->lock);
+	INIT_WORK(&trng->work, starfive_trng_randreseed_work);
+
+	trng->irq = platform_get_irq(pdev, 0);
+	if (trng->irq < 0)
+		return trng->irq;
 
 	trng->rng.name = dev_driver_string(&pdev->dev);
 	trng->rng.init = starfive_trng_init;
@@ -333,40 +457,86 @@ static int starfive_trng_probe(struct platform_device *pdev)
 	trng->mission = 1;
 	trng->reseed = RANDOM_RESEED;
 
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
-	pm_runtime_enable(&pdev->dev);
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret) {
+		dev_err(&pdev->dev, "hclk clk_enable failed: %d\n", ret);
+		return ret;
+	}
 
-	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
+	ret = clk_prepare_enable(trng->ahb);
 	if (ret) {
-		pm_runtime_disable(&pdev->dev);
+		clk_disable_unprepare(trng->hclk);
+		dev_err(&pdev->dev, "ahb clk_enable failed: %d\n", ret);
+		return ret;
+	}
 
-		reset_control_assert(trng->rst);
+	ret = reset_control_deassert(trng->rst);
+	if (ret) {
 		clk_disable_unprepare(trng->ahb);
 		clk_disable_unprepare(trng->hclk);
+		dev_err(&pdev->dev, "failed to deassert trng\n");
+		return ret;
+	}
 
-		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
+	devm_pm_runtime_set_active_enabled(&pdev->dev);
+
+	ret = devm_request_irq(&pdev->dev, trng->irq, starfive_trng_irq, 0, pdev->name,
+			       (void *)trng);
+	if (ret) {
+		starfive_trng_release(trng);
+		return dev_err_probe(&pdev->dev, ret, "Failed to register interrupt handler\n");
 	}
 
+	ret = devm_add_action_or_reset(&pdev->dev, starfive_trng_release, trng);
+	if (ret)
+		return ret;
+
+	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+
 	return 0;
 }
 
 static int __maybe_unused starfive_trng_suspend(struct device *dev)
 {
 	struct starfive_trng *trng = dev_get_drvdata(dev);
+	bool cleanup = READ_ONCE(trng->cleanup);
+
+	if (cleanup && trng->data->seq_rst_clk == SEQ_RST_FIRST)
+		reset_control_assert(trng->rst);
 
-	clk_disable_unprepare(trng->hclk);
 	clk_disable_unprepare(trng->ahb);
+	clk_disable_unprepare(trng->hclk);
+
+	if (cleanup && trng->data->seq_rst_clk == SEQ_CLK_FIRST)
+		reset_control_assert(trng->rst);
 
 	return 0;
 }
 
 static int __maybe_unused starfive_trng_resume(struct device *dev)
 {
+	int ret;
 	struct starfive_trng *trng = dev_get_drvdata(dev);
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret) {
+		dev_err(trng->dev, "hclk clk_enable failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(trng->ahb);
+	if (ret) {
+		clk_disable_unprepare(trng->hclk);
+		dev_err(trng->dev, "ahb clk_enable failed: %d\n", ret);
+		return ret;
+	}
+
+	if (READ_ONCE(trng->cleanup))
+		reset_control_deassert(trng->rst);
 
 	return 0;
 }
@@ -378,8 +548,17 @@ static const struct dev_pm_ops starfive_trng_pm_ops = {
 			   starfive_trng_resume, NULL)
 };
 
-static const struct of_device_id trng_dt_ids[] __maybe_unused = {
-	{ .compatible = "starfive,jh7110-trng" },
+static const struct starfive_trng_data jh7110_data = {
+	.seq_rst_clk = SEQ_RST_FIRST,
+};
+
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
@@ -389,7 +568,7 @@ static struct platform_driver starfive_trng_driver = {
 	.driver	= {
 		.name		= "jh7110-trng",
 		.pm		= &starfive_trng_pm_ops,
-		.of_match_table	= of_match_ptr(trng_dt_ids),
+		.of_match_table	= trng_dt_ids,
 	},
 };
 
-- 
2.43.0


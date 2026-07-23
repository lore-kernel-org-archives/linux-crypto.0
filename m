Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2121.outbound.protection.partner.outlook.cn [139.219.146.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C583F328A;
	Thu, 23 Jul 2026 07:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784793157; cv=fail; b=e6ch2unHycMAoD8nbKl2ea5xwrNnUvCuXVm8bxifH4/8ZBqV7iguU8VqYE+gCAjMt4vT6PAetc4nqShMLdaf9BHXPhjQnXBPqbJtmQurEuTDxtdMt99W2rtgjXPceqUaI0gXJq7908aoVFQ8QCW19oHby2w/YsegC81GLjicpvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784793157; c=relaxed/simple;
	bh=LOkxN9jNz/wvHUIB5X5kONMI8Y26duySrVqima8P20k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VEPWhiKvYrtlsb8e43xrn+Xab0BRTyhQiWH3CvIGlTrFXJuHdet2kK/Vov2+ibxUAjpErRL3Y21gJt8KPmpRi9wEin53NXDw2fac4srQ34T+sV0Yw+Q9/JcuuMR7KCz53WbFDLKECVvbHP/8sA/Ii2aKSr9trZW1HKtfNZcesCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVrTjxDydQS53ySoWCe2tr9IDwmjqIL+Z8DCdqMB1vmSCYz4dbt0oCt+CB38pc3pYliOP1IgY/fmKkViMolJiI8+AawBtgNbNc/HarmiNfGebSZEDgewpKauztgNj4zFDaaGXig3qtZO3Ihr6qoLhNYNdba+obw3WQssopvd3gGVMk3s9tqci6iRl4migcUjNRF4b0bW6hw8UxkCEdv03aV65ufVdyu0Itpvnk2EttBhh5OHf5dE8X7np+YrcCkdCJquvF2oZZBCoWmJnwR03Qlf/Yjscfpz0j5gW7PFjcSf5hVVRcufjn1NLQbP+InOwLFvVdhiTlQwGpH20Yj+SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5PIwx/8c+BGx0+cQLmmAwp1bbm7ublwiGGnuuEsHmY=;
 b=ZRU9EPfpRrQhMN/gBbXVX17Hz2KqRr7Fsa5fAwMi6905Xo6SrMv7regZz8D190Xkljqe2f7ZDWJvUUpp/7W006Gsqa+9jkyzi1GomjAlS1N8oDNAiJH55EWDJQIXKqI1dSIWZCVVg6dphSZFNCKjLDOcxryBvrKP8G9iUFm6K0aPeYpvjN1F4Va+FxQSq7uY9VE/1wbrjiigYlLz1oQgGlzBKvjZKV7BUtDk9w5NbPDigdcW8s7n26eRgLp1ovb6oc7ATHeX9Q49w2H3bVP+4HPKTYgBO0fRBUSZXHFVJlS1om1Zj2N1m3mZ9JtLvJY020jChMqcCRgIR7ve4FbQhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1126.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 07:52:16 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 07:52:16 +0000
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
Subject: [PATCH v6 2/2] hwrng: starfive: rework clk/reset teardown order for JHB100
Date: Thu, 23 Jul 2026 15:52:06 +0800
Message-Id: <20260723075206.3032-3-lianfeng.ouyang@starfivetech.com>
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
X-MS-Office365-Filtering-Correlation-Id: 09d2cbc8-15e6-44c1-16df-08dee88f50ac
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|23010399003|38350700014|22082099003|18002099003|6133799003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	k3xtuB3c5UlOaQGBo/dPe1CGADjIvxC3qCX+Pp8cqqYy9lHk9UbvXCGU07ktfv6xf4AUEVefTn/tajMJ7LdJ0JN/8L6bSbrwP0k3xoS76wPDL6XiaL38kT8ESnglpFNqNNzELxPW+KJg48Z3axGhShWa8a2S++TrhTmkg1DQmQHsEtGtDQQVT7oZeEgMOHc/84aaCIHKhJLavfsxTEPVLE4H0m0H5nHxyrOZg93Ggp6J4BZzpP52hHlTnr3cpWlM0xWwKyCKKsazUai8JN+yKEYaZDsgAoOOamonsySF6GAdS539SuFDEMYwZmel4XYVMBNa/mPyGyg8ebOVk6/rabp9E2H5LNZp4NoCjzTfclLlZGbtM7haYcJMauPz5o4RdsjojpkU0v3LvoDwkZa+pjd7pvnEndFv0v6/0ZS0zkHtEhLTf96Xzo+S7H6NZm49YPD74rh2bJGG666YPol6gGEz9/gw+MKG3yIJ0Z4IG8/NTci0+tXMTz+wNGrkk8WiJyDk7s1a/NhUwu1oi3WLa5K3Voriio+vsyXfiXYFCMCtstpuQgnVcurS/gFV3dZF
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(23010399003)(38350700014)(22082099003)(18002099003)(6133799003)(10067099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iRGIWF0evDMsIIn3WIkX+EaXG+5RkCNOZrZbz4c70YlLsQIxxcnGep1aHCzL?=
 =?us-ascii?Q?W+dMXLBQCKzlvpivOTos391KMCa4i3Yv/i2UA8gf3HmmDuWroHIqOKZ+NlKJ?=
 =?us-ascii?Q?0vBkjCEcpPaRv3eC3ylaYe8aN2xs7O7RAjsVKq/u5h8g6ccYT3a/UttIt9kF?=
 =?us-ascii?Q?dFLAWihBPCjSwZrm1oH2+/pR5gPWQifV6udANs0XKgWTbqTkriVfJQSQWrV/?=
 =?us-ascii?Q?WqEA50gJGUmVvsFQg4ZXeVJM2hFGH/dKHl0tHUnu9cq49ulT+zhcHvNMlHcA?=
 =?us-ascii?Q?2yvlGVLr888gDTMkVbAxrRHCHETm/K+cm/v8ostxMtlGtocerI+Mm7X1hNBZ?=
 =?us-ascii?Q?rP382l3VE5VoBgFlmGMjrpR3Jq/akE6Dl7njgSdRO6nhhCkzC+RUqtgH2wGD?=
 =?us-ascii?Q?L2sdJwfANAPbhMQ9wiFhhRHo3odVBNzWmYhG/c6TmS6TESJCtUegbyifBJO/?=
 =?us-ascii?Q?OIYMxsdeb2YCceW3oUqFIsoEfPGeNqAk9o14eYjmcqq05L2Lmu+Vs32yZIXW?=
 =?us-ascii?Q?vafgle7bizbsDNSH0eKHXvxqtPx6TB45OEdrbhTEWnvDVqPHXGbREl52f1B5?=
 =?us-ascii?Q?7zRR0pWONQ2MRA1ihdNZbiOy1Oe4nVTw659veByybXL+I2iPTDDLuagq1J/e?=
 =?us-ascii?Q?wVD7AqOIxyQQ2R6S8rZbjQGWUFbbn//IbzT3beZX++edbya0TNYhWZYyhgVa?=
 =?us-ascii?Q?LsCuo7rSkhfsHKkAvhd3/ZXLoppLMccCmO9DyteOp/kOsGqDRf8LW+CGhS05?=
 =?us-ascii?Q?Gl6Q9hBvC3M65ChAhQ+qTptAaQW98uVC8ZFF8nVdJsR9l8atZmm9aZK9F17X?=
 =?us-ascii?Q?9uikCJGbVO0PJxpA3ALiHjDJMqK7w5HrzNNoyJJO34tHOfK+AhYhKWFygNYs?=
 =?us-ascii?Q?321sKogHp0Jr72cr2ZYKfwkm+Qb/V/OJonu8nXQUJjqTjsDCqw6N4yCILuAj?=
 =?us-ascii?Q?oaBwSRamQ1BGNefroY/sQb8jxaIkW6izQrOIK9YUnBAAuakpWb7WZqXs0oT8?=
 =?us-ascii?Q?AKLVwdlJNTrluthW/OZ6ek0nHHmBTCV7pcNhGejEbOHGmVDcoZe+3Ng1YrP0?=
 =?us-ascii?Q?rG75r0rSI6QD/o3wzP5gku/9r5bns2J3KGq+ZlYgwr4cMbkYPqLqYdZoX9NG?=
 =?us-ascii?Q?sRroq3KlSvmCB5M7/+fN7Zzl0Y05NLIDbIanbdmO8lqZsv3gZe35fKoQTDPy?=
 =?us-ascii?Q?KibfcKwYVfIfr8TeHZsN6sUTAGiBb686ruPfWjgg3VTtU/Oa0+ZV0Ng91zmv?=
 =?us-ascii?Q?GrkhPJkqlFFh/c6RsWNy5nUclMRrrhdD52FoxwjOHoC+c4htxUa7qls8HJET?=
 =?us-ascii?Q?odFf0d/7h42znuiDURqA+oH5QIh2krbsk9ZqzPHPLmBTKC/AYo+yiZJomu40?=
 =?us-ascii?Q?3wvhFsIMbYilvUbIqJ4ovly1sHgaabgtuhW631/GzOfb7ePD4RI5MVoJIH9W?=
 =?us-ascii?Q?FGYE8JUxnLmct+momnMfb0/Sdoz7PsbkflLhWMO5fAJQ1Yztft+98R4VBKLT?=
 =?us-ascii?Q?Xk/HBp0YTDextUbr9HubfVhSaS8F0ssFVahSQo6IBLeV0h7DzHvq2H6f3qR+?=
 =?us-ascii?Q?DBZQm4WHqT9W3JhOivNSWgjMwPiULMLwodUuYgl5ogFglE4WkswnTP1U7Tpm?=
 =?us-ascii?Q?Uyih4Y5w2hkp6J76be9eOZtXImE5LnelRvzVLONSZoAPmbgmmccImAVri2OH?=
 =?us-ascii?Q?skLVuVw8o+1f5iDgnrpcRaH5tiCAq5hGaWrpgB13/0HqXa8+Y29TsSPx0hA9?=
 =?us-ascii?Q?0LJnu+7/dXTTXLAtV8prCNuJN2gkU6xQAFOXQg13ALktUnxc5Uga?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d2cbc8-15e6-44c1-16df-08dee88f50ac
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 07:52:16.5543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMrWGvALhzYFxLcUkgrsJgmt7q7UfYW/NsBxuYSJAXHM+MDMRgxKteDreE8t7ddDg0UJeM+bs3LOMOD73bRiCPFeDpDxK+abDsJ3cUspcY3PqJfxlKpJ2FC7fOzdJl+s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1126

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
 drivers/char/hw_random/jh7110-trng.c | 293 +++++++++++++++++++++------
 2 files changed, 237 insertions(+), 58 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d3a6b3f6b6a0..729b20ecc697 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25280,7 +25280,7 @@ F:	Documentation/devicetree/bindings/perf/starfive,jh8100-starlink-pmu.yaml
 F:	drivers/perf/starfive_starlink_pmu.c
 
 STARFIVE TRNG DRIVER
-M:	Jia Jie Ho <jiajie.ho@starfivetech.com>
+M:	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/rng/starfive*
 F:	drivers/char/hw_random/jh7110-trng.c
diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 9776f4daa044..ba56b71ec202 100644
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
@@ -247,7 +358,16 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	struct starfive_trng *trng = to_trng(rng);
 	int ret;
 
-	pm_runtime_get_sync(trng->dev);
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_warn(trng->dev, "Failed to wake device for read: %d\n", ret);
+		return ret;
+	}
+
+	if (!wait && !mutex_trylock(&trng->lock))
+		return -EAGAIN;
+
+	mutex_lock(&trng->lock);
 
 	if (trng->mode == PRNG_256BIT)
 		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
@@ -257,24 +377,28 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	if (wait) {
 		ret = starfive_trng_wait_idle(trng);
 		if (ret)
-			return -ETIMEDOUT;
+			goto end;
 	}
 
 	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, wait);
 	if (ret)
-		return ret;
+		goto end;
 
 	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);
 
-	pm_runtime_put_sync_autosuspend(trng->dev);
+	ret = max;
+
+end:
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_autosuspend(trng->dev);
 
-	return max;
+	return ret;
 }
 
 static int starfive_trng_probe(struct platform_device *pdev)
 {
 	int ret;
-	int irq;
 	struct starfive_trng *trng;
 
 	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
@@ -282,27 +406,22 @@ static int starfive_trng_probe(struct platform_device *pdev)
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
-		return dev_err_probe(&pdev->dev, ret,
-				     "Failed to register interrupt handler\n");
-
 	trng->hclk = devm_clk_get(&pdev->dev, "hclk");
 	if (IS_ERR(trng->hclk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->hclk),
@@ -318,9 +437,14 @@ static int starfive_trng_probe(struct platform_device *pdev)
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
@@ -331,40 +455,86 @@ static int starfive_trng_probe(struct platform_device *pdev)
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
@@ -376,8 +546,17 @@ static const struct dev_pm_ops starfive_trng_pm_ops = {
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
@@ -387,7 +566,7 @@ static struct platform_driver starfive_trng_driver = {
 	.driver	= {
 		.name		= "jh7110-trng",
 		.pm		= &starfive_trng_pm_ops,
-		.of_match_table	= of_match_ptr(trng_dt_ids),
+		.of_match_table	= trng_dt_ids,
 	},
 };
 
-- 
2.43.0


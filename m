Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2090.outbound.protection.partner.outlook.cn [139.219.17.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EA63F7ABC;
	Mon, 29 Jun 2026 08:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782722241; cv=fail; b=tQjdjuV5rkcUnfnrhQc75RfuGxs1ZLGDiizd6XBbIgM3HLxc3iGptzXQo+DfoQmVHbvqp7bHnXIytzTZyqPJvp0bV7jfO7xqi5DfLKoYDQx3EkJ429s/i5cd+kpJ+8HdQHTfJf2/8ORczh3ZV/vRDrJfJpFRelZvfbqakaKvjuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782722241; c=relaxed/simple;
	bh=4a4Zprj6PnrzyVBtnp/oefgjgzSUUACwQQM1XtMer/8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Rha22EqrtHD3U6l/jUfmEn3CtmGvUwUbFIW33JrztjsYaCTat7fJbJsZSrU1Fz15PSigrIrprgWlH/pxLY0wzR748K3TC20czVNK49qGzXyoQkbH3B5nlIFst2dzvvFKwltU8IuSGtY1aV66YWNRogazywatmoJuKasytZOfLvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOeYtm6tM1WuFPKpnUzKacg7zWKqGcS1OcbWQTeEFpQoGuLLHyfiCqrBzyZDIYsclMe+hhjxcpaN3ytyBVh047kYMvOmdUGLXeg5Dimjo/h1JcBa7OSmU4myRJp1v7edJTi67vACVgrbyXryLyg/3w2iCyHI6P8wjkUeClzpJhmHnpdJn1rt9cu0OVaU5kJUKPEfjUCBO8RBWXIvsa2QuLuR28bdH0ujk0pad+WC71uNTAFFpGzvz2ObL3tM2UUQIQyrxi6EmnY4sxGGuuI6Ay6ccFWcC05Xyouhm62OxbnM4WkbtOihnZ2ksq6JX/A1nSH9pADs4ZlNhQbrqnTyyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzqjHhjpTPx+ehSJSzaBbY9QuOHTj/PVkpQVrVz7W9A=;
 b=cs9RqGrHshOBo0o+HHX4RtnYYG/hIRcvbTzyeC2e//mjtoBc87aEeFS4/QjqglkAfMh00n7dGqp7lYUizZCjS33IWRVm2aJ9IyqaqGLHhnn+tc4pXRSiGgk8t54XvUhuJYAkSqi4VUtc4PVMkSs6l689NaildiwJazBHauqa9pZJjUVw6VGLGP+13zqoomw5mQmtSBWaIdAIz1RDEvXdsySphHac5DOCUGMkW7nmrvnDIn139P8mgM1mwnzvtNM1OgusynHlqjiJ6JC71/kdExfJ0jWZBNJgaq1LdkgUgiI0HyWzHX57HfihVvptAdAez0+oM4vgIC/6A/DFG+IAZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1029.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.23; Mon, 29 Jun
 2026 08:37:07 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%5]) with mapi id 15.21.0113.021; Mon, 29 Jun 2026
 08:37:07 +0000
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
Subject: [PATCH v5 2/2] hwrng: starfive: rework clk/reset teardown order for JHB100
Date: Mon, 29 Jun 2026 16:36:58 +0800
Message-Id: <20260629083658.300191-3-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629083658.300191-1-lianfeng.ouyang@starfivetech.com>
References: <20260629083658.300191-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0022.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:5::34) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1029:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f6bbd46-b930-4743-589d-08ded5b99a68
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|23010399003|376014|366016|1800799024|38350700014|6133799003|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	aphDDZ3aBN6jVj1TbBuVQDwfJvY8BfVJmDA55bDxKVuKIrbvbrB8FqI5bMjiTNZKYP1fdFRFQ0G15eGLoXYATfazMBwnJsRlRu65RgEfza/0GK3cDTwgbSJJkGB8SyGWIdcPnYGGmy2WFDEEsXywHUk2y20AWbQ2ASvSw/MgEfA7awu0rAHVk4amnvp6gy2g2NL5vRYPzJ3+y1HcauJRuy28+SDmkzrHKvGVnUEUuieO+eztWKzAEgvVf9MgzA4iTMyY5mxE13YRmn+ywQ2lfAZh/8Dp5IrshfrjcncL4NnuVb4piU3aZc4tGXYyw5nxxS+y7hjeHq0kYCD2HJH4eU6OgCSv6OUz8Ya15UxlsG+JmF01GMp8/7gSAVIgSplIioCl1yUuuTNvaIhZgdB3KPVWlrCx7l8yZmPeamwN/G4vLXN3W2/0SqTu8CXQmQVrQ8xDFIJa8qmjAdx28qrT9V31mKolXtVvBNmUknTROr63r11LcXyR/exNZkbbjMbJzUfgO+vFwV2TIG0kOt1GyMj2491FPHtWrjzh8bIfHOoe+a9PB19DmNx0NR3EIx2k
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(52116014)(23010399003)(376014)(366016)(1800799024)(38350700014)(6133799003)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NP6p7JbyykHAVDDc6vnwqwtChtU76Vz+HJ1B4+uSLqtveSuwMsfi52mvaK3f?=
 =?us-ascii?Q?dYeZnRnCeEjweRadgf1STCH63NwTazjexd2WrqnQ3U3PYP6YGSWQR9atnSO1?=
 =?us-ascii?Q?iyhwgRkTQsl28y6IMbThhOaYlQjW7umQBzl+ZiLrsDM+hklXvo1Vs0jh8nfE?=
 =?us-ascii?Q?5/ghWsRfJk+pXUWm9xkqIO9ZcpSXqtDYzsRilZb36Wuc2e6DNzMajpLyIyow?=
 =?us-ascii?Q?KJlJZR46U0azt9gGaDAFziP0JdR70HL8sa113/QxhZaYIhZRgcg0E49DU/uY?=
 =?us-ascii?Q?vfGLhWEteZ03fV0DN4toRDO0tQKJyhnGLj0gjel/uDfVzs1jHixpMTS7SQbR?=
 =?us-ascii?Q?mmJBEFfvihynRGpBog8Wh9fuO8uAos00lwB1f1bPWE7OXSnO6849HajoEhze?=
 =?us-ascii?Q?ep58K1JX6kGpvDloYkJzN86BARgbbdIDUlLC4kkKMzlkbM4EJjePbNiIoBWD?=
 =?us-ascii?Q?y95j8GmFegzAY1KFveACC/h9VpDaxbwnGTndG3WJT8RJXIpqxYh7ESDS2jJx?=
 =?us-ascii?Q?kToLoZC9/XnA1je1UMvf7NbC0n2iFuDA4Sqps4v7L4VKAtGivR+pbiqRiZ68?=
 =?us-ascii?Q?zIhFf+crSep+VEU0lq/Pyyb5YpQ1l3wT8UFEBV1QvNpIk0RoXNwDs0mncpvm?=
 =?us-ascii?Q?sgqSclBNsGA21R5xn+E6hWjZXJLabY6ceNg6tW8Aggn5N49aLVyeNVEL0i+n?=
 =?us-ascii?Q?Ax1+df8i/AAkx3yjwVcgEsV0FyO00r+Kn+wnllEh1Ck8sXARirmV84YyMYzx?=
 =?us-ascii?Q?ZgFTuxhzNez2WctzXrkSKB0iHJTzJUqeBmvbUSAI7gZ019I7a98L2iX8sX0R?=
 =?us-ascii?Q?+OgDE6hRgqjj/0UMwz0vzzmjAGjdwb/EHhLkdWRf7G0Ua5lMNU976pDMCtJ8?=
 =?us-ascii?Q?3cx1EKnzILcG/0u7aNMideTqH0Fptcetnu91R5I6Fd/li/PZyCZ072av1XU+?=
 =?us-ascii?Q?SOe3Ez5iOOBgcFCqiTv5lPV39a5p0DBa659qoFM3Tm9KYymeBuIJKoF9o4Ln?=
 =?us-ascii?Q?6XjCy8v4QoDlTm+32YU/Zhjn0iUBlVSZFqGrL1yxZsYtvUe5Ys7MZWiFLxs9?=
 =?us-ascii?Q?dLZS5w7G+rsW3yGzaaTPKrOmEgJ6fdPXW9el3MjM7TxJ/qEgwuigLP3bxhS+?=
 =?us-ascii?Q?UiN2hQzsee29K6q/oflJedWH/8QUmng40v0M/++rrWYPYdV6Sb23L74qNbGT?=
 =?us-ascii?Q?T/CLYMiHQeN84FuA79RGl50oUPZtd+y8Jo+pcxnlxo7BioocIIYFzFqYi6Yw?=
 =?us-ascii?Q?kGsx37fGgC6L1zND95Vhwt8qCQ3nVlQnrkNmkI+uonUMtV1v70Dr+PcFZy3s?=
 =?us-ascii?Q?3v7SJRb3Vk7T3JWx3XRbkF5mO1W4opdsda6QgmcgYyYuvobOLjuhFC3rkqN+?=
 =?us-ascii?Q?EUz+097A/O79HgUB2YvBT/RgpIIZMPpaVKQVWitK33hCIyeAhByMyVqpxqR3?=
 =?us-ascii?Q?aWBkhQXniOJkRbIrn721uYTjGNuZp0S2KZ4ClhnXmcmeXBZ7qQe98aCCdNhX?=
 =?us-ascii?Q?MKezEdaVJXeb1CFLQp2tSeMu73UdLETrKtvU4hyZ0foTN1JfL85PIsnNIgOh?=
 =?us-ascii?Q?q1yc7y7B8qqp2Sud6rrmPiACPqULXiDJalSfiaJnqouuB88UWp9cahEeiyEX?=
 =?us-ascii?Q?3Iw3xpXTyqN2gTWgndAduanHM+iFqg740CXVO02DDwSybLdqf3534KzvzmzL?=
 =?us-ascii?Q?nb3QE4fz6KYQb39J5gAWw/AX5mMQ3U8E7253UBA+1TyBwT224PqNKBQnhvfJ?=
 =?us-ascii?Q?sM7hB6Xtc/jS9H2BHFkeYLLJnVvegm+nGya/6tS1lfYHB4dUGqVR?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6bbd46-b930-4743-589d-08ded5b99a68
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 08:37:07.0237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MCRpcHOKh0M7vQxFoQX03ink/0sMmz2vxIbdDg0FO2EjZq6pwkIVVvyI33c81CJxK9PrmynJt9nkw+tbUHrIppXuMDDxUBDh+oJA3RKGXTnQH1fjoBi87khpZxN7Gs6v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1029

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
 drivers/char/hw_random/jh7110-trng.c | 312 +++++++++++++++++++++------
 2 files changed, 245 insertions(+), 69 deletions(-)

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
index 9776f4daa044..1434dcb6efed 100644
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
-	struct device		*dev;
-	void __iomem		*base;
-	struct clk		*hclk;
-	struct clk		*ahb;
-	struct reset_control	*rst;
-	struct hwrng		rng;
-	struct completion	random_done;
-	struct completion	reseed_done;
-	u32			mode;
-	u32			mission;
-	u32			reseed;
-	/* protects against concurrent write to ctrl register */
-	spinlock_t		write_lock;
+	struct device			*dev;
+	void __iomem			*base;
+	int				irq;
+	struct clk			*hclk;
+	struct clk			*ahb;
+	struct reset_control		*rst;
+	struct hwrng			rng;
+	struct completion		random_done;
+	struct completion		reseed_done;
+	struct work_struct		work;
+	const struct starfive_trng_data *data;
+	u32				mode;
+	u32				mission;
+	u32				reseed;
+	u32				cleanup;
+	struct mutex			lock; /* protect trng cmd seq */
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
@@ -247,7 +358,13 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	struct starfive_trng *trng = to_trng(rng);
 	int ret;
 
-	pm_runtime_get_sync(trng->dev);
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_warn(trng->dev, "Failed to wake device for read: %d\n", ret);
+		return ret;
+	}
+
+	mutex_lock(&trng->lock);
 
 	if (trng->mode == PRNG_256BIT)
 		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
@@ -257,24 +374,28 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
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
 
-	return max;
+	pm_runtime_put_autosuspend(trng->dev);
+
+	return ret;
 }
 
 static int starfive_trng_probe(struct platform_device *pdev)
 {
 	int ret;
-	int irq;
 	struct starfive_trng *trng;
 
 	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
@@ -282,27 +403,22 @@ static int starfive_trng_probe(struct platform_device *pdev)
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
@@ -318,9 +434,14 @@ static int starfive_trng_probe(struct platform_device *pdev)
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
@@ -331,40 +452,86 @@ static int starfive_trng_probe(struct platform_device *pdev)
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
@@ -376,8 +543,17 @@ static const struct dev_pm_ops starfive_trng_pm_ops = {
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
@@ -387,7 +563,7 @@ static struct platform_driver starfive_trng_driver = {
 	.driver	= {
 		.name		= "jh7110-trng",
 		.pm		= &starfive_trng_pm_ops,
-		.of_match_table	= of_match_ptr(trng_dt_ids),
+		.of_match_table	= trng_dt_ids,
 	},
 };
 
-- 
2.43.0


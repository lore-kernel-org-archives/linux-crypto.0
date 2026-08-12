Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2136.outbound.protection.partner.outlook.cn [139.219.146.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D547537F74B;
	Wed, 12 Aug 2026 02:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786502064; cv=fail; b=SaJ/UfQSyEesL1r1SgYdewzRo6CBWFNjq3ksv4jmBtk0Hj4Qga97uXbLftBhYrfT6Lx7iPHjb5vsDzyVKRBziNgXLNk8BoQhhHucJo0gszLTt+jnJffv2swxvT7lrsX8FsUfrbpWi+u1ZnVwL0urE3WPZnTwfgDP6Twhkcgs8cY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786502064; c=relaxed/simple;
	bh=iMwfhdGlctxFq5R9eJO4bbct6KgMZ8JNxeC2NgVDBmE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sVLd3S1cEE5Ps27p8wnEkXsiMsNxvWGO8RDyCxeMYBHYKHzLmhKpFe9BO3wfjxtA9/7qYiiTRLrEV0ijxmKj24gx9oMFH3iRnqIUD8K0BOSxpPZX9s0WISbiYTUMF9lAJabxuxf/XwgTfKL2+rfb2wK8tjuMG+xXm+3kbGq4HvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0QSsooCnoJMZ1RAw5XDNqd1hDHH/2nA4yo02isWlNi0akrGABi5TVfAdipnNI8Re1suels2XmYIvBbRv3+DDo2Nw7bX5r9VziLkXO5YBiKkkNbU36fYHZRnhaG29XpS8U8+t6jYpKBGf5WrKzMrpHj56Rjayq5Xn3+Rasw1vLNIqj//w295Qr/8kWgAQIL3GYrWokWqC1W7ZmCJES+8kfCGyfbPP47OoDXjxBTKVvfjiHPPbmUwU74mcPnommJ1Ihn3xYhxxD+cWhPiDl3al5dlJsqEjrD+vqpYSvugFybvz9byojShlpS7OBN/xO5NxXoiJCTGxtQS99ozI9vftA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hWD5wh+H1k9fuGif2yr/1EDeykzL/FeGQWPxJDN7wXE=;
 b=VkS3RIQ8xqoN6HILlhtYSKVnJ/NDPSAhkJsV349NAh1gW63VWnRwxhDRpdmob0K9GYlWq7fZZaqZp24ArtGuSRtP9HHfXoY9Hx6rpOPvZ/asjZ4/qor5fL+Ahb6R58EfIhW+8wEUIdB1nbTusP9vqymAZ1U382yRL0XTD7BL4I/J+SHEn/jwrV628K7OU9xSm5jD5xlNtL3mN2ANOs7siK9i7dgBb1miGf8a/l9jKBnw2SwvtdYck3200g3MvuRoKGShAmIpSsc4Vhu80Nx/ZEh67skDt27YhZLnqdNWnsOU7U37fh/e+vMKJ9Ayn197a60lLuA1aKxon1fzBxUVtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB0998.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 12 Aug
 2026 02:34:10 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0292.024; Wed, 12 Aug 2026
 02:34:10 +0000
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
Subject: [PATCH v7 2/2] hwrng: starfive: rework clk/reset teardown order for JHB100
Date: Wed, 12 Aug 2026 10:34:01 +0800
Message-Id: <20260812023401.44149-3-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260812023401.44149-1-lianfeng.ouyang@starfivetech.com>
References: <20260812023401.44149-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0011.CHNPR01.prod.partner.outlook.cn
 (10.43.109.87) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn (10.2.3.134)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB0998:EE_
X-MS-Office365-Filtering-Correlation-Id: 68e4f368-1a87-441f-8b3e-08def81a3103
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|52116014|1800799024|366016|38350700014|6133799003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WnZ/T1dK0t4XREbezubKaco+H5dHmmti3eg30WFnTyOPO1fClP6ipiIkFOl8dEFigwYRZTA2JJJdwH+dVFgf+EXXsL5kSTJ5j3PQ5iQVFRcPCH6xLJd4S7wBc3Sh4+wcuBupOO0KpCUYgE14M84/zYikfACZlj3h2LAEX2mcK0qk6ZOY0bbaGuuW8QaFKVQl1buBg+HFzsDin/p3Rxt4K4KjnixlteTDWXRGCwNCLYXr5xo/dJDEEDgxfqwHoj0x6LKsL83vr9Wrdbqg+RLpWSn7lDl+8jvGN7mY6jwsjknVdZe2WG94EneJiziRvqPcrJy+PmzLrUMh7L+jWDkGjHyey4XWc5JhW1sZVohhw0oEVdyqHPkT4zBBROc77/072J0TFuyjfptQT2g5bqoT9XG71tr0xXpyfNoFiOttqFTQuBL0lya5Zl76eoSic5y23goq3MlZY9yQpS4P9PF7wh5/3BpzqykXYzF8I7rys2yhBumzlFjBjniiJXc9sI6s+eD8jW08a2tDpV91aqjh6gDzBlno36yDFSudmlmwu9InLk1lr2UT9Yo+6koU/ter
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(52116014)(1800799024)(366016)(38350700014)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5tHXKieadCvydJsIgbNnj+EFZrQVklXXtmg6/UVkMdoDDvZYZuWOiFD4d8rn?=
 =?us-ascii?Q?nx7PvpZOfOeL3ARSrHbXEt87UKOpf6AqGHMdQxL8DdWEkIrJBBrXEd0Aqwo8?=
 =?us-ascii?Q?bETd69WcIaJC5Xm8AbHqJ7QyVOGy9TeqjU9wGhx0YAwvMvUV70GEB4dTZ3tr?=
 =?us-ascii?Q?YdMEIOg8B6qjbLFtIPQKkjpJfr9ZUIHgv+hfcYo/u9utsYoJ46K+dKpjWi4b?=
 =?us-ascii?Q?JZ1CKvwfOOIkq8SEgMhpekvq62Ps1SA4ipetVs/B+6TuHfO98Z8JCC0RM1SN?=
 =?us-ascii?Q?6nQvrXf6BW6lxCEjXewLWe/WH6WHYOEtYwj+TgqNqyoh4IplrwnRNGq7zNJR?=
 =?us-ascii?Q?DMLjtkf0SrglBoI8RrxIxvsN2eOWXHZaqcNiIHrEd/lz0z1Tn8M3brlxEQSp?=
 =?us-ascii?Q?2owND9FFiML+CgN34MpIMiz2oncI74wWJ5i4JwP0hdzNjqdFRzVXu9HtX8rI?=
 =?us-ascii?Q?MHGf+Q9PJgeZ5glzHLHSTmYRSA555QuUvLmot+4RqEvmCggPJ889xpyiIvol?=
 =?us-ascii?Q?OM9xnvJn8CZX89N+nAtr7aaE08zqe0t/HYhke2ksGASMycPENpsoJRosblo4?=
 =?us-ascii?Q?TZtp2StbVCLpnSBDA0gWYRyCsXW3lPT6O33xHlBvrgpv1O8A6db+1Iw7na66?=
 =?us-ascii?Q?tKS5GYQH3hf16JE1N43Y+y0gTUPNu6LGqxFYNkfEh+fOD3UaIplFR2khedKZ?=
 =?us-ascii?Q?K8QbKd+LpcS+hkl9GMVN/caYTbdAIlc3cEcmsgZDa91sbj0n9mgMiRpC+P97?=
 =?us-ascii?Q?WhlOZsL20sapXIn2rIaZnIm9kcP6mbpxNFeS3DeoHsWYoImnmsae9JPSCL/U?=
 =?us-ascii?Q?ZhViY69c72uvgCNjyhUYqACFgJqEcvvz0ZoZzUUtPhW14ZjfMcYKEzbcNpek?=
 =?us-ascii?Q?pvAa64REHCI1dgHf/NNgnAFylWqWLBnZiZn8DrmdfP0inSRSvdcj9GdhfGuN?=
 =?us-ascii?Q?kE6bXrcjIZ8pqpNhtF6+IULtU+0nAfJuQzR7u0us8qmdFQCJ+2biNDYwc/hK?=
 =?us-ascii?Q?8xN/MJEjjPM2970p6bH5FaP6NoULPnv55zwGvjWhvTrVHfFD+KjjM+1KxFzE?=
 =?us-ascii?Q?UdK1VtipObQHmhw+3oGC0EG9Wzuv+zkBFpUesWbPpr+6nRYI6+ecA917j8lc?=
 =?us-ascii?Q?Qtu3NC3q+NVDQPaZ2bXqjs7DJf+Jt6zxhCTKya3r2MWeCJ/sSB3aqSdNRbwd?=
 =?us-ascii?Q?dWrn71Ss2zXEQVNucSDJlEQayL2qZNPMlHuYGNXps3tRtikC1M5nY/7V8Gjw?=
 =?us-ascii?Q?Favv42I49WdhHW+YNOituW0es84qPXo95FotBQVOzVslJYskiya/dygT4PON?=
 =?us-ascii?Q?u+7gKhBzmUe9268oQWU1YkZroJ1PXluHI2BpVk7XfxLsZh1hoy4Ka/4ReKqE?=
 =?us-ascii?Q?Z7g25fGE1HgWXDGMMGXJc9Q7NA+T7DUv5SJpGZaU2oONumKALmXNURcke6mM?=
 =?us-ascii?Q?0fvENx/JN5Fe+k7jZApiJE2irjbpztNA5IhorPIZzEVLFD8QDInfG3qMY8n4?=
 =?us-ascii?Q?gdA+w5fWO63mpZFFfcxrWw3cc7t/gcfALtMQ33596NvaMBn5MVb/wftHlKTi?=
 =?us-ascii?Q?VL8bjwoqDKgZ+TJPT9EHFEd3b5drvgIaawuDeATkeOa7lwfdlizTHIIF+p8K?=
 =?us-ascii?Q?Igd/+e1eZPemKP8RRqEZB0tl3CZ1M/vnrl4TU3R8EIl+EqJFCcMLyP9drIq2?=
 =?us-ascii?Q?vf98FH229ZizGRYSnmCNQvA76MG57Eo+Zne7PkZjfUaJf/eiJWpc742huMMx?=
 =?us-ascii?Q?5u3Nh0kSrCHjfOeY0iB6ApwFVmn2ICU=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e4f368-1a87-441f-8b3e-08def81a3103
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 02:34:10.9034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dOCLKIiFgesoZ3wxc2eYI+oLdNjsXV+UHggYJ+gUkQCq3xeZphHx2nyHZnTfROzKtoVv3VkcUHtyD4gQirOhz2pIgfKVYlgsN9p1AHZ/J/qA2XeOgbC9xJCYG3rFYzTe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0998

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
 drivers/char/hw_random/jh7110-trng.c | 295 +++++++++++++++++++++------
 2 files changed, 239 insertions(+), 58 deletions(-)

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
index 9776f4daa044..ecc7d5bd7bf5 100644
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
@@ -257,24 +379,28 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
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
@@ -282,27 +408,22 @@ static int starfive_trng_probe(struct platform_device *pdev)
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
@@ -318,9 +439,14 @@ static int starfive_trng_probe(struct platform_device *pdev)
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
@@ -331,40 +457,86 @@ static int starfive_trng_probe(struct platform_device *pdev)
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
@@ -376,8 +548,17 @@ static const struct dev_pm_ops starfive_trng_pm_ops = {
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
@@ -387,7 +568,7 @@ static struct platform_driver starfive_trng_driver = {
 	.driver	= {
 		.name		= "jh7110-trng",
 		.pm		= &starfive_trng_pm_ops,
-		.of_match_table	= of_match_ptr(trng_dt_ids),
+		.of_match_table	= trng_dt_ids,
 	},
 };

--
2.43.0


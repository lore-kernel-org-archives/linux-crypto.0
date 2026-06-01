Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2107.outbound.protection.partner.outlook.cn [139.219.146.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE2D39185C;
	Mon,  1 Jun 2026 09:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780306692; cv=fail; b=Q087JMrk9r6al/cmsDeS0ygbXNR9sQNPPq03sWV9fBRiV1FOcjTpDOzB5Ufg+6jJ2rCyt0YczsUuykBaG5K6HKrdUf38Z7WvJrztrSzGrQHtGNpAdic13QMXa0R5Mz2/Mpb+IDGKZpGVCxG/r+g173AsFKjB8Anrbqw1Qrvamtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780306692; c=relaxed/simple;
	bh=5WtVN2FnGSBDje4Z1v0urY1KCH9o0j6PJkic/9YcgVs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qAZWLsG8JHheeti+i8tkMsaTXfowsOUvHS0kFugXWF202/6AIHHcqrNoeem1c3F9cvNjihk6+boJjM0lIU6VZ90zttu7rcawUE6LTB78hFbJeHC25AGsXY+M6IK0Zn8qWff2uI5z+8D0pGevACz9GvMzgKUQlsimk7dkPCXZths=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7zIuFtwqoKIY+fOwc8Id39DdH8ctlPIzqMdUtlcXfp3mdgHOJ5C+ZPWZ2j5z9SthGwWDFTuy1r5hO6v4p2tY/5kDtjln26DWfIzC8K4gpAVTomCfC7DFzl2mW3pKWVzeKj5TgEjdncfD059/9CtyXwfQQ68MVo/e04C4vKb0M6lCRgQQtF+IXO0fdENVePoTcHsBVyAuCGmeq0e2bOQy9jC4sG/b7BWNP3sI8fnIYDBlUyeahm3vj8W14ymU413RpU5F5a6RFexPxrl6a4Em/ajm2Ru+XIrxKftqNE5E97/5my69NruuUwSLn/zWP2EUZyOUX+TZYZ1y7CYIeQMyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBlSbVlpW/1/A+wpx0z+S4l4TebOQCVsaMaVf71ba7A=;
 b=ndi0bc4+VuvokP7FoEBPdukFy4DeAGmac5Zldjlo/K7MPw5ufLJckQomcCnWg6cAIlN0qvK1+yJI3wnVmz+G6XVoIOILU9SjdRdfYq4yX1aBk8RyaLCr4bEEJ4Iyai99WGb3HrNo84TmuEOY/mSf+pq7uSmEU1oVHDZnrgR6ylO1iRrZTJJnFXu90p6wPZtLhkdyQzgbPFlXTkJ14r7pLGb+0ZmrLRrYuXjr6//89KtpnziOLVltmY6BBf8b65s61UOhpR/nICQ75o2vwS+ACm85bPH+xCtz7dyvw2g7MrxQIN7hFze7/px1pJv/Qrom4fMBmt0CSUrz/vmcwzExzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1254.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.18; Mon, 1 Jun 2026
 09:37:54 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.21.0071.017; Mon, 1 Jun 2026
 09:37:54 +0000
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
Subject: [PATCH v3 2/2] hwrng: starfive: rework clk/reset teardown order for JHB100 & fix RPM
Date: Mon,  1 Jun 2026 17:37:44 +0800
Message-Id: <20260601093744.84210-3-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260601093744.84210-1-lianfeng.ouyang@starfivetech.com>
References: <20260601093744.84210-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0009.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:5::21) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1254:EE_
X-MS-Office365-Filtering-Correlation-Id: 932aa9e7-f7e0-4265-4248-08debfc174b3
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|1800799024|376014|38350700014|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	nms389a48jUvcESXSUClPOTuweBpcDAqZdflg928CWDA4zTI559HgAPK8/E8DZ98Cr2X2DE227alhV6ksZ/wJR0Nc8S95O/f7ccIb3sJFAXxx4gwWuwrvMrVA6F9sCQbmUjJmp98a0AC2ZUJBWuZmQuO1rmouV+lb5g8CBoePhqwg89PyCqTDa3jKtn9kweJt6JTcWa3k+UhdqC9g6uIRuyKqGaTCQj34y1JP5k3fhYb6NpSdS12zdmkKdRBQ6aMk/6ndyTm9m/ykR5wd5Fgpgv7DUCQvH+TpwCjGshPXkRXADzOjMXiXJjgICqNQfIPhfKxmQw51Np3z6YkhlenGgmqO4QnpCGGUc3HH17fnCkv3YL1tnsE9h8F3YkiFBo9HpUrM0U1Mx2MjFMYigIydve0kq+hCbob0jSsKgB/1pWs5vP41WsAEW8qbZMtGKM6KPLCGsSOYwdBWyxE6skm5bOnqpHoHgBTbW4sUm+SQn4TaYq94marZ5F38IBZkussXt6oGZuXk3VCETTjtzi0n5BJj+KOJinHgfGUqelyH+t+1GlhhaInQk5PuzzQQcue
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(1800799024)(376014)(38350700014)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+IoPVLW88OOklvmGjla+nYL1OKUuvZq6KPYS6dOQaoje9NhzXD8b0ah+uzyD?=
 =?us-ascii?Q?mQO/oGO+QU3KlTNEemNvee32eRRhdJXHBW+mBgScGej51mkULYUeGc2tEeCk?=
 =?us-ascii?Q?Azp91lbXYXnbmI36qBy/NQ++IIHd4Mx56rAECRFYX1cT9rBI9MPIgearkv2J?=
 =?us-ascii?Q?est3B0/5kMo0looG1ynMIPHnpGCxK50oFxXOlv2ZUGZy64pHS2zjA/vBjqE1?=
 =?us-ascii?Q?7IfAlHmzojWgvbITgDeGsmvaukuN1AyOl1dcjJ2zGvlgtxx38v/yt6SjXQlQ?=
 =?us-ascii?Q?CTCfLG0D9IHxukIPLPWdLSUQagxW0hvPl6ft2KUyfYPO0ozn3C73D0I9r6eu?=
 =?us-ascii?Q?AkcYggoD5YYWy5UoBzD68uWQVid7RCdphAXE8RbojdCeJrqsFr0vViGJcGNt?=
 =?us-ascii?Q?/r8v8v+XKp04sK6yRCp0KE6nu6LoQcBQAZSM4/A4drbzbdmChLd+i9ooR9A5?=
 =?us-ascii?Q?amxE2GXH1hgpZFAGsOEZdaQyrKhD35jMEq2TSv4vtMCUC1kPXhukHLwLRZEE?=
 =?us-ascii?Q?vgt8s1f1PZ8U1O3YnUcFQgB5/9zxg5WJNPa+RiHn1RTihUhziqKxrq4KJq1S?=
 =?us-ascii?Q?dq1EWFzyac8kVkQVi2/XUrHn+u3Xhj8hXh3eYUdWMgkVw0whdlecn4AVvTrt?=
 =?us-ascii?Q?DIlFg99+nQ4rPbeOp8LEtdGsWlQlq3U2uKs6nywU9npPAAK1KJmh13Y0G/TF?=
 =?us-ascii?Q?ZZjgdATKmsGJTUgYDPafSb1Ub9hU6diSgl8xnWO6TWEGj+/43yDmejVtsdKo?=
 =?us-ascii?Q?N6CuVkcrcMYumd9BpLL8udBNyLvD09xsjNRykAbfhbi0X4AvuD040K2t0TBY?=
 =?us-ascii?Q?3NyffoCBY45sOVe4uwih8PqXBbTU8v8NOUHw/o0GzImuFl0E8y0ulwOe3Dhg?=
 =?us-ascii?Q?URyP6JZvj61fPGxPiUOslL8u7xDP1d8Fg0ys/1p4VZEkIc17uIUkojeokRcZ?=
 =?us-ascii?Q?2HjMaORo4FxVbFLaKG9ckZUhXHRkEUkHThomok49ZNtCKhSTKBf2LCfjSoln?=
 =?us-ascii?Q?0ZReBL815D5zCPA5HShk5BQQ3AhJA/hwa6Wt+hfcb6njjhjzTlJUTbpHcYB6?=
 =?us-ascii?Q?sjShE6sg+jq5XJKIRcgXKQrQqZwru9Wg2F4aah0Qwz3y5yJXmMFZoWKIAa98?=
 =?us-ascii?Q?GGpNktFTqPKvhUvGBX6lPkeqjbU2QEVEz3tHO8KIUOOD7iL2ZO2iPzbS0i7q?=
 =?us-ascii?Q?Cc1F7dqiZ6z/m80Ea8GbFkqt8dilQzxBdhs855hcNtXleTk80f6uZuKUo4V7?=
 =?us-ascii?Q?H5P2OHTvj/0ioZ0Tjn+MEK4OyqoKHfyCdeAnQ3K/KwV4LQ43cH7KZYc60Okv?=
 =?us-ascii?Q?espFMm97tNWyKYjT41aPDPdItRgb+ah3gfdzAdbc46q5p42c73Q4dW69JUff?=
 =?us-ascii?Q?Gsnos+5kmZRhaXvxdope8o3K4+e/9BrIvUPPA59RKTkRjCFpaKvunPXi8wK+?=
 =?us-ascii?Q?sy6c3XaoausLuotJ/05IMMzN7qbVvTNAOIgSmEe1FI7F5k1Q8/ykNhIxo2xt?=
 =?us-ascii?Q?jvFcx9A71VorJ6qIMlQnM6DtacrydnVTL4RGo0HosKmfQKr8Kfpqr2bxgA+k?=
 =?us-ascii?Q?WswCZl2VcQfwqZVb9yN7nBSd3XfyATJppapEj6vv2ibPSkBlK+2xzaiXe9dt?=
 =?us-ascii?Q?UhdqhoGr90DCe8aPtpuy5yWPeV0AG5g1xdi+afW6MGqvgj5b5LPd8Ad4H/wk?=
 =?us-ascii?Q?GP+yadVgUzM+7nNg/syd0uBXc2yvU2rxJAlNXwyCYXzACtg+YfgIj03blGba?=
 =?us-ascii?Q?7EfaWmnBmGwDNs12ID4lSx4Pf74sdMiPNSd7BI54T08O2VZ80gl1?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932aa9e7-f7e0-4265-4248-08debfc174b3
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 09:37:54.1725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oYFy6Rel2mMu0tmOnz3zjc4+q6u5JFD03U2Vqgq3IIDcixlcddhWpAzKhiRHZ34nBlZxD1pVTS9VaaF0OAon7I1VC3s29zLBcpIUVh2Jzjba7U8+eWWERaIZD5SY/hbF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1254

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

JHB100: to avoid RDC glitch, assert reset only after clocks are gated.
  Introduce a per-compatible seq_rst_clk flag (RST_FIRST/CLK_FIRST)
  selected via of_device_get_match_data().

RPM fixes:
- Mark device RPM_ACTIVE in probe after clocks & reset deassert,
  before pm_runtime_enable(), so usage count can eventually drop to 0
  and autosuspend actually triggers.
- Balance pm_runtime_get/put in init/read/cleanup, and reject
  register access when RPM resume fails.
- Move low-level disable/reset into a devm action
  (starfive_trng_release()) so error-path unwind order is correct.

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 MAINTAINERS                          |   2 +-
 drivers/char/hw_random/jh7110-trng.c | 191 +++++++++++++++++++++------
 2 files changed, 148 insertions(+), 45 deletions(-)

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
index 9776f4daa044..9c164a0011ae 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -92,20 +92,36 @@ enum mode {
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
+	const struct starfive_trng_data *data;
+	u32				mode;
+	u32				mission;
+	u32				reseed;
+	struct mutex			lock; /* protect trng cmd seq */
+	spinlock_t			write_lock; /* protects register access seq */
 };
 
 static u16 autoreq;
@@ -130,7 +146,7 @@ static inline int starfive_trng_wait_idle(struct starfive_trng *trng)
 					  10, 100000);
 }
 
-static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
+static inline void starfive_trng_irq_clear(struct starfive_trng *trng)
 {
 	/* clear register: ISTAT */
 	u32 data = readl(trng->base + STARFIVE_ISTAT);
@@ -138,6 +154,31 @@ static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
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
+
+	pm_runtime_dont_use_autosuspend(trng->dev);
+	pm_runtime_disable(trng->dev);
+}
+
 static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, bool wait)
 {
 	int wait_time = 1000;
@@ -174,13 +215,22 @@ static int starfive_trng_init(struct hwrng *rng)
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
 
 	/* setup Auto Request/Age register */
 	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
 	writel(autoreq, trng->base + STARFIVE_AUTO_RQSTS);
 
 	/* clear register: ISTAT */
-	starfive_trng_irq_mask_clear(trng);
+	starfive_trng_irq_clear(trng);
 
 	intr |= STARFIVE_IE_ALL;
 	writel(intr, trng->base + STARFIVE_IE);
@@ -201,7 +251,13 @@ static int starfive_trng_init(struct hwrng *rng)
 
 	writel(mode, trng->base + STARFIVE_MODE);
 
-	return starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_autosuspend(trng->dev);
+
+	return ret;
 }
 
 static irqreturn_t starfive_trng_irq(int irq, void *priv)
@@ -209,16 +265,17 @@ static irqreturn_t starfive_trng_irq(int irq, void *priv)
 	u32 status;
 	struct starfive_trng *trng = (struct starfive_trng *)priv;
 
+	if (!pm_runtime_get_if_active(trng->dev)) {
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
@@ -228,18 +285,37 @@ static irqreturn_t starfive_trng_irq(int irq, void *priv)
 		spin_unlock(&trng->write_lock);
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
+		return;
+	}
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
+	pm_runtime_put_sync(trng->dev);
 }
 
 static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -247,7 +323,13 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
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
@@ -257,24 +339,28 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
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
@@ -282,22 +368,32 @@ static int starfive_trng_probe(struct platform_device *pdev)
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
+	trng->irq = platform_get_irq(pdev, 0);
+	if (trng->irq < 0)
+		return trng->irq;
 
 	init_completion(&trng->random_done);
 	init_completion(&trng->reseed_done);
+	mutex_init(&trng->lock);
 	spin_lock_init(&trng->write_lock);
 
-	ret = devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->name,
+	ret = devm_request_irq(&pdev->dev, trng->irq, starfive_trng_irq, 0, pdev->name,
 			       (void *)trng);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,
@@ -333,18 +429,16 @@ static int starfive_trng_probe(struct platform_device *pdev)
 
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
+	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
-	if (ret) {
-		pm_runtime_disable(&pdev->dev);
-
-		reset_control_assert(trng->rst);
-		clk_disable_unprepare(trng->ahb);
-		clk_disable_unprepare(trng->hclk);
+	ret = devm_add_action_or_reset(&pdev->dev, starfive_trng_release, trng);
+	if (ret)
+		return ret;
 
+	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
+	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
-	}
 
 	return 0;
 }
@@ -376,8 +470,17 @@ static const struct dev_pm_ops starfive_trng_pm_ops = {
 			   starfive_trng_resume, NULL)
 };
 
+static const struct starfive_trng_data jh7110_data = {
+	.seq_rst_clk = SEQ_RST_FIRST,
+};
+
+static const struct starfive_trng_data jhb100_data = {
+	.seq_rst_clk = SEQ_CLK_FIRST,
+};
+
 static const struct of_device_id trng_dt_ids[] __maybe_unused = {
-	{ .compatible = "starfive,jh7110-trng" },
+	{ .compatible = "starfive,jh7110-trng", .data = &jh7110_data },
+	{ .compatible = "starfive,jhb100-trng", .data = &jhb100_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, trng_dt_ids);
-- 
2.43.0


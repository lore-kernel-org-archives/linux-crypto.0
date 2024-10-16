Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534CD1D27B4;
	Wed, 16 Oct 2024 08:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729066008; cv=none; b=mnYPhPlom0SOMyI9DFrcskYqZM/KAw+bvDMoUoH3tS+DYMTZc5rI3KZs9ifkevuV5zI0HwreX8N2DRkiYB4t2KjcMcey+oPyH12qWr28aKicvwId7kf6YGA656YYXg721DRYyDz7kjiyIo6ggYtmit9+64Vxrc4Ot+BSYorkdxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729066008; c=relaxed/simple;
	bh=dm69zLlAyOqjpblFsxT8rIwfjadrhYwmYtcCnyUT+Mw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=Q1qP2I94T7Ed24HUzLYDByyH3UX0RhHPSHghf/3jAyZEDIAHeJctVCciKZ3qQSMHOWMmpS2Wq9igoxvLg4sA3Sac/G3qKahg5435OtSxbubjFRheKMEmqI5IqN0ohZiIB8wspP+kr8+UoTniMqTPcbpEgNROXhRWG5V6M8/ONCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=ZmMbgWji; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="ZmMbgWji"
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G6soUY018493;
	Wed, 16 Oct 2024 10:06:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	OMBkIP4yBxlbCoEGmX8+sMGiFNm4Ds3W/buqBNATsD8=; b=ZmMbgWji5b5glPf2
	ldx6wF9j8t7RmfSUn8zHEaM1G25UJlwYqOdDhGXx5uJOLGE4QfoRtpRoKj1VmA6x
	0rYcgwWSufreaDIbgy3GdrxVbGTYI4yGcnBXLigvPiVUjEMrHGPRQBCo3KjSEPmu
	yJoJgrbkmD3whWBlLmEBwyQ4rp5WyMVS+70qImCAASi6m+YTZf9iitTZI6pL6IJI
	Zw4wvvAVvJc7VWtXwhR+bj/+pHV2NvESLuWwBQj8oAn8BMbOVJ92zqnGTAsveveJ
	l2X3PRKJnGJoQ8FUoek96bVBVSpbODTuYkYcRt6BnXQaE/WNVkfdtwalbSM3Zaf/
	+t57sA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 42a8mv8c9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 10:06:26 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 4889A40050;
	Wed, 16 Oct 2024 10:05:18 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 9551923CB2C;
	Wed, 16 Oct 2024 10:04:33 +0200 (CEST)
Received: from localhost (10.48.86.225) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Wed, 16 Oct
 2024 10:04:33 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Date: Wed, 16 Oct 2024 10:04:19 +0200
Subject: [PATCH v4 2/4] hwrng: stm32 - implement support for STM32MP25x
 platforms
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20241016-rng-mp25-v2-v4-2-5dca590cb092@foss.st.com>
References: <20241016-rng-mp25-v2-v4-0-5dca590cb092@foss.st.com>
In-Reply-To: <20241016-rng-mp25-v2-v4-0-5dca590cb092@foss.st.com>
To: Olivia Mackall <olivia@selenic.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        Rob Herring <robh@kernel.org>,
        Krzysztof
 Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Maxime
 Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue
	<alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>, <marex@denx.de>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Gatien Chevallier <gatien.chevallier@foss.st.com>
X-Mailer: b4 0.14.2
X-ClientProxiedBy: EQNCAS1NODE3.st.com (10.75.129.80) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

Implement the support for STM32MP25x platforms. On this platform, a
security clock is shared between some hardware blocks. For the RNG,
it is the RNG kernel clock. Therefore, the gate is no more shared
between the RNG bus and kernel clocks as on STM32MP1x platforms and
the bus clock has to be managed on its own.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Reviewed-by: Marek Vasut <marex@denx.de>
---
Changes in V4:
	- Added Marek's tag

Changes in V3:
	- Use clk_bulk APIs in the RNG driver to avoid manually handling
	  clocks.

Changes in V2
	-Renamed RNG clocks to "core" and "bus"
	-Use clk_bulk_* APIs instead of handling each clock. Just make
	 sure that the RNG core clock is first
---
 drivers/char/hw_random/stm32-rng.c | 74 ++++++++++++++++++++++++++++----------
 1 file changed, 56 insertions(+), 18 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 9d041a67c295a54d283d235bbcf5a9ab7a8baa5c..279328902bf89af15b8ca9df9a061bf2a1ddcf55 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/delay.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
@@ -49,6 +50,7 @@
 
 struct stm32_rng_data {
 	uint	max_clock_rate;
+	uint	nb_clock;
 	u32	cr;
 	u32	nscr;
 	u32	htcr;
@@ -72,7 +74,7 @@ struct stm32_rng_private {
 	struct hwrng rng;
 	struct device *dev;
 	void __iomem *base;
-	struct clk *clk;
+	struct clk_bulk_data *clk_bulk;
 	struct reset_control *rst;
 	struct stm32_rng_config pm_conf;
 	const struct stm32_rng_data *data;
@@ -266,7 +268,7 @@ static uint stm32_rng_clock_freq_restrain(struct hwrng *rng)
 	unsigned long clock_rate = 0;
 	uint clock_div = 0;
 
-	clock_rate = clk_get_rate(priv->clk);
+	clock_rate = clk_get_rate(priv->clk_bulk[0].clk);
 
 	/*
 	 * Get the exponent to apply on the CLKDIV field in RNG_CR register
@@ -276,7 +278,7 @@ static uint stm32_rng_clock_freq_restrain(struct hwrng *rng)
 	while ((clock_rate >> clock_div) > priv->data->max_clock_rate)
 		clock_div++;
 
-	pr_debug("RNG clk rate : %lu\n", clk_get_rate(priv->clk) >> clock_div);
+	pr_debug("RNG clk rate : %lu\n", clk_get_rate(priv->clk_bulk[0].clk) >> clock_div);
 
 	return clock_div;
 }
@@ -288,7 +290,7 @@ static int stm32_rng_init(struct hwrng *rng)
 	int err;
 	u32 reg;
 
-	err = clk_prepare_enable(priv->clk);
+	err = clk_bulk_prepare_enable(priv->data->nb_clock, priv->clk_bulk);
 	if (err)
 		return err;
 
@@ -328,7 +330,7 @@ static int stm32_rng_init(struct hwrng *rng)
 							(!(reg & RNG_CR_CONDRST)),
 							10, 50000);
 		if (err) {
-			clk_disable_unprepare(priv->clk);
+			clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 			dev_err(priv->dev, "%s: timeout %x!\n", __func__, reg);
 			return -EINVAL;
 		}
@@ -356,12 +358,13 @@ static int stm32_rng_init(struct hwrng *rng)
 						reg & RNG_SR_DRDY,
 						10, 100000);
 	if (err || (reg & ~RNG_SR_DRDY)) {
-		clk_disable_unprepare(priv->clk);
+		clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 		dev_err(priv->dev, "%s: timeout:%x SR: %x!\n", __func__, err, reg);
+
 		return -EINVAL;
 	}
 
-	clk_disable_unprepare(priv->clk);
+	clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 
 	return 0;
 }
@@ -379,7 +382,8 @@ static int __maybe_unused stm32_rng_runtime_suspend(struct device *dev)
 	reg = readl_relaxed(priv->base + RNG_CR);
 	reg &= ~RNG_CR_RNGEN;
 	writel_relaxed(reg, priv->base + RNG_CR);
-	clk_disable_unprepare(priv->clk);
+
+	clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 
 	return 0;
 }
@@ -389,7 +393,7 @@ static int __maybe_unused stm32_rng_suspend(struct device *dev)
 	struct stm32_rng_private *priv = dev_get_drvdata(dev);
 	int err;
 
-	err = clk_prepare_enable(priv->clk);
+	err = clk_bulk_prepare_enable(priv->data->nb_clock, priv->clk_bulk);
 	if (err)
 		return err;
 
@@ -403,7 +407,7 @@ static int __maybe_unused stm32_rng_suspend(struct device *dev)
 
 	writel_relaxed(priv->pm_conf.cr, priv->base + RNG_CR);
 
-	clk_disable_unprepare(priv->clk);
+	clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 
 	return 0;
 }
@@ -414,7 +418,7 @@ static int __maybe_unused stm32_rng_runtime_resume(struct device *dev)
 	int err;
 	u32 reg;
 
-	err = clk_prepare_enable(priv->clk);
+	err = clk_bulk_prepare_enable(priv->data->nb_clock, priv->clk_bulk);
 	if (err)
 		return err;
 
@@ -434,7 +438,7 @@ static int __maybe_unused stm32_rng_resume(struct device *dev)
 	int err;
 	u32 reg;
 
-	err = clk_prepare_enable(priv->clk);
+	err = clk_bulk_prepare_enable(priv->data->nb_clock, priv->clk_bulk);
 	if (err)
 		return err;
 
@@ -462,7 +466,7 @@ static int __maybe_unused stm32_rng_resume(struct device *dev)
 							reg & ~RNG_CR_CONDRST, 10, 100000);
 
 		if (err) {
-			clk_disable_unprepare(priv->clk);
+			clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 			dev_err(priv->dev, "%s: timeout:%x CR: %x!\n", __func__, err, reg);
 			return -EINVAL;
 		}
@@ -472,7 +476,7 @@ static int __maybe_unused stm32_rng_resume(struct device *dev)
 		writel_relaxed(reg, priv->base + RNG_CR);
 	}
 
-	clk_disable_unprepare(priv->clk);
+	clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 
 	return 0;
 }
@@ -484,9 +488,19 @@ static const struct dev_pm_ops __maybe_unused stm32_rng_pm_ops = {
 				stm32_rng_resume)
 };
 
+static const struct stm32_rng_data stm32mp25_rng_data = {
+	.has_cond_reset = true,
+	.max_clock_rate = 48000000,
+	.nb_clock = 2,
+	.cr = 0x00F00D00,
+	.nscr = 0x2B5BB,
+	.htcr = 0x969D,
+};
+
 static const struct stm32_rng_data stm32mp13_rng_data = {
 	.has_cond_reset = true,
 	.max_clock_rate = 48000000,
+	.nb_clock = 1,
 	.cr = 0x00F00D00,
 	.nscr = 0x2B5BB,
 	.htcr = 0x969D,
@@ -495,9 +509,14 @@ static const struct stm32_rng_data stm32mp13_rng_data = {
 static const struct stm32_rng_data stm32_rng_data = {
 	.has_cond_reset = false,
 	.max_clock_rate = 3000000,
+	.nb_clock = 1,
 };
 
 static const struct of_device_id stm32_rng_match[] = {
+	{
+		.compatible = "st,stm32mp25-rng",
+		.data = &stm32mp25_rng_data,
+	},
 	{
 		.compatible = "st,stm32mp13-rng",
 		.data = &stm32mp13_rng_data,
@@ -516,6 +535,7 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 	struct device_node *np = ofdev->dev.of_node;
 	struct stm32_rng_private *priv;
 	struct resource *res;
+	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -525,10 +545,6 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
 
-	priv->clk = devm_clk_get(&ofdev->dev, NULL);
-	if (IS_ERR(priv->clk))
-		return PTR_ERR(priv->clk);
-
 	priv->rst = devm_reset_control_get(&ofdev->dev, NULL);
 	if (!IS_ERR(priv->rst)) {
 		reset_control_assert(priv->rst);
@@ -551,6 +567,28 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 	priv->rng.read = stm32_rng_read;
 	priv->rng.quality = 900;
 
+	if (!priv->data->nb_clock || priv->data->nb_clock > 2)
+		return -EINVAL;
+
+	ret = devm_clk_bulk_get_all(dev, &priv->clk_bulk);
+	if (ret != priv->data->nb_clock)
+		return dev_err_probe(dev, -EINVAL, "Failed to get clocks: %d\n", ret);
+
+	if (priv->data->nb_clock == 2) {
+		const char *id = priv->clk_bulk[1].id;
+		struct clk *clk = priv->clk_bulk[1].clk;
+
+		if (!priv->clk_bulk[0].id || !priv->clk_bulk[1].id)
+			return dev_err_probe(dev, -EINVAL, "Missing clock name\n");
+
+		if (strcmp(priv->clk_bulk[0].id, "core")) {
+			priv->clk_bulk[1].id = priv->clk_bulk[0].id;
+			priv->clk_bulk[1].clk = priv->clk_bulk[0].clk;
+			priv->clk_bulk[0].id = id;
+			priv->clk_bulk[0].clk = clk;
+		}
+	}
+
 	pm_runtime_set_autosuspend_delay(dev, 100);
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_enable(dev);

-- 
2.25.1


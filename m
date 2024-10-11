Received: from mx08-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374778121F;
	Fri, 11 Oct 2024 15:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728661666; cv=none; b=hvh7+CBpFFddCjwhMpU7QB63//KA5lDRC7I3bZZqjUoYSsmShTBxdrIPyKYYLCWokxBt2WdcbGpdqpzAGB0LZf2R4oFhaMgC9Ntd5CUXMrALrSqetTBvgxyMAdDoq/Jkr3BjthYq0sqlfe0M13ZzvRW/m1ns31PHqWHXLfyHIyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728661666; c=relaxed/simple;
	bh=pY3HPUzNjPgjv0Cmibc6l9JbTz0qD5wkGAYRN/dsxf0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=ojiqoaAH4OdRJhVCejwuQYjFkp6V6hndWbets9vVNWn48ywlhWj44XHlWkelf99+Li2Ez5savCVqc6pk5ZJNZjDboQRp4zs5r1CWb+uY3Cj94pUq8pqphizP3tZ0Da/r2aW5viUW+iU9oS5F4rdk4zOEm+IEORjtr9SUhg0BslM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=nvDTr9PX; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="nvDTr9PX"
Received: from pps.filterd (m0369457.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49BCM4jP004698;
	Fri, 11 Oct 2024 17:47:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	zvHyj2kl9ZF339cIQfBGt0O6QAjQz8aYGjJ+YqPTeOE=; b=nvDTr9PXdtkpB33l
	RnKwqZmHB90vrQEeUYkSYqrKTcZWwGoGnJERUX6fqxO6a9+Yt3EcHO0D5sna53dI
	SnF6teRQ02+TlViCCeVuW7HCj6DnqQiIRcO4W4XS0gqiKMppQPK+16QwWPKyPrb2
	7er5VEb2cDM0EjceDnKAfBEYLxhfMLDLNCSmDTlIF3hYkjzuMbA7jEglMp5FS6BK
	MzEuNYvS3wM+emfaHn1NLqaWf28artTCWr7Yn+25FIM+zi5Ru5pgY/66mvaPiyPV
	CefvERY/yE8qT0ZtWVPWg5hF4wXdmOi8PrWdSueq8TPVH/+VdBwNJiKIn3fkVn0O
	AM3DMg==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 425w7xtut0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 17:47:04 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 313A8400A2;
	Fri, 11 Oct 2024 17:45:50 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 9ADE829E027;
	Fri, 11 Oct 2024 17:43:16 +0200 (CEST)
Received: from localhost (10.252.28.117) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Fri, 11 Oct
 2024 17:43:16 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Date: Fri, 11 Oct 2024 17:41:42 +0200
Subject: [PATCH v2 2/4] hwrng: stm32 - implement support for STM32MP25x
 platforms
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20241011-rng-mp25-v2-v2-2-76fd6170280c@foss.st.com>
References: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
In-Reply-To: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
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
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE1.st.com
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
---

Changes in V2
	-Renamed RNG clocks to "core" and "bus"
	-Use clk_bulk_* APIs instead of handling each clock. Just make
	 sure that the RNG core clock is first
---
 drivers/char/hw_random/stm32-rng.c | 85 ++++++++++++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 18 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 9d041a67c295a54d283d235bbcf5a9ab7a8baa5c..62aa9f87415d2518b0c1cb5fb51b0b646422ed35 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -49,6 +49,7 @@
 
 struct stm32_rng_data {
 	uint	max_clock_rate;
+	uint	nb_clock;
 	u32	cr;
 	u32	nscr;
 	u32	htcr;
@@ -72,7 +73,7 @@ struct stm32_rng_private {
 	struct hwrng rng;
 	struct device *dev;
 	void __iomem *base;
-	struct clk *clk;
+	struct clk_bulk_data *clk_bulk;
 	struct reset_control *rst;
 	struct stm32_rng_config pm_conf;
 	const struct stm32_rng_data *data;
@@ -266,7 +267,7 @@ static uint stm32_rng_clock_freq_restrain(struct hwrng *rng)
 	unsigned long clock_rate = 0;
 	uint clock_div = 0;
 
-	clock_rate = clk_get_rate(priv->clk);
+	clock_rate = clk_get_rate(priv->clk_bulk[0].clk);
 
 	/*
 	 * Get the exponent to apply on the CLKDIV field in RNG_CR register
@@ -276,7 +277,7 @@ static uint stm32_rng_clock_freq_restrain(struct hwrng *rng)
 	while ((clock_rate >> clock_div) > priv->data->max_clock_rate)
 		clock_div++;
 
-	pr_debug("RNG clk rate : %lu\n", clk_get_rate(priv->clk) >> clock_div);
+	pr_debug("RNG clk rate : %lu\n", clk_get_rate(priv->clk_bulk[0].clk) >> clock_div);
 
 	return clock_div;
 }
@@ -288,7 +289,7 @@ static int stm32_rng_init(struct hwrng *rng)
 	int err;
 	u32 reg;
 
-	err = clk_prepare_enable(priv->clk);
+	err = clk_bulk_prepare_enable(priv->data->nb_clock, priv->clk_bulk);
 	if (err)
 		return err;
 
@@ -328,7 +329,7 @@ static int stm32_rng_init(struct hwrng *rng)
 							(!(reg & RNG_CR_CONDRST)),
 							10, 50000);
 		if (err) {
-			clk_disable_unprepare(priv->clk);
+			clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 			dev_err(priv->dev, "%s: timeout %x!\n", __func__, reg);
 			return -EINVAL;
 		}
@@ -356,12 +357,13 @@ static int stm32_rng_init(struct hwrng *rng)
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
@@ -379,7 +381,8 @@ static int __maybe_unused stm32_rng_runtime_suspend(struct device *dev)
 	reg = readl_relaxed(priv->base + RNG_CR);
 	reg &= ~RNG_CR_RNGEN;
 	writel_relaxed(reg, priv->base + RNG_CR);
-	clk_disable_unprepare(priv->clk);
+
+	clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 
 	return 0;
 }
@@ -389,7 +392,7 @@ static int __maybe_unused stm32_rng_suspend(struct device *dev)
 	struct stm32_rng_private *priv = dev_get_drvdata(dev);
 	int err;
 
-	err = clk_prepare_enable(priv->clk);
+	err = clk_bulk_prepare_enable(priv->data->nb_clock, priv->clk_bulk);
 	if (err)
 		return err;
 
@@ -403,7 +406,7 @@ static int __maybe_unused stm32_rng_suspend(struct device *dev)
 
 	writel_relaxed(priv->pm_conf.cr, priv->base + RNG_CR);
 
-	clk_disable_unprepare(priv->clk);
+	clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 
 	return 0;
 }
@@ -414,7 +417,7 @@ static int __maybe_unused stm32_rng_runtime_resume(struct device *dev)
 	int err;
 	u32 reg;
 
-	err = clk_prepare_enable(priv->clk);
+	err = clk_bulk_prepare_enable(priv->data->nb_clock, priv->clk_bulk);
 	if (err)
 		return err;
 
@@ -434,7 +437,7 @@ static int __maybe_unused stm32_rng_resume(struct device *dev)
 	int err;
 	u32 reg;
 
-	err = clk_prepare_enable(priv->clk);
+	err = clk_bulk_prepare_enable(priv->data->nb_clock, priv->clk_bulk);
 	if (err)
 		return err;
 
@@ -462,7 +465,7 @@ static int __maybe_unused stm32_rng_resume(struct device *dev)
 							reg & ~RNG_CR_CONDRST, 10, 100000);
 
 		if (err) {
-			clk_disable_unprepare(priv->clk);
+			clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 			dev_err(priv->dev, "%s: timeout:%x CR: %x!\n", __func__, err, reg);
 			return -EINVAL;
 		}
@@ -472,7 +475,7 @@ static int __maybe_unused stm32_rng_resume(struct device *dev)
 		writel_relaxed(reg, priv->base + RNG_CR);
 	}
 
-	clk_disable_unprepare(priv->clk);
+	clk_bulk_disable_unprepare(priv->data->nb_clock, priv->clk_bulk);
 
 	return 0;
 }
@@ -484,9 +487,19 @@ static const struct dev_pm_ops __maybe_unused stm32_rng_pm_ops = {
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
@@ -495,9 +508,14 @@ static const struct stm32_rng_data stm32mp13_rng_data = {
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
@@ -525,10 +543,6 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
 
-	priv->clk = devm_clk_get(&ofdev->dev, NULL);
-	if (IS_ERR(priv->clk))
-		return PTR_ERR(priv->clk);
-
 	priv->rst = devm_reset_control_get(&ofdev->dev, NULL);
 	if (!IS_ERR(priv->rst)) {
 		reset_control_assert(priv->rst);
@@ -551,6 +565,41 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 	priv->rng.read = stm32_rng_read;
 	priv->rng.quality = 900;
 
+	if (!priv->data->nb_clock || priv->data->nb_clock > 2)
+		return -EINVAL;
+
+	priv->clk_bulk = devm_kzalloc(dev, priv->data->nb_clock * sizeof(*priv->clk_bulk),
+				      GFP_KERNEL);
+	if (!priv->clk_bulk)
+		return -ENOMEM;
+
+	if (priv->data->nb_clock == 2) {
+		struct clk *clk;
+		struct clk *bus_clk;
+
+		clk = devm_clk_get(&ofdev->dev, "core");
+		if (IS_ERR(clk))
+			return PTR_ERR(clk);
+
+		bus_clk = devm_clk_get(&ofdev->dev, "bus");
+		if (IS_ERR(clk))
+			return PTR_ERR(bus_clk);
+
+		priv->clk_bulk[0].clk = clk;
+		priv->clk_bulk[0].id = "core";
+		priv->clk_bulk[1].clk = bus_clk;
+		priv->clk_bulk[1].id = "bus";
+	} else {
+		struct clk *clk;
+
+		clk = devm_clk_get(&ofdev->dev, NULL);
+		if (IS_ERR(clk))
+			return PTR_ERR(clk);
+
+		priv->clk_bulk[0].clk = clk;
+		priv->clk_bulk[0].id = "core";
+	}
+
 	pm_runtime_set_autosuspend_delay(dev, 100);
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_enable(dev);

-- 
2.25.1


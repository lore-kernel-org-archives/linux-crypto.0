Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA5B305E09;
	Fri,  7 Nov 2025 10:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762511395; cv=none; b=ho8JK0+/uhJnOjNyXqn92ojrHJ7Jm7byiPDnzdZVfFX+2e7bI2nZ9moaU3ONx2rILD0jE/ySVG+eAJild1zSnN9c8fmj3yBYB7voC2EAzP9y9J72/lvk81aukeH0VocExtydytzkwYS1XkrM0vpJdz74I4oVGRwEgM3DIgSiAzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762511395; c=relaxed/simple;
	bh=PSrSWiIVbpn6czV4JmjiWTzr+3TkryO0Cfx8dgQT/XY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=I5YIlQPMYyFS1LtLUrHlsC/zFbklkML5RGheOb4BMDC/J02fubEI1JSRvgiY/t9GrxetMXGpWnabXs2SYe9KGzy8OH6tfeSO/1X6zQadn3SW9cgKD5ZK1Vlkx8gUZvNcN41D3UuEgkIarWPYeIynAyKIDnClk+aQ3GLTolzwqbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org; spf=pass smtp.mailfrom=yoseli.org; dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b=aF213VrY; arc=none smtp.client-ip=217.70.183.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yoseli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b="aF213VrY"
Received: by mail.gandi.net (Postfix) with ESMTPSA id EBB2944292;
	Fri,  7 Nov 2025 10:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yoseli.org; s=gm1;
	t=1762511391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BmMJrFZ2dloB0VnzDAR4oKmr7EZY45/bU42OgpgHP8U=;
	b=aF213VrYZkaoeI7ntvYcD4qfJdxve7h8TfI/ZQPBx8nKe6RMTzyJDL7YNjzYERDBSI9hM2
	89bAY58o3CKalW6GEyH3bvjkuYPEP8nY9ZNuA4P14gs6XX2NboXsiyMHB/ajxFh9I30oy2
	qPtOq0H0jPJ/MZmvSE77FX72bQSy7ft09NnOYVfErakBaX1orsOjtxhHFIlvp15Yi+yqID
	hh/ZoF45KAayWtgQ1zQyqIBmeliHmd1ryxNavIilp39PVrYM2+CnJdLkliF+NwxnPSUOHG
	OHG+XJC0N3J0Bcad1SEeVJ0NavHbHNAY18sCnuqgBDhlRK7mCW792VqY9kjhtw==
From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Date: Fri, 07 Nov 2025 11:29:44 +0100
Subject: [PATCH v2 2/2] m68k: coldfire: Add RNG support for MCF54418
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251107-b4-m5441x-add-rng-support-v2-2-f91d685832b9@yoseli.org>
References: <20251107-b4-m5441x-add-rng-support-v2-0-f91d685832b9@yoseli.org>
In-Reply-To: <20251107-b4-m5441x-add-rng-support-v2-0-f91d685832b9@yoseli.org>
To: Greg Ungerer <gerg@linux-m68k.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Shawn Guo <shawnguo@kernel.org>, 
 Sascha Hauer <s.hauer@pengutronix.de>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 Fabio Estevam <festevam@gmail.com>
Cc: linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, 
 Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762511384; l=5529;
 i=jeanmichel.hautbois@yoseli.org; s=20240925; h=from:subject:message-id;
 bh=PSrSWiIVbpn6czV4JmjiWTzr+3TkryO0Cfx8dgQT/XY=;
 b=EUGS7OCZpt1eCI5kkVQK7/hSxyPZTuOtSCCY8VQLiT6XtgYTF117WBjImk+M0Eq9+8h1vy5jQ
 djb/Z7vDqjKBY/IyELs3wLWOxX4d0Bm5RlRHb3mk9cKjwsc2LtYrw4P
X-Developer-Key: i=jeanmichel.hautbois@yoseli.org; a=ed25519;
 pk=MsMTVmoV69wLIlSkHlFoACIMVNQFyvJzvsJSQsn/kq4=
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeelgeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhfffugggtgffkfhgjvfevofesthejredtredtjeenucfhrhhomheplfgvrghnqdfoihgthhgvlhcujfgruhhtsghoihhsuceojhgvrghnmhhitghhvghlrdhhrghuthgsohhisheshihoshgvlhhirdhorhhgqeenucggtffrrghtthgvrhhnpeffjefhtdelhffhheevheeutefghfefteeluedvudfhgeegteeitddtuefhhfelteenucfkphepvdgrtddumegvtdgrmeduieelmeejudegtdemkegtrgdtmedukegtjeemhegvfhgtmegtsghfvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedvrgdtudemvgdtrgemudeileemjedugedtmeektggrtdemudektgejmeehvghftgemtggsfhdvpdhhvghlohephihoshgvlhhiqdihohgtthhordihohhsvghlihdrohhrghdpmhgrihhlfhhrohhmpehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrghdpnhgspghrtghpthhtohepudegpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrk
 hgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlsehpvghnghhuthhrohhnihigrdguvgdprhgtphhtthhopehgvggvrhhtsehlihhnuhigqdhmieekkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrghdprhgtphhtthhopehfvghsthgvvhgrmhesghhmrghilhdrtghomhdprhgtphhtthhopehgvghrgheslhhinhhugidqmheikehkrdhorhhg
X-GND-Sasl: jeanmichel.hautbois@yoseli.org

Add platform device support for the MCF54418 RNGB hardware with clock
enabled at platform initialization.

The imx-rngc driver now uses devm_clk_get_optional() to support both
Coldfire (always-on clock) and i.MX platforms (managed clock).

Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
---
 arch/m68k/coldfire/device.c       | 28 ++++++++++++++++++++++++++++
 arch/m68k/coldfire/m5441x.c       |  2 +-
 arch/m68k/include/asm/m5441xsim.h |  9 +++++++++
 drivers/char/hw_random/Kconfig    |  3 ++-
 drivers/char/hw_random/imx-rngc.c |  9 ++++++++-
 5 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
index 20adba27a687029ef53249bad71b342d563d612b..4183929b0b501459da25d1b4cde7d77f19c3dc16 100644
--- a/arch/m68k/coldfire/device.c
+++ b/arch/m68k/coldfire/device.c
@@ -622,6 +622,31 @@ static struct platform_device mcf_flexcan0 = {
 };
 #endif /* MCFFLEXCAN_SIZE */
 
+#ifdef MCF_RNG_BASE
+/*
+ * Random Number Generator (RNG) - only on MCF54418
+ */
+static const struct resource mcf_rng_resource[] = {
+	{
+		.start = MCF_RNG_BASE,
+		.end   = MCF_RNG_BASE + MCF_RNG_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = MCF_IRQ_RNG,
+		.end   = MCF_IRQ_RNG,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device mcf_rng = {
+	.name           = "imx-rngc",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(mcf_rng_resource),
+	.resource       = mcf_rng_resource,
+};
+#endif /* MCF_RNG_BASE */
+
 static struct platform_device *mcf_devices[] __initdata = {
 	&mcf_uart,
 #ifdef MCFFEC_BASE0
@@ -660,6 +685,9 @@ static struct platform_device *mcf_devices[] __initdata = {
 #ifdef MCFFLEXCAN_SIZE
 	&mcf_flexcan0,
 #endif
+#ifdef MCF_RNG_BASE
+	&mcf_rng,
+#endif
 };
 
 /*
diff --git a/arch/m68k/coldfire/m5441x.c b/arch/m68k/coldfire/m5441x.c
index 7a25cfc7ac07570ff15da3c55d080a717cf93a06..ab5b006372379294db3b522820de88137bfb7e78 100644
--- a/arch/m68k/coldfire/m5441x.c
+++ b/arch/m68k/coldfire/m5441x.c
@@ -158,6 +158,7 @@ static struct clk * const enable_clks[] __initconst = {
 	&__clk_0_33, /* pit.1 */
 	&__clk_0_37, /* eport */
 	&__clk_0_48, /* pll */
+	&__clk_0_49, /* rng */
 	&__clk_0_51, /* esdhc */
 
 	&__clk_1_36, /* CCM/reset module/Power management */
@@ -179,7 +180,6 @@ static struct clk * const disable_clks[] __initconst = {
 	&__clk_0_44, /* usb otg */
 	&__clk_0_45, /* usb host */
 	&__clk_0_47, /* ssi.0 */
-	&__clk_0_49, /* rng */
 	&__clk_0_50, /* ssi.1 */
 	&__clk_0_53, /* enet-fec */
 	&__clk_0_54, /* enet-fec */
diff --git a/arch/m68k/include/asm/m5441xsim.h b/arch/m68k/include/asm/m5441xsim.h
index f48cf63bd7822fd53c33788128f984585c0c421a..dd64cdfcad3e810254c6854b9de5b6bbeb67b950 100644
--- a/arch/m68k/include/asm/m5441xsim.h
+++ b/arch/m68k/include/asm/m5441xsim.h
@@ -198,6 +198,15 @@
 #define MCFRTC_SIZE		(0xfc0a8840 - 0xfc0a8000)
 #define MCF_IRQ_RTC		(MCFINT2_VECBASE + MCFINT2_RTC)
 
+/*
+ *  Random Number Generator (RNG) Module.
+ *  Note: Only present in MCF54418, not in MCF54410/54415/54417
+ */
+#define MCF_RNG_BASE		0xfc0c4000
+#define MCF_RNG_SIZE		0x1c
+#define MCFINT2_RNG		28
+#define MCF_IRQ_RNG		(MCFINT2_VECBASE + MCFINT2_RNG)
+
 /*
  *  GPIO Module.
  */
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 492a2a61a65be8bd9e46b0a70f3e43703973512e..e046eabaac2d9053a5a4a98c6e3733bb19258e54 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -270,12 +270,13 @@ config HW_RANDOM_MXC_RNGA
 config HW_RANDOM_IMX_RNGC
 	tristate "Freescale i.MX RNGC Random Number Generator"
 	depends on HAS_IOMEM
-	depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || COMPILE_TEST
+	depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || M5441x || COMPILE_TEST
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator Version C hardware found on some Freescale i.MX
 	  processors. Version B is also supported by this driver.
+	  Also supports RNGB on Freescale MCF54418 (Coldfire V4e).
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called imx-rngc.
diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 241664a9b5d9ac7244f15cbe5d5302ca3787ebea..44f20a05de0a425cb6ff7b2a347b111750ac3702 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -259,7 +259,7 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
 	if (IS_ERR(rngc->base))
 		return PTR_ERR(rngc->base);
 
-	rngc->clk = devm_clk_get(&pdev->dev, NULL);
+	rngc->clk = devm_clk_get_optional(&pdev->dev, NULL);
 	if (IS_ERR(rngc->clk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(rngc->clk), "Cannot get rng_clk\n");
 
@@ -353,12 +353,19 @@ static const struct of_device_id imx_rngc_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, imx_rngc_dt_ids);
 
+static const struct platform_device_id imx_rngc_devtype[] = {
+	{ .name = "imx-rngc" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(platform, imx_rngc_devtype);
+
 static struct platform_driver imx_rngc_driver = {
 	.driver = {
 		.name = KBUILD_MODNAME,
 		.pm = pm_ptr(&imx_rngc_pm_ops),
 		.of_match_table = imx_rngc_dt_ids,
 	},
+	.id_table = imx_rngc_devtype,
 };
 
 module_platform_driver_probe(imx_rngc_driver, imx_rngc_probe);

-- 
2.39.5


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1160822AE7A;
	Wed, 26 Nov 2025 07:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764140891; cv=none; b=Hv+RWI/dE/g02HKoKGDt8d5/rbVlrrPexhibjDEHhCehbwn7V21wdXr1K+GulImOOvvGaLqCYbxRBYmULFi5/l5HjD0tPYloSDlQPFy0DN3XrMmZBkL8uhwtpZbGXtNmGH+NaxdxFlqhAuQGEWM8+JIhofkHS/EleawdqStdL+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764140891; c=relaxed/simple;
	bh=qS077zI1NvAHbDxWo1Wem2TkNBu4/E1/LRqcMpbpdy8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JRmvALoq1n9nL4x4GFUeHHNt9SxWkYDzt5uVb3wzAEZo9WzKepqSSgg8AiBuIeW39skB/GTm5JoyqbLcJF1jQku5utOSYe26xpRUwVLzjsT0VNMKdy/9vczfkZgnPZTJXNJv6spBgTrNvvCm4m8FGss//1ZY087etotKQfcjjro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZV3mZ77v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZV3mZ77v"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F093C19421;
	Wed, 26 Nov 2025 07:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764140890;
	bh=qS077zI1NvAHbDxWo1Wem2TkNBu4/E1/LRqcMpbpdy8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZV3mZ77vCnhSZrANCI9EIWgF7YBFTK/lHP0I7gwhPPJkhbKrFwtEvDIcpOPOIy+zH
	 hGPXTaSxwIaXqHb7o4Acq7a1IYf4VO52/m5yJkqVwGM44teZM3zmqUBVqTdTXXs6q9
	 +UMibSqcswEHtvSsU9MxkyjYMGKrnpDEKcq5bwOaLUXogtI+DWxJHXgeiH/1jH9dJc
	 dfu3F3RUTvbGXq4Dzfb7yNw6sF5RUmIeuEXpa0q4hZi2sKMill41SMTMK5+LPo6Z2m
	 spJPUc9TLAVzl4SQxjLRIOIvxmCgNFIH4gboX20//O8oyYKlGOXYxnMbWRKGVvhuYe
	 s64Q8KdIy3fDA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A27D10385;
	Wed, 26 Nov 2025 07:08:10 +0000 (UTC)
From: Jean-Michel Hautbois via B4 Relay <devnull+jeanmichel.hautbois.yoseli.org@kernel.org>
Date: Wed, 26 Nov 2025 08:08:10 +0100
Subject: [PATCH v4 2/2] m68k: coldfire: Add RNG support for MCF54418
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-b4-m5441x-add-rng-support-v4-2-5309548c9555@yoseli.org>
References: <20251126-b4-m5441x-add-rng-support-v4-0-5309548c9555@yoseli.org>
In-Reply-To: <20251126-b4-m5441x-add-rng-support-v4-0-5309548c9555@yoseli.org>
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
 Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764140889; l=4887;
 i=jeanmichel.hautbois@yoseli.org; s=20240925; h=from:subject:message-id;
 bh=Wf41xP1w92+KfS3UWg3IiwFpcF0WXqx8HqqnnCeLd90=;
 b=2f0HwZebz9fZ6srrUaKevglM40X3tY/U/N3M3M+AymSxHKT1TeADFj223cY3FFZQiR71GM22V
 T4TW0dTN/OkD8ytKdUlffYIltCZOetIGP0O67BJ8Do/bokPl68PhfdB
X-Developer-Key: i=jeanmichel.hautbois@yoseli.org; a=ed25519;
 pk=MsMTVmoV69wLIlSkHlFoACIMVNQFyvJzvsJSQsn/kq4=
X-Endpoint-Received: by B4 Relay for
 jeanmichel.hautbois@yoseli.org/20240925 with auth_id=570
X-Original-From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Reply-To: jeanmichel.hautbois@yoseli.org

From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

Add support for the hardware Random Number Generator (RNGB) found on
MCF54418 ColdFire processors with clock enabled at platform
initialization.

The RNGB block is compatible with the imx-rngc driver.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
---
 arch/m68k/coldfire/device.c       | 28 ++++++++++++++++++++++++++++
 arch/m68k/coldfire/m5441x.c       |  2 +-
 arch/m68k/include/asm/m5441xsim.h |  9 +++++++++
 drivers/char/hw_random/Kconfig    |  3 ++-
 drivers/char/hw_random/imx-rngc.c |  7 +++++++
 5 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
index b6958ec2a220..9d8f844e319a 100644
--- a/arch/m68k/coldfire/device.c
+++ b/arch/m68k/coldfire/device.c
@@ -622,6 +622,31 @@ static struct platform_device mcf_flexcan0 = {
 };
 #endif /* MCFFLEXCAN_SIZE */
 
+#ifdef MCF_RNG_BASE
+/*
+ * Random Number Generator (RNG) - only on MCF54418
+ */
+static struct resource mcf_rng_resource[] = {
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
index 7a25cfc7ac07..ab5b00637237 100644
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
index f48cf63bd782..dd64cdfcad3e 100644
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
index 492a2a61a65b..2f301e43db84 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -270,12 +270,13 @@ config HW_RANDOM_MXC_RNGA
 config HW_RANDOM_IMX_RNGC
 	tristate "Freescale i.MX RNGC Random Number Generator"
 	depends on HAS_IOMEM
-	depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || COMPILE_TEST
+	depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || COLDFIRE || COMPILE_TEST
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator Version C hardware found on some Freescale i.MX
 	  processors. Version B is also supported by this driver.
+	  Also supports RNGB on Freescale MCF54418 (Coldfire V4e).
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called imx-rngc.
diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index d6a847e48339..44f20a05de0a 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
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



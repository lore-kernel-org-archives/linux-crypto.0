From: Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 3/3] Visstrim M10: Add support for SAHARA2 module.
Date: Thu, 21 Feb 2013 13:19:22 +0100
Message-ID: <1361449162-27302-4-git-send-email-javier.martin@vista-silicon.com>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, tony@atomide.com,
	swarren@nvidia.com, shawn.guo@linaro.org, gcembed@gmail.com,
	arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	Javier Martin <javier.martin@vista-silicon.com>
To: kernel@pengutronix.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:42009 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3BUMTj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 07:19:39 -0500
Received: by mail-we0-f176.google.com with SMTP id s43so7353882wey.7
        for <linux-crypto@vger.kernel.org>; Thu, 21 Feb 2013 04:19:37 -0800 (PST)
In-Reply-To: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-imx/Kconfig                   |    1 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 1ad0d76..d232a56 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -402,6 +402,7 @@ config MACH_IMX27_VISSTRIM_M10
 	select IMX_HAVE_PLATFORM_IMX_UART
 	select IMX_HAVE_PLATFORM_MX2_CAMERA
 	select IMX_HAVE_PLATFORM_MX2_EMMA
+	select IMX_HAVE_PLATFORM_IMX27_SAHARA
 	select IMX_HAVE_PLATFORM_MXC_EHCI
 	select IMX_HAVE_PLATFORM_MXC_MMC
 	select LEDS_GPIO_REGISTER
diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index 318bd8d..b051592 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -565,6 +565,7 @@ static void __init visstrim_m10_board_init(void)
 	imx27_add_mxc_mmc(0, &visstrim_m10_sdhc_pdata);
 	imx27_add_mxc_ehci_otg(&visstrim_m10_usbotg_pdata);
 	imx27_add_fec(NULL);
+	imx27_add_sahara();
 	imx_add_gpio_keys(&visstrim_gpio_keys_platform_data);
 	platform_add_devices(platform_devices, ARRAY_SIZE(platform_devices));
 	imx_add_platform_device("mx27vis", 0, NULL, 0, &snd_mx27vis_pdata,
-- 
1.7.9.5

From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/39] ARM: ux500: Move SDI (MMC) and UART devices under more descriptive heading
Date: Wed, 15 May 2013 10:51:29 +0100
Message-ID: <1368611522-9984-7-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, vinod.koul@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60980 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab3EOJwY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 May 2013 05:52:24 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so1425644wgh.30
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2013 02:52:23 -0700 (PDT)
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now DMA DT bindings exist and are in use by he MMC and UART drivers, it
should be possible to remove them from the auxdata structure. However,
after doing so the drivers fail. Common clk is still reliant on the
dev_name() call to do device name matching, which will fail due to the
fact that Device Tree naming differs somewhat do the more traditional
conventions.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 96ddbae..b1c9241 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -230,15 +230,15 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires call-back bindings. */
 	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &db8500_pmu_platdata),
 	/* Requires DMA bindings. */
+	OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
+	/* Requires clock name bindings. */
 	OF_DEV_AUXDATA("arm,pl011", 0x80120000, "uart0", NULL),
 	OF_DEV_AUXDATA("arm,pl011", 0x80121000, "uart1", NULL),
 	OF_DEV_AUXDATA("arm,pl011", 0x80007000, "uart2", NULL),
-	OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80126000, "sdi0",  NULL),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  NULL),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80005000, "sdi2",  NULL),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80114000, "sdi4",  NULL),
-	/* Requires clock name bindings. */
 	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e000, "gpio.0", NULL),
 	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e080, "gpio.1", NULL),
 	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8000e000, "gpio.2", NULL),
-- 
1.7.10.4

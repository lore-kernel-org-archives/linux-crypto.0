From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 37/39] ARM: ux500: Stop passing DMA platform data though AUXDATA
Date: Wed, 15 May 2013 10:52:00 +0100
Message-ID: <1368611522-9984-38-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, vinod.koul@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The DMA platform data is now empty due to some recent refactoring,
so there is no longer a requirement to pass it though.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index b407601..3b77e36 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -259,8 +259,7 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80125000,
 		"ux500-msp-i2s.3", &msp3_platform_data),
 	/* Requires clock name bindings and channel address lookup table. */
-	OF_DEV_AUXDATA("stericsson,db8500-dma40", 0x801C0000,
-		       "dma40.0", &dma40_plat_data),
+	OF_DEV_AUXDATA("stericsson,db8500-dma40", 0x801C0000, "dma40.0", NULL),
 	{},
 };
 
-- 
1.7.10.4

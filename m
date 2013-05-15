From: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 28/39] ARM: ux500: Remove empty function u8500_of_init_devices()
Date: Wed, 15 May 2013 10:51:51 +0100
Message-ID: <1368611522-9984-29-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, linus.walleij-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org,
	srinidhi.kasagar-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	balbi-l0cyMroinI0@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

As promised, now all devices which resided in u8500_of_init_devices()
have been enabled for Device Tree, we can completely remove it.

Acked-by: Fabio Baltieri <fabio.baltieri-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index f1e7a75..b407601 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -215,15 +215,6 @@ struct device * __init u8500_init_devices(void)
 }
 
 #ifdef CONFIG_MACH_UX500_DT
-
-/* TODO: Once all pieces are DT:ed, remove completely. */
-static struct device * __init u8500_of_init_devices(void)
-{
-	struct device *parent = db8500_soc_device_init();
-
-	return parent;
-}
-
 static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires call-back bindings. */
 	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &db8500_pmu_platdata),
@@ -283,7 +274,7 @@ static const struct of_device_id u8500_local_bus_nodes[] = {
 
 static void __init u8500_init_machine(void)
 {
-	struct device *parent = NULL;
+	struct device *parent = db8500_soc_device_init();
 
 	/* Pinmaps must be in place before devices register */
 	if (of_machine_is_compatible("st-ericsson,mop500"))
@@ -296,9 +287,6 @@ static void __init u8500_init_machine(void)
 	else if (of_machine_is_compatible("st-ericsson,ccu9540")) {}
 		/* TODO: Add pinmaps for ccu9540 board. */
 
-	/* TODO: Export SoC, USB, cpu-freq and DMA40 */
-	parent = u8500_of_init_devices();

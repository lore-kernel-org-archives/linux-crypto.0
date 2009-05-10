From: Harald Welte <HaraldWelte@viatech.com>
Subject: [RFC] how to auto-load via-rng ?
Date: Sun, 10 May 2009 14:33:37 +0800
Message-ID: <20090510063337.GE12152@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:60565 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZEJHIs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 May 2009 03:08:48 -0400
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.63)
	(envelope-from <HaraldWelte@viatech.com>)
	id 1M32gd-0004QT-Nl
	for linux-crypto@vger.kernel.org; Sun, 10 May 2009 08:38:59 +0200
Received: from laforge by prithivi.gnumonks.org with local (Exim 4.69)
	(envelope-from <HaraldWelte@viatech.com>)
	id 1M32bR-0003Yd-9b
	for linux-crypto@vger.kernel.org; Sun, 10 May 2009 14:33:37 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

I've been trying to come up with a method to automatically load the via-rng.ko
kernel module on systems that support the hardware RNG.

Right now the kernel builds the module, but almost nobody uses it, since it
is not automatically loaded.

I was thinking of creating a platform device from arch/x86/kernel/cpu/centaur.c
and then binding the via-rng.c driver to that platform device.  I've cooked
up a patch for this (see below), but it doesn't seem to work, all I get is
a very early kernel oops.

Maybe it is too early during kernel startup to create a platform_device?

Does anyone have an idea how to solve the problem? Is there a better method
than a platform device?

Right now, there also are three flavours of hardware RNG and in order to
support the Nano CPU, I need to be able to differentiate the different hardware
from via-rng.c.  The identification is based on CPUID flags.  I have a patch to
use CPUID from the via-rng.c, but think it's not clean.  The platform_device
method would allow me to use some platform_data to pass information about the
CPU stepping to via_rng.  What do you think about this?

Regards,


diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index c95e831..422502b 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -1,6 +1,7 @@
 #include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/platform_device.h>
 
 #include <asm/processor.h>
 #include <asm/e820.h>
@@ -239,6 +240,9 @@ static void __cpuinit winchip2_protect_mcr(void)
 }
 #endif /* CONFIG_X86_OOSTORE */
 
+/* fake device for request_firmware */
+static struct platform_device *via_rng_pdev;
+
 #define ACE_PRESENT	(1 << 6)
 #define ACE_ENABLED	(1 << 7)
 #define ACE_FCR		(1 << 28)	/* MSR_VIA_FCR */
@@ -271,6 +275,13 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 			printk(KERN_INFO "CPU: Enabled h/w RNG\n");
 		}
 
+		if (tmp & RNG_PRESENT)
+			via_rng_pdev =
+				platform_device_register_simple("via-rng", -1,
+								NULL, 0);
+		if (!via_rng_pdev)
+			printk(KERN_ERR "Cannot register VIA RNG device\n");
+
 		/* store Centaur Extended Feature Flags as
 		 * word 5 of the CPU capability bit array
 		 */
diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index 4e9573c..7b62857 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -7,6 +7,7 @@
  *
  * Hardware driver for the Intel/AMD/VIA Random Number Generators (RNG)
  * (c) Copyright 2003 Red Hat Inc <jgarzik@redhat.com>
+ * (c) Copyright 2009 Harald Welte <laforge@gnumonks.org>
  *
  * derived from
  *
@@ -28,6 +29,7 @@
 #include <linux/kernel.h>
 #include <linux/hw_random.h>
 #include <linux/delay.h>
+#include <linux/platform_device.h>
 #include <asm/io.h>
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
@@ -171,7 +173,6 @@ static int via_rng_init(struct hwrng *rng)
 	return 0;
 }
 
-
 static struct hwrng via_rng = {
 	.name		= "via",
 	.init		= via_rng_init,
@@ -179,13 +180,10 @@ static struct hwrng via_rng = {
 	.data_read	= via_rng_data_read,
 };
 
-
-static int __init mod_init(void)
+static int __init via_rng_probe(struct platform_device *pdev)
 {
 	int err;
 
-	if (!cpu_has_xstore)
-		return -ENODEV;
 	printk(KERN_INFO "VIA RNG detected\n");
 	err = hwrng_register(&via_rng);
 	if (err) {
@@ -197,9 +195,33 @@ out:
 	return err;
 }
 
-static void __exit mod_exit(void)
+static int __exit via_rng_remove(struct platform_device *pdev)
 {
 	hwrng_unregister(&via_rng);
+
+	return 0;
+}
+
+static struct platform_driver via_rng_driver = {
+	.driver = {
+		.name	= "via-rng",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= via_rng_probe,
+	.remove = __exit_p(via_rng_remove),
+};
+
+static int __init mod_init(void)
+{
+	if (!cpu_has_xstore)
+		return -ENODEV;
+
+	return platform_driver_register(&via_rng_driver);
+}
+
+static void __exit mod_exit(void)
+{
+	platform_driver_unregister(&via_rng_driver);
 }
 
 module_init(mod_init);
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison

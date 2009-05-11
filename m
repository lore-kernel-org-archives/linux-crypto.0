From: Arjan Koers <4kgluc2fa5qp@list.nospam.xutrox.com>
Subject: Re: [PATCH] The VIA Hardware RNG driver is for the CPU, not Chipset
Date: Mon, 11 May 2009 02:12:17 +0200
Message-ID: <4A076D61.1040608@list.nospam.xutrox.com>
References: <20090510062844.GD12152@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:55473 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbZEKAbB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 May 2009 20:31:01 -0400
Received: from [82.169.46.210] (helo=plutonium.lan)
	by smtp-out2.tiscali.nl with esmtp
	id 1M3J7y-0003p6-VZ
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2009 02:12:19 +0200
Received: from [IPv6:2001:470:d12d:2d84:4fd:acd2:d97:dfeb] (unknown [IPv6:2001:470:d12d:2d84:4fd:acd2:d97:dfeb])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by plutonium.lan (Postfix) with ESMTPS id E562D47BBF
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2009 02:12:17 +0200 (CEST)
In-Reply-To: <20090510062844.GD12152@prithivi.gnumonks.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Harald Welte wrote:
> This is a cosmetic change, fixing the MODULE_DESCRIPTION() of via-rng.c

Coincidentally, I was trying to make my RNG work for x86_64 today and I
was wondering about this. How can multiple RNGs in current dual-processor
setups and in the future multicore Nano be handled?


The MSR wizardry in via_rng_init doesn't seem to work on my Nano. I'm
simply skipping it with the patch below, because my RNG is enabled
by default. I don't know the proper way to initialize it because of
lacking documentation. Would you happen to know a better way of doing
this?

diff -u linux-2.6.30-rc5.orig/drivers/char/hw_random/Kconfig linux-2.6.30-rc5/drivers/char/hw_random/Kconfig
--- linux-2.6.30-rc5.orig/drivers/char/hw_random/Kconfig	2009-04-23 20:13:55.000000000 +0000
+++ linux-2.6.30-rc5/drivers/char/hw_random/Kconfig	2009-05-10 09:59:59.000000000 +0000
@@ -88,7 +88,7 @@

 config HW_RANDOM_VIA
 	tristate "VIA HW Random Number Generator support"
-	depends on HW_RANDOM && X86_32
+	depends on HW_RANDOM && X86
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
diff -u linux-2.6.30-rc5.orig/drivers/char/hw_random/via-rng.c linux-2.6.30-rc5/drivers/char/hw_random/via-rng.c
--- linux-2.6.30-rc5.orig/drivers/char/hw_random/via-rng.c	2009-03-23 23:12:14.000000000 +0000
+++ linux-2.6.30-rc5/drivers/char/hw_random/via-rng.c	2009-05-10 15:33:23.000000000 +0000
@@ -132,6 +132,17 @@
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	u32 lo, hi, old_lo;

+	/* Nano */
+	if ((c->x86 == 6) && (c->x86_model >= 0xf)) {
+		if (!cpu_has_xstore_enabled) {
+			printk(KERN_ERR PFX
+			       "don't know how to enable VIA Nano RNG,"
+			       " aborting\n");
+			return -ENODEV;
+		}
+		return 0;
+	}
+
 	/* Control the RNG via MSR.  Tread lightly and pay very close
 	 * close attention to values written, as the reserved fields
 	 * are documented to be "undefined and unpredictable"; but it


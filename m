From: Arjan Koers <4kgluc2fa5qp@list.nospam.xutrox.com>
Subject: Re: [PATCH] The VIA Hardware RNG driver is for the CPU, not Chipset
Date: Mon, 11 May 2009 13:22:01 +0200
Message-ID: <4A080A59.3010203@list.nospam.xutrox.com>
References: <20090510062844.GD12152@prithivi.gnumonks.org> <4A076D61.1040608@list.nospam.xutrox.com> <20090511025852.GE4005@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Harald Welte <HaraldWelte@viatech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:33127 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZEKLWJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2009 07:22:09 -0400
In-Reply-To: <20090511025852.GE4005@prithivi.gnumonks.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Harald,

Harald Welte wrote:
> Dear Arjan,
[...]
>> How can multiple RNGs in current dual-processor setups and in the future
>> multicore Nano be handled?
>  
> That's actually a good question.  I'll probably forward that to the CPU
> division and see what they come up with.  I would assume you just run the
> initialization on every CPU, and that's it.

It would probably have to be setup the same on all CPUs (enabled on all /
disabled on all), because the code might execute on any CPU.


> Now the more interesting question is: how can the hw_random framework deal
> with it?  As far as I remember, it can only select one out of N available
> concurrent providers of hardware randomness.  correct?

I don't know, but it would be nice if it could use PadLock functionality on
multiple CPUs at the same time for increased speed.


>> The MSR wizardry in via_rng_init doesn't seem to work on my Nano. 
> 
> This is due to the fact that the MSR itself does no longer exist on the Nano.
> It only exists on C3 to C7 silicon.

Thanks for the information. Do you happen to know what changed for the other
MSRs that are used for ACE, PowerSaver, ...?


>> I'm simply skipping it with the patch below, because my RNG is enabled by
>> default. 
> 
> yes, this is the correct method.  On Nano you only have to see if it is enabled
> in CPUID and forget about

Since the Nano RNG can't be configured, the patch could be changed to
something like this:

--- linux-2.6.30-rc5/drivers/char/hw_random/via-rng.c.orig	2009-03-23 23:12:14.000000000 +0000
+++ linux-2.6.30-rc5/drivers/char/hw_random/via-rng.c	2009-05-11 10:02:29.000000000 +0000
@@ -132,6 +132,13 @@
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	u32 lo, hi, old_lo;

+	/* VIA Nano CPUs don't have the MSR_VIA_RNG anymore.  The RNG
+	 * is always enabled if CPUID rng_en is set.  There is no
+	 * RNG configuration like it used to be the case in this
+	 * register */
+	if ((c->x86 == 6) && (c->x86_model >= 0x0f))
+		return 0;
+
 	/* Control the RNG via MSR.  Tread lightly and pay very close
 	 * close attention to values written, as the reserved fields
 	 * are documented to be "undefined and unpredictable"; but it
@@ -184,8 +191,17 @@
 {
 	int err;

-	if (!cpu_has_xstore)
+	if (!cpu_has_xstore) {
+		printk(KERN_NOTICE PFX "VIA RNG not detected.\n");
+		return -ENODEV;
+	}
+
+	if (!cpu_has_xstore_enabled) {
+		printk(KERN_NOTICE PFX "VIA RNG detected, but not enabled."
+		       " Hmm, strange...\n");
 		return -ENODEV;
+	}
+
 	printk(KERN_INFO "VIA RNG detected\n");
 	err = hwrng_register(&via_rng);
 	if (err) {

The check for cpu_has_xstore_enabled was moved to mod_init, because
it turns out that arch/x86/kernel/cpu/centaur.c already tries to
enable it in init_c3. This might break things if people have found
ways to disable it again after it got enabled in init_c3.
I've also changed mod_init to look more like
drivers/crypto/padlock-aes.c and drivers/crypto/padlock-sha.c

If it's possible for a Nano to have the cpuid rng flag set and the
rng_en flag unset, init_c3 in arch/x86/kernel/cpu/centaur.c may have
to be changed too. This seems very unlikely to me, because there would
be no way to enable the RNG then.


>> I don't know the proper way to initialize it because of lacking
>> documentation. 
> 
> the quick reference for padlock on the nano is public, despite not
> at a very well-known location:
> ftp://ftp.vtbridge.org/Docs/CPU/Nano/padlock_quick_reference_V095.pdf

Thanks for the link. Together with version 3.1 of the PadLock SDK
from the viaarena website, that's enough information about PadLock.
Unfortunately I've not been able to find documentation about other
features like the MSRs and Powersaver.

Kind regards,

Arjan Koers

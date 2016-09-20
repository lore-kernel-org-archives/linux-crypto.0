From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: crypto: caam from tasklet to threadirq
Date: Tue, 20 Sep 2016 22:10:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1609202202520.5476@nanos>
References: <DB5PR04MB130229BBD433C8FF7BDD975FEEF90@DB5PR04MB1302.eurprd04.prod.outlook.com> <DB5PR04MB1302AD00536D2E37E726E104EEF30@DB5PR04MB1302.eurprd04.prod.outlook.com> <20160920161228.GQ1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Cata Vasile <cata.vasile@nxp.com>,
        Horia Geanta Neag <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60453 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbcITUMs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2016 16:12:48 -0400
In-Reply-To: <20160920161228.GQ1041@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 20 Sep 2016, Russell King - ARM Linux wrote:
> which corresponds to an 8% slowdown for the threaded IRQ case.  So,
> tasklets are indeed faster than threaded IRQs.

Fair enough.

> I've tried to perf it, but...
>  ....
 
> So, sorry, I'm not going to bother trying to get any further with this.
> If the job was not made harder stupid hardware design and kernel
> politics, then I might be more inclined to do deeper investigation, but
> right now I'm finding that I'm not interested in trying to jump through
> these stupid hoops.

I'd be very interested in a sched_switch + irq + softirq trace which does
not involve PMU hardware for both irqthreads and tasklets, but I can
understand if you can't be bothered to gather it.

Vs. the PMU interrupt thing. What's the politics about that? Do you have
any pointers?
 
> I think I've proven from the above that this patch needs to be reverted
> due to the performance regression, and that there _is_ most definitely
> a deterimental effect of switching from tasklets to threaded IRQs.

I agree that the revert should happen, but I'd rather see a bit more
information why this regression happens with the switch from tasklets to
threaded irqs.

Thanks,

	tglx

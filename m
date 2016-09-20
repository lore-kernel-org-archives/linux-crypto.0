From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: crypto: caam from tasklet to threadirq
Date: Wed, 21 Sep 2016 01:31:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1609210104210.5476@nanos>
References: <DB5PR04MB130229BBD433C8FF7BDD975FEEF90@DB5PR04MB1302.eurprd04.prod.outlook.com> <DB5PR04MB1302AD00536D2E37E726E104EEF30@DB5PR04MB1302.eurprd04.prod.outlook.com> <20160920161228.GQ1041@n2100.armlinux.org.uk> <alpine.DEB.2.20.1609202202520.5476@nanos>
 <20160920213219.GR1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Cata Vasile <cata.vasile@nxp.com>,
        Horia Geanta Neag <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60851 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbcITXe0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2016 19:34:26 -0400
In-Reply-To: <20160920213219.GR1041@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 20 Sep 2016, Russell King - ARM Linux wrote:
> each of those places where af_alg_wait_for_completion() called, we
> end up submitting a bunch of data and then immediately waiting for
> the operation to complete... and this can be seen in the perf
> trace logs.

That'd explain it.
 
> So, unless I'm mistaken, there's no way for a crypto backend to run
> asynchronously, and there's no way for a crypto backend to batch up
> the "job" - in order to do that, I think it would have to store quite
> a lot of state.

Hmm.

> Now, I'm not entirely sure that asking perf to record irq:* and
> sched:* events was what we were after - there appears to be no trace
> events recorded for entering a threaded IRQ handler.

Indeed. We can only deduce it from the thread being woken and scheduled
in/out. ?me makes note to add a tracepoint in the thread handler
invocation.

> So 123us (260322 - 260199) to the switch to openssl via the threaded IRQ.

> 101us (667202 - 667101) between the same two events, which is 22us
> faster than the above.

So it looks like the two extra context switches are responsible for that
delta.
 
> Attached are compressed files of the perf script -G output.  If you
> want the perf.data files, I have them (I'm not sure how useful they
> are without the binaries though.)

Thanks. I'll have a look tomorrow when brain is unfried.

> > Vs. the PMU interrupt thing. What's the politics about that? Do you have
> > any pointers?
> 
> I just remember there being a discussion about how stupid FSL have been
> and "we're not going to support that" - the perf code wants the per-CPU
> performance unit interrupts delivered _on_ the CPU to which the perf
> unit is attached.  FSL decided in their stupidity to OR all the perf
> unit interrupts together and route them to a single common interrupt.

Brilliant.
 
> This means that we end up with one CPU taking the perf interrupt for
> any perf unit - and the CPUs can only access their local perf unit.
> So, if (eg) CPU1's perf unit fires an interrupt, but the common
> interrupt is routed to CPU0, CPU0 checks its perf unit, finds no
> interrupt, and returns with IRQ_NONE.
> 
> There's no mechanism in perf (or anywhere else) to hand the interrupt
> over to another CPU.
> 
> The result is that trying to run perf on the multi-core iMX SoCs ends
> up with the perf interrupt disabled, at which point perf collapses in
> a sad pile.

Not surprising.

Solving that in perf is probably the wrong place. So what we'd need is some
kind of special irq flow handler which does:

	ret = handle_irq(desc);
	if (ret == IRQ_NONE && desc->ipi_next) {
     		dest = get_next_cpu(this_cpu);
		if (dest != this_cpu)
			desc->ipi_next(dest);
			
     }

get_next_cpu() would just pick the next cpu in the online mask or the first
when this_cpu is the last one in the mask.

That shouldn't be overly complex to implement. All you'd need to do in the
PMU driver is to hook into that IPI vector.

If you're interested then I can hack the core bits.

Thanks,

	tglx




   

      	

From: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH] The VIA Hardware RNG driver is for the CPU, not Chipset
Date: Tue, 12 May 2009 01:46:15 +0800
Message-ID: <20090511174615.GH4163@prithivi.gnumonks.org>
References: <20090510062844.GD12152@prithivi.gnumonks.org> <4A076D61.1040608@list.nospam.xutrox.com> <20090511025852.GE4005@prithivi.gnumonks.org> <4A080A59.3010203@list.nospam.xutrox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Arjan Koers <4kgluc2fa5qp@list.nospam.xutrox.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:49671 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZEKSAU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2009 14:00:20 -0400
Content-Disposition: inline
In-Reply-To: <4A080A59.3010203@list.nospam.xutrox.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Arjan,

On Mon, May 11, 2009 at 01:22:01PM +0200, Arjan Koers wrote:
> Harald Welte wrote:
> >> How can multiple RNGs in current dual-processor setups and in the future
> >> multicore Nano be handled?
> >  
> > That's actually a good question.  I'll probably forward that to the CPU
> > division and see what they come up with.  I would assume you just run the
> > initialization on every CPU, and that's it.
> 
> It would probably have to be setup the same on all CPUs (enabled on all /
> disabled on all), because the code might execute on any CPU.

yes, but I don't really consider this a practical problem.  I think there
is no practical case where half of the CPUs want a hardware RNG, and half
of them don't.  If somebody really has that kind of special need, he can
probably patch his kernel himself.

> > Now the more interesting question is: how can the hw_random framework deal
> > with it?  As far as I remember, it can only select one out of N available
> > concurrent providers of hardware randomness.  correct?
> 
> I don't know, but it would be nice if it could use PadLock functionality on
> multiple CPUs at the same time for increased speed.

I'm not so sure if that really makes sense just to increase throughput of
a single workload / work item.  However, for multiple concurrent threads,
of course each thread on each CPU should be able to use the padlock
instructions for AES / PHE / RNG.  And if you enable the feature on all CPU's
during the respective module_init(), it should simply work afterwards.

> > This is due to the fact that the MSR itself does no longer exist on the Nano.
> > It only exists on C3 to C7 silicon.
> 
> Thanks for the information. Do you happen to know what changed for the other
> MSRs that are used for ACE, PowerSaver, ...?

I unfortunately don't [yet] but I'll inquire.

> Since the Nano RNG can't be configured, the patch could be changed to
> something like this:

yes, thanks. looks fine to me.

> If it's possible for a Nano to have the cpuid rng flag set and the
> rng_en flag unset, init_c3 in arch/x86/kernel/cpu/centaur.c may have
> to be changed too. This seems very unlikely to me, because there would
> be no way to enable the RNG then.

I'll re-confirm this with the CPU R&D, too.

Regards,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison

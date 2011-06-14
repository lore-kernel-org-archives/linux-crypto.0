From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Tue, 14 Jun 2011 12:13:49 -0500
Message-ID: <1308071629.15617.127.camel@calx>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
	 <1308006912.15617.67.camel@calx>  <4DF77BBC.8090702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from waste.org ([173.11.57.241]:51331 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab1FNRNw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 13:13:52 -0400
In-Reply-To: <4DF77BBC.8090702@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2011-06-14 at 11:18 -0400, Jarod Wilson wrote:
> Matt Mackall wrote:
> > On Mon, 2011-06-13 at 18:06 -0400, Jarod Wilson wrote:
> >> Many server systems are seriously lacking in sources of entropy,
> >> as we typically only feed the entropy pool by way of input layer
> >> events, a few NIC driver interrupts and disk activity. A non-busy
> >> server can easily become entropy-starved. We can mitigate this
> >> somewhat by periodically mixing in entropy data based on the
> >> delta between multiple high-resolution clocksource reads, per:
> >>
> >>    https://www.osadl.org/Analysis-of-inherent-randomness-of-the-L.rtlws11-developers-okech.0.html
> >>
> >> Additionally, NIST already approves of similar implementations, so
> >> this should be usable in high-securtiy deployments requiring a
> >> fair chunk of available entropy data for frequent use of /dev/random.
> >
> > So, mixed feelings here:
> >
> > Yes: it's a great idea to regularly mix other data into the pool. More
> > samples are always better for RNG quality.
> >
> > Maybe: the current RNG is not really designed with high-bandwidth
> > entropy sources in mind, so this might introduce non-negligible overhead
> > in systems with, for instance, huge numbers of CPUs.
> 
> The current implementation is opt-in, and single-threaded, so at least 
> currently, I don't think there should be any significant issues. But 
> yeah, there's nothing currently in the implementation preventing a 
> variant that is per-cpu, which could certainly lead to some scalability 
> issues.

The pool itself is single-threaded. On large-ish machines (100+ CPUs),
we've seen contention rise to 60% or more. Hence the addition of the
trickle threshold. But I can see that breaking down with a lot more
writers.

> > No: it's not a great idea to _credit_ the entropy count with this data.
> > Someone watching the TSC or HPET from userspace can guess when samples
> > are added by watching for drop-outs in their sampling (ie classic timing
> > attack).
> 
> I'm admittedly a bit of a novice in this area... Why does it matter if 
> someone watching knows more or less when a sample is added? It doesn't 
> really reveal anything about the sample itself, if we're using a 
> high-granularity counter value's low bits -- round-trip to userspace has 
> all sorts of inherent timing jitter, so determining the low-order bits 
> the kernel got by monitoring from userspace should be more or less 
> impossible. And the pool is constantly changing, making it a less static 
> target on an otherwise mostly idle system.

I recommend you do some Google searches for "ssl timing attack" and "aes
timing attack" to get a feel for the kind of seemingly impossible things
that can be done and thereby recalibrate your scale of the impossible.

> > (I see you do credit only 1 bit per byte: that's fairly conservative,
> > true, but it must be _perfectly conservative_ for the theoretical
> > requirements of /dev/random to be met. These requirements are in fact
> > known to be unfulfillable in practice(!), but that doesn't mean we
> > should introduce more users of entropy accounting. Instead, it means
> > that entropy accounting is broken and needs to be removed.)
> 
> Hrm. The government seems to have a different opinion. Various certs 
> have requirements for some sort of entropy accounting and minimum 
> estimated entropy guarantees. We can certainly be even more conservative 
> than 1 bit per byte, but yeah, I don't really have a good answer for 
> perfectly conservative, and I don't know what might result (on the 
> government cert front) from removing entropy accounting altogether...

Well, the deal with accounting is this: if you earn $.90 and spend $1.00
every day, you'll eventually go broke, even if your
rounded-to-the-nearest-dollar accounting tells you you're solidly in the
black.

The only distinction between /dev/random and urandom is that we claim
that /dev/random is always solidly in the black. But as we don't have a
firm theoretical basis for making our accounting estimates on the input
side, the whole accounting thing kind of breaks down into a kind of
busted rate-limiter.

We'd do better counting a raw number of samples per source, and then
claiming that we've reached a 'full' state when we reach a certain
'diversity x depth' score. And then assuring we have a lot of diversity
and depth going into the pool.


> Any thoughts on the idea of mixing clocksource bits with reads from 
> ansi_cprng?

Useless. The definition of entropy here can be thought of as 'log(volume
of state space that can't be observed by an attacker)'. There is nothing
we can do algorithmically to a sample that will increase that volume, we
can only shrink it! And any function that is not completely reversible
(aka 1:1) will in fact shrink that volume, so you have to be very
careful here. The mixing primitives are already quite solid, no need to
layer on more potentially faulty ones.


-- 
Mathematics is the supreme nostalgia of our time.

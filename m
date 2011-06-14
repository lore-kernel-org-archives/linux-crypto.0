From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Tue, 14 Jun 2011 18:12:22 -0500
Message-ID: <1308093142.15617.233.camel@calx>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
	 <1308006912.15617.67.camel@calx>  <4DF77BBC.8090702@redhat.com>
	 <1308071629.15617.127.camel@calx>  <4DF7C1CD.4060504@redhat.com>
	 <1308087902.15617.208.camel@calx>  <4DF7E5FB.3080907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Steve Grubb <sgrubb@redhat.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from waste.org ([173.11.57.241]:48334 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab1FNX1F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 19:27:05 -0400
In-Reply-To: <4DF7E5FB.3080907@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2011-06-14 at 18:51 -0400, Jarod Wilson wrote:
> Matt Mackall wrote:
> > On Tue, 2011-06-14 at 16:17 -0400, Jarod Wilson wrote:
> >> Matt Mackall wrote:
> >>> On Tue, 2011-06-14 at 11:18 -0400, Jarod Wilson wrote:
> >>>> Matt Mackall wrote:
> >> ...
> >>>>> No: it's not a great idea to _credit_ the entropy count with this data.
> >>>>> Someone watching the TSC or HPET from userspace can guess when samples
> >>>>> are added by watching for drop-outs in their sampling (ie classic timing
> >>>>> attack).
> >>>> I'm admittedly a bit of a novice in this area... Why does it matter if
> >>>> someone watching knows more or less when a sample is added? It doesn't
> >>>> really reveal anything about the sample itself, if we're using a
> >>>> high-granularity counter value's low bits -- round-trip to userspace has
> >>>> all sorts of inherent timing jitter, so determining the low-order bits
> >>>> the kernel got by monitoring from userspace should be more or less
> >>>> impossible. And the pool is constantly changing, making it a less static
> >>>> target on an otherwise mostly idle system.
> >>> I recommend you do some Google searches for "ssl timing attack" and "aes
> >>> timing attack" to get a feel for the kind of seemingly impossible things
> >>> that can be done and thereby recalibrate your scale of the impossible.
> >> Hm. These are attempting to reveal a static key though. We're talking
> >> about trying to reveal the exact value of the counter when it was read
> >> by the kernel. And trying to do so repeatedly, several times per second.
> >
> > I read this as "I am not yet properly recalibrated".
> 
> Probably not. :)
> 
> > Yes, it's hard. Hard != impractical.
> >
> >> And this can't be done without getting some form of local system access,
> >
> > Ok, now Google "remote timing attack".
> 
> The stuff I'm reading seems to require that the data you're trying to 
> discern is somehow exposed over the network, which so far as I know, the 
> entropy input pool isn't, but you obviously know this stuff WAY better 
> than I do, so I'll stop trying. ;)
> 
> >> This code is largely spurned on by someone here at Red Hat who I
> >> probably should have had in the cc list to begin with, Steve Grubb, who
> >> pointed to slides 23-25 and the chart in slide 30 of this doc...
> >>
> >> https://www.osadl.org/fileadmin/dam/presentations/RTLWS11/okech-inherent-randomness.pdf
> >>
> >> ...as the primary arguments for why this is a good source of entropy.
> >
> > ..on a sixth-generation desktop CPU with a cycle-accurate counter.
> >
> > Welcome to the real world, where that's now a tiny minority of deployed
> > systems.
> 
> Sure, but that's part of why only the hpet and tsc clocksources were 
> wired up in this patchset.

> > But that's not even the point. Entropy accounting here is about
> > providing a theoretical level of security above "cryptographically
> > strong". As the source says:
> >
> > "Even if it is possible to  analyze SHA in some clever way, as long as
> > the amount of data returned from the generator is less than the inherent
> > entropy in the pool, the output data is totally unpredictable."
> >
> > This is the goal of the code as it exists. And that goal depends on
> > consistent _underestimates_ and accurate accounting.
> 
> Okay, so as you noted, I was only crediting one bit of entropy per byte 
> mixed in. Would there be some higher mixed-to-credited ratio that might 
> be sufficient to meet the goal?

As I've mentioned elsewhere, I think something around .08 bits per
timestamp is probably a good target. That's the entropy content of a
coin-flip that is biased to flip heads 99 times out of 100. But even
that isn't good enough in the face of a 100Hz clock source.

And obviously the current system doesn't handle fractional bits at all.

> > Look, I understand what I'm trying to say here is very confusing, so
> > please make an effort to understand all the pieces together:
> >
> > - the driver is designed for -perfect- security as described above
> > - the usual assumptions about observability of network samples and other
> > timestamps ARE FALSE on COMMON NON-PC HARDWARE
> > - thus network sampling is incompatible with the CURRENT design
> > - nonetheless, the current design of entropy accounting is not actually
> > meeting its goals in practice
> 
> Heh, I guess that answers my question already...
> 
> > - thus we need an alternative to entropy accounting
> > - that alternative WILL be compatible with sampling insecure sources
> 
> Okay. So I admit to really only considering and/or caring about x86 
> hardware, which doesn't seem to have helped my cause. But you do seem to 
> be saying that clocksource-based sampling *will* be compatible with the 
> new alternative, correct? And is said alternative something on the 
> relatively near-term radar?

Various people have offered to spend some time fixing this; I haven't
had time to look at it for a while.

-- 
Mathematics is the supreme nostalgia of our time.

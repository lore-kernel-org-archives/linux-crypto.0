From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Wed, 15 Jun 2011 15:06:43 -0500
Message-ID: <1308168403.15617.368.camel@calx>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
	 <1308006912.15617.67.camel@calx>  <4DF77BBC.8090702@redhat.com>
	 <1308071629.15617.127.camel@calx>  <4DF7C1CD.4060504@redhat.com>
	 <1308087902.15617.208.camel@calx>  <4DF7E5FB.3080907@redhat.com>
	 <1308093142.15617.233.camel@calx>  <4DF8C683.8040709@redhat.com>
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
Received: from waste.org ([173.11.57.241]:45266 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab1FOUGs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2011 16:06:48 -0400
In-Reply-To: <4DF8C683.8040709@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2011-06-15 at 10:49 -0400, Jarod Wilson wrote:
> Matt Mackall wrote:
> > On Tue, 2011-06-14 at 18:51 -0400, Jarod Wilson wrote:
> >> Matt Mackall wrote:
> ...
> >>> But that's not even the point. Entropy accounting here is about
> >>> providing a theoretical level of security above "cryptographically
> >>> strong". As the source says:
> >>>
> >>> "Even if it is possible to  analyze SHA in some clever way, as long as
> >>> the amount of data returned from the generator is less than the inherent
> >>> entropy in the pool, the output data is totally unpredictable."
> >>>
> >>> This is the goal of the code as it exists. And that goal depends on
> >>> consistent _underestimates_ and accurate accounting.
> >> Okay, so as you noted, I was only crediting one bit of entropy per byte
> >> mixed in. Would there be some higher mixed-to-credited ratio that might
> >> be sufficient to meet the goal?
> >
> > As I've mentioned elsewhere, I think something around .08 bits per
> > timestamp is probably a good target. That's the entropy content of a
> > coin-flip that is biased to flip heads 99 times out of 100. But even
> > that isn't good enough in the face of a 100Hz clock source.
> >
> > And obviously the current system doesn't handle fractional bits at all.
> 
> What if only one bit every n samples were credited? So 1/n bits per 
> timestamp, effectively, and for an n of 100, that would yield .01 bits 
> per timestamp. Something like this:

Something like that would "work", sure. But it's a hack/abuse -relative
to the current framework-. I'm reluctant to just pile on the hacks on
the current system, as that just means getting it coherent is that much
further away.

The current system says things like "I've gotten 20 samples at intervals
that look vaguely random based on their timestamps, I'm calling that 64
bits of entropy. That's enough to reseed!" But what it doesn't know is
that those all came from the local network from an attacker with access
to a better clock than us. Or that they all came from an HPET, but the
attacker was directly driving its firing. Or that they came from a
wireless mouse, and the attacker has an RF snooper. So that in the end,
it's only 20 bits of entropy and the attacker can brute-force its way
through the state space. (Yes, this is obviously paranoid, because
that's a ground rule.)

A better framework would say something like "I don't actually pretend to
know how to 'measure' entropy, but I've got 1000 samples batched from 4
different subsystems (clock, scheduler, network, block I/O), an attacker
is going to have a very hard time monitoring/predicting all of those,
and even if it's got 99% accuracy per sample on all sources, it's still
got > 2^64 work to guess the current state. Let's refresh our pool and
call it full". See?

Here's a sketch. Each subsystem does something like:

 add_rng_sample(RNG_NETWORK, some_packet_data);

And that code does something like:

pool = per_cpu(sample_pool);
timestamp = sched_clock();
mix(pool, MAKESAMPLE(sample_data, source, timestamp), sizeof(rng_sample));

pool.sample_count++;
if (!(source & pool.source_mask)) {
	/* haven't seen this source since last reseed */
	pool.source_mask |= source;
	pool.source_count++;	

/* Do we have enough sample depth and diversity in our per-cpu pool? */
if (pool.sample_count[pool.source_count] > threshold[pool.source_count]) {
	/* yes, reseed the main pool */
	reseed(input_pool, pool, reseed_entropy);
	/* "empty" our sample pool */
	pool.sample_count = pool.source_count = pool.source_mask = 0;
}

-- 
Mathematics is the supreme nostalgia of our time.

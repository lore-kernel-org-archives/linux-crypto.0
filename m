From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Fri, 17 Jun 2011 15:28:07 -0500
Message-ID: <1308342487.15617.552.camel@calx>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
	 <1308006912.15617.67.camel@calx>  <4DF77BBC.8090702@redhat.com>
	 <1308071629.15617.127.camel@calx>  <4DF7C1CD.4060504@redhat.com>
	 <1308087902.15617.208.camel@calx>  <4DF7E5FB.3080907@redhat.com>
	 <1308093142.15617.233.camel@calx>  <4DFBAF75.30505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Steve Grubb <sgrubb@redhat.com>,
	Fenghua Yu <fenghua.yu@intel.com>
To: hpas@zytor.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from waste.org ([173.11.57.241]:44186 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab1FQU2M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2011 16:28:12 -0400
In-Reply-To: <4DFBAF75.30505@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2011-06-17 at 12:48 -0700, hpas@zytor.com wrote:
> On 06/14/2011 04:12 PM, Matt Mackall wrote:
> > 
> > Various people have offered to spend some time fixing this; I haven't
> > had time to look at it for a while.
> > 
> 
> So on my (long...) list of things to do for a while is enablement of
> RDRAND, which is a new instruction in Ivy Bridge disclosed in the latest
> few revisions of the AVX spec and is now in the SDM (the functional
> description is in vol 1, section 7.3.18 of the May 2011 edition.)
> 
> Fenghua Yu did an initial enabling patch, but we have had to make some
> changes.
> 
> >From the SDM:
> 
> "The random numbers that are returned by the RDRAND instruction are
> supplied by a cryptographically secure Random Number Generator that
> employs a hardware DRBG (Digital Random Bit Generator, also known as a
> Pseudo Random Number Generator) seeded by a hardware NRBG
> (Nondeterministic Random Bit Generator, also known as a TRNG or True
> Random Number generator).
> 
> In order for the hardware design to meet its security goals, the random
> number generator continuously tests itself and the random data it is
> generating. Runtime failures in the random number generator circuitry or
> statistically anomalous data occurring by chance will be detected by the
> self test hardware and flag the resulting data as being bad. In such
> extremely rare cases, the RDRAND instruction will return no data instead
> of bad data."
> 
> Additionally, there is a software enabling guide containing a *lot* more
> detail at:
> 
> 	http://tinyurl.com/6x6dmd2/
> 
> This basically means it is similar in behavior to our /dev/urandom in
> that it may gracefully degrade to a PRNG for short stretches of time,
> but will not degrade to a PRNG for an extended time, nor will it produce
> guessable data, ever; instead it will "fail shut."
> 
> The one use case that it is cryptographically insufficient for is to
> seed a new PRNG, which probably means it is unsuitable for being fed
> as-is into /dev/random.

The thing to understand about the input side of /dev/random is that it's
COMPLETELY immune to untrusted data. So there's absolutely no harm in
sending it data of questionable entropy so long as you don't tell it to
account it. And, of course, if it DOES contain entropy, it makes things
better.

Think of it this way: I have a coin in my pocket. You, the attacker,
tell me to flip it. You can do that any number of times and not improve
your guess about the coin's state over your initial guess. This is what
it means to have a reversible mixing function: no number of iterations
reduces the degrees of freedom of the pool.

-- 
Mathematics is the supreme nostalgia of our time.

From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Sun, 19 Jun 2011 09:38:43 -0400
Message-ID: <20110619133843.GA2900@neilslaptop.think-freely.org>
References: <1308006912.15617.67.camel@calx>
 <4DF77BBC.8090702@redhat.com>
 <1308071629.15617.127.camel@calx>
 <4DF7C1CD.4060504@redhat.com>
 <1308087902.15617.208.camel@calx>
 <4DF7E5FB.3080907@redhat.com>
 <1308093142.15617.233.camel@calx>
 <4DFBAF75.30505@zytor.com>
 <1308342487.15617.552.camel@calx>
 <4DFD2972.7020603@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, Jarod Wilson <jarod@redhat.com>,
	linux-crypto@vger.kernel.org,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Steve Grubb <sgrubb@redhat.com>,
	Fenghua Yu <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37252 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1FSNjF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Jun 2011 09:39:05 -0400
Content-Disposition: inline
In-Reply-To: <4DFD2972.7020603@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 18, 2011 at 03:40:50PM -0700, H. Peter Anvin wrote:
> On 06/17/2011 01:28 PM, Matt Mackall wrote:
> >>
> >> The one use case that it is cryptographically insufficient for is to
> >> seed a new PRNG, which probably means it is unsuitable for being fed
> >> as-is into /dev/random.
> > 
> > The thing to understand about the input side of /dev/random is that it's
> > COMPLETELY immune to untrusted data. So there's absolutely no harm in
> > sending it data of questionable entropy so long as you don't tell it to
> > account it. And, of course, if it DOES contain entropy, it makes things
> > better.
> > 
> > Think of it this way: I have a coin in my pocket. You, the attacker,
> > tell me to flip it. You can do that any number of times and not improve
> > your guess about the coin's state over your initial guess. This is what
> > it means to have a reversible mixing function: no number of iterations
> > reduces the degrees of freedom of the pool.
> > 
> 
> What I meant is that it is unsuitable to *bypass the pool* for
> /dev/random.  I think we can -- and almost certainly should -- use
> RDRAND on the input side; we just have to figure out the accounting.
> 
>From your description of the instruction, this sounds almost identical to me as
what I suggested in using an instance of the cprng module in the kernel as the
drng coupled with using the tsc entropy as the trng input to reseed it.  We
could use rnrand when possible on the input to the entropy pool, and the
software cprng when that wasn't available.

> However, RDRAND is high enough quality (and high enough bandwidth) that
> it should be not just possible but desirable to completely bypass the
> pool system for /dev/urandom users and pull straight from the RDRAND
> instruction.  I don't actually know what the exact numbers look like,
> but the stall conditions being looked at are of the order of "every core
> in the socket trying to execute RDRAND at the same time."
> 
It sounds to me like, if its desireous to bypass the entropy pool, then we
should bypass the /dev/random path altogether.  Why not write a hwrng driver
that can export access to the rdrand instruction via a misc device.

Neil

> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

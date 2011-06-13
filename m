From: Kent Borg <kentborg@borg.org>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Mon, 13 Jun 2011 19:55:28 -0400
Message-ID: <4DF6A370.3000200@borg.org>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	<1308002818-27802-5-git-send-email-jarod@redhat.com> <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: Venkatesh Pallipadi <venki@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from borg.org ([64.105.205.123]:40323 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab1FMXzi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 19:55:38 -0400
In-Reply-To: <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Venkatesh Pallipadi wrote:
> On Mon, Jun 13, 2011 at 3:06 PM, Jarod Wilson <jarod@redhat.com> wrote:
>   
>> TSC is high enough resolution that we can use its low-order byte to
>> stir new data into the random number generator entropy pool.
>
> From what I vaguely remember from years past, rdtsc, especially last
> few bits of it are not very good as random number source. 

It doesn't have to be "random" (a very high bar), it just has to be 
somewhat non-deterministic to contain entropy (a low-bar).  The idea 
isn't to  use the TSC as a random number, only to use it for mixing the 
pool.  If somehow the TSC were *completely* deterministic, we would only 
fail to add entropy, any entropy already in the pool would still be just 
as good as before, no harm done.  (Like a perfect shuffle of an already 
randomly arranged deck of cards.)

Okay, not "no harm", a ~little~ harm.  There are two problems with using 
the TSC if it doesn't have much entropy:

  1. It wastes computrons.  Okay, have efficient code, don't run it too 
often.

  2. Entropy estimates might be too high.  Okay, but entropy estimation 
is a horrible
     problem in the best of well-defined circumstances.  Some (Schneier 
I think) say
     it isn't worth attempting.  Difficulty in estimating entropy is a 
bad excuse for
     starving the system of entropy.  Better to credit no entropy than 
to collect
     no entropy.  In a server, entropy sources should not be discarded.

> As they are
> based on lower bus frequency and a multiplier. 

Based on a lower bus frequency, but multiplied up in the CPU.  Why?  
Because synchronous clock distribution is very difficult at GHz speeds.  
Heck, even inside the CPU, clock distribution is not a trivial matter.  
It is impossible for anyone at a distance to know the LSB of the TSC at 
any given moment because the very concept of a "given moment" is ill 
defined at any distance.

And how is the low-frequency clock multiplied up?  With analog circuitry 
(a PLL, right?), and analog is a source of indeterminism.  There is 
going to be a little jitter in there.  Differences from chip-to-chip, 
with slight power supply changes, with temperature, with time.


Disclaimer: I have not looked at the patch carefully, it might be shit.  
But the idea of letting us add some entropy is excellent!


-kb, the Kent who has been paid money for building a defensible RNG.

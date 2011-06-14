From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Tue, 14 Jun 2011 16:04:18 -0500
Message-ID: <1308085458.15617.175.camel@calx>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
	 <1308002818-27802-5-git-send-email-jarod@redhat.com>
	 <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
	 <4DF690E4.1060004@zytor.com> <4DF6ADD0.6080607@borg.org>
	 <4DF6BDB4.2060201@zytor.com>  <4DF75688.2050509@borg.org>
	 <1308062037.15617.71.camel@calx>  <4DF79EF1.3010004@borg.org>
	 <1308074432.15617.136.camel@calx>  <4DF7BEB5.1070006@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Venkatesh Pallipadi <venki@google.com>,
	Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: Kent Borg <kentborg@borg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from waste.org ([173.11.57.241]:37846 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab1FNVEX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 17:04:23 -0400
In-Reply-To: <4DF7BEB5.1070006@borg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2011-06-14 at 16:04 -0400, Kent Borg wrote:
> Matt Mackall wrote:
>  > [network adapters are] a great source of potential entropy, a bad
>  > source of guaranteed entropy. The current RNG tries to do
>  > accounting on the latter. Accounting on the former is extremely
>  > suspect.
> 
> So we need a patch that:
> 
>  - Deletes the IRQF_SAMPLE_RANDOM mention in feature-removal-schedule.txt,
> 
>  - Restores instances of IRQF_SAMPLE_RANDOM in drivers, and
> 
>  - Changes the credit_entropy_bits() to credit less entropy*.
> 
>    * The code seems to only handle integer values of entropy.  Maybe 
> when crediting, choose between 1 and 0 credits. 

No, that's not what I'm saying here. I'm saying we need to rethink
entropy accounting entirely.

An alternate plan is:

- add an add_network_randomness hook in the network stack that feeds
samples with 0 entropy credits (strengthen /dev/urandom)

- add similar sources elsewhere in the kernel

- remove the entropy accounting framework so that /dev/random is the
same as /dev/urandom


I currently don't think either of these is quite right for lots of
interesting systems and the answer is somewhere in the middle. 


Let me describle one extremely common pathological case: Wifi routers.
Many of these have effectively no storage and don't preserve pool data
across boots or a battery-backed RTC so they come up in a 'known' pool
state. Many of them also don't have a high-resolution time source or
cycle counter available. So guessing the timestamp on a network packet
is just about trivial. State extension attacks here are probably quite
easy (though I don't know that anyone's tried it).

So I think what we want to instead do is simply count samples until
we've got enough unleaked internal state that state extension becomes
hopeless. If we assume an attacker can guess each sample with 99%
accuracy (.08 bits per sample), pool state extension becomes intractable
(> 2^64 guesses) at a batch size on the order of 1000 samples. If we
have inputs from a variety of sources (network, keyboard, mouse, etc),
this number is probably quite a bit smaller.

This is a lot like the existing catastrophic reseed logic, except that
the effective multiplier is much larger and probably implies another
pool in the chain.

-- 
Mathematics is the supreme nostalgia of our time.

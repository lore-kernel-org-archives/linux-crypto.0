From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Mon, 13 Jun 2011 18:15:12 -0500
Message-ID: <1308006912.15617.67.camel@calx>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from waste.org ([173.11.57.241]:56626 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab1FNOlS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 10:41:18 -0400
In-Reply-To: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2011-06-13 at 18:06 -0400, Jarod Wilson wrote:
> Many server systems are seriously lacking in sources of entropy,
> as we typically only feed the entropy pool by way of input layer
> events, a few NIC driver interrupts and disk activity. A non-busy
> server can easily become entropy-starved. We can mitigate this
> somewhat by periodically mixing in entropy data based on the
> delta between multiple high-resolution clocksource reads, per:
> 
>   https://www.osadl.org/Analysis-of-inherent-randomness-of-the-L.rtlws11-developers-okech.0.html
> 
> Additionally, NIST already approves of similar implementations, so
> this should be usable in high-securtiy deployments requiring a
> fair chunk of available entropy data for frequent use of /dev/random.

So, mixed feelings here:

Yes: it's a great idea to regularly mix other data into the pool. More
samples are always better for RNG quality.

Maybe: the current RNG is not really designed with high-bandwidth
entropy sources in mind, so this might introduce non-negligible overhead
in systems with, for instance, huge numbers of CPUs.

No: it's not a great idea to _credit_ the entropy count with this data.
Someone watching the TSC or HPET from userspace can guess when samples
are added by watching for drop-outs in their sampling (ie classic timing
attack).

(I see you do credit only 1 bit per byte: that's fairly conservative,
true, but it must be _perfectly conservative_ for the theoretical
requirements of /dev/random to be met. These requirements are in fact
known to be unfulfillable in practice(!), but that doesn't mean we
should introduce more users of entropy accounting. Instead, it means
that entropy accounting is broken and needs to be removed.)

> http://csrc.nist.gov/groups/STM/cmvp/documents/140-1/140sp/140sp750.pdf
> (section 6.1 mentions a clock-based seed source).
> 
> Yes, thus far, I've only bothered with x86-based clocksources, since that
> is what I can test most easily. If this patch series isn't deemed totally
> insane, adding support for other clocksources should be trivial.
> 
> Also note that unless you explicitly build and load the clock-entropy
> driver, there should be little or no change whatsoever to the way anything
> behaves right now, its purely opt-in. There's probably room for some
> improvement here, and I'm kind of outside my comfort area, but hey, it
> seems to work pretty well here in my own testing, so here it is...
> 
> Jarod Wilson (5):
>   random: add new clocksource entropy interface
>   clocksource: add support for entropy-generation function
>   hpet: wire up entropy generation function
>   tsc: wire up entropy generation function
>   misc: add clocksource-based entropy generation driver
> 
>  arch/x86/kernel/hpet.c       |   18 ++++++
>  arch/x86/kernel/tsc.c        |   18 ++++++
>  drivers/char/random.c        |   28 ++++++++++
>  drivers/misc/Kconfig         |   14 +++++
>  drivers/misc/Makefile        |    1 +
>  drivers/misc/clock-entropy.c |  122 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/clocksource.h  |    6 ++
>  include/linux/random.h       |    1 +
>  kernel/time/clocksource.c    |   33 +++++++++++
>  9 files changed, 241 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/clock-entropy.c
> 
> CC: Matt Mackall <mpm@selenic.com>
> CC: "Venkatesh Pallipadi (Venki)" <venki@google.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: John Stultz <johnstul@us.ibm.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>


-- 
Mathematics is the supreme nostalgia of our time.

From: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Mon, 13 Jun 2011 15:38:45 -0700
Message-ID: <1308004725.2893.20.camel@work-vm>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:55604 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab1FMWjK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 18:39:10 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5DMa7do005945
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jun 2011 16:36:07 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5DMcopF174934
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jun 2011 16:38:50 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5DGclcP007860
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jun 2011 10:38:49 -0600
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
> 
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

So this is interesting work, but I have a few questions.

1) hpet_add_entropy() and tsc_add_entropy() are basically identical. It
seems there should be a generic bit of code that uses the clocksource's
read() function and does the same calculation.

2) If the .entropy() functions really aren't clocksource specific, it
doesn't really seem like this functionality belongs in the clocksource
layer. Instead it seems it should be a layer above, that makes use of
the clocksource code in a generic fashion.

3) Why are you making use of the curr_clocksource? The timekeeping code
has very strict rules about what makes a clocksource usable for
timekeeping. I suspect entropy generation has different requirements,
and thus shouldn't lean on the curr_clocksource value (ie: TSC may be
unsynced or halts in idle, and thus unusable for time, but likely still
ok for entropy).

4) Further on that point, there's a likely bug: If an entropy supporting
clocksource is available,  clocksource_entropy_available() will return
true, but if the one curr_clocksource is not the one that supports
entropy, clocksource_add_entropy() won't do anything. I suspect the
add_entropy function needs to scan for a entropy flagged clocksource and
use it instead. 

5) Does the entropy calculation need to be flagged clocksource by
clocksource? Or could a generic metric be made (ie: frequency?) in order
to enable such functionality on all capable clocksources automatically?


thanks
-john

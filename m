From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Tue, 14 Jun 2011 11:18:20 -0400
Message-ID: <4DF77BBC.8090702@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com> <1308006912.15617.67.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab1FNPTB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 11:19:01 -0400
In-Reply-To: <1308006912.15617.67.camel@calx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Matt Mackall wrote:
> On Mon, 2011-06-13 at 18:06 -0400, Jarod Wilson wrote:
>> Many server systems are seriously lacking in sources of entropy,
>> as we typically only feed the entropy pool by way of input layer
>> events, a few NIC driver interrupts and disk activity. A non-busy
>> server can easily become entropy-starved. We can mitigate this
>> somewhat by periodically mixing in entropy data based on the
>> delta between multiple high-resolution clocksource reads, per:
>>
>>    https://www.osadl.org/Analysis-of-inherent-randomness-of-the-L.rtlws11-developers-okech.0.html
>>
>> Additionally, NIST already approves of similar implementations, so
>> this should be usable in high-securtiy deployments requiring a
>> fair chunk of available entropy data for frequent use of /dev/random.
>
> So, mixed feelings here:
>
> Yes: it's a great idea to regularly mix other data into the pool. More
> samples are always better for RNG quality.
>
> Maybe: the current RNG is not really designed with high-bandwidth
> entropy sources in mind, so this might introduce non-negligible overhead
> in systems with, for instance, huge numbers of CPUs.

The current implementation is opt-in, and single-threaded, so at least 
currently, I don't think there should be any significant issues. But 
yeah, there's nothing currently in the implementation preventing a 
variant that is per-cpu, which could certainly lead to some scalability 
issues.

> No: it's not a great idea to _credit_ the entropy count with this data.
> Someone watching the TSC or HPET from userspace can guess when samples
> are added by watching for drop-outs in their sampling (ie classic timing
> attack).

I'm admittedly a bit of a novice in this area... Why does it matter if 
someone watching knows more or less when a sample is added? It doesn't 
really reveal anything about the sample itself, if we're using a 
high-granularity counter value's low bits -- round-trip to userspace has 
all sorts of inherent timing jitter, so determining the low-order bits 
the kernel got by monitoring from userspace should be more or less 
impossible. And the pool is constantly changing, making it a less static 
target on an otherwise mostly idle system.

> (I see you do credit only 1 bit per byte: that's fairly conservative,
> true, but it must be _perfectly conservative_ for the theoretical
> requirements of /dev/random to be met. These requirements are in fact
> known to be unfulfillable in practice(!), but that doesn't mean we
> should introduce more users of entropy accounting. Instead, it means
> that entropy accounting is broken and needs to be removed.)

Hrm. The government seems to have a different opinion. Various certs 
have requirements for some sort of entropy accounting and minimum 
estimated entropy guarantees. We can certainly be even more conservative 
than 1 bit per byte, but yeah, I don't really have a good answer for 
perfectly conservative, and I don't know what might result (on the 
government cert front) from removing entropy accounting altogether...

Any thoughts on the idea of mixing clocksource bits with reads from 
ansi_cprng? We could mix in more bytes while still only crediting one 
bit, and periodically reseed ansi_cprng from the clocksource, or 
something along those lines... This may be entirely orthogonal to the 
timing attack issue you're talking about though. :)

-- 
Jarod Wilson
jarod@redhat.com

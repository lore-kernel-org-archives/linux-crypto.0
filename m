From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Tue, 14 Jun 2011 16:17:17 -0400
Message-ID: <4DF7C1CD.4060504@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	 <1308006912.15617.67.camel@calx>  <4DF77BBC.8090702@redhat.com> <1308071629.15617.127.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Steve Grubb <sgrubb@redhat.com>
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab1FNURq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 16:17:46 -0400
In-Reply-To: <1308071629.15617.127.camel@calx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Matt Mackall wrote:
> On Tue, 2011-06-14 at 11:18 -0400, Jarod Wilson wrote:
>> Matt Mackall wrote:
...
>>> No: it's not a great idea to _credit_ the entropy count with this data.
>>> Someone watching the TSC or HPET from userspace can guess when samples
>>> are added by watching for drop-outs in their sampling (ie classic timing
>>> attack).
>> I'm admittedly a bit of a novice in this area... Why does it matter if
>> someone watching knows more or less when a sample is added? It doesn't
>> really reveal anything about the sample itself, if we're using a
>> high-granularity counter value's low bits -- round-trip to userspace has
>> all sorts of inherent timing jitter, so determining the low-order bits
>> the kernel got by monitoring from userspace should be more or less
>> impossible. And the pool is constantly changing, making it a less static
>> target on an otherwise mostly idle system.
>
> I recommend you do some Google searches for "ssl timing attack" and "aes
> timing attack" to get a feel for the kind of seemingly impossible things
> that can be done and thereby recalibrate your scale of the impossible.

Hm. These are attempting to reveal a static key though. We're talking 
about trying to reveal the exact value of the counter when it was read 
by the kernel. And trying to do so repeatedly, several times per second. 
And this can't be done without getting some form of local system access, 
so far as I know. And the act of trying to monitor and calculate deltas 
should serve to introduce even more potential randomness into the actual 
clock read deltas.

This code is largely spurned on by someone here at Red Hat who I 
probably should have had in the cc list to begin with, Steve Grubb, who 
pointed to slides 23-25 and the chart in slide 30 of this doc...

https://www.osadl.org/fileadmin/dam/presentations/RTLWS11/okech-inherent-randomness.pdf

...as the primary arguments for why this is a good source of entropy.


>>> (I see you do credit only 1 bit per byte: that's fairly conservative,
>>> true, but it must be _perfectly conservative_ for the theoretical
>>> requirements of /dev/random to be met. These requirements are in fact
>>> known to be unfulfillable in practice(!), but that doesn't mean we
>>> should introduce more users of entropy accounting. Instead, it means
>>> that entropy accounting is broken and needs to be removed.)
>> Hrm. The government seems to have a different opinion. Various certs
>> have requirements for some sort of entropy accounting and minimum
>> estimated entropy guarantees. We can certainly be even more conservative
>> than 1 bit per byte, but yeah, I don't really have a good answer for
>> perfectly conservative, and I don't know what might result (on the
>> government cert front) from removing entropy accounting altogether...
>
> Well, the deal with accounting is this: if you earn $.90 and spend $1.00
> every day, you'll eventually go broke, even if your
> rounded-to-the-nearest-dollar accounting tells you you're solidly in the
> black.
>
> The only distinction between /dev/random and urandom is that we claim
> that /dev/random is always solidly in the black. But as we don't have a
> firm theoretical basis for making our accounting estimates on the input
> side, the whole accounting thing kind of breaks down into a kind of
> busted rate-limiter.

Well, they *are* understood to be estimates, and /dev/random does block 
when we've spent everything we've (estimated we've) got, and at least 
circa 2.6.18 in RHEL5.4, NIST was satisfied that /dev/random's 
estimation was "good enough" by way of some statistical analysis done on 
data dumped out of it. What if we could show through statistical 
analysis that our entropy estimation is still good enough even with 
clock data mixed in? (Ignoring the potential of timing attacks for the 
moment).


> We'd do better counting a raw number of samples per source, and then
> claiming that we've reached a 'full' state when we reach a certain
> 'diversity x depth' score. And then assuring we have a lot of diversity
> and depth going into the pool.

Hrm. I presume NIST and friends would still need some way to translate 
that into estimated bits of entropy for the purposes of having a common 
metric with other systems, but I guess we could feel better about the 
entropy if we had some sort of guarantee that no more than x% came from 
a single entropy source -- such as, say, no more than 25% of your 
entropy bits are from a clocksource. But then we may end up right back 
where we are right now -- a blocking entropy-starved /dev/random on a 
server system that has no other significant sources generating entropy.

-- 
Jarod Wilson
jarod@redhat.com

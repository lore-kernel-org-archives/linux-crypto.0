From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Wed, 15 Jun 2011 10:49:39 -0400
Message-ID: <4DF8C683.8040709@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	 <1308006912.15617.67.camel@calx>  <4DF77BBC.8090702@redhat.com>	 <1308071629.15617.127.camel@calx>  <4DF7C1CD.4060504@redhat.com>	 <1308087902.15617.208.camel@calx>  <4DF7E5FB.3080907@redhat.com> <1308093142.15617.233.camel@calx>
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
Received: from mx1.redhat.com ([209.132.183.28]:29947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab1FOOuY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2011 10:50:24 -0400
In-Reply-To: <1308093142.15617.233.camel@calx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Matt Mackall wrote:
> On Tue, 2011-06-14 at 18:51 -0400, Jarod Wilson wrote:
>> Matt Mackall wrote:
...
>>> But that's not even the point. Entropy accounting here is about
>>> providing a theoretical level of security above "cryptographically
>>> strong". As the source says:
>>>
>>> "Even if it is possible to  analyze SHA in some clever way, as long as
>>> the amount of data returned from the generator is less than the inherent
>>> entropy in the pool, the output data is totally unpredictable."
>>>
>>> This is the goal of the code as it exists. And that goal depends on
>>> consistent _underestimates_ and accurate accounting.
>> Okay, so as you noted, I was only crediting one bit of entropy per byte
>> mixed in. Would there be some higher mixed-to-credited ratio that might
>> be sufficient to meet the goal?
>
> As I've mentioned elsewhere, I think something around .08 bits per
> timestamp is probably a good target. That's the entropy content of a
> coin-flip that is biased to flip heads 99 times out of 100. But even
> that isn't good enough in the face of a 100Hz clock source.
>
> And obviously the current system doesn't handle fractional bits at all.

What if only one bit every n samples were credited? So 1/n bits per 
timestamp, effectively, and for an n of 100, that would yield .01 bits 
per timestamp. Something like this:

void add_clocksource_randomness(int clock_delta)
{
         static int samples;
         /* only mix in the low byte */
         u8 mix = clock_delta & 0xff;

         DEBUG_ENT("clock event %u\n", mix);

         preempt_disable();
         if (input_pool.entropy_count > trickle_thresh &&
             (__get_cpu_var(trickle_count)++ & 0xfff))
                 goto out;

         mix_pool_bytes(&input_pool, &mix, sizeof(mix));
         samples++;
         /* Only credit one bit per 100 samples to be conservative */
         if (samples == 100) {
                 credit_entropy_bits(&input_pool, sizeof(mix));
                 samples = 0;
         }

out:
         preempt_enable();
}


Additionally, this function would NOT be exported, it would only be 
utilized by a new clocksource entropy contribution function in 
kernel/time/clocksource.c. Locally, I've made most of the changes as 
discussed with John, so clocksources now have an entropy rating rather 
than an entropy function, and if the rating is not high enough, the 
clocksource won't be able to add entropy -- all clocksources default to 
a rating of 0, only hpet and tsc have been marked otherwise.

Additionally, hpet has a higher rating than tsc, so it'll be preferred 
over tsc, even if tsc is the system timer clocksource. This code will 
effectively do absolutely nothing if not running on x86 PC hardware with 
an hpet or tsc (and it seems maybe tsc shouldn't even be considered, so 
perhaps this should be hpet-only).

One further thought: what if reads of both the hpet and tsc were mixed 
together to form the sample value actually fed into the entropy pool? 
This of course assumes the system has both available, and that the tsc 
is actually fine-grained enough to be usable, but maybe it strengthens 
the randomness of the sample value at least somewhat?

This could also be marked as experimental or dangerous or what have you, 
so that its a kernel builder's conscious decision to enable clock-based 
entropy contributions.

(If I appear to be grasping at straws here, well, I probably am.) ;)

>>> Look, I understand what I'm trying to say here is very confusing, so
>>> please make an effort to understand all the pieces together:
>>>
>>> - the driver is designed for -perfect- security as described above
>>> - the usual assumptions about observability of network samples and other
>>> timestamps ARE FALSE on COMMON NON-PC HARDWARE
>>> - thus network sampling is incompatible with the CURRENT design
>>> - nonetheless, the current design of entropy accounting is not actually
>>> meeting its goals in practice
>> Heh, I guess that answers my question already...
>>
>>> - thus we need an alternative to entropy accounting
>>> - that alternative WILL be compatible with sampling insecure sources
>> Okay. So I admit to really only considering and/or caring about x86
>> hardware, which doesn't seem to have helped my cause. But you do seem to
>> be saying that clocksource-based sampling *will* be compatible with the
>> new alternative, correct? And is said alternative something on the
>> relatively near-term radar?
>
> Various people have offered to spend some time fixing this; I haven't
> had time to look at it for a while.

Okay, I know how that goes. So not likely to come to fruition in the 
immediate near-term. I'd offer to spend some time working on it, but I 
don't think I'm qualified. :)

-- 
Jarod Wilson
jarod@redhat.com

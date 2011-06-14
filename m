From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Tue, 14 Jun 2011 10:25:21 -0400
Message-ID: <4DF76F51.2040002@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com> <1308004725.2893.20.camel@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>
To: john stultz <johnstul@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab1FNOZm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 10:25:42 -0400
In-Reply-To: <1308004725.2893.20.camel@work-vm>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

john stultz wrote:
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
>>
>> http://csrc.nist.gov/groups/STM/cmvp/documents/140-1/140sp/140sp750.pdf
>> (section 6.1 mentions a clock-based seed source).
>>
>> Yes, thus far, I've only bothered with x86-based clocksources, since that
>> is what I can test most easily. If this patch series isn't deemed totally
>> insane, adding support for other clocksources should be trivial.
>>
>> Also note that unless you explicitly build and load the clock-entropy
>> driver, there should be little or no change whatsoever to the way anything
>> behaves right now, its purely opt-in. There's probably room for some
>> improvement here, and I'm kind of outside my comfort area, but hey, it
>> seems to work pretty well here in my own testing, so here it is...
>>
>> Jarod Wilson (5):
>>    random: add new clocksource entropy interface
>>    clocksource: add support for entropy-generation function
>>    hpet: wire up entropy generation function
>>    tsc: wire up entropy generation function
>>    misc: add clocksource-based entropy generation driver
>
> So this is interesting work, but I have a few questions.
>
> 1) hpet_add_entropy() and tsc_add_entropy() are basically identical. It
> seems there should be a generic bit of code that uses the clocksource's
> read() function and does the same calculation.
>
> 2) If the .entropy() functions really aren't clocksource specific, it
> doesn't really seem like this functionality belongs in the clocksource
> layer. Instead it seems it should be a layer above, that makes use of
> the clocksource code in a generic fashion.

Wasn't sure at first if there might be a need for more differentiation 
in the entropy-gathering functions, but yeah, at least with these two, 
just using the clocksource read function from a common entropy-gathering 
function does look to make more sense.


> 3) Why are you making use of the curr_clocksource? The timekeeping code
> has very strict rules about what makes a clocksource usable for
> timekeeping. I suspect entropy generation has different requirements,
> and thus shouldn't lean on the curr_clocksource value (ie: TSC may be
> unsynced or halts in idle, and thus unusable for time, but likely still
> ok for entropy).
>
> 4) Further on that point, there's a likely bug: If an entropy supporting
> clocksource is available,  clocksource_entropy_available() will return
> true, but if the one curr_clocksource is not the one that supports
> entropy, clocksource_add_entropy() won't do anything. I suspect the
> add_entropy function needs to scan for a entropy flagged clocksource and
> use it instead.

Yeah, there are definitely different requirements. Using 
curr_clocksource was sort of the easy way out, I guess. :) So yeah, its 
entirely possible for someone to set a non-entropy-generating 
clocksource as their active one, and still have an entropy-generating 
one that is available -- I was actually running tsc as my primary 
clocksource and using the hpet for entropy in my initial internal 
implementation here.

Each clocksource currently has a rating for how good a timekeeping 
clocksource it is, would it make sense to have a second rating that 
indicates how good an entropy source it is, and use that to determine 
which clocksource would best serve for entropy generation?


> 5) Does the entropy calculation need to be flagged clocksource by
> clocksource? Or could a generic metric be made (ie: frequency?) in order
> to enable such functionality on all capable clocksources automatically?

I honestly haven't a clue here. I'm not sure if there are possibly 
clocksources that have a relatively high frequency, but lack precision 
in their lowest bits, nor am I sure (yet?) how to figure out what the 
frequency and/or precision of a given clocksource actually is. I guess I 
assume its non-trivial, since we have to have the 'rating' value to 
choose primary timekeeping clocksource.

My initial thinking is that it would be best to have this purely opt-in, 
for clocksources that have been evaluated and deemed acceptable for this 
use.

So I'll see what I can come up with in the way of removing the 
per-clocksource entropy functions. Doing so adds a new complication, by 
way of removing what I was keying off of to decide if the clocksource 
should be providing entropy, but perhaps I can try working in an entropy 
quality rating at the same time.

-- 
Jarod Wilson
jarod@redhat.com

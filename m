From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Fri, 17 Jun 2011 14:51:31 -0400
Message-ID: <4DFBA233.7060407@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	 <1308006912.15617.67.camel@calx>  <4DF77BBC.8090702@redhat.com>	 <1308071629.15617.127.camel@calx>  <4DF7C1CD.4060504@redhat.com>	 <1308087902.15617.208.camel@calx>  <4DF7E5FB.3080907@redhat.com>	 <1308093142.15617.233.camel@calx>  <4DF8C683.8040709@redhat.com> <1308168403.15617.368.camel@calx>
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
Received: from mx1.redhat.com ([209.132.183.28]:5712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab1FQSwN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2011 14:52:13 -0400
In-Reply-To: <1308168403.15617.368.camel@calx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Matt Mackall wrote:
> On Wed, 2011-06-15 at 10:49 -0400, Jarod Wilson wrote:
>> Matt Mackall wrote:
>>> On Tue, 2011-06-14 at 18:51 -0400, Jarod Wilson wrote:
>>>> Matt Mackall wrote:
>> ...
>>>>> But that's not even the point. Entropy accounting here is about
>>>>> providing a theoretical level of security above "cryptographically
>>>>> strong". As the source says:
>>>>>
>>>>> "Even if it is possible to  analyze SHA in some clever way, as long as
>>>>> the amount of data returned from the generator is less than the inherent
>>>>> entropy in the pool, the output data is totally unpredictable."
>>>>>
>>>>> This is the goal of the code as it exists. And that goal depends on
>>>>> consistent _underestimates_ and accurate accounting.
>>>> Okay, so as you noted, I was only crediting one bit of entropy per byte
>>>> mixed in. Would there be some higher mixed-to-credited ratio that might
>>>> be sufficient to meet the goal?
>>> As I've mentioned elsewhere, I think something around .08 bits per
>>> timestamp is probably a good target. That's the entropy content of a
>>> coin-flip that is biased to flip heads 99 times out of 100. But even
>>> that isn't good enough in the face of a 100Hz clock source.
>>>
>>> And obviously the current system doesn't handle fractional bits at all.
>> What if only one bit every n samples were credited? So 1/n bits per
>> timestamp, effectively, and for an n of 100, that would yield .01 bits
>> per timestamp. Something like this:
>
> Something like that would "work", sure. But it's a hack/abuse -relative
> to the current framework-. I'm reluctant to just pile on the hacks on
> the current system, as that just means getting it coherent is that much
> further away.

Something I should have probably made clearer was that we were looking 
for a semi-quick improvement for a particular use case that involves a 
certain 2.6.32-based kernel... For the short term, we're looking at some 
userspace alternatives, such as a Linux implementation of an entropy 
seed approach BSI approves of. Reference doc here, but in German:

https://www.bsi.bund.de/ContentBSI/Publikationen/TechnischeRichtlinien/tr02102/index_htm.html

Longer-term, we're having some discussions related to the revamped 
framework you've laid out. I'll table this clocksource-based entropy 
contribution code for now.

Also, thank you for putting up with me. ;)

-- 
Jarod Wilson
jarod@redhat.com

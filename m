From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC HIFN 00/02]: RNG support
Date: Sun, 18 Nov 2007 04:30:40 +0100
Message-ID: <473FB1E0.600@trash.net>
References: <20071117192949.19399.75523.sendpatchset@localhost.localdomain> <20071117195324.GA4010@2ka.mipt.ru> <20071118031402.GA25388@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57287 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbXKRDan (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Nov 2007 22:30:43 -0500
In-Reply-To: <20071118031402.GA25388@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu wrote:
> On Sat, Nov 17, 2007 at 07:53:25PM +0000, Evgeniy Polyakov wrote:
>   
>>> The second patch adds hw_random support. The ugly part is finding out
>>> when to allow reads from the RNG. It currently translates the public
>>> key engine clock cycles to CPU cycles based on a 4GHz CPU and uses
>>> get_cycles(). The problems with this are obvious, it only works on CPUs
>>> that actually have some kind of cycle counter, has problems with
>>> unsynchronized TSCs and the 4GHz assumption is not very nice either,
>>> but I was reluctant to use ktime for this since it seems rather
>>> expensive to call ktime_get once per 4 bytes of random. Suggestion
>>> for improvement of this are also welcome :)
>>>       
>> It will not work on arm, but I'm not sure this is relevant...
>> Another option is to directly access xtime without all wrappers in the
>> ktime_get().
>>     
>
> Is it really that bad? You're most likely going to be spinning
> for 10us in udelay() or worse busy-looping anyway so I'm not sure
> if we need to worry about that overhead too much.
>   

Thats a good point, the busy-waiting makes any overhead pretty
much irrelevant (10us is most like much more than ktime_get())
so I'm going to try using ktime_get. xtime doesn't seem suitable
since its only updated on timer interrupts.

On a related issue, I think the rng interface is not very suitable
for chips like HIFN that have a constant random bandwidth, it would
make a lot more sense to return the time to wait to the core, instead
of waiting 10us in all cases. 256 cycles at a speed of 266MHz comes
down to 0.96us, so we're waiting about 10 times as long as necessary.
Since its busy waiting anyway, I'd think that from a performance POV
constant polling or returning the exact amount of time would be more
reasonable.
>
> Otherwise these patches look pretty nice to me.  Thanks Patrick!

Fresh patches coming up tommorrow :)

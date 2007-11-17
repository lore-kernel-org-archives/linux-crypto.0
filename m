From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC HIFN 00/02]: RNG support
Date: Sat, 17 Nov 2007 21:04:27 +0100
Message-ID: <473F494B.3000503@trash.net>
References: <20071117192949.19399.75523.sendpatchset@localhost.localdomain> <20071117195324.GA4010@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48975 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879AbXKQUEs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Nov 2007 15:04:48 -0500
In-Reply-To: <20071117195324.GA4010@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Evgeniy Polyakov wrote:
> On Sat, Nov 17, 2007 at 08:30:09PM +0100, Patrick McHardy (kaber@trash.net) wrote:
> 
>> The second patch adds hw_random support. The ugly part is finding out
>> when to allow reads from the RNG. It currently translates the public
>> key engine clock cycles to CPU cycles based on a 4GHz CPU and uses
>> get_cycles(). The problems with this are obvious, it only works on CPUs
>> that actually have some kind of cycle counter, has problems with
>> unsynchronized TSCs and the 4GHz assumption is not very nice either,
>> but I was reluctant to use ktime for this since it seems rather
>> expensive to call ktime_get once per 4 bytes of random. Suggestion
>> for improvement of this are also welcome :)
> 
> It will not work on arm, but I'm not sure this is relevant...
> Another option is to directly access xtime without all wrappers in the
> ktime_get().


I'll look into that, thanks.

>> Running rngtest on the random number generator indicates that it works
>> properly, with an average failure ratio of about 1:1000 at ~2.5mbit.
>>
>>
>>  drivers/crypto/hifn_795x.c |  158 +++++++++++++++++++++++++++++++++++++++++++-
>>  1 files changed, 156 insertions(+), 2 deletions(-)
>>
>> Patrick McHardy (2):
>>       [HIFN]: Improve PLL initialization
>>       [HIFN]: Add support for using the random number generator
> 
> Ack both patches.


Just in case, they shouldn't be applied yet, I forgot one minor bit
when splitting them (discarding the first value read from the RNG).

The PLL initialization also doesn't seem to follow the specified way
from the documentation, I want to have another look at this.

From: Patrick McHardy <kaber@trash.net>
Subject: Re: hifn_795x in Linux-2.6.27-rc7
Date: Wed, 24 Sep 2008 19:13:36 +0200
Message-ID: <48DA7540.8030102@trash.net>
References: <48D7D84B.9020507@psycast.de> <20080923165521.GA26513@2ka.mipt.ru> <48D93028.20903@psycast.de> <48DA6D7D.80705@trash.net> <20080924170032.GA5190@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dimitri Puzin <max@psycast.de>, linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42807 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYIXROC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Sep 2008 13:14:02 -0400
In-Reply-To: <20080924170032.GA5190@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Evgeniy Polyakov wrote:
> Hi Patrick.
>
> On Wed, Sep 24, 2008 at 06:40:29PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>
>    [HIFN]: Fix DMA setup
>
> without a changelog :) IIRC the problem is that HIFN sets up each
> DMA descriptor for the full request length, even though it should
> only cover on SG entry. The result is memory corruption.
>   
>
> Can not tell without patch itself, but code operates on the number of
> bytes provided from the higher levels, not full dma size (0x3ff bytes).
>   

Yes, but it uses that size for every descriptor.

I'm going to send you the patches in private (they're quite large)
so you can have a look.

>   
>>    [HIFN]: Don't copy src sg list
>>
>> also without a changelog. I think this one was just an optimization,
>> the source descriptors don't have alignment or size restrictions and
>> thus we don't need to linearize it first.
>>     
>
> Also can not say for sure, but there should not be src linearization,
> instead we copy data from src to aligned dst and then perform crypto
> processin in place, and then copy data back.
>   

Right, I remember. The copying to the (temporary) destination area
is not necessary, the chip can just read it from the source are directly.


>   
>>    [HIFN]: Fix request context corruption
>>   
>>    HIFN uses the transform context to store per-request data, which breaks
>>    when more than one request is outstanding. Move per request members from
>>    struct hifn_context to a new struct hifn_request_context and convert
>>    the code to use this.
>>     
>
> Its per-tfm, so things like key and iv are ok, and others should only be
> accessed under the lock, but there may be problems.
>   

Things like op, mode, ... are per request and are set without any
locking.

>> If someone is interested in picking this up I could send my old patches,
>> I probably won't manage to do it myself in the next time.
>>     
>
> Please do, if they work for you, we can just apply them, but I would
> like first to check them out.

I'm not sure whether they're ready for applying. IIRC I still got stalls 
occasionally,
but I don't remember the details. They made things better for me though :)

Anyways, patches coming up in a minute.

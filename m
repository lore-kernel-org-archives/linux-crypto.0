From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: AF_ALG AIO - lock context IV
Date: Thu, 1 Feb 2018 12:06:30 +0200
Message-ID: <CAOtvUMeLGRS-NJvf7R_J5bX1CB77htasZO0wKCU4uXeNE93Ttw@mail.gmail.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <20180131122956.000061a3@huawei.com>
 <CAOtvUMd=T8WkeMRhcF6PzDerzBsszBOCp9x=DpCjQMtLxgTPvg@mail.gmail.com> <1794487.2xX5c1mbjk@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:39698 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbeBAKGb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 05:06:31 -0500
Received: by mail-ua0-f171.google.com with SMTP id e18so11456558ual.6
        for <linux-crypto@vger.kernel.org>; Thu, 01 Feb 2018 02:06:31 -0800 (PST)
In-Reply-To: <1794487.2xX5c1mbjk@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 1, 2018 at 11:46 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Donnerstag, 1. Februar 2018, 10:35:07 CET schrieb Gilad Ben-Yossef:
>
> Hi Gilad,
>
>> Hi,
>>
<snip>
>> >
>> > Quoting a private email from Stephan (at Stephan's suggestion)
>> >
>> >> What I however could fathom is that we introduce a flag where a driver
>> >> implements its own queuing mechanism. In this case, the mutex handling
>> >> would be disregarded.
>> >
>> > Which works well for the sort of optimization I did and for hardware that
>> > can do iv dependency tracking itself. If hardware dependency tracking was
>> > avilable, you would be able to queue up requests with a chained IV
>> > without taking any special precautions at all. The hardware would
>> > handle the IV update dependencies.
>> >
>> > So in conclusion, Stephan's approach should work and give us a nice
>> > small patch suitable for stable inclusion.
>> >
>> > However, if people know that their setup overhead can be put in parallel
>> > with previous requests (even when the IV is not yet updated) then they
>> > will
>> > probably want to do something inside their own driver and set the flag
>> > that Stephan is proposing adding to bypass the mutex approach.
>>
>> The patches from Stephan looks good to me, but I think we can do better
>> for the long term approach you are discussing.
>>
>> Consider that the issue we are dealing with is in no way unique to the
>> AF_ALG use case, it just happens to expose it.
>>
>> The grander issue is, I believe, that we are missing an API for chained
>> crypto operations. One that allows submitting multiple concurrent but
>> dependent requests
>> to tfm providers.
>>
>> Trying to second guess whether or not there is a dependency between calls
>> from the address of the IV is not a clean solution. Why don't we make it
>> explicit?
>>
>> For example, a flag that can be set on a tfm that states that the subsequent
>> series of requests are interdependent. If you need a different stream,
>> simply allocated anotehr
>> tfm object.
>
> But this is already implemented, is it not considering the discussed patches?
>
> Again, here are the use cases I see for AIO:
>
> - multiple IOCBs which are totally separate and have no interdependencies: the
> inline IV approach
>
> - multiple IOCBs which are interdependent: the current API with the patches
> that we are discussing here (note, a new patch set is coming after the merge
> window)
>
> - if you have several independent invocations of multiple interdependent
> IOCBs: call accept() again on the TFM-FD to get another operations FD. This is
> followed either option one or two above. Note, this is the idea behind the
> kcapi_handle_reinit() call just added to libkcapi. So, you have multiple
> operation-FDs on which you do either interdependent operation or inline IV
> handling.
>>
>> This will let each driver do it's best, be it a simple mutex, software
>> queuing or hardware
>> dependency tracking as the case m may be.
>
> Again, I am wondering that with the discussed patch set we have this
> functionality already.
>>
>> Than of course, AF_ALG code (or any other user for that matter) will
>> not need to handle
>> interdependence, just set the right flag.
>
> The issue is that some drivers simply do not handle this interdependency at
> all -- see the bug report from Harsh.
>
> Thus, the current patch set (again which will be updated after the merge
> window) contains:
>
> 1. adding a mutex to AF_ALG to ensure serialization of interdependent calls
> (option 2 from above) irrespective whether the driver implements support for
> it or not.
>
> 2. add the inline IV handling (to serve option 1)
>
> 3. add a flag that can be set by the crypto implementation. If this flag is
> set, then the mutex of AF_ALG is *not* set assuming that the crypto driver
> handles the serialization.
>
> Note, option 3 from above is implemented in the proper usage of the AF_ALG
> interface.

Sorry for not communicating clearly enough. I was not objecting at
all. Let me try again.

What I was trying to say is, more succinctly hopefully this time:

1. Advocating for that 3rd option. I did not understand the plan
include adding it,

2. Pointing out that the problem solved (and rightfully so) by mutex in AF_ALG
AIO implementation must exists elsewhere as well - for example IPsec, and is
probably solved there too, so if we add the flag as suggested, it can be used
there as well to gain similar benefits to what Jonathan is suggesting.

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

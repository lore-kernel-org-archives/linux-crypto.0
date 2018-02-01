From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: AF_ALG AIO - lock context IV
Date: Thu, 1 Feb 2018 12:07:21 +0200
Message-ID: <CAOtvUMe8gqBJtFjkO-Jssw1Q32GdR0oZNPRitt81skKO2f_+yg@mail.gmail.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <20180131122956.000061a3@huawei.com>
 <CAOtvUMd=T8WkeMRhcF6PzDerzBsszBOCp9x=DpCjQMtLxgTPvg@mail.gmail.com> <2665140.KarSQuFonJ@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:42572 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbeBAKHX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 05:07:23 -0500
Received: by mail-vk0-f67.google.com with SMTP id t4so10902244vkb.9
        for <linux-crypto@vger.kernel.org>; Thu, 01 Feb 2018 02:07:22 -0800 (PST)
In-Reply-To: <2665140.KarSQuFonJ@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 1, 2018 at 12:04 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Donnerstag, 1. Februar 2018, 10:35:07 CET schrieb Gilad Ben-Yossef:
>
> Hi Gilad,
>
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
>
> What you made me think of is the following: shouldn't we relay the inline IV
> flag on to the crypto drivers?
>
> The reason is to allow a clean implementation of the enabling or disabling of
> the dependency handling in the driver. Jonathan's driver, for example, decides
> based on the pointer value of the IV buffer whether it is the same buffer and
> thus dependency handling is to be applied. This is fragile.
>
> As AF_ALG knows whether the inline IV with separate IVs per request or the
> serialization with one IV buffer for all requests is requested, it should
> relay this state on to the drivers. Thus, for example, Jonathan's driver can
> be changed to rely on this flag instead on the buffer pointer value to decide
> whether to enable its dependency handling.

Yes, that is exactly what I was trying to point out :-)

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

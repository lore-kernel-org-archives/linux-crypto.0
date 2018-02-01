From: Harsh Jain <harsh@chelsio.com>
Subject: Re: [PATCH] crypto: AF_ALG AIO - lock context IV
Date: Thu, 1 Feb 2018 16:25:59 +0530
Message-ID: <328bf21a-cba6-4ee6-8367-952124b1b523@chelsio.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
 <20180131122956.000061a3@huawei.com>
 <CAOtvUMd=T8WkeMRhcF6PzDerzBsszBOCp9x=DpCjQMtLxgTPvg@mail.gmail.com>
 <2665140.KarSQuFonJ@tauon.chronox.de>
 <CAOtvUMe8gqBJtFjkO-Jssw1Q32GdR0oZNPRitt81skKO2f_+yg@mail.gmail.com>
 <20180201102519.000044c1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:65352 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbeBAK4X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 05:56:23 -0500
In-Reply-To: <20180201102519.000044c1@huawei.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 01-02-2018 15:55, Jonathan Cameron wrote:
> On Thu, 1 Feb 2018 12:07:21 +0200
> Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
>> On Thu, Feb 1, 2018 at 12:04 PM, Stephan Mueller <smueller@chronox.de> wrote:
>>> Am Donnerstag, 1. Februar 2018, 10:35:07 CET schrieb Gilad Ben-Yossef:
>>>
>>> Hi Gilad,
>>>  
>>>>> Which works well for the sort of optimization I did and for hardware that
>>>>> can do iv dependency tracking itself. If hardware dependency tracking was
>>>>> avilable, you would be able to queue up requests with a chained IV
>>>>> without taking any special precautions at all. The hardware would
>>>>> handle the IV update dependencies.
>>>>>
>>>>> So in conclusion, Stephan's approach should work and give us a nice
>>>>> small patch suitable for stable inclusion.
>>>>>
>>>>> However, if people know that their setup overhead can be put in parallel
>>>>> with previous requests (even when the IV is not yet updated) then they
>>>>> will
>>>>> probably want to do something inside their own driver and set the flag
>>>>> that Stephan is proposing adding to bypass the mutex approach.  
>>>> The patches from Stephan looks good to me, but I think we can do better
>>>> for the long term approach you are discussing.  
>>> What you made me think of is the following: shouldn't we relay the inline IV
>>> flag on to the crypto drivers?
>>>
>>> The reason is to allow a clean implementation of the enabling or disabling of
>>> the dependency handling in the driver. Jonathan's driver, for example, decides
>>> based on the pointer value of the IV buffer whether it is the same buffer and
>>> thus dependency handling is to be applied. This is fragile.
> I agree it's inelegant and a flag would be better than pointer tricks (though
> they are safe currently - we never know what might change in future)
> It was really a minimal example rather than a suggestion of the ultimate
> solution ;)  I was planning on suggesting a flag myself once the basic
> discussion concluded the approach was worthwhile.
>
>>> As AF_ALG knows whether the inline IV with separate IVs per request or the
>>> serialization with one IV buffer for all requests is requested, it should
>>> relay this state on to the drivers. Thus, for example, Jonathan's driver can
>>> be changed to rely on this flag instead on the buffer pointer value to decide
>>> whether to enable its dependency handling.  
>> Yes, that is exactly what I was trying to point out :-)
> Agreed - make things explicit rather than basically relying on knowing how
> the above layers are working.
IPSec layer may not get benefit from this because they send complete sg list in single request only. They don't need partial mode support.
>
> Thanks,
>
> Jonathan
>

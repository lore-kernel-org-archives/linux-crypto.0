From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: crypto_shash_update & CRYPTO_TFM_REQ_MAY_SLEEP
Date: Mon, 15 Feb 2010 21:20:35 +0200
Message-ID: <4B799E83.5000700@nokia.com>
References: <20100209074146.GA17681@gondor.apana.org.au> <4B72A3A4.4050700@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:43003 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab0BOTUz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Feb 2010 14:20:55 -0500
In-Reply-To: <4B72A3A4.4050700@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Alg code and drivers uses req/desc->flags to use GFP_KERNEL or GFP_ATOMIC.

crypto_kmap() -> Does not it make a sense to also use kmap/kmap_atomic
instead of just kmap_atomic()?

-----------------------------------
static inline void *crypto_kmap(struct page *page, int out)
{
    return kmap_atomic(page, crypto_kmap_type(out));
}
-------------------------------------------------

It is now not only about sync but also async code.
Would be nice to "wait" for hash completion in some cases...

What do you think?
What is the reason to have only kmap_atomic()?

- Dmitry


Kasatkin Dmitry (Nokia-D/Helsinki) wrote:
> Hi,
>
> Anyway, crypto driver is called with CRYPTO_TFM_REQ_MAY_SLEEP flag set.
> It basically mean it can sleep.
> But it is not because of kmap_atomic()
>
> So no possibility to know if to use GFP_KERNEL or GFP_ATOMIC.
>
> I guess that is not correct way.
>
> If driver cannot sleep then CRYPTO_TFM_REQ_MAY_SLEEP should not be set
> when calling it.
>
> Even sync implementation might use HW and sleep a bit while HW is doing
> calculation...
>
>
> - Dmitry
>
> ext Herbert Xu wrote:
>   
>> Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
>>   
>>     
>>> One interesting issue
>>>
>>> Many clients in the kernel set CRYPTO_TFM_REQ_MAY_SLEEP to desc.flags.
>>> It is used by crypto_yeld().
>>>     
>>>       
>> That flag is really only meaningful for synchronous implementations.
>>
>> For hardware crypto that is asynchronous, you can simply ignore it
>> in most cases (exceptions include invoking a syncrhonous backup, for
>> example).
>>
>> Cheers,
>>   
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

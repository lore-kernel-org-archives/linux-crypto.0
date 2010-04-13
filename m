From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 17:36:40 +0300
Message-ID: <4BC48178.4020104@nokia.com>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC44446.2010405@nokia.com> <20100413121004.GB10822@gondor.apana.org.au> <4BC47543.1020508@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51040 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0DMOhG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 10:37:06 -0400
In-Reply-To: <4BC47543.1020508@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Also one more question.

can reqa and reqb could come from the same tfm as well?

thanks

On 13/04/10 16:44, Kasatkin Dmitry (Nokia-D/Helsinki) wrote:
> Please see inline. Nice to clarify it.
>
> On 13/04/10 15:10, ext Herbert Xu wrote:
>    
>> On Tue, Apr 13, 2010 at 01:15:34PM +0300, Dmitry Kasatkin wrote:
>>
>>      
>>> But anyway hmac does not support ahash now. right?
>>> So the only way currently is to add to the driver.
>>>
>>>        
>> No the only way is to add an ahash version of hmac.
>>
>> Anyway, the fact that you can't easily implement import/export
>> is not just a question of supporting hmac.  It is in fact a sign
>> that your driver breaks the crypto API.
>>
>> The fundamental requirement for the ahash interface is that you
>> must be able to launch multiple operations, which means that all
>> state must be stored in the request and not held in hardware
>> (except as a cache).
>>
>> IOW, you must be able to support
>>
>> 	crypto_ahash_update(&reqa);
>>
>> 	...
>>
>> 	crypto_ahash_update(&reqb);
>>
>> 	...
>>
>> 	ahash_request_set_crypt(&reqa, ...);
>> 	crypto_ahash_finup(&reqa);
>>
>> 	...
>>
>> 	ahash_request_set_crypt(&reqb, ...);
>> 	crypto_ahash_finup(&reqb);
>>
>> AFAICS your driver cannot do this correctly in its current form.
>>
>>
>>      
> Well it can... if reqa occupied hw all other requests will fallback to
> sw sha1.
>
> But if to do only hw and to follow above algorithm then it is necessary
> to remove shash support completely from the driver.
> And have a queue as I have with aes driver..
> err = ablkcipher_enqueue_request(&dd->queue, req);
>
> I see there is ahash_enqueue_request() which is in
> crypto/internal/hash.h and NEVER called.
>
> Also in one of your earlier emails you said that it is not possible to
> call crypto_ahash_update() before completion.
> But with having a queue it does not really matter.
> Possible to queue several update request from the same tfm.
>
> The only need to wait_for_completion is to export/get results...
>
> Can you confirm my understanding?
>
> Thanks
>
>
>
> Well. not like that.
>
>    
>> Thanks,
>>
>>      
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

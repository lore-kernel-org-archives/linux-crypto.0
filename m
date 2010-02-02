From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: Async Crypto API
Date: Tue, 02 Feb 2010 15:46:58 +0200
Message-ID: <4B682CD2.3010308@nokia.com>
References: <20100123032039.GA5551@gondor.apana.org.au> <4B6817EF.7060307@nokia.com> <4B6819FB.8080607@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19900 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0BBNrP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Feb 2010 08:47:15 -0500
In-Reply-To: <4B6819FB.8080607@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

in sync API final() does not have any data.

Is async driver also should ignore req->src in final() call?

- Dmitry


Kasatkin Dmitry (Nokia-D/Helsinki) wrote:
> Hi,
>
> It actually would not make sense as final() suppose to cleanup
> everything and in the case of EINPROGRESS we can not do it.
>
> So the question how then to "wait for completion" of the hash by HW if
> not to use finup()
>
> - Dmitry
>
>
> Kasatkin Dmitry (Nokia-D/Helsinki) wrote:
>   
>> Hi,
>>
>> In the case when finup() is not used, just update/update/../final
>> driver finalize calculation from the final function.
>>
>> It takes a time and if it may not sleep, can final() also return
>> EINPROGRESS?
>>
>> Thanks,
>> Dmitry
>>
>>
>> ext Herbert Xu wrote:
>>   
>>     
>>> Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
>>>   
>>>     
>>>       
>>>> Hello,
>>>>
>>>> I have one question about async api.
>>>>
>>>> I work on AHASH driver and wonder about one thing.
>>>>
>>>> while calculating hash, client might call many times
>>>>
>>>> ahash_request_set_crypt(req, &sg, sha1, len);
>>>> crypto_ahash_update(req);
>>>> ..
>>>> ..
>>>> ahash_request_set_crypt(req, &sg, sha1, len);
>>>> crypto_ahash_finup(req);
>>>>
>>>> right?
>>>>
>>>> But because it is async and driver does not wait_for_completion,
>>>> previous request may not be completed before client will call next update.
>>>>
>>>> But what should be the behavior of the driver?
>>>>     
>>>>       
>>>>         
>>> If any async operation returns EINPROGRESS, the client must not
>>> proceed until that operation has completed.
>>>
>>> Cheers,
>>>   
>>>     
>>>       
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>   
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

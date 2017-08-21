From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v8 3/4] crypto: AF_ALG -- add asymmetric cipher
Date: Mon, 21 Aug 2017 12:23:55 +0300
Message-ID: <3b25c721-bde7-8427-be2f-2d5ca9fdbd22@microchip.com>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <2379311.RoATi6cCiZ@positron.chronox.de>
 <8450990a-61bb-0f7c-70dd-643a45220d3f@microchip.com>
 <5370549.LiGXVyRayf@positron.chronox.de>
 <fbc8c754-e519-e98b-a8f8-5a975cba013a@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:16221 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdHUJYR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2017 05:24:17 -0400
In-Reply-To: <fbc8c754-e519-e98b-a8f8-5a975cba013a@microchip.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 08/21/2017 11:55 AM, Tudor Ambarus wrote:
> Hi, Stephan,
> 
>>>> +static int akcipher_setprivkey(void *private, const u8 *key,
>>>> +                   unsigned int keylen)
>>>> +{
>>>> +    struct akcipher_tfm *tfm = private;
>>>> +    struct crypto_akcipher *akcipher = tfm->akcipher;
>>>> +    int err;
>>>> +
>>>> +    err = crypto_akcipher_set_priv_key(akcipher, key, keylen);
>>>> +    tfm->has_key = !err;
>>>> +
>>>> +    /* Return the maximum size of the akcipher operation. */
>>>> +    if (!err)
>>>> +        err = crypto_akcipher_maxsize(akcipher);
>>>
>>> crypto subsystem returns zero when setkey is successful and introduces
>>> a new function for determining the maxsize. Should we comply with that?
>>
>> The idea is that only when the the setting of the priv key fails, it 
>> returns
>> the size of the expected privkey.
>>
>> Which new function are you referring to?
> 
> I was referring to crypto_akcipher_maxsize. When
> crypto_akcipher_set_priv_key fails, you are overwriting it's return
> value with the value of crypto_akcipher_maxsize, hiding the cause of
> the error.

Oops, I missed the negation. When crypto_akcipher_set_priv_key succeeds
you return the akcipher_maxsize. Not a bad idea, you save few cpu
cycles.

> 
> crypto akcipher uses a dedicated function for determining the length of
> the output buffer, crypto_akcipher_maxsize. Should we add a new function
> pointer in struct af_alg_type that returns the maxsize?

Your API is different from crypto's akcipher. Should we make them
identical?

Cheers,
ta

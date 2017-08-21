From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v8 3/4] crypto: AF_ALG -- add asymmetric cipher
Date: Mon, 21 Aug 2017 11:55:43 +0300
Message-ID: <fbc8c754-e519-e98b-a8f8-5a975cba013a@microchip.com>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <2379311.RoATi6cCiZ@positron.chronox.de>
 <8450990a-61bb-0f7c-70dd-643a45220d3f@microchip.com>
 <5370549.LiGXVyRayf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:13958 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdHUI4F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2017 04:56:05 -0400
In-Reply-To: <5370549.LiGXVyRayf@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Stephan,

>>> +static int akcipher_setprivkey(void *private, const u8 *key,
>>> +			       unsigned int keylen)
>>> +{
>>> +	struct akcipher_tfm *tfm = private;
>>> +	struct crypto_akcipher *akcipher = tfm->akcipher;
>>> +	int err;
>>> +
>>> +	err = crypto_akcipher_set_priv_key(akcipher, key, keylen);
>>> +	tfm->has_key = !err;
>>> +
>>> +	/* Return the maximum size of the akcipher operation. */
>>> +	if (!err)
>>> +		err = crypto_akcipher_maxsize(akcipher);
>>
>> crypto subsystem returns zero when setkey is successful and introduces
>> a new function for determining the maxsize. Should we comply with that?
> 
> The idea is that only when the the setting of the priv key fails, it returns
> the size of the expected privkey.
> 
> Which new function are you referring to?

I was referring to crypto_akcipher_maxsize. When
crypto_akcipher_set_priv_key fails, you are overwriting it's return
value with the value of crypto_akcipher_maxsize, hiding the cause of
the error.

crypto akcipher uses a dedicated function for determining the length of
the output buffer, crypto_akcipher_maxsize. Should we add a new function
pointer in struct af_alg_type that returns the maxsize?

Thanks,
ta

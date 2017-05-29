From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [RFC PATCH v2 1/4] crypto: ecc - add privkey generation support
Date: Mon, 29 May 2017 12:47:48 +0300
Message-ID: <f8e3cae5-d431-85e2-8d87-6624058d52ea@microchip.com>
References: <1495034813-27143-1-git-send-email-tudor.ambarus@microchip.com>
 <8501918.Kgl28GDAYF@positron.chronox.de>
 <c9c47d0f-d4cb-0326-4c43-979fec11001c@microchip.com>
 <6869489.T5IFoD8UlO@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <marcel@holtmann.org>,
        <Nicolas.Ferre@microchip.com>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:15789 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbdE2Jrw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 05:47:52 -0400
In-Reply-To: <6869489.T5IFoD8UlO@tauon.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Stephan,

On 29.05.2017 12:23, Stephan Müller wrote:
> Am Montag, 29. Mai 2017, 11:08:38 CEST schrieb Tudor Ambarus:
> 
> Hi Tudor,
>>
>>>> +	unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>>>> +
>>>> +	get_random_bytes(priv, nbytes);
>>>
>>> Can you please use crypto_get_default_rng / crypto_rng_get_bytes /
>>> crypto_put_default_rng?
>>
>> Actually I tried this and I encountered some problems, I'm currently
>> debugging it.
>>
>> When using the default rng and the run-time self tests are enabled,
>> the kernel is in a blocking state. What's worse is that the kernel
>> blocks before the console has the chance to be enabled and I can't see
>> anything :).
>>
>> I suspect that the kernel blocks because the rng does not have enough
>> entropy. Could you please give me some hints?
> 
> Hm, there should be no blocking for the DRBG to initialize.
> 
> What happens if you compile that as a module and insmod it at runtime?

We will have a nop:

#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS

/* a perfect nop */
int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
{
	printk(KERN_ERR "no op in alg_test");
	return 0;
}

#else
...
#endif

If I further mangle it and change #ifdef with #ifndef then the tests are
passing.

Thanks,
ta

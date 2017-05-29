From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [RFC PATCH v2 1/4] crypto: ecc - add privkey generation support
Date: Mon, 29 May 2017 16:27:23 +0300
Message-ID: <f9602040-d25e-212e-f4f1-daea3a2e833a@microchip.com>
References: <1495034813-27143-1-git-send-email-tudor.ambarus@microchip.com>
 <6869489.T5IFoD8UlO@tauon.chronox.de>
 <f8e3cae5-d431-85e2-8d87-6624058d52ea@microchip.com>
 <1712750.5bvosCThh4@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <marcel@holtmann.org>,
        <Nicolas.Ferre@microchip.com>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:55391 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdE2N11 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 09:27:27 -0400
In-Reply-To: <1712750.5bvosCThh4@tauon.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Stephan,

On 29.05.2017 12:56, Stephan Müller wrote:
> Am Montag, 29. Mai 2017, 11:47:48 CEST schrieb Tudor Ambarus:
> 
> Hi Tudor,
> 
>>> Hm, there should be no blocking for the DRBG to initialize.
>>>
>>> What happens if you compile that as a module and insmod it at runtime?
>>
>> We will have a nop:
>>
>> #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
>>
>> /* a perfect nop */
>> int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
>> {
>> 	printk(KERN_ERR "no op in alg_test");
>> 	return 0;
>> }
>>
>> #else
>> ...
>> #endif
>>
>> If I further mangle it and change #ifdef with #ifndef then the tests are
>> passing.
> 
> Can you please enable the testmgr in the kernel config and compile the DH/ECDH
> code as a module. Then I would insmod the dh/ecdh kernel module to see whether
> the self tests work or not.

dh/ecdh self tests are passing when I insert dh/ecdh modules.

> 
> Note, if you use the calls of crypto_get_default_rng and friends, the DRBG
> must be present in the kernel at the time of calling. I.e. if you statically
> compile dh/ecdh but compile the RNG support as a module, the RNG will not load
> during self test. If you compile dh/ecdh as a module, the RNG can stay as a
> module.

However, when the self tests are enabled and DH/ECDH code is built-in, 
the kernel blocks.

I have to ensure that the drivers are loaded in the right order. 
Deferring the probe or just simply changing the order of the object
files from crypto/Makefile solves the issue. I'll go with the second
approach.

Thanks,
ta

From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: KPP questions and confusion
Date: Fri, 28 Jul 2017 10:01:29 +0300
Message-ID: <389a9dcf-05c1-2b59-90d9-ef9de5ff640b@microchip.com>
References: <CAJU8_nUhapH=nKkL=NEa2uW5f-vdAX3kvi5Ua7b_bA8d=BjRLQ@mail.gmail.com>
 <9580BB6F-45D8-49CD-B859-09C39FD4D7D0@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
To: Marcel Holtmann <marcel@holtmann.org>, Kyle Rose <krose@krose.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36344 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdG1HBr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 03:01:47 -0400
In-Reply-To: <9580BB6F-45D8-49CD-B859-09C39FD4D7D0@holtmann.org>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Marcel, Kyle,

On 07/17/2017 09:17 PM, Marcel Holtmann wrote:
> Hi Kyle,
> 
>> I am confused about several things in the new key agreement code.
>>
>> net/bluetooth/smp.c in two places generates random bytes for the
>> private_key argument to
>> net/bluetooth/ecdh_helper.c:generate_ecdh_keys, which suggests the
>> private key is static within the function. However, there is a do ...
>> while(true) loop within generate_ecdh_keys, with the following near
>> the end:
>>
>> /* Private key is not valid. Regenerate */
>> if (err == -EINVAL)
>>             continue;
>>
>> which suggests that it expects a different private key to be generated
>> on each iteration of the loop. But it looks like it runs through the
>> loop yet again with the same private key generated in the caller,
>> which suggests it would infinitely loop on a bad private key value. Is
>> this incorrect?
> 
> actually it seems that I screwed that up with commit 71653eb64bcca6110c42aadfd50b8d54d3a88079 where I moved the seeding of private_key outside of generate_ecdh_keys() function.
> 
>> Furthermore, since req->src == NULL via the call to
>> kpp_request_set_input, ecc_make_pub_key will always be called in
>> ecdh.c:ecdh_compute_value, in which case -EINVAL would be returned
>> only by invalid input (!private_key or bad curve_id) that AFAICT
>> cannot happen, or at least wouldn't be resolved by another run through
>> the loop.
>>
>> OTOH, -EAGAIN would be returned by ecc_make_pub_key if the public key
>> turns out to be the zero point, which is at least one reason why you'd
>> want to generate a new private key (if that loop were to do that.)
>>
>> I'm a little confused about some other things:
>>
>> * The bluetooth code doesn't seem to use ecc_gen_privkey, opting to
>> instead just generate random bytes and hope for the best.
>> * There doesn't appear to be any way for ecc_gen_privkey to get called
>> from crypto/ecdh.c:ecdh_set_secret, as it starts with a call to
>> crypto/ecdh_helper.c:crypto_ecdh_decode_key that returns -EINVAL if
>> decoding fails, meaning that both params.key != NULL and (if I'm
>> reading this correctly) params.key_size > 0. Is that dead code, or is
>> there a way it is intended to be used?
> 
> I am fine switching to ecc_gen_privkey. Care to provide a patch for it?
> 

Marcel, regarding the ecdh offload to hw from Bluetooth SMP code, this
is not possible as of know because SMP code uses it's own private keys.
atmel-ecc driver will fallback to the ecdh software implementation if
user wants to use it's own private keys.

I can jump in the Bluetooth's ecdh handling, but at best effort, my
primary goal is to add support for KPP in af_alg.

>> The context for this email is that I have need for the same basic
>> functionality in net/bluetooth/ecdh_helper.c for a non-BT purpose, so
>> it seems like this should be part of crypto/ecdh_helper.c (abstracted
>> to work for any curve). Basically, I need to do basic ECDH key
>> agreement:
>>
>> * Generate a new (valid) ephemeral private key, or potentially re-use
>> an existing one
>> * Compute the corresponding public key for the curve
>> * Compute the shared secret based on my private and peer's public
>>
>> Is KPP intended to be an abstract interface to all of the above, e.g.,
>> for both ECDH and FFDH? Right now it seems like layer violations are
>> required as there doesn't appear to be any way to (for example)
>> generate a fresh private key via kpp_*.
> 

Kyle, you can do all of the above for ecdh. Look at alg_test_kpp from
crypto/testmgr.c.

FFDH private key generation is not supported yet.

Cheers,
ta

> I think the whole goal is to abstract this. Mainly so that ECDH can also be offload to hardware.
> 
> Regards
> 
> Marcel
> 

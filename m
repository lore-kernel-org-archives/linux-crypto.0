From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: KPP questions and confusion
Date: Thu, 3 Aug 2017 10:40:26 +0200
Message-ID: <625119CA-F823-4B9B-88F6-EAFFA58D965D@holtmann.org>
References: <CAJU8_nUhapH=nKkL=NEa2uW5f-vdAX3kvi5Ua7b_bA8d=BjRLQ@mail.gmail.com>
 <9580BB6F-45D8-49CD-B859-09C39FD4D7D0@holtmann.org>
 <389a9dcf-05c1-2b59-90d9-ef9de5ff640b@microchip.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Kyle Rose <krose@krose.org>, linux-crypto@vger.kernel.org,
        smueller@chronox.de, Nicolas Ferre <nicolas.ferre@microchip.com>
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:42619 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbdHCIk3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 04:40:29 -0400
In-Reply-To: <389a9dcf-05c1-2b59-90d9-ef9de5ff640b@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tudor,

>>> I am confused about several things in the new key agreement code.
>>> 
>>> net/bluetooth/smp.c in two places generates random bytes for the
>>> private_key argument to
>>> net/bluetooth/ecdh_helper.c:generate_ecdh_keys, which suggests the
>>> private key is static within the function. However, there is a do ...
>>> while(true) loop within generate_ecdh_keys, with the following near
>>> the end:
>>> 
>>> /* Private key is not valid. Regenerate */
>>> if (err == -EINVAL)
>>>            continue;
>>> 
>>> which suggests that it expects a different private key to be generated
>>> on each iteration of the loop. But it looks like it runs through the
>>> loop yet again with the same private key generated in the caller,
>>> which suggests it would infinitely loop on a bad private key value. Is
>>> this incorrect?
>> actually it seems that I screwed that up with commit 71653eb64bcca6110c42aadfd50b8d54d3a88079 where I moved the seeding of private_key outside of generate_ecdh_keys() function.
>>> Furthermore, since req->src == NULL via the call to
>>> kpp_request_set_input, ecc_make_pub_key will always be called in
>>> ecdh.c:ecdh_compute_value, in which case -EINVAL would be returned
>>> only by invalid input (!private_key or bad curve_id) that AFAICT
>>> cannot happen, or at least wouldn't be resolved by another run through
>>> the loop.
>>> 
>>> OTOH, -EAGAIN would be returned by ecc_make_pub_key if the public key
>>> turns out to be the zero point, which is at least one reason why you'd
>>> want to generate a new private key (if that loop were to do that.)
>>> 
>>> I'm a little confused about some other things:
>>> 
>>> * The bluetooth code doesn't seem to use ecc_gen_privkey, opting to
>>> instead just generate random bytes and hope for the best.
>>> * There doesn't appear to be any way for ecc_gen_privkey to get called
>>> from crypto/ecdh.c:ecdh_set_secret, as it starts with a call to
>>> crypto/ecdh_helper.c:crypto_ecdh_decode_key that returns -EINVAL if
>>> decoding fails, meaning that both params.key != NULL and (if I'm
>>> reading this correctly) params.key_size > 0. Is that dead code, or is
>>> there a way it is intended to be used?
>> I am fine switching to ecc_gen_privkey. Care to provide a patch for it?
> 
> Marcel, regarding the ecdh offload to hw from Bluetooth SMP code, this
> is not possible as of know because SMP code uses it's own private keys.
> atmel-ecc driver will fallback to the ecdh software implementation if
> user wants to use it's own private keys.
> 
> I can jump in the Bluetooth's ecdh handling, but at best effort, my
> primary goal is to add support for KPP in af_alg.

then we need a better abstraction inside KPP. Since even for Bluetooth SMP the keys are temporary. The only thing we have to check is against a well know public/private key pair that was designated as debug key for sniffer purposes.

Essentially we do what all other key exchange procedure do. Generate a private/public key pair, give the public key to the other side, run DH with the value from the other side. That Bluetooth SMP knows about the private key is really pointless. Since the detection of debug key usage is actually via the public key portion.

Regards

Marcel

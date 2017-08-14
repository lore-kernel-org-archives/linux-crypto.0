From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Mon, 14 Aug 2017 08:42:04 +0200
Message-ID: <B33F81CA-75A2-43C6-A341-41A6D2F9E830@holtmann.org>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <4460438.43jVvca0Xd@positron.chronox.de>
 <B3DDB822-FCDC-41A2-A5AB-9956866D6725@holtmann.org>
 <30055124.HBDiccPrro@tauon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <david@woodhou.se>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:34973 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdHNGmH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 02:42:07 -0400
In-Reply-To: <30055124.HBDiccPrro@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

>>> Thanks for the reminder. I have looked at that but I am unsure about
>>> whether this one covers asym crypto appropriately, too.
>>> 
>>> The issue is that some hardware may only offer accelerators without a full
>>> blown RSA siggen/ver logic (that pulls in PKCS or OAEP or others). How do
>>> you propose to cover raw primitives with keyctl?
>> 
>> where is such a hardware?
> 
> Strangely, I see such support all the time in embedded devices where 
> asymmetric acceleration is really necessary.

and where are the support patches to integrate them with KPP in the kernel. Maybe we should first have these before exposing anything to userspace.

I said this in another thread before, we have Bluetooth Security Manager which uses ECDH. It has been re-written to use KPP and once we have that fully supporting hardware based ECC key generation and ECDH operation, I would be a lot more confident that we understand how asymmetric crypto accelerators actually do their job. Especially in the embedded world.

>> And what is the usage of it? Look at what we are
>> using asymmetric crypto for at the moment. It is either for sign and verify
>> with secure boot etc. Or it is for key exchange purposes.
> 
> I understand that this is the core purpose of asymmetric ciphers. Yet, 
> asymmetric ciphers are complex and we as kernel developers do not know (or 
> shall not mandate?) where the complexity shall be implemented. By forcing all 
> into the keyctl, we would insist that the entire complexity of the full-blown 
> asym cipher is in the kernel without an option that user space may implement 
> it.
> 
> What we are currently seemingly discuss is the choice of
> 
> - keyctl: having all complexity of the entire asym logic including its key 
> handling in the kernel with the benefit of the kernel protection of the 
> private key

Which we already have anyway since the kernel supports Secure Boot.

> - algif_akcipher (maybe with a link to keyctl): only exporting the cipher 
> support and allow user space to decide where the complexity lies
> 
> Just to give you an example: A full blown RSA operation (excluding the hashing 
> part for signatures) consists of padding and the asymmetric operation. For the 
> asymmetric operation, we have sign/verify and encrypt/decrypt (keywrap). There 
> are a gazillion padding types out there:
> 
> - PKCS1
> 
> - OAEP
> 
> - SP800-56B: RSAEP, RSADP, RSASVE, RSA-OAEP, RSA-KEM-KWS
> 
> And there may be others.
> 
> When we talk about encryption/decryption we have to consider the KDFs 
> (SP800-108, RFC5689, SP800-56A).
> 
> When we consider the KDFs, we have to think of the KDF data styles (ASN.1, 
> concatenation)
> 
> With keyctl to me it seems that we need to integrate all that logic into the 
> kernel. As all of that is just processing logic, securing it in the kernel may 
> not be the right way as this code does not need the elevated privileges in the 
> kernel for that.

The keyring subsystem has extensive user permissions available. Actually that is even more of a reason to not expose anything with private keys via AF_ALG. If I can use AF_ALG to access (meaning use a private key) that I am not suppose to use, then we have a real security nightmare on our hands. The keyring subsystem has permission that can be restricted on a per-thread level.

On a side note, have a look at ELL and how it uses Mat’s crypto tree. For fun look at iwd and how it does WPA-Enterprise with mostly only kernel primitives.

> Yet, some hardware may provide some/all of this logic. And we want to make 
> that available to user space.

I don’t get the raw access to RSA for example. Nobody uses it in raw mode. There is always some sort of padding involved and needed. Otherwise RSA would be pretty insecure.

It is also funny how RSA centric this is. There is more than RSA since especially ECDH and its friends are getting more and more traction in the IoT spaces. Secure key exchange without the usage of certificates is actually a valid use case as well.

>> The asymmetric crypto is a means to an end. If it is not for certification
>> verification, then it for is creating a symmetric key to be used with a
>> symmetric cipher. We have the the asymmetric_keys subsystem for
>> representing the nature of this crypto. Also the list of asymmetric ciphers
>> is a lot smaller than the symmetric ones.
>> 
>> What raw primitives? When we are using for example ECDH for Bluetooth where
>> you need to create a pairwise symmetric key, then what you really want from
>> the cryptographic primitives is this:
>> 
>> 1) Create public/private key pair
> 
> See above, it is my opinion that with asym ciphers, there is a lot of 
> complexity and lots of options. I do not think that the kernel API should be a 
> limiting factor here, because the kernel simply does not implement a specific 
> cipher type.

What has cipher type to do with this? This confuses me. If the kernel supports any KPP backed algorithm, it should be able to generate key pairs for it. The complexity if the private key is in hardware is not what I care about. Frankly if the public is not leaving the kernel space, that is a huge bonus in my mind. The constant copying and with that securing of keys is always an attack vector.

>> 2) Give public key to applications and store the private key safely
>> 3) Retrieve public key from remote side and challenge
> 
> This assumes that always the Linux kernel is the manager of keys (or the 
> gatekeeper to the key store). Are we sure that this is always the case?

Why would it not be? How can you do a better job in userspace? And if you have hardware backend for storage, then it can be easily abstracted with the keyring subsystem. See TPM for example.

Regards

Marcel

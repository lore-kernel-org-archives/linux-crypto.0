From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Wed, 2 Mar 2016 05:46:44 -0800
Message-ID: <F79358BD-CFB3-4B7B-A609-F050038A3D91@holtmann.org>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com> <3E4EC1AA-9696-4DBF-9C0A-18EF94300FDC@holtmann.org> <20160302093831.GA2384@sbenedet-virtual-machine>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [82.165.8.211] ([82.165.8.211]:55274 "EHLO mail.holtmann.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750999AbcCBNqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Mar 2016 08:46:50 -0500
In-Reply-To: <20160302093831.GA2384@sbenedet-virtual-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Salvatore,

>>> Implement Diffie-Hellman primitives required by the scheme under the
>>> akcipher API. Here is how it works.
>>> 1) Call set_pub_key() by passing DH parameters (p,g) in PKCS3 format
>>> 2) Call set_priv_key() to set your own private key (xa) in raw format
>> 
>> this combination seems odd since it is normally the remote public key and the local private key. Generally the public key and private key are both remote ones.
> 
> I'm not sure I understand what you mean here. Usually the public key is
> remote and the private key is local. How can the private key be remote?

I accidentally mistyped. I meant of course local.

>> 
>> For using PKCS3 format is this standardized somewhere? I don't think it is a good idea to invent new ones here.
> 
> PKCS3 is the format used by openssl for genating DH params, that's why I
> used it.

Is that OpenSSL specific or backed up by a RFC?

>> 
>> In addition, how would this work for ECDH?
> 
> Don't know. There is not even ECC support right now.

If you call something dh-generic, then we need to think about how it would work for all the other ciphers that it might be used with. Making this RSA specific is not a good idea.

> 
>> 
>>> 3) Call decrypt() without passing any data as input to get back the
>>>  public part which will be computed as g^xa mod p
>>> 4) Call encrypt() by passing the counter part public key (yb) in raw format
>>>  as input to get back the shared secret calculated as zz = yb^xa mod p
>>> 
>>> A test is included in the patch. Test vector has been generated with
>>> openssl
>>> 
>>> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
>>> ---
>>> crypto/Kconfig    |   8 ++
>>> crypto/Makefile   |   7 ++
>>> crypto/dh.c       | 264 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>> crypto/pkcs3.asn1 |   5 ++
>>> crypto/tcrypt.c   |   4 +
>>> crypto/testmgr.c  | 140 +++++++++++++++++++++++++++--
>>> crypto/testmgr.h  | 208 +++++++++++++++++++++++++++++++++++++++++-
>>> 7 files changed, 627 insertions(+), 9 deletions(-)
>>> create mode 100644 crypto/dh.c
>>> create mode 100644 crypto/pkcs3.asn1
>>> 
>>> diff --git a/crypto/Kconfig b/crypto/Kconfig
>>> index f6bfdda..fd5b78d 100644
>>> --- a/crypto/Kconfig
>>> +++ b/crypto/Kconfig
>>> @@ -101,6 +101,14 @@ config CRYPTO_RSA
>>> 	help
>>> 	  Generic implementation of the RSA public key algorithm.
>>> 
>>> +config CRYPTO_DH
>>> +	tristate "Diffie-Hellman algorithm"
>>> +	select CRYPTO_AKCIPHER
>>> +	select MPILIB
>>> +	select ASN1
>> 
>> I really wonder that depending on ASN1 is a good idea here. As mentioned above ECDH would make sense to actually have supported from the beginning. The Bluetooth subsystem could be then converted to utilize in kernel ECC key generation and ECDH shared secret computation. It would be good to show this is truly generic DH.
>> 
> 
> This is an RFC. I understand it is not the best approach, but
> the idea behind was to try to reuse the akcipher for DH.

And I have the feeling that akcipher is not the best approach for adding a key exchange method. I think we need a new method for doing exactly that. At the base of it, the key exchange is fundamentally different.

>From an API point of view, I am also not convinced that it is a good idea to generate the private keys used on the fly. I think this all needs to be a lot more deterministic and flexible. In addition there are cases where you want to point to specific private / public key pair that you locally have. There are even protocols like Bluetooth that have defined fixed debug key pairs. If we can not support that, then this approach is not generic enough.

So my thinking actually is that we need a new key exchange abstraction in the crypto stack. However I am not sure that an userspace facing API should be done via AF_ALG. I think that does not fit. I think that doing it via keyctl is a lot more logical place.

It also means that we need a separate keyctl to actually generate the local private / public key pairs first. I think that makes sense no matter what. You can generate the keys, the private key stays in kernel memory forever and you can read out the public key. Some protocols will throw away the keys after single use, but others might actually reuse them. Or as mentioned above has fixed keys for debugging purposes. Using keyctl should then also make it easy to handle RSA vs ECC for the key generation since we need to be able to store both types at some point anyway. Also in cases where keys are RSA keys in ASN.1 format in the first place or are learned from certificates are already present and uniquely presented in the kernel. No need to invent yet another format for keys.

Especially in the case where you create a session key based out of certificates and existing public / private key pairs, it makes sense that keyctl can turn them directly into a new key. In most cases these are symmetric keys that can then be easily referenced by skcipher for ease of use.

And I did mention this before, this would also solve the problem where you might have to use a private key that is part of a TPM or secure enclave. The case where the kernel does not even know the key, just its existence. Use it to generate the session key and keep the session key in the kernel.

Regards

Marcel

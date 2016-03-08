From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Tue, 8 Mar 2016 09:03:09 -0800
Message-ID: <D5F209A6-47E3-4C2E-B183-20B3ADF13F20@holtmann.org>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com> <3E4EC1AA-9696-4DBF-9C0A-18EF94300FDC@holtmann.org> <20160302093831.GA2384@sbenedet-virtual-machine> <F79358BD-CFB3-4B7B-A609-F050038A3D91@holtmann.org> <56DDF682.5070008@intel.com> <EBC36642-63BA-4575-BC03-8E5555DDF49F@holtmann.org> <56DE0C72.3000000@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Cc: Salvatore Benedetto <salvatore.benedetto@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	David Woodhouse <david@woodhou.se>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ipv4.connman.net ([82.165.8.211]:46418 "EHLO mail.holtmann.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933200AbcCHRDP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Mar 2016 12:03:15 -0500
In-Reply-To: <56DE0C72.3000000@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tadeusz,

>>> In this way we can define a generic user side of the key exchange interface,
>>>> and on the the driver side of the akcipher, the implementations would overload
>>>> the existing akcipher encrypt(), decrypt(), set_pub_key(), set_priv_key() methods
>>>> and do what should be done for a given algorithm. We just need to agree on the
>>>> format of the input parameters to these operations.
>> I think trying to heavily map this to encrypt and decrypt is a bad idea. These callbacks are not really designed to return what you need them to return. Key exchange is different.
>> 
>> So why are we trying to push this into akcipher in the first place? I mean lets just create a keyexch (or similar name) and design it explicitly for key exchange handling. We are also not trying to map hashes into skcipher. I think the clear distinction of semantics calls for a different API.
>> 
> 
> I just think that before introducing new API we should try to reuse what's already
> there. Looking at RSA and DH, they basically perform x = a^b mod p, so we should
> have what's needed for both and we just could overload the methods already defined.
> I'm fine either way. Herbert, what's your preference?

I do not think that it is a valid argument because the operations are the same to use akcipher. While operations are similar, the inputs are totally different. And it is really not performing encrypt or decrypt operations here. You use different inputs and get different outputs. You are not encrypting or decrypting anything. Especially key generation via decrypt is something I can not wrap my mind around.

>>> Agree, we need to support all the cases, but dealing with different type of keys
>>>> needs to happen above this API. This API should solely be an interface to math
>>>> primitives of certain operations, which can be implemented in SW or can be HW
>>>> accelerated. Modules like public_key or afalg_akcipher need to be smart enough
>>>> and know what key types they deal with and do the right thing depending on that
>>>> knowledge.
>> I am not sure this can be that easily generalized. Just pushing the problem of key types and formats off to userspace just forces complexity and extra knowledge there. We need to be really carefully here. And I really dislike introducing custom ASN.1 structures that are not backed by an actual RFC document.
> 
> I'm not saying that we should push this to user space. I'm just saying this should
> be handled above the crypto API.
> 
>>> Agree, and to make this work with afalg_akcipher, I have proposed new
>>>> ALG_SET_KEY_ID and ALG_SET_KEY_ID operations. See here: https://lkml.org/lkml/2015/12/26/65
>>>> The plan is that in this case the afalg_akcipher will not use akcipher api at all.
>>>> In this case the algif_akcipher will use the request_key() interface to retrieve
>>>> the key type info and will use the operations that the new TPM interface will define.
>> The ALG_SET_KEY_ID is great for skcipher where you key is a fixed size blob. There is works really well. And you will need if we let keyctl derive the session key from a set of asymmetric keys.
>> 
>> I get that we want to enable OpenSSL and others to gain access to kernel crypto operations. We want the same actually for ELL as well. However what is dangerous here is that AF_ALG can never support hardware based keys. So that means support in OpenSSL is broken by design. See earlier emails from David Woodhouse. If you have your certificates / keys in hardware then you need to be able to make them work with OpenSSL. We can not ignore this. It is a design we need to consider from the beginning.
> 
> If we will have the TPM interface that allows to invoke functions for HW keys and
> the *_KEY_ID, then I don't see why AF_ALG would not work. As I said, in case when
> the keys will be in HW the algif_akcipher will not use akcipher api, but use the
> TPM defined functions in the same way as the keyctl would use it.
> So I think both AF_ALG and keyctl should work just fine.

When David and I talked to Herbert at the kernel summit in Seoul, he said that the crypto subsystem (and with that AF_ALG) always needs to support software fallback crypto. In case of hardware based keys, there is no software fallback possible. If you have a hardware key, then it always needs to use the hardware crypto that comes with the key.

And that is precisely my point in going forward with keyctl for all of these. We need _one_ interface that can handle software and hardware keys / key pairs.

Regards

Marcel

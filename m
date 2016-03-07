From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Mon, 7 Mar 2016 15:19:14 -0800
Message-ID: <56DE0C72.3000000@intel.com>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
 <3E4EC1AA-9696-4DBF-9C0A-18EF94300FDC@holtmann.org>
 <20160302093831.GA2384@sbenedet-virtual-machine>
 <F79358BD-CFB3-4B7B-A609-F050038A3D91@holtmann.org>
 <56DDF682.5070008@intel.com>
 <EBC36642-63BA-4575-BC03-8E5555DDF49F@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Salvatore Benedetto <salvatore.benedetto@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	David Woodhouse <david@woodhou.se>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62590 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933232AbcCGXXx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Mar 2016 18:23:53 -0500
In-Reply-To: <EBC36642-63BA-4575-BC03-8E5555DDF49F@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Marcel,
On 03/07/2016 02:29 PM, Marcel Holtmann wrote:
>> In this way we can define a generic user side of the key exchange interface,
>> > and on the the driver side of the akcipher, the implementations would overload
>> > the existing akcipher encrypt(), decrypt(), set_pub_key(), set_priv_key() methods
>> > and do what should be done for a given algorithm. We just need to agree on the
>> > format of the input parameters to these operations.
> I think trying to heavily map this to encrypt and decrypt is a bad idea. These callbacks are not really designed to return what you need them to return. Key exchange is different.
> 
> So why are we trying to push this into akcipher in the first place? I mean lets just create a keyexch (or similar name) and design it explicitly for key exchange handling. We are also not trying to map hashes into skcipher. I think the clear distinction of semantics calls for a different API.
> 

I just think that before introducing new API we should try to reuse what's already
there. Looking at RSA and DH, they basically perform x = a^b mod p, so we should
have what's needed for both and we just could overload the methods already defined.
I'm fine either way. Herbert, what's your preference?

>> Agree, we need to support all the cases, but dealing with different type of keys
>> > needs to happen above this API. This API should solely be an interface to math
>> > primitives of certain operations, which can be implemented in SW or can be HW
>> > accelerated. Modules like public_key or afalg_akcipher need to be smart enough
>> > and know what key types they deal with and do the right thing depending on that
>> > knowledge.
> I am not sure this can be that easily generalized. Just pushing the problem of key types and formats off to userspace just forces complexity and extra knowledge there. We need to be really carefully here. And I really dislike introducing custom ASN.1 structures that are not backed by an actual RFC document.

I'm not saying that we should push this to user space. I'm just saying this should
be handled above the crypto API.

>> Agree, and to make this work with afalg_akcipher, I have proposed new
>> > ALG_SET_KEY_ID and ALG_SET_KEY_ID operations. See here: https://lkml.org/lkml/2015/12/26/65
>> > The plan is that in this case the afalg_akcipher will not use akcipher api at all.
>> > In this case the algif_akcipher will use the request_key() interface to retrieve
>> > the key type info and will use the operations that the new TPM interface will define.
> The ALG_SET_KEY_ID is great for skcipher where you key is a fixed size blob. There is works really well. And you will need if we let keyctl derive the session key from a set of asymmetric keys.
> 
> I get that we want to enable OpenSSL and others to gain access to kernel crypto operations. We want the same actually for ELL as well. However what is dangerous here is that AF_ALG can never support hardware based keys. So that means support in OpenSSL is broken by design. See earlier emails from David Woodhouse. If you have your certificates / keys in hardware then you need to be able to make them work with OpenSSL. We can not ignore this. It is a design we need to consider from the beginning.

If we will have the TPM interface that allows to invoke functions for HW keys and
the *_KEY_ID, then I don't see why AF_ALG would not work. As I said, in case when
the keys will be in HW the algif_akcipher will not use akcipher api, but use the
TPM defined functions in the same way as the keyctl would use it.
So I think both AF_ALG and keyctl should work just fine.
Thanks,
-- 
TS

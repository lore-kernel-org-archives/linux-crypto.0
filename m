From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Proposal for adding setpubkey callback to akcipher_alg
Date: Mon, 3 Aug 2015 00:25:31 -0700
Message-ID: <3743CED6-E3E0-416E-9B82-F1677628E35E@holtmann.org>
References: <905E1812-AD9B-4188-A668-3CD8985EA1BF@holtmann.org> <1704807.Rn4DsddD6R@tauon.atsec.com> <70C201C0-233D-4912-9856-C8C0E7A6A0FA@holtmann.org> <14682477.78a1L9JDin@myon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47288 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbbHCHZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 03:25:37 -0400
In-Reply-To: <14682477.78a1L9JDin@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

>>>> I think we need to split the akcipher_alg setkey callback into a setkey
>>>> and
>>>> setpubkey.
>>>> 
>>>> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
>>>> index 69d163e39101..ca93952b6d19 100644
>>>> --- a/include/crypto/akcipher.h
>>>> +++ b/include/crypto/akcipher.h
>>>> @@ -91,6 +91,8 @@ struct akcipher_alg {
>>>> 
>>>>      int (*decrypt)(struct akcipher_request *req);
>>>>      int (*setkey)(struct crypto_akcipher *tfm, const void *key,
>>>> 
>>>>                    unsigned int keylen);
>>>> 
>>>> +       int (*setpubkey)(struct crypto_akcipher *tfm, const void *key,
>>>> +                        unsigned int keylen);
>>>> 
>>>>      int (*init)(struct crypto_akcipher *tfm);
>>>>      void (*exit)(struct crypto_akcipher *tfm);
>>>> 
>>>> If the cipher actually uses two different formats for the public +
>>>> private
>>> 
>>> The public key is n + e.
>>> 
>>> The private key is n + d.
>> 
>> for RSA Public Key it is just n and e. However for RSA Private Key it is n
>> and e and d and also version, primes etc. So the RSA Public Key contains a
>> sequence of 2 integers and the RSA Private Key contains a sequence of 9
>> integers.
>>> Both are encoded in the BER structure the current API requires. It is
>>> perfectly valid to provide only n + e when you do public key operations.
>> 
>> And from an API perspective that is fully wrong from my point of view. We
>> just invented another format that is not in any standard. The two standard
>> key formats for RSA are RSA Private Key and RSA Public Key. These are the
>> ones we should support.
>> 
>> The format with n plus e and optionally d is total Linux invention as far as
>> I can tell. And I do not want this exposed to userspace.
>> 
>> For a clean separation I think splitting this into setkey for the RSA
>> Private Key and setpubkey for the RSA Public Key is pretty obvious choice.
> 
> Please define exactly what your pubkey and your privkey contains. Even when I 
> think of the DER keys from OpenSSL, we once have n+e and once n+e+d (see 
> asn1dump), no?

RSA Private Key is n + e + d (including 6 other fields). RSA Public Key is n + e (no other fields).

So for RSA you would make setkey to take RSA Private Key and setpubkey to take RSA Public Key. Meaning you only have to use one of them since if you have the private key, you always have the public key.

This real difference here is that you can provide the key in two different key formats. As explained RSA uses two different format.

>>> Please see in the testmgr.h for the 2048 bit key test vector (i.e. the one
>>> with public_key_vec = true). The BER structure has nice comments from
>>> Tadeusz to indicate it only contains n and e without d.
>> 
>> And it is totally made up format. Why would you force conversion of a RSA
> 
> BER is a made up implementation? I do not think so: 
> https://en.wikipedia.org/wiki/Basic_Encoding_Rules
> 
> Or do you say that the kernel's implementation of BER is broken?

BER is an encoding format. It does NOT define a key format. You can use BER to define a key format, but that still means that our defined format that is currently used for setkey with RSA is made up. It is Linux specific.

The standards for key formats for RSA are RSA Public Key and RSA Private Key.

>> Public Key or RSA Private Key in DER format into this format. This Linux
>> only input format makes it just complicated for no reason. It is also not
>> documented anywhere as I can tell. I had to dig this out of the code and
>> rsakey.asn1.
>> 
>> As mentioned above, splitting this into two functions makes this simpler.
>> For all intense and purposes this is akcipher so we always either have
>> public/private key pair or we just have the public key. And at least with
>> RSA they are defined as two independent formats.
> 
> I can see that user space (e.g. libkcapi) has such two functions. But 
> currently I do not see such distinction necessary in the kernel as mentioned 
> above.

Then how do you tell the two key formats apart? Try one, fail, try the other? I do not like these things. Just tell the kernel clearly what format you have. Simple and easy.

>> Since the parsing of the key data is not a generic handling, I do not see a
>> good enough reason to invent new formats. Use the format the cipher you
>> implement already has defined.
>>> Thus, I do not currently understand your request. May I ask you to give
>>> more explanation why the use of BER is insufficient?
>> 
>> Tell me how you create this Linux specific BER encoded key. I would like
>> someone to provide the magic OpenSSL conversion command line to get this.
> 
> Again: there is no DER to BER converter that I am aware of. Agreed, that 
> should be there. But currently I do not see that the kernel should do that.

For all intense and purposes DER is valid BER. Why are discussing this?

>> Hand crafting such keys when there is a standard format for RSA Private Key
>> and RSA Public Key makes no sense whatsoever.
> 
> Fully agreed. Thus, a BER encoder is on my agenda for libkcapi.

You are missing my point here. You should not need such a thing. The RSA keys are already provided in two well defined DER encoded key formats. Why are we trying to invent new formats?

Regards

Marcel

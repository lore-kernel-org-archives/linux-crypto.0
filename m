From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Limited usefulness of RSA set key function
Date: Mon, 3 Aug 2015 00:14:28 -0700
Message-ID: <6876D9AA-A51A-4D79-9127-3B3ED58784CA@holtmann.org>
References: <BC087D1C-7D4D-4F6D-9644-B2043C3E39D3@holtmann.org> <3848823.PNN01JLIZu@tauon.atsec.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:54169 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbHCHOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 03:14:35 -0400
In-Reply-To: <3848823.PNN01JLIZu@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

>> I have been working with the AF_ALG patches for akcipher lately and I find
>> the RSA set key function way too limited. Especially the fact that it uses a
>> format that I can not find a single reference / standard for worries me.
>> 
>> RsaKey ::= SEQUENCE {
>>       n INTEGER ({ rsa_get_n }),
>>       e INTEGER ({ rsa_get_e }),
>>       d INTEGER ({ rsa_get_d })
>> }
> 
> Note, the kernel uses BER encoding.

so what? DER is still valid BER.

>> So where is this format coming from? I can find the RSA Public Key format
>> which is a sequence of n and e. If you have a DER encoded RSA public key,
>> then you can use it to encrypt and verify. So that is okay.
>> 
>> However if you have a standard Public Key that OpenSSL would create by
>> default, then things do not work since that is actually a more complicated
>> DER encoded format. However in the end, I would expect that we could also
>> load such a key here. The RSA set key function should auto detect it and
>> extract the right information if it is marked as rsaEncryption type.
> 
> Do you propose to add a DER parser to the kernel? I feel that the BER parser 
> is complex enough. If somebody has a DER key, user space should have the code 
> to convert it to BER.

Why would you do that? DER is still valid BER.

>> My biggest concern however is that this does not reassemble the RSA Private
>> Key at all. That key format is a sequence of 9 integers starting with a
>> version. So logically I would expect that I can just set a RSA Private Key
>> and then utilize the encrypt and decrypt features of the RSA cipher.
> 
> Why do you think this is not possible? testmgr.h seems to exactly do that.

It does not. The RSA Private Key has a different format.

      RSAPrivateKey ::= SEQUENCE {
          version           Version,
          modulus           INTEGER,  -- n
          publicExponent    INTEGER,  -- e
          privateExponent   INTEGER,  -- d
          prime1            INTEGER,  -- p
          prime2            INTEGER,  -- q
          exponent1         INTEGER,  -- d mod (p-1)
          exponent2         INTEGER,  -- d mod (q-1)
          coefficient       INTEGER,  -- (inverse of q) mod p
      }

And honestly that the RSA Public Key magically matches seems more luck then clear intention.

      RSAPublicKey ::= SEQUENCE {
          modulus           INTEGER,  -- n
          publicExponent    INTEGER   -- e
      }

So what you have in testmgr.h is neither RSA Private Key nor RSA Public Key. It is a brand new format that is sadly Linux specific.

>> When it comes to exposing RSA via AF_ALG and akcipher, I really want standard
>> format for the set key operation. Asking userspace to construct this Linux
>> kernel only key format is not helpful. You want to be able to just load the
>> RSA Private Key in DER format and be done with it.
> 
> I am all for it. BER is a standard, is it not? Yes, I have not yet seen a 
> converter for DER to BER (and I have not searched for one either). But I feel 
> DER should be left to user space.

DER is valid BER. However just saying the key is BER has no meaning whatsoever. It does not define an actual key format.

What I would like to see is support for RSA Private Key (DER encoded) and RSA Public Key (DER encoded) when using the RSA cipher. That makes sense to me. Everything else is just insanity since we force the user to convert well known formats into new ones for no apparent reason.

>> Any ideas on how we can fix this to allow a sensible userspace API?
> 
> I actually planned to add a BER encoder to my libkcapi. I feel that should be 
> right place to provide that code, including a potential DER to BER converter.

No idea what DER to BER would give you since DER is always valid BER. I see no need for BER or DER encoders if the keys and also certificates are already available in DER format your system (or can be easily converted from PEM to DER with standard tools).

Seriously, I want to take the RSA Private Key that comes out of OpenSSL and use it. I want to be able to extract the RSA Public Key out of a certificate and use it. Plain and simple. No other gimmicks, conversions or tricks to play. Using existing key format standards is really the key here.

Regards

Marcel

From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Limited usefulness of RSA set key function
Date: Mon, 3 Aug 2015 00:30:50 -0700
Message-ID: <2726A091-A7A2-451F-BB11-A19A73DA3C36@holtmann.org>
References: <BC087D1C-7D4D-4F6D-9644-B2043C3E39D3@holtmann.org> <3848823.PNN01JLIZu@tauon.atsec.com> <6876D9AA-A51A-4D79-9127-3B3ED58784CA@holtmann.org> <1580424.u6GEQiXd8T@myon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37507 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbbHCHa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 03:30:57 -0400
In-Reply-To: <1580424.u6GEQiXd8T@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

>> It does not. The RSA Private Key has a different format.
>> 
>>      RSAPrivateKey ::= SEQUENCE {
>>          version           Version,
>>          modulus           INTEGER,  -- n
>>          publicExponent    INTEGER,  -- e
>>          privateExponent   INTEGER,  -- d
>>          prime1            INTEGER,  -- p
>>          prime2            INTEGER,  -- q
>>          exponent1         INTEGER,  -- d mod (p-1)
>>          exponent2         INTEGER,  -- d mod (q-1)
>>          coefficient       INTEGER,  -- (inverse of q) mod p
>>      }
>> 
>> And honestly that the RSA Public Key magically matches seems more luck then
>> clear intention.
>> 
>>      RSAPublicKey ::= SEQUENCE {
>>          modulus           INTEGER,  -- n
>>          publicExponent    INTEGER   -- e
>>      }
> 
> I think here we may have the issue: the ASN.1 structure the kernel uses should 
> be changed to implement that commonly used ASN.1 structure. If this change 
> would allow a DER to be used, I think we have the solution.

as you can clearly see. There are two formats defined here. There is no single ASN.1 structure that can decode both of these.

It is what it is, RSA Public Key and RSA Private Key formats are two different key formats. And OpenSSL also treats it like this. You can extract the public key from a private key (same way you can extract it from a certificate), but you can not create a private key structure that only contains the public key.

For RSA we need to support the two formats as listed above. To make this really easy from an API point of view, I would have setkey and setpubkey function. And also expose them as ALG_SET_KEY and ALG_SET_PUBKEY socket options for AF_ALG.

Regards

Marcel

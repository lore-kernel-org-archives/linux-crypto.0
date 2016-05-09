From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: pkcs1pad_verify_complete: decoding missing?
Date: Mon, 9 May 2016 11:15:04 -0700
Message-ID: <4de27b5e-e719-9fee-6441-858fb9198274@intel.com>
References: <5061410.3QzdTXsEjv@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:56843 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbcEISQJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 May 2016 14:16:09 -0400
In-Reply-To: <5061410.3QzdTXsEjv@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Strphan,
On 05/09/2016 03:24 AM, Stephan Mueller wrote:
> Hi,
> 
> I am experimenting with pkcs1pad(rsa-generic) signature verify. The following 
> numbers shall serve as examples -- using other valid signatures, similar 
> results are visible.
> 
> All signatures are correct.
> 
> The result of the signature verify operation is the following byte stream:
> 
> 3021300906052b0e03021a05000414ba3bc9c6fb57dfa3103e5991e8992d4387afa6f2d93e4f478d3cb74138b28cc5d1601f2bc549c2297e5bf76578fbaf5defe617748ac29f825aa974a56b7fdffe21f8d5c6abd7d9050525c60d94a36b3ce7a763af66b1ed501ebd0edd4b686a6bb8afd903c9ab97a60853fa7345fdd28fcc
> 
> The hash of the message is:
> 
> ba3bc9c6fb57dfa3103e5991e8992d4387afa6f2
> 
> 
> The hash of the message is embedded in the data stream returned by the 
> signature verify operation.
> 
> Looking at the first bytes of the data stream from the signature verify, it 
> looks like an ASN.1 sequence.
> 
> Looking into the function pkcs1pad_verify_complete, that suspicion is 
> confirmed: the padding is removed, but the decoding is not implemented. Shall 
> a caller implement the decoding?
> 
> If so, what is the purpose of the pkcs1pad implementation when only a part of 
> the sig ver is implemented?

Verify operation decrypts data provided in src, verifies, if the result has valid
padding and DER wrappings, strips the padding and wrapping and copies
the decrypted message to the dst. If padding or wrappings are not as expected
it returns -EBADMSG.
It is done in
https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/crypto/rsa-pkcs1pad.c#n517
see up to line #550

An example of how it is used can be found here:
https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/crypto/asymmetric_keys/public_key.c#n71

> 
> Looking into pkcs1pad_sign, I also do not see the BER encoding. Again, shall 
> the caller do that?

No, the sign operation prepends the padding and hash wrappings to the message
provided in src, encrypts the whole thing and returns the cipher text in the dst,
which is the opposite to what is done in verify.
Thanks,
-- 
TS

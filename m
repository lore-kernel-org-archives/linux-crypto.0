From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: Limited usefulness of RSA set key function
Date: Mon, 03 Aug 2015 10:52:28 -0700
Message-ID: <55BFAA5C.6010101@intel.com>
References: <BC087D1C-7D4D-4F6D-9644-B2043C3E39D3@holtmann.org> <3848823.PNN01JLIZu@tauon.atsec.com> <6876D9AA-A51A-4D79-9127-3B3ED58784CA@holtmann.org> <1580424.u6GEQiXd8T@myon.chronox.de> <2726A091-A7A2-451F-BB11-A19A73DA3C36@holtmann.org> <55BFA0B5.6070107@intel.com> <6C3A9837-2B02-4133-B916-40F0F1BAF51B@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>,
	David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:29929 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbbHCRxo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 13:53:44 -0400
In-Reply-To: <6C3A9837-2B02-4133-B916-40F0F1BAF51B@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/03/2015 10:39 AM, Marcel Holtmann wrote:
> I already have patches for that actually. The question is just which approach to take?
> 
> My current proposal is to separate the current crypto_akcipher_setkey into two functions. Use the crypto_akcipher_setkey for loading combined private and public key formats and crypto_akcipher_setpubkey for just loading the public key only format.

I would prefer to have one setkey function if possible.

> 
> One other option is actually for crypto_akcipher_setkey to use struct public_key from include/crypto/public_key.h. I mean we have this all defined. Why do we operate on binary blobs for the keys in the first place. For example if the key comes from a certificate in the keyring, lets just use that data. Most likely the asymmetric key type already decoded it nicely for us. No need to do this again.

That was the first proposal to use this struct, but it was rejected. Looks like MPIs are not acceptable on the API.
I think it make sense now as it will only be useful for the SW implementation. For hardware the easiest way is to take
it in this form.

> 
> I mean there is more than RSA out there and this would allow us to express struct public_key_algorithm in addition to the allowed applications of said key as well. This would properly also allow us to combine the crypto/asymmetric_keys/rsa.c and crypto/rsa.c so that we only have a single RSA implementation. Not to mention that we also have lib/digsig.c in the kernel.

The crypto/asymmetric_keys/ will be converted to the new api and crypto/asymmetric_keys/rsa.c removed soon.

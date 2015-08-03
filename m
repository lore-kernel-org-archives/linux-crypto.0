From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Limited usefulness of RSA set key function
Date: Mon, 3 Aug 2015 11:11:42 -0700
Message-ID: <3C8EA251-A1BB-40CA-AF38-134F814FFD59@holtmann.org>
References: <BC087D1C-7D4D-4F6D-9644-B2043C3E39D3@holtmann.org> <3848823.PNN01JLIZu@tauon.atsec.com> <6876D9AA-A51A-4D79-9127-3B3ED58784CA@holtmann.org> <1580424.u6GEQiXd8T@myon.chronox.de> <2726A091-A7A2-451F-BB11-A19A73DA3C36@holtmann.org> <55BFA0B5.6070107@intel.com> <6C3A9837-2B02-4133-B916-40F0F1BAF51B@holtmann.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:34217 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbbHCSLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 14:11:52 -0400
In-Reply-To: <6C3A9837-2B02-4133-B916-40F0F1BAF51B@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tadeusz,

>>> as you can clearly see. There are two formats defined here. There is no single ASN.1 structure that can decode both of these.
>>> 
>>> It is what it is, RSA Public Key and RSA Private Key formats are two different key formats. And OpenSSL also treats it like this. You can extract the public key from a private key (same way you can extract it from a certificate), but you can not create a private key structure that only contains the public key.
>>> 
>>> For RSA we need to support the two formats as listed above. To make this really easy from an API point of view, I would have setkey and setpubkey function. And also expose them as ALG_SET_KEY and ALG_SET_PUBKEY socket options for AF_ALG.
>> 
>> I'll have a look what will be the easiest way to get the openSSL generated & unmodified private key working.
> 
> I already have patches for that actually. The question is just which approach to take?
> 
> My current proposal is to separate the current crypto_akcipher_setkey into two functions. Use the crypto_akcipher_setkey for loading combined private and public key formats and crypto_akcipher_setpubkey for just loading the public key only format.
> 
> One other option is actually for crypto_akcipher_setkey to use struct public_key from include/crypto/public_key.h. I mean we have this all defined. Why do we operate on binary blobs for the keys in the first place. For example if the key comes from a certificate in the keyring, lets just use that data. Most likely the asymmetric key type already decoded it nicely for us. No need to do this again.

actually taking this one step further, why don't we integrate directly with the keys.

int crypto_akcipher_setkey(struct crypto_akcipher *tfm, struct key *key)

Or maybe key_ref_t or key_serial_t depending on what is the preferred method of referencing keys. So for every key loaded via the asymmetric key type, we can a have nice clean way to get the key from various different parts of the kernel and it is also reference counted.

It is also by definition cipher agnostic. So this would work for DSA, ECDH or whatever comes next. The only check needed is that the provided key is of type asymmetric and of subtype public key.

This means there is no need to parse it twice or store an extra copy of it or invent some new reference counting around struct public_key.

And then it would be dead simple to introduce ALG_SET_KEY_ID that takes a key_serial_t for usage with AF_ALG. I have implemented ALG_SET_KEY_ID for skcipher and it works great. However for akcipher this would show even more benefits. Especially when certificates and public keys come from the system keyring or via TPM / UEFI.

Regards

Marcel

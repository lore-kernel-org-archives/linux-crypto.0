From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Limited usefulness of RSA set key function
Date: Mon, 3 Aug 2015 11:20:06 -0700
Message-ID: <C0C27417-4970-48AF-A115-0C83DC000EBE@holtmann.org>
References: <BC087D1C-7D4D-4F6D-9644-B2043C3E39D3@holtmann.org> <3848823.PNN01JLIZu@tauon.atsec.com> <6876D9AA-A51A-4D79-9127-3B3ED58784CA@holtmann.org> <1580424.u6GEQiXd8T@myon.chronox.de> <2726A091-A7A2-451F-BB11-A19A73DA3C36@holtmann.org> <55BFA0B5.6070107@intel.com> <6C3A9837-2B02-4133-B916-40F0F1BAF51B@holtmann.org> <55BFAA5C.6010101@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Cc: David Howells <dhowells@redhat.com>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:50415 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbbHCSUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 14:20:12 -0400
In-Reply-To: <55BFAA5C.6010101@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tadeusz,

>> I already have patches for that actually. The question is just which approach to take?
>> 
>> My current proposal is to separate the current crypto_akcipher_setkey into two functions. Use the crypto_akcipher_setkey for loading combined private and public key formats and crypto_akcipher_setpubkey for just loading the public key only format.
> 
> I would prefer to have one setkey function if possible.
> 
>> 
>> One other option is actually for crypto_akcipher_setkey to use struct public_key from include/crypto/public_key.h. I mean we have this all defined. Why do we operate on binary blobs for the keys in the first place. For example if the key comes from a certificate in the keyring, lets just use that data. Most likely the asymmetric key type already decoded it nicely for us. No need to do this again.
> 
> That was the first proposal to use this struct, but it was rejected. Looks like MPIs are not acceptable on the API.
> I think it make sense now as it will only be useful for the SW implementation. For hardware the easiest way is to take
> it in this form.

actually I think this reasoning needs to be revisited. When I look at this, this makes no sense whatsoever. The end result is that we have keys in multiple formats in the kernel and have to convert between them or parse them again.

If you do not want to use struct public_key, then lets go for struct key as I proposed in my other response. That should in the end be able to represent hardware keys as well. There is really no good reason to move things around and parse them again or create new formats out of it.

My take is that we want to store a key once in a single location and single location only. Storing the same key in different formats in different locations is just a plain bad idea. Keep it secure and locked in one place.

>> I mean there is more than RSA out there and this would allow us to express struct public_key_algorithm in addition to the allowed applications of said key as well. This would properly also allow us to combine the crypto/asymmetric_keys/rsa.c and crypto/rsa.c so that we only have a single RSA implementation. Not to mention that we also have lib/digsig.c in the kernel.
> 
> The crypto/asymmetric_keys/ will be converted to the new api and crypto/asymmetric_keys/rsa.c removed soon.

I hope someone is looking at lib/digsig.c as well and gets this all cleaned up into a single implementation. However for this to happen, we really need to get this key stuff figured out. Right now this looks to me like the left hand does not know what the right hand is doing.

Regards

Marcel

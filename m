From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] crypto: Fix ASN.1 key handling for RSA akcipher
Date: Fri, 28 Aug 2015 08:44:37 -0700
Message-ID: <457F135F-5A3F-44DD-AA95-C68BB951F159@holtmann.org>
References: <1440739738-19587-1-git-send-email-marcel@holtmann.org> <1498436.tXns0NW3Yg@tauon.atsec.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41801 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbbH1Poo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Aug 2015 11:44:44 -0400
In-Reply-To: <1498436.tXns0NW3Yg@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

>> The RSA algorithm provides two ASN.1 key types. One for RSA Private Key
>> and another for RSA Public Key. Use these two already defined ASN.1
>> definitions instead of inventing a new one.
>> 
>> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
>> ---
>> crypto/Makefile           |  9 ++++++---
>> crypto/rsa_helper.c       | 13 +++++++++----
>> crypto/rsakey.asn1        |  5 -----
>> crypto/rsaprivatekey.asn1 | 13 +++++++++++++
>> crypto/rsapublickey.asn1  |  4 ++++
>> 5 files changed, 32 insertions(+), 12 deletions(-)
>> delete mode 100644 crypto/rsakey.asn1
>> create mode 100644 crypto/rsaprivatekey.asn1
>> create mode 100644 crypto/rsapublickey.asn1
>> 
>> diff --git a/crypto/Makefile b/crypto/Makefile
>> index 3cc91c3301c7..0b056c411aa7 100644
>> --- a/crypto/Makefile
>> +++ b/crypto/Makefile
>> @@ -31,10 +31,13 @@ obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
>> obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
>> obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
>> 
>> -$(obj)/rsakey-asn1.o: $(obj)/rsakey-asn1.c $(obj)/rsakey-asn1.h
>> -clean-files += rsakey-asn1.c rsakey-asn1.h
>> +$(obj)/rsapublickey-asn1.o: $(obj)/rsapublickey-asn1.c
>> $(obj)/rsapublickey-asn1.h +clean-files += rsapublickey-asn1.c
>> rsapublickey-asn1.h
>> 
>> -rsa_generic-y := rsakey-asn1.o
>> +$(obj)/rsaprivatekey-asn1.o: $(obj)/rsaprivatekey-asn1.c
>> $(obj)/rsaprivatekey-asn1.h +clean-files += rsaprivatekey-asn1.c
>> rsaprivatekey-asn1.h
>> +
>> +rsa_generic-y := rsapublickey-asn1.o rsaprivatekey-asn1.o
>> rsa_generic-y += rsa.o
>> rsa_generic-y += rsa_helper.o
>> obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
>> diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
>> index 8d96ce969b44..26617e3132fb 100644
>> --- a/crypto/rsa_helper.c
>> +++ b/crypto/rsa_helper.c
>> @@ -15,7 +15,8 @@
>> #include <linux/err.h>
>> #include <linux/fips.h>
>> #include <crypto/internal/rsa.h>
>> -#include "rsakey-asn1.h"
>> +#include "rsapublickey-asn1.h"
>> +#include "rsaprivatekey-asn1.h"
>> 
>> int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
>> 	      const void *value, size_t vlen)
>> @@ -109,9 +110,13 @@ int rsa_parse_key(struct rsa_key *rsa_key, const void
>> *key, int ret;
>> 
>> 	free_mpis(rsa_key);
>> -	ret = asn1_ber_decoder(&rsakey_decoder, rsa_key, key, key_len);
>> -	if (ret < 0)
>> -		goto error;
>> +	ret = asn1_ber_decoder(&rsapublickey_decoder, rsa_key, key, key_len);
>> +	if (ret < 0) {
>> +		ret = asn1_ber_decoder(&rsaprivatekey_decoder, rsa_key,
>> +				       key, key_len);
> 
> 
> Wouldn't it be better to have 2 parse_key functions here? We (will) have 2 
> setkey functions which are the callers of parse_key.

I am no longer convinced that two setkey function will actually help. The RSA Private Key data structure contains the public and private key. And the RSA Public Key data structure contains just the private key.

> The reason is that the added if requires CPU cycles that can be easily 
> avoided.
> 
> Hence I propose:
> 
> rsa_parse_pubkey()
> 	rsapublickey_decoder
> 
> rsa_parse_privkey()
> 	rsaprivatekey_decoder
> 
> to avoid parsing a key as pub key even though we already know it is a priv 
> key.

If we really care about CPU cycles when setting the key, then we should not even be discussing ASN.1 parsing here. I think we really need to add support for setkeyid callback and use struct key / key serial to reference a given key.

This whole parsing of DER over and over again is a bad API design anyway. The kernel has a keys subsystem that knows how to handle asymmetric keys and parse key credentials out of it. Especially akcipher should learn how to use these keys.

It is also the only real way to unify the existing RSA implementations and allowing future asymmetric ciphers like ECC to utilize this correctly. I mean, we really need to stop handing DER encoded keys around. The amount of encoding and decoding that needs to be done in the kernel is the real waste of CPU cycles.

Regards

Marcel

From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] crypto: Fix ASN.1 key handling for RSA akcipher
Date: Fri, 28 Aug 2015 17:54:26 -0700
Message-ID: <C966DBDA-0161-4523-A705-43D96C7B8A04@holtmann.org>
References: <1440739738-19587-1-git-send-email-marcel@holtmann.org> <55E0EB89.6050800@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:56409 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbbH2Ayf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Aug 2015 20:54:35 -0400
In-Reply-To: <55E0EB89.6050800@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tadeusz,

>> +++ b/crypto/rsaprivatekey.asn1
>> @@ -0,0 +1,13 @@
>> +RSAPrivateKey ::= SEQUENCE {
>> +	version		Version,
>> +	modulus		INTEGER ({ rsa_get_n }),	-- n
>> +	publicExponent	INTEGER ({ rsa_get_e }),	-- e
>> +	privateExponent	INTEGER ({ rsa_get_d }),	-- d
>> +	prime1		INTEGER,			-- p
>> +	prime2		INTEGER,			-- q
>> +	exponent1	INTEGER,			-- d mod (p-1)
>> +	exponent2	INTEGER,			-- d mod (q-1)
>> +	coefficient	INTEGER				-- (inverse of q) mod p
>> +}
>> +
>> +Version ::= INTEGER
> 
> If you want to do this you should also update the existing RSA test vectors, because
> they are failing after this patch is applied.

the test vectors have been failing no matter what. The crypto/rsakey.asn1 is actually broken as I explained in previous emails. That the ASN.1 parser accepted the test vectors was a bug which has been fixed now.

> The reason is that there is no version in the private keys in crypto/testmgr.h
> And the QAT RSA implementation should also be updated so they are consistent.

The QAT code should be updated indeed, but honestly I am still maintaining the case that akcipher should just only operate on setkeyid with struct key / key serial and some ASN.1 blob that we have to decode and recode all the time.

> I have already started to do the changes proposed for the akcipher api to add SGLs
> support and to split the set_key for set_publickey and set_privatekey so I will
> take care of this.

I am not in favor of just hacking in this split until the semantics are actually understood. As said, the right solution from my point of view is to remove setkey from akcipher and replace it with setkeyid instead.

Remember that a private key contains the public key as well. Meaning operations are mutually exclusive. And there is really no point in forcing the caller to split things into two. With asymmetric cryptography you either have private and public key or you just have the public key. The case where you only have the private key is pointless.

We could keep the setkey as it is to load the private + public key information and add an extra setpubkey for loading only the public key. Then again a setkeyid would solve both of these problems since the key material would be nicely represented in a struct key.

However we actually want to load the keys into the asymmetric key type and use it from there. The asymmetric key type should be the only entity that has to deal with ASN.1 encoding. Having an akcipher deal with ASN.1 is just wrong.

What we really want is to be able to use keys from certificates to verify and encrypt information. And we want this all in one single place and not duplicate this whole ASN.1 stuff in the keys subsystem and the crypto subsystem. This means I am strongly against trying to add setkey, setpubkey, setcert, setkeychain or whatever else you might need when it comes to akcipher. There is one thing that is needed and that is setkeyid and have to reference the key serial from the keys subsystem.

Regards

Marcel

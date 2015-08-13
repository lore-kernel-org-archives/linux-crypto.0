From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 1/2] crypto: KEYS: convert public key to the akcipher
 API
Date: Thu, 13 Aug 2015 09:47:39 -0700
Message-ID: <55CCCA2B.2000003@intel.com>
References: <20150813035439.25108.62457.stgit@tstruk-mobl1> <20150813035433.25108.3065.stgit@tstruk-mobl1> <10795.1439475796@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5889 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbbHMQtD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 12:49:03 -0400
In-Reply-To: <10795.1439475796@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/13/2015 07:23 AM, David Howells wrote:
> Tadeusz Struk <tadeusz.struk@intel.com> wrote:
> 
>>  const char *const pkey_algo_name[PKEY_ALGO__LAST] = {
>> -	[PKEY_ALGO_DSA]		= "DSA",
>> -	[PKEY_ALGO_RSA]		= "RSA",
>> +	[PKEY_ALGO_DSA]		= "dsa",
>> +	[PKEY_ALGO_RSA]		= "rsa",
>>  };
> 
> Be aware that these are exposed to userspace through /proc.  The change
> probably doesn't matter, but you might need to update the documentation.
> 
>> +int public_key_verify_signature(const struct public_key *pkey,
>>  				const struct public_key_signature *sig)
>>  {
>> ...
>> -	return algo->verify_signature(pk, sig);
>> +	return rsa_pkcs1_v1_5_verify_signature(pkey, sig);
>>  }
> 
> No.  You can't assume RSA here.  It's quite likely we'll have to support ECDSA
> or similar soon.  This must be contingent on the algorithm selected.
> 
>>  {
>>  	const struct public_key *pk = key->payload.data;
>> +
>>  	return public_key_verify_signature(pk, sig);
>>  }
> 
> That's nothing to do with this patch.
> 
>> +static int rsa_signture_verify(const u8 *H, const u8 *EM, size_t k,
> 
> 'signture' -> 'signature'.
> 
>> +/*
>> + * Perform the RSA signature verification.
>> + * @H: Value of hash of data and metadata
>> + * @EM: The computed signature value
>> + * @k: The size of EM (EM[0] is an invalid location but should hold 0x00)
>> + * @hash_size: The size of H
>> + * @asn1_template: The DigestInfo ASN.1 template
>> + * @asn1_size: Size of asm1_template[]
>> + */
>> +static int rsa_signture_verify(const u8 *H, const u8 *EM, size_t k,
>> +			       size_t hash_size, const u8 *asn1_template,
>> +			       size_t asn1_size)
>> +{
> 
> Why is this here and not in crypto/rsa.c?
> 
>> +	/* initlialzie out buf */
> 
> 'initialise'.
> 
>> -	/* Decode the public key */
>> -	ret = asn1_ber_decoder(&x509_rsakey_decoder, ctx,
>> -			       ctx->key, ctx->key_size);
>> -	if (ret < 0)
>> +	cert->pub->key = kmemdup(ctx->key, ctx->key_size, GFP_KERNEL);
>> +	if (!cert->pub->key)
>>  		goto error_decode;
> 
> The generic public key code should *not* see the container wrappings (ASN.1
> from an X.509 cert in this case).  The public key could be supplied by OpenPGP
> instead, for example, or directly by a driver.
> 
> Further, at this point, we need to make sure that the data we were given has
> the right bits and emit EBADMSG if it doesn't.
> 
> Okay, I can accept that the public_key struct might just have a list of void *
> and size_t fields that get filled in, one for each integer that we extract
> rather than MPIs, but we should not expose the generic code to the stuff we've
> parsed away.
> 
>>  struct public_key {
>> -	const struct public_key_algorithm *algo;
>> -	u8	capabilities;
>> -#define PKEY_CAN_ENCRYPT	0x01
>> -#define PKEY_CAN_DECRYPT	0x02
>> -#define PKEY_CAN_SIGN		0x04
>> -#define PKEY_CAN_VERIFY		0x08
> 
> You still need the capabilities.  The X.509 certificate and the OpenPGP
> message indicate restrictions on the key that we need to honour.

Thanks David for all your feedback. I'll rework it according to your comments.
Regards,
T 

From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/4] crypto: kdf - SP800-108 Key Derivation Function
Date: Tue, 26 Jan 2016 14:20:48 +0100
Message-ID: <2697635.0NlC1kamfF@tauon.atsec.com>
References: <4445045.XP4c23S4mB@positron.chronox.de> <6838062.nWpazeNV2T@positron.chronox.de> <20160126102814.GA19419@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42548 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbcAZNUu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 08:20:50 -0500
In-Reply-To: <20160126102814.GA19419@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 26. Januar 2016, 18:28:14 schrieb Herbert Xu:

Hi Herbert,

>On Tue, Jan 26, 2016 at 07:20:59AM +0100, Stephan Mueller wrote:
>> +/*
>> + * Implementation of the KDF in counter mode according to SP800-108
>> section 5.1. + *
>> + * The caller must provide Label || 0x00 || Context in src. This src
>> pointer + * may also be NULL if the caller wishes not to provide anything.
>> + */
>> +static int crypto_kdf_ctr_random(struct crypto_rng *rng,
>> +				 const u8 *src, unsigned int slen,
>> +				 u8 *dst, unsigned int dlen)
>> +{
>> +	struct crypto_kdf_ctx *ctx = crypto_tfm_ctx(crypto_rng_tfm(rng));
>> +	struct shash_desc *desc = &ctx->shash;
>> +	unsigned int h = crypto_shash_digestsize(desc->tfm);
>> +	int err = 0;
>> +	u8 *dst_orig = dst;
>> +	u32 i = 1;
>> +	u8 iteration[sizeof(u32)];
>> +
>> +	/* enforce the note from above */
>> +	if (dlen != h && src == dst)
>> +		return -EINVAL;
>
>Why is this an RNG? It always produces exactly h bytes so it looks
>like a hash function to me, no?

It generates an arbitrary number of bytes like an RNG -- see dlen. The check 
you quote here is only for the special case where the caller wants exactly h 
bytes where he can have an in-place cipher operation.

When he wants to generate more data, then we cannot have dst and src pointing 
to the same location. We have multiple loops we always require the use of the 
original src data. Thus, when we have multiple loops, src would be overwritten 
in the first loop iteration which means that with the second loop iteration, 
we would not be compliant to the spec any more.

Ciao
Stephan

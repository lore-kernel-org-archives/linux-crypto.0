From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC PATCH] crypto: prevent helper ciphers from being allocated by users
Date: Tue, 17 Mar 2015 12:40:12 +0100
Message-ID: <1442292.caf3IdtESe@tauon>
References: <13986065.EbkBp8M36a@tachyon.chronox.de> <20150317112350.GA11671@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46696 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbbCQLk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2015 07:40:56 -0400
In-Reply-To: <20150317112350.GA11671@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 17. M=E4rz 2015, 22:23:50 schrieb Herbert Xu:

Hi Herbert,

>On Fri, Mar 13, 2015 at 10:09:21PM +0100, Stephan Mueller wrote:
>> +struct crypto_tfm *__crypto_alloc_tfm_safe(struct crypto_alg *alg,
>> u32 type, +					   u32 mask)
>> +{
>> +	/*
>> +	 * Prevent all ciphers from being loaded which have a=20
cra_priority
>> +	 * of 0. Those cipher implementations are helper ciphers and
>> +	 * are not intended for general consumption.
>> +	 *
>> +	 * The only exceptions are the compression algorithms which
>> +	 * have no priority.
>> +	 */
>> +	if (!alg->cra_priority &&
>> +	    ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) !=3D
>> +	      CRYPTO_ALG_TYPE_PCOMPRESS) &&
>> +	    ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) !=3D
>> +	      CRYPTO_ALG_TYPE_COMPRESS))
>> +		return ERR_PTR(-ENOENT);
>
>How about adding a flag to all these internal algorithms and then
>change crypto_alg_mod_lookup to disable that flag by default?

The issue with flags is the following: first we have to think about=20
whether we want a black list or white list approach. Your suggestion=20
implies a black list. Black lists for ensuring security is not good IMH=
O=20
as it has a tendency to miss cases. This especially applies to this are=
a=20
where we have already an indicator for internal ciphers: the prio is so=
=20
low that it will never ever be selected based on the name. Now, adding =
a=20
flag means that we mark such an internal cipher twice.

Therefore, I would not opt for such a flag (at least for a black list)=20
and stay with the prio approach.

Ciao
Stephan

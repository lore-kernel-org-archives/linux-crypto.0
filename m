From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Alignment in the API, once again
Date: Thu, 2 Aug 2007 09:41:22 +0200
Message-ID: <20070802074122.GA22601@Chamillionaire.breakpoint.cc>
References: <20070801230240.GA18744@Chamillionaire.breakpoint.cc> <20070802023006.GA10180@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36341 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbXHBHl0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 03:41:26 -0400
Content-Disposition: inline
In-Reply-To: <20070802023006.GA10180@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-08-02 10:30:06 [+0800]:

>> I noticed this, after my code did not work properly. The reason was,
>> that my private ctx was not retrieved with
>> crypto_ablkcipher_ctx_aligned() (attached) but with
>> crypto_ablkcipher_ctx() (and it was not properly aligned anymore).
>> My fault right? 
>
>Yeah if your ctx needs to be aligned you need to use
>crypto_tfm_ctx_aligned.

Okey this makes sense. What about crypto_ctxsize()? Isn't a bug there?
I can't specify an alignmask of 16 (what I assumed yesterday after a
part of brain switched to sleep()) because this brakes the ALIGN()
macro. Isn't something like

--- a/crypto/api.c
+++ b/crypto/api.c
@@ -273,7 +273,7 @@ static unsigned int crypto_ctxsize(struc
 	const struct crypto_type *type_obj = alg->cra_type;
 	unsigned int len;
 
-	len = alg->cra_alignmask & ~(crypto_tfm_ctx_alignment() - 1);
+	len = alg->cra_alignmask | (crypto_tfm_ctx_alignment() -1)
 	if (type_obj)
 		return len + type_obj->ctxsize(alg, type, mask);
 
----
required? VIA's PadLock driver uses manully ALIGN() instead of
crypto_.*_ctx_aligned() to do this. Therefore it will overwrite memory
or am I overlooking something?

>> --- a/include/crypto/algapi.h
>> +++ b/include/crypto/algapi.h
>> @@ -160,6 +160,11 @@ static inline void *crypto_ablkcipher_ct
>>  	return crypto_tfm_ctx(&tfm->base);
>>  }
>>  
>> +static inline void *crypto_ablkcipher_ctx_aligned(struct crypto_ablkcipher *tfm)
>> +{
>> +	return crypto_tfm_ctx_aligned(&tfm->base);
>> +}
>> +
>>  static inline struct crypto_blkcipher *crypto_spawn_blkcipher(
>>  	struct crypto_spawn *spawn)
>
>Looks good.  Could you add a description and sign-off?

Yes, no problem.

Sebastian

From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3] crypto: remove instance when test failed
Date: Thu, 09 Apr 2015 11:22:19 +0200
Message-ID: <9590265.Rdkakn8z8k@tauon>
References: <1461449.htSjBpksos@tachyon.chronox.de> <20150409074141.GA4394@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34045 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885AbbDIJW0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 05:22:26 -0400
In-Reply-To: <20150409074141.GA4394@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 9. April 2015, 15:41:41 schrieb Herbert Xu:

Hi Herbert,

>On Thu, Apr 09, 2015 at 09:36:03AM +0200, Stephan Mueller wrote:
>> diff --git a/crypto/algapi.c b/crypto/algapi.c
>> index f1d0307..cfca1de 100644
>> --- a/crypto/algapi.c
>> +++ b/crypto/algapi.c
>> @@ -533,6 +533,13 @@ int crypto_register_instance(struct crypto_template
>> *tmpl,> 
>>  	if (IS_ERR(larval))
>>  	
>>  		goto unlock;
>> 
>> +	err = -EAGAIN;
>> +	if (unlikely(!crypto_mod_get(&inst->alg))) {
>> +		up_write(&crypto_alg_sem);
>> +		crypto_unregister_instance(inst);
>> +		goto err;
>> +	}
>
>Just grab the reference count as soon as you enter the function
>and then you can unconditionally drop the reference count at the
>end.  If you fail to grab it then just return an error and the
>caller will free it for you.

I tested it and this approach does not work.

If I see that right, the reason for that is the following: The suggestion is 
to grab the ref count at the start of the function followed by a 
__crypto_register_alg. __crypto_register_alg however sets the refcount to 1 
unconditionally. That means that the final put of the alg will most likely set 
the refcount to 0 that causes an issue with all other operations (at least I 
cannot allocate HMAC or CMAC any more -- the ones I currently test).

So, the grabing of the alg must happen after the invocation of 
__crypto_register_alg.
>
>Cheers,


Ciao
Stephan

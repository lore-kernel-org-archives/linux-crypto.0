From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: alignmask in the API
Date: Wed, 9 May 2007 09:05:53 +0200
Message-ID: <20070509070553.GB21679@Chamillionaire.breakpoint.cc>
References: <20070416212400.GA30547@Chamillionaire.breakpoint.cc> <E1HdgLJ-0004iw-00@gondolin.me.apana.org.au> <20070508171701.GB5234@Chamillionaire.breakpoint.cc> <20070509034024.GA32283@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41904 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967872AbXEIHF6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 May 2007 03:05:58 -0400
Content-Disposition: inline
In-Reply-To: <20070509034024.GA32283@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-05-09 13:40:24 [+1000]:

>On Tue, May 08, 2007 at 07:17:01PM +0200, Sebastian Siewior wrote:
>> 
>> setkey() is for crypto user is defined as:
>> static inline int crypto_ablkcipher_setkey(struct crypto_ablkcipher
>>                 *tfm,
>>                 const u8 *key, unsigned int keylen)
>> {
>>         return crypto_ablkcipher_crt(tfm)->setkey(tfm, key, keylen);
>> }
>> 
>> If the key is not properly aligned by the caller, the cipher gets an
>> unaligned key.
>> What do you recommend?
>
>I recommend that you write a patch :)
Okey.

>We just need some code in {cipher,blkcipher,ablkcipher}.c to check the
>alignment and copy it if necessary.  Check out how we deal with unaligned
>IVs in blkcipher.c for example.
Will check.

>Cheers,
Sebastian

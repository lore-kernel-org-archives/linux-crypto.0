From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [patch] [CRYPTO] add alignment for setkey()
Date: Fri, 18 May 2007 15:43:41 +0200
Message-ID: <20070518134341.GA16349@Chamillionaire.breakpoint.cc>
References: <20070510095717.GD26502@Chamillionaire.breakpoint.cc> <20070518063001.GA16171@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44008 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754497AbXERNnr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 May 2007 09:43:47 -0400
Content-Disposition: inline
In-Reply-To: <20070518063001.GA16171@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-05-18 16:30:01 [+1000]:

>> +static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen,
>> +		unsigned long alignmask)
>> +{
>> +	struct cipher_alg *cia = &tfm->__crt_alg->cra_cipher;
>> +	u8 buffer[keylen + alignmask];
>
>Hmm, I'm not comfortable with this since keylen could be unbounded,
>especially for hash algorithms.  How about getting the memory via
>kmalloc instead?
Good point. I take kmalloc() with GFP_KERNEL (the caller should not be
atomic at this point). Additionaly I zero the temporary key (I don't
think the setkey() path is performace critical).

>Cheers,
Sebastian

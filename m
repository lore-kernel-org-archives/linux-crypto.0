From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [Patch] [CRYPTO] add alignment for setkey() (rev 2)
Date: Sat, 19 May 2007 11:18:40 +0200
Message-ID: <20070519091840.GA23688@Chamillionaire.breakpoint.cc>
References: <20070518140130.GB16349@Chamillionaire.breakpoint.cc> <20070519074136.GA6281@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46494 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496AbXESJSq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 May 2007 05:18:46 -0400
Content-Disposition: inline
In-Reply-To: <20070519074136.GA6281@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-05-19 17:41:36 [+1000]:

>I think we should stick with GFP_ATOMIC for now.  Once all the atomic
>users have been fixed (if they can be), then we can start changing this
>interface.
okey. 

>> +static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen,
>> +		unsigned long alignmask)
>
>Minor nit.  Could you get rid of the alignmask parameter here and just
>read it again from tfm? This should make it easier for certain compiler/
>arch combos to generate a tail call.
sure

>> +	if ((unsigned long) key & alignmask)
>
>Please kill the space before key.
okey.

>Thanks,
Sebastian

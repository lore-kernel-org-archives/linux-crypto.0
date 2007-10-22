From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC 4/5] [crypto] geode: add fallback for unsupported modes.
Date: Mon, 22 Oct 2007 19:30:06 +0200
Message-ID: <20071022173006.GA16319@Chamillionaire.breakpoint.cc>
References: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc> <1192788233-14968-5-git-send-email-linux-crypto@ml.breakpoint.cc> <20071021083158.GD9397@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:39063 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584AbXJVRaH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Oct 2007 13:30:07 -0400
Content-Disposition: inline
In-Reply-To: <20071021083158.GD9397@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-21 16:31:58 [+0800]:

>> +	if (type == CRYPTO_ALG_TYPE_BLKCIPHER) {
>> +		op->fallback.blk = crypto_alloc_blkcipher(name, 0,
>> +				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
>> +
>> +	} else if (type == CRYPTO_ALG_TYPE_CIPHER) {
>> +		op->fallback.cip = crypto_alloc_cipher(name, 0,
>> +				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
>> +	} else {
>> +		printk(KERN_ERR "%s is neither a cipher nor a block cipher: %x\n",
>> +				name, type);
>> +		return -EINVAL;
>> +	}
>
>This looks really icky though.  Couldn't we just have different
>functions for each case (blkcipher vs. cipher)?
will take look.

>
>>  static struct crypto_alg geode_ecb_alg = {
>>  	.cra_name		=	"ecb(aes)",
>> -	.cra_driver_name	=	"ecb-aes-geode-128",
>> -	.cra_priority		=	400,
>> -	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
>> +	.cra_driver_name	=	"ecb-aes-geode",
>> +	.cra_priority		=	300,
>
>What's with the priority decrease?
I don't know. I probably though lets make it 300 like the other one :).
Will revert.

>Cheers,
Sebastian

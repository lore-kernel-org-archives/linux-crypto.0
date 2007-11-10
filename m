From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [patch 2/2] remove similar aes glue code
Date: Sat, 10 Nov 2007 22:20:00 +0100
Message-ID: <20071110212000.GC15150@Chamillionaire.breakpoint.cc>
References: <20071102180503.712394234@ml.breakpoint.cc> <20071102181036.701800933@ml.breakpoint.cc> <20071110111955.GB5485@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46829 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163AbXKJVUB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Nov 2007 16:20:01 -0500
Content-Disposition: inline
In-Reply-To: <20071110111955.GB5485@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-11-10 19:19:55 [+0800]:

>On Sat, Nov 03, 2007 at 11:05:03AM +0100, Sebastian Siewior wrote:
>>
>>  static struct crypto_alg aes_alg = {
>> -	.cra_name		=	"aes",
>> -	.cra_driver_name	=	"aes-x86_64",
>> +	.cra_name			=	"aes",
>> +	.cra_driver_name	=	"aes-asm",
>
>This is bad because the algorithm name no longer matches the module
>name.
This is case for every aes driver after I renamed them. Or am I missing
something? You are not talking about cra_drive_name are you?

>I suppose we could rename the modules too, or perhaps just
>add an alias?

We can't rename the asm optimized module to aes.ko. Well we could but
this might be little ugly since we allready haven an alias for AES
provided by the generic algorithm (on which this algorithm depends on).
If you are talking about adding an alias which one should it be?
We allready have an AES alias in the glue code.

>Cheers,

Sebastian

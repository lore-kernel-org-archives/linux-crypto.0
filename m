From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [patch 2/2] remove similar aes glue code
Date: Mon, 26 Nov 2007 10:35:00 +0100
Message-ID: <20071126093500.GD18309@Chamillionaire.breakpoint.cc>
References: <20071102180503.712394234@ml.breakpoint.cc> <20071102181036.701800933@ml.breakpoint.cc> <20071110111955.GB5485@gondor.apana.org.au> <20071110212000.GC15150@Chamillionaire.breakpoint.cc> <20071111011856.GA10745@gondor.apana.org.au>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37113 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961AbXKZJfC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 04:35:02 -0500
Content-Disposition: inline
In-Reply-To: <20071111011856.GA10745@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-11-11 09:18:56 [+0800]:

>On Sat, Nov 10, 2007 at 10:20:00PM +0100, Sebastian Siewior wrote:
>> * Herbert Xu | 2007-11-10 19:19:55 [+0800]:
>> 
>> >On Sat, Nov 03, 2007 at 11:05:03AM +0100, Sebastian Siewior wrote:
>> >>
>> >>  static struct crypto_alg aes_alg = {
>> >> -	.cra_name		=	"aes",
>> >> -	.cra_driver_name	=	"aes-x86_64",
>> >> +	.cra_name			=	"aes",
>> >> +	.cra_driver_name	=	"aes-asm",
>> >
>> >This is bad because the algorithm name no longer matches the module
>> >name.
>> This is case for every aes driver after I renamed them. Or am I missing
>> something? You are not talking about cra_drive_name are you?
>
>I meant the cra_driver_name.  Both names can be used to find
>the algorithm.
I checked it and cra_driver_name is only used for compare. I think you
could use something like "cbc(aes-asm)" but this would only work on x86.
Is there something I am overlooking?
I have no problem with adding another alias but atleast I would like
understand it :)
>
>Thanks,

Sebastian

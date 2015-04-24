From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Fri, 24 Apr 2015 02:22:15 +0200
Message-ID: <1631170.dsiKAyPJ3M@tauon>
References: <6218629.uO4632Hmli@myon.chronox.de> <2261126.vD1ovnGobO@myon.chronox.de> <20150423232105.GC26635@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.atsec.com ([195.30.99.214]:50464 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbbDXAbv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 20:31:51 -0400
Received: from mail.atsec.com (localhost [127.0.0.1])
	by mail.atsec.com (Postfix) with ESMTP id 37C8121B14
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2015 02:22:22 +0200 (CEST)
In-Reply-To: <20150423232105.GC26635@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 24. April 2015, 07:21:05 schrieb Herbert Xu:

Hi Herbert,

>On Thu, Apr 23, 2015 at 03:42:19PM +0200, Stephan Mueller wrote:
>> Now, shall I kind of re-implement the chainiv ablkcipher wrapper into an IV
>> handler that just helps my code? That will be a lot of code for a simple
>> memcmp.
>
>No no no.  You don't need to do a template for givencrypt.  chainiv
>is a template because it can be used by any blkcipher.  In your case
>your fixed IV is only used by you.  So just implement givencrypt and
>givdecrypt directly in your blkcipher (or ablkcipher rather because
>only ablkcipher supports givencrypt/givdecrypt).
>
>If you really want to keep the underlying kw as a blkcipher for the
>sake of simplicity you could go back to the wrapper idea and have
>the rfc wrapper around kw as an ablkcipher so that you can add the
>givencrypt/givdecrypt calls.

For the moment, I was working on the following approach:

- kw() as blkcipher (like ctr()

- implement a kwiv geniv handler and use it by kw via:

	inst->alg.cra_blkcipher.geniv = "kwiv";



So, if I read your recommendation right, I would do the following:

- kw() as blkcipher (like the ctr())

- rfc3394() as ablkcipher around kw (like rfc3686())

I also have the givencrypt and givdecrypt functions. How would I directly hook 
them into the ablkcipher without using a reference for inst-
>alg.cra_ablkcipher.geniv?


Which approach would fit best?


Ciao
Stephan

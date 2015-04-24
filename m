From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Fri, 24 Apr 2015 08:24:07 +0800
Message-ID: <20150424002407.GA27121@gondor.apana.org.au>
References: <6218629.uO4632Hmli@myon.chronox.de>
 <2261126.vD1ovnGobO@myon.chronox.de>
 <20150423232105.GC26635@gondor.apana.org.au>
 <1631170.dsiKAyPJ3M@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37146 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934223AbbDXAYJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 20:24:09 -0400
Content-Disposition: inline
In-Reply-To: <1631170.dsiKAyPJ3M@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 24, 2015 at 02:22:15AM +0200, Stephan Mueller wrote:
>
> I also have the givencrypt and givdecrypt functions. How would I directly hook 
> them into the ablkcipher without using a reference for inst-
> >alg.cra_ablkcipher.geniv?

ablkcipher itself has givencrypt/givdecrypt so you don't need
an instance.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

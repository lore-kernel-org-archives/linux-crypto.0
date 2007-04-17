From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: alignmask in the API
Date: Tue, 17 Apr 2007 15:35:05 +1000
Message-ID: <E1HdgLJ-0004iw-00@gondolin.me.apana.org.au>
References: <20070416212400.GA30547@Chamillionaire.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: linux-crypto@ml.breakpoint.cc (Sebastian Siewior)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2581 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753975AbXDQFfJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 01:35:09 -0400
In-Reply-To: <20070416212400.GA30547@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sebastian Siewior <linux-crypto@ml.breakpoint.cc> wrote:
> The API allows to set an align mask. This mask is considered on the
> allocation of cipher's private ctx and the IV (for block cipher). This
> mask is ignored in the setkey function (what is fine with me). 
> encrypt() and decrypt() functions get their data through a scatterlist.
> Is my understanding correct that I can't assume any alignment of the
> input / output data? If so, is it fungible to modify the caller's code
> to respect the aligmask?

It's the API's responsibility to guarantee alignment.  So in principle
neither the user nor the algorithm need to worry about alignment.

However, for the sake of performance, the user should take care of
alignment where it is easy to do.  For instance, if you have to
allocate memory for an IV or src/dst as a crypto user, you should
try to get something that's aligned properly.

However, there is no point in doing an extra copy for the sake of
alignment since the crypto API will do it for you anyway.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

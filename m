From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] [1/1] skeleton for async crypto drivers
Date: Fri, 25 May 2007 16:49:18 +1000
Message-ID: <E1HrTby-0006uF-00@gondolin.me.apana.org.au>
References: <20070522152848.GC32493@Chamillionaire.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: linux-crypto@ml.breakpoint.cc (Sebastian Siewior)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2598 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752045AbXEYGtW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2007 02:49:22 -0400
In-Reply-To: <20070522152848.GC32493@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sebastian Siewior <linux-crypto@ml.breakpoint.cc> wrote:
> 
> Currently the crypto driver has to allocate a structure in order to
> remember later whether encrypt or decrypt is requested. 
> Isn't it better to add a operation field into the request struct which
> contains the requested operation (set but the crypto user)? This would
> then replace encrypt & decrypt function with a crypt function which
> queues the request.

No doubt that you have to allocate it one way or another.  Not
allocating it explicitly means that you have the freedom of
representing it in the most convenient fashion.  For example,
the cryptd module represents it using a function pointer.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

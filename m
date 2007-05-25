From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 25 May 2007 21:03:14 +1000
Message-ID: <20070525110314.GB28366@gondor.apana.org.au>
References: <20070523080354.GA19665@2ka.mipt.ru> <E1HrV37-00076a-00@gondolin.me.apana.org.au> <20070525090004.GB3808@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto@ml.breakpoint.cc
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4056 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751470AbXEYLDQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2007 07:03:16 -0400
Content-Disposition: inline
In-Reply-To: <20070525090004.GB3808@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 25, 2007 at 01:00:05PM +0400, Evgeniy Polyakov wrote:
> 
> I think that would be good to have set of functions like
> struct crypto_alg alloc_crypto_alg(char *name, setkey_callback,
> encrypt/decrypt callbacks);
> I will put them into driver initially for testing purposes, later
> we could move them into generic code to be reused.

I completely agree.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

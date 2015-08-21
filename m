From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: skcipher - Add top-level skcipher interface
Date: Fri, 21 Aug 2015 17:27:54 +0800
Message-ID: <20150821092754.GA6854@gondor.apana.org.au>
References: <20150820072055.GA27176@gondor.apana.org.au>
 <E1ZSKAT-00075n-MI@gondolin.me.apana.org.au>
 <3197252.zpooAnFuUp@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51133 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbbHUJ16 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 05:27:58 -0400
Content-Disposition: inline
In-Reply-To: <3197252.zpooAnFuUp@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 21, 2015 at 11:24:08AM +0200, Stephan Mueller wrote:
> 
> If I understand the patch set correctly, a caller uses the skcipher API and 
> the API sets up the synchronous or asynchronous callbacks depending on the 
> chosen cipher implementation.
> 
> Now, does a caller always need to create an skcipher_request and always need 
> the async logic of providing a callback function and the like, even though a 
> synchronous cipher is chosen? I.e. the caller has no means to use a 
> synchronous cipher operation any more.
> 
> It looks to me like that, but I would like to confirm.

No you can still use it synchronously.  When allocating it you
should do this:

	crypto_alloc_skcipher(name, 0, CRYPTO_ALG_ASYNC)

When setting up the request just leave the callback and data as
NULL.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

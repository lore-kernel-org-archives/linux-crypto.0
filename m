From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/2] crypto: engine - Permit to enqueue skcipher
 request
Date: Mon, 21 Aug 2017 23:07:32 +0800
Message-ID: <20170821150732.GA3644@gondor.apana.org.au>
References: <20170606134417.18850-1-clabbe.montjoie@gmail.com>
 <20170606134417.18850-3-clabbe.montjoie@gmail.com>
 <20170619052707.GA13180@gondor.apana.org.au>
 <20170619075524.GA27419@Red>
 <20170623064837.GA29139@gondor.apana.org.au>
 <20170714111536.GA30440@Red>
 <20170728135257.GE21401@gondor.apana.org.au>
 <20170728150119.GD7221@Red>
 <20170809094012.GC7137@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57998 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753446AbdHUPHq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2017 11:07:46 -0400
Content-Disposition: inline
In-Reply-To: <20170809094012.GC7137@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 09, 2017 at 11:40:12AM +0200, Corentin Labbe wrote:
>
> I really didnt see how to do that since cra_type is const.
> Anyway, I think it cannot be possible since we could have two different engine with two different prepare_request().
> 
> I will really appreciate any advice on what you want exactly.

The issue is that we have these handlers such as prepare_request
that gives us a level of indirection into the driver.  However,
on top of those we're adding another level of indirection based
on the type of request.

I'd like to see these two combined into just a single function
pointer.

My idea of using cra_type is indeed broken as these functions
ultimately live in the driver and not crypto API.

So how about something like this:

struct crypto_engine_op {
	int (*prepare_request)(struct crypto_engine *engine,
			       struct crypto_async_request *req);
	int (*unprepare_request)(struct crypto_engine *engine,
				 struct crypto_async_request *req);
	int (*do_one_request)(struct crypto_engine *engine,
			      struct crypto_async_request *req);
};

struct crypto_engine_reqctx {
	struct crypto_engine_op *op;
};	

struct crypto_engine {
	struct crypto_engine_op aead;
	struct crypto_engine_op hash;
	struct crypto_engine_op cipher;

	...
};

Then in the request_to_engine functions you would store the right
op pointer inside the request context area.  Obviously the users
of crypto_engine would need to allocate space for the struct
crypto_engine_reqctx in their reqctx structure.

The only wart with this scheme is that the drivers end up seeing
struct crypto_async_request and will need to convert that to the
respective request types but I couldn't really find a better way.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

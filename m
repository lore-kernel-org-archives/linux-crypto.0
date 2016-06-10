From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v3 1/1] crypto: engine: permit to enqueue ashash_request
Date: Fri, 10 Jun 2016 16:43:09 +0200
Message-ID: <20160610144309.GA25816@Red>
References: <1464873212-15426-1-git-send-email-clabbe.montjoie@gmail.com>
 <1464873212-15426-2-git-send-email-clabbe.montjoie@gmail.com>
 <20160607103139.GA325@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, baolin.wang@linaro.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160607103139.GA325@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 07, 2016 at 06:31:39PM +0800, Herbert Xu wrote:
> On Thu, Jun 02, 2016 at 03:13:32PM +0200, LABBE Corentin wrote:
> >
> >  static int omap_aes_prepare_req(struct crypto_engine *engine,
> > -				struct ablkcipher_request *req)
> > +				struct crypto_async_request *areq)
> >  {
> > +	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
> 
> You're still doing casting in the driver.
> 
> I want this to be moved into the crypto engine API.  There should
> be separate function pointers for each request type.
> 
> Thanks,
> -- 

So I need to split do_one_request to cipher_one_request/hash_one_request.
Same with prepare_request to prepare_hash_request/prepare_cipher_request.
With the choice of each function done in crypto_engine.c.

Since this modification need to add <crypto/hash.h> to algapi.h, I think it is necessary to move all crypto engine stuff to crypto/engine.h
Do you agree ?

Regards

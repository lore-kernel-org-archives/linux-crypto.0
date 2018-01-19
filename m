From: Megha Dey <megha.dey@intel.com>
Subject: Re: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
 support
Date: Thu, 18 Jan 2018 16:44:21 -0800
Message-ID: <1516322661.2526.3.camel@megha-Z97X-UD7-TH>
References: <1515542948-24041-1-git-send-email-megha.dey@linux.intel.com>
         <1515542948-24041-2-git-send-email-megha.dey@linux.intel.com>
         <20180118113905.GA19904@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42224 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750762AbeASA16 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 19:27:58 -0500
In-Reply-To: <20180118113905.GA19904@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2018-01-18 at 22:39 +1100, Herbert Xu wrote:
> On Tue, Jan 09, 2018 at 04:09:04PM -0800, Megha Dey wrote:
> >
> > +static void mcryptd_skcipher_encrypt(struct crypto_async_request *base,
> > +								int err)
> > +{
> > +	struct skcipher_request *req = skcipher_request_cast(base);
> > +	struct mcryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
> > +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> > +	struct mcryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
> > +	struct crypto_skcipher *child = ctx->child;
> > +	struct skcipher_request subreq;
> > +
> > +	if (unlikely(err == -EINPROGRESS))
> > +		goto out;
> > +
> > +	/* set up the skcipher request to work on */
> > +	skcipher_request_set_tfm(&subreq, child);
> > +	skcipher_request_set_callback(&subreq,
> > +					CRYPTO_TFM_REQ_MAY_SLEEP, 0, 0);
> > +	skcipher_request_set_crypt(&subreq, req->src, req->dst,
> > +					req->cryptlen, req->iv);
> > +
> > +	/*
> > +	 * pass addr of descriptor stored in the request context
> > +	 * so that the callee can get to the request context
> > +	 */
> > +	rctx->desc = subreq;
> > +	err = crypto_skcipher_encrypt(&rctx->desc);
> > +
> > +	if (err) {
> > +		req->base.complete = rctx->complete;
> > +		goto out;
> > +	}
> > +	return;
> > +
> > +out:
> > +	mcryptd_skcipher_complete(req, err);
> > +}
> 
> OK this looks better but it's still abusing the crypto API interface.
> In particular, you're sharing data with the underlying algorithm
> behind the crypto API's back.  Also, the underlying algorithm does
> callback completion behind the API's back through the shared data
> context.
> 
> It seems to me that the current mcryptd scheme is flawed.  You
> want to batch multiple requests and yet this isn't actually being
> done by mcryptd at all.  The actual batching happens at the very
> lowest level, i.e., in the crypto algorithm below mcryptd.  For
> example, with your patch, the batching appears to happen in
> aes_cbc_job_mgr_submit.
> 
> So the mcryptd template is in fact completely superfluous.  You
> can remove it and just have all the main encrypt/decrypt functions
> invoke the underlying encrypt/decrypt function directly and achieve
> the same result.
> 
> Am I missing something?

Hi Herbert,

After discussing with Tim, it seems like the mcryptd is responsible for
queuing up the encrypt requests and dispatching them to the actual
multi-buffer raw algorithm.  It also flushes the queue
if we wait too long without new requests coming in to force dispatch of
the requests in queue.

Its function is analogous to cryptd but it has its own multi-lane twists
so we haven't reused the cryptd interface.
> 
> Cheers,

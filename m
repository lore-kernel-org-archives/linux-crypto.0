From: Megha Dey <megha.dey@intel.com>
Subject: Re: [PATCH 2/2] crypto : async implementation for sha1-mb
Date: Thu, 02 Jun 2016 10:20:20 -0700
Message-ID: <1464888020.9394.6.camel@megha-Z97X-UD7-TH>
References: <1464730941-8847-1-git-send-email-megha.dey@intel.com>
	 <1464730941-8847-3-git-send-email-megha.dey@intel.com>
	 <20160602103331.GA16969@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:17199 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161223AbcFBROw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 13:14:52 -0400
In-Reply-To: <20160602103331.GA16969@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2016-06-02 at 18:33 +0800, Herbert Xu wrote:
> On Tue, May 31, 2016 at 02:42:21PM -0700, Megha Dey wrote:
> >
> > @@ -416,8 +421,8 @@ static void mcryptd_hash_finup(struct crypto_async_request *req_async, int err)
> >  
> >  	if (unlikely(err == -EINPROGRESS))
> >  		goto out;
> > -
> > -	err = shash_ahash_mcryptd_finup(req, &rctx->desc);
> > +	rctx->out = req->result;
> > +	err = shash_ahash_mcryptd_finup(req, &rctx->areq);
> 
> These shash_ahash functions should be renamed.
> 
> Also why are they exported?

taken care of this.
> 
> > @@ -439,17 +444,18 @@ static int mcryptd_hash_finup_enqueue(struct ahash_request *req)
> >  static void mcryptd_hash_digest(struct crypto_async_request *req_async, int err)
> >  {
> >  	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
> > -	struct crypto_shash *child = ctx->child;
> > +	struct crypto_ahash *child = ctx->child;
> >  	struct ahash_request *req = ahash_request_cast(req_async);
> >  	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
> > -	struct shash_desc *desc = &rctx->desc;
> > +	struct ahash_request *desc = &rctx->areq;
> > +	struct crypto_async_request *base = &desc->base;
> >  
> >  	if (unlikely(err == -EINPROGRESS))
> >  		goto out;
> > +	base->tfm = &child->base;
> > +	base->flags = CRYPTO_TFM_REQ_MAY_SLEEP;  /* check this again */
> 
> You should not be touching crypto_async_request directly.  Use
> the proper ahash interface to set the child request.
> 
Herbert, Could you please clarify?
In the earlier code we had a async_request which is now replaced by
crypto_async_request. Do you want a new async_request to be used?
Do you think we shouldn't be setting the members of the
crypto_ahash_request directly, but use some other interface to do the
same for us?
> Thanks,

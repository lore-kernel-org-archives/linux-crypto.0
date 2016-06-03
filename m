From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto : async implementation for sha1-mb
Date: Fri, 3 Jun 2016 08:33:10 +0800
Message-ID: <20160603003310.GA27765@gondor.apana.org.au>
References: <1464730941-8847-1-git-send-email-megha.dey@intel.com>
 <1464730941-8847-3-git-send-email-megha.dey@intel.com>
 <20160602103331.GA16969@gondor.apana.org.au>
 <1464888020.9394.6.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33227 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbcFCAdV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 20:33:21 -0400
Content-Disposition: inline
In-Reply-To: <1464888020.9394.6.camel@megha-Z97X-UD7-TH>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 02, 2016 at 10:20:20AM -0700, Megha Dey wrote:
>
> > > @@ -439,17 +444,18 @@ static int mcryptd_hash_finup_enqueue(struct ahash_request *req)
> > >  static void mcryptd_hash_digest(struct crypto_async_request *req_async, int err)
> > >  {
> > >  	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
> > > -	struct crypto_shash *child = ctx->child;
> > > +	struct crypto_ahash *child = ctx->child;
> > >  	struct ahash_request *req = ahash_request_cast(req_async);
> > >  	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
> > > -	struct shash_desc *desc = &rctx->desc;
> > > +	struct ahash_request *desc = &rctx->areq;
> > > +	struct crypto_async_request *base = &desc->base;
> > >  
> > >  	if (unlikely(err == -EINPROGRESS))
> > >  		goto out;
> > > +	base->tfm = &child->base;
> > > +	base->flags = CRYPTO_TFM_REQ_MAY_SLEEP;  /* check this again */
> > 
> > You should not be touching crypto_async_request directly.  Use
> > the proper ahash interface to set the child request.
> > 
> Herbert, Could you please clarify?
> In the earlier code we had a async_request which is now replaced by
> crypto_async_request. Do you want a new async_request to be used?
> Do you think we shouldn't be setting the members of the
> crypto_ahash_request directly, but use some other interface to do the
> same for us?

You already have an ahash_request here.  So you should be doing

ahash_request_set_tfm(...)
ahash_request_set_callback(...)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

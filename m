From: "Dey, Megha" <megha.dey@intel.com>
Subject: RE: [PATCH 2/2] crypto : async implementation for sha1-mb
Date: Fri, 3 Jun 2016 02:51:14 +0000
Message-ID: <C440BA31B54DCD4AAC682D2365C8FEE703C52D94@ORSMSX111.amr.corp.intel.com>
References: <1464730941-8847-1-git-send-email-megha.dey@intel.com>
 <1464730941-8847-3-git-send-email-megha.dey@intel.com>
 <20160602103331.GA16969@gondor.apana.org.au>
 <1464888020.9394.6.camel@megha-Z97X-UD7-TH>
 <20160603003310.GA27765@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yu, Fenghua" <fenghua.yu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12817 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbcFCCvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 22:51:20 -0400
In-Reply-To: <20160603003310.GA27765@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Thursday, June 2, 2016 5:33 PM
To: Dey, Megha <megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com; davem@davemloft.net; linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Yu, Fenghua <fenghua.yu@intel.com>
Subject: Re: [PATCH 2/2] crypto : async implementation for sha1-mb

On Thu, Jun 02, 2016 at 10:20:20AM -0700, Megha Dey wrote:
>
> > > @@ -439,17 +444,18 @@ static int mcryptd_hash_finup_enqueue(struct 
> > > ahash_request *req)  static void mcryptd_hash_digest(struct 
> > > crypto_async_request *req_async, int err)  {
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
> > You should not be touching crypto_async_request directly.  Use the 
> > proper ahash interface to set the child request.
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

>ok,done!
Thanks,
--
Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

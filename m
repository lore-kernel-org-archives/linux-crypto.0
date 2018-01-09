From: Megha Dey <megha.dey@intel.com>
Subject: Re: [PATCH V7 5/7] crypto: AES CBC multi-buffer glue code
Date: Tue, 09 Jan 2018 13:07:24 -0800
Message-ID: <1515532044.2526.4.camel@megha-Z97X-UD7-TH>
References: <1501035000-6283-1-git-send-email-megha.dey@linux.intel.com>
         <1501035000-6283-6-git-send-email-megha.dey@linux.intel.com>
         <20170803052733.GA11871@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170803052733.GA11871@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2017-08-03 at 13:27 +0800, Herbert Xu wrote:
> On Tue, Jul 25, 2017 at 07:09:58PM -0700, Megha Dey wrote:
> >
> > +/* notify the caller of progress ; request still stays in queue */
> > +
> > +static void notify_callback(struct mcryptd_skcipher_request_ctx *rctx,
> > +			    struct mcryptd_alg_cstate *cstate,
> > +			    int err)
> > +{
> > +	struct skcipher_request *req = cast_mcryptd_ctx_to_req(rctx);
> > +
> > +	local_bh_disable();
> > +	rctx->complete(&req->base, err);
> > +	local_bh_enable();
> > +}
> 
> Please explain why you have this crazy construct that does async
> operations behind the crypto API's back while pretending to be sync
> by always returning zero?
> 
> Why is this even needed now that you have switched the underlying
> implementation to be async?

Hi Herbert,

In the next version, I have removed this construct. After giving it some
thought, I realise this is actually incorrect. Hopefully now, both the
outer and inner algorithm are async. 
> 
> > +	/* from mcryptd, we need to callback */
> > +	if (irqs_disabled())
> > +		rctx->complete(&req->base, err);
> > +	else {
> > +		local_bh_disable();
> > +		rctx->complete(&req->base, err);
> > +		local_bh_enable();
> > +	}
> 
> I complained about this the first time around and yet this crap is
> still there.

Sorry about that, will get rid of the context check in the next version.
> 
> Cheers,

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V7 5/7] crypto: AES CBC multi-buffer glue code
Date: Thu, 3 Aug 2017 13:27:33 +0800
Message-ID: <20170803052733.GA11871@gondor.apana.org.au>
References: <1501035000-6283-1-git-send-email-megha.dey@linux.intel.com>
 <1501035000-6283-6-git-send-email-megha.dey@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        megha.dey@intel.com
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58184 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdHCF1u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 01:27:50 -0400
Content-Disposition: inline
In-Reply-To: <1501035000-6283-6-git-send-email-megha.dey@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 25, 2017 at 07:09:58PM -0700, Megha Dey wrote:
>
> +/* notify the caller of progress ; request still stays in queue */
> +
> +static void notify_callback(struct mcryptd_skcipher_request_ctx *rctx,
> +			    struct mcryptd_alg_cstate *cstate,
> +			    int err)
> +{
> +	struct skcipher_request *req = cast_mcryptd_ctx_to_req(rctx);
> +
> +	local_bh_disable();
> +	rctx->complete(&req->base, err);
> +	local_bh_enable();
> +}

Please explain why you have this crazy construct that does async
operations behind the crypto API's back while pretending to be sync
by always returning zero?

Why is this even needed now that you have switched the underlying
implementation to be async?

> +	/* from mcryptd, we need to callback */
> +	if (irqs_disabled())
> +		rctx->complete(&req->base, err);
> +	else {
> +		local_bh_disable();
> +		rctx->complete(&req->base, err);
> +		local_bh_enable();
> +	}

I complained about this the first time around and yet this crap is
still there.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

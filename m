From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 1/2] SPU-AES support (kernel side)
Date: Thu, 12 Jul 2007 12:36:13 +0800
Message-ID: <20070712043613.GC18292@gondor.apana.org.au>
References: <20070626230027.GA4581@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4735 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751310AbXGLEgP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jul 2007 00:36:15 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1I8qPW-0000wm-BG
	for <linux-crypto@vger.kernel.org>; Thu, 12 Jul 2007 14:36:14 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1I8qPV-0004mS-00
	for <linux-crypto@vger.kernel.org>; Thu, 12 Jul 2007 12:36:13 +0800
Content-Disposition: inline
In-Reply-To: <20070626230027.GA4581@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 27, 2007 at 01:00:27AM +0200, Sebastian Siewior wrote:
>
> +static int enqueue_request(struct ablkcipher_request *req,
> +		enum SPU_FUNCTIONS op_type)
> +{
> +	struct async_d_request *asy_d_ctx = ablkcipher_request_ctx(req);
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
> +	struct aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
> +	struct kspu_work_item *work = &asy_d_ctx->kspu_work;
> +
> +	asy_d_ctx->crypto_operation = op_type;
> +	asy_d_ctx->progress = 0;
> +	work->enqueue = aes_queue_work_items;
> +
> +	kspu_enqueue_work_item(ctx->spe_ctx->ctx, &asy_d_ctx->kspu_work);

OK this is a software queue so we want to put a limit on it.
In fact, any reason why you couldn't juse use the existing
crypto_enqueue_request interface here? That would also make
that cast function unnecessary.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

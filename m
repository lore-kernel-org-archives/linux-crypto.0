From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 22 Jun 2007 15:28:44 +0800
Message-ID: <20070622072844.GA27341@gondor.apana.org.au>
References: <20070604134248.GA9645@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2241 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751278AbXFVH3U (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 03:29:20 -0400
Content-Disposition: inline
In-Reply-To: <20070604134248.GA9645@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Evgeniey:

Sorry for taking so long to get back to you.  I've been busy lately.

On Mon, Jun 04, 2007 at 05:42:48PM +0400, Evgeniy Polyakov wrote:
>
> +static int hifn_setup_crypto(struct ablkcipher_request *req, u8 op, u8 type, u8 mode)
> +{
> +	struct hifn_device *dev = ablkcipher_request_ctx(req);
> +	int err = -EBUSY;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev->lock, flags);
> +	if (dev->started < HIFN_QUEUE_LENGTH) {
> +		err = hifn_setup_session(dev, req->src, 1, req->dst, 1, 
> +				(dev->flags & HIFN_FLAG_OLD_KEY)?NULL:dev->current_key, dev->current_key_len,
> +				NULL, 0, 
> +				op, type, mode, dev->snum, req);
> +		dev->snum++;
> +		dev->started++;
> +	}
> +	spin_unlock_irqrestore(&dev->lock, flags);
> +
> +	/*
> +	 * HEAVY TODO: needs to kick Herbert XU to write documentation.
> +	 * HEAVY TODO: needs to kick Herbert XU to write documentation.
> +	 * HEAVY TODO: needs to kick Herbert XU to write documentation.
> +	 *
> +	 * Actually I need to think about how to handle the case, when queue is full.
> +	 * So far error (-EINVAL) is returned.
> +	 */

OK you need to provide a software queue here.  Since you already
have a hardware queue, you may choose to have a queue with a
(advisory) maximum length of zero.  However, a queue is still
necessary since requests with the MAY_BACKLOG flag must never
be discarded.

This is (or will be) used by users such as dm-crypt that must be
able to add at least one request but can throttle themselves
afterwards .

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

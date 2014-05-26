From: Marek Vasut <marex@denx.de>
Subject: Re: [QUESTION] Crypto queue handling
Date: Mon, 26 May 2014 18:16:58 +0200
Message-ID: <201405261816.58803.marex@denx.de>
References: <201405261758.19425.marex@denx.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, Arnd Bergmann <arnd@arndb.de>,
	Pantelis Antoniou <panto@antoniou-consulting.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:33676 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaEZQQu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 May 2014 12:16:50 -0400
In-Reply-To: <201405261758.19425.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello again,

> Hello,
> 
> I'm digging in crypto/algapi.c , in the crypto_enqueue_request() function.
> I don't quite understand how the backlog mechanism should work. According
> to [1], I suspect it should limit the amount of requests in the queue to
> $max_qlen and allow one more request to be enqueued into the $backlog ;
> and if there is more requests than $max_qlen, it should start dropping the
> requests ?
> 
> Inspecting the code, I see these situations:
> 1) qlen < max_qlen
>    -> The request is enqueued, qlen is increased , returns -EINPROGRESS
> 2) qlen >= max_qlen
>    -> The crypto_enqueue_request() returns -EBUSY in this case
>    2a) request->flags has CRYPTO_TFM_REQ_MAY_BACKLOG unset
>        => Request is not enqueued , qlen is not increased
>    2b) request->flags has CRYPTO_TFM_REQ_MAY_BACKLOG set
>        => Request is enqueued , qlen is increased
> 
> Therefore, I suspect if 2b) case happens repeatedly, the queue will grow
> indefinitelly. I'm not sure if this can happen, but I suspect that's really
> possible. My understanding is that the driver will call
> crypto_enqueue_request() and propagate it's return value to the upper
> layers. They upper layet can generate such a request that has
> CRYPTO_TFM_REQ_MAY_BACKLOG set .
> 
> But how shall the upper layers handle the -EBUSY return value from the
> crypto API calls? Shall they stop saturating the crypto API with requests
> ? How can the upper layers determine when can they resume sending crypto
> requests ? Shall they just try calling crypto_enqueue_request() again to
> see if it still returns - EBUSY ?

There is one more thing which I don't quite understand with regards to the 
queues, it's this pattern one can see in every second crypto driver (I took this 
from bfin_crc.c):

302         struct crypto_async_request *async_req, *backlog;
[...]
311         spin_lock_irqsave(&crc->lock, flags);
[...]
318         backlog = crypto_get_backlog(&crc->queue);
319         async_req = crypto_dequeue_request(&crc->queue);
320         if (async_req)
321                 crc->busy = 1;
322         spin_unlock_irqrestore(&crc->lock, flags);
323 
324         if (!async_req)
325                 return ret;
326 
327         if (backlog)
328                 backlog->complete(backlog, -EINPROGRESS);

So, we call backlog->complete() , but who did actually ever process the request 
stored in the queue->backlog ? To me, it seems like the request was never 
processed, but we complete it.

I think this will work in case the ->backlog == ->list , since in that case we 
will basically complete the currently dequeued request. Will this also work in 
case ->backlog != ->list (that is, in case the qlen overflew max_qlen)? I'm not 
sure.

Can you please help me understand this ?

Thank you!

Best regards,
Marek Vasut

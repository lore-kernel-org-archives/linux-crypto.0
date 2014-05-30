From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [QUESTION] Crypto queue handling
Date: Fri, 30 May 2014 17:30:30 +0800
Message-ID: <20140530093030.GC12760@gondor.apana.org.au>
References: <201405261758.19425.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Pantelis Antoniou <panto@antoniou-consulting.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:37791 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaE3Jai (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 05:30:38 -0400
Content-Disposition: inline
In-Reply-To: <201405261758.19425.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 26, 2014 at 05:58:19PM +0200, Marek Vasut wrote:
> Hello,
> 
> I'm digging in crypto/algapi.c , in the crypto_enqueue_request() function. I 
> don't quite understand how the backlog mechanism should work. According to [1], 
> I suspect it should limit the amount of requests in the queue to $max_qlen and 
> allow one more request to be enqueued into the $backlog ; and if there is more 
> requests than $max_qlen, it should start dropping the requests ?
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

The queue is per-tfm.  In this case you never want to share a
tfm between two users that do not agree on whether to have backlog
or not.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

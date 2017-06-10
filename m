From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v8 1/2] crypto: skcipher AF_ALG - overhaul memory
 management
Date: Sat, 10 Jun 2017 16:59:40 +0800
Message-ID: <20170610085940.GA15537@gondor.apana.org.au>
References: <1534260.eLzG41Ydnz@positron.chronox.de>
 <2934385.XAQy5ZyJXM@positron.chronox.de>
 <20170610031316.GA14206@gondor.apana.org.au>
 <25395002.4o58NXqqVS@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:53088 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751870AbdFJJAB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 05:00:01 -0400
Content-Disposition: inline
In-Reply-To: <25395002.4o58NXqqVS@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 10, 2017 at 10:33:28AM +0200, Stephan Müller wrote:
>
> Right. Shouldn't we drop the ctx->inflight completely?
> 
> The code in the current patch set contains:
> 
> when an async operation is queued:
> 
>                 sock_hold(sk);
>                 ctx->inflight++;
> 
> upon completion of the callback:
> 
>         __sock_put(sk);
>         ctx->inflight--;
> 
> Thus, the socket is grabbed already. Hence, when dropping the inflight code 
> including the wait queue entirely, I would think we are still save as we hold 
> the socket.

Indeed, we should just kill the wait or perhaps convert it to
a WARN_ON.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

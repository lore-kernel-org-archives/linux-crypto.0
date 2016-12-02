From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 2/2] crypto: marvell - Don't corrupt state of an STD req
 for re-stepped ahash
Date: Fri, 2 Dec 2016 17:21:11 +0100
Message-ID: <20161202172111.05a4df87@bbrezillon>
References: <20161202160551.9940-1-romain.perier@free-electrons.com>
        <20161202160551.9940-3-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>, linux-crypto@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        stable@vger.kernel.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:38930 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752197AbcLBQVO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2016 11:21:14 -0500
In-Reply-To: <20161202160551.9940-3-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri,  2 Dec 2016 17:05:51 +0100
Romain Perier <romain.perier@free-electrons.com> wrote:

> mv_cesa_hash_std_step always copies creq->state into the SRAM. If an IRQ
> is triggered while the current STD request is not finished, this request
> will be stepped again and the initial state will be filled into the
> engine.

Hm, it's not really related to the IRQ itself. You get several
interrupts because your request has been split into several chunks to
fit in the SRAM.
The fact that you receive several IRQs for the same crypto request is
just a side-effect of the 'split in several chunk' approach.

Maybe you should rephrase it like:

"
mv_cesa_hash_std_step() copies the creq->state into the SRAM at each
step, but this is only required on the first one. By doing that, we
overwrite the engine state, and get erroneous results when the crypto
request is split in several chunks to fit in the internal SRAM.
"

> 
> This commit changes the function in order to copy the state only when
> the request is launched for the first time.

"
This commit changes the function to copy the state only on the first
step.
"

> 
> Fixes: commit 2786cee8e50b ("crypto: marvell - Move SRAM I/O op...")
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
> ---
>  drivers/crypto/marvell/hash.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index fbbcbf8..047e05f 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -168,9 +168,11 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  	mv_cesa_adjust_op(engine, &creq->op_tmpl);
>  	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
>  
> -	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
> -	for (i = 0; i < digsize / 4; i++)
> -		writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
> +	if (sreq->offset == 0) {

Just a nit, but I'd prefer

	if (!sreq->offset) {

> +		digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
> +		for (i = 0; i < digsize / 4; i++)
> +			writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
> +	}
>  
>  	if (creq->cache_ptr)
>  		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,

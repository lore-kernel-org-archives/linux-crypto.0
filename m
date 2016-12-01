From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH] crypto: marvell - Don't copy hash operation twice into the SRAM
Date: Thu, 01 Dec 2016 17:27:53 +0100
Message-ID: <87shq7iph2.fsf@free-electrons.com>
References: <20161201162157.14563-1-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:35757 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932467AbcLAQ1z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2016 11:27:55 -0500
In-Reply-To: <20161201162157.14563-1-romain.perier@free-electrons.com> (Romain
        Perier's message of "Thu, 1 Dec 2016 17:21:57 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Romain,
 
 On jeu., déc. 01 2016, Romain Perier <romain.perier@free-electrons.com> wrote:

> No need to copy the template of an hash operation twice into the SRAM
> from the step function.
>

Does this patch fix a bug ot it is jsute a cleanup/improvement?

If it is a bug you should CC stable and add use the Fixes tag.

Gregory

> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
> ---
>  drivers/crypto/marvell/hash.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index 2a92605..fbbcbf8 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -172,9 +172,6 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  	for (i = 0; i < digsize / 4; i++)
>  		writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
>  
> -	mv_cesa_adjust_op(engine, &creq->op_tmpl);
> -	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
> -
>  	if (creq->cache_ptr)
>  		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
>  			    creq->cache, creq->cache_ptr);
> -- 
> 2.9.3
>

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

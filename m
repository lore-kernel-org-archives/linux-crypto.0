From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 1/2] crypto: marvell - Don't copy hash operation twice
 into the SRAM
Date: Fri, 2 Dec 2016 17:30:02 +0100
Message-ID: <20161202173002.23ee6fdb@bbrezillon>
References: <20161202160551.9940-1-romain.perier@free-electrons.com>
        <20161202160551.9940-2-romain.perier@free-electrons.com>
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
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20161202160551.9940-2-romain.perier@free-electrons.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri,  2 Dec 2016 17:05:50 +0100
Romain Perier <romain.perier@free-electrons.com> wrote:

> No need to copy the template of an hash operation twice into the SRAM
> from the step function.
> 
> Fixes: commit 85030c5168f1 ("crypto: marvell - Add support for chai...")
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Oh, and please add

Cc: <stable@vger.kernel.org>

to both patches.

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

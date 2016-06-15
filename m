From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 6/7] crypto: marvell: Adding load balancing between
 engines
Date: Wed, 15 Jun 2016 23:13:15 +0200
Message-ID: <20160615231315.5e254706@bbrezillon>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
	<1466018134-10779-7-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57212 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750751AbcFOVNS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 17:13:18 -0400
In-Reply-To: <1466018134-10779-7-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 15 Jun 2016 21:15:33 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> This commits adds support for fine grained load balancing on
> multi-engine IPs. The engine is pre-selected based on its current load
> and on the weight of the crypto request that is about to be processed.
> The global crypto queue is also moved to each engine. These changes are

					to the mv_cesa_engine object.

> useful for preparing the code to support TDMA chaining between crypto
> requests, because each tdma chain will be handled per engine.

These changes are required to allow chaining crypto requests at the DMA
level.

> By using
> a crypto queue per engine, we make sure that we keep the state of the
> tdma chain synchronized with the crypto queue. We also reduce contention
> on 'cesa_dev->lock' and improve parallelism.
> 
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
> ---
>  drivers/crypto/marvell/cesa.c   | 30 +++++++++----------
>  drivers/crypto/marvell/cesa.h   | 26 +++++++++++++++--
>  drivers/crypto/marvell/cipher.c | 59 ++++++++++++++++++-------------------
>  drivers/crypto/marvell/hash.c   | 65 +++++++++++++++++++----------------------
>  4 files changed, 97 insertions(+), 83 deletions(-)
> 

[...]

> diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
> index fbaae2f..02aa38f 100644
> --- a/drivers/crypto/marvell/cipher.c
> +++ b/drivers/crypto/marvell/cipher.c
> @@ -89,6 +89,9 @@ static void mv_cesa_ablkcipher_std_step(struct ablkcipher_request *req)
>  	size_t  len = min_t(size_t, req->nbytes - sreq->offset,
>  			    CESA_SA_SRAM_PAYLOAD_SIZE);
>  
> +	mv_cesa_adjust_op(engine, &sreq->op);
> +	memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
> +
>  	len = sg_pcopy_to_buffer(req->src, creq->src_nents,
>  				 engine->sram + CESA_SA_DATA_SRAM_OFFSET,
>  				 len, sreq->offset);
> @@ -167,12 +170,9 @@ mv_cesa_ablkcipher_std_prepare(struct ablkcipher_request *req)
>  {
>  	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
>  	struct mv_cesa_ablkcipher_std_req *sreq = &creq->req.std;
> -	struct mv_cesa_engine *engine = sreq->base.engine;
>  
>  	sreq->size = 0;
>  	sreq->offset = 0;
> -	mv_cesa_adjust_op(engine, &sreq->op);
> -	memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));

Are these changes really related to this load balancing support?
AFAICT, it's something that could have been done earlier, and is not
dependent on the changes your introducing here, but maybe I'm missing
something.

>  }

[...]

>  static int mv_cesa_ecb_aes_encrypt(struct ablkcipher_request *req)
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index f7f84cc..5946a69 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -162,6 +162,15 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  	unsigned int new_cache_ptr = 0;
>  	u32 frag_mode;
>  	size_t  len;
> +	unsigned int digsize;
> +	int i;
> +
> +	mv_cesa_adjust_op(engine, &creq->op_tmpl);
> +	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
> +
> +	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
> +	for (i = 0; i < digsize / 4; i++)
> +		writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
>  
>  	if (creq->cache_ptr)
>  		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
> @@ -265,11 +274,8 @@ static void mv_cesa_ahash_std_prepare(struct ahash_request *req)
>  {
>  	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
>  	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
> -	struct mv_cesa_engine *engine = sreq->base.engine;
>  
>  	sreq->offset = 0;
> -	mv_cesa_adjust_op(engine, &creq->op_tmpl);
> -	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));

Same as above: it doesn't seem related to the load balancing stuff.

>  }

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v2 04/10] crypto: marvell: Copy IV vectors by DMA
 transfers for acipher requests
Date: Fri, 17 Jun 2016 14:49:13 +0200
Message-ID: <20160617144913.1f70ed75@bbrezillon>
References: <1466162649-29911-1-git-send-email-romain.perier@free-electrons.com>
	<1466162649-29911-5-git-send-email-romain.perier@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:51188 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751757AbcFQMt0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2016 08:49:26 -0400
In-Reply-To: <1466162649-29911-5-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 17 Jun 2016 13:24:03 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> Add a TDMA descriptor at the end of the request for copying the
> output IV vector via a DMA transfer. This is a good way for offloading
> as much as processing as possible to the DMA and the crypto engine.
> This is also required for processing multiple cipher requests
> in chained mode, otherwise the content of the IV vector would be
> overwritten by the last processed request.
> 
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

After fixing the coding style issue,

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
> 
> Changes in v2:
>   - Reworded the commit message, the term 'asynchronously' was
> ambigous
>   - Changed the value of CESA_TDMA_IV from 4 to 3
>   - Adding missing blank lines
>   - Rewrote the function mv_cesa_ablkcipher_process to something more
>     readable.
>   - Fixed a bug about how the type of a TDMA operation was tested in
>     mv_cesa_dma_cleanup and mv_cesa_dma_prepare, I created a separated
>     commit for that (see PATCH 03/10)
>   - Renamed variables in mv_cesa_dma_add_iv_op
>   - Removed the flag CESA_TDMA_DATA from mv_cesa_dma_add_iv_op (not
> needed)
> 
>  drivers/crypto/marvell/cesa.c   |  4 ++++
>  drivers/crypto/marvell/cesa.h   |  5 +++++
>  drivers/crypto/marvell/cipher.c | 32 +++++++++++++++++++++++---------
>  drivers/crypto/marvell/tdma.c   | 29 +++++++++++++++++++++++++++++
>  4 files changed, 61 insertions(+), 9 deletions(-)
> 

[...]

> @@ -135,21 +140,21 @@ static int mv_cesa_ablkcipher_process(struct
> crypto_async_request *req, {
>  	struct ablkcipher_request *ablkreq =
> ablkcipher_request_cast(req); struct mv_cesa_ablkcipher_req *creq =
> ablkcipher_request_ctx(ablkreq);
> -	struct mv_cesa_ablkcipher_std_req *sreq = &creq->req.std;
> -	struct mv_cesa_engine *engine = sreq->base.engine;
> +	struct mv_cesa_tdma_req *dreq;
> +	unsigned int ivsize;
>  	int ret;
>  
> -	if (creq->req.base.type == CESA_DMA_REQ)
> -		ret = mv_cesa_dma_process(&creq->req.dma, status);
> -	else
> -		ret = mv_cesa_ablkcipher_std_process(ablkreq,
> status);
> +	if (creq->req.base.type == CESA_STD_REQ)
> +		return mv_cesa_ablkcipher_std_process(ablkreq,
> status); 
> +	ret = mv_cesa_dma_process(&creq->req.dma, status);
>  	if (ret)
>  		return ret;
>  
> -	memcpy_fromio(ablkreq->info,
> -		      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
> -
> crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq)));
> +	dreq = &creq->req.dma;
> +	ivsize =
> +	crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq));

My bad, my mailer wrapped the line: please put the assignment on the
same line and use a temporary variable if it exceeds 80 chars.


> +	memcpy_fromio(ablkreq->info, dreq->chain.last->data, ivsize);
>  
>  	return 0;
>  }

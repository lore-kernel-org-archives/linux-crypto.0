From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] crypto: marvell: Don't copy IV vectors from the
 _process op for ciphers
Date: Thu, 28 Jul 2016 12:09:11 +0200
Message-ID: <20160728120911.34f02176@bbrezillon>
References: <1469699983-21370-1-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Gregory Clement <gregory.clement@free-electrons.com>
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:49808 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752508AbcG1KJY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jul 2016 06:09:24 -0400
In-Reply-To: <1469699983-21370-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 28 Jul 2016 11:59:43 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> The IV output vectors should only be copied from the _complete operation
> and not from the _process operation, i.e only from the operation that is
> designed to copy the result of the request to the right location. This
> copy is already done in the _complete operation, so this commit removes
> the duplicated code in the _process op.
> 
> Fixes: 3610d6cd5231 ("crypto: marvell - Add a complete...")
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/crypto/marvell/cipher.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
> index 8391aba..d19dc96 100644
> --- a/drivers/crypto/marvell/cipher.c
> +++ b/drivers/crypto/marvell/cipher.c
> @@ -139,20 +139,11 @@ static int mv_cesa_ablkcipher_process(struct crypto_async_request *req,
>  	struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
>  	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
>  	struct mv_cesa_req *basereq = &creq->base;
> -	unsigned int ivsize;
> -	int ret;
>  
>  	if (mv_cesa_req_get_type(basereq) == CESA_STD_REQ)
>  		return mv_cesa_ablkcipher_std_process(ablkreq, status);
>  
> -	ret = mv_cesa_dma_process(basereq, status);
> -	if (ret)
> -		return ret;
> -
> -	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq));
> -	memcpy_fromio(ablkreq->info, basereq->chain.last->data, ivsize);
> -
> -	return 0;
> +	return mv_cesa_dma_process(basereq, status);
>  }
>  
>  static void mv_cesa_ablkcipher_step(struct crypto_async_request *req)

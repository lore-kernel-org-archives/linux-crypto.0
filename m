From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] crypto: marvell - Update cache with input sg only when
 it is unmapped
Date: Mon, 25 Jul 2016 14:33:39 +0200
Message-ID: <20160725143339.53f747f6@bbrezillon>
References: <1469195184-4700-1-git-send-email-romain.perier@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:59883 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751292AbcGYMdm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jul 2016 08:33:42 -0400
In-Reply-To: <1469195184-4700-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 22 Jul 2016 15:46:24 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> So far, the cache of the ahash requests was updated from the 'complete'
> operation. This complete operation is called from mv_cesa_tdma_process
> before the cleanup operation, which means that the content of req->src
> can be read and copied when it is still mapped. This commit fixes the
> issue by moving this cache update from mv_cesa_ahash_complete to
> mv_cesa_ahash_req_cleanup, so the copy is done once the sglist is
> unmapped.
> 
> Fixes: 1bf6682cb31d ("crypto: marvell - Add a complete operation for..")
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/crypto/marvell/hash.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index c35912b..82e0f4e6 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -315,12 +315,6 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
>  	for (i = 0; i < digsize / 4; i++)
>  		creq->state[i] = readl_relaxed(engine->regs + CESA_IVDIG(i));
>  
> -	if (creq->cache_ptr)
> -		sg_pcopy_to_buffer(ahashreq->src, creq->src_nents,
> -				   creq->cache,
> -				   creq->cache_ptr,
> -				   ahashreq->nbytes - creq->cache_ptr);
> -
>  	if (creq->last_req) {
>  		/*
>  		 * Hardware's MD5 digest is in little endian format, but
> @@ -365,6 +359,12 @@ static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
>  		mv_cesa_ahash_last_cleanup(ahashreq);
>  
>  	mv_cesa_ahash_cleanup(ahashreq);
> +
> +	if (creq->cache_ptr)
> +		sg_pcopy_to_buffer(ahashreq->src, creq->src_nents,
> +				   creq->cache,
> +				   creq->cache_ptr,
> +				   ahashreq->nbytes - creq->cache_ptr);
>  }
>  
>  static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops = {

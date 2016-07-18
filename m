From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] crypto: marvell: Fix wrong flag used for GFP in
 mv_cesa_dma_add_iv_op
Date: Mon, 18 Jul 2016 12:00:57 +0200
Message-ID: <20160718120057.3acbfc95@bbrezillon>
References: <1468834344-14160-1-git-send-email-romain.perier@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:37329 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751426AbcGRKA7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 06:00:59 -0400
In-Reply-To: <1468834344-14160-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 18 Jul 2016 11:32:24 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> Use the parameter 'gfp_flags' instead of 'flag' as second argument of
> dma_pool_alloc(). The parameter 'flag' is for the TDMA descriptor, its
> content has no sense for the allocator.
> 
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Herbert, can you add the following line when applying then patch?

Fixes: bac8e805a30d ("crypto: marvell - Copy IV vectors by DMA transfers for acipher requests")

> ---
>  drivers/crypto/marvell/tdma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
> index 942f4b6..51a631d 100644
> --- a/drivers/crypto/marvell/tdma.c
> +++ b/drivers/crypto/marvell/tdma.c
> @@ -223,7 +223,7 @@ int mv_cesa_dma_add_iv_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
>  	if (IS_ERR(tdma))
>  		return PTR_ERR(tdma);
>  
> -	iv = dma_pool_alloc(cesa_dev->dma->iv_pool, flags, &dma_handle);
> +	iv = dma_pool_alloc(cesa_dev->dma->iv_pool, gfp_flags, &dma_handle);
>  	if (!iv)
>  		return -ENOMEM;
>  

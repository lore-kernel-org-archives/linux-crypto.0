From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [patch] crypto: marvell/cesa - remove unneeded condition
Date: Mon, 21 Mar 2016 10:10:54 +0100
Message-ID: <20160321101054.2c42ee16@bbrezillon>
References: <20160321090342.GB31670@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:55586 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752638AbcCUJK5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2016 05:10:57 -0400
In-Reply-To: <20160321090342.GB31670@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 21 Mar 2016 12:03:43 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> creq->cache[] is an array inside the struct, it's not a pointer and it
> can't be NULL.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> 
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index 7ca2e0f..7a5058d 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -768,8 +768,7 @@ static int mv_cesa_ahash_export(struct ahash_request *req, void *hash,
>  	*len = creq->len;
>  	memcpy(hash, creq->state, digsize);
>  	memset(cache, 0, blocksize);
> -	if (creq->cache)
> -		memcpy(cache, creq->cache, creq->cache_ptr);
> +	memcpy(cache, creq->cache, creq->cache_ptr);
>  
>  	return 0;
>  }



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

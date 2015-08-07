From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 09/31] crypto: use kmemdup rather than duplicating its
 implementation
Date: Fri, 7 Aug 2015 16:05:33 +0800
Message-ID: <20150807080533.GA26121@gondor.apana.org.au>
References: <1438934377-4922-1-git-send-email-a.hajda@samsung.com>
 <1438934377-4922-10-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Andrzej Hajda <a.hajda@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438934377-4922-10-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 07, 2015 at 09:59:15AM +0200, Andrzej Hajda wrote:
> The patch was generated using fixed coccinelle semantic patch
> scripts/coccinelle/api/memdup.cocci [1].
> 
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2014320
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Actually I think you've identified a bug in the code.
 
> diff --git a/crypto/echainiv.c b/crypto/echainiv.c
> index d3896c7..d8968c0 100644
> --- a/crypto/echainiv.c
> +++ b/crypto/echainiv.c
> @@ -134,13 +134,10 @@ static int echainiv_encrypt(struct aead_request *req)
>  
>  	if (unlikely(!IS_ALIGNED((unsigned long)info,
>  				 crypto_aead_alignmask(geniv) + 1))) {
> -		info = kmalloc(ivsize, req->base.flags &
> -				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
> -								  GFP_ATOMIC);
> +		info = kmemdup(req->iv, ivsize,
> +			       req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC);
>  		if (!info)
>  			return -ENOMEM;
> -
> -		memcpy(info, req->iv, ivsize);

This is meant to reallocate a buffer aligned to geniv but it isn't
actually doing that.

So we should be changing it to align the pointer rather than
converting it to memcpy.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

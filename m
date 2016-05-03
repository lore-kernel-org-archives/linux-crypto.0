From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/5] crypto: Use dma_pool_zalloc
Date: Tue, 3 May 2016 16:17:17 +0800
Message-ID: <20160503081717.GE17166@gondor.apana.org.au>
References: <1461960552-7429-1-git-send-email-Julia.Lawall@lip6.fr>
 <1461960552-7429-5-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	kernel-janitors@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461960552-7429-5-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 29, 2016 at 10:09:11PM +0200, Julia Lawall wrote:
> Dma_pool_zalloc combines dma_pool_alloc and memset 0.  The semantic patch
> that makes this transformation is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression d,e;
> statement S;
> @@
> 
>         d =
> -            dma_pool_alloc
> +            dma_pool_zalloc
>              (...);
>         if (!d) S
> -       memset(d, 0, sizeof(*d));
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

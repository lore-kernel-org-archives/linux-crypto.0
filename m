From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH] crypto: inside-secure: safexcel - fix memory allocation
Date: Wed, 10 Oct 2018 15:55:14 +0200
Message-ID: <20181010135514.GC3368@kwain>
References: <20181008191712.GA12892@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181008191712.GA12892@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gustavo,

On Mon, Oct 08, 2018 at 09:17:12PM +0200, Gustavo A. R. Silva wrote:
> The original intention is to allocate space for EIP197_DEFAULT_RING_SIZE
> *pointers* to struct, so sizeof(priv->ring[i].rdr_req) should be
> sizeof(*priv->ring[i].rdr_req).
> 
> Addresses-Coverity-ID: 1473962 ("Sizeof not portable")
> Fixes: 9744fec95f06 ("crypto: inside-secure - remove request list to improve performance")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Good catch, thanks!
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index 86c699c1..bc6c5cb 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1066,7 +1066,7 @@ static int safexcel_probe(struct platform_device *pdev)
>  
>  		priv->ring[i].rdr_req = devm_kcalloc(dev,
>  			EIP197_DEFAULT_RING_SIZE,
> -			sizeof(priv->ring[i].rdr_req),
> +			sizeof(*priv->ring[i].rdr_req),
>  			GFP_KERNEL);
>  		if (!priv->ring[i].rdr_req) {
>  			ret = -ENOMEM;
> -- 
> 2.7.4
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

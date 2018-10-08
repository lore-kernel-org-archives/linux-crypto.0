From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] crypto: inside-secure: safexcel - fix memory allocation
Date: Mon, 8 Oct 2018 15:20:10 -0700
Message-ID: <CAGXu5j+a=81mGFrF5igMXe46mv_PsqzUKCzLWj0oCEMk1PY62g@mail.gmail.com>
References: <20181008191712.GA12892@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181008191712.GA12892@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 8, 2018 at 12:17 PM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> The original intention is to allocate space for EIP197_DEFAULT_RING_SIZE
> *pointers* to struct, so sizeof(priv->ring[i].rdr_req) should be
> sizeof(*priv->ring[i].rdr_req).
>
> Addresses-Coverity-ID: 1473962 ("Sizeof not portable")
> Fixes: 9744fec95f06 ("crypto: inside-secure - remove request list to improve performance")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

Luckily, this results in the same size, since it's still a pointer:

struct crypto_async_request **rdr_req;

But yes, it should be fixed.

-Kees

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
>                 priv->ring[i].rdr_req = devm_kcalloc(dev,
>                         EIP197_DEFAULT_RING_SIZE,
> -                       sizeof(priv->ring[i].rdr_req),
> +                       sizeof(*priv->ring[i].rdr_req),
>                         GFP_KERNEL);
>                 if (!priv->ring[i].rdr_req) {
>                         ret = -ENOMEM;
> --
> 2.7.4
>



-- 
Kees Cook
Pixel Security

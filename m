From: Steve Lin <steven.lin1@broadcom.com>
Subject: Re: [PATCH] crypto: brcm: fix spelling mistake: "fallbck" -> "fallback"
Date: Mon, 5 Jun 2017 10:10:48 -0400
Message-ID: <CA+Jmh7F0oWL44==Xsy6HY_kabVQQNcefh3Q8S0mH5mHhRyD1ag@mail.gmail.com>
References: <20170604182920.26389-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170604182920.26389-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jun 4, 2017 at 2:29 PM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Trivial fix to spelling mistake in flow_log message
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Good catch, thanks!
Reviewed-by: Steve Lin <steven.lin1@broadcom.com>

> ---
>  drivers/crypto/bcm/cipher.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
> index 61393dc70b0b..9cfd36c1bcb6 100644
> --- a/drivers/crypto/bcm/cipher.c
> +++ b/drivers/crypto/bcm/cipher.c
> @@ -2639,7 +2639,7 @@ static int aead_need_fallback(struct aead_request *req)
>             (spu->spu_type == SPU_TYPE_SPUM) &&
>             (ctx->digestsize != 8) && (ctx->digestsize != 12) &&
>             (ctx->digestsize != 16)) {
> -               flow_log("%s() AES CCM needs fallbck for digest size %d\n",
> +               flow_log("%s() AES CCM needs fallback for digest size %d\n",
>                          __func__, ctx->digestsize);
>                 return 1;
>         }
> --
> 2.11.0
>

From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Subject: Re: [RFC PATCH] crypto: brcm - explicitly cast cipher to hash type
Date: Wed, 28 Mar 2018 12:08:24 +0530
Message-ID: <CAAFb_vrFF6D8DEvnZMDda-qd-jTh3mKt0BgGBJ5eWxydY1LEXA@mail.gmail.com>
References: <20180324110242.9474-1-stefan@agner.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, clabbe.montjoie@gmail.com,
        Scott Branden <scott.branden@broadcom.com>,
        Steven Lin <steven.lin1@broadcom.com>, garsilva@embeddedor.com,
        pravin.shedge4linux@gmail.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stefan Agner <stefan@agner.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180324110242.9474-1-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stefan,

The change looks to be fine.  From the IP point of view its using the
same values in case of AES cipher and hash types so explicit casting
should be ok.

-Raveendra

On Sat, Mar 24, 2018 at 4:32 PM, Stefan Agner <stefan@agner.ch> wrote:
> In the AES cases enum spu_cipher_type and enum hash_type have
> the same values, so the assignment is fine. Explicitly cast
> the enum type conversion.
>
> This fixes two warnings when building with clang:
>   drivers/crypto/bcm/cipher.c:821:34: warning: implicit conversion from
>       enumeration type 'enum spu_cipher_type' to different enumeration
>       type 'enum hash_type' [-Wenum-conversion]
>                 hash_parms.type = cipher_parms.type;
>                                 ~ ~~~~~~~~~~~~~^~~~
>   drivers/crypto/bcm/cipher.c:1412:26: warning: implicit conversion from
>       enumeration type 'enum spu_cipher_type' to different enumeration
>       type 'enum hash_type' [-Wenum-conversion]
>                 hash_parms.type = ctx->cipher_type;
>                                 ~ ~~~~~^~~~~~~~~~~
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> I am not familar with the IP... I would be glad if somebody with
> better insight could have a look whether that patch makes sense.
>
>  drivers/crypto/bcm/cipher.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
> index 2b75f95bbe1b..309c67c7012f 100644
> --- a/drivers/crypto/bcm/cipher.c
> +++ b/drivers/crypto/bcm/cipher.c
> @@ -818,7 +818,7 @@ static int handle_ahash_req(struct iproc_reqctx_s *rctx)
>
>         /* AES hashing keeps key size in type field, so need to copy it here */
>         if (hash_parms.alg == HASH_ALG_AES)
> -               hash_parms.type = cipher_parms.type;
> +               hash_parms.type = (enum hash_type)cipher_parms.type;
>         else
>                 hash_parms.type = spu->spu_hash_type(rctx->total_sent);
>
> @@ -1409,7 +1409,7 @@ static int handle_aead_req(struct iproc_reqctx_s *rctx)
>                                                 rctx->iv_ctr_len);
>
>         if (ctx->auth.alg == HASH_ALG_AES)
> -               hash_parms.type = ctx->cipher_type;
> +               hash_parms.type = (enum hash_type)ctx->cipher_type;
>
>         /* General case AAD padding (CCM and RFC4543 special cases below) */
>         aead_parms.aad_pad_len = spu->spu_gcm_ccm_pad_len(ctx->cipher.mode,
> --
> 2.16.2
>

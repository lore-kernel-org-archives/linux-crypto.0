From: Jan Glauber <jan.glauber@cavium.com>
Subject: Re: [PATCH] crypto: zip: make several functions static
Date: Mon, 2 Jul 2018 07:45:40 +0200
Message-ID: <20180702054540.GA14359@hc>
References: <20180630113049.4402-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Robert Richter <rrichter@cavium.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180630113049.4402-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Colin,

I've already posted a similar patch:
https://patchwork.kernel.org/patch/10482283/

--Jan

On Sat, Jun 30, 2018 at 12:30:49PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The functions zip_ctx_exit, zip_compress, zip_decompress and zip_ctx_init
> are local to the source and do not need to be in global scope, so make
> them static.
> 
> Cleans up sparse warnings:
> symbol 'zip_ctx_exit' was not declared. Should it be static?
> symbol 'zip_compress' was not declared. Should it be static?
> symbol 'zip_decompress' was not declared. Should it be static?
> symbol 'zip_ctx_init' was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/crypto/cavium/zip/zip_crypto.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/cavium/zip/zip_crypto.c b/drivers/crypto/cavium/zip/zip_crypto.c
> index b92b6e7e100f..f9e99a15d2a0 100644
> --- a/drivers/crypto/cavium/zip/zip_crypto.c
> +++ b/drivers/crypto/cavium/zip/zip_crypto.c
> @@ -69,7 +69,7 @@ static void zip_static_init_zip_ops(struct zip_operation *zip_ops,
>         zip_ops->csum         = 1; /* Adler checksum desired */
>  }
> 
> -int zip_ctx_init(struct zip_kernel_ctx *zip_ctx, int lzs_flag)
> +static int zip_ctx_init(struct zip_kernel_ctx *zip_ctx, int lzs_flag)
>  {
>         struct zip_operation  *comp_ctx   = &zip_ctx->zip_comp;
>         struct zip_operation  *decomp_ctx = &zip_ctx->zip_decomp;
> @@ -107,7 +107,7 @@ int zip_ctx_init(struct zip_kernel_ctx *zip_ctx, int lzs_flag)
>         return -ENOMEM;
>  }
> 
> -void zip_ctx_exit(struct zip_kernel_ctx *zip_ctx)
> +static void zip_ctx_exit(struct zip_kernel_ctx *zip_ctx)
>  {
>         struct zip_operation  *comp_ctx   = &zip_ctx->zip_comp;
>         struct zip_operation  *dec_ctx = &zip_ctx->zip_decomp;
> @@ -119,9 +119,9 @@ void zip_ctx_exit(struct zip_kernel_ctx *zip_ctx)
>         zip_data_buf_free(dec_ctx->output, MAX_OUTPUT_BUFFER_SIZE);
>  }
> 
> -int zip_compress(const u8 *src, unsigned int slen,
> -                u8 *dst, unsigned int *dlen,
> -                struct zip_kernel_ctx *zip_ctx)
> +static int zip_compress(const u8 *src, unsigned int slen,
> +                       u8 *dst, unsigned int *dlen,
> +                       struct zip_kernel_ctx *zip_ctx)
>  {
>         struct zip_operation  *zip_ops   = NULL;
>         struct zip_state      *zip_state;
> @@ -155,9 +155,9 @@ int zip_compress(const u8 *src, unsigned int slen,
>         return ret;
>  }
> 
> -int zip_decompress(const u8 *src, unsigned int slen,
> -                  u8 *dst, unsigned int *dlen,
> -                  struct zip_kernel_ctx *zip_ctx)
> +static int zip_decompress(const u8 *src, unsigned int slen,
> +                         u8 *dst, unsigned int *dlen,
> +                         struct zip_kernel_ctx *zip_ctx)
>  {
>         struct zip_operation  *zip_ops   = NULL;
>         struct zip_state      *zip_state;
> --
> 2.17.1

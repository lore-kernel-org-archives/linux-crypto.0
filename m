From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH crypto-next 07/23] block: cryptoloop: Remove VLA usage of skcipher
Date: Mon, 24 Sep 2018 13:52:47 +0200
Message-ID: <CAKv+Gu8ynaVi1KCMNsjCU0ucAjFFku=ourh9Yc9Rizoc4ztvOQ@mail.gmail.com>
References: <20180919021100.3380-1-keescook@chromium.org> <20180919021100.3380-8-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919021100.3380-8-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 19 Sep 2018 at 04:11, Kees Cook <keescook@chromium.org> wrote:
>
> In the quest to remove all stack VLA usage from the kernel[1], this
> replaces struct crypto_skcipher and SKCIPHER_REQUEST_ON_STACK() usage
> with struct crypto_sync_skcipher and SYNC_SKCIPHER_REQUEST_ON_STACK(),
> which uses a fixed stack size.
>
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: linux-block@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/block/cryptoloop.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
> index 7033a4beda66..254ee7d54e91 100644
> --- a/drivers/block/cryptoloop.c
> +++ b/drivers/block/cryptoloop.c
> @@ -45,7 +45,7 @@ cryptoloop_init(struct loop_device *lo, const struct loop_info64 *info)
>         char cms[LO_NAME_SIZE];                 /* cipher-mode string */
>         char *mode;
>         char *cmsp = cms;                       /* c-m string pointer */
> -       struct crypto_skcipher *tfm;
> +       struct crypto_sync_skcipher *tfm;
>
>         /* encryption breaks for non sector aligned offsets */
>
> @@ -80,13 +80,13 @@ cryptoloop_init(struct loop_device *lo, const struct loop_info64 *info)
>         *cmsp++ = ')';
>         *cmsp = 0;
>
> -       tfm = crypto_alloc_skcipher(cms, 0, CRYPTO_ALG_ASYNC);
> +       tfm = crypto_alloc_sync_skcipher(cms, 0, 0);
>         if (IS_ERR(tfm))
>                 return PTR_ERR(tfm);
>
> -       err = crypto_skcipher_setkey(tfm, info->lo_encrypt_key,
> -                                    info->lo_encrypt_key_size);
> -
> +       err = crypto_sync_skcipher_setkey(tfm, info->lo_encrypt_key,
> +                                         info->lo_encrypt_key_size);
> +
>         if (err != 0)
>                 goto out_free_tfm;
>
> @@ -94,7 +94,7 @@ cryptoloop_init(struct loop_device *lo, const struct loop_info64 *info)
>         return 0;
>
>   out_free_tfm:
> -       crypto_free_skcipher(tfm);
> +       crypto_free_sync_skcipher(tfm);
>
>   out:
>         return err;
> @@ -109,8 +109,8 @@ cryptoloop_transfer(struct loop_device *lo, int cmd,
>                     struct page *loop_page, unsigned loop_off,
>                     int size, sector_t IV)
>  {
> -       struct crypto_skcipher *tfm = lo->key_data;
> -       SKCIPHER_REQUEST_ON_STACK(req, tfm);
> +       struct crypto_sync_skcipher *tfm = lo->key_data;
> +       SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
>         struct scatterlist sg_out;
>         struct scatterlist sg_in;
>
> @@ -119,7 +119,7 @@ cryptoloop_transfer(struct loop_device *lo, int cmd,
>         unsigned in_offs, out_offs;
>         int err;
>
> -       skcipher_request_set_tfm(req, tfm);
> +       skcipher_request_set_sync_tfm(req, tfm);
>         skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
>                                       NULL, NULL);
>

Does this work?

> @@ -175,9 +175,9 @@ cryptoloop_ioctl(struct loop_device *lo, int cmd, unsigned long arg)
>  static int
>  cryptoloop_release(struct loop_device *lo)
>  {
> -       struct crypto_skcipher *tfm = lo->key_data;
> +       struct crypto_sync_skcipher *tfm = lo->key_data;
>         if (tfm != NULL) {
> -               crypto_free_skcipher(tfm);
> +               crypto_free_sync_skcipher(tfm);
>                 lo->key_data = NULL;
>                 return 0;
>         }
> --
> 2.17.1
>

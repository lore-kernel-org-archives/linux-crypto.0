From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v6 17/18] crypto: ccm: Remove VLA usage
Date: Tue, 24 Jul 2018 18:57:44 +0200
Message-ID: <CAKv+Gu-D9FrOrFU0EmkPA52vrywCGZkFP9vUsyEovdby9dLj0g@mail.gmail.com>
References: <20180724164936.37477-1-keescook@chromium.org> <20180724164936.37477-18-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregk
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180724164936.37477-18-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 24 July 2018 at 18:49, Kees Cook <keescook@chromium.org> wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> In the quest to remove all stack VLA usage from the kernel[1], this
> drops AHASH_REQUEST_ON_STACK by preallocated the ahash request area
> with the skcipher area (which are not used at the same time).
>

-EGRAMMAR

> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  crypto/ccm.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/crypto/ccm.c b/crypto/ccm.c
> index 0a083342ec8c..b242fd0d3262 100644
> --- a/crypto/ccm.c
> +++ b/crypto/ccm.c
> @@ -50,7 +50,10 @@ struct crypto_ccm_req_priv_ctx {
>         u32 flags;
>         struct scatterlist src[3];
>         struct scatterlist dst[3];
> -       struct skcipher_request skreq;
> +       union {
> +               struct ahash_request ahreq;
> +               struct skcipher_request skreq;
> +       };
>  };
>
>  struct cbcmac_tfm_ctx {
> @@ -181,7 +184,7 @@ static int crypto_ccm_auth(struct aead_request *req, struct scatterlist *plain,
>         struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
>         struct crypto_aead *aead = crypto_aead_reqtfm(req);
>         struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
> -       AHASH_REQUEST_ON_STACK(ahreq, ctx->mac);
> +       struct ahash_request *ahreq = &pctx->ahreq;
>         unsigned int assoclen = req->assoclen;
>         struct scatterlist sg[3];
>         u8 *odata = pctx->odata;
> @@ -427,7 +430,7 @@ static int crypto_ccm_init_tfm(struct crypto_aead *tfm)
>         crypto_aead_set_reqsize(
>                 tfm,
>                 align + sizeof(struct crypto_ccm_req_priv_ctx) +
> -               crypto_skcipher_reqsize(ctr));
> +               max(crypto_ahash_reqsize(mac), crypto_skcipher_reqsize(ctr)));
>
>         return 0;
>
> --
> 2.17.1
>

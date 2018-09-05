From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/2] crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Wed, 5 Sep 2018 11:18:05 +0200
Message-ID: <CAKv+Gu9uJ+ZjBSCM=aU0GDvYR72cy2k8reXdLV5on3dOVw8KdQ@mail.gmail.com>
References: <20180904181629.20712-1-keescook@chromium.org> <20180904181629.20712-3-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180904181629.20712-3-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4 September 2018 at 20:16, Kees Cook <keescook@chromium.org> wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> caps the skcipher request size similar to other limits and adds a sanity
> check at registration. Looking at instrumented tcrypt output, the largest
> is for lrw:
>
>         crypt: testing lrw(aes)
>         crypto_skcipher_set_reqsize: 8
>         crypto_skcipher_set_reqsize: 88
>         crypto_skcipher_set_reqsize: 472
>

Are you sure this is a representative sampling? I haven't double
checked myself, but we have plenty of drivers for peripherals in
drivers/crypto that implement block ciphers, and they would not turn
up in tcrypt unless you are running on a platform that provides the
hardware in question.

> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/crypto/internal/skcipher.h | 3 +++
>  include/crypto/skcipher.h          | 4 +++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
> index d2926ecae2ac..6da811c0747e 100644
> --- a/include/crypto/internal/skcipher.h
> +++ b/include/crypto/internal/skcipher.h
> @@ -130,6 +130,9 @@ static inline struct crypto_skcipher *crypto_spawn_skcipher(
>  static inline int crypto_skcipher_set_reqsize(
>         struct crypto_skcipher *skcipher, unsigned int reqsize)
>  {
> +       if (WARN_ON(reqsize > SKCIPHER_MAX_REQSIZE))
> +               return -EINVAL;
> +
>         skcipher->reqsize = reqsize;
>
>         return 0;
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index 2f327f090c3e..c48e194438cf 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -139,9 +139,11 @@ struct skcipher_alg {
>         struct crypto_alg base;
>  };
>
> +#define SKCIPHER_MAX_REQSIZE   472
> +
>  #define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
>         char __##name##_desc[sizeof(struct skcipher_request) + \
> -               crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
> +               SKCIPHER_MAX_REQSIZE] CRYPTO_MINALIGN_ATTR; \
>         struct skcipher_request *name = (void *)__##name##_desc
>
>  /**
> --
> 2.17.1
>

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 3/5] crypto: chacha20 - Remove cra_alignmask
Date: Wed, 22 Nov 2017 20:30:27 +0000
Message-ID: <CAKv+Gu9w8iaL15gNiBJTeYxamSBk-fOnL5tAjo7yi8NfGPZGPQ@mail.gmail.com>
References: <20171122195139.121269-1-ebiggers3@gmail.com> <20171122195139.121269-4-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171122195139.121269-4-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 22 November 2017 at 19:51, Eric Biggers <ebiggers3@gmail.com> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Now that crypto_chacha20_setkey() and crypto_chacha20_init() use the
> unaligned access macros and crypto_xor() also accepts unaligned buffers,
> there is no need to have a cra_alignmask set for chacha20-generic.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/chacha20_generic.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
> index b5a10ebf1b82..bb4affbd591c 100644
> --- a/crypto/chacha20_generic.c
> +++ b/crypto/chacha20_generic.c
> @@ -105,7 +105,6 @@ static struct skcipher_alg alg = {
>         .base.cra_priority      = 100,
>         .base.cra_blocksize     = 1,
>         .base.cra_ctxsize       = sizeof(struct chacha20_ctx),
> -       .base.cra_alignmask     = sizeof(u32) - 1,
>         .base.cra_module        = THIS_MODULE,
>
>         .min_keysize            = CHACHA20_KEY_SIZE,
> --
> 2.15.0.448.gf294e3d99a-goog
>

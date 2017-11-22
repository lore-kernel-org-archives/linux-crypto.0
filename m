From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm64/aes - do not call crypto_unregister_skcipher
 twice on error
Date: Wed, 22 Nov 2017 08:55:14 +0000
Message-ID: <CAKv+Gu9m3v_iMdg8ngX-3x1HT+c8D52dhjJ=MiTp11VByD=ewA@mail.gmail.com>
References: <1511338114-39583-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Corentin Labbe <clabbe@baylibre.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511338114-39583-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Corentin,

On 22 November 2017 at 08:08, Corentin Labbe <clabbe@baylibre.com> wrote:
> When a cipher fail

fails

> to register in aes_init(), the error path go thought

goes through

> aes_exit() then crypto_unregister_skciphers().
> Since aes_exit calls also crypto_unregister_skcipher, this trigger a

triggers

> refcount_t: underflow; use-after-free.
>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  arch/arm64/crypto/aes-glue.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
> index 998ba519a026..9e42ec96243e 100644
> --- a/arch/arm64/crypto/aes-glue.c
> +++ b/arch/arm64/crypto/aes-glue.c
> @@ -664,7 +664,10 @@ static int __init aes_init(void)
>         return 0;
>
>  unregister_simds:
> -       aes_exit();
> +       for (i = 0; i < ARRAY_SIZE(aes_simd_algs); i++)
> +               if (aes_simd_algs[i])
> +                       simd_skcipher_free(aes_simd_algs[i]);
> +       crypto_unregister_shashes(mac_algs, ARRAY_SIZE(mac_algs));
>  unregister_ciphers:
>         crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
>         return err;
> --
> 2.13.6
>
>


Would this also fix it?

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 998ba519a026..2fa850e86aa8 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -665,6 +665,7 @@ static int __init aes_init(void)

 unregister_simds:
        aes_exit();
+       return err;
 unregister_ciphers:
        crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
        return err;

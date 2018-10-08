From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto/testmgr.c: fix sizeof() on COMP_BUF_SIZE
Date: Mon, 8 Oct 2018 13:39:29 +0200
Message-ID: <CAKv+Gu9s_0xCMvVJoTRRsEkXdDjLdKjj34=1U1y=o=r-OqLm8Q@mail.gmail.com>
References: <20181007115810.27779-1-michael@schupikov.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Michael Schupikov <michael@schupikov.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181007115810.27779-1-michael@schupikov.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7 October 2018 at 13:58, Michael Schupikov <michael@schupikov.de> wrote:
> After allocation, output and decomp_output both point to memory chunks of
> size COMP_BUF_SIZE. Then, only the first bytes are zeroed out using
> sizeof(COMP_BUF_SIZE) as parameter to memset(), because
> sizeof(COMP_BUF_SIZE) provides the size of the constant and not the size of
> allocated memory.
>
> Instead, the whole allocated memory is meant to be zeroed out. Use
> COMP_BUF_SIZE as parameter to memset() directly in order to accomplish
> this.
>
> Fixes: 336073840a872 ("crypto: testmgr - Allow different compression results")
>
> Signed-off-by: Michael Schupikov <michael@schupikov.de>

Nice catch

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/testmgr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index a1d42245082a..790aa3536631 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1400,8 +1400,8 @@ static int test_comp(struct crypto_comp *tfm,
>                 int ilen;
>                 unsigned int dlen = COMP_BUF_SIZE;
>
> -               memset(output, 0, sizeof(COMP_BUF_SIZE));
> -               memset(decomp_output, 0, sizeof(COMP_BUF_SIZE));
> +               memset(output, 0, COMP_BUF_SIZE);
> +               memset(decomp_output, 0, COMP_BUF_SIZE);
>
>                 ilen = ctemplate[i].inlen;
>                 ret = crypto_comp_compress(tfm, ctemplate[i].input,
> @@ -1445,7 +1445,7 @@ static int test_comp(struct crypto_comp *tfm,
>                 int ilen;
>                 unsigned int dlen = COMP_BUF_SIZE;
>
> -               memset(decomp_output, 0, sizeof(COMP_BUF_SIZE));
> +               memset(decomp_output, 0, COMP_BUF_SIZE);
>
>                 ilen = dtemplate[i].inlen;
>                 ret = crypto_comp_decompress(tfm, dtemplate[i].input,
> --
> 2.19.0
>

From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [dm-devel] [PATCH 05/11] crypto alg: Introduce max blocksize and
 alignmask
Date: Wed, 20 Jun 2018 16:40:31 -0700
Message-ID: <20180620234031.GC111712@gmail.com>
References: <20180620190408.45104-1-keescook@chromium.org>
 <20180620190408.45104-6-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        qat-linux@intel.com, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-crypto@vger.kernel.org,
        Lars Persson <larper@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180620190408.45104-6-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 20, 2018 at 12:04:02PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> exposes the existing upper bound on crypto block sizes for VLA removal,
> and introduces a new check for alignmask (current maximum in the kernel
> is 63 from manual inspection of all cra_alignmask settings).
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  crypto/algapi.c        | 5 ++++-
>  include/linux/crypto.h | 4 ++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index c0755cf4f53f..760a412b059c 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -57,7 +57,10 @@ static int crypto_check_alg(struct crypto_alg *alg)
>  	if (alg->cra_alignmask & (alg->cra_alignmask + 1))
>  		return -EINVAL;
>  
> -	if (alg->cra_blocksize > PAGE_SIZE / 8)
> +	if (alg->cra_blocksize > CRYPTO_ALG_MAX_BLOCKSIZE)
> +		return -EINVAL;
> +
> +	if (alg->cra_alignmask > CRYPTO_ALG_MAX_ALIGNMASK)
>  		return -EINVAL;
>  
>  	if (!alg->cra_type && (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 6eb06101089f..e76ffcbd5aa6 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -134,6 +134,10 @@
>   */
>  #define CRYPTO_MAX_ALG_NAME		128
>  
> +/* Maximum values for registered algorithms. */
> +#define CRYPTO_ALG_MAX_BLOCKSIZE    (PAGE_SIZE / 8)
> +#define CRYPTO_ALG_MAX_ALIGNMASK    63
> +

How do these differ from MAX_CIPHER_BLOCKSIZE and MAX_CIPHER_ALIGNMASK, and why
are they declared in different places?

- Eric

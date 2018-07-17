From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [dm-devel] [PATCH v5 05/11] crypto: ahash: Remove VLA usage
Date: Tue, 17 Jul 2018 09:39:36 -0700
Message-ID: <20180717163936.GB75957@gmail.com>
References: <20180717042150.37761-1-keescook@chromium.org>
 <20180717042150.37761-6-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Eric Biggers <ebiggers@google.com>, qat-linux@intel.com,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org, Lars Persson <larper@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180717042150.37761-6-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 16, 2018 at 09:21:44PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> introduces max size macros for ahash, as already done for shash, and
> adjust the crypto user to max state size.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  crypto/ahash.c        | 4 ++--
>  crypto/algif_hash.c   | 2 +-
>  include/crypto/hash.h | 3 +++
>  3 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index a64c143165b1..6435bdbe42fd 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -550,8 +550,8 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
>  {
>  	struct crypto_alg *base = &alg->halg.base;
>  
> -	if (alg->halg.digestsize > PAGE_SIZE / 8 ||
> -	    alg->halg.statesize > PAGE_SIZE / 8 ||
> +	if (alg->halg.digestsize > AHASH_MAX_DIGESTSIZE ||
> +	    alg->halg.statesize > AHASH_MAX_STATESIZE ||
>  	    alg->halg.statesize == 0)
>  		return -EINVAL;
>  
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index bfcf595fd8f9..8974ee8ebead 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -239,7 +239,7 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags,
>  	struct alg_sock *ask = alg_sk(sk);
>  	struct hash_ctx *ctx = ask->private;
>  	struct ahash_request *req = &ctx->req;
> -	char state[crypto_ahash_statesize(crypto_ahash_reqtfm(req)) ? : 1];
> +	char state[AHASH_MAX_STATESIZE];
>  	struct sock *sk2;
>  	struct alg_sock *ask2;
>  	struct hash_ctx *ctx2;
> diff --git a/include/crypto/hash.h b/include/crypto/hash.h
> index ae14cc0e0cdb..4fcd0e2368cd 100644
> --- a/include/crypto/hash.h
> +++ b/include/crypto/hash.h
> @@ -64,6 +64,9 @@ struct ahash_request {
>  	void *__ctx[] CRYPTO_MINALIGN_ATTR;
>  };
>  
> +#define AHASH_MAX_DIGESTSIZE	512
> +#define AHASH_MAX_STATESIZE	512
> +

Why is AHASH_MAX_DIGESTSIZE (512) so much larger than SHASH_MAX_DIGESTSIZE (64)?
I would have expected them to be the same.

- Eric

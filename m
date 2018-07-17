From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [dm-devel] [PATCH v5 10/11] crypto: ahash: Remove VLA usage for
 AHASH_REQUEST_ON_STACK
Date: Tue, 17 Jul 2018 09:43:58 -0700
Message-ID: <20180717164358.GC75957@gmail.com>
References: <20180717042150.37761-1-keescook@chromium.org>
 <20180717042150.37761-11-keescook@chromium.org>
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
In-Reply-To: <20180717042150.37761-11-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 16, 2018 at 09:21:49PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this caps
> the ahash request size similar to the other limits and adds a sanity
> check at initialization. AHASH_REQUEST_ON_STACK is special, though: it
> is only ever used for shash-wrapped ahash, so its size is bounded only
> by non-async hashes. A manual inspection of this shows the largest to be:
> sizeof(struct shash_desc) + SHASH_MAX_DESCSIZE
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  crypto/shash.c        |  9 ++++++++-
>  include/crypto/hash.h | 10 +++++++++-
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/shash.c b/crypto/shash.c
> index 8d4746b14dd5..e344560458cb 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -355,6 +355,7 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
>  	struct crypto_ahash *crt = __crypto_ahash_cast(tfm);
>  	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
>  	struct crypto_shash *shash;
> +	size_t reqsize;
>  
>  	if (!crypto_mod_get(calg))
>  		return -EAGAIN;
> @@ -365,6 +366,12 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
>  		return PTR_ERR(shash);
>  	}
>  
> +	reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
> +	if (WARN_ON(reqsize > AHASH_MAX_REQSIZE)) {
> +		crypto_mod_put(calg);
> +		return -EINVAL;
> +	}

'crypto_free_shash(shash);' instead of 'crypto_mod_put(calg);'

- Eric

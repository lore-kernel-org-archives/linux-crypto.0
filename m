From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 01/11] crypto: xcbc: Remove VLA usage
Date: Tue, 17 Jul 2018 14:35:01 +0800
Message-ID: <20180717063501.exqa54plsfjl4s73@gondor.apana.org.au>
References: <20180717042150.37761-1-keescook@chromium.org>
 <20180717042150.37761-2-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180717042150.37761-2-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 16, 2018 at 09:21:40PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this uses
> the maximum blocksize and adds a sanity check. For xcbc, the blocksize
> must always be 16, so use that, since it's already being enforced during
> instantiation.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  crypto/xcbc.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/xcbc.c b/crypto/xcbc.c
> index 25c75af50d3f..7aa03beed795 100644
> --- a/crypto/xcbc.c
> +++ b/crypto/xcbc.c
> @@ -57,6 +57,8 @@ struct xcbc_desc_ctx {
>  	u8 ctx[];
>  };
>  
> +#define XCBC_BLOCKSIZE	16
> +
>  static int crypto_xcbc_digest_setkey(struct crypto_shash *parent,
>  				     const u8 *inkey, unsigned int keylen)
>  {
> @@ -65,7 +67,10 @@ static int crypto_xcbc_digest_setkey(struct crypto_shash *parent,
>  	int bs = crypto_shash_blocksize(parent);
>  	u8 *consts = PTR_ALIGN(&ctx->ctx[0], alignmask + 1);
>  	int err = 0;
> -	u8 key1[bs];
> +	u8 key1[XCBC_BLOCKSIZE];
> +
> +	if (WARN_ON(bs > sizeof(key1)))
> +		return -EINVAL;

Please remove this.  You already checked it in xcbc_create.

In fact, you should just make bs XCBC_BLOCKSIZE unconditinoally
in this function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

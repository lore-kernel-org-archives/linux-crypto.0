From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [dm-devel] [PATCH 07/11] crypto: xcbc: Remove VLA usage
Date: Wed, 20 Jun 2018 16:46:23 -0700
Message-ID: <20180620234623.GE111712@gmail.com>
References: <20180620190408.45104-1-keescook@chromium.org>
 <20180620190408.45104-8-keescook@chromium.org>
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
In-Reply-To: <20180620190408.45104-8-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 20, 2018 at 12:04:04PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this uses
> the maximum blocksize and adds a sanity check.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  crypto/xcbc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/xcbc.c b/crypto/xcbc.c
> index 25c75af50d3f..016481b1f3ba 100644
> --- a/crypto/xcbc.c
> +++ b/crypto/xcbc.c
> @@ -65,7 +65,10 @@ static int crypto_xcbc_digest_setkey(struct crypto_shash *parent,
>  	int bs = crypto_shash_blocksize(parent);
>  	u8 *consts = PTR_ALIGN(&ctx->ctx[0], alignmask + 1);
>  	int err = 0;
> -	u8 key1[bs];
> +	u8 key1[CRYPTO_ALG_MAX_BLOCKSIZE];
> +
> +	if (WARN_ON(bs > sizeof(key1)))
> +		return -EINVAL;

Similarly, why not MAX_CIPHER_BLOCKSIZE?

Also, xcbc_create() only allows a 16-byte block size, and you made the API
enforce the maximum for algorithms anyway.  So I think the extra check here
isn't very worthwhile.

- Eric

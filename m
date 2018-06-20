From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 09/11] crypto: shash: Remove VLA usage in unaligned
 hashing
Date: Wed, 20 Jun 2018 16:57:21 -0700
Message-ID: <20180620235721.GF111712@gmail.com>
References: <20180620190408.45104-1-keescook@chromium.org>
 <20180620190408.45104-10-keescook@chromium.org>
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
In-Reply-To: <20180620190408.45104-10-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 20, 2018 at 12:04:06PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this uses
> the newly defined max alignment to perform unaligned hashing to avoid
> VLAs, and drops the helper function while adding sanity checks on the
> resulting buffer sizes.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  crypto/shash.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/crypto/shash.c b/crypto/shash.c
> index ab6902c6dae7..1bb58209330a 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -73,13 +73,6 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
>  }
>  EXPORT_SYMBOL_GPL(crypto_shash_setkey);
>  
> -static inline unsigned int shash_align_buffer_size(unsigned len,
> -						   unsigned long mask)
> -{
> -	typedef u8 __aligned_largest u8_aligned;
> -	return len + (mask & ~(__alignof__(u8_aligned) - 1));
> -}
> -
>  static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
>  				  unsigned int len)
>  {
> @@ -88,11 +81,14 @@ static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
>  	unsigned long alignmask = crypto_shash_alignmask(tfm);
>  	unsigned int unaligned_len = alignmask + 1 -
>  				     ((unsigned long)data & alignmask);
> -	u8 ubuf[shash_align_buffer_size(unaligned_len, alignmask)]
> -		__aligned_largest;
> +	u8 ubuf[CRYPTO_ALG_MAX_ALIGNMASK]
> +		__aligned(CRYPTO_ALG_MAX_ALIGNMASK + 1);
>  	u8 *buf = PTR_ALIGN(&ubuf[0], alignmask + 1);
>  	int err;

Are you sure that __attribute__((aligned(64))) works correctly on stack
variables on all architectures?

And if it is expected to work, then why is the buffer still aligned by hand on
the very next line?

>  
> +	if (WARN_ON(buf + unaligned_len > ubuf + sizeof(ubuf)))
> +		return -EINVAL;
> +
>  	if (unaligned_len > len)
>  		unaligned_len = len;
>  
> @@ -124,11 +120,14 @@ static int shash_final_unaligned(struct shash_desc *desc, u8 *out)
>  	unsigned long alignmask = crypto_shash_alignmask(tfm);
>  	struct shash_alg *shash = crypto_shash_alg(tfm);
>  	unsigned int ds = crypto_shash_digestsize(tfm);
> -	u8 ubuf[shash_align_buffer_size(ds, alignmask)]
> -		__aligned_largest;
> +	u8 ubuf[SHASH_MAX_DIGESTSIZE]
> +		__aligned(CRYPTO_ALG_MAX_ALIGNMASK + 1);
>  	u8 *buf = PTR_ALIGN(&ubuf[0], alignmask + 1);
>  	int err;

Same questions here.

>  
> +	if (WARN_ON(buf + ds > ubuf + sizeof(ubuf)))
> +		return -EINVAL;
> +
>  	err = shash->final(desc, buf);
>  	if (err)
>  		goto out;
> -- 

- Eric

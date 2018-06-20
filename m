From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [dm-devel] [PATCH 06/11] crypto: cbc: Remove VLA usage
Date: Wed, 20 Jun 2018 16:42:33 -0700
Message-ID: <20180620234233.GD111712@gmail.com>
References: <20180620190408.45104-1-keescook@chromium.org>
 <20180620190408.45104-7-keescook@chromium.org>
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
In-Reply-To: <20180620190408.45104-7-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 20, 2018 at 12:04:03PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> uses the upper bounds on blocksize.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/crypto/cbc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/crypto/cbc.h b/include/crypto/cbc.h
> index f5b8bfc22e6d..260096bcf99b 100644
> --- a/include/crypto/cbc.h
> +++ b/include/crypto/cbc.h
> @@ -113,7 +113,7 @@ static inline int crypto_cbc_decrypt_inplace(
>  	unsigned int bsize = crypto_skcipher_blocksize(tfm);
>  	unsigned int nbytes = walk->nbytes;
>  	u8 *src = walk->src.virt.addr;
> -	u8 last_iv[bsize];
> +	u8 last_iv[CRYPTO_ALG_MAX_BLOCKSIZE];
>  

Why not MAX_CIPHER_BLOCKSIZE?

- Eric

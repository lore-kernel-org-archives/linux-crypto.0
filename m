From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 06/11] crypto: cbc: Remove VLA usage
Date: Wed, 20 Jun 2018 20:16:39 +0000
Message-ID: <1e08a813-1872-4372-1c2c-d8fd02dfb63a@c-s.fr>
References: <20180620190408.45104-1-keescook@chromium.org>
 <20180620190408.45104-7-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620190408.45104-7-keescook@chromium.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 06/20/2018 07:04 PM, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> uses the upper bounds on blocksize.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

crypto/cbc.c: In function ‘crypto_cbc_decrypt’:
crypto/cbc.c:79:1: warning: the frame size of 2144 bytes is larger than 
1024 bytes [-Wframe-larger-than=]

Christophe

> ---
>   include/crypto/cbc.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/crypto/cbc.h b/include/crypto/cbc.h
> index f5b8bfc22e6d..260096bcf99b 100644
> --- a/include/crypto/cbc.h
> +++ b/include/crypto/cbc.h
> @@ -113,7 +113,7 @@ static inline int crypto_cbc_decrypt_inplace(
>   	unsigned int bsize = crypto_skcipher_blocksize(tfm);
>   	unsigned int nbytes = walk->nbytes;
>   	u8 *src = walk->src.virt.addr;
> -	u8 last_iv[bsize];
> +	u8 last_iv[CRYPTO_ALG_MAX_BLOCKSIZE];
>   
>   	/* Start of the last block. */
>   	src += nbytes - (nbytes & (bsize - 1)) - bsize;
> 

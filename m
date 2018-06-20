From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 11/11] crypto: skcipher: Remove VLA usage for
 SKCIPHER_REQUEST_ON_STACK
Date: Wed, 20 Jun 2018 20:22:34 +0000
Message-ID: <6537de88-cd81-1c96-afc0-45af17a07729@c-s.fr>
References: <20180620190408.45104-1-keescook@chromium.org>
 <20180620190408.45104-12-keescook@chromium.org>
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
In-Reply-To: <20180620190408.45104-12-keescook@chromium.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 06/20/2018 07:04 PM, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> caps the skcipher request size similar to other limits and adds a sanity
> check at registration.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

crypto/echainiv.c: In function ‘echainiv_encrypt’:
crypto/echainiv.c:88:1: warning: the frame size of 2120 bytes is larger 
than 1024 bytes [-Wframe-larger-than=]
crypto/authenc.c: In function ‘crypto_authenc_copy_assoc’:
crypto/authenc.c:197:1: warning: the frame size of 2120 bytes is larger 
than 1024 bytes [-Wframe-larger-than=]
crypto/authencesn.c: In function ‘crypto_authenc_esn_copy’:
crypto/authencesn.c:194:1: warning: the frame size of 2120 bytes is 
larger than 1024 bytes [-Wframe-larger-than=]
crypto/algif_aead.c: In function ‘crypto_aead_copy_sgl’:
crypto/algif_aead.c:90:1: warning: the frame size of 2120 bytes is 
larger than 1024 bytes [-Wframe-larger-than=]

Christophe

> ---
>   include/crypto/internal/skcipher.h | 1 +
>   include/crypto/skcipher.h          | 4 +++-
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
> index e42f7063f245..5035482cbe68 100644
> --- a/include/crypto/internal/skcipher.h
> +++ b/include/crypto/internal/skcipher.h
> @@ -130,6 +130,7 @@ static inline struct crypto_skcipher *crypto_spawn_skcipher(
>   static inline void crypto_skcipher_set_reqsize(
>   	struct crypto_skcipher *skcipher, unsigned int reqsize)
>   {
> +	BUG_ON(reqsize > SKCIPHER_MAX_REQSIZE);
>   	skcipher->reqsize = reqsize;
>   }
>   
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index 2f327f090c3e..25294d0089b2 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -139,9 +139,11 @@ struct skcipher_alg {
>   	struct crypto_alg base;
>   };
>   
> +#define SKCIPHER_MAX_REQSIZE	(PAGE_SIZE / 8)
> +
>   #define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
>   	char __##name##_desc[sizeof(struct skcipher_request) + \
> -		crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
> +		SKCIPHER_MAX_REQSIZE] CRYPTO_MINALIGN_ATTR; \
>   	struct skcipher_request *name = (void *)__##name##_desc
>   
>   /**
> 

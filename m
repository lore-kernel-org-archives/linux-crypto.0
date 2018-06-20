From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 03/11] crypto: ahash: Remove VLA usage
Date: Wed, 20 Jun 2018 20:13:01 +0000
Message-ID: <d6c501ae-8429-3c6c-2368-16a1f68372e2@c-s.fr>
References: <20180620190408.45104-1-keescook@chromium.org>
 <20180620190408.45104-4-keescook@chromium.org>
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
In-Reply-To: <20180620190408.45104-4-keescook@chromium.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 06/20/2018 07:04 PM, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> introduces max size macros for ahash, as already done for shash, and
> adjust the crypto user to max state size.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

I get:

crypto/algif_hash.c: In function ‘hash_accept’:
crypto/algif_hash.c:276:1: warning: the frame size of 2048 bytes is 
larger than 1024 bytes [-Wframe-larger-than=]

Christophe

> ---
>   crypto/ahash.c        | 4 ++--
>   crypto/algif_hash.c   | 2 +-
>   include/crypto/hash.h | 3 +++
>   3 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index a64c143165b1..6435bdbe42fd 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -550,8 +550,8 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
>   {
>   	struct crypto_alg *base = &alg->halg.base;
>   
> -	if (alg->halg.digestsize > PAGE_SIZE / 8 ||
> -	    alg->halg.statesize > PAGE_SIZE / 8 ||
> +	if (alg->halg.digestsize > AHASH_MAX_DIGESTSIZE ||
> +	    alg->halg.statesize > AHASH_MAX_STATESIZE ||
>   	    alg->halg.statesize == 0)
>   		return -EINVAL;
>   
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index bfcf595fd8f9..8974ee8ebead 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -239,7 +239,7 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags,
>   	struct alg_sock *ask = alg_sk(sk);
>   	struct hash_ctx *ctx = ask->private;
>   	struct ahash_request *req = &ctx->req;
> -	char state[crypto_ahash_statesize(crypto_ahash_reqtfm(req)) ? : 1];
> +	char state[AHASH_MAX_STATESIZE];
>   	struct sock *sk2;
>   	struct alg_sock *ask2;
>   	struct hash_ctx *ctx2;
> diff --git a/include/crypto/hash.h b/include/crypto/hash.h
> index 308aad8bf523..b9df568dc98e 100644
> --- a/include/crypto/hash.h
> +++ b/include/crypto/hash.h
> @@ -64,6 +64,9 @@ struct ahash_request {
>   	void *__ctx[] CRYPTO_MINALIGN_ATTR;
>   };
>   
> +#define AHASH_MAX_DIGESTSIZE	(PAGE_SIZE / 8)
> +#define AHASH_MAX_STATESIZE	(PAGE_SIZE / 8)
> +
>   #define AHASH_REQUEST_ON_STACK(name, ahash) \
>   	char __##name##_desc[sizeof(struct ahash_request) + \
>   		crypto_ahash_reqsize(ahash)] CRYPTO_MINALIGN_ATTR; \
> 

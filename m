From: Alexander Stein <alexander.stein@systec-electronic.com>
Subject: Re: [PATCH 2/2] crypto: skcipher: Remove VLA usage for
 SKCIPHER_REQUEST_ON_STACK
Date: Wed, 05 Sep 2018 08:05:29 +0200
Message-ID: <2109885.PdqaXYh4EC@ws-140106>
References: <20180904181629.20712-1-keescook@chromium.org>
 <20180904181629.20712-3-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
 Arnaud Ebalard <arno@natisbad.org>, Herbert Xu <herbert@gondor.apana.org.au>,
 Boris Brezillon <boris.brezillon@bootlin.com>,
 Antoine Tenart <antoine.tenart@bootlin.com>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org,
 Gilad Ben-Yossef <gilad@benyossef.com>, Chen-Yu Tsai <wens@csie.org>,
 Eric Biggers <ebiggers@google.com>, linux-crypto@vger.kernel.org,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Philippe Ombredanne <pombredanne@nexb.com>,
 Corentin Labbe <clabbe.montjoie@gmail.com>,
 linux-arm-kernel@lists.infradead.org, Christian Lamparter <chunkeey@gmail.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180904181629.20712-3-keescook@chromium.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday, September 4, 2018, 8:16:29 PM CEST Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> caps the skcipher request size similar to other limits and adds a sanity
> check at registration. Looking at instrumented tcrypt output, the largest
> is for lrw:
> 
> 	crypt: testing lrw(aes)
> 	crypto_skcipher_set_reqsize: 8
> 	crypto_skcipher_set_reqsize: 88
> 	crypto_skcipher_set_reqsize: 472
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/crypto/internal/skcipher.h | 3 +++
>  include/crypto/skcipher.h          | 4 +++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
> index d2926ecae2ac..6da811c0747e 100644
> --- a/include/crypto/internal/skcipher.h
> +++ b/include/crypto/internal/skcipher.h
> @@ -130,6 +130,9 @@ static inline struct crypto_skcipher *crypto_spawn_skcipher(
>  static inline int crypto_skcipher_set_reqsize(
>  	struct crypto_skcipher *skcipher, unsigned int reqsize)
>  {
> +	if (WARN_ON(reqsize > SKCIPHER_MAX_REQSIZE))
> +		return -EINVAL;
> +
>  	skcipher->reqsize = reqsize;
>  
>  	return 0;
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index 2f327f090c3e..c48e194438cf 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -139,9 +139,11 @@ struct skcipher_alg {
>  	struct crypto_alg base;
>  };
>  
> +#define SKCIPHER_MAX_REQSIZE	472
> +
>  #define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
>  	char __##name##_desc[sizeof(struct skcipher_request) + \
> -		crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
> +		SKCIPHER_MAX_REQSIZE] CRYPTO_MINALIGN_ATTR; \
>  	struct skcipher_request *name = (void *)__##name##_desc

Now tfm could be removed from the macro arguments, no?

Best regards,
Alexander

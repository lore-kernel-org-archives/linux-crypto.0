From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH RFC 2/3] crypto: Implement a generic crypto statistics
Date: Wed, 20 Dec 2017 15:37:13 -0800
Message-ID: <f2047b92-fc5c-a141-e533-a8ccb798ecac@infradead.org>
References: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
 <1513800567-12764-3-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513800567-12764-3-git-send-email-clabbe@baylibre.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 12/20/2017 12:09 PM, Corentin Labbe wrote:
> This patch implement a generic way to get statistics about all crypto
> usages.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  crypto/Kconfig             |  11 +++
>  crypto/ahash.c             |  18 +++++
>  crypto/algapi.c            | 186 +++++++++++++++++++++++++++++++++++++++++++++
>  crypto/rng.c               |   3 +
>  include/crypto/acompress.h |  10 +++
>  include/crypto/akcipher.h  |  12 +++
>  include/crypto/kpp.h       |   9 +++
>  include/crypto/rng.h       |   5 ++
>  include/crypto/skcipher.h  |   8 ++
>  include/linux/crypto.h     |  22 ++++++
>  10 files changed, 284 insertions(+)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index d6e9b60fc063..69f1822a026b 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1781,6 +1781,17 @@ config CRYPTO_USER_API_AEAD
>  	  This option enables the user-spaces interface for AEAD
>  	  cipher algorithms.
>  
> +config CRYPTO_STATS
> +	bool "Crypto usage statistics for User-space"
> +	help
> +	  This option enables the gathering of crypto stats.
> +	  This will collect:
> +	  - encrypt/decrypt size and numbers of symmeric operations

	                                        symmetric

> +	  - compress/decompress size and numbers of compress operations
> +	  - size and numbers of hash operations
> +	  - encrypt/decrypt/sign/verify numbers for asymmetric operations
> +	  - generate/seed numbers for rng operations
> +
>  config CRYPTO_HASH_INFO
>  	bool
>  

> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index b8f6122f37e9..4fca4576af78 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -20,11 +20,158 @@
>  #include <linux/rtnetlink.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
> +#include <linux/kobject.h>
>  
>  #include "internal.h"
>  

> +static ssize_t fcrypto_stat_type(struct kobject *kobj,
> +				 struct kobj_attribute *attr, char *buf)
> +{
> +	struct crypto_alg *alg;
> +	u32 type;
> +
> +	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
> +	type = (alg->cra_flags & CRYPTO_ALG_TYPE_MASK);
> +	if (type == CRYPTO_ALG_TYPE_ABLKCIPHER ||
> +	    type == CRYPTO_ALG_TYPE_SKCIPHER ||
> +	    type == CRYPTO_ALG_TYPE_CIPHER ||
> +	    type == CRYPTO_ALG_TYPE_BLKCIPHER
> +		)
> +		return snprintf(buf, 9, "cipher\n");
> +	if (type == CRYPTO_ALG_TYPE_AHASH ||
> +	    type == CRYPTO_ALG_TYPE_HASH
> +		)
> +		return snprintf(buf, 9, "hash\n");
> +	if (type == CRYPTO_ALG_TYPE_COMPRESS ||
> +	    type == CRYPTO_ALG_TYPE_SCOMPRESS)
> +		return snprintf(buf, 11, "compress\n");
> +	if (type == CRYPTO_ALG_TYPE_RNG)
> +		return snprintf(buf, 9, "rng\n");
> +	if (type == CRYPTO_ALG_TYPE_AKCIPHER)
> +		return snprintf(buf, 11, "asymetric\n");

		                          asymmetric

> +	if (type == CRYPTO_ALG_TYPE_KPP)
> +		return snprintf(buf, 4, "kpp\n");
> +	return snprintf(buf, 16, "unknown %x\n", type);
> +}


-- 
~Randy

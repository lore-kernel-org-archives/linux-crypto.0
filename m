Return-Path: <SRS0=a5OM=NO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726904AbeKDHcO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Nov 2018 02:32:14 -0500
Date: Sat, 3 Nov 2018 15:19:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Corentin Labbe <clabbe@baylibre.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] crypto: Implement a generic crypto statistics
Message-ID: <20181103221935.GB808@sol.localdomain>
References: <1537351855-16618-1-git-send-email-clabbe@baylibre.com>
 <1537351855-16618-2-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537351855-16618-2-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Corentin,

On Wed, Sep 19, 2018 at 10:10:54AM +0000, Corentin Labbe wrote:
> This patch implement a generic way to get statistics about all crypto
> usages.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  crypto/Kconfig                               |  11 +
>  crypto/Makefile                              |   1 +
>  crypto/ahash.c                               |  21 +-
>  crypto/algapi.c                              |   8 +
>  crypto/{crypto_user.c => crypto_user_base.c} |   9 +-
>  crypto/crypto_user_stat.c                    | 463 +++++++++++++++++++++++++++
>  crypto/rng.c                                 |   1 +
>  include/crypto/acompress.h                   |  38 ++-
>  include/crypto/aead.h                        |  51 ++-
>  include/crypto/akcipher.h                    |  76 ++++-
>  include/crypto/hash.h                        |  32 +-
>  include/crypto/internal/cryptouser.h         |   8 +
>  include/crypto/kpp.h                         |  51 ++-
>  include/crypto/rng.h                         |  29 +-
>  include/crypto/skcipher.h                    |  44 ++-
>  include/linux/crypto.h                       | 110 ++++++-
>  include/uapi/linux/cryptouser.h              |  52 +++
>  17 files changed, 970 insertions(+), 35 deletions(-)
>  rename crypto/{crypto_user.c => crypto_user_base.c} (97%)
>  create mode 100644 crypto/crypto_user_stat.c
>  create mode 100644 include/crypto/internal/cryptouser.h
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 90f2811fac5f..4ef95b0b25a3 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1799,6 +1799,17 @@ config CRYPTO_USER_API_AEAD
>  	  This option enables the user-spaces interface for AEAD
>  	  cipher algorithms.
>  
> +config CRYPTO_STATS
> +	bool "Crypto usage statistics for User-space"
> +	help
> +	  This option enables the gathering of crypto stats.
> +	  This will collect:
> +	  - encrypt/decrypt size and numbers of symmeric operations
> +	  - compress/decompress size and numbers of compress operations
> +	  - size and numbers of hash operations
> +	  - encrypt/decrypt/sign/verify numbers for asymmetric operations
> +	  - generate/seed numbers for rng operations
> +
>  config CRYPTO_HASH_INFO
>  	bool
>  
> diff --git a/crypto/Makefile b/crypto/Makefile
> index d719843f8b6e..ff5c2bbda04a 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -54,6 +54,7 @@ cryptomgr-y := algboss.o testmgr.o
>  
>  obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
>  obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
> +crypto_user-y := crypto_user_base.o crypto_user_stat.o
>  obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
>  obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
>  obj-$(CONFIG_CRYPTO_VMAC) += vmac.o

Why is crypto_user_stat.c always being compiled when CONFIG_CRYPTO_USER is
enabled, even when CONFIG_CRYPTO_STATS is not?

When CONFIG_CRYPTO_STATS is disabled, all the crypto stat stuff should be
stubbed out so that crypto_user_stat.c doesn't need to be compiled.

[...]
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index e8839d3a7559..3634ad6fe202 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -454,6 +454,33 @@ struct compress_alg {
>   * @cra_refcnt: internally used
>   * @cra_destroy: internally used
>   *
> + * All following statistics are for this crypto_alg
> + * @encrypt_cnt:	number of encrypt requests
> + * @decrypt_cnt:	number of decrypt requests
> + * @compress_cnt:	number of compress requests
> + * @decompress_cnt:	number of decompress requests
> + * @generate_cnt:	number of RNG generate requests
> + * @seed_cnt:		number of times the rng was seeded
> + * @hash_cnt:		number of hash requests
> + * @sign_cnt:		number of sign requests
> + * @setsecret_cnt:	number of setsecrey operation
> + * @generate_public_key_cnt:	number of generate_public_key operation
> + * @verify_cnt:			number of verify operation
> + * @compute_shared_secret_cnt:	number of compute_shared_secret operation
> + * @encrypt_tlen:	total data size handled by encrypt requests
> + * @decrypt_tlen:	total data size handled by decrypt requests
> + * @compress_tlen:	total data size handled by compress requests
> + * @decompress_tlen:	total data size handled by decompress requests
> + * @generate_tlen:	total data size of generated data by the RNG
> + * @hash_tlen:		total data size hashed
> + * @akcipher_err_cnt:	number of error for akcipher requests
> + * @cipher_err_cnt:	number of error for akcipher requests
> + * @compress_err_cnt:	number of error for akcipher requests
> + * @aead_err_cnt:	number of error for akcipher requests
> + * @hash_err_cnt:	number of error for akcipher requests
> + * @rng_err_cnt:	number of error for akcipher requests
> + * @kpp_err_cnt:	number of error for akcipher requests
> + *
>   * The struct crypto_alg describes a generic Crypto API algorithm and is common
>   * for all of the transformations. Any variable not documented here shall not
>   * be used by a cipher implementation as it is internal to the Crypto API.
> @@ -487,6 +514,45 @@ struct crypto_alg {
>  	void (*cra_destroy)(struct crypto_alg *alg);
>  	
>  	struct module *cra_module;
> +
> +	union {
> +		atomic_t encrypt_cnt;
> +		atomic_t compress_cnt;
> +		atomic_t generate_cnt;
> +		atomic_t hash_cnt;
> +		atomic_t setsecret_cnt;
> +	};
> +	union {
> +		atomic64_t encrypt_tlen;
> +		atomic64_t compress_tlen;
> +		atomic64_t generate_tlen;
> +		atomic64_t hash_tlen;
> +	};
> +	union {
> +		atomic_t akcipher_err_cnt;
> +		atomic_t cipher_err_cnt;
> +		atomic_t compress_err_cnt;
> +		atomic_t aead_err_cnt;
> +		atomic_t hash_err_cnt;
> +		atomic_t rng_err_cnt;
> +		atomic_t kpp_err_cnt;
> +	};
> +	union {
> +		atomic_t decrypt_cnt;
> +		atomic_t decompress_cnt;
> +		atomic_t seed_cnt;
> +		atomic_t generate_public_key_cnt;
> +	};
> +	union {
> +		atomic64_t decrypt_tlen;
> +		atomic64_t decompress_tlen;
> +	};
> +	union {
> +		atomic_t verify_cnt;
> +		atomic_t compute_shared_secret_cnt;
> +	};
> +	atomic_t sign_cnt;
> +
>  } CRYPTO_MINALIGN_ATTR;

The new fields here should all be behind CONFIG_CRYPTO_STATS.

Ideally there would be zero overhead when CONFIG_CRYPTO_STATS is disabled.
That's not quite the case currently.

- Eric

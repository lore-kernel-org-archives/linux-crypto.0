Return-Path: <SRS0=5PE5=PU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfALF2C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Jan 2019 00:28:02 -0500
Date: Fri, 11 Jan 2019 21:27:59 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/6] crypto: kdf - SP800-108 Key Derivation Function
Message-ID: <20190112052758.GD639@sol.localdomain>
References: <20190103143227.9138-1-jlee@suse.com>
 <20190109082103.GA8586@sol.localdomain>
 <9733066.Vrs4h5eWcW@positron.chronox.de>
 <1830918.5I3Y3k8tQf@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1830918.5I3Y3k8tQf@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 11, 2019 at 08:10:02PM +0100, Stephan Müller wrote:
> The SP800-108 compliant Key Derivation Function is implemented as a
> random number generator considering that it behaves like a deterministic
> RNG.
> 
> All three KDF types specified in SP800-108 are implemented.
> 
> The code comments provide details about how to invoke the different KDF
> types.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/Kconfig  |   7 +
>  crypto/Makefile |   1 +
>  crypto/kdf.c    | 492 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 500 insertions(+)
>  create mode 100644 crypto/kdf.c
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 86960aa53e0f..cc80d89e0cf5 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -561,6 +561,13 @@ config CRYPTO_HMAC
>  	  HMAC: Keyed-Hashing for Message Authentication (RFC2104).
>  	  This is required for IPSec.
>  
> +config CRYPTO_KDF
> +	tristate "Key Derivation Function (SP800-108)"
> +	select CRYPTO_RNG
> +	help
> +	  Support for KDF compliant to SP800-108. All three types of
> +	  KDF specified in SP800-108 are implemented.
> +
>  config CRYPTO_XCBC
>  	tristate "XCBC support"
>  	select CRYPTO_HASH
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 799ed5e94606..69a0bb64b0ac 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -58,6 +58,7 @@ crypto_user-y := crypto_user_base.o
>  crypto_user-$(CONFIG_CRYPTO_STATS) += crypto_user_stat.o
>  obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
>  obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
> +obj-$(CONFIG_CRYPTO_KDF) += kdf.o

This naming is too generic.  CONFIG_CRYPTO_KDF and kdf.c imply that this is
related to all KDFs.  But actually it is an implementation of a few specific
KDFs.  Can you give it a clearer name, like KDF_SP800?

- Eric

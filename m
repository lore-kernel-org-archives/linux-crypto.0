From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: atmel - refine Kconfig dependencies
Date: Sat, 11 Feb 2017 18:55:29 +0800
Message-ID: <20170211105529.GI855@gondor.apana.org.au>
References: <20170206123240.1698839-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170206123240.1698839-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 06, 2017 at 01:32:15PM +0100, Arnd Bergmann wrote:
> With the new authenc support, we get a harmless Kconfig warning:
> 
> warning: (CRYPTO_DEV_ATMEL_AUTHENC) selects CRYPTO_DEV_ATMEL_SHA which has unmet direct dependencies (CRYPTO && CRYPTO_HW && ARCH_AT91)
> 
> The problem is that each of the options has slightly different dependencies,
> although they all seem to want the same thing: allow building for real AT91
> targets that actually have the hardware, and possibly for compile testing.
> 
> This makes all four options consistent: instead of depending on a particular
> dmaengine implementation, we depend on the ARM platform, CONFIG_COMPILE_TEST
> as an alternative when that is turned off. This makes the 'select' statements
> work correctly.
> 
> Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to authenc(hmac(shaX), Y(aes)) modes")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

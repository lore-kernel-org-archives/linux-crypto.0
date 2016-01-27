From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/2] crypto: jitterentropy - always select CRYPTO_RNG
Date: Wed, 27 Jan 2016 22:17:46 +0800
Message-ID: <20160127141746.GC1601@gondor.apana.org.au>
References: <1453815902-3070323-1-git-send-email-arnd@arndb.de>
 <1453816035-3070440-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453816035-3070440-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 26, 2016 at 02:47:10PM +0100, Arnd Bergmann wrote:
> When building the jitterentropy driver by itself, we get a link error
> when CRYPTO_RNG is not enabled as well:
> 
> crypto/built-in.o: In function `jent_mod_init':
> jitterentropy-kcapi.c:(.init.text+0x98): undefined reference to `crypto_register_rng'
> crypto/built-in.o: In function `jent_mod_exit':
> jitterentropy-kcapi.c:(.exit.text+0x60): undefined reference to `crypto_unregister_rng'
> 
> This adds a 'select CRYPTO_RNG' to CRYPTO_JITTERENTROPY to ensure the API
> is always there when it's used, not just when DRBG is also enabled.
> CRYPTO_DRBG would set it implicitly through CRYPTO_JITTERENTROPY now,
> but this leaves it in place to make it explicit what the driver does.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

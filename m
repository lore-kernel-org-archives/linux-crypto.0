From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: hash - select CRYPTO_HASH where needed
Date: Tue, 26 Jan 2016 22:48:54 +0800
Message-ID: <20160126144854.GB23264@gondor.apana.org.au>
References: <1453740685-1980366-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453740685-1980366-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jan 25, 2016 at 05:51:21PM +0100, Arnd Bergmann wrote:
> The ghash and poly1305 hash implementations can be enabled when
> CONFIG_CRYPTO_HASH is turned off, causing a link error:
> 
> crypto/built-in.o: In function `ghash_mod_init':
> (.init.text+0xd0): undefined reference to `crypto_register_shash'
> crypto/built-in.o: In function `ghash_mod_exit':
> (.exit.text+0xb4): undefined reference to `crypto_unregister_shash'
> crypto/built-in.o: In function `poly1305_mod_init':
> (.init.text+0xb4): undefined reference to `crypto_register_shash'
> crypto/built-in.o: In function `poly1305_mod_exit':
> (.exit.text+0x98): undefined reference to `crypto_unregister_shash'
> 
> This adds an explicit 'select', like all other hashes have it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

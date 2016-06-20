From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam: fix misspelled upper_32_bits
Date: Mon, 20 Jun 2016 19:34:38 +0800
Message-ID: <20160620113438.GB10773@gondor.apana.org.au>
References: <20160616090609.1041337-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160616090609.1041337-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 16, 2016 at 11:05:46AM +0200, Arnd Bergmann wrote:
> An endianess fix mistakenly used higher_32_bits() instead of
> upper_32_bits(), and that doesn't exist:
> 
> drivers/crypto/caam/desc_constr.h: In function 'append_ptr':
> drivers/crypto/caam/desc_constr.h:84:75: error: implicit declaration of function 'higher_32_bits' [-Werror=implicit-function-declaration]
>   *offset = cpu_to_caam_dma(ptr);
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 261ea058f016 ("crypto: caam - handle core endianness != caam endianness")

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

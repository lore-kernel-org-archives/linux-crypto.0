From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chcr: select CRYPTO_GF128MUL
Date: Fri, 22 Dec 2017 19:33:59 +1100
Message-ID: <20171222083359.GC29663@gondor.apana.org.au>
References: <20171205101032.985159-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harsh@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46164 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753417AbdLVIeJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 03:34:09 -0500
Content-Disposition: inline
In-Reply-To: <20171205101032.985159-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 05, 2017 at 11:10:26AM +0100, Arnd Bergmann wrote:
> Without the gf128mul library support, we can run into a link
> error:
> 
> drivers/crypto/chelsio/chcr_algo.o: In function `chcr_update_tweak':
> chcr_algo.c:(.text+0x7e0): undefined reference to `gf128mul_x8_ble'
> 
> This adds a Kconfig select statement for it, next to the ones we
> already have.
> 
> Fixes: b8fd1f4170e7 ("crypto: chcr - Add ctr mode and process large sg entries for cipher")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

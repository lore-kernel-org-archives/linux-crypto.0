From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - select CONFIG_CRYPTO_RSA
Date: Wed, 9 Aug 2017 21:57:12 +0800
Message-ID: <20170809135712.GE743@gondor.apana.org.au>
References: <20170731211104.2012741-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170731211104.2012741-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 31, 2017 at 11:10:57PM +0200, Arnd Bergmann wrote:
> Without the base RSA code, we run into a link error:
> 
> ERROR: "rsa_parse_pub_key" [drivers/crypto/ccp/ccp-crypto.ko] undefined!
> ERROR: "rsa_parse_priv_key" [drivers/crypto/ccp/ccp-crypto.ko] undefined!
> 
> Like the other drivers implementing RSA in hardware, this
> can be avoided by always enabling the base support when we build
> CCP.
> 
> Fixes: ceeec0afd684 ("crypto: ccp - Add support for RSA on the CCP")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

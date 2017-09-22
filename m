From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: axis - hide an unused variable
Date: Fri, 22 Sep 2017 18:14:21 +0800
Message-ID: <20170922101420.GJ16270@gondor.apana.org.au>
References: <20170824222016.731342-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Niklas Cassel <niklas.cassel@axis.com>,
        "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@axis.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170824222016.731342-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 25, 2017 at 12:19:54AM +0200, Arnd Bergmann wrote:
> Without CONFIG_DEBUG_FS, we get a harmless warning:
> 
> drivers/crypto/axis/artpec6_crypto.c:352:23: error: 'dbgfs_root' defined but not used [-Werror=unused-variable]
> 
> This moves it into the #ifdef that hides the only user.
> 
> Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: caam: pass key buffers with typesafe pointers
Date: Thu, 1 Dec 2016 21:21:44 +0800
Message-ID: <20161201132144.GD2249@gondor.apana.org.au>
References: <20161130210234.1666417-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Vasile <cata.vasile@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161130210234.1666417-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 30, 2016 at 10:01:59PM +0100, Arnd Bergmann wrote:
> The 'key' field is defined as a 'u64' and used for two different
> pieces of information: either to store a pointer or a dma_addr_t.
> The former leads to a build error on 32-bit machines:
> 
> drivers/crypto/caam/caamalg_desc.c: In function 'cnstr_shdsc_aead_null_encap':
> drivers/crypto/caam/caamalg_desc.c:67:27: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
> drivers/crypto/caam/caamalg_desc.c: In function 'cnstr_shdsc_aead_null_decap':
> drivers/crypto/caam/caamalg_desc.c:143:27: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
> 
> Using a union to provide correct types gets rid of the warnings
> and as well as a couple of redundant casts.
> 
> Fixes: db57656b0072 ("crypto: caam - group algorithm related params")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: CRYPTO_DEV_ATMEL_TDES and
 CRYPTO_DEV_ATMEL_SHA should depend on HAS_DMA
Date: Mon, 27 Feb 2017 18:37:56 +0800
Message-ID: <20170227103756.GC31739@gondor.apana.org.au>
References: <1487932059-31522-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487932059-31522-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 24, 2017 at 11:27:38AM +0100, Geert Uytterhoeven wrote:
> If NO_DMA=y:
> 
>     ERROR: "bad_dma_ops" [drivers/crypto/atmel-tdes.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/crypto/atmel-sha.ko] undefined!
> 
> Add dependencies on HAS_DMA to fix this.
> 
> Fixes: ceb4afb3086ab08f ("crypto: atmel - refine Kconfig dependencies")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

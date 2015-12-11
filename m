From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: sahara: fix 64-bit dma_addr_t compilation
Date: Fri, 11 Dec 2015 11:00:46 +0800
Message-ID: <20151211030046.GB10399@gondor.apana.org.au>
References: <1707164.bU6CqSGiie@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1707164.bU6CqSGiie@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 08, 2015 at 04:23:51PM +0100, Arnd Bergmann wrote:
> The sahara hardware uses DMA descriptors with 32-bit addresses, but
> dma_addr_t is variable size depending on whether we want to support
> any devices that use 64-bit DMA addresses in hardware.
> This means that the definition of the DMA descriptor structure is wrong,
> and we helpfully get a compiler warning about them too:
> 
> drivers/crypto/sahara.c:423:372: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t {aka long long unsigned int}' [-Wformat=]
> 
> This changes the definition of the sahara_hw_desc and sahara_hw_link
> structures to only contain fixed-length members, which is required
> to make the driver work on ARM LPAE mode, and avoids most of the
> gcc warnings we get.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

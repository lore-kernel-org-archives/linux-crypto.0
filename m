From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 16/39] crypto: ux500/cryp - Set DMA configuration
 though dma_slave_config()
Date: Thu, 16 May 2013 15:01:57 +0800
Message-ID: <20130516070157.GC6721@gondor.apana.org.au>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-17-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	vinod.koul@intel.com, arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com,
	Andreas Westin <andreas.westin@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1368611522-9984-17-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 15, 2013 at 10:51:39AM +0100, Lee Jones wrote:
> The DMA controller currently takes configuration information from
> information passed though dma_channel_request(), but it shouldn't.
> Using the API, the DMA channel should only be configured during
> a dma_slave_config() call.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

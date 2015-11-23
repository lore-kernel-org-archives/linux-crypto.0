From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: atmel: fix bogus select
Date: Mon, 23 Nov 2015 21:05:10 +0800
Message-ID: <20151123130510.GF7866@gondor.apana.org.au>
References: <12173927.U7ILfy5BBh@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Leilei Zhao <leilei.zhao@atmel.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	linux-kernel@vger.kernel.org,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <12173927.U7ILfy5BBh@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 18, 2015 at 04:33:54PM +0100, Arnd Bergmann wrote:
> >From 0d53d42a56e9a3769847fd03c703876f2c063fb4 Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Tue, 27 Jan 2015 22:34:04 +0100
> Subject: [PATCH] [SUBMITTED] crypto: atmel: fix bogus select
> 
> The Atmel at91 crypto driver unconditionally selects AT_HDMAC,
> which results in a Kconfig warning if that driver is not enabled:
> 
> warning: (CRYPTO_DEV_ATMEL_AES) selects AT_HDMAC which has unmet direct dependencies (DMADEVICES && ARCH_AT91)
> 
> The crypto driver itself does not actually have a dependency
> on a particular dma engine, other than this being the one that
> is used in at91.
> 
> Removing the 'select' gets rid of the warning, but can cause
> the driver to be unusable if the HDMAC is not enabled at the
> same time. To work around that, this patch clarifies the runtime
> dependency to be 'AT_HDMAC || AT_XDMAC', but adds an alternative
> for COMPILE_TEST, which lets the driver get build on all systems.
> 
> The ARCH_AT91 dependency is implied by AT_XDMAC || AT_HDMAC now
> and no longer needs to be listed separately.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

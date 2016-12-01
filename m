From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: arm/aesbs - Select SIMD in Kconfig
Date: Thu, 01 Dec 2016 14:43:00 +0100
Message-ID: <3127384.oX3XkmieGV@wuerfel>
References: <20161130234826.854879-1-arnd@arndb.de> <20161201125616.GB2249@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161201125616.GB2249@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday, December 1, 2016 8:56:16 PM CET Herbert Xu wrote:
> On Thu, Dec 01, 2016 at 12:47:59AM +0100, Arnd Bergmann wrote:
> > Commit 585b5fa63da9 ("crypto: arm/aes - Select SIMD in Kconfig") added
> > the dependency for CRYPTO_AES_ARM_CE, but missed the same change
> > for CRYPTO_AES_ARM_BS:
> > 
> > arch/arm/crypto/aes-arm-bs.o: In function `aesbs_mod_init':
> > aesbs-glue.c:(.init.text+0x38): undefined reference to `simd_skcipher_create_compat'
> > 
> > Fixes: 211f41af534a ("crypto: aesbs - Convert to skcipher")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Thanks Arnd.  This should already be fixed by 6fdf436fd854.

Right. I have discarded my patch on today's linux-next and I
get no more link errors.

	Arnd

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: introduce Microchip / Atmel ECC driver
Date: Tue, 18 Jul 2017 18:38:01 +0800
Message-ID: <20170718103801.GP6479@gondor.apana.org.au>
References: <1499249280-31779-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        wsa@the-dreams.de, linux-i2c@vger.kernel.org,
        nicolas.ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499249280-31779-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-i2c-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 05, 2017 at 01:07:57PM +0300, Tudor Ambarus wrote:
> Hi,
> 
> This patch set introduces Microchip / Atmel ECC driver.
> 
> The first patch adds some helpers that will be used by fallbacks to
> kpp software implementations.
> 
> The second patch adds ECDH support for the ATECC508A (I2C)
> cryptographic engine. The I2C interface is designed to operate
> at a maximum clock speed of 1MHz.
> 
> The device features hardware acceleration for the NIST standard
> P256 prime curve and supports the complete key life cycle from
> private key generation to ECDH key agreement.
> 
> Random private key generation is supported internally within
> the device to ensure that the private key can never be known
> outside of the device. If the user wants to use its own private
> keys, the driver will fallback to the ecdh software implementation.
> 
> Tudor Ambarus (3):
>   crypto: kpp: add get/set_flags helpers
>   crypto: introduce Microchip / Atmel ECC driver
>   MAINTAINERS: add a maintainer for Microchip / Atmel ECC driver

All patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

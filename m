From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [WIP/RFC] crypto: add support for Orion5X crypto engine
Date: Wed, 18 Mar 2009 17:55:17 +0200
Message-ID: <49C11965.9000200@teltonika.lt>
References: <20090317215844.GA23739@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
 linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.arm.linux.org.uk>
In-Reply-To: <20090317215844.GA23739@Chamillionaire.breakpoint.cc>
List-Unsubscribe: <http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=unsubscribe>
List-Archive: <http://lists.arm.linux.org.uk/lurker/list/linux-arm-kernel.html>
List-Post: <mailto:linux-arm-kernel@lists.arm.linux.org.uk>
List-Help: <mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=help>
List-Subscribe: <http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.arm.linux.org.uk
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org+linux-arm-kernel=m.gmane.org@lists.arm.linux.org.uk
List-Id: linux-crypto.vger.kernel.org

Sebastian Andrzej Siewior wrote:
> This is version two of the the driver. New things:
> - aes-ecb passes selftests
> - aes-cbc passes selftests
> 
> The driver still does memcpy() from/to sram. To solve this, a dma driver
> would be required but first I wanted to compare the performance between
> now and nothing/generic aes. However I managed to crash cryptsetup with
> luksOpen. Got look into this...
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  drivers/crypto/Kconfig      |    9 +
>  drivers/crypto/Makefile     |    1 +
>  drivers/crypto/mav_crypto.c |  724 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 734 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/crypto/mav_crypto.c
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 01afd75..514fe78 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -157,6 +157,15 @@ config S390_PRNG
>  	  ANSI X9.17 standard. The PRNG is usable via the char device
>  	  /dev/prandom.
>  
> +config CRYPTO_DEV_MARVELL_CRYPTO_ENGINE

CRYPTO_DEV...CRYPTO_ENGINE
Maybe CRYPTO_DEV_MARVELL would be enough?

> +	tristate "Marvell's Cryptographic Engine"
> +	depends on PLAT_ORION
> +	select CRYPTO_ALGAPI
> +	select CRYPTO_AES
> +	help
> +	  This driver allows you utilize the cryptographic engine which can be
> +	  found on certain SoC like QNAP's TS-209.
> +

-------------------------------------------------------------------
List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php

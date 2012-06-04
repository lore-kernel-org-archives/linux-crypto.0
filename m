From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 2/2 v2] crypto: bfin_crc: CRC hardware driver for BF60x
 family processors.
Date: Sun, 03 Jun 2012 21:11:58 -0700
Message-ID: <4FCC358E.4000905@xenotime.net>
References: <1338782431-24305-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Sonic Zhang <sonic.zhang@analog.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338782431-24305-1-git-send-email-sonic.adi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/03/2012 09:00 PM, Sonic Zhang wrote:

> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 69fdf18..3a05ba9 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -306,4 +306,11 @@ if CRYPTO_DEV_UX500
>  	source "drivers/crypto/ux500/Kconfig"
>  endif # if CRYPTO_DEV_UX500
>  
> +config CRYPTO_DEV_BFIN_CRC
> +	tristate "Support for Blackfin CRC hareware"


	                                   hardware


> +	depends on BF60x
> +	help
> +	  Newer Blackfin processors have CRC hardware. Select this if you
> +	  want to use the Blackfin CRC module.
> +
>  endif # CRYPTO_HW

-- 
~Randy

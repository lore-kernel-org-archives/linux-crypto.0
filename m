From: Boris Brezillon <boris.brezillon-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 14/20] mtd: Remove depends on HAS_DMA in case of
	platform dependency
Date: Sun, 22 Apr 2018 19:12:57 +0200
Message-ID: <20180422191257.255bdd9f@bbrezillon>
References: <1523987360-18760-1-git-send-email-geert@linux-m68k.org>
	<1523987360-18760-15-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ulf Hansson <ulf.hansson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>,
	linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org,
	Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux1394-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
	Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>,
	Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matias Bjorling <mb-VR7NuqX4VJ8tq7phqP6ubQ@public.gmane.org>,
	David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ohad Ben-Cohen <ohad-Ix1uc/W3ht7QT0dZR+AlfA@public.gmane.org>,
	devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Alan Tull <atull@k
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1523987360-18760-15-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 17 Apr 2018 19:49:14 +0200
Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:

> Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
> symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
> In most cases this other symbol is an architecture or platform specific
> symbol, or PCI.
> 
> Generic symbols and drivers without platform dependencies keep their
> dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
> cannot work anyway.
> 
> This simplifies the dependencies, and allows to improve compile-testing.
> 
> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> Reviewed-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>

Applied to mtd/next.

Thanks,

Boris

> ---
> v3:
>   - Rebase to v4.17-rc1,
> 
> v2:
>   - Add Reviewed-by, Acked-by,
>   - Drop RFC state,
>   - Drop new dependency of MTD_NAND_MARVELL on HAS_DMA,
>   - Split per subsystem.
> ---
>  drivers/mtd/nand/raw/Kconfig | 8 ++------
>  drivers/mtd/spi-nor/Kconfig  | 2 +-
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
> index 19a2b283fbbe627e..6871ff0fd300bb81 100644
> --- a/drivers/mtd/nand/raw/Kconfig
> +++ b/drivers/mtd/nand/raw/Kconfig
> @@ -46,7 +46,7 @@ config MTD_NAND_DENALI
>  config MTD_NAND_DENALI_PCI
>          tristate "Support Denali NAND controller on Intel Moorestown"
>  	select MTD_NAND_DENALI
> -	depends on HAS_DMA && PCI
> +	depends on PCI
>          help
>            Enable the driver for NAND flash on Intel Moorestown, using the
>            Denali NAND controller core.
> @@ -152,7 +152,6 @@ config MTD_NAND_S3C2410_CLKSTOP
>  config MTD_NAND_TANGO
>  	tristate "NAND Flash support for Tango chips"
>  	depends on ARCH_TANGO || COMPILE_TEST
> -	depends on HAS_DMA
>  	help
>  	  Enables the NAND Flash controller on Tango chips.
>  
> @@ -285,7 +284,7 @@ config MTD_NAND_MARVELL
>  	tristate "NAND controller support on Marvell boards"
>  	depends on PXA3xx || ARCH_MMP || PLAT_ORION || ARCH_MVEBU || \
>  		   COMPILE_TEST
> -	depends on HAS_IOMEM && HAS_DMA
> +	depends on HAS_IOMEM
>  	help
>  	  This enables the NAND flash controller driver for Marvell boards,
>  	  including:
> @@ -447,7 +446,6 @@ config MTD_NAND_SH_FLCTL
>  	tristate "Support for NAND on Renesas SuperH FLCTL"
>  	depends on SUPERH || COMPILE_TEST
>  	depends on HAS_IOMEM
> -	depends on HAS_DMA
>  	help
>  	  Several Renesas SuperH CPU has FLCTL. This option enables support
>  	  for NAND Flash using FLCTL.
> @@ -515,7 +513,6 @@ config MTD_NAND_SUNXI
>  config MTD_NAND_HISI504
>  	tristate "Support for NAND controller on Hisilicon SoC Hip04"
>  	depends on ARCH_HISI || COMPILE_TEST
> -	depends on HAS_DMA
>  	help
>  	  Enables support for NAND controller on Hisilicon SoC Hip04.
>  
> @@ -529,7 +526,6 @@ config MTD_NAND_QCOM
>  config MTD_NAND_MTK
>  	tristate "Support for NAND controller on MTK SoCs"
>  	depends on ARCH_MEDIATEK || COMPILE_TEST
> -	depends on HAS_DMA
>  	help
>  	  Enables support for NAND controller on MTK SoCs.
>  	  This controller is found on mt27xx, mt81xx, mt65xx SoCs.
> diff --git a/drivers/mtd/spi-nor/Kconfig b/drivers/mtd/spi-nor/Kconfig
> index 89da88e591215db1..c493b8230a38c059 100644
> --- a/drivers/mtd/spi-nor/Kconfig
> +++ b/drivers/mtd/spi-nor/Kconfig
> @@ -71,7 +71,7 @@ config SPI_FSL_QUADSPI
>  config SPI_HISI_SFC
>  	tristate "Hisilicon SPI-NOR Flash Controller(SFC)"
>  	depends on ARCH_HISI || COMPILE_TEST
> -	depends on HAS_IOMEM && HAS_DMA
> +	depends on HAS_IOMEM
>  	help
>  	  This enables support for hisilicon SPI-NOR flash controller.
>  

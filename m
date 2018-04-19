From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v3 15/20] net: Remove depends on HAS_DMA in case of
 platform dependency
Date: Thu, 19 Apr 2018 19:41:15 +0300
Message-ID: <87wox3i1xw.fsf@kamboji.qca.qualcomm.com>
References: <1523987360-18760-1-git-send-email-geert@linux-m68k.org>
 <1523987360-18760-16-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
 linux-iio@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-fpga@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 alsa-devel@alsa-project.org, Bjorn Andersson <bjorn.andersson@linaro.org>,
 Eric Anholt <eric@anholt.net>, netdev@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
 linux1394-devel@lists.sourceforge.net, Christoph Hellwig <hch@lst.de>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Stefan Wahren <stefan.wahren@i2se.com>,
 Boris Brezillon <boris.brezillon@free-electrons.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Richard Weinberger <richard@nod.at>,
 Joerg Roedel <joro@8bytes.org>, Jassi Brar <jassisinghbrar@gmail.com>,
 Marek Vasut <marek.vasut@gmail.com>, linux-serial@vger.kernel.org,
 Matias Bjorling <mb@lightnvm.io>, David Woodhouse <dwmw2@infradead.org>,
 l
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1523987360-18760-16-git-send-email-geert@linux-m68k.org> (Geert
 Uytterhoeven's message of "Tue, 17 Apr 2018 19:49:15 +0200")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

(adding linux-wireless)

Geert Uytterhoeven <geert@linux-m68k.org> writes:

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
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Acked-by: Robin Murphy <robin.murphy@arm.com>
> ---
> v3:
>   - Rebase to v4.17-rc1,
>   - Drop obsolete note about FSL_FMAN,
>
> v2:
>   - Add Reviewed-by, Acked-by,
>   - Drop RFC state,
>   - Split per subsystem.
> ---
>  drivers/net/ethernet/amd/Kconfig                | 2 +-
>  drivers/net/ethernet/apm/xgene-v2/Kconfig       | 1 -
>  drivers/net/ethernet/apm/xgene/Kconfig          | 1 -
>  drivers/net/ethernet/arc/Kconfig                | 6 ++++--
>  drivers/net/ethernet/broadcom/Kconfig           | 2 --
>  drivers/net/ethernet/calxeda/Kconfig            | 2 +-
>  drivers/net/ethernet/hisilicon/Kconfig          | 2 +-
>  drivers/net/ethernet/marvell/Kconfig            | 8 +++-----
>  drivers/net/ethernet/mellanox/mlxsw/Kconfig     | 2 +-
>  drivers/net/ethernet/renesas/Kconfig            | 2 --
>  drivers/net/wireless/broadcom/brcm80211/Kconfig | 1 -
>  drivers/net/wireless/quantenna/qtnfmac/Kconfig  | 2 +-
>  12 files changed, 12 insertions(+), 19 deletions(-)

For wireless:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

Leaving the hunks for linux-wireless list to see:

> diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
> index 9d99eb42d9176f0f..6acba67bca07abd7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
> +++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
> @@ -60,7 +60,6 @@ config BRCMFMAC_PCIE
>  	bool "PCIE bus interface support for FullMAC driver"
>  	depends on BRCMFMAC
>  	depends on PCI
> -	depends on HAS_DMA
>  	select BRCMFMAC_PROTO_MSGBUF
>  	select FW_LOADER
>  	---help---
> diff --git a/drivers/net/wireless/quantenna/qtnfmac/Kconfig b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
> index 025fa6018550895a..8d1492a90bd135c0 100644
> --- a/drivers/net/wireless/quantenna/qtnfmac/Kconfig
> +++ b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
> @@ -7,7 +7,7 @@ config QTNFMAC
>  config QTNFMAC_PEARL_PCIE
>  	tristate "Quantenna QSR10g PCIe support"
>  	default n
> -	depends on HAS_DMA && PCI && CFG80211
> +	depends on PCI && CFG80211
>  	select QTNFMAC
>  	select FW_LOADER
>  	select CRC32

-- 
Kalle Valo

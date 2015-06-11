From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v4 00/14] crypto: add a new driver for Marvell's CESA
Date: Thu, 11 Jun 2015 22:14:54 +0200
Message-ID: <20150611221454.3a1d9780@bbrezillon>
References: <1434044206-10459-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	"Imre Kaloz" <kaloz@ope
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1434044206-10459-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Sorry for the noise: apparently I forgot to remove existing patches
when regenerating the series with format-patch.
I'll resend the series tomorrow.

On Thu, 11 Jun 2015 19:36:19 +0200
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> Hello,
> 
> This patch series adds a new driver supporting Marvell's CESA IP.
> This driver addresses some limitations of the existing one.
> From a performance and CPU load point of view the most important
> limitation in the existing driver is the lack of DMA support, thus
> preventing us from chaining crypto operations.
> 
> I know we usually try to adapt existing drivers instead of replacing them
> by new ones, but after trying to refactor the mv_cesa driver I realized it
> would take longer than writing an new one from scratch.
> 
> Here are the main features brought by this new driver:
> - support for armada SoCs (up to 38x) while keeping support for older ones
>   (Orion and Kirkwood). Note that old DT bindings (those used on Orion and
>   Kirkwood platforms) are supported, or IOTW, old DTs are compatible with
>   this new driver.
> - DMA mode to offload the CPU in case of intensive crypto usage
> - new algorithms: SHA256, DES and 3DES
> 
> I'd like to thank Arnaud, who has carefully reviewed several iterations of
> this driver, helped me improved my implementation, provided support for
> several crypto algorithms, provided support for armada-370 and tested
> the driver on different platforms, hence the SoB and dual MODULE_AUTHOR
> in the driver code.
> 
> In this version I dropped the DT changes, but you'll find them in my
> cesa-v4 branch [1]. In this branch you'll find everything you need to
> test on all Marvell platforms (including the old ones).
> I'll post a series updating all the DTs once this driver has been merged.
> 
> Best Regards,
> 
> Boris
> 
> [1]https://github.com/bbrezillon/linux-marvell/tree/cesa-v4
> 
> Changes since v3:
> - add import functions for hash algorithms
> - patch mv_cesa driver to support the new DT bindings
> - few fixes in the documentation
> - replace mv_mbus_dram_info() call by mv_mbus_dram_info_nooverlap()
> - remove DT updates from the series
> 
> Changes since v2:
> - fixes in the cipher code (->dst_nents was assigned the ->src_nents
>   value and CBC state was overwritten by the IV after each chunk
>   operation)
> 
> Arnaud Ebalard (4):
>   crypto: marvell/CESA: add Triple-DES support
>   crypto: marvell/CESA: add MD5 support
>   crypto: marvell/CESA: add SHA256 support
>   crypto: marvell/CESA: add support for Kirkwood and Dove SoCs
> 
> Boris Brezillon (10):
>   crypto: mv_cesa: document the clocks property
>   crypto: mv_cesa: use gen_pool to reserve the SRAM memory region
>   crypto: mv_cesa: explicitly define kirkwood and dove compatible
>     strings
>   crypto: add a new driver for Marvell's CESA
>   crypto: marvell/CESA: add TDMA support
>   crypto: marvell/CESA: add DES support
>   crypto: marvell/CESA: add support for all armada SoCs
>   crypto: marvell/CESA: add allhwsupport module parameter
>   crypto: marvell/CESA: add support for Orion SoCs
>   crypto: marvell/CESA: add DT bindings documentation
> 
>  .../devicetree/bindings/crypto/marvell-cesa.txt    |   45 +
>  .../devicetree/bindings/crypto/mv_cesa.txt         |   31 +-
>  drivers/crypto/Kconfig                             |   18 +
>  drivers/crypto/Makefile                            |    1 +
>  drivers/crypto/marvell/Makefile                    |    2 +
>  drivers/crypto/marvell/cesa.c                      |  544 ++++++++
>  drivers/crypto/marvell/cesa.h                      |  804 +++++++++++
>  drivers/crypto/marvell/cipher.c                    |  774 +++++++++++
>  drivers/crypto/marvell/hash.c                      | 1433 ++++++++++++++++++++
>  drivers/crypto/marvell/tdma.c                      |  224 +++
>  drivers/crypto/mv_cesa.c                           |   60 +-
>  11 files changed, 3912 insertions(+), 24 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/marvell-cesa.txt
>  create mode 100644 drivers/crypto/marvell/Makefile
>  create mode 100644 drivers/crypto/marvell/cesa.c
>  create mode 100644 drivers/crypto/marvell/cesa.h
>  create mode 100644 drivers/crypto/marvell/cipher.c
>  create mode 100644 drivers/crypto/marvell/hash.c
>  create mode 100644 drivers/crypto/marvell/tdma.c
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

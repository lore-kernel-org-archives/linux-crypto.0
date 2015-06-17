From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v6 00/14] crypto: add a new driver for Marvell's CESA
Date: Wed, 17 Jun 2015 09:45:28 +0200
Message-ID: <1434527142-3609-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
	Tawfik Bayouk <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Lior Amsalem <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Eran Ben-Avi <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
	"Imre Kaloz" <kaloz-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hello,

This patch series adds a new driver supporting Marvell's CESA IP.
This driver addresses some limitations of the existing one.
>From a performance and CPU load point of view the most important
limitation in the existing driver is the lack of DMA support, thus
preventing us from chaining crypto operations.

I know we usually try to adapt existing drivers instead of replacing them
by new ones, but after trying to refactor the mv_cesa driver I realized it
would take longer than writing an new one from scratch.

Here are the main features brought by this new driver:
- support for armada SoCs (up to 38x) while keeping support for older ones
  (Orion and Kirkwood). Note that old DT bindings (those used on Orion and
  Kirkwood platforms) are supported, or IOTW, old DTs are compatible with
  this new driver.
- DMA mode to offload the CPU in case of intensive crypto usage
- new algorithms: SHA256, DES and 3DES

I'd like to thank Arnaud, who has carefully reviewed several iterations of
this driver, helped me improved my implementation, provided support for
several crypto algorithms, provided support for armada-370 and tested
the driver on different platforms, hence the SoB and dual MODULE_AUTHOR
in the driver code.

In this version I dropped the DT changes, but you'll find them in my
cesa-v6 branch [1]. In this branch you'll find everything you need to
test on all Marvell platforms (including the old ones).
I'll post a series updating all the DTs once this driver has been merged.

Best Regards,

Boris

[1]https://github.com/bbrezillon/linux-marvell/tree/cesa-v6

Changes since v5:
- fix the dma_map_sg return code check (again)
- fix select entries in the Kconfig option

Changes since v4:
- fix the dma_map_sg return code check
- add import/export functions to all HMAC algos
- update the passed IV when handling cipher requests
- properly handle requests in the crypto queue backlog
- use sg_nents_for_len

Changes since v3:
- add import functions for hash algorithms
- patch mv_cesa driver to support the new DT bindings
- few fixes in the documentation
- replace mv_mbus_dram_info() call by mv_mbus_dram_info_nooverlap()
- remove DT updates from the series

Changes since v2:
- fixes in the cipher code (->dst_nents was assigned the ->src_nents
  value and CBC state was overwritten by the IV after each chunk
  operation)
- spit the code as suggested by Sebastian

Changes since v1:
- (suggested by Jason) kept the existing CESA driver and added a mechanism
  to prevent the new driver from probing devices handled my the existing
  one (Orion and Kirkwood platforms)
- (reported by Paul) addressed a few Kconfig and module definition issues
- (suggested by Andrew) added DT changes to the series

Arnaud Ebalard (4):
  crypto: marvell/CESA: add Triple-DES support
  crypto: marvell/CESA: add MD5 support
  crypto: marvell/CESA: add SHA256 support
  crypto: marvell/CESA: add support for Kirkwood and Dove SoCs

Boris Brezillon (10):
  crypto: mv_cesa: document the clocks property
  crypto: mv_cesa: use gen_pool to reserve the SRAM memory region
  crypto: mv_cesa: explicitly define kirkwood and dove compatible
    strings
  crypto: add a new driver for Marvell's CESA
  crypto: marvell/CESA: add TDMA support
  crypto: marvell/CESA: add DES support
  crypto: marvell/CESA: add support for all armada SoCs
  crypto: marvell/CESA: add allhwsupport module parameter
  crypto: marvell/CESA: add support for Orion SoCs
  crypto: marvell/CESA: add DT bindings documentation

 .../devicetree/bindings/crypto/marvell-cesa.txt    |   45 +
 .../devicetree/bindings/crypto/mv_cesa.txt         |   31 +-
 drivers/crypto/Kconfig                             |   17 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/marvell/Makefile                    |    2 +
 drivers/crypto/marvell/cesa.c                      |  548 ++++++++
 drivers/crypto/marvell/cesa.h                      |  791 +++++++++++
 drivers/crypto/marvell/cipher.c                    |  784 +++++++++++
 drivers/crypto/marvell/hash.c                      | 1443 ++++++++++++++++++++
 drivers/crypto/marvell/tdma.c                      |  224 +++
 drivers/crypto/mv_cesa.c                           |   60 +-
 11 files changed, 3922 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/marvell-cesa.txt
 create mode 100644 drivers/crypto/marvell/Makefile
 create mode 100644 drivers/crypto/marvell/cesa.c
 create mode 100644 drivers/crypto/marvell/cesa.h
 create mode 100644 drivers/crypto/marvell/cipher.c
 create mode 100644 drivers/crypto/marvell/hash.c
 create mode 100644 drivers/crypto/marvell/tdma.c

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

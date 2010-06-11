From: Maurus Cuelenaere <mcuelenaere@gmail.com>
Subject: [RFC/PATCH 0/9] Samsung crypto engine
Date: Fri, 11 Jun 2010 21:48:37 +0200
Message-ID: <4C129315.4030404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: ben-linux@fluff.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi all,

this patchset introduces crypto acceleration support for the crypto engine
available in S3C64XX and S5PC100 SoC's. I only have access to a S3C6410 board so
it would be nice if people could test these patches on S5PC100.

The driver currently only supports AES and (T)DES in PIO mode, but even then it
doesn't always succeed the DES self-tests so the driver part of this patch is
more an RFC than an actual patch.

AES seems to work better than (T)DES, but it hangs on 64-bytes transfers (DES
hangs on a 24-byte transfer).

There is support for DMA in the driver, but that has its own set of problems (it
can't even finish a single transfer).

I've tagged the patches I think are worthy for upstreaming with [PATCH], the
others are tagged with [RFC] (reviews are welcome!).

I'm not completely sure about my approach of handling the subsystems' register
offsets currently as this limits the driver to S3C64XX- or S5PC100-only.

Mapping these to virtual space could solve this and would have the benefit of
reducing the ~11MB IO space on S3C64XX SoC's.

Maurus Cuelenaere (9):
  ARM: S3C64XX: Add SDMA clocks
  ARM: S3C64XX: Add SDMA support to DMA core
  ARM: S3C64XX: Stop and flush requests on freeing
  ARM: S3C64XX: Add support for secur clock
  ARM: S3C64XX: Add crypto engine register definitions
  ARM: S5PC100: Add crypto engine register definitions
  ARM: SAMSUNG: Add crypto engine platform definition
  ARM: SAMSUNG: Add crypto engine register definitions
  crypto: Add Samsung crypto engine driver

 arch/arm/Kconfig                              |    2 +
 arch/arm/mach-s3c64xx/clock.c                 |   21 +
 arch/arm/mach-s3c64xx/dma.c                   |   54 +-
 arch/arm/mach-s3c64xx/include/mach/map.h      |    3 +
 arch/arm/mach-s3c64xx/include/mach/regs-sss.h |   27 +
 arch/arm/mach-s5pc100/include/mach/map.h      |    4 +
 arch/arm/mach-s5pc100/include/mach/regs-sss.h |   29 +
 arch/arm/plat-samsung/Kconfig                 |    5 +
 arch/arm/plat-samsung/Makefile                |    1 +
 arch/arm/plat-samsung/dev-sss.c               |   46 +
 arch/arm/plat-samsung/include/plat/devs.h     |    2 +
 arch/arm/plat-samsung/include/plat/regs-sss.h |  153 +++
 drivers/crypto/Kconfig                        |   11 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/s3c-sss.c                      | 1320 +++++++++++++++++++++++++
 15 files changed, 1668 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm/mach-s3c64xx/include/mach/regs-sss.h
 create mode 100644 arch/arm/mach-s5pc100/include/mach/regs-sss.h
 create mode 100644 arch/arm/plat-samsung/dev-sss.c
 create mode 100644 arch/arm/plat-samsung/include/plat/regs-sss.h
 create mode 100644 drivers/crypto/s3c-sss.c

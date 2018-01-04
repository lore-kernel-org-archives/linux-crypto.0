From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v10 0/8] Add io{read|write}64 to io-64-atomic headers
Date: Thu,  4 Jan 2018 12:16:37 -0700
Message-ID: <20180104191645.10006-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Logan Gunthorpe <logang@deltatee.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is v10 of my cleanup series to push a number of instances of people
defining their own io{read|write}64 functions into common headers seing
they don't exist in non-64bit systems. This series adds inline functions to the
io-64-nonatomic headers and then cleans up the drivers that defined their
own.

This cleanup was originally requested by Greg after he reviewed my
Switchtec NTB code.

Changes since v9:
- Rebased onto v4.15-rc6
- Fixed a couple of issues in the new version of the CAAM patch as
  pointed out by Horia

Changes since v8:
- Rebased onto v4.15-rc2, as a result rewrote patch 7 seeing someone did
  some similar cleanup in that area.
- Added a patch to clean up the Switchtec NTB driver which landed in
  v4.15-rc1

Changes since v7:
- Fix minor nits from Andy Shevchenko
- Rebased onto v4.14-rc1

Changes since v6:
 ** none **

Changes since v5:
- Added a fix to the tilcdc driver to ensure it doesn't use the
  non-atomic operation. (This includes adding io{read|write}64[be]_is_nonatomic
  defines).

Changes since v4:
- Add functions so the powerpc implementation of iomap.c compiles. (As
  noticed by Horia)

Changes since v3:

- I noticed powerpc didn't use the appropriate functions seeing
  readq/writeq were not defined when iomap.h was included. Thus I've
  included a patch to adjust this
- Fixed some mistakes with a couple of the defines in io-64-nonatomic*
  headers
- Fixed a typo noticed by Horia.

(earlier versions were drastically different)

Logan Gunthorpe (8):
  drm/tilcdc: ensure nonatomic iowrite64 is not used
  powerpc: io.h: move iomap.h include so that it can use readq/writeq
    defs
  powerpc: iomap.c: introduce io{read|write}64_{lo_hi|hi_lo}
  iomap: introduce io{read|write}64_{lo_hi|hi_lo}
  io-64-nonatomic: add io{read|write}64[be]{_lo_hi|_hi_lo} macros
  ntb: ntb_hw_intel: use io-64-nonatomic instead of in-driver hacks
  crypto: caam: cleanup CONFIG_64BIT ifdefs when using io{read|write}64
  ntb: ntb_hw_switchtec: Cleanup 64bit IO defines to use the common
    header

 arch/powerpc/include/asm/io.h          |   6 +-
 arch/powerpc/kernel/iomap.c            |  40 ++++++++++
 drivers/crypto/caam/regs.h             |  30 +-------
 drivers/gpu/drm/tilcdc/tilcdc_regs.h   |   2 +-
 drivers/ntb/hw/intel/ntb_hw_intel.c    |  30 +-------
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c |  30 +-------
 include/asm-generic/iomap.h            |  26 +++++--
 include/linux/io-64-nonatomic-hi-lo.h  |  64 ++++++++++++++++
 include/linux/io-64-nonatomic-lo-hi.h  |  64 ++++++++++++++++
 lib/iomap.c                            | 132 +++++++++++++++++++++++++++++++++
 10 files changed, 330 insertions(+), 94 deletions(-)

--
2.11.0

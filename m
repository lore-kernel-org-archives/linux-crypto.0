From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v6 0/7] make io{read|write}64 globally usable
Date: Thu,  3 Aug 2017 12:30:11 -0600
Message-ID: <20170803183018.5889-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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

Horia Geantă (1):
  crypto: caam: cleanup CONFIG_64BIT ifdefs when using io{read|write}64

Logan Gunthorpe (6):
  drm/tilcdc: ensure nonatomic iowrite64 is not used
  powerpc: io.h: move iomap.h include so that it can use readq/writeq
    defs
  powerpc: iomap.c: introduce io{read|write}64_{lo_hi|hi_lo}
  iomap: introduce io{read|write}64_{lo_hi|hi_lo}
  io-64-nonatomic: add io{read|write}64[be]{_lo_hi|_hi_lo} macros
  ntb: ntb_hw_intel: use io-64-nonatomic instead of in-driver hacks

 arch/powerpc/include/asm/io.h         |   6 +-
 arch/powerpc/kernel/iomap.c           |  40 +++++++++++
 drivers/crypto/caam/regs.h            |  35 ++-------
 drivers/gpu/drm/tilcdc/tilcdc_regs.h  |   2 +-
 drivers/ntb/hw/intel/ntb_hw_intel.c   |  30 +-------
 include/asm-generic/iomap.h           |  26 +++++--
 include/linux/io-64-nonatomic-hi-lo.h |  64 +++++++++++++++++
 include/linux/io-64-nonatomic-lo-hi.h |  64 +++++++++++++++++
 lib/iomap.c                           | 132 ++++++++++++++++++++++++++++++++++
 9 files changed, 331 insertions(+), 68 deletions(-)

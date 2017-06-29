From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v3 0/4] make io{read|write}64 more globally usable
Date: Thu, 29 Jun 2017 10:09:56 -0600
Message-ID: <20170629161000.15563-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Here's my third attempt. This time we add functions to io-64-nonatomic-*
which call io{read|write}32 twice so that the pio is done correctly.

I've also included a patch that adds these functions to the generic iomap
library so that readq/writeq can be used while still splitting pio
operations (when appropriate).

Thanks,

Logan

Horia Geantă (1):
  crypto: caam: cleanup CONFIG_64BIT ifdefs when using io{read|write}64

Logan Gunthorpe (3):
  iomap: introduce io{read|write}64_{lo_hi|hi_lo}
  io-64-nonatomic: add io{read|write}64[be]{_lo_hi|_hi_lo} macros
  ntb: ntb_hw_intel: use io-64-nonatomic instead of in-driver hacks

 drivers/crypto/caam/regs.h            |  35 ++-------
 drivers/ntb/hw/intel/ntb_hw_intel.c   |  31 +-------
 include/asm-generic/iomap.h           |  26 +++++--
 include/linux/io-64-nonatomic-hi-lo.h |  62 ++++++++++++++++
 include/linux/io-64-nonatomic-lo-hi.h |  60 ++++++++++++++++
 lib/iomap.c                           | 132 ++++++++++++++++++++++++++++++++++
 6 files changed, 280 insertions(+), 66 deletions(-)

--
2.11.0

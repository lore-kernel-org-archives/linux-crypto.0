From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 0/7] staging: ccree: bug fixes and TODO items for 4.13
Date: Thu, 22 Jun 2017 16:36:54 +0300
Message-ID: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

An assortment of bug fixes and staging TODO items.
Highlights includes the driver passing crypto testmgr boot tests
and support of multiple HW revs. without build time changes.

CC: Dan Carpenter <dan.carpenter@oracle.com>

Changes from v1:
- Rebased on top of latest patches sent to mailing
  list but not yet marged for same driver.
- Address Dan Carpenter style review comments
- Fix clk de-init being called on clk init failure
  error path pointed out by Dan Carpenter.

Gilad Ben-Yossef (7):
  staging: ccree: fix hash import/export
  staging: ccree: register setkey for none hash macs
  staging: ccree: add support for older HW revisions
  staging: ccree: remove unused function
  staging: ccree: add clock management support
  staging: ccree: add DT bus coherency detection
  staging: ccree: use signal safe completion wait

 drivers/staging/ccree/Kconfig            |   7 +-
 drivers/staging/ccree/Makefile           |   2 +-
 drivers/staging/ccree/cc_crypto_ctx.h    |  16 --
 drivers/staging/ccree/cc_hw_queue_defs.h |  14 +-
 drivers/staging/ccree/cc_regs.h          |   7 +-
 drivers/staging/ccree/dx_crys_kernel.h   |   1 +
 drivers/staging/ccree/dx_host.h          |   3 +
 drivers/staging/ccree/dx_reg_common.h    |   2 -
 drivers/staging/ccree/ssi_aead.c         |  36 ++-
 drivers/staging/ccree/ssi_buffer_mgr.c   |  37 +--
 drivers/staging/ccree/ssi_cipher.c       |  27 +-
 drivers/staging/ccree/ssi_config.h       |  20 --
 drivers/staging/ccree/ssi_driver.c       | 167 +++++++++---
 drivers/staging/ccree/ssi_driver.h       |  32 ++-
 drivers/staging/ccree/ssi_fips_ll.c      |  59 +++--
 drivers/staging/ccree/ssi_hash.c         | 441 ++++++++++++++++++-------------
 drivers/staging/ccree/ssi_hash.h         |  12 +-
 drivers/staging/ccree/ssi_pm.c           |  13 +-
 drivers/staging/ccree/ssi_pm_ext.c       |  60 -----
 drivers/staging/ccree/ssi_pm_ext.h       |  33 ---
 drivers/staging/ccree/ssi_request_mgr.c  |  22 +-
 drivers/staging/ccree/ssi_sram_mgr.c     |  15 +-
 22 files changed, 561 insertions(+), 465 deletions(-)
 delete mode 100644 drivers/staging/ccree/ssi_pm_ext.c
 delete mode 100644 drivers/staging/ccree/ssi_pm_ext.h

-- 
2.1.4

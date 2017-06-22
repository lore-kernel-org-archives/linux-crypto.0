From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/7] staging: ccree: bug fixes and TODO items for 4.13
Date: Thu, 22 Jun 2017 10:07:46 +0300
Message-ID: <1498115276-1601-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:33328 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751143AbdFVHIF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 03:08:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

An assortment of bug fixes and staging TODO items.
Highlights includes the driver passing crypto testmgr boot tests
and support of multiple HW revs. without build time changes.

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
 drivers/staging/ccree/ssi_driver.c       | 170 +++++++++---
 drivers/staging/ccree/ssi_driver.h       |  32 ++-
 drivers/staging/ccree/ssi_fips_ll.c      |  59 +++--
 drivers/staging/ccree/ssi_hash.c         | 441 ++++++++++++++++++-------------
 drivers/staging/ccree/ssi_hash.h         |  12 +-
 drivers/staging/ccree/ssi_pm.c           |  13 +-
 drivers/staging/ccree/ssi_pm_ext.c       |  60 -----
 drivers/staging/ccree/ssi_pm_ext.h       |  33 ---
 drivers/staging/ccree/ssi_request_mgr.c  |  22 +-
 drivers/staging/ccree/ssi_sram_mgr.c     |  15 +-
 22 files changed, 564 insertions(+), 465 deletions(-)
 delete mode 100644 drivers/staging/ccree/ssi_pm_ext.c
 delete mode 100644 drivers/staging/ccree/ssi_pm_ext.h

-- 
2.1.4

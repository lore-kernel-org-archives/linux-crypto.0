From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 00/10] staging: ccree: cleanups & fixes
Date: Thu, 14 Dec 2017 14:02:37 +0000
Message-ID: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

- More cleanups and dead code removal.
- Handle TODO item of moving none standard sysfs interface
  to debugfs
- One fix to FIPS event irq handling code

Gilad Ben-Yossef (10):
  staging: ccree: drop ifdef CONFIG_OF in code
  staging: ccree: clean up PM registration
  staging: ccree: add explicit module init/exit func
  staging: ccree: staging: ccree: replace sysfs by debugfs interface
  staging: ccree: remove CC_IRQ_DELAY dead code
  staging: ccree: remove useless debug code
  staging: ccree: turn compile time debug log to params
  staging: ccree: remove ssi_config.h
  staging: ccree: fix fips event irq handling build
  staging: ccree: update TODO

 drivers/staging/ccree/Makefile          |   3 +-
 drivers/staging/ccree/TODO              |   3 +-
 drivers/staging/ccree/cc_debugfs.c      | 113 +++++++++++++++++++
 drivers/staging/ccree/cc_debugfs.h      |  45 ++++++++
 drivers/staging/ccree/ssi_aead.c        |  47 --------
 drivers/staging/ccree/ssi_buffer_mgr.h  |   1 -
 drivers/staging/ccree/ssi_cipher.c      |   2 -
 drivers/staging/ccree/ssi_config.h      |  38 -------
 drivers/staging/ccree/ssi_driver.c      | 103 +++++++----------
 drivers/staging/ccree/ssi_driver.h      |  22 ++--
 drivers/staging/ccree/ssi_fips.c        |   1 -
 drivers/staging/ccree/ssi_hash.c        |   2 -
 drivers/staging/ccree/ssi_ivgen.c       |   1 -
 drivers/staging/ccree/ssi_pm.c          |   6 +-
 drivers/staging/ccree/ssi_pm.h          |   4 +-
 drivers/staging/ccree/ssi_request_mgr.c |  51 +++------
 drivers/staging/ccree/ssi_sysfs.c       | 192 --------------------------------
 drivers/staging/ccree/ssi_sysfs.h       |  32 ------
 18 files changed, 236 insertions(+), 430 deletions(-)
 create mode 100644 drivers/staging/ccree/cc_debugfs.c
 create mode 100644 drivers/staging/ccree/cc_debugfs.h
 delete mode 100644 drivers/staging/ccree/ssi_config.h
 delete mode 100644 drivers/staging/ccree/ssi_sysfs.c
 delete mode 100644 drivers/staging/ccree/ssi_sysfs.h

-- 
2.7.4

From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 00/24] staging: ccree: more cleanup patches
Date: Mon, 13 Nov 2017 14:45:28 +0000
Message-ID: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Another set of cleanup patches. 
This set goes on top of the previous fixes and cleanups patch set
sent to the list.

With this set of patches checkpatch now only reports one false
warning and a warning on device tree string being undocumented.

Gilad Ben-Yossef (24):
  staging: ccree: fix typos
  staging: ccree: alloc by instance not type
  staging: ccree: remove unnecessary parentheses
  staging: ccree: remove MIN/MAX macros
  staging: ccree: move logical cont. to 1st line
  staging: ccree: remove unneeded empty lines
  staging: ccree: remove unneeded cast
  staging: ccree: make mem barrier per request
  staging: ccree: replace open coded loop with for
  staging: ccree: document spinlock usage
  staging: ccree: constify help string
  staging: ccree: fix code indent
  staging: ccree: Replace CONFIG_PM_RUNTIME with CONFIG_PM
  staging: ccree: replace macro with inline func
  staging: ccree: trim long lines for readability
  staging: ccree: remove dead defs and decls
  staging: ccree: refactor code with local vars
  staging: ccree: rename func for readability
  staging: ccree: rename long define for readability
  staging: ccree: remove unneeded wrapper function
  staging: ccree: remove unused field
  staging: ccree: replace msleep with a completion
  staging: ccree: use local vars for readability
  staging: ccree: drop unused macro

 drivers/staging/ccree/cc_hw_queue_defs.h |   2 -
 drivers/staging/ccree/ssi_aead.c         | 195 ++++++++++++++++++++-----------
 drivers/staging/ccree/ssi_aead.h         |  17 ++-
 drivers/staging/ccree/ssi_buffer_mgr.c   | 174 +++++++++++++++------------
 drivers/staging/ccree/ssi_cipher.c       | 100 ++++++++++------
 drivers/staging/ccree/ssi_cipher.h       |   5 +-
 drivers/staging/ccree/ssi_config.h       |   6 +-
 drivers/staging/ccree/ssi_driver.c       |  14 ++-
 drivers/staging/ccree/ssi_driver.h       |  23 ++--
 drivers/staging/ccree/ssi_fips.h         |   3 +-
 drivers/staging/ccree/ssi_hash.c         | 180 +++++++++++++++++-----------
 drivers/staging/ccree/ssi_hash.h         |  14 ++-
 drivers/staging/ccree/ssi_ivgen.c        |  13 ++-
 drivers/staging/ccree/ssi_ivgen.h        |   3 +-
 drivers/staging/ccree/ssi_pm.c           |   6 +-
 drivers/staging/ccree/ssi_pm.h           |   2 +-
 drivers/staging/ccree/ssi_request_mgr.c  | 106 ++++++++++-------
 drivers/staging/ccree/ssi_request_mgr.h  |   4 +-
 drivers/staging/ccree/ssi_sram_mgr.c     |   2 +-
 drivers/staging/ccree/ssi_sysfs.c        |  39 +++++--
 drivers/staging/ccree/ssi_sysfs.h        |  23 ----
 21 files changed, 562 insertions(+), 369 deletions(-)

-- 
2.7.4

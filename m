From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 0/6] staging: ccree: bug fixes and TODO items for 4.13
Date: Sun, 25 Jun 2017 10:47:18 +0300
Message-ID: <1498376846-24136-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

An assortment of bug fixes and staging TODO items.
Highlights includes the driver passing crypto testmgr boot tests
and relying on device tree for various HW config options as
opposed to build time configuration.

CC: Dan Carpenter <dan.carpenter@oracle.com>

Gilad Ben-Yossef (6):
  staging: ccree: fix hash import/export
  staging: ccree: register setkey for none hash macs
  staging: ccree: remove unused function
  staging: ccree: add clock management support
  staging: ccree: add DT bus coherency detection
  staging: ccree: use signal safe completion wait

Changes from v2:
- Rebased on latest staging-next.
- Added poison of unused hash import field based
  on review discussions with Dan Carpenter.
- Dropped older HW support patches for staging
  at GregKH request.
- Rewrote for clarity hash setkey fix commit
  message.
- Added now no longer needed KConfig option to
  code dropped by bus coherency being set by DT
  patch.

Changes from v1:
- Rebased on top of latest patches sent to mailing
  list but not yet marged for same driver.
- Address Dan Carpenter style review comments
- Fix clk de-init being called on clk init failure
  error path pointed out by Dan Carpenter.

 drivers/staging/ccree/Kconfig            |   9 --
 drivers/staging/ccree/Makefile           |   2 +-
 drivers/staging/ccree/cc_hw_queue_defs.h |  12 --
 drivers/staging/ccree/ssi_buffer_mgr.c   |  37 ++---
 drivers/staging/ccree/ssi_config.h       |  20 ---
 drivers/staging/ccree/ssi_driver.c       |  55 ++++++--
 drivers/staging/ccree/ssi_driver.h       |   8 +-
 drivers/staging/ccree/ssi_hash.c         | 226 +++++++++++++++++++------------
 drivers/staging/ccree/ssi_hash.h         |   2 +
 drivers/staging/ccree/ssi_pm.c           |  13 +-
 drivers/staging/ccree/ssi_pm_ext.c       |  60 --------
 drivers/staging/ccree/ssi_pm_ext.h       |  33 -----
 drivers/staging/ccree/ssi_request_mgr.c  |   3 +-
 13 files changed, 227 insertions(+), 253 deletions(-)
 delete mode 100644 drivers/staging/ccree/ssi_pm_ext.c
 delete mode 100644 drivers/staging/ccree/ssi_pm_ext.h

-- 
2.1.4

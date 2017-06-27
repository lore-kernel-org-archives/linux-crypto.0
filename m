From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 00/14] staging: ccree: coding style fixes
Date: Tue, 27 Jun 2017 10:27:12 +0300
Message-ID: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
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

Fix a bunch of coding style across the whole ccree driver

Gilad Ben-Yossef (14):
  staging: ccree: fix missing or redundant spaces
  staging: ccree: drop comparsion to true/false
  staging: ccree: fix else placement
  staging: ccree: remove redundant blank lines
  staging: ccree: no need for braces for single statements
  staging: ccree: fix unmatched if/else braces
  staging: ccree: remove comparisons to NULL
  staging: ccree: fix pointer location
  staging: ccree: remove custom type tdes_keys_t
  staging: ccree: remove custom type ssi_fips_error_t
  staging: ccree: remove custom type ssi_fips_state_t
  staging: ccree: remove unused type CCFipsSyncStatus_t
  staging: ccree: remove/add (un)needed blank lines
  staging: ccree: fix block comment style

 drivers/staging/ccree/Kconfig            |   2 +-
 drivers/staging/ccree/cc_hw_queue_defs.h |   8 +-
 drivers/staging/ccree/ssi_aead.c         | 142 ++++++---------
 drivers/staging/ccree/ssi_aead.h         |  20 +-
 drivers/staging/ccree/ssi_buffer_mgr.c   | 301 +++++++++++++++----------------
 drivers/staging/ccree/ssi_buffer_mgr.h   |   1 -
 drivers/staging/ccree/ssi_cipher.c       | 124 +++++--------
 drivers/staging/ccree/ssi_cipher.h       |   6 -
 drivers/staging/ccree/ssi_driver.c       |  50 +++--
 drivers/staging/ccree/ssi_driver.h       |   4 +-
 drivers/staging/ccree/ssi_fips.c         |  16 +-
 drivers/staging/ccree/ssi_fips.h         |  15 +-
 drivers/staging/ccree/ssi_fips_data.h    |  20 +-
 drivers/staging/ccree/ssi_fips_ext.c     |  20 +-
 drivers/staging/ccree/ssi_fips_ll.c      | 101 +++++------
 drivers/staging/ccree/ssi_fips_local.c   | 107 +++++------
 drivers/staging/ccree/ssi_fips_local.h   |  20 +-
 drivers/staging/ccree/ssi_hash.c         | 101 +++++------
 drivers/staging/ccree/ssi_hash.h         |   6 +-
 drivers/staging/ccree/ssi_ivgen.c        |   9 +-
 drivers/staging/ccree/ssi_ivgen.h        |   1 -
 drivers/staging/ccree/ssi_pm.c           |  25 +--
 drivers/staging/ccree/ssi_pm.h           |   5 +-
 drivers/staging/ccree/ssi_request_mgr.c  | 102 +++++------
 drivers/staging/ccree/ssi_request_mgr.h  |   6 +-
 drivers/staging/ccree/ssi_sram_mgr.c     |   4 +-
 drivers/staging/ccree/ssi_sram_mgr.h     |   1 -
 drivers/staging/ccree/ssi_sysfs.c        |  66 ++++---
 drivers/staging/ccree/ssi_sysfs.h        |   1 +
 29 files changed, 550 insertions(+), 734 deletions(-)

-- 
2.1.4

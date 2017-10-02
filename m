From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/4] staging: ccree: logging related coding style fixes
Date: Mon,  2 Oct 2017 10:03:21 +0100
Message-ID: <1506935008-14240-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The following patch set cleans up some code and builds upon this to replace
ccree custom logging macros with the generic device dev_* facilities,
handles the resulting fallout and further simplifies logging handling in
some OOM error handling code path exposed by checkpatch following the
change.

Patch set based upon commit 1cd5929ab675 ("staging: greybus: light:
remove unnecessary error check") in the staging-next tree.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad Ben-Yossef (4):
  staging: ccree: remove sysfs if of deleted code
  staging: ccree: simplify access to struct device
  staging: ccree: move to generic device log infra
  staging: ccree: simplify OOM handling

 drivers/staging/ccree/ssi_aead.c        | 237 +++++++++++--------
 drivers/staging/ccree/ssi_buffer_mgr.c  | 408 +++++++++++++++-----------------
 drivers/staging/ccree/ssi_buffer_mgr.h  |   5 +-
 drivers/staging/ccree/ssi_cipher.c      | 158 ++++++-------
 drivers/staging/ccree/ssi_driver.c      | 163 ++++++-------
 drivers/staging/ccree/ssi_driver.h      |  14 +-
 drivers/staging/ccree/ssi_fips.c        |  12 +-
 drivers/staging/ccree/ssi_hash.c        | 374 ++++++++++++++---------------
 drivers/staging/ccree/ssi_ivgen.c       |  18 +-
 drivers/staging/ccree/ssi_pm.c          |  30 +--
 drivers/staging/ccree/ssi_request_mgr.c | 107 +++++----
 drivers/staging/ccree/ssi_sram_mgr.c    |  30 +--
 drivers/staging/ccree/ssi_sysfs.c       | 269 +--------------------
 13 files changed, 771 insertions(+), 1054 deletions(-)

-- 
2.7.4

From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 0/4] staging: ccree: logging related coding style fixes
Date: Tue,  3 Oct 2017 11:42:13 +0100
Message-ID: <1507027339-23824-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:46686 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751156AbdJCKml (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 06:42:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following patch set cleans up some code and builds upon this to replace
ccree custom logging macros with the generic device dev_* facilities,
handles the resulting fallout and further simplifies handling of
memory and allocation OOM error handling code path exposed by checkpatch
following the change.

Patch set based upon commit 1cd5929ab675 ("staging: greybus: light:
remove unnecessary error check") in the staging-next tree.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Changes from v1:
- Turn DEV macro into drvdats_to_dev inline function as suggested
  by Joe Perches.
- Fix a compile warning about an unused variable seen between after
  the application of the 2nd patch in the series before the 3rd.
- Remove even more uneeded code in the memory allocation functions

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
 drivers/staging/ccree/ssi_driver.h      |  19 +-
 drivers/staging/ccree/ssi_fips.c        |  12 +-
 drivers/staging/ccree/ssi_hash.c        | 374 ++++++++++++++---------------
 drivers/staging/ccree/ssi_ivgen.c       |  18 +-
 drivers/staging/ccree/ssi_pm.c          |  30 +--
 drivers/staging/ccree/ssi_request_mgr.c | 107 +++++----
 drivers/staging/ccree/ssi_sram_mgr.c    |  33 +--
 drivers/staging/ccree/ssi_sysfs.c       | 269 +--------------------
 13 files changed, 773 insertions(+), 1060 deletions(-)

-- 
2.7.4

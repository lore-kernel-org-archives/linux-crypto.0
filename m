From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/3] More code cleanups
Date: Mon,  6 Nov 2017 06:55:49 +0000
Message-ID: <1509951354-16370-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60122 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750749AbdKFG4E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 01:56:04 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Additional code readability and simplification patches.
These goes on top the previous patch set sent to the list.

Gilad Ben-Yossef (3):
  staging: ccree: simplify error handling logic
  staging: ccree: simplify registers access
  staging: ccree: simplify ioread/iowrite

 drivers/staging/ccree/cc_hal.h           | 33 --------------
 drivers/staging/ccree/cc_regs.h          | 42 ------------------
 drivers/staging/ccree/dx_reg_base_host.h | 25 -----------
 drivers/staging/ccree/ssi_driver.c       | 75 ++++++++++++++------------------
 drivers/staging/ccree/ssi_driver.h       | 20 +++++++--
 drivers/staging/ccree/ssi_fips.c         | 14 +++---
 drivers/staging/ccree/ssi_pm.c           |  4 +-
 drivers/staging/ccree/ssi_request_mgr.c  | 72 +++++++++++++++---------------
 drivers/staging/ccree/ssi_sysfs.c        | 11 +++--
 9 files changed, 98 insertions(+), 198 deletions(-)
 delete mode 100644 drivers/staging/ccree/cc_hal.h
 delete mode 100644 drivers/staging/ccree/cc_regs.h
 delete mode 100644 drivers/staging/ccree/dx_reg_base_host.h

-- 
2.7.4

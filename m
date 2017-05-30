From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 00/27] Drivers: ccree - align block comments
Date: Tue, 30 May 2017 18:09:37 +1200
Message-ID: <20170530060937.12981-1-robsonde@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Derek Robson <robsonde@gmail.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33544 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdE3GJu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 02:09:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed block comments across whole ccree driver

Version #1 has some trailing white space issue in a few patches


Derek Robson (27):
  Drivers: ccree: ssi_sysfs.h - align block comments
  Drivers: ccree: ssi_sysfs.c - align block comments
  Drivers: ccree: ssi_request_mgr.h - align block comments
  Drivers: ccree: ssi_request_mgr.c - align block comments
  Drivers: ccree: ssi_pm_ext.h - align block comments
  Drivers: ccree: ssi_pm_ext.c - align block comments
  Drivers: ccree: ssi_pm.h - align block comments
  Drivers: ccree: ssi_ivgen.c - align block comments
  Drivers: ccree: ssi_hash.h - align block comments
  Drivers: ccree: ssi_hash.c - align block comments
  Drivers: ccree: ssi_fips_local.c - align block comments
  Drivers: ccree: ssi_fips_ll.c - align block comments
  Drivers: ccree: ssi_fips_ext.c - align block comments
  Drivers: ccree: ssi_fips_data.h - align block comments
  Drivers: ccree: ssi_fips.h - align block comments
  Drivers: ccree: ssi_fips.c - align block comments
  Drivers: ccree: ssi_driver.h - align block comments
  Drivers: ccree: ssi_config.h - align block comments
  Drivers: ccree: ssi_cipher.h - align block comments
  Drivers: ccree: ssi_buffer_mgr.h - align block comments
  Drivers: ccree: ssi_buffer_mgr.c - align block comments
  Drivers: ccree: ssi_aead.h - align block comments
  Drivers: ccree: ssi_aead.c - align block comments
  Drivers: ccree: hash_defs.h - align block comments
  Drivers: ccree: cc_regs.h - align block comments
  Drivers: ccree: cc_hw_queue_defs.h - align block comments
  Drivers: ccree: cc_crypto_ctx.h - align block comments

 drivers/staging/ccree/cc_crypto_ctx.h    | 17 +++---
 drivers/staging/ccree/cc_hw_queue_defs.h | 32 +++++------
 drivers/staging/ccree/cc_regs.h          | 13 ++---
 drivers/staging/ccree/hash_defs.h        | 15 +++---
 drivers/staging/ccree/ssi_aead.c         | 45 ++++++++++------
 drivers/staging/ccree/ssi_aead.h         |  7 +--
 drivers/staging/ccree/ssi_buffer_mgr.c   | 87 +++++++++++++++++-------------
 drivers/staging/ccree/ssi_buffer_mgr.h   |  2 +-
 drivers/staging/ccree/ssi_cipher.h       |  2 +-
 drivers/staging/ccree/ssi_config.h       |  5 +-
 drivers/staging/ccree/ssi_driver.h       | 16 +++---
 drivers/staging/ccree/ssi_fips.c         | 16 +++---
 drivers/staging/ccree/ssi_fips.h         |  6 +--
 drivers/staging/ccree/ssi_fips_data.h    | 93 ++++++++++++++++----------------
 drivers/staging/ccree/ssi_fips_ext.c     | 46 ++++++++--------
 drivers/staging/ccree/ssi_fips_ll.c      | 21 ++++----
 drivers/staging/ccree/ssi_fips_local.c   | 21 ++++----
 drivers/staging/ccree/ssi_hash.c         |  9 ++--
 drivers/staging/ccree/ssi_hash.h         |  2 +-
 drivers/staging/ccree/ssi_ivgen.c        |  6 ++-
 drivers/staging/ccree/ssi_pm.h           |  2 +-
 drivers/staging/ccree/ssi_pm_ext.c       | 14 ++---
 drivers/staging/ccree/ssi_pm_ext.h       |  2 +-
 drivers/staging/ccree/ssi_request_mgr.c  | 37 +++++++------
 drivers/staging/ccree/ssi_request_mgr.h  |  2 +-
 drivers/staging/ccree/ssi_sysfs.c        |  3 +-
 drivers/staging/ccree/ssi_sysfs.h        |  2 +-
 27 files changed, 288 insertions(+), 235 deletions(-)

-- 
2.13.0

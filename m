From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 00/10] Fix alignment issues in staging/ccree
Date: Sun,  2 Jul 2017 01:25:45 +0200
Message-ID: <20170701232555.5538-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35605 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbdGAX02 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jul 2017 19:26:28 -0400
Received: by mail-lf0-f47.google.com with SMTP id b207so86272576lfg.2
        for <linux-crypto@vger.kernel.org>; Sat, 01 Jul 2017 16:26:27 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes a total of 195 alignment issues in staging/ccree reported by
checkpatch.pl. Adds a few "line over 80 characters" warnings as a
result of the realignments, but I could try to get rid of them in the
same patchset if needed.

-- Simon

---

Simon Sandström (10):
  staging: ccree: Fix alignment issues in ssi_aead.c
  staging: ccree: Fix alignment issues in ssi_buffer_mgr.c
  staging: ccree: Fix alignment issues in ssi_cipher.c
  staging: ccree: Fix alignment issues in ssi_driver.c
  staging: ccree: Fix alignment issues in ssi_fips_local.c
  staging: ccree: Fix alignment issues in ssi_hash.c
  staging: ccree: Fix alignment issues in ssi_ivgen.c
  staging: ccree: Fix alignment issues in ssi_request_mgr.c
  staging: ccree: Fix alignment issues in ssi_sram_mgr.c
  staging: ccree: Fix alignment issues in ssi_sysfs.c

 drivers/staging/ccree/ssi_aead.c        |  67 ++++----
 drivers/staging/ccree/ssi_buffer_mgr.c  | 295 ++++++++++++++++++--------------
 drivers/staging/ccree/ssi_cipher.c      |  75 ++++----
 drivers/staging/ccree/ssi_driver.c      |  40 ++---
 drivers/staging/ccree/ssi_fips_local.c  |   3 +-
 drivers/staging/ccree/ssi_hash.c        | 116 +++++++------
 drivers/staging/ccree/ssi_ivgen.c       |   3 +-
 drivers/staging/ccree/ssi_request_mgr.c |  42 +++--
 drivers/staging/ccree/ssi_sram_mgr.c    |   6 +-
 drivers/staging/ccree/ssi_sysfs.c       |  59 ++++---
 10 files changed, 372 insertions(+), 334 deletions(-)

-- 
2.11.0

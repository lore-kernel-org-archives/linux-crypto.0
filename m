From: sleepingzucchini@gmail.com
Subject: [PATCH 0/5] staging: ccree: fix checkpatch errors
Date: Sun,  9 Jul 2017 17:10:42 -0400
Message-ID: <cover.1499608047.git.sleepingzucchini@gmail.com>
Cc: gregkh@linuxfoundation.orgc, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        Tyler Olivieri <sleepingzucchini@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34660 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752707AbdGIWPx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Jul 2017 18:15:53 -0400
Received: by mail-qt0-f195.google.com with SMTP id m54so10699872qtb.1
        for <linux-crypto@vger.kernel.org>; Sun, 09 Jul 2017 15:15:53 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tyler Olivieri <sleepingzucchini@gmail.com>

This patchset fixes several checkpatch errors and warnings in /staging/ccree:

ERROR: that open brace { should be on the previous line
ERROR: open brace '{' following function declarations go on the next line
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
ERROR: do not use assignment in if condition
ERROR: switch and case should be at the same indent
WARNING: Statements terminations use 1 semicolon

This is also a submission for the eudyptula challenge. 

Tyler Olivieri (5):
  staging: ccree: remove redudant semicolons
  staging: ccree: fix placement of curly braces
  staging: ccree: remove assignement in conditional
  staging: ccree: export symbol immediately following function
  staging: ccree: fix switch case indentation

 drivers/staging/ccree/ssi_buffer_mgr.c | 14 ++----
 drivers/staging/ccree/ssi_cipher.c     |  6 ++-
 drivers/staging/ccree/ssi_driver.c     |  5 +-
 drivers/staging/ccree/ssi_fips.c       |  2 -
 drivers/staging/ccree/ssi_fips_ll.c    | 85 +++++++++++-----------------------
 drivers/staging/ccree/ssi_hash.c       | 33 +++++++------
 drivers/staging/ccree/ssi_sysfs.c      |  3 +-
 7 files changed, 57 insertions(+), 91 deletions(-)

-- 
2.9.4

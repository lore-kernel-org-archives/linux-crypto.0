From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 01/27] Drivers: ccree: ssi_sysfs.h - align block comments
Date: Wed, 24 May 2017 16:40:32 +1200
Message-ID: <20170524044032.29913-1-robsonde@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Derek Robson <robsonde@gmail.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35517 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934000AbdEXElE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 00:41:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_sysfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.h b/drivers/staging/ccree/ssi_sysfs.h
index cd456c5dccc4..4893e014adf7 100644
--- a/drivers/staging/ccree/ssi_sysfs.h
+++ b/drivers/staging/ccree/ssi_sysfs.h
@@ -15,7 +15,7 @@
  */
 
 /* \file ssi_sysfs.h
-   ARM CryptoCell sysfs APIs
+ * ARM CryptoCell sysfs APIs
  */
 
 #ifndef __SSI_SYSFS_H__
-- 
2.12.2

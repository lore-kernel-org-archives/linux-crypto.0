From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 01/27] Drivers: ccree: ssi_sysfs.h - align block comments
Date: Tue, 30 May 2017 18:09:54 +1200
Message-ID: <20170530060954.13027-1-robsonde@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Derek Robson <robsonde@gmail.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35027 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdE3GKG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 02:10:06 -0400
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
2.13.0

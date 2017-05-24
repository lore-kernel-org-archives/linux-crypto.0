From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 05/27] Drivers: ccree: ssi_pm_ext.h - align block comments
Date: Wed, 24 May 2017 16:42:08 +1200
Message-ID: <20170524044208.30097-1-robsonde@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Derek Robson <robsonde@gmail.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34817 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933009AbdEXEmR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 00:42:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_pm_ext.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_pm_ext.h b/drivers/staging/ccree/ssi_pm_ext.h
index 9049e6ffa8d3..dbe658b530bf 100644
--- a/drivers/staging/ccree/ssi_pm_ext.h
+++ b/drivers/staging/ccree/ssi_pm_ext.h
@@ -15,7 +15,7 @@
  */
 
 /* \file ssi_pm_ext.h
-    */
+ */
 
 #ifndef __PM_EXT_H__
 #define __PM_EXT_H__
-- 
2.12.2

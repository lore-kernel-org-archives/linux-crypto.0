From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH] Drivers: ccree - style fix
Date: Fri,  9 Jun 2017 18:08:00 +1200
Message-ID: <20170609060800.21736-1-robsonde@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Derek Robson <robsonde@gmail.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34117 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbdFIGIL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2017 02:08:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Align block comments
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/cc_hw_queue_defs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index aaa56c85bda2..0e6416ed9a58 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -23,8 +23,8 @@
 #include <linux/bitfield.h>
 
 /******************************************************************************
-*				DEFINITIONS
-******************************************************************************/
+ *				DEFINITIONS
+ ******************************************************************************/
 
 #define HW_DESC_SIZE_WORDS		6
 #define HW_QUEUE_SLOTS_MAX              15 /* Max. available slots in HW queue */
@@ -70,8 +70,8 @@
 #define WORD5_DOUT_ADDR_HIGH	CC_GENMASK(5, DOUT_ADDR_HIGH)
 
 /******************************************************************************
-*				TYPE DEFINITIONS
-******************************************************************************/
+ *				TYPE DEFINITIONS
+ ******************************************************************************/
 
 struct cc_hw_desc {
 	union {
-- 
2.13.0

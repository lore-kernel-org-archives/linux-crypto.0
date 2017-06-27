From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 14/14] staging: ccree: fix block comment style
Date: Tue, 27 Jun 2017 10:27:26 +0300
Message-ID: <1498548449-10803-15-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52548 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752580AbdF0H2x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2017 03:28:53 -0400
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Align block comments according to coding style.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_hw_queue_defs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index f11487a..e6b8cea 100644
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
2.1.4

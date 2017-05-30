From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 16/27] Drivers: ccree: ssi_fips.c - align block comments
Date: Tue, 30 May 2017 18:14:20 +1200
Message-ID: <20170530061420.13722-1-robsonde@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Derek Robson <robsonde@gmail.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36176 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdE3GOb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 02:14:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_fips.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index 25ee23a1cecf..60a2452f7b0b 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -16,8 +16,8 @@
 
 
 /**************************************************************
-This file defines the driver FIPS APIs                                                             *
-***************************************************************/
+ * This file defines the driver FIPS APIs                     *
+ **************************************************************/
 
 #include <linux/module.h>
 #include "ssi_fips.h"
@@ -27,9 +27,9 @@ extern int ssi_fips_ext_get_state(ssi_fips_state_t *p_state);
 extern int ssi_fips_ext_get_error(ssi_fips_error_t *p_err);
 
 /*
-This function returns the REE FIPS state.
-It should be called by kernel module.
-*/
+ * This function returns the REE FIPS state.
+ * It should be called by kernel module.
+ */
 int ssi_fips_get_state(ssi_fips_state_t *p_state)
 {
 	int rc = 0;
@@ -46,9 +46,9 @@ int ssi_fips_get_state(ssi_fips_state_t *p_state)
 EXPORT_SYMBOL(ssi_fips_get_state);
 
 /*
-This function returns the REE FIPS error.
-It should be called by kernel module.
-*/
+ * This function returns the REE FIPS error.
+ * It should be called by kernel module.
+ */
 int ssi_fips_get_error(ssi_fips_error_t *p_err)
 {
 	int rc = 0;
-- 
2.13.0

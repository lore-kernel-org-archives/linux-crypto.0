From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] staging: ccree: fix __dump_byte_array() declaration mismatch
Date: Wed, 20 Dec 2017 18:16:08 +0000
Message-ID: <1513793768-11051-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38556 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755818AbdLTSQQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 13:16:16 -0500
Received: by mail-wr0-f195.google.com with SMTP id o2so23048819wro.5
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 10:16:15 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch corrects the type of the size argument in __dump_byte_array()
from unsigned long to size_t as done only in drivers/staging/ccree/ssi_driver.c

This fix also a build error:
drivers/staging/ccree/ssi_driver.c:82:6: error: conflicting types for '__dump_byte_array'

Fixes: 3f268f5d6669 ("staging: ccree: turn compile time debug log to params")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/staging/ccree/ssi_driver.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 5a56f7a76b71..0f57c9a8b8a6 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -174,8 +174,7 @@ static inline struct device *drvdata_to_dev(struct cc_drvdata *drvdata)
 	return &drvdata->plat_dev->dev;
 }
 
-void __dump_byte_array(const char *name, const u8 *the_array,
-		       unsigned long size);
+void __dump_byte_array(const char *name, const u8 *buf, size_t size);
 static inline void dump_byte_array(const char *name, const u8 *the_array,
 				   unsigned long size)
 {
-- 
2.13.6

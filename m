From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] staging: ccree: use size_t consistently
Date: Wed, 20 Dec 2017 07:23:31 +0000
Message-ID: <1513754611-14409-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:47844 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754433AbdLTHYZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 02:24:25 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix declaration, implementation and wrapper function to use
the same size_t type we actually define the parameter to be.

Fixes: 3f268f5d6669 ("staging: ccree: turn compile time debug log to params")
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 2 +-
 drivers/staging/ccree/ssi_driver.h | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 56b5d45..1254c69 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -86,7 +86,7 @@ void __dump_byte_array(const char *name, const u8 *buf, size_t len)
 	if (!buf)
 		return;
 
-	snprintf(prefix, sizeof(prefix), "%s[%lu]: ", name, len);
+	snprintf(prefix, sizeof(prefix), "%s[%zu]: ", name, len);
 
 	print_hex_dump(KERN_DEBUG, prefix, DUMP_PREFIX_ADDRESS, 16, 1, buf,
 		       len, false);
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 5a56f7a..bf83f3e 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -174,10 +174,9 @@ static inline struct device *drvdata_to_dev(struct cc_drvdata *drvdata)
 	return &drvdata->plat_dev->dev;
 }
 
-void __dump_byte_array(const char *name, const u8 *the_array,
-		       unsigned long size);
+void __dump_byte_array(const char *name, const u8 *buf, size_t len);
 static inline void dump_byte_array(const char *name, const u8 *the_array,
-				   unsigned long size)
+				   size_t size)
 {
 	if (cc_dump_bytes)
 		__dump_byte_array(name, the_array, size);
-- 
2.7.4

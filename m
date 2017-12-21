From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] staging: ccree: fix type mismatch warning
Date: Thu, 21 Dec 2017 14:31:20 +0100
Message-ID: <20171221133139.1968427-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Suniel Mahesh <sunil.m@techveda.org>,
        Derek Robson <robsonde@gmail.com>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:56552 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbdLUNbs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Dec 2017 08:31:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

__dump_byte_array used to be hidden, but is now visible to the compiler
and causes a harmless warning:

drivers/staging/ccree/ssi_driver.c:82:6: error: conflicting types for '__dump_byte_array'
drivers/staging/ccree/ssi_driver.c: In function '__dump_byte_array':
drivers/staging/ccree/ssi_driver.c:89:41: error: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t {aka unsigned int}' [-Werror=format=]

This changes the prototype in the header to match that of the actual
function on all architectures, and the format string to match the
argument.

Fixes: 3f268f5d6669 ("staging: ccree: turn compile time debug log to params")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/ccree/ssi_driver.c | 2 +-
 drivers/staging/ccree/ssi_driver.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 56b5d45a205c..1254c6922d50 100644
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
index 5a56f7a76b71..e1406d6e1ab2 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -175,9 +175,9 @@ static inline struct device *drvdata_to_dev(struct cc_drvdata *drvdata)
 }
 
 void __dump_byte_array(const char *name, const u8 *the_array,
-		       unsigned long size);
+		       size_t size);
 static inline void dump_byte_array(const char *name, const u8 *the_array,
-				   unsigned long size)
+				   size_t size)
 {
 	if (cc_dump_bytes)
 		__dump_byte_array(name, the_array, size);
-- 
2.9.0

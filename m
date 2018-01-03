From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] staging: ccree: mark debug_regs[] as static
Date: Wed,  3 Jan 2018 10:26:17 +0100
Message-ID: <20180103092628.1930457-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:60905 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbeACJ0g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 04:26:36 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The global array clashes with an existing symbol of the same name:

drivers/staging/ccree/cc_debugfs.o:(.data+0x0): multiple definition of `debug_regs'
drivers/mmc/host/s3cmci.o:(.data+0x70): first defined here

We should fix both, this one addresses the ccree driver by removing
the symbol from the global namespace.

Fixes: 9bdd203b4dc8 ("s3cmci: add debugfs support for examining driver and hardware state")
Fixes: b3ec9a6736f2 ("staging: ccree: staging: ccree: replace sysfs by debugfs interface")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/ccree/cc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/cc_debugfs.c b/drivers/staging/ccree/cc_debugfs.c
index 7cd33957fdc6..662fa07af832 100644
--- a/drivers/staging/ccree/cc_debugfs.c
+++ b/drivers/staging/ccree/cc_debugfs.c
@@ -37,7 +37,7 @@ struct cc_debugfs_ctx {
  */
 static struct dentry *cc_debugfs_dir;
 
-struct debugfs_reg32 debug_regs[] = {
+static struct debugfs_reg32 debug_regs[] = {
 	CC_DEBUG_REG(HOST_SIGNATURE),
 	CC_DEBUG_REG(HOST_IRR),
 	CC_DEBUG_REG(HOST_POWER_DOWN_EN),
-- 
2.9.0

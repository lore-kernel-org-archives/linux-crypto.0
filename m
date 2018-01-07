From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 27/27] staging: ccree: add missing include
Date: Sun,  7 Jan 2018 12:14:38 +0000
Message-ID: <1515327285-8948-28-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add the missing include of include file with function declarations.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ccree/cc_debugfs.c b/drivers/staging/ccree/cc_debugfs.c
index f927a73..08f8db4 100644
--- a/drivers/staging/ccree/cc_debugfs.c
+++ b/drivers/staging/ccree/cc_debugfs.c
@@ -6,6 +6,7 @@
 #include <linux/stringify.h>
 #include "cc_driver.h"
 #include "cc_crypto_ctx.h"
+#include "cc_debugfs.h"
 
 struct cc_debugfs_ctx {
 	struct dentry *dir;
-- 
2.7.4

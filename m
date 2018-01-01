From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 07/26] staging: ccree: tag debugfs init/exit func properly
Date: Mon,  1 Jan 2018 12:06:34 +0000
Message-ID: <1514808421-21993-8-git-send-email-gilad@benyossef.com>
References: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The debugfs global init and exit functions were missing
__init and __exit tags, potentially wasting memory.
Fix it by properly tagging them.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/cc_debugfs.c b/drivers/staging/ccree/cc_debugfs.c
index d56cf91..62bf011 100644
--- a/drivers/staging/ccree/cc_debugfs.c
+++ b/drivers/staging/ccree/cc_debugfs.c
@@ -38,14 +38,14 @@ struct debugfs_reg32 debug_regs[] = {
 	CC_DEBUG_REG(AXIM_MON_COMP),
 };
 
-int cc_debugfs_global_init(void)
+int __init cc_debugfs_global_init(void)
 {
 	cc_debugfs_dir = debugfs_create_dir("ccree", NULL);
 
 	return !cc_debugfs_dir;
 }
 
-void cc_debugfs_global_fini(void)
+void __exit cc_debugfs_global_fini(void)
 {
 	debugfs_remove(cc_debugfs_dir);
 }
-- 
2.7.4

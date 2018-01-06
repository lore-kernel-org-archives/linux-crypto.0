From: George Edward Bulmer <gebulmer@googlemail.com>
Subject: [PATCH] staging: ccree: shorten lengthy lines with breaks
Date: Sat,  6 Jan 2018 15:47:26 +0000
Message-ID: <20180106154726.10465-1-gebulmer@googlemail.com>
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        George Edward Bulmer <gebulmer@googlemail.com>
To: gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This fixes five instances of checkpatch warning:
WARNING: line over 80 characters

Signed-off-by: George Edward Bulmer <gebulmer@googlemail.com>
---
 drivers/staging/ccree/ssi_sysfs.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 5d39f15cdb59..d488f65e4b1e 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -32,15 +32,26 @@ static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 	int offset = 0;
 
 	register_value = cc_ioread(drvdata, CC_REG(HOST_SIGNATURE));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_SIGNATURE       ", DX_HOST_SIGNATURE_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_SIGNATURE       ",
+			    DX_HOST_SIGNATURE_REG_OFFSET, register_value);
 	register_value = cc_ioread(drvdata, CC_REG(HOST_IRR));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_IRR             ", DX_HOST_IRR_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_IRR             ",
+			    DX_HOST_IRR_REG_OFFSET, register_value);
 	register_value = cc_ioread(drvdata, CC_REG(HOST_POWER_DOWN_EN));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_POWER_DOWN_EN   ", DX_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_POWER_DOWN_EN   ",
+			    DX_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
 	register_value =  cc_ioread(drvdata, CC_REG(AXIM_MON_ERR));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "AXIM_MON_ERR         ", DX_AXIM_MON_ERR_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+			    "%s \t(0x%lX)\t 0x%08X\n", "AXIM_MON_ERR         ",
+			    DX_AXIM_MON_ERR_REG_OFFSET, register_value);
 	register_value = cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "DSCRPTR_QUEUE_CONTENT", DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+			    "%s \t(0x%lX)\t 0x%08X\n", "DSCRPTR_QUEUE_CONTENT",
+			    DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET,
+			    register_value);
 	return offset;
 }
 
-- 
2.15.1

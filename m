From: Janani Sankara Babu <jananis37@gmail.com>
Subject: [PATCH] staging:ccree Fix char * array declaration
Date: Thu, 21 Sep 2017 12:11:55 +0530
Message-ID: <1505976115-28396-1-git-send-email-jananis37@gmail.com>
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Janani Sankara Babu <jananis37@gmail.com>
To: gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37685 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdIUGqu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 02:46:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch solves the following warning shown by the checkpatch script
Warning: char * array declaration might be better as static const

Signed-off-by: Janani Sankara Babu <jananis37@gmail.com>
---
 drivers/staging/ccree/ssi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index dbcd163..87cef46 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -300,7 +300,7 @@ static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 static ssize_t ssi_sys_help_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
-	char *help_str[] = {
+	static const char *help_str[] = {
 				"cat reg_dump              ", "Print several of CC register values",
 		#if defined CC_CYCLE_COUNT
 				"cat stats_host            ", "Print host statistics",
-- 
1.9.1

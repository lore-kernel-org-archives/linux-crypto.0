Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20537C43464
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 01:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE22420659
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 01:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgIRBaq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 21:30:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55854 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726245AbgIRBaq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 21:30:46 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 385D9E9300440C0C19D1;
        Fri, 18 Sep 2020 09:30:45 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 09:30:37 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Qinglang Miao" <miaoqinglang@huawei.com>
Subject: [PATCH -next v2] crypto: cavium/zip - Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Fri, 18 Sep 2020 09:31:12 +0800
Message-ID: <20200918013112.82695-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
v2: based on linux-next(20200917), and can be applied to
    mainline cleanly now.

 drivers/crypto/cavium/zip/zip_main.c | 44 ++++------------------------
 1 file changed, 6 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
index 194624b48..d35216e2f 100644
--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -460,7 +460,7 @@ static void zip_unregister_compression_device(void)
 #include <linux/debugfs.h>
 
 /* Displays ZIP device statistics */
-static int zip_show_stats(struct seq_file *s, void *unused)
+static int zip_stats_show(struct seq_file *s, void *unused)
 {
 	u64 val = 0ull;
 	u64 avg_chunk = 0ull, avg_cr = 0ull;
@@ -523,7 +523,7 @@ static int zip_show_stats(struct seq_file *s, void *unused)
 }
 
 /* Clears stats data */
-static int zip_clear_stats(struct seq_file *s, void *unused)
+static int zip_clear_show(struct seq_file *s, void *unused)
 {
 	int index = 0;
 
@@ -558,7 +558,7 @@ static struct zip_registers zipregs[64] = {
 };
 
 /* Prints registers' contents */
-static int zip_print_regs(struct seq_file *s, void *unused)
+static int zip_regs_show(struct seq_file *s, void *unused)
 {
 	u64 val = 0;
 	int i = 0, index = 0;
@@ -584,41 +584,9 @@ static int zip_print_regs(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int zip_stats_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, zip_show_stats, NULL);
-}
-
-static const struct file_operations zip_stats_fops = {
-	.owner = THIS_MODULE,
-	.open  = zip_stats_open,
-	.read  = seq_read,
-	.release = single_release,
-};
-
-static int zip_clear_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, zip_clear_stats, NULL);
-}
-
-static const struct file_operations zip_clear_fops = {
-	.owner = THIS_MODULE,
-	.open  = zip_clear_open,
-	.read  = seq_read,
-	.release = single_release,
-};
-
-static int zip_regs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, zip_print_regs, NULL);
-}
-
-static const struct file_operations zip_regs_fops = {
-	.owner = THIS_MODULE,
-	.open  = zip_regs_open,
-	.read  = seq_read,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(zip_stats);
+DEFINE_SHOW_ATTRIBUTE(zip_clear);
+DEFINE_SHOW_ATTRIBUTE(zip_regs);
 
 /* Root directory for thunderx_zip debugfs entry */
 static struct dentry *zip_debugfs_root;
-- 
2.23.0


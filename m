Return-Path: <SRS0=BBPV=OK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37730 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbeLAVIm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Dec 2018 16:08:42 -0500
From: Yangtao Li <tiny.windzz@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        Jampala.Srikanth@cavium.com, sgadam@cavium.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH] crypto: cavium/nitrox convert to DEFINE_SHOW_ATTRIBUTE
Date: Sat,  1 Dec 2018 04:56:30 -0500
Message-Id: <20181201095630.6232-1-tiny.windzz@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
---
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c | 48 ++++---------------
 1 file changed, 9 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
index 5f3cd5fafe04..0196b992280f 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
@@ -13,18 +13,7 @@ static int firmware_show(struct seq_file *s, void *v)
 	return 0;
 }
 
-static int firmware_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, firmware_show, inode->i_private);
-}
-
-static const struct file_operations firmware_fops = {
-	.owner = THIS_MODULE,
-	.open = firmware_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(firmware);
 
 static int device_show(struct seq_file *s, void *v)
 {
@@ -41,18 +30,7 @@ static int device_show(struct seq_file *s, void *v)
 	return 0;
 }
 
-static int nitrox_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, device_show, inode->i_private);
-}
-
-static const struct file_operations nitrox_fops = {
-	.owner = THIS_MODULE,
-	.open = nitrox_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(device);
 
 static int stats_show(struct seq_file *s, void *v)
 {
@@ -69,18 +47,7 @@ static int stats_show(struct seq_file *s, void *v)
 	return 0;
 }
 
-static int nitrox_stats_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, stats_show, inode->i_private);
-}
-
-static const struct file_operations nitrox_stats_fops = {
-	.owner = THIS_MODULE,
-	.open = nitrox_stats_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(stats);
 
 void nitrox_debugfs_exit(struct nitrox_device *ndev)
 {
@@ -97,13 +64,16 @@ int nitrox_debugfs_init(struct nitrox_device *ndev)
 		return -ENOMEM;
 
 	ndev->debugfs_dir = dir;
-	f = debugfs_create_file("firmware", 0400, dir, ndev, &firmware_fops);
+	f = debugfs_create_file("firmware", 0400, dir, ndev,
+				&firmware_fops);
 	if (!f)
 		goto err;
-	f = debugfs_create_file("device", 0400, dir, ndev, &nitrox_fops);
+	f = debugfs_create_file("device", 0400, dir, ndev,
+				&device_fops);
 	if (!f)
 		goto err;
-	f = debugfs_create_file("stats", 0400, dir, ndev, &nitrox_stats_fops);
+	f = debugfs_create_file("stats", 0400, dir, ndev,
+				&stats_fops);
 	if (!f)
 		goto err;
 
-- 
2.17.0

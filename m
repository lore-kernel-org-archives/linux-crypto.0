From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH] crypto: change hwrng device default permissions to 0444
Date: Mon,  3 Jul 2017 12:37:59 +0200
Message-ID: <1499078279-19135-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, schwidefsky@de.ibm.com,
        Christian.Rund@de.ibm.com,
        Harald Freudenberger <freude@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50279 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753413AbdGCKiW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jul 2017 06:38:22 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v63AYBf5120358
        for <linux-crypto@vger.kernel.org>; Mon, 3 Jul 2017 06:38:22 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bfhghy1v8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 03 Jul 2017 06:38:21 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@de.ibm.com>;
        Mon, 3 Jul 2017 11:38:19 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently /dev/hwrng uses default device node permissions
which is 0600. So by default the device node is not accessible
by an ordinary user. Some distros do rewrite the device node
permissions via udev rule, others don't. This patch provides
0444 as the new mode value and so makes the device node
accessible for all users without the need to have udev rules
rewriting the access rights.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
---
 drivers/char/hw_random/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 503a41d..4093db5 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -285,6 +285,7 @@ static struct miscdevice rng_miscdev = {
 	.minor		= HWRNG_MINOR,
 	.name		= RNG_MODULE_NAME,
 	.nodename	= "hwrng",
+	.mode		= 0444,
 	.fops		= &rng_chrdev_ops,
 	.groups		= rng_dev_groups,
 };
-- 
2.7.4

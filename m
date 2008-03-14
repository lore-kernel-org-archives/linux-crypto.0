From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 1/2] hw_random: allow rng_dev_read() to return hardware errors.
Date: Fri, 14 Mar 2008 10:25:24 +0100
Message-ID: <20080314093046.656233449@de.ibm.com>
References: <20080314092523.147382820@de.ibm.com>
Cc: Ralph Wuerthner <rwuerthn@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:30346 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033AbYCNJav (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Mar 2008 05:30:51 -0400
Content-Disposition: inline; filename=111-crypto-hwerrors.diff
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ralph Wuerthner <rwuerthn@de.ibm.com>

The api for hardware random number generators is currently limited to
devices that never fail. If the hardware is registered as a source for
random numbers it has to work. This prevents the use of i/o based
random number devices where the i/o might fail.

Add a check for errors after the read from a hardware random number device.

This patch is required to support large random numbers retrieved
from the CEX2C cards on System z.

Signed-off-by: Ralph Wuerthner <rwuerthn@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/char/hw_random/core.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: quilt-2.6/drivers/char/hw_random/core.c
===================================================================
--- quilt-2.6.orig/drivers/char/hw_random/core.c
+++ quilt-2.6/drivers/char/hw_random/core.c
@@ -116,6 +116,10 @@ static ssize_t rng_dev_read(struct file 
 		err = -EAGAIN;
 		if (!bytes_read && (filp->f_flags & O_NONBLOCK))
 			goto out;
+		if (bytes_read < 0) {
+			err = bytes_read;
+			goto out;
+		}
 
 		err = -EFAULT;
 		while (bytes_read && size) {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


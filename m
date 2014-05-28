From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] crypto/nx/nx-842: dev_set_drvdata can no longer fail
Date: Wed, 28 May 2014 14:02:24 +0200
Message-ID: <20140528140224.3352b072@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Robert Jennings <rcj@linux.vnet.ibm.com>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaE1MC2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 May 2014 08:02:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Don't check if dev_set_drvdata() failed, it can't, and it returns void
now.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
Cc: Fionnuala Gunter <fin@linux.vnet.ibm.com>
---
I believe this should go through Greg's driver-core tree, as this is
where the rest of the dev_set_drvdata() changes are.

 drivers/crypto/nx/nx-842.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -1197,12 +1197,7 @@ static int __init nx842_probe(struct vio
 	}
 
 	rcu_read_lock();
-	if (dev_set_drvdata(&viodev->dev, rcu_dereference(devdata))) {
-		rcu_read_unlock();
-		dev_err(&viodev->dev, "failed to set driver data for device\n");
-		ret = -1;
-		goto error;
-	}
+	dev_set_drvdata(&viodev->dev, rcu_dereference(devdata));
 	rcu_read_unlock();
 
 	if (sysfs_create_group(&viodev->dev.kobj, &nx842_attribute_group)) {


-- 
Jean Delvare
SUSE L3 Support

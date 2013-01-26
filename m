From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] padata: test correct variable in ->store function
Date: Sat, 26 Jan 2013 10:49:46 +0300
Message-ID: <20130126074946.GC14365@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Dan Kruchinin <dkruchinin@acm.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37877 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3AZHtz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Jan 2013 02:49:55 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It's testing for ->show but calling ->store().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static analysis.  I don't know if it affects real life.

diff --git a/kernel/padata.c b/kernel/padata.c
index 072f4ee..7ac61c1 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1013,7 +1013,7 @@ static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
 
 	pinst = kobj2pinst(kobj);
 	pentry = attr2pentry(attr);
-	if (pentry->show)
+	if (pentry->store)
 		ret = pentry->store(pinst, attr, buf, count);
 
 	return ret;

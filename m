From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: [PATCH 2/6] nx-842-pseries: rename nx842_{init,exit} to
 nx842_pseries_{init,exit}
Date: Thu, 2 Jul 2015 15:39:21 -0700
Message-ID: <20150702223921.GC1712@linux.vnet.ibm.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Dan Streetman <ddstreet@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:56551 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbbGBWjZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 18:39:25 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <nacc@linux.vnet.ibm.com>;
	Thu, 2 Jul 2015 16:39:34 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 64ADD1FF001E
	for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2015 16:30:33 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t62MdMJm47841392
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 15:39:22 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t62MdMM2011513
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 16:39:22 -0600
Content-Disposition: inline
In-Reply-To: <20150702223800.GA1712@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

While there is no technical reason that both nx-842.c and
nx-842-pseries.c can have the same name for the init/exit functions, it
is a bit confusing with initcall_debug. Rename the pseries specific
functions appropriately

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

---
 drivers/crypto/nx/nx-842-pseries.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 819c23c546e3..e17f4d2e96e0 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -1080,7 +1080,7 @@ static struct vio_driver nx842_vio_driver = {
 	.id_table = nx842_vio_driver_ids,
 };
 
-static int __init nx842_init(void)
+static int __init nx842_pseries_init(void)
 {
 	struct nx842_devdata *new_devdata;
 	int ret;
@@ -1116,9 +1116,9 @@ static int __init nx842_init(void)
 	return 0;
 }
 
-module_init(nx842_init);
+module_init(nx842_pseries_init);
 
-static void __exit nx842_exit(void)
+static void __exit nx842_pseries_exit(void)
 {
 	struct nx842_devdata *old_devdata;
 	unsigned long flags;
@@ -1137,5 +1137,5 @@ static void __exit nx842_exit(void)
 	vio_unregister_driver(&nx842_vio_driver);
 }
 
-module_exit(nx842_exit);
+module_exit(nx842_pseries_exit);
 
-- 
2.1.4

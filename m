From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: [PATCH 4/6] crypto/nx-842-{powerpc,pseries}: only load on the
 appropriate machine type
Date: Thu, 2 Jul 2015 15:40:49 -0700
Message-ID: <20150702224049.GE1712@linux.vnet.ibm.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Dan Streetman <ddstreet@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:59431 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbbGBWkx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 18:40:53 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <nacc@linux.vnet.ibm.com>;
	Thu, 2 Jul 2015 18:40:53 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id E60196E803F
	for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2015 18:32:37 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t62Meo7o60620938
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 22:40:50 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t62Meo3e008382
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 18:40:50 -0400
Content-Disposition: inline
In-Reply-To: <20150702223800.GA1712@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

While we never would successfully load on the wrong machine type, there
is extra output by default regardless of machine type.

For instance, on a PowerVM LPAR, we see the following:

nx_compress_powernv: loading
nx_compress_powernv: no coprocessors found

even though those coprocessors could never be found. Similar pseries
messages are printed on powernv.

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

---
 drivers/crypto/nx/nx-842-powernv.c | 6 ++++++
 drivers/crypto/nx/nx-842-pseries.c | 6 ++++++
 drivers/crypto/nx/nx-842.h         | 1 +
 3 files changed, 13 insertions(+)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 33b3b0abf4ae..6b5e5143c95b 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -594,6 +594,9 @@ static __init int nx842_powernv_init(void)
 	BUILD_BUG_ON(DDE_BUFFER_ALIGN % DDE_BUFFER_SIZE_MULT);
 	BUILD_BUG_ON(DDE_BUFFER_SIZE_MULT % DDE_BUFFER_LAST_MULT);
 
+	if (!machine_is(powernv))
+		return -ENODEV;
+
 	pr_info("loading\n");
 
 	for_each_compatible_node(dn, NULL, "ibm,power-nx")
@@ -625,6 +628,9 @@ static void __exit nx842_powernv_exit(void)
 {
 	struct nx842_coproc *coproc, *n;
 
+	if (!machine_is(powernv))
+		return;
+
 	nx842_platform_driver_unset(&nx842_powernv_driver);
 
 	list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index b84b0ceeb46e..75a7bfdc160e 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -1091,6 +1091,9 @@ static int __init nx842_pseries_init(void)
 	struct nx842_devdata *new_devdata;
 	int ret;
 
+	if (!machine_is(pseries))
+		return -ENODEV;
+
 	pr_info("Registering IBM Power 842 compression driver\n");
 
 	if (!of_find_compatible_node(NULL, NULL, "ibm,compression"))
@@ -1129,6 +1132,9 @@ static void __exit nx842_pseries_exit(void)
 	struct nx842_devdata *old_devdata;
 	unsigned long flags;
 
+	if (!machine_is(pseries))
+		return;
+
 	pr_info("Exiting IBM Power 842 compression driver\n");
 	nx842_platform_driver_unset(&nx842_pseries_driver);
 	spin_lock_irqsave(&devdata_mutex, flags);
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index ac0ea79d0f8b..ea89c661e476 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -10,6 +10,7 @@
 #include <linux/io.h>
 #include <linux/mm.h>
 #include <linux/ratelimit.h>
+#include <asm/machdep.h>
 
 /* Restrictions on Data Descriptor List (DDL) and Entry (DDE) buffers
  *
-- 
2.1.4

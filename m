From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [cryptodev PATCH] qat: cleanup coccicheck warning - NULL check before
	freeing functions
Date: Wed, 15 Oct 2014 11:33:21 -0700
Message-ID: <20141015183321.23860.21499.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tadeusz.struk@intel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, qat-linux@intel.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26487 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaJOSdZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Oct 2014 14:33:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Analyzing with coccinelle MODE=report...

Please check for false positives in the output before submitting a patch.
When using "patch" mode, carefully review the patch before submitting it.

drivers/crypto/qat/qat_dh895xcc/adf_isr.c:191:3-8: WARNING: NULL check
before freeing functions like kfree, debugfs_remove,
debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider
reorganizing relevant code to avoid passing NULL values.

drivers/crypto/qat/qat_dh895xcc/adf_isr.c:208:3-8: WARNING: NULL check
before freeing functions like kfree, debugfs_remove,
debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider
reorganizing relevant code to avoid passing NULL values.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---

 drivers/crypto/qat/qat_dh895xcc/adf_isr.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
index 67ec61e..c9212b9 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
@@ -186,10 +186,8 @@ static int adf_isr_alloc_msix_entry_table(struct adf_accel_dev *accel_dev)
 	accel_dev->accel_pci_dev.msix_entries.names = names;
 	return 0;
 err:
-	for (i = 0; i < msix_num_entries; i++) {
-		if (*(names + i))
-			kfree(*(names + i));
-	}
+	for (i = 0; i < msix_num_entries; i++)
+		kfree(*(names + i));
 	kfree(entries);
 	kfree(names);
 	return -ENOMEM;
@@ -203,10 +201,8 @@ static void adf_isr_free_msix_entry_table(struct adf_accel_dev *accel_dev)
 	int i;
 
 	kfree(accel_dev->accel_pci_dev.msix_entries.entries);
-	for (i = 0; i < msix_num_entries; i++) {
-		if (*(names + i))
-			kfree(*(names + i));
-	}
+	for (i = 0; i < msix_num_entries; i++)
+		kfree(*(names + i));
 	kfree(names);
 }
 

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] crypto: qat - remove incorrect __exit markup
Date: Mon, 9 Mar 2015 13:25:49 -0700
Message-ID: <20150309202549.GA9684@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	"Allan, Bruce W" <bruce.w.allan@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46546 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbbCIUZy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 16:25:54 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

PCI bus is hot-pluggable, and even if it wasn't one can still unbind the
device from driver via sysfs, so we should not make driver's remove
method as __exit.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 8ffdb95..e7af9d5 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -379,7 +379,7 @@ out_err:
 	return ret;
 }
 
-static void __exit adf_remove(struct pci_dev *pdev)
+static void adf_remove(struct pci_dev *pdev)
 {
 	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
 
-- 
2.2.0.rc0.207.ga3a616c


-- 
Dmitry

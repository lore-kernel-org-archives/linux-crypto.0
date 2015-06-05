From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - Set max request size
Date: Fri, 05 Jun 2015 15:51:18 -0700
Message-ID: <20150605225118.4911.47264.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tianliang.wang@intel.com, davem@davemloft.net,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:27770 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbbFEWvJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Jun 2015 18:51:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The device doensn't support the default value and will change it to 256, which
will cause performace degradation for biger packets.
Add an explicit write to set it to 1024.

Reported-by: Tianliang Wang <tianliang.wang@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index ecf0ef1..1bde45b 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -300,6 +300,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err;
 
+	pcie_set_readrq(pdev, 1024);
+
 	/* enable PCI device */
 	if (pci_enable_device(pdev)) {
 		ret = -EFAULT;

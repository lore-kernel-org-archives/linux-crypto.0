From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - VF should never trigger SBR on PH
Date: Fri, 18 Sep 2015 08:59:47 -0700
Message-ID: <20150918155947.24663.97648.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	conor.mcloughlin@intel.com, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35339 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbbIRQBv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 12:01:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Conor McLoughlin <conor.mcloughlin@intel.com>

Don't allow to trigger SBR from a VF running in VMM context.

Signed-off-by: Conor McLoughlin <conor.mcloughlin@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_aer.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index a57b419..0a5ca0b 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -88,6 +88,9 @@ static void adf_dev_restore(struct adf_accel_dev *accel_dev)
 	struct pci_dev *parent = pdev->bus->self;
 	uint16_t bridge_ctl = 0;
 
+	if (accel_dev->is_vf)
+		return;
+
 	dev_info(&GET_DEV(accel_dev), "Resetting device qat_dev%d\n",
 		 accel_dev->accel_id);
 

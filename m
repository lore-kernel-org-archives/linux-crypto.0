From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/7] crypto: qat - add new device definitions
Date: Fri, 04 Dec 2015 16:56:17 -0800
Message-ID: <20151205005617.27411.90530.stgit@tstruk-mobl1>
References: <20151205005612.27411.60451.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, pingchao.yang@intel.com,
	qat-linux@intel.com, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53304 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbbLEA71 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2015 19:59:27 -0500
In-Reply-To: <20151205005612.27411.60451.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add dev ids and names for the new device types.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index ca853d5..9786a2e 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -55,8 +55,18 @@
 
 #define ADF_DH895XCC_DEVICE_NAME "dh895xcc"
 #define ADF_DH895XCCVF_DEVICE_NAME "dh895xccvf"
+#define ADF_C62X_DEVICE_NAME "c62x"
+#define ADF_C62XVF_DEVICE_NAME "c62xvf"
+#define ADF_C3XXX_DEVICE_NAME "c3xxx"
+#define ADF_C3XXXVF_DEVICE_NAME "c3xxxvf"
 #define ADF_DH895XCC_PCI_DEVICE_ID 0x435
 #define ADF_DH895XCCIOV_PCI_DEVICE_ID 0x443
+#define ADF_C62X_PCI_DEVICE_ID 0x37c8
+#define ADF_C62XIOV_PCI_DEVICE_ID 0x37c9
+#define ADF_C3XXX_PCI_DEVICE_ID 0x19e2
+#define ADF_C3XXXIOV_PCI_DEVICE_ID 0x19e3
+#define ADF_ERRSOU3 (0x3A000 + 0x0C)
+#define ADF_ERRSOU5 (0x3A000 + 0xD8)
 #define ADF_PCI_MAX_BARS 3
 #define ADF_DEVICE_NAME_LENGTH 32
 #define ADF_ETR_MAX_RINGS_PER_BANK 16

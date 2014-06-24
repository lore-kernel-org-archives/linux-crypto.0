From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 2/4] crypto: qat: Updated Firmware Info Metadata
Date: Tue, 24 Jun 2014 15:19:29 -0700
Message-ID: <20140624221929.3872.19304.stgit@tstruk-mobl1.intel.com>
References: <20140624221833.3872.65930.stgit@tstruk-mobl1.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, bruce.w.allan@intel.com,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaFXWWw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Jun 2014 18:22:52 -0400
In-Reply-To: <20140624221833.3872.65930.stgit@tstruk-mobl1.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Updated Firmware Info Metadata

Reviewed-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/Kconfig                |    1 +
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 3bd3fd9..49bede2 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -8,6 +8,7 @@ config CRYPTO_DEV_QAT
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select FW_LOADER
 
 config CRYPTO_DEV_QAT_DH895xCC
 	tristate "Support for Intel(R) DH895xCC"
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 1da2f78..0d0435a 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -445,4 +445,5 @@ module_exit(adfdrv_release);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
+MODULE_FIRMWARE("qat_895xcc.bin");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");

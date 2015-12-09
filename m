From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - select PCI_IOV when VF are enabled
Date: Wed, 09 Dec 2015 11:59:47 -0800
Message-ID: <20151209195947.17596.6859.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: fengguang.wu@intel.com, linux-crypto@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:23117 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbbLIUDR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 15:03:17 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix i386-randconfig-x004-12092241.
PCI_IOV needs to be selected when VFs are enabled

Reported-by: <fengguang.wu@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index d275d48..85b44e5 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -60,6 +60,7 @@ config CRYPTO_DEV_QAT_DH895xCCVF
 config CRYPTO_DEV_QAT_C3XXXVF
 	tristate "Support for Intel(R) C3XXX Virtual Function"
 	depends on X86 && PCI
+	select PCI_IOV
 	select CRYPTO_DEV_QAT
 	help
 	  Support for Intel(R) C3xxx with Intel(R) QuickAssist Technology
@@ -71,6 +72,7 @@ config CRYPTO_DEV_QAT_C3XXXVF
 config CRYPTO_DEV_QAT_C62XVF
 	tristate "Support for Intel(R) C62X Virtual Function"
 	depends on X86 && PCI
+	select PCI_IOV
 	select CRYPTO_DEV_QAT
 	help
 	  Support for Intel(R) C62x with Intel(R) QuickAssist Technology

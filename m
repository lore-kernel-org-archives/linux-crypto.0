From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/3] crypto: qat: Enable all 32 IRQs
Date: Wed, 10 Sep 2014 14:07:25 -0700
Message-ID: <20140910210725.25455.59705.stgit@tstruk-mobl1>
References: <20140910210559.25455.16693.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, bruce.w.allan@intel.com, qat-linux@intel.com,
	conor.mcloughlin@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19980 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaIJVIt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Sep 2014 17:08:49 -0400
In-Reply-To: <20140910210559.25455.16693.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable interrupts from all 32 bundles.

Signed-off-by: Conor McLoughlin <conor.mcloughlin@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index b707f29..65dd1ff 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -66,7 +66,7 @@
 #define ADF_DH895XCC_ETR_MAX_BANKS 32
 #define ADF_DH895XCC_SMIAPF0_MASK_OFFSET (0x3A000 + 0x28)
 #define ADF_DH895XCC_SMIAPF1_MASK_OFFSET (0x3A000 + 0x30)
-#define ADF_DH895XCC_SMIA0_MASK 0xFFFF
+#define ADF_DH895XCC_SMIA0_MASK 0xFFFFFFFF
 #define ADF_DH895XCC_SMIA1_MASK 0x1
 /* Error detection and correction */
 #define ADF_DH895XCC_AE_CTX_ENABLES(i) (i * 0x1000 + 0x20818)

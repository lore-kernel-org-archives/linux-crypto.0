From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix bug in ADF_RING_SIZE_BYTES_MIN macro
Date: Fri, 24 Jul 2015 13:18:25 -0700
Message-ID: <20150724201825.27624.22237.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Bruce Allan <bruce.w.allan@intel.com>, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbbGXUTG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2015 16:19:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Bruce Allan <bruce.w.allan@intel.com>

The subject macro mistakenly compares the passed-in ring size in bytes
with ADF_RING_SIZE_4K which is 0x6 (an internal representation of 4KB)
rather than comparing with the intended value of 4096.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 .../qat/qat_common/adf_transport_access_macros.h   |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
index 160c9a3..6ad7e4e 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
@@ -97,8 +97,9 @@
 #define ADF_RING_SIZE_IN_BYTES_TO_SIZE(SIZE) ((1 << (SIZE - 1)) >> 7)
 
 /* Minimum ring bufer size for memory allocation */
-#define ADF_RING_SIZE_BYTES_MIN(SIZE) ((SIZE < ADF_RING_SIZE_4K) ? \
-				ADF_RING_SIZE_4K : SIZE)
+#define ADF_RING_SIZE_BYTES_MIN(SIZE) \
+	((SIZE < ADF_SIZE_TO_RING_SIZE_IN_BYTES(ADF_RING_SIZE_4K)) ? \
+		ADF_SIZE_TO_RING_SIZE_IN_BYTES(ADF_RING_SIZE_4K) : SIZE)
 #define ADF_RING_SIZE_MODULO(SIZE) (SIZE + 0x6)
 #define ADF_SIZE_TO_POW(SIZE) ((((SIZE & 0x4) >> 1) | ((SIZE & 0x4) >> 2) | \
 				SIZE) & ~0x4)

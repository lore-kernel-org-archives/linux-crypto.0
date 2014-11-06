From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC 1/4] crytpo: qat - Fix 64 bytes requests
Date: Thu, 06 Nov 2014 11:59:37 -0800
Message-ID: <20141106195937.13328.38363.stgit@tstruk-mobl1>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4451 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbaKFUC6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 15:02:58 -0500
In-Reply-To: <20141106195931.13328.90501.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix invalid inflights calculation for 64byte PKE requests that will be sent
from userspace.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 .../qat/qat_common/adf_transport_access_macros.h   |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
index 91d88d6..160c9a3 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
@@ -83,14 +83,14 @@
 #define ADF_MAX_RING_SIZE ADF_RING_SIZE_4M
 #define ADF_DEFAULT_RING_SIZE ADF_RING_SIZE_16K
 
-/* Valid internal msg size values internal */
+/* Valid internal msg size values */
 #define ADF_MSG_SIZE_32 0x01
 #define ADF_MSG_SIZE_64 0x02
 #define ADF_MSG_SIZE_128 0x04
 #define ADF_MIN_MSG_SIZE ADF_MSG_SIZE_32
 #define ADF_MAX_MSG_SIZE ADF_MSG_SIZE_128
 
-/* Size to bytes conversion macros for ring and msg values */
+/* Size to bytes conversion macros for ring and msg size values */
 #define ADF_MSG_SIZE_TO_BYTES(SIZE) (SIZE << 5)
 #define ADF_BYTES_TO_MSG_SIZE(SIZE) (SIZE >> 5)
 #define ADF_SIZE_TO_RING_SIZE_IN_BYTES(SIZE) ((1 << (SIZE - 1)) << 7)
@@ -100,8 +100,11 @@
 #define ADF_RING_SIZE_BYTES_MIN(SIZE) ((SIZE < ADF_RING_SIZE_4K) ? \
 				ADF_RING_SIZE_4K : SIZE)
 #define ADF_RING_SIZE_MODULO(SIZE) (SIZE + 0x6)
+#define ADF_SIZE_TO_POW(SIZE) ((((SIZE & 0x4) >> 1) | ((SIZE & 0x4) >> 2) | \
+				SIZE) & ~0x4)
+/* Max outstanding requests */
 #define ADF_MAX_INFLIGHTS(RING_SIZE, MSG_SIZE) \
-	((((1 << (RING_SIZE - 1)) << 4) >> MSG_SIZE) - 1)
+	((((1 << (RING_SIZE - 1)) << 3) >> ADF_SIZE_TO_POW(MSG_SIZE)) - 1)
 #define BUILD_RING_CONFIG(size)	\
 	((ADF_RING_NEAR_WATERMARK_0 << ADF_RING_CONFIG_NEAR_FULL_WM) \
 	| (ADF_RING_NEAR_WATERMARK_0 << ADF_RING_CONFIG_NEAR_EMPTY_WM) \

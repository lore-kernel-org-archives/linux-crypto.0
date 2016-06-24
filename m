From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH 2/7] crypto: sha256-mb - Enable multibuffer support
Date: Thu, 23 Jun 2016 18:40:43 -0700
Message-ID: <1466732448-27856-3-git-send-email-megha.dey@intel.com>
References: <1466732448-27856-1-git-send-email-megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	megha.dey@intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466732448-27856-1-git-send-email-megha.dey@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add the config CRYPTO_SHA256_MB which will enable the computation using the
SHA256 multi-buffer algorithm.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/Kconfig | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5baaa9d..d8cc0f0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -704,6 +704,22 @@ config CRYPTO_SHA1_MB
 	  lanes remain unfilled, a flush operation will be initiated to
 	  process the crypto jobs, adding a slight latency.
 
+config CRYPTO_SHA256_MB
+	tristate "SHA256 digest algorithm (x86_64 Multi-Buffer, Experimental)"
+	depends on X86 && 64BIT
+	select CRYPTO_SHA256
+	select CRYPTO_HASH
+	select CRYPTO_MCRYPTD
+	help
+	  SHA-256 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
+	  using multi-buffer technique.  This algorithm computes on
+	  multiple data lanes concurrently with SIMD instructions for
+	  better throughput.  It should not be enabled by default but
+	  used when there is significant amount of work to keep the keep
+	  the data lanes filled to get performance benefit.  If the data
+	  lanes remain unfilled, a flush operation will be initiated to
+	  process the crypto jobs, adding a slight latency.
+
 config CRYPTO_SHA256
 	tristate "SHA224 and SHA256 digest algorithm"
 	select CRYPTO_HASH
-- 
1.9.1

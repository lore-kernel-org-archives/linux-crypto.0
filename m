From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 4/4] crypto: Use ARCH_KMALLOC_MINALIGN for CRYPTO_MINALIGN
 now that it's exposed
Date: Wed, 19 May 2010 12:02:17 +0100
Message-ID: <1274266937.6930.9841.camel@macbook.infradead.org>
References: <1274266725.6930.9823.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
	mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
	michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1274266725.6930.9823.camel@macbook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 include/linux/crypto.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 24d2e30..a6a7a1c 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -99,13 +99,7 @@
  * as arm where pointers are 32-bit aligned but there are data types such as
  * u64 which require 64-bit alignment.
  */
-#if defined(ARCH_KMALLOC_MINALIGN)
 #define CRYPTO_MINALIGN ARCH_KMALLOC_MINALIGN
-#elif defined(ARCH_SLAB_MINALIGN)
-#define CRYPTO_MINALIGN ARCH_SLAB_MINALIGN
-#else
-#define CRYPTO_MINALIGN __alignof__(unsigned long long)
-#endif
 
 #define CRYPTO_MINALIGN_ATTR __attribute__ ((__aligned__(CRYPTO_MINALIGN)))
 
-- 
1.6.6.1

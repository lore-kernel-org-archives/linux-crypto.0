From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 01/20] crypto: prevent helper ciphers from being used
Date: Mon, 30 Mar 2015 21:55:52 +0200
Message-ID: <41994679.OgvKdo2o3x@tachyon.chronox.de>
References: <3417827.fluZli1WvQ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3417827.fluZli1WvQ@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Several hardware related cipher implementations are implemented as
follows: a "helper" cipher implementation is registered with the
kernel crypto API.

Such helper ciphers are never intended to be called by normal users. In
some cases, calling them via the normal crypto API may even cause
failures including kernel crashes. In a normal case, the "wrapping"
ciphers that use the helpers ensure that these helpers are invoked
such that they cannot cause any calamity.

Considering the AF_ALG user space interface, unprivileged users can
call all ciphers registered with the crypto API, including these
helper ciphers that are not intended to be called directly. That
means, with AF_ALG user space may invoke these helper ciphers
and may cause undefined states or side effects.

To avoid any potential side effects with such helpers, the patch
prevents the helpers to be called directly. A new cipher type
flag is added: CRYPTO_ALG_INTERNAL. This flag shall be used
to mark helper ciphers. These ciphers can only be used if the
caller invoke the cipher with CRYPTO_ALG_INTERNAL in the type and
mask field.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/api.c           | 10 ++++++++++
 include/linux/crypto.h |  6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/crypto/api.c b/crypto/api.c
index 2a81e98..afe4610 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -257,6 +257,16 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
 		mask |= CRYPTO_ALG_TESTED;
 	}
 
+	/*
+	 * If the internal flag is set for a cipher, require a caller to
+	 * to invoke the cipher with the internal flag to use that cipher.
+	 * Also, if a caller wants to allocate a cipher that may or may
+	 * not be an internal cipher, use type | CRYPTO_ALG_INTERNAL and
+	 * !(mask & CRYPTO_ALG_INTERNAL).
+	 */
+	if (!((type | mask) & CRYPTO_ALG_INTERNAL))
+		mask |= CRYPTO_ALG_INTERNAL;
+
 	larval = crypto_larval_lookup(name, type, mask);
 	if (IS_ERR(larval) || !crypto_is_larval(larval))
 		return larval;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index fb5ef16..10df5d2 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -95,6 +95,12 @@
 #define CRYPTO_ALG_KERN_DRIVER_ONLY	0x00001000
 
 /*
+ * Mark a cipher as a service implementation only usable by another
+ * cipher and never by a normal user of the kernel crypto API
+ */
+#define CRYPTO_ALG_INTERNAL		0x00002000
+
+/*
  * Transform masks and values (for crt_flags).
  */
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
-- 
2.1.0

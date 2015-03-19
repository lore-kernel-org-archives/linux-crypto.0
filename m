From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 01/16] crypto: prevent helper ciphers from being used
Date: Thu, 19 Mar 2015 07:57:36 +0100
Message-ID: <109752153.14abfcUJ8X@tachyon.chronox.de>
References: <21952258.n2qYaab1Is@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21952258.n2qYaab1Is@tachyon.chronox.de>
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
to mark helper ciphers. All ciphers with that flag can be used
by wrapping ciphers via the crypto_*_spawn* API calls. In addtion
the testmgr also can directly use the ciphers via the
kernel crypto API. Any other callers cannot use ciphers marked
with this flag using the kernel crypto API. The various crypto_alloc_*
calls will return an error.

This patch modified all callers of __crypto_alloc_tfm to honor the new
flag, except the crypto_spawn_tfm function that services the
crypto_*_spawn_* API.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/ablkcipher.c    |  2 +-
 crypto/aead.c          |  2 +-
 crypto/api.c           | 21 ++++++++++++++++++++-
 crypto/internal.h      |  2 ++
 include/linux/crypto.h |  6 ++++++
 5 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index db201bca..2cd83ad 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -688,7 +688,7 @@ struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
 			goto err;
 		}
 
-		tfm = __crypto_alloc_tfm(alg, type, mask);
+		tfm = __crypto_alloc_tfm_safe(alg, type, mask);
 		if (!IS_ERR(tfm))
 			return __crypto_ablkcipher_cast(tfm);
 
diff --git a/crypto/aead.c b/crypto/aead.c
index 2222710..9ae3aa9 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -542,7 +542,7 @@ struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
 			goto err;
 		}
 
-		tfm = __crypto_alloc_tfm(alg, type, mask);
+		tfm = __crypto_alloc_tfm_safe(alg, type, mask);
 		if (!IS_ERR(tfm))
 			return __crypto_aead_cast(tfm);
 
diff --git a/crypto/api.c b/crypto/api.c
index 2a81e98..3fdc47b 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -389,6 +389,25 @@ out:
 }
 EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
 
+struct crypto_tfm *__crypto_alloc_tfm_safe(struct crypto_alg *alg, u32 type,
+					   u32 mask)
+{
+	/*
+	 * Prevent all ciphers from being loaded which have are marked
+	 * as CRYPTO_ALG_INTERNAL. Those cipher implementations are helper
+	 * ciphers and are not intended for general consumption.
+	 *
+	 * The only exceptions are allocation of ciphers for executing
+	 * the testing via the test manager.
+	 */
+
+	if ((alg->cra_flags & CRYPTO_ALG_INTERNAL) &&
+	    !(mask & CRYPTO_ALG_TESTED))
+		return ERR_PTR(-ENOENT);
+
+	return __crypto_alloc_tfm(alg, type, mask);
+}
+EXPORT_SYMBOL_GPL(__crypto_alloc_tfm_safe);
 /*
  *	crypto_alloc_base - Locate algorithm and allocate transform
  *	@alg_name: Name of algorithm
@@ -425,7 +444,7 @@ struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
 			goto err;
 		}
 
-		tfm = __crypto_alloc_tfm(alg, type, mask);
+		tfm = __crypto_alloc_tfm_safe(alg, type, mask);
 		if (!IS_ERR(tfm))
 			return tfm;
 
diff --git a/crypto/internal.h b/crypto/internal.h
index bd39bfc..8526a37 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -91,6 +91,8 @@ void crypto_remove_final(struct list_head *list);
 void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
+struct crypto_tfm *__crypto_alloc_tfm_safe(struct crypto_alg *alg, u32 type,
+					   u32 mask);
 void *crypto_create_tfm(struct crypto_alg *alg,
 			const struct crypto_type *frontend);
 struct crypto_alg *crypto_find_alg(const char *alg_name,
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

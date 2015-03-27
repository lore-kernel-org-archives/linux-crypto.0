From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 01/20] crypto: prevent helper ciphers from being used
Date: Fri, 27 Mar 2015 23:49:58 +0100
Message-ID: <2386905.FFHjDQ6mFB@tachyon.chronox.de>
References: <1746748.uPZFXamDiM@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46776 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076AbbC0XFm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Mar 2015 19:05:42 -0400
In-Reply-To: <1746748.uPZFXamDiM@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
 crypto/api.c           | 6 ++++++
 include/linux/crypto.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/crypto/api.c b/crypto/api.c
index 2a81e98..e45d37a 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -257,6 +257,12 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
 		mask |= CRYPTO_ALG_TESTED;
 	}
 
+	/*
+	 * If the internal flag is set for a cipher, require a caller to
+	 * to invoke the cipher with the internal flag to use that cipher.
+	 */
+	mask |= CRYPTO_ALG_INTERNAL;
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

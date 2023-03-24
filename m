Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4744CC6FD1C
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Mar 2023 09:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjCXJ7r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Mar 2023 05:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjCXJ7q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2023 05:59:46 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB14817CE9
        for <linux-crypto@vger.kernel.org>; Fri, 24 Mar 2023 02:59:43 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pfeCw-008F4a-UG; Fri, 24 Mar 2023 17:59:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Mar 2023 17:59:38 +0800
Date:   Fri, 24 Mar 2023 17:59:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: lib/utils - Move utilities into new header
Message-ID: <ZB10ijozlmPmxjJr@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The utilities have historically resided in algapi.h as they were
first used internally before being exported.  Move them into a
new header file so external users don't see internal API details.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/algapi.h |   63 -----------------------------------------
 include/crypto/utils.h  |   73 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/crypto/utils.c      |    2 -
 3 files changed, 75 insertions(+), 63 deletions(-)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index e28957993b56..bbf8c43c3320 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -7,15 +7,12 @@
 #ifndef _CRYPTO_ALGAPI_H
 #define _CRYPTO_ALGAPI_H
 
+#include <crypto/utils.h>
 #include <linux/align.h>
 #include <linux/cache.h>
 #include <linux/crypto.h>
-#include <linux/kconfig.h>
-#include <linux/list.h>
 #include <linux/types.h>
 
-#include <asm/unaligned.h>
-
 /*
  * Maximum values for blocksize and alignmask, used to allocate
  * static buffers that are big enough for any combination of
@@ -172,47 +169,6 @@ static inline unsigned int crypto_queue_len(struct crypto_queue *queue)
 }
 
 void crypto_inc(u8 *a, unsigned int size);
-void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int size);
-
-static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
-{
-	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
-	    __builtin_constant_p(size) &&
-	    (size % sizeof(unsigned long)) == 0) {
-		unsigned long *d = (unsigned long *)dst;
-		unsigned long *s = (unsigned long *)src;
-		unsigned long l;
-
-		while (size > 0) {
-			l = get_unaligned(d) ^ get_unaligned(s++);
-			put_unaligned(l, d++);
-			size -= sizeof(unsigned long);
-		}
-	} else {
-		__crypto_xor(dst, dst, src, size);
-	}
-}
-
-static inline void crypto_xor_cpy(u8 *dst, const u8 *src1, const u8 *src2,
-				  unsigned int size)
-{
-	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
-	    __builtin_constant_p(size) &&
-	    (size % sizeof(unsigned long)) == 0) {
-		unsigned long *d = (unsigned long *)dst;
-		unsigned long *s1 = (unsigned long *)src1;
-		unsigned long *s2 = (unsigned long *)src2;
-		unsigned long l;
-
-		while (size > 0) {
-			l = get_unaligned(s1++) ^ get_unaligned(s2++);
-			put_unaligned(l, d++);
-			size -= sizeof(unsigned long);
-		}
-	} else {
-		__crypto_xor(dst, src1, src2, size);
-	}
-}
 
 static inline void *crypto_tfm_ctx(struct crypto_tfm *tfm)
 {
@@ -291,23 +247,6 @@ static inline u32 crypto_algt_inherited_mask(struct crypto_attr_type *algt)
 	return crypto_requires_off(algt, CRYPTO_ALG_INHERITED_FLAGS);
 }
 
-noinline unsigned long __crypto_memneq(const void *a, const void *b, size_t size);
-
-/**
- * crypto_memneq - Compare two areas of memory without leaking
- *		   timing information.
- *
- * @a: One area of memory
- * @b: Another area of memory
- * @size: The size of the area.
- *
- * Returns 0 when data is equal, 1 otherwise.
- */
-static inline int crypto_memneq(const void *a, const void *b, size_t size)
-{
-	return __crypto_memneq(a, b, size) != 0UL ? 1 : 0;
-}
-
 int crypto_register_notifier(struct notifier_block *nb);
 int crypto_unregister_notifier(struct notifier_block *nb);
 
diff --git a/include/crypto/utils.h b/include/crypto/utils.h
new file mode 100644
index 000000000000..acbb917a00c6
--- /dev/null
+++ b/include/crypto/utils.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Cryptographic utilities
+ *
+ * Copyright (c) 2023 Herbert Xu <herbert@gondor.apana.org.au>
+ */
+#ifndef _CRYPTO_UTILS_H
+#define _CRYPTO_UTILS_H
+
+#include <asm/unaligned.h>
+#include <linux/compiler_attributes.h>
+#include <linux/types.h>
+
+void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int size);
+
+static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
+{
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
+	    __builtin_constant_p(size) &&
+	    (size % sizeof(unsigned long)) == 0) {
+		unsigned long *d = (unsigned long *)dst;
+		unsigned long *s = (unsigned long *)src;
+		unsigned long l;
+
+		while (size > 0) {
+			l = get_unaligned(d) ^ get_unaligned(s++);
+			put_unaligned(l, d++);
+			size -= sizeof(unsigned long);
+		}
+	} else {
+		__crypto_xor(dst, dst, src, size);
+	}
+}
+
+static inline void crypto_xor_cpy(u8 *dst, const u8 *src1, const u8 *src2,
+				  unsigned int size)
+{
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
+	    __builtin_constant_p(size) &&
+	    (size % sizeof(unsigned long)) == 0) {
+		unsigned long *d = (unsigned long *)dst;
+		unsigned long *s1 = (unsigned long *)src1;
+		unsigned long *s2 = (unsigned long *)src2;
+		unsigned long l;
+
+		while (size > 0) {
+			l = get_unaligned(s1++) ^ get_unaligned(s2++);
+			put_unaligned(l, d++);
+			size -= sizeof(unsigned long);
+		}
+	} else {
+		__crypto_xor(dst, src1, src2, size);
+	}
+}
+
+noinline unsigned long __crypto_memneq(const void *a, const void *b, size_t size);
+
+/**
+ * crypto_memneq - Compare two areas of memory without leaking
+ *		   timing information.
+ *
+ * @a: One area of memory
+ * @b: Another area of memory
+ * @size: The size of the area.
+ *
+ * Returns 0 when data is equal, 1 otherwise.
+ */
+static inline int crypto_memneq(const void *a, const void *b, size_t size)
+{
+	return __crypto_memneq(a, b, size) != 0UL ? 1 : 0;
+}
+
+#endif	/* _CRYPTO_UTILS_H */
diff --git a/lib/crypto/utils.c b/lib/crypto/utils.c
index 53230ab1b195..c852c7151b0a 100644
--- a/lib/crypto/utils.c
+++ b/lib/crypto/utils.c
@@ -6,7 +6,7 @@
  */
 
 #include <asm/unaligned.h>
-#include <crypto/algapi.h>
+#include <crypto/utils.h>
 #include <linux/module.h>
 
 /*
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

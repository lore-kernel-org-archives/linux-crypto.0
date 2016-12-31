From: gidisrael@gmail.com
Subject: [PATCH] crypto: Replaced gcc specific attributes with macros from compiler.h
Date: Sat, 31 Dec 2016 21:26:23 +0530
Message-ID: <1483199783-31588-1-git-send-email-gidisrael@gmail.com>
Cc: Gideon Israel Dsouza <gidisrael@gmail.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        nhorman@tuxdriver.com, joe@perches.com, akpm@linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34796 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754612AbcLaP4i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Dec 2016 10:56:38 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Gideon Israel Dsouza <gidisrael@gmail.com>

Continuing from this commit: 52f5684c8e1e
("kernel: use macros from compiler.h instead of __attribute__((...))")

I submitted 4 total patches. They are part of task I've taken up to
increase compiler portability in the kernel. I've cleaned up the
subsystems under /kernel /mm /block and /security, this patch targets
/crypto.

There is <linux/compiler.h> which provides macros for various gcc specific
constructs. Eg: __weak for __attribute__((weak)). I've cleaned all
instances of gcc specific attributes with the right macros for the crypto
subsystem.

I had to make one additional change into compiler-gcc.h for the case when
one wants to use this: __attribute__((aligned) and not specify an alignment
factor. From the gcc docs, this will result in the largest alignment for
that data type on the target machine so I've named the macro
__aligned_largest. Please advise if another name is more appropriate.

Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
---
 crypto/ablkcipher.c          | 5 +++--
 crypto/acompress.c           | 3 ++-
 crypto/aead.c                | 3 ++-
 crypto/ahash.c               | 3 ++-
 crypto/akcipher.c            | 3 ++-
 crypto/blkcipher.c           | 7 ++++---
 crypto/cts.c                 | 5 +++--
 crypto/kpp.c                 | 3 ++-
 crypto/pcbc.c                | 3 ++-
 crypto/rng.c                 | 3 ++-
 crypto/scompress.c           | 3 ++-
 crypto/shash.c               | 9 +++++----
 crypto/skcipher.c            | 3 ++-
 include/linux/compiler-gcc.h | 1 +
 14 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index d676fc5..d880a48 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/cryptouser.h>
+#include <linux/compiler.h>
 #include <net/netlink.h>
 
 #include <crypto/scatterwalk.h>
@@ -394,7 +395,7 @@ static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	struct ablkcipher_alg *ablkcipher = &alg->cra_ablkcipher;
@@ -468,7 +469,7 @@ static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static void crypto_givcipher_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 static void crypto_givcipher_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	struct ablkcipher_alg *ablkcipher = &alg->cra_ablkcipher;
diff --git a/crypto/acompress.c b/crypto/acompress.c
index 887783d..47d1162 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -20,6 +20,7 @@
 #include <linux/crypto.h>
 #include <crypto/algapi.h>
 #include <linux/cryptouser.h>
+#include <linux/compiler.h>
 #include <net/netlink.h>
 #include <crypto/internal/acompress.h>
 #include <crypto/internal/scompress.h>
@@ -50,7 +51,7 @@ static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static void crypto_acomp_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 
 static void crypto_acomp_show(struct seq_file *m, struct crypto_alg *alg)
 {
diff --git a/crypto/aead.c b/crypto/aead.c
index 3f5c5ff..f794b30 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/cryptouser.h>
+#include <linux/compiler.h>
 #include <net/netlink.h>
 
 #include "internal.h"
@@ -132,7 +133,7 @@ static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	struct aead_alg *aead = container_of(alg, struct aead_alg, base);
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 2ce8bcb..e58c497 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/cryptouser.h>
+#include <linux/compiler.h>
 #include <net/netlink.h>
 
 #include "internal.h"
@@ -493,7 +494,7 @@ static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	seq_printf(m, "type         : ahash\n");
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index def301e..cfbdb06 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/crypto.h>
+#include <linux/compiler.h>
 #include <crypto/algapi.h>
 #include <linux/cryptouser.h>
 #include <net/netlink.h>
@@ -47,7 +48,7 @@ static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static void crypto_akcipher_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 
 static void crypto_akcipher_show(struct seq_file *m, struct crypto_alg *alg)
 {
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index a832426..6c43a0a 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -1,6 +1,6 @@
 /*
  * Block chaining cipher operations.
- * 
+ *
  * Generic encrypt/decrypt wrapper for ciphers, handles operations across
  * multiple page boundaries by using temporary blocks.  In user context,
  * the kernel is given a chance to schedule us once per page.
@@ -9,7 +9,7 @@
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  */
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/cryptouser.h>
+#include <linux/compiler.h>
 #include <net/netlink.h>
 
 #include "internal.h"
@@ -534,7 +535,7 @@ static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	seq_printf(m, "type         : blkcipher\n");
diff --git a/crypto/cts.c b/crypto/cts.c
index 00254d7..a1335d6 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -49,6 +49,7 @@
 #include <linux/scatterlist.h>
 #include <crypto/scatterwalk.h>
 #include <linux/slab.h>
+#include <linux/compiler.h>
 
 struct crypto_cts_ctx {
 	struct crypto_skcipher *child;
@@ -103,7 +104,7 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 	int bsize = crypto_skcipher_blocksize(tfm);
-	u8 d[bsize * 2] __attribute__ ((aligned(__alignof__(u32))));
+	u8 d[bsize * 2] __aligned(__alignof__(u32));
 	struct scatterlist *sg;
 	unsigned int offset;
 	int lastn;
@@ -183,7 +184,7 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_request *subreq = &rctx->subreq;
 	int bsize = crypto_skcipher_blocksize(tfm);
-	u8 d[bsize * 2] __attribute__ ((aligned(__alignof__(u32))));
+	u8 d[bsize * 2] __aligned(__alignof__(u32));
 	struct scatterlist *sg;
 	unsigned int offset;
 	u8 *space;
diff --git a/crypto/kpp.c b/crypto/kpp.c
index d36ce05..a90edc2 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -19,6 +19,7 @@
 #include <linux/crypto.h>
 #include <crypto/algapi.h>
 #include <linux/cryptouser.h>
+#include <linux/compiler.h>
 #include <net/netlink.h>
 #include <crypto/kpp.h>
 #include <crypto/internal/kpp.h>
@@ -47,7 +48,7 @@ static int crypto_kpp_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static void crypto_kpp_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 
 static void crypto_kpp_show(struct seq_file *m, struct crypto_alg *alg)
 {
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index e4538e0..11d2486 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/compiler.h>
 
 struct crypto_pcbc_ctx {
 	struct crypto_cipher *child;
@@ -146,7 +147,7 @@ static int crypto_pcbc_decrypt_inplace(struct skcipher_request *req,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
-	u8 tmpbuf[bsize] __attribute__ ((aligned(__alignof__(u32))));
+	u8 tmpbuf[bsize] __aligned(__alignof__(u32));
 
 	do {
 		memcpy(tmpbuf, src, bsize);
diff --git a/crypto/rng.c b/crypto/rng.c
index b81cffb..f46dac5 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/cryptouser.h>
+#include <linux/compiler.h>
 #include <net/netlink.h>
 
 #include "internal.h"
@@ -95,7 +96,7 @@ static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	seq_printf(m, "type         : rng\n");
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 35e396d..6b048b3 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/crypto.h>
+#include <linux/compiler.h>
 #include <linux/vmalloc.h>
 #include <crypto/algapi.h>
 #include <linux/cryptouser.h>
@@ -57,7 +58,7 @@ static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 
 static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
 {
diff --git a/crypto/shash.c b/crypto/shash.c
index a051541..5e31c8d 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 #include <linux/cryptouser.h>
 #include <net/netlink.h>
+#include <linux/compiler.h>
 
 #include "internal.h"
 
@@ -67,7 +68,7 @@ EXPORT_SYMBOL_GPL(crypto_shash_setkey);
 static inline unsigned int shash_align_buffer_size(unsigned len,
 						   unsigned long mask)
 {
-	typedef u8 __attribute__ ((aligned)) u8_aligned;
+	typedef u8 __aligned_largest u8_aligned;
 	return len + (mask & ~(__alignof__(u8_aligned) - 1));
 }
 
@@ -80,7 +81,7 @@ static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
 	unsigned int unaligned_len = alignmask + 1 -
 				     ((unsigned long)data & alignmask);
 	u8 ubuf[shash_align_buffer_size(unaligned_len, alignmask)]
-		__attribute__ ((aligned));
+		__aligned_largest;
 	u8 *buf = PTR_ALIGN(&ubuf[0], alignmask + 1);
 	int err;
 
@@ -116,7 +117,7 @@ static int shash_final_unaligned(struct shash_desc *desc, u8 *out)
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned int ds = crypto_shash_digestsize(tfm);
 	u8 ubuf[shash_align_buffer_size(ds, alignmask)]
-		__attribute__ ((aligned));
+		__aligned_largest;
 	u8 *buf = PTR_ALIGN(&ubuf[0], alignmask + 1);
 	int err;
 
@@ -403,7 +404,7 @@ static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	struct shash_alg *salg = __crypto_shash_alg(alg);
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 0e1e6c3..1a0bd92 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -19,6 +19,7 @@
 #include <crypto/scatterwalk.h>
 #include <linux/bug.h>
 #include <linux/cryptouser.h>
+#include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
@@ -807,7 +808,7 @@ static void crypto_skcipher_free_instance(struct crypto_instance *inst)
 }
 
 static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
+	__maybe_unused;
 static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	struct skcipher_alg *skcipher = container_of(alg, struct skcipher_alg,
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 0444b13..fddd1a5 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -116,6 +116,7 @@
  */
 #define __pure			__attribute__((pure))
 #define __aligned(x)		__attribute__((aligned(x)))
+#define __aligned_largest	__attribute__((aligned))
 #define __printf(a, b)		__attribute__((format(printf, a, b)))
 #define __scanf(a, b)		__attribute__((format(scanf, a, b)))
 #define __attribute_const__	__attribute__((__const__))
-- 
2.7.4

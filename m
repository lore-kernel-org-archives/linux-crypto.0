From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [PATCH v2] crypto: gf128mul - define gf128mul_x_* in gf128mul.h
Date: Fri, 31 Mar 2017 00:04:42 +0200
Message-ID: <20170330220442.11012-1-omosnacek@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36824 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdC3WHw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Mar 2017 18:07:52 -0400
Received: by mail-wr0-f193.google.com with SMTP id k6so14490050wre.3
        for <linux-crypto@vger.kernel.org>; Thu, 30 Mar 2017 15:07:51 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The gf128mul_x_ble function is currently defined in gf128mul.c, because
it depends on the gf128mul_table_be multiplication table.

However, since the function is very small and only uses two values from
the table, it is better for it to be defined as inline function in
gf128mul.h. That way, the function can be inlined by the compiler for
better performance.

For consistency, the other gf128mul_x_* functions are also moved to the
header file.

After this change, the speed of the generic 'xts(aes)' implementation
increased from ~225 MiB/s to ~235 MiB/s (measured using 'cryptsetup
benchmark -c aes-xts-plain64' on an Intel system with CRYPTO_AES_X86_64
and CRYPTO_AES_NI_INTEL disabled).

Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
Cc: Eric Biggers <ebiggers@google.com>
---
 crypto/gf128mul.c         | 33 +------------------------------
 include/crypto/gf128mul.h | 49 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 48 insertions(+), 34 deletions(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index 04facc0..dc01212 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -130,43 +130,12 @@ static const u16 gf128mul_table_le[256] = gf128mul_dat(xda_le);
 static const u16 gf128mul_table_be[256] = gf128mul_dat(xda_be);
 
 /*
- * The following functions multiply a field element by x or by x^8 in
+ * The following functions multiply a field element by x^8 in
  * the polynomial field representation.  They use 64-bit word operations
  * to gain speed but compensate for machine endianness and hence work
  * correctly on both styles of machine.
  */
 
-static void gf128mul_x_lle(be128 *r, const be128 *x)
-{
-	u64 a = be64_to_cpu(x->a);
-	u64 b = be64_to_cpu(x->b);
-	u64 _tt = gf128mul_table_le[(b << 7) & 0xff];
-
-	r->b = cpu_to_be64((b >> 1) | (a << 63));
-	r->a = cpu_to_be64((a >> 1) ^ (_tt << 48));
-}
-
-static void gf128mul_x_bbe(be128 *r, const be128 *x)
-{
-	u64 a = be64_to_cpu(x->a);
-	u64 b = be64_to_cpu(x->b);
-	u64 _tt = gf128mul_table_be[a >> 63];
-
-	r->a = cpu_to_be64((a << 1) | (b >> 63));
-	r->b = cpu_to_be64((b << 1) ^ _tt);
-}
-
-void gf128mul_x_ble(be128 *r, const be128 *x)
-{
-	u64 a = le64_to_cpu(x->a);
-	u64 b = le64_to_cpu(x->b);
-	u64 _tt = gf128mul_table_be[b >> 63];
-
-	r->a = cpu_to_le64((a << 1) ^ _tt);
-	r->b = cpu_to_le64((b << 1) | (a >> 63));
-}
-EXPORT_SYMBOL(gf128mul_x_ble);
-
 static void gf128mul_x8_lle(be128 *x)
 {
 	u64 a = be64_to_cpu(x->a);
diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index 0bc9b5f..2a24553 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -49,6 +49,7 @@
 #ifndef _CRYPTO_GF128MUL_H
 #define _CRYPTO_GF128MUL_H
 
+#include <asm/byteorder.h>
 #include <crypto/b128ops.h>
 #include <linux/slab.h>
 
@@ -163,8 +164,52 @@ void gf128mul_lle(be128 *a, const be128 *b);
 
 void gf128mul_bbe(be128 *a, const be128 *b);
 
-/* multiply by x in ble format, needed by XTS */
-void gf128mul_x_ble(be128 *a, const be128 *b);
+/*
+ * The following functions multiply a field element by x in
+ * the polynomial field representation.  They use 64-bit word operations
+ * to gain speed but compensate for machine endianness and hence work
+ * correctly on both styles of machine.
+ *
+ * They are defined here for performance.
+ */
+
+static inline void gf128mul_x_lle(be128 *r, const be128 *x)
+{
+	u64 a = be64_to_cpu(x->a);
+	u64 b = be64_to_cpu(x->b);
+
+	/* equivalent to gf128mul_table_le[(b << 7) & 0xff] >> 8
+	 * (see crypto/gf128mul.c): */
+	u64 _tt = (b & (u64)1) ? 0xe1 : 0x00;
+
+	r->b = cpu_to_be64((b >> 1) | (a << 63));
+	r->a = cpu_to_be64((a >> 1) ^ (_tt << 56));
+}
+
+static inline void gf128mul_x_bbe(be128 *r, const be128 *x)
+{
+	u64 a = be64_to_cpu(x->a);
+	u64 b = be64_to_cpu(x->b);
+
+	/* equivalent to gf128mul_table_be[a >> 63] (see crypto/gf128mul.c): */
+	u64 _tt = (a & ((u64)1 << 63)) ? 0x87 : 0x00;
+
+	r->a = cpu_to_be64((a << 1) | (b >> 63));
+	r->b = cpu_to_be64((b << 1) ^ _tt);
+}
+
+/* needed by XTS */
+static inline void gf128mul_x_ble(be128 *r, const be128 *x)
+{
+	u64 a = le64_to_cpu(x->a);
+	u64 b = le64_to_cpu(x->b);
+
+	/* equivalent to gf128mul_table_be[b >> 63] (see crypto/gf128mul.c): */
+	u64 _tt = (b & ((u64)1 << 63)) ? 0x87 : 0x00;
+
+	r->a = cpu_to_le64((a << 1) ^ _tt);
+	r->b = cpu_to_le64((b << 1) | (a >> 63));
+}
 
 /* 4k table optimization */
 
-- 
2.9.3

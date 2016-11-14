From: Alex Cope <alexcope@google.com>
Subject: [RFC][PATCH 3/7] crypto: gf128mul - Add ble multiplication functions
Date: Mon, 14 Nov 2016 13:01:14 -0800
Message-ID: <1479157277-10251-4-git-send-email-alexcope@google.com>
References: <1479157277-10251-1-git-send-email-alexcope@google.com>
Cc: mhalcrow@google.com, edknapp@google.com,
        Alex Cope <alexcope@google.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36501 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753274AbcKNVBs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Nov 2016 16:01:48 -0500
Received: by mail-pf0-f176.google.com with SMTP id 189so31439180pfz.3
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2016 13:01:47 -0800 (PST)
In-Reply-To: <1479157277-10251-1-git-send-email-alexcope@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adding ble multiplication to GF128mul, and fixing up comments.

The ble multiplication functions multiply GF(2^128) elements in the
ble format. This format is preferable because the bits within each
byte map to polynomial coefficients in the natural order (lowest order
bit = coefficient of lowest degree polynomial term), and the bytes are
stored in little endian order which matches the endianness of most
modern CPUs.

These new functions will be used by the HEH algorithm.

Signed-off-by: Alex Cope <alexcope@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gf128mul.c         | 99 ++++++++++++++++++++++++++++++++++++++++++++---
 include/crypto/gf128mul.h | 45 +++++++++++----------
 2 files changed, 117 insertions(+), 27 deletions(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index 8b65b1e..f3d9f6d 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -44,7 +44,7 @@
  ---------------------------------------------------------------------------
  Issue 31/01/2006
 
- This file provides fast multiplication in GF(128) as required by several
+ This file provides fast multiplication in GF(2^128) as required by several
  cryptographic authentication modes
 */
 
@@ -130,9 +130,10 @@
 static const u16 gf128mul_table_le[256] = gf128mul_dat(xda_le);
 static const u16 gf128mul_table_be[256] = gf128mul_dat(xda_be);
 
-/* These functions multiply a field element by x, by x^4 and by x^8
- * in the polynomial field representation. It uses 32-bit word operations
- * to gain speed but compensates for machine endianess and hence works
+/*
+ * The following functions multiply a field element by x or by x^8 in
+ * the polynomial field representation.  They use 64-bit word operations
+ * to gain speed but compensate for machine endianness and hence work
  * correctly on both styles of machine.
  */
 
@@ -187,6 +188,16 @@ static void gf128mul_x8_bbe(be128 *x)
 	x->b = cpu_to_be64((b << 8) ^ _tt);
 }
 
+static void gf128mul_x8_ble(be128 *x)
+{
+	u64 a = le64_to_cpu(x->b);
+	u64 b = le64_to_cpu(x->a);
+	u64 _tt = gf128mul_table_be[a >> 56];
+
+	x->b = cpu_to_le64((a << 8) | (b >> 56));
+	x->a = cpu_to_le64((b << 8) ^ _tt);
+}
+
 void gf128mul_lle(be128 *r, const be128 *b)
 {
 	be128 p[8];
@@ -263,9 +274,48 @@ void gf128mul_bbe(be128 *r, const be128 *b)
 }
 EXPORT_SYMBOL(gf128mul_bbe);
 
+void gf128mul_ble(be128 *r, const be128 *b)
+{
+	be128 p[8];
+	int i;
+
+	p[0] = *r;
+	for (i = 0; i < 7; ++i)
+		gf128mul_x_ble((be128 *)&p[i + 1], (be128 *)&p[i]);
+
+	memset(r, 0, sizeof(*r));
+	for (i = 0;;) {
+		u8 ch = ((u8 *)b)[15 - i];
+
+		if (ch & 0x80)
+			be128_xor(r, r, &p[7]);
+		if (ch & 0x40)
+			be128_xor(r, r, &p[6]);
+		if (ch & 0x20)
+			be128_xor(r, r, &p[5]);
+		if (ch & 0x10)
+			be128_xor(r, r, &p[4]);
+		if (ch & 0x08)
+			be128_xor(r, r, &p[3]);
+		if (ch & 0x04)
+			be128_xor(r, r, &p[2]);
+		if (ch & 0x02)
+			be128_xor(r, r, &p[1]);
+		if (ch & 0x01)
+			be128_xor(r, r, &p[0]);
+
+		if (++i >= 16)
+			break;
+
+		gf128mul_x8_ble(r);
+	}
+}
+EXPORT_SYMBOL(gf128mul_ble);
+
+
 /*      This version uses 64k bytes of table space.
     A 16 byte buffer has to be multiplied by a 16 byte key
-    value in GF(128).  If we consider a GF(128) value in
+    value in GF(2^128).  If we consider a GF(2^128) value in
     the buffer's lowest byte, we can construct a table of
     the 256 16 byte values that result from the 256 values
     of this byte.  This requires 4096 bytes. But we also
@@ -399,7 +449,7 @@ EXPORT_SYMBOL(gf128mul_64k_bbe);
 
 /*      This version uses 4k bytes of table space.
     A 16 byte buffer has to be multiplied by a 16 byte key
-    value in GF(128).  If we consider a GF(128) value in a
+    value in GF(2^128).  If we consider a GF(2^128) value in a
     single byte, we can construct a table of the 256 16 byte
     values that result from the 256 values of this byte.
     This requires 4096 bytes. If we take the highest byte in
@@ -457,6 +507,28 @@ struct gf128mul_4k *gf128mul_init_4k_bbe(const be128 *g)
 }
 EXPORT_SYMBOL(gf128mul_init_4k_bbe);
 
+struct gf128mul_4k *gf128mul_init_4k_ble(const be128 *g)
+{
+	struct gf128mul_4k *t;
+	int j, k;
+
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
+	if (!t)
+		goto out;
+
+	t->t[1] = *g;
+	for (j = 1; j <= 64; j <<= 1)
+		gf128mul_x_ble(&t->t[j + j], &t->t[j]);
+
+	for (j = 2; j < 256; j += j)
+		for (k = 1; k < j; ++k)
+			be128_xor(&t->t[j + k], &t->t[j], &t->t[k]);
+
+out:
+	return t;
+}
+EXPORT_SYMBOL(gf128mul_init_4k_ble);
+
 void gf128mul_4k_lle(be128 *a, struct gf128mul_4k *t)
 {
 	u8 *ap = (u8 *)a;
@@ -487,5 +559,20 @@ void gf128mul_4k_bbe(be128 *a, struct gf128mul_4k *t)
 }
 EXPORT_SYMBOL(gf128mul_4k_bbe);
 
+void gf128mul_4k_ble(be128 *a, struct gf128mul_4k *t)
+{
+	u8 *ap = (u8 *)a;
+	be128 r[1];
+	int i = 15;
+
+	*r = t->t[ap[15]];
+	while (i--) {
+		gf128mul_x8_ble(r);
+		be128_xor(r, r, &t->t[ap[i]]);
+	}
+	*a = *r;
+}
+EXPORT_SYMBOL(gf128mul_4k_ble);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Functions for multiplying elements of GF(2^128)");
diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index 7217fe6..230760a 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -43,7 +43,7 @@
  ---------------------------------------------------------------------------
  Issue Date: 31/01/2006
 
- An implementation of field multiplication in Galois Field GF(128)
+ An implementation of field multiplication in Galois Field GF(2^128)
 */
 
 #ifndef _CRYPTO_GF128MUL_H
@@ -65,7 +65,7 @@
  * are left and the lsb's are right. char b[16] is an array and b[0] is
  * the first octet.
  *
- * 80000000 00000000 00000000 00000000 .... 00000000 00000000 00000000
+ * 10000000 00000000 00000000 00000000 .... 00000000 00000000 00000000
  *   b[0]     b[1]     b[2]     b[3]          b[13]    b[14]    b[15]
  *
  * Every bit is a coefficient of some power of X. We can store the bits
@@ -99,21 +99,21 @@
  *
  * bbe on a little endian machine u32 x[4]:
  *
- *  MS            x[0]           LS  MS            x[1]		  LS
+ *  MS            x[0]           LS  MS            x[1]           LS
  *  ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
  *  103..96 111.104 119.112 127.120  71...64 79...72 87...80 95...88
  *
- *  MS            x[2]           LS  MS            x[3]		  LS
+ *  MS            x[2]           LS  MS            x[3]           LS
  *  ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
  *  39...32 47...40 55...48 63...56  07...00 15...08 23...16 31...24
  *
  * ble on a little endian machine
  *
- *  MS            x[0]           LS  MS            x[1]		  LS
+ *  MS            x[0]           LS  MS            x[1]           LS
  *  ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
  *  31...24 23...16 15...08 07...00  63...56 55...48 47...40 39...32
  *
- *  MS            x[2]           LS  MS            x[3]		  LS
+ *  MS            x[2]           LS  MS            x[3]           LS
  *  ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
  *  95...88 87...80 79...72 71...64  127.120 199.112 111.104 103..96
  *
@@ -127,7 +127,7 @@
  * machines this will automatically aligned to wordsize and on a 64-bit
  * machine also.
  */
-/*	Multiply a GF128 field element by x. Field elements are held in arrays
+/*  Multiply a GF128 field element by x. Field elements are held in arrays
     of bytes in which field bits 8n..8n + 7 are held in byte[n], with lower
     indexed bits placed in the more numerically significant bit positions
     within bytes.
@@ -135,45 +135,47 @@
     On little endian machines the bit indexes translate into the bit
     positions within four 32-bit words in the following way
 
-    MS            x[0]           LS  MS            x[1]		  LS
+    MS            x[0]           LS  MS            x[1]           LS
     ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
     24...31 16...23 08...15 00...07  56...63 48...55 40...47 32...39
 
-    MS            x[2]           LS  MS            x[3]		  LS
+    MS            x[2]           LS  MS            x[3]           LS
     ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
     88...95 80...87 72...79 64...71  120.127 112.119 104.111 96..103
 
     On big endian machines the bit indexes translate into the bit
     positions within four 32-bit words in the following way
 
-    MS            x[0]           LS  MS            x[1]		  LS
+    MS            x[0]           LS  MS            x[1]           LS
     ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
     00...07 08...15 16...23 24...31  32...39 40...47 48...55 56...63
 
-    MS            x[2]           LS  MS            x[3]		  LS
+    MS            x[2]           LS  MS            x[3]           LS
     ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
     64...71 72...79 80...87 88...95  96..103 104.111 112.119 120.127
 */
 
-/*	A slow generic version of gf_mul, implemented for lle and bbe
- * 	It multiplies a and b and puts the result in a */
+/*  A slow generic version of gf_mul, implemented for lle, bbe, and ble.
+ *  It multiplies a and b and puts the result in a
+ */
 void gf128mul_lle(be128 *a, const be128 *b);
-
 void gf128mul_bbe(be128 *a, const be128 *b);
+void gf128mul_ble(be128 *a, const be128 *b);
 
-/* multiply by x in ble format, needed by XTS */
+/* multiply by x in ble format, needed by XTS and HEH */
 void gf128mul_x_ble(be128 *a, const be128 *b);
 
 /* 4k table optimization */
-
 struct gf128mul_4k {
 	be128 t[256];
 };
 
 struct gf128mul_4k *gf128mul_init_4k_lle(const be128 *g);
 struct gf128mul_4k *gf128mul_init_4k_bbe(const be128 *g);
+struct gf128mul_4k *gf128mul_init_4k_ble(const be128 *g);
 void gf128mul_4k_lle(be128 *a, struct gf128mul_4k *t);
 void gf128mul_4k_bbe(be128 *a, struct gf128mul_4k *t);
+void gf128mul_4k_ble(be128 *a, struct gf128mul_4k *t);
 
 static inline void gf128mul_free_4k(struct gf128mul_4k *t)
 {
@@ -181,16 +183,17 @@ static inline void gf128mul_free_4k(struct gf128mul_4k *t)
 }
 
 
-/* 64k table optimization, implemented for lle and bbe */
+/* 64k table optimization, implemented for lle, ble, and bbe */
 
 struct gf128mul_64k {
 	struct gf128mul_4k *t[16];
 };
 
-/* first initialize with the constant factor with which you
- * want to multiply and then call gf128_64k_lle with the other
- * factor in the first argument, the table in the second and a
- * scratch register in the third. Afterwards *a = *r. */
+/* First initialize with the constant factor with which you
+ * want to multiply and then call gf128mul_64k_bbe with the other
+ * factor in the first argument, and the table in the second.
+ * Afterwards, the result is stored in *a.
+ */
 struct gf128mul_64k *gf128mul_init_64k_lle(const be128 *g);
 struct gf128mul_64k *gf128mul_init_64k_bbe(const be128 *g);
 void gf128mul_free_64k(struct gf128mul_64k *t);
-- 
2.8.0.rc3.226.g39d4020

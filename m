From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 3/4] crypto: gf128mul - rename the byte overflow tables
Date: Tue, 14 Feb 2017 13:43:29 -0800
Message-ID: <20170214214330.99845-4-ebiggers@google.com>
References: <20170214214330.99845-1-ebiggers@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Alex Cope <alexcope@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:36257 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753311AbdBNVqE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 16:46:04 -0500
Received: by mail-it0-f41.google.com with SMTP id c7so52110279itd.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2017 13:46:04 -0800 (PST)
In-Reply-To: <20170214214330.99845-1-ebiggers@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Though the GF(2^128) byte overflow tables were named the "lle" and "bbe"
tables, they are not actually tied to these element formats
specifically, but rather to particular a "bit endianness".  For example,
the bbe table is actually used for both bbe and ble multiplication.
Therefore, rename the tables to "le" and "be" and update the comment to
explain this.

Cc: Alex Cope <alexcope@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gf128mul.c | 49 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index c050cf6f5aa9..1fde1c79ffa5 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -88,31 +88,46 @@
 	q(0xf8), q(0xf9), q(0xfa), q(0xfb), q(0xfc), q(0xfd), q(0xfe), q(0xff) \
 }
 
-/*	Given the value i in 0..255 as the byte overflow when a field element
-    in GHASH is multiplied by x^8, this function will return the values that
-    are generated in the lo 16-bit word of the field value by applying the
-    modular polynomial. The values lo_byte and hi_byte are returned via the
-    macro xp_fun(lo_byte, hi_byte) so that the values can be assembled into
-    memory as required by a suitable definition of this macro operating on
-    the table above
-*/
+/*
+ * Given a value i in 0..255 as the byte overflow when a field element
+ * in GF(2^128) is multiplied by x^8, the following macro returns the
+ * 16-bit value that must be XOR-ed into the low-degree end of the
+ * product to reduce it modulo the polynomial x^128 + x^7 + x^2 + x + 1.
+ *
+ * There are two versions of the macro, and hence two tables: one for
+ * the "be" convention where the highest-order bit is the coefficient of
+ * the highest-degree polynomial term, and one for the "le" convention
+ * where the highest-order bit is the coefficient of the lowest-degree
+ * polynomial term.  In both cases the values are stored in CPU byte
+ * endianness such that the coefficients are ordered consistently across
+ * bytes, i.e. in the "be" table bits 15..0 of the stored value
+ * correspond to the coefficients of x^15..x^0, and in the "le" table
+ * bits 15..0 correspond to the coefficients of x^0..x^15.
+ *
+ * Therefore, provided that the appropriate byte endianness conversions
+ * are done by the multiplication functions (and these must be in place
+ * anyway to support both little endian and big endian CPUs), the "be"
+ * table can be used for multiplications of both "bbe" and "ble"
+ * elements, and the "le" table can be used for multiplications of both
+ * "lle" and "lbe" elements.
+ */
 
-#define xda_bbe(i) ( \
+#define xda_be(i) ( \
 	(i & 0x80 ? 0x4380 : 0) ^ (i & 0x40 ? 0x21c0 : 0) ^ \
 	(i & 0x20 ? 0x10e0 : 0) ^ (i & 0x10 ? 0x0870 : 0) ^ \
 	(i & 0x08 ? 0x0438 : 0) ^ (i & 0x04 ? 0x021c : 0) ^ \
 	(i & 0x02 ? 0x010e : 0) ^ (i & 0x01 ? 0x0087 : 0) \
 )
 
-#define xda_lle(i) ( \
+#define xda_le(i) ( \
 	(i & 0x80 ? 0xe100 : 0) ^ (i & 0x40 ? 0x7080 : 0) ^ \
 	(i & 0x20 ? 0x3840 : 0) ^ (i & 0x10 ? 0x1c20 : 0) ^ \
 	(i & 0x08 ? 0x0e10 : 0) ^ (i & 0x04 ? 0x0708 : 0) ^ \
 	(i & 0x02 ? 0x0384 : 0) ^ (i & 0x01 ? 0x01c2 : 0) \
 )
 
-static const u16 gf128mul_table_lle[256] = gf128mul_dat(xda_lle);
-static const u16 gf128mul_table_bbe[256] = gf128mul_dat(xda_bbe);
+static const u16 gf128mul_table_le[256] = gf128mul_dat(xda_le);
+static const u16 gf128mul_table_be[256] = gf128mul_dat(xda_be);
 
 /*
  * The following functions multiply a field element by x or by x^8 in
@@ -125,7 +140,7 @@ static void gf128mul_x_lle(be128 *r, const be128 *x)
 {
 	u64 a = be64_to_cpu(x->a);
 	u64 b = be64_to_cpu(x->b);
-	u64 _tt = gf128mul_table_lle[(b << 7) & 0xff];
+	u64 _tt = gf128mul_table_le[(b << 7) & 0xff];
 
 	r->b = cpu_to_be64((b >> 1) | (a << 63));
 	r->a = cpu_to_be64((a >> 1) ^ (_tt << 48));
@@ -135,7 +150,7 @@ static void gf128mul_x_bbe(be128 *r, const be128 *x)
 {
 	u64 a = be64_to_cpu(x->a);
 	u64 b = be64_to_cpu(x->b);
-	u64 _tt = gf128mul_table_bbe[a >> 63];
+	u64 _tt = gf128mul_table_be[a >> 63];
 
 	r->a = cpu_to_be64((a << 1) | (b >> 63));
 	r->b = cpu_to_be64((b << 1) ^ _tt);
@@ -145,7 +160,7 @@ void gf128mul_x_ble(be128 *r, const be128 *x)
 {
 	u64 a = le64_to_cpu(x->a);
 	u64 b = le64_to_cpu(x->b);
-	u64 _tt = gf128mul_table_bbe[b >> 63];
+	u64 _tt = gf128mul_table_be[b >> 63];
 
 	r->a = cpu_to_le64((a << 1) ^ _tt);
 	r->b = cpu_to_le64((b << 1) | (a >> 63));
@@ -156,7 +171,7 @@ static void gf128mul_x8_lle(be128 *x)
 {
 	u64 a = be64_to_cpu(x->a);
 	u64 b = be64_to_cpu(x->b);
-	u64 _tt = gf128mul_table_lle[b & 0xff];
+	u64 _tt = gf128mul_table_le[b & 0xff];
 
 	x->b = cpu_to_be64((b >> 8) | (a << 56));
 	x->a = cpu_to_be64((a >> 8) ^ (_tt << 48));
@@ -166,7 +181,7 @@ static void gf128mul_x8_bbe(be128 *x)
 {
 	u64 a = be64_to_cpu(x->a);
 	u64 b = be64_to_cpu(x->b);
-	u64 _tt = gf128mul_table_bbe[a >> 56];
+	u64 _tt = gf128mul_table_be[a >> 56];
 
 	x->a = cpu_to_be64((a << 8) | (b >> 56));
 	x->b = cpu_to_be64((b << 8) ^ _tt);
-- 
2.11.0.483.g087da7b7c-goog

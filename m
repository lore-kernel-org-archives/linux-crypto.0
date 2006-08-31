From: Rik Snel <rsnel@cube.dyndns.org>
Subject: [PATCH 4/6] crypto: table driven multiplications in GF(2^128), needed by LRW (and in the future ABL)
Date: Thu, 31 Aug 2006 14:39:34 +0200
Message-ID: <11570279793927-git-send-email-rsnel@cube.dyndns.org>
References: <11570279761772-git-send-email-rsnel@cube.dyndns.org>
Reply-To: Rik Snel <rsnel@cube.dyndns.org>
Cc: linux-crypto@vger.kernel.org, Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:41232 "EHLO
	smtp-vbr4.xs4all.nl") by vger.kernel.org with ESMTP id S932163AbWHaMkM
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Aug 2006 08:40:12 -0400
To: herbert@gondor.apana.org.au
In-Reply-To: <11570279761772-git-send-email-rsnel@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

WARNING: untested on bigendian, please test.

A lot of cypher modes need multiplications in GF(2^128). LRW, ABL, GCM...
I use functions from this library in my LRW implementation and I will
also use them in my ABL (Arbitrary Block Length, an unencumbered (correct
me if I am wrong, wide block cipher mode).

Elements of GF(2^128) must be presented as u64* (specifically u64[2]),
it encourages automatic and proper alignment.

The library contains support for two different representations of GF(2^128),
see the comment in gf128mul.h. There different levels of optimization
(memory/speed tradeoff).

The code is based on work by Dr Brian Gladman. Notable changes:
- deletion of two optimization modes
- change from u32 to u64 for faster handling on 64bit machines
- support for 'bbe' representation in addition to the, already implemented,
  'lle' representation.
- move 'inline void' functions from header to 'static void' in the
  source file
- update to use the linux coding style conventions

The original can be found at:
http://fp.gladman.plus.com/AES/modes.vc8.19-06-06.zip

The copyright (and GPL statement) of the original author is preserved.

Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>
---
 crypto/Kconfig    |   11 +
 crypto/Makefile   |    1 
 crypto/gf128mul.c |  401 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/gf128mul.h |  196 ++++++++++++++++++++++++++
 4 files changed, 609 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1e2f39c..6b23c20 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -128,6 +128,17 @@ config CRYPTO_TGR192
 	  See also:
 	  <http://www.cs.technion.ac.il/~biham/Reports/Tiger/>.
 
+config CRYPTO_GF128MUL
+	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	default n
+	help
+	  Efficient table driven implementation of multiplications in the
+	  field GF(2^128). This is needed by some cypher modes. This
+	  option will be selected automatically if you select such a
+	  cipher mode. Only select this option by hand if you expect to load
+	  an external module that requires these functions.
+
 config CRYPTO_ECB
 	tristate "ECB support"
 	select CRYPTO_BLKCIPHER
diff --git a/crypto/Makefile b/crypto/Makefile
index 7236620..bf0406b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_CRYPTO_SHA256) += sha256.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
+obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
 obj-$(CONFIG_CRYPTO_DES) += des.o
diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
new file mode 100644
index 0000000..6d17704
--- /dev/null
+++ b/crypto/gf128mul.c
@@ -0,0 +1,401 @@
+/* gf128mul.c - GF(2^128) multiplication functions
+ * 
+ * Copyright (c) 2003, Dr Brian Gladman, Worcester, UK.
+ * Copyright (c) 2006, Rik Snel <rsnel@cube.dyndns.org>
+ *
+ * Based on Dr Brain Gladman's (GPL'd) work published at
+ * http://fp.gladman.plus.com/cryptography_technology/index.htm
+ * See the original copyright notice below.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+/*
+ ---------------------------------------------------------------------------
+ Copyright (c) 2003, Dr Brian Gladman, Worcester, UK.   All rights reserved.
+
+ LICENSE TERMS
+
+ The free distribution and use of this software in both source and binary
+ form is allowed (with or without changes) provided that:
+
+   1. distributions of this source code include the above copyright
+      notice, this list of conditions and the following disclaimer;
+
+   2. distributions in binary form include the above copyright
+      notice, this list of conditions and the following disclaimer
+      in the documentation and/or other associated materials;
+
+   3. the copyright holder's name is not used to endorse products
+      built using this software without specific written permission.
+
+ ALTERNATIVELY, provided that this notice is retained in full, this product
+ may be distributed under the terms of the GNU General Public License (GPL),
+ in which case the provisions of the GPL apply INSTEAD OF those given above.
+
+ DISCLAIMER
+
+ This software is provided 'as is' with no explicit or implied warranties
+ in respect of its properties, including, but not limited to, correctness
+ and/or fitness for purpose.
+ ---------------------------------------------------------------------------
+ Issue 31/01/2006
+
+ This file provides fast multiplication in GF(128) as required by several
+ cryptographic authentication modes
+*/
+
+#include <linux/module.h>
+#include "b128ops.h"
+#include "gf128mul.h"
+
+#define gf128mul_dat(q) { \
+	q(0x00), q(0x01), q(0x02), q(0x03), q(0x04), q(0x05), q(0x06), q(0x07),\
+	q(0x08), q(0x09), q(0x0a), q(0x0b), q(0x0c), q(0x0d), q(0x0e), q(0x0f),\
+	q(0x10), q(0x11), q(0x12), q(0x13), q(0x14), q(0x15), q(0x16), q(0x17),\
+	q(0x18), q(0x19), q(0x1a), q(0x1b), q(0x1c), q(0x1d), q(0x1e), q(0x1f),\
+	q(0x20), q(0x21), q(0x22), q(0x23), q(0x24), q(0x25), q(0x26), q(0x27),\
+	q(0x28), q(0x29), q(0x2a), q(0x2b), q(0x2c), q(0x2d), q(0x2e), q(0x2f),\
+	q(0x30), q(0x31), q(0x32), q(0x33), q(0x34), q(0x35), q(0x36), q(0x37),\
+	q(0x38), q(0x39), q(0x3a), q(0x3b), q(0x3c), q(0x3d), q(0x3e), q(0x3f),\
+	q(0x40), q(0x41), q(0x42), q(0x43), q(0x44), q(0x45), q(0x46), q(0x47),\
+	q(0x48), q(0x49), q(0x4a), q(0x4b), q(0x4c), q(0x4d), q(0x4e), q(0x4f),\
+	q(0x50), q(0x51), q(0x52), q(0x53), q(0x54), q(0x55), q(0x56), q(0x57),\
+	q(0x58), q(0x59), q(0x5a), q(0x5b), q(0x5c), q(0x5d), q(0x5e), q(0x5f),\
+	q(0x60), q(0x61), q(0x62), q(0x63), q(0x64), q(0x65), q(0x66), q(0x67),\
+	q(0x68), q(0x69), q(0x6a), q(0x6b), q(0x6c), q(0x6d), q(0x6e), q(0x6f),\
+	q(0x70), q(0x71), q(0x72), q(0x73), q(0x74), q(0x75), q(0x76), q(0x77),\
+	q(0x78), q(0x79), q(0x7a), q(0x7b), q(0x7c), q(0x7d), q(0x7e), q(0x7f),\
+	q(0x80), q(0x81), q(0x82), q(0x83), q(0x84), q(0x85), q(0x86), q(0x87),\
+	q(0x88), q(0x89), q(0x8a), q(0x8b), q(0x8c), q(0x8d), q(0x8e), q(0x8f),\
+	q(0x90), q(0x91), q(0x92), q(0x93), q(0x94), q(0x95), q(0x96), q(0x97),\
+	q(0x98), q(0x99), q(0x9a), q(0x9b), q(0x9c), q(0x9d), q(0x9e), q(0x9f),\
+	q(0xa0), q(0xa1), q(0xa2), q(0xa3), q(0xa4), q(0xa5), q(0xa6), q(0xa7),\
+	q(0xa8), q(0xa9), q(0xaa), q(0xab), q(0xac), q(0xad), q(0xae), q(0xaf),\
+	q(0xb0), q(0xb1), q(0xb2), q(0xb3), q(0xb4), q(0xb5), q(0xb6), q(0xb7),\
+	q(0xb8), q(0xb9), q(0xba), q(0xbb), q(0xbc), q(0xbd), q(0xbe), q(0xbf),\
+	q(0xc0), q(0xc1), q(0xc2), q(0xc3), q(0xc4), q(0xc5), q(0xc6), q(0xc7),\
+	q(0xc8), q(0xc9), q(0xca), q(0xcb), q(0xcc), q(0xcd), q(0xce), q(0xcf),\
+	q(0xd0), q(0xd1), q(0xd2), q(0xd3), q(0xd4), q(0xd5), q(0xd6), q(0xd7),\
+	q(0xd8), q(0xd9), q(0xda), q(0xdb), q(0xdc), q(0xdd), q(0xde), q(0xdf),\
+	q(0xe0), q(0xe1), q(0xe2), q(0xe3), q(0xe4), q(0xe5), q(0xe6), q(0xe7),\
+	q(0xe8), q(0xe9), q(0xea), q(0xeb), q(0xec), q(0xed), q(0xee), q(0xef),\
+	q(0xf0), q(0xf1), q(0xf2), q(0xf3), q(0xf4), q(0xf5), q(0xf6), q(0xf7),\
+	q(0xf8), q(0xf9), q(0xfa), q(0xfb), q(0xfc), q(0xfd), q(0xfe), q(0xff) \
+}
+
+/*	Given the value i in 0..255 as the byte overflow when a field element
+    in GHASH is multipled by x^8, this function will return the values that
+    are generated in the lo 16-bit word of the field value by applying the
+    modular polynomial. The values lo_byte and hi_byte are returned via the
+    macro xp_fun(lo_byte, hi_byte) so that the values can be assembled into
+    memory as required by a suitable definition of this macro operating on
+    the table above
+*/
+
+#ifdef __BIG_ENDIAN
+#define xx(p,q)	0x##p##q	/* assemble in big endian order    */
+#else
+#define xx(p,q)	0x##q##p	/* assemble in little endian order */
+#endif
+
+#define xda_bbe(i) ( \
+    (i&0x80?xx(43,80):0)^(i&0x40?xx(21,c0):0)^ \
+    (i&0x20?xx(10,e0):0)^(i&0x10?xx(08,70):0)^ \
+    (i&0x08?xx(04,38):0)^(i&0x04?xx(02,1c):0)^ \
+    (i&0x02?xx(01,0e):0)^(i&0x01?xx(00,87):0) \
+)
+
+#define xda_lle(i) ( \
+    (i&0x80?xx(e1,00):0)^(i&0x40?xx(70,80):0)^ \
+    (i&0x20?xx(38,40):0)^(i&0x10?xx(1c,20):0)^ \
+    (i&0x08?xx(0e,10):0)^(i&0x04?xx(07,08):0)^ \
+    (i&0x02?xx(03,84):0)^(i&0x01?xx(01,c2):0) \
+)
+
+static const u16 gf128mul_table_lle[256] = gf128mul_dat(xda_lle);
+EXPORT_SYMBOL(gf128mul_table_lle);
+
+static const u16 gf128mul_table_bbe[256] = gf128mul_dat(xda_bbe);
+EXPORT_SYMBOL(gf128mul_table_bbe);
+
+/* These functions multiply a field element by x, by x^4 and by x^8 
+ * in the polynomial field representation. It uses 32-bit word operations 
+ * to gain speed but compensates for machine endianess and hence works
+ * correctly on both styles of machine.
+ */
+#ifdef __BIG_ENDIAN
+
+static void gf128mul_x_lle(u64 *r, const u64 *x)
+{
+	u64 _tt = gf128mul_table_lle[(x[1] << 7) & 0xff];
+	r[1] = (x[1] >> 1) | (x[0] << 63);
+	r[0] = (x[0] >> 1) ^ (_tt << 48);
+}
+
+static void gf128mul_x_bbe(u64 *r, const u64 *x)
+{
+	u64 _tt = gf128mul_tab_bbe[(x[0] >> 63)];
+	r[0] = (x[0] << 1) | (x[1] >> 63);
+	r[1] = (x[1] << 1) ^ _tt;
+}
+
+static void gf128mul_x8_lle(u64 *x)
+{
+	_tt = gf128mul_table_lle[x[1] & 0xff];
+	x[1] = (x[1] >> 8) | (x[0] << 56);
+	x[0] = (x[0] >> 8) ^ (_tt << 48);
+}
+
+static void gf128mul_x8_bbe(u64 *x)
+{	
+	_tt = gf128mul_tab_bbe[x[0] >> 56];
+	x[0] = (x[0] << 8) | (x[1] >> 56);
+	x[1] = (x[1] << 8) ^ _tt;
+}
+
+#else
+
+#define M80X	0x8080808080808080LLU
+#define M01X	0x0101010101010101LLU
+
+static void gf128mul_x_lle(u64 r[2], const u64 x[2])
+{
+	u64  _tt = gf128mul_table_lle[(x[1] >> 49) & 0x80];
+	r[1] =  ((x[1] >> 1) & ~M80X) | (((x[1] << 15) | (x[0] >> 49)) & M80X);
+	r[0] = (((x[0] >> 1) & ~M80X) |  ((x[0] << 15) & M80X)) ^ _tt;
+}
+
+static void gf128mul_x8_lle(u64 x[2])
+{
+	u64 _tt = gf128mul_table_lle[x[1] >> 56];
+	x[1] = (x[1] << 8) | (x[0] >> 56);
+	x[0] = (x[0] << 8) ^ _tt;
+}
+
+static void gf128mul_x_bbe(u64 r[2], const u64 x[2])
+{
+	u64 _tt = gf128mul_table_bbe[(x[0] >> 7) & 0x01];
+	r[0] =  ((x[0] << 1) & ~M01X) | (((x[0] >> 15) | (x[1] << 49)) & M01X);
+	r[1] = (((x[1] << 1) & ~M01X) |  ((x[1] >> 15) & M01X)) ^ _tt << 48;
+}
+
+static void gf128mul_x8_bbe(u64 x[2])
+{
+	u64 _tt = gf128mul_table_bbe[x[0]&0xff];
+	x[0] = (x[0] >> 8) | (x[1] << 56);
+	x[1] = (x[1] >> 8) ^ (_tt << 48);
+}
+
+#endif
+
+void gf128mul_lle(u64 *a, const u64* b)
+{
+	u64 r[GF128MUL_BYTES >> 3], p[8][GF128MUL_BYTES >> 3];
+	int i;
+
+	b128ops_mov(p[0], b);
+	for(i = 0; i < 7; ++i) gf128mul_x_lle(p[i+1], p[i]);
+
+	memset(r, 0, GF128MUL_BYTES);
+	for(i = 0; i < 16; ++i) {
+		u8 ch = ((u8*)a)[15-i];
+		if(i) gf128mul_x8_lle(r);
+
+		if(ch&0x80) b128ops_xor(r, p[0]);
+		if(ch&0x40) b128ops_xor(r, p[1]);
+		if(ch&0x20) b128ops_xor(r, p[2]);
+		if(ch&0x10) b128ops_xor(r, p[3]);
+		if(ch&0x08) b128ops_xor(r, p[4]);
+		if(ch&0x04) b128ops_xor(r, p[5]);
+		if(ch&0x02) b128ops_xor(r, p[6]);
+		if(ch&0x01) b128ops_xor(r, p[7]);
+	}
+	b128ops_mov(a, r);
+}
+EXPORT_SYMBOL(gf128mul_lle);
+
+void gf128mul_bbe(u64 *a, const u64* b)
+{
+	u64 r[GF128MUL_BYTES >> 3], p[8][GF128MUL_BYTES >> 3];
+	int i;
+	b128ops_mov(p[0], b);
+	for(i = 0; i < 7; ++i) gf128mul_x_bbe(p[i+1], p[i]);
+	
+	memset(r, 0, GF128MUL_BYTES);
+	for(i = 0; i < 16; ++i) {
+		u8 ch = ((u8*)a)[i];
+		if(i) gf128mul_x8_bbe(r);
+
+		if(ch&0x80) b128ops_xor(r, p[7]);
+		if(ch&0x40) b128ops_xor(r, p[6]);
+		if(ch&0x20) b128ops_xor(r, p[5]);
+		if(ch&0x10) b128ops_xor(r, p[4]);
+		if(ch&0x08) b128ops_xor(r, p[3]);
+		if(ch&0x04) b128ops_xor(r, p[2]);
+		if(ch&0x02) b128ops_xor(r, p[1]);
+		if(ch&0x01) b128ops_xor(r, p[0]);
+	}
+	b128ops_mov(a, r);
+}
+EXPORT_SYMBOL(gf128mul_bbe);
+
+/*      This version uses 64k bytes of table space on the stack.
+    A 16 byte buffer has to be multiplied by a 16 byte key
+    value in GF(128).  If we consider a GF(128) value in
+    the buffer's lowest byte, we can construct a table of
+    the 256 16 byte values that result from the 256 values
+    of this byte.  This requires 4096 bytes. But we also
+    need tables for each of the 16 higher bytes in the
+    buffer as well, which makes 64 kbytes in total.
+*/
+/* additional explanation
+ * t[0][BYTE] contains g*BYTE
+ * t[1][BYTE] contains g*x^8*BYTE
+ *  ..
+ * t[15][BYTE] contains g*x^120*BYTE */
+void gf128mul_init_64k_lle(struct gf128mul_64k *t, const u64 *g)
+{
+	int i, j, k;
+
+	memset(t->t, 0, 16*256*GF128MUL_BYTES);
+	for (i = 0; i < GF128MUL_BYTES; ++i) {
+        	if (!i) {
+			b128ops_mov(t->t[0][128], g);
+			for (j = 64; j > 0; j >>= 1) {
+				gf128mul_x_lle(t->t[0][j], t->t[0][j + j]);
+			}			
+        	} else for (j = 128; j > 0; j >>= 1) {
+			b128ops_mov(t->t[i][j], t->t[i - 1][j]);
+			gf128mul_x8_lle(t->t[i][j]);
+		}
+
+		for (j = 2; j < 256; j += j) for(k = 1; k < j; ++k) {
+			t->t[i][j+k][0] = t->t[i][j][0]^t->t[i][k][0];
+			t->t[i][j+k][1] = t->t[i][j][1]^t->t[i][k][1];
+		}
+	}
+}
+EXPORT_SYMBOL(gf128mul_init_64k_lle);
+
+void gf128mul_init_64k_bbe(struct gf128mul_64k *t, const u64 *g)
+{
+	int i, j, k;
+
+	memset(t->t, 0, 16*256*GF128MUL_BYTES);
+	for (i = 0; i < GF128MUL_BYTES; ++i) {
+        	if (!i) {
+			b128ops_mov(t->t[0][1], g);
+			for (j = 1; j <= 64; j <<= 1) {
+				gf128mul_x_bbe(t->t[0][j + j], t->t[0][j]);
+			}			
+        	} else for (j = 128; j > 0; j >>= 1) {
+			b128ops_mov(t->t[i][j], t->t[i - 1][j]);
+			gf128mul_x8_bbe(t->t[i][j]);
+		}
+
+		for (j = 2; j < 256; j += j) for(k = 1; k < j; ++k) {
+			t->t[i][j+k][0] = t->t[i][j][0]^t->t[i][k][0];
+			t->t[i][j+k][1] = t->t[i][j][1]^t->t[i][k][1];
+		}
+	}
+}
+EXPORT_SYMBOL(gf128mul_init_64k_bbe);
+
+void gf128mul_64k_lle(u64 a[], struct gf128mul_64k *t, u64 *r)
+{
+        int i;
+        b128ops_mov(r, t->t[0][((u8*)a)[0]]);
+        for (i = 1; i < GF128MUL_BYTES; ++i) {
+                b128ops_xor(r, t->t[i][((u8*)a)[i]]);
+        }
+        b128ops_mov(a, r);
+}
+EXPORT_SYMBOL(gf128mul_64k_lle); 
+
+void gf128mul_64k_bbe(u64 a[], struct gf128mul_64k *t, u64 *r)
+{
+        int i;
+        b128ops_mov(r, t->t[0][((u8*)a)[15]]);
+        for (i = 1; i < GF128MUL_BYTES; ++i) {
+                b128ops_xor(r, t->t[i][((u8*)a)[15 - i]]);
+        }
+        b128ops_mov(a, r);
+}
+EXPORT_SYMBOL(gf128mul_64k_bbe); 
+
+/*      This version uses 4k bytes of table space on the stack.
+    A 16 byte buffer has to be multiplied by a 16 byte key
+    value in GF(128).  If we consider a GF(128) value in a
+    single byte, we can construct a table of the 256 16 byte
+    values that result from the 256 values of this byte.
+    This requires 4096 bytes. If we take the highest byte in
+    the buffer and use this table to get the result, we then
+    have to multiply by x^120 to get the final value. For the
+    next highest byte the result has to be multiplied by x^112
+    and so on. But we can do this by accumulating the result
+    in an accumulator starting with the result for the top
+    byte.  We repeatedly multiply the accumulator value by
+    x^8 and then add in (i.e. xor) the 16 bytes of the next
+    lower byte in the buffer, stopping when we reach the
+    lowest byte. This requires a 4096 byte table.
+*/
+void gf128mul_init_4k_lle(struct gf128mul_4k *t, const u64 *g)
+{
+	int j, k;
+
+	memset(t, 0, 256*GF128MUL_BYTES);
+	b128ops_mov(t->t[128], g);
+	for (j = 64; j > 0; j >>= 1) gf128mul_x_lle(t->t[j], t->t[j+j]);
+
+	for (j = 2; j < 256; j += j) for (k = 1; k < j; ++k) {
+		t->t[j + k][0] = t->t[j][0] ^ t->t[k][0];
+		t->t[j + k][1] = t->t[j][1] ^ t->t[k][1];
+        }
+}
+EXPORT_SYMBOL(gf128mul_init_4k_lle);
+
+void gf128mul_init_4k_bbe(struct gf128mul_4k *t, const u64 *g)
+{
+	int j, k;
+
+	memset(t, 0, 256*GF128MUL_BYTES);
+	b128ops_mov(t->t[1], g);
+	for (j = 1; j <= 64; j <<= 1) gf128mul_x_bbe(t->t[j + j], t->t[j]);
+
+	for (j = 2; j < 256; j += j) for (k = 1; k < j; ++k) {
+		t->t[j + k][0] = t->t[j][0] ^ t->t[k][0];
+		t->t[j + k][1] = t->t[j][1] ^ t->t[k][1];
+        }
+}
+EXPORT_SYMBOL(gf128mul_init_4k_bbe);
+
+void gf128mul_4k_lle(u64 *a, struct gf128mul_4k *t, u64 *r)
+{
+        int i = 15;
+        b128ops_mov(r, t->t[((u8*)a)[15]]);
+        while(i--) {
+		gf128mul_x8_lle(r);
+		b128ops_xor(r, t->t[((u8*)a)[i]]);
+        }
+        b128ops_mov(a, r);
+}
+EXPORT_SYMBOL(gf128mul_4k_lle);
+
+void gf128mul_4k_bbe(u64 *a, struct gf128mul_4k *t, u64 *r)
+{
+        int i = 0;
+        b128ops_mov(r, t->t[((u8*)a)[0]]);
+        while(++i < 16) {
+		gf128mul_x8_bbe(r);
+		b128ops_xor(r, t->t[((u8*)a)[i]]);
+        }
+        b128ops_mov(a, r);
+}
+EXPORT_SYMBOL(gf128mul_4k_bbe);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("functions for multiplying elements of GF(2^128)");
diff --git a/crypto/gf128mul.h b/crypto/gf128mul.h
new file mode 100644
index 0000000..bbaae1f
--- /dev/null
+++ b/crypto/gf128mul.h
@@ -0,0 +1,196 @@
+/* gf128mul.h - GF(2^128) multiplication functions
+ * 
+ * Copyright (c) 2003, Dr Brian Gladman, Worcester, UK.
+ * Copyright (c) 2006 Rik Snel <rsnel@cube.dyndns.org>
+ *
+ * Based on Dr Brain Gladman's (GPL'd) work published at
+ * http://fp.gladman.plus.com/cryptography_technology/index.htm
+ * See the original copyright notice below.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+/*
+ ---------------------------------------------------------------------------
+ Copyright (c) 2003, Dr Brian Gladman, Worcester, UK.   All rights reserved.
+
+ LICENSE TERMS
+
+ The free distribution and use of this software in both source and binary
+ form is allowed (with or without changes) provided that:
+
+   1. distributions of this source code include the above copyright
+      notice, this list of conditions and the following disclaimer;
+
+   2. distributions in binary form include the above copyright
+      notice, this list of conditions and the following disclaimer
+      in the documentation and/or other associated materials;
+
+   3. the copyright holder's name is not used to endorse products
+      built using this software without specific written permission.
+
+ ALTERNATIVELY, provided that this notice is retained in full, this product
+ may be distributed under the terms of the GNU General Public License (GPL),
+ in which case the provisions of the GPL apply INSTEAD OF those given above.
+
+ DISCLAIMER
+
+ This software is provided 'as is' with no explicit or implied warranties
+ in respect of its properties, including, but not limited to, correctness
+ and/or fitness for purpose.
+ ---------------------------------------------------------------------------
+ Issue Date: 31/01/2006
+
+ An implementation of field multiplication in Galois Field GF(128)
+*/
+
+#ifndef _LINUX_GF128MUL_H
+#define _LINUX_GF128MUL_H
+/* Comment by Rik:
+ * 
+ * For some background on GF(2^128) see for example: http://-
+ * csrc.nist.gov/CryptoToolkit/modes/proposedmodes/gcm/gcm-revised-spec.pdf 
+ * 
+ * The elements of GF(2^128) := GF(2)[X]/(X^128-X^7-X^2-X^1-1) can
+ * be mapped to computer memory in a variety of ways. Let's examine
+ * three common cases 
+ *
+ * Take a look at the 16 binary octets below in memory order. The msb's 
+ * are left and the lsb's are right. char b[16] is an array and b[0] is 
+ * the first octet.
+ *
+ * 80000000 00000000 00000000 00000000 .... 00000000 00000000 00000000
+ *   b[0]     b[1]     b[2]     b[3]          b[13]    b[14]    b[15]
+ *
+ * Every bit is a coefficient of some power of X. We can store the bits
+ * in every byte in little-endian order and the bytes themselves also in
+ * little endian order. I will call this lle (little-little-endian).
+ * The above buffer represents the polynomial 1, and X^7+X^2+X^1+1 looks
+ * like 11100001 00000000 .... 00000000 = { 0xE1, 0x00, }.
+ * This format was originally implemented in gf128mul and is used
+ * in GCM (Galois/Counter mode) and in ABL (Arbitrary Block Length).
+ *
+ * Another convention says: store the bits in bigendian order and the
+ * bytes also. This is bbe (big-big-endian). Now the buffer above
+ * represents X^127. X^7+X^2+X^1+1 looks like 00000000 .... 10000111,
+ * b[15] = 0x87 and the rest is 0. LRW uses this convention and bbe
+ * is partly implemented.
+ *
+ * Both of the above formats are easy to implement on big-endian
+ * machines.
+ *
+ * EME (which is patent encumbered) uses the ble format (bits are stored 
+ * in big endian order and the bytes in little endian). The above buffer
+ * represents X^7 in this case and the primitive polynomial is b[0] = 0x87.
+ *
+ * The common machine word-size is smaller than 128 bits, so to make
+ * an efficient implementation we must split into machine word sizes.
+ * This file uses one 32bit for the moment. Machine endianness comes into
+ * play. The lle format in relation to machine endianness is discusses
+ * below by the original author of gf128mul Dr Brian Gladman.
+ *
+ * Let's look at the bbe and ble format on a little endian machine.
+ *
+ * bbe on a little endian machine u32 x[4]:
+ *
+ *  MS            x[0]           LS  MS            x[1]		  LS
+ *  ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
+ *  103..96 111.104 119.112 127.120  71...64 79...72 87...80 95...88
+ *
+ *  MS            x[2]           LS  MS            x[3]		  LS
+ *  ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
+ *  39...32 47...40 55...48 63...56  07...00 15...08 23...16 31...24
+ *
+ * ble on a little endian machine
+ *
+ *  MS            x[0]           LS  MS            x[1]		  LS
+ *  ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
+ *  31...24 23...16 15...08 07...00  63...56 55...48 47...40 39...32
+ *
+ *  MS            x[2]           LS  MS            x[3]		  LS
+ *  ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
+ *  95...88 87...80 79...72 71...64  127.120 199.112 111.104 103..96
+ *
+ * Multiplications in GF(2^128) are mostly bit-shifts, so you see why
+ * ble (and lbe also) are easier to implement on a little-endian
+ * machine than om a big-endian machine. The converse holds for bbe 
+ * and lle.
+ *
+ * Note: to have good alignment, it seems to me that it is sufficient
+ * to keep elements of GF(2^128) in type u64[2]. On 32-bit wordsize
+ * machines this will automatically aligned to wordsize and on a 64-bit
+ * machine also.
+ */
+/*	Multiply a GF128 field element by x. Field elements are held in arrays
+    of bytes in which field bits 8n..8n + 7 are held in byte[n], with lower
+    indexed bits placed in the more numerically significant bit positions
+    within bytes.
+
+    On little endian machines the bit indexes translate into the bit
+    positions within four 32-bit words in the following way
+
+    MS            x[0]           LS  MS            x[1]		  LS
+    ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
+    24...31 16...23 08...15 00...07  56...63 48...55 40...47 32...39
+
+    MS            x[2]           LS  MS            x[3]		  LS
+    ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
+    88...95 80...87 72...79 64...71  120.127 112.119 104.111 96..103
+
+    On big endian machines the bit indexes translate into the bit
+    positions within four 32-bit words in the following way
+
+    MS            x[0]           LS  MS            x[1]		  LS
+    ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
+    00...07 08...15 16...23 24...31  32...39 40...47 48...55 56...63
+
+    MS            x[2]           LS  MS            x[3]		  LS
+    ms   ls ms   ls ms   ls ms   ls  ms   ls ms   ls ms   ls ms   ls
+    64...71 72...79 80...87 88...95  96..103 104.111 112.119 120.127
+*/
+
+#define GF128MUL_BYTES	16
+
+/*	A slow generic version of gf_mul, implemented for lle and bbe
+ * 	It multiplies a and b and puts the result in a */
+void gf128mul_lle(u64 *a, const u64* b);
+
+void gf128mul_bbe(u64 *a, const u64* b);
+
+
+/* 64k table optimization, implemented for lle and bbe */
+
+struct gf128mul_64k {
+	u64 t[16][256][GF128MUL_BYTES >> 3];
+};
+
+/* first initialize with the constant factor with which you 
+ * want to multiply and then call gf128_64k_lle with the other
+ * factor in the first argument, the table in the second and a
+ * scratch register in the third. Afterwards *a = *r. */
+void gf128mul_init_64k_lle(struct gf128mul_64k *t, const u64 *g);
+
+void gf128mul_init_64k_bbe(struct gf128mul_64k *t, const u64 *g);
+
+void gf128mul_64k_lle(u64 *a, struct gf128mul_64k *t, u64 *r);
+
+void gf128mul_64k_bbe(u64 *a, struct gf128mul_64k *t, u64 *r);
+
+
+/* 4k table optimization */
+
+struct gf128mul_4k {
+	u64 t[256][GF128MUL_BYTES >> 3];
+};
+
+void gf128mul_init_4k_lle(struct gf128mul_4k *t, const u64 *g);
+
+void gf128mul_init_4k_bbe(struct gf128mul_4k *t, const u64 *g);
+
+void gf128mul_4k_lle(u64 *a, struct gf128mul_4k *t, u64 *r);
+
+void gf128mul_4k_bbe(u64 *a, struct gf128mul_4k *t, u64 *r);
+
+#endif /* _LINUX_GF128MUL_H */
-- 
1.4.1.1


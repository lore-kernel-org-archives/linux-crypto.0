From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 1/4] crypto: gf128mul - fix some comments
Date: Tue, 14 Feb 2017 13:43:27 -0800
Message-ID: <20170214214330.99845-2-ebiggers@google.com>
References: <20170214214330.99845-1-ebiggers@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Alex Cope <alexcope@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:36187 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753175AbdBNVp7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 16:45:59 -0500
Received: by mail-it0-f54.google.com with SMTP id c7so52107274itd.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2017 13:45:59 -0800 (PST)
In-Reply-To: <20170214214330.99845-1-ebiggers@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix incorrect references to GF(128) instead of GF(2^128), as these are
two entirely different fields, and fix a few other incorrect comments.

Cc: Alex Cope <alexcope@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gf128mul.c         | 13 +++++++------
 include/crypto/gf128mul.h | 26 ++++++++++++++------------
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index 72015fee533d..d9e3eecc218a 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -44,7 +44,7 @@
  ---------------------------------------------------------------------------
  Issue 31/01/2006
 
- This file provides fast multiplication in GF(128) as required by several
+ This file provides fast multiplication in GF(2^128) as required by several
  cryptographic authentication modes
 */
 
@@ -116,9 +116,10 @@
 static const u16 gf128mul_table_lle[256] = gf128mul_dat(xda_lle);
 static const u16 gf128mul_table_bbe[256] = gf128mul_dat(xda_bbe);
 
-/* These functions multiply a field element by x, by x^4 and by x^8
- * in the polynomial field representation. It uses 32-bit word operations
- * to gain speed but compensates for machine endianess and hence works
+/*
+ * The following functions multiply a field element by x or by x^8 in
+ * the polynomial field representation.  They use 64-bit word operations
+ * to gain speed but compensate for machine endianness and hence work
  * correctly on both styles of machine.
  */
 
@@ -251,7 +252,7 @@ EXPORT_SYMBOL(gf128mul_bbe);
 
 /*      This version uses 64k bytes of table space.
     A 16 byte buffer has to be multiplied by a 16 byte key
-    value in GF(128).  If we consider a GF(128) value in
+    value in GF(2^128).  If we consider a GF(2^128) value in
     the buffer's lowest byte, we can construct a table of
     the 256 16 byte values that result from the 256 values
     of this byte.  This requires 4096 bytes. But we also
@@ -330,7 +331,7 @@ EXPORT_SYMBOL(gf128mul_64k_bbe);
 
 /*      This version uses 4k bytes of table space.
     A 16 byte buffer has to be multiplied by a 16 byte key
-    value in GF(128).  If we consider a GF(128) value in a
+    value in GF(2^128).  If we consider a GF(2^128) value in a
     single byte, we can construct a table of the 256 16 byte
     values that result from the 256 values of this byte.
     This requires 4096 bytes. If we take the highest byte in
diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index 592d47e565a8..9662c4538873 100644
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
@@ -85,15 +85,17 @@
  * Both of the above formats are easy to implement on big-endian
  * machines.
  *
- * EME (which is patent encumbered) uses the ble format (bits are stored
- * in big endian order and the bytes in little endian). The above buffer
- * represents X^7 in this case and the primitive polynomial is b[0] = 0x87.
+ * XTS and EME (the latter of which is patent encumbered) use the ble
+ * format (bits are stored in big endian order and the bytes in little
+ * endian). The above buffer represents X^7 in this case and the
+ * primitive polynomial is b[0] = 0x87.
  *
  * The common machine word-size is smaller than 128 bits, so to make
  * an efficient implementation we must split into machine word sizes.
- * This file uses one 32bit for the moment. Machine endianness comes into
- * play. The lle format in relation to machine endianness is discussed
- * below by the original author of gf128mul Dr Brian Gladman.
+ * This implementation uses 64-bit words for the moment. Machine
+ * endianness comes into play. The lle format in relation to machine
+ * endianness is discussed below by the original author of gf128mul Dr
+ * Brian Gladman.
  *
  * Let's look at the bbe and ble format on a little endian machine.
  *
@@ -127,10 +129,10 @@
  * machines this will automatically aligned to wordsize and on a 64-bit
  * machine also.
  */
-/*	Multiply a GF128 field element by x. Field elements are held in arrays
-    of bytes in which field bits 8n..8n + 7 are held in byte[n], with lower
-    indexed bits placed in the more numerically significant bit positions
-    within bytes.
+/*	Multiply a GF(2^128) field element by x. Field elements are
+    held in arrays of bytes in which field bits 8n..8n + 7 are held in
+    byte[n], with lower indexed bits placed in the more numerically
+    significant bit positions within bytes.
 
     On little endian machines the bit indexes translate into the bit
     positions within four 32-bit words in the following way
-- 
2.11.0.483.g087da7b7c-goog

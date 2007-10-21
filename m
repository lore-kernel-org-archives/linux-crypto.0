From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH] do not unroll big stuff in twofish key setup if OPTIMIZE_FOR_SIZE
Date: Sun, 21 Oct 2007 20:16:25 +0100
Message-ID: <200710212016.25792.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JW6GHjAXKro526x"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:55209 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbXJUTQg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Oct 2007 15:16:36 -0400
Received: by ug-out-1314.google.com with SMTP id z38so817792ugc
        for <linux-crypto@vger.kernel.org>; Sun, 21 Oct 2007 12:16:34 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_JW6GHjAXKro526x
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Herbert,

Currently twofish cipher key setup code
has unrolled loops - approximately 70-100
instructions are repeated 40 times.

As a result, twofish module is the biggest module
in crypto/*.

Attached patch conditionalize this unrolling on
CONFIG_CC_OPTIMIZE_FOR_SIZE. Presumably, people which
want to use -Os will also prefer to not have these loops
unrolled:

$ size */twofish_common.o
   text    data     bss     dec     hex filename
  37920       0       0   37920    9420 crypto.org/twofish_common.o
  13209       0       0   13209    3399 crypto/twofish_common.o

Run tested (modprobe tcrypt reports ok). Please apply.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_JW6GHjAXKro526x
Content-Type: text/x-diff;
  charset="us-ascii";
  name="twofish_common.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="twofish_common.diff"

--- linux-2.6.23.crypto/crypto/twofish_common0.c	Sun Oct 21 18:30:14 2007
+++ linux-2.6.23.crypto/crypto/twofish_common.c	Sun Oct 21 18:17:36 2007
@@ -655,6 +655,23 @@
 			CALC_SB256_2( i, calc_sb_tbl[j], calc_sb_tbl[k] );
 		}
 
+		/* Unrolling produces x2.5 more code (+18k on i386),
+		 * and speeds up key setup by 7%:
+		 * unrolled: twofish_setkey/sec: 41128
+		 *     loop: twofish_setkey/sec: 38148
+		 * CALC_K256: ~100 insns each
+		 * CALC_K192: ~90 insns
+		 *    CALC_K: ~70 insns
+		 */
+#ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
+		/* Calculate whitening and round subkeys */
+		for ( i = 0; i < 8; i += 2 ) {
+			CALC_K256 (w, i, q0[i], q1[i], q0[i+1], q1[i+1]);
+		}
+		for ( i = 0; i < 32; i += 2 ) {
+			CALC_K256 (k, i, q0[i+8], q1[i+8], q0[i+9], q1[i+9]);
+		}
+#else
 		/* Calculate whitening and round subkeys.  The constants are
 		 * indices of subkeys, preprocessed through q0 and q1. */
 		CALC_K256 (w, 0, 0xA9, 0x75, 0x67, 0xF3);
@@ -677,12 +694,22 @@
 		CALC_K256 (k, 26, 0x8B, 0xAE, 0x30, 0x5B);
 		CALC_K256 (k, 28, 0x84, 0x8A, 0x54, 0x00);
 		CALC_K256 (k, 30, 0xDF, 0xBC, 0x23, 0x9D);
+#endif
 	} else if (key_len == 24) { /* 192-bit key */
 		/* Compute the S-boxes. */
 		for ( i = j = 0, k = 1; i < 256; i++, j += 2, k += 2 ) {
 		        CALC_SB192_2( i, calc_sb_tbl[j], calc_sb_tbl[k] );
 		}
 
+#ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
+		/* Calculate whitening and round subkeys */
+		for ( i = 0; i < 8; i += 2 ) {
+			CALC_K192 (w, i, q0[i], q1[i], q0[i+1], q1[i+1]);
+		}
+		for ( i = 0; i < 32; i += 2 ) {
+			CALC_K192 (k, i, q0[i+8], q1[i+8], q0[i+9], q1[i+9]);
+		}
+#else
 		/* Calculate whitening and round subkeys.  The constants are
 		 * indices of subkeys, preprocessed through q0 and q1. */
 		CALC_K192 (w, 0, 0xA9, 0x75, 0x67, 0xF3);
@@ -705,12 +732,22 @@
 		CALC_K192 (k, 26, 0x8B, 0xAE, 0x30, 0x5B);
 		CALC_K192 (k, 28, 0x84, 0x8A, 0x54, 0x00);
 		CALC_K192 (k, 30, 0xDF, 0xBC, 0x23, 0x9D);
+#endif
 	} else { /* 128-bit key */
 		/* Compute the S-boxes. */
 		for ( i = j = 0, k = 1; i < 256; i++, j += 2, k += 2 ) {
 			CALC_SB_2( i, calc_sb_tbl[j], calc_sb_tbl[k] );
 		}
 
+#ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
+		/* Calculate whitening and round subkeys */
+		for ( i = 0; i < 8; i += 2 ) {
+			CALC_K (w, i, q0[i], q1[i], q0[i+1], q1[i+1]);
+		}
+		for ( i = 0; i < 32; i += 2 ) {
+			CALC_K (k, i, q0[i+8], q1[i+8], q0[i+9], q1[i+9]);
+		}
+#else
 		/* Calculate whitening and round subkeys.  The constants are
 		 * indices of subkeys, preprocessed through q0 and q1. */
 		CALC_K (w, 0, 0xA9, 0x75, 0x67, 0xF3);
@@ -733,6 +770,7 @@
 		CALC_K (k, 26, 0x8B, 0xAE, 0x30, 0x5B);
 		CALC_K (k, 28, 0x84, 0x8A, 0x54, 0x00);
 		CALC_K (k, 30, 0xDF, 0xBC, 0x23, 0x9D);
+#endif
 	}
 
 	return 0;

--Boundary-00=_JW6GHjAXKro526x--

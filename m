From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] do not unroll big stuff in twofish key setup if OPTIMIZE_FOR_SIZE
Date: Thu, 25 Oct 2007 19:33:55 +0100
Message-ID: <200710251933.55853.vda.linux@googlemail.com>
References: <200710212016.25792.vda.linux@googlemail.com> <200710241844.54215.vda.linux@googlemail.com> <20071025010822.GB15154@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TGOIHpdGvvuLkoN"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:30583 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbXJYSeF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Oct 2007 14:34:05 -0400
Received: by nf-out-0910.google.com with SMTP id g13so563753nfb
        for <linux-crypto@vger.kernel.org>; Thu, 25 Oct 2007 11:34:02 -0700 (PDT)
In-Reply-To: <20071025010822.GB15154@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_TGOIHpdGvvuLkoN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 25 October 2007 02:08, Herbert Xu wrote:
> On Wed, Oct 24, 2007 at 06:44:54PM +0100, Denys Vlasenko wrote:
> >
> > 7% slower key setup (see patch - there is a comment about it).
> 
> Is it just the keying? If so please simply delete the unrolled
> version because keying is supposed to be a rare event.

In some crypto applications key setup takes much longer
than encryption itself (e.g. password check).
Not sure whether this kind of behavior ever happens in kernel,
though.

And second, there will be people which want speed at all costs
and they surely will see 7% speedup as significant.

I personally am in the -Os camp and prefer smaller code,
so I personally have no objections.

See attached patch.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_TGOIHpdGvvuLkoN
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="twofish_common02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="twofish_common02.diff"

--- linux-2.6.23.src/crypto/twofish_common0.c	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23.src/crypto/twofish_common.c	2007-10-25 19:28:28.000000000 +0100
@@ -655,84 +655,48 @@ int twofish_setkey(struct crypto_tfm *tf
 			CALC_SB256_2( i, calc_sb_tbl[j], calc_sb_tbl[k] );
 		}
 
-		/* Calculate whitening and round subkeys.  The constants are
-		 * indices of subkeys, preprocessed through q0 and q1. */
-		CALC_K256 (w, 0, 0xA9, 0x75, 0x67, 0xF3);
-		CALC_K256 (w, 2, 0xB3, 0xC6, 0xE8, 0xF4);
-		CALC_K256 (w, 4, 0x04, 0xDB, 0xFD, 0x7B);
-		CALC_K256 (w, 6, 0xA3, 0xFB, 0x76, 0xC8);
-		CALC_K256 (k, 0, 0x9A, 0x4A, 0x92, 0xD3);
-		CALC_K256 (k, 2, 0x80, 0xE6, 0x78, 0x6B);
-		CALC_K256 (k, 4, 0xE4, 0x45, 0xDD, 0x7D);
-		CALC_K256 (k, 6, 0xD1, 0xE8, 0x38, 0x4B);
-		CALC_K256 (k, 8, 0x0D, 0xD6, 0xC6, 0x32);
-		CALC_K256 (k, 10, 0x35, 0xD8, 0x98, 0xFD);
-		CALC_K256 (k, 12, 0x18, 0x37, 0xF7, 0x71);
-		CALC_K256 (k, 14, 0xEC, 0xF1, 0x6C, 0xE1);
-		CALC_K256 (k, 16, 0x43, 0x30, 0x75, 0x0F);
-		CALC_K256 (k, 18, 0x37, 0xF8, 0x26, 0x1B);
-		CALC_K256 (k, 20, 0xFA, 0x87, 0x13, 0xFA);
-		CALC_K256 (k, 22, 0x94, 0x06, 0x48, 0x3F);
-		CALC_K256 (k, 24, 0xF2, 0x5E, 0xD0, 0xBA);
-		CALC_K256 (k, 26, 0x8B, 0xAE, 0x30, 0x5B);
-		CALC_K256 (k, 28, 0x84, 0x8A, 0x54, 0x00);
-		CALC_K256 (k, 30, 0xDF, 0xBC, 0x23, 0x9D);
+		/* CALC_K256/CALC_K192/CALC_K loops were unrolled.
+		 * Unrolling produced x2.5 more code (+18k on i386),
+		 * and speeded up key setup by 7%:
+		 * unrolled: twofish_setkey/sec: 41128
+		 *     loop: twofish_setkey/sec: 38148
+		 * CALC_K256: ~100 insns each
+		 * CALC_K192: ~90 insns
+		 *    CALC_K: ~70 insns
+		 */
+		/* Calculate whitening and round subkeys */
+		for ( i = 0; i < 8; i += 2 ) {
+			CALC_K256 (w, i, q0[i], q1[i], q0[i+1], q1[i+1]);
+		}
+		for ( i = 0; i < 32; i += 2 ) {
+			CALC_K256 (k, i, q0[i+8], q1[i+8], q0[i+9], q1[i+9]);
+		}
 	} else if (key_len == 24) { /* 192-bit key */
 		/* Compute the S-boxes. */
 		for ( i = j = 0, k = 1; i < 256; i++, j += 2, k += 2 ) {
 		        CALC_SB192_2( i, calc_sb_tbl[j], calc_sb_tbl[k] );
 		}
 
-		/* Calculate whitening and round subkeys.  The constants are
-		 * indices of subkeys, preprocessed through q0 and q1. */
-		CALC_K192 (w, 0, 0xA9, 0x75, 0x67, 0xF3);
-		CALC_K192 (w, 2, 0xB3, 0xC6, 0xE8, 0xF4);
-		CALC_K192 (w, 4, 0x04, 0xDB, 0xFD, 0x7B);
-		CALC_K192 (w, 6, 0xA3, 0xFB, 0x76, 0xC8);
-		CALC_K192 (k, 0, 0x9A, 0x4A, 0x92, 0xD3);
-		CALC_K192 (k, 2, 0x80, 0xE6, 0x78, 0x6B);
-		CALC_K192 (k, 4, 0xE4, 0x45, 0xDD, 0x7D);
-		CALC_K192 (k, 6, 0xD1, 0xE8, 0x38, 0x4B);
-		CALC_K192 (k, 8, 0x0D, 0xD6, 0xC6, 0x32);
-		CALC_K192 (k, 10, 0x35, 0xD8, 0x98, 0xFD);
-		CALC_K192 (k, 12, 0x18, 0x37, 0xF7, 0x71);
-		CALC_K192 (k, 14, 0xEC, 0xF1, 0x6C, 0xE1);
-		CALC_K192 (k, 16, 0x43, 0x30, 0x75, 0x0F);
-		CALC_K192 (k, 18, 0x37, 0xF8, 0x26, 0x1B);
-		CALC_K192 (k, 20, 0xFA, 0x87, 0x13, 0xFA);
-		CALC_K192 (k, 22, 0x94, 0x06, 0x48, 0x3F);
-		CALC_K192 (k, 24, 0xF2, 0x5E, 0xD0, 0xBA);
-		CALC_K192 (k, 26, 0x8B, 0xAE, 0x30, 0x5B);
-		CALC_K192 (k, 28, 0x84, 0x8A, 0x54, 0x00);
-		CALC_K192 (k, 30, 0xDF, 0xBC, 0x23, 0x9D);
+		/* Calculate whitening and round subkeys */
+		for ( i = 0; i < 8; i += 2 ) {
+			CALC_K192 (w, i, q0[i], q1[i], q0[i+1], q1[i+1]);
+		}
+		for ( i = 0; i < 32; i += 2 ) {
+			CALC_K192 (k, i, q0[i+8], q1[i+8], q0[i+9], q1[i+9]);
+		}
 	} else { /* 128-bit key */
 		/* Compute the S-boxes. */
 		for ( i = j = 0, k = 1; i < 256; i++, j += 2, k += 2 ) {
 			CALC_SB_2( i, calc_sb_tbl[j], calc_sb_tbl[k] );
 		}
 
-		/* Calculate whitening and round subkeys.  The constants are
-		 * indices of subkeys, preprocessed through q0 and q1. */
-		CALC_K (w, 0, 0xA9, 0x75, 0x67, 0xF3);
-		CALC_K (w, 2, 0xB3, 0xC6, 0xE8, 0xF4);
-		CALC_K (w, 4, 0x04, 0xDB, 0xFD, 0x7B);
-		CALC_K (w, 6, 0xA3, 0xFB, 0x76, 0xC8);
-		CALC_K (k, 0, 0x9A, 0x4A, 0x92, 0xD3);
-		CALC_K (k, 2, 0x80, 0xE6, 0x78, 0x6B);
-		CALC_K (k, 4, 0xE4, 0x45, 0xDD, 0x7D);
-		CALC_K (k, 6, 0xD1, 0xE8, 0x38, 0x4B);
-		CALC_K (k, 8, 0x0D, 0xD6, 0xC6, 0x32);
-		CALC_K (k, 10, 0x35, 0xD8, 0x98, 0xFD);
-		CALC_K (k, 12, 0x18, 0x37, 0xF7, 0x71);
-		CALC_K (k, 14, 0xEC, 0xF1, 0x6C, 0xE1);
-		CALC_K (k, 16, 0x43, 0x30, 0x75, 0x0F);
-		CALC_K (k, 18, 0x37, 0xF8, 0x26, 0x1B);
-		CALC_K (k, 20, 0xFA, 0x87, 0x13, 0xFA);
-		CALC_K (k, 22, 0x94, 0x06, 0x48, 0x3F);
-		CALC_K (k, 24, 0xF2, 0x5E, 0xD0, 0xBA);
-		CALC_K (k, 26, 0x8B, 0xAE, 0x30, 0x5B);
-		CALC_K (k, 28, 0x84, 0x8A, 0x54, 0x00);
-		CALC_K (k, 30, 0xDF, 0xBC, 0x23, 0x9D);
+		/* Calculate whitening and round subkeys */
+		for ( i = 0; i < 8; i += 2 ) {
+			CALC_K (w, i, q0[i], q1[i], q0[i+1], q1[i+1]);
+		}
+		for ( i = 0; i < 32; i += 2 ) {
+			CALC_K (k, i, q0[i+8], q1[i+8], q0[i+9], q1[i+9]);
+		}
 	}
 
 	return 0;

--Boundary-00=_TGOIHpdGvvuLkoN--

From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Tue, 13 Nov 2007 15:34:33 -0700
Message-ID: <200711131534.33521.vda.linux@googlemail.com>
References: <200711071322.52630.vda.linux@googlemail.com> <20071113.150702.628183529.takamiya@po.ntts.co.jp> <20071113.152545.859492002.takamiya@po.ntts.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_5ZiOHpCMQ6YxOOY"
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:60228 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018AbXKMWem (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2007 17:34:42 -0500
Received: by an-out-0708.google.com with SMTP id b36so308222ana
        for <linux-crypto@vger.kernel.org>; Tue, 13 Nov 2007 14:34:40 -0800 (PST)
In-Reply-To: <20071113.152545.859492002.takamiya@po.ntts.co.jp>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_5ZiOHpCMQ6YxOOY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 12 November 2007 23:25, Noriaki TAKAMIYA wrote:
> Hi,
>
>   sorry, again.
>
> >> Tue, 13 Nov 2007 15:07:02 +0900 (JST)
> >> [Subject: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling,
> >> 64bit-ization] Noriaki TAKAMIYA <takamiya@po.ntts.co.jp> wrote...
> >>
> > > I'd like to hear the opinion of the author.
> > >
> > > Takamiya-san, what do you think about this change?
> >
> >   For IPsec processing, I think performance is important.
> >
> >   If this fix improves the performance, it is acceptable.
>
>   I misunderstood the meaning. If this fix decreases the performance,
>   I wouldn't prefer this patch(and the below is also one of the
>   reason).

My preferred solution is to make loop unrolling conditional on
CONFIG_CC_OPTIMIZE_FOR_SIZE - and this is what is done in my
(first) patch (see attached). This part:

+#ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
+       while (1) {
+               i -=3D 8;
+               ROUNDS(i);
+               if (i =3D=3D 0)
+                       break;
+               FLS(i);
+       }
+#else
+       if (i =3D=3D 32) {
+               ROUNDS(24);
+               FLS(24);
+       }
+       ROUNDS(16);
+       FLS(16);
+       ROUNDS(8);
+       FLS(8);
+       ROUNDS(0);
+#endif

Do you agree that this solution does not look too ugly
and would satisfy both "speed" and "size" camps?


=46or reference, size and speed numbers again:

All times are in microseconds. Two runs give some idea of test variability.
"Setup NN: NNNNNN NNNNNN" - time taken by 100000 key setups (two runs).
"Encrypt: NNNNNN NNNNNN" - time taken by 1000 encryptions of 8K buffer.
"Decrypt: NNNNNN NNNNNN" - time taken by 1000 decryptions of 8K buffer.
"(matches)" - encrypt/decrypt cycle produced non corrupted plaintext.

CONFIG_CC_OPTIMIZE_FOR_SIZE is not set:

$ ./camellia
Setup 16:32779 33169 Encrypt:153582 153740 Decrypt:150985 149811 (matches)
Setup 24:49333 48987 Encrypt:197973 198853 Decrypt:201240 197585 (matches)
Setup 32:46700 47680 Encrypt:195650 195800 Decrypt:195450 195469 (matches)
$ ./camellia5
Setup 16:33417 32968 Encrypt:149195 149095 Decrypt:148593 148661 (matches)
Setup 24:50082 50064 Encrypt:201214 199204 Decrypt:197078 197579 (matches)
Setup 32:48938 48824 Encrypt:200231 199545 Decrypt:198954 198996 (matches)
$ ./camellia_64
Setup 16:22247 22473 Encrypt:152321 149860 Decrypt:149058 148451 (matches)
Setup 24:33832 34017 Encrypt:200428 202969 Decrypt:196789 195524 (matches)
Setup 32:32884 32821 Encrypt:200414 200640 Decrypt:197857 195987 (matches)
$ size camellia.o camellia7.o camellia_64.o
=A0 =A0text =A0 =A0data =A0 =A0 bss =A0 =A0 dec =A0 =A0 hex filename
=A0 24586 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 24586 =A0 =A0600a camellia.o
=A0 21714 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 21714 =A0 =A054d2 camellia5.o
=A0 18666 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 18666 =A0 =A048ea camellia_64.o

Very small speed loss in camellia -> camellia5, noticeably smaller size.
Big key setup speedup in 64-bit camellia_64, and it is even smaller.

CONFIG_CC_OPTIMIZE_FOR_SIZE is set:

$ ./camellia_Os
Setup 16:32573 34985 Encrypt:151825 152011 Decrypt:147581 147630 (matches)
Setup 24:48528 49250 Encrypt:196223 199056 Decrypt:198811 196394 (matches)
Setup 32:46650 47538 Encrypt:197466 196412 Decrypt:196290 196550 (matches)
$ ./camellia5_Os
Setup 16:33360 34487 Encrypt:154718 154499 Decrypt:157432 157135 (matches)
Setup 24:53969 54304 Encrypt:205184 205818 Decrypt:210675 208552 (matches)
Setup 32:53064 52904 Encrypt:205350 205439 Decrypt:211654 208468 (matches)
$ ./camellia_64_Os
Setup 16:24696 25894 Encrypt:155903 155747 Decrypt:157385 155696 (matches)
Setup 24:33873 33230 Encrypt:206111 206385 Decrypt:208111 207650 (matches)
Setup 32:32799 32325 Encrypt:209715 205973 Decrypt:207578 207644 (matches)
$ size camellia_Os.o camellia7_Os.o camellia_64_Os.o
   text    data     bss     dec     hex filename
  24586       0       0   24586    600a camellia_Os.o
  15906       0       0   15906    3e22 camellia5_Os.o
  13098       0       0   13098    332a camellia_64_Os.o

~5% speed loss in camellia -> camellia5, much smaller size.
Big key setup speedup in 64-bit camellia_64, and it is even smaller still.
=2D-
vda

--Boundary-00=_5ZiOHpCMQ6YxOOY
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="camellia5.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="camellia5.diff"

--- linux-2.6.23.src/crypto/camellia4.c	2007-10-24 19:03:57.000000000 +0100
+++ linux-2.6.23.src/crypto/camellia.c	2007-10-25 11:57:16.000000000 +0100
@@ -36,6 +36,13 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#if BITS_PER_LONG >= 64
+
+/* Use alternative implementation with mostly 64-bit ops */
+#include "camellia_64.c"
+
+#else
+
 static const u32 camellia_sp1110[256] = {
 	0x70707000,0x82828200,0x2c2c2c00,0xececec00,
 	0xb3b3b300,0x27272700,0xc0c0c000,0xe5e5e500,
@@ -329,7 +336,6 @@ static const u32 camellia_sp4404[256] = 
 /*
  *  macros
  */
-
 # define GETU32(v, pt) \
     do { \
 	/* latest breed of gcc is clever enough to use move */ \
@@ -364,63 +370,28 @@ static const u32 camellia_sp4404[256] = 
     } while(0)
 
 
+/*
+ * Key setup
+ */
 #define CAMELLIA_F(xl, xr, kl, kr, yl, yr, il, ir, t0, t1)	\
     do {							\
 	il = xl ^ kl;						\
 	ir = xr ^ kr;						\
 	t0 = il >> 16;						\
 	t1 = ir >> 16;						\
-	yl = camellia_sp1110[ir & 0xff]				\
-	   ^ camellia_sp0222[(t1 >> 8) & 0xff]			\
-	   ^ camellia_sp3033[t1 & 0xff]				\
-	   ^ camellia_sp4404[(ir >> 8) & 0xff];			\
-	yr = camellia_sp1110[(t0 >> 8) & 0xff]			\
-	   ^ camellia_sp0222[t0 & 0xff]				\
-	   ^ camellia_sp3033[(il >> 8) & 0xff]			\
-	   ^ camellia_sp4404[il & 0xff];			\
+	yl = camellia_sp1110[(u8)(ir     )]			\
+	   ^ camellia_sp0222[    (t1 >> 8)]			\
+	   ^ camellia_sp3033[(u8)(t1     )]			\
+	   ^ camellia_sp4404[(u8)(ir >> 8)];			\
+	yr = camellia_sp1110[    (t0 >> 8)]			\
+	   ^ camellia_sp0222[(u8)(t0     )]			\
+	   ^ camellia_sp3033[(u8)(il >> 8)]			\
+	   ^ camellia_sp4404[(u8)(il     )];			\
 	yl ^= yr;						\
 	yr = ROR8(yr);						\
 	yr ^= yl;						\
     } while(0)
 
-
-/*
- * for speed up
- *
- */
-#define CAMELLIA_FLS(ll, lr, rl, rr, kll, klr, krl, krr, t0, t1, t2, t3) \
-    do {								\
-	t0 = kll;							\
-	t2 = krr;							\
-	t0 &= ll;							\
-	t2 |= rr;							\
-	rl ^= t2;							\
-	lr ^= ROL1(t0);							\
-	t3 = krl;							\
-	t1 = klr;							\
-	t3 &= rl;							\
-	t1 |= lr;							\
-	ll ^= t1;							\
-	rr ^= ROL1(t3);							\
-    } while(0)
-
-#define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir, t0, t1)	\
-    do {								\
-	ir =  camellia_sp1110[xr & 0xff];				\
-	il =  camellia_sp1110[(xl>>24) & 0xff];				\
-	ir ^= camellia_sp0222[(xr>>24) & 0xff];				\
-	il ^= camellia_sp0222[(xl>>16) & 0xff];				\
-	ir ^= camellia_sp3033[(xr>>16) & 0xff];				\
-	il ^= camellia_sp3033[(xl>>8) & 0xff];				\
-	ir ^= camellia_sp4404[(xr>>8) & 0xff];				\
-	il ^= camellia_sp4404[xl & 0xff];				\
-	il ^= kl;							\
-	ir ^= il ^ kr;							\
-	yl ^= ir;							\
-	yr ^= ROR8(il) ^ ir;						\
-    } while(0)
-
-
 #define SUBKEY_L(INDEX) (subkey[(INDEX)*2])
 #define SUBKEY_R(INDEX) (subkey[(INDEX)*2 + 1])
 
@@ -622,7 +593,7 @@ static void camellia_setup128(const unsi
 	SUBKEY_L(6) = subL[5] ^ subL[7]; /* round 5 */
 	SUBKEY_R(6) = subR[5] ^ subR[7];
 	tl = subL[10] ^ (subR[10] & ~subR[8]);
-	dw = tl & subL[8],  /* FL(kl1) */
+	dw = tl & subL[8];  /* FL(kl1) */
 		tr = subR[10] ^ ROL1(dw);
 	SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
 	SUBKEY_R(7) = subR[6] ^ tr;
@@ -1000,400 +971,173 @@ static void camellia_setup192(const unsi
 }
 
 
-static void camellia_encrypt128(const u32 *subkey, u32 *io_text)
-{
-	u32 il,ir,t0,t1;               /* temporary variables */
-
-	u32 io[4];
-
-	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(0);
-	io[1] = io_text[1] ^ SUBKEY_R(0);
-	io[2] = io_text[2];
-	io[3] = io_text[3];
-
-	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[0],io[1],il,ir,t0,t1);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[0],io[1],il,ir,t0,t1);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[0],io[1],il,ir,t0,t1);
+/*
+ * Encrypt/decrypt
+ */
+#define CAMELLIA_FLS(ll, lr, rl, rr, kll, klr, krl, krr, t0, t1, t2, t3) \
+    do {								\
+	t0 = kll;							\
+	t2 = krr;							\
+	t0 &= ll;							\
+	t2 |= rr;							\
+	rl ^= t2;							\
+	lr ^= ROL1(t0);							\
+	t3 = krl;							\
+	t1 = klr;							\
+	t3 &= rl;							\
+	t1 |= lr;							\
+	ll ^= t1;							\
+	rr ^= ROL1(t3);							\
+    } while(0)
 
-	/* post whitening but kw4 */
-	io_text[0] = io[2] ^ SUBKEY_L(24);
-	io_text[1] = io[3] ^ SUBKEY_R(24);
-	io_text[2] = io[0];
-	io_text[3] = io[1];
-}
+#define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir)		\
+    do {								\
+	ir =  camellia_sp1110[(u8)xr];					\
+	il =  camellia_sp1110[    (xl >> 24)];				\
+	ir ^= camellia_sp0222[    (xr >> 24)];				\
+	il ^= camellia_sp0222[(u8)(xl >> 16)];				\
+	ir ^= camellia_sp3033[(u8)(xr >> 16)];				\
+	il ^= camellia_sp3033[(u8)(xl >> 8)];				\
+	ir ^= camellia_sp4404[(u8)(xr >> 8)];				\
+	il ^= camellia_sp4404[(u8)xl];					\
+	il ^= kl;							\
+	ir ^= il ^ kr;							\
+	yl ^= ir;							\
+	yr ^= ROR8(il) ^ ir;						\
+    } while(0)
 
-static void camellia_decrypt128(const u32 *subkey, u32 *io_text)
+/* max = 24: 128bit encrypt, max = 32: 256bit encrypt */
+static void camellia_do_encrypt(const u32 *subkey, u32 *io, unsigned max)
 {
 	u32 il,ir,t0,t1;               /* temporary variables */
 
-	u32 io[4];
-
 	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(24);
-	io[1] = io_text[1] ^ SUBKEY_R(24);
-	io[2] = io_text[2];
-	io[3] = io_text[3];
+	io[0] ^= SUBKEY_L(0);
+	io[1] ^= SUBKEY_R(0);
 
 	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[0],io[1],il,ir,t0,t1);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[0],io[1],il,ir,t0,t1);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[0],io[1],il,ir,t0,t1);
-
-	/* post whitening but kw4 */
-	io_text[0] = io[2] ^ SUBKEY_L(0);
-	io_text[1] = io[3] ^ SUBKEY_R(0);
-	io_text[2] = io[0];
-	io_text[3] = io[1];
-}
-
-static void camellia_encrypt256(const u32 *subkey, u32 *io_text)
-{
-	u32 il,ir,t0,t1;           /* temporary variables */
-
-	u32 io[4];
-
-	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(0);
-	io[1] = io_text[1] ^ SUBKEY_R(0);
-	io[2] = io_text[2];
-	io[3] = io_text[3];
+#define ROUNDS(i) do { \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 2),SUBKEY_R(i + 2), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 3),SUBKEY_R(i + 3), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 4),SUBKEY_R(i + 4), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 5),SUBKEY_R(i + 5), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 6),SUBKEY_R(i + 6), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 7),SUBKEY_R(i + 7), \
+			 io[0],io[1],il,ir); \
+} while (0)
+#define FLS(i) do { \
+	CAMELLIA_FLS(io[0],io[1],io[2],io[3], \
+		     SUBKEY_L(i + 0),SUBKEY_R(i + 0), \
+		     SUBKEY_L(i + 1),SUBKEY_R(i + 1), \
+		     t0,t1,il,ir); \
+} while (0)
+
+#ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
+	{
+		unsigned i = 0;
+		while (1) {
+			ROUNDS(i);
+			i += 8;
+			if (i >= max)
+				break;
+			FLS(i);
+		}
+	}
+#else
+	ROUNDS(0);
+	FLS(8);
+	ROUNDS(8);
+	FLS(16);
+	ROUNDS(16);
+	if (max == 32) {
+		FLS(24);
+		ROUNDS(24);
+	}
+#endif
 
-	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[0],io[1],il,ir,t0,t1);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[0],io[1],il,ir,t0,t1);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[0],io[1],il,ir,t0,t1);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(24),SUBKEY_R(24),
-		     SUBKEY_L(25),SUBKEY_R(25),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(26),SUBKEY_R(26),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(27),SUBKEY_R(27),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(28),SUBKEY_R(28),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(29),SUBKEY_R(29),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(30),SUBKEY_R(30),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(31),SUBKEY_R(31),
-			 io[0],io[1],il,ir,t0,t1);
+#undef ROUNDS
+#undef FLS
 
 	/* post whitening but kw4 */
-	io_text[0] = io[2] ^ SUBKEY_L(32);
-	io_text[1] = io[3] ^ SUBKEY_R(32);
-	io_text[2] = io[0];
-	io_text[3] = io[1];
+	io[2] ^= SUBKEY_L(max);
+	io[3] ^= SUBKEY_R(max);
+	/* NB: io[0],[1] should be swapped with [2],[3] by caller! */
 }
 
-static void camellia_decrypt256(const u32 *subkey, u32 *io_text)
+static void camellia_do_decrypt(const u32 *subkey, u32 *io, unsigned i)
 {
-	u32 il,ir,t0,t1;           /* temporary variables */
-
-	u32 io[4];
+	u32 il,ir,t0,t1;               /* temporary variables */
 
 	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(32);
-	io[1] = io_text[1] ^ SUBKEY_R(32);
-	io[2] = io_text[2];
-	io[3] = io_text[3];
+	io[0] ^= SUBKEY_L(i);
+	io[1] ^= SUBKEY_R(i);
 
 	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(31),SUBKEY_R(31),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(30),SUBKEY_R(30),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(29),SUBKEY_R(29),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(28),SUBKEY_R(28),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(27),SUBKEY_R(27),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(26),SUBKEY_R(26),
-			 io[0],io[1],il,ir,t0,t1);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(25),SUBKEY_R(25),
-		     SUBKEY_L(24),SUBKEY_R(24),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[0],io[1],il,ir,t0,t1);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[0],io[1],il,ir,t0,t1);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[0],io[1],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[2],io[3],il,ir,t0,t1);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[0],io[1],il,ir,t0,t1);
+#define ROUNDS(i) do { \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 7),SUBKEY_R(i + 7), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 6),SUBKEY_R(i + 6), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 5),SUBKEY_R(i + 5), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 4),SUBKEY_R(i + 4), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 3),SUBKEY_R(i + 3), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 2),SUBKEY_R(i + 2), \
+			 io[0],io[1],il,ir); \
+} while (0)
+#define FLS(i) do { \
+	CAMELLIA_FLS(io[0],io[1],io[2],io[3], \
+		     SUBKEY_L(i + 1),SUBKEY_R(i + 1), \
+		     SUBKEY_L(i + 0),SUBKEY_R(i + 0), \
+		     t0,t1,il,ir); \
+} while (0)
+
+#ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
+	while (1) {
+		i -= 8;
+		ROUNDS(i);
+		if (i == 0)
+			break;
+		FLS(i);
+	}
+#else
+	if (i == 32) {
+		ROUNDS(24);
+		FLS(24);
+	}
+	ROUNDS(16);
+	FLS(16);
+	ROUNDS(8);
+	FLS(8);
+	ROUNDS(0);
+#endif
+
+#undef ROUNDS
+#undef FLS
 
 	/* post whitening but kw4 */
-	io_text[0] = io[2] ^ SUBKEY_L(0);
-	io_text[1] = io[3] ^ SUBKEY_R(0);
-	io_text[2] = io[0];
-	io_text[3] = io[1];
+	io[2] ^= SUBKEY_L(0);
+	io[3] ^= SUBKEY_R(0);
+	/* NB: 0,1 should be swapped with 2,3 by caller! */
 }
 
 
@@ -1445,21 +1189,15 @@ static void camellia_encrypt(struct cryp
 	tmp[2] = be32_to_cpu(src[2]);
 	tmp[3] = be32_to_cpu(src[3]);
 
-	switch (cctx->key_length) {
-	case 16:
-		camellia_encrypt128(cctx->key_table, tmp);
-		break;
-	case 24:
-		/* fall through */
-	case 32:
-		camellia_encrypt256(cctx->key_table, tmp);
-		break;
-	}
-
-	dst[0] = cpu_to_be32(tmp[0]);
-	dst[1] = cpu_to_be32(tmp[1]);
-	dst[2] = cpu_to_be32(tmp[2]);
-	dst[3] = cpu_to_be32(tmp[3]);
+	camellia_do_encrypt(cctx->key_table, tmp,
+		cctx->key_length == 16 ? 24 : 32 /* for key lengths of 24 and 32 */
+	);
+
+	/* do_encrypt returns 0,1 swapped with 2,3 */
+	dst[0] = cpu_to_be32(tmp[2]);
+	dst[1] = cpu_to_be32(tmp[3]);
+	dst[2] = cpu_to_be32(tmp[0]);
+	dst[3] = cpu_to_be32(tmp[1]);
 }
 
 static void camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
@@ -1475,21 +1213,15 @@ static void camellia_decrypt(struct cryp
 	tmp[2] = be32_to_cpu(src[2]);
 	tmp[3] = be32_to_cpu(src[3]);
 
-	switch (cctx->key_length) {
-	case 16:
-		camellia_decrypt128(cctx->key_table, tmp);
-		break;
-	case 24:
-		/* fall through */
-	case 32:
-		camellia_decrypt256(cctx->key_table, tmp);
-		break;
-	}
-
-	dst[0] = cpu_to_be32(tmp[0]);
-	dst[1] = cpu_to_be32(tmp[1]);
-	dst[2] = cpu_to_be32(tmp[2]);
-	dst[3] = cpu_to_be32(tmp[3]);
+	camellia_do_decrypt(cctx->key_table, tmp,
+		cctx->key_length == 16 ? 24 : 32 /* for key lengths of 24 and 32 */
+	);
+
+	/* do_decrypt returns 0,1 swapped with 2,3 */
+	dst[0] = cpu_to_be32(tmp[2]);
+	dst[1] = cpu_to_be32(tmp[3]);
+	dst[2] = cpu_to_be32(tmp[0]);
+	dst[3] = cpu_to_be32(tmp[1]);
 }
 
 static struct crypto_alg camellia_alg = {
@@ -1528,3 +1260,5 @@ module_exit(camellia_fini);
 
 MODULE_DESCRIPTION("Camellia Cipher Algorithm");
 MODULE_LICENSE("GPL");
+
+#endif /* if BITS_PER_LONG < 64 */
--- /dev/null	2006-05-22 15:25:23.000000000 +0100
+++ linux-2.6.23.src/crypto/camellia_64.c	2007-10-25 12:32:16.000000000 +0100
@@ -0,0 +1,1172 @@
+/*
+ * Copyright (C) 2006
+ * NTT (Nippon Telegraph and Telephone Corporation).
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/*
+ * Algorithm Specification
+ *  http://info.isl.ntt.co.jp/crypt/eng/camellia/specifications.html
+ */
+
+/*
+ *
+ * NOTE --- NOTE --- NOTE --- NOTE
+ * This implementation assumes that all memory addresses passed
+ * as parameters are four-byte aligned.
+ *
+ */
+
+/* #included from camellia.c if long is 64bit */
+
+/*
+#include <linux/crypto.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+*/
+
+static const u32 camellia_sp1110[256] = {
+	0x70707000,0x82828200,0x2c2c2c00,0xececec00,
+	0xb3b3b300,0x27272700,0xc0c0c000,0xe5e5e500,
+	0xe4e4e400,0x85858500,0x57575700,0x35353500,
+	0xeaeaea00,0x0c0c0c00,0xaeaeae00,0x41414100,
+	0x23232300,0xefefef00,0x6b6b6b00,0x93939300,
+	0x45454500,0x19191900,0xa5a5a500,0x21212100,
+	0xededed00,0x0e0e0e00,0x4f4f4f00,0x4e4e4e00,
+	0x1d1d1d00,0x65656500,0x92929200,0xbdbdbd00,
+	0x86868600,0xb8b8b800,0xafafaf00,0x8f8f8f00,
+	0x7c7c7c00,0xebebeb00,0x1f1f1f00,0xcecece00,
+	0x3e3e3e00,0x30303000,0xdcdcdc00,0x5f5f5f00,
+	0x5e5e5e00,0xc5c5c500,0x0b0b0b00,0x1a1a1a00,
+	0xa6a6a600,0xe1e1e100,0x39393900,0xcacaca00,
+	0xd5d5d500,0x47474700,0x5d5d5d00,0x3d3d3d00,
+	0xd9d9d900,0x01010100,0x5a5a5a00,0xd6d6d600,
+	0x51515100,0x56565600,0x6c6c6c00,0x4d4d4d00,
+	0x8b8b8b00,0x0d0d0d00,0x9a9a9a00,0x66666600,
+	0xfbfbfb00,0xcccccc00,0xb0b0b000,0x2d2d2d00,
+	0x74747400,0x12121200,0x2b2b2b00,0x20202000,
+	0xf0f0f000,0xb1b1b100,0x84848400,0x99999900,
+	0xdfdfdf00,0x4c4c4c00,0xcbcbcb00,0xc2c2c200,
+	0x34343400,0x7e7e7e00,0x76767600,0x05050500,
+	0x6d6d6d00,0xb7b7b700,0xa9a9a900,0x31313100,
+	0xd1d1d100,0x17171700,0x04040400,0xd7d7d700,
+	0x14141400,0x58585800,0x3a3a3a00,0x61616100,
+	0xdedede00,0x1b1b1b00,0x11111100,0x1c1c1c00,
+	0x32323200,0x0f0f0f00,0x9c9c9c00,0x16161600,
+	0x53535300,0x18181800,0xf2f2f200,0x22222200,
+	0xfefefe00,0x44444400,0xcfcfcf00,0xb2b2b200,
+	0xc3c3c300,0xb5b5b500,0x7a7a7a00,0x91919100,
+	0x24242400,0x08080800,0xe8e8e800,0xa8a8a800,
+	0x60606000,0xfcfcfc00,0x69696900,0x50505000,
+	0xaaaaaa00,0xd0d0d000,0xa0a0a000,0x7d7d7d00,
+	0xa1a1a100,0x89898900,0x62626200,0x97979700,
+	0x54545400,0x5b5b5b00,0x1e1e1e00,0x95959500,
+	0xe0e0e000,0xffffff00,0x64646400,0xd2d2d200,
+	0x10101000,0xc4c4c400,0x00000000,0x48484800,
+	0xa3a3a300,0xf7f7f700,0x75757500,0xdbdbdb00,
+	0x8a8a8a00,0x03030300,0xe6e6e600,0xdadada00,
+	0x09090900,0x3f3f3f00,0xdddddd00,0x94949400,
+	0x87878700,0x5c5c5c00,0x83838300,0x02020200,
+	0xcdcdcd00,0x4a4a4a00,0x90909000,0x33333300,
+	0x73737300,0x67676700,0xf6f6f600,0xf3f3f300,
+	0x9d9d9d00,0x7f7f7f00,0xbfbfbf00,0xe2e2e200,
+	0x52525200,0x9b9b9b00,0xd8d8d800,0x26262600,
+	0xc8c8c800,0x37373700,0xc6c6c600,0x3b3b3b00,
+	0x81818100,0x96969600,0x6f6f6f00,0x4b4b4b00,
+	0x13131300,0xbebebe00,0x63636300,0x2e2e2e00,
+	0xe9e9e900,0x79797900,0xa7a7a700,0x8c8c8c00,
+	0x9f9f9f00,0x6e6e6e00,0xbcbcbc00,0x8e8e8e00,
+	0x29292900,0xf5f5f500,0xf9f9f900,0xb6b6b600,
+	0x2f2f2f00,0xfdfdfd00,0xb4b4b400,0x59595900,
+	0x78787800,0x98989800,0x06060600,0x6a6a6a00,
+	0xe7e7e700,0x46464600,0x71717100,0xbababa00,
+	0xd4d4d400,0x25252500,0xababab00,0x42424200,
+	0x88888800,0xa2a2a200,0x8d8d8d00,0xfafafa00,
+	0x72727200,0x07070700,0xb9b9b900,0x55555500,
+	0xf8f8f800,0xeeeeee00,0xacacac00,0x0a0a0a00,
+	0x36363600,0x49494900,0x2a2a2a00,0x68686800,
+	0x3c3c3c00,0x38383800,0xf1f1f100,0xa4a4a400,
+	0x40404000,0x28282800,0xd3d3d300,0x7b7b7b00,
+	0xbbbbbb00,0xc9c9c900,0x43434300,0xc1c1c100,
+	0x15151500,0xe3e3e300,0xadadad00,0xf4f4f400,
+	0x77777700,0xc7c7c700,0x80808000,0x9e9e9e00,
+};
+
+static const u32 camellia_sp0222[256] = {
+	0x00e0e0e0,0x00050505,0x00585858,0x00d9d9d9,
+	0x00676767,0x004e4e4e,0x00818181,0x00cbcbcb,
+	0x00c9c9c9,0x000b0b0b,0x00aeaeae,0x006a6a6a,
+	0x00d5d5d5,0x00181818,0x005d5d5d,0x00828282,
+	0x00464646,0x00dfdfdf,0x00d6d6d6,0x00272727,
+	0x008a8a8a,0x00323232,0x004b4b4b,0x00424242,
+	0x00dbdbdb,0x001c1c1c,0x009e9e9e,0x009c9c9c,
+	0x003a3a3a,0x00cacaca,0x00252525,0x007b7b7b,
+	0x000d0d0d,0x00717171,0x005f5f5f,0x001f1f1f,
+	0x00f8f8f8,0x00d7d7d7,0x003e3e3e,0x009d9d9d,
+	0x007c7c7c,0x00606060,0x00b9b9b9,0x00bebebe,
+	0x00bcbcbc,0x008b8b8b,0x00161616,0x00343434,
+	0x004d4d4d,0x00c3c3c3,0x00727272,0x00959595,
+	0x00ababab,0x008e8e8e,0x00bababa,0x007a7a7a,
+	0x00b3b3b3,0x00020202,0x00b4b4b4,0x00adadad,
+	0x00a2a2a2,0x00acacac,0x00d8d8d8,0x009a9a9a,
+	0x00171717,0x001a1a1a,0x00353535,0x00cccccc,
+	0x00f7f7f7,0x00999999,0x00616161,0x005a5a5a,
+	0x00e8e8e8,0x00242424,0x00565656,0x00404040,
+	0x00e1e1e1,0x00636363,0x00090909,0x00333333,
+	0x00bfbfbf,0x00989898,0x00979797,0x00858585,
+	0x00686868,0x00fcfcfc,0x00ececec,0x000a0a0a,
+	0x00dadada,0x006f6f6f,0x00535353,0x00626262,
+	0x00a3a3a3,0x002e2e2e,0x00080808,0x00afafaf,
+	0x00282828,0x00b0b0b0,0x00747474,0x00c2c2c2,
+	0x00bdbdbd,0x00363636,0x00222222,0x00383838,
+	0x00646464,0x001e1e1e,0x00393939,0x002c2c2c,
+	0x00a6a6a6,0x00303030,0x00e5e5e5,0x00444444,
+	0x00fdfdfd,0x00888888,0x009f9f9f,0x00656565,
+	0x00878787,0x006b6b6b,0x00f4f4f4,0x00232323,
+	0x00484848,0x00101010,0x00d1d1d1,0x00515151,
+	0x00c0c0c0,0x00f9f9f9,0x00d2d2d2,0x00a0a0a0,
+	0x00555555,0x00a1a1a1,0x00414141,0x00fafafa,
+	0x00434343,0x00131313,0x00c4c4c4,0x002f2f2f,
+	0x00a8a8a8,0x00b6b6b6,0x003c3c3c,0x002b2b2b,
+	0x00c1c1c1,0x00ffffff,0x00c8c8c8,0x00a5a5a5,
+	0x00202020,0x00898989,0x00000000,0x00909090,
+	0x00474747,0x00efefef,0x00eaeaea,0x00b7b7b7,
+	0x00151515,0x00060606,0x00cdcdcd,0x00b5b5b5,
+	0x00121212,0x007e7e7e,0x00bbbbbb,0x00292929,
+	0x000f0f0f,0x00b8b8b8,0x00070707,0x00040404,
+	0x009b9b9b,0x00949494,0x00212121,0x00666666,
+	0x00e6e6e6,0x00cecece,0x00ededed,0x00e7e7e7,
+	0x003b3b3b,0x00fefefe,0x007f7f7f,0x00c5c5c5,
+	0x00a4a4a4,0x00373737,0x00b1b1b1,0x004c4c4c,
+	0x00919191,0x006e6e6e,0x008d8d8d,0x00767676,
+	0x00030303,0x002d2d2d,0x00dedede,0x00969696,
+	0x00262626,0x007d7d7d,0x00c6c6c6,0x005c5c5c,
+	0x00d3d3d3,0x00f2f2f2,0x004f4f4f,0x00191919,
+	0x003f3f3f,0x00dcdcdc,0x00797979,0x001d1d1d,
+	0x00525252,0x00ebebeb,0x00f3f3f3,0x006d6d6d,
+	0x005e5e5e,0x00fbfbfb,0x00696969,0x00b2b2b2,
+	0x00f0f0f0,0x00313131,0x000c0c0c,0x00d4d4d4,
+	0x00cfcfcf,0x008c8c8c,0x00e2e2e2,0x00757575,
+	0x00a9a9a9,0x004a4a4a,0x00575757,0x00848484,
+	0x00111111,0x00454545,0x001b1b1b,0x00f5f5f5,
+	0x00e4e4e4,0x000e0e0e,0x00737373,0x00aaaaaa,
+	0x00f1f1f1,0x00dddddd,0x00595959,0x00141414,
+	0x006c6c6c,0x00929292,0x00545454,0x00d0d0d0,
+	0x00787878,0x00707070,0x00e3e3e3,0x00494949,
+	0x00808080,0x00505050,0x00a7a7a7,0x00f6f6f6,
+	0x00777777,0x00939393,0x00868686,0x00838383,
+	0x002a2a2a,0x00c7c7c7,0x005b5b5b,0x00e9e9e9,
+	0x00eeeeee,0x008f8f8f,0x00010101,0x003d3d3d,
+};
+
+static const u32 camellia_sp3033[256] = {
+	0x38003838,0x41004141,0x16001616,0x76007676,
+	0xd900d9d9,0x93009393,0x60006060,0xf200f2f2,
+	0x72007272,0xc200c2c2,0xab00abab,0x9a009a9a,
+	0x75007575,0x06000606,0x57005757,0xa000a0a0,
+	0x91009191,0xf700f7f7,0xb500b5b5,0xc900c9c9,
+	0xa200a2a2,0x8c008c8c,0xd200d2d2,0x90009090,
+	0xf600f6f6,0x07000707,0xa700a7a7,0x27002727,
+	0x8e008e8e,0xb200b2b2,0x49004949,0xde00dede,
+	0x43004343,0x5c005c5c,0xd700d7d7,0xc700c7c7,
+	0x3e003e3e,0xf500f5f5,0x8f008f8f,0x67006767,
+	0x1f001f1f,0x18001818,0x6e006e6e,0xaf00afaf,
+	0x2f002f2f,0xe200e2e2,0x85008585,0x0d000d0d,
+	0x53005353,0xf000f0f0,0x9c009c9c,0x65006565,
+	0xea00eaea,0xa300a3a3,0xae00aeae,0x9e009e9e,
+	0xec00ecec,0x80008080,0x2d002d2d,0x6b006b6b,
+	0xa800a8a8,0x2b002b2b,0x36003636,0xa600a6a6,
+	0xc500c5c5,0x86008686,0x4d004d4d,0x33003333,
+	0xfd00fdfd,0x66006666,0x58005858,0x96009696,
+	0x3a003a3a,0x09000909,0x95009595,0x10001010,
+	0x78007878,0xd800d8d8,0x42004242,0xcc00cccc,
+	0xef00efef,0x26002626,0xe500e5e5,0x61006161,
+	0x1a001a1a,0x3f003f3f,0x3b003b3b,0x82008282,
+	0xb600b6b6,0xdb00dbdb,0xd400d4d4,0x98009898,
+	0xe800e8e8,0x8b008b8b,0x02000202,0xeb00ebeb,
+	0x0a000a0a,0x2c002c2c,0x1d001d1d,0xb000b0b0,
+	0x6f006f6f,0x8d008d8d,0x88008888,0x0e000e0e,
+	0x19001919,0x87008787,0x4e004e4e,0x0b000b0b,
+	0xa900a9a9,0x0c000c0c,0x79007979,0x11001111,
+	0x7f007f7f,0x22002222,0xe700e7e7,0x59005959,
+	0xe100e1e1,0xda00dada,0x3d003d3d,0xc800c8c8,
+	0x12001212,0x04000404,0x74007474,0x54005454,
+	0x30003030,0x7e007e7e,0xb400b4b4,0x28002828,
+	0x55005555,0x68006868,0x50005050,0xbe00bebe,
+	0xd000d0d0,0xc400c4c4,0x31003131,0xcb00cbcb,
+	0x2a002a2a,0xad00adad,0x0f000f0f,0xca00caca,
+	0x70007070,0xff00ffff,0x32003232,0x69006969,
+	0x08000808,0x62006262,0x00000000,0x24002424,
+	0xd100d1d1,0xfb00fbfb,0xba00baba,0xed00eded,
+	0x45004545,0x81008181,0x73007373,0x6d006d6d,
+	0x84008484,0x9f009f9f,0xee00eeee,0x4a004a4a,
+	0xc300c3c3,0x2e002e2e,0xc100c1c1,0x01000101,
+	0xe600e6e6,0x25002525,0x48004848,0x99009999,
+	0xb900b9b9,0xb300b3b3,0x7b007b7b,0xf900f9f9,
+	0xce00cece,0xbf00bfbf,0xdf00dfdf,0x71007171,
+	0x29002929,0xcd00cdcd,0x6c006c6c,0x13001313,
+	0x64006464,0x9b009b9b,0x63006363,0x9d009d9d,
+	0xc000c0c0,0x4b004b4b,0xb700b7b7,0xa500a5a5,
+	0x89008989,0x5f005f5f,0xb100b1b1,0x17001717,
+	0xf400f4f4,0xbc00bcbc,0xd300d3d3,0x46004646,
+	0xcf00cfcf,0x37003737,0x5e005e5e,0x47004747,
+	0x94009494,0xfa00fafa,0xfc00fcfc,0x5b005b5b,
+	0x97009797,0xfe00fefe,0x5a005a5a,0xac00acac,
+	0x3c003c3c,0x4c004c4c,0x03000303,0x35003535,
+	0xf300f3f3,0x23002323,0xb800b8b8,0x5d005d5d,
+	0x6a006a6a,0x92009292,0xd500d5d5,0x21002121,
+	0x44004444,0x51005151,0xc600c6c6,0x7d007d7d,
+	0x39003939,0x83008383,0xdc00dcdc,0xaa00aaaa,
+	0x7c007c7c,0x77007777,0x56005656,0x05000505,
+	0x1b001b1b,0xa400a4a4,0x15001515,0x34003434,
+	0x1e001e1e,0x1c001c1c,0xf800f8f8,0x52005252,
+	0x20002020,0x14001414,0xe900e9e9,0xbd00bdbd,
+	0xdd00dddd,0xe400e4e4,0xa100a1a1,0xe000e0e0,
+	0x8a008a8a,0xf100f1f1,0xd600d6d6,0x7a007a7a,
+	0xbb00bbbb,0xe300e3e3,0x40004040,0x4f004f4f,
+};
+
+static const u32 camellia_sp4404[256] = {
+	0x70700070,0x2c2c002c,0xb3b300b3,0xc0c000c0,
+	0xe4e400e4,0x57570057,0xeaea00ea,0xaeae00ae,
+	0x23230023,0x6b6b006b,0x45450045,0xa5a500a5,
+	0xeded00ed,0x4f4f004f,0x1d1d001d,0x92920092,
+	0x86860086,0xafaf00af,0x7c7c007c,0x1f1f001f,
+	0x3e3e003e,0xdcdc00dc,0x5e5e005e,0x0b0b000b,
+	0xa6a600a6,0x39390039,0xd5d500d5,0x5d5d005d,
+	0xd9d900d9,0x5a5a005a,0x51510051,0x6c6c006c,
+	0x8b8b008b,0x9a9a009a,0xfbfb00fb,0xb0b000b0,
+	0x74740074,0x2b2b002b,0xf0f000f0,0x84840084,
+	0xdfdf00df,0xcbcb00cb,0x34340034,0x76760076,
+	0x6d6d006d,0xa9a900a9,0xd1d100d1,0x04040004,
+	0x14140014,0x3a3a003a,0xdede00de,0x11110011,
+	0x32320032,0x9c9c009c,0x53530053,0xf2f200f2,
+	0xfefe00fe,0xcfcf00cf,0xc3c300c3,0x7a7a007a,
+	0x24240024,0xe8e800e8,0x60600060,0x69690069,
+	0xaaaa00aa,0xa0a000a0,0xa1a100a1,0x62620062,
+	0x54540054,0x1e1e001e,0xe0e000e0,0x64640064,
+	0x10100010,0x00000000,0xa3a300a3,0x75750075,
+	0x8a8a008a,0xe6e600e6,0x09090009,0xdddd00dd,
+	0x87870087,0x83830083,0xcdcd00cd,0x90900090,
+	0x73730073,0xf6f600f6,0x9d9d009d,0xbfbf00bf,
+	0x52520052,0xd8d800d8,0xc8c800c8,0xc6c600c6,
+	0x81810081,0x6f6f006f,0x13130013,0x63630063,
+	0xe9e900e9,0xa7a700a7,0x9f9f009f,0xbcbc00bc,
+	0x29290029,0xf9f900f9,0x2f2f002f,0xb4b400b4,
+	0x78780078,0x06060006,0xe7e700e7,0x71710071,
+	0xd4d400d4,0xabab00ab,0x88880088,0x8d8d008d,
+	0x72720072,0xb9b900b9,0xf8f800f8,0xacac00ac,
+	0x36360036,0x2a2a002a,0x3c3c003c,0xf1f100f1,
+	0x40400040,0xd3d300d3,0xbbbb00bb,0x43430043,
+	0x15150015,0xadad00ad,0x77770077,0x80800080,
+	0x82820082,0xecec00ec,0x27270027,0xe5e500e5,
+	0x85850085,0x35350035,0x0c0c000c,0x41410041,
+	0xefef00ef,0x93930093,0x19190019,0x21210021,
+	0x0e0e000e,0x4e4e004e,0x65650065,0xbdbd00bd,
+	0xb8b800b8,0x8f8f008f,0xebeb00eb,0xcece00ce,
+	0x30300030,0x5f5f005f,0xc5c500c5,0x1a1a001a,
+	0xe1e100e1,0xcaca00ca,0x47470047,0x3d3d003d,
+	0x01010001,0xd6d600d6,0x56560056,0x4d4d004d,
+	0x0d0d000d,0x66660066,0xcccc00cc,0x2d2d002d,
+	0x12120012,0x20200020,0xb1b100b1,0x99990099,
+	0x4c4c004c,0xc2c200c2,0x7e7e007e,0x05050005,
+	0xb7b700b7,0x31310031,0x17170017,0xd7d700d7,
+	0x58580058,0x61610061,0x1b1b001b,0x1c1c001c,
+	0x0f0f000f,0x16160016,0x18180018,0x22220022,
+	0x44440044,0xb2b200b2,0xb5b500b5,0x91910091,
+	0x08080008,0xa8a800a8,0xfcfc00fc,0x50500050,
+	0xd0d000d0,0x7d7d007d,0x89890089,0x97970097,
+	0x5b5b005b,0x95950095,0xffff00ff,0xd2d200d2,
+	0xc4c400c4,0x48480048,0xf7f700f7,0xdbdb00db,
+	0x03030003,0xdada00da,0x3f3f003f,0x94940094,
+	0x5c5c005c,0x02020002,0x4a4a004a,0x33330033,
+	0x67670067,0xf3f300f3,0x7f7f007f,0xe2e200e2,
+	0x9b9b009b,0x26260026,0x37370037,0x3b3b003b,
+	0x96960096,0x4b4b004b,0xbebe00be,0x2e2e002e,
+	0x79790079,0x8c8c008c,0x6e6e006e,0x8e8e008e,
+	0xf5f500f5,0xb6b600b6,0xfdfd00fd,0x59590059,
+	0x98980098,0x6a6a006a,0x46460046,0xbaba00ba,
+	0x25250025,0x42420042,0xa2a200a2,0xfafa00fa,
+	0x07070007,0x55550055,0xeeee00ee,0x0a0a000a,
+	0x49490049,0x68680068,0x38380038,0xa4a400a4,
+	0x28280028,0x7b7b007b,0xc9c900c9,0xc1c100c1,
+	0xe3e300e3,0xf4f400f4,0xc7c700c7,0x9e9e009e,
+};
+
+
+#define CAMELLIA_MIN_KEY_SIZE        16
+#define CAMELLIA_MAX_KEY_SIZE        32
+#define CAMELLIA_BLOCK_SIZE          16
+#define CAMELLIA_TABLE_BYTE_LEN     272
+
+
+/* key constants */
+
+#define CAMELLIA_SIGMA1 (0xA09E667F3BCC908B)
+#define CAMELLIA_SIGMA2 (0xB67AE8584CAA73B2)
+#define CAMELLIA_SIGMA3 (0xC6EF372FE94F82BE)
+#define CAMELLIA_SIGMA4 (0x54FF53A5F1D36F1C)
+#define CAMELLIA_SIGMA5 (0x10E527FADE682D1D)
+#define CAMELLIA_SIGMA6 (0xB05688C2B3E6C1FD)
+
+/*
+ *  macros
+ */
+#define GETU64(v, pt) \
+    do { \
+	/* latest breed of gcc is clever enough to use move */ \
+	memcpy(&(v), (pt), 8); \
+	(v) = be64_to_cpu(v); \
+    } while(0)
+
+/* rotation right shift 1byte */
+#define ROR8(x) (((x) >> 8) + ((x) << (sizeof(x)*8 - 8)))
+/* rotation left shift 1bit */
+#define ROL1(x) (((x) << 1) + ((x) >> (sizeof(x)*8 - 1)))
+/* rotation left shift 1byte */
+#define ROL8(x) (((x) << 8) + ((x) >> (sizeof(x)*8 - 8)))
+
+#define ROLDQ(l, r, w, bits)				\
+    do {						\
+	w = l;						\
+	l = (l << bits) + (r >> (64 - bits));		\
+	r = (r << bits) + (w >> (64 - bits));		\
+    } while(0)
+
+/*
+ * NB: L and R below stand for 'left' and 'right' as in written numbers.
+ * That is, in (xxxL,xxxR) pair xxxL holds most significant digits,
+ * _not_ least significant ones!
+ */
+
+
+/*
+ * Key setup
+ */
+#define CAMELLIA_F(x, k, y, i)					\
+    do {							\
+	u32 yl, yr;						\
+	i = x ^ k;						\
+	yl = camellia_sp1110[(u8)i]				\
+	   ^ camellia_sp0222[(u8)(i >> 24)]			\
+	   ^ camellia_sp3033[(u8)(i >> 16)]			\
+	   ^ camellia_sp4404[(u8)(i >> 8)];			\
+	yr = camellia_sp1110[    (i >> 56)]			\
+	   ^ camellia_sp0222[(u8)(i >> 48)]			\
+	   ^ camellia_sp3033[(u8)(i >> 40)]			\
+	   ^ camellia_sp4404[(u8)(i >> 32)];			\
+	yl ^= yr;						\
+	yr = ROR8(yr);						\
+	yr ^= yl;						\
+	y = ((u64)yl << 32) + yr;				\
+    } while(0)
+
+#define SUBKEY(INDEX) (subkey[(INDEX)])
+
+#ifdef __BIG_ENDIAN
+#define SUBKEY_L(INDEX) (((u32*)subkey)[(INDEX)*2])
+#define SUBKEY_R(INDEX) (((u32*)subkey)[(INDEX)*2 + 1])
+#else
+#define SUBKEY_L(INDEX) (((u32*)subkey)[(INDEX)*2 + 1])
+#define SUBKEY_R(INDEX) (((u32*)subkey)[(INDEX)*2])
+#endif
+
+static void camellia_setup_tail(u64 *subkey, int max)
+{
+	u32 dw;
+	int i = 2;
+	do {
+		dw = SUBKEY_L(i + 0) ^ SUBKEY_R(i + 0); dw = ROL8(dw);/* round 1 */
+		SUBKEY_R(i + 0) = SUBKEY_L(i + 0) ^ dw; SUBKEY_L(i + 0) = dw;
+		dw = SUBKEY_L(i + 1) ^ SUBKEY_R(i + 1); dw = ROL8(dw);/* round 2 */
+		SUBKEY_R(i + 1) = SUBKEY_L(i + 1) ^ dw; SUBKEY_L(i + 1) = dw;
+		dw = SUBKEY_L(i + 2) ^ SUBKEY_R(i + 2); dw = ROL8(dw);/* round 3 */
+		SUBKEY_R(i + 2) = SUBKEY_L(i + 2) ^ dw; SUBKEY_L(i + 2) = dw;
+		dw = SUBKEY_L(i + 3) ^ SUBKEY_R(i + 3); dw = ROL8(dw);/* round 4 */
+		SUBKEY_R(i + 3) = SUBKEY_L(i + 3) ^ dw; SUBKEY_L(i + 3) = dw;
+		dw = SUBKEY_L(i + 4) ^ SUBKEY_R(i + 4); dw = ROL8(dw);/* round 5 */
+		SUBKEY_R(i + 4) = SUBKEY_L(i + 4) ^ dw; SUBKEY_L(i + 4) = dw;
+		dw = SUBKEY_L(i + 5) ^ SUBKEY_R(i + 5); dw = ROL8(dw);/* round 6 */
+		SUBKEY_R(i + 5) = SUBKEY_L(i + 5) ^ dw; SUBKEY_L(i + 5) = dw;
+		i += 8;
+	} while (i < max);
+}
+
+#ifdef __BIG_ENDIAN
+#define subL(INDEX) (((u32*)sub)[(INDEX)*2])
+#define subR(INDEX) (((u32*)sub)[(INDEX)*2 + 1])
+#else
+#define subL(INDEX) (((u32*)sub)[(INDEX)*2 + 1])
+#define subR(INDEX) (((u32*)sub)[(INDEX)*2])
+#endif
+
+static void camellia_setup128(const unsigned char *key, u64 *subkey)
+{
+	u64 kl, kr;
+	u64 i, t, w;
+	u64 kw4;
+	u32 dw;
+	u64 sub[26];
+
+	/**
+	 *  k == kl || kr (|| is concatination)
+	 */
+	GETU64(kl, key     );
+	GETU64(kr, key +  8);
+
+	/**
+	 * generate KL dependent subkeys
+	 */
+	/* kw1 */
+	sub[0] = kl;
+	/* kw2 */
+	sub[1] = kr;
+	/* rotation left shift 15bit */
+	ROLDQ(kl, kr, w, 15);
+	/* k3 */
+	sub[4] = kl;
+	/* k4 */
+	sub[5] = kr;
+	/* rotation left shift 15+30bit */
+	ROLDQ(kl, kr, w, 30);
+	/* k7 */
+	sub[10] = kl;
+	/* k8 */
+	sub[11] = kr;
+	/* rotation left shift 15+30+15bit */
+	ROLDQ(kl, kr, w, 15);
+	/* k10 */
+	sub[13] = kr;
+	/* rotation left shift 15+30+15+17 bit */
+	ROLDQ(kl, kr, w, 17);
+	/* kl3 */
+	sub[16] = kl;
+	/* kl4 */
+	sub[17] = kr;
+	/* rotation left shift 15+30+15+17+17 bit */
+	ROLDQ(kl, kr, w, 17);
+	/* k13 */
+	sub[18] = kl;
+	/* k14 */
+	sub[19] = kr;
+	/* rotation left shift 15+30+15+17+17+17 bit */
+	ROLDQ(kl, kr, w, 17);
+	/* k17 */
+	sub[22] = kl;
+	/* k18 */
+	sub[23] = kr;
+
+	/* generate KA */
+	kl = sub[0];
+	kr = sub[1];
+	CAMELLIA_F(kl, CAMELLIA_SIGMA1, w, i);
+	kr ^= w;
+	CAMELLIA_F(kr, CAMELLIA_SIGMA2, kl, i);
+	/* current status == (kl, w) */
+	CAMELLIA_F(kl, CAMELLIA_SIGMA3, kr, i);
+	kr ^= w;
+	CAMELLIA_F(kr, CAMELLIA_SIGMA4, w, i);
+	kl ^= w;
+
+	/* generate KA dependent subkeys */
+	/* k1, k2 */
+	sub[2] = kl;
+	sub[3] = kr;
+	ROLDQ(kl, kr, w, 15);
+	/* k5,k6 */
+	sub[6] = kl;
+	sub[7] = kr;
+	ROLDQ(kl, kr, w, 15);
+	/* kl1, kl2 */
+	sub[8] = kl;
+	sub[9] = kr;
+	ROLDQ(kl, kr, w, 15);
+	/* k9 */
+	sub[12] = kl;
+	ROLDQ(kl, kr, w, 15);
+	/* k11, k12 */
+	sub[14] = kl;
+	sub[15] = kr;
+	ROLDQ(kl, kr, w, 34);
+	/* k15, k16 */
+	sub[20] = kl;
+	sub[21] = kr;
+	ROLDQ(kl, kr, w, 17);
+	/* kw3, kw4 */
+	sub[24] = kl;
+	sub[25] = kr;
+
+	/* absorb kw2 to other subkeys */
+	/* round 2 */
+	sub[3] ^= sub[1];
+	/* round 4 */
+	sub[5] ^= sub[1];
+	/* round 6 */
+	sub[7] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(9);
+	dw = subL(1) & subL(9),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl2) */
+	/* round 8 */
+	sub[11] ^= sub[1];
+	/* round 10 */
+	sub[13] ^= sub[1];
+	/* round 12 */
+	sub[15] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(17);
+	dw = subL(1) & subL(17),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl4) */
+	/* round 14 */
+	sub[19] ^= sub[1];
+	/* round 16 */
+	sub[21] ^= sub[1];
+	/* round 18 */
+	sub[23] ^= sub[1];
+	/* kw3 */
+	sub[24] ^= sub[1];
+
+	/* absorb kw4 to other subkeys */
+	kw4 = sub[25];
+	/* round 17 */
+	sub[22] ^= kw4;
+	/* round 15 */
+	sub[20] ^= kw4;
+	/* round 13 */
+	sub[18] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(16)) << 32; //kw4l ^= kw4r & ~subR(16);
+	dw = (u32)(kw4 >> 32) & subL(16); // kw4l & subL[16],
+	kw4 ^= ROL1(dw); /* modified for FL(kl3) */
+	/* round 11 */
+	sub[14] ^= kw4;
+	/* round 9 */
+	sub[12] ^= kw4;
+	/* round 7 */
+	sub[10] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(8)) << 32; //kw4l ^= kw4r & ~subR[8];
+	dw = (u32)(kw4 >> 32) & subL(8);
+	kw4 ^= ROL1(dw); /* modified for FL(kl1) */
+	/* round 5 */
+	sub[6] ^= kw4;
+	/* round 3 */
+	sub[4] ^= kw4;
+	/* round 1 */
+	sub[2] ^= kw4;
+	/* kw1 */
+	sub[0] ^= kw4;
+
+	/* key XOR is end of F-function */
+	SUBKEY(0) = sub[0] ^ sub[2];/* kw1 */
+	SUBKEY(2) = sub[3];       /* round 1 */
+	SUBKEY(3) = sub[2] ^ sub[4]; /* round 2 */
+	SUBKEY(4) = sub[3] ^ sub[5]; /* round 3 */
+	SUBKEY(5) = sub[4] ^ sub[6]; /* round 4 */
+	SUBKEY(6) = sub[5] ^ sub[7]; /* round 5 */
+	t = subL(10) ^ (subR(10) & ~subR(8)); // tl = subL[10] ^ (subR[10] & ~subR[8]);
+	dw = (u32)t & subL(8);  /* FL(kl1) */
+	t = (t << 32) | (subR(10) ^ ROL1(dw)); // tr = subR[10] ^ ROL1(dw);
+	SUBKEY(7) = sub[6] ^ t; /* round 6 */
+	SUBKEY(8) = sub[8];       /* FL(kl1) */
+	SUBKEY(9) = sub[9];       /* FLinv(kl2) */
+	t = subL(7) ^ (subR(7) & ~subR(9));
+	dw = (u32)t & subL(9);  /* FLinv(kl2) */
+	t = (t << 32) | (subR(7) ^ ROL1(dw));
+	SUBKEY(10) = t ^ sub[11]; /* round 7 */
+	SUBKEY(11) = sub[10] ^ sub[12]; /* round 8 */
+	SUBKEY(12) = sub[11] ^ sub[13]; /* round 9 */
+	SUBKEY(13) = sub[12] ^ sub[14]; /* round 10 */
+	SUBKEY(14) = sub[13] ^ sub[15]; /* round 11 */
+	t = subL(18) ^ (subR(18) & ~subR(16));
+	dw = (u32)t & subL(16); /* FL(kl3) */
+	t = (t << 32) | (subR(18) ^ ROL1(dw));
+	SUBKEY(15) = sub[14] ^ t; /* round 12 */
+	SUBKEY(16) = sub[16];     /* FL(kl3) */
+	SUBKEY(17) = sub[17];     /* FLinv(kl4) */
+	t = subL(15) ^ (subR(15) & ~subR(17));
+	dw = (u32)t & subL(17); /* FLinv(kl4) */
+	t = (t << 32) | (subR(15) ^ ROL1(dw));
+	SUBKEY(18) = t ^ sub[19]; /* round 13 */
+	SUBKEY(19) = sub[18] ^ sub[20]; /* round 14 */
+	SUBKEY(20) = sub[19] ^ sub[21]; /* round 15 */
+	SUBKEY(21) = sub[20] ^ sub[22]; /* round 16 */
+	SUBKEY(22) = sub[21] ^ sub[23]; /* round 17 */
+	SUBKEY(23) = sub[22];     /* round 18 */
+	SUBKEY(24) = sub[24] ^ sub[23]; /* kw3 */
+
+	/* apply the inverse of the last half of P-function */
+	camellia_setup_tail(subkey, 24);
+}
+
+static void camellia_setup256(const unsigned char *key, u64 *subkey)
+{
+	u64 kl, kr;        /* left half of key */
+	u64 krl, krr;      /* right half of key */
+	u64 i, t, w;       /* temporary variables */
+	u64 kw4;
+	u32 dw;
+	u64 sub[34];
+
+	/**
+	 *  key = (kl || kr || krl || krr)
+	 *  (|| is concatination)
+	 */
+	GETU64(kl,  key     );
+	GETU64(kr,  key +  8);
+	GETU64(krl, key + 16);
+	GETU64(krr, key + 24);
+
+	/* generate KL dependent subkeys */
+	/* kw1 */
+	sub[0] = kl;
+	/* kw2 */
+	sub[1] = kr;
+	ROLDQ(kl, kr, w, 45);
+	/* k9 */
+	sub[12] = kl;
+	/* k10 */
+	sub[13] = kr;
+	ROLDQ(kl, kr, w, 15);
+	/* kl3 */
+	sub[16] = kl;
+	/* kl4 */
+	sub[17] = kr;
+	ROLDQ(kl, kr, w, 17);
+	/* k17 */
+	sub[22] = kl;
+	/* k18 */
+	sub[23] = kr;
+	ROLDQ(kl, kr, w, 34);
+	/* k23 */
+	sub[30] = kl;
+	/* k24 */
+	sub[31] = kr;
+
+	/* generate KR dependent subkeys */
+	ROLDQ(krl, krr, w, 15);
+	/* k3 */
+	sub[4] = krl;
+	/* k4 */
+	sub[5] = krr;
+	ROLDQ(krl, krr, w, 15);
+	/* kl1 */
+	sub[8] = krl;
+	/* kl2 */
+	sub[9] = krr;
+	ROLDQ(krl, krr, w, 30);
+	/* k13 */
+	sub[18] = krl;
+	/* k14 */
+	sub[19] = krr;
+	ROLDQ(krl, krr, w, 34);
+	/* k19 */
+	sub[26] = krl;
+	/* k20 */
+	sub[27] = krr;
+	ROLDQ(krl, krr, w, 34);
+
+	/* generate KA */
+	kl = sub[0] ^ krl;
+	kr = sub[1] ^ krr;
+	CAMELLIA_F(kl, CAMELLIA_SIGMA1, w, i);
+	kr ^= w;
+	CAMELLIA_F(kr, CAMELLIA_SIGMA2, kl, i);
+	kl ^= krl;
+	CAMELLIA_F(kl, CAMELLIA_SIGMA3, kr, i);
+	kr ^= w ^ krr;
+	CAMELLIA_F(kr, CAMELLIA_SIGMA4, w, i);
+	kl ^= w;
+
+	/* generate KB */
+	krl ^= kl;
+	krr ^= kr;
+	CAMELLIA_F(krl, CAMELLIA_SIGMA5, w, i);
+	krr ^= w;
+	CAMELLIA_F(krr, CAMELLIA_SIGMA6, w, i);
+	krl ^= w;
+
+	/* generate KA dependent subkeys */
+	ROLDQ(kl, kr, w, 15);
+	/* k5 */
+	sub[6] = kl;
+	/* k6 */
+	sub[7] = kr;
+	ROLDQ(kl, kr, w, 30);
+	/* k11 */
+	sub[14] = kl;
+	/* k12 */
+	sub[15] = kr;
+	/* kl5 */
+	ROLDQ(kl, kr, w, 32);
+	sub[24] = kl;
+	/* kl6 */
+	sub[25] = kr;
+	/* rotation left shift 49 from k11,k12 -> k21,k22 */
+	ROLDQ(kl, kr, w, (49 - 32));
+	/* k21 */
+	sub[28] = kl;
+	/* k22 */
+	sub[29] = kr;
+
+	/* generate KB dependent subkeys */
+	/* k1 */
+	sub[2] = krl;
+	/* k2 */
+	sub[3] = krr;
+	ROLDQ(krl, krr, w, 30);
+	/* k7 */
+	sub[10] = krl;
+	/* k8 */
+	sub[11] = krr;
+	ROLDQ(krl, krr, w, 30);
+	/* k15 */
+	sub[20] = krl;
+	/* k16 */
+	sub[21] = krr;
+	ROLDQ(krl, krr, w, 51);
+	/* kw3 */
+	sub[32] = krl;
+	/* kw4 */
+	sub[33] = krr;
+
+	/* absorb kw2 to other subkeys */
+	/* round 2 */
+	sub[3] ^= sub[1];
+	/* round 4 */
+	sub[5] ^= sub[1];
+	/* round 6 */
+	sub[7] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(9);
+	dw = subL(1) & subL(9),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl2) */
+	/* round 8 */
+	sub[11] ^= sub[1];
+	/* round 10 */
+	sub[13] ^= sub[1];
+	/* round 12 */
+	sub[15] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(17);
+	dw = subL(1) & subL(17),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl4) */
+	/* round 14 */
+	sub[19] ^= sub[1];
+	/* round 16 */
+	sub[21] ^= sub[1];
+	/* round 18 */
+	sub[23] ^= sub[1];
+	subL(1) ^= subR(1) & ~subR(25);
+	dw = subL(1) & subL(25),
+		subR(1) ^= ROL1(dw); /* modified for FLinv(kl6) */
+	/* round 20 */
+	sub[27] ^= sub[1];
+	/* round 22 */
+	sub[29] ^= sub[1];
+	/* round 24 */
+	sub[31] ^= sub[1];
+	/* kw3 */
+	sub[32] ^= sub[1];
+
+	/* absorb kw4 to other subkeys */
+	kw4 = sub[33];
+	/* round 23 */
+	sub[30] ^= kw4;
+	/* round 21 */
+	sub[28] ^= kw4;
+	/* round 19 */
+	sub[26] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(24)) << 32; //kw4l ^= kw4r & ~subR[24];
+	dw = (u32)(kw4 >> 32) & subL(24),
+		kw4 ^= ROL1(dw); /* modified for FL(kl5) */
+	/* round 17 */
+	sub[22] ^= kw4;
+	/* round 15 */
+	sub[20] ^= kw4;
+	/* round 13 */
+	sub[18] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(16)) << 32;
+	dw = (u32)(kw4 >> 32) & subL(16),
+		kw4 ^= ROL1(dw); /* modified for FL(kl3) */
+	/* round 11 */
+	sub[14] ^= kw4;
+	/* round 9 */
+	sub[12] ^= kw4;
+	/* round 7 */
+	sub[10] ^= kw4;
+	kw4 ^= (u64)((u32)kw4 & ~subR(8)) << 32;
+	dw = (u32)(kw4 >> 32) & subL(8),
+		kw4 ^= ROL1(dw); /* modified for FL(kl1) */
+	/* round 5 */
+	sub[6] ^= kw4;
+	/* round 3 */
+	sub[4] ^= kw4;
+	/* round 1 */
+	sub[2] ^= kw4;
+	/* kw1 */
+	sub[0] ^= kw4;
+
+	/* key XOR is end of F-function */
+	SUBKEY(0) = sub[0] ^ sub[2];/* kw1 */
+	SUBKEY(2) = sub[3];       /* round 1 */
+	SUBKEY(3) = sub[2] ^ sub[4]; /* round 2 */
+	SUBKEY(4) = sub[3] ^ sub[5]; /* round 3 */
+	SUBKEY(5) = sub[4] ^ sub[6]; /* round 4 */
+	SUBKEY(6) = sub[5] ^ sub[7]; /* round 5 */
+	t = subL(10) ^ (subR(10) & ~subR(8)); // tl = subL[10] ^ (subR[10] & ~subR[8]);
+	dw = (u32)t & subL(8);  /* FL(kl1) */
+	t = (t << 32) | (subR(10) ^ ROL1(dw)); //tr = subR[10] ^ ROL1(dw);
+	SUBKEY(7) = sub[6] ^ t;   /* round 6 */
+	SUBKEY(8) = sub[8];       /* FL(kl1) */
+	SUBKEY(9) = sub[9];       /* FLinv(kl2) */
+	t = subL(7) ^ (subR(7) & ~subR(9));
+	dw = (u32)t & subL(9);  /* FLinv(kl2) */
+	t = (t << 32) | (subR(7) ^ ROL1(dw));
+	SUBKEY(10) = t ^ sub[11]; /* round 7 */
+	SUBKEY(11) = sub[10] ^ sub[12]; /* round 8 */
+	SUBKEY(12) = sub[11] ^ sub[13]; /* round 9 */
+	SUBKEY(13) = sub[12] ^ sub[14]; /* round 10 */
+	SUBKEY(14) = sub[13] ^ sub[15]; /* round 11 */
+	t = subL(18) ^ (subR(18) & ~subR(16));
+	dw = (u32)t & subL(16); /* FL(kl3) */
+	t = (t << 32) | (subR(18) ^ ROL1(dw));
+	SUBKEY(15) = sub[14] ^ t; /* round 12 */
+	SUBKEY(16) = sub[16];     /* FL(kl3) */
+	SUBKEY(17) = sub[17];     /* FLinv(kl4) */
+	t = subL(15) ^ (subR(15) & ~subR(17));
+	dw = (u32)t & subL(17); /* FLinv(kl4) */
+	t = (t << 32) | (subR(15) ^ ROL1(dw));
+	SUBKEY(18) = t ^ sub[19]; /* round 13 */
+	SUBKEY(19) = sub[18] ^ sub[20]; /* round 14 */
+	SUBKEY(20) = sub[19] ^ sub[21]; /* round 15 */
+	SUBKEY(21) = sub[20] ^ sub[22]; /* round 16 */
+	SUBKEY(22) = sub[21] ^ sub[23]; /* round 17 */
+	t = subL(26) ^ (subR(26) & ~subR(24));
+	dw = (u32)t & subL(24); /* FL(kl5) */
+	t = (t << 32) | (subR(26) ^ ROL1(dw));
+	SUBKEY(23) = sub[22] ^ t; /* round 18 */
+	SUBKEY(24) = sub[24];     /* FL(kl5) */
+	SUBKEY(25) = sub[25];     /* FLinv(kl6) */
+	t = subL(23) ^ (subR(23) & ~subR(25));
+	dw = (u32)t & subL(25); /* FLinv(kl6) */
+	t = (t << 32) | (subR(23) ^ ROL1(dw));
+	SUBKEY(26) = t ^ sub[27]; /* round 19 */
+	SUBKEY(27) = sub[26] ^ sub[28]; /* round 20 */
+	SUBKEY(28) = sub[27] ^ sub[29]; /* round 21 */
+	SUBKEY(29) = sub[28] ^ sub[30]; /* round 22 */
+	SUBKEY(30) = sub[29] ^ sub[31]; /* round 23 */
+	SUBKEY(31) = sub[30];     /* round 24 */
+	SUBKEY(32) = sub[32] ^ sub[31]; /* kw3 */
+
+	/* apply the inverse of the last half of P-function */
+	camellia_setup_tail(subkey, 32);
+}
+
+static void camellia_setup192(const unsigned char *key, u64 *subkey)
+{
+	unsigned char kk[32];
+	u64 krl, krr;
+
+	memcpy(kk, key, 24);
+	memcpy((unsigned char *)&krl, key+16, 8);
+	krr = ~krl;
+	memcpy(kk+24, (unsigned char *)&krr, 8);
+	camellia_setup256(kk, subkey);
+}
+
+
+/*
+ * Encrypt/decrypt
+ */
+#define CAMELLIA_FLS(ll, lr, rl, rr, kll, klr, krl, krr, t0, t1, t2, t3) \
+    do {								\
+	t0 = kll & ll;							\
+	t2 = krr | rr;							\
+	rl ^= t2;							\
+	lr ^= ROL1(t0);							\
+	t3 = krl & rl;							\
+	t1 = klr | lr;							\
+	ll ^= t1;							\
+	rr ^= ROL1(t3);							\
+    } while(0)
+
+#define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir)		\
+    do {								\
+	ir =  camellia_sp1110[(u8)xr];					\
+	il =  camellia_sp1110[    (xl >> 24)];				\
+	ir ^= camellia_sp0222[    (xr >> 24)];				\
+	il ^= camellia_sp0222[(u8)(xl >> 16)];				\
+	ir ^= camellia_sp3033[(u8)(xr >> 16)];				\
+	il ^= camellia_sp3033[(u8)(xl >> 8)];				\
+	ir ^= camellia_sp4404[(u8)(xr >> 8)];				\
+	il ^= camellia_sp4404[(u8)xl];					\
+	il ^= kl;							\
+	ir ^= il ^ kr;							\
+	yl ^= ir;							\
+	yr ^= ROR8(il) ^ ir;						\
+    } while(0)
+
+/* max = 24: 128bit encrypt, max = 32: 256bit encrypt */
+static void camellia_do_encrypt(const u64 *subkey, u32 *io, unsigned max)
+{
+	u32 il,ir,t0,t1;               /* temporary variables */
+
+	/* pre whitening but absorb kw2 */
+	io[0] ^= SUBKEY_L(0);
+	io[1] ^= SUBKEY_R(0);
+
+	/* main iteration */
+#define ROUNDS(i) do { \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 2),SUBKEY_R(i + 2), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 3),SUBKEY_R(i + 3), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 4),SUBKEY_R(i + 4), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 5),SUBKEY_R(i + 5), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 6),SUBKEY_R(i + 6), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 7),SUBKEY_R(i + 7), \
+			 io[0],io[1],il,ir); \
+} while (0)
+#define FLS(i) do { \
+	CAMELLIA_FLS(io[0],io[1],io[2],io[3], \
+		     SUBKEY_L(i + 0),SUBKEY_R(i + 0), \
+		     SUBKEY_L(i + 1),SUBKEY_R(i + 1), \
+		     t0,t1,il,ir); \
+} while (0)
+
+#ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
+	{
+		unsigned i = 0;
+		while (1) {
+			ROUNDS(i);
+			i += 8;
+			if (i >= max)
+				break;
+			FLS(i);
+		}
+	}
+#else
+	ROUNDS(0);
+	FLS(8);
+	ROUNDS(8);
+	FLS(16);
+	ROUNDS(16);
+	if (max == 32) {
+		FLS(24);
+		ROUNDS(24);
+	}
+#endif
+
+#undef ROUNDS
+#undef FLS
+
+	/* post whitening but kw4 */
+	io[2] ^= SUBKEY_L(max);
+	io[3] ^= SUBKEY_R(max);
+	/* NB: 0,1 should be swapped with 2,3 by caller! */
+}
+
+static void camellia_do_decrypt(const u64 *subkey, u32 *io, unsigned i)
+{
+	u32 il,ir,t0,t1;               /* temporary variables */
+
+	/* pre whitening but absorb kw2 */
+	io[0] ^= SUBKEY_L(i);
+	io[1] ^= SUBKEY_R(i);
+
+	/* main iteration */
+#define ROUNDS(i) do { \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 7),SUBKEY_R(i + 7), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 6),SUBKEY_R(i + 6), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 5),SUBKEY_R(i + 5), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 4),SUBKEY_R(i + 4), \
+			 io[0],io[1],il,ir); \
+	CAMELLIA_ROUNDSM(io[0],io[1], \
+			 SUBKEY_L(i + 3),SUBKEY_R(i + 3), \
+			 io[2],io[3],il,ir); \
+	CAMELLIA_ROUNDSM(io[2],io[3], \
+			 SUBKEY_L(i + 2),SUBKEY_R(i + 2), \
+			 io[0],io[1],il,ir); \
+} while (0)
+#define FLS(i) do { \
+	CAMELLIA_FLS(io[0],io[1],io[2],io[3], \
+		     SUBKEY_L(i + 1),SUBKEY_R(i + 1), \
+		     SUBKEY_L(i + 0),SUBKEY_R(i + 0), \
+		     t0,t1,il,ir); \
+} while (0)
+
+#ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
+	while (1) {
+		i -= 8;
+		ROUNDS(i);
+		if (i == 0)
+			break;
+		FLS(i);
+	}
+#else
+	if (i == 32) {
+		ROUNDS(24);
+		FLS(24);
+	}
+	ROUNDS(16);
+	FLS(16);
+	ROUNDS(8);
+	FLS(8);
+	ROUNDS(0);
+#endif
+
+#undef ROUNDS
+#undef FLS
+
+	/* post whitening but kw4 */
+	io[2] ^= SUBKEY_L(0);
+	io[3] ^= SUBKEY_R(0);
+	/* NB: 0,1 should be swapped with 2,3 by caller! */
+}
+
+
+struct camellia_ctx {
+	int key_length;
+	u64 key_table[CAMELLIA_TABLE_BYTE_LEN / 8];
+};
+
+static int
+camellia_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+		 unsigned int key_len)
+{
+	struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
+	const unsigned char *key = (const unsigned char *)in_key;
+	u32 *flags = &tfm->crt_flags;
+
+	if (key_len != 16 && key_len != 24 && key_len != 32) {
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	cctx->key_length = key_len;
+
+	switch (key_len) {
+	case 16:
+		camellia_setup128(key, cctx->key_table);
+		break;
+	case 24:
+		camellia_setup192(key, cctx->key_table);
+		break;
+	case 32:
+		camellia_setup256(key, cctx->key_table);
+		break;
+	}
+
+	return 0;
+}
+
+static void camellia_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	const struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
+	const __be32 *src = (const __be32 *)in;
+	__be32 *dst = (__be32 *)out;
+
+	u32 tmp[4];
+
+	tmp[0] = be32_to_cpu(src[0]);
+	tmp[1] = be32_to_cpu(src[1]);
+	tmp[2] = be32_to_cpu(src[2]);
+	tmp[3] = be32_to_cpu(src[3]);
+
+	camellia_do_encrypt(cctx->key_table, tmp,
+		cctx->key_length == 16 ? 24 : 32 /* for key lengths of 24 and 32 */
+	);
+
+	/* do_encrypt returns 0,1 swapped with 2,3 */
+	dst[0] = cpu_to_be32(tmp[2]);
+	dst[1] = cpu_to_be32(tmp[3]);
+	dst[2] = cpu_to_be32(tmp[0]);
+	dst[3] = cpu_to_be32(tmp[1]);
+}
+
+static void camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	const struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
+	const __be32 *src = (const __be32 *)in;
+	__be32 *dst = (__be32 *)out;
+
+	u32 tmp[4];
+
+	tmp[0] = be32_to_cpu(src[0]);
+	tmp[1] = be32_to_cpu(src[1]);
+	tmp[2] = be32_to_cpu(src[2]);
+	tmp[3] = be32_to_cpu(src[3]);
+
+	camellia_do_decrypt(cctx->key_table, tmp,
+		cctx->key_length == 16 ? 24 : 32 /* for key lengths of 24 and 32 */
+	);
+
+	/* do_decrypt returns 0,1 swapped with 2,3 */
+	dst[0] = cpu_to_be32(tmp[2]);
+	dst[1] = cpu_to_be32(tmp[3]);
+	dst[2] = cpu_to_be32(tmp[0]);
+	dst[3] = cpu_to_be32(tmp[1]);
+}
+
+static struct crypto_alg camellia_alg = {
+	.cra_name		=	"camellia",
+	.cra_driver_name	=	"camellia-generic",
+	.cra_priority		=	100,
+	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		=	CAMELLIA_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct camellia_ctx),
+	.cra_alignmask		=	3,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(camellia_alg.cra_list),
+	.cra_u			=	{
+		.cipher = {
+			.cia_min_keysize	=	CAMELLIA_MIN_KEY_SIZE,
+			.cia_max_keysize	=	CAMELLIA_MAX_KEY_SIZE,
+			.cia_setkey		=	camellia_set_key,
+			.cia_encrypt		=	camellia_encrypt,
+			.cia_decrypt		=	camellia_decrypt
+		}
+	}
+};
+
+static int __init camellia_init(void)
+{
+	return crypto_register_alg(&camellia_alg);
+}
+
+static void __exit camellia_fini(void)
+{
+	crypto_unregister_alg(&camellia_alg);
+}
+
+module_init(camellia_init);
+module_exit(camellia_fini);
+
+MODULE_DESCRIPTION("Camellia Cipher Algorithm");
+MODULE_LICENSE("GPL");

--Boundary-00=_5ZiOHpCMQ6YxOOY--

From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 2/5] camellia: code shrink #2
Date: Thu, 22 Nov 2007 14:43:25 -0800
Message-ID: <200711221443.25426.vda.linux@googlemail.com>
References: <200711221441.45027.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NYgRHw/52dOsGeR"
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:49035 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbXKVWp5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 17:45:57 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2481199rvb
        for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 14:45:56 -0800 (PST)
In-Reply-To: <200711221441.45027.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Boundary-00=_NYgRHw/52dOsGeR
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 22 November 2007 14:41, Denys Vlasenko wrote:
> camellia6:
>         unifies encrypt/decrypt routines for different key lengths.
>         This reduces module size by ~25%, with tiny (less than 1%)
>         speed impact.
>         Also collapses encrypt/decrypt into more readable
>         (visually shorter) form using macros.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_NYgRHw/52dOsGeR
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="cryptodev-2.6.camellia6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cryptodev-2.6.camellia6.diff"

diff -urpN cryptodev-2.6.camellia5/crypto/camellia.c cryptodev-2.6.camellia6/crypto/camellia.c
--- cryptodev-2.6.camellia5/crypto/camellia.c	2007-11-22 14:14:11.000000000 -0800
+++ cryptodev-2.6.camellia6/crypto/camellia.c	2007-11-22 14:20:03.000000000 -0800
@@ -1001,400 +1001,115 @@ static void camellia_setup192(const unsi
 	yr ^= ROR8(il) ^ ir;						\
     } while(0)
 
-static void camellia_encrypt128(const u32 *subkey, u32 *io_text)
+/* max = 24: 128bit encrypt, max = 32: 256bit encrypt */
+static void camellia_do_encrypt(const u32 *subkey, u32 *io, unsigned max)
 {
 	u32 il,ir,t0,t1;               /* temporary variables */
 
-	u32 io[4];
-
 	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(0);
-	io[1] = io_text[1] ^ SUBKEY_R(0);
-	io[2] = io_text[2];
-	io[3] = io_text[3];
+	io[0] ^= SUBKEY_L(0);
+	io[1] ^= SUBKEY_R(0);
 
 	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[0],io[1],il,ir);
-
-	/* post whitening but kw4 */
-	io_text[0] = io[2] ^ SUBKEY_L(24);
-	io_text[1] = io[3] ^ SUBKEY_R(24);
-	io_text[2] = io[0];
-	io_text[3] = io[1];
-}
-
-static void camellia_decrypt128(const u32 *subkey, u32 *io_text)
-{
-	u32 il,ir,t0,t1;               /* temporary variables */
-
-	u32 io[4];
-
-	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(24);
-	io[1] = io_text[1] ^ SUBKEY_R(24);
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
+	ROUNDS(0);
+	FLS(8);
+	ROUNDS(8);
+	FLS(16);
+	ROUNDS(16);
+	if (max == 32) {
+		FLS(24);
+		ROUNDS(24);
+	}
 
-	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[0],io[1],il,ir);
+#undef ROUNDS
+#undef FLS
 
 	/* post whitening but kw4 */
-	io_text[0] = io[2] ^ SUBKEY_L(0);
-	io_text[1] = io[3] ^ SUBKEY_R(0);
-	io_text[2] = io[0];
-	io_text[3] = io[1];
+	io[2] ^= SUBKEY_L(max);
+	io[3] ^= SUBKEY_R(max);
+	/* NB: io[0],[1] should be swapped with [2],[3] by caller! */
 }
 
-static void camellia_encrypt256(const u32 *subkey, u32 *io_text)
+static void camellia_do_decrypt(const u32 *subkey, u32 *io, unsigned i)
 {
-	u32 il,ir,t0,t1;           /* temporary variables */
-
-	u32 io[4];
+	u32 il,ir,t0,t1;               /* temporary variables */
 
 	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(0);
-	io[1] = io_text[1] ^ SUBKEY_R(0);
-	io[2] = io_text[2];
-	io[3] = io_text[3];
+	io[0] ^= SUBKEY_L(i);
+	io[1] ^= SUBKEY_R(i);
 
 	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(24),SUBKEY_R(24),
-		     SUBKEY_L(25),SUBKEY_R(25),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(26),SUBKEY_R(26),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(27),SUBKEY_R(27),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(28),SUBKEY_R(28),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(29),SUBKEY_R(29),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(30),SUBKEY_R(30),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(31),SUBKEY_R(31),
-			 io[0],io[1],il,ir);
-
-	/* post whitening but kw4 */
-	io_text[0] = io[2] ^ SUBKEY_L(32);
-	io_text[1] = io[3] ^ SUBKEY_R(32);
-	io_text[2] = io[0];
-	io_text[3] = io[1];
-}
-
-static void camellia_decrypt256(const u32 *subkey, u32 *io_text)
-{
-	u32 il,ir,t0,t1;           /* temporary variables */
-
-	u32 io[4];
-
-	/* pre whitening but absorb kw2 */
-	io[0] = io_text[0] ^ SUBKEY_L(32);
-	io[1] = io_text[1] ^ SUBKEY_R(32);
-	io[2] = io_text[2];
-	io[3] = io_text[3];
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
+	if (i == 32) {
+		ROUNDS(24);
+		FLS(24);
+	}
+	ROUNDS(16);
+	FLS(16);
+	ROUNDS(8);
+	FLS(8);
+	ROUNDS(0);
 
-	/* main iteration */
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(31),SUBKEY_R(31),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(30),SUBKEY_R(30),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(29),SUBKEY_R(29),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(28),SUBKEY_R(28),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(27),SUBKEY_R(27),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(26),SUBKEY_R(26),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(25),SUBKEY_R(25),
-		     SUBKEY_L(24),SUBKEY_R(24),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(23),SUBKEY_R(23),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(22),SUBKEY_R(22),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(21),SUBKEY_R(21),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(20),SUBKEY_R(20),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(19),SUBKEY_R(19),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(18),SUBKEY_R(18),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(17),SUBKEY_R(17),
-		     SUBKEY_L(16),SUBKEY_R(16),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(15),SUBKEY_R(15),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(14),SUBKEY_R(14),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(13),SUBKEY_R(13),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(12),SUBKEY_R(12),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(11),SUBKEY_R(11),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(10),SUBKEY_R(10),
-			 io[0],io[1],il,ir);
-
-	CAMELLIA_FLS(io[0],io[1],io[2],io[3],
-		     SUBKEY_L(9),SUBKEY_R(9),
-		     SUBKEY_L(8),SUBKEY_R(8),
-		     t0,t1,il,ir);
-
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(7),SUBKEY_R(7),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(6),SUBKEY_R(6),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(5),SUBKEY_R(5),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(4),SUBKEY_R(4),
-			 io[0],io[1],il,ir);
-	CAMELLIA_ROUNDSM(io[0],io[1],
-			 SUBKEY_L(3),SUBKEY_R(3),
-			 io[2],io[3],il,ir);
-	CAMELLIA_ROUNDSM(io[2],io[3],
-			 SUBKEY_L(2),SUBKEY_R(2),
-			 io[0],io[1],il,ir);
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
 
 
@@ -1446,21 +1161,15 @@ static void camellia_encrypt(struct cryp
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
@@ -1476,21 +1185,15 @@ static void camellia_decrypt(struct cryp
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

--Boundary-00=_NYgRHw/52dOsGeR--

From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Mon, 7 Jan 2008 15:40:58 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696243703-2102025713-1199713258=:31652"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51815 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYAGNlA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jan 2008 08:41:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-2102025713-1199713258=:31652
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

Bloat-o-meter shows rather high readings for cast6...

crypto/cast6.c:
  cast6_setkey  | -1310
  cast6_encrypt | -4567
  cast6_decrypt | -4561
 3 functions changed, 10438 bytes removed, diff: -10438

crypto/cast6.c:
  W    | +659
  Q    | +308
  QBAR | +316
 3 functions changed, 1283 bytes added, diff: +1283

crypto/cast6.o:
 6 functions changed, 1283 bytes added, 10438 bytes removed, diff: -9155

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 crypto/cast6.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/cast6.c b/crypto/cast6.c
index 136ab6d..5fd9420 100644
--- a/crypto/cast6.c
+++ b/crypto/cast6.c
@@ -369,7 +369,7 @@ static const u8 Tr[4][8] = {
 };
 
 /* forward octave */
-static inline void W(u32 *key, unsigned int i) {
+static void W(u32 *key, unsigned int i) {
 	u32 I;
 	key[6] ^= F1(key[7], Tr[i % 4][0], Tm[i][0]);
 	key[5] ^= F2(key[6], Tr[i % 4][1], Tm[i][1]);
@@ -428,7 +428,7 @@ static int cast6_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 }
 
 /*forward quad round*/
-static inline void Q (u32 * block, u8 * Kr, u32 * Km) {
+static void Q (u32 * block, u8 * Kr, u32 * Km) {
 	u32 I;
 	block[2] ^= F1(block[3], Kr[0], Km[0]);
 	block[1] ^= F2(block[2], Kr[1], Km[1]);
@@ -437,7 +437,7 @@ static inline void Q (u32 * block, u8 * Kr, u32 * Km) {
 }
 
 /*reverse quad round*/
-static inline void QBAR (u32 * block, u8 * Kr, u32 * Km) {
+static void QBAR (u32 * block, u8 * Kr, u32 * Km) {
 	u32 I;
         block[3] ^= F1(block[0], Kr[3], Km[3]);
         block[0] ^= F3(block[1], Kr[2], Km[2]);
-- 
1.5.0.6

---696243703-2102025713-1199713258=:31652--

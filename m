From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] Revert "[CRYPTO] cast6: inline bloat--"
Date: Tue, 28 Aug 2012 16:49:28 +0300
Message-ID: <20120828134928.7602.26086.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ilpo =?utf-8?b?SsOkcnZpbmVu?= <ilpo.jarvinen@helsinki.fi>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:37084 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2H1Ntb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Aug 2012 09:49:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This reverts commit e6ccc727f30a02670f6a00df6d548942bc988f43.

Above commit caused performance regression for CAST6. Reverting gives
following increase in tcrypt speed tests (revert-vs-old ratios).

AMD Phenom II X6 1055T, x86-64:

size    ecb             cbc             ctr             lrw            =
 xts
        enc     dec     enc     dec     enc     dec     enc     dec    =
 enc     dec
16b     1.15x   1.17x   1.16x   1.17x   1.16x   1.16x   1.14x   1.19x  =
 1.05x   1.07x
64b     1.19x   1.23x   1.20x   1.22x   1.19x   1.19x   1.16x   1.24x  =
 1.12x   1.12x
256b    1.21x   1.24x   1.22x   1.24x   1.20x   1.20x   1.17x   1.21x  =
 1.16x   1.14x
1kb     1.21x   1.25x   1.22x   1.24x   1.21x   1.21x   1.18x   1.22x  =
 1.17x   1.15x
8kb     1.21x   1.25x   1.22x   1.24x   1.21x   1.21x   1.18x   1.22x  =
 1.18x   1.15x

Cc: Ilpo J=C3=A4rvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/cast6_generic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/cast6_generic.c b/crypto/cast6_generic.c
index dc9309d..1acd2f1 100644
--- a/crypto/cast6_generic.c
+++ b/crypto/cast6_generic.c
@@ -370,7 +370,7 @@ static const u8 Tr[4][8] =3D {
 };
=20
 /* forward octave */
-static void W(u32 *key, unsigned int i)
+static inline void W(u32 *key, unsigned int i)
 {
 	u32 I;
 	key[6] ^=3D F1(key[7], Tr[i % 4][0], Tm[i][0]);
@@ -434,7 +434,7 @@ int cast6_setkey(struct crypto_tfm *tfm, const u8 *=
key, unsigned int keylen)
 EXPORT_SYMBOL_GPL(cast6_setkey);
=20
 /*forward quad round*/
-static void Q(u32 *block, u8 *Kr, u32 *Km)
+static inline void Q(u32 *block, u8 *Kr, u32 *Km)
 {
 	u32 I;
 	block[2] ^=3D F1(block[3], Kr[0], Km[0]);
@@ -444,7 +444,7 @@ static void Q(u32 *block, u8 *Kr, u32 *Km)
 }
=20
 /*reverse quad round*/
-static void QBAR(u32 *block, u8 *Kr, u32 *Km)
+static inline void QBAR(u32 *block, u8 *Kr, u32 *Km)
 {
 	u32 I;
 	block[3] ^=3D F1(block[0], Kr[3], Km[3]);

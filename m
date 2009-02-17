From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] crypto: shash - Handle failures in crypto_alloc_shash()
 correctly
Date: Tue, 17 Feb 2009 18:46:40 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902171845420.13163@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:37838 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754388AbZBQRqo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Feb 2009 12:46:44 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_alloc_tfm() returns an error-valued pointer in case of failure,
which must not be translated using __crypto_shash_cast().

Currently everything works fine because __crypto_shash_cast() is a no-o=
p
(crypto_shash.base is at offset zero).

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/shash.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 13a0dc1..fbc6993 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -480,8 +480,12 @@ static const struct crypto_type crypto_shash_type =
=3D {
 struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type=
,
 					u32 mask)
 {
-	return __crypto_shash_cast(
-		crypto_alloc_tfm(alg_name, &crypto_shash_type, type, mask));
+	struct crypto_tfm *tfm =3D crypto_alloc_tfm(alg_name, &crypto_shash_t=
ype,
+						  type, mask);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+
+	return __crypto_shash_cast(tfm);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_shash);
=20
--=20
1.6.0.4

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] crypto: Validate output length in (de)compression tests
Date: Thu, 27 Nov 2008 18:48:13 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811271847240.10372@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:55573 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752655AbYK0Rs0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Nov 2008 12:48:26 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When self-testing (de)compression algorithms, make sure the actual size=
 of
the (de)compressed output data matches the expected output size.
Otherwise, in case the actual output size would be smaller than the exp=
ected
output size, the subsequent buffer compare test would still succeed, an=
d no
error would be reported.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 67ff4aa..24eb013 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -843,6 +843,14 @@ static int test_comp(struct crypto_comp *tfm, stru=
ct comp_testvec *ctemplate,
 			goto out;
 		}
=20
+		if (dlen !=3D ctemplate[i].outlen ) {
+			printk(KERN_ERR "alg: comp: Compression test %d "
+			       "failed for %s: output len =3D %d\n", i + 1, algo,
+			       dlen);
+			ret =3D -EINVAL;
+			goto out;
+		}
+
 		if (memcmp(result, ctemplate[i].output, dlen)) {
 			printk(KERN_ERR "alg: comp: Compression test %d "
 			       "failed for %s\n", i + 1, algo);
@@ -867,6 +875,14 @@ static int test_comp(struct crypto_comp *tfm, stru=
ct comp_testvec *ctemplate,
 			goto out;
 		}
=20
+		if (dlen !=3D dtemplate[i].outlen) {
+			printk(KERN_ERR "alg: comp: Decompression test %d "
+			       "failed for %s: output len =3D %d\n", i + 1, algo,
+			       dlen);
+			ret =3D -EINVAL;
+			goto out;
+		}
+
 		if (memcmp(result, dtemplate[i].output, dlen)) {
 			printk(KERN_ERR "alg: comp: Decompression test %d "
 			       "failed for %s\n", i + 1, algo);

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =C2=B7 RPR Brussels
=46ortis =C2=B7 BIC GEBABEBB =C2=B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

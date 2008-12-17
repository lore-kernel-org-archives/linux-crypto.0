From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 4/8] crypto: api - Add type init function to crypto_tfm
Date: Wed, 17 Dec 2008 17:36:39 +0100
Message-ID: <20081217164036.660327919@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65194 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751411AbYLQQmD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:03 -0500
Content-Disposition: inline; filename=crypto-add-tfm-init.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Add a type init function to crypto_tfm, so transforms can override the =
default
action of calling the algorithm's cra_init() method.

This will be used by the "comp" compatibility layer for the "pcomp" typ=
e, which
needs to call the algorithm's coa_setup() method, in addition to the cr=
a_init()
method.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/api.c           |   20 ++++++++++++++++----
 include/linux/crypto.h |    1 +
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/crypto/api.c
+++ b/crypto/api.c
@@ -390,8 +390,14 @@ struct crypto_tfm *__crypto_alloc_tfm(st
 	if (err)
 		goto out_free_tfm;
=20
-	if (!tfm->exit && alg->cra_init && (err =3D alg->cra_init(tfm)))
-		goto cra_init_failed;
+	if (!tfm->exit) {
+		if (tfm->init)
+			err =3D tfm->init(tfm);
+		else if (alg->cra_init)
+			err =3D alg->cra_init(tfm);
+		if (err)
+			goto cra_init_failed;
+	}
=20
 	goto out;
=20
@@ -487,8 +493,14 @@ struct crypto_tfm *crypto_create_tfm(str
 	if (err)
 		goto out_free_tfm;
=20
-	if (!tfm->exit && alg->cra_init && (err =3D alg->cra_init(tfm)))
-		goto cra_init_failed;
+	if (!tfm->exit) {
+		if (tfm->init)
+			err =3D tfm->init(tfm);
+		else if (alg->cra_init)
+			err =3D alg->cra_init(tfm);
+		if (err)
+			goto cra_init_failed;
+	}
=20
 	goto out;
=20
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -527,6 +527,7 @@ struct crypto_tfm {
 		struct rng_tfm rng;
 	} crt_u;
=20
+	int (*init)(struct crypto_tfm *tfm);
 	void (*exit)(struct crypto_tfm *tfm);
 =09
 	struct crypto_alg *__crt_alg;

--=20
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

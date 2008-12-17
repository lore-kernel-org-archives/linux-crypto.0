From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 7/8] crypto: testmgr - swith deflate test to pcomp
Date: Wed, 17 Dec 2008 17:36:42 +0100
Message-ID: <20081217164036.848760163@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65211 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751968AbYLQQmD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:03 -0500
Content-Disposition: inline; filename=crypto-convert-deflate-test-to-pcomp.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Change the tests for the "deflate" crypto module from the "comp" to the=
 "pcomp"
test framework.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.c |    4 ++--
 crypto/testmgr.h |   25 +++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 4 deletions(-)

--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1389,9 +1389,9 @@ static const struct alg_test_desc alg_te
 		}
 	}, {
 		.alg =3D "deflate",
-		.test =3D alg_test_comp,
+		.test =3D alg_test_pcomp,
 		.suite =3D {
-			.comp =3D {
+			.pcomp =3D {
 				.comp =3D {
 					.vecs =3D deflate_comp_tv_template,
 					.count =3D DEFLATE_COMP_TEST_VECTORS
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -15,6 +15,8 @@
 #ifndef _CRYPTO_TESTMGR_H
 #define _CRYPTO_TESTMGR_H
=20
+#include <linux/zlib.h>
+
 #define MAX_DIGEST_SIZE		64
 #define MAX_TAP			8
=20
@@ -8358,11 +8360,27 @@ struct pcomp_testvec {
  * Deflate test vectors (null-terminated strings).
  * Params: winbits=3D-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
  */
+
+static const struct deflate_comp_params deflate_comp_params =3D {
+	.enable_comp		=3D 1,
+	.windowBits		=3D -11,
+	.level			=3D Z_DEFAULT_COMPRESSION,
+	.method			=3D Z_DEFLATED,
+	.memLevel		=3D MAX_MEM_LEVEL,
+	.strategy		=3D Z_DEFAULT_STRATEGY
+};
+
+static const struct deflate_comp_params deflate_decomp_params =3D {
+	.enable_decomp		=3D 1,
+	.windowBits		=3D -11,
+};
+
 #define DEFLATE_COMP_TEST_VECTORS 2
 #define DEFLATE_DECOMP_TEST_VECTORS 2
=20
-static struct comp_testvec deflate_comp_tv_template[] =3D {
+static struct pcomp_testvec deflate_comp_tv_template[] =3D {
 	{
+		.params =3D &deflate_comp_params,
 		.inlen	=3D 70,
 		.outlen	=3D 38,
 		.input	=3D "Join us now and share the software "
@@ -8373,6 +8391,7 @@ static struct comp_testvec deflate_comp_
 			  "\x48\x55\x28\xce\x4f\x2b\x29\x07"
 			  "\x71\xbc\x08\x2b\x01\x00",
 	}, {
+		.params =3D &deflate_comp_params,
 		.inlen	=3D 191,
 		.outlen	=3D 122,
 		.input	=3D "This document describes a compression method based on th=
e DEFLATE"
@@ -8397,8 +8416,9 @@ static struct comp_testvec deflate_comp_
 	},
 };
=20
-static struct comp_testvec deflate_decomp_tv_template[] =3D {
+static struct pcomp_testvec deflate_decomp_tv_template[] =3D {
 	{
+		.params =3D &deflate_decomp_params,
 		.inlen	=3D 122,
 		.outlen	=3D 191,
 		.input	=3D "\x5d\x8d\x31\x0e\xc2\x30\x10\x04"
@@ -8421,6 +8441,7 @@ static struct comp_testvec deflate_decom
 			"compression algorithm.  This document defines the application of "
 			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
 	}, {
+		.params =3D &deflate_decomp_params,
 		.inlen	=3D 38,
 		.outlen	=3D 70,
 		.input	=3D "\xf3\xca\xcf\xcc\x53\x28\x2d\x56"

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

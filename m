From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 1/8] crypto: testmgr - Correct comment about deflate parameters
Date: Wed, 17 Dec 2008 17:36:36 +0100
Message-ID: <20081217164036.475086811@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65182 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752047AbYLQQmF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:05 -0500
Content-Disposition: inline; filename=crypto-testmgr-correct-deflate-windowbits.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

The comment for the deflate test vectors says the winbits parameter is =
11,
while the deflate module actually uses -11 (a negative window bits para=
meter
enables the raw deflate format instead of the zlib format).
Correct this, to avoid confusion about the format used.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -8349,7 +8349,7 @@ struct comp_testvec {
=20
 /*
  * Deflate test vectors (null-terminated strings).
- * Params: winbits=3D11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
+ * Params: winbits=3D-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
  */
 #define DEFLATE_COMP_TEST_VECTORS 2
 #define DEFLATE_DECOMP_TEST_VECTORS 2

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

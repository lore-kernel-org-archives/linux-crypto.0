From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 3/4] crypto: Add a test for the "zlib" crypto module
Date: Mon, 24 Nov 2008 17:13:26 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811241713070.9844@vixen.sonytel.be>
References: <20080829134158.108976037@vixen.sonytel.be>
 <20080829134418.874948211@vixen.sonytel.be> <20080830062315.GA18441@gondor.apana.org.au>
 <Pine.LNX.4.64.0811241700100.9844@vixen.sonytel.be>
 <Pine.LNX.4.64.0811241711510.9844@vixen.sonytel.be>
 <Pine.LNX.4.64.0811241712390.9844@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51176 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753143AbYKXQN1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 11:13:27 -0500
In-Reply-To: <Pine.LNX.4.64.0811241712390.9844@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 tcrypt.c  |    6 +++-
 testmgr.c |   15 +++++++++++
 testmgr.h |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++
 3 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 28a45a1..c3c9124 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -53,7 +53,7 @@ static char *check[] =3D {
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
 	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256", "rmd320"=
,
-	"lzo", "cts", NULL
+	"lzo", "cts", "zlib", NULL
 };
=20
 static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc,
@@ -661,6 +661,10 @@ static void do_test(int m)
 		tcrypt_test("ecb(seed)");
 		break;
=20
+	case 44:
+		tcrypt_test("zlib");
+		break;
+
 	case 100:
 		tcrypt_test("hmac(md5)");
 		break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b828c6c..9320bb8 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1770,6 +1770,21 @@ static const struct alg_test_desc alg_test_descs=
[] =3D {
 				}
 			}
 		}
+	}, {
+		.alg =3D "zlib",
+		.test =3D alg_test_comp,
+		.suite =3D {
+			.comp =3D {
+				.comp =3D {
+					.vecs =3D zlib_comp_tv_template,
+					.count =3D ZLIB_COMP_TEST_VECTORS
+				},
+				.decomp =3D {
+					.vecs =3D zlib_decomp_tv_template,
+					.count =3D ZLIB_DECOMP_TEST_VECTORS
+				}
+			}
+		}
 	}
 };
=20
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index dee94d9..6307b42 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -8509,6 +8509,87 @@ static struct comp_testvec lzo_decomp_tv_templat=
e[] =3D {
 };
=20
 /*
+ * Zlib test vectors (null-terminated strings).
+ * Params: winbits=3DDEF_WBITS, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
+ */
+#define ZLIB_COMP_TEST_VECTORS 2
+#define ZLIB_DECOMP_TEST_VECTORS 2
+
+static struct comp_testvec zlib_comp_tv_template[] =3D {
+	{
+		.inlen	=3D 70,
+		.outlen	=3D 44,
+		.input	=3D "Join us now and share the software "
+			"Join us now and share the software ",
+		.output	=3D "\x78\x9c\xf3\xca\xcf\xcc\x53\x28"
+			  "\x2d\x56\xc8\xcb\x2f\x57\x48\xcc"
+			  "\x4b\x51\x28\xce\x48\x2c\x4a\x55"
+			  "\x28\xc9\x48\x55\x28\xce\x4f\x2b"
+			  "\x29\x07\x71\xbc\x08\x2b\x01\x00"
+			  "\x7c\x65\x19\x3d",
+	}, {
+		.inlen	=3D 191,
+		.outlen	=3D 128,
+		.input	=3D "This document describes a compression method based on th=
e DEFLATE"
+			"compression algorithm.  This document defines the application of "
+			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
+		.output	=3D "\x78\x9c\x5d\x8d\x31\x0e\xc2\x30"
+			  "\x10\x04\xbf\xb2\x2f\xc8\x1f\x10"
+			  "\x04\x09\x89\xc2\x85\x3f\x70\xb1"
+			  "\x2f\xf8\x24\xdb\x67\xd9\x47\xc1"
+			  "\xef\x49\x68\x12\x51\xae\x76\x67"
+			  "\xd6\x27\x19\x88\x1a\xde\x85\xab"
+			  "\x21\xf2\x08\x5d\x16\x1e\x20\x04"
+			  "\x2d\xad\xf3\x18\xa2\x15\x85\x2d"
+			  "\x69\xc4\x42\x83\x23\xb6\x6c\x89"
+			  "\x71\x9b\xef\xcf\x8b\x9f\xcf\x33"
+			  "\xca\x2f\xed\x62\xa9\x4c\x80\xff"
+			  "\x13\xaf\x52\x37\xed\x0e\x52\x6b"
+			  "\x59\x02\xd9\x4e\xe8\x7a\x76\x1d"
+			  "\x02\x98\xfe\x8a\x87\x83\xa3\x4f"
+			  "\x56\x8a\xb8\x9e\x8e\x5c\x57\xd3"
+			  "\xa0\x79\xfa\x02\x2e\x32\x45\x4e",
+	},
+};
+
+static struct comp_testvec zlib_decomp_tv_template[] =3D {
+	{
+		.inlen	=3D 128,
+		.outlen	=3D 191,
+		.input	=3D "\x78\x9c\x5d\x8d\x31\x0e\xc2\x30"
+			  "\x10\x04\xbf\xb2\x2f\xc8\x1f\x10"
+			  "\x04\x09\x89\xc2\x85\x3f\x70\xb1"
+			  "\x2f\xf8\x24\xdb\x67\xd9\x47\xc1"
+			  "\xef\x49\x68\x12\x51\xae\x76\x67"
+			  "\xd6\x27\x19\x88\x1a\xde\x85\xab"
+			  "\x21\xf2\x08\x5d\x16\x1e\x20\x04"
+			  "\x2d\xad\xf3\x18\xa2\x15\x85\x2d"
+			  "\x69\xc4\x42\x83\x23\xb6\x6c\x89"
+			  "\x71\x9b\xef\xcf\x8b\x9f\xcf\x33"
+			  "\xca\x2f\xed\x62\xa9\x4c\x80\xff"
+			  "\x13\xaf\x52\x37\xed\x0e\x52\x6b"
+			  "\x59\x02\xd9\x4e\xe8\x7a\x76\x1d"
+			  "\x02\x98\xfe\x8a\x87\x83\xa3\x4f"
+			  "\x56\x8a\xb8\x9e\x8e\x5c\x57\xd3"
+			  "\xa0\x79\xfa\x02\x2e\x32\x45\x4e",
+		.output	=3D "This document describes a compression method based on t=
he DEFLATE"
+			"compression algorithm.  This document defines the application of "
+			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
+	}, {
+		.inlen	=3D 44,
+		.outlen	=3D 70,
+		.input	=3D "\x78\x9c\xf3\xca\xcf\xcc\x53\x28"
+			  "\x2d\x56\xc8\xcb\x2f\x57\x48\xcc"
+			  "\x4b\x51\x28\xce\x48\x2c\x4a\x55"
+			  "\x28\xc9\x48\x55\x28\xce\x4f\x2b"
+			  "\x29\x07\x71\xbc\x08\x2b\x01\x00"
+			  "\x7c\x65\x19\x3d",
+		.output	=3D "Join us now and share the software "
+			"Join us now and share the software ",
+	},
+};
+
+/*
  * Michael MIC test vectors from IEEE 802.11i
  */
 #define MICHAEL_MIC_TEST_VECTORS 6

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

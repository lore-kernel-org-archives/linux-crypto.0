From: "Wang, Shane" <shane.wang@intel.com>
Subject: RE: [PATCH] to fix vmac test fails on s390
Date: Sun, 21 Feb 2010 13:32:49 +0800
Message-ID: <6CADD16F56BC954D8E28F3836FA7ED71282AC1E357@shzsmsx501.ccr.corp.intel.com>
References: <1263477930.5880.22.camel@bender>
 <20100117110546.GA32690@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_6CADD16F56BC954D8E28F3836FA7ED71282AC1E357shzsmsx501ccr_"
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Jan Glauber <jang@linux.vnet.ibm.com>,
	"Cihula, Joseph" <joseph.cihula@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41495 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab0BUFdc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Feb 2010 00:33:32 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--_002_6CADD16F56BC954D8E28F3836FA7ED71282AC1E357shzsmsx501ccr_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<Updated & Resend>

This patch is to fix the vmac algorithm, add more test cases for vmac, and =
fix the test failure on some big endian system like s390.

Signed-off-by: Shane Wang <shane.wang@intel.com>

crypto/testmgr.h |   64 +++++++++++++++++++++++++++++++++++--
crypto/vmac.c    |   77 ++++++++++++++++++++++-----------------------
2 files changed, 99 insertions(+), 42 deletions(-)

diff -r 91636f5ce7a2 crypto/testmgr.h
--- a/crypto/testmgr.h	Thu Feb 11 00:45:57 2010 -0800
+++ b/crypto/testmgr.h	Sun Feb 21 02:23:01 2010 -0800
@@ -1669,17 +1669,73 @@ static struct hash_testvec aes_xcbc128_t
 	}
 };
=20
-#define VMAC_AES_TEST_VECTORS	1
-static char vmac_string[128] =3D {'\x01', '\x01', '\x01', '\x01',
+#define VMAC_AES_TEST_VECTORS	8
+static char vmac_string1[128] =3D {'\x01', '\x01', '\x01', '\x01',
 				'\x02', '\x03', '\x02', '\x02',
 				'\x02', '\x04', '\x01', '\x07',
 				'\x04', '\x01', '\x04', '\x03',};
+static char vmac_string2[128] =3D {'a', 'b', 'c',};
+static char vmac_string3[128] =3D {'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				};
+
 static struct hash_testvec aes_vmac128_tv_template[] =3D {
 	{
+		.key	=3D "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.plaintext =3D NULL,
+		.digest	=3D "\x07\x58\x80\x35\x77\xa4\x7b\x54",
+		.psize	=3D 0,
+		.ksize	=3D 16,
+	}, {
 		.key    =3D "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
-		.plaintext =3D vmac_string,
-		.digest =3D "\xcb\xd7\x8a\xfd\xb7\x33\x79\xe7",
+		.plaintext =3D vmac_string1,
+		.digest =3D "\xce\xf5\x3c\xd3\xae\x68\x8c\xa1",
+		.psize  =3D 128,
+		.ksize  =3D 16,
+	}, {
+		.key    =3D "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.plaintext =3D vmac_string2,
+		.digest =3D "\xc9\x27\xb0\x73\x81\xbd\x14\x2d",
+		.psize  =3D 128,
+		.ksize  =3D 16,
+	}, {
+		.key    =3D "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.plaintext =3D vmac_string3,
+		.digest =3D "\x8d\x1a\x95\x8c\x98\x47\x0b\x19",
+		.psize  =3D 128,
+		.ksize  =3D 16,
+	}, {
+		.key	=3D "abcdefghijklmnop",
+		.plaintext =3D NULL,
+		.digest	=3D "\x3b\x89\xa1\x26\x9e\x55\x8f\x84",
+		.psize	=3D 0,
+		.ksize	=3D 16,
+	}, {
+		.key    =3D "abcdefghijklmnop",
+		.plaintext =3D vmac_string1,
+		.digest =3D "\xab\x5e\xab\xb0\xf6\x8d\x74\xc2",
+		.psize  =3D 128,
+		.ksize  =3D 16,
+	}, {
+		.key    =3D "abcdefghijklmnop",
+		.plaintext =3D vmac_string2,
+		.digest =3D "\x11\x15\x68\x42\x3d\x7b\x09\xdf",
+		.psize  =3D 128,
+		.ksize  =3D 16,
+	}, {
+		.key    =3D "abcdefghijklmnop",
+		.plaintext =3D vmac_string3,
+		.digest =3D "\x8b\x32\x8f\xe1\xed\x8f\xfa\xd4",
 		.psize  =3D 128,
 		.ksize  =3D 16,
 	},
diff -r 91636f5ce7a2 crypto/vmac.c
--- a/crypto/vmac.c	Thu Feb 11 00:45:57 2010 -0800
+++ b/crypto/vmac.c	Sun Feb 21 02:23:01 2010 -0800
@@ -42,6 +42,8 @@ const u64 m63   =3D UINT64_C(0x7ffffffffff
 const u64 m63   =3D UINT64_C(0x7fffffffffffffff);  /* 63-bit mask       */
 const u64 m64   =3D UINT64_C(0xffffffffffffffff);  /* 64-bit mask       */
 const u64 mpoly =3D UINT64_C(0x1fffffff1fffffff);  /* Poly key mask     */
+
+#define pe64_to_cpup le64_to_cpup		/* Prefer little endian */
=20
 #ifdef __LITTLE_ENDIAN
 #define INDEX_HIGH 1
@@ -110,8 +112,8 @@ const u64 mpoly =3D UINT64_C(0x1fffffff1ff
 		int i; u64 th, tl;					\
 		rh =3D rl =3D 0;						\
 		for (i =3D 0; i < nw; i +=3D 2) {				\
-			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i],	\
-				le64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i],	\
+				pe64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
 			ADD128(rh, rl, th, tl);				\
 		}							\
 	} while (0)
@@ -121,11 +123,11 @@ const u64 mpoly =3D UINT64_C(0x1fffffff1ff
 		int i; u64 th, tl;					\
 		rh1 =3D rl1 =3D rh =3D rl =3D 0;				\
 		for (i =3D 0; i < nw; i +=3D 2) {				\
-			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i],	\
-				le64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i],	\
+				pe64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
 			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i+2],	\
-				le64_to_cpup((mp)+i+1)+(kp)[i+3]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i+2],	\
+				pe64_to_cpup((mp)+i+1)+(kp)[i+3]);	\
 			ADD128(rh1, rl1, th, tl);			\
 		}							\
 	} while (0)
@@ -136,17 +138,17 @@ const u64 mpoly =3D UINT64_C(0x1fffffff1ff
 		int i; u64 th, tl;					\
 		rh =3D rl =3D 0;						\
 		for (i =3D 0; i < nw; i +=3D 8) {				\
-			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i],	\
-				le64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i],	\
+				pe64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
 			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, le64_to_cpup((mp)+i+2)+(kp)[i+2],	\
-				le64_to_cpup((mp)+i+3)+(kp)[i+3]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i+2)+(kp)[i+2],	\
+				pe64_to_cpup((mp)+i+3)+(kp)[i+3]);	\
 			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, le64_to_cpup((mp)+i+4)+(kp)[i+4],	\
-				le64_to_cpup((mp)+i+5)+(kp)[i+5]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i+4)+(kp)[i+4],	\
+				pe64_to_cpup((mp)+i+5)+(kp)[i+5]);	\
 			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, le64_to_cpup((mp)+i+6)+(kp)[i+6],	\
-				le64_to_cpup((mp)+i+7)+(kp)[i+7]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i+6)+(kp)[i+6],	\
+				pe64_to_cpup((mp)+i+7)+(kp)[i+7]);	\
 			ADD128(rh, rl, th, tl);				\
 		}							\
 	} while (0)
@@ -156,29 +158,29 @@ const u64 mpoly =3D UINT64_C(0x1fffffff1ff
 		int i; u64 th, tl;					\
 		rh1 =3D rl1 =3D rh =3D rl =3D 0;				\
 		for (i =3D 0; i < nw; i +=3D 8) {				\
-			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i],	\
-				le64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i],	\
+				pe64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
 			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i+2],	\
-				le64_to_cpup((mp)+i+1)+(kp)[i+3]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i+2],	\
+				pe64_to_cpup((mp)+i+1)+(kp)[i+3]);	\
 			ADD128(rh1, rl1, th, tl);			\
-			MUL64(th, tl, le64_to_cpup((mp)+i+2)+(kp)[i+2],	\
-				le64_to_cpup((mp)+i+3)+(kp)[i+3]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i+2)+(kp)[i+2],	\
+				pe64_to_cpup((mp)+i+3)+(kp)[i+3]);	\
 			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, le64_to_cpup((mp)+i+2)+(kp)[i+4],	\
-				le64_to_cpup((mp)+i+3)+(kp)[i+5]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i+2)+(kp)[i+4],	\
+				pe64_to_cpup((mp)+i+3)+(kp)[i+5]);	\
 			ADD128(rh1, rl1, th, tl);			\
-			MUL64(th, tl, le64_to_cpup((mp)+i+4)+(kp)[i+4],	\
-				le64_to_cpup((mp)+i+5)+(kp)[i+5]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i+4)+(kp)[i+4],	\
+				pe64_to_cpup((mp)+i+5)+(kp)[i+5]);	\
 			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, le64_to_cpup((mp)+i+4)+(kp)[i+6],	\
-				le64_to_cpup((mp)+i+5)+(kp)[i+7]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i+4)+(kp)[i+6],	\
+				pe64_to_cpup((mp)+i+5)+(kp)[i+7]);	\
 			ADD128(rh1, rl1, th, tl);			\
-			MUL64(th, tl, le64_to_cpup((mp)+i+6)+(kp)[i+6],	\
-				le64_to_cpup((mp)+i+7)+(kp)[i+7]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i+6)+(kp)[i+6],	\
+				pe64_to_cpup((mp)+i+7)+(kp)[i+7]);	\
 			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, le64_to_cpup((mp)+i+6)+(kp)[i+8],	\
-				le64_to_cpup((mp)+i+7)+(kp)[i+9]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i+6)+(kp)[i+8],	\
+				pe64_to_cpup((mp)+i+7)+(kp)[i+9]);	\
 			ADD128(rh1, rl1, th, tl);			\
 		}							\
 	} while (0)
@@ -216,8 +218,8 @@ const u64 mpoly =3D UINT64_C(0x1fffffff1ff
 		int i;							\
 		rh =3D rl =3D t =3D 0;					\
 		for (i =3D 0; i < nw; i +=3D 2)  {				\
-			t1 =3D le64_to_cpup(mp+i) + kp[i];		\
-			t2 =3D le64_to_cpup(mp+i+1) + kp[i+1];		\
+			t1 =3D pe64_to_cpup(mp+i) + kp[i];		\
+			t2 =3D pe64_to_cpup(mp+i+1) + kp[i+1];		\
 			m2 =3D MUL32(t1 >> 32, t2);			\
 			m1 =3D MUL32(t1, t2 >> 32);			\
 			ADD128(rh, rl, MUL32(t1 >> 32, t2 >> 32),	\
@@ -322,8 +324,7 @@ static void vhash_abort(struct vmac_ctx=20
 	ctx->first_block_processed =3D 0;
 }
=20
-static u64 l3hash(u64 p1, u64 p2,
-			u64 k1, u64 k2, u64 len)
+static u64 l3hash(u64 p1, u64 p2, u64 k1, u64 k2, u64 len)
 {
 	u64 rh, rl, t, z =3D 0;
=20
@@ -549,10 +550,6 @@ static int vmac_setkey(struct crypto_sha
=20
 static int vmac_init(struct shash_desc *pdesc)
 {
-	struct crypto_shash *parent =3D pdesc->tfm;
-	struct vmac_ctx_t *ctx =3D crypto_shash_ctx(parent);
-
-	memset(&ctx->__vmac_ctx, 0, sizeof(struct vmac_ctx));
 	return 0;
 }
=20
@@ -575,6 +572,10 @@ static int vmac_final(struct shash_desc=20
 	u8 nonce[16] =3D {};
=20
 	mac =3D vmac(NULL, 0, nonce, NULL, ctx);
+
+	/* set output invariant considering endianness */
+	mac =3D le64_to_cpup(&mac);
+
 	memcpy(out, &mac, sizeof(vmac_t));
 	memset(&mac, 0, sizeof(vmac_t));
 	memset(&ctx->__vmac_ctx, 0, sizeof(struct vmac_ctx));=

--_002_6CADD16F56BC954D8E28F3836FA7ED71282AC1E357shzsmsx501ccr_
Content-Type: application/octet-stream; name="vmac_fix.patch"
Content-Description: vmac_fix.patch
Content-Disposition: attachment; filename="vmac_fix.patch"; size=8564;
	creation-date="Sat, 21 Feb 2009 05:27:00 GMT";
	modification-date="Sat, 21 Feb 2009 05:27:00 GMT"
Content-Transfer-Encoding: base64

VGhpcyBwYXRjaCBpcyB0byBmaXggdGhlIHZtYWMgYWxnb3JpdGhtLCBhZGQgbW9yZSB0ZXN0IGNh
c2VzIGZvciB2bWFjLCBhbmQgZml4IHRoZSB0ZXN0IGZhaWx1cmUgb24gc29tZSBiaWcgZW5kaWFu
IHN5c3RlbSBsaWtlIHMzOTAuCgpTaWduZWQtb2ZmLWJ5OiBTaGFuZSBXYW5nIDxzaGFuZS53YW5n
QGludGVsLmNvbT4KCmRpZmYgLXIgOTE2MzZmNWNlN2EyIGNyeXB0by90ZXN0bWdyLmgKLS0tIGEv
Y3J5cHRvL3Rlc3RtZ3IuaAlUaHUgRmViIDExIDAwOjQ1OjU3IDIwMTAgLTA4MDAKKysrIGIvY3J5
cHRvL3Rlc3RtZ3IuaAlTdW4gRmViIDIxIDAyOjIzOjAxIDIwMTAgLTA4MDAKQEAgLTE2NjksMTcg
KzE2NjksNzMgQEAgc3RhdGljIHN0cnVjdCBoYXNoX3Rlc3R2ZWMgYWVzX3hjYmMxMjhfdAogCX0K
IH07CiAKLSNkZWZpbmUgVk1BQ19BRVNfVEVTVF9WRUNUT1JTCTEKLXN0YXRpYyBjaGFyIHZtYWNf
c3RyaW5nWzEyOF0gPSB7J1x4MDEnLCAnXHgwMScsICdceDAxJywgJ1x4MDEnLAorI2RlZmluZSBW
TUFDX0FFU19URVNUX1ZFQ1RPUlMJOAorc3RhdGljIGNoYXIgdm1hY19zdHJpbmcxWzEyOF0gPSB7
J1x4MDEnLCAnXHgwMScsICdceDAxJywgJ1x4MDEnLAogCQkJCSdceDAyJywgJ1x4MDMnLCAnXHgw
MicsICdceDAyJywKIAkJCQknXHgwMicsICdceDA0JywgJ1x4MDEnLCAnXHgwNycsCiAJCQkJJ1x4
MDQnLCAnXHgwMScsICdceDA0JywgJ1x4MDMnLH07CitzdGF0aWMgY2hhciB2bWFjX3N0cmluZzJb
MTI4XSA9IHsnYScsICdiJywgJ2MnLH07CitzdGF0aWMgY2hhciB2bWFjX3N0cmluZzNbMTI4XSA9
IHsnYScsICdiJywgJ2MnLCAnYScsICdiJywgJ2MnLAorCQkJCSdhJywgJ2InLCAnYycsICdhJywg
J2InLCAnYycsCisJCQkJJ2EnLCAnYicsICdjJywgJ2EnLCAnYicsICdjJywKKwkJCQknYScsICdi
JywgJ2MnLCAnYScsICdiJywgJ2MnLAorCQkJCSdhJywgJ2InLCAnYycsICdhJywgJ2InLCAnYycs
CisJCQkJJ2EnLCAnYicsICdjJywgJ2EnLCAnYicsICdjJywKKwkJCQknYScsICdiJywgJ2MnLCAn
YScsICdiJywgJ2MnLAorCQkJCSdhJywgJ2InLCAnYycsICdhJywgJ2InLCAnYycsCisJCQkJfTsK
Kwogc3RhdGljIHN0cnVjdCBoYXNoX3Rlc3R2ZWMgYWVzX3ZtYWMxMjhfdHZfdGVtcGxhdGVbXSA9
IHsKIAl7CisJCS5rZXkJPSAiXHgwMFx4MDFceDAyXHgwM1x4MDRceDA1XHgwNlx4MDciCisJCQkg
ICJceDA4XHgwOVx4MGFceDBiXHgwY1x4MGRceDBlXHgwZiIsCisJCS5wbGFpbnRleHQgPSBOVUxM
LAorCQkuZGlnZXN0CT0gIlx4MDdceDU4XHg4MFx4MzVceDc3XHhhNFx4N2JceDU0IiwKKwkJLnBz
aXplCT0gMCwKKwkJLmtzaXplCT0gMTYsCisJfSwgewogCQkua2V5ICAgID0gIlx4MDBceDAxXHgw
Mlx4MDNceDA0XHgwNVx4MDZceDA3IgogCQkJICAiXHgwOFx4MDlceDBhXHgwYlx4MGNceDBkXHgw
ZVx4MGYiLAotCQkucGxhaW50ZXh0ID0gdm1hY19zdHJpbmcsCi0JCS5kaWdlc3QgPSAiXHhjYlx4
ZDdceDhhXHhmZFx4YjdceDMzXHg3OVx4ZTciLAorCQkucGxhaW50ZXh0ID0gdm1hY19zdHJpbmcx
LAorCQkuZGlnZXN0ID0gIlx4Y2VceGY1XHgzY1x4ZDNceGFlXHg2OFx4OGNceGExIiwKKwkJLnBz
aXplICA9IDEyOCwKKwkJLmtzaXplICA9IDE2LAorCX0sIHsKKwkJLmtleSAgICA9ICJceDAwXHgw
MVx4MDJceDAzXHgwNFx4MDVceDA2XHgwNyIKKwkJCSAgIlx4MDhceDA5XHgwYVx4MGJceDBjXHgw
ZFx4MGVceDBmIiwKKwkJLnBsYWludGV4dCA9IHZtYWNfc3RyaW5nMiwKKwkJLmRpZ2VzdCA9ICJc
eGM5XHgyN1x4YjBceDczXHg4MVx4YmRceDE0XHgyZCIsCisJCS5wc2l6ZSAgPSAxMjgsCisJCS5r
c2l6ZSAgPSAxNiwKKwl9LCB7CisJCS5rZXkgICAgPSAiXHgwMFx4MDFceDAyXHgwM1x4MDRceDA1
XHgwNlx4MDciCisJCQkgICJceDA4XHgwOVx4MGFceDBiXHgwY1x4MGRceDBlXHgwZiIsCisJCS5w
bGFpbnRleHQgPSB2bWFjX3N0cmluZzMsCisJCS5kaWdlc3QgPSAiXHg4ZFx4MWFceDk1XHg4Y1x4
OThceDQ3XHgwYlx4MTkiLAorCQkucHNpemUgID0gMTI4LAorCQkua3NpemUgID0gMTYsCisJfSwg
eworCQkua2V5CT0gImFiY2RlZmdoaWprbG1ub3AiLAorCQkucGxhaW50ZXh0ID0gTlVMTCwKKwkJ
LmRpZ2VzdAk9ICJceDNiXHg4OVx4YTFceDI2XHg5ZVx4NTVceDhmXHg4NCIsCisJCS5wc2l6ZQk9
IDAsCisJCS5rc2l6ZQk9IDE2LAorCX0sIHsKKwkJLmtleSAgICA9ICJhYmNkZWZnaGlqa2xtbm9w
IiwKKwkJLnBsYWludGV4dCA9IHZtYWNfc3RyaW5nMSwKKwkJLmRpZ2VzdCA9ICJceGFiXHg1ZVx4
YWJceGIwXHhmNlx4OGRceDc0XHhjMiIsCisJCS5wc2l6ZSAgPSAxMjgsCisJCS5rc2l6ZSAgPSAx
NiwKKwl9LCB7CisJCS5rZXkgICAgPSAiYWJjZGVmZ2hpamtsbW5vcCIsCisJCS5wbGFpbnRleHQg
PSB2bWFjX3N0cmluZzIsCisJCS5kaWdlc3QgPSAiXHgxMVx4MTVceDY4XHg0Mlx4M2RceDdiXHgw
OVx4ZGYiLAorCQkucHNpemUgID0gMTI4LAorCQkua3NpemUgID0gMTYsCisJfSwgeworCQkua2V5
ICAgID0gImFiY2RlZmdoaWprbG1ub3AiLAorCQkucGxhaW50ZXh0ID0gdm1hY19zdHJpbmczLAor
CQkuZGlnZXN0ID0gIlx4OGJceDMyXHg4Zlx4ZTFceGVkXHg4Zlx4ZmFceGQ0IiwKIAkJLnBzaXpl
ICA9IDEyOCwKIAkJLmtzaXplICA9IDE2LAogCX0sCmRpZmYgLXIgOTE2MzZmNWNlN2EyIGNyeXB0
by92bWFjLmMKLS0tIGEvY3J5cHRvL3ZtYWMuYwlUaHUgRmViIDExIDAwOjQ1OjU3IDIwMTAgLTA4
MDAKKysrIGIvY3J5cHRvL3ZtYWMuYwlTdW4gRmViIDIxIDAyOjIzOjAxIDIwMTAgLTA4MDAKQEAg
LTQyLDYgKzQyLDggQEAgY29uc3QgdTY0IG02MyAgID0gVUlOVDY0X0MoMHg3ZmZmZmZmZmZmZgog
Y29uc3QgdTY0IG02MyAgID0gVUlOVDY0X0MoMHg3ZmZmZmZmZmZmZmZmZmZmKTsgIC8qIDYzLWJp
dCBtYXNrICAgICAgICovCiBjb25zdCB1NjQgbTY0ICAgPSBVSU5UNjRfQygweGZmZmZmZmZmZmZm
ZmZmZmYpOyAgLyogNjQtYml0IG1hc2sgICAgICAgKi8KIGNvbnN0IHU2NCBtcG9seSA9IFVJTlQ2
NF9DKDB4MWZmZmZmZmYxZmZmZmZmZik7ICAvKiBQb2x5IGtleSBtYXNrICAgICAqLworCisjZGVm
aW5lIHBlNjRfdG9fY3B1cCBsZTY0X3RvX2NwdXAJCS8qIFByZWZlciBsaXR0bGUgZW5kaWFuICov
CiAKICNpZmRlZiBfX0xJVFRMRV9FTkRJQU4KICNkZWZpbmUgSU5ERVhfSElHSCAxCkBAIC0xMTAs
OCArMTEyLDggQEAgY29uc3QgdTY0IG1wb2x5ID0gVUlOVDY0X0MoMHgxZmZmZmZmZjFmZgogCQlp
bnQgaTsgdTY0IHRoLCB0bDsJCQkJCVwKIAkJcmggPSBybCA9IDA7CQkJCQkJXAogCQlmb3IgKGkg
PSAwOyBpIDwgbnc7IGkgKz0gMikgewkJCQlcCi0JCQlNVUw2NCh0aCwgdGwsIGxlNjRfdG9fY3B1
cCgobXApK2kpKyhrcClbaV0sCVwKLQkJCQlsZTY0X3RvX2NwdXAoKG1wKStpKzEpKyhrcClbaSsx
XSk7CVwKKwkJCU1VTDY0KHRoLCB0bCwgcGU2NF90b19jcHVwKChtcCkraSkrKGtwKVtpXSwJXAor
CQkJCXBlNjRfdG9fY3B1cCgobXApK2krMSkrKGtwKVtpKzFdKTsJXAogCQkJQUREMTI4KHJoLCBy
bCwgdGgsIHRsKTsJCQkJXAogCQl9CQkJCQkJCVwKIAl9IHdoaWxlICgwKQpAQCAtMTIxLDExICsx
MjMsMTEgQEAgY29uc3QgdTY0IG1wb2x5ID0gVUlOVDY0X0MoMHgxZmZmZmZmZjFmZgogCQlpbnQg
aTsgdTY0IHRoLCB0bDsJCQkJCVwKIAkJcmgxID0gcmwxID0gcmggPSBybCA9IDA7CQkJCVwKIAkJ
Zm9yIChpID0gMDsgaSA8IG53OyBpICs9IDIpIHsJCQkJXAotCQkJTVVMNjQodGgsIHRsLCBsZTY0
X3RvX2NwdXAoKG1wKStpKSsoa3ApW2ldLAlcCi0JCQkJbGU2NF90b19jcHVwKChtcCkraSsxKSso
a3ApW2krMV0pOwlcCisJCQlNVUw2NCh0aCwgdGwsIHBlNjRfdG9fY3B1cCgobXApK2kpKyhrcClb
aV0sCVwKKwkJCQlwZTY0X3RvX2NwdXAoKG1wKStpKzEpKyhrcClbaSsxXSk7CVwKIAkJCUFERDEy
OChyaCwgcmwsIHRoLCB0bCk7CQkJCVwKLQkJCU1VTDY0KHRoLCB0bCwgbGU2NF90b19jcHVwKCht
cCkraSkrKGtwKVtpKzJdLAlcCi0JCQkJbGU2NF90b19jcHVwKChtcCkraSsxKSsoa3ApW2krM10p
OwlcCisJCQlNVUw2NCh0aCwgdGwsIHBlNjRfdG9fY3B1cCgobXApK2kpKyhrcClbaSsyXSwJXAor
CQkJCXBlNjRfdG9fY3B1cCgobXApK2krMSkrKGtwKVtpKzNdKTsJXAogCQkJQUREMTI4KHJoMSwg
cmwxLCB0aCwgdGwpOwkJCVwKIAkJfQkJCQkJCQlcCiAJfSB3aGlsZSAoMCkKQEAgLTEzNiwxNyAr
MTM4LDE3IEBAIGNvbnN0IHU2NCBtcG9seSA9IFVJTlQ2NF9DKDB4MWZmZmZmZmYxZmYKIAkJaW50
IGk7IHU2NCB0aCwgdGw7CQkJCQlcCiAJCXJoID0gcmwgPSAwOwkJCQkJCVwKIAkJZm9yIChpID0g
MDsgaSA8IG53OyBpICs9IDgpIHsJCQkJXAotCQkJTVVMNjQodGgsIHRsLCBsZTY0X3RvX2NwdXAo
KG1wKStpKSsoa3ApW2ldLAlcCi0JCQkJbGU2NF90b19jcHVwKChtcCkraSsxKSsoa3ApW2krMV0p
OwlcCisJCQlNVUw2NCh0aCwgdGwsIHBlNjRfdG9fY3B1cCgobXApK2kpKyhrcClbaV0sCVwKKwkJ
CQlwZTY0X3RvX2NwdXAoKG1wKStpKzEpKyhrcClbaSsxXSk7CVwKIAkJCUFERDEyOChyaCwgcmws
IHRoLCB0bCk7CQkJCVwKLQkJCU1VTDY0KHRoLCB0bCwgbGU2NF90b19jcHVwKChtcCkraSsyKSso
a3ApW2krMl0sCVwKLQkJCQlsZTY0X3RvX2NwdXAoKG1wKStpKzMpKyhrcClbaSszXSk7CVwKKwkJ
CU1VTDY0KHRoLCB0bCwgcGU2NF90b19jcHVwKChtcCkraSsyKSsoa3ApW2krMl0sCVwKKwkJCQlw
ZTY0X3RvX2NwdXAoKG1wKStpKzMpKyhrcClbaSszXSk7CVwKIAkJCUFERDEyOChyaCwgcmwsIHRo
LCB0bCk7CQkJCVwKLQkJCU1VTDY0KHRoLCB0bCwgbGU2NF90b19jcHVwKChtcCkraSs0KSsoa3Ap
W2krNF0sCVwKLQkJCQlsZTY0X3RvX2NwdXAoKG1wKStpKzUpKyhrcClbaSs1XSk7CVwKKwkJCU1V
TDY0KHRoLCB0bCwgcGU2NF90b19jcHVwKChtcCkraSs0KSsoa3ApW2krNF0sCVwKKwkJCQlwZTY0
X3RvX2NwdXAoKG1wKStpKzUpKyhrcClbaSs1XSk7CVwKIAkJCUFERDEyOChyaCwgcmwsIHRoLCB0
bCk7CQkJCVwKLQkJCU1VTDY0KHRoLCB0bCwgbGU2NF90b19jcHVwKChtcCkraSs2KSsoa3ApW2kr
Nl0sCVwKLQkJCQlsZTY0X3RvX2NwdXAoKG1wKStpKzcpKyhrcClbaSs3XSk7CVwKKwkJCU1VTDY0
KHRoLCB0bCwgcGU2NF90b19jcHVwKChtcCkraSs2KSsoa3ApW2krNl0sCVwKKwkJCQlwZTY0X3Rv
X2NwdXAoKG1wKStpKzcpKyhrcClbaSs3XSk7CVwKIAkJCUFERDEyOChyaCwgcmwsIHRoLCB0bCk7
CQkJCVwKIAkJfQkJCQkJCQlcCiAJfSB3aGlsZSAoMCkKQEAgLTE1NiwyOSArMTU4LDI5IEBAIGNv
bnN0IHU2NCBtcG9seSA9IFVJTlQ2NF9DKDB4MWZmZmZmZmYxZmYKIAkJaW50IGk7IHU2NCB0aCwg
dGw7CQkJCQlcCiAJCXJoMSA9IHJsMSA9IHJoID0gcmwgPSAwOwkJCQlcCiAJCWZvciAoaSA9IDA7
IGkgPCBudzsgaSArPSA4KSB7CQkJCVwKLQkJCU1VTDY0KHRoLCB0bCwgbGU2NF90b19jcHVwKCht
cCkraSkrKGtwKVtpXSwJXAotCQkJCWxlNjRfdG9fY3B1cCgobXApK2krMSkrKGtwKVtpKzFdKTsJ
XAorCQkJTVVMNjQodGgsIHRsLCBwZTY0X3RvX2NwdXAoKG1wKStpKSsoa3ApW2ldLAlcCisJCQkJ
cGU2NF90b19jcHVwKChtcCkraSsxKSsoa3ApW2krMV0pOwlcCiAJCQlBREQxMjgocmgsIHJsLCB0
aCwgdGwpOwkJCQlcCi0JCQlNVUw2NCh0aCwgdGwsIGxlNjRfdG9fY3B1cCgobXApK2kpKyhrcClb
aSsyXSwJXAotCQkJCWxlNjRfdG9fY3B1cCgobXApK2krMSkrKGtwKVtpKzNdKTsJXAorCQkJTVVM
NjQodGgsIHRsLCBwZTY0X3RvX2NwdXAoKG1wKStpKSsoa3ApW2krMl0sCVwKKwkJCQlwZTY0X3Rv
X2NwdXAoKG1wKStpKzEpKyhrcClbaSszXSk7CVwKIAkJCUFERDEyOChyaDEsIHJsMSwgdGgsIHRs
KTsJCQlcCi0JCQlNVUw2NCh0aCwgdGwsIGxlNjRfdG9fY3B1cCgobXApK2krMikrKGtwKVtpKzJd
LAlcCi0JCQkJbGU2NF90b19jcHVwKChtcCkraSszKSsoa3ApW2krM10pOwlcCisJCQlNVUw2NCh0
aCwgdGwsIHBlNjRfdG9fY3B1cCgobXApK2krMikrKGtwKVtpKzJdLAlcCisJCQkJcGU2NF90b19j
cHVwKChtcCkraSszKSsoa3ApW2krM10pOwlcCiAJCQlBREQxMjgocmgsIHJsLCB0aCwgdGwpOwkJ
CQlcCi0JCQlNVUw2NCh0aCwgdGwsIGxlNjRfdG9fY3B1cCgobXApK2krMikrKGtwKVtpKzRdLAlc
Ci0JCQkJbGU2NF90b19jcHVwKChtcCkraSszKSsoa3ApW2krNV0pOwlcCisJCQlNVUw2NCh0aCwg
dGwsIHBlNjRfdG9fY3B1cCgobXApK2krMikrKGtwKVtpKzRdLAlcCisJCQkJcGU2NF90b19jcHVw
KChtcCkraSszKSsoa3ApW2krNV0pOwlcCiAJCQlBREQxMjgocmgxLCBybDEsIHRoLCB0bCk7CQkJ
XAotCQkJTVVMNjQodGgsIHRsLCBsZTY0X3RvX2NwdXAoKG1wKStpKzQpKyhrcClbaSs0XSwJXAot
CQkJCWxlNjRfdG9fY3B1cCgobXApK2krNSkrKGtwKVtpKzVdKTsJXAorCQkJTVVMNjQodGgsIHRs
LCBwZTY0X3RvX2NwdXAoKG1wKStpKzQpKyhrcClbaSs0XSwJXAorCQkJCXBlNjRfdG9fY3B1cCgo
bXApK2krNSkrKGtwKVtpKzVdKTsJXAogCQkJQUREMTI4KHJoLCBybCwgdGgsIHRsKTsJCQkJXAot
CQkJTVVMNjQodGgsIHRsLCBsZTY0X3RvX2NwdXAoKG1wKStpKzQpKyhrcClbaSs2XSwJXAotCQkJ
CWxlNjRfdG9fY3B1cCgobXApK2krNSkrKGtwKVtpKzddKTsJXAorCQkJTVVMNjQodGgsIHRsLCBw
ZTY0X3RvX2NwdXAoKG1wKStpKzQpKyhrcClbaSs2XSwJXAorCQkJCXBlNjRfdG9fY3B1cCgobXAp
K2krNSkrKGtwKVtpKzddKTsJXAogCQkJQUREMTI4KHJoMSwgcmwxLCB0aCwgdGwpOwkJCVwKLQkJ
CU1VTDY0KHRoLCB0bCwgbGU2NF90b19jcHVwKChtcCkraSs2KSsoa3ApW2krNl0sCVwKLQkJCQls
ZTY0X3RvX2NwdXAoKG1wKStpKzcpKyhrcClbaSs3XSk7CVwKKwkJCU1VTDY0KHRoLCB0bCwgcGU2
NF90b19jcHVwKChtcCkraSs2KSsoa3ApW2krNl0sCVwKKwkJCQlwZTY0X3RvX2NwdXAoKG1wKStp
KzcpKyhrcClbaSs3XSk7CVwKIAkJCUFERDEyOChyaCwgcmwsIHRoLCB0bCk7CQkJCVwKLQkJCU1V
TDY0KHRoLCB0bCwgbGU2NF90b19jcHVwKChtcCkraSs2KSsoa3ApW2krOF0sCVwKLQkJCQlsZTY0
X3RvX2NwdXAoKG1wKStpKzcpKyhrcClbaSs5XSk7CVwKKwkJCU1VTDY0KHRoLCB0bCwgcGU2NF90
b19jcHVwKChtcCkraSs2KSsoa3ApW2krOF0sCVwKKwkJCQlwZTY0X3RvX2NwdXAoKG1wKStpKzcp
KyhrcClbaSs5XSk7CVwKIAkJCUFERDEyOChyaDEsIHJsMSwgdGgsIHRsKTsJCQlcCiAJCX0JCQkJ
CQkJXAogCX0gd2hpbGUgKDApCkBAIC0yMTYsOCArMjE4LDggQEAgY29uc3QgdTY0IG1wb2x5ID0g
VUlOVDY0X0MoMHgxZmZmZmZmZjFmZgogCQlpbnQgaTsJCQkJCQkJXAogCQlyaCA9IHJsID0gdCA9
IDA7CQkJCQlcCiAJCWZvciAoaSA9IDA7IGkgPCBudzsgaSArPSAyKSAgewkJCQlcCi0JCQl0MSA9
IGxlNjRfdG9fY3B1cChtcCtpKSArIGtwW2ldOwkJXAotCQkJdDIgPSBsZTY0X3RvX2NwdXAobXAr
aSsxKSArIGtwW2krMV07CQlcCisJCQl0MSA9IHBlNjRfdG9fY3B1cChtcCtpKSArIGtwW2ldOwkJ
XAorCQkJdDIgPSBwZTY0X3RvX2NwdXAobXAraSsxKSArIGtwW2krMV07CQlcCiAJCQltMiA9IE1V
TDMyKHQxID4+IDMyLCB0Mik7CQkJXAogCQkJbTEgPSBNVUwzMih0MSwgdDIgPj4gMzIpOwkJCVwK
IAkJCUFERDEyOChyaCwgcmwsIE1VTDMyKHQxID4+IDMyLCB0MiA+PiAzMiksCVwKQEAgLTMyMiw4
ICszMjQsNyBAQCBzdGF0aWMgdm9pZCB2aGFzaF9hYm9ydChzdHJ1Y3Qgdm1hY19jdHggCiAJY3R4
LT5maXJzdF9ibG9ja19wcm9jZXNzZWQgPSAwOwogfQogCi1zdGF0aWMgdTY0IGwzaGFzaCh1NjQg
cDEsIHU2NCBwMiwKLQkJCXU2NCBrMSwgdTY0IGsyLCB1NjQgbGVuKQorc3RhdGljIHU2NCBsM2hh
c2godTY0IHAxLCB1NjQgcDIsIHU2NCBrMSwgdTY0IGsyLCB1NjQgbGVuKQogewogCXU2NCByaCwg
cmwsIHQsIHogPSAwOwogCkBAIC01NDksMTAgKzU1MCw2IEBAIHN0YXRpYyBpbnQgdm1hY19zZXRr
ZXkoc3RydWN0IGNyeXB0b19zaGEKIAogc3RhdGljIGludCB2bWFjX2luaXQoc3RydWN0IHNoYXNo
X2Rlc2MgKnBkZXNjKQogewotCXN0cnVjdCBjcnlwdG9fc2hhc2ggKnBhcmVudCA9IHBkZXNjLT50
Zm07Ci0Jc3RydWN0IHZtYWNfY3R4X3QgKmN0eCA9IGNyeXB0b19zaGFzaF9jdHgocGFyZW50KTsK
LQotCW1lbXNldCgmY3R4LT5fX3ZtYWNfY3R4LCAwLCBzaXplb2Yoc3RydWN0IHZtYWNfY3R4KSk7
CiAJcmV0dXJuIDA7CiB9CiAKQEAgLTU3NSw2ICs1NzIsMTAgQEAgc3RhdGljIGludCB2bWFjX2Zp
bmFsKHN0cnVjdCBzaGFzaF9kZXNjIAogCXU4IG5vbmNlWzE2XSA9IHt9OwogCiAJbWFjID0gdm1h
YyhOVUxMLCAwLCBub25jZSwgTlVMTCwgY3R4KTsKKworCS8qIHNldCBvdXRwdXQgaW52YXJpYW50
IGNvbnNpZGVyaW5nIGVuZGlhbm5lc3MgKi8KKwltYWMgPSBsZTY0X3RvX2NwdXAoJm1hYyk7CisK
IAltZW1jcHkob3V0LCAmbWFjLCBzaXplb2Yodm1hY190KSk7CiAJbWVtc2V0KCZtYWMsIDAsIHNp
emVvZih2bWFjX3QpKTsKIAltZW1zZXQoJmN0eC0+X192bWFjX2N0eCwgMCwgc2l6ZW9mKHN0cnVj
dCB2bWFjX2N0eCkpOwo=

--_002_6CADD16F56BC954D8E28F3836FA7ED71282AC1E357shzsmsx501ccr_--

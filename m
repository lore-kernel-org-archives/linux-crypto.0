From: "Wang, Shane" <shane.wang@intel.com>
Subject: [PATCH] to fix vmac test fails on s390
Date: Thu, 11 Feb 2010 11:18:08 +0800
Message-ID: <6CADD16F56BC954D8E28F3836FA7ED711EB163307A@shzsmsx501.ccr.corp.intel.com>
References: <1263477930.5880.22.camel@bender>
 <20100117110546.GA32690@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_6CADD16F56BC954D8E28F3836FA7ED711EB163307Ashzsmsx501ccr_"
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Jan Glauber <jang@linux.vnet.ibm.com>,
	"Cihula, Joseph" <joseph.cihula@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:44769 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab0BKDTu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Feb 2010 22:19:50 -0500
In-Reply-To: <20100117110546.GA32690@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--_002_6CADD16F56BC954D8E28F3836FA7ED711EB163307Ashzsmsx501ccr_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Herbert,

Here is the patch to fix it. I missed an important fact that the digest of =
vmac is not a string or a char array, but an 64bit integer.

This patch is to fix the vmac algorithm, add more test cases for vmac, and =
fix the test failure on some big endian system like s390.
(the attachment is for applying the patch)

Signed-off-by: Shane Wang <shane.wang@intel.com>


crypto/testmgr.h |   96 +++++++++++++++++++++++++++++++++++++++++++--
crypto/vmac.c    |   74 ++++++++++++++++------------------
2 files changed, 128 insertions(+), 42 deletions(-)

diff -r 91636f5ce7a2 crypto/testmgr.h
--- a/crypto/testmgr.h	Thu Feb 11 00:45:57 2010 -0800
+++ b/crypto/testmgr.h	Thu Feb 11 01:20:22 2010 -0800
@@ -1669,17 +1669,105 @@ static struct hash_testvec aes_xcbc128_t
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
+#ifdef __LITTLE_ENDIAN
+		.digest	=3D "\x07\x58\x80\x35\x77\xa4\x7b\x54",
+#else
+		.digest =3D "\x54\x7b\xa4\x77\x35\x80\x58\x07",
+#endif
+		.psize	=3D 0,
+		.ksize	=3D 16,
+	}, {
 		.key    =3D "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
-		.plaintext =3D vmac_string,
-		.digest =3D "\xcb\xd7\x8a\xfd\xb7\x33\x79\xe7",
+		.plaintext =3D vmac_string1,
+#ifdef __LITTLE_ENDIAN
+		.digest =3D "\xce\xf5\x3c\xd3\xae\x68\x8c\xa1",
+#else
+		.digest =3D "\xa1\x8c\x68\xae\xd3\x3c\xf5\xce",
+#endif
+		.psize  =3D 128,
+		.ksize  =3D 16,
+	}, {
+		.key    =3D "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.plaintext =3D vmac_string2,
+#ifdef __LITTLE_ENDIAN
+		.digest =3D "\xc9\x27\xb0\x73\x81\xbd\x14\x2d",
+#else
+		.digest =3D "\x2d\x14\xbd\x81\x73\xb0\x27\xc9",
+#endif
+		.psize  =3D 128,
+		.ksize  =3D 16,
+	}, {
+		.key    =3D "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.plaintext =3D vmac_string3,
+#ifdef __LITTLE_ENDIAN
+		.digest =3D "\x8d\x1a\x95\x8c\x98\x47\x0b\x19",
+#else
+		.digest =3D "\x19\x0b\x47\x98\x8c\x95\x1a\x8d",
+#endif
+		.psize  =3D 128,
+		.ksize  =3D 16,
+	}, {
+		.key	=3D "abcdefghijklmnop",
+		.plaintext =3D NULL,
+#ifdef __LITTLE_ENDIAN
+		.digest	=3D "\x3b\x89\xa1\x26\x9e\x55\x8f\x84",
+#else
+		.digest =3D "\x84\x8f\x55\x9e\x26\xa1\x89\x3b",
+#endif
+		.psize	=3D 0,
+		.ksize	=3D 16,
+	}, {
+		.key    =3D "abcdefghijklmnop",
+		.plaintext =3D vmac_string1,
+#ifdef __LITTLE_ENDIAN
+		.digest =3D "\xab\x5e\xab\xb0\xf6\x8d\x74\xc2",
+#else
+		.digest =3D "\xc2\x74\x8d\xf6\xb0\xab\x5e\xab",
+#endif
+		.psize  =3D 128,
+		.ksize  =3D 16,
+	}, {
+		.key    =3D "abcdefghijklmnop",
+		.plaintext =3D vmac_string2,
+#ifdef __LITTLE_ENDIAN
+		.digest =3D "\x11\x15\x68\x42\x3d\x7b\x09\xdf",
+#else
+		.digest =3D "\xdf\x09\x7b\x3d\x42\x68\x15\x11",
+#endif
+		.psize  =3D 128,
+		.ksize  =3D 16,
+	}, {
+		.key    =3D "abcdefghijklmnop",
+		.plaintext =3D vmac_string3,
+#ifdef __LITTLE_ENDIAN
+		.digest =3D "\x8b\x32\x8f\xe1\xed\x8f\xfa\xd4",
+#else
+		.digest =3D "\xd4\xfa\x8f\xed\xe1\x8f\x32\x8b",
+#endif
 		.psize  =3D 128,
 		.ksize  =3D 16,
 	},
diff -r 91636f5ce7a2 crypto/vmac.c
--- a/crypto/vmac.c	Thu Feb 11 00:45:57 2010 -0800
+++ b/crypto/vmac.c	Thu Feb 11 01:20:22 2010 -0800
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
@@ -575,6 +572,7 @@ static int vmac_final(struct shash_desc=20
 	u8 nonce[16] =3D {};
=20
 	mac =3D vmac(NULL, 0, nonce, NULL, ctx);
+
 	memcpy(out, &mac, sizeof(vmac_t));
 	memset(&mac, 0, sizeof(vmac_t));
 	memset(&ctx->__vmac_ctx, 0, sizeof(struct vmac_ctx));


Herbert Xu wrote:
> On Thu, Jan 14, 2010 at 02:05:30PM +0000, Jan Glauber wrote:
>> Hi,
>>=20
>> Jan 14 14:47:38 h42lp52 kernel: alg: hash: Test 1 failed for
>> vmac(aes-s390) Jan 14 14:47:38 h42lp52 kernel: 00000000: e7 79 33 b7
>> fd 8a d7 cb=20
>>=20
>> Looking at the digest from the failing test vector:
>>=20
>> .digest =3D "\xcb\xd7\x8a\xfd\xb7\x33\x79\xe7",
>>=20
>> the output looks somehow familiar... Maybe a missing endian
>> conversion? The patch fixes the test for me but it is just a wild
>> guess and maybe=20
>> it should be done at another place?
>=20
> Shane, please look into this.
>=20
> Thanks,


--_002_6CADD16F56BC954D8E28F3836FA7ED711EB163307Ashzsmsx501ccr_
Content-Type: application/octet-stream; name="vmac_fix.patch"
Content-Description: vmac_fix.patch
Content-Disposition: attachment; filename="vmac_fix.patch"; size=9186;
	creation-date="Thu, 11 Feb 2010 02:53:00 GMT";
	modification-date="Thu, 11 Feb 2010 02:53:00 GMT"
Content-Transfer-Encoding: base64

VGhpcyBwYXRjaCBpcyB0byBmaXggdGhlIHZtYWMgYWxnb3JpdGhtLCBhZGQgbW9yZSB0ZXN0IGNh
c2VzIGZvciB2bWFjLCBhbmQgZml4IHRoZSB0ZXN0IGZhaWx1cmUgb24gc29tZSBiaWcgZW5kaWFu
IHN5c3RlbSBsaWtlIHMzOTAuCgpTaWduZWQtb2ZmLWJ5OiBTaGFuZSBXYW5nIDxzaGFuZS53YW5n
QGludGVsLmNvbT4KCmRpZmYgLXIgOTE2MzZmNWNlN2EyIGNyeXB0by90ZXN0bWdyLmgKLS0tIGEv
Y3J5cHRvL3Rlc3RtZ3IuaAlUaHUgRmViIDExIDAwOjQ1OjU3IDIwMTAgLTA4MDAKKysrIGIvY3J5
cHRvL3Rlc3RtZ3IuaAlUaHUgRmViIDExIDAxOjIwOjIyIDIwMTAgLTA4MDAKQEAgLTE2NjksMTcg
KzE2NjksMTA1IEBAIHN0YXRpYyBzdHJ1Y3QgaGFzaF90ZXN0dmVjIGFlc194Y2JjMTI4X3QKIAl9
CiB9OwogCi0jZGVmaW5lIFZNQUNfQUVTX1RFU1RfVkVDVE9SUwkxCi1zdGF0aWMgY2hhciB2bWFj
X3N0cmluZ1sxMjhdID0geydceDAxJywgJ1x4MDEnLCAnXHgwMScsICdceDAxJywKKyNkZWZpbmUg
Vk1BQ19BRVNfVEVTVF9WRUNUT1JTCTgKK3N0YXRpYyBjaGFyIHZtYWNfc3RyaW5nMVsxMjhdID0g
eydceDAxJywgJ1x4MDEnLCAnXHgwMScsICdceDAxJywKIAkJCQknXHgwMicsICdceDAzJywgJ1x4
MDInLCAnXHgwMicsCiAJCQkJJ1x4MDInLCAnXHgwNCcsICdceDAxJywgJ1x4MDcnLAogCQkJCSdc
eDA0JywgJ1x4MDEnLCAnXHgwNCcsICdceDAzJyx9Oworc3RhdGljIGNoYXIgdm1hY19zdHJpbmcy
WzEyOF0gPSB7J2EnLCAnYicsICdjJyx9Oworc3RhdGljIGNoYXIgdm1hY19zdHJpbmczWzEyOF0g
PSB7J2EnLCAnYicsICdjJywgJ2EnLCAnYicsICdjJywKKwkJCQknYScsICdiJywgJ2MnLCAnYScs
ICdiJywgJ2MnLAorCQkJCSdhJywgJ2InLCAnYycsICdhJywgJ2InLCAnYycsCisJCQkJJ2EnLCAn
YicsICdjJywgJ2EnLCAnYicsICdjJywKKwkJCQknYScsICdiJywgJ2MnLCAnYScsICdiJywgJ2Mn
LAorCQkJCSdhJywgJ2InLCAnYycsICdhJywgJ2InLCAnYycsCisJCQkJJ2EnLCAnYicsICdjJywg
J2EnLCAnYicsICdjJywKKwkJCQknYScsICdiJywgJ2MnLCAnYScsICdiJywgJ2MnLAorCQkJCX07
CisKIHN0YXRpYyBzdHJ1Y3QgaGFzaF90ZXN0dmVjIGFlc192bWFjMTI4X3R2X3RlbXBsYXRlW10g
PSB7CiAJeworCQkua2V5CT0gIlx4MDBceDAxXHgwMlx4MDNceDA0XHgwNVx4MDZceDA3IgorCQkJ
ICAiXHgwOFx4MDlceDBhXHgwYlx4MGNceDBkXHgwZVx4MGYiLAorCQkucGxhaW50ZXh0ID0gTlVM
TCwKKyNpZmRlZiBfX0xJVFRMRV9FTkRJQU4KKwkJLmRpZ2VzdAk9ICJceDA3XHg1OFx4ODBceDM1
XHg3N1x4YTRceDdiXHg1NCIsCisjZWxzZQorCQkuZGlnZXN0ID0gIlx4NTRceDdiXHhhNFx4Nzdc
eDM1XHg4MFx4NThceDA3IiwKKyNlbmRpZgorCQkucHNpemUJPSAwLAorCQkua3NpemUJPSAxNiwK
Kwl9LCB7CiAJCS5rZXkgICAgPSAiXHgwMFx4MDFceDAyXHgwM1x4MDRceDA1XHgwNlx4MDciCiAJ
CQkgICJceDA4XHgwOVx4MGFceDBiXHgwY1x4MGRceDBlXHgwZiIsCi0JCS5wbGFpbnRleHQgPSB2
bWFjX3N0cmluZywKLQkJLmRpZ2VzdCA9ICJceGNiXHhkN1x4OGFceGZkXHhiN1x4MzNceDc5XHhl
NyIsCisJCS5wbGFpbnRleHQgPSB2bWFjX3N0cmluZzEsCisjaWZkZWYgX19MSVRUTEVfRU5ESUFO
CisJCS5kaWdlc3QgPSAiXHhjZVx4ZjVceDNjXHhkM1x4YWVceDY4XHg4Y1x4YTEiLAorI2Vsc2UK
KwkJLmRpZ2VzdCA9ICJceGExXHg4Y1x4NjhceGFlXHhkM1x4M2NceGY1XHhjZSIsCisjZW5kaWYK
KwkJLnBzaXplICA9IDEyOCwKKwkJLmtzaXplICA9IDE2LAorCX0sIHsKKwkJLmtleSAgICA9ICJc
eDAwXHgwMVx4MDJceDAzXHgwNFx4MDVceDA2XHgwNyIKKwkJCSAgIlx4MDhceDA5XHgwYVx4MGJc
eDBjXHgwZFx4MGVceDBmIiwKKwkJLnBsYWludGV4dCA9IHZtYWNfc3RyaW5nMiwKKyNpZmRlZiBf
X0xJVFRMRV9FTkRJQU4KKwkJLmRpZ2VzdCA9ICJceGM5XHgyN1x4YjBceDczXHg4MVx4YmRceDE0
XHgyZCIsCisjZWxzZQorCQkuZGlnZXN0ID0gIlx4MmRceDE0XHhiZFx4ODFceDczXHhiMFx4Mjdc
eGM5IiwKKyNlbmRpZgorCQkucHNpemUgID0gMTI4LAorCQkua3NpemUgID0gMTYsCisJfSwgewor
CQkua2V5ICAgID0gIlx4MDBceDAxXHgwMlx4MDNceDA0XHgwNVx4MDZceDA3IgorCQkJICAiXHgw
OFx4MDlceDBhXHgwYlx4MGNceDBkXHgwZVx4MGYiLAorCQkucGxhaW50ZXh0ID0gdm1hY19zdHJp
bmczLAorI2lmZGVmIF9fTElUVExFX0VORElBTgorCQkuZGlnZXN0ID0gIlx4OGRceDFhXHg5NVx4
OGNceDk4XHg0N1x4MGJceDE5IiwKKyNlbHNlCisJCS5kaWdlc3QgPSAiXHgxOVx4MGJceDQ3XHg5
OFx4OGNceDk1XHgxYVx4OGQiLAorI2VuZGlmCisJCS5wc2l6ZSAgPSAxMjgsCisJCS5rc2l6ZSAg
PSAxNiwKKwl9LCB7CisJCS5rZXkJPSAiYWJjZGVmZ2hpamtsbW5vcCIsCisJCS5wbGFpbnRleHQg
PSBOVUxMLAorI2lmZGVmIF9fTElUVExFX0VORElBTgorCQkuZGlnZXN0CT0gIlx4M2JceDg5XHhh
MVx4MjZceDllXHg1NVx4OGZceDg0IiwKKyNlbHNlCisJCS5kaWdlc3QgPSAiXHg4NFx4OGZceDU1
XHg5ZVx4MjZceGExXHg4OVx4M2IiLAorI2VuZGlmCisJCS5wc2l6ZQk9IDAsCisJCS5rc2l6ZQk9
IDE2LAorCX0sIHsKKwkJLmtleSAgICA9ICJhYmNkZWZnaGlqa2xtbm9wIiwKKwkJLnBsYWludGV4
dCA9IHZtYWNfc3RyaW5nMSwKKyNpZmRlZiBfX0xJVFRMRV9FTkRJQU4KKwkJLmRpZ2VzdCA9ICJc
eGFiXHg1ZVx4YWJceGIwXHhmNlx4OGRceDc0XHhjMiIsCisjZWxzZQorCQkuZGlnZXN0ID0gIlx4
YzJceDc0XHg4ZFx4ZjZceGIwXHhhYlx4NWVceGFiIiwKKyNlbmRpZgorCQkucHNpemUgID0gMTI4
LAorCQkua3NpemUgID0gMTYsCisJfSwgeworCQkua2V5ICAgID0gImFiY2RlZmdoaWprbG1ub3Ai
LAorCQkucGxhaW50ZXh0ID0gdm1hY19zdHJpbmcyLAorI2lmZGVmIF9fTElUVExFX0VORElBTgor
CQkuZGlnZXN0ID0gIlx4MTFceDE1XHg2OFx4NDJceDNkXHg3Ylx4MDlceGRmIiwKKyNlbHNlCisJ
CS5kaWdlc3QgPSAiXHhkZlx4MDlceDdiXHgzZFx4NDJceDY4XHgxNVx4MTEiLAorI2VuZGlmCisJ
CS5wc2l6ZSAgPSAxMjgsCisJCS5rc2l6ZSAgPSAxNiwKKwl9LCB7CisJCS5rZXkgICAgPSAiYWJj
ZGVmZ2hpamtsbW5vcCIsCisJCS5wbGFpbnRleHQgPSB2bWFjX3N0cmluZzMsCisjaWZkZWYgX19M
SVRUTEVfRU5ESUFOCisJCS5kaWdlc3QgPSAiXHg4Ylx4MzJceDhmXHhlMVx4ZWRceDhmXHhmYVx4
ZDQiLAorI2Vsc2UKKwkJLmRpZ2VzdCA9ICJceGQ0XHhmYVx4OGZceGVkXHhlMVx4OGZceDMyXHg4
YiIsCisjZW5kaWYKIAkJLnBzaXplICA9IDEyOCwKIAkJLmtzaXplICA9IDE2LAogCX0sCmRpZmYg
LXIgOTE2MzZmNWNlN2EyIGNyeXB0by92bWFjLmMKLS0tIGEvY3J5cHRvL3ZtYWMuYwlUaHUgRmVi
IDExIDAwOjQ1OjU3IDIwMTAgLTA4MDAKKysrIGIvY3J5cHRvL3ZtYWMuYwlUaHUgRmViIDExIDAx
OjIwOjIyIDIwMTAgLTA4MDAKQEAgLTQyLDYgKzQyLDggQEAgY29uc3QgdTY0IG02MyAgID0gVUlO
VDY0X0MoMHg3ZmZmZmZmZmZmZgogY29uc3QgdTY0IG02MyAgID0gVUlOVDY0X0MoMHg3ZmZmZmZm
ZmZmZmZmZmZmKTsgIC8qIDYzLWJpdCBtYXNrICAgICAgICovCiBjb25zdCB1NjQgbTY0ICAgPSBV
SU5UNjRfQygweGZmZmZmZmZmZmZmZmZmZmYpOyAgLyogNjQtYml0IG1hc2sgICAgICAgKi8KIGNv
bnN0IHU2NCBtcG9seSA9IFVJTlQ2NF9DKDB4MWZmZmZmZmYxZmZmZmZmZik7ICAvKiBQb2x5IGtl
eSBtYXNrICAgICAqLworCisjZGVmaW5lIHBlNjRfdG9fY3B1cCBsZTY0X3RvX2NwdXAJCS8qIFBy
ZWZlciBsaXR0bGUgZW5kaWFuICovCiAKICNpZmRlZiBfX0xJVFRMRV9FTkRJQU4KICNkZWZpbmUg
SU5ERVhfSElHSCAxCkBAIC0xMTAsOCArMTEyLDggQEAgY29uc3QgdTY0IG1wb2x5ID0gVUlOVDY0
X0MoMHgxZmZmZmZmZjFmZgogCQlpbnQgaTsgdTY0IHRoLCB0bDsJCQkJCVwKIAkJcmggPSBybCA9
IDA7CQkJCQkJXAogCQlmb3IgKGkgPSAwOyBpIDwgbnc7IGkgKz0gMikgewkJCQlcCi0JCQlNVUw2
NCh0aCwgdGwsIGxlNjRfdG9fY3B1cCgobXApK2kpKyhrcClbaV0sCVwKLQkJCQlsZTY0X3RvX2Nw
dXAoKG1wKStpKzEpKyhrcClbaSsxXSk7CVwKKwkJCU1VTDY0KHRoLCB0bCwgcGU2NF90b19jcHVw
KChtcCkraSkrKGtwKVtpXSwJXAorCQkJCXBlNjRfdG9fY3B1cCgobXApK2krMSkrKGtwKVtpKzFd
KTsJXAogCQkJQUREMTI4KHJoLCBybCwgdGgsIHRsKTsJCQkJXAogCQl9CQkJCQkJCVwKIAl9IHdo
aWxlICgwKQpAQCAtMTIxLDExICsxMjMsMTEgQEAgY29uc3QgdTY0IG1wb2x5ID0gVUlOVDY0X0Mo
MHgxZmZmZmZmZjFmZgogCQlpbnQgaTsgdTY0IHRoLCB0bDsJCQkJCVwKIAkJcmgxID0gcmwxID0g
cmggPSBybCA9IDA7CQkJCVwKIAkJZm9yIChpID0gMDsgaSA8IG53OyBpICs9IDIpIHsJCQkJXAot
CQkJTVVMNjQodGgsIHRsLCBsZTY0X3RvX2NwdXAoKG1wKStpKSsoa3ApW2ldLAlcCi0JCQkJbGU2
NF90b19jcHVwKChtcCkraSsxKSsoa3ApW2krMV0pOwlcCisJCQlNVUw2NCh0aCwgdGwsIHBlNjRf
dG9fY3B1cCgobXApK2kpKyhrcClbaV0sCVwKKwkJCQlwZTY0X3RvX2NwdXAoKG1wKStpKzEpKyhr
cClbaSsxXSk7CVwKIAkJCUFERDEyOChyaCwgcmwsIHRoLCB0bCk7CQkJCVwKLQkJCU1VTDY0KHRo
LCB0bCwgbGU2NF90b19jcHVwKChtcCkraSkrKGtwKVtpKzJdLAlcCi0JCQkJbGU2NF90b19jcHVw
KChtcCkraSsxKSsoa3ApW2krM10pOwlcCisJCQlNVUw2NCh0aCwgdGwsIHBlNjRfdG9fY3B1cCgo
bXApK2kpKyhrcClbaSsyXSwJXAorCQkJCXBlNjRfdG9fY3B1cCgobXApK2krMSkrKGtwKVtpKzNd
KTsJXAogCQkJQUREMTI4KHJoMSwgcmwxLCB0aCwgdGwpOwkJCVwKIAkJfQkJCQkJCQlcCiAJfSB3
aGlsZSAoMCkKQEAgLTEzNiwxNyArMTM4LDE3IEBAIGNvbnN0IHU2NCBtcG9seSA9IFVJTlQ2NF9D
KDB4MWZmZmZmZmYxZmYKIAkJaW50IGk7IHU2NCB0aCwgdGw7CQkJCQlcCiAJCXJoID0gcmwgPSAw
OwkJCQkJCVwKIAkJZm9yIChpID0gMDsgaSA8IG53OyBpICs9IDgpIHsJCQkJXAotCQkJTVVMNjQo
dGgsIHRsLCBsZTY0X3RvX2NwdXAoKG1wKStpKSsoa3ApW2ldLAlcCi0JCQkJbGU2NF90b19jcHVw
KChtcCkraSsxKSsoa3ApW2krMV0pOwlcCisJCQlNVUw2NCh0aCwgdGwsIHBlNjRfdG9fY3B1cCgo
bXApK2kpKyhrcClbaV0sCVwKKwkJCQlwZTY0X3RvX2NwdXAoKG1wKStpKzEpKyhrcClbaSsxXSk7
CVwKIAkJCUFERDEyOChyaCwgcmwsIHRoLCB0bCk7CQkJCVwKLQkJCU1VTDY0KHRoLCB0bCwgbGU2
NF90b19jcHVwKChtcCkraSsyKSsoa3ApW2krMl0sCVwKLQkJCQlsZTY0X3RvX2NwdXAoKG1wKStp
KzMpKyhrcClbaSszXSk7CVwKKwkJCU1VTDY0KHRoLCB0bCwgcGU2NF90b19jcHVwKChtcCkraSsy
KSsoa3ApW2krMl0sCVwKKwkJCQlwZTY0X3RvX2NwdXAoKG1wKStpKzMpKyhrcClbaSszXSk7CVwK
IAkJCUFERDEyOChyaCwgcmwsIHRoLCB0bCk7CQkJCVwKLQkJCU1VTDY0KHRoLCB0bCwgbGU2NF90
b19jcHVwKChtcCkraSs0KSsoa3ApW2krNF0sCVwKLQkJCQlsZTY0X3RvX2NwdXAoKG1wKStpKzUp
KyhrcClbaSs1XSk7CVwKKwkJCU1VTDY0KHRoLCB0bCwgcGU2NF90b19jcHVwKChtcCkraSs0KSso
a3ApW2krNF0sCVwKKwkJCQlwZTY0X3RvX2NwdXAoKG1wKStpKzUpKyhrcClbaSs1XSk7CVwKIAkJ
CUFERDEyOChyaCwgcmwsIHRoLCB0bCk7CQkJCVwKLQkJCU1VTDY0KHRoLCB0bCwgbGU2NF90b19j
cHVwKChtcCkraSs2KSsoa3ApW2krNl0sCVwKLQkJCQlsZTY0X3RvX2NwdXAoKG1wKStpKzcpKyhr
cClbaSs3XSk7CVwKKwkJCU1VTDY0KHRoLCB0bCwgcGU2NF90b19jcHVwKChtcCkraSs2KSsoa3Ap
W2krNl0sCVwKKwkJCQlwZTY0X3RvX2NwdXAoKG1wKStpKzcpKyhrcClbaSs3XSk7CVwKIAkJCUFE
RDEyOChyaCwgcmwsIHRoLCB0bCk7CQkJCVwKIAkJfQkJCQkJCQlcCiAJfSB3aGlsZSAoMCkKQEAg
LTE1NiwyOSArMTU4LDI5IEBAIGNvbnN0IHU2NCBtcG9seSA9IFVJTlQ2NF9DKDB4MWZmZmZmZmYx
ZmYKIAkJaW50IGk7IHU2NCB0aCwgdGw7CQkJCQlcCiAJCXJoMSA9IHJsMSA9IHJoID0gcmwgPSAw
OwkJCQlcCiAJCWZvciAoaSA9IDA7IGkgPCBudzsgaSArPSA4KSB7CQkJCVwKLQkJCU1VTDY0KHRo
LCB0bCwgbGU2NF90b19jcHVwKChtcCkraSkrKGtwKVtpXSwJXAotCQkJCWxlNjRfdG9fY3B1cCgo
bXApK2krMSkrKGtwKVtpKzFdKTsJXAorCQkJTVVMNjQodGgsIHRsLCBwZTY0X3RvX2NwdXAoKG1w
KStpKSsoa3ApW2ldLAlcCisJCQkJcGU2NF90b19jcHVwKChtcCkraSsxKSsoa3ApW2krMV0pOwlc
CiAJCQlBREQxMjgocmgsIHJsLCB0aCwgdGwpOwkJCQlcCi0JCQlNVUw2NCh0aCwgdGwsIGxlNjRf
dG9fY3B1cCgobXApK2kpKyhrcClbaSsyXSwJXAotCQkJCWxlNjRfdG9fY3B1cCgobXApK2krMSkr
KGtwKVtpKzNdKTsJXAorCQkJTVVMNjQodGgsIHRsLCBwZTY0X3RvX2NwdXAoKG1wKStpKSsoa3Ap
W2krMl0sCVwKKwkJCQlwZTY0X3RvX2NwdXAoKG1wKStpKzEpKyhrcClbaSszXSk7CVwKIAkJCUFE
RDEyOChyaDEsIHJsMSwgdGgsIHRsKTsJCQlcCi0JCQlNVUw2NCh0aCwgdGwsIGxlNjRfdG9fY3B1
cCgobXApK2krMikrKGtwKVtpKzJdLAlcCi0JCQkJbGU2NF90b19jcHVwKChtcCkraSszKSsoa3Ap
W2krM10pOwlcCisJCQlNVUw2NCh0aCwgdGwsIHBlNjRfdG9fY3B1cCgobXApK2krMikrKGtwKVtp
KzJdLAlcCisJCQkJcGU2NF90b19jcHVwKChtcCkraSszKSsoa3ApW2krM10pOwlcCiAJCQlBREQx
MjgocmgsIHJsLCB0aCwgdGwpOwkJCQlcCi0JCQlNVUw2NCh0aCwgdGwsIGxlNjRfdG9fY3B1cCgo
bXApK2krMikrKGtwKVtpKzRdLAlcCi0JCQkJbGU2NF90b19jcHVwKChtcCkraSszKSsoa3ApW2kr
NV0pOwlcCisJCQlNVUw2NCh0aCwgdGwsIHBlNjRfdG9fY3B1cCgobXApK2krMikrKGtwKVtpKzRd
LAlcCisJCQkJcGU2NF90b19jcHVwKChtcCkraSszKSsoa3ApW2krNV0pOwlcCiAJCQlBREQxMjgo
cmgxLCBybDEsIHRoLCB0bCk7CQkJXAotCQkJTVVMNjQodGgsIHRsLCBsZTY0X3RvX2NwdXAoKG1w
KStpKzQpKyhrcClbaSs0XSwJXAotCQkJCWxlNjRfdG9fY3B1cCgobXApK2krNSkrKGtwKVtpKzVd
KTsJXAorCQkJTVVMNjQodGgsIHRsLCBwZTY0X3RvX2NwdXAoKG1wKStpKzQpKyhrcClbaSs0XSwJ
XAorCQkJCXBlNjRfdG9fY3B1cCgobXApK2krNSkrKGtwKVtpKzVdKTsJXAogCQkJQUREMTI4KHJo
LCBybCwgdGgsIHRsKTsJCQkJXAotCQkJTVVMNjQodGgsIHRsLCBsZTY0X3RvX2NwdXAoKG1wKStp
KzQpKyhrcClbaSs2XSwJXAotCQkJCWxlNjRfdG9fY3B1cCgobXApK2krNSkrKGtwKVtpKzddKTsJ
XAorCQkJTVVMNjQodGgsIHRsLCBwZTY0X3RvX2NwdXAoKG1wKStpKzQpKyhrcClbaSs2XSwJXAor
CQkJCXBlNjRfdG9fY3B1cCgobXApK2krNSkrKGtwKVtpKzddKTsJXAogCQkJQUREMTI4KHJoMSwg
cmwxLCB0aCwgdGwpOwkJCVwKLQkJCU1VTDY0KHRoLCB0bCwgbGU2NF90b19jcHVwKChtcCkraSs2
KSsoa3ApW2krNl0sCVwKLQkJCQlsZTY0X3RvX2NwdXAoKG1wKStpKzcpKyhrcClbaSs3XSk7CVwK
KwkJCU1VTDY0KHRoLCB0bCwgcGU2NF90b19jcHVwKChtcCkraSs2KSsoa3ApW2krNl0sCVwKKwkJ
CQlwZTY0X3RvX2NwdXAoKG1wKStpKzcpKyhrcClbaSs3XSk7CVwKIAkJCUFERDEyOChyaCwgcmws
IHRoLCB0bCk7CQkJCVwKLQkJCU1VTDY0KHRoLCB0bCwgbGU2NF90b19jcHVwKChtcCkraSs2KSso
a3ApW2krOF0sCVwKLQkJCQlsZTY0X3RvX2NwdXAoKG1wKStpKzcpKyhrcClbaSs5XSk7CVwKKwkJ
CU1VTDY0KHRoLCB0bCwgcGU2NF90b19jcHVwKChtcCkraSs2KSsoa3ApW2krOF0sCVwKKwkJCQlw
ZTY0X3RvX2NwdXAoKG1wKStpKzcpKyhrcClbaSs5XSk7CVwKIAkJCUFERDEyOChyaDEsIHJsMSwg
dGgsIHRsKTsJCQlcCiAJCX0JCQkJCQkJXAogCX0gd2hpbGUgKDApCkBAIC0yMTYsOCArMjE4LDgg
QEAgY29uc3QgdTY0IG1wb2x5ID0gVUlOVDY0X0MoMHgxZmZmZmZmZjFmZgogCQlpbnQgaTsJCQkJ
CQkJXAogCQlyaCA9IHJsID0gdCA9IDA7CQkJCQlcCiAJCWZvciAoaSA9IDA7IGkgPCBudzsgaSAr
PSAyKSAgewkJCQlcCi0JCQl0MSA9IGxlNjRfdG9fY3B1cChtcCtpKSArIGtwW2ldOwkJXAotCQkJ
dDIgPSBsZTY0X3RvX2NwdXAobXAraSsxKSArIGtwW2krMV07CQlcCisJCQl0MSA9IHBlNjRfdG9f
Y3B1cChtcCtpKSArIGtwW2ldOwkJXAorCQkJdDIgPSBwZTY0X3RvX2NwdXAobXAraSsxKSArIGtw
W2krMV07CQlcCiAJCQltMiA9IE1VTDMyKHQxID4+IDMyLCB0Mik7CQkJXAogCQkJbTEgPSBNVUwz
Mih0MSwgdDIgPj4gMzIpOwkJCVwKIAkJCUFERDEyOChyaCwgcmwsIE1VTDMyKHQxID4+IDMyLCB0
MiA+PiAzMiksCVwKQEAgLTMyMiw4ICszMjQsNyBAQCBzdGF0aWMgdm9pZCB2aGFzaF9hYm9ydChz
dHJ1Y3Qgdm1hY19jdHggCiAJY3R4LT5maXJzdF9ibG9ja19wcm9jZXNzZWQgPSAwOwogfQogCi1z
dGF0aWMgdTY0IGwzaGFzaCh1NjQgcDEsIHU2NCBwMiwKLQkJCXU2NCBrMSwgdTY0IGsyLCB1NjQg
bGVuKQorc3RhdGljIHU2NCBsM2hhc2godTY0IHAxLCB1NjQgcDIsIHU2NCBrMSwgdTY0IGsyLCB1
NjQgbGVuKQogewogCXU2NCByaCwgcmwsIHQsIHogPSAwOwogCkBAIC01NDksMTAgKzU1MCw2IEBA
IHN0YXRpYyBpbnQgdm1hY19zZXRrZXkoc3RydWN0IGNyeXB0b19zaGEKIAogc3RhdGljIGludCB2
bWFjX2luaXQoc3RydWN0IHNoYXNoX2Rlc2MgKnBkZXNjKQogewotCXN0cnVjdCBjcnlwdG9fc2hh
c2ggKnBhcmVudCA9IHBkZXNjLT50Zm07Ci0Jc3RydWN0IHZtYWNfY3R4X3QgKmN0eCA9IGNyeXB0
b19zaGFzaF9jdHgocGFyZW50KTsKLQotCW1lbXNldCgmY3R4LT5fX3ZtYWNfY3R4LCAwLCBzaXpl
b2Yoc3RydWN0IHZtYWNfY3R4KSk7CiAJcmV0dXJuIDA7CiB9CiAKQEAgLTU3NSw2ICs1NzIsNyBA
QCBzdGF0aWMgaW50IHZtYWNfZmluYWwoc3RydWN0IHNoYXNoX2Rlc2MgCiAJdTggbm9uY2VbMTZd
ID0ge307CiAKIAltYWMgPSB2bWFjKE5VTEwsIDAsIG5vbmNlLCBOVUxMLCBjdHgpOworCiAJbWVt
Y3B5KG91dCwgJm1hYywgc2l6ZW9mKHZtYWNfdCkpOwogCW1lbXNldCgmbWFjLCAwLCBzaXplb2Yo
dm1hY190KSk7CiAJbWVtc2V0KCZjdHgtPl9fdm1hY19jdHgsIDAsIHNpemVvZihzdHJ1Y3Qgdm1h
Y19jdHgpKTsK

--_002_6CADD16F56BC954D8E28F3836FA7ED711EB163307Ashzsmsx501ccr_--

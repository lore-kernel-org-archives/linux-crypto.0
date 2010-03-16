From: Shane Wang <shane.wang@intel.com>
Subject: [PATCH] crypto: fix vmac test fails on s390 (v2)
Date: Tue, 16 Mar 2010 07:22:44 -0700
Message-ID: <1268749364-2397-1-git-send-email-shane.wang@intel.com>
Cc: linux-crypto@vger.kernel.org, joseph.cihula@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2686 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965996Ab0CPGWy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Mar 2010 02:22:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch is to fix the vmac algorithm, add more test cases for vmac, and fix the test failure on some big endian system like s390.

Signed-off-by: Shane Wang <shane.wang@intel.com>
---
 crypto/testmgr.h |   64 ++++++++++++++++++++++++++++++++++++--
 crypto/vmac.c    |   75 +++++++++++++++++++++------------------------
 2 files changed, 96 insertions(+), 43 deletions(-)

diff -r 91636f5ce7a2 crypto/testmgr.h
--- a/crypto/testmgr.h	Thu Feb 11 00:45:57 2010 -0800
+++ b/crypto/testmgr.h	Tue Mar 16 06:12:07 2010 -0700
@@ -1669,17 +1669,73 @@ static struct hash_testvec aes_xcbc128_t
 	}
 };
 
-#define VMAC_AES_TEST_VECTORS	1
-static char vmac_string[128] = {'\x01', '\x01', '\x01', '\x01',
+#define VMAC_AES_TEST_VECTORS	8
+static char vmac_string1[128] = {'\x01', '\x01', '\x01', '\x01',
 				'\x02', '\x03', '\x02', '\x02',
 				'\x02', '\x04', '\x01', '\x07',
 				'\x04', '\x01', '\x04', '\x03',};
+static char vmac_string2[128] = {'a', 'b', 'c',};
+static char vmac_string3[128] = {'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				'a', 'b', 'c', 'a', 'b', 'c',
+				};
+
 static struct hash_testvec aes_vmac128_tv_template[] = {
 	{
+		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.plaintext = NULL,
+		.digest	= "\x07\x58\x80\x35\x77\xa4\x7b\x54",
+		.psize	= 0,
+		.ksize	= 16,
+	}, {
 		.key    = "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
-		.plaintext = vmac_string,
-		.digest = "\xcb\xd7\x8a\xfd\xb7\x33\x79\xe7",
+		.plaintext = vmac_string1,
+		.digest = "\xce\xf5\x3c\xd3\xae\x68\x8c\xa1",
+		.psize  = 128,
+		.ksize  = 16,
+	}, {
+		.key    = "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.plaintext = vmac_string2,
+		.digest = "\xc9\x27\xb0\x73\x81\xbd\x14\x2d",
+		.psize  = 128,
+		.ksize  = 16,
+	}, {
+		.key    = "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.plaintext = vmac_string3,
+		.digest = "\x8d\x1a\x95\x8c\x98\x47\x0b\x19",
+		.psize  = 128,
+		.ksize  = 16,
+	}, {
+		.key	= "abcdefghijklmnop",
+		.plaintext = NULL,
+		.digest	= "\x3b\x89\xa1\x26\x9e\x55\x8f\x84",
+		.psize	= 0,
+		.ksize	= 16,
+	}, {
+		.key    = "abcdefghijklmnop",
+		.plaintext = vmac_string1,
+		.digest = "\xab\x5e\xab\xb0\xf6\x8d\x74\xc2",
+		.psize  = 128,
+		.ksize  = 16,
+	}, {
+		.key    = "abcdefghijklmnop",
+		.plaintext = vmac_string2,
+		.digest = "\x11\x15\x68\x42\x3d\x7b\x09\xdf",
+		.psize  = 128,
+		.ksize  = 16,
+	}, {
+		.key    = "abcdefghijklmnop",
+		.plaintext = vmac_string3,
+		.digest = "\x8b\x32\x8f\xe1\xed\x8f\xfa\xd4",
 		.psize  = 128,
 		.ksize  = 16,
 	},
diff -r 91636f5ce7a2 crypto/vmac.c
--- a/crypto/vmac.c	Thu Feb 11 00:45:57 2010 -0800
+++ b/crypto/vmac.c	Tue Mar 16 06:12:07 2010 -0700
@@ -42,6 +42,8 @@ const u64 m63   = UINT64_C(0x7ffffffffff
 const u64 m63   = UINT64_C(0x7fffffffffffffff);  /* 63-bit mask       */
 const u64 m64   = UINT64_C(0xffffffffffffffff);  /* 64-bit mask       */
 const u64 mpoly = UINT64_C(0x1fffffff1fffffff);  /* Poly key mask     */
+
+#define pe64_to_cpup le64_to_cpup		/* Prefer little endian */
 
 #ifdef __LITTLE_ENDIAN
 #define INDEX_HIGH 1
@@ -110,8 +112,8 @@ const u64 mpoly = UINT64_C(0x1fffffff1ff
 		int i; u64 th, tl;					\
 		rh = rl = 0;						\
 		for (i = 0; i < nw; i += 2) {				\
-			MUL64(th, tl, le64_to_cpup((mp)+i)+(kp)[i],	\
-				le64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
+			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i],	\
+				pe64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
 			ADD128(rh, rl, th, tl);				\
 		}							\
 	} while (0)
@@ -121,11 +123,11 @@ const u64 mpoly = UINT64_C(0x1fffffff1ff
 		int i; u64 th, tl;					\
 		rh1 = rl1 = rh = rl = 0;				\
 		for (i = 0; i < nw; i += 2) {				\
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
@@ -136,17 +138,17 @@ const u64 mpoly = UINT64_C(0x1fffffff1ff
 		int i; u64 th, tl;					\
 		rh = rl = 0;						\
 		for (i = 0; i < nw; i += 8) {				\
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
@@ -156,29 +158,29 @@ const u64 mpoly = UINT64_C(0x1fffffff1ff
 		int i; u64 th, tl;					\
 		rh1 = rl1 = rh = rl = 0;				\
 		for (i = 0; i < nw; i += 8) {				\
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
@@ -216,8 +218,8 @@ const u64 mpoly = UINT64_C(0x1fffffff1ff
 		int i;							\
 		rh = rl = t = 0;					\
 		for (i = 0; i < nw; i += 2)  {				\
-			t1 = le64_to_cpup(mp+i) + kp[i];		\
-			t2 = le64_to_cpup(mp+i+1) + kp[i+1];		\
+			t1 = pe64_to_cpup(mp+i) + kp[i];		\
+			t2 = pe64_to_cpup(mp+i+1) + kp[i+1];		\
 			m2 = MUL32(t1 >> 32, t2);			\
 			m1 = MUL32(t1, t2 >> 32);			\
 			ADD128(rh, rl, MUL32(t1 >> 32, t2 >> 32),	\
@@ -322,8 +324,7 @@ static void vhash_abort(struct vmac_ctx 
 	ctx->first_block_processed = 0;
 }
 
-static u64 l3hash(u64 p1, u64 p2,
-			u64 k1, u64 k2, u64 len)
+static u64 l3hash(u64 p1, u64 p2, u64 k1, u64 k2, u64 len)
 {
 	u64 rh, rl, t, z = 0;
 
@@ -474,7 +475,7 @@ static u64 vmac(unsigned char m[], unsig
 	}
 	p = be64_to_cpup(out_p + i);
 	h = vhash(m, mbytes, (u64 *)0, &ctx->__vmac_ctx);
-	return p + h;
+	return le64_to_cpu(p + h);
 }
 
 static int vmac_set_key(unsigned char user_key[], struct vmac_ctx_t *ctx)
@@ -549,10 +550,6 @@ static int vmac_setkey(struct crypto_sha
 
 static int vmac_init(struct shash_desc *pdesc)
 {
-	struct crypto_shash *parent = pdesc->tfm;
-	struct vmac_ctx_t *ctx = crypto_shash_ctx(parent);

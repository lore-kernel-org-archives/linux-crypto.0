From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 2/2] crypto: add SM3 test vectors
Date: Mon, 21 Aug 2017 13:51:29 +0300
Message-ID: <1503312690-2770-3-git-send-email-gilad@benyossef.com>
References: <1503312690-2770-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503312690-2770-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add testmgr and tcrypt tests and vectors for SM3 secure hash.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/tcrypt.c  | 14 +++++++++++-
 crypto/testmgr.c |  6 +++++
 crypto/testmgr.h | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 0dd6a43..baa3e7c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -70,7 +70,7 @@ static int mode;
 static char *tvmem[TVMEMSIZE];
 
 static char *check[] = {
-	"des", "md5", "des3_ede", "rot13", "sha1", "sha224", "sha256",
+	"des", "md5", "des3_ede", "rot13", "sha1", "sha224", "sha256", "sm3",
 	"blowfish", "twofish", "serpent", "sha384", "sha512", "md4", "aes",
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
@@ -1269,6 +1269,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		ret += tcrypt_test("sha3-512");
 		break;
 
+	case 52:
+		ret += tcrypt_test("sm3");
+		break;
+
 	case 100:
 		ret += tcrypt_test("hmac(md5)");
 		break;
@@ -1712,6 +1716,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		test_hash_speed("sha3-512", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
+	case 326:
+		test_hash_speed("sm3", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+
 	case 399:
 		break;
 
@@ -1820,6 +1828,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		test_mb_ahash_speed("sha512", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 
+	case 425:
+		test_mb_ahash_speed("sm3", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
 	case 499:
 		break;
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 7125ba3..baf96cec 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3500,6 +3500,12 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.hash = __VECS(sha512_tv_template)
 		}
 	}, {
+		.alg = "sm3",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = __VECS(sm3_tv_template)
+		}
+	}, {
 		.alg = "tgr128",
 		.test = alg_test_hash,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 6ceb0e2..c4d20ea 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -1497,6 +1497,73 @@ static const struct hash_testvec crct10dif_tv_template[] = {
 	}
 };
 
+/* Example vectors below taken from
+ * http://www.oscca.gov.cn/UpFile/20101222141857786.pdf
+ *
+ * The rest taken from
+ * https://github.com/adamws/oscca-sm3
+ */
+static const struct hash_testvec sm3_tv_template[] = {
+	{
+		.plaintext = "",
+		.psize = 0,
+		.digest = (u8 *)(u8 []) {
+			0x1A, 0xB2, 0x1D, 0x83, 0x55, 0xCF, 0xA1, 0x7F,
+			0x8e, 0x61, 0x19, 0x48, 0x31, 0xE8, 0x1A, 0x8F,
+			0x22, 0xBE, 0xC8, 0xC7, 0x28, 0xFE, 0xFB, 0x74,
+			0x7E, 0xD0, 0x35, 0xEB, 0x50, 0x82, 0xAA, 0x2B }
+	}, {
+		.plaintext = "a",
+		.psize = 1,
+		.digest = (u8 *)(u8 []) {
+			0x62, 0x34, 0x76, 0xAC, 0x18, 0xF6, 0x5A, 0x29,
+			0x09, 0xE4, 0x3C, 0x7F, 0xEC, 0x61, 0xB4, 0x9C,
+			0x7E, 0x76, 0x4A, 0x91, 0xA1, 0x8C, 0xCB, 0x82,
+			0xF1, 0x91, 0x7A, 0x29, 0xC8, 0x6C, 0x5E, 0x88 }
+	}, {
+		/* A.1. Example 1 */
+		.plaintext = "abc",
+		.psize = 3,
+		.digest = (u8 *)(u8 []) {
+			0x66, 0xC7, 0xF0, 0xF4, 0x62, 0xEE, 0xED, 0xD9,
+			0xD1, 0xF2, 0xD4, 0x6B, 0xDC, 0x10, 0xE4, 0xE2,
+			0x41, 0x67, 0xC4, 0x87, 0x5C, 0xF2, 0xF7, 0xA2,
+			0x29, 0x7D, 0xA0, 0x2B, 0x8F, 0x4B, 0xA8, 0xE0 }
+	}, {
+		.plaintext = "abcdefghijklmnopqrstuvwxyz",
+		.psize = 26,
+		.digest = (u8 *)(u8 []) {
+			0xB8, 0x0F, 0xE9, 0x7A, 0x4D, 0xA2, 0x4A, 0xFC,
+			0x27, 0x75, 0x64, 0xF6, 0x6A, 0x35, 0x9E, 0xF4,
+			0x40, 0x46, 0x2A, 0xD2, 0x8D, 0xCC, 0x6D, 0x63,
+			0xAD, 0xB2, 0x4D, 0x5C, 0x20, 0xA6, 0x15, 0x95 }
+	}, {
+		/* A.1. Example 2 */
+		.plaintext = "abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdab"
+			     "cdabcdabcdabcdabcd",
+		.psize = 64,
+		.digest = (u8 *)(u8 []) {
+			0xDE, 0xBE, 0x9F, 0xF9, 0x22, 0x75, 0xB8, 0xA1,
+			0x38, 0x60, 0x48, 0x89, 0xC1, 0x8E, 0x5A, 0x4D,
+			0x6F, 0xDB, 0x70, 0xE5, 0x38, 0x7E, 0x57, 0x65,
+			0x29, 0x3D, 0xCB, 0xA3, 0x9C, 0x0C, 0x57, 0x32 }
+	}, {
+		.plaintext = "abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd"
+			     "abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd"
+			     "abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd"
+			     "abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd"
+			     "abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd"
+			     "abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd"
+			     "abcdabcdabcdabcdabcdabcdabcdabcd",
+		.psize = 256,
+		.digest = (u8 *)(u8 []) {
+			0xB9, 0x65, 0x76, 0x4C, 0x8B, 0xEB, 0xB0, 0x91,
+			0xC7, 0x60, 0x2B, 0x74, 0xAF, 0xD3, 0x4E, 0xEF,
+			0xB5, 0x31, 0xDC, 0xCB, 0x4E, 0x00, 0x76, 0xD9,
+			0xB7, 0xCD, 0x81, 0x31, 0x99, 0xB4, 0x59, 0x71 }
+	}
+};
+
 /*
  * SHA1 test vectors  from from FIPS PUB 180-1
  * Long vector from CAVS 5.0
-- 
2.1.4

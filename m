Return-Path: <SRS0=schb=NE=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:46244 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbeJXLvl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Oct 2018 07:51:41 -0400
From: Vitaly Chikunov <vt@altlinux.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] crypto: streebog - add Streebog test vectors
Date: Wed, 24 Oct 2018 06:23:51 +0300
Message-Id: <20181024032356.3388-4-vt@altlinux.org>
In-Reply-To: <20181024032356.3388-1-vt@altlinux.org>
References: <20181024032356.3388-1-vt@altlinux.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add testmgr and tcrypt tests and vectors for Streebog hash function
from RFC 6986 and GOST R 34.11-2012, for HMAC-Streebog vectors are
from R 50.1.113-2016.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/tcrypt.c  |  35 +++++++++++++++++
 crypto/testmgr.c |  24 ++++++++++++
 crypto/testmgr.h | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index bdde95e8d369..5dae2eb16c8d 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -77,6 +77,7 @@ static char *check[] = {
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
 	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256", "rmd320",
 	"lzo", "cts", "zlib", "sha3-224", "sha3-256", "sha3-384", "sha3-512",
+	"sb256", "sb512",
 	NULL
 };
 
@@ -1914,6 +1915,14 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("sm3");
 		break;
 
+	case 53:
+		ret += tcrypt_test("sb256");
+		break;
+
+	case 54:
+		ret += tcrypt_test("sb512");
+		break;
+
 	case 100:
 		ret += tcrypt_test("hmac(md5)");
 		break;
@@ -1970,6 +1979,14 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("hmac(sha3-512)");
 		break;
 
+	case 115:
+		ret += tcrypt_test("hmac(sb256)");
+		break;
+
+	case 116:
+		ret += tcrypt_test("hmac(sb512)");
+		break;
+
 	case 150:
 		ret += tcrypt_test("ansi_cprng");
 		break;
@@ -2392,6 +2409,14 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_hash_speed("sm3", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		/* fall through */
+	case 327:
+		test_hash_speed("sb256", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+		/* fall through */
+	case 328:
+		test_hash_speed("sb512", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+		/* fall through */
 	case 399:
 		break;
 
@@ -2505,6 +2530,16 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		/* fall through */
+	case 426:
+		test_mb_ahash_speed("sb256", sec, generic_hash_speed_template,
+				    num_mb);
+		if (mode > 400 && mode < 500) break;
+		/* fall through */
+	case 427:
+		test_mb_ahash_speed("sb512", sec, generic_hash_speed_template,
+				    num_mb);
+		if (mode > 400 && mode < 500) break;
+		/* fall through */
 	case 499:
 		break;
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a1d42245082a..6f3f0379260b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3122,6 +3122,18 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.hash = __VECS(hmac_rmd160_tv_template)
 		}
 	}, {
+		.alg = "hmac(sb256)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = __VECS(hmac_sb256_tv_template)
+		}
+	}, {
+		.alg = "hmac(sb512)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = __VECS(hmac_sb512_tv_template)
+		}
+	}, {
 		.alg = "hmac(sha1)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
@@ -3428,6 +3440,18 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.cipher = __VECS(salsa20_stream_tv_template)
 		}
 	}, {
+		.alg = "sb256",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = __VECS(sb256_tv_template)
+		}
+	}, {
+		.alg = "sb512",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = __VECS(sb512_tv_template)
+		}
+	}, {
 		.alg = "sha1",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 173111c70746..a48ba2945093 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -2309,6 +2309,120 @@ static const struct hash_testvec crct10dif_tv_template[] = {
 	}
 };
 
+/*
+ * Streebog test vectors from RFC 6986 and GOST R 34.11-2012
+ */
+static const struct hash_testvec sb256_tv_template[] = {
+	{ /* M1 */
+		.plaintext = "012345678901234567890123456789012345678901234567890123456789012",
+		.psize = 63,
+		.digest =
+			"\x9d\x15\x1e\xef\xd8\x59\x0b\x89"
+			"\xda\xa6\xba\x6c\xb7\x4a\xf9\x27"
+			"\x5d\xd0\x51\x02\x6b\xb1\x49\xa4"
+			"\x52\xfd\x84\xe5\xe5\x7b\x55\x00",
+	},
+	{ /* M2 */
+		.plaintext =
+			"\xd1\xe5\x20\xe2\xe5\xf2\xf0\xe8"
+			"\x2c\x20\xd1\xf2\xf0\xe8\xe1\xee"
+			"\xe6\xe8\x20\xe2\xed\xf3\xf6\xe8"
+			"\x2c\x20\xe2\xe5\xfe\xf2\xfa\x20"
+			"\xf1\x20\xec\xee\xf0\xff\x20\xf1"
+			"\xf2\xf0\xe5\xeb\xe0\xec\xe8\x20"
+			"\xed\xe0\x20\xf5\xf0\xe0\xe1\xf0"
+			"\xfb\xff\x20\xef\xeb\xfa\xea\xfb"
+			"\x20\xc8\xe3\xee\xf0\xe5\xe2\xfb",
+		.psize = 72,
+		.digest =
+			"\x9d\xd2\xfe\x4e\x90\x40\x9e\x5d"
+			"\xa8\x7f\x53\x97\x6d\x74\x05\xb0"
+			"\xc0\xca\xc6\x28\xfc\x66\x9a\x74"
+			"\x1d\x50\x06\x3c\x55\x7e\x8f\x50",
+	},
+};
+
+static const struct hash_testvec sb512_tv_template[] = {
+	{ /* M1 */
+		.plaintext = "012345678901234567890123456789012345678901234567890123456789012",
+		.psize = 63,
+		.digest =
+			"\x1b\x54\xd0\x1a\x4a\xf5\xb9\xd5"
+			"\xcc\x3d\x86\xd6\x8d\x28\x54\x62"
+			"\xb1\x9a\xbc\x24\x75\x22\x2f\x35"
+			"\xc0\x85\x12\x2b\xe4\xba\x1f\xfa"
+			"\x00\xad\x30\xf8\x76\x7b\x3a\x82"
+			"\x38\x4c\x65\x74\xf0\x24\xc3\x11"
+			"\xe2\xa4\x81\x33\x2b\x08\xef\x7f"
+			"\x41\x79\x78\x91\xc1\x64\x6f\x48",
+	},
+	{ /* M2 */
+		.plaintext =
+			"\xd1\xe5\x20\xe2\xe5\xf2\xf0\xe8"
+			"\x2c\x20\xd1\xf2\xf0\xe8\xe1\xee"
+			"\xe6\xe8\x20\xe2\xed\xf3\xf6\xe8"
+			"\x2c\x20\xe2\xe5\xfe\xf2\xfa\x20"
+			"\xf1\x20\xec\xee\xf0\xff\x20\xf1"
+			"\xf2\xf0\xe5\xeb\xe0\xec\xe8\x20"
+			"\xed\xe0\x20\xf5\xf0\xe0\xe1\xf0"
+			"\xfb\xff\x20\xef\xeb\xfa\xea\xfb"
+			"\x20\xc8\xe3\xee\xf0\xe5\xe2\xfb",
+		.psize = 72,
+		.digest =
+			"\x1e\x88\xe6\x22\x26\xbf\xca\x6f"
+			"\x99\x94\xf1\xf2\xd5\x15\x69\xe0"
+			"\xda\xf8\x47\x5a\x3b\x0f\xe6\x1a"
+			"\x53\x00\xee\xe4\x6d\x96\x13\x76"
+			"\x03\x5f\xe8\x35\x49\xad\xa2\xb8"
+			"\x62\x0f\xcd\x7c\x49\x6c\xe5\xb3"
+			"\x3f\x0c\xb9\xdd\xdc\x2b\x64\x60"
+			"\x14\x3b\x03\xda\xba\xc9\xfb\x28",
+	},
+};
+
+/* Two HMAC-Streebog test vectors from R 50.1.113-2016 A */
+static const struct hash_testvec hmac_sb256_tv_template[] = {
+	{
+		.key =  "\x00\x01\x02\x03\x04\x05\x06\x07"
+			"\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			"\x10\x11\x12\x13\x14\x15\x16\x17"
+			"\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.ksize  = 32,
+		.plaintext =
+			"\x01\x26\xbd\xb8\x78\x00\xaf\x21"
+			"\x43\x41\x45\x65\x63\x78\x01\x00",
+		.psize  = 16,
+		.digest =
+			"\xa1\xaa\x5f\x7d\xe4\x02\xd7\xb3"
+			"\xd3\x23\xf2\x99\x1c\x8d\x45\x34"
+			"\x01\x31\x37\x01\x0a\x83\x75\x4f"
+			"\xd0\xaf\x6d\x7c\xd4\x92\x2e\xd9",
+	},
+};
+
+static const struct hash_testvec hmac_sb512_tv_template[] = {
+	{
+		.key =  "\x00\x01\x02\x03\x04\x05\x06\x07"
+			"\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			"\x10\x11\x12\x13\x14\x15\x16\x17"
+			"\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.ksize  = 32,
+		.plaintext =
+			"\x01\x26\xbd\xb8\x78\x00\xaf\x21"
+			"\x43\x41\x45\x65\x63\x78\x01\x00",
+		.psize  = 16,
+		.digest =
+			"\xa5\x9b\xab\x22\xec\xae\x19\xc6"
+			"\x5f\xbd\xe6\xe5\xf4\xe9\xf5\xd8"
+			"\x54\x9d\x31\xf0\x37\xf9\xdf\x9b"
+			"\x90\x55\x00\xe1\x71\x92\x3a\x77"
+			"\x3d\x5f\x15\x30\xf2\xed\x7e\x96"
+			"\x4c\xb2\xee\xdc\x29\xe9\xad\x2f"
+			"\x3a\xfe\x93\xb2\x81\x4f\x79\xf5"
+			"\x00\x0f\xfc\x03\x66\xc2\x51\xe6",
+	},
+};
+
 /* Example vectors below taken from
  * http://www.oscca.gov.cn/UpFile/20101222141857786.pdf
  *
-- 
2.11.0

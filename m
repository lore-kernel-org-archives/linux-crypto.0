From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 3/4] crypto: testmgr - add AES GMAC test vectors
Date: Sun, 07 Apr 2013 16:43:51 +0300
Message-ID: <20130407134351.8718.76502.stgit@localhost6.localdomain6>
References: <20130407134340.8718.96643.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:53085 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933625Ab3DGNnx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Apr 2013 09:43:53 -0400
In-Reply-To: <20130407134340.8718.96643.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/tcrypt.c  |    4 ++
 crypto/testmgr.c |   17 +++++++++-
 crypto/testmgr.h |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 87ef7d6..6b911ef 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1225,6 +1225,10 @@ static int do_test(int m)
 		ret += tcrypt_test("rfc4106(gcm(aes))");
 		break;
 
+	case 152:
+		ret += tcrypt_test("rfc4543(gcm(aes))");
+		break;
+
 	case 200:
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index efd8b20..442ddb4 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2696,8 +2696,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-
-
 		.alg = "rfc4309(ccm(aes))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
@@ -2714,6 +2712,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "rfc4543(gcm(aes))",
+		.test = alg_test_aead,
+		.suite = {
+			.aead = {
+				.enc = {
+					.vecs = aes_gcm_rfc4543_enc_tv_template,
+					.count = AES_GCM_4543_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = aes_gcm_rfc4543_dec_tv_template,
+					.count = AES_GCM_4543_DEC_TEST_VECTORS
+				},
+			}
+		}
+	}, {
 		.alg = "rmd128",
 		.test = alg_test_hash,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index b5721e0..92db37d 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -12680,6 +12680,8 @@ static struct cipher_testvec cast6_xts_dec_tv_template[] = {
 #define AES_GCM_DEC_TEST_VECTORS 8
 #define AES_GCM_4106_ENC_TEST_VECTORS 7
 #define AES_GCM_4106_DEC_TEST_VECTORS 7
+#define AES_GCM_4543_ENC_TEST_VECTORS 1
+#define AES_GCM_4543_DEC_TEST_VECTORS 2
 #define AES_CCM_ENC_TEST_VECTORS 7
 #define AES_CCM_DEC_TEST_VECTORS 7
 #define AES_CCM_4309_ENC_TEST_VECTORS 7
@@ -18193,6 +18195,93 @@ static struct aead_testvec aes_gcm_rfc4106_dec_tv_template[] = {
 	}
 };
 
+static struct aead_testvec aes_gcm_rfc4543_enc_tv_template[] = {
+	{ /* From draft-mcgrew-gcm-test-01 */
+		.key	= "\x4c\x80\xcd\xef\xbb\x5d\x10\xda"
+			  "\x90\x6a\xc7\x3c\x36\x13\xa6\x34"
+			  "\x22\x43\x3c\x64",
+		.klen	= 20,
+		.iv	= zeroed_string,
+		.assoc	= "\x00\x00\x43\x21\x00\x00\x00\x07",
+		.alen	= 8,
+		.input	= "\x45\x00\x00\x30\xda\x3a\x00\x00"
+			  "\x80\x01\xdf\x3b\xc0\xa8\x00\x05"
+			  "\xc0\xa8\x00\x01\x08\x00\xc6\xcd"
+			  "\x02\x00\x07\x00\x61\x62\x63\x64"
+			  "\x65\x66\x67\x68\x69\x6a\x6b\x6c"
+			  "\x6d\x6e\x6f\x70\x71\x72\x73\x74"
+			  "\x01\x02\x02\x01",
+		.ilen	= 52,
+		.result	= "\x45\x00\x00\x30\xda\x3a\x00\x00"
+			  "\x80\x01\xdf\x3b\xc0\xa8\x00\x05"
+			  "\xc0\xa8\x00\x01\x08\x00\xc6\xcd"
+			  "\x02\x00\x07\x00\x61\x62\x63\x64"
+			  "\x65\x66\x67\x68\x69\x6a\x6b\x6c"
+			  "\x6d\x6e\x6f\x70\x71\x72\x73\x74"
+			  "\x01\x02\x02\x01\xf2\xa9\xa8\x36"
+			  "\xe1\x55\x10\x6a\xa8\xdc\xd6\x18"
+			  "\xe4\x09\x9a\xaa",
+		.rlen	= 68,
+	}
+};
+
+static struct aead_testvec aes_gcm_rfc4543_dec_tv_template[] = {
+	{ /* From draft-mcgrew-gcm-test-01 */
+		.key	= "\x4c\x80\xcd\xef\xbb\x5d\x10\xda"
+			  "\x90\x6a\xc7\x3c\x36\x13\xa6\x34"
+			  "\x22\x43\x3c\x64",
+		.klen	= 20,
+		.iv	= zeroed_string,
+		.assoc	= "\x00\x00\x43\x21\x00\x00\x00\x07",
+		.alen	= 8,
+		.input	= "\x45\x00\x00\x30\xda\x3a\x00\x00"
+			  "\x80\x01\xdf\x3b\xc0\xa8\x00\x05"
+			  "\xc0\xa8\x00\x01\x08\x00\xc6\xcd"
+			  "\x02\x00\x07\x00\x61\x62\x63\x64"
+			  "\x65\x66\x67\x68\x69\x6a\x6b\x6c"
+			  "\x6d\x6e\x6f\x70\x71\x72\x73\x74"
+			  "\x01\x02\x02\x01\xf2\xa9\xa8\x36"
+			  "\xe1\x55\x10\x6a\xa8\xdc\xd6\x18"
+			  "\xe4\x09\x9a\xaa",
+		.ilen	= 68,
+		.result	= "\x45\x00\x00\x30\xda\x3a\x00\x00"
+			  "\x80\x01\xdf\x3b\xc0\xa8\x00\x05"
+			  "\xc0\xa8\x00\x01\x08\x00\xc6\xcd"
+			  "\x02\x00\x07\x00\x61\x62\x63\x64"
+			  "\x65\x66\x67\x68\x69\x6a\x6b\x6c"
+			  "\x6d\x6e\x6f\x70\x71\x72\x73\x74"
+			  "\x01\x02\x02\x01",
+		.rlen	= 52,
+	}, { /* nearly same as previous, but should fail */
+		.key	= "\x4c\x80\xcd\xef\xbb\x5d\x10\xda"
+			  "\x90\x6a\xc7\x3c\x36\x13\xa6\x34"
+			  "\x22\x43\x3c\x64",
+		.klen	= 20,
+		.iv	= zeroed_string,
+		.assoc	= "\x00\x00\x43\x21\x00\x00\x00\x07",
+		.alen	= 8,
+		.input	= "\x45\x00\x00\x30\xda\x3a\x00\x00"
+			  "\x80\x01\xdf\x3b\xc0\xa8\x00\x05"
+			  "\xc0\xa8\x00\x01\x08\x00\xc6\xcd"
+			  "\x02\x00\x07\x00\x61\x62\x63\x64"
+			  "\x65\x66\x67\x68\x69\x6a\x6b\x6c"
+			  "\x6d\x6e\x6f\x70\x71\x72\x73\x74"
+			  "\x01\x02\x02\x01\xf2\xa9\xa8\x36"
+			  "\xe1\x55\x10\x6a\xa8\xdc\xd6\x18"
+			  "\x00\x00\x00\x00",
+		.ilen	= 68,
+		.novrfy = 1,
+		.result	= "\x45\x00\x00\x30\xda\x3a\x00\x00"
+			  "\x80\x01\xdf\x3b\xc0\xa8\x00\x05"
+			  "\xc0\xa8\x00\x01\x08\x00\xc6\xcd"
+			  "\x02\x00\x07\x00\x61\x62\x63\x64"
+			  "\x65\x66\x67\x68\x69\x6a\x6b\x6c"
+			  "\x6d\x6e\x6f\x70\x71\x72\x73\x74"
+			  "\x01\x02\x02\x01",
+		.rlen	= 52,
+	},
+};
+
 static struct aead_testvec aes_ccm_enc_tv_template[] = {
 	{ /* From RFC 3610 */
 		.key	= "\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"

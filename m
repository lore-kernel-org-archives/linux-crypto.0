From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v4 3/3] crypto: keywrap - add testmgr support
Date: Thu, 15 Oct 2015 09:07:40 +0200
Message-ID: <2963701.QnyuGqI2Hv@myon.chronox.de>
References: <5314960.0aGFzHXOSP@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: boris.brezillon@free-electrons.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34341 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbbJOHH7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 03:07:59 -0400
In-Reply-To: <5314960.0aGFzHXOSP@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The testmanager code for symmetric ciphers is extended to allow
verification of the IV after a cipher operation.

In addition, test vectors for kw(aes) for encryption and decryption are
added.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/testmgr.c | 28 +++++++++++++++++++++++++++-
 crypto/testmgr.h | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 25032b0..e48b1c8 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1034,12 +1034,22 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 
 		q = data;
 		if (memcmp(q, template[i].result, template[i].rlen)) {
-			pr_err("alg: skcipher%s: Test %d failed on %s for %s\n",
+			pr_err("alg: skcipher%s: Test %d failed (invalid result) on %s for %s\n",
 			       d, j, e, algo);
 			hexdump(q, template[i].rlen);
 			ret = -EINVAL;
 			goto out;
 		}
+
+		if (template[i].iv_out &&
+		    memcmp(iv, template[i].iv_out,
+			   crypto_skcipher_ivsize(tfm))) {
+			pr_err("alg: skcipher%s: Test %d failed (invalid output IV) on %s for %s\n",
+			       d, j, e, algo);
+			hexdump(iv, crypto_skcipher_ivsize(tfm));
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	j = 0;
@@ -3277,6 +3287,22 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.test = alg_test_null,
 	}, {
+		.alg = "kw(aes)",
+		.test = alg_test_skcipher,
+		.fips_allowed = 1,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = aes_kw_enc_tv_template,
+					.count = ARRAY_SIZE(aes_kw_enc_tv_template)
+				},
+				.dec = {
+					.vecs = aes_kw_dec_tv_template,
+					.count = ARRAY_SIZE(aes_kw_dec_tv_template)
+				}
+			}
+		}
+	}, {
 		.alg = "lrw(aes)",
 		.test = alg_test_skcipher,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index e10582d..da0a8fd 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -67,6 +67,7 @@ struct hash_testvec {
 struct cipher_testvec {
 	char *key;
 	char *iv;
+	char *iv_out;
 	char *input;
 	char *result;
 	unsigned short tap[MAX_TAP];
@@ -23832,6 +23833,46 @@ static struct aead_testvec rfc7539esp_dec_tv_template[] = {
 };
 
 /*
+ * All key wrapping test vectors taken from
+ * http://csrc.nist.gov/groups/STM/cavp/documents/mac/kwtestvectors.zip
+ *
+ * Note: as documented in keywrap.c, the ivout for encryption is the first
+ * semiblock of the ciphertext from the test vector. For decryption, iv is
+ * the first semiblock of the ciphertext.
+ */
+static struct cipher_testvec aes_kw_enc_tv_template[] = {
+	{
+		.key	= "\x75\x75\xda\x3a\x93\x60\x7c\xc2"
+			  "\xbf\xd8\xce\xc7\xaa\xdf\xd9\xa6",
+		.klen	= 16,
+		.input	= "\x42\x13\x6d\x3c\x38\x4a\x3e\xea"
+			  "\xc9\x5a\x06\x6f\xd2\x8f\xed\x3f",
+		.ilen	= 16,
+		.result	= "\xf6\x85\x94\x81\x6f\x64\xca\xa3"
+			  "\xf5\x6f\xab\xea\x25\x48\xf5\xfb",
+		.rlen	= 16,
+		.iv_out	= "\x03\x1f\x6b\xd7\xe6\x1e\x64\x3d",
+	},
+};
+
+static struct cipher_testvec aes_kw_dec_tv_template[] = {
+	{
+		.key	= "\x80\xaa\x99\x73\x27\xa4\x80\x6b"
+			  "\x6a\x7a\x41\xa5\x2b\x86\xc3\x71"
+			  "\x03\x86\xf9\x32\x78\x6e\xf7\x96"
+			  "\x76\xfa\xfb\x90\xb8\x26\x3c\x5f",
+		.klen	= 32,
+		.input	= "\xd3\x3d\x3d\x97\x7b\xf0\xa9\x15"
+			  "\x59\xf9\x9c\x8a\xcd\x29\x3d\x43",
+		.ilen	= 16,
+		.result	= "\x0a\x25\x6b\xa7\x5c\xfa\x03\xaa"
+			  "\xa0\x2b\xa9\x42\x03\xf1\x5b\xaa",
+		.rlen	= 16,
+		.iv	= "\x42\x3c\x96\x0d\x8a\x2a\xc4\xc1",
+	},
+};
+
+/*
  * ANSI X9.31 Continuous Pseudo-Random Number Generator (AES mode)
  * test vectors, taken from Appendix B.2.9 and B.2.10:
  *     http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
-- 
2.5.0

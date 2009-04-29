From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/2] add ansi_cprng test vectors
Date: Tue, 28 Apr 2009 21:32:10 -0400
Message-ID: <200904282132.10884.jarod@redhat.com>
References: <200904282127.33190.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Neil Horman <nhorman@tuxdriver.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49812 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759378AbZD2BcT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2009 21:32:19 -0400
In-Reply-To: <200904282127.33190.jarod@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add ANSI X9.31 Continuous Pseudo-Random Number Generator (AES mode),
aka 'ansi_cprng' test vectors, taken from Appendix B.2.9 and B.2.10
of the NIST RNGVS document, found here:
    http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf

Successfully tested against both the cryptodev-2.6 tree and a Red
Hat Enterprise Linux 5.4 kernel, via 'modprobe tcrypt mode=150'.

The selection of 150 was semi-arbitrary, didn't seem like it should
go any place in particular, so I started a new range for rng tests.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/tcrypt.c  |    4 ++
 crypto/testmgr.c |    9 +++++
 crypto/testmgr.h |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 0452036..ea3b8a8 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -707,6 +707,10 @@ static void do_test(int m)
 		tcrypt_test("hmac(rmd160)");
 		break;
 
+	case 150:
+		tcrypt_test("ansi_cprng");
+		break;
+
 	case 200:
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6330081..a0af8b8 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1380,6 +1380,15 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
+		.alg = "ansi_cprng",
+		.test = alg_test_cprng,
+		.suite = {
+			.cprng = {
+				.vecs = ansi_cprng_aes_tv_template,
+				.count = ANSI_CPRNG_AES_TEST_VECTORS
+			}
+		}
+	}, {
 		.alg = "cbc(aes)",
 		.test = alg_test_skcipher,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 13d5a61..c1c709b 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -6208,6 +6208,102 @@ static struct aead_testvec aes_ccm_rfc4309_dec_tv_template[] = {
 	},
 };
 
+/*
+ * ANSI X9.31 Continuous Pseudo-Random Number Generator (AES mode)
+ * test vectors, taken from Appendix B.2.9 and B.2.10:
+ *     http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
+ * Only AES-128 is supported at this time.
+ */
+#define ANSI_CPRNG_AES_TEST_VECTORS	6
+
+static struct cprng_testvec ansi_cprng_aes_tv_template[] = {
+	{
+		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
+			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
+		.klen	= 16,
+		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
+			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xf9",
+		.dtlen	= 16,
+		.v	= "\x80\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.vlen	= 16,
+		.result	= "\x59\x53\x1e\xd1\x3b\xb0\xc0\x55"
+			  "\x84\x79\x66\x85\xc1\x2f\x76\x41",
+		.rlen	= 16,
+		.loops	= 1,
+	}, {
+		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
+			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
+		.klen	= 16,
+		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
+			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfa",
+		.dtlen	= 16,
+		.v	= "\xc0\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.vlen	= 16,
+		.result	= "\x7c\x22\x2c\xf4\xca\x8f\xa2\x4c"
+			  "\x1c\x9c\xb6\x41\xa9\xf3\x22\x0d",
+		.rlen	= 16,
+		.loops	= 1,
+	}, {
+		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
+			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
+		.klen	= 16,
+		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
+			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfb",
+		.dtlen	= 16,
+		.v	= "\xe0\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.vlen	= 16,
+		.result	= "\x8a\xaa\x00\x39\x66\x67\x5b\xe5"
+			  "\x29\x14\x28\x81\xa9\x4d\x4e\xc7",
+		.rlen	= 16,
+		.loops	= 1,
+	}, {
+		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
+			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
+		.klen	= 16,
+		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
+			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfc",
+		.dtlen	= 16,
+		.v	= "\xf0\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.vlen	= 16,
+		.result	= "\x88\xdd\xa4\x56\x30\x24\x23\xe5"
+			  "\xf6\x9d\xa5\x7e\x7b\x95\xc7\x3a",
+		.rlen	= 16,
+		.loops	= 1,
+	}, {
+		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
+			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
+		.klen	= 16,
+		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
+			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfd",
+		.dtlen	= 16,
+		.v	= "\xf8\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.vlen	= 16,
+		.result	= "\x05\x25\x92\x46\x61\x79\xd2\xcb"
+			  "\x78\xc4\x0b\x14\x0a\x5a\x9a\xc8",
+		.rlen	= 16,
+		.loops	= 1,
+	}, {	/* Monte Carlo Test */
+		.key	= "\x9f\x5b\x51\x20\x0b\xf3\x34\xb5"
+			  "\xd8\x2b\xe8\xc3\x72\x55\xc8\x48",
+		.klen	= 16,
+		.dt	= "\x63\x76\xbb\xe5\x29\x02\xba\x3b"
+			  "\x67\xc9\x25\xfa\x70\x1f\x11\xac",
+		.dtlen	= 16,
+		.v	= "\x57\x2c\x8e\x76\x87\x26\x47\x97"
+			  "\x7e\x74\xfb\xdd\xc4\x95\x01\xd1",
+		.vlen	= 16,
+		.result	= "\x48\xe9\xbd\x0d\x06\xee\x18\xfb"
+			  "\xe4\x57\x90\xd5\xc3\xfc\x9b\x73",
+		.rlen	= 16,
+		.loops	= 10000,
+	},
+};
+
 /* Cast5 test vectors from RFC 2144 */
 #define CAST5_ENC_TEST_VECTORS	3
 #define CAST5_DEC_TEST_VECTORS	3


-- 
Jarod Wilson
jarod@redhat.com

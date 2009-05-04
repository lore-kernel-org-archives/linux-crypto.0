From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] crypto: add ctr(aes) test vectors
Date: Mon, 4 May 2009 16:24:44 -0400
Message-ID: <200905041624.45060.jarod@redhat.com>
References: <200904282118.22823.jarod@redhat.com> <20090504111010.GA4991@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53360 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbZEDUZb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2009 16:25:31 -0400
In-Reply-To: <20090504111010.GA4991@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday 04 May 2009 07:10:10 Herbert Xu wrote:
> On Tue, Apr 28, 2009 at 09:18:22PM -0400, Jarod Wilson wrote:
> > Per the NIST AESAVS document, Appendix A[1], it isn't possible to
> > have automated self-tests for counter-mode AES, but people are
> > misled to believe something is wrong by the message that says there
> > is no test for ctr(aes). Simply suppress all 'no test for ctr(aes*'
> > messages if fips_enabled is set to avoid confusion.
> 
> This is not true at all.  In our implementation the counter is
> set through the IV so it definitely is possible to test counter
> mode algorithms in Linux.

Indeed, the first enc/dec operation after we set the counter *is*
completely deterministic across all implementations, the AESAVS
is referring to tests with multiple operations, which aren't
possible, due to varying implementations of counter increment
routines. This patch adds test vectors for ctr(aes), using the
first block input values from Appendix F.5 of NIST Special Pub
800-38A.

Was also necessary to rename the rfc3686(ctr(aes)) components
slightly, to resolve a namespace collision.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |   23 +++++++++++--
 crypto/testmgr.h |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 109 insertions(+), 6 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ffe7963..0efdda7 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1518,6 +1518,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "ctr(aes)",
+		.test = alg_test_skcipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = aes_ctr_enc_tv_template,
+					.count = AES_CTR_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = aes_ctr_dec_tv_template,
+					.count = AES_CTR_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
 		.alg = "cts(cbc(aes))",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -1967,12 +1982,12 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.cipher = {
 				.enc = {
-					.vecs = aes_ctr_enc_tv_template,
-					.count = AES_CTR_ENC_TEST_VECTORS
+					.vecs = aes_ctr_rfc3686_enc_tv_template,
+					.count = AES_CTR_3686_ENC_TEST_VECTORS
 				},
 				.dec = {
-					.vecs = aes_ctr_dec_tv_template,
-					.count = AES_CTR_DEC_TEST_VECTORS
+					.vecs = aes_ctr_rfc3686_dec_tv_template,
+					.count = AES_CTR_3686_DEC_TEST_VECTORS
 				}
 			}
 		}
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index c1c709b..0a11285 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -2854,8 +2854,10 @@ static struct cipher_testvec cast6_dec_tv_template[] = {
 #define AES_LRW_DEC_TEST_VECTORS 8
 #define AES_XTS_ENC_TEST_VECTORS 4
 #define AES_XTS_DEC_TEST_VECTORS 4
-#define AES_CTR_ENC_TEST_VECTORS 7
-#define AES_CTR_DEC_TEST_VECTORS 6
+#define AES_CTR_ENC_TEST_VECTORS 3
+#define AES_CTR_DEC_TEST_VECTORS 3
+#define AES_CTR_3686_ENC_TEST_VECTORS 7
+#define AES_CTR_3686_DEC_TEST_VECTORS 6
 #define AES_GCM_ENC_TEST_VECTORS 9
 #define AES_GCM_DEC_TEST_VECTORS 8
 #define AES_CCM_ENC_TEST_VECTORS 7
@@ -3998,6 +4000,92 @@ static struct cipher_testvec aes_xts_dec_tv_template[] = {
 
 
 static struct cipher_testvec aes_ctr_enc_tv_template[] = {
+	{ /* From NIST Special Publication 800-38A, Appendix F.5 */
+		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.klen	= 16,
+		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.input	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a",
+		.ilen	= 16,
+		.result	= "\x87\x4d\x61\x91\xb6\x20\xe3\x26"
+			  "\x1b\xef\x68\x64\x99\x0d\xb6\xce",
+		.rlen	= 16,
+	}, {
+		.key	= "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
+			  "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
+			  "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
+		.klen	= 24,
+		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.input	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a",
+		.ilen	= 16,
+		.result	= "\x1a\xbc\x93\x24\x17\x52\x1c\xa2"
+			  "\x4f\x2b\x04\x59\xfe\x7e\x6e\x0b",
+		.rlen	= 16,
+	}, {
+		.key	= "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
+			  "\x2b\x73\xae\xf0\x85\x7d\x77\x81"
+			  "\x1f\x35\x2c\x07\x3b\x61\x08\xd7"
+			  "\x2d\x98\x10\xa3\x09\x14\xdf\xf4",
+		.klen	= 32,
+		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.input	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a",
+		.ilen	= 16,
+		.result	= "\x60\x1e\xc3\x13\x77\x57\x89\xa5"
+			  "\xb7\xa7\xf5\x04\xbb\xf3\xd2\x28",
+		.rlen	= 16,
+	}
+};
+
+static struct cipher_testvec aes_ctr_dec_tv_template[] = {
+	{ /* From NIST Special Publication 800-38A, Appendix F.5 */
+		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.klen	= 16,
+		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.input	= "\x87\x4d\x61\x91\xb6\x20\xe3\x26"
+			  "\x1b\xef\x68\x64\x99\x0d\xb6\xce",
+		.ilen	= 16,
+		.result	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a",
+		.rlen	= 16,
+	}, {
+		.key	= "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
+			  "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
+			  "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
+		.klen	= 24,
+		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.input	= "\x1a\xbc\x93\x24\x17\x52\x1c\xa2"
+			  "\x4f\x2b\x04\x59\xfe\x7e\x6e\x0b",
+		.ilen	= 16,
+		.result	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a",
+		.rlen	= 16,
+	}, {
+		.key	= "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
+			  "\x2b\x73\xae\xf0\x85\x7d\x77\x81"
+			  "\x1f\x35\x2c\x07\x3b\x61\x08\xd7"
+			  "\x2d\x98\x10\xa3\x09\x14\xdf\xf4",
+		.klen	= 32,
+		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.input	= "\x60\x1e\xc3\x13\x77\x57\x89\xa5"
+			  "\xb7\xa7\xf5\x04\xbb\xf3\xd2\x28",
+		.ilen	= 16,
+		.result	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a",
+		.rlen	= 16,
+	}
+};
+
+static struct cipher_testvec aes_ctr_rfc3686_enc_tv_template[] = {
 	{ /* From RFC 3686 */
 		.key	= "\xae\x68\x52\xf8\x12\x10\x67\xcc"
 			  "\x4b\xf7\xa5\x76\x55\x77\xf3\x9e"

-- 
Jarod Wilson
jarod@redhat.com

From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH v2] crypto: add ctr(aes) test vectors
Date: Tue, 5 May 2009 10:42:58 -0400
Message-ID: <200905051042.58929.jarod@redhat.com>
References: <200904282118.22823.jarod@redhat.com> <20090505131835.GA18659@gondor.apana.org.au> <200905050955.24743.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49735 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZEEOns (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2009 10:43:48 -0400
In-Reply-To: <200905050955.24743.jarod@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday 05 May 2009 09:55:24 Jarod Wilson wrote:
> On Tuesday 05 May 2009 09:18:35 Herbert Xu wrote:
> > On Mon, May 04, 2009 at 04:24:44PM -0400, Jarod Wilson wrote:
> > >
> > > Indeed, the first enc/dec operation after we set the counter *is*
> > > completely deterministic across all implementations, the AESAVS
> > > is referring to tests with multiple operations, which aren't
> > > possible, due to varying implementations of counter increment
> > > routines. This patch adds test vectors for ctr(aes), using the
> > > first block input values from Appendix F.5 of NIST Special Pub
> > > 800-38A.
> > 
> > Well, our ctr(aes) must be completely deterministic as it is
> > used as the base for CCM and GCM.  In fact, if it weren't so
> > then you can't use it for anything since two implementations
> > may produces different outputs.
> 
> Yeah, that makes sense, I believe I finally see the light.
> 
> > So if you could resend some vectors that test multiple blocks
> > then I'll happily add them.
> 
> Multi-block test vectors coming shortly, passing in all the input
> blocks from F.5 of 800-38A is spitting back the expected answers
> for ever block.

Now with multi-block test vectors, all from SP800-38A, Appendix F.5.
Also added ctr(aes) to case 10 in tcrypt.

Quickly smoke-tested in fips mode, got back "alg_test: alg
ctr(aes-x86_64) (ctr(aes)) self-test passed".

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/tcrypt.c  |    1 +
 crypto/testmgr.c |   23 ++++++-
 crypto/testmgr.h |  164 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 182 insertions(+), 6 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ea3b8a8..9e4974e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -526,6 +526,7 @@ static void do_test(int m)
 		tcrypt_test("cbc(aes)");
 		tcrypt_test("lrw(aes)");
 		tcrypt_test("xts(aes)");
+		tcrypt_test("ctr(aes)");
 		tcrypt_test("rfc3686(ctr(aes))");
 		break;
 
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
index c1c709b..6883fd7 100644
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
@@ -3998,6 +4000,164 @@ static struct cipher_testvec aes_xts_dec_tv_template[] = {
 
 
 static struct cipher_testvec aes_ctr_enc_tv_template[] = {
+	{ /* From NIST Special Publication 800-38A, Appendix F.5 */
+		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.klen	= 16,
+		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.input	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ilen	= 64,
+		.result	= "\x87\x4d\x61\x91\xb6\x20\xe3\x26"
+			  "\x1b\xef\x68\x64\x99\x0d\xb6\xce"
+			  "\x98\x06\xf6\x6b\x79\x70\xfd\xff"
+			  "\x86\x17\x18\x7b\xb9\xff\xfd\xff"
+			  "\x5a\xe4\xdf\x3e\xdb\xd5\xd3\x5e"
+			  "\x5b\x4f\x09\x02\x0d\xb0\x3e\xab"
+			  "\x1e\x03\x1d\xda\x2f\xbe\x03\xd1"
+			  "\x79\x21\x70\xa0\xf3\x00\x9c\xee",
+		.rlen	= 64,
+	}, {
+		.key	= "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
+			  "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
+			  "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
+		.klen	= 24,
+		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.input	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ilen	= 64,
+		.result	= "\x1a\xbc\x93\x24\x17\x52\x1c\xa2"
+			  "\x4f\x2b\x04\x59\xfe\x7e\x6e\x0b"
+			  "\x09\x03\x39\xec\x0a\xa6\xfa\xef"
+			  "\xd5\xcc\xc2\xc6\xf4\xce\x8e\x94"
+			  "\x1e\x36\xb2\x6b\xd1\xeb\xc6\x70"
+			  "\xd1\xbd\x1d\x66\x56\x20\xab\xf7"
+			  "\x4f\x78\xa7\xf6\xd2\x98\x09\x58"
+			  "\x5a\x97\xda\xec\x58\xc6\xb0\x50",
+		.rlen	= 64,
+	}, {
+		.key	= "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
+			  "\x2b\x73\xae\xf0\x85\x7d\x77\x81"
+			  "\x1f\x35\x2c\x07\x3b\x61\x08\xd7"
+			  "\x2d\x98\x10\xa3\x09\x14\xdf\xf4",
+		.klen	= 32,
+		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.input	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ilen	= 64,
+		.result	= "\x60\x1e\xc3\x13\x77\x57\x89\xa5"
+			  "\xb7\xa7\xf5\x04\xbb\xf3\xd2\x28"
+			  "\xf4\x43\xe3\xca\x4d\x62\xb5\x9a"
+			  "\xca\x84\xe9\x90\xca\xca\xf5\xc5"
+			  "\x2b\x09\x30\xda\xa2\x3d\xe9\x4c"
+			  "\xe8\x70\x17\xba\x2d\x84\x98\x8d"
+			  "\xdf\xc9\xc5\x8d\xb6\x7a\xad\xa6"
+			  "\x13\xc2\xdd\x08\x45\x79\x41\xa6",
+		.rlen	= 64,
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
+			  "\x1b\xef\x68\x64\x99\x0d\xb6\xce"
+			  "\x98\x06\xf6\x6b\x79\x70\xfd\xff"
+			  "\x86\x17\x18\x7b\xb9\xff\xfd\xff"
+			  "\x5a\xe4\xdf\x3e\xdb\xd5\xd3\x5e"
+			  "\x5b\x4f\x09\x02\x0d\xb0\x3e\xab"
+			  "\x1e\x03\x1d\xda\x2f\xbe\x03\xd1"
+			  "\x79\x21\x70\xa0\xf3\x00\x9c\xee",
+		.ilen	= 64,
+		.result	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.rlen	= 64,
+	}, {
+		.key	= "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
+			  "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
+			  "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
+		.klen	= 24,
+		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.input	= "\x1a\xbc\x93\x24\x17\x52\x1c\xa2"
+			  "\x4f\x2b\x04\x59\xfe\x7e\x6e\x0b"
+			  "\x09\x03\x39\xec\x0a\xa6\xfa\xef"
+			  "\xd5\xcc\xc2\xc6\xf4\xce\x8e\x94"
+			  "\x1e\x36\xb2\x6b\xd1\xeb\xc6\x70"
+			  "\xd1\xbd\x1d\x66\x56\x20\xab\xf7"
+			  "\x4f\x78\xa7\xf6\xd2\x98\x09\x58"
+			  "\x5a\x97\xda\xec\x58\xc6\xb0\x50",
+		.ilen	= 64,
+		.result	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.rlen	= 64,
+	}, {
+		.key	= "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
+			  "\x2b\x73\xae\xf0\x85\x7d\x77\x81"
+			  "\x1f\x35\x2c\x07\x3b\x61\x08\xd7"
+			  "\x2d\x98\x10\xa3\x09\x14\xdf\xf4",
+		.klen	= 32,
+		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.input	= "\x60\x1e\xc3\x13\x77\x57\x89\xa5"
+			  "\xb7\xa7\xf5\x04\xbb\xf3\xd2\x28"
+			  "\xf4\x43\xe3\xca\x4d\x62\xb5\x9a"
+			  "\xca\x84\xe9\x90\xca\xca\xf5\xc5"
+			  "\x2b\x09\x30\xda\xa2\x3d\xe9\x4c"
+			  "\xe8\x70\x17\xba\x2d\x84\x98\x8d"
+			  "\xdf\xc9\xc5\x8d\xb6\x7a\xad\xa6"
+			  "\x13\xc2\xdd\x08\x45\x79\x41\xa6",
+		.ilen	= 64,
+		.result	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.rlen	= 64,
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

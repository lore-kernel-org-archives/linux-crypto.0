From: puneets-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v3] crypto: testmgr: add support for aes ofb mode
Date: Tue, 26 Apr 2011 14:41:11 +0530
Message-ID: <1303809071-4081-1-git-send-email-puneets@nvidia.com>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	puneet saxena <puneets-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
To: herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: puneet saxena <puneets-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

the fix add testcase for testing aes ofb mode.

Signed-off-by: Puneet Saxena <puneets-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
---
v3: fix indentation  

 crypto/testmgr.c |   16 ++++++++++++++
 crypto/testmgr.h |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2854865..b6b93d4 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2219,6 +2219,22 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "ofb(aes)",
+		.test = alg_test_skcipher,
+		.fips_allowed = 1,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = aes_ofb_enc_tv_template,
+					.count = AES_OFB_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = aes_ofb_dec_tv_template,
+					.count = AES_OFB_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
 		.alg = "pcbc(fcrypt)",
 		.test = alg_test_skcipher,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index aa6dac0..4ed6b6c 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -2980,6 +2980,8 @@ static struct cipher_testvec cast6_dec_tv_template[] = {
 #define AES_XTS_DEC_TEST_VECTORS 4
 #define AES_CTR_ENC_TEST_VECTORS 3
 #define AES_CTR_DEC_TEST_VECTORS 3
+#define AES_OFB_ENC_TEST_VECTORS 1
+#define AES_OFB_DEC_TEST_VECTORS 1
 #define AES_CTR_3686_ENC_TEST_VECTORS 7
 #define AES_CTR_3686_DEC_TEST_VECTORS 6
 #define AES_GCM_ENC_TEST_VECTORS 9
@@ -4123,8 +4125,6 @@ static struct cipher_testvec aes_xts_dec_tv_template[] = {
 		.rlen   = 512,
 	}
 };
-
-
 static struct cipher_testvec aes_ctr_enc_tv_template[] = {
 	{ /* From NIST Special Publication 800-38A, Appendix F.5 */
 		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
@@ -5506,6 +5506,64 @@ static struct cipher_testvec aes_ctr_rfc3686_dec_tv_template[] = {
 	},
 };
 
+static struct cipher_testvec aes_ofb_enc_tv_template[] = {
+	 /* From NIST Special Publication 800-38A, Appendix F.5 */
+	{
+		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07\x08"
+			  "\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.input = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ilen	= 64,
+		.result = "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
+			  "\x33\x34\x49\xf8\xe8\x3c\xfb\x4a"
+			  "\x77\x89\x50\x8d\x16\x91\x8f\x03\xf5"
+			  "\x3c\x52\xda\xc5\x4e\xd8\x25"
+			  "\x97\x40\x05\x1e\x9c\x5f\xec\xf6\x43"
+			  "\x44\xf7\xa8\x22\x60\xed\xcc"
+			  "\x30\x4c\x65\x28\xf6\x59\xc7\x78"
+			  "\x66\xa5\x10\xd9\xc1\xd6\xae\x5e",
+		.rlen	= 64,
+	}
+};
+
+static struct cipher_testvec aes_ofb_dec_tv_template[] = {
+	 /* From NIST Special Publication 800-38A, Appendix F.5 */
+	{
+		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07\x08"
+			  "\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.input = "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
+			  "\x33\x34\x49\xf8\xe8\x3c\xfb\x4a"
+			  "\x77\x89\x50\x8d\x16\x91\x8f\x03\xf5"
+			  "\x3c\x52\xda\xc5\x4e\xd8\x25"
+			  "\x97\x40\x05\x1e\x9c\x5f\xec\xf6\x43"
+			  "\x44\xf7\xa8\x22\x60\xed\xcc"
+			  "\x30\x4c\x65\x28\xf6\x59\xc7\x78"
+			  "\x66\xa5\x10\xd9\xc1\xd6\xae\x5e",
+		.ilen	= 64,
+		.result = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
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
 static struct aead_testvec aes_gcm_enc_tv_template[] = {
 	{ /* From McGrew & Viega - http://citeseer.ist.psu.edu/656989.html */
 		.key    = zeroed_string,
-- 
1.7.1.1

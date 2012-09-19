From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/3] crypto: testmgr - add test vectors for partial ctr(cast5)
 and ctr(cast6)
Date: Wed, 19 Sep 2012 09:42:54 +0300
Message-ID: <20120919064254.10607.57422.stgit@localhost6.localdomain6>
References: <20120919064249.10607.45593.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:45766 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2ISGm5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2012 02:42:57 -0400
In-Reply-To: <20120919064249.10607.45593.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/testmgr.h |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 70984f5..2257157 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -6979,8 +6979,8 @@ static struct cipher_testvec serpent_xts_dec_tv_template[] = {
 #define CAST6_DEC_TEST_VECTORS		4
 #define CAST6_CBC_ENC_TEST_VECTORS	1
 #define CAST6_CBC_DEC_TEST_VECTORS	1
-#define CAST6_CTR_ENC_TEST_VECTORS	1
-#define CAST6_CTR_DEC_TEST_VECTORS	1
+#define CAST6_CTR_ENC_TEST_VECTORS	2
+#define CAST6_CTR_DEC_TEST_VECTORS	2
 #define CAST6_LRW_ENC_TEST_VECTORS	1
 #define CAST6_LRW_DEC_TEST_VECTORS	1
 #define CAST6_XTS_ENC_TEST_VECTORS	1
@@ -7621,6 +7621,22 @@ static struct cipher_testvec cast6_ctr_enc_tv_template[] = {
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
 		.input	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
+			  "\x3A",
+		.ilen	= 17,
+		.result	= "\x26\x0A\xF1\xE2\x3F\x8A\xEF\xA3"
+			  "\x53\x9A\x5E\x1B\x2A\x1A\xC6\x0A"
+			  "\x57",
+		.rlen	= 17,
+	}, { /* Generated from TF test vectors */
+		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
+			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
+			  "\x27\x04\xE1\x27\x04\xE1\xBE\x9B"
+			  "\x78\xBE\x9B\x78\x55\x32\x0F\x55",
+		.klen	= 32,
+		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
+			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.input	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
+			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
 			  "\xAC\x20\xB7\x4E\xE5\x59\xF0\x87"
 			  "\x1E\x92\x29\xC0\x34\xCB\x62\xF9"
@@ -7762,6 +7778,22 @@ static struct cipher_testvec cast6_ctr_dec_tv_template[] = {
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
 		.input	= "\x26\x0A\xF1\xE2\x3F\x8A\xEF\xA3"
 			  "\x53\x9A\x5E\x1B\x2A\x1A\xC6\x0A"
+			  "\x57",
+		.ilen	= 17,
+		.result	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
+			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
+			  "\x3A",
+		.rlen	= 17,
+	}, { /* Generated from TF test vectors */
+		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
+			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
+			  "\x27\x04\xE1\x27\x04\xE1\xBE\x9B"
+			  "\x78\xBE\x9B\x78\x55\x32\x0F\x55",
+		.klen	= 32,
+		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
+			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.input	= "\x26\x0A\xF1\xE2\x3F\x8A\xEF\xA3"
+			  "\x53\x9A\x5E\x1B\x2A\x1A\xC6\x0A"
 			  "\x57\xA3\xEF\x47\x2A\xE8\x88\xA7"
 			  "\x3C\xD0\xEC\xB9\x94\x50\x7D\x56"
 			  "\xBC\xE1\xC1\xF5\xE1\xEE\x12\xF8"
@@ -13657,8 +13689,8 @@ static struct cprng_testvec ansi_cprng_aes_tv_template[] = {
 #define CAST5_DEC_TEST_VECTORS		4
 #define CAST5_CBC_ENC_TEST_VECTORS	1
 #define CAST5_CBC_DEC_TEST_VECTORS	1
-#define CAST5_CTR_ENC_TEST_VECTORS	1
-#define CAST5_CTR_DEC_TEST_VECTORS	1
+#define CAST5_CTR_ENC_TEST_VECTORS	2
+#define CAST5_CTR_DEC_TEST_VECTORS	2
 
 static struct cipher_testvec cast5_enc_tv_template[] = {
 	{
@@ -14266,6 +14298,19 @@ static struct cipher_testvec cast5_ctr_enc_tv_template[] = {
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F",
 		.input	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
+			  "\x3A",
+		.ilen	= 17,
+		.result	= "\xFF\xC4\x2E\x82\x3D\xF8\xA8\x39"
+			  "\x7C\x52\xC4\xD3\xBB\x62\xC6\xA8"
+			  "\x0C",
+		.rlen	= 17,
+	}, { /* Generated from TF test vectors */
+		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
+			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
+		.klen	= 16,
+		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F",
+		.input	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
+			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
 			  "\xAC\x20\xB7\x4E\xE5\x59\xF0\x87"
 			  "\x1E\x92\x29\xC0\x34\xCB\x62\xF9"
@@ -14404,6 +14449,19 @@ static struct cipher_testvec cast5_ctr_dec_tv_template[] = {
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F",
 		.input	= "\xFF\xC4\x2E\x82\x3D\xF8\xA8\x39"
 			  "\x7C\x52\xC4\xD3\xBB\x62\xC6\xA8"
+			  "\x0C",
+		.ilen	= 17,
+		.result	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
+			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
+			  "\x3A",
+		.rlen	= 17,
+	}, { /* Generated from TF test vectors */
+		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
+			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
+		.klen	= 16,
+		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F",
+		.input	= "\xFF\xC4\x2E\x82\x3D\xF8\xA8\x39"
+			  "\x7C\x52\xC4\xD3\xBB\x62\xC6\xA8"
 			  "\x0C\x63\xA5\x55\xE3\xF8\x1C\x7F"
 			  "\xDC\x59\xF9\xA0\x52\xAD\x83\xDF"
 			  "\xD5\x3B\x53\x4A\xAA\x1F\x49\x44"

From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 3/4] crypto: CTR DRBG - use full CTR AES for update
Date: Tue, 14 Jun 2016 07:35:37 +0200
Message-ID: <3327520.LEXYZXk9td@positron.chronox.de>
References: <1842774.dgV8IOeQEu@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36442 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbcFNFgY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 01:36:24 -0400
In-Reply-To: <1842774.dgV8IOeQEu@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CTR DRBG update function performs a full CTR AES operation including
the XOR with "plaintext" data. Hence, remove the XOR from the code and
use the CTR mode to do the XOR.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 8ac3ea1..8ceb716 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -258,7 +258,10 @@ static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
 			  const struct drbg_string *in);
 static int drbg_init_sym_kernel(struct drbg_state *drbg);
 static int drbg_fini_sym_kernel(struct drbg_state *drbg);
-static int drbg_kcapi_sym_ctr(struct drbg_state *drbg, u8 *outbuf, u32 outlen);
+static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
+			      u8 *inbuf, u32 inbuflen,
+			      u8 *outbuf, u32 outlen);
+#define DRBG_CTR_NULL_LEN 128
 
 /* BCC function for CTR DRBG as defined in 10.4.3 */
 static int drbg_ctr_bcc(struct drbg_state *drbg,
@@ -481,8 +484,6 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 	unsigned char *temp = drbg->scratchpad;
 	unsigned char *df_data = drbg->scratchpad + drbg_statelen(drbg) +
 				 drbg_blocklen(drbg);
-	unsigned char *temp_p, *df_data_p; /* pointer to iterate over buffers */
-	unsigned int len = 0;
 
 	if (3 > reseed)
 		memset(df_data, 0, drbg_statelen(drbg));
@@ -510,18 +511,11 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 			goto out;
 	}
 
-	ret = drbg_kcapi_sym_ctr(drbg, temp, drbg_statelen(drbg));
+	ret = drbg_kcapi_sym_ctr(drbg, df_data, drbg_statelen(drbg),
+				 temp, drbg_statelen(drbg));
 	if (ret)
 		return ret;
 
-	/* 10.2.1.2 step 4 */
-	temp_p = temp;
-	df_data_p = df_data;
-	for (len = 0; len < drbg_statelen(drbg); len++) {
-		*temp_p ^= *df_data_p;
-		df_data_p++; temp_p++;
-	}
-
 	/* 10.2.1.2 step 5 */
 	memcpy(drbg->C, temp, drbg_keylen(drbg));
 	ret = crypto_skcipher_setkey(drbg->ctr_handle, drbg->C,
@@ -561,7 +555,8 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 	}
 
 	/* 10.2.1.5.2 step 4.1 */
-	ret = drbg_kcapi_sym_ctr(drbg, buf, len);
+	ret = drbg_kcapi_sym_ctr(drbg, drbg->ctr_null_value, DRBG_CTR_NULL_LEN,
+				 buf, len);
 	if (ret)
 		return ret;
 
@@ -1657,7 +1652,6 @@ static void drbg_skcipher_cb(struct crypto_async_request *req, int error)
 	complete(&drbg->ctr_completion);
 }
 
-#define DRBG_CTR_NULL_LEN 128
 static int drbg_init_sym_kernel(struct drbg_state *drbg)
 {
 	struct crypto_cipher *tfm;
@@ -1733,14 +1727,16 @@ static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
 	return 0;
 }
 
-static int drbg_kcapi_sym_ctr(struct drbg_state *drbg, u8 *outbuf, u32 outlen)
+static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
+			      u8 *inbuf, u32 inlen,
+			      u8 *outbuf, u32 outlen)
 {
 	struct scatterlist sg_in;
 
-	sg_init_one(&sg_in, drbg->ctr_null_value, DRBG_CTR_NULL_LEN);
+	sg_init_one(&sg_in, inbuf, inlen);
 
 	while (outlen) {
-		u32 cryptlen = min_t(u32, outlen, DRBG_CTR_NULL_LEN);
+		u32 cryptlen = min_t(u32, inlen, outlen);
 		struct scatterlist sg_out;
 		int ret;
 
-- 
2.5.5

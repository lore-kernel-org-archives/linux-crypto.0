From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: drbg - set HMAC key only when altered
Date: Mon, 28 Mar 2016 16:47:55 +0200
Message-ID: <1989575.kgMrm1hmR5@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33666 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbcC1OsC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Mar 2016 10:48:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The HMAC implementation allows setting the HMAC key independently from
the hashing operation. Therefore, the key only needs to be set when a
new key is generated.

This patch increases the speed of the HMAC DRBG by at least 35% depending
on the use case.

The patch is fully CAVS tested.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1b86310..0a3538f 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -592,8 +592,10 @@ static const struct drbg_state_ops drbg_ctr_ops = {
  ******************************************************************/
 
 #if defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_HMAC)
-static int drbg_kcapi_hash(struct drbg_state *drbg, const unsigned char *key,
-			   unsigned char *outval, const struct list_head *in);
+static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
+			   const struct list_head *in);
+static void drbg_kcapi_hmacsetkey(struct drbg_state *drbg,
+				  const unsigned char *key);
 static int drbg_init_hash_kernel(struct drbg_state *drbg);
 static int drbg_fini_hash_kernel(struct drbg_state *drbg);
 #endif /* (CONFIG_CRYPTO_DRBG_HASH || CONFIG_CRYPTO_DRBG_HMAC) */
@@ -619,9 +621,11 @@ static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
 	LIST_HEAD(seedlist);
 	LIST_HEAD(vdatalist);
 
-	if (!reseed)
+	if (!reseed) {
 		/* 10.1.2.3 step 2 -- memset(0) of C is implicit with kzalloc */
 		memset(drbg->V, 1, drbg_statelen(drbg));
+		drbg_kcapi_hmacsetkey(drbg, drbg->C);
+	}
 
 	drbg_string_fill(&seed1, drbg->V, drbg_statelen(drbg));
 	list_add_tail(&seed1.list, &seedlist);
@@ -641,12 +645,13 @@ static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
 			prefix = DRBG_PREFIX1;
 		/* 10.1.2.2 step 1 and 4 -- concatenation and HMAC for key */
 		seed2.buf = &prefix;
-		ret = drbg_kcapi_hash(drbg, drbg->C, drbg->C, &seedlist);
+		ret = drbg_kcapi_hash(drbg, drbg->C, &seedlist);
 		if (ret)
 			return ret;
+		drbg_kcapi_hmacsetkey(drbg, drbg->C);
 
 		/* 10.1.2.2 step 2 and 5 -- HMAC for V */
-		ret = drbg_kcapi_hash(drbg, drbg->C, drbg->V, &vdatalist);
+		ret = drbg_kcapi_hash(drbg, drbg->V, &vdatalist);
 		if (ret)
 			return ret;
 
@@ -681,7 +686,7 @@ static int drbg_hmac_generate(struct drbg_state *drbg,
 	while (len < buflen) {
 		unsigned int outlen = 0;
 		/* 10.1.2.5 step 4.1 */
-		ret = drbg_kcapi_hash(drbg, drbg->C, drbg->V, &datalist);
+		ret = drbg_kcapi_hash(drbg, drbg->V, &datalist);
 		if (ret)
 			return ret;
 		outlen = (drbg_blocklen(drbg) < (buflen - len)) ?
@@ -796,7 +801,7 @@ static int drbg_hash_df(struct drbg_state *drbg,
 	while (len < outlen) {
 		short blocklen = 0;
 		/* 10.4.1 step 4.1 */
-		ret = drbg_kcapi_hash(drbg, NULL, tmp, entropylist);
+		ret = drbg_kcapi_hash(drbg, tmp, entropylist);
 		if (ret)
 			goto out;
 		/* 10.4.1 step 4.2 */
@@ -874,7 +879,7 @@ static int drbg_hash_process_addtl(struct drbg_state *drbg,
 	list_add_tail(&data1.list, &datalist);
 	list_add_tail(&data2.list, &datalist);
 	list_splice_tail(addtl, &datalist);
-	ret = drbg_kcapi_hash(drbg, NULL, drbg->scratchpad, &datalist);
+	ret = drbg_kcapi_hash(drbg, drbg->scratchpad, &datalist);
 	if (ret)
 		goto out;
 
@@ -907,7 +912,7 @@ static int drbg_hash_hashgen(struct drbg_state *drbg,
 	while (len < buflen) {
 		unsigned int outlen = 0;
 		/* 10.1.1.4 step hashgen 4.1 */
-		ret = drbg_kcapi_hash(drbg, NULL, dst, &datalist);
+		ret = drbg_kcapi_hash(drbg, dst, &datalist);
 		if (ret) {
 			len = ret;
 			goto out;
@@ -956,7 +961,7 @@ static int drbg_hash_generate(struct drbg_state *drbg,
 	list_add_tail(&data1.list, &datalist);
 	drbg_string_fill(&data2, drbg->V, drbg_statelen(drbg));
 	list_add_tail(&data2.list, &datalist);
-	ret = drbg_kcapi_hash(drbg, NULL, drbg->scratchpad, &datalist);
+	ret = drbg_kcapi_hash(drbg, drbg->scratchpad, &datalist);
 	if (ret) {
 		len = ret;
 		goto out;
@@ -1600,14 +1605,20 @@ static int drbg_fini_hash_kernel(struct drbg_state *drbg)
 	return 0;
 }
 
-static int drbg_kcapi_hash(struct drbg_state *drbg, const unsigned char *key,
-			   unsigned char *outval, const struct list_head *in)
+static void drbg_kcapi_hmacsetkey(struct drbg_state *drbg,
+				  const unsigned char *key)
+{
+	struct sdesc *sdesc = (struct sdesc *)drbg->priv_data;
+
+	crypto_shash_setkey(sdesc->shash.tfm, key, drbg_statelen(drbg));
+}
+
+static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
+			   const struct list_head *in)
 {
 	struct sdesc *sdesc = (struct sdesc *)drbg->priv_data;
 	struct drbg_string *input = NULL;
 
-	if (key)
-		crypto_shash_setkey(sdesc->shash.tfm, key, drbg_statelen(drbg));
 	crypto_shash_init(&sdesc->shash);
 	list_for_each_entry(input, in, list)
 		crypto_shash_update(&sdesc->shash, input->buf, input->len);
-- 
2.5.0

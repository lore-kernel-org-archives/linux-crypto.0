From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 2/2] crypto: drbg: remove superflowous memsets
Date: Sun, 01 Mar 2015 20:40:17 +0100
Message-ID: <1676054.DkmtgsCnh5@tachyon.chronox.de>
References: <50904620.OAA2OAojed@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36245 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbbCATkd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Mar 2015 14:40:33 -0500
In-Reply-To: <50904620.OAA2OAojed@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The DRBG code contains memset(0) calls to initialize a varaible
that are not necessary as the variable is always overwritten by
the processing.

This patch increases the CTR and Hash DRBGs by about 5%.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index c14274a..56c1d7e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -308,9 +308,6 @@ static int drbg_ctr_bcc(struct drbg_state *drbg,
 
 	drbg_string_fill(&data, out, drbg_blocklen(drbg));
 
-	/* 10.4.3 step 1 */
-	memset(out, 0, drbg_blocklen(drbg));
-
 	/* 10.4.3 step 2 / 4 */
 	list_for_each_entry(curr, in, list) {
 		const unsigned char *pos = curr->buf;
@@ -406,7 +403,6 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 
 	memset(pad, 0, drbg_blocklen(drbg));
 	memset(iv, 0, drbg_blocklen(drbg));
-	memset(temp, 0, drbg_statelen(drbg));
 
 	/* 10.4.2 step 1 is implicit as we work byte-wise */
 
@@ -523,7 +519,6 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 	unsigned int len = 0;
 	struct drbg_string cipherin;
 
-	memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
 	if (3 > reseed)
 		memset(df_data, 0, drbg_statelen(drbg));
 
@@ -585,8 +580,6 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 	int ret = 0;
 	struct drbg_string data;
 
-	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
-
 	/* 10.2.1.5.2 step 2 */
 	if (addtl && !list_empty(addtl)) {
 		ret = drbg_ctr_update(drbg, addtl, 2);
@@ -761,7 +754,6 @@ static struct drbg_state_ops drbg_hmac_ops = {
 	.generate	= drbg_hmac_generate,
 	.crypto_init	= drbg_init_hash_kernel,
 	.crypto_fini	= drbg_fini_hash_kernel,
-
 };
 #endif /* CONFIG_CRYPTO_DRBG_HMAC */
 
@@ -838,8 +830,6 @@ static int drbg_hash_df(struct drbg_state *drbg,
 	unsigned char *tmp = drbg->scratchpad + drbg_statelen(drbg);
 	struct drbg_string data;
 
-	memset(tmp, 0, drbg_blocklen(drbg));
-
 	/* 10.4.1 step 3 */
 	input[0] = 1;
 	drbg_cpu_to_be32((outlen * 8), &input[1]);
@@ -879,7 +869,6 @@ static int drbg_hash_update(struct drbg_state *drbg, struct list_head *seed,
 	unsigned char *V = drbg->scratchpad;
 	unsigned char prefix = DRBG_PREFIX1;
 
-	memset(drbg->scratchpad, 0, drbg_statelen(drbg));
 	if (!seed)
 		return -EINVAL;
 
@@ -921,9 +910,6 @@ static int drbg_hash_process_addtl(struct drbg_state *drbg,
 	LIST_HEAD(datalist);
 	unsigned char prefix = DRBG_PREFIX2;
 
-	/* this is value w as per documentation */
-	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
-
 	/* 10.1.1.4 step 2 */
 	if (!addtl || list_empty(addtl))
 		return 0;
@@ -959,9 +945,6 @@ static int drbg_hash_hashgen(struct drbg_state *drbg,
 	struct drbg_string data;
 	LIST_HEAD(datalist);
 
-	memset(src, 0, drbg_statelen(drbg));
-	memset(dst, 0, drbg_blocklen(drbg));
-
 	/* 10.1.1.4 step hashgen 2 */
 	memcpy(src, drbg->V, drbg_statelen(drbg));
 
@@ -1018,7 +1001,6 @@ static int drbg_hash_generate(struct drbg_state *drbg,
 	len = drbg_hash_hashgen(drbg, buf, buflen);
 
 	/* this is the value H as documented in 10.1.1.4 */
-	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
 	/* 10.1.1.4 step 4 */
 	drbg_string_fill(&data1, &prefix, 1);
 	list_add_tail(&data1.list, &datalist);
-- 
2.1.0

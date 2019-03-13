Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85EDC10F03
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA8E21874
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552454139;
	bh=edsI4P2A+j5OH1u930iSsYk0nQmkkbGDtx8/n5Q4xfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rogi+qxRAFG0XBYgxoXk0lnB7xWWZb9QvQk783zlpPEGqDOCCT1SjqE9eT52Ba0n8
	 gEr6oyH79pecSSQUy0erYbLUEzNiQwqloS8HY9To2SY/6Lo35ZSi+YZV2pHMSvhMQH
	 nHXUd8pKexnlsU8T1SitFknsY66GziXSYinAI/go=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfCMFPj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbfCMFPi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 01:15:38 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EF82218A2;
        Wed, 13 Mar 2019 05:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552454136;
        bh=edsI4P2A+j5OH1u930iSsYk0nQmkkbGDtx8/n5Q4xfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkCT0WHg3SA1+iMLbKUH4A4YzaKXCydMwLbJSkOvSO4UXIhBMHcmmCrFa+PEWmP7X
         S4UYKxHIScvCDxwrr3vdkjuK4/vdgmd5WJzD0JiOz8JZHzk3mNOtWYXIJuR0MNiU3I
         VQEvxLyLlNqtHYHzwTB0CcPYgtjxx/L8MCB7GJLM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: [PATCH 8/8] crypto: testmgr - test the !may_use_simd() fallback code
Date:   Tue, 12 Mar 2019 22:12:52 -0700
Message-Id: <20190313051252.2917-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313051252.2917-1-ebiggers@kernel.org>
References: <20190313051252.2917-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

All crypto API algorithms are supposed to support the case where they
are called in a context where SIMD instructions are unusable, e.g. IRQ
context on some architectures.  However, this isn't tested for by the
self-tests, causing bugs to go undetected.

Now that all algorithms have been converted to use crypto_simd_usable(),
update the self-tests to test the no-SIMD case.  First, a bool
testvec_config::nosimd is added.  When set, the crypto operation is
executed with preemption disabled and with crypto_simd_usable() mocked
out to return false on the current CPU.

A bool test_sg_division::nosimd is also added.  For hash algorithms it's
honored by the corresponding ->update().  By setting just a subset of
these bools, the case where some ->update()s are done in SIMD context
and some are done in no-SIMD context is also tested.

These bools are then randomly set by generate_random_testvec_config().

For now, all no-SIMD testing is limited to the extra crypto self-tests,
because it might be a bit too invasive for the regular self-tests.
But this could be changed later.

This has already found bugs in the arm64 AES-GCM and ChaCha algorithms.
This would have found some past bugs as well.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 116 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 92 insertions(+), 24 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 52417dde811f..2c2ddebb48d3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -234,12 +234,14 @@ enum finalization_type {
  *				  @offset
  * @flush_type: for hashes, whether an update() should be done now vs.
  *		continuing to accumulate data
+ * @nosimd: if doing the pending update(), do it with SIMD disabled?
  */
 struct test_sg_division {
 	unsigned int proportion_of_total;
 	unsigned int offset;
 	bool offset_relative_to_alignmask;
 	enum flush_type flush_type;
+	bool nosimd;
 };
 
 /**
@@ -259,6 +261,7 @@ struct test_sg_division {
  * @iv_offset_relative_to_alignmask: if true, add the algorithm's alignmask to
  *				     the @iv_offset
  * @finalization_type: what finalization function to use for hashes
+ * @nosimd: execute with SIMD disabled?  Requires !CRYPTO_TFM_REQ_MAY_SLEEP.
  */
 struct testvec_config {
 	const char *name;
@@ -269,6 +272,7 @@ struct testvec_config {
 	unsigned int iv_offset;
 	bool iv_offset_relative_to_alignmask;
 	enum finalization_type finalization_type;
+	bool nosimd;
 };
 
 #define TESTVEC_CONFIG_NAMELEN	192
@@ -420,8 +424,11 @@ static unsigned int count_test_sg_divisions(const struct test_sg_division *divs)
 	return ndivs;
 }
 
+#define SGDIVS_HAVE_FLUSHES	BIT(0)
+#define SGDIVS_HAVE_NOSIMD	BIT(1)
+
 static bool valid_sg_divisions(const struct test_sg_division *divs,
-			       unsigned int count, bool *any_flushes_ret)
+			       unsigned int count, int *flags_ret)
 {
 	unsigned int total = 0;
 	unsigned int i;
@@ -432,7 +439,9 @@ static bool valid_sg_divisions(const struct test_sg_division *divs,
 			return false;
 		total += divs[i].proportion_of_total;
 		if (divs[i].flush_type != FLUSH_TYPE_NONE)
-			*any_flushes_ret = true;
+			*flags_ret |= SGDIVS_HAVE_FLUSHES;
+		if (divs[i].nosimd)
+			*flags_ret |= SGDIVS_HAVE_NOSIMD;
 	}
 	return total == TEST_SG_TOTAL &&
 		memchr_inv(&divs[i], 0, (count - i) * sizeof(divs[0])) == NULL;
@@ -445,19 +454,18 @@ static bool valid_sg_divisions(const struct test_sg_division *divs,
  */
 static bool valid_testvec_config(const struct testvec_config *cfg)
 {
-	bool any_flushes = false;
+	int flags = 0;
 
 	if (cfg->name == NULL)
 		return false;
 
 	if (!valid_sg_divisions(cfg->src_divs, ARRAY_SIZE(cfg->src_divs),
-				&any_flushes))
+				&flags))
 		return false;
 
 	if (cfg->dst_divs[0].proportion_of_total) {
 		if (!valid_sg_divisions(cfg->dst_divs,
-					ARRAY_SIZE(cfg->dst_divs),
-					&any_flushes))
+					ARRAY_SIZE(cfg->dst_divs), &flags))
 			return false;
 	} else {
 		if (memchr_inv(cfg->dst_divs, 0, sizeof(cfg->dst_divs)))
@@ -470,7 +478,12 @@ static bool valid_testvec_config(const struct testvec_config *cfg)
 	    MAX_ALGAPI_ALIGNMASK + 1)
 		return false;
 
-	if (any_flushes && cfg->finalization_type == FINALIZATION_TYPE_DIGEST)
+	if ((flags & (SGDIVS_HAVE_FLUSHES | SGDIVS_HAVE_NOSIMD)) &&
+	    cfg->finalization_type == FINALIZATION_TYPE_DIGEST)
+		return false;
+
+	if ((cfg->nosimd || (flags & SGDIVS_HAVE_NOSIMD)) &&
+	    (cfg->req_flags & CRYPTO_TFM_REQ_MAY_SLEEP))
 		return false;
 
 	return true;
@@ -731,13 +744,14 @@ static int build_cipher_test_sglists(struct cipher_test_sglists *tsgls,
 #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
 static char *generate_random_sgl_divisions(struct test_sg_division *divs,
 					   size_t max_divs, char *p, char *end,
-					   bool gen_flushes)
+					   bool gen_flushes, u32 req_flags)
 {
 	struct test_sg_division *div = divs;
 	unsigned int remaining = TEST_SG_TOTAL;
 
 	do {
 		unsigned int this_len;
+		const char *flushtype_str;
 
 		if (div == &divs[max_divs - 1] || prandom_u32() % 2 == 0)
 			this_len = remaining;
@@ -766,11 +780,31 @@ static char *generate_random_sgl_divisions(struct test_sg_division *divs,
 			}
 		}
 
+		if (div->flush_type != FLUSH_TYPE_NONE &&
+		    !(req_flags & CRYPTO_TFM_REQ_MAY_SLEEP) &&
+		    prandom_u32() % 2 == 0)
+			div->nosimd = true;
+
+		switch (div->flush_type) {
+		case FLUSH_TYPE_FLUSH:
+			if (div->nosimd)
+				flushtype_str = "<flush,nosimd>";
+			else
+				flushtype_str = "<flush>";
+			break;
+		case FLUSH_TYPE_REIMPORT:
+			if (div->nosimd)
+				flushtype_str = "<reimport,nosimd>";
+			else
+				flushtype_str = "<reimport>";
+			break;
+		default:
+			flushtype_str = "";
+			break;
+		}
+
 		BUILD_BUG_ON(TEST_SG_TOTAL != 10000); /* for "%u.%u%%" */
-		p += scnprintf(p, end - p, "%s%u.%u%%@%s+%u%s",
-			       div->flush_type == FLUSH_TYPE_NONE ? "" :
-			       div->flush_type == FLUSH_TYPE_FLUSH ?
-			       "<flush> " : "<reimport> ",
+		p += scnprintf(p, end - p, "%s%u.%u%%@%s+%u%s", flushtype_str,
 			       this_len / 100, this_len % 100,
 			       div->offset_relative_to_alignmask ?
 					"alignmask" : "",
@@ -820,18 +854,26 @@ static void generate_random_testvec_config(struct testvec_config *cfg,
 		break;
 	}
 
+	if (!(cfg->req_flags & CRYPTO_TFM_REQ_MAY_SLEEP) &&
+	    prandom_u32() % 2 == 0) {
+		cfg->nosimd = true;
+		p += scnprintf(p, end - p, " nosimd");
+	}
+
 	p += scnprintf(p, end - p, " src_divs=[");
 	p = generate_random_sgl_divisions(cfg->src_divs,
 					  ARRAY_SIZE(cfg->src_divs), p, end,
 					  (cfg->finalization_type !=
-					   FINALIZATION_TYPE_DIGEST));
+					   FINALIZATION_TYPE_DIGEST),
+					  cfg->req_flags);
 	p += scnprintf(p, end - p, "]");
 
 	if (!cfg->inplace && prandom_u32() % 2 == 0) {
 		p += scnprintf(p, end - p, " dst_divs=[");
 		p = generate_random_sgl_divisions(cfg->dst_divs,
 						  ARRAY_SIZE(cfg->dst_divs),
-						  p, end, false);
+						  p, end, false,
+						  cfg->req_flags);
 		p += scnprintf(p, end - p, "]");
 	}
 
@@ -864,6 +906,23 @@ static void crypto_reenable_simd_for_test(void)
 }
 #endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 
+static int do_ahash_op(int (*op)(struct ahash_request *req),
+		       struct ahash_request *req,
+		       struct crypto_wait *wait, bool nosimd)
+{
+	int err;
+
+	if (nosimd)
+		crypto_disable_simd_for_test();
+
+	err = op(req);
+
+	if (nosimd)
+		crypto_reenable_simd_for_test();
+
+	return crypto_wait_req(err, wait);
+}
+
 static int check_nonfinal_hash_op(const char *op, int err,
 				  u8 *result, unsigned int digestsize,
 				  const char *driver, unsigned int vec_num,
@@ -938,7 +997,7 @@ static int test_hash_vec_cfg(const char *driver,
 		ahash_request_set_callback(req, req_flags, crypto_req_done,
 					   &wait);
 		ahash_request_set_crypt(req, tsgl->sgl, result, vec->psize);
-		err = crypto_wait_req(crypto_ahash_digest(req), &wait);
+		err = do_ahash_op(crypto_ahash_digest, req, &wait, cfg->nosimd);
 		if (err) {
 			pr_err("alg: hash: %s digest() failed with err %d on test vector %u, cfg=\"%s\"\n",
 			       driver, err, vec_num, cfg->name);
@@ -951,7 +1010,7 @@ static int test_hash_vec_cfg(const char *driver,
 
 	ahash_request_set_callback(req, req_flags, crypto_req_done, &wait);
 	ahash_request_set_crypt(req, NULL, result, 0);
-	err = crypto_wait_req(crypto_ahash_init(req), &wait);
+	err = do_ahash_op(crypto_ahash_init, req, &wait, cfg->nosimd);
 	err = check_nonfinal_hash_op("init", err, result, digestsize,
 				     driver, vec_num, cfg);
 	if (err)
@@ -967,7 +1026,8 @@ static int test_hash_vec_cfg(const char *driver,
 						   crypto_req_done, &wait);
 			ahash_request_set_crypt(req, pending_sgl, result,
 						pending_len);
-			err = crypto_wait_req(crypto_ahash_update(req), &wait);
+			err = do_ahash_op(crypto_ahash_update, req, &wait,
+					  divs[i]->nosimd);
 			err = check_nonfinal_hash_op("update", err,
 						     result, digestsize,
 						     driver, vec_num, cfg);
@@ -1010,12 +1070,12 @@ static int test_hash_vec_cfg(const char *driver,
 	ahash_request_set_crypt(req, pending_sgl, result, pending_len);
 	if (cfg->finalization_type == FINALIZATION_TYPE_FINAL) {
 		/* finish with update() and final() */
-		err = crypto_wait_req(crypto_ahash_update(req), &wait);
+		err = do_ahash_op(crypto_ahash_update, req, &wait, cfg->nosimd);
 		err = check_nonfinal_hash_op("update", err, result, digestsize,
 					     driver, vec_num, cfg);
 		if (err)
 			return err;
-		err = crypto_wait_req(crypto_ahash_final(req), &wait);
+		err = do_ahash_op(crypto_ahash_final, req, &wait, cfg->nosimd);
 		if (err) {
 			pr_err("alg: hash: %s final() failed with err %d on test vector %u, cfg=\"%s\"\n",
 			       driver, err, vec_num, cfg->name);
@@ -1023,7 +1083,7 @@ static int test_hash_vec_cfg(const char *driver,
 		}
 	} else {
 		/* finish with finup() */
-		err = crypto_wait_req(crypto_ahash_finup(req), &wait);
+		err = do_ahash_op(crypto_ahash_finup, req, &wait, cfg->nosimd);
 		if (err) {
 			pr_err("alg: hash: %s finup() failed with err %d on test vector %u, cfg=\"%s\"\n",
 			       driver, err, vec_num, cfg->name);
@@ -1259,8 +1319,12 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 	aead_request_set_crypt(req, tsgls->src.sgl_ptr, tsgls->dst.sgl_ptr,
 			       enc ? vec->plen : vec->clen, iv);
 	aead_request_set_ad(req, vec->alen);
-	err = crypto_wait_req(enc ? crypto_aead_encrypt(req) :
-			      crypto_aead_decrypt(req), &wait);
+	if (cfg->nosimd)
+		crypto_disable_simd_for_test();
+	err = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
+	if (cfg->nosimd)
+		crypto_reenable_simd_for_test();
+	err = crypto_wait_req(err, &wait);
 	if (err) {
 		if (err == -EBADMSG && vec->novrfy)
 			return 0;
@@ -1594,8 +1658,12 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	skcipher_request_set_callback(req, req_flags, crypto_req_done, &wait);
 	skcipher_request_set_crypt(req, tsgls->src.sgl_ptr, tsgls->dst.sgl_ptr,
 				   vec->len, iv);
-	err = crypto_wait_req(enc ? crypto_skcipher_encrypt(req) :
-			      crypto_skcipher_decrypt(req), &wait);
+	if (cfg->nosimd)
+		crypto_disable_simd_for_test();
+	err = enc ? crypto_skcipher_encrypt(req) : crypto_skcipher_decrypt(req);
+	if (cfg->nosimd)
+		crypto_reenable_simd_for_test();
+	err = crypto_wait_req(err, &wait);
 	if (err) {
 		pr_err("alg: skcipher: %s %s failed with err %d on test vector %u, cfg=\"%s\"\n",
 		       driver, op, err, vec_num, cfg->name);
-- 
2.21.0


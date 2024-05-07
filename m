Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3548010F1;
	Tue,  7 May 2024 00:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715041517; cv=none; b=mMLnfIgkZH/FJgpTI6BWeDjmRumxoKlwyPJJGRr/25cjQNS06I7P5rRrN6dCR3somN3uesILHIB6makKWTzIxiJ7zxLUumK9m0wUDFR+hZ3hvcUMO14f4wjU9sngVv90DHyadRsLK41Wl6g4MEtIgVksvZgyh2AOmDVe8Xjh+U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715041517; c=relaxed/simple;
	bh=mikLvuHnCELnv5V+E9UY0ATBXU4dTifNwORhN9O+1Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lH3gKqv9zbueFo/ERF0l5HMNhtgqyJPkCNUughuBUE1XJkJAU266zjueikELdT73wN2oPU/eyxVRJ3xPgbJn+Xpxyp7ncnz/Tjb3BeufgZHUfjLl9ok6Sgq6El4mRQlW+fZcjkebUjGcZ75Q0BLiDqD8aDE4sgyBqHpqCktg2vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WH+ZFubT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WH+ZFubT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29E0C3277B;
	Tue,  7 May 2024 00:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715041517;
	bh=mikLvuHnCELnv5V+E9UY0ATBXU4dTifNwORhN9O+1Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WH+ZFubTmp7nE6YRp8qaxl5HbG2ZSETA5Khki005EFpXYisbUU7abW9X37aFuS+1s
	 qENi/XCeyjmcVB9mvWNMnlGCYxORjPvAQKE83iyc58FAL453/HZfOb/lawj0QDGwXa
	 QxCHseufYsNAhcrYjcRySBc2NNpowoKZEFDLPvvz7NyiOX9d2nqQKIEw/D/4z2A81r
	 Gs4GaXhMXjWfxY7KyTAvP0BaeLnl/9BBL9OfZT10OALhD7CorAGDYnhbijPyoAzhGM
	 ZFaGvlq5mQKnMzsGmqzw1Ev7/BoYEhJDmumcOscbNj5RirdqnyT1owhW5yVN/zGuw7
	 jLxo65RD84yQA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 3/8] crypto: testmgr - add tests for finup_mb
Date: Mon,  6 May 2024 17:23:38 -0700
Message-ID: <20240507002343.239552-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240507002343.239552-1-ebiggers@kernel.org>
References: <20240507002343.239552-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Update the shash self-tests to test the new finup_mb method when
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 74 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 67 insertions(+), 7 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2c57ebcaf368..3253dc1501e4 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -227,10 +227,11 @@ enum flush_type {
 
 /* finalization function for hash algorithms */
 enum finalization_type {
 	FINALIZATION_TYPE_FINAL,	/* use final() */
 	FINALIZATION_TYPE_FINUP,	/* use finup() */
+	FINALIZATION_TYPE_FINUP_MB,	/* use finup_mb() */
 	FINALIZATION_TYPE_DIGEST,	/* use digest() */
 };
 
 /*
  * Whether the crypto operation will occur in-place, and if so whether the
@@ -290,10 +291,15 @@ struct test_sg_division {
  *				     the @iv_offset
  * @key_offset: misalignment of the key, where 0 is default alignment
  * @key_offset_relative_to_alignmask: if true, add the algorithm's alignmask to
  *				      the @key_offset
  * @finalization_type: what finalization function to use for hashes
+ * @multibuffer_index: random number used to generate the message index to use
+ *		       for finup_mb (if finup_mb is used).
+ * @multibuffer_count: random number used to generate the num_msgs parameter to
+ *		       finup_mb (if finup_mb is used).
+ *
  * @nosimd: execute with SIMD disabled?  Requires !CRYPTO_TFM_REQ_MAY_SLEEP.
  */
 struct testvec_config {
 	const char *name;
 	enum inplace_mode inplace_mode;
@@ -303,10 +309,12 @@ struct testvec_config {
 	unsigned int iv_offset;
 	unsigned int key_offset;
 	bool iv_offset_relative_to_alignmask;
 	bool key_offset_relative_to_alignmask;
 	enum finalization_type finalization_type;
+	unsigned int multibuffer_index;
+	unsigned int multibuffer_count;
 	bool nosimd;
 };
 
 #define TESTVEC_CONFIG_NAMELEN	192
 
@@ -1109,19 +1117,27 @@ static void generate_random_testvec_config(struct rnd_state *rng,
 	if (prandom_bool(rng)) {
 		cfg->req_flags |= CRYPTO_TFM_REQ_MAY_SLEEP;
 		p += scnprintf(p, end - p, " may_sleep");
 	}
 
-	switch (prandom_u32_below(rng, 4)) {
+	switch (prandom_u32_below(rng, 8)) {
 	case 0:
+	case 1:
 		cfg->finalization_type = FINALIZATION_TYPE_FINAL;
 		p += scnprintf(p, end - p, " use_final");
 		break;
-	case 1:
+	case 2:
 		cfg->finalization_type = FINALIZATION_TYPE_FINUP;
 		p += scnprintf(p, end - p, " use_finup");
 		break;
+	case 3:
+	case 4:
+		cfg->finalization_type = FINALIZATION_TYPE_FINUP_MB;
+		cfg->multibuffer_index = prandom_u32_state(rng);
+		cfg->multibuffer_count = prandom_u32_state(rng);
+		p += scnprintf(p, end - p, " use_finup_mb");
+		break;
 	default:
 		cfg->finalization_type = FINALIZATION_TYPE_DIGEST;
 		p += scnprintf(p, end - p, " use_digest");
 		break;
 	}
@@ -1270,10 +1286,37 @@ static inline int check_shash_op(const char *op, int err,
 		pr_err("alg: shash: %s %s() failed with err %d on test vector %s, cfg=\"%s\"\n",
 		       driver, op, err, vec_name, cfg->name);
 	return err;
 }
 
+static int do_finup_mb(struct shash_desc *desc,
+		       const u8 *data, unsigned int len, u8 *result,
+		       const struct testvec_config *cfg,
+		       const struct test_sglist *tsgl)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	const u8 *unused_data = tsgl->bufs[XBUFSIZE - 1];
+	u8 unused_result[HASH_MAX_DIGESTSIZE];
+	const u8 *datas[HASH_MAX_MB_MSGS];
+	u8 *outs[HASH_MAX_MB_MSGS];
+	unsigned int num_msgs;
+	unsigned int msg_idx;
+	unsigned int i;
+
+	num_msgs = 1 + (cfg->multibuffer_count % crypto_shash_mb_max_msgs(tfm));
+	if (WARN_ON_ONCE(num_msgs > HASH_MAX_MB_MSGS))
+		return -EINVAL;
+	msg_idx = cfg->multibuffer_index % num_msgs;
+	for (i = 0; i < num_msgs; i++) {
+		datas[i] = unused_data;
+		outs[i] = unused_result;
+	}
+	datas[msg_idx] = data;
+	outs[msg_idx] = result;
+	return crypto_shash_finup_mb(desc, datas, len, outs, num_msgs);
+}
+
 /* Test one hash test vector in one configuration, using the shash API */
 static int test_shash_vec_cfg(const struct hash_testvec *vec,
 			      const char *vec_name,
 			      const struct testvec_config *cfg,
 			      struct shash_desc *desc,
@@ -1346,11 +1389,14 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
 			return -EINVAL;
 		}
 		goto result_ready;
 	}
 
-	/* Using init(), zero or more update(), then final() or finup() */
+	/*
+	 * Using init(), zero or more update(), then either final(), finup(), or
+	 * finup_mb().
+	 */
 
 	if (cfg->nosimd)
 		crypto_disable_simd_for_test();
 	err = crypto_shash_init(desc);
 	if (cfg->nosimd)
@@ -1358,28 +1404,42 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
 	err = check_shash_op("init", err, driver, vec_name, cfg);
 	if (err)
 		return err;
 
 	for (i = 0; i < tsgl->nents; i++) {
+		const u8 *data = sg_virt(&tsgl->sgl[i]);
+		unsigned int len = tsgl->sgl[i].length;
+
 		if (i + 1 == tsgl->nents &&
 		    cfg->finalization_type == FINALIZATION_TYPE_FINUP) {
 			if (divs[i]->nosimd)
 				crypto_disable_simd_for_test();
-			err = crypto_shash_finup(desc, sg_virt(&tsgl->sgl[i]),
-						 tsgl->sgl[i].length, result);
+			err = crypto_shash_finup(desc, data, len, result);
 			if (divs[i]->nosimd)
 				crypto_reenable_simd_for_test();
 			err = check_shash_op("finup", err, driver, vec_name,
 					     cfg);
 			if (err)
 				return err;
 			goto result_ready;
 		}
+		if (i + 1 == tsgl->nents &&
+		    cfg->finalization_type == FINALIZATION_TYPE_FINUP_MB) {
+			if (divs[i]->nosimd)
+				crypto_disable_simd_for_test();
+			err = do_finup_mb(desc, data, len, result, cfg, tsgl);
+			if (divs[i]->nosimd)
+				crypto_reenable_simd_for_test();
+			err = check_shash_op("finup_mb", err, driver, vec_name,
+					     cfg);
+			if (err)
+				return err;
+			goto result_ready;
+		}
 		if (divs[i]->nosimd)
 			crypto_disable_simd_for_test();
-		err = crypto_shash_update(desc, sg_virt(&tsgl->sgl[i]),
-					  tsgl->sgl[i].length);
+		err = crypto_shash_update(desc, data, len);
 		if (divs[i]->nosimd)
 			crypto_reenable_simd_for_test();
 		err = check_shash_op("update", err, driver, vec_name, cfg);
 		if (err)
 			return err;
-- 
2.45.0


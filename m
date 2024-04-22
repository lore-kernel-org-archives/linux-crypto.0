Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC1A1BDC4;
	Mon, 22 Apr 2024 20:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713818163; cv=none; b=AZV8dWpj0k4eTq0St9nNVSwGQJn/rPaEAEWZj0mn+0L3bluSTDI2sr6RyW/PwBbrOnQMgxkEIUVEJHVIZGf5FC0vkizaGPv2vcQ1Pq/D03k3Yg0dbT5X2L2X+BtvryI30GO/gxRGZAdryIEYXvWsKg8/WkVyG2J3hvOCv8FWNcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713818163; c=relaxed/simple;
	bh=g2lxiYMhd7JfTooN9yvW8o7SK6LFd1hw8m3EZ1YtqW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sxdifbik1MThsDQCBPf3adhkEorQje+aVYCSYGhqUzJhaqT6OYRXdk0pvyXyI31skN0b97deCkIIKmF4MSCQWiKSzAVFiIfpCk9rUC4Y0YokuxUku3lb8WnAMKTe0pvtPH5x6nkB327XIThmcUSg72TtAriK4Kq/lwh0xWHQdTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=guEFiQ7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="guEFiQ7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EB7C4AF08;
	Mon, 22 Apr 2024 20:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713818162;
	bh=g2lxiYMhd7JfTooN9yvW8o7SK6LFd1hw8m3EZ1YtqW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guEFiQ7agdb4PW66xa0AifMHOKe0fsNK9s0Au1C096IMK8Z68EDRGPQJ1MaOrs8pN
	 oBRaxxP6C7oPWC7GRH3V12xiAKS24uN6vO8sh8RkZA4GhzeaHKDqWB9z1Rfng5eahi
	 5q0zNeWecb9r+ogAvQ6XqJLzPI6zs5FQ5BLOtoGjupsrnQMZmXEDPw5BmX8ZTQHFMK
	 Pa57FVRwSZv+y5V130P/rFHEZZZ9MMYEFNOgwbgEMWWSmBE7GQy797opqxh6AuhwRd
	 aw+XmZjmkNPNA5p618grKeuz+sjaiFSdxPTYuSWY0+vVvTvWlrJMXkUyC1Wdce2f7p
	 nXWpDY4HXHTOg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 3/8] crypto: testmgr - add tests for finup2x
Date: Mon, 22 Apr 2024 13:35:39 -0700
Message-ID: <20240422203544.195390-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422203544.195390-1-ebiggers@kernel.org>
References: <20240422203544.195390-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Update the shash self-tests to test the new finup2x method when
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 56 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 10 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2c57ebcaf368..b49fa88c95e1 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -227,10 +227,12 @@ enum flush_type {
 
 /* finalization function for hash algorithms */
 enum finalization_type {
 	FINALIZATION_TYPE_FINAL,	/* use final() */
 	FINALIZATION_TYPE_FINUP,	/* use finup() */
+	FINALIZATION_TYPE_FINUP2X_BUF1, /* use 1st buffer of finup2x() */
+	FINALIZATION_TYPE_FINUP2X_BUF2, /* use 2nd buffer of finup2x() */
 	FINALIZATION_TYPE_DIGEST,	/* use digest() */
 };
 
 /*
  * Whether the crypto operation will occur in-place, and if so whether the
@@ -1109,19 +1111,28 @@ static void generate_random_testvec_config(struct rnd_state *rng,
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
+		cfg->finalization_type = FINALIZATION_TYPE_FINUP2X_BUF1;
+		p += scnprintf(p, end - p, " use_finup2x_buf1");
+		break;
+	case 4:
+		cfg->finalization_type = FINALIZATION_TYPE_FINUP2X_BUF2;
+		p += scnprintf(p, end - p, " use_finup2x_buf2");
+		break;
 	default:
 		cfg->finalization_type = FINALIZATION_TYPE_DIGEST;
 		p += scnprintf(p, end - p, " use_digest");
 		break;
 	}
@@ -1346,11 +1357,14 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
 			return -EINVAL;
 		}
 		goto result_ready;
 	}
 
-	/* Using init(), zero or more update(), then final() or finup() */
+	/*
+	 * Using init(), zero or more update(), then either final(), finup(), or
+	 * finup2x().
+	 */
 
 	if (cfg->nosimd)
 		crypto_disable_simd_for_test();
 	err = crypto_shash_init(desc);
 	if (cfg->nosimd)
@@ -1358,28 +1372,50 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
 	err = check_shash_op("init", err, driver, vec_name, cfg);
 	if (err)
 		return err;
 
 	for (i = 0; i < tsgl->nents; i++) {
+		const u8 *data = sg_virt(&tsgl->sgl[i]);
+		unsigned int len = tsgl->sgl[i].length;
+
 		if (i + 1 == tsgl->nents &&
-		    cfg->finalization_type == FINALIZATION_TYPE_FINUP) {
+		    (cfg->finalization_type == FINALIZATION_TYPE_FINUP ||
+		     cfg->finalization_type == FINALIZATION_TYPE_FINUP2X_BUF1 ||
+		     cfg->finalization_type == FINALIZATION_TYPE_FINUP2X_BUF2)) {
+			const u8 *unused_data = tsgl->bufs[XBUFSIZE - 1];
+			u8 unused_result[HASH_MAX_DIGESTSIZE];
+			const char *op;
+
 			if (divs[i]->nosimd)
 				crypto_disable_simd_for_test();
-			err = crypto_shash_finup(desc, sg_virt(&tsgl->sgl[i]),
-						 tsgl->sgl[i].length, result);
+			if (cfg->finalization_type == FINALIZATION_TYPE_FINUP ||
+			    !crypto_shash_supports_finup2x(tfm)) {
+				err = crypto_shash_finup(desc, data, len,
+							 result);
+				op = "finup";
+			} else if (cfg->finalization_type ==
+				   FINALIZATION_TYPE_FINUP2X_BUF1) {
+				err = crypto_shash_finup2x(
+						desc, data, unused_data, len,
+						result, unused_result);
+				op = "finup2x_buf1";
+			} else { /* FINALIZATION_TYPE_FINUP2X_BUF2 */
+				err = crypto_shash_finup2x(
+						desc, unused_data, data, len,
+						unused_result, result);
+				op = "finup2x_buf2";
+			}
 			if (divs[i]->nosimd)
 				crypto_reenable_simd_for_test();
-			err = check_shash_op("finup", err, driver, vec_name,
-					     cfg);
+			err = check_shash_op(op, err, driver, vec_name, cfg);
 			if (err)
 				return err;
 			goto result_ready;
 		}
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
2.44.0


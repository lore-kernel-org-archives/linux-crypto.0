Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D1015746D;
	Mon, 15 Apr 2024 21:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713217130; cv=none; b=AKzSVrCYUu2lFeA8lEwI+QRzfbWv+X7jqrFRRVbCN6KsziScRIqwO+4Mth2eZAAjsRcNoetkfY38Ov7wJm7jcU9o0e9GjRwX6BBBzXIEsk8zEuM8P5Cq8RKzxWLdRcj6M5LS30QvrsXIvLQUiLFlDDfJy51ZU0AzBr8tG/KIWE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713217130; c=relaxed/simple;
	bh=hbXIxMNQiPU1jkfQ0yP6wwnFgvTFspy1GiHj+tI7hHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGNmNktGk5+TcRB7dgPVdBP2tBRo+lJUn+p8kkJgIcKQt/HKVG+YKiGLi7p3EMFWF1rf9OFbuI+zdtA+H0uwQUqKPaoaieXXiLUJWoQCS1YO6qi+JOot5mHVz79tXDMBMFdOrsTr9MAl70+QUIunddW0cpH4UX6+hRNBqL8JBLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFDstHMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFDstHMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F143C4AF09;
	Mon, 15 Apr 2024 21:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713217129;
	bh=hbXIxMNQiPU1jkfQ0yP6wwnFgvTFspy1GiHj+tI7hHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFDstHMuJ1BmztILQZsAjxXlnfjaMFlmrn0NOIO9NjMVQ2/JXiWtJevkGoB8ih+wQ
	 eImM0PMMoLGATxNL/h9le9TleeW9jfLDoRNYjCqlM9Ra96wG87/H73AtHJ4YP4gCjg
	 4MXMS+dUlFyj3eew2pKHKwiKeiHjegGfCnxsWZUs/BKhnkDU80p23NxWD35ZIBiqbP
	 SN/jWQ43nnVgRp3wls16EOmTfCmLir9FPFOyv3RRHlP6sQNaGYnd4+ul2Rgzt2x3/z
	 DuTMaJfdey7ObNZrIQNV4PJqc7wBgOtMewPp4+xlI+/GDbm395kXIdFCnRgxnHnzsf
	 f5pS0SeI12big==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [RFC PATCH 3/8] crypto: testmgr - add tests for finup2x
Date: Mon, 15 Apr 2024 14:37:14 -0700
Message-ID: <20240415213719.120673-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415213719.120673-1-ebiggers@kernel.org>
References: <20240415213719.120673-1-ebiggers@kernel.org>
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
 crypto/testmgr.c | 53 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2200d70e2aa9d..e6d42db6f344e 100644
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
@@ -1105,19 +1107,27 @@ static void generate_random_testvec_config(struct rnd_state *rng,
 	if (prandom_bool(rng)) {
 		cfg->req_flags |= CRYPTO_TFM_REQ_MAY_SLEEP;
 		p += scnprintf(p, end - p, " may_sleep");
 	}
 
-	switch (prandom_u32_below(rng, 4)) {
+	switch (prandom_u32_below(rng, 6)) {
 	case 0:
 		cfg->finalization_type = FINALIZATION_TYPE_FINAL;
 		p += scnprintf(p, end - p, " use_final");
 		break;
 	case 1:
 		cfg->finalization_type = FINALIZATION_TYPE_FINUP;
 		p += scnprintf(p, end - p, " use_finup");
 		break;
+	case 2:
+		cfg->finalization_type = FINALIZATION_TYPE_FINUP2X_BUF1;
+		p += scnprintf(p, end - p, " use_finup2x_buf1");
+		break;
+	case 3:
+		cfg->finalization_type = FINALIZATION_TYPE_FINUP2X_BUF2;
+		p += scnprintf(p, end - p, " use_finup2x_buf2");
+		break;
 	default:
 		cfg->finalization_type = FINALIZATION_TYPE_DIGEST;
 		p += scnprintf(p, end - p, " use_digest");
 		break;
 	}
@@ -1342,11 +1352,14 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
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
@@ -1354,28 +1367,50 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
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


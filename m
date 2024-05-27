Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D288D381A4
	for <linux-crypto@vger.kernel.org>; Mon, 27 May 2024 08:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716797145; cv=none; b=PpLRDA3gG4XtRgyZmlB7P9tButW1ObQiQhhIjFfQcflVedBByo6zDezjSs7VL666ar/h5x+UqgXpcBvLOCmGseL02Wx7vJ50yfR2IS6tLb8HSWbdEwj2q/1nFueB0DSXrbM69PIe3RCpDzkKh/fQQ9Ig/ly3jYy8W2QShnf4XA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716797145; c=relaxed/simple;
	bh=3DDBsxPmMiaT2ZVtbL2hPOPFaxiQLUWIfAZuVjSxrdM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=o1VD+YTsFaWzJin4SR/nVM8Mh4HIOX/cAW4ag228zt6qrO5n18BjZ1wUVE03zr/QQaiCeDgfx6JdI1ayrP/ZSvl98VTN4Ba4b8hcV2EVKZv0ZQVYBlGI1/1ZuknHmgmT0mSNH8XXmb8KtJZusrM7rzqfYqOO17BZp4GfPMQoc7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMwUCNrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMwUCNrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52973C2BBFC
	for <linux-crypto@vger.kernel.org>; Mon, 27 May 2024 08:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716797145;
	bh=3DDBsxPmMiaT2ZVtbL2hPOPFaxiQLUWIfAZuVjSxrdM=;
	h=From:To:Subject:Date:From;
	b=vMwUCNrZXSB0lbhSj3wleoZYvVsrbWe7wPcZ2Whvu+HX8I/sutwnTE0xwolqC/fDk
	 8ytj75ArzjSYnMhq1Bsg8GIJaMSysyT0jocZlnuqRKChxtZpFv/yBfgvjZqDSOjgX2
	 O3x8/Jv/9DYyva7NJTaHNJd+qbO0aAplvItItz2+pW8eTpdSQec8hbSxkRypSrJzun
	 HAYdXu1Ps1s4M5YXvDtCbFa+7AIubiPW9JlXP5dytY8fpMQaNoCoqx3sOjlMaw6COd
	 Cu56GSwJZmT47iaEWbnJLj3+IZ6FCPU2nEIyN7cdtePf/zWPGR38w4lVWXeIFQ/nMa
	 hfUxPhRe1RAyw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: testmgr - test setkey in no-SIMD context
Date: Mon, 27 May 2024 01:05:39 -0700
Message-ID: <20240527080539.163052-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since crypto_shash_setkey(), crypto_ahash_setkey(),
crypto_skcipher_setkey(), and crypto_aead_setkey() apparently need to
work in no-SIMD context on some architectures, make the self-tests cover
this scenario.  Specifically, sometimes do the setkey while under
crypto_disable_simd_for_test(), and do this independently from disabling
SIMD for the other parts of the crypto operation since there is no
guarantee that all parts happen in the same context.  (I.e., drivers
mustn't store the key in different formats for SIMD vs. no-SIMD.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 00f5a6cf341a5..1b30e3565e805 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -291,10 +291,14 @@ struct test_sg_division {
  * @key_offset: misalignment of the key, where 0 is default alignment
  * @key_offset_relative_to_alignmask: if true, add the algorithm's alignmask to
  *				      the @key_offset
  * @finalization_type: what finalization function to use for hashes
  * @nosimd: execute with SIMD disabled?  Requires !CRYPTO_TFM_REQ_MAY_SLEEP.
+ *	    This applies to the parts of the operation that aren't controlled
+ *	    individually by @nosimd_setkey or @src_divs[].nosimd.
+ * @nosimd_setkey: set the key (if applicable) with SIMD disabled?  Requires
+ *		   !CRYPTO_TFM_REQ_MAY_SLEEP.
  */
 struct testvec_config {
 	const char *name;
 	enum inplace_mode inplace_mode;
 	u32 req_flags;
@@ -304,10 +308,11 @@ struct testvec_config {
 	unsigned int key_offset;
 	bool iv_offset_relative_to_alignmask;
 	bool key_offset_relative_to_alignmask;
 	enum finalization_type finalization_type;
 	bool nosimd;
+	bool nosimd_setkey;
 };
 
 #define TESTVEC_CONFIG_NAMELEN	192
 
 /*
@@ -531,11 +536,12 @@ static bool valid_testvec_config(const struct testvec_config *cfg)
 
 	if ((flags & (SGDIVS_HAVE_FLUSHES | SGDIVS_HAVE_NOSIMD)) &&
 	    cfg->finalization_type == FINALIZATION_TYPE_DIGEST)
 		return false;
 
-	if ((cfg->nosimd || (flags & SGDIVS_HAVE_NOSIMD)) &&
+	if ((cfg->nosimd || cfg->nosimd_setkey ||
+	     (flags & SGDIVS_HAVE_NOSIMD)) &&
 	    (cfg->req_flags & CRYPTO_TFM_REQ_MAY_SLEEP))
 		return false;
 
 	return true;
 }
@@ -839,20 +845,27 @@ static int prepare_keybuf(const u8 *key, unsigned int ksize,
 	*keybuf_ret = keybuf;
 	*keyptr_ret = keyptr;
 	return 0;
 }
 
-/* Like setkey_f(tfm, key, ksize), but sometimes misalign the key */
+/*
+ * Like setkey_f(tfm, key, ksize), but sometimes misalign the key.
+ * In addition, run the setkey function in no-SIMD context if requested.
+ */
 #define do_setkey(setkey_f, tfm, key, ksize, cfg, alignmask)		\
 ({									\
 	const u8 *keybuf, *keyptr;					\
 	int err;							\
 									\
 	err = prepare_keybuf((key), (ksize), (cfg), (alignmask),	\
 			     &keybuf, &keyptr);				\
 	if (err == 0) {							\
+		if ((cfg)->nosimd_setkey)				\
+			crypto_disable_simd_for_test();			\
 		err = setkey_f((tfm), keyptr, (ksize));			\
+		if ((cfg)->nosimd_setkey)				\
+			crypto_reenable_simd_for_test();		\
 		kfree(keybuf);						\
 	}								\
 	err;								\
 })
 
@@ -1116,13 +1129,19 @@ static void generate_random_testvec_config(struct rnd_state *rng,
 		cfg->finalization_type = FINALIZATION_TYPE_DIGEST;
 		p += scnprintf(p, end - p, " use_digest");
 		break;
 	}
 
-	if (!(cfg->req_flags & CRYPTO_TFM_REQ_MAY_SLEEP) && prandom_bool(rng)) {
-		cfg->nosimd = true;
-		p += scnprintf(p, end - p, " nosimd");
+	if (!(cfg->req_flags & CRYPTO_TFM_REQ_MAY_SLEEP)) {
+		if (prandom_bool(rng)) {
+			cfg->nosimd = true;
+			p += scnprintf(p, end - p, " nosimd");
+		}
+		if (prandom_bool(rng)) {
+			cfg->nosimd_setkey = true;
+			p += scnprintf(p, end - p, " nosimd_setkey");
+		}
 	}
 
 	p += scnprintf(p, end - p, " src_divs=[");
 	p = generate_random_sgl_divisions(rng, cfg->src_divs,
 					  ARRAY_SIZE(cfg->src_divs), p, end,

base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.45.1


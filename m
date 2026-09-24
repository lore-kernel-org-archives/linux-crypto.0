Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A8E43C7C1;
	Thu, 24 Sep 2026 07:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236771; cv=none; b=IkpjvD6kbBhl7XW3qMvgXxzwwFLNQreCBDGUHf6AKFLjV/BAUsknBzWudSE6PUUpDc4O07t5FNTDUSFXrOzD4qL7zYRSAIg00VFTmB3jWFIMDUw1xI/7bVoYvsk1g0ovtaScRaVQPb0mYRu8At6RvptvILlkcmDSnGKIEN+B22k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236771; c=relaxed/simple;
	bh=VWw8V4pGr0owLDf3UcPhPH2MT6Zo5PEddJ75ArtMtcs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sVHrnM+/hIjwp94WMdY5IVo1tIaHQ1gdW60JGHtvvxJTjK+kzvITiKOgcNBMR7HU3emQ58wtpFHuiAMCztX4UNsD9RFnTLbE/pUpTgmXQkALp1saH/gX5+rNP/4LKR7sqd72hbNvgtAB76LtMfOA8OkUkO87DeyXaWnfQhOSKHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=WTus7FZ8; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="WTus7FZ8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790236768; x=1821772768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YgwTr/ayWgmnL9MGFOXJHjDYbA9tdAiOKfUQa3KUotM=;
  b=WTus7FZ87xD7+ly31Nnsgx0KYLQ1UXiylyahToQ20JKNKZtG1UbYwpEQ
   3PrmHUXh74F137LG35/TRfeRoijVhEtuw0cZGZx6t8B3z9oQcMf7NBZGo
   4mSzflCyDsJmq0N7ASSczLyTTgxlM6SPEFej2hp6KwhzFUOlP7Qp/x2FJ
   FQMm0+9y5u+6HEuhP8fQrDjhF5LqRaz0quyVJrcXn3vgWv/sA8aTCowmH
   tnKP0I5IlDyGKCfyqOGDOy5MCTcYHx3zYxK+VCrKG9IOt6Up/djstTJz1
   En/OQOsWhyrdh52pQG2C2VxkaBhdJODB1qTPbDABJo4cQwlfanWzndRGi
   g==;
X-CSE-ConnectionGUID: Ixy4z4mfQYq9qvOJGla9oQ==
X-CSE-MsgGUID: dHMnEMJ4T0WnAt+x5dhfNw==
X-IronPort-AV: E=Sophos;i="6.27,120,1787011200"; 
   d="scan'208";a="29546286"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 07:59:26 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:14576]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.27:2525] with esmtp (Farcaster)
 id 226f5852-3a50-4cd9-b029-5a58ef5087eb; Thu, 24 Sep 2026 07:59:25 +0000 (UTC)
X-Farcaster-Flow-ID: 226f5852-3a50-4cd9-b029-5a58ef5087eb
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:59:25 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:59:23 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ebiggers@kernel.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<mpatocka@redhat.com>, <bmarzins@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 5/6] crypto: testmgr - test multi-unit dispatch
Date: Thu, 24 Sep 2026 07:58:45 +0000
Message-ID: <20260924075846.28203-6-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260924075846.28203-1-lravich@amazon.com>
References: <20260924075846.28203-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Cross-check multi-unit dispatch against an independent single-unit
reference for every self-tested sync skcipher with an eligible IV:
one batched request (unit_size set) over a deliberately fragmented
scatterlist must produce ciphertext byte-identical to N single-unit
requests with counter-walked IVs, then round-trip.

The reference increments the IV as a 64-bit little-endian counter in
the low 8 bytes -- independent of the API layer's implementation, so
the two agree only if the carry-and-wrap is right -- and each unit size
is additionally run with an IV seeded to force the counter to wrap back
to zero.  The caller's IV must come back unmodified.  Covers ivsize 16
(xts) and 32 (Adiantum).

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 crypto/testmgr.c | 272 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 272 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4d86efae65b2..225c6a9806cb 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3211,6 +3211,274 @@ static int test_skcipher(int enc, const struct cipher_test_suite *suite,
 	return 0;
 }
 
+/* Upper bound on the IVs the multi-unit split accepts (16: xts; 32: Adiantum). */
+#define TEST_MDU_MAX_IVSIZE	32
+
+/*
+ * Increment the IV as a 64-bit little-endian data-unit-number counter in the
+ * low 8 bytes (byte 0 the LSB), wrapping at 2^64 with no carry above -- the
+ * dm-crypt plain64/essiv convention.  Deliberately independent of
+ * skcipher_unit_iv_next()'s implementation, so the two only agree if the
+ * carry-and-wrap is right.
+ */
+static void test_mdu_iv_inc(u8 *iv)
+{
+	int i;
+
+	for (i = 0; i < 8; i++)
+		if (++iv[i])
+			break;
+}
+
+/*
+ * Seed @iv so the low 64-bit counter (bytes [0,8)) is all-ones but its
+ * least-significant byte: the 2nd increment wraps the counter back to zero,
+ * exercising the rollover.  Bytes outside the low 8 keep their value.
+ */
+static void test_mdu_iv_boundary(u8 *iv)
+{
+	unsigned int i;
+
+	for (i = 0; i < 8; i++)
+		iv[i] = 0xff;
+	iv[0] = 0xfe;
+}
+
+/* Encrypt one du_size block with a plain single-DU request (the reference). */
+static int test_mdu_ref_encrypt(struct crypto_skcipher *tfm, const u8 *in,
+				u8 *out, unsigned int du_size, const u8 *iv,
+				unsigned int ivsize)
+{
+	struct skcipher_request *req;
+	struct scatterlist sg_in;
+	DECLARE_CRYPTO_WAIT(wait);
+	u8 ivbuf[TEST_MDU_MAX_IVSIZE];
+	int err;
+
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+	memcpy(ivbuf, iv, ivsize);
+	memcpy(out, in, du_size);
+	sg_init_one(&sg_in, out, du_size);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, &sg_in, &sg_in, du_size, ivbuf);
+	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+	skcipher_request_free(req);
+	return err;
+}
+
+/*
+ * Build an SG over @buf with du_size-unaligned entries, so the splitter's
+ * per-DU views cross SG entries and exercise the scatter_walk cursor.
+ */
+static void test_mdu_sg_fragment(struct scatterlist *sg, unsigned int nents,
+				 u8 *buf, unsigned int total)
+{
+	unsigned int chunk = total / nents;
+	unsigned int off = 0, i;
+
+	sg_init_table(sg, nents);
+	for (i = 0; i < nents; i++) {
+		unsigned int len = (i == nents - 1) ? total - off : chunk;
+
+		sg_set_buf(&sg[i], buf + off, len);
+		off += len;
+	}
+}
+
+#define TEST_MDU_NR_UNITS	4
+#define TEST_MDU_NR_FRAGS	5
+/*
+ * Verify a batched (unit_size-set) request on @tfm is byte-equal to an
+ * independent N x single-unit reference on the same tfm with
+ * little-endian-walked IVs, over a fragmented SG, then round-trips.
+ * @iv_orig is the ivsize-byte starting IV (the caller varies it to exercise
+ * both a random IV and one seeded to cross a carry boundary).
+ */
+static int test_skcipher_multi_du_one(struct crypto_skcipher *tfm,
+				      unsigned int du_size,
+				      const u8 *iv_orig)
+{
+	const char *driver = crypto_skcipher_driver_name(tfm);
+	const unsigned int total = du_size * TEST_MDU_NR_UNITS;
+	const unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	const u32 flags = CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP;
+	struct skcipher_request *req = NULL;
+	struct scatterlist sg[TEST_MDU_NR_FRAGS], sg_out[TEST_MDU_NR_FRAGS];
+	DECLARE_CRYPTO_WAIT(wait);
+	u8 iv_work[TEST_MDU_MAX_IVSIZE], iv_ref[TEST_MDU_MAX_IVSIZE];
+	u8 *plain = NULL, *buf = NULL, *ref = NULL, *obuf = NULL;
+	unsigned int u;
+	int err;
+
+	plain = kmalloc(total, GFP_KERNEL);
+	buf = kmalloc(total, GFP_KERNEL);
+	ref = kmalloc(total, GFP_KERNEL);
+	obuf = kmalloc(total, GFP_KERNEL);
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!plain || !buf || !ref || !obuf || !req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	get_random_bytes(plain, total);
+
+	/* Reference: per-unit single requests, counter-walked IVs. */
+	memcpy(iv_ref, iv_orig, ivsize);
+	for (u = 0; u < TEST_MDU_NR_UNITS; u++) {
+		err = test_mdu_ref_encrypt(tfm, plain + u * du_size,
+					   ref + u * du_size, du_size, iv_ref,
+					   ivsize);
+		if (err) {
+			pr_err("alg: skcipher: %s multi-DU ref encrypt failed (du=%u): %d\n",
+			       driver, du_size, err);
+			goto out;
+		}
+		test_mdu_iv_inc(iv_ref);
+	}
+
+	/* Batched: one request over a fragmented SG. */
+	memcpy(buf, plain, total);
+	memcpy(iv_work, iv_orig, ivsize);
+	test_mdu_sg_fragment(sg, TEST_MDU_NR_FRAGS, buf, total);
+	skcipher_request_set_callback(req, flags, crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, sg, sg, total, iv_work);
+	skcipher_request_set_unit_size(req, du_size);
+	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+	if (err) {
+		pr_err("alg: skcipher: %s multi-DU encrypt failed (du=%u): %d\n",
+		       driver, du_size, err);
+		goto out;
+	}
+	if (memcmp(buf, ref, total) != 0) {
+		pr_err("alg: skcipher: %s multi-DU ciphertext differs from single-DU reference (du=%u)\n",
+		       driver, du_size);
+		err = -EBADMSG;
+		goto out;
+	}
+	/* req->iv must be unchanged after multi-DU dispatch. */
+	if (memcmp(iv_work, iv_orig, ivsize) != 0) {
+		pr_err("alg: skcipher: %s multi-DU encrypt mutated caller IV (du=%u)\n",
+		       driver, du_size);
+		err = -EBADMSG;
+		goto out;
+	}
+
+	/* Out-of-place: distinct dst SG, fragmented differently from src. */
+	memcpy(buf, plain, total);
+	memset(obuf, 0, total);
+	test_mdu_sg_fragment(sg, TEST_MDU_NR_FRAGS, buf, total);
+	test_mdu_sg_fragment(sg_out, TEST_MDU_NR_FRAGS - 2, obuf, total);
+	skcipher_request_set_callback(req, flags, crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, sg, sg_out, total, iv_work);
+	skcipher_request_set_unit_size(req, du_size);
+	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+	if (err) {
+		pr_err("alg: skcipher: %s multi-DU out-of-place encrypt failed (du=%u): %d\n",
+		       driver, du_size, err);
+		goto out;
+	}
+	if (memcmp(obuf, ref, total) != 0) {
+		pr_err("alg: skcipher: %s multi-DU out-of-place ciphertext differs (du=%u)\n",
+		       driver, du_size);
+		err = -EBADMSG;
+		goto out;
+	}
+
+	/* Round-trip the batched ciphertext back to plaintext. */
+	memcpy(buf, ref, total);
+	test_mdu_sg_fragment(sg, TEST_MDU_NR_FRAGS, buf, total);
+	skcipher_request_set_callback(req, flags, crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, sg, sg, total, iv_work);
+	skcipher_request_set_unit_size(req, du_size);
+	err = crypto_wait_req(crypto_skcipher_decrypt(req), &wait);
+	if (err) {
+		pr_err("alg: skcipher: %s multi-DU decrypt failed (du=%u): %d\n",
+		       driver, du_size, err);
+		goto out;
+	}
+	if (memcmp(buf, plain, total) != 0) {
+		pr_err("alg: skcipher: %s multi-DU round-trip mismatch (du=%u)\n",
+		       driver, du_size);
+		err = -EBADMSG;
+	}
+
+out:
+	skcipher_request_free(req);
+	kfree(obuf);
+	kfree(ref);
+	kfree(buf);
+	kfree(plain);
+	return err;
+}
+
+/*
+ * Cross-check multi-unit dispatch against a single-unit reference on @tfm
+ * over all unit sizes.  Returns 0 on success or skip; -EBADMSG on a real
+ * mismatch.
+ */
+static int test_skcipher_multi_du_sizes(struct crypto_skcipher *tfm)
+{
+	static const unsigned int du_sizes[] = { 512, 1024, 2048, 4096 };
+	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	u8 iv[TEST_MDU_MAX_IVSIZE];
+	unsigned int j;
+	int err = 0;
+
+	for (j = 0; j < ARRAY_SIZE(du_sizes); j++) {
+		/* A random starting IV. */
+		get_random_bytes(iv, ivsize);
+		err = test_skcipher_multi_du_one(tfm, du_sizes[j], iv);
+		if (err)
+			break;
+		/* And one seeded to carry across a 64-bit limb. */
+		get_random_bytes(iv, ivsize);
+		test_mdu_iv_boundary(iv);
+		err = test_skcipher_multi_du_one(tfm, du_sizes[j], iv);
+		if (err)
+			break;
+		cond_resched();
+	}
+	return err;
+}
+
+/*
+ * Cross-check multi-unit dispatch against a single-unit reference for every
+ * eligible ivsize (16: xts; 32: Adiantum).
+ */
+static int test_skcipher_multi_du(struct crypto_skcipher *tfm)
+{
+	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	unsigned int blocksize = crypto_skcipher_blocksize(tfm);
+	u8 keybuf[128];
+	unsigned int keylen;
+	int err;
+
+	if (noslowtests)
+		return 0;
+
+	/* Mirror the API-layer split's eligibility; skip what it rejects. */
+	if (!ivsize || ivsize % sizeof(__le64) || ivsize > TEST_MDU_MAX_IVSIZE)
+		return 0;
+	if (!blocksize || 512 % blocksize)
+		return 0;	/* unit sizes below are 512-multiples */
+	if (crypto_skcipher_alg(tfm)->co.base.cra_flags & CRYPTO_ALG_ASYNC)
+		return 0;	/* the transparent split is sync-only */
+
+	keylen = crypto_skcipher_min_keysize(tfm);
+	if (keylen > sizeof(keybuf))
+		return 0;	/* unusually large key; skip rather than overflow */
+	get_random_bytes(keybuf, keylen);
+	err = crypto_skcipher_setkey(tfm, keybuf, keylen);
+	if (err)
+		return 0;	/* weak/rejected key (e.g. XTS equal halves): skip */
+
+	return test_skcipher_multi_du_sizes(tfm);
+}
+
 static int alg_test_skcipher(const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
 {
@@ -3259,6 +3527,10 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 	if (err)
 		goto out;
 
+	err = test_skcipher_multi_du(tfm);
+	if (err)
+		goto out;
+
 	err = test_skcipher_vs_generic_impl(desc->generic_driver, req, tsgls);
 out:
 	free_cipher_test_sglists(tsgls);
-- 
2.47.3


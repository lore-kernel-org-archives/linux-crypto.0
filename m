Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BD2175A73;
	Tue, 30 Jun 2026 08:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782808494; cv=none; b=tGf4uv3d9aPwYiaoRvbTtee4zZJmarM9HXZaZjqayAv4a7KwexlLDvLYWzOdtc+ImI2qGRmo1iZmRUaKiYu/DKgWUilH+03xhsCKqgoNct4E/qMK9S17nMTfrEE9HL3oCyf+LqUEAmYJISqJr0CO+xL0Rq4/jbpxlV8KCegyPSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782808494; c=relaxed/simple;
	bh=7/IOagPsD5SbbSudMDei3USPXzrE+1u69h9mV5tqSkw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YJ+RfOm7JkeoWz1KzQi9UzjK938nUVJRIqvHvIL5jIb2Hg0mM6cVvceck47xBgNEP4AszSee66TY1kb+wm1erf3hyYQsZSynXsSnwBWE4LCyfnlwLf2W01TgiNQkoi7mp7wZzxlbvkdNWPC2po20W1+ELQ/qhdW/33c6jyR/C18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=sa11sHXM; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="sa11sHXM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1782808491; x=1814344491;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pOfKmycEvE5853rTYlDZwDOy4gkDDIDynAj/X9HCV3c=;
  b=sa11sHXMlcuJoyFeiN/KRfAnG+b64TNRMiIYrsOskVO/hjYK2COIdcAM
   ukdpc5xxmpj7/58iLa6AcbhLwAdbZQkm5CxRSaKRh0TLMRkoXu+M9iKNG
   snz+c7rHNiebAi8Hx0Qrmsf2AlI9NVcjRFbodNDnXdMTPHwwsEvIAreEm
   8K032j2259h9di/I4P51Hm5TGzLzZyeZtMxSZazERBtPyhPLIqBScYMVx
   ybznffPq52BqEKw1yvhtE6+pQDLYZCUOsUdIxELdBPC+tte6SSky2/i0V
   U26igOW1kQtmKsnyQA6Spq7EaZeu3wX57oRPawmnhgjXwwr/myivbv7Hs
   A==;
X-CSE-ConnectionGUID: zwEpHO3+RRO2dm46nxrYYA==
X-CSE-MsgGUID: xctEXT9yR42gcV1b3mdA6Q==
X-IronPort-AV: E=Sophos;i="6.24,233,1774310400"; 
   d="scan'208";a="22738041"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 08:34:46 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:16452]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.4.192:2525] with esmtp (Farcaster)
 id 44ed3a2e-5fe0-4b2b-b693-b552b908ebdb; Tue, 30 Jun 2026 08:34:46 +0000 (UTC)
X-Farcaster-Flow-ID: 44ed3a2e-5fe0-4b2b-b693-b552b908ebdb
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 08:34:46 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 08:34:44 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ebiggers@kernel.org>,
	<snitzer@kernel.org>, <mpatocka@redhat.com>, <axboe@kernel.dk>
Subject: [PATCH v5 3/5] crypto: testmgr - test dun() dispatch
Date: Tue, 30 Jun 2026 08:34:29 +0000
Message-ID: <20260630083431.2772-4-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630083431.2772-1-lravich@amazon.com>
References: <20260630083431.2772-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

For every ivsize-16 skcipher, wrap it in both a dun(<inner>,le) and a
dun(<inner>,be) instance and cross-check each batched output against an
independent N x single-DU reference run directly on the inner tfm (both
keyed with one random key, the reference counter walked in the matching
endianness), over a deliberately fragmented scatterlist whose entries do
not align to the data-unit size.  The two must produce byte-identical
ciphertext; the batched ciphertext is then round-tripped and the caller
IV checked unchanged.  Testing both endiannesses exercises the be path
independently of any in-tree consumer.  Algorithms with no dun wrapper
(ivsize != 16) are skipped; a genuine mismatch returns -EBADMSG.

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 crypto/testmgr.c | 289 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 289 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4d86efae65b2..cd9246f432de 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3211,6 +3211,291 @@ static int test_skcipher(int enc, const struct cipher_test_suite *suite,
 	return 0;
 }
 
+/* Upper bound on the IVs the dun() template accepts (16: xts; 32: Adiantum). */
+#define TEST_MDU_MAX_IVSIZE	32
+
+/*
+ * Increment an @ivsize-byte IV as a wide counter.  Byte-wise with carry --
+ * deliberately independent of crypto/dun.c's per-limb walk, so the two only
+ * agree if the carry is right.  LE: byte 0 least significant; BE: last byte.
+ */
+static void test_mdu_iv_inc(u8 *iv, unsigned int ivsize, bool big_endian)
+{
+	int i;
+
+	if (big_endian) {
+		for (i = ivsize - 1; i >= 0; i--)
+			if (++iv[i])
+				break;
+	} else {
+		for (i = 0; i < (int)ivsize; i++)
+			if (++iv[i])
+				break;
+	}
+}
+
+/*
+ * Seed @iv so the low 64-bit limb is all-ones but its least-significant byte:
+ * the 2nd increment wraps the limb and carries into the next.  LE limb is
+ * bytes [0,8); BE limb is the last 8 bytes.  Bytes outside keep their value.
+ */
+static void test_mdu_iv_boundary(u8 *iv, unsigned int ivsize, bool big_endian)
+{
+	unsigned int i;
+
+	if (big_endian) {
+		for (i = ivsize - 8; i < ivsize; i++)
+			iv[i] = 0xff;
+		iv[ivsize - 1] = 0xfe;
+	} else {
+		for (i = 0; i < 8; i++)
+			iv[i] = 0xff;
+		iv[0] = 0xfe;
+	}
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
+ * Verify batched dispatch on @mdu (a dun(<inner>,<endian>) tfm) is byte-equal
+ * to an independent N x single-DU reference on @inner with @big_endian-walked
+ * IVs, over a fragmented SG, then round-trips.  Both tfms must share a key.
+ * @iv_orig is the ivsize-byte starting IV (the caller varies it to exercise
+ * both a random IV and one seeded to cross a carry boundary).
+ */
+static int test_skcipher_multi_du_one(struct crypto_skcipher *mdu,
+				      struct crypto_skcipher *inner,
+				      unsigned int du_size, bool big_endian,
+				      const u8 *iv_orig)
+{
+	const char *driver = crypto_skcipher_driver_name(mdu);
+	const unsigned int total = du_size * TEST_MDU_NR_UNITS;
+	const unsigned int ivsize = crypto_skcipher_ivsize(mdu);
+	struct skcipher_request *req = NULL;
+	struct scatterlist sg[TEST_MDU_NR_FRAGS];
+	DECLARE_CRYPTO_WAIT(wait);
+	u8 iv_work[TEST_MDU_MAX_IVSIZE], iv_ref[TEST_MDU_MAX_IVSIZE];
+	u8 *plain = NULL, *buf = NULL, *ref = NULL;
+	unsigned int u;
+	int err;
+
+	plain = kmalloc(total, GFP_KERNEL);
+	buf = kmalloc(total, GFP_KERNEL);
+	ref = kmalloc(total, GFP_KERNEL);
+	req = skcipher_request_alloc(mdu, GFP_KERNEL);
+	if (!plain || !buf || !ref || !req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	get_random_bytes(plain, total);
+
+	/* Reference: per-DU single requests on the inner tfm, counter-walked IVs. */
+	memcpy(iv_ref, iv_orig, ivsize);
+	for (u = 0; u < TEST_MDU_NR_UNITS; u++) {
+		err = test_mdu_ref_encrypt(inner, plain + u * du_size,
+					   ref + u * du_size, du_size, iv_ref,
+					   ivsize);
+		if (err) {
+			pr_err("alg: skcipher: %s multi-DU ref encrypt failed (du=%u): %d\n",
+			       driver, du_size, err);
+			goto out;
+		}
+		test_mdu_iv_inc(iv_ref, ivsize, big_endian);
+	}
+
+	/* Batched: one request over a fragmented SG. */
+	memcpy(buf, plain, total);
+	memcpy(iv_work, iv_orig, ivsize);
+	test_mdu_sg_fragment(sg, TEST_MDU_NR_FRAGS, buf, total);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, sg, sg, total, iv_work);
+	skcipher_request_set_data_unit_size(req, du_size);
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
+	/* Round-trip the batched ciphertext back to plaintext. */
+	test_mdu_sg_fragment(sg, TEST_MDU_NR_FRAGS, buf, total);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, sg, sg, total, iv_work);
+	skcipher_request_set_data_unit_size(req, du_size);
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
+	kfree(ref);
+	kfree(buf);
+	kfree(plain);
+	return err;
+}
+
+/*
+ * Cross-check the dun(<inner>,@endian) wrapper against @tfm over all du sizes.
+ * Returns 0 on success or skip (no wrapper / rejected key); -EBADMSG on a real
+ * mismatch.
+ */
+static int test_skcipher_multi_du_endian(struct crypto_skcipher *tfm,
+					 const char *alg_name,
+					 const char *endian, bool big_endian,
+					 const u8 *keybuf, unsigned int keylen)
+{
+	static const unsigned int du_sizes[] = { 512, 1024, 2048, 4096 };
+	char mdu_name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_skcipher *mdu;
+	unsigned int ivsize;
+	u8 iv[TEST_MDU_MAX_IVSIZE];
+	unsigned int j;
+	int err;
+
+	if (snprintf(mdu_name, sizeof(mdu_name), "dun(%s,%s)", alg_name,
+		     endian) >= (int)sizeof(mdu_name))
+		return 0;
+
+	mdu = crypto_alloc_skcipher(mdu_name, 0, 0);
+	if (IS_ERR(mdu)) {
+		/* No dun wrapper (ivsize not a multiple of 8, or too wide): skip. */
+		if (PTR_ERR(mdu) == -ENOENT || PTR_ERR(mdu) == -EINVAL)
+			return 0;
+		return PTR_ERR(mdu);
+	}
+
+	ivsize = crypto_skcipher_ivsize(mdu);
+	if (ivsize > TEST_MDU_MAX_IVSIZE) {
+		err = 0;	/* wider than we have buffers for: skip */
+		goto out;
+	}
+
+	err = crypto_skcipher_setkey(mdu, keybuf, keylen);
+	if (err) {
+		err = 0;	/* weak/rejected key (e.g. XTS equal halves): skip */
+		goto out;
+	}
+
+	for (j = 0; j < ARRAY_SIZE(du_sizes); j++) {
+		/* A random starting IV. */
+		get_random_bytes(iv, ivsize);
+		err = test_skcipher_multi_du_one(mdu, tfm, du_sizes[j],
+						 big_endian, iv);
+		if (err)
+			break;
+		/* And one seeded to carry across a 64-bit limb / byte run. */
+		get_random_bytes(iv, ivsize);
+		test_mdu_iv_boundary(iv, ivsize, big_endian);
+		err = test_skcipher_multi_du_one(mdu, tfm, du_sizes[j],
+						 big_endian, iv);
+		if (err)
+			break;
+		cond_resched();
+	}
+out:
+	crypto_free_skcipher(mdu);
+	return err;
+}
+
+/*
+ * Cross-check dun() dispatch against a single-DU reference, in both le and be,
+ * for every ivsize the template accepts (16: xts; 32: Adiantum).
+ */
+static int test_skcipher_multi_du(struct crypto_skcipher *tfm)
+{
+	const char *alg_name = crypto_skcipher_alg(tfm)->base.cra_name;
+	u8 keybuf[128];
+	unsigned int keylen;
+	int err;
+
+	/* Key the inner tfm; each dun() wrapper is keyed identically below. */
+	keylen = crypto_skcipher_min_keysize(tfm);
+	if (keylen > sizeof(keybuf))
+		return 0;	/* unusually large key; skip rather than overflow */
+	get_random_bytes(keybuf, keylen);
+	err = crypto_skcipher_setkey(tfm, keybuf, keylen);
+	if (err)
+		return 0;	/* weak/rejected key (e.g. XTS equal halves): skip */
+
+	err = test_skcipher_multi_du_endian(tfm, alg_name, "le", false,
+					    keybuf, keylen);
+	if (err)
+		return err;
+	return test_skcipher_multi_du_endian(tfm, alg_name, "be", true,
+					     keybuf, keylen);
+}
+
 static int alg_test_skcipher(const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
 {
@@ -3259,6 +3544,10 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
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


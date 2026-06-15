Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720FB3E4C90;
	Mon, 15 Jun 2026 11:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781522117; cv=none; b=gO6x9AZUbDWDfrAT5EiZrCDpgROGQYrd0vCCVVq4sIHUuleoi9QpyEHEx1LI6MAHnPoTC+cwoyA+bNqwJ42uQNMuFqBbecPrp1CQXbm1FMtiWWsWiSk3dmuOG4UguWk1gcCvy4EaEvz3Ui21Xd846Re/P5Nvlt6MsSitjCaE7m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781522117; c=relaxed/simple;
	bh=uQiyN8t7p9nQW1IMu+mO8bn1XhFA4KngcqsORwXAro0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CrR59kBjOm4TcpH8uNBWgZnlYMduY/2EwPz0qWNqOMLG+9kGvZcW+3S/1NJPCfA3Ht/MmngVX8WSWD9OKaBXc4b9IAedoa76Cv4ETM4fgzDbUwirzjNdwSQ+KdiZwFI+5M872VLvFuOGdDIyWk/J0ooxsJWhDiz7AZokZ9NP8xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=DBt3ZZDn; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="DBt3ZZDn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1781522115; x=1813058115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NjpRuBDzwnF/oxt/9bz6BzPrWShPwF5Q2t06bXONSaU=;
  b=DBt3ZZDnveQ32c6fWZgQBspv2IwWRpjuoGeSyUza3OGhnQ/e0PWxrq0R
   ttGVkrSBVtPEvQw7N3UVXPOUq1EfwuyrSSalZu29inYLrNETL/FGkJrVK
   0AK4uVe1fM2r7sNNV48++mdsTKLsG5wG1K8zHIfYEj2UHmTLYRFIOyj68
   0UBVnSLv3y6a6+9D4vVsrEwDfBKntyBeDswaQDxjHbMsOKALQ3iQ80A8M
   Z+i5+Rmyr4vElZkGRZTGvFrrhUSgeCZC0T1sun+HXmOCDwm2qUu+XLXns
   DnNNEQCgqmmeuRlVVxdPFTm2t3XThKKvYLxftc9v6X4D2qHKepTy0valk
   Q==;
X-CSE-ConnectionGUID: i5ZV05s+TXyj2x7YIgBhog==
X-CSE-MsgGUID: vATTV8ktTNuqyc+zRv4n+Q==
X-IronPort-AV: E=Sophos;i="6.24,206,1774310400"; 
   d="scan'208";a="21752868"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:15:10 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:21120]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.13.145:2525] with esmtp (Farcaster)
 id db16f6ed-c9c7-4e4b-833d-fe9eb1a21f29; Mon, 15 Jun 2026 11:15:10 +0000 (UTC)
X-Farcaster-Flow-ID: db16f6ed-c9c7-4e4b-833d-fe9eb1a21f29
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 15 Jun 2026 11:15:10 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 15 Jun 2026 11:15:08 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, "Eric
 Biggers" <ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH v4 2/3] crypto: testmgr - test for multi-data-unit dispatch
Date: Mon, 15 Jun 2026 11:14:58 +0000
Message-ID: <20260615111459.9452-3-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260615111459.9452-1-lravich@amazon.com>
References: <20260615111459.9452-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add a test that runs on every skcipher with ivsize == 16.  It
encrypts random plaintext two ways and compares:

  1. one batched request with skcipher_request_set_data_unit_size()
     set, over a deliberately fragmented scatterlist whose entries do
     not align to the data-unit size (so per-DU views cross SG entries
     and exercise the scatter_walk cursor), and
  2. an independent reference of N single-DU requests with IVs walked
     as a 128-bit LE counter, matching the convention documented in
     skcipher_request_set_data_unit_size().

The two must produce byte-identical ciphertext; this pins the IV
convention rather than only checking encrypt/decrypt symmetry.  The
batched ciphertext is then round-tripped back to plaintext, and the
caller IV is checked unchanged.  Iterates over typical data unit
sizes (512, 1024, 2048, 4096).

Algorithms the validator rejects for multi-DU return -EOPNOTSUPP on
the first call and skip cleanly; a genuine mismatch returns -EBADMSG
so it cannot be confused with a skip.

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 crypto/testmgr.c | 192 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 192 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4d86efae65b2..5cbd0f4b070e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3211,6 +3211,194 @@ static int test_skcipher(int enc, const struct cipher_test_suite *suite,
 	return 0;
 }
 
+/* Increment a 16-byte IV as a little-endian 128-bit counter. */
+static void test_mdu_iv_inc(u8 iv[16])
+{
+	int i;
+
+	for (i = 0; i < 16; i++)
+		if (++iv[i])
+			break;
+}
+
+/*
+ * Encrypt one du_size block with a plain single-DU request; used to
+ * build an independent reference for the batched dispatch.
+ */
+static int test_mdu_ref_encrypt(struct crypto_skcipher *tfm, const u8 *in,
+				u8 *out, unsigned int du_size, const u8 iv[16])
+{
+	struct skcipher_request *req;
+	struct scatterlist sg_in, sg_out;
+	DECLARE_CRYPTO_WAIT(wait);
+	u8 ivbuf[16];
+	int err;
+
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+	memcpy(ivbuf, iv, 16);
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
+ * Build a deliberately fragmented SG over @buf: entries that do not
+ * align to du_size, so the splitter's per-DU views cross SG entries
+ * and exercise the scatter_walk cursor.
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
+/*
+ * Multi-DU test: verify the batched dispatch produces byte-identical
+ * ciphertext to an independent N x single-DU reference with per-DU IVs
+ * walked as a 128-bit LE counter (pins the IV convention, not just
+ * enc/dec symmetry), over a fragmented SG, then round-trips.  Real
+ * mismatches return -EBADMSG; ineligible algorithms skip via the
+ * validator's -EOPNOTSUPP.
+ */
+#define TEST_MDU_NR_UNITS	4
+#define TEST_MDU_NR_FRAGS	5
+static int test_skcipher_multi_du_one(struct crypto_skcipher *tfm,
+				      unsigned int du_size)
+{
+	const char *driver = crypto_skcipher_driver_name(tfm);
+	const unsigned int total = du_size * TEST_MDU_NR_UNITS;
+	struct skcipher_request *req = NULL;
+	struct scatterlist sg[TEST_MDU_NR_FRAGS];
+	DECLARE_CRYPTO_WAIT(wait);
+	u8 iv_orig[16], iv_work[16], iv_ref[16];
+	u8 *plain = NULL, *buf = NULL, *ref = NULL;
+	unsigned int u;
+	int err;
+
+	plain = kmalloc(total, GFP_KERNEL);
+	buf = kmalloc(total, GFP_KERNEL);
+	ref = kmalloc(total, GFP_KERNEL);
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!plain || !buf || !ref || !req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	get_random_bytes(plain, total);
+	get_random_bytes(iv_orig, sizeof(iv_orig));
+
+	/* Reference: per-DU single requests with LE128-walked IVs. */
+	memcpy(iv_ref, iv_orig, sizeof(iv_orig));
+	for (u = 0; u < TEST_MDU_NR_UNITS; u++) {
+		err = test_mdu_ref_encrypt(tfm, plain + u * du_size,
+					   ref + u * du_size, du_size, iv_ref);
+		/* First single-DU call reveals an ineligible algorithm. */
+		if (err == -EOPNOTSUPP && u == 0)
+			goto out;
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
+	memcpy(iv_work, iv_orig, sizeof(iv_orig));
+	test_mdu_sg_fragment(sg, TEST_MDU_NR_FRAGS, buf, total);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, sg, sg, total, iv_work);
+	skcipher_request_set_data_unit_size(req, du_size);
+	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+	if (err == -EOPNOTSUPP)
+		goto out;
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
+	if (memcmp(iv_work, iv_orig, sizeof(iv_orig)) != 0) {
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
+static int test_skcipher_multi_du(struct crypto_skcipher *tfm)
+{
+	static const unsigned int du_sizes[] = { 512, 1024, 2048, 4096 };
+	unsigned int j;
+	int err;
+
+	if (crypto_skcipher_ivsize(tfm) != 16)
+		return 0;
+
+	for (j = 0; j < ARRAY_SIZE(du_sizes); j++) {
+		err = test_skcipher_multi_du_one(tfm, du_sizes[j]);
+		/* Ineligible algorithms skip; real failures propagate. */
+		if (err == -EOPNOTSUPP)
+			return 0;
+		if (err)
+			return err;
+		cond_resched();
+	}
+	return 0;
+}
+
 static int alg_test_skcipher(const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
 {
@@ -3259,6 +3447,10 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
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


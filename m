Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652913644BC;
	Mon,  1 Jun 2026 08:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780304223; cv=none; b=DGPMVriPwj/ZF6n8xhhw5XNwWzUi3IeNXyIfFEsNcVbb3oqNwLMZHFQ32hCTrGs/Sl3eLwaOx1CmqLqbe9/WjKv5hJghjlXTHLYp0nNv48XagOlAGTGClaezQaJgUOy13MIwe95VDzGqG8L2rTRlZvP2KfvpiJo0XieUAPLDd4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780304223; c=relaxed/simple;
	bh=6jigbqFIVkHaSIPggd1rbggXPOMUnaRBGgM0QovpREc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WyliWsx4tP72QlDy7fCEAPWW4eTIbLgmVyNnKib0rXXH1VYvjdA5JueeAIAhRrtnYdc1Qt4EWA0VOqsnq8uQzTSXr6j3RqbWtPqK4oUk6SVIHE5gcTOQ4sbB/XEixC94OT+uykqouMEMMQ5ADyDRRObaF8CVpzjUiyCQzZ2aA/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=rUp9yawN; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="rUp9yawN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1780304222; x=1811840222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4mWB/J/i2cCgXu1keGyZ9CrkSLaEjSqWOjWRM5v/zg4=;
  b=rUp9yawN5eLkfZjn7thWLqpDI+8h3FUSuviwycU6UQLg7LeCnyTTMvAE
   f1bQCUm/OYFLZJbmvWpHROBXAdZYurkMG0s8IBiC9cQev3li5n4ZSeR1L
   grgAaJG3jx4CtD/jd/dmbovwlgiorN0lgQaS7tphnlho1AE8PEhnPjl5b
   Dhxue4mLbsL0mG+XnvGLwYRA9ioJ07k4NhgFfyFulA1d+lh+d9tWYhDsm
   qYvak0dpg8UFIfapT6aPj53nqq5QQCY5qqznb+Ea9v65x7/VTaIOSbKqi
   m5mDoUrr4STewAovQ+02mMbet5EHmJdo/nW5O7INuuCZlJ0qfYC5r0AFG
   A==;
X-CSE-ConnectionGUID: 5B6r7oO8QaupzivRgYho6g==
X-CSE-MsgGUID: HGuiVuAoTeOpF7kO2ul2BA==
X-IronPort-AV: E=Sophos;i="6.24,180,1774310400"; 
   d="scan'208";a="20642872"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 08:56:56 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:3283]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.51.252:2525] with esmtp (Farcaster)
 id e2924209-61ef-4084-a008-83e7cc262083; Mon, 1 Jun 2026 08:56:56 +0000 (UTC)
X-Farcaster-Flow-ID: e2924209-61ef-4084-a008-83e7cc262083
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 1 Jun 2026 08:56:56 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 1 Jun 2026 08:56:54 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, "Eric
 Biggers" <ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH v3 3/4] crypto: testmgr - exercise multi-data-unit path for skcipher
Date: Mon, 1 Jun 2026 08:56:43 +0000
Message-ID: <20260601085644.13026-4-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260601085644.13026-1-lravich@amazon.com>
References: <20260601085644.13026-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add a self-comparison test that runs whenever an skcipher algorithm
advertises CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT in cra_flags.  The test
encrypts the same random plaintext two ways:

  1. as one batched request with data_unit_size set, and
  2. as N back-to-back single-data-unit requests with IVs derived from
     the original IV by adding the data-unit index (treated as a
     128-bit little-endian counter, matching the convention documented
     in crypto_skcipher_set_data_unit_size()).

Both encrypts must produce byte-identical ciphertext, otherwise the
algorithm's multi-DU implementation is inconsistent with its single-DU
behaviour.  Iterates over a fixed set of typical data unit sizes
(512, 1024, 2048, 4096) which cover the dm-crypt sector-size range.

The test is gated on ivsize == 16 (XTS, the only multi-DU consumer in
the kernel today) and on the algorithm advertising the capability,
so it costs nothing for the existing fleet of skcipher drivers.

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 crypto/testmgr.c | 129 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4d86efae65b2..8ca92ee6b37c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3211,6 +3211,123 @@ static int test_skcipher(int enc, const struct cipher_test_suite *suite,
 	return 0;
 }
 
+/*
+ * For algorithms that advertise CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT,
+ * verify that one request batching N data units produces the same
+ * ciphertext as N back-to-back single-data-unit requests with IVs
+ * derived from the original IV by adding the data-unit index (treated
+ * as a 128-bit little-endian counter).
+ *
+ * This is a self-comparison: it does not depend on test-vector
+ * authoritativeness, only on the algorithm being internally consistent
+ * between its single-DU and multi-DU paths.
+ */
+#define TEST_MDU_NR_UNITS	4
+static int test_skcipher_multi_du(struct crypto_skcipher *tfm,
+				  unsigned int du_size)
+{
+	const char *driver = crypto_skcipher_driver_name(tfm);
+	const unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	const unsigned int total = du_size * TEST_MDU_NR_UNITS;
+	struct skcipher_request *req = NULL;
+	struct scatterlist sg_in, sg_out;
+	DECLARE_CRYPTO_WAIT(wait);
+	u8 iv_orig[16] = {0};
+	u8 iv_work[16];
+	u8 *plain = NULL, *batched = NULL, *unit = NULL;
+	unsigned int i;
+	int err;
+
+	if (ivsize != 16)
+		return 0;
+
+	plain = kmalloc(total, GFP_KERNEL);
+	batched = kmalloc(total, GFP_KERNEL);
+	unit = kmalloc(total, GFP_KERNEL);
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!plain || !batched || !unit || !req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	get_random_bytes(plain, total);
+	get_random_bytes(iv_orig, ivsize);
+
+	/* Pass 1: one batched encrypt with data_unit_size set. */
+	err = crypto_skcipher_set_data_unit_size(tfm, du_size);
+	if (err) {
+		pr_err("alg: skcipher: %s set_data_unit_size(%u) failed: %d\n",
+		       driver, du_size, err);
+		goto out;
+	}
+	memcpy(batched, plain, total);
+	memcpy(iv_work, iv_orig, ivsize);
+	sg_init_one(&sg_in, batched, total);
+	sg_out = sg_in;
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, &sg_in, &sg_out, total, iv_work);
+	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+	if (err) {
+		pr_err("alg: skcipher: %s multi-DU batched encrypt failed: %d\n",
+		       driver, err);
+		goto out_clear_du;
+	}
+
+	/* Pass 2: TEST_MDU_NR_UNITS single-DU encrypts with derived IVs. */
+	err = crypto_skcipher_set_data_unit_size(tfm, 0);
+	if (err)
+		goto out;
+	memcpy(unit, plain, total);
+	memcpy(iv_work, iv_orig, ivsize);
+	for (i = 0; i < TEST_MDU_NR_UNITS; i++) {
+		sg_init_one(&sg_in, unit + i * du_size, du_size);
+		sg_out = sg_in;
+		skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+					      CRYPTO_TFM_REQ_MAY_SLEEP,
+					      crypto_req_done, &wait);
+		skcipher_request_set_crypt(req, &sg_in, &sg_out, du_size,
+					   iv_work);
+		err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+		if (err) {
+			pr_err("alg: skcipher: %s single-DU[%u] encrypt failed: %d\n",
+			       driver, i, err);
+			goto out;
+		}
+		/* Increment iv_work as a 128-bit little-endian counter. */
+		{
+			__le64 lo_le, hi_le;
+			u64 lo;
+
+			memcpy(&lo_le, iv_work, 8);
+			memcpy(&hi_le, iv_work + 8, 8);
+			lo = le64_to_cpu(lo_le) + 1;
+			lo_le = cpu_to_le64(lo);
+			memcpy(iv_work, &lo_le, 8);
+			if (lo == 0) {
+				hi_le = cpu_to_le64(le64_to_cpu(hi_le) + 1);
+				memcpy(iv_work + 8, &hi_le, 8);
+			}
+		}
+	}
+
+	if (memcmp(batched, unit, total) != 0) {
+		pr_err("alg: skcipher: %s multi-DU mismatch (du=%u, n=%u)\n",
+		       driver, du_size, TEST_MDU_NR_UNITS);
+		err = -EINVAL;
+	}
+
+out_clear_du:
+	(void)crypto_skcipher_set_data_unit_size(tfm, 0);
+out:
+	skcipher_request_free(req);
+	kfree(unit);
+	kfree(batched);
+	kfree(plain);
+	return err;
+}
+
 static int alg_test_skcipher(const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
 {
@@ -3259,6 +3376,18 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 	if (err)
 		goto out;
 
+	if (crypto_skcipher_supports_multi_data_unit(tfm)) {
+		static const unsigned int du_sizes[] = { 512, 1024, 2048, 4096 };
+		unsigned int j;
+
+		for (j = 0; j < ARRAY_SIZE(du_sizes); j++) {
+			err = test_skcipher_multi_du(tfm, du_sizes[j]);
+			if (err)
+				goto out;
+			cond_resched();
+		}
+	}
+
 	err = test_skcipher_vs_generic_impl(desc->generic_driver, req, tsgls);
 out:
 	free_cipher_test_sglists(tsgls);
-- 
2.47.3


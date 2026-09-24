Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B0E413789;
	Thu, 24 Sep 2026 07:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236768; cv=none; b=K6e6zUwRIPb5RR/QPupTmF6V5iH00XMEKgqi4p8KRqA+BtU0WHmqIxp6Z1x6ComOWt4X6omFwpy7LdAcRu9cO6UM+Te7cmHtmImbxfWLqJXK6OP18Pwd8gM5XfhDFImGN2nRqrNKHQZHbyE2krrsydUjXkWHwM5SCQqrQov0sQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236768; c=relaxed/simple;
	bh=Ltn94xgSMghIzo/Jv3ryi2MCyLURItnDbmFwZTtvYPU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aq0uDqWMjLJTnUzpCkmkQUHc8vBWqqsuME7FbI/TGJI4YFrAkAaD7D0N/jGONWDUdb+CqswnNbHRQf20UNe7rajFgP7cXAbysbCLBDWxFf7XtZp5FaF+INIpGMSeKdgj5bCjI3x9H8oxWowSzI3wkgCv/QYaUz0iuHzfjWSpsSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=oZ30hn9M; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="oZ30hn9M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790236767; x=1821772767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1LeNJJmXuOOwaF3g5L5jTNjFtBySa/mG9oiGNVHE4BE=;
  b=oZ30hn9MCm/DKwaoUn459Ikl2MSPTo64gc9x/hhSRLu8G446u7m0qZq4
   Z8iSyRPGp5jggTJggaR9aCFONGSDo8KL49gfhzAoYCvoxkImJqcSuiguX
   avLPNWxkLuGpXWPuky1n2JLqM0PDfWD7pjIDVoDOKDvH482U5xpMmY3gn
   E4MhBlorP+VTEe4UQLC2ZvCC5B2dRMucfMM690FwbBmTg3oNN4Ll9z1Er
   C8xoTPtFAbGWVHvFbTaR6KpdrcfU2D/M4J7+qH2266wiKP+17tS1j7heo
   0xEX1oucYnz+VRZb+MOvU+zImJPtMu839p+JuOuof+WJ1UcWlQzAc9fIV
   Q==;
X-CSE-ConnectionGUID: jHiw0YDKTqapEofeic83mQ==
X-CSE-MsgGUID: nGdbCIe3RpuhCbHRNkAcvw==
X-IronPort-AV: E=Sophos;i="6.27,120,1787011200"; 
   d="scan'208";a="29419260"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 07:59:24 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:22481]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.18:2525] with esmtp (Farcaster)
 id 17a31595-cb57-4caa-978d-4e8adbabfd3c; Thu, 24 Sep 2026 07:59:23 +0000 (UTC)
X-Farcaster-Flow-ID: 17a31595-cb57-4caa-978d-4e8adbabfd3c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:59:23 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:59:21 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ebiggers@kernel.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<mpatocka@redhat.com>, <bmarzins@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 4/6] crypto: skcipher - split multi-unit requests in the API layer
Date: Thu, 24 Sep 2026 07:58:44 +0000
Message-ID: <20260924075846.28203-5-lravich@amazon.com>
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

When a caller sets skcipher_request::unit_size and the algorithm does
not advertise CRYPTO_ALG_REQ_SEG, transparently split the request in
crypto_skcipher_encrypt/decrypt(): one call per data unit, advancing
the IV between units as a 64-bit little-endian data-unit-number counter
held in the low 8 bytes (the dm-crypt plain64/essiv convention).  The
counter wraps at 2^64 and never carries into the higher IV bytes, so the
output is bit-identical to the per-unit path across the counter
rollover; any other on-disk IV format is produced by a template wrapping
the algorithm.  An algorithm with native multi-unit support gets the
whole request unchanged.  The eventual goal is for underlying algorithms
to gain native support so this path stops triggering.

The split reuses the caller's request for each unit (same tfm, so the
request context is already sized) and restores it before returning;
req->iv is never modified -- each unit gets a private IV copy the
algorithm may clobber.  That copy is aligned to MAX_ALGAPI_ALIGNMASK so
it keeps the alignment the caller's IV had.  The split is synchronous,
so a multi-unit request on an async non-native algorithm is rejected
-EOPNOTSUPP; it reschedules between units when the caller allows
sleeping (CRYPTO_TFM_REQ_MAY_SLEEP), since a large batch would otherwise
run without a preemption point.

Callers that never set unit_size pay one unlikely() test; the split
runs before the lskcipher redirect so lskcipher-backed modes (e.g.
cbc) are split correctly too.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 crypto/skcipher.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 2b31d1d5d268..db1576f6bba0 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -432,6 +432,112 @@ int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_skcipher_setkey);
 
+/* Bounds the on-stack per-unit IV buffers: 16 covers xts, 32 Adiantum. */
+#define SKCIPHER_MAX_UNIT_IVSIZE	32
+
+/*
+ * Advance the per-unit IV to the next data unit.  The data-unit number is a
+ * 64-bit little-endian counter held in the low 8 bytes of @iv (matching
+ * dm-crypt's plain64/essiv sector generators, which the caller feeds in as a
+ * little-endian sector number).  It wraps at 2^64 and never carries into the
+ * higher IV bytes, so batched output stays bit-identical to the per-unit path
+ * across the counter rollover; any other on-disk IV format is produced by a
+ * template wrapping the algorithm, not here.
+ */
+static void skcipher_unit_iv_next(u8 *iv)
+{
+	__le64 lo;
+
+	memcpy(&lo, iv, sizeof(lo));
+	lo = cpu_to_le64(le64_to_cpu(lo) + 1);
+	memcpy(iv, &lo, sizeof(lo));
+}
+
+/*
+ * Transparently split a multi-unit request for an algorithm with no native
+ * multi-unit support: one call per unit, walking the IV as a wide counter.
+ * The caller's request is reused for each unit (same tfm, so the request
+ * context is already correctly sized) and fully restored before returning.
+ * @req->iv is never modified; each unit gets a private copy the algorithm
+ * may write back in place (e.g. xts).
+ */
+static int skcipher_crypt_unit(struct skcipher_request *req, bool enc)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	const unsigned int unit = req->unit_size;
+	const unsigned int total = req->cryptlen;
+	const unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	bool inplace = req->src == req->dst;
+	struct scatterlist *o_src = req->src, *o_dst = req->dst;
+	struct scatter_walk src_walk, dst_walk;
+	struct scatterlist src_sg[2], dst_sg[2];
+	u8 iv_ctr[SKCIPHER_MAX_UNIT_IVSIZE];
+	/* Becomes req->iv: keep the alignment the caller's IV would have had. */
+	u8 iv_unit[SKCIPHER_MAX_UNIT_IVSIZE] __aligned(MAX_ALGAPI_ALIGNMASK + 1);
+	u8 *o_iv = req->iv;
+	unsigned int off;
+	int err = 0;
+
+	if (!total || !IS_ALIGNED(unit, crypto_skcipher_blocksize(tfm)) ||
+	    (total % unit) || !ivsize ||
+	    !IS_ALIGNED(ivsize, sizeof(__le64)) ||
+	    ivsize > SKCIPHER_MAX_UNIT_IVSIZE)
+		return -EINVAL;
+
+	/* The split is synchronous; only a native (REQ_SEG) alg may be async. */
+	if (alg->co.base.cra_flags & CRYPTO_ALG_ASYNC)
+		return -EOPNOTSUPP;
+
+	/* iv_ctr is the counter; iv_unit is the per-unit copy. */
+	memcpy(iv_ctr, req->iv, ivsize);
+
+	sg_init_table(src_sg, 2);
+	scatterwalk_start(&src_walk, req->src);
+	if (!inplace) {
+		sg_init_table(dst_sg, 2);
+		scatterwalk_start(&dst_walk, req->dst);
+	}
+
+	req->unit_size = 0;
+	req->cryptlen = unit;
+
+	for (off = 0; off < total; off += unit) {
+		scatterwalk_get_sglist(&src_walk, src_sg);
+		scatterwalk_skip(&src_walk, unit);
+		req->src = src_sg;
+		if (inplace) {
+			req->dst = src_sg;
+		} else {
+			scatterwalk_get_sglist(&dst_walk, dst_sg);
+			scatterwalk_skip(&dst_walk, unit);
+			req->dst = dst_sg;
+		}
+
+		memcpy(iv_unit, iv_ctr, ivsize);
+		req->iv = iv_unit;
+		err = enc ? crypto_skcipher_encrypt(req) :
+			    crypto_skcipher_decrypt(req);
+		if (err)
+			break;
+
+		skcipher_unit_iv_next(iv_ctr);
+		/*
+		 * Match dm-crypt's per-sector reschedule, but only when the
+		 * caller allows sleeping (the split can run in atomic context).
+		 */
+		if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP)
+			cond_resched();
+	}
+
+	req->src = o_src;
+	req->dst = o_dst;
+	req->iv = o_iv;
+	req->cryptlen = total;
+	req->unit_size = unit;
+	return err;
+}
+
 int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -439,6 +545,9 @@ int crypto_skcipher_encrypt(struct skcipher_request *req)
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
+	/* Must precede the lskcipher redirect, which ignores unit_size. */
+	if (unlikely(req->unit_size) && !crypto_skcipher_req_seg(tfm))
+		return skcipher_crypt_unit(req, true);
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		return crypto_lskcipher_encrypt_sg(req);
 	return alg->encrypt(req);
@@ -452,6 +561,9 @@ int crypto_skcipher_decrypt(struct skcipher_request *req)
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
+	/* Must precede the lskcipher redirect, which ignores unit_size. */
+	if (unlikely(req->unit_size) && !crypto_skcipher_req_seg(tfm))
+		return skcipher_crypt_unit(req, false);
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		return crypto_lskcipher_decrypt_sg(req);
 	return alg->decrypt(req);
-- 
2.47.3


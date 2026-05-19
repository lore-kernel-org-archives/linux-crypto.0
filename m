Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906B44C6EEE;
	Tue, 19 May 2026 12:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779192022; cv=none; b=j8/nERmwCt1QUUr/fYexg2+roy/w3eZiLvWnHiC5ehIFN3BRXQXV/Bl6hPJpXvNO0f7grdX3ZQ6aL9FlAdBraRk0zaqh42iMoKFaBPtUwPdWhQk4edIHDppgObQVPy9qKEAm7eaWQLBq9pQPeSgTfgJYSHQ6p8RjHJvHxajk/Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779192022; c=relaxed/simple;
	bh=9nqmk2j8kVAVuv/aVQ3RC2lPERBgNz9x/pIlfVcbS8E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qMug2lzWfxXo1SjjjPtDT/9xCD7TL1I3OkN+MVS1MwVDX9B+rjsc9LFYjyjRVT3udpr+FMybEd7dnsYMS8TqJSMWnWXK8FrRbruDnAUKopygbbyvcCdW7vl2FZ4Kmx5KV0T+ZAnRNSxxffJj10wX0TZGM55Ci5tpvuhmVbRitWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=k6qFGHBl; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="k6qFGHBl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1779192020; x=1810728020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=csv5KLoYQ2BnvevRg0X/ryKlhBHQX9nXWrbR0xbkwPQ=;
  b=k6qFGHBlKLU6cCGv1gkIhVD++WHZN0gxopC7fic/jl42MDLhwjo0lA3e
   IkXUOTZo1lLLnMN68TdI/lYsInXB00ZtZgvS0xLMz7MHPA4JlyolVWJ/2
   iYRvasisyM+Hpo6V/n+hGpHIKxjT3+TFTKaO0eJ19XpyJKTb1Co7AR6Fa
   hqPL0Nf1cDpZ1W+D3KHK4LZnA6k69cNs0WqOycRmOGVuzI6ODlIQm+f7z
   ngIPM1PWv6GmTx3tS/3clw3IpDymcevX/FX2OBfSTAB/gEhcWmsxeTYS5
   wdVEDp+BSi826lZ9KMAebTiYvsASCDAv/LqvQPUqXRtOeINlsmg91A2Vr
   Q==;
X-CSE-ConnectionGUID: yQnVgvDeTWy/Kafn7Vg1tw==
X-CSE-MsgGUID: Suh2mbHSQ8a5SS3M/kWrjg==
X-IronPort-AV: E=Sophos;i="6.23,243,1770595200"; 
   d="scan'208";a="19858456"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 12:00:17 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:5362]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.21:2525] with esmtp (Farcaster)
 id 1e8b19da-aa86-4e1a-874a-afecec23277e; Tue, 19 May 2026 12:00:17 +0000 (UTC)
X-Farcaster-Flow-ID: 1e8b19da-aa86-4e1a-874a-afecec23277e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 19 May 2026 12:00:14 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 19 May 2026 12:00:12 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon
	<agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH 1/4] crypto: skcipher - add per-tfm data_unit_size for batched requests
Date: Tue, 19 May 2026 11:59:57 +0000
Message-ID: <20260519120002.27267-2-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428101225.24316-1-lravich@amazon.com>
References: <20260428101225.24316-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D041UWB002.ant.amazon.com (10.13.139.179) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add a per-tfm data_unit_size and an algorithm capability flag that
together allow a caller to submit several data units in a single
skcipher request.  The IV passed in the request applies to the first
data unit; the algorithm advances the tweak between data units
according to the mode specification (e.g., LE128 multiply for XTS per
IEEE 1619).

This mirrors the data_unit_size concept already exposed by
struct blk_crypto_config for inline encryption hardware, but at the
software skcipher layer.  The first user is dm-crypt, which today
issues one request per sector and so pays a per-sector cost in
request allocation, IV generation, callback dispatch, and completion
handling.  Allowing the cipher to consume a whole bio per request
removes that overhead for drivers that can chain across data units
internally.

The data_unit_size lives on struct crypto_skcipher rather than on
struct skcipher_request because it does not change between requests
for any plausible consumer: dm-crypt picks one sector size per
mapped target at table load time; fscrypt would pick one per master
key.  Anchoring it to the tfm also lets the driver validate it once
at setkey() time and avoids per-request initialisation hazards on
mempool-recycled requests.

Capability is advertised with CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT
in cra_flags (type-specific high-byte range, mirroring the
CRYPTO_AHASH_ALG_* convention).  This makes the capability visible
in /proc/crypto and lets templates OR it into their derived
algorithms.

crypto_skcipher_set_data_unit_size() returns -EOPNOTSUPP if the
algorithm does not advertise the flag, and accepts 0 (the default)
unconditionally so callers can re-disable batching cheaply.

crypto_skcipher_encrypt()/decrypt() reject requests whose cryptlen
is not a multiple of the configured data_unit_size with -EINVAL.
The check is gated on data_unit_size != 0 so it costs nothing for
the common single-data-unit case.

No in-tree algorithm advertises the flag yet; subsequent patches
add the generic xts() template, arm64, and x86 producers as well
as the dm-crypt consumer.

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 crypto/skcipher.c                  | 120 +++++++++++++++++++++++++++++
 include/crypto/internal/skcipher.h |  34 ++++++++
 include/crypto/skcipher.h          |  85 ++++++++++++++++++++
 3 files changed, 239 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 8fa5d9686d08..9155a4d9ea6d 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -183,13 +183,119 @@ int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_skcipher_setkey);
 
+int crypto_skcipher_set_data_unit_size(struct crypto_skcipher *tfm,
+				       unsigned int data_unit_size)
+{
+	unsigned int blocksize;
+
+	if (!data_unit_size) {
+		tfm->data_unit_size = 0;
+		return 0;
+	}
+
+	if (!crypto_skcipher_supports_multi_data_unit(tfm))
+		return -EOPNOTSUPP;
+
+	blocksize = crypto_skcipher_blocksize(tfm);
+	if (data_unit_size < blocksize || data_unit_size % blocksize)
+		return -EINVAL;
+
+	tfm->data_unit_size = data_unit_size;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_skcipher_set_data_unit_size);
+
+static int crypto_skcipher_check_data_unit_size(struct crypto_skcipher *tfm,
+						struct skcipher_request *req)
+{
+	unsigned int du = tfm->data_unit_size;
+
+	if (likely(!du))
+		return 0;
+	if (req->cryptlen % du)
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * Increment a 16-byte little-endian counter held in @iv.  See
+ * crypto_skcipher_set_data_unit_size() for the convention.
+ */
+static inline void skcipher_iv_inc_le128(u8 *iv)
+{
+	__le64 lo_le, hi_le;
+	u64 lo;
+
+	memcpy(&lo_le, iv, 8);
+	memcpy(&hi_le, iv + 8, 8);
+	lo = le64_to_cpu(lo_le) + 1;
+	lo_le = cpu_to_le64(lo);
+	memcpy(iv, &lo_le, 8);
+	if (unlikely(lo == 0)) {
+		hi_le = cpu_to_le64(le64_to_cpu(hi_le) + 1);
+		memcpy(iv + 8, &hi_le, 8);
+	}
+}
+
+int skcipher_walk_data_units(struct skcipher_request *req,
+			     int (*body)(struct skcipher_request *))
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const unsigned int du = tfm->data_unit_size;
+	const unsigned int total = req->cryptlen;
+	struct scatterlist *orig_src = req->src;
+	struct scatterlist *orig_dst = req->dst;
+	struct scatterlist src_sg[2], dst_sg[2];
+	u8 iv_save[16];
+	unsigned int off;
+	int err = 0;
+
+	if (likely(!du))
+		return body(req);
+
+	/*
+	 * Registration of an algorithm advertising
+	 * CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT enforces ivsize == 16
+	 * (see skcipher_prepare_alg_common()), so this is purely
+	 * defensive against algorithm-registration bugs.
+	 */
+	if (WARN_ON_ONCE(crypto_skcipher_ivsize(tfm) != 16))
+		return -EINVAL;
+
+	memcpy(iv_save, req->iv, 16);
+
+	for (off = 0; off < total; off += du) {
+		req->cryptlen = du;
+		req->src = scatterwalk_ffwd(src_sg, orig_src, off);
+		req->dst = (orig_src == orig_dst) ? req->src :
+			   scatterwalk_ffwd(dst_sg, orig_dst, off);
+
+		err = body(req);
+		if (err)
+			break;
+
+		skcipher_iv_inc_le128(iv_save);
+		memcpy(req->iv, iv_save, 16);
+	}
+
+	req->src = orig_src;
+	req->dst = orig_dst;
+	req->cryptlen = total;
+	return err;
+}
+EXPORT_SYMBOL_GPL(skcipher_walk_data_units);
+
 int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	int err;
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
+	err = crypto_skcipher_check_data_unit_size(tfm, req);
+	if (err)
+		return err;
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		return crypto_lskcipher_encrypt_sg(req);
 	return alg->encrypt(req);
@@ -200,9 +306,13 @@ int crypto_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	int err;
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
+	err = crypto_skcipher_check_data_unit_size(tfm, req);
+	if (err)
+		return err;
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		return crypto_lskcipher_decrypt_sg(req);
 	return alg->decrypt(req);
@@ -432,6 +542,16 @@ int skcipher_prepare_alg_common(struct skcipher_alg_common *alg)
 	    (alg->ivsize + alg->statesize) > PAGE_SIZE / 2)
 		return -EINVAL;
 
+	/*
+	 * Algorithms advertising multi-data-unit support must use the
+	 * 16-byte little-endian counter convention documented in
+	 * crypto_skcipher_set_data_unit_size(); see also
+	 * skcipher_walk_data_units().
+	 */
+	if ((base->cra_flags & CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT) &&
+	    alg->ivsize != 16)
+		return -EINVAL;
+
 	if (!alg->chunksize)
 		alg->chunksize = base->cra_blocksize;
 
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index d5aa535263f6..bfabc97f34ef 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -22,6 +22,40 @@
  */
 #define CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE CRYPTO_ALG_OPTIONAL_KEY
 
+/**
+ * skcipher_walk_data_units - dispatch a request as one body call per data unit
+ * @req: the caller's skcipher request
+ * @body: the algorithm's single-data-unit encrypt or decrypt function
+ *
+ * When tfm->data_unit_size is zero this is a tail call into @body with
+ * @req unchanged.  Otherwise the request is split into
+ * cryptlen / data_unit_size sub-ranges and @body is called once per
+ * sub-range with req->cryptlen, req->src, req->dst, and req->iv adjusted
+ * for that sub-range.  The IV passed to data unit n is the caller-
+ * supplied IV plus n, where + is a 128-bit little-endian add — this
+ * matches the convention documented in
+ * crypto_skcipher_set_data_unit_size().
+ *
+ * Many single-data-unit XTS bodies modify the IV buffer in place during
+ * processing (the tweak is walked block by block).  This helper saves
+ * the caller's IV before each call and rewrites the next data unit's
+ * IV from the saved value, so the body always sees a fresh per-DU IV
+ * regardless of any in-place mutation it performs.
+ *
+ * The body MUST run to completion synchronously.  Drivers that use this
+ * helper therefore advertise CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT only
+ * for synchronous configurations.
+ *
+ * After the call returns, the contents of req->iv are unspecified per
+ * the documented contract.  src/dst/cryptlen are restored to the
+ * caller's values to keep skcipher request post-conditions intact.
+ *
+ * Return: 0 on success, or the body's negative errno on the first
+ *	   data unit that returned non-zero.
+ */
+int skcipher_walk_data_units(struct skcipher_request *req,
+			     int (*body)(struct skcipher_request *));
+
 struct aead_request;
 struct rtattr;
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 9e5853464345..c4112c57f6a2 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -26,6 +26,15 @@
 /* Set this bit if the skcipher operation is not final. */
 #define CRYPTO_SKCIPHER_REQ_NOTFINAL	0x00000002
 
+/*
+ * Set in cra_flags by an skcipher algorithm that supports processing
+ * multiple data units in a single request.  See
+ * crypto_skcipher_set_data_unit_size().
+ *
+ * Type-specific flag in the 0xff000000 reserved range.
+ */
+#define CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT	0x01000000
+
 struct scatterlist;
 
 /**
@@ -53,6 +62,22 @@ struct skcipher_request {
 struct crypto_skcipher {
 	unsigned int reqsize;
 
+	/*
+	 * Number of bytes in one data unit when batching multiple data units
+	 * per request.  0 means "single data unit per request" (legacy
+	 * behaviour).  Set via crypto_skcipher_set_data_unit_size().
+	 *
+	 * When non-zero, cryptlen must be a multiple of data_unit_size.  The
+	 * IV passed in skcipher_request::iv applies to the first data unit;
+	 * the algorithm advances the tweak between data units according to
+	 * the mode specification (e.g., LE128 multiply for XTS per
+	 * IEEE 1619).
+	 *
+	 * Only algorithms that advertise CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT
+	 * in cra_flags accept a non-zero value.
+	 */
+	unsigned int data_unit_size;
+
 	struct crypto_tfm base;
 };
 
@@ -491,6 +516,66 @@ static inline unsigned int crypto_lskcipher_chunksize(
 	return crypto_lskcipher_alg(tfm)->co.chunksize;
 }
 
+/**
+ * crypto_skcipher_supports_multi_data_unit() - test multi-data-unit support
+ * @tfm: cipher handle
+ *
+ * Return: true if the algorithm advertises that it can process multiple
+ *	   data units in a single skcipher_request.
+ */
+static inline bool
+crypto_skcipher_supports_multi_data_unit(struct crypto_skcipher *tfm)
+{
+	return crypto_skcipher_alg_common(tfm)->base.cra_flags &
+		CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT;
+}
+
+/**
+ * crypto_skcipher_set_data_unit_size() - set data unit size for the tfm
+ * @tfm: cipher handle
+ * @data_unit_size: data unit size in bytes; 0 disables multi-data-unit mode
+ *
+ * Configure the tfm to process multiple data units per request.  When set
+ * to a non-zero value, every subsequent encrypt/decrypt request must have
+ * cryptlen that is a multiple of @data_unit_size.  Each data unit is
+ * processed as if it were a separate request whose IV is derived from the
+ * preceding data unit's IV by the algorithm-specific tweak update rule:
+ * the implementation treats the caller-supplied IV as a 128-bit
+ * little-endian counter and adds the data-unit index for each subsequent
+ * data unit.
+ *
+ * The contents of req->iv after a multi-data-unit request returns are
+ * unspecified — callers MUST NOT rely on it being either the original
+ * value or the final-data-unit value.  Set a fresh IV before every
+ * request.
+ *
+ * The algorithm must advertise CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT in its
+ * cra_flags.  @data_unit_size must be a positive multiple of the
+ * algorithm's cra_blocksize, otherwise -EINVAL is returned.
+ *
+ * Setting @data_unit_size to 0 reverts the tfm to single-data-unit
+ * behaviour and is always permitted.
+ *
+ * Return: 0 on success; -EOPNOTSUPP if the algorithm does not advertise
+ *	   multi-data-unit support; -EINVAL if @data_unit_size is not a
+ *	   positive multiple of the cipher block size.
+ */
+int crypto_skcipher_set_data_unit_size(struct crypto_skcipher *tfm,
+				       unsigned int data_unit_size);
+
+/**
+ * crypto_skcipher_data_unit_size() - obtain data unit size
+ * @tfm: cipher handle
+ *
+ * Return: configured data unit size in bytes; 0 if multi-data-unit mode
+ *	   is disabled.
+ */
+static inline unsigned int
+crypto_skcipher_data_unit_size(struct crypto_skcipher *tfm)
+{
+	return tfm->data_unit_size;
+}
+
 /**
  * crypto_skcipher_statesize() - obtain state size
  * @tfm: cipher handle
-- 
2.47.3


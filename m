Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDEC3DA5A5;
	Mon, 15 Jun 2026 11:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781522113; cv=none; b=sJfvMpTagXFZg7t1E34B/1wBUCblvXSwpmDZAsgJCqUQaKF2aYk0iE31RWfT9X3ikC1Oakz2WXk2l3Hq/RjdGk6PLcSEaRug4PecBjQifJdDmB0jxAvGqrMgs+OmeVf3crLkmEs2CZTqWkJBvdC9gn8CoxOuR7xPEurpF2sgtpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781522113; c=relaxed/simple;
	bh=ciMYLH+iUM9q05ZT4XtBY+PHMs7r5ZbpQ0Rc821yV9g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DREmhuUbFAvNuyZVVCJhEwmQ3b/WY1JCaNC7Mz8PSuoEzDSvda6SoYPdeG3t/ajTgw1gOPThFHrlnHfis1dO5gwiwMrNnjUGsZQgcEQdbmPX/rN+k1kPYbhtp6JBjNXDhSsvJGJkv0MaTSpGtXLJF2uhmR0mQbAJMgnEir8E6Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=J8M/vQqV; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="J8M/vQqV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1781522112; x=1813058112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=coO4f3CGZoL4jOgbuQqbftSIxxxR+UrDn5/Rv9Zcyyo=;
  b=J8M/vQqVNhZ6nViFLqYWaoXiAOL1YEEfJAIXnWDnRfiI56qRNDfQDfH5
   Te1J8nGbrk6Km9a7DpqjYB849twqKVamu5V7Z2aubigtAf6QLJ27jfAzt
   qBHLc/LdRKEvvMOPxc1oe9Ry7TjAyD5nQSuoXJYdZKUro5i0mSLseHBoV
   KGmgcwbZN79YTC9eNNHexxCuxe1ELwNnZ77+utJ59Fqtuvmqxq/GcgaIp
   VXvSUq9nIsTIeJAp7LrUIL6SZ0M0Sz9CLZUyXs7PxEgeHsdxkWxVC0//O
   eixZERW0WSREOBiBvp+PLK1Y+2VKR4Mamw1GL0Ruj1XEfr4Vmb7Sm8ZV4
   g==;
X-CSE-ConnectionGUID: uk5i50VXQLiR0JbYhF3feg==
X-CSE-MsgGUID: fGjdYRUOTGqvLilq3u4rvQ==
X-IronPort-AV: E=Sophos;i="6.24,206,1774310400"; 
   d="scan'208";a="21273359"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:15:08 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:21428]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.63.253:2525] with esmtp (Farcaster)
 id 52eaf02d-f54f-4d0e-b898-9fb056db8c23; Mon, 15 Jun 2026 11:15:08 +0000 (UTC)
X-Farcaster-Flow-ID: 52eaf02d-f54f-4d0e-b898-9fb056db8c23
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 15 Jun 2026 11:15:08 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 15 Jun 2026 11:15:06 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, "Eric
 Biggers" <ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH v4 1/3] crypto: skcipher - add per-request data_unit_size with auto-splitting
Date: Mon, 15 Jun 2026 11:14:57 +0000
Message-ID: <20260615111459.9452-2-lravich@amazon.com>
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

Add a data_unit_size field to struct skcipher_request that lets a
caller submit several data units (typically 512..4096-byte sectors)
sharing one starting IV in a single request.  Algorithms derive each
data unit's IV from the caller-supplied IV by treating it as a
128-bit little-endian counter and adding the data-unit index, which
matches the layout produced by dm-crypt's plain64 IV mode and by
typical inline-encryption hardware.

This mirrors the data_unit_size concept already exposed by
struct blk_crypto_config for inline encryption.

The crypto API auto-splits a multi-data-unit request into per-DU
sub-requests when the underlying algorithm does not advertise
CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU (a type-specific cra_flags bit,
defined in crypto/internal/skcipher.h).  A consumer sets
data_unit_size and submits: a native driver handles all units in one
pass, otherwise the core splits transparently.  The split derives
per-DU IVs as a 128-bit LE counter, so this is correct only for
algorithms using that IV convention (e.g. XTS with plain64-style
IVs); callers are responsible for that match, as they already are for
the IV itself.

skcipher_request_set_tfm() resets the field to 0 so a request reused
from a pool or stack defaults to single-data-unit semantics; callers
that want batching set it explicitly via
skcipher_request_set_data_unit_size() after configuring the tfm.

crypto_skcipher_encrypt()/decrypt() call
crypto_skcipher_validate_multi_du() before any algorithm dispatch.
data_unit_size must be a power of two when non-zero (realistic sizes
are 512..4096, letting the per-DU loop and the cryptlen alignment
check use a mask instead of a divide) and cryptlen a positive
multiple of it; a malformed geometry is rejected with -EINVAL.  A
target that cannot do multi-DU - ivsize != SKCIPHER_MDU_IVSIZE (16),
an lskcipher, or an async algorithm without the native flag - is
rejected with -EOPNOTSUPP so a caller can fall back.  Async is
excluded because the splitter dispatches synchronously: an
-EINPROGRESS return would leave later units unsubmitted while the
driver still owned the request's scatterlists and IV.  The check
gates the native path too, so algorithms never see a malformed
multi-DU request.

No in-tree algorithm sets CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU yet;
subsequent patches add the testmgr coverage and the dm-crypt
consumer.

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 crypto/skcipher.c                  | 132 +++++++++++++++++++++++++++++
 include/crypto/internal/skcipher.h |  10 +++
 include/crypto/skcipher.h          |  28 ++++++
 3 files changed, 170 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 2b31d1d5d268..9262b47acfb9 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -17,6 +17,7 @@
 #include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/log2.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
@@ -432,15 +433,139 @@ int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_skcipher_setkey);
 
+/* IV size for the 128-bit LE-counter multi-data-unit convention. */
+#define SKCIPHER_MDU_IVSIZE	16
+
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
+/*
+ * Dispatch a multi-data-unit request as one single-DU sub-request per
+ * unit.  Each unit's IV is the caller's IV plus the unit index, taken
+ * as a 128-bit little-endian counter.  A pair of scatter_walks advances
+ * through src/dst in a single linear pass (O(entries + units)); building
+ * each sub-request's view with scatterwalk_ffwd() would instead rescan
+ * from the head every unit, i.e. O(units^2).
+ */
+static int skcipher_split_data_units(struct skcipher_request *req,
+				     int (*body)(struct skcipher_request *))
+{
+	const unsigned int du = req->data_unit_size;
+	const unsigned int total = req->cryptlen;
+	struct scatterlist *orig_src = req->src;
+	struct scatterlist *orig_dst = req->dst;
+	bool inplace = orig_src == orig_dst;
+	struct scatter_walk src_walk, dst_walk;
+	struct scatterlist src_sg[2], dst_sg[2];
+	u8 iv_orig[SKCIPHER_MDU_IVSIZE];
+	u8 iv_work[SKCIPHER_MDU_IVSIZE];
+	unsigned int off;
+	int err = 0;
+
+	memcpy(iv_orig, req->iv, sizeof(iv_orig));
+	memcpy(iv_work, iv_orig, sizeof(iv_orig));
+
+	sg_init_table(src_sg, 2);
+	scatterwalk_start(&src_walk, orig_src);
+	if (!inplace) {
+		sg_init_table(dst_sg, 2);
+		scatterwalk_start(&dst_walk, orig_dst);
+	}
+
+	/* Stop the per-DU body from re-entering the splitter. */
+	req->data_unit_size = 0;
+	req->src = src_sg;
+	req->dst = inplace ? src_sg : dst_sg;
+
+	for (off = 0; off < total; off += du) {
+		req->cryptlen = du;
+		scatterwalk_get_sglist(&src_walk, src_sg);
+		scatterwalk_skip(&src_walk, du);
+		if (!inplace) {
+			scatterwalk_get_sglist(&dst_walk, dst_sg);
+			scatterwalk_skip(&dst_walk, du);
+		}
+
+		err = body(req);
+		if (err)
+			break;
+
+		skcipher_iv_inc_le128(iv_work);
+		memcpy(req->iv, iv_work, sizeof(iv_work));
+	}
+
+	/* Caller-visible IV is the starting IV regardless of outcome. */
+	memcpy(req->iv, iv_orig, sizeof(iv_orig));
+	req->src = orig_src;
+	req->dst = orig_dst;
+	req->cryptlen = total;
+	req->data_unit_size = du;
+	return err;
+}
+
+static int crypto_skcipher_validate_multi_du(struct skcipher_request *req)
+{
+	const unsigned int du = req->data_unit_size;
+	struct crypto_skcipher *tfm;
+	struct skcipher_alg *alg;
+	u32 cra_flags;
+
+	if (likely(!du))
+		return 0;
+	if (!is_power_of_2(du) || du < SKCIPHER_MDU_IVSIZE)
+		return -EINVAL;
+	if (!req->cryptlen || (req->cryptlen & (du - 1)))
+		return -EINVAL;
+
+	tfm = crypto_skcipher_reqtfm(req);
+	alg = crypto_skcipher_alg(tfm);
+
+	/* lskcipher's *_sg path doesn't honour data_unit_size. */
+	if (alg->co.base.cra_type != &crypto_skcipher_type)
+		return -EOPNOTSUPP;
+
+	/* Capability mismatch, not a malformed request: report -EOPNOTSUPP. */
+	if (crypto_skcipher_ivsize(tfm) != SKCIPHER_MDU_IVSIZE)
+		return -EOPNOTSUPP;
+
+	/* The auto-splitter is sync-only; native drivers own async dispatch. */
+	cra_flags = alg->co.base.cra_flags;
+	if ((cra_flags & CRYPTO_ALG_ASYNC) &&
+	    !(cra_flags & CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	int err;
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
+	err = crypto_skcipher_validate_multi_du(req);
+	if (err)
+		return err;
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		return crypto_lskcipher_encrypt_sg(req);
+	if (req->data_unit_size &&
+	    !(alg->co.base.cra_flags & CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU))
+		return skcipher_split_data_units(req, alg->encrypt);
 	return alg->encrypt(req);
 }
 EXPORT_SYMBOL_GPL(crypto_skcipher_encrypt);
@@ -449,11 +574,18 @@ int crypto_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	int err;
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
+	err = crypto_skcipher_validate_multi_du(req);
+	if (err)
+		return err;
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		return crypto_lskcipher_decrypt_sg(req);
+	if (req->data_unit_size &&
+	    !(alg->co.base.cra_flags & CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU))
+		return skcipher_split_data_units(req, alg->decrypt);
 	return alg->decrypt(req);
 }
 EXPORT_SYMBOL_GPL(crypto_skcipher_decrypt);
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index a965b6aabf61..4c826f3bc715 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -21,6 +21,16 @@
  */
 #define CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE CRYPTO_ALG_OPTIONAL_KEY
 
+/*
+ * Set by an skcipher that handles skcipher_request::data_unit_size > 0
+ * natively in one pass; otherwise the API splits the request.  Lives in
+ * the type-specific 0xff000000 cra_flags range.  A native driver must
+ * derive per-DU IVs as a 128-bit LE counter and leave @iv at the
+ * caller-supplied starting value on return, success or error, matching
+ * the auto-splitter so the two paths are observably identical.
+ */
+#define CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU	0x01000000
+
 struct aead_request;
 struct rtattr;
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 4efe2ca8c4d1..ced1fae08147 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -31,6 +31,11 @@ struct scatterlist;
 /**
  *	struct skcipher_request - Symmetric key cipher request
  *	@cryptlen: Number of bytes to encrypt or decrypt
+ *	@data_unit_size: Size in bytes of each data unit, or 0 for a
+ *		single-data-unit request (the default).  When non-zero,
+ *		must be a power of two, @cryptlen must be a positive
+ *		multiple of it, and per-DU IVs are derived from @iv as a
+ *		128-bit little-endian counter.
  *	@iv: Initialisation Vector
  *	@src: Source SG list
  *	@dst: Destination SG list
@@ -39,6 +44,7 @@ struct scatterlist;
  */
 struct skcipher_request {
 	unsigned int cryptlen;
+	unsigned int data_unit_size;
 
 	u8 *iv;
 
@@ -225,6 +231,7 @@ struct lskcipher_alg {
 	struct skcipher_request *name = \
 		(((struct skcipher_request *)__##name##_desc)->base.tfm = \
 			crypto_sync_skcipher_tfm((_tfm)), \
+		 ((struct skcipher_request *)__##name##_desc)->data_unit_size = 0, \
 		 (void *)__##name##_desc)
 
 /**
@@ -819,6 +826,8 @@ static inline void skcipher_request_set_tfm(struct skcipher_request *req,
 					    struct crypto_skcipher *tfm)
 {
 	req->base.tfm = crypto_skcipher_tfm(tfm);
+	/* Reused requests default to single-data-unit. */
+	req->data_unit_size = 0;
 }
 
 static inline void skcipher_request_set_sync_tfm(struct skcipher_request *req,
@@ -937,5 +946,24 @@ static inline void skcipher_request_set_crypt(
 	req->iv = iv;
 }
 
+/**
+ * skcipher_request_set_data_unit_size() - submit as multiple data units
+ * @req: request handle
+ * @data_unit_size: data-unit size in bytes (power of two), or 0 to disable
+ *
+ * Process @req as @cryptlen / @data_unit_size data units sharing one starting
+ * @iv, with per-DU IVs derived as a 128-bit little-endian counter.  @cryptlen
+ * must be a positive multiple of @data_unit_size, else the encrypt/decrypt
+ * call returns -EINVAL; a target that cannot do multi-DU (ivsize != 16, an
+ * lskcipher, or async without native support) returns -EOPNOTSUPP.  Unlike
+ * the single-DU path, @iv is preserved across the call regardless of outcome.
+ */
+static inline void
+skcipher_request_set_data_unit_size(struct skcipher_request *req,
+				    unsigned int data_unit_size)
+{
+	req->data_unit_size = data_unit_size;
+}
+
 #endif	/* _CRYPTO_SKCIPHER_H */
 

base-commit: a8cafdf8c949f17c92eca0045532e88ac0dac30d
-- 
2.47.3


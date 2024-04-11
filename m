Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA011422DB
	for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2024 09:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712828659; cv=none; b=caRMrf9fQTtQg2kMug00F+m+7d2tLUMkqE9br6B+KGWyHEHtoFAn0/U/V06aMxuRRo9e+UEUZYMs9fISTqt6LQsooxFyGScuRE1CyK/l+ZzeFKVXZVd/6EbEP9cHXI+JUdsLeeCDMAw5HIEpnhQO1tK1DkW1rIepurFzapHU2LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712828659; c=relaxed/simple;
	bh=4ytJZXrlLIX4MDl48jzj1jv5bmJfqXaT8kzbsZkajJU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pTe8GJBbZd+Af/bNE7y8FTZ+ZlEFrvDNgJBdy5h9Vn2AmfWZO5pKlDQklq/j64CCyJFDib7sQt4PuEqItZ4pOI0sWE8M65W5nvtZO5fNXyimDRAcxkVXM5aULSRVYHbUCMavsmx6luxt/GjUiR8CDzIGbZcsOuksxcrNU1yZjQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HKcW0jfg; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HKcW0jfg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712828657; x=1744364657;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4ytJZXrlLIX4MDl48jzj1jv5bmJfqXaT8kzbsZkajJU=;
  b=HKcW0jfg8VrxoE5XHFV2eYspoxgft2Vq4GcJSykfNtU66skfWPlkWTLC
   g+1whMYVNJCI+Xai7yEB4Ff1dpAe2GbS6RwmLcEMVCVLBUGjaaWOkIs7g
   VtGxc2Yuf61bf/hAfMvLEJIlYHmkyLgu0dwu3tciDnDzGILyOoJEmmFI7
   hUz95tT9r65/uoGtbXadxt/L+MDMZm/E+dS0HJBXzhNfOd+vvfFyRvoGP
   2cxNyDX3l7Z5/7rZb3BEUPC+6r74n7hzZH9eDq3QhQ7shJpkdPli7c423
   J/EsWMLlV3CbMLh9SY1Qh8qR4qyVsbZwzKVz79wSHric7CUVHEDAAaOsi
   Q==;
X-CSE-ConnectionGUID: 3e5da3R7RjaKkGAETatIFw==
X-CSE-MsgGUID: MkaYAJOfSoiAVWZoOtkQBA==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8087468"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="8087468"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 02:44:16 -0700
X-CSE-ConnectionGUID: jpPfTrzdQhatoxeLaYzNpg==
X-CSE-MsgGUID: NdNp+182QEWC/FWqEvKzQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="20900588"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmviesa007.fm.intel.com with ESMTP; 11 Apr 2024 02:44:15 -0700
From: Damian Muszynski <damian.muszynski@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - implement dh fallback for primes > 4K
Date: Thu, 11 Apr 2024 11:24:58 +0200
Message-ID: <20240411092526.127182-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit

The Intel QAT driver provides support for the Diffie-Hellman (DH)
algorithm, limited to prime numbers up to 4K. This driver is used
by default on platforms with integrated QAT hardware for all DH requests.
This has led to failures with algorithms requiring larger prime sizes,
such as ffdhe6144.

  alg: ffdhe6144(dh): test failed on vector 1, err=-22
  alg: self-tests for ffdhe6144(qat-dh) (ffdhe6144(dh)) failed (rc=-22)

Implement a fallback mechanism when an unsupported request is received.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_common/qat_asym_algs.c      | 66 +++++++++++++++++--
 1 file changed, 60 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index 4128200a9032..85c682e248fb 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -110,6 +110,8 @@ struct qat_dh_ctx {
 	unsigned int p_size;
 	bool g2;
 	struct qat_crypto_instance *inst;
+	struct crypto_kpp *ftfm;
+	bool fallback;
 } __packed __aligned(64);
 
 struct qat_asym_request {
@@ -381,6 +383,36 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	return ret;
 }
 
+static int qat_dh_generate_public_key(struct kpp_request *req)
+{
+	struct kpp_request *nreq = kpp_request_ctx(req);
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	if (ctx->fallback) {
+		memcpy(nreq, req, sizeof(*req));
+		kpp_request_set_tfm(nreq, ctx->ftfm);
+		return crypto_kpp_generate_public_key(nreq);
+	}
+
+	return qat_dh_compute_value(req);
+}
+
+static int qat_dh_compute_shared_secret(struct kpp_request *req)
+{
+	struct kpp_request *nreq = kpp_request_ctx(req);
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	if (ctx->fallback) {
+		memcpy(nreq, req, sizeof(*req));
+		kpp_request_set_tfm(nreq, ctx->ftfm);
+		return crypto_kpp_compute_shared_secret(nreq);
+	}
+
+	return qat_dh_compute_value(req);
+}
+
 static int qat_dh_check_params_length(unsigned int p_len)
 {
 	switch (p_len) {
@@ -398,9 +430,6 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev = &GET_DEV(inst->accel_dev);
 
-	if (qat_dh_check_params_length(params->p_size << 3))
-		return -EINVAL;
-
 	ctx->p_size = params->p_size;
 	ctx->p = dma_alloc_coherent(dev, ctx->p_size, &ctx->dma_p, GFP_KERNEL);
 	if (!ctx->p)
@@ -454,6 +483,13 @@ static int qat_dh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	if (crypto_dh_decode_key(buf, len, &params) < 0)
 		return -EINVAL;
 
+	if (qat_dh_check_params_length(params.p_size << 3)) {
+		ctx->fallback = true;
+		return crypto_kpp_set_secret(ctx->ftfm, buf, len);
+	}
+
+	ctx->fallback = false;
+
 	/* Free old secret if any */
 	qat_dh_clear_ctx(dev, ctx);
 
@@ -481,6 +517,9 @@ static unsigned int qat_dh_max_size(struct crypto_kpp *tfm)
 {
 	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
 
+	if (ctx->fallback)
+		return crypto_kpp_maxsize(ctx->ftfm);
+
 	return ctx->p_size;
 }
 
@@ -489,11 +528,22 @@ static int qat_dh_init_tfm(struct crypto_kpp *tfm)
 	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
 	struct qat_crypto_instance *inst =
 			qat_crypto_get_instance_node(numa_node_id());
+	const char *alg = kpp_alg_name(tfm);
+	unsigned int reqsize;
 
 	if (!inst)
 		return -EINVAL;
 
-	kpp_set_reqsize(tfm, sizeof(struct qat_asym_request) + 64);
+	ctx->ftfm = crypto_alloc_kpp(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->ftfm))
+		return PTR_ERR(ctx->ftfm);
+
+	crypto_kpp_set_flags(ctx->ftfm, crypto_kpp_get_flags(tfm));
+
+	reqsize = max(sizeof(struct qat_asym_request) + 64,
+		      sizeof(struct kpp_request) + crypto_kpp_reqsize(ctx->ftfm));
+
+	kpp_set_reqsize(tfm, reqsize);
 
 	ctx->p_size = 0;
 	ctx->g2 = false;
@@ -506,6 +556,9 @@ static void qat_dh_exit_tfm(struct crypto_kpp *tfm)
 	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
 	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
 
+	if (ctx->ftfm)
+		crypto_free_kpp(ctx->ftfm);
+
 	qat_dh_clear_ctx(dev, ctx);
 	qat_crypto_put_instance(ctx->inst);
 }
@@ -1265,8 +1318,8 @@ static struct akcipher_alg rsa = {
 
 static struct kpp_alg dh = {
 	.set_secret = qat_dh_set_secret,
-	.generate_public_key = qat_dh_compute_value,
-	.compute_shared_secret = qat_dh_compute_value,
+	.generate_public_key = qat_dh_generate_public_key,
+	.compute_shared_secret = qat_dh_compute_shared_secret,
 	.max_size = qat_dh_max_size,
 	.init = qat_dh_init_tfm,
 	.exit = qat_dh_exit_tfm,
@@ -1276,6 +1329,7 @@ static struct kpp_alg dh = {
 		.cra_priority = 1000,
 		.cra_module = THIS_MODULE,
 		.cra_ctxsize = sizeof(struct qat_dh_ctx),
+		.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 	},
 };
 

base-commit: 48ecf78975245006171f255f16348187e1880476
-- 
2.44.0


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4165E39BFE7
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774371157; cv=none; b=BbSV/Ej6VtZyM0Wkan6d6A3sL1qaiNHbicEQ/W9ko3cKm5Gx1JSAhmjoV/sU9rJzrfJrA0RU9LKLiRYOVwwLQ7VWmZatbahoa6gtst3/1Q38DxbhSGaKnVCEmqz2nLZt/pyJKrbBqKUUKaRk7Rtb1um4EyXKWca4dPkXGPdmoII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774371157; c=relaxed/simple;
	bh=GpRSU2xfemRam71Ed4+2cC/oqm/WtC1tbFvvd4/0Kw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ctz/r2OCZVV+8qnKnq/v8I4sAMeS6AugPumXawBzSiGlyBXrboeeNrGjgfYvazgYnExbLCR2NRf5c2L2VL9PWVUYOnJU/F2H5RTZ2posUe3fRxRss6AlwZ7xuwkn6b5NdWVpo4HHDD0D1kNzVq8oC/q7wZxyN5qsi3YQgA8w/Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OHybgZca; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OHybgZca"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774371156; x=1805907156;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GpRSU2xfemRam71Ed4+2cC/oqm/WtC1tbFvvd4/0Kw0=;
  b=OHybgZcaReSbgTi3D7l08CpI4mzp7V7aGQJIDqx8jaLN4U852dVO0qzS
   v4GEhrqkkhtHHE5dllP4ZweA5ywb+SBYA4WIe5eWeEhg7AqOtSsRbXq6t
   85ZzzwLNGuRnfDzJqDipTeLAPfLtRQRJrYnT8Bav4Yr+pkEfFGIdxXwDL
   9tDcNgqIaorITJw9mkLYs+lvdqD7kVn4M3H/anSY1hb0A+K83ftLZACU7
   wkpIV+tLNUgxGB2g2WyBypP1/83DcO/VyNEowShLWmgzV5MOW4VfB7XVg
   a2pr2F7IFcBppT2PI75of8FRfKz7S3sBOSPinv8mc780FJkAG9dz1XjtM
   Q==;
X-CSE-ConnectionGUID: PWtWreCUS1KVmkWS0nhovA==
X-CSE-MsgGUID: QsDVREF7SBSqoshylD8zJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="75280804"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="75280804"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 09:52:35 -0700
X-CSE-ConnectionGUID: zUZNGDCwSiStK+GOsZNW3A==
X-CSE-MsgGUID: jZrzOMzoSwWB18QrZHPUIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="219539282"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by fmviesa006.fm.intel.com with ESMTP; 24 Mar 2026 09:52:34 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: [PATCH] crypto: qat - use acomp_tfm_ctx()
Date: Tue, 24 Mar 2026 16:52:11 +0000
Message-ID: <20260324165221.114280-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Replace the usage of crypto_acomp_tfm() followed by crypto_tfm_ctx()
with a single call to the equivalent acomp_tfm_ctx().

This does not introduce any functional changes.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_comp_algs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
index 8b123472b71c..1265177e3a89 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
@@ -130,8 +130,8 @@ void qat_comp_alg_callback(void *resp)
 
 static int qat_comp_alg_init_tfm(struct crypto_acomp *acomp_tfm)
 {
+	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
-	struct qat_compression_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct qat_compression_instance *inst;
 	int node;
 
@@ -151,8 +151,7 @@ static int qat_comp_alg_init_tfm(struct crypto_acomp *acomp_tfm)
 
 static void qat_comp_alg_exit_tfm(struct crypto_acomp *acomp_tfm)
 {
-	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
-	struct qat_compression_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
 
 	qat_compression_put_instance(ctx->inst);
 	memset(ctx, 0, sizeof(*ctx));
@@ -164,8 +163,7 @@ static int qat_comp_alg_compress_decompress(struct acomp_req *areq, enum directi
 {
 	struct qat_compression_req *qat_req = acomp_request_ctx(areq);
 	struct crypto_acomp *acomp_tfm = crypto_acomp_reqtfm(areq);
-	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
-	struct qat_compression_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
 	struct qat_compression_instance *inst = ctx->inst;
 	gfp_t f = qat_algs_alloc_flags(&areq->base);
 	struct qat_sgl_to_bufl_params params = {0};

base-commit: 91adbdbe829e8de435e24460960f434ce5a49611
-- 
2.53.0


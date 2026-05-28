Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7213FF89B;
	Thu, 28 May 2026 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779983945; cv=none; b=gV77eLnSX/eKmqxtRB9MoQeDRq4Va2u/n4wSFumJteDz0qOChOYrqQ+p6sxpIHZCQ5zAnWaT0PgoauvXAqGJna1fVIsfzaftG3AadYB0yNABm65TeB+6b5ISimfdTDDSdeDbVjiy7jcGDn47ihfw0x2JWyzGuY65e/Exz2h8AfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779983945; c=relaxed/simple;
	bh=XgCXlshtxklSakhCi1RUwGGvMxGLeHuGIfvywM6bf5s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JPFor1km2xcPAfqmFgnJl5hBoX6NaxQ01chfHLV46F7jq0vYCE9pMFDoISPk5tJxhL/JtI6KLXaszeP9AddcOCvFxRWW6WmfrcT1g7+pT2a0EtsyrcZqJtOAyEdG8KP7JNzzhpZoofgRhuvXds6bn1R8hta+5ydjiZbKVsstm0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BuS37Px+; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BuS37Px+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779983941; x=1811519941;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XgCXlshtxklSakhCi1RUwGGvMxGLeHuGIfvywM6bf5s=;
  b=BuS37Px+pPjXuhfRszN4WgZCUdTh1kY0RCJIfM7z+UqECm3MBX3f7Nnr
   l7vdFOf7EXOHCJQLVW6wvm/eShmeLPY5wHGOhqP6vRdrR+0clYjUi8Wdm
   c9QiGuQ/RjRl4e4mX8A8HWIK/VDARtOXbB/fZg9iF+Mx8WsM0k8B3/Xkv
   jiXfoxsTZ7wtQxMs7iCy1L4DwJoXtIlU8qslbFbeLl/n/7OlHGFCCn/V7
   kFiuhbdTIvpDPxUPlqOQvE86HkQpl/9wD9BupTjrgg1dgkqCxisxaZ3GT
   EV2eLDMgT6bC27uycEH5d+iNthkgjHnYWAM4/mBbg3D+uHdniuLogPxYJ
   A==;
X-CSE-ConnectionGUID: DU2SgLNgRuincEk+ZfQrDg==
X-CSE-MsgGUID: 0cZFJ3D1R32A2+AGb4KolA==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="79862914"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="79862914"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 08:59:00 -0700
X-CSE-ConnectionGUID: Of34VBRHSkaRAaxqYRAIGw==
X-CSE-MsgGUID: DW0qB+j6QpWBdnxdZFU33A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="241548892"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa006.jf.intel.com with ESMTP; 28 May 2026 08:58:59 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org,
	Ahsan Atta <ahsan.atta@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>
Subject: [PATCH] crypto: qat - validate RSA CRT component lengths
Date: Thu, 28 May 2026 16:57:44 +0100
Message-ID: <20260528155854.40858-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The generic RSA key parser (rsa_helper.c) bounds each CRT component (p,
q, dp, dq, qinv) by the modulus size n_sz, but qat_rsa_setkey_crt()
allocates half-size DMA buffers (key_sz / 2) and right-aligns each
component with:

    memcpy(dst + half_key_sz - len, src, len)

When a CRT component is larger than half_key_sz the subtraction
underflows and memcpy writes past the DMA buffer, causing memory
corruption.

Add a len > half_key_sz check next to the existing !len check for each
of the five CRT components so the driver falls back to the non-CRT path
instead of writing out of bounds.

Fixes: 879f77e9071f ("crypto: qat - Add RSA CRT mode")
Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
Tested-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index e09b9edfce42..75c15c8e41db 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -1085,7 +1085,7 @@ static void qat_rsa_setkey_crt(struct qat_rsa_ctx *ctx, struct rsa_key *rsa_key)
 	ptr = rsa_key->p;
 	len = rsa_key->p_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto err;
 	ctx->p = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_p, GFP_KERNEL);
 	if (!ctx->p)
@@ -1096,7 +1096,7 @@ static void qat_rsa_setkey_crt(struct qat_rsa_ctx *ctx, struct rsa_key *rsa_key)
 	ptr = rsa_key->q;
 	len = rsa_key->q_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_p;
 	ctx->q = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_q, GFP_KERNEL);
 	if (!ctx->q)
@@ -1107,7 +1107,7 @@ static void qat_rsa_setkey_crt(struct qat_rsa_ctx *ctx, struct rsa_key *rsa_key)
 	ptr = rsa_key->dp;
 	len = rsa_key->dp_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_q;
 	ctx->dp = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_dp,
 				     GFP_KERNEL);
@@ -1119,7 +1119,7 @@ static void qat_rsa_setkey_crt(struct qat_rsa_ctx *ctx, struct rsa_key *rsa_key)
 	ptr = rsa_key->dq;
 	len = rsa_key->dq_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_dp;
 	ctx->dq = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_dq,
 				     GFP_KERNEL);
@@ -1131,7 +1131,7 @@ static void qat_rsa_setkey_crt(struct qat_rsa_ctx *ctx, struct rsa_key *rsa_key)
 	ptr = rsa_key->qinv;
 	len = rsa_key->qinv_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_dq;
 	ctx->qinv = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_qinv,
 				       GFP_KERNEL);

base-commit: a36f3ace3504ad60981e21e3159655bcded4764f
-- 
2.54.0


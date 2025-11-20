Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292E2137923
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 11:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763638109; cv=none; b=jF0bhXuztdgh+Q0FkYafvn3Awaej/8/kvVpb70I+4wtDW7+VrpNb7HZcdED+phcU4GGIcHNYUSBdoxR+J1/0HbdsKJuuV8uu4yKK+yxBv9kC0N5LL3QDe+Xly0nN5a3RyVLdbyYYw1Ki/Sgeee3OwNoK57x4Jnhf08ONmOjIdRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763638109; c=relaxed/simple;
	bh=4Gy4UJF2o/HD0aI+1to6lVh6fKMLQO6d3/S7KNNALak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aNVsiZ4NZwGKpvUqjsUKOfMTujZesttOvUzcA9L9WAjewIq1v6a9gTrl2yJnpKz7aaXZTQpqeDIwkPzqliuVlwEFAWF6muyJQ7OQNV/zMPmn9tF9reVEs7cIEjbrNG3XSYGoqLApXfycNIGBTdEBtVRG2CJaVeLeCW6VuGDDP1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lzUduPLe; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lzUduPLe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763638108; x=1795174108;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4Gy4UJF2o/HD0aI+1to6lVh6fKMLQO6d3/S7KNNALak=;
  b=lzUduPLes/2SEUqGe3mRkbJmdn4XlcS1CDRw+Zu1XBINQ4R36aJODGBv
   wJr+ZkEsq2eqFOft+aujI5d3eNyEucPN8pUCUd1d7pDeiVFaRFFcL7srU
   Ww0tyGdhKVry3Cf0av9idVe9fL9ak3CfVR/7okk7ezEdi6X1diDtjrnBW
   KKDJUM8bCc8oFlyYN4a7i1ohv6YmMFy4dhfZ3PAsT1JOv3YKwWf5DGLHu
   4V/ddzTEz67Xw07kO+kG+2hoBSGeNuSGB4AUJPaRBqmjMIF8qzh6lM8hu
   ePXdP57/uzh7EbZpRGb7dr7L0GffnJLSL2bJr1H7DMJQ7dJsmIQi/qyiI
   A==;
X-CSE-ConnectionGUID: JaAuVmiMTBWAZkJ6yX0wag==
X-CSE-MsgGUID: htArdYUKRj+wXTKNuMYCdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="69320679"
X-IronPort-AV: E=Sophos;i="6.20,317,1758610800"; 
   d="scan'208";a="69320679"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 03:28:28 -0800
X-CSE-ConnectionGUID: k1LqcxndQ1ihkg1dGqXKAg==
X-CSE-MsgGUID: Na2/t/ndT0WqiQGYnG8ABQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,317,1758610800"; 
   d="scan'208";a="195822007"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa004.jf.intel.com with ESMTP; 20 Nov 2025 03:28:26 -0800
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Qihua Dai <qihua.dai@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - fix parameter order used in ICP_QAT_FW_COMN_FLAGS_BUILD
Date: Thu, 20 Nov 2025 16:29:23 +0000
Message-ID: <20251120162932.29051-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The macro ICP_QAT_FW_COMN_FLAGS_BUILD sets flags in the firmware
descriptor to indicate:

  * Whether the content descriptor is a pointer or contains embedded
    data.
  * Whether the source and destination buffers are scatter-gather lists
    or flat buffers.

The correct parameter order is:

  * First: content descriptor type
  * Second: source/destination pointer type

In the asymmetric crypto code, the macro was used with the parameters
swapped. Although this does not cause functional issues, since both
macros currently evaluate to 0, it is incorrect.

Fix the parameter order in the Diffie-Hellman and RSA code paths.

Fixes: a990532023b9 ("crypto: qat - Add support for RSA algorithm")
Fixes: c9839143ebbf ("crypto: qat - Add DH support")
Reported-by: Qihua Dai <qihua.dai@intel.com> # off-list
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index 85c682e248fb..e09b9edfce42 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -255,8 +255,8 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	qat_req->areq.dh = req;
 	msg->pke_hdr.service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_PKE;
 	msg->pke_hdr.comn_req_flags =
-		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
-					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
+		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_CD_FLD_TYPE_64BIT_ADR,
+					    QAT_COMN_PTR_TYPE_FLAT);
 
 	/*
 	 * If no source is provided use g as base
@@ -731,8 +731,8 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	qat_req->areq.rsa = req;
 	msg->pke_hdr.service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_PKE;
 	msg->pke_hdr.comn_req_flags =
-		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
-					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
+		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_CD_FLD_TYPE_64BIT_ADR,
+					    QAT_COMN_PTR_TYPE_FLAT);
 
 	qat_req->in.rsa.enc.e = ctx->dma_e;
 	qat_req->in.rsa.enc.n = ctx->dma_n;
@@ -867,8 +867,8 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	qat_req->areq.rsa = req;
 	msg->pke_hdr.service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_PKE;
 	msg->pke_hdr.comn_req_flags =
-		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
-					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
+		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_CD_FLD_TYPE_64BIT_ADR,
+					    QAT_COMN_PTR_TYPE_FLAT);
 
 	if (ctx->crt_mode) {
 		qat_req->in.rsa.dec_crt.p = ctx->dma_p;

base-commit: 8faa5c4b47998c5930314a3bb8ee53534cfdc1ce
-- 
2.51.1


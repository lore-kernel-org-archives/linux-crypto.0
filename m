Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA43C42050
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375222; cv=none; b=s9GB8Xy1QLq03aGpR8ompokmkQMZmVL/CsekxCFGMFz5CWCp7lL1Dsf10SIYwjNAqiuGDKQfsXxudh8mTXlUYIwg0xW27W1ZiSp9zVZ6+K/CAXDd2gBRzrJQfImPhj70LSdFEUQEkMeCJkkvATeJAowlNp/sF6+Lucb+/UtTkrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375222; c=relaxed/simple;
	bh=gJjjJvCcHWCDQY/NQfOgCpUEj6a2S6ztbzUGT0S7hiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=As73mAp4h2jorbOfaCMSzarIHx/P0GgJHvb1a/Bm77pCGebHNjiC10ickiGtW0sRI8CF7O7G61ZjvSjDcBolIKi+fnA5/xUtrB8/93zoqMuI8uvLiiRsWPNJClKcImcXC8Ypq4ZDOPE4yVLNPEH5BIdsV2HH9N1531cBiVwwZqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jH6VuNcx; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jH6VuNcx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774375221; x=1805911221;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gJjjJvCcHWCDQY/NQfOgCpUEj6a2S6ztbzUGT0S7hiI=;
  b=jH6VuNcxUrleHLyxbDZymI2v5H0b25SKWXbsXoB07ZPfd69TXABQn4o5
   abhBvflLcZXesqusjhBTkagGmnsjq8VcH6/vfHzHOVVJs5p3ywEX6o8Nc
   0D9pWl7PulBGXN/1778HZFfmY2fan2t3/0VPRPGcYNnJCauc9bibBSbkn
   rCFM4Qw8YwJbUh+p2HrL3dQiaGzt/S+HDw1TP6pxT2BMYUr2QAzgMQdv/
   pVB3t499UjfOOIEvX2QMLCgIlr2qEQrQD7IB2kSeocgoLTrlEgJ7m1Q/7
   WfQqMAcX6f390nK2o0dDOrR0ZmMtlQXrEIy4pfIDBdl9sm9SsIuwxX7id
   w==;
X-CSE-ConnectionGUID: VZCGFu0AS/OzFdVqQOAoIg==
X-CSE-MsgGUID: YtGWwWHPTbKcg13U/3e62g==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="74583909"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="74583909"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 11:00:20 -0700
X-CSE-ConnectionGUID: qB/AqOMISBqbJV+ob3nq5Q==
X-CSE-MsgGUID: pMDHWAkDT3GlkgvqlGkdTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="229200150"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by fmviesa005.fm.intel.com with ESMTP; 24 Mar 2026 11:00:18 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Wojciech Drewek <wojciech.drewek@linux.intel.com>
Subject: [PATCH] crypto: qat - fix compression instance leak
Date: Tue, 24 Mar 2026 17:59:40 +0000
Message-ID: <20260324180012.119237-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

qat_comp_alg_init_tfm() acquires a compression instance via
qat_compression_get_instance_node() before calling qat_comp_build_ctx()
to initialize the compression context. If qat_comp_build_ctx() fails, the
function returns an error without releasing the compression instance,
causing a resource leak.

When qat_comp_build_ctx() fails, release the compression instance with
qat_compression_put_instance() and clear the context to avoid leaving a
stale reference to the released instance.

The issue was introduced when build_deflate_ctx() (which always returned
void) was replaced by qat_comp_build_ctx() (which can return an error)
without adding error handling for the failure path.

Fixes: cd0e7160f80f ("crypto: qat - refactor compression template logic")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_comp_algs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
index 1265177e3a89..bfc820a08ada 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
@@ -133,7 +133,7 @@ static int qat_comp_alg_init_tfm(struct crypto_acomp *acomp_tfm)
 	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
 	struct qat_compression_instance *inst;
-	int node;
+	int node, ret;
 
 	if (tfm->node == NUMA_NO_NODE)
 		node = numa_node_id();
@@ -146,7 +146,13 @@ static int qat_comp_alg_init_tfm(struct crypto_acomp *acomp_tfm)
 		return -EINVAL;
 	ctx->inst = inst;
 
-	return qat_comp_build_ctx(inst->accel_dev, ctx->comp_ctx, QAT_DEFLATE);
+	ret = qat_comp_build_ctx(inst->accel_dev, ctx->comp_ctx, QAT_DEFLATE);
+	if (ret) {
+		qat_compression_put_instance(inst);
+		memset(ctx, 0, sizeof(*ctx));
+	}
+
+	return ret;
 }
 
 static void qat_comp_alg_exit_tfm(struct crypto_acomp *acomp_tfm)

base-commit: b2f9f3d273c4ccd73bf5ca1e422114d4b2f917ae
-- 
2.53.0


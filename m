Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8BE3F3285
	for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2026 10:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787566657; cv=none; b=dyRIxym3QRsX2yBjsAplrqd60udyhxAQiU/meIXYuoiMNbvhA8TR91V1qNbvFRllkuiV53+okcum8DF29W3xksOKKuH2lxSY4dM1IS3ODIEpn3KynKVNa+QbOkzaQ9wEfon05738q5R2egS0VPiEbztLTp2LOyVLaD0uyGbM+vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787566657; c=relaxed/simple;
	bh=mr5RIBgSEVfYIX8fGLuNhzkfFdOkbVsOMC+b+fVh6ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eKldWNsX73EvAoySyjM8XYIvkZtjCIKxVnMwcBMS1dYS0MWGWmq6f7ALXs78ppTxp6WAaNpaFfja2tVo0o3WY+5xrXpEb98epeepeG4AZTTBgpjagsNZBmZpJkZOUmqIcJJcvMULwJiY6wDxEGbi2IooSSrWAxjRhsCYOCUZGak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dn9E7Z1v; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dn9E7Z1v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787566655; x=1819102655;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mr5RIBgSEVfYIX8fGLuNhzkfFdOkbVsOMC+b+fVh6ZE=;
  b=dn9E7Z1vooiNEU7f/6KF6Upf65JdgfSeU2WCiKJUSJ51DhzwbtKxikB5
   zrEodDn0k2rBEhGxHHbt7zU3D2kokEZsVO+l8Ig+mkq/SEfR963oq5XYq
   y5leP3nXMn3ffAIasWqq4xdVA/FMc2Qy8bht6uAZq4EqYwcdtwuWaL86v
   4nYpryNGhDVuAcVYCDxHN45Ao114BrQa0fWwMsdkAn7mlUy/K+304qnP4
   JJTeAkx/UYBCizqvRmaYm/31f5WawOZIgBOhqLlNhlAaeyjcXra3hb+IA
   aaf8tvcMif9VSxuoKuwL305tH6FqSrE4LUcPSjKuET1y6uEtrPLBCXUCs
   g==;
X-CSE-ConnectionGUID: uekJybkyQeWdRM43ZpFPuA==
X-CSE-MsgGUID: su5kTfifSx65dBsmxsgJaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11884"; a="99174515"
X-IronPort-AV: E=Sophos;i="6.25,240,1779174000"; 
   d="scan'208";a="99174515"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 03:17:35 -0700
X-CSE-ConnectionGUID: GJyie9EuSBmyMr7QkUxoZA==
X-CSE-MsgGUID: Ks3keJ7EQBOsls1VqZKXVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,240,1779174000"; 
   d="scan'208";a="262670405"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa006.fm.intel.com with ESMTP; 24 Aug 2026 03:17:33 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - avoid OOB read when stripping RSA leading zeros
Date: Mon, 24 Aug 2026 11:17:44 +0100
Message-ID: <20260824101744.382099-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The logical AND operator uses short-circuit evaluation: the first
operand is always evaluated, while the second is evaluated only if
the first is true. Because the first operand dereferences a pointer,
it may cause an out-of-bounds access before the bounds check in the
second operand is evaluated.

Resolve this by checking the vlen prior to the pointer being dereferenced.

Fixes: a990532023b9 ("crypto: qat - Add support for RSA algorithm")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index 75c15c8e41db..aa2ea563f25f 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -987,7 +987,7 @@ static int qat_rsa_set_n(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1018,7 +1018,7 @@ static int qat_rsa_set_e(struct qat_rsa_ctx *ctx, const char *value,
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	const char *ptr = value;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1044,7 +1044,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1067,7 +1067,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 
 static void qat_rsa_drop_leading_zeros(const char **ptr, unsigned int *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.50.1

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.


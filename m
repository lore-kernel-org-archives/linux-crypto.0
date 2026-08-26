Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DE9272E56
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 09:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737165; cv=none; b=fMQEuyAl3xBZtFRgxA3cqpelA9j0qZrmPEE8n/SLNsGcGcyLC2c/kkkn/kgQBLlEVmPFHtKH8VPpYkyS966/L4bjFpZeB9P3zUaS0ccULHHqcSJc9K7SLsS+e9IFhIqKizBnoHD129ruxN7CBEMp16CGprcyM+KVikW6MrgAroI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737165; c=relaxed/simple;
	bh=LgnONb3m2yDCCnC8fjxFXFgwu6xaTvkE4SrdQ95BQRE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EOHNS7KQi/o33S+SddowryDQK0QIvPDyc2FomSbISDEjKgTkXZx79ZufgoM7B+tungqxHXUYiGoLBF5s8qQczauXnyfKni49DHFrPNL1Gpx28uNtnesV1vZ+47VlABszuQU9andxFft4dD3gLblTtYAkA45lfKpPxWLC8T6OzWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n89lF6cU; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n89lF6cU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787737163; x=1819273163;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LgnONb3m2yDCCnC8fjxFXFgwu6xaTvkE4SrdQ95BQRE=;
  b=n89lF6cUJUU4U2ZxfrzSHtFyldJCbcT3p8/kw54A4NuNvMMDdVWNt4+e
   ewwdHhl7o/UvR/skRd4yfCMCYAoh65IJ5E4mF0+0c53f/RLNtmRyGv/Cg
   emL3VuOqyWc4fuqhiavq9VSpcHMLX3jYcczeJVCA4FX9NtZqfBQV2DSJP
   77x/eMDgPu/rzqzxBbNmykll3dMVpXaCFuo4VW+HpMMEZfRXq1mCVjooi
   h5povQG7c9GdR+5rOUuqRhdiWswyhsDnX8b//ewL0zi8KlMUJJi66qR3J
   YQnLgrIP1+YagIzff4CqLG9XhvE6vfAkCbo2k8mJgdP1ugdeHtwKDd2dC
   Q==;
X-CSE-ConnectionGUID: nv2VZZP2QIWk8Sq0SfHFUw==
X-CSE-MsgGUID: rbd4uUUKSg+7c4HGnZmgJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="88419118"
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="88419118"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 02:39:22 -0700
X-CSE-ConnectionGUID: TXd04RvaSOWoUACgpJg0Pg==
X-CSE-MsgGUID: Sf1GgL8aR+2i69wV4rGC+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="263237417"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa006.fm.intel.com with ESMTP; 26 Aug 2026 02:39:21 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - release instance on DH fallback allocation failure
Date: Wed, 26 Aug 2026 10:39:31 +0100
Message-ID: <20260826093931.445639-1-ahsan.atta@intel.com>
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

qat_dh_init_tfm() acquires a QAT crypto instance before allocating the
software fallback transform. If fallback allocation fails, the instance
reference is leaked and the device remains permanently in use.

Release the instance before returning the allocation error.

Fixes: 5d5bd24f4155 ("crypto: qat - implement dh fallback for primes > 4K")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index aa2ea563f25f..1049c583f84f 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -535,8 +535,10 @@ static int qat_dh_init_tfm(struct crypto_kpp *tfm)
 		return -EINVAL;
 
 	ctx->ftfm = crypto_alloc_kpp(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(ctx->ftfm))
+	if (IS_ERR(ctx->ftfm)) {
+		qat_crypto_put_instance(inst);
 		return PTR_ERR(ctx->ftfm);
+	}
 
 	crypto_kpp_set_flags(ctx->ftfm, crypto_kpp_get_flags(tfm));
 
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


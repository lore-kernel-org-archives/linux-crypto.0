Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241A014A83
	for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2024 15:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712849469; cv=none; b=kPGXw1X4RrXnZD3CLu+FmhjZTFLF5EdwWts8p+396h2nv7GrTyHjt7Yte6dv28ePLwvKt85YRNqtbGzVJAOofnlQYbJ+Tf43bxXKWHIblZOIFoL7vYG3DiUBvurfWPwuBtjIqwebwap9SZ13Khn8gwSAA2Y9lPgzagQVvEWmdH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712849469; c=relaxed/simple;
	bh=KZTxlNi/B40PE/etAgygnfvqYna8Yo5iqHWxrTOx2zs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oWvOKAZZfqwYk1Hr2m+xsJUZ++uBNogh3evWQeW+RWyMYgoCjM+kYvfkurfu+VKuvHQO5vmV3opL5Z+sEY8oQrkBmUoruRitx9D4T0OaXO13g0EmOnl9muODJt2lNEEReW0QwwZOkwoSBGSZLBCqshUwYU7AGis7/B1Fn7odQYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cWsqWhtb; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cWsqWhtb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712849468; x=1744385468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KZTxlNi/B40PE/etAgygnfvqYna8Yo5iqHWxrTOx2zs=;
  b=cWsqWhtbT88VR7MGOj+GbAZZ9+e+6vObc7I7s1S3n2wMJEFr5RxAMuKt
   rZkiJX54OOsypK/IE+GO4k5TCfimwY1AI1IryzIA2K3srMz//vbedTTKz
   4RlAl76rgpg+BBd9GTqFl7rX+u2HnrbMpK6G/0sKXQ096RFRb4F+s8Mq5
   We4xVw83RBk82GqZ8c3Cv2zO208lCWlapkGgAP+qFwCbdUqqyJ3QYWENs
   WAg7iqJnEb2FA303CtT+biDaXGlrx87fWlzjJ+/ZTNdzLeTdmmExzZ1Us
   HTxwMkSiuiys4Vene7/hQm8BBamcgEmiwaCqHukaThXSXCLSlgA684hg9
   g==;
X-CSE-ConnectionGUID: kFw8J6fwTj+nbCle22h/KQ==
X-CSE-MsgGUID: mwS1xp31QQ+ylcY8nUJwcw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8142572"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="8142572"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 08:31:07 -0700
X-CSE-ConnectionGUID: 2QXTvmUXT/665R5cCXwHsQ==
X-CSE-MsgGUID: 0H8obsxLQm2Qi+8TqSfiVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="25584859"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by orviesa003.jf.intel.com with ESMTP; 11 Apr 2024 08:31:07 -0700
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/2] crypto: qat - improve error logging to be consistent across features
Date: Thu, 11 Apr 2024 16:08:21 +0100
Message-Id: <20240411150819.240050-2-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240411150819.240050-1-adam.guerin@intel.com>
References: <20240411150819.240050-1-adam.guerin@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit

Improve error logging in rate limiting feature. Staying consistent with
the error logging found in the telemetry feature.

Fixes: d9fb840 ("crypto: qat - add rate limiting feature to qat_4xxx")
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index 65f752f4792a..346ef8bee99d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -1125,7 +1125,7 @@ int adf_rl_start(struct adf_accel_dev *accel_dev)
 	}
 
 	if ((fw_caps & RL_CAPABILITY_MASK) != RL_CAPABILITY_VALUE) {
-		dev_info(&GET_DEV(accel_dev), "not supported\n");
+		dev_info(&GET_DEV(accel_dev), "feature not supported by FW\n");
 		ret = -EOPNOTSUPP;
 		goto ret_free;
 	}
-- 
2.40.1


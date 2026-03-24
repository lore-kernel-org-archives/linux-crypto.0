Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD2F369208
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 18:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375653; cv=none; b=InEHVIBSMuPqqQisuIqRF6MwoOISDXr8ELua7sZoR7samWWg7MQ96G5BiiGdnv3V2NoZeTeTA72Spic1NazrYWO8QaqaN3LS1Nenl/voZAWKcRNiTRh/3ha4xxNBgrgbM74sDq4WCMuhr2/MNlcykkNP97YwYC32NIPWCP98fl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375653; c=relaxed/simple;
	bh=GB2nrhGCv/U1uXk5LA59GY9aY0aaVrqs0rL0MKa8V6w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qkszaj/evFOYftl6UfM/Vln1tIwO8nGgZdA7ZbI4bu1FTXpiLrAhJpHhBpuIi2gNp/hG+Ya8x5qbvHEJCQXRHMyq4mqky1eI/B3WbzG9Z5cf0keTMMS9yRiS4VEPX+AeWZqvDKWPQzfbo0LPdxMptl0eLEG9laKktQOw1FA7ghM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gTkSydPp; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gTkSydPp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774375650; x=1805911650;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GB2nrhGCv/U1uXk5LA59GY9aY0aaVrqs0rL0MKa8V6w=;
  b=gTkSydPplSggd+uFJBR+AwTTgHctw7DS0IvVPqJSNVjN7SWCGy6BNgpy
   Miz/V5FF3w9PD+lQq/PH87LCBg0LaMFbMi3xJh6v3XWphaWZFBPWLDiJ0
   dRVJjcul8+wj/l1i+pp1si6go284dP3K4RsFSdDhfEL3f1Inei7wPcm22
   WisA5VLQwVhf58lW+VSXBBFs3ZYiYb/J3Y/JYmaZGu8ROsb5wDfe2F/5U
   hZxyrtxK/4tLo8aFfQPWBRZiZtQNBUE0030RrNEtxssg0bC7maOnPYO0b
   gh4pcQ3GWSKPyIXeOLFEBqmKdDREdWdCYw0F3VS9oEHfi43SW2IJo2Tk9
   Q==;
X-CSE-ConnectionGUID: 8L4d33uITMSVQUTd2tq6mA==
X-CSE-MsgGUID: 8WUzQYtBSheOfb3Q9Su34A==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="98025836"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="98025836"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 11:07:30 -0700
X-CSE-ConnectionGUID: XQA3ueSvRLC/9cvLNQb8tg==
X-CSE-MsgGUID: U6tGKF2ETvKWgH5zjfxr4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="228482955"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa003.jf.intel.com with ESMTP; 24 Mar 2026 11:07:31 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Wojciech Drewek <wojciech.drewek@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: [PATCH] crypto: acomp - fix wrong pointer in acomp_reqchain_done()
Date: Tue, 24 Mar 2026 18:07:09 +0000
Message-ID: <20260324180721.120175-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

acomp_save_req() stores a pointer to req->chain in req->base.data:

    req->base.data = state;  /* state = &req->chain */

When a driver completes asynchronously, acomp_reqchain_done() receives
this pointer as its data argument. However, it incorrectly casts the
data pointer to a struct acomp_req.

Use container_of() to recover the enclosing acomp_req from the chain
member pointer.

Fixes: 64929fe8c0a4 ("crypto: acomp - Remove request chaining")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 crypto/acompress.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 1f9cb04b447f..deb50c078f80 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -9,6 +9,7 @@
 
 #include <crypto/internal/acompress.h>
 #include <crypto/scatterwalk.h>
+#include <linux/container_of.h>
 #include <linux/cryptouser.h>
 #include <linux/cpumask.h>
 #include <linux/err.h>
@@ -251,7 +252,7 @@ static int acomp_reqchain_finish(struct acomp_req *req, int err)
 
 static void acomp_reqchain_done(void *data, int err)
 {
-	struct acomp_req *req = data;
+	struct acomp_req *req = container_of(data, struct acomp_req, chain);
 	crypto_completion_t compl;
 
 	compl = req->chain.compl;
-- 
2.53.0


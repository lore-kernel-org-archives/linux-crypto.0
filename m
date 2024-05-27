Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6174715E5CC;
	Mon, 27 May 2024 13:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716816387; cv=none; b=d9kGHB6m8F4WiO1XZUZUqGWULiuUVKMpf6+x8rFwuRIUbKbADMUexJLEDmnP4v7jZ2gKWz4B7Gk1N6psy7o3DbEl8DlL4or3Yyd+DaylXecDTW95AEJF7zX7vx8TAgF/HrHRouCkuAU4QdALOpOJWEOVi6jrXfVV2capMJ382yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716816387; c=relaxed/simple;
	bh=CItaBbgg6JwWwi5IdRPDwkpBgMhptPIUuGPvIV9glqM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=WxZ7vZOYCHzn1Rly0XAfaQPmOAolYzrYenQWOELXnSB8sb2YhaVP06VmETAR5Tky6cYHdLk+TgVZMxaFGgVE22x44YEMyrP9Wah2GR30I9KxrlkjB0DnWxJHeoNFJzBAEfbanXhUcYH1oP2Tb9u4+5frAfl4hGvCU4xa9PCQeiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y2D54uTW; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y2D54uTW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716816386; x=1748352386;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CItaBbgg6JwWwi5IdRPDwkpBgMhptPIUuGPvIV9glqM=;
  b=Y2D54uTWEhAAjwR8xjgIK7aRmWRnQFytgdGO1/mfIh1yB7PyixBFhRyO
   8jJ6Elcv8UiwJyKzMcFuKE2OqUFigOVeI+ECIF7x6RNecwu3LXSdHHQUN
   aVtCH1URzmM6fiIQh3zgUrh/1B0I4DqrZQ1DTfINwJDjvKtAxopCZw6BJ
   xovAv3Cyffq0sKX0HNfPQbe2Fvd/KQ6yqFz6iw4A2R69uxZm8mkkNCT/Z
   KRAb8NsVbntx/hWbcN187wsIZWJu0f1ubEJOQ9E5lVlNSu+IDp4ssGtDv
   BX3UUK/WBeoIoxBzsfbAePtDluBVfGYPMlj/DDkdU/TuxFqteioMlJ8Rt
   A==;
X-CSE-ConnectionGUID: L7kohyR4RR2LmZPP2IaXyQ==
X-CSE-MsgGUID: kpf9QdxaQfOIi2JCUoaxCg==
X-IronPort-AV: E=McAfee;i="6600,9927,11084"; a="38520316"
X-IronPort-AV: E=Sophos;i="6.08,192,1712646000"; 
   d="scan'208";a="38520316"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 06:26:26 -0700
X-CSE-ConnectionGUID: yB0ThovoSDu9Ib2iOE5ENg==
X-CSE-MsgGUID: ZGSNm+4qS4+b4kH9UZ9xVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,192,1712646000"; 
   d="scan'208";a="39206646"
Received: from unknown (HELO localhost) ([10.245.247.140])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 06:26:23 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Michael Buesch <mb@bu3sch.de>,
	Andrew Morton <akpm@osdl.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/1] hwrng: amd - Convert PCIBIOS_* return codes to errnos
Date: Mon, 27 May 2024 16:26:15 +0300
Message-Id: <20240527132615.14170-1-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

amd_rng_mod_init() uses pci_read_config_dword() that returns PCIBIOS_*
codes. The return code is then returned as is but amd_rng_mod_init() is
a module_init() function that should return normal errnos.

Convert PCIBIOS_* returns code using pcibios_err_to_errno() into normal
errno before returning it.

Fixes: 96d63c0297cc ("[PATCH] Add AMD HW RNG driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/char/hw_random/amd-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 86162a13681e..9a24d19236dc 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -143,8 +143,10 @@ static int __init amd_rng_mod_init(void)
 
 found:
 	err = pci_read_config_dword(pdev, 0x58, &pmbase);
-	if (err)
+	if (err) {
+		err = pcibios_err_to_errno(err);
 		goto put_dev;
+	}
 
 	pmbase &= 0x0000FF00;
 	if (pmbase == 0) {
-- 
2.39.2


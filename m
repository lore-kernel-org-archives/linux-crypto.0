Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AB21BC2A;
	Wed,  3 Dec 2025 03:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764731947; cv=none; b=IvLPHXNHgXnVeqLgErHetr/WIwAqDEV6viBiQjpxMqYJYHV2rYxwuRwIm62Exwr8JcRY9mPri6/8ldqgkNShXpfdo1pO0W5aZXuo6408swlrJjrF8NdGTHdjbYnuCgkHUaGR9y4qoYw3m1Dv1/XtzUw4DStPEYo2sI3hl9fUbLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764731947; c=relaxed/simple;
	bh=ULWsoHB44epi2/ZleJGYGNAUAK4cCs0hxt1ionS3+CA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g7MiSWAWK5nroH9hJuxaVrawtQm2t//F+V4ThtE1ZBeu6rk00YL1PI3qUAFzQnVPvO+kYnwydL5iritX/21LBSv7rcslm1CplC/YuxqUR5nLglaABRL4AdJZENQNLueEw1H9/AB2GFrHlYnU72+a4eQLfHzlkqM6WDHfwPc5cxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JVPKlwEF; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JVPKlwEF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764731945; x=1796267945;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ULWsoHB44epi2/ZleJGYGNAUAK4cCs0hxt1ionS3+CA=;
  b=JVPKlwEFEWc9TSRUqilK6aKynueYTzP7UYl5WPNBXBM3nOuHmtQHpCmb
   23aEhvh9wuw7aX0809XCtThTKcglz3i0OJoaUWwYAcJTwTBnbea2bKZj8
   lNef+DYKEBl2PLN/VX1UmuW7G4sp6WMfc3Ys8Gmg2zYDTKGsTX7X8G6dp
   cBJnjR57YW4jfHOj2T5qriqfrbq43DpvUloY6g1TVRjl4wA6g/OulY+XS
   yd/Pg20JNTKfIFeOXtw2+kaL4/OTg/LE4cx4fPyk+DKWKtlOHvCiWxwaL
   cgRvFOFyEaJheL56mJCrGnWnPgjSLKwjMhDkTzMaA8V42QRtGx/f499sg
   g==;
X-CSE-ConnectionGUID: zZ3MKt5hTRaNEcLKkHOmMw==
X-CSE-MsgGUID: j7ISG1kCRt6IsLBdwGhKIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="65721132"
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="65721132"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 19:19:05 -0800
X-CSE-ConnectionGUID: EV4JCPUaRbmtB5pak/0+LA==
X-CSE-MsgGUID: C5RzoMg4SweQ78fHGdK0qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="194444999"
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by fmviesa006.fm.intel.com with ESMTP; 02 Dec 2025 19:19:04 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>
Subject: [PATCH] crypto/ccp: Fix CONFIG_PCI=n build
Date: Tue,  2 Dec 2025 19:19:48 -0800
Message-ID: <20251203031948.2471431-1-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It turns out that the PCI driver for ccp is unconditionally built into the
kernel in the CONFIG_PCI=y case. This means that the new SEV-TIO support
needs an explicit dependency on PCI to avoid build errors when
CONFIG_CRYPTO_DEV_SP_PSP=y and CONFIG_PCI=n.

Reported-by: kernel test robot <lkp@intel.com>
Closes: http://lore.kernel.org/202512030743.6pVPA4sx-lkp@intel.com
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: John Allen <john.allen@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/crypto/ccp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index e2b127f0986b..f16a0f611317 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -39,7 +39,7 @@ config CRYPTO_DEV_SP_PSP
 	bool "Platform Security Processor (PSP) device"
 	default y
 	depends on CRYPTO_DEV_CCP_DD && X86_64 && AMD_IOMMU
-	select PCI_TSM
+	select PCI_TSM if PCI
 	help
 	 Provide support for the AMD Platform Security Processor (PSP).
 	 The PSP is a dedicated processor that provides support for key

base-commit: f7ae6d4ec6520a901787cbab273983e96d8516da
prerequisite-patch-id: 085ed7fc143cfcfd0418527cfad03db88d4b64ec
prerequisite-patch-id: c1d1a6d802b3b4bfffb9f45fc5ac6a9a1b5e361d
prerequisite-patch-id: 44c6ea6fb683418ae67ff3efdb0c07fda013e6b2
prerequisite-patch-id: 407daf59d54ecebcb7fefd22a5b5833e03c038e4
-- 
2.51.1


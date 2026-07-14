Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C30C31C56D;
	Tue, 14 Jul 2026 04:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784002271; cv=none; b=JCktXjD+QVRuA0KxNflJySFVGNMx/wxcNZ3HSmQ2QNzGi3LmnNfe2HQII9+M1Qhv1SIGoJCQmn24R4HPudkstu8wfo5gzatRNGFD1lYEk9Qy4hxfoLuXO06gnarSeU/aSqe+HmCJDgDmkvc/ZU6XOv724VLwtx6KN0CsR/pqAgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784002271; c=relaxed/simple;
	bh=EkMrq2fq+kdV/RvjKR48hty+vUzZfNwFC7L29I8jEjE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=j1jPx4cHAwCRYZlEvupY6FkyUOJ5j3Y8mQDOWPYvEFL98Na8+sNOpqKrJEn48p4cXuU+tcKCaq3Ra9v5JkkMkwqNpnQjqs2CQLkXNhyO9reJFMmKgtwmUVZt0bfb0zrMF4if+oe1hyfgmIFTElq45FMJD8QiLtS1b/85fvDaf5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cZKudavU; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cZKudavU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784002270; x=1815538270;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=EkMrq2fq+kdV/RvjKR48hty+vUzZfNwFC7L29I8jEjE=;
  b=cZKudavUNa5jVHfiZuCqaC89C4J/GMnZ3wGSC+AdPVkgf7+98gY0l3e1
   hyeXyxCr+9DK4Qdcm/tSQiB93AcHk0NepmEPyEP1Iu1Cy7vq4cSaYTiMm
   W2/0cawRvubzdBCEvbyDzBLbEs/6rjhtSPnHqiLdhQAvl2l8cT4GtDVq6
   PJh+ZvXWlnTmbhVepkkPUQSOQKRcCA8/dZqL0w2py5UFX+CoyCjHVoZHO
   OhyYkbNeyCnj64CGiVzzk3zgc3JIFGQQ3L4Pn4JS6ZTpaRw6dM5Q08JiA
   OdYdjmlST0joGeCZfaYtJJ5NRwSGW7cPl2QYNITuQW1sv6I+VPZyajK6k
   w==;
X-CSE-ConnectionGUID: IlOg9RR0S7SEoz9x6/JfOQ==
X-CSE-MsgGUID: iMKno+jgR6OwrF85NeNQvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="94970471"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="94970471"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 21:11:09 -0700
X-CSE-ConnectionGUID: 5tmtqeLTRY6+6KzlpEmOwA==
X-CSE-MsgGUID: fIV8zmubSaOlJ6p/83A+9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="249383510"
Received: from vcostago-desk1.jf.intel.com (HELO [10.88.27.144]) ([10.88.27.144])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 21:11:08 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH 0/4] crypto: iaa - Fixes for multi entry SG lists
Date: Mon, 13 Jul 2026 21:10:52 -0700
Message-Id: <20260713-iaa-crypto-fixes-zswap-v1-0-65cac23c684d@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMywqDQAyF4VeRrA0YRQt9ldJFHDM2XegwsV4qv
 nvHuvw4/GcHk6hicM92iDKr6TgkUJ6Be/HQC2qXDGVRNsWNKlRmdHEL04heVzH82sIBva9bZqm
 IOoIUhyj/ObWP52X7tG9x0/kGx/EDXCZXRXoAAAA=
X-Change-ID: 20260713-iaa-crypto-fixes-zswap-ff5baae311d1
To: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>, 
 Frank Li <Frank.Li@kernel.org>, 
 Kristen Accardi <kristen.c.accardi@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784002267; l=1925;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=EkMrq2fq+kdV/RvjKR48hty+vUzZfNwFC7L29I8jEjE=;
 b=VXL0glBcu49y0XSDNxfckPJ4DcurDH/Pajc594Rz9rPh4ZE6rMbZC3jJ1XB9ipoE2UE6O8rnM
 VkFb1KfFnzOBcEiezRttOMVS+HzGX8r9ud84iWfljiNwlh6GUewpjrB
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

Since commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs
from zsmalloc"), iaa_crypto started seeing some failures with
multi-entry scatter lists.

For that we introduce software fallback, in patch 2/4, to iaa-crypto
when SG lists have more than one entry, for both input and output.
Patch 4/4 adds a bounce buffer so small/simple requests can be
linearized and sent to the hardware. This recovers most of the
performance.

Patch 1/4 updates the default resources reserved to iaa-crypto so more
engines are associated to the iaa_crypto group, resulting in better
utilization by default. Patch 3/4 fixes so software requests are not
double counted. As the idxd changes only affect iaa_crypto, sending
them here makes more sense.

It should be noted that as the software and hardware implementations
have different expectations for the window size, something like patch
[1] or the future 'set_params()' API are needed to verify that patch
2/4 works without patch 4/4.

[1] https://lore.kernel.org/linux-crypto/20260326100433.57324-1-giovanni.cabiddu@intel.com/

Cheers,

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
Giovanni Cabiddu (4):
      dmaengine: idxd: assign all engines to group 0 in IAA defaults
      crypto: iaa - fall back to software for multi-entry scatterlists
      crypto: iaa - avoid counting fallback decompression bytes
      crypto: iaa - use bounce buffer for multi-sg decompress input

 drivers/crypto/intel/iaa/iaa_crypto_main.c  | 236 ++++++++++++++++++++--------
 drivers/crypto/intel/iaa/iaa_crypto_stats.c |  11 +-
 drivers/crypto/intel/iaa/iaa_crypto_stats.h |   2 +
 drivers/dma/idxd/defaults.c                 |  12 +-
 4 files changed, 186 insertions(+), 75 deletions(-)
---
base-commit: b73b71df4cb4ca241165ad31218c82dfe489147c
change-id: 20260713-iaa-crypto-fixes-zswap-ff5baae311d1

Best regards,
--  
Vinicius


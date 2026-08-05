Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98903EFFCA;
	Wed,  5 Aug 2026 21:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785964804; cv=none; b=UjBrIZfqWI8RY4RYg3KmQvwMKAGAYwA/00bhO5Sv/WiezbcISjfRXvWOp0pl/MyPxgbtcMCxiN1zO3tonwjMWBENDsZpJanW6MTOzhOk+DgURRaS6mWjbE6lGhuAsiImq0dl5GGrBeWQXa3zwxSQRFgZTLYe+tj/G12jOOMyvHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785964804; c=relaxed/simple;
	bh=yLwMnlNSw//4tnyrhYlccaXrbpuYjZpqCoT2+7zppaE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=cTjlVRcbocjb/o6TNZYesIkQjdU3xRXcxmxlQLJMjZNB4JQGe1wemBN4waPpNkzs6GBlGVueIo6Dir9JZS987yLI5wptgtPG8x2yB2QrPoT573UitdsgjcxSsYVoNCKwa57QEezHPveg/1kudQp+tB5aEcfOECc53Tbg4GB5194=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TEUiwWjo; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TEUiwWjo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785964796; x=1817500796;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=yLwMnlNSw//4tnyrhYlccaXrbpuYjZpqCoT2+7zppaE=;
  b=TEUiwWjovLMDl7VjaYqRZYDEAWk47m0UkuRnn9xBeBSyfCCn0H6fHnQD
   x/jgbob/uhe4y1mW0uvY1veDSOU3A/lFPBKdYgQMh/PsXjgVUanaeC7uN
   f4Jc+V94soOrFcthToEk1uoe1hUXpJKUUjf1SzkJnGetvtHcNyFd3TqtQ
   ZX4jVvlpojagi6TabK1iAeTaUTWFoIhdg9mmS/f+nu22bbGhF9AlxVow+
   TvtGEdDdZCpSvlfmwQ+0xxuIGfQIhi5lgmO+s8Dgc03Wa1IR4NpS/1pGL
   9W0GljbzRmvkJs7GPm5IDp/FysB7hiPC3nE4Hm05jQXx+Q22gHmrh0YvX
   w==;
X-CSE-ConnectionGUID: Y9BrOq1dT+CMAwh40Pzd0A==
X-CSE-MsgGUID: Te93CXjAQ+emhsJl3QLitA==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109341666"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109341666"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:49 -0700
X-CSE-ConnectionGUID: A3rKib6gSmK4UHofe+c+Rw==
X-CSE-MsgGUID: vZbIDPIFSKSm+y2iz3U5lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="300138472"
Received: from vcostago-desk1.jf.intel.com (HELO [10.88.27.144]) ([10.88.27.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:48 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH v2 0/5] crypto: iaa - Fixes for multi entry SG lists
Date: Wed, 05 Aug 2026 14:19:21 -0700
Message-Id: <20260805-iaa-crypto-fixes-zswap-v2-0-55c02694f499@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNQQ6CMBBFr0Jm7RhaBI0r7mFYlGGQMUpJW1Ek3
 N2CB3D58v/7fwbPTtjDOZnB8ShebB9B7xKgzvRXRmkig051kR5VhmIMkpuGYLGVN3v8+JcZsG3
 z2hjOlGoURHlwvMXRvVQ/9s/6xhTWtbXRiQ/WTdvzqNbe35NRYYpFToZ0RsXp0JTSB77vyT6gW
 pblCwXCDi/OAAAA
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
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785964788; l=2761;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=yLwMnlNSw//4tnyrhYlccaXrbpuYjZpqCoT2+7zppaE=;
 b=8wyWLI2MIScACUwSKC+fFFriW0co+cNdWs2G6b60bAyZ0Yxqc80zerIa9h5aySsqK3+CzGpP0
 nTmVufnsCL2BlS+zlloDjNgWHCLRBDy0kBNbqFHbKPUmyq2d9CbqdAb
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

Since commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs
from zsmalloc"), iaa_crypto started seeing some failures with
multi-entry scatter lists.

For that we introduce software fallback, in patch 2/5, to iaa-crypto
when SG lists have more than one entry, for both input and output.
Patch 4/5 adds a bounce buffer so small/simple requests can be
linearized and sent to the hardware. This recovers most of the
performance.

Patch 1/5 updates the default resources reserved to iaa-crypto so more
engines are associated to the iaa_crypto group, resulting in better
utilization by default. Patch 3/5 fixes so software request "bytes"
are not counted as hardware "bytes". As the idxd changes only affect
iaa_crypto, sending them here makes more sense. Patch 5/5 fixes a
pre-existing issue pointed out by sashiko, that could cause data
corruption when a hardware error is reported.

A potential use-after-free issue when a descriptor submission times
out, pointed out by Sashiko, still remains and will be handled on a
future series.

It should be noted that as the software and hardware implementations
have different expectations for the window size, something like patch
[1] or the future 'set_params()' API are needed to verify that patch
2/5 works without patch 4/5.

[1] https://lore.kernel.org/linux-crypto/20260326100433.57324-1-giovanni.cabiddu@intel.com/

Cheers,

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
Changes in v2:
- Added patch 5/5, for a pre-existing issue, that touches the same
  code paths as this series (Sashiko);
- I took an old version of Giovanni's patch 4/5, new version is
  simpler to read; because of changes did not take Dave Jiang's
  Reviewed-by;
- Added the missing Signed-off-by tags (Dave Jiang);
- Link to v1: https://patch.msgid.link/20260713-iaa-crypto-fixes-zswap-v1-0-65cac23c684d@intel.com

---
Giovanni Cabiddu (4):
      dmaengine: idxd: assign all engines to group 0 in IAA defaults
      crypto: iaa - fall back to software for multi-entry scatterlists
      crypto: iaa - avoid counting fallback decompression bytes
      crypto: iaa - use bounce buffer for multi-sg decompress input

Vinicius Costa Gomes (1):
      crypto: iaa - unmap dst before software fallback on decompress

 drivers/crypto/intel/iaa/iaa_crypto_main.c  | 270 +++++++++++++++++++---------
 drivers/crypto/intel/iaa/iaa_crypto_stats.c |   9 +
 drivers/crypto/intel/iaa/iaa_crypto_stats.h |   2 +
 drivers/dma/idxd/defaults.c                 |  12 +-
 4 files changed, 201 insertions(+), 92 deletions(-)
---
base-commit: 947d62c094367ef6064907d570b47612cd579df6
change-id: 20260713-iaa-crypto-fixes-zswap-ff5baae311d1

Best regards,
--  
Vinicius


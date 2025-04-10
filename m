Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07A51C6FE8
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744298580; cv=none; b=NyHg0uY6hJ89x2uE3CeV+2fNRDHJM6nDW6XuqPhwouqToTcX8Z6DbCTQ1rQUuu8jNvrQIZLsqcOOnN43cToKt3cd3HYb9x2us2B+jXmo+ED81DyXnC5r3IuSZGA/YvitE723CPkOBF/jfXGr6rVGmng5ZdnZSoEyqLUrj7/7/18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744298580; c=relaxed/simple;
	bh=kVA5MpLBMU4IYqfLgN92o9IEr4g+jq3spidVJHcMb6o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AjUig1RtZ5oxj9SIexQxY1reYWvcJ3XPOWbG2Exr5Uxf65D4CZJhqGdrGeps0uXcjLWI7o8PWjqvIMk2Z0TVoTBIrNdedId0wXxdhjtKb5+ORXNBpo+hrL1cL0VfN97zxz3no/vLD3BWtXTPwpyTWBl8cQ+aa35pDw1g/Jk2Mzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F+vCj7RW; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F+vCj7RW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744298579; x=1775834579;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kVA5MpLBMU4IYqfLgN92o9IEr4g+jq3spidVJHcMb6o=;
  b=F+vCj7RWR7oYrP1928ZdkeKLW7tho4g95VSXJfwPnRFFUrVVMKrGRRGl
   2q6GCwg4w7QU3qpEW2FlrlB6bCx1JIHW+XywdJiete0tUZZiNqz2cg4Ru
   9dLQbJ9ihhuEXNGjaD2bP035rWjHCQa6AObOiEN9GLrsEAfyVWduWq5EW
   +IvHbGjO0curCwAwNswsLrYGF5xJeUoBX/wUQB4bieyDnzlmUyGR+A/yA
   b41b+qeOEdZotxQAgUrLbcDh1p7g73r66cEseuvRqffm6/UARecc2Y/+k
   LWPi3nK7H3Q2AGrb63f3WgIdgg9IFC/DwoFRpelXe0wdRTHu1fC0YzKDV
   g==;
X-CSE-ConnectionGUID: dBvDs7+1QQqM+M0Q14hqug==
X-CSE-MsgGUID: c8BWFwvZQbmQBqYT0rLzuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="45716269"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45716269"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 08:22:56 -0700
X-CSE-ConnectionGUID: 3j6bmGJiRKOZWNowD2NzRA==
X-CSE-MsgGUID: ew/RyzT9RNy/1OP0CZJiGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="134108194"
Received: from turnipsi.fi.intel.com (HELO kekkonen.fi.intel.com) ([10.237.72.44])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 08:22:52 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
	by kekkonen.fi.intel.com (Postfix) with ESMTP id DEA3A11F74E;
	Thu, 10 Apr 2025 18:22:49 +0300 (EEST)
Received: from sailus by punajuuri.localdomain with local (Exim 4.96)
	(envelope-from <sakari.ailus@linux.intel.com>)
	id 1u2tjt-00HObw-2j;
	Thu, 10 Apr 2025 18:22:49 +0300
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-crypto@vger.kernel.org
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avi Fishman <avifishman70@gmail.com>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Tali Perry <tali.perry1@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	openbmc@lists.ozlabs.org
Subject: [PATCH v2 0/3] Use a local device pointer for hwrng drivers instead of casting constantly
Date: Thu, 10 Apr 2025 18:22:36 +0300
Message-Id: <20250410152239.4146166-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Clean up random number reading by storing struct device pointer to device
context struct. The changes are very similar in all three drivers.

since v2:

- Add a struct device pointer field to device context structs, don't use
  struct hwrgn priv field for the purpose anymore.

Sakari Ailus (3):
  hwrng: atmel - Add struct device pointer to device context struct
  hwrng: mtk - Add struct device pointer to device context struct
  hwrng: npcm - Add struct device pointer to device context struct

 drivers/char/hw_random/atmel-rng.c | 11 ++++++-----
 drivers/char/hw_random/mtk-rng.c   |  9 +++++----
 drivers/char/hw_random/npcm-rng.c  |  9 +++++----
 3 files changed, 16 insertions(+), 13 deletions(-)

-- 
2.39.5


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F61C204C03
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 07:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268804; cv=none; b=ZJR1m5xK9aMvq8xLJkqPLIpXIYxus0ruBVPQKKgom3wWOhBip+YvoNhwFhVC0OCTFr1EEeq4m5vQEFYeVNXNnXB3Q3C2ozaglfwhvhzUsgG9En+YjbJhk/FyhxJbI/iEUvMwfyqvsrWLMx6f7PykZa6+hiPuV3UeXVLK8CAhZk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268804; c=relaxed/simple;
	bh=BwgGI6MZYv2vNydtUJb8sY2UgwkVT1/xfezAVPOvL2k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HQoso7LrqzKPLtKCy1UftYjaI2xdncv0zsphX5KNgaG3AebZsYBggJWWm6OqF+pAo155bRWqp100IVqWQinlK2UwE2e22T5ard0pdL0qln8S8b7NzUmznn5T/vkvxwA8oTq/1Fne9pPg3wvDiG1U1AgUSt4BgUFqnJjcGUZ1LDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IBo2V+wm; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IBo2V+wm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744268803; x=1775804803;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BwgGI6MZYv2vNydtUJb8sY2UgwkVT1/xfezAVPOvL2k=;
  b=IBo2V+wm9LHaoN9+ycvhGi2Hu3NIC9QKIr6i86CcpO9xHQMmcqIiX5pt
   eqJmSDSCCRvmnPAb3WizVgVY7KVU388T+JFeFtgWo0Zg1a8+YvU3nTQc2
   z4GRzy8bVtxfalpbmwCMlrDjRpj1SqHVws2yiwZ6SRU0MbnWrMBq9Vg1P
   xDS2MO3/5yBqcR2yN+d/Cmo7T9FFF53KE/Gc16uR5MGF2/4SZTwZfUifI
   l8Q8wtJ1QAqRgVeOkc0Jzorx0p5kMm/CBqMQbaahuJnO8KaFIvA0WmsfN
   5mJxcbmbI08T3Z63Nsb8QrTMXr9olD533gc2fOTkvbNlXWM55qeDbgrBC
   g==;
X-CSE-ConnectionGUID: j+vZTDSVQr2vrUvTVv7dxQ==
X-CSE-MsgGUID: NIXVziBAS4GbS5qbvM19pA==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45484810"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45484810"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:06:40 -0700
X-CSE-ConnectionGUID: dc0X+vL2S5ioxsxxRhI0SA==
X-CSE-MsgGUID: 4vsCeVDXRH+kGFuW1sc24A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128791503"
Received: from turnipsi.fi.intel.com (HELO kekkonen.fi.intel.com) ([10.237.72.44])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:06:36 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
	by kekkonen.fi.intel.com (Postfix) with ESMTP id A9DBE11FA2C;
	Thu, 10 Apr 2025 10:06:33 +0300 (EEST)
Received: from sailus by punajuuri.localdomain with local (Exim 4.96)
	(envelope-from <sakari.ailus@linux.intel.com>)
	id 1u2lzd-00FQT3-20;
	Thu, 10 Apr 2025 10:06:33 +0300
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
Subject: [PATCH 0/3] Use a local device pointer for hwrng drivers instead of casting constantly
Date: Thu, 10 Apr 2025 10:06:20 +0300
Message-Id: <20250410070623.3676647-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Clean up random number reading by adding a local shorthand variable for a
struct device pointer used on multiple Runtime PM functions. The changes
are very similar in all three drivers.

Sakari Ailus (3):
  hwrng: atmel - Add a local variable for struct device pointer
  hwrng: mtk - Add a local variable for struct device pointer
  hwrng: npcm - Add a local variable for struct device pointer

 drivers/char/hw_random/atmel-rng.c | 9 +++++----
 drivers/char/hw_random/mtk-rng.c   | 7 ++++---
 drivers/char/hw_random/npcm-rng.c  | 7 ++++---
 3 files changed, 13 insertions(+), 10 deletions(-)

-- 
2.39.5


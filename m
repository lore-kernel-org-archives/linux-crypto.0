Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E4D231CB0;
	Fri,  4 Jul 2025 04:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751603023; cv=none; b=LXYdHaV1CB3594CUiQ7AzRAJj4kqzOTS1ptdXw55RgTsrvtsqBGRXQcgyoxce2VbuCiK43aE/q2a9v/7c12ET3jXxgNQNnfB2uF2SxdQLH3P7mQ7buOMCqcVz36TTgJmUQB8Z7N/+QD4W9Q43JpixdIeLS75LdFZRCFyTxXihAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751603023; c=relaxed/simple;
	bh=iHcKlrWv8V8BFEDg1k8Ep9fQj/9wfrzWnLL9RjUOkZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g2bdOcLT0YOroUaX6BAYxrx9tsKd9QSEw8SweHfCRYFeGC5+DCbS7tXHXs6O5wFmtt9oGxjxxkKZs97VZ6hz69TZ7GdWxxBdLgYDU07ueZfICfZhNEXdjw+hsM9RgykL0cJmwwbeCRh0upfifnD9PVFUNdVFkaiU9bqMFag426A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fdPHy9Nc; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fdPHy9Nc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751603022; x=1783139022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iHcKlrWv8V8BFEDg1k8Ep9fQj/9wfrzWnLL9RjUOkZ0=;
  b=fdPHy9NckIMeihHKvhN+P8Ynlwd+wMPQBVs4gK1XdGWpWg5enNT9sIgl
   s6NcM6ThHhd+xYWItFeaqWgyPYolCMhD0phC3nLR75kk4IV4tFUkseG0J
   iGOV+xCr5A3UnUb41T1PLPEtSj8YAFh3Syv6nmS0zTw+wHpWHMXf53LBO
   5YtR1e/OzN+7HP/NHtR3sTDWe4MEarZx0wF/4PyoQ01pnz7olrB1Sd9Vv
   pnvACxAY2LQl6ayw5ghz6EmAYJFh9LiW86Wse3DIKHv3tHoFmwK1kIiZ1
   4KBk80BFzo7YYMm5LENsk1YSEI3F0U7AJN1SR385uj356YBv+s62kmUbV
   g==;
X-CSE-ConnectionGUID: y1BUE/+OQBqcCPMygvNb/w==
X-CSE-MsgGUID: tk9odqokSM6DioI1nC4DEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53909196"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="53909196"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 21:23:27 -0700
X-CSE-ConnectionGUID: eJ56qMzzTnO6TvzwKh2imA==
X-CSE-MsgGUID: q6NYL5VHRyiQ+PWQWpmyqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="153968717"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 03 Jul 2025 21:23:27 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v10 19/25] crypto: iaa - IAA acomp_algs register the get_batch_size() interface.
Date: Thu,  3 Jul 2025 21:23:17 -0700
Message-Id: <20250704042323.10318-20-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250704042323.10318-1-kanchana.p.sridhar@intel.com>
References: <20250704042323.10318-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Fixed ("deflate-iaa") and Dynamic ("deflate-iaa-dynamic") IAA
acomp_algs register an implementation for get_batch_size(). zswap can
query crypto_acomp_batch_size() to get the maximum number of requests
that can be batch [de]compressed. zswap can use the minimum of this, and
any zswap-specific upper limits for batch-size to allocate batching
resources.

This enables zswap to compress/decompress pages in parallel in the IAA
hardware accelerator to improve swapout/swapin performance and memory
savings.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 30782478b18e2..b4b1c3e0fbfd9 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2781,6 +2781,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_comp_init_fixed,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.get_batch_size		= iaa_comp_get_max_batch_size,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
@@ -2806,6 +2807,7 @@ static struct acomp_alg iaa_acomp_dynamic_deflate = {
 	.init			= iaa_comp_init_dynamic,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.get_batch_size		= iaa_comp_get_max_batch_size,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa-dynamic",
-- 
2.27.0


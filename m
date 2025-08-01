Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A1821B185;
	Fri,  1 Aug 2025 04:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023021; cv=none; b=lsV312EO7etXbzceWsUkO3fJzVOiwzCCE9ZeN3yn8/QVq67d96HXvZeqso6iAbh08M9EizRYDm69hEBsic2Q3BkfBZoOLDxGDDxHq2jk89zLRWJ8rI7ejlWsGkKQe4Tkg/+NOfGt70xtYJjUN6EVSeUYzPzW/AcPHc+YYaX+B0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023021; c=relaxed/simple;
	bh=Bc9zoKzIVBnGxpwUL5rpg1l1pe/k7F1rcvDEigNKHfQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MHBkONnpxc0lnq/o8v3+Iai7VXWvvt9P+/meXTpWmN6JSN1kkMkuCbeLlX6+wp2YrwtHbRbbtBpnQjK6ZOSO8/gz8OvrlWpxK7oKvZnr3PM2GCSdwQRdCuPk3CHL1i5pUNzXg0oYSk9fkKdYHf3SiKEEHyM5xR4UFg9tl/r4LSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oCvxb8Bm; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCvxb8Bm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023020; x=1785559020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bc9zoKzIVBnGxpwUL5rpg1l1pe/k7F1rcvDEigNKHfQ=;
  b=oCvxb8Bm+kT4Mp10X4bHT0Mi+c2J74yXx95m0EOTalMe68cJpLEHIAMG
   QLWdh59lDT4vWh4lPMUl4nGGlND6YIdxAaA0ST1B95ivMHYl2E5VLQFy0
   TieN0WsJCWm798sCXJOrJJ1am4EqkBW6OLr0xdlzh0ZG/9FMO3OrBT1by
   cEO0YM4Ps5EKBnBpcAnF0bMfXJhXYC+ItZXX7QrhDOeHu+uzrV75CudH/
   xw7LnSlsTywPMernv76ygyfavU2GvbXpSKbfLtJxv3dYQHadyG17TqzC9
   l9ufZr7ydiGZQfahB6pLPryeN48sNB8+BG5DYEoYm+nNHb0whxCdDrhqI
   A==;
X-CSE-ConnectionGUID: aEEA76oSSXmSgH/CpWrgiQ==
X-CSE-MsgGUID: ydC/99V6SOG3wn1GCvhn3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820388"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820388"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:47 -0700
X-CSE-ConnectionGUID: o0cLFII2TvernnpSjip6ZQ==
X-CSE-MsgGUID: UqWXAbUASByFcDRRjbcZ0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796301"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:46 -0700
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
Subject: [PATCH v11 19/24] crypto: iaa - IAA acomp_algs register the get_batch_size() interface.
Date: Thu, 31 Jul 2025 21:36:37 -0700
Message-Id: <20250801043642.8103-20-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
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
index 480e12c1d77a5..b7c6fc334dae7 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2785,6 +2785,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_comp_init_fixed,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.get_batch_size		= iaa_comp_get_max_batch_size,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
@@ -2810,6 +2811,7 @@ static struct acomp_alg iaa_acomp_dynamic_deflate = {
 	.init			= iaa_comp_init_dynamic,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.get_batch_size		= iaa_comp_get_max_batch_size,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa-dynamic",
-- 
2.27.0


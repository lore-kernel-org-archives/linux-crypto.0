Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D4525D552;
	Fri, 28 Feb 2025 10:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736839; cv=none; b=fiieKFTddkF9CuihMyxl2DA6fT2JHg93bS7VxWN4wsGgtpLdZ+rwbw75p8TcWqF9TD1Wux/ab1aETSX5hWTPRyrHwzzhR6xgcIJybRx8HxZwWjANyCwRo0/57d2GLVZay6LZIQV4eED4YglioK+VF4IvT3/RX+KPS2CA+gqQIC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736839; c=relaxed/simple;
	bh=nu1yNk8S8EgSrO+ZHhQ4Hl0iMXbUsnYxF38CaLmoAAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=czy/S9EFA8ZgGvlFuZSv67VXn+2PDWpypPCDT+rkwEsaqKJb/ceU/FXgYmDclpJFdZRm42fvt0BKJZKlvIsMy8rFAmzgWeAlzw6J8hfYz2Dy1UqW6iySQyF3aDc+UsmKoS/AR71dAB3IuUvi0JQ1hxD6u5GRWPhVGWpzn4jh+sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eHolsIYi; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eHolsIYi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736837; x=1772272837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nu1yNk8S8EgSrO+ZHhQ4Hl0iMXbUsnYxF38CaLmoAAI=;
  b=eHolsIYiOy6nQHpk+7mu20LXrrKt4lUEMXzGicKuKhuQpmVBot2Ql9Ho
   NoEYQ6iZ0lm2nNDrCchR20Tp6ktm/sReFCXYU5HIPo7FAkZKwlD7EsOqa
   Dp2P5XGVgZGh1UAuQpNEFPw6rWQtlHGu48wrXjEGxuOULB2e4v+uJAIwj
   qMXK/pZIH6KG8k4L+YZhdBbZPskY9cpdnaE0h8XoOaa5xA687vUfiLHdf
   kAEPFclUdwuW5qDhS7WE/6bIYTdzTzAlegy2jJpmUzadrZIJFFNqcF/nb
   TS7O8KDPjictWZ5hcFsaSZ6BsxI7ZYWj1TjGL9F2Mh9pSnrzsQil4y8Yp
   w==;
X-CSE-ConnectionGUID: f59G+UgqS6yuwfWh7ga81g==
X-CSE-MsgGUID: G7kFA7mES1iff4+WXARkkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40902693"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="40902693"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:28 -0800
X-CSE-ConnectionGUID: oQnOQUszQLSG6ECXKMtNow==
X-CSE-MsgGUID: yhZ+k6hdQkGkDfWwMFVwbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="117325741"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 28 Feb 2025 02:00:28 -0800
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
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v7 11/15] crypto: iaa - Fix for "deflate_generic_tfm" global being accessed without locks.
Date: Fri, 28 Feb 2025 02:00:20 -0800
Message-Id: <20250228100024.332528-12-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
References: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mainline implementation of "deflate_generic_decompress" has a bug in
the usage of this global variable:

static struct crypto_comp *deflate_generic_tfm;

The "deflate_generic_tfm" is allocated at module init time, and freed
during module cleanup. Any calls to software decompress, for instance, if
descriptor allocation fails or job submission fails, will trigger this bug
in the deflate_generic_decompress() procedure. The problem is the
unprotected access of "deflate_generic_tfm" in this procedure. While
stress testing workloads under high memory pressure, with 1 IAA device
and "deflate-iaa" as the compressor, the descriptor allocation times out
and the software fallback route is taken. With multiple processes calling:

        ret = crypto_comp_decompress(deflate_generic_tfm,
                                     src, req->slen, dst, &req->dlen);

we end up with data corruption, that results in req->dlen being larger
than PAGE_SIZE. zswap_decompress() subsequently raises a kernel bug.

This bug can manifest under high contention and memory pressure situations
with high likelihood. This has been resolved by adding a mutex, which is
locked before accessing "deflate_generic_tfm" and unlocked after the
crypto_comp call is done.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 7503fafca279..2a994f307679 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -105,6 +105,7 @@ static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
 
 LIST_HEAD(iaa_devices);
 DEFINE_MUTEX(iaa_devices_lock);
+DEFINE_MUTEX(deflate_generic_tfm_lock);
 
 /* If enabled, IAA hw crypto algos are registered, unavailable otherwise */
 static bool iaa_crypto_enabled;
@@ -1407,6 +1408,9 @@ static int deflate_generic_decompress(struct acomp_req *req)
 	int ret;
 
 	req->dlen = PAGE_SIZE;
+
+	mutex_lock(&deflate_generic_tfm_lock);
+
 	src = kmap_local_page(sg_page(req->src)) + req->src->offset;
 	dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
 
@@ -1416,6 +1420,8 @@ static int deflate_generic_decompress(struct acomp_req *req)
 	kunmap_local(src);
 	kunmap_local(dst);
 
+	mutex_unlock(&deflate_generic_tfm_lock);
+
 	update_total_sw_decomp_calls();
 
 	return ret;
-- 
2.27.0


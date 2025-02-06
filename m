Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E36225A44;
	Thu,  6 Feb 2025 07:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826476; cv=none; b=J+qCRCOCj/zQjFVAs1JeMDcM0PhmCdCZRafndP4cPiNhQzLOAha8NWjjLRjOg1ooqFo+jqNpP9/nLhqsvMPcNvjFYJfYHGhO1cFlVEmNsgxAX2ykz6ghHtCrP3Th5GT0rRfH9DT4tGLfuFFeC6mHPKFwbTbgs66ny171UJLiYrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826476; c=relaxed/simple;
	bh=6c1d9813y0GRE+6bR9SnHZofzGJx7eVHq/LRDvJCxss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lSfmMsJN+VlHZ1vLSpeRHLrt4azaZakuaduKtbE9D9+0aRCwa9Qdc03JvlomK4pO+3DUw4shQjLfdqReE6DSlNrlNlk2szX7BN6U+r1lVIBArH2MsmYr/0EiH5OdUxaOdnF/ofQeb6mqs5C2/urqDrwNkF9sgwok2xpAowgsVoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L16JS7qo; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L16JS7qo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738826475; x=1770362475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6c1d9813y0GRE+6bR9SnHZofzGJx7eVHq/LRDvJCxss=;
  b=L16JS7qoA3j7Eq5a9W6ga3YrIGbWQlDmoInH/j/Y5DVU0Cb+/UU9KV+X
   3Tsf80psphGvaU0GKOgg+ITnLdwUcwAkOVfLmm+ac0DnMR8Cld+O3eGOW
   hXzG4/CjLKAxH/7Q/sazCpPlmwtoFqBe0JDNZpwlIHaBVyi+l6c9JR0FC
   vFN3pD4uzEX3uw3a26frKX6ab89G58BqeEsjfXeUjDuxH0n9FETCu5P74
   FTFBHyHownIMbpONs3d8z5IebD1ioOnbC/Iy5blhwaOavJVmQewvfO4Jg
   AFkj8KXcvWw9SfHt+3kcfMpO4SpMzTBhZnAKrXznjUmbO9sG/VQFYIygJ
   w==;
X-CSE-ConnectionGUID: H0uw+SczS/eQzO5lOGlwUg==
X-CSE-MsgGUID: Y2PU0RCgRumY4HaJW0ovTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="56962712"
X-IronPort-AV: E=Sophos;i="6.13,263,1732608000"; 
   d="scan'208";a="56962712"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 23:21:05 -0800
X-CSE-ConnectionGUID: SKYLn851TW6vkdfKb0Rdkw==
X-CSE-MsgGUID: 4cehqHtlRLeQcDOBefapEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112022632"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 05 Feb 2025 23:21:05 -0800
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
Subject: [PATCH v6 11/16] crypto: iaa - Fix for "deflate_generic_tfm" global being accessed without locks.
Date: Wed,  5 Feb 2025 23:20:57 -0800
Message-Id: <20250206072102.29045-12-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
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
index 5292d8f7ebd6..6796c783dd16 100644
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


Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D6D1F237A;
	Mon,  3 Mar 2025 08:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740991662; cv=none; b=hOUOxfYL6a6J1YhCui4S66mnW9BMlsSyHTGsr68YQYcdVNSaP2FpSKDVt3tBWbg+XcqChfDFB5GelNxRXc6KE4PixdlXXIMo9zfvCyUx+kxvATfgIVMKe4PFvwtXRySIGWikkVpNUHDdGVVVKdzt8FoH2oxp6kleK/jvD0nyqNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740991662; c=relaxed/simple;
	bh=nu1yNk8S8EgSrO+ZHhQ4Hl0iMXbUsnYxF38CaLmoAAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OgTGFxuMEZWaM5SevubScAIvw4nG369C/CGnuZGO0k4fVtUR01/PJn7xJquauIiitxGaWhMFs1IWr2bytXbMxTvQ68Mskrlv1ttPqtVLyN1mt8aaEkHggmOsWEXcJrt34DZmDHZVhr/44KMiJrWvxpp/986FlHpS4u+iLP2oa2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xmh2yriG; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xmh2yriG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740991661; x=1772527661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nu1yNk8S8EgSrO+ZHhQ4Hl0iMXbUsnYxF38CaLmoAAI=;
  b=Xmh2yriGF7OjL/FJ2HoQZA3h45RXDKYzh1gfHn1lE26hllCvmEEf+nph
   oCYSmkl2VAZU1X9/D9U+4JTM9Bt7dMwxN/QBnEQ9H+hOqfvCXi11s8qiv
   B9GHn1d7kNnBn0M23imNcbGcjvm2w0lr3L11OfDfRf7ZGdL1yBRlSzu6Z
   NWowBC74Q5+nyzhXAac6Vsnc1h1vgliWZA/Ft81kNo9UYk4dIBf8UQuWz
   5fdbu0Cpc4XqPnbBjneT/FYitPxg8KluYbk8tvg5mbt5+oKIUpXswxIki
   z6MgVi+LqDoalg8jJcgWpyw3xY+ZR6LG7f0RG6jYBQyIcBWuQ89NgAJT8
   g==;
X-CSE-ConnectionGUID: Ln02oyqhQBSt7iOCzC1ARg==
X-CSE-MsgGUID: IbQV5mGvSaqHL/dNgajwmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="42111991"
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="42111991"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 00:47:39 -0800
X-CSE-ConnectionGUID: RcBRVQJHThmfzPKoFFz43Q==
X-CSE-MsgGUID: Mf9Syfb0RG6aEdF/ZVQZAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="118426822"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 03 Mar 2025 00:47:36 -0800
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
Subject: [PATCH v8 11/14] crypto: iaa - Fix for "deflate_generic_tfm" global being accessed without locks.
Date: Mon,  3 Mar 2025 00:47:21 -0800
Message-Id: <20250303084724.6490-12-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
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


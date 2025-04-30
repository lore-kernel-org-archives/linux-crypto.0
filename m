Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE63D2983E9;
	Wed, 30 Apr 2025 20:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746046392; cv=none; b=SC1MO8lE2YmZexkL9kkX9OmcvPywmcy3uiySJLppIBip6TQ9loYXECLWViY13SagByGeIeQWOlNKG9Oo0H7vN7xqN49Kf2x2bv1hMe7VgrtqI9dyHmNznxpuSSdD3XdcSiaPkRa9B0i/40DafHpkvnt0WQEMR38kZxM8J5paLn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746046392; c=relaxed/simple;
	bh=6wbRhOV0GFWlmqPXQS6DTk+b5GGSil7xU+GDXQbyLR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oWg+/QuG2P9NeS++wHqH1IjIhg439UnZIl90b17Mf4Rc0VkeXV9Lvx82z2t5/d8CwUvR7i7D7Z04X9/wlxPM17OsCsP3eccviqyGCAf4CqazQ7n0Q2dpI2HBAHx8FWbX/XoX8uTTsYqseWGdr4GetAJiVmNVLge08aYlXuLYV38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ID+WMFH3; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ID+WMFH3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746046391; x=1777582391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6wbRhOV0GFWlmqPXQS6DTk+b5GGSil7xU+GDXQbyLR0=;
  b=ID+WMFH3aNwACK47bQ/BhqainNBxbM2MiCy81SDjyP7VIJjZpE5BznnP
   HVRqFKqipmoPZdvLMq5Fzq8ZgdVOYDwNJgakz79dhudjij8rYS04Ves/U
   RS6QROpAQoj6zfJbDeEF5D9J2HhnawfMpDNQdRJViR12G5VPztY0KFXuU
   /b+W77Xt0wfrjPi3J8Dq+sNrJXRPQgrjegk3P7aJ0i0F8PWofNIR3I2O1
   gQM8jxMNwCSxBi1ACHP3kzf2D0+Bimz4F8XHCJ9M/rgVEdX98FtmcPDQQ
   e1DgnEknOmfu3bc2nVVCvGGoyomDsIIb947nNn3/m47DAVDNcgYu/XwjL
   w==;
X-CSE-ConnectionGUID: QZPZmI/nSwWGZ8ItD4wTIw==
X-CSE-MsgGUID: RlAjiTB0T/ytnvk+GxWdSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51388490"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="51388490"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:53:09 -0700
X-CSE-ConnectionGUID: Qv3hyzFRRt66jXyyBrDrAg==
X-CSE-MsgGUID: DNCHjZ4LRBOGQBsceF2LLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="138248876"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 30 Apr 2025 13:53:07 -0700
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
Subject: [PATCH v9 02/19] crypto: acomp - Reinstate non-chained crypto_acomp_[de]compress().
Date: Wed, 30 Apr 2025 13:52:48 -0700
Message-Id: <20250430205305.22844-3-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts the request chaining implementations of
crypto_acomp_[de]compress() introduced in commit b67a02600372
("crypto: acomp - Add request chaining and virtual addresses") since
request chaining has been removed from acomp subsequently in commit
64929fe8c0a4 ("crypto: acomp - Remove request chaining").

This patch restores the implementations of crypto_acomp_[de]compress()
from prior to commit b67a02600372.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 crypto/acompress.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 82fb3c04e68f..d08e0fe8cd9e 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -310,21 +310,13 @@ static int acomp_do_req_chain(struct acomp_req *req, bool comp)
 
 int crypto_acomp_compress(struct acomp_req *req)
 {
-	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-
-	if (crypto_acomp_req_chain(tfm) || acomp_request_issg(req))
-		crypto_acomp_reqtfm(req)->compress(req);
-	return acomp_do_req_chain(req, true);
+	return crypto_acomp_reqtfm(req)->compress(req);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_compress);
 
 int crypto_acomp_decompress(struct acomp_req *req)
 {
-	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-
-	if (crypto_acomp_req_chain(tfm) || acomp_request_issg(req))
-		crypto_acomp_reqtfm(req)->decompress(req);
-	return acomp_do_req_chain(req, false);
+	return crypto_acomp_reqtfm(req)->decompress(req);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
 
-- 
2.27.0


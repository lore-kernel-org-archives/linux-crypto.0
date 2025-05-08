Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EF928B3FF;
	Thu,  8 May 2025 19:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733302; cv=none; b=Eljn2kUXkDn+411lZEL/wgOxOZBkcYR0WMOy5F+gXARD1aHftNiX95j0Sa+db3nt6B3ykA1i1c9mGZ5xOXptGubNS3GImKPwVi7TBhzGBGUssV8DYP++xp7c1vU3sBfAjzQq49NFWCJuASaV1456gna4sWB2JhBezgaJrxv0clM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733302; c=relaxed/simple;
	bh=6wbRhOV0GFWlmqPXQS6DTk+b5GGSil7xU+GDXQbyLR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=smj0MugZ1kY/CwOLlriasr0MDY9FyORs2eTit7wu17bQIidwCZnuFzsyhEfJzlj8sSD2RWuRJEK5NlxZyGwZfzAcYlKY28Y1HR2oQ9a24qVw+q51mEgRe0XzhCImnWhSRvKB/IxHwBcbaTAyaFMYEIcRotPHmq2d91vV6vQIfmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G7cAgXfv; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G7cAgXfv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746733301; x=1778269301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6wbRhOV0GFWlmqPXQS6DTk+b5GGSil7xU+GDXQbyLR0=;
  b=G7cAgXfvha+wZliockLplGlKJ0UKtBNeRm+rduUW/JW/3orMqCSkbhzL
   hAUFCFTHG/HyAMVQ5LiD+5amibosvNlT9rOh1T4y5P90N71g8bNh3v5Dp
   hBgRu9c0LsZvyNioKmgJ7qbGXxmRFppNO1sy1bVcRl9awWLW3fJUEjvyT
   UpEzKlEb7Zl882ou6I6b5IRvSX6aQKyOR3kKai2C6yxccmxNMLP3pyL8t
   0Hb2nXzIjTcwMf7RZ8H0m050AxrklGhKULl6B8kOyd7r47nMRnNyMa+pc
   8xgNBq3qkegqOuY7xHgeSil7fBLdJW8MV9EjOqNztnPpxNkAHR2lK5EFd
   g==;
X-CSE-ConnectionGUID: VPHJ6jOeR+W8kHjqJtbEmw==
X-CSE-MsgGUID: a6cMcUVQQ7mROxl1mN7/uQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48454570"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48454570"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:41:36 -0700
X-CSE-ConnectionGUID: 7MUR0bThTVCKOt+PlSoAVg==
X-CSE-MsgGUID: iEe5hw7uS4+ZnqZrvIKNDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136880808"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 08 May 2025 12:41:35 -0700
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
Subject: [PATCH v9 02/19] crypto: acomp - Reinstate non-chained crypto_acomp_[de]compress().
Date: Thu,  8 May 2025 12:41:17 -0700
Message-Id: <20250508194134.28392-3-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
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


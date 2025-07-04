Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF154258CCE;
	Fri,  4 Jul 2025 04:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751603025; cv=none; b=gWh6w+b6TrEaJhJG0/dru9hbHdrdQPZO6mmVZw9bPRx9F4px6mU0pelztQHC/A2E8nzkKo3IFOj7gCs7IcXNUMSbaQqvy5Skde0qMGvTScHIY74h/+AyVEA1HCxxmvE3Xm4CpmMMi2LVpJFRbLGhbGGgB7BWUJfwa9174+amqYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751603025; c=relaxed/simple;
	bh=pGg9+BuQcNzzvHBWkrmR+YAXBo4WPWN1ABcyBZGemzs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mSFiB3TA+2mY7Yd+39MwJfNLj+90CD9i0ovtMMXQFac62xAWrK1DbuQ0T93r7h9atI+GJgKF2Yk19W6zDRGu0/5n880cv6cAk1pgvGeEuOtYOZpIS0AOfXUMHRhLlvuZo0PhdiC1ELUn+e14fIhP9m9m/qhW+lsugSJPNrS5Yzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yn79WQXn; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yn79WQXn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751603024; x=1783139024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pGg9+BuQcNzzvHBWkrmR+YAXBo4WPWN1ABcyBZGemzs=;
  b=Yn79WQXnQZEBP+EJUbsI45qrw7mCVPzAF193N0qITIMoliKTVTli8LDu
   pwCVu4Y1GAD/t4LiQT4chxVzAzIGaMpQPZfQ0TLnVS78qsNnJenSa8jTF
   tm6vXWIr/w+8YQY4LMrHI5E7IV6oDYIccL15GKnRC5sY2+YMxlG8r7XPq
   lLHl6F+mtbsxbqJspyz1Lfcrpz4EnQ+aNRfi4sJdcQRmrlFOMIVEIgVUb
   3+6qQJRWUPKfve3c88sDBimDUbAJUQdf2q07dwQpHEPq5+YI2OQNvLOsB
   2WDkZEgyko+88uer7bvlZSgiaqb7c/MYNKwbLH251Ah+IUSYPZ6Y9SYQg
   w==;
X-CSE-ConnectionGUID: jfN6sUUFTNGRjY72mQu06w==
X-CSE-MsgGUID: IjSX8ulgQamnDvxun0CVhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53909238"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="53909238"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 21:23:28 -0700
X-CSE-ConnectionGUID: PP+XM/OvQOK5i3Ll6zVQQg==
X-CSE-MsgGUID: lh8hEO1XRcCv6uzCVG0ZiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="153968728"
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
Subject: [PATCH v10 22/25] mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Thu,  3 Jul 2025 21:23:20 -0700
Message-Id: <20250704042323.10318-23-kanchana.p.sridhar@intel.com>
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

This patch uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check
for valid acomp/req, thereby making it consistent with acomp_ctx_dealloc().

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3635a7d6cf7b4..688ce7ed39ca8 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -294,7 +294,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return ret;
 
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
+	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
 		ret = PTR_ERR(acomp_ctx->acomp);
@@ -303,7 +303,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
-- 
2.27.0


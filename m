Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C61224B0B;
	Thu,  6 Feb 2025 07:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826471; cv=none; b=C1NIY/JUnLk8YXsPN7Q3kWuZhhPrue5AGp9JOMB3AZENweh7CnQdiKAlwvJyh8ELyYQuWXGP5Enpn0Mj7RaAAmd0ersQCcGxDUlD6ABEt4DvmnL8tCpJmZvpduRfkAzsL83dYpDwg3QjgWah4U4SciECZiWW1EnAsA5nLiAToFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826471; c=relaxed/simple;
	bh=aa0CRR/xEnOe7ecidFKr7n4dRE0EgIea9NyU6tuNilQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vvq456K//xadi7eqaegAC+wpuCHCS8OMPAqtjL0ocJxI7r8qlRvA92s2Rm2tXSAPN0SJgtAjRq8PHZZBYRfAK8P0V//T3/WDe5ik8i0hjmHs+tfdxbnH8N6Vdz/V0WzuzXu6D0XqbznO8JhdZa2MFdhiWRl8mbZagYJ8ei9yDSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n3wzOAEr; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n3wzOAEr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738826470; x=1770362470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aa0CRR/xEnOe7ecidFKr7n4dRE0EgIea9NyU6tuNilQ=;
  b=n3wzOAErVWfZZXKWuRR1KED1m+e4A/ElXCUREA+G5Z98HSV+CTDCbRlx
   JdHBIDljACqASmlZCxmN7SvHA51AU7gfhdiAGp+bdM4+d7IG/DhPqHiLy
   M1Qw/JbCgppk3PjOcr/mCHxYbJXQA5/Kqt1gjYFm0M6WpuVUfdnpCMCy9
   6AUgCrYCoOwvBmNDT+ZXli4w1YEWBtKJSh8v+/tuh2OqJdUSz5+ZVr+Jq
   86SRcDqnbE5ZnJpWiN3yczU0qOkcKLy+Q9c6Jnyhd53a9V1A9ErxXp1jv
   d2ba13HuQITzRojmEiJh2iLDq8IGJUbWW67DOQ6h+q6ZE5XbbSVgaKAgx
   w==;
X-CSE-ConnectionGUID: /hLY0mCGTsmvrK7d+c1XEw==
X-CSE-MsgGUID: ZsMPXwkWSWeMhHzmmwWqRg==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="56962642"
X-IronPort-AV: E=Sophos;i="6.13,263,1732608000"; 
   d="scan'208";a="56962642"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 23:21:04 -0800
X-CSE-ConnectionGUID: 0qv2Q5XmQcmCbrrd3qHiSA==
X-CSE-MsgGUID: ZBp6cQVISTO02ezo4hUqhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112022600"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 05 Feb 2025 23:21:04 -0800
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
Subject: [PATCH v6 03/16] crypto: iaa - Add an acomp_req flag CRYPTO_ACOMP_REQ_POLL to enable async mode.
Date: Wed,  5 Feb 2025 23:20:49 -0800
Message-Id: <20250206072102.29045-4-kanchana.p.sridhar@intel.com>
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

If the iaa_crypto driver has async_mode set to true, and use_irq set to
false, it can still be forced to use synchronous mode by turning off the
CRYPTO_ACOMP_REQ_POLL flag in req->flags.

In other words, all three of the following need to be true for a request
to be processed in fully async poll mode:

 1) async_mode should be "true"
 2) use_irq should be "false"
 3) req->flags & CRYPTO_ACOMP_REQ_POLL should be "true"

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 11 ++++++++++-
 include/crypto/acompress.h                 |  5 +++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index c3776b0de51d..d7983ab3c34a 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1520,6 +1520,10 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		return -EINVAL;
 	}
 
+	/* If the caller has requested no polling, disable async. */
+	if (!(req->flags & CRYPTO_ACOMP_REQ_POLL))
+		disable_async = true;
+
 	cpu = get_cpu();
 	wq = wq_table_next_wq(cpu);
 	put_cpu();
@@ -1712,6 +1716,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 {
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
+	bool disable_async = false;
 	int nr_sgs, cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct device *dev;
@@ -1727,6 +1732,10 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		return -EINVAL;
 	}
 
+	/* If the caller has requested no polling, disable async. */
+	if (!(req->flags & CRYPTO_ACOMP_REQ_POLL))
+		disable_async = true;
+
 	if (!req->dst)
 		return iaa_comp_adecompress_alloc_dest(req);
 
@@ -1775,7 +1784,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
-			     dst_addr, &req->dlen, false);
+			     dst_addr, &req->dlen, disable_async);
 	if (ret == -EINPROGRESS)
 		return ret;
 
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 8451ade70fd8..e090538e8406 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -14,6 +14,11 @@
 #include <linux/crypto.h>
 
 #define CRYPTO_ACOMP_ALLOC_OUTPUT	0x00000001
+/*
+ * If set, the driver must have a way to submit the req, then
+ * poll its completion status for success/error.
+ */
+#define CRYPTO_ACOMP_REQ_POLL		0x00000002
 #define CRYPTO_ACOMP_DST_MAX		131072
 
 /**
-- 
2.27.0


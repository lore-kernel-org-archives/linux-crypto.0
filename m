Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B27A157E99;
	Sat, 23 Nov 2024 07:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732345293; cv=none; b=Ze4KRmuGRMSX1m94vrm1pEogoxRPhxn18x4+Lm+pjWo6qze3SsQTJRaiFF+ozeyYtfHuDE2v1lwwr6djG7yci2Qb8aQQEo4ZafWbWKTIQMqhcvw62dF2FPpVigC14asNQbHs4M9cZfb51XoO/W137D+pQkciYmAVEeuJctF2mSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732345293; c=relaxed/simple;
	bh=2nV7tAyF29XIJl5hqo4L8d+IjA/bGBNSbr3o8YrSMP0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W9PkJgJpeO00F5dlIDH66vlDOIJVin7XO1u8i2IyxiWNUfC+sUGmiSZI+64Eu0+luUK4k9uu/dy7W1JO1aMmvEyRNH83dXjWQoJ2055/4LpN/K13Vc/w4mR7OpUd/OVB0A2mMe+6OkewJJ8hCwaUBhVhRqDkgjFz0XG8aIItIvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NpZOzzmn; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NpZOzzmn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732345292; x=1763881292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2nV7tAyF29XIJl5hqo4L8d+IjA/bGBNSbr3o8YrSMP0=;
  b=NpZOzzmnRpZX0OW0knZtHgmlbSu5wv1xFtW0/xax+xPDz6JVt6VL01Yn
   RMy2y5fbLSnkBQukx4xv79cNLkU6lpYbpOGd26DCb/FQr5a3YY+bk4hcj
   4Qq5u1tGrw5kTVRp0BiNvP9ZdOv+mOuXctcijsC+C2Ud9TuUotktWVGlV
   SEr69LsJG27cUBE4ErD2gMEk5EFrO4yTrhuwXviVsuu66q21oXEI+Q/SN
   UxdSOHElsJCrzb+wIUDiWSMNNvyTpZUm/Cxw4AZi45B+o/As0RgRkOZT7
   xcGKtpXdp9A4V7z0MpgncG7RlXebgR0SFAMekeYGTLYgbxkgGYIaFZ8Mc
   A==;
X-CSE-ConnectionGUID: RuCUNPAAQ9+3kMp1+npF+A==
X-CSE-MsgGUID: 1TBv+GglSyGv7ABZfsKDuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32435480"
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="32435480"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 23:01:29 -0800
X-CSE-ConnectionGUID: zgZFbcPVTsqJbBTEyVkAlQ==
X-CSE-MsgGUID: 2fHdvS1NQqiWAwE+SNwUbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="91573550"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 22 Nov 2024 23:01:28 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	ying.huang@intel.com,
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
Subject: [PATCH v4 02/10] crypto: iaa - Add an acomp_req flag CRYPTO_ACOMP_REQ_POLL to enable async mode.
Date: Fri, 22 Nov 2024 23:01:19 -0800
Message-Id: <20241123070127.332773-3-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
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

All three of the following need to be true for a request to be processed in
fully async poll mode:

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
index 237f87000070..2edaecd42cc6 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1510,6 +1510,10 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		return -EINVAL;
 	}
 
+	/* If the caller has requested no polling, disable async. */
+	if (!(req->flags & CRYPTO_ACOMP_REQ_POLL))
+		disable_async = true;
+
 	cpu = get_cpu();
 	wq = wq_table_next_wq(cpu);
 	put_cpu();
@@ -1702,6 +1706,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 {
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
+	bool disable_async = false;
 	int nr_sgs, cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct device *dev;
@@ -1717,6 +1722,10 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		return -EINVAL;
 	}
 
+	/* If the caller has requested no polling, disable async. */
+	if (!(req->flags & CRYPTO_ACOMP_REQ_POLL))
+		disable_async = true;
+
 	if (!req->dst)
 		return iaa_comp_adecompress_alloc_dest(req);
 
@@ -1765,7 +1774,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
-			     dst_addr, &req->dlen, false);
+			     dst_addr, &req->dlen, disable_async);
 	if (ret == -EINPROGRESS)
 		return ret;
 
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 4252bab3d0e1..c1ed47405557 100644
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


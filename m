Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0CE70834;
	Sun,  3 Nov 2024 03:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730604079; cv=none; b=WWTjpbsXhQy33vnDex8YrBKiTEYShuy3GpHqAP+hI8FrzcFH1QOO1h+qurWOCSku8UiU4rqqROfM5jFCqY/jyHodABTwrp1DLybgWrkPxAEencLCodB3C6Gy31byQFkCv/IKzRUoZuWYyih5rrU6CRFMxx7kDUHrMLOwH2yGsu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730604079; c=relaxed/simple;
	bh=LsH6bLbkT8Oq6ZmvZizx30VKkaEZwigMJxQ/s5KiGZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jX/5hOLg3BeulBKenQaHCIv/moD626qJe/gSxdkn4ieJveQtd6R5iMcIy/zknnlw0too6Wuj8AhoFEkw4yVvaphlbEdKzuMcb3nhbR2rm0enaGlkrHEdX+0uTUFnD0/sH1gvglYUPYU5tPZwBZkrzn2wras5N27/G/KrLuVX8yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FRZ62b2V; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FRZ62b2V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730604077; x=1762140077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LsH6bLbkT8Oq6ZmvZizx30VKkaEZwigMJxQ/s5KiGZI=;
  b=FRZ62b2VJM//uWCQp/7MaAWS/Jh7ki8ErwpdoeVquUdg/ko41YZeGw5I
   rbA6mYYFzD2pfHwa6afG4z1madJ/tVLSmiNSNUV2SlvTJ0Ebb8gKuJ7rn
   8P/8wsHFrWtaeK0xC6rHgAIZowfJ3mnZ2Vv5d+iIiZX4TVPFm5yqFzXId
   G988Ppw6NHq6WrmkojduOxAL8llFgeNpQPu4wRxlZ94KSm1wqyex7Nx4v
   RZ89FCuEH5bB1Pd7zC2FPcrKy7INRRHuWTWOnzeeCCNd1F8aPfFV0oJsj
   9EW6QarqVv94hWrXgzDm5TIv6qPtr2YBHLzP5RFNMV/pLWSm3iqXU5XAJ
   A==;
X-CSE-ConnectionGUID: BK4zsnziTR+IzCIDyx+hqw==
X-CSE-MsgGUID: 8y3IcvQFQj6VWoc3+AEP3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11244"; a="30548246"
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="30548246"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2024 20:21:13 -0700
X-CSE-ConnectionGUID: OModDCsfTFqmbXDkZFRLLQ==
X-CSE-MsgGUID: 3DAXP24xSo+OwZV1sOY6/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="83451871"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 02 Nov 2024 20:21:13 -0700
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
	kristen.c.accardi@intel.com,
	zanussi@kernel.org
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v2 02/13] crypto: iaa - Add an acomp_req flag CRYPTO_ACOMP_REQ_POLL to enable async mode.
Date: Sat,  2 Nov 2024 20:21:00 -0700
Message-Id: <20241103032111.333282-3-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
References: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
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
index ab0d9987bde1..5973f5f67954 100644
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


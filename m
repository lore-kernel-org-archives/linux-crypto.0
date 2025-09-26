Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ECD2773C3;
	Fri, 26 Sep 2025 03:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758857718; cv=none; b=BoipipNuBNUS8Grh2h+1ru/HCaJLZrbpg3ZIj2xu5vfMnTonaKHEz0Y7YaHzjidN+5cmTU9mg2fnT2r9hBhP1lEpZRtJ8JmmMwN+OnJLT6kr0zJK4aUNC3+jShRm5sXTulqRdli263EwR03Qt2trkAdyWy/DvcEAKelpy2+PEIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758857718; c=relaxed/simple;
	bh=pwC8gGnN93tPpG8XUySSvRTzqGEe+iI+19bkiX/xCZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iYJUEn7zCwdClF2nz48yTMRR2qc378CoQsmPRREHKsiGrOCjeBv+/zA7IkAS3DxWNTzllZ35dJYxyRQPMVu2TNvRpwit5NWzkVLluzfB0ValpWmwEJYO6/EgUGgMFHwJKbQ1SfuC/LzYIVljaMoCULodomHXxBS954pKs7pVNXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aEgwT3AV; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aEgwT3AV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857716; x=1790393716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pwC8gGnN93tPpG8XUySSvRTzqGEe+iI+19bkiX/xCZY=;
  b=aEgwT3AVsePz72KHk2xQhMTgmnP0pJqbMnuUBIlRZ7vKEpcU8N3GiPTf
   S4+WD0rO/GpGvIAR6si2K0gcrQ4qBcRK84i+rwm59+TObwxsxwSYq/qV7
   DWv+pFZPw3/kewU63nqX2KxOJbnRP40rZapO1kzA7iavYOJWkVUWoNR7w
   k08YJ/UvunJ6Kez7Eon9Wbs8+YVfCbpdx3ud8JixXbP79cVqizgmCprnZ
   KSJVTRB05K1NRalhIeiuwN+LJMh4TurxJDipNxpbMn++JvqDavxrKr3ZI
   4bNizonZaSjOpKsWZ06XaSWztA/Dbz+/aqiDfCaXlcyWHc4JlawcZEyTg
   w==;
X-CSE-ConnectionGUID: DQaP5aACSiWkiffZH+6RtA==
X-CSE-MsgGUID: R+GxTc2ZSVGmxsOjDK+6/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819554"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819554"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:06 -0700
X-CSE-ConnectionGUID: 5JNP4bi0RRaUIOdbR0R7xg==
X-CSE-MsgGUID: wIVCNUzbRyyBSK7y3Qvb8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636587"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:05 -0700
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
	sj@kernel.org,
	kasong@tencent.com,
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
Subject: [PATCH v12 13/23] crypto: acomp - Define a unit_size in struct acomp_req to enable batching.
Date: Thu, 25 Sep 2025 20:34:52 -0700
Message-Id: <20250926033502.7486-14-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We add a new @unit_size data member to struct acomp_req along with a
helper function acomp_request_set_unit_size() for kernel modules to set
the unit size to use while breaking down the request's src/dst
scatterlists.

An acomp_alg can implement batching by using the @req->unit_size to
break down the SG lists passed in via @req->dst and/or @req->src, to
submit individual @req->slen/@req->unit_size compress jobs or
@req->dlen/@req->unit_size decompress jobs, for batch compression and
batch decompression respectively.

In case of batch compression, the folio's pages for the batch can be
retrieved from the @req->src scatterlist by using an struct sg_page_iter
after determining the number of pages as @req->slen/@req->unit_size.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 include/crypto/acompress.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 9eacb9fa375d..0f1334168f1b 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -79,6 +79,7 @@ struct acomp_req_chain {
  * @dvirt:	Destination virtual address
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
+ * @unit_size:  Unit size for the request for use in batching
  * @chain:	Private API code data, do not use
  * @__ctx:	Start of private context data
  */
@@ -94,6 +95,7 @@ struct acomp_req {
 	};
 	unsigned int slen;
 	unsigned int dlen;
+	unsigned int unit_size;
 
 	struct acomp_req_chain chain;
 
@@ -328,9 +330,43 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 {
 	flgs &= ~CRYPTO_ACOMP_REQ_PRIVATE;
 	flgs |= req->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
+	req->unit_size = 0;
 	crypto_request_set_callback(&req->base, flgs, cmpl, data);
 }
 
+/**
+ * acomp_request_set_unit_size() -- Sets the unit size for the request.
+ *
+ * As suggested by Herbert Xu, this is a new helper function that enables
+ * batching for zswap, IPComp, etc.
+ *
+ * Example usage model:
+ *
+ * A module like zswap that wants to use batch compression of @nr_pages with
+ * crypto_acomp must create an output SG table for the batch, initialized to
+ * contain @nr_pages SG lists. Each scatterlist is mapped to the nth
+ * destination buffer for the batch.
+ *
+ * An acomp_alg can implement batching by using the @req->unit_size to
+ * break down the SG lists passed in via @req->dst and/or @req->src, to
+ * submit individual @req->slen/@req->unit_size compress jobs or
+ * @req->dlen/@req->unit_size decompress jobs, for batch compression and
+ * batch decompression respectively.
+ *
+ * This API must be called after acomp_request_set_callback(),
+ * which sets @req->unit_size to 0.
+ *
+ * @du would be PAGE_SIZE for zswap, it could be the MTU for IPsec.
+ *
+ * @req:	asynchronous compress request
+ * @du:		data unit size of the input buffer scatterlist.
+ */
+static inline void acomp_request_set_unit_size(struct acomp_req *req,
+					       unsigned int du)
+{
+	req->unit_size = du;
+}
+
 /**
  * acomp_request_set_params() -- Sets request parameters
  *
-- 
2.27.0


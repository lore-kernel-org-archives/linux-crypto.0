Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28343314D13;
	Tue,  4 Nov 2025 09:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247569; cv=none; b=VOCpI60uYverRKixXP6BiHlQBBqwu46SgMHYYk6XiIELvmDbdRW4Vnxjgf4eT1V9kLI605//UGiAFRJ3Xh20BMg10LbhS5mez8v0O5v4rFvZPOHhUF0Q0jjkDER8+S93DytUlKCmC9eadzLKJ7R9QaYnQuOaxFuKxjkjne5QjKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247569; c=relaxed/simple;
	bh=rEsrEPz/0zrCVWa4aN50sbVb7C5pN8I1T4EdA4dzSUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FPxw9XUkSTKYzfXemwfovmD2t1P/kXhrO3G33heh9Qj4yEWZDrK3rLeL/lT3hncORJszIYhfJDhsP6aCCrHDg4+cssIbRkCCV7Pxf/K0JvIh0yHrI9lYLk8O5a56deh9+aBk3hTZ6h2E1IL2kCjr4AwKnrAtKOXWU3gEj/eQA18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AyJQfjR6; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AyJQfjR6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247567; x=1793783567;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rEsrEPz/0zrCVWa4aN50sbVb7C5pN8I1T4EdA4dzSUY=;
  b=AyJQfjR6GutzpZ0/6YnHg6SulFd4sSpbnEkYCs4+pLgFngLtfCZWpZmX
   HPFDpKVz6Zq8KXwpl0nigRZh8xoOxKpdwct8quuMdgD9LiqHyayWuBisb
   L4ckjQpwlqIkCj5a4R32zcdhuqvQLsz+ov2b6bLYFGuvyc93B2h1bcDss
   daz8DpUKos35WKGJqfWYX52ju7b4Gb7sIuUwpgMihQKquUhX1XUgwPH/r
   ak6kwk89rewk8GbW5avcVSbFkXW3WxC3hMrmegGRwQAZrf6UOFZazyIPT
   he2JLwqJC63VtpKT2tn5qaCVvQ/xcriQVYtJjrnqp1GmdQsYixLaP62NV
   g==;
X-CSE-ConnectionGUID: xcH0DryzREKPPieTuvHAdA==
X-CSE-MsgGUID: lgNmcCgXRvG9qvpojhXxfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89798684"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="89798684"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:38 -0800
X-CSE-ConnectionGUID: GuTJUa5BTsWVMAyNsIATEg==
X-CSE-MsgGUID: FCjTrpThS5aZEz4mXM7FcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795811"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:39 -0800
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
Subject: [PATCH v13 12/22] crypto: acomp - Define a unit_size in struct acomp_req to enable batching.
Date: Tue,  4 Nov 2025 01:12:25 -0800
Message-Id: <20251104091235.8793-13-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mm: zswap: Set the unit size for zswap to PAGE_SIZE.

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
retrieved from the @req->src scatterlist by using a struct sg_page_iter
after determining the number of pages as @req->slen/@req->unit_size.

As per Herbert's suggestion:

 1) acomp_request_set_callback() sets the @req->unit_size to 0.
 2) In zswap_cpu_comp_prepare(), after the call to
    acomp_request_set_callback(), we call:

      acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);

    to set the unit size for zswap to PAGE_SIZE.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 include/crypto/acompress.h | 36 ++++++++++++++++++++++++++++++++++++
 mm/zswap.c                 |  3 +++
 2 files changed, 39 insertions(+)

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
diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958..4897ed689b9f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -783,6 +783,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->acomp = acomp;
 	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 	acomp_ctx->req = req;
+
+	acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);
+
 	mutex_unlock(&acomp_ctx->mutex);
 	return 0;
 
-- 
2.27.0


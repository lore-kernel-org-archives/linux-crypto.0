Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6321D2264CF;
	Sun, 25 Jan 2026 03:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312167; cv=none; b=OpqVT2Z2cRdIeD5sFq5FRPQ8399m6PJn/WdD3aOXs2r/67sXxPySPNAWivLLsves1zmoIiJDXsA8Wa+ywwRD/f0XEDwzhBojl/+L3kCPEKs3NtQTgldx5AHDr/mwAfQVwxhbZxzNzf+KE6UgQtW9/WyrwlfQmcvhtUvz62xWSbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312167; c=relaxed/simple;
	bh=HC8fdqJFaBib45Q8EUreD6PT2wkYvwrws+aVSwrcud0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G/nFWizIT2ATIjlxjttN6qEgI6Ft40wpjHOiqe061JFa1F8sfqa2sRyCUHgZ/0uNjrec4uE9Jo7leGvLp87ek1L+ooRB2yxWZcO7/y8vy90+GlEXXUQjymWtKTE7fCfn0+5rUoLgaBMo3lcAjgjIXk0s5KnM+dr2lwCfWSeE7Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=btnvQQY7; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="btnvQQY7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312161; x=1800848161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HC8fdqJFaBib45Q8EUreD6PT2wkYvwrws+aVSwrcud0=;
  b=btnvQQY7TcjpOjlMPikvLe7U3ZEHTh7rkkBQcGk4fQFhLtDc0DgUYJk4
   0GgxpwqctyYARla/dB0GuF++JpcmbXozYkLqG2npbni6PRgl2J1ry5wVs
   RBbBnJt9SGajCyhNzwq00TqdabthGJQOk+mfBZqXmAFSwG8to1Ck8THy1
   LcnzdIdveMGUwpkW9s3jjBEqUSb6jIb6/xpLtg8anb+3ku5jioQDE7ZTZ
   AzbGn0OGqBpLRiCt5o6JL+T54dHLYCS1Fli4PTEcuvrsTrdePt+lryiYT
   Hqg9d3GqFN4X5kZPiM53GGMFyrdNbu+8l2KiLuFCxysSoMD40gkB5DiV9
   w==;
X-CSE-ConnectionGUID: ZSB52kABTaKJPNowKPU28A==
X-CSE-MsgGUID: 1+O44jdkT6afXmq+oPnEcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887525"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887525"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:01 -0800
X-CSE-ConnectionGUID: qnIXTLqWTZ23va22SQ/BYA==
X-CSE-MsgGUID: zalW4RTiQNa1H401+BbH6w==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:59 -0800
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
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 15/26] crypto: acomp - Add trivial segmentation wrapper
Date: Sat, 24 Jan 2026 19:35:26 -0800
Message-Id: <20260125033537.334628-16-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch provides a wrapper for existing algorithms so that they can
accept a single segment while returning the compressed length or error
through the dst SG list length.

This trivial segmentation wrapper only supports compression with a
segment count of exactly one.

The reason is that the first user zswap will only allocate the
extra memory if the underlying algorithm supports segmentation,
and otherwise only one segment will be given at a time.

Having this wrapper means that the same calling convention can
be used for all algorithms, regardless of segmentation support.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c         | 33 ++++++++++++++++++++++++++-------
 include/crypto/acompress.h |  1 +
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e3..cfb8ede02cf4 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -170,8 +170,13 @@ static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 
 	state->compl = req->base.complete;
 	state->data = req->base.data;
+	state->unit_size = req->unit_size;
+	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
+					  CRYPTO_ACOMP_REQ_DST_VIRT);
+
 	req->base.complete = cplt;
 	req->base.data = state;
+	req->unit_size = 0;
 }
 
 static void acomp_restore_req(struct acomp_req *req)
@@ -180,6 +185,7 @@ static void acomp_restore_req(struct acomp_req *req)
 
 	req->base.complete = state->compl;
 	req->base.data = state->data;
+	req->unit_size = state->unit_size;
 }
 
 static void acomp_reqchain_virt(struct acomp_req *req)
@@ -198,9 +204,6 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 {
 	struct acomp_req_chain *state = &req->chain;
 
-	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
-					  CRYPTO_ACOMP_REQ_DST_VIRT);
-
 	if (acomp_request_src_isvirt(req)) {
 		unsigned int slen = req->slen;
 		const u8 *svirt = req->svirt;
@@ -248,6 +251,10 @@ static int acomp_reqchain_finish(struct acomp_req *req, int err)
 {
 	acomp_reqchain_virt(req);
 	acomp_restore_req(req);
+
+	if (req->unit_size)
+		req->dst->length = unlikely(err) ? err : req->dlen;
+
 	return err;
 }
 
@@ -268,14 +275,17 @@ static void acomp_reqchain_done(void *data, int err)
 	compl(data, err);
 }
 
-static int acomp_do_req_chain(struct acomp_req *req, bool comp)
+static __always_inline int acomp_do_req_chain(struct acomp_req *req, bool comp)
 {
 	int err;
 
+	if (unlikely(req->unit_size && req->slen > req->unit_size))
+		return -ENOSYS;
+
 	acomp_save_req(req, acomp_reqchain_done);
 
 	err = acomp_do_one_req(req, comp);
-	if (err == -EBUSY || err == -EINPROGRESS)
+	if (unlikely(err == -EBUSY || err == -EINPROGRESS))
 		return err;
 
 	return acomp_reqchain_finish(req, err);
@@ -287,8 +297,17 @@ int crypto_acomp_compress(struct acomp_req *req)
 
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
+
+	if (req->unit_size && acomp_request_issg(req)) {
+		if (!crypto_acomp_req_seg(tfm))
+			return acomp_do_req_chain(req, true);
+
+		return tfm->compress(req);
+	}
+
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
-		return crypto_acomp_reqtfm(req)->compress(req);
+		return tfm->compress(req);
+
 	return acomp_do_req_chain(req, true);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_compress);
@@ -300,7 +319,7 @@ int crypto_acomp_decompress(struct acomp_req *req)
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
-		return crypto_acomp_reqtfm(req)->decompress(req);
+		return tfm->decompress(req);
 	return acomp_do_req_chain(req, false);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 23a1a659843c..86e4932cd112 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -67,6 +67,7 @@ struct acomp_req_chain {
 		struct folio *dfolio;
 	};
 	u32 flags;
+	u32 unit_size;
 };
 
 /**
-- 
2.27.0


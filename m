Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFC01FFC6D;
	Fri,  4 Jul 2025 04:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751603018; cv=none; b=NOdMlpkyXDW72Bg8QHDQrae4Hmt+oVSD3ApZvWzYKjjqv306x22r5V0g75Dv0s0vuAGZl8QCT/OhF5UY+697XdwweGO5vDDEibKbv7J8wLm6fM+vBqEzcRoThILx3jX/ilViOwEFkaMkP+Es4BJIZlI6vf8vXAlz7j+7JhK/fYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751603018; c=relaxed/simple;
	bh=Kmk+iJsQT2Exsw/kR1m8SAtMwjqShpsgO63jDQplw8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H2LwqNuqqlb37XAflvXy+AuI5cPNsbgVfD/pDJfungB+eJk3VZTAwQv1XnaBNOGGjYnMCkyFSZXNDtj+SYBPg+FqcaI0skvBE3kVMkk+AOHLub7vhfx5ow+O5JPDmq7H1dR1+MXec7gE652WM/GO/dUXmJVUNILxideu1oF9GO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QU84ST+/; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QU84ST+/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751603017; x=1783139017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kmk+iJsQT2Exsw/kR1m8SAtMwjqShpsgO63jDQplw8s=;
  b=QU84ST+/W0BNYiLSyeEIZYt2AFx/DLRxbwwqVXP7Wufewoji07onqDVd
   oCfZ+cYqfp69hD7qrjcJpsMQRLbnPmvBcnKSv8xgqxVz2ysayArngi6Xc
   20TMZFroATC5Mgu0Jbo+fKfQ3TxdRiEz54SSZ+D62JLDIvPd/LeA2SpXk
   z74/F39jKaItek/CJ8zQZmH5fLUHrb/7fd2sa/yMkYFlRVymwk3F956Hq
   ofvQRLVdKkYxwY+yCmjxkcG5fHcXPQcQu6S83RUxb0qdiGuh0UK7ntV9J
   Cy6PHGVeF/HvJoy6w08x7nilGfk4eP3Lp+NtJL0EFJKz71/qrk+L2KTKf
   Q==;
X-CSE-ConnectionGUID: d504oV5ETgyO8HwpbplJFQ==
X-CSE-MsgGUID: rvCEyz7MRXqgIC7U6IdeTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53909097"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="53909097"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 21:23:26 -0700
X-CSE-ConnectionGUID: Er3bdchGTuG5T5PevgL8YA==
X-CSE-MsgGUID: +jHzUwczSc+qv779WCs0GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="153968696"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 03 Jul 2025 21:23:25 -0700
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
Subject: [PATCH v10 12/25] crypto: acomp - Add "void *kernel_data" in "struct acomp_req" for kernel users.
Date: Thu,  3 Jul 2025 21:23:10 -0700
Message-Id: <20250704042323.10318-13-kanchana.p.sridhar@intel.com>
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

This commit adds a "void *kernel_data" member in "struct acomp_req":

  @kernel_data:  Private API kernel code data for kernel users

This allows kernel modules such as zswap and zram to input driver data
without interfering with existing usage of acomp_req->base.data.

Since acomp_request_set_params() is the main interface for kernel users
to initialize the acomp_req members, this routine sets
acomp_req->kernel_data to NULL. Kernel users such as zswap will need to
explicitly set acomp_req->kernel_data for interacting with
crypto_acomp_[de]compress(). This usage model will be covered in a
separate patch-series.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 include/crypto/acompress.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 9eacb9fa375d7..0312322d2ca03 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -79,6 +79,7 @@ struct acomp_req_chain {
  * @dvirt:	Destination virtual address
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
+ * @kernel_data:  Private API kernel code data for kernel users
  * @chain:	Private API code data, do not use
  * @__ctx:	Start of private context data
  */
@@ -95,6 +96,7 @@ struct acomp_req {
 	unsigned int slen;
 	unsigned int dlen;
 
+	void *kernel_data;
 	struct acomp_req_chain chain;
 
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
@@ -354,6 +356,7 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 	req->dst = dst;
 	req->slen = slen;
 	req->dlen = dlen;
+	req->kernel_data = NULL;
 
 	req->base.flags &= ~(CRYPTO_ACOMP_REQ_SRC_VIRT |
 			     CRYPTO_ACOMP_REQ_SRC_NONDMA |
-- 
2.27.0


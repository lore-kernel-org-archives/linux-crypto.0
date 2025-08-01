Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F161FE451;
	Fri,  1 Aug 2025 04:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023017; cv=none; b=mC2PMj2d9obOrJv/o9E8yN3U58smqVpisgFLPRscoOBPqyZS0mV9vZMBslRAZm0WiEYcLnBZTBS9NPkpczOI3d1nKqd+b1BZY+JBC8wpPiQpYqwn9rap69OlCDsafOZ4h74VEBfa4opiLtsb7p5TwQ87VoAq+YNBrZU0yzhgONk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023017; c=relaxed/simple;
	bh=Kmk+iJsQT2Exsw/kR1m8SAtMwjqShpsgO63jDQplw8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DSY2ykomM56/fo2UGxgul3I+Tb17m1rhHd0xRhcSwN5fPlgRXJArN2lPwVh88Y4c8bHJT3jyY+bbtmsxUV4LazbbYlicTa5crJEVWGjBcwoW1UDm3BD+hNkc7jdYk68sqXo6UKVvM/doz/Kkvq4VaATs3Wq4dC9C573U7jLsr2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FRkAvmmE; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FRkAvmmE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023015; x=1785559015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kmk+iJsQT2Exsw/kR1m8SAtMwjqShpsgO63jDQplw8s=;
  b=FRkAvmmEy/wgUSBKz7YLh5RiCAoWuvgUshtmRhIvAuSbTacMAH4JDHPk
   aq3TdkSQvbqYnifvjmcC+7cFrt0uJDlbaW6q/US7SSUH9QtCbEsJI4fYe
   XSY6xEPao133EyywPdFezCIE0f033x1v7Ehmqj+5GcWTrwXeN2pP0OAcz
   ju7+3k1WubXkBzbiLCF4PQUplGzHjn4pM8oF880c51x6Ps4JcEZdO4zbh
   +U2rfPuhRkgJkaDAKrP/mRrF0eQvk/M/JZWIdgWlkMn36EMcY0KdycCmq
   e1Xv2Wm2lW5NyqujwpDuHnj4Q2kjBkG45w0Alx4XymsvHgJ6S5shJzfNv
   Q==;
X-CSE-ConnectionGUID: j64CGy5zSmmM1K9eqFlWeQ==
X-CSE-MsgGUID: GfOEOTcVSiCQgt4Vc9NqMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820290"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820290"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:45 -0700
X-CSE-ConnectionGUID: HQ+jdxk6RnOiSN724BwVlg==
X-CSE-MsgGUID: 3rcGpta2QbWn93R7RBNzZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796268"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:45 -0700
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
Subject: [PATCH v11 12/24] crypto: acomp - Add "void *kernel_data" in "struct acomp_req" for kernel users.
Date: Thu, 31 Jul 2025 21:36:30 -0700
Message-Id: <20250801043642.8103-13-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
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


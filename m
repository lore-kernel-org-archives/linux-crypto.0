Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA4A28BA9F;
	Thu,  8 May 2025 19:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733304; cv=none; b=PoZNGhzYqp5J+kxdQa3UBn9ssuKJqOqzNZV5p5U4mCO+0qNJAjNa0yfXX0ZrQ7CGqHA10pGfAjCP6v9in8Ncnkq45QGmR7ZusRgLeYceaubJNybDmxZtryLETT53MYkbObxHHUCznQG0ayK7GehpOHwVyHK9ItNyBQ/vrlt2beU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733304; c=relaxed/simple;
	bh=WKyBT52U1L3mEjci9iHKwXn3qQ9NOODMueb2KPC9q4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=leV1X8X65ckQLbSoXRxF2SVWxP03zreHiwHBg8CA8ATCxWTwIXmWt0W4Uw/Julv/tWCjJyvMtA/aICb2JHL8mL/zBMQfZVQQCbjIK+MItM3mm/74bvWhuwVbuy30g0UETnHJmYLrLsUw63Ea5Qh1fW2SwX0E7aXaY4TPn1sd6mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fonUzAIx; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fonUzAIx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746733303; x=1778269303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WKyBT52U1L3mEjci9iHKwXn3qQ9NOODMueb2KPC9q4M=;
  b=fonUzAIx+umAU871/jhnh10aTCI+5vB4+l1AiUR6ZC95KKZ5ifqKm9GK
   0b3M8psn6lMGsJ+4OsgowsD2jADZ6cHjb/RkiBTnsIHjso8y280RCNEtX
   D3R8OZUk0BwpK9C6sE5YyxsI//tPhbGpnLWO59otLroeuSpxT05p5KOhx
   cVDWImLacBNxsEvBFlDDVBiyDhw8m4js8OA1yUo1TPZ2Zwa0zBqdRr1vy
   foB511m3LeKu0e/FKCDRuvHC+VMrdsCcNISCVVzoZvOhItiRnyI2kyFId
   kF7RQpowq9q0KSWWY5IUvRPF0vi7mZVm0YeJyr6y5+zf53RCWuF/EQalo
   w==;
X-CSE-ConnectionGUID: GdD20rMwQ3CPyF2AnQDvPQ==
X-CSE-MsgGUID: 6XvzeoN0QtenjoMVC+wCLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48454657"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48454657"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:41:40 -0700
X-CSE-ConnectionGUID: NmiaWf8zRE+xGxVwN4rSJA==
X-CSE-MsgGUID: tagljZ4IRdSbiyzYXTkNlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136880851"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 08 May 2025 12:41:39 -0700
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
Subject: [PATCH v9 07/19] crypto: iaa - Define and use req->data instead of req->base.data.
Date: Thu,  8 May 2025 12:41:22 -0700
Message-Id: <20250508194134.28392-8-kanchana.p.sridhar@intel.com>
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

Since req->base.data is for the user and not for the driver, we define a
"void *data" in struct acomp_req for use by driver code.

At present, iaa_crypto saves the "struct idxd_desc *idxd_desc" that is
allocated in iaa_[de]compress(), in req->data. When batching is
introduced in subsequent patches, we will need to support an async
"submit-poll" mechanism to achieve parallelism using IAA hardware. To
accomplish this, we will submit the descriptors for each request in the
batch in iaa_[de]compress(), and return -EINPROGRESS. The polling
function will retrieve the descriptor from req->data to check the
request's completion status.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 12 +++++++-----
 include/crypto/acompress.h                 |  2 ++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 2f2dc6987cc6..0b821b8b4264 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1718,7 +1718,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	iaa_wq_put(idxd_desc->wq);
 }
 
-static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
+static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
 			dma_addr_t dst_addr, unsigned int *dlen,
@@ -1778,8 +1778,9 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 			" src_addr %llx, dst_addr %llx\n", __func__,
 			active_compression_mode->name,
 			src_addr, dst_addr);
-	} else if (ctx->async_mode)
-		req->base.data = idxd_desc;
+	} else if (ctx->async_mode) {
+		req->data = idxd_desc;
+	}
 
 	dev_dbg(dev, "%s: compression mode %s,"
 		" desc->src1_addr %llx, desc->src1_size %d,"
@@ -1889,8 +1890,9 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			" src_addr %llx, dst_addr %llx\n", __func__,
 			active_compression_mode->name,
 			src_addr, dst_addr);
-	} else if (ctx->async_mode && !disable_async)
-		req->base.data = idxd_desc;
+	} else if (ctx->async_mode && !disable_async) {
+		req->data = idxd_desc;
+	}
 
 	dev_dbg(dev, "%s: decompression mode %s,"
 		" desc->src1_addr %llx, desc->src1_size %d,"
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 267d557daeb1..01389fd7055f 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -81,6 +81,7 @@ struct acomp_req_chain {
  * @doff:	Destination folio offset
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
+ * @data:	Private API code data, do not use
  * @chain:	Private API code data, do not use
  * @__ctx:	Start of private context data
  */
@@ -101,6 +102,7 @@ struct acomp_req {
 	unsigned int slen;
 	unsigned int dlen;
 
+	void *data;
 	struct acomp_req_chain chain;
 
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
-- 
2.27.0


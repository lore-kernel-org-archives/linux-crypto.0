Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3852C2AA1;
	Wed, 30 Apr 2025 20:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746046395; cv=none; b=gpFdDmvAEKhaRAaeBoZazGQntS6suHP4X1cx4HWJxTO4Z5Sb4wufAu6PdkB7C8hjtx4Ak49k5sKImHJRK444nXQBW3XI19QBPhN3G7P3fXO7UltKSmPcRt6LAtFQj59PW38etMtkw/5p79R8tlKBOhBG2XlQjeBg8M+ycCLggvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746046395; c=relaxed/simple;
	bh=WKyBT52U1L3mEjci9iHKwXn3qQ9NOODMueb2KPC9q4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mod9sQzW8twpoarWDWUz+CHekWEZTcunC4sh9arhfQzirxDGfX9Gqg1OjoomYkkV+daF6trzIfEYnPfUx+u2k7Vhl3OH4XTkBmE29GXz+M1bLtdTKQXsRWPG/pRqLPIzYfVbcObh9zkK885BfdQE+lf87eIZQhvlt6itpOgtFnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cj0McV2+; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cj0McV2+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746046394; x=1777582394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WKyBT52U1L3mEjci9iHKwXn3qQ9NOODMueb2KPC9q4M=;
  b=cj0McV2+9cpQdrY63VcC+t6wsOM4F2jo2zpLvprIujNIm+pnPaI7USXI
   gbgdWq/VuMuy6JYifTBIXouGy0wJ1gc+8F7QkPqShx3yekDWKPq3k4/tf
   5n8Glkicd/MRcvRHcyTyfE6lT2n3mz/GbA+SygHksVlXbE0qw6WGPwhCd
   SAY3Zo5nPqG5/ngZPZVu/5qlKWfGk9o1uA3YLB88slwXgZjQIgFfGIHHW
   ekHTVlSeU2dN+jgTcW64qto+mkmCiQRUv7U59GJacha55qJ2HE7JZOEqc
   E0Hv8d/XjsOwrWISQqA+jb835dKcq9dPT4VmwbErHhiZpxCzGtw2MC78F
   w==;
X-CSE-ConnectionGUID: TFgtEG7zREq/rHFil0yGnw==
X-CSE-MsgGUID: ezCmCxaMQVqsA6hOg4aPTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51388571"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="51388571"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:53:13 -0700
X-CSE-ConnectionGUID: zRmnVO5iRN+pmqNzjQ2kwg==
X-CSE-MsgGUID: C+FBmurUTvCXJDo87pycMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="138248904"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 30 Apr 2025 13:53:12 -0700
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
Subject: [PATCH v9 07/19] crypto: iaa - Define and use req->data instead of req->base.data.
Date: Wed, 30 Apr 2025 13:52:53 -0700
Message-Id: <20250430205305.22844-8-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
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


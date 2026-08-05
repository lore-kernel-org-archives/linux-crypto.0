Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495623EE1EE;
	Wed,  5 Aug 2026 21:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785964829; cv=none; b=g8oK5vuxD+JSRKlPI5TExs916Dv3zVt0ZWb3u11QIX3RGPeO5otAXh3vdxXrrvpZkx0n4c3/EsieUv6F7WUvmHKG+pJMrcPF9GIRKiCl8hvrJK+K80UxS59hk88Y0n+nfhi9d7yFWEvDtwpaKI3iLqGp4U5bFzVK42/sKJOOD8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785964829; c=relaxed/simple;
	bh=fpRoZKbF2e8q5k7sXeU2+xeaef+9Njs626uYt/34cH4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gJ597kcVuclqPd0BYU8ICQ21YalQ7rxD8mxHpo8VJG4yhZRwWziJ7+/GkZ0SzgGxx5UuozAAlccPdVKdhuQyTJvRf4vEgT74O4A5PgeXHakQYvjeC2/qNcRHVDWrKZVMFnTeheZX11Wh7S1O+WKtVahB/MNRcnQ1M2vOW+2H8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DJYMWqz2; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DJYMWqz2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785964823; x=1817500823;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=fpRoZKbF2e8q5k7sXeU2+xeaef+9Njs626uYt/34cH4=;
  b=DJYMWqz2wBwOurJjk/eWMay3ESdWP40HS7oH288MdLEdD4IufLuUJGtz
   s10rU4WRNSwPVpXY1OxodXHA9h1Rp/rCHkMh8vTkoGaIHhRX2DVDC9fjJ
   MoESPKIBOLAHMmpuv058fCoyhw9J3Hte/VVD7+XmJLvm5g8nXw3PhPTyx
   0V5qVnjEOsYRvvtxY8SKIKT+BdIi6UiecUvREkL4TNS6hFdT58ahmJSM+
   lWI/E7aqu60RHvhO1kSqdix4wKotIj7zYJ4uFy/RtWioHaFvy3taVWrEi
   GLe3I0+gVOOGh9Pc63M7HH2JyQbi4JDGtrdaWCGdqqyTM49cS2drDjtqv
   g==;
X-CSE-ConnectionGUID: ASPAX9bFRwaRTTM4syURsA==
X-CSE-MsgGUID: +uie/gs0RPu5ylI14gFmuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109341694"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109341694"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:49 -0700
X-CSE-ConnectionGUID: Z4I1BAlYQ7iSmKcSmjDDUg==
X-CSE-MsgGUID: 6FylbtVgQkikTWR6eBwdYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="300138486"
Received: from vcostago-desk1.jf.intel.com (HELO [10.88.27.144]) ([10.88.27.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:49 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Wed, 05 Aug 2026 14:19:26 -0700
Subject: [PATCH v2 5/5] crypto: iaa - unmap dst before software fallback on
 decompress
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260805-iaa-crypto-fixes-zswap-v2-5-55c02694f499@intel.com>
References: <20260805-iaa-crypto-fixes-zswap-v2-0-55c02694f499@intel.com>
In-Reply-To: <20260805-iaa-crypto-fixes-zswap-v2-0-55c02694f499@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>, 
 Frank Li <Frank.Li@kernel.org>, 
 Kristen Accardi <kristen.c.accardi@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785964788; l=3568;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=fpRoZKbF2e8q5k7sXeU2+xeaef+9Njs626uYt/34cH4=;
 b=86mR1jS9vLMsfNcxuBjSZQZnzXqC3W5RubH6HCjxOCxSHdw5ZSd+pj6DXrsVVUNayQLHURzkU
 E3y2/Ba7jgDCQD39ss8oZr2d+AXCwQOykwcw0AfnZ17/19E8mF+aKFP
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

On a hardware analytics error, decompress retries through the software
fallback, which writes req->dst with the CPU while it is still mapped
DMA_FROM_DEVICE. With SWIOTLB active the later dma_unmap_sg() copies the
stale bounce buffer over req->dst, corrupting the result.

Unmap before the fallback runs. The async path unmaps inline; the sync
path signals the retry with -EAGAIN so iaa_comp_adecompress() runs the
fallback after unmapping.

Fixes: 2ec6761df889 ("crypto: iaa - Add support for deflate-iaa compression algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 35 +++++++++++++++---------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 51547c5fcf70..c9ab4b83ae02 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -995,6 +995,11 @@ static inline int check_completion(struct device *dev,
 	return ret;
 }
 
+static bool iaa_error_should_retry(struct idxd_desc *idxd_desc)
+{
+	return idxd_desc->iax_completion->status == IAA_ANALYTICS_ERROR;
+}
+
 static void iaa_unmap_src(struct device *dev, struct acomp_req *req)
 {
 	struct iaa_req_ctx *req_ctx = acomp_request_ctx(req);
@@ -1082,18 +1087,21 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 			       ctx->compress, false);
 	if (ret) {
 		dev_dbg(dev, "%s: check_completion failed ret=%d\n", __func__, ret);
-		if (!ctx->compress &&
-		    idxd_desc->iax_completion->status == IAA_ANALYTICS_ERROR) {
+		if (!ctx->compress && iaa_error_should_retry(idxd_desc)) {
 			pr_warn("%s: falling back to deflate-generic decompress, "
 				"analytics error code %x\n", __func__,
 				idxd_desc->iax_completion->error_code);
+			dma_unmap_sg(dev, ctx->req->dst, sg_nents(ctx->req->dst),
+				     DMA_FROM_DEVICE);
+			iaa_unmap_src(dev, ctx->req);
+
 			ret = deflate_generic_decompress(ctx->req);
 			if (ret) {
 				dev_dbg(dev, "%s: deflate-generic failed ret=%d\n",
 					__func__, ret);
 				err = -EIO;
-				goto err;
 			}
+			goto out;
 		} else {
 			err = -EIO;
 			goto err;
@@ -1477,19 +1485,9 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
 	if (ret) {
 		dev_dbg(dev, "%s: check_completion failed ret=%d\n", __func__, ret);
-		if (idxd_desc->iax_completion->status == IAA_ANALYTICS_ERROR) {
-			pr_warn("%s: falling back to deflate-generic decompress, "
-				"analytics error code %x\n", __func__,
-				idxd_desc->iax_completion->error_code);
-			ret = deflate_generic_decompress(req);
-			if (ret) {
-				dev_dbg(dev, "%s: deflate-generic failed ret=%d\n",
-					__func__, ret);
-				goto err;
-			}
-		} else {
-			goto err;
-		}
+		if (iaa_error_should_retry(idxd_desc))
+			ret = -EAGAIN;
+		goto err;
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
 
@@ -1722,13 +1720,16 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	if (ret == -EINPROGRESS)
 		return ret;
 
-	if (ret != 0)
+	if (ret != 0 && ret != -EAGAIN)
 		dev_dbg(dev, "asynchronous decompress failed ret=%d\n", ret);
 
 	dma_unmap_sg(dev, req->dst, 1, DMA_FROM_DEVICE);
 	iaa_unmap_src(dev, req);
 	iaa_wq_put(wq);
 
+	if (ret == -EAGAIN)
+		ret = deflate_generic_decompress(req);
+
 	return ret;
 }
 

-- 
2.55.0


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4723F1AC5;
	Wed,  5 Aug 2026 21:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785964826; cv=none; b=ELl4fRPsSo4AtO2cULpvFL7gX1Ny7amjYhECgpGFY+eY0KJxpUHlq9AurMUpOnzMLPi5d5m0uZx38KEBmiAoVKLqPkXantTmhr2E3WbvmZWJWVboKCEEvUwJnB8UKDI246sND3Yl6nzB2zo1gLig+rOnh/y9UfkoObvtQ548x4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785964826; c=relaxed/simple;
	bh=2gCd4qkpTC2cn0TrW9fNKJsdBnOMA4DDLXfjvTEGzkU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ao1o828JMQxuGA4JHn+iVlKtVlY4mjS0Xqa+XHRKxNPM4pzgZ03JUe9e5SHIWPHGZlUKrBabBdYnacsb3c5mrJbq6bxUvS1tcqQnQDduM9GapwHnRA7mGyBqt5YeNlKk/QLPVm61Q1sP1p/gk3BkG81l3P8xdaR5pdoaDFtp1+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RZGNIfkY; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RZGNIfkY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785964820; x=1817500820;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=2gCd4qkpTC2cn0TrW9fNKJsdBnOMA4DDLXfjvTEGzkU=;
  b=RZGNIfkYub2pAFrkVcegwSbcAYv23DCrTI6iA0yIx5u41ROdpKqSAzej
   QNAr+UoobNzdf0ws16fz7ayPoGWuPEbqQv7jc9KyN6pJOkBbcNPJWPgnK
   g7kznVgLHnOIYoUZzJ1JyUUQW8O7Yp66ZCG6tA9iXWicFuSIoBZtXGeB6
   3pXR9tAc+bodjRHQEejCKFs5f7vs/F0CKyaYYGUmB/q4c4kkFN+3zByfv
   igrgkQrD9H2H7PU0hLyo05gldvudZof9h9CUyXgTuNSMEsTsVRxZwey4G
   kPY45Ehi7aMR39rJ+FjJTxoqZuvVa9ARqlWMJxxQbgp0uKtAQp24vb3yR
   g==;
X-CSE-ConnectionGUID: ka60IwI5TmCrKnuvUYPTTA==
X-CSE-MsgGUID: ea9vuo+5TUK2DXSPdP+tFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109341688"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109341688"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:49 -0700
X-CSE-ConnectionGUID: LlRD53ImQg+hymcvEEbnIg==
X-CSE-MsgGUID: 6p6cL0YjRpGn29ZItKnJZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="300138481"
Received: from vcostago-desk1.jf.intel.com (HELO [10.88.27.144]) ([10.88.27.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:49 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Wed, 05 Aug 2026 14:19:24 -0700
Subject: [PATCH v2 3/5] crypto: iaa - avoid counting fallback decompression
 bytes
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260805-iaa-crypto-fixes-zswap-v2-3-55c02694f499@intel.com>
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
 Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785964788; l=2018;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=xj4K3URZRVeDWjfTpUmV9VHYcH37W3JvnbOHwvU4O+I=;
 b=BzQqsmRIfA9oZNQ8hrLfEWckHcLXWkjlihWfddUHBI2hGxBPRk7Q4ROOQcO33wrg2J5HmGlki
 6Fi+5bs7Nr6AINm6PdcyjuCZ+FProR/W8lOuLjq3dG9ka9TiGTPmBhw
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

When decompression falls back to deflate-generic after an analytics
error, the request no longer completes through IAA.

Move decompression byte accounting into the successful IAA completion
path in both the synchronous and asynchronous flows so decomp_bytes only
reflects bytes actually processed by IAA.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 904d9413ba18..9505ca23e6f3 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1071,15 +1071,17 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 		}
 	} else {
 		ctx->req->dlen = idxd_desc->iax_completion->output_size;
+
+		if (!ctx->compress) {
+			update_total_decomp_bytes_in(ctx->req->slen);
+			update_wq_decomp_bytes(iaa_wq->wq, ctx->req->slen);
+		}
 	}
 
 	/* Update stats */
 	if (ctx->compress) {
 		update_total_comp_bytes_out(ctx->req->dlen);
 		update_wq_comp_bytes(iaa_wq->wq, ctx->req->dlen);
-	} else {
-		update_total_decomp_bytes_in(ctx->req->slen);
-		update_wq_decomp_bytes(iaa_wq->wq, ctx->req->slen);
 	}
 
 	if (ctx->compress && compression_ctx->verify_compress) {
@@ -1462,16 +1464,16 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		}
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
+
+		/* Update stats */
+		update_total_decomp_bytes_in(slen);
+		update_wq_decomp_bytes(wq, slen);
 	}
 
 	*dlen = req->dlen;
 
 	if (!ctx->async_mode)
 		idxd_free_desc(wq, idxd_desc);
-
-	/* Update stats */
-	update_total_decomp_bytes_in(slen);
-	update_wq_decomp_bytes(wq, slen);
 out:
 	return ret;
 err:

-- 
2.55.0


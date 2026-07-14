Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A4E36AB77;
	Tue, 14 Jul 2026 04:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784002273; cv=none; b=Q5VeEBNrkhDLZzdEHwQohrlTKBER4mF0o03d2z3nq1l7t//TMv5I9RapklxvD2CCkA1RjvzHyXPuYBwRkKue4THoEKSwcmCuDuNgFEztoe9Ot+Gj2b9rLoz1jwzHHpe926Mj3UXaSTHAPthGi9LM6cssC2oLadt6wWHXI5fblsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784002273; c=relaxed/simple;
	bh=DimQniesOwePrAQW8cknWA9ZqhNGU3Pe01x+pNQhS2w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=r/mxyEsyUg7Zl5dCrzH0HIXZc2h59v+1BZFbyj9GTYQFuTmBux5v04+VVeXecVyA4lJXAGNQhoia3CAHm6UJzBZWMPZecd4sGpOj6jcWu3GscnQdC/maesz+0tea3xBFA4onduciOuFPdxfyjYxsLQw6A9yUFhMW0GDaa82PU00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CSmEQYGz; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CSmEQYGz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784002272; x=1815538272;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=DimQniesOwePrAQW8cknWA9ZqhNGU3Pe01x+pNQhS2w=;
  b=CSmEQYGzIq8IHCPxhqzhl6IutPivQMinfoTw2H9DeN/HdZN6aZVXq0xR
   ixjP3lognvdl5MyvUCdtT/Sf0CwiOUARqHtNJhVR0DZVb8Sy771mQcSTV
   sz2Dk02MBhhdEidlLDgrZJEJbI917NKeEv60D9yy0yA7VRipOuT7c1aqS
   YmBKnMJPWnE9arEUw80LOhx1eZhMEu/AJNQAf1F1ateV2m1EOsIdC800t
   gsFcxTjrwupvBOHmbDZ4icTjE/ck7ED7+vE107lV5mulK0HkLeRXvq4Km
   heFWYaisVBeymDVHnymW7HKNe4aplf9uuaXzcG1Mf7CXs3gKpy6UpSE4A
   A==;
X-CSE-ConnectionGUID: VICxpeFRSM2UOKjnxTni7w==
X-CSE-MsgGUID: dthsovrtSoeIqIJpmwWd0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="94970487"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="94970487"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 21:11:10 -0700
X-CSE-ConnectionGUID: JYn3O0UXR0KxeqAW3xbqaA==
X-CSE-MsgGUID: df/vGAT3S42mrFH0iBy5TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="249383520"
Received: from vcostago-desk1.jf.intel.com (HELO [10.88.27.144]) ([10.88.27.144])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 21:11:09 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Mon, 13 Jul 2026 21:10:55 -0700
Subject: [PATCH 3/4] crypto: iaa - avoid counting fallback decompression
 bytes
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-iaa-crypto-fixes-zswap-v1-3-65cac23c684d@intel.com>
References: <20260713-iaa-crypto-fixes-zswap-v1-0-65cac23c684d@intel.com>
In-Reply-To: <20260713-iaa-crypto-fixes-zswap-v1-0-65cac23c684d@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784002267; l=1906;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=Bzzsxw3x1+Awdq1YVut9OLn/yRKJ1WIjPIJmOnYqEXs=;
 b=jcqR1EHjhR2o3aNkqtGmNPbjADHFM/OXYYkPRUBbe8ylwoaFOvv+3NpmqKMgiTsJ+2RWgFNSp
 yi3C0wYFidkCEWTrr+IEC+9EyxeqBdCYuyt1hXv9EpwvWYijnmRXq5/
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

When decompression falls back to deflate-generic after an analytics
error, the request no longer completes through IAA.

Move decompression byte accounting into the successful IAA completion
path in both the synchronous and asynchronous flows so decomp_bytes only
reflects bytes actually processed by IAA.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index fb154959c2aa..8f68b1478476 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1084,15 +1084,17 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
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
@@ -1475,16 +1477,16 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792451199;
	b=J7pargOHwk438DmMq2rW7OwM4WlbtPtKNoS7/TPiyryALEDlCgSKhXRlTykzqPO4fBKZ
	 F24clNuCaaI75oPIvb6gDXPdwzg4ZRByv9iAsLOk+BxKTgRjAL9wStxRsgFTS0M0tWkRp
	 /JhUVJbvPJ35mU2S5h4SPWmilqKwfpgTrgZXk6/XAWbTt3ZBAcpLhmloNCvrcwgSppQWf
	 jQTFLIwhvvhSpEA6YSQYwdRYs2T0Blg2qWJui+K580SLiq5x1KV5zWPduvac2KOWCY9nd
	 XQgVdxUjBRCWIMdARpx84whnwbm9YeGAOuO18eiCNQscETkca9he8kV+W7qODpmbHgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451199;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=DYOYKIvx6b3Y3aPOxGUrup+U2yFn3WqpjX7LhjjpSEA=;
	b=0ORkpVJ/n8btAtRpiBvmgJ3o/gdWLgGCX6df0wVq5X6Mws162cjtHYxavubya2hsiOtb
	 DTnsiqLbII9EZzRv/iUwUdDuDsx7aSa/0bOWwIP5iOxDES9X/HLG9jyCMdEgLE2+GIIQ4
	 YJZONntFXPYoYA4SDmklTw9wHAZC9buh0fP0vURXFPsfGHnxlJww9WSuaQ6DIYMPCuH/C
	 nJUqcLn+3aCm58T4rBODTgEceIMYKAkf4I+KD4XZnYMzW9/rjXIHLFqGtgQZTzJDuVbz4
	 L4ZdKvWSdfewRiBJr+Aj1OT+DwgStanD+/IfPGcNmUylFAvBQOsswP7+st1R3jeYFEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZaguGSdI;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E68606A31B;
	Mon, 19 Oct 2026 23:06:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0E68606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZaguGSdI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792451198; x=1823987198;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=iEKA2AyZdkz+MXs7DYO4QeDo4cly4nKKPbqXuZnTmQ4=;
  b=ZaguGSdI7GddkHzlibLUA+Nmx+SQ4PuEb69arzQAKp1QunrxEVjrwHiL
   a7SRaQIPUC0dzv6lNW/MaUaOlD74VKFK/GxdrTRs3WT38egtW3hygpDn8
   M2tzIVqwfhVv8CcPgFZqwlW2GqtmDFZHUd4oNq0om4xlmHOhcOHxnyFmd
   iBiapk40lZPzDwltM4rFslVe7pzvR3dy9IHnOxwPsP0qugCbu5An7ufLZ
   WnE6lW74xhdLWoLj8OmjmKgcDYczsBe1nq8h9ybsY+eyabRAg6lLngNZx
   wy0WESyGEn6qdwEWYaMlF8iKULtMZdWeO1lLIr2GtGMOZWWZVmsaHzMVE
   w==;
X-CSE-ConnectionGUID: 6qNtMbKgSHyJIy/AnHrMSg==
X-CSE-MsgGUID: rQCtG8g3SZSwb0zTRrWvMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1249175"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1249175"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:36 -0700
X-CSE-ConnectionGUID: IlHiKjb1SDyP0DCzurp3ZQ==
X-CSE-MsgGUID: nm6UnrKlSLmXulIBAuGgwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2989971"
Received: from vcostago-desk1.jf.intel.com (HELO [10.98.24.84]) ([10.98.24.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:35 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Mon, 19 Oct 2026 16:06:20 -0700
Subject: [PATCH 1/4] crypto: iaa - carry the iaa_wq in the request
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-iaa-crypto-wq-tables-v1-1-fab67b2a1538@intel.com>
References: <20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538@intel.com>
In-Reply-To: <20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538@intel.com>
To: Kristen Accardi <kristen.c.accardi@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
X-Mailer: b4 0.17-dev-6be7c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792451190; l=3039;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=iEKA2AyZdkz+MXs7DYO4QeDo4cly4nKKPbqXuZnTmQ4=;
 b=/kTHq4vYKzBU+7IfrJDIKVis89wtoKoPewEQBGKOmNdRJpOSvgodt38j0fZQS3jm8Xec4x2w3
 l8VDz+3Y+dVCwCF0wspdSeZHiFtqAJoSCJiypOz3qSniZ/XsPs6o23U
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

The submit helpers and the completion look the iaa_wq up again through
the WQ's private pointer, after the entry point has already found it to
take its reference. The submit helpers are also passed the WQ
separately, so a request has no single record of which WQ it holds its
reference on.

Store the iaa_wq in the request context when the reference is taken, and
use it everywhere after that. This makes the association of a
IAA workqueue and the request clear.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index c9ab4b83ae02..0f5bd244b00a 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -159,6 +159,7 @@ static bool async_mode;
 static bool use_irq;
 
 struct iaa_req_ctx {
+	struct iaa_wq *iaa_wq;
 	u32 compression_crc;
 	struct page *bounce_src;
 	dma_addr_t bounce_src_dma;
@@ -1070,7 +1071,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 
 	compression_ctx = crypto_tfm_ctx(ctx->tfm);
 
-	iaa_wq = idxd_wq_get_private(idxd_desc->wq);
+	iaa_wq = req_ctx->iaa_wq;
 	iaa_device = iaa_wq->iaa_device;
 	idxd = iaa_device->idxd;
 	pdev = idxd->pdev;
@@ -1177,7 +1178,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 	struct device *dev;
 	int ret = 0;
 
-	iaa_wq = idxd_wq_get_private(wq);
+	iaa_wq = req_ctx->iaa_wq;
 	iaa_device = iaa_wq->iaa_device;
 	idxd = iaa_device->idxd;
 	pdev = idxd->pdev;
@@ -1328,7 +1329,7 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct device *dev;
 	int ret = 0;
 
-	iaa_wq = idxd_wq_get_private(wq);
+	iaa_wq = req_ctx->iaa_wq;
 	iaa_device = iaa_wq->iaa_device;
 	idxd = iaa_device->idxd;
 	pdev = idxd->pdev;
@@ -1405,6 +1406,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct iaa_req_ctx *req_ctx = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc;
 	struct iax_hw_desc *desc;
@@ -1414,7 +1416,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct device *dev;
 	int ret = 0;
 
-	iaa_wq = idxd_wq_get_private(wq);
+	iaa_wq = req_ctx->iaa_wq;
 	iaa_device = iaa_wq->iaa_device;
 	idxd = iaa_device->idxd;
 	pdev = idxd->pdev;
@@ -1555,6 +1557,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	}
 
 	iaa_wq = idxd_wq_get_private(wq);
+	req_ctx->iaa_wq = iaa_wq;
 
 	dev = &wq->idxd->pdev->dev;
 
@@ -1664,6 +1667,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	}
 
 	iaa_wq = idxd_wq_get_private(wq);
+	req_ctx->iaa_wq = iaa_wq;
 
 	dev = &wq->idxd->pdev->dev;
 

-- 
2.56.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792451203;
	b=vWSEZMvpTVeLLfhL1wCUFD/2f/0cXLlyekZvGjXBLKnPxsOHJgdoAYhaP7TfzcaLtAEc
	 zUVEjQvcvngLZD6FcPnaK33n9p4W3I3Qr3CaPyWOTtoqsGQwPAUmRkjWEF+xruExco6uQ
	 H6sGZnI+G3JSq7hgU8nfGq8nL05sSkS3WBHn4iaAI7YMb9ZMt6pQ/E5fhoQbb46qu0/3c
	 /32tIQ38t2XE2UByaqcF8P2nVeD2bykArAUg7d5zRtoAPUCVUF7dV/QBZNI0bdbP0lG27
	 IQTO9VozV/dzAl5SWo7SO0AVJ/eD3jBb7keTfG0vjVat+V6RgwhBxNBeAwg2YKIl/lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451203;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=8OzSBSKQBAQmP8x7/bKwGU98Enj16fS4z9hEf8giMac=;
	b=yiaOAvsBiIUhdWSkQp0kv68H0e+8RDN7bUiJDvAG3RO6p6064zRgxhYGcNbOjyqu/S76
	 tCaL4iSMCuzgyTBH2sWxUUkTVSqSsHD3z8TSk9W0FNItbVpw7LDSFxYQofePSaj2hBWDa
	 4xdXHwrEC4w70G2IAOv+ejjLcPbNcoz9it8dIearFEqOBlP5SenTYrhQZM7/49AL8OL6s
	 4s9QWfBtVwYLk546kxyhVYY6cTFPOBC5N4GAJLELc8iEbRXnN/oJt0XJc5S4HtB5SyOBb
	 B5KcUgFbbaiZJsnB+7nByoVtzk1/XPYhWJcVIBm3i0dgOViDA5zlFfTsocV8qKO1FEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=M53zdsuE;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1131C606A319;
	Mon, 19 Oct 2026 23:06:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1131C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=M53zdsuE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792451198; x=1823987198;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=hRlLc+25IiT02qqUKtrDG21UjsoWBK02Oeivj/ogzp4=;
  b=M53zdsuEEQ7fzJI9ZylYRHF91aLaujcF7Iao6Lt07BpIwsSCUGxJd/+J
   MQ+/uFyt3BcDXXPgLw3xeESSUz63tgBhVRoXpybsQ5PZD8d+nvNocDjfW
   HnQCOoLfCV+U10Kv9a4vZR4qSL1bMOCYokrlGDnXfSrCOUUIHyW1PtBXC
   ObYwNUSzcPVCVKcbwplNBSLJ19T1txxTADDa24EhAP33x746H+os3TmD6
   bmRzgdo0P1IrMBBB3UdmyBR0oTV1YxCEaabhVfuBE6JLefU4S4UOZCCvq
   58/sY9BCOjr7TVYt6Ylm7LCOcTa3+keHUbwodYftzzjleV/3jf0/8hbxg
   Q==;
X-CSE-ConnectionGUID: pH1oazzySfG6JlJpKbPnIQ==
X-CSE-MsgGUID: iRJAMi+ISF2R1RLNMO+ufA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1249178"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1249178"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:36 -0700
X-CSE-ConnectionGUID: 1nUGjk8kRbmneG4yXjRNhg==
X-CSE-MsgGUID: MQZ1shB3TwSKl1QZuGrjVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2989974"
Received: from vcostago-desk1.jf.intel.com (HELO [10.98.24.84]) ([10.98.24.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:35 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Mon, 19 Oct 2026 16:06:21 -0700
Subject: [PATCH 2/4] crypto: iaa - take the WQ from the request in the
 submit helpers
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
Message-Id: <20261019-iaa-crypto-wq-tables-v1-2-fab67b2a1538@intel.com>
References: <20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538@intel.com>
In-Reply-To: <20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538@intel.com>
To: Kristen Accardi <kristen.c.accardi@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
X-Mailer: b4 0.17-dev-6be7c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792451190; l=4691;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=hRlLc+25IiT02qqUKtrDG21UjsoWBK02Oeivj/ogzp4=;
 b=J3cFfUC1vtYfgnhFeNuZpSxp5qsnqplgqEZfXAWnTWN6AqVtJQWYjXpxK4xn7bUHGVnZEmHe9
 LpSiHU1BGcyCoL9HDov3lpKVMybtmYEmXYeY0YIg5ddIfbVeZlustgN
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

iaa_compress(), iaa_compress_verify() and iaa_decompress() take the WQ
to submit to as a parameter, and also find the iaa_wq in the request
context. Nothing ties the two together.

Drop the parameter and use the request's iaa_wq->wq.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 0f5bd244b00a..7b02d3836623 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1049,7 +1049,6 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 				dma_addr_t *src_addr, dma_addr_t *dst_addr);
 
 static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
-			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
 			       dma_addr_t dst_addr, unsigned int *dlen);
 
@@ -1134,7 +1133,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 			goto out;
 		}
 
-		ret = iaa_compress_verify(ctx->tfm, ctx->req, iaa_wq->wq, src_addr,
+		ret = iaa_compress_verify(ctx->tfm, ctx->req, src_addr,
 					  ctx->req->slen, dst_addr, &ctx->req->dlen);
 		if (ret) {
 			dev_dbg(dev, "%s: compress verify failed ret=%d\n", __func__, ret);
@@ -1162,7 +1161,6 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 }
 
 static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
-			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
 			dma_addr_t dst_addr, unsigned int *dlen)
 {
@@ -1175,10 +1173,12 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
 	struct pci_dev *pdev;
+	struct idxd_wq *wq;
 	struct device *dev;
 	int ret = 0;
 
 	iaa_wq = req_ctx->iaa_wq;
+	wq = iaa_wq->wq;
 	iaa_device = iaa_wq->iaa_device;
 	idxd = iaa_device->idxd;
 	pdev = idxd->pdev;
@@ -1313,7 +1313,6 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 }
 
 static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
-			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
 			       dma_addr_t dst_addr, unsigned int *dlen)
 {
@@ -1326,10 +1325,12 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
 	struct pci_dev *pdev;
+	struct idxd_wq *wq;
 	struct device *dev;
 	int ret = 0;
 
 	iaa_wq = req_ctx->iaa_wq;
+	wq = iaa_wq->wq;
 	iaa_device = iaa_wq->iaa_device;
 	idxd = iaa_device->idxd;
 	pdev = idxd->pdev;
@@ -1400,7 +1401,6 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 }
 
 static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
-			  struct idxd_wq *wq,
 			  dma_addr_t src_addr, unsigned int slen,
 			  dma_addr_t dst_addr, unsigned int *dlen)
 {
@@ -1413,10 +1413,12 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	struct idxd_device *idxd;
 	struct iaa_wq *iaa_wq;
 	struct pci_dev *pdev;
+	struct idxd_wq *wq;
 	struct device *dev;
 	int ret = 0;
 
 	iaa_wq = req_ctx->iaa_wq;
+	wq = iaa_wq->wq;
 	iaa_device = iaa_wq->iaa_device;
 	idxd = iaa_device->idxd;
 	pdev = idxd->pdev;
@@ -1582,8 +1584,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	dev_dbg(dev, "map dst %llx req->dst %p dlen %d sg_len %d\n", dst_addr,
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
-	ret = iaa_compress(tfm, req, wq, src_addr, req->slen, dst_addr,
-			   &req->dlen);
+	ret = iaa_compress(tfm, req, src_addr, req->slen, dst_addr, &req->dlen);
 	if (ret == -EINPROGRESS)
 		return ret;
 
@@ -1594,7 +1595,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 			goto out;
 		}
 
-		ret = iaa_compress_verify(tfm, req, wq, src_addr, req->slen,
+		ret = iaa_compress_verify(tfm, req, src_addr, req->slen,
 					  dst_addr, &req->dlen);
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
@@ -1719,8 +1720,8 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	dev_dbg(dev, "map dst %llx req->dst %p dlen %d sg_len %d\n", dst_addr,
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
-	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
-			     dst_addr, &req->dlen);
+	ret = iaa_decompress(tfm, req, src_addr, req->slen, dst_addr,
+			     &req->dlen);
 	if (ret == -EINPROGRESS)
 		return ret;
 

-- 
2.56.0


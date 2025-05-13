Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4131E5B7A
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 06:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116254; cv=none; b=CBMK+oyL88EKxcfOR9ClN8P5WrSGjNVFB78TlaLodvltiuJoRiOwT9ZJG1USVa2YUOEzYTZnz/mYaCr7lKOyTNmflCot6iCBhz8PozWNKCfbfuhCuH8ARRZSG1uPgmARirRdsKblp1fT9k3T956irz54QYRSAaIuOclch0L6buc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116254; c=relaxed/simple;
	bh=WVQVWl7uAnuBYxIB+zxO4djbrZQl/RZJdOCNVUal+Wg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=WZ/yRp7lAErAE5Q7q+weaNrvYfnmPtWoZ/4v0fSyUUbcfNYwxeyAVc3CN7TKzJhNv9vngJlFUauoswz+utqRig2eq8qspCJHkzhpvv3VV+Re8oD7cp5y2Zasjs0E2S4vVK6yfRdf06rFhpavzyEW8T15ZkZb1SShXm2Q5/PKyCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BUhd5ZUM; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BUhd5ZUM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=4Wtwzookz1HcELV23w9yfUZZzRBWFBxswmKn3PTe1iA=; b=BUhd5ZUMed8sFBr3W4Xv6t4PIh
	+DJAGKLIhpIoq0XDh7/JKKKY25q8NdVLJZAHyeDJoUM9NcsJnZyoqtExv+MiWrbsTFn43JzDMFL+l
	myY4YIE6cvCo/K7Ssqpbrp/vEhjfoFJIDiJXZwMa5zl7U2AorNXDOp/EknLaKTXTz06P+qi1PJMgm
	5AmhHk3FTGTRQ47SsC93JcVAV5fvE/gKJf7tqXXSyauZBtxX5v9EiuMPkoKLd/+vQ2lchdr3Fbl5V
	MX9ujeXy/xRLm/qNSAGTi82saqCFDEWEZ4ghvTx/UA5HWthDUk8cprJQxKoV9fxxs9C1hjIwBe/St
	D0iogDtg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEikI-005g6J-1e;
	Tue, 13 May 2025 14:04:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 14:04:06 +0800
Date: Tue, 13 May 2025 14:04:06 +0800
Message-Id: <67a2783ef1a4a5c37ba868af511fe0f0c6ef8476.1747116129.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747116129.git.herbert@gondor.apana.org.au>
References: <cover.1747116129.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 09/11] crypto: aspeed/hash - Add fallback
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Neal Liu <neal_liu@aspeedtech.com>, linux-aspeed@lists.ozlabs.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

If a hash request fails due to a DMA mapping error, or if it is too
large to fit in the the driver buffer, use a fallback to do the hash
rather than failing.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/aspeed/aspeed-hace-hash.c | 28 +++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index d7c7f867d6e1..3bfb7db96c40 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -420,6 +420,32 @@ static int aspeed_hace_hash_handle_queue(struct aspeed_hace_dev *hace_dev,
 			hace_dev->crypt_engine_hash, req);
 }
 
+static noinline int aspeed_ahash_fallback(struct ahash_request *req)
+{
+	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
+	HASH_FBREQ_ON_STACK(fbreq, req);
+	u8 *state = rctx->buffer;
+	struct scatterlist sg[2];
+	struct scatterlist *ssg;
+	int ret;
+
+	ssg = scatterwalk_ffwd(sg, req->src, rctx->offset);
+	ahash_request_set_crypt(fbreq, ssg, req->result,
+				rctx->total - rctx->offset);
+
+	ret = aspeed_sham_export(req, state) ?:
+	      crypto_ahash_import_core(fbreq, state);
+
+	if (rctx->flags & SHA_FLAGS_FINUP)
+		ret = ret ?: crypto_ahash_finup(fbreq);
+	else
+		ret = ret ?: crypto_ahash_update(fbreq);
+			     crypto_ahash_export_core(fbreq, state) ?:
+			     aspeed_sham_import(req, state);
+	HASH_REQUEST_ZERO(fbreq);
+	return ret;
+}
+
 static int aspeed_ahash_do_request(struct crypto_engine *engine, void *areq)
 {
 	struct ahash_request *req = ahash_request_cast(areq);
@@ -434,7 +460,7 @@ static int aspeed_ahash_do_request(struct crypto_engine *engine, void *areq)
 
 	ret = aspeed_ahash_req_update(hace_dev);
 	if (ret != -EINPROGRESS)
-		return ret;
+		return aspeed_ahash_fallback(req);
 
 	return 0;
 }
-- 
2.39.5


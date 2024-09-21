Received: from exchange.fintech.ru (exchange.fintech.ru [195.54.195.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEC8176FB4;
	Sat, 21 Sep 2024 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.54.195.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726936502; cv=none; b=rBoDImk5uxB4MkS2KKpa5NtcktHOyXPaciH9DqwXiPcv8nizGwQiIxXEITFN7PT+y1fDFZjjqijeBds37JJZRkVqfPIJURyuv9k1DSCP0w8FSVCaJ/Gu1t36U0N/l/ilGA6ddhUS254tgdkhhqDVPkMArGdYnlASjlVd7fXWnaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726936502; c=relaxed/simple;
	bh=ByF66H+/e+ofon85gaQkGnlWj+iNp82/hH2iL6TZwwA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o0Uf/j3bOuPxxCmceMt1cCJZGZ/sjSAQDz0K7l6O5W8WiziTpi13GjwsPPEmCgLeNuWAe277f3OPc8enFJ0pE5kLBrLlmKQGlDGGM4p0tRWE6hofk5pVALegd5oWH7j7hJsUrla7R9cs3D9mkqrpjRR8Z9T13n1aysZEQM35ESM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fintech.ru; spf=pass smtp.mailfrom=fintech.ru; arc=none smtp.client-ip=195.54.195.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fintech.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fintech.ru
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.169) with Microsoft SMTP Server (TLS) id 14.3.498.0; Sat, 21 Sep
 2024 19:34:45 +0300
Received: from localhost (10.0.253.138) by Ex16-01.fintech.ru (10.0.10.18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Sat, 21 Sep
 2024 19:34:45 +0300
From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
To: <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Nikita Zhandarovich <n.zhandarovich@fintech.ru>, Antoine Tenart
	<atenart@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S.
 Miller" <davem@davemloft.net>, Peter Harliman Liem <pliem@maxlinear.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>
Subject: [PATCH 5.10/5.15 1/2] crypto: inside_secure - Avoid dma map if size is zero
Date: Sat, 21 Sep 2024 09:34:37 -0700
Message-ID: <20240921163438.25253-2-n.zhandarovich@fintech.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240921163438.25253-1-n.zhandarovich@fintech.ru>
References: <20240921163438.25253-1-n.zhandarovich@fintech.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: Ex16-02.fintech.ru (10.0.10.19) To Ex16-01.fintech.ru
 (10.0.10.18)

From: Peter Harliman Liem <pliem@maxlinear.com>

commit 49186a7d9e46ff132a0ed9b721ad6b6a58dba6c1 upstream.

From commit d03c54419274 ("dma-mapping: disallow .map_sg
operations from returning zero on error"), dma_map_sg()
produces warning if size is 0. This results in visible
warnings if crypto length is zero.
To avoid that, we avoid calling dma_map_sg if size is zero.

Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
---
 .../crypto/inside-secure/safexcel_cipher.c    | 44 +++++++++++++------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 9bcfb79a030f..b1f9deb59da8 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -641,10 +641,16 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 	safexcel_complete(priv, ring);
 
 	if (src == dst) {
-		dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
+		if (sreq->nr_src > 0)
+			dma_unmap_sg(priv->dev, src, sreq->nr_src,
+				     DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
-		dma_unmap_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
+		if (sreq->nr_src > 0)
+			dma_unmap_sg(priv->dev, src, sreq->nr_src,
+				     DMA_TO_DEVICE);
+		if (sreq->nr_dst > 0)
+			dma_unmap_sg(priv->dev, dst, sreq->nr_dst,
+				     DMA_FROM_DEVICE);
 	}
 
 	/*
@@ -736,23 +742,29 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 				max(totlen_src, totlen_dst));
 			return -EINVAL;
 		}
-		dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
+		if (sreq->nr_src > 0)
+			dma_map_sg(priv->dev, src, sreq->nr_src,
+				   DMA_BIDIRECTIONAL);
 	} else {
 		if (unlikely(totlen_src && (sreq->nr_src <= 0))) {
 			dev_err(priv->dev, "Source buffer not large enough (need %d bytes)!",
 				totlen_src);
 			return -EINVAL;
 		}
-		dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
+
+		if (sreq->nr_src > 0)
+			dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
 
 		if (unlikely(totlen_dst && (sreq->nr_dst <= 0))) {
 			dev_err(priv->dev, "Dest buffer not large enough (need %d bytes)!",
 				totlen_dst);
-			dma_unmap_sg(priv->dev, src, sreq->nr_src,
-				     DMA_TO_DEVICE);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto unmap;
 		}
-		dma_map_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
+
+		if (sreq->nr_dst > 0)
+			dma_map_sg(priv->dev, dst, sreq->nr_dst,
+				   DMA_FROM_DEVICE);
 	}
 
 	memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);
@@ -882,12 +894,18 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 cdesc_rollback:
 	for (i = 0; i < n_cdesc; i++)
 		safexcel_ring_rollback_wptr(priv, &priv->ring[ring].cdr);
-
+unmap:
 	if (src == dst) {
-		dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
+		if (sreq->nr_src > 0)
+			dma_unmap_sg(priv->dev, src, sreq->nr_src,
+				     DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
-		dma_unmap_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
+		if (sreq->nr_src > 0)
+			dma_unmap_sg(priv->dev, src, sreq->nr_src,
+				     DMA_TO_DEVICE);
+		if (sreq->nr_dst > 0)
+			dma_unmap_sg(priv->dev, dst, sreq->nr_dst,
+				     DMA_FROM_DEVICE);
 	}
 
 	return ret;
-- 
2.25.1


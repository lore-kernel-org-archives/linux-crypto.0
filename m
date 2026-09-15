Received: from mout-b-202.mailbox.org (mout-b-202.mailbox.org [195.10.208.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2E94A384F;
	Tue, 15 Sep 2026 11:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.10.208.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472474; cv=none; b=k09FGC4qZh8RPwBSv4K9JBrN3gviUCgSVuZKVcvE1jBBExh06hrdvYfftSGXqO56x4Eojm/pCgamTbbK1e2tOLMkKGo06eNbbKJlPGoA6hbidsGRvxU5C790LPuk+UmO84oOu1vN++VE2ZUUPRTrYFJvxthm8XscFnODkHvdE8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472474; c=relaxed/simple;
	bh=IAs3OiIJo3O5rPcXmlXJ2KBpC52K1tzgEIoVpSwYIVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdFtYj8UPDOD0ZW78aLp6d6TG0ZsjemT5edoXn0geaKgyvAxYbq2eBQRISk6cXaqjfi4jF8O539fPJbyKVaBnJ9O/ZsW5+paGbZos/vPG4y9DktCM8JKNhGsHh+vYWPKeEbIycVPO5l81sVQOgk1B5OGDpQ09QaNlMv+lc3ZDoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com; spf=pass smtp.mailfrom=mandelbit.com; dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b=UU7kjnEs; arc=none smtp.client-ip=195.10.208.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b="UU7kjnEs"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-202.mailbox.org (Postfix) with ESMTPS id 4hkfxz3vT4zKnfJ;
	Tue, 15 Sep 2026 13:32:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1789471943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YId96aUBJA7Q13QK1MT0jzDtqKXA7u5TmZO3FZ6Urlw=;
	b=UU7kjnEs0SSavvAgSRmqS5mZ7HPZZNkobDOE3InBJnCuaWWJ5o3Cbiupeqg/FuQEwxIDj3
	S+fGq0BjU9k1e5UYDPiede7aUAwpIgMemjLEGhQUeadAJI8DahLBfankQtNeYpHIR2ZjJs
	xH/RUBoMaU5GGnnj0s6h3yS4FMjBZqtkBkhQz82F2HfCfwOv7Nkn5LLO13S7/513vdWm3K
	kbYff8uzXL0kpAcBVrk1A7nMXgyucSFbqQygcjrgx9X9iwt3lKI/8ldTKkFvnjoyEMf7zW
	WUOCcp9VWQgAl0IfLS+uHNV9HQ062kpVgJrCZMYrTmmsNayWfq3C7EjXKLE4bQ==
From: Ralf Lici <ralf@mandelbit.com>
To: linux-crypto@vger.kernel.org
Cc: Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	linux-kernel@vger.kernel.org
Subject: [PATCH crypto 1/2] crypto: safexcel - Avoid unmapping failed DMA mappings
Date: Tue, 15 Sep 2026 13:32:11 +0200
Message-ID: <88b0d054b0518f324f3d62ee7ffab589a61fcda6.1789469436.git.ralf@mandelbit.com>
In-Reply-To: <cover.1789469436.git.ralf@mandelbit.com>
References: <cover.1789469436.git.ralf@mandelbit.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dma_map_sg undoes any partial mapping before returning zero. If mapping
the destination of an out-of-place request fails, safexcel nevertheless
reaches its common cleanup path with a positive destination SG count and
calls dma_unmap_sg on the already-unmapped list.

Track which mappings completed successfully and restrict error cleanup
to those lists.

Fixes: 87e02063d077 ("crypto: safexcel - Add error handling for dma_map_sg() calls")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
---
 .../crypto/inside-secure/safexcel_cipher.c    | 36 ++++++++++++-------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index a8349b684693..4982c64bf236 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -695,6 +695,7 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 	struct safexcel_token *atoken;
 	int n_cdesc = 0, n_rdesc = 0;
 	int queued, i, ret = 0;
+	bool src_mapped = false, dst_mapped = false;
 	bool first = true;
 
 	sreq->nr_src = sg_nents_for_len(src, totlen_src);
@@ -746,9 +747,12 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 				max(totlen_src, totlen_dst));
 			return -EINVAL;
 		}
-		if (sreq->nr_src > 0 &&
-		    !dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL))
-			return -EIO;
+		if (sreq->nr_src > 0) {
+			src_mapped = dma_map_sg(priv->dev, src, sreq->nr_src,
+						DMA_BIDIRECTIONAL);
+			if (!src_mapped)
+				return -EIO;
+		}
 	} else {
 		if (unlikely(totlen_src && (sreq->nr_src <= 0))) {
 			dev_err(priv->dev, "Source buffer not large enough (need %d bytes)!",
@@ -756,9 +760,12 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 			return -EINVAL;
 		}
 
-		if (sreq->nr_src > 0 &&
-		    !dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE))
-			return -EIO;
+		if (sreq->nr_src > 0) {
+			src_mapped = dma_map_sg(priv->dev, src, sreq->nr_src,
+						DMA_TO_DEVICE);
+			if (!src_mapped)
+				return -EIO;
+		}
 
 		if (unlikely(totlen_dst && (sreq->nr_dst <= 0))) {
 			dev_err(priv->dev, "Dest buffer not large enough (need %d bytes)!",
@@ -767,10 +774,13 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 			goto unmap;
 		}
 
-		if (sreq->nr_dst > 0 &&
-		    !dma_map_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE)) {
-			ret = -EIO;
-			goto unmap;
+		if (sreq->nr_dst > 0) {
+			dst_mapped = dma_map_sg(priv->dev, dst, sreq->nr_dst,
+						DMA_FROM_DEVICE);
+			if (!dst_mapped) {
+				ret = -EIO;
+				goto unmap;
+			}
 		}
 	}
 
@@ -903,14 +913,14 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 		safexcel_ring_rollback_wptr(priv, &priv->ring[ring].cdr);
 unmap:
 	if (src == dst) {
-		if (sreq->nr_src > 0)
+		if (src_mapped)
 			dma_unmap_sg(priv->dev, src, sreq->nr_src,
 				     DMA_BIDIRECTIONAL);
 	} else {
-		if (sreq->nr_src > 0)
+		if (src_mapped)
 			dma_unmap_sg(priv->dev, src, sreq->nr_src,
 				     DMA_TO_DEVICE);
-		if (sreq->nr_dst > 0)
+		if (dst_mapped)
 			dma_unmap_sg(priv->dev, dst, sreq->nr_dst,
 				     DMA_FROM_DEVICE);
 	}
-- 
2.55.0


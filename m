Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795752279;
	b=pNF9rc62+F0HKwZBZ+yQaczZJyqllDRtF5O7C9TSmG4U1p9F/Zxk4HWj9bzxnj3buekz
	 w/hS//9Nqv2rAY/7EtclpK7uezOElCdaoyx1CAzxIe4WPc54x8RsbWUjPIMOKikzAST4b
	 n5zvgrFg0sF4RqgsVsxJ3Vs3GkW6aNYBnzM5qapDWppD83vm361aTZ9BBB+XFZYfhIKdV
	 LmXUUCDOGCTJZRLJYmHwbtW0vCQQM9dncjm443PSl6KuHTM1U4TTMZ7p3VcMKFQkhbE+g
	 dYAIOL1IZJgXoeh+T+XSJarAU5wEdQo1xFqx8z4pQC+kz+rZaeB0QQI45v8NODvd3FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752279;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=blOKfjSWsQPv0HlDd7Osb56cmUVJCD4UwxbvSXL+r/U=;
	b=QooItYRsUi1G9od2+XXyR3ZMisHUWXX+L2LRUXMSkk0c4OW5y1qOlUQfEBu6d61ZnB2K
	 Cq+h0n+KuLfR3L1Q36zo2XiH0r4oS9NOmtwXKC3l/0RGmaMALI0WjcqTmYaSHmsVtA03y
	 ZKXzm44tRkKLMerQYYcsVyDLTh08XHk/GZ4HnHgwl1y/9mDXQT53zvK73XzwYRfrJFHUq
	 1blSNDI07FC9mDiCCEc6JPOyObHDzBAi0pUMSdIThyT6KwO75vpfoVLiyHSUAeCimiVbr
	 PnLw/sBVu9pKnCkwuomrThkrT4gYShyC23NCZ8SA4wB9Kwvh+syGY4Vp2LR8nBB7g3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uqi+oYMX;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA9B606A32D
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:04:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFA9B606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uqi+oYMX
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b40d23e1adso5103447a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 20:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795752278; x=1796357078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=blOKfjSWsQPv0HlDd7Osb56cmUVJCD4UwxbvSXL+r/U=;
        b=uqi+oYMXxS76lkzT2QOfFahlDVQwFfALlHa32K4FnqsYGxxo8lKNuJiFYGADnfcwbs
         w4ZpaJtFd3WMdZIVubGAFZxFLXuPBaEQKFlJW43eCExOzrMkJtISqWKb9rWA4mi6E/DC
         rlIqNFWwUDeVdjIfs/HObTl8a1DPKLEYJYk1mhQuzxteVnQ/l9Y7f6YuwrF+1AGi5dnh
         nH2GyKuWczFI53PNHp7UEsizqKwB68M1vqN/dfQIWq1M2gC97+3A7W+VhLVQoWuDuT0g
         73rOUQGW702R5taQOlJQLDU6TIApXwHvvtXB4UjQ+4+cR1Hi+ZblGtldoaBqdL0lLeUX
         lwpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752278; x=1796357078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=blOKfjSWsQPv0HlDd7Osb56cmUVJCD4UwxbvSXL+r/U=;
        b=1S0iLYK4L1Ro8lMcfw/SJYO3+1cSGOmPtwQ8boqVkmC9BbP5Vm4o08i74CbrYFYQ0u
         yHSn/rE74JsRF+51YGiXqm9aEEjr3H/jP2QEzBTum9+K2CBLN/NEZChFSKROWKdHYYzX
         aa6NH72xpa2FriVDoSCaBHqEZGNFOkA0R8cQsrxxWl/kXQh2O/Fl09PzxZ9zLucnOLAv
         JmRsVQ/W5ZyELh1tU+oYfcq2l/9BlkcbqehUO8qxNLwFxKNisy37R6tlLr5oDxpBKdAJ
         DG5qEJ5PnRAnwMp5jd1t0E/M54GHt35DWJYmDg8zVZRUjaHDmOXickinSOWJRBzbUbhz
         Hw9w==
X-Gm-Message-State: APuU4Z9oLAH3DNsUQihEYenLH6/fBlk+yuCholDAhdIx/7G7XbUVztgN
	YXKyMyVSzayyF0Z0RVqv1yl6eYto84OrSLPlZalZrO9wM79px6YIx9ZdLsmGmQ==
X-Gm-Gg: AZFdTZe7n9iw1RZlYBn8BFbbQNFjmHz4ag7qvPiSz1vmPLCp0MdWhmPEzexIE5V3JEA
	amiKqJppXSmVpQzPm/h00tojlX+vygd1vVqhYnpI9a4OeVU17YBYqD6wGalbTyV3MHTyNA4m7H4
	HaTcODr+Am5qDIt2pmJr8Ly1ikxuH3DRGBsdUhdqx0Ctp6Zw0f5XMXWU5dstL5Sdeg4r6+rjd6p
	Li6cOQIGhvTdBPKY5FM1cIxZpUBHNeW4Wjo2s4tWG2kUuh2yHx3zb78X7/z7UX8hvGfCZ2tJRo9
	CJKRV1fWCdAYZpSQrG4+mOW8cVaD7ggW45mDoaQ2+2xNjQHHpUIHsI1ppYV/p7cgt6V4IZSFR0J
	GJKYx7rGdfoIP5KLJpsZKS6OTaZCvmhaNHzIf56hHQaj1b8edS7bdQeMcvfY929/J6LqTO0ZXQK
	hJ/Un9bhi8rDYpsRGnhUfYgl+TwF9V5e9vrWCQbmy6RLcortdtJUhfzPoS3ONTiPiK1IxNlKCfb
	4Toy1rbw+t69q4oR5oL6ao2MAulKzQkJoIk531kRCOoHLgnCZsYM43LvXtCK0RTZhpeoSyvBb89
	Q9rvJJr5RP5X8Kuo/JNmUoYxtusyVov00XUz85pi/yIxg0Twr6zTEtSzgDLhYeqpUl6HRccauZ6
	bLyYWTgEmllTGmtCUZbABAZJPxy5q9mpJZTncrq8k1xQU9pgsPH1AG5aXR5IvoXoCo+d1RKgBaY
	4nLg==
X-Received: by 2002:a17:90b:268a:b0:3ac:7c52:fae5 with SMTP id 98e67ed59e1d1-3b41c9778e9mr21991809a91.50.1795752277204;
        Thu, 26 Nov 2026 20:04:37 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b457a58d04sm15090652a91.0.2026.11.26.20.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:04:36 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Hsiao <jhsiao@amcc.com>,
	Rosen Penev <rosenp@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 6/8] crypto: amcc - fix the DMA mappings of the source and destination
Date: Thu, 26 Nov 2026 20:04:21 -0800
Message-ID: <20261127040423.1023233-7-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127040423.1023233-1-rosenp@gmail.com>
References: <20261127040423.1023233-1-rosenp@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

crypto4xx_build_pd() maps every source segment with dma_map_page(),
but the mappings are never unmapped. The destination is mapped
DMA_TO_DEVICE and unmapped DMA_FROM_DEVICE with a different length,
and none of the mappings are checked for errors. The non-coherent
4xx DMA ops make this mostly harmless today, but it leaks mappings
on any setup that tracks them, and CONFIG_DMA_API_DEBUG reports all
of it.

Map the source with dma_map_sg() and the destination with
DMA_FROM_DEVICE before any ring descriptor is reserved, so a mapping
failure has nothing to give back, and record the mappings in the
pd_uinfo so the completion path unmaps exactly what was mapped. The
busy and ring-full error paths unmap them again.

A request with no data now completes right away, as there is nothing
to map.

Fixes: 049359d65527 ("crypto: amcc - Add crypt4xx driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 122 +++++++++++++++++----------
 drivers/crypto/amcc/crypto4xx_core.h |   4 +
 2 files changed, 81 insertions(+), 45 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index cb9b36d6f4fc..4c1b76f28de0 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -482,6 +482,23 @@ static void crypto4xx_copy_pkt_to_dst(struct crypto4xx_device *dev,
 	}
 }
 
+static void crypto4xx_unmap(struct crypto4xx_device *dev,
+			    struct scatterlist *src, int src_nents,
+			    dma_addr_t dst_dma, u32 dst_len)
+{
+	if (dst_len)
+		dma_unmap_page(dev->core_dev->device, dst_dma, dst_len,
+			       DMA_FROM_DEVICE);
+	dma_unmap_sg(dev->core_dev->device, src, src_nents, DMA_TO_DEVICE);
+}
+
+static void crypto4xx_unmap_pd(struct crypto4xx_device *dev,
+			       struct pd_uinfo *pd_uinfo)
+{
+	crypto4xx_unmap(dev, pd_uinfo->src_va, pd_uinfo->src_nents,
+			pd_uinfo->dst_dma, pd_uinfo->dst_len);
+}
+
 static void crypto4xx_ret_sg_desc(struct crypto4xx_device *dev,
 				  struct pd_uinfo *pd_uinfo)
 {
@@ -506,18 +523,14 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
 				     struct ce_pd *pd)
 {
 	struct skcipher_request *req;
-	struct scatterlist *dst;
 
 	req = skcipher_request_cast(pd_uinfo->async_req);
 
-	if (pd_uinfo->sa_va->sa_command_0.bf.scatter) {
+	crypto4xx_unmap_pd(dev, pd_uinfo);
+
+	if (pd_uinfo->sa_va->sa_command_0.bf.scatter)
 		crypto4xx_copy_pkt_to_dst(dev, pd, pd_uinfo,
 					  req->cryptlen, req->dst);
-	} else {
-		dst = pd_uinfo->dest_va;
-		dma_unmap_page(dev->core_dev->device, pd->dest, dst->length,
-			       DMA_FROM_DEVICE);
-	}
 
 	if (pd_uinfo->sa_va->sa_command_0.bf.save_iv == SA_SAVE_IV) {
 		struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
@@ -546,14 +559,12 @@ static void crypto4xx_aead_done(struct crypto4xx_device *dev,
 	u32 icv[AES_BLOCK_SIZE];
 	int err = 0;
 
-	if (pd_uinfo->sa_va->sa_command_0.bf.scatter) {
+	crypto4xx_unmap_pd(dev, pd_uinfo);
+
+	if (pd_uinfo->sa_va->sa_command_0.bf.scatter)
 		crypto4xx_copy_pkt_to_dst(dev, pd, pd_uinfo,
 					  pd->pd_ctl_len.bf.pkt_len,
 					  dst);
-	} else {
-		dma_unmap_page(dev->core_dev->device, pd->dest, dst->length,
-				DMA_FROM_DEVICE);
-	}
 
 	if (pd_uinfo->sa_va->sa_command_0.bf.dir == DIR_OUTBOUND) {
 		/* append icv at the end */
@@ -660,7 +671,9 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	unsigned int nbytes = datalen;
 	size_t offset_to_sr_ptr;
 	u32 gd_idx = 0;
-	int tmp;
+	dma_addr_t dst_dma = 0;
+	u32 dst_len = 0;
+	int src_nents, nmapped, i, rc;
 	bool is_busy, force_sd;
 
 	/*
@@ -679,15 +692,16 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		|| req_sa->sa_command_1.bf.crypto_mode9_8 == CRYPTO_MODE_OFB)
 		&& (datalen % AES_BLOCK_SIZE);
 
+	/* Nothing to process; there is nothing to map either. */
+	if (!(assoclen + datalen))
+		return 0;
+
 	/* figure how many gd are needed */
-	tmp = sg_nents_for_len(src, assoclen + datalen);
-	if (tmp < 0) {
+	src_nents = sg_nents_for_len(src, assoclen + datalen);
+	if (src_nents < 0) {
 		dev_err(dev->core_dev->device, "Invalid number of src SG.\n");
-		return tmp;
+		return src_nents;
 	}
-	if (tmp == 1)
-		tmp = 0;
-	num_gd = tmp;
 
 	if (assoclen) {
 		nbytes += assoclen;
@@ -707,6 +721,27 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		}
 	}
 
+	/*
+	 * Map the buffers before reserving any descriptors, so a mapping
+	 * failure has nothing to give back to the rings.
+	 */
+	nmapped = dma_map_sg(dev->core_dev->device, src, src_nents,
+			     DMA_TO_DEVICE);
+	if (!nmapped)
+		return -ENOMEM;
+	num_gd = nmapped == 1 ? 0 : nmapped;
+
+	if (!num_sd) {
+		dst_len = min(datalen, dst->length);
+		dst_dma = dma_map_page(dev->core_dev->device, sg_page(dst),
+				       dst->offset, dst_len, DMA_FROM_DEVICE);
+		if (dma_mapping_error(dev->core_dev->device, dst_dma)) {
+			dma_unmap_sg(dev->core_dev->device, src, src_nents,
+				     DMA_TO_DEVICE);
+			return -ENOMEM;
+		}
+	}
+
 	/*
 	 * The follow section of code needs to be protected
 	 * The gather ring and scatter ring needs to be consecutive
@@ -734,25 +769,23 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 			((PPC4XX_NUM_PD * 15) / 16);
 
 		if (is_busy) {
-			spin_unlock_irqrestore(&dev->core_dev->lock, flags);
-			return -EBUSY;
+			rc = -EBUSY;
+			goto err_unlock;
 		}
 	}
 
+	rc = -EAGAIN;
 	if (num_gd) {
 		fst_gd = crypto4xx_get_n_gd(dev, num_gd);
-		if (fst_gd == ERING_WAS_FULL) {
-			spin_unlock_irqrestore(&dev->core_dev->lock, flags);
-			return -EAGAIN;
-		}
+		if (fst_gd == ERING_WAS_FULL)
+			goto err_unlock;
 	}
 	if (num_sd) {
 		fst_sd = crypto4xx_get_n_sd(dev, num_sd);
 		if (fst_sd == ERING_WAS_FULL) {
 			if (num_gd)
 				dev->gdr_head = fst_gd;
-			spin_unlock_irqrestore(&dev->core_dev->lock, flags);
-			return -EAGAIN;
+			goto err_unlock;
 		}
 	}
 	pd_entry = crypto4xx_get_pd_from_pdr_nolock(dev);
@@ -761,8 +794,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 			dev->gdr_head = fst_gd;
 		if (num_sd)
 			dev->sdr_head = fst_sd;
-		spin_unlock_irqrestore(&dev->core_dev->lock, flags);
-		return -EAGAIN;
+		goto err_unlock;
 	}
 	spin_unlock_irqrestore(&dev->core_dev->lock, flags);
 
@@ -779,6 +811,10 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	pd_uinfo->num_gd = num_gd;
 	pd_uinfo->num_sd = num_sd;
 	pd_uinfo->dest_va = dst;
+	pd_uinfo->src_va = src;
+	pd_uinfo->src_nents = src_nents;
+	pd_uinfo->dst_dma = dst_dma;
+	pd_uinfo->dst_len = dst_len;
 	pd_uinfo->async_req = req;
 
 	if (iv_len)
@@ -805,28 +841,22 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		sa->sa_command_0.bf.gather = 1;
 		/* walk the sg, and setup gather array */
 
-		sg = src;
-		while (nbytes) {
-			size_t len;
+		for_each_sg(src, sg, nmapped, i) {
+			u32 len = min(sg_dma_len(sg), nbytes);
 
-			len = min(sg->length, nbytes);
-			gd->ptr = dma_map_page(dev->core_dev->device,
-				sg_page(sg), sg->offset, len, DMA_TO_DEVICE);
+			gd->ptr = sg_dma_address(sg);
 			gd->ctl_len.len = len;
 			gd->ctl_len.done = 0;
 			gd->ctl_len.ready = 1;
-			if (len >= nbytes)
+			nbytes -= len;
+			if (!nbytes)
 				break;
 
-			nbytes -= sg->length;
 			gd_idx = get_next_gd(gd_idx);
 			gd = crypto4xx_get_gdp(dev, &gd_dma, gd_idx);
-			sg = sg_next(sg);
 		}
 	} else {
-		pd->src = (u32)dma_map_page(dev->core_dev->device, sg_page(src),
-				src->offset, min(nbytes, src->length),
-				DMA_TO_DEVICE);
+		pd->src = sg_dma_address(src);
 		/*
 		 * Disable gather in sa command
 		 */
@@ -843,10 +873,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		 */
 		pd_uinfo->first_sd = 0xffffffff;
 		sa->sa_command_0.bf.scatter = 0;
-		pd->dest = (u32)dma_map_page(dev->core_dev->device,
-					     sg_page(dst), dst->offset,
-					     min(datalen, dst->length),
-					     DMA_TO_DEVICE);
+		pd->dest = dst_dma;
 	} else {
 		dma_addr_t sd_dma;
 		struct ce_sd *sd = NULL;
@@ -904,6 +931,11 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	writel(0, dev->ce_base + CRYPTO4XX_INT_DESCR_RD);
 	writel(1, dev->ce_base + CRYPTO4XX_INT_DESCR_RD);
 	return is_busy ? -EBUSY : -EINPROGRESS;
+
+err_unlock:
+	spin_unlock_irqrestore(&dev->core_dev->lock, flags);
+	crypto4xx_unmap(dev, src, src_nents, dst_dma, dst_len);
+	return rc;
 }
 
 /*
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 294a57b77733..cdd40bb7d254 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -65,6 +65,10 @@ struct pd_uinfo {
 	struct sa_state_record *sr_va;	/* state record for shadow sa */
 	u32 sr_pa;
 	struct scatterlist *dest_va;
+	struct scatterlist *src_va;	/* DMA mapped source */
+	int src_nents;
+	dma_addr_t dst_dma;		/* DMA mapped destination */
+	u32 dst_len;			/* 0 if the scatter ring is used */
 	struct crypto_async_request *async_req; 	/* base crypto request
 							for this packet */
 };
-- 
2.56.1


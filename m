Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D258229B2A;
	Mon, 28 Jul 2025 06:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753682884; cv=none; b=ZFAj398uruagj88NfIld374c4e0xD/bIKsG6CfqNg9ixoHfpphobcTb/A41Top33j4bWTVSEpzb3Jgjvwn81SIeJoS+1MLyAO8xSRXcUNja4tw0LppeelldYll6mCdKPTAfOIMvZK+D/n/RMl0Dsn4tiq0JutGPrsCIdje0ZNZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753682884; c=relaxed/simple;
	bh=xmk9NUUKau69JXd8j/FyZNIhFMPQAiXB84NiNB/WsI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaN46XSnI1/rPa5g1hXIGaUcHL11qv1zRqoAWNe7a7eZeyEj4P57mcZmsUN+g3i++maplrWhHbmFB2SmGrnhxV/FLgyYwj43eK2akt3gGP3vyh9CWAMXu4rDgLaUkxW4YlM/i7N18GQ81CTNzSJ76m2o8wbHXCBwJwhBGFpktYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=meyQPxnc; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="meyQPxnc"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4563cfac2d2so42757575e9.3;
        Sun, 27 Jul 2025 23:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753682881; x=1754287681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sdqdaaScOBYi48Kijra/+QGBgmA2GIY7lfOSgwcV1kY=;
        b=meyQPxnckyjRPIELJw4O1JVIuJ2CY6SZ5W0iqT7KyG5QKbakOm63cAgWu9cBoq2nrM
         OLSeQPvz0smQNdi0Iq0qFn54tjk4My7rNR5ODab0hCI3WO+prdGtwOYzXwiMS77oZRqV
         XoaOaKsHOE5CAUsu55kUVDyuDPaE/5A8VmL5W+GzfBYs/voQCkxNTiq3M3IjDl/LajzE
         Q9uh4CbIrbBUs0RtSJni9c6SYtfGlOmHmII3V9S01OXMMvFZwJltBwhMZ3UvWisRj/BX
         dva5rCNqYMc+edaSXigev7jtCV1iqt9tLzP4l8sPMW3BaCYsXMVejTg/g+QdEhqNeWXJ
         ZEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753682881; x=1754287681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sdqdaaScOBYi48Kijra/+QGBgmA2GIY7lfOSgwcV1kY=;
        b=dq9VIifhkXGItO6Y/aHmuK8YT4g5FjRkT7hB9sSDo/XverbRFzWHkPYE8h0J9acHDf
         hZmwfgdTh7ApYwwEslmwBzcv28O+mSGzDVR3VgahCsspS/szFr+vqvyGMjLm9adlNrQj
         6YLXjHaE9tgTqm8OIjhxs/m4K9ZRYcLwLO8G9+ywMn9zfk5Ypm/1PYmqceajUo1uQN8p
         /LQxLE/cSi12714AsieP0CriHb3zdc1ULWgBDrKapSSC9JvItLbig6S2hk714qO94aiN
         /2nXq9hwBBEd0okbVSdS2QG0IL8IXSHKa6CJ+vKXFBXbOkE/PGJe86rKiFGpto0tIdVc
         d6jQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdOWjRe6Cve1x7oLPJCiijEuiBUkXASiYL2bHcKlNyhEy+tYmMpzy2L2GCsA1ezGRUta01ffmrAGN2KbSn@vger.kernel.org, AJvYcCWEVSq7a3IaJL+rcjN7yth54jYIZKD6ZcmiTxE5gxNWtlc1AWlUEry+EiVtSOZ3YQjKnHw2H7v411VVEQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+iBNQ8NFO0Hb0lI/1qkwlU9Mw7o6cVF/tTsMi7Q609yKMZsh1
	D5NNHOoVcFc+MoCXHox4DruG4Umx9Woii/2x6oTDEhao+Xi5U7qhg+43
X-Gm-Gg: ASbGnctAdFuv6BLsi3wvyHh7CN/qGr+W1q3fwF46VmjroAx4HWse0ms7At54VDUUJ1b
	rZz3uZ38YuKQY8fDQFQoLVwTZtMBBpysW9pcdBszPRsxKa6H7w0M4sB9LYMw5VMgenTDN7SCrtH
	bkY9fE1nVwyWVvTibEO1n5w605dcQl1duqRp29a/BaitaLvdFfuvb1s8p0ADGXAkDrubbNM3eyM
	zbr1EaYe4tcMBeRTlKX371bW0+xLrbAz+KlLiKXqTKWRF7uJysYfYDjNZailNwp9mtq6RPEFHZL
	50PW0N0RR1gtscC3E/C4BLTUREWJiL6hAsoHHBqqE9yOdf2dkAgp+2XF+9GmslF26qflQLKnafq
	YzacZ6N/xb8fouX987/FdWTQNLk1wG4+mEQ==
X-Google-Smtp-Source: AGHT+IHZ+61CYtmRgVeRSYGGn06dcWJ7qkkpNHOxwMUzzATXNR8lg1Va00usgycivkfePU3GB9B7Ig==
X-Received: by 2002:a05:600c:5027:b0:456:1a87:a6ba with SMTP id 5b1f17b1804b1-4587666af1amr70261495e9.33.1753682880486;
        Sun, 27 Jul 2025 23:08:00 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587abe6ba0sm86195215e9.9.2025.07.27.23.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 23:08:00 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 5/9] crypto: sun8i-ce - move bounce_iv and backup_iv to request context
Date: Mon, 28 Jul 2025 09:06:57 +0300
Message-ID: <20250728060701.1787607-6-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250728060701.1787607-1-ovidiu.panait.oss@gmail.com>
References: <20250728060701.1787607-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the iv buffers are allocated once per flow during driver probe.
However, the iv buffers hold request-specific data, so they should be part
of the request context.

Therefore, allocate iv buffers per request, rather than per flow.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c       | 18 +++++++++---------
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c  | 12 ------------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h   |  8 ++++----
 3 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index c57c64a1a388..69ba8236cf2d 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -209,11 +209,11 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	if (areq->iv && ivsize > 0) {
 		if (rctx->op_dir & CE_DECRYPTION) {
 			offset = areq->cryptlen - ivsize;
-			scatterwalk_map_and_copy(chan->backup_iv, areq->src,
+			scatterwalk_map_and_copy(rctx->backup_iv, areq->src,
 						 offset, ivsize, 0);
 		}
-		memcpy(chan->bounce_iv, areq->iv, ivsize);
-		rctx->addr_iv = dma_map_single(ce->dev, chan->bounce_iv, ivsize,
+		memcpy(rctx->bounce_iv, areq->iv, ivsize);
+		rctx->addr_iv = dma_map_single(ce->dev, rctx->bounce_iv, ivsize,
 					       DMA_TO_DEVICE);
 		if (dma_mapping_error(ce->dev, rctx->addr_iv)) {
 			dev_err(ce->dev, "Cannot DMA MAP IV\n");
@@ -299,13 +299,13 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
-			memcpy(areq->iv, chan->backup_iv, ivsize);
-			memzero_explicit(chan->backup_iv, ivsize);
+			memcpy(areq->iv, rctx->backup_iv, ivsize);
+			memzero_explicit(rctx->backup_iv, ivsize);
 		} else {
 			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 						 ivsize, 0);
 		}
-		memzero_explicit(chan->bounce_iv, ivsize);
+		memzero_explicit(rctx->bounce_iv, ivsize);
 	}
 
 	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
@@ -348,13 +348,13 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
 					 DMA_TO_DEVICE);
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
-			memcpy(areq->iv, chan->backup_iv, ivsize);
-			memzero_explicit(chan->backup_iv, ivsize);
+			memcpy(areq->iv, rctx->backup_iv, ivsize);
+			memzero_explicit(rctx->backup_iv, ivsize);
 		} else {
 			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 						 ivsize, 0);
 		}
-		memzero_explicit(chan->bounce_iv, ivsize);
+		memzero_explicit(rctx->bounce_iv, ivsize);
 	}
 
 	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index d94304a439d3..ac29e3f4e099 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -759,18 +759,6 @@ static int sun8i_ce_allocate_chanlist(struct sun8i_ce_dev *ce)
 			err = -ENOMEM;
 			goto error_engine;
 		}
-		ce->chanlist[i].bounce_iv = devm_kmalloc(ce->dev, AES_BLOCK_SIZE,
-							 GFP_KERNEL | GFP_DMA);
-		if (!ce->chanlist[i].bounce_iv) {
-			err = -ENOMEM;
-			goto error_engine;
-		}
-		ce->chanlist[i].backup_iv = devm_kmalloc(ce->dev, AES_BLOCK_SIZE,
-							 GFP_KERNEL);
-		if (!ce->chanlist[i].backup_iv) {
-			err = -ENOMEM;
-			goto error_engine;
-		}
 	}
 	return 0;
 error_engine:
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index f12c32d1843f..0d46531c475c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -188,8 +188,6 @@ struct ce_task {
  * @status:	set to 1 by interrupt if task is done
  * @t_phy:	Physical address of task
  * @tl:		pointer to the current ce_task for this flow
- * @backup_iv:		buffer which contain the next IV to store
- * @bounce_iv:		buffer which contain the IV
  * @stat_req:	number of request done by this flow
  */
 struct sun8i_ce_flow {
@@ -198,8 +196,6 @@ struct sun8i_ce_flow {
 	int status;
 	dma_addr_t t_phy;
 	struct ce_task *tl;
-	void *backup_iv;
-	void *bounce_iv;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
 #endif
@@ -264,6 +260,8 @@ static inline __le32 desc_addr_val_le32(struct sun8i_ce_dev *dev,
  * @nr_sgd:		The number of destination SG (as given by dma_map_sg())
  * @addr_iv:		The IV addr returned by dma_map_single, need to unmap later
  * @addr_key:		The key addr returned by dma_map_single, need to unmap later
+ * @bounce_iv:		Current IV buffer
+ * @backup_iv:		Next IV buffer
  * @fallback_req:	request struct for invoking the fallback skcipher TFM
  */
 struct sun8i_cipher_req_ctx {
@@ -273,6 +271,8 @@ struct sun8i_cipher_req_ctx {
 	int nr_sgd;
 	dma_addr_t addr_iv;
 	dma_addr_t addr_key;
+	u8 bounce_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
+	u8 backup_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
 	struct skcipher_request fallback_req;   // keep at the end
 };
 
-- 
2.50.0


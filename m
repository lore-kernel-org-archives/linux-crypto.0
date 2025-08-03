Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3221EDA2A;
	Sun,  3 Aug 2025 19:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754248272; cv=none; b=rpMTXwVr9OMLH+/kwUY2Ef18jfoTfrjQ79czHWUVDhRAMoG7HKMVqCqXdSR27xAzphFjDcu92aYINx196dXSyYKebHOnG8TWTmcbO6d6KDrxxKR3bjSqJsSCh9kSf7xClWWIlXtOiGjd08/XVQ1rjXq3CFp+YkZ6Lr+0kvo49Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754248272; c=relaxed/simple;
	bh=4gturWBm9llQ03CvUeU357O9qcWzGD7EQUK/d5jFGRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Noy+tXNGHh3fdZgCOACjVy5aN2EthpQa/Glx/1eBMiwJvnDzI+EX3Ykcr+mBjkeeO6kDAY6jFKYj4u7weLLt/jxUkQWcSSm4MVAL3M/VijEtGQJ+FA6PfTkMXI5jXxepoAB52cDnx2VRJJALRg6DJ82Hbnvuza2dXCl6UaBLPkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ThDZCANB; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ThDZCANB"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3b782cca9a0so1968085f8f.1;
        Sun, 03 Aug 2025 12:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754248268; x=1754853068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+X8fG0ywPfrmQVR6r26O20nKFt/URQggWx0ndoBVaZQ=;
        b=ThDZCANBm/NhB8vhImGUKHH6uS4+1DA+5F5Z46c7JaMCyoXOYrRetQHRipZcbSac8i
         Eawug6ial7m1rA+TW7z+A3AkDjnzBa2pomfX7uM5OzsDqa1wNzeWDXeQ4zTvsWas/kse
         G3/TI0rS5bVOR3ZIdGwBSrFpUIi+taTMJhQQixbb750koj2hOKEFAvV8yMXx1DSeqFz2
         On5TUgXYa+9PRVFH6M8K67sz+yoA7u90Oyxzd3Moz5LYTXtuyCwzK0jGGknPMs2vgvoB
         CibVk8HTag1ZEC5qtf4WDn7RdEuffICZx4ZKdDVdbrz7cCf3YFRF0TykmnpqduJPwid2
         2FSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754248268; x=1754853068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+X8fG0ywPfrmQVR6r26O20nKFt/URQggWx0ndoBVaZQ=;
        b=F1zPRiwih0YQy65C1eNohvV2anRcJwasSR3EfovkcBY8qBglTZR98+cxiKAtMTeuqZ
         FgqAZadiiKiHYb0dBCwxnlDuPBNHLa9NtzHReEgauO/mB3/2sfRvVhwDfu9UYXD7RhVt
         V85HQ3TD5MMEIvkaAmKjQMaqiEzbaNPhL1SfmJXxlNN66jAvxq6T4NiAI+aY9f1vjBnZ
         F6LmE5DNDvX8i91UcZ0TO2Nz3wbd+toMBVtiFLNuEOqcq/1PiCmQCeBRVRHF8iemzXgo
         2Mxxs7hCsG9fRa1NcgZ/js7E3ETdyO5cxYpLgSgqP7x//aNX6hv07vGkVM4zxWKMyw1F
         dZ9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVDw/TvJB6wBSlYMehXg3iu/3Zk91J5mEs/I39AdF/UDRUcjbN07XhmolRGMEkAlriUH27KtBp6qgmtQDIn@vger.kernel.org, AJvYcCWMvEsRj/e0b/M+No0fg43x/l77ghWxe8DZrTXmsre1NxVCP4yYXiI2TAoPAHxFFVdkbFwmss3nouHGcHI=@vger.kernel.org
X-Gm-Message-State: AOJu0YylxOOm7CtoxlYgtlTIJB8vaetEJ9dTVjEkX1gM4A8/1X7uxiF2
	c5u0ADP+9eA1o1rCApwXDoYZLrffbU27amZEvDnnAhf3hF9UxSsk5YQy
X-Gm-Gg: ASbGncsgzgoeBIhH2P2XuFhNThwD/5fFIF2nz5U5psK7hNjMN/IePK4/ljSHMunUziB
	P9IE20xIAIxOItuZBQ4WlIoFI5fGGkb+pFmw5Y6dZnEp4mWe3Eprr2SIc1viznWBPu2GSwDao97
	Y7xsnFy4GJgYLW9afDR5m5MGYDqX0LZ572SjizmCzf+U4pZdkA6s2lCbzlx8YjKyl4DuKWnreiJ
	78XDEciwOl1fod9RXo8lSn51rSOI3qpG32yo8tHrHTEjClmPzORl8dKkV7dmPhMJK5yx/XeGfo+
	fYYd1+9p8n4g4+cVojZqC9jGXINGLyczR54NfaQgal/dOGVaki9wSZm3Cy4+pJkjGrvPaZkp04Y
	cWeBw3iVofDiy45BzCayjGms7S8hFlSwVaA==
X-Google-Smtp-Source: AGHT+IHmU63nL7KhrYVgzX7obJHqRHaKsmdzwuH3zpDNrqoBJQ2FLJGMFWpvAfGKl736d20CpxhjUQ==
X-Received: by 2002:a05:6000:290c:b0:3b7:97c8:da97 with SMTP id ffacd0b85a97d-3b8d94baa99mr5568207f8f.43.1754248268189;
        Sun, 03 Aug 2025 12:11:08 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c45346asm13099210f8f.39.2025.08.03.12.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 12:11:07 -0700 (PDT)
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
Subject: [PATCH v2 5/9] crypto: sun8i-ce - move bounce_iv and backup_iv to request context
Date: Sun,  3 Aug 2025 22:10:25 +0300
Message-ID: <20250803191029.3592987-6-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250803191029.3592987-1-ovidiu.panait.oss@gmail.com>
References: <20250803191029.3592987-1-ovidiu.panait.oss@gmail.com>
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
index b7093fbb8e9d..c16bb6ce6ee3 100644
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


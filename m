Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D62E284693;
	Mon, 19 May 2025 15:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747667674; cv=none; b=eRlrF8LjojMC6yPY6JHV2hTDVkftY17NkWYHy0MbAbpqAwCiJtZsTA1CaliTZaXVRMdvpZF5Qjq+g3UocvmD4OgjrjUXzyLss5URxkCnGMNXGOFJM9P6QcYIgVRRUsXixbC2JQMq1yTPrmKc03kDtOoPU1tzXnGu1x11e+gzKxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747667674; c=relaxed/simple;
	bh=uQMEZH2UY5Jm2u+FOuxDZp8bnbU3aSj7eRys9xEdlOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwWapSjHHYaGa5Mms4bCVCqsSsRf5gYYocwsf1/LiOoudR46vqS4zjjmMqhrv60rG+O+umw9tWDl687xdcFhNt7ZkcS3RKFgHt4/Dm3dRDJj10nlD2DhnaFGR8ROHdJGUA8OD5/Veo4Ge0MjUWU8GZ8PDmaem6Eqc9kiRjXbLKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Axdyw5e1; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Axdyw5e1"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso832884866b.0;
        Mon, 19 May 2025 08:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747667670; x=1748272470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iYtYa5Hmz7e97gZT2Sf2chY466RHYEoEJJ/npJRNZKw=;
        b=Axdyw5e1YV2NzNOd2wzVEuMEQsCv6096jQBf6uJOrrO966btTUv50EMET2dEsv1ko0
         wdXgWzZ82+LSD9ad/+9zFJg/5unwFZYJ7z8YSkpCYyyMjZU/ULhFQVGkzH/L5cceMJoh
         N3daMWJaVE2Q4SMD3QFTFPsXKGakLhvDv/SVmSitDMoZBJ8DxN7XSdMK8R8aHl1cB+Cy
         1vTzLE2vzZgAbGhEyohKeZhr64dJXeTAXQLwXJbmB9VkEkrPzHKc9ccrgquUDa5dJq6d
         mqcSekRCxsNVnXzXUZnn12flctfBwG28pRsK7EqxxhiYDPeceUMWZ6Dtsf7rssH+R43A
         O4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747667670; x=1748272470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iYtYa5Hmz7e97gZT2Sf2chY466RHYEoEJJ/npJRNZKw=;
        b=kHCmFAvII8bHj215MX4KXsXs4zR4OMCJuhtj2wtEbpovLUnZ4qwUWWBoWrHOpJ2k8t
         +06dI7HYE9bmK6TPqiHRqDHEBnJoak8d+gyq0mIK+MhRUfpsbUaM+8hDnCtnNDGDHlxr
         Pe+Cahcu41UIcjceK5eBygsXEJEPOXgMVELfzh2ql8INeWIzYMusDa295yke+WC2D1Hn
         YnDbZdJJmPJGs3Llp88Ydf1vFVgAZ7ylZkZnPVNrVeo/CnsVpkI+F68MfROhCBVLQi7q
         RklVEd7ceX1NNtwIw75KYAgk5rv8vmaIKhFw42qqdSXAciR6qglMOMrDCgOwBm/V+8Mz
         6COA==
X-Forwarded-Encrypted: i=1; AJvYcCUNpDPYfaRdl4kb+V70u/C+34vRa97F2hGkjomfhXCtpqaGxBzz4x8HFZTiMthcFFArtOe5BXeR8bj18BbF@vger.kernel.org, AJvYcCW8Bp0K7o8utZMXq/5jFNnbBlbnv2LCNNwJi9QcPjSK+0hJTY8emrIL1Z0q9ldy+M03VwEwZ74UkJxc8dU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb5tRBZGmu1BvDtdhOR8mXnxpge1iNeeM1BdK1zIEWhXoLelXX
	qaKulC+stxSwV9DYJSOjBc7tC9Flklkvumm4RU3TiUjwB5e1nxpjWihb
X-Gm-Gg: ASbGncuu8smWJ+SOavIAegUo2OVwLTaIRVsucyTu+CqW1WphBL8UnhlJbyYapomEXUP
	M6MLVXS5CMeFtm0+ckTg4NfXLmyL1j4fmuoxfLVfFAHflg00WvuJ+MTd9elXsUWXSmxbXVEOa+Q
	5PXY7jyOuEFvguDVCqi7ZueQj59apjVwVi/p/mP5YKAdQ1f6gK/boS+odncUvwRHi5nmoglhK28
	jEmIL19r8wzxAqvn8lYVOoK0RCBxgmp+3soubdG81dq70QOCnx9ShQCg7tBAzD1DpW+VJ8LSTOY
	DF44e/C/BLS1nOaye+rC1jzca9dMtzL08wd6P7Y5cb26JYYlN2rB6HqJRTpIvDGXKhg/nKPJJoB
	j+k8=
X-Google-Smtp-Source: AGHT+IEdFDlMvFo4JwLpnmG07B9+mYT8Lr9dmRx+b+IvnhMbKrdoukQEvMfyH7MVsguioYjxxvQVMQ==
X-Received: by 2002:a17:907:1c91:b0:ad5:5857:ece2 with SMTP id a640c23a62f3a-ad55857f064mr687560966b.37.1747667670306;
        Mon, 19 May 2025 08:14:30 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f07:610b:a400:6472:d2f9:d536:4c30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d04b08bsm608522566b.13.2025.05.19.08.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 08:14:29 -0700 (PDT)
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
Subject: [PATCH 2/3] crypto: sun8i-ce - remove ivlen field of sun8i_cipher_req_ctx
Date: Mon, 19 May 2025 18:13:49 +0300
Message-ID: <20250519151350.3442981-2-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250519151350.3442981-1-ovidiu.panait.oss@gmail.com>
References: <20250519151350.3442981-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove `ivlen` field of `sun8i_cipher_req_ctx`, as it is not really useful.

The iv length returned by crypto_skcipher_ivsize() is already available
everywhere and can be used instead.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 11 ++++++-----
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h        |  2 --
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 7cd3b13f3bdc..5663df49dd81 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -206,15 +206,14 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	cet->t_key = desc_addr_val_le32(ce, rctx->addr_key);
 
 	ivsize = crypto_skcipher_ivsize(tfm);
-	if (areq->iv && crypto_skcipher_ivsize(tfm) > 0) {
-		rctx->ivlen = ivsize;
+	if (areq->iv && ivsize > 0) {
 		if (rctx->op_dir & CE_DECRYPTION) {
 			offset = areq->cryptlen - ivsize;
 			scatterwalk_map_and_copy(chan->backup_iv, areq->src,
 						 offset, ivsize, 0);
 		}
 		memcpy(chan->bounce_iv, areq->iv, ivsize);
-		rctx->addr_iv = dma_map_single(ce->dev, chan->bounce_iv, rctx->ivlen,
+		rctx->addr_iv = dma_map_single(ce->dev, chan->bounce_iv, ivsize,
 					       DMA_TO_DEVICE);
 		if (dma_mapping_error(ce->dev, rctx->addr_iv)) {
 			dev_err(ce->dev, "Cannot DMA MAP IV\n");
@@ -296,7 +295,8 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 theend_iv:
 	if (areq->iv && ivsize > 0) {
 		if (!dma_mapping_error(ce->dev, rctx->addr_iv))
-			dma_unmap_single(ce->dev, rctx->addr_iv, rctx->ivlen, DMA_TO_DEVICE);
+			dma_unmap_single(ce->dev, rctx->addr_iv, ivsize,
+					 DMA_TO_DEVICE);
 
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
@@ -345,7 +345,8 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
 
 	if (areq->iv && ivsize > 0) {
 		if (cet->t_iv)
-			dma_unmap_single(ce->dev, rctx->addr_iv, rctx->ivlen, DMA_TO_DEVICE);
+			dma_unmap_single(ce->dev, rctx->addr_iv, ivsize,
+					 DMA_TO_DEVICE);
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
 			memcpy(areq->iv, chan->backup_iv, ivsize);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 83df4d719053..0f9a89067016 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -260,7 +260,6 @@ static inline __le32 desc_addr_val_le32(struct sun8i_ce_dev *dev,
  * struct sun8i_cipher_req_ctx - context for a skcipher request
  * @op_dir:		direction (encrypt vs decrypt) for this request
  * @flow:		the flow to use for this request
- * @ivlen:		size of bounce_iv
  * @nr_sgs:		The number of source SG (as given by dma_map_sg())
  * @nr_sgd:		The number of destination SG (as given by dma_map_sg())
  * @addr_iv:		The IV addr returned by dma_map_single, need to unmap later
@@ -270,7 +269,6 @@ static inline __le32 desc_addr_val_le32(struct sun8i_ce_dev *dev,
 struct sun8i_cipher_req_ctx {
 	u32 op_dir;
 	int flow;
-	unsigned int ivlen;
 	int nr_sgs;
 	int nr_sgd;
 	dma_addr_t addr_iv;
-- 
2.48.1


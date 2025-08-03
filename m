Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45791DE8B5;
	Sun,  3 Aug 2025 19:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754248266; cv=none; b=l23t5src95ocrMbgb8akoa2/E1/yFEUDCm83aPmQjfgJGZoPGfeiGPumCqHdltugVRegk7bIOFnMyv3vAEcZYkJMHhOe5jyb5Z3IwjU0rsXPtNfhrn//XiWEXzDghCHQDrJLajT1+5gMXSikQcI//R7FVH2CUylb3z3XuPOJlcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754248266; c=relaxed/simple;
	bh=JhryCQPIHZMBHN4Dh3iGOODDbabwR0S+i4gukSM6ud0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWL0ECy5WUyF7A7Dy0R6R1y4XpSD3HGqehJ6tYCu+H7LXR+icbET2PFpEAS9wGPi0LNSVBw23Dy69Q4TOhCMCchR9O+LmRJXSq7g/a3eDsdehGp6vCJQlSsxzhtovotB3jMVzNSBgGNlxopnGi/YPQeDniB/vXbZVtmvnFbjBpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKhFhjIm; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKhFhjIm"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b77b8750acso2313595f8f.0;
        Sun, 03 Aug 2025 12:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754248263; x=1754853063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yzXOYoDcw0s4gQ4w74V4qvU2nwkX5U7En2+CKV1FmvU=;
        b=EKhFhjImTQFy/j+toRRyW8x2T7oe7KVpsl9vLpJZ8uTgZa5VQKhDGetzkGzveAvtYn
         qZtyj/gel3JYKYDsHeccID/F4Sln128RsBboc4PwpngcT8W7E81zce+e39GTMe8BJc3L
         bSRZ9S2OrMpV3TR3K7UVU0oWqUZgSVpKc0vREPh745TOJMxDLmxKy3pUI2SbLzhbsJOh
         UiH03SVlim5MD+LOG0Acrx0mb2qR58YVO7YPiSJuvB4+IrnLj8ivWVPYpe4OEagPDk5d
         rD2iTpcOdF3YUS8vVcPoQkrr4E/D0f8VRasj0p6LiAbd5H9JtL6NVHJksbPurge8F9xZ
         1Clw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754248263; x=1754853063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yzXOYoDcw0s4gQ4w74V4qvU2nwkX5U7En2+CKV1FmvU=;
        b=ol2PnyN3NLGu8LGAew9VVmuv2gutSp+uoko1DHkIbsTr8cH4unF5CsZQ2lRU6cECXf
         7qmiMNNQziAKTGLVSM4hExv5b5lxUN9wl1OBCgrI1aFzaeku26jvAaTOVN4f85SfTADf
         weNzQK/kQGIS6iRvCeO6rk7txgHUIhQiNKMoenkV4MuE2q8ObXHNCL+5SYBRcGHFFN9/
         HfySOUCdS5t3HV+jWfn6VHF1oKbPZqaUd6m80d+oQxJziXPPoPNmW5ivxwoLvV0Xd7dF
         QUpwqWmL5cDNUK9AZ0lc6OnyW6sl5v+S0vVjBzK32hPkUADkQ0vAQRyyRd+i58VTbBT9
         R5iQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXWe+q1eYXxGkzPCp4+1fj8qEVZucWMv10qs65FXjM3o+0QtdO538E8/NK+geke1CGo909G5ML7qF3I1ln@vger.kernel.org, AJvYcCWQ/9+rSTr6XTkEutAE8hYz+QZcjyP5IKdQrPL0S//dvW3wY+Kn6w616LsDbwLwAqai15InbxML/V6vzNg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBx8yLMuQYq/Kv+5KGe3xDKS7GETI/z1fFaEHFSVSYW1SQyA0P
	r/+I7bgaX4gsQsMywXRJOgvE2oTXjKnvcymLrRHTo/U7FlCDrZOllIQr
X-Gm-Gg: ASbGncvFNRxpiWN5Vk/+ik7chqPoaCbMudEhz/wjw30iFsQCm+xRgUqcgXsV2+rtWqw
	lOYhHhclyWojxtFoGskT8IazWC6MbXqjQVH13W+qNEyJ2+ma8QH3fsdJmJ7/re3b4gbVkXZrOeW
	z+Sv9wkXKm7PlRXmfFHr/3ev9lmhykt4W0Tcu4rprGhjqcLWUxCd/K4LBvTEzBW1BvaZGsBIVVg
	PvLTxsPZ4/e4yL4SP2kjRXRxrY5SWmZVnc0rApWOhHmLeS2Xtwp57A9iIIINQ7+0nO1HD9B5rvc
	t8NMRDbPPditWK3Jt3u8H0izDc6a6vlJeP+hXIDG5LSX9Fwtllx6kjcA8ipuHxkG1LdZTXkQDDx
	/+R0NnekCChJHt95ewCPxROfnpC+roDv942LcSVENrmjE
X-Google-Smtp-Source: AGHT+IG9wEYs4+lgjHCzhOPCxH3cmlxe163baafRUi6P07GZhQb6rgYttNhQt1qtCDkr7AuXCuEO3g==
X-Received: by 2002:a05:6000:420d:b0:3a4:f7dd:6fad with SMTP id ffacd0b85a97d-3b8d959d43cmr5579015f8f.14.1754248262831;
        Sun, 03 Aug 2025 12:11:02 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c45346asm13099210f8f.39.2025.08.03.12.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 12:11:02 -0700 (PDT)
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
Subject: [PATCH v2 1/9] crypto: sun8i-ce - remove channel timeout field
Date: Sun,  3 Aug 2025 22:10:21 +0300
Message-ID: <20250803191029.3592987-2-ovidiu.panait.oss@gmail.com>
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

Using the number of bytes in the request as DMA timeout is really
inconsistent, as large requests could possibly set a timeout of
hundreds of seconds.

Remove the per-channel timeout field and use a single, static DMA
timeout of 3 seconds for all requests.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Reviewed-by: Corentin LABBE <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 5 ++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   | 2 --
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c   | 1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c   | 1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h        | 2 +-
 6 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 5663df49dd81..113a1100f2ae 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -276,7 +276,6 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 		goto theend_sgs;
 	}
 
-	chan->timeout = areq->cryptlen;
 	rctx->nr_sgs = ns;
 	rctx->nr_sgd = nd;
 	return 0;
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 658f520cee0c..79ec172e5c99 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -210,11 +210,10 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 	mutex_unlock(&ce->mlock);
 
 	wait_for_completion_interruptible_timeout(&ce->chanlist[flow].complete,
-			msecs_to_jiffies(ce->chanlist[flow].timeout));
+			msecs_to_jiffies(CE_DMA_TIMEOUT_MS));
 
 	if (ce->chanlist[flow].status == 0) {
-		dev_err(ce->dev, "DMA timeout for %s (tm=%d) on flow %d\n", name,
-			ce->chanlist[flow].timeout, flow);
+		dev_err(ce->dev, "DMA timeout for %s on flow %d\n", name, flow);
 		err = -EFAULT;
 	}
 	/* No need to lock for this read, the channel is locked so
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 13bdfb8a2c62..b26f5427c1e0 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -446,8 +446,6 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	else
 		cet->t_dlen = cpu_to_le32(areq->nbytes / 4 + j);
 
-	chan->timeout = areq->nbytes;
-
 	err = sun8i_ce_run_task(ce, flow, crypto_ahash_alg_name(tfm));
 
 	dma_unmap_single(ce->dev, addr_pad, j * 4, DMA_TO_DEVICE);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
index 762459867b6c..d0a1ac66738b 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
@@ -137,7 +137,6 @@ int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
 
 	cet->t_dst[0].addr = desc_addr_val_le32(ce, dma_dst);
 	cet->t_dst[0].len = cpu_to_le32(todo / 4);
-	ce->chanlist[flow].timeout = 2000;
 
 	err = sun8i_ce_run_task(ce, 3, "PRNG");
 	mutex_unlock(&ce->rnglock);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
index e1e8bc15202e..244529bf0616 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
@@ -79,7 +79,6 @@ static int sun8i_ce_trng_read(struct hwrng *rng, void *data, size_t max, bool wa
 
 	cet->t_dst[0].addr = desc_addr_val_le32(ce, dma_dst);
 	cet->t_dst[0].len = cpu_to_le32(todo / 4);
-	ce->chanlist[flow].timeout = todo;
 
 	err = sun8i_ce_run_task(ce, 3, "TRNG");
 	mutex_unlock(&ce->rnglock);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 0f9a89067016..f12c32d1843f 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -106,6 +106,7 @@
 #define MAX_SG 8
 
 #define CE_MAX_CLOCKS 4
+#define CE_DMA_TIMEOUT_MS	3000
 
 #define MAXFLOW 4
 
@@ -196,7 +197,6 @@ struct sun8i_ce_flow {
 	struct completion complete;
 	int status;
 	dma_addr_t t_phy;
-	int timeout;
 	struct ce_task *tl;
 	void *backup_iv;
 	void *bounce_iv;
-- 
2.50.0


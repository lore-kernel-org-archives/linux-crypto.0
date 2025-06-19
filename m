Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C2D23B609;
	Thu, 19 Jun 2025 12:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750335856; cv=none; b=XJKeU/QijC5ZCoLqYVuY3agizLAS+dNDu8daYNZtXcP2TNXNL8bU3bAtjbKXB8/+NK1I3S+vaMqaoxBkdj6JpfIzMl83WmspcQac3vUu4/ecIbUI5g3iIvXCf4WmZTyI6WhNwZ7lzE+Xe0o7eJmJrI9UwpBq/Kd1KzY4DVHfNpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750335856; c=relaxed/simple;
	bh=V+HFJ3mcjgzB1Gr3bIDT3f6dj+Z5XsFbLbUNii2zGtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCEKQ/AoZjVCiaLI//f4b3JntXUtrCOdXJ2DxNOnhscixsVAPAvHsnmLvpGiIvh+DJQYMTdiZAZsJLF4/M5Q1qZh79+xG5MapzQb1BO/L1aNDWo4kZ3YgeSlkNDty9v7kTzUY0sq/1L/W66DE7PPVfC7/bcLGBwvTq3RwWH6hvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e64iRcA4; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e64iRcA4"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-60867565fb5so1162194a12.3;
        Thu, 19 Jun 2025 05:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750335852; x=1750940652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XbU44eJvfJDBcTZ+xWKQo+1cPwZ/TlkyCXqSjcDCqLQ=;
        b=e64iRcA49GseZRg/Cm6Ag73zA/ieF1F35I98NrSMSr4juBfQ3ZNGQlQ8olLp3appq2
         Gq4Tr140wnbe3piq7gdnH2RI2L0RvjSg7cmXIBedoXWFVbUORQuzZ6JIC6SkyuPW3lrQ
         L3KEsGSct5CY/vSpX3oUPNekU8WntzQx6KmAf6rSJJPeVH3h4+VEyKjopUKkdeCg5C6w
         wlraUETxG9B7hURQFe5PmMciiRbF43T1R30QOyXEYDzbCYSnCWiDHhu6Jfx3INOF3P95
         WeRUmj+amyWbt73rthqKvG4uFRo12M0cZpUVYX9kRUQEbmLO0pUOD9auSdvsBvEL1und
         2xyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750335852; x=1750940652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XbU44eJvfJDBcTZ+xWKQo+1cPwZ/TlkyCXqSjcDCqLQ=;
        b=nTk3F3F2IrbpguFQb0BOjJVkGx5AkEDXfXT8fhk7p8powDUJTYZkzhLfBTHN9j5Ocu
         liJPnc0+r0stvVkUD1+BQe+tVtBVKRF9j3pPLM5r5DRQhUiTH4tLxlHz9aYY+Q5X/NBE
         pJ3fmW5ZJd1il6LkOaeYCP7GYOo8+uanTlbtROgwJuSFaGhjdpmZLCyIwt0ChN1LKawG
         i56GIEM4pwS+dnxD6jEa5m2hMdDXUOpTGR7BuRTLXUNQr/OxycPYlPjmS4u9LO/cY1LE
         YrAmFAysCR+pBWH+SetC9L4srrmnX8Cak7HPWIWkh0fqR547PgxueO4ACs5sHGMYl+YV
         qhCw==
X-Forwarded-Encrypted: i=1; AJvYcCVb1R2YSY30rurdb7t4T8ZC2lc0Ao0UIptNpJXUMSF559PNg/u2IwRPEtgR17s3JP5QgKn3l7E3eIHhGzY=@vger.kernel.org, AJvYcCWKz0BqHZtSU6EYwjy0Te9Bzu6B7vo+xC+2xZmFKyhOFJWfyqyVKR7m47xZU8yP/fPZL4vLXb9XrTkXaaeG@vger.kernel.org
X-Gm-Message-State: AOJu0YzA2O/jYc0ThEV2cEKVWr0r3nUH1GklT6ONK9WvDeP6o3jz+ThK
	NVF5YL8YkLTPIoXSaIxcOBwRdTbQHMpUm4t5fNGfR4CfcsuYhgH36Cwf
X-Gm-Gg: ASbGncviVRDCjeTnVZfbdSRZPLloAKT8xp3EVy045rcbfCULpe+9ZG4kNVTcTKBJZ9h
	DlAcmmR1VtaSdvQjZ9omwnYyxQ5x8+P1SgMzbIErhh12p5o0osPvyeOwZrMf86h9M+iC1ZH33kh
	2p0406N1g98xLoIjEggUDibQmMYVjcf5yyLjllgYaZbW1e+95Ug/o5icgCNVAlfBPYZuEtk7p5d
	qiTRQn/mx0F/1sUL8fHQz6v3hcROq92c6dqeXDrazA/a+FGX2Og2EbHRzWTO6eUn95wkwk1lVFg
	oAVJfPpkZAyirFTV3teXtvL1oz/P8MkAfH/i1b8p+ucKNn1PuDQPtWUIrzZQfy8ldbMr+nXU0gw
	6UeVviOHqTo1oqA==
X-Google-Smtp-Source: AGHT+IHxZ6KyDVZH+/AWtxZdICZOs1YlDPZ1ZpE6Nu/jpvdE/3Ii2DDUvVsNbEbPVhvCkr3A2LmzwA==
X-Received: by 2002:a17:907:d86:b0:ad8:8d89:bbec with SMTP id a640c23a62f3a-adfad4123a2mr2149991966b.28.1750335851736;
        Thu, 19 Jun 2025 05:24:11 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae000b02bd3sm504688066b.3.2025.06.19.05.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 05:24:11 -0700 (PDT)
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
Subject: [PATCH 01/10] crypto: sun8i-ce - remove channel timeout field
Date: Thu, 19 Jun 2025 15:23:07 +0300
Message-ID: <20250619122316.2587236-2-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250619122316.2587236-1-ovidiu.panait.oss@gmail.com>
References: <20250619122316.2587236-1-ovidiu.panait.oss@gmail.com>
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
2.49.0


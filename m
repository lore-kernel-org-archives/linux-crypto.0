Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D9D2F1FC9;
	Thu, 26 Jun 2025 09:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750931962; cv=none; b=XYl6dojZlMYksOOYP0xwfUFCNSo58WuCwjolO27mtvRKvqN8sphOrvPEBlD/LpWyu7ZT9c+7plE4+dMSJvLvLy+89O9uXLr10Iv+ziUV8bU2lkNPUtheMu+IbQYI7fz0w91cXawF6Oiwe1n2GU/Z8kYIPoQjHpmQdU8lMCIDo9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750931962; c=relaxed/simple;
	bh=V+HFJ3mcjgzB1Gr3bIDT3f6dj+Z5XsFbLbUNii2zGtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzXTEXK7ytxd/HhvjCGSq0O/jAeJJkJyRGGHex77adYO0ypJa56Plqvn8kHAWCZCcDN0hOxUggx1xKc/LRKlXJJhdxwrfWha7v1OYSvhZI1DPefuicFAkswGJwsmK/xFbox0bIel0B5/gft5zT+75LlZLA4yo6f1lhfQZ2qymaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a0h5DQ5T; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0h5DQ5T"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-60c4521ae2cso1451737a12.0;
        Thu, 26 Jun 2025 02:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750931959; x=1751536759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XbU44eJvfJDBcTZ+xWKQo+1cPwZ/TlkyCXqSjcDCqLQ=;
        b=a0h5DQ5TOLNkU15uXdaSIRBXhsFc7OHLWyVganC2PTTSgPiZGMnnGB++tR4VWuPCsF
         frlBeUj5u2j5NE14iIPURbtg8a1gdmFw8JPtfd0E638pBw4dQO/XGoaoIec7W1JhGerq
         uQsaP5u4fEzfBr2Pf6bJkRQl7Kr8UPpMnlkP2xlgwb8R9m3A3c57KUPPJjonBm+zU74v
         qSgGflfp7iDkyWO++3yZyDYXI7MoTm2niaqL/rpnHGjD/RdPEicOApK+cRoFDsCO4vGi
         H3eTOedPtVncfRLc9zHtn3MTRyCnJM3K8a7f9cWbEOgH46NOquv38zn6cKj1aMOh0qCc
         jXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750931959; x=1751536759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XbU44eJvfJDBcTZ+xWKQo+1cPwZ/TlkyCXqSjcDCqLQ=;
        b=rBR2I7WE6jhDG0++cakDNUejjLmwEMQRjgLZeNoRol697h6VQPXEH/RsfPSsV57FCh
         c9NDhhZR+hLDRL+7D6qP/JSSfHe/DRb/6Qc+u1RNskyjEMbOGJ4Acf0HIKU2mi+dNueQ
         9N88gG9Ss0m8uSHewVzAStO/cZkh7YGNKhrjIRGf1pFekL28EkbAlgW/ojLXaiR8k+ar
         8NtDMxQtsssp3nLTgJuoX3hXRES0DQ559bs2UHypzqFEUVGqnUuoCRAQDMcTOJP9KfXL
         Uy2RLuNGXUvH0QMWLN4QHPkMyMe3E+psz6Gko2l3X3wOQ6clcifRES1VB2iduxQeU5IS
         BThA==
X-Forwarded-Encrypted: i=1; AJvYcCU0qx0g3G4rpe7CTBmvx1zQ8JFf/ppmBMsGKzei6zgQlD8cWywhsq5iNwFbyK/kIdj5Ogn1rMNwyvP/vRo=@vger.kernel.org, AJvYcCV3m9+oeaBHwzX3H0VXcLc3t+DMdRAwyyP8jsUqZj9VV4zf9p8ylXr4xqRaDH3lJwiUqFEyUn9VntDV9+EY@vger.kernel.org
X-Gm-Message-State: AOJu0YzfR+lAd3y/qRHJ2JhqVauzxOMUBhWxn2feTCFhpUX/H/3/5ew/
	72cchK+BR3/VICGt/IziJqIiDwflOEWKiX4NTUY2C7FACNNA/BH4fRpT
X-Gm-Gg: ASbGncuvftrvMWAjKqBA4tdi3sE3Ede2qh5NfcEJ1H3HXPgWFtzKxBrLBDs4KwAr/19
	IqGuAjs689ddddT+Ng7WcU+jkOsqY4gSd/Vk5SZDzs2npSgpeWgRPwoySf54jlerAZRzamnerOv
	CziRJiYzOuKxneoY6dJB76Ulup3AFRJ62+bImgBJQ/0Oww0h0LBR8ykecQQW3hY9B4s+7Qbl/HT
	DZEPoV5oKPra66awf6ycBj6Z4PEGkCwdCs0wYlml1zUwm82tawBmUvqvMfn408e2wIT5z3FGMIt
	jqrOEN6Nu+AqHDwBhP2GhqFQK7Op78IvdKzoxeaXJEtN9MlP+7hAoMEgnR5NgIBamfw8EKdYHCd
	3TSnw0MApg63v1g==
X-Google-Smtp-Source: AGHT+IEaMXp6A7i8DWJAL63v7SwwWZbY3qhE9qWDgXfE0g+LUPmTke+IYpv3zr+vGVl6rNn5ZDE3ag==
X-Received: by 2002:a17:906:360f:b0:ae0:bc2b:61cc with SMTP id a640c23a62f3a-ae0be84e3e8mr577634666b.14.1750931958448;
        Thu, 26 Jun 2025 02:59:18 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae06aa5ff34sm1014106166b.40.2025.06.26.02.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 02:59:18 -0700 (PDT)
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
Subject: [PATCH v2 01/10] crypto: sun8i-ce - remove channel timeout field
Date: Thu, 26 Jun 2025 12:58:04 +0300
Message-ID: <20250626095813.83963-2-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
References: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
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


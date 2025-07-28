Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9270221FC4;
	Mon, 28 Jul 2025 06:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753682881; cv=none; b=TG7HPDGtnqxkkCUqVKeHBJvX/VWau+GFqnosPFoMq3pGOveLswvjK6eWvGb700xE9qu4dvTkNVEbSA1JVREbEJZL6fXX22DZ/8OkLtYEbRbILXC1rBJXpGsHqObCal8hJTonDtbDQfmMI9tNvvMZtA8UEv6zNJY5XNMoMPIQVIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753682881; c=relaxed/simple;
	bh=4zJMhQ+VcPBQ76ASBvFai/gasWQveJW54RMGe/zEYD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CW9S8SIGF+xVgzgs2qsHg315m06tEqcplIWR+zIvcKzculXSky4LiAd5DQQM2FtGK2lRFuYHfBRRJ8cqPnvBHjbqOJO8h4C9ME1e6RWpNw1gp57L20njLHubr1AAIDO0EHwydj1560Se6PHc3BONvvzt/YsNc7EfT3j5JqlJow4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LGpgnINZ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LGpgnINZ"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-456108bf94bso22401055e9.0;
        Sun, 27 Jul 2025 23:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753682878; x=1754287678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j2K/bAbM7b4hD+UZ1sY7e2X2nlDeVKcJvl2Epy7suEc=;
        b=LGpgnINZeihBfuUzyvGWLniXRs5uPRfuRZpwiNZUscJSv3u7GAUApG7UMnkRQlPlVO
         SzR50DAnGo1/37/ABTT/bBRZMwi12grgr2J91RBLNFcxtnp8m7ppxPeNAHndlDbKW6Pu
         SHAzLO2GQSQ5X9NO46OQKk6yS3dFQCyZwg6uElMZbx00C3ENquyXpfgo0j1e3stWpnB6
         SYaufPGeaIxwU8QckXqAd8woanoAQYWOkSb5ynnE7iYZhhHhRgcyTMPhaumsxxoNxWgs
         5LYJE8T4adL/FoInJYuv12KI7GA3BSu1V+P1Xx639sI6GCgcwmEs09KctkPEBQrYGMEx
         NCeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753682878; x=1754287678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j2K/bAbM7b4hD+UZ1sY7e2X2nlDeVKcJvl2Epy7suEc=;
        b=ht/kcx4xwBtok4km8v+7L5lGc7RPp5QlXtRgdGXZjntOvFIbGLe6t1QbD9yhBbe8VH
         7uEgElgZl1unyb/dKgbQM34Vl9SM4cMxNyRwuIdNPZ3arsHLtWjQWu4oTK4QjgdcUeWG
         2Y+z9KsRw2F5sFwr1ihFvl9hh3KFFjgBpS/8GmVFP7AWld3J6KfE8KJqBHybPPiEgYIt
         bd1VGnj6v0YDoY6Q2QUGwRBRJ661YmEQx58SDO0w14pzRwexSl17Pd35PiCQ41wlChm/
         GplYxrV0NDsjoz0GX+S2M4E+kaTBpeI4BK+zgCsELlFXOdqKLi+ljoJvnn2mrJd/1AJ7
         /SNQ==
X-Forwarded-Encrypted: i=1; AJvYcCURD/mvzyrTsckDmXHkSBoe+K6Vxu5fQ55lgQ630KCZVZM+cIyQ6/8YOd/e9Bl7SgkjDVFAwDl8cXIc32Q=@vger.kernel.org, AJvYcCV5XWUaMWB6SChnI3c/zwfQmNgFGznNxOI81o0RNhlITXE6jalxDQB/3LWr9TSl/kC7EDAwwfzJt0/uEdup@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2XzCq1nsfOFRFS8GE8onQxtTOmYLAV2miCRRIhcxFeSExRzlW
	uvxYlSoD4LHw041rNrKP4AEgblgdyOX1INTDshzQ3fUqfImQbx4ginxD
X-Gm-Gg: ASbGncvELjrZn8Jj4EK8lAWMq9MLQNba0j1AnYX8S3USrj9Oru8PZXVHVt2JO1hi9pu
	3lWEsxXl1WsDplngZNYEWUaS4jrm0SNz5d0YrrE5sQc6BdH46PVx3eWmnk3khUPtBpHo6ZQGRZ/
	Bh4HsmEy+2YENO98pCRTsGB6ZPSIwMRKEGAu2lt9W+AJD1ehJcGO21/uvwEXK/gStju1c/3nYKA
	BnJou6EvKXCLTvT7hiEH0YKIiWNWbZTYCTRA8I7vxSkj/BtZVnpVSbzeLr5/cP3I5POg8I1ULye
	i6X8pgEYsl+iEzcrTHBRpa1w4rcWgvBPB2bKjkQULaBrrOPCJ7sG13/iC/uVIgQUbyEDmZFPRlS
	RSG/azfczwLWlHbqLqVlQJfp9WEGzA0Stcg==
X-Google-Smtp-Source: AGHT+IES0WVeYiOQzgvF9uZ/F/ZuRvB9DCBVa5KoIGMgW6lVQFOUgMPsAT/Es0z6LGY/i4jb9SI8lQ==
X-Received: by 2002:a05:600c:1d1e:b0:456:3b21:ad1e with SMTP id 5b1f17b1804b1-45876442799mr90886165e9.17.1753682877810;
        Sun, 27 Jul 2025 23:07:57 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587abe6ba0sm86195215e9.9.2025.07.27.23.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 23:07:57 -0700 (PDT)
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
Subject: [PATCH 3/9] crypto: sun8i-ce - remove unnecessary __maybe_unused annotations
Date: Mon, 28 Jul 2025 09:06:55 +0300
Message-ID: <20250728060701.1787607-4-ovidiu.panait.oss@gmail.com>
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

There are 4 instances of '__maybe_unused' annotations that are not needed,
as the variables are always used, so remove them.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 4 ++--
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 113a1100f2ae..c57c64a1a388 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -111,7 +111,7 @@ static int sun8i_ce_cipher_fallback(struct skcipher_request *areq)
 
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
 		struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
-		struct sun8i_ce_alg_template *algt __maybe_unused;
+		struct sun8i_ce_alg_template *algt;
 
 		algt = container_of(alg, struct sun8i_ce_alg_template,
 				    alg.skcipher.base);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 79ec172e5c99..326d9c988bb1 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -1062,8 +1062,8 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(ce->dev);
 
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
-		struct dentry *dbgfs_dir __maybe_unused;
-		struct dentry *dbgfs_stats __maybe_unused;
+		struct dentry *dbgfs_dir;
+		struct dentry *dbgfs_stats;
 
 		/* Ignore error of debugfs */
 		dbgfs_dir = debugfs_create_dir("sun8i-ce", NULL);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 61e8d968fdcc..df2acef9c679 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -26,7 +26,7 @@
 static void sun8i_ce_hash_stat_fb_inc(struct crypto_ahash *tfm)
 {
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
-		struct sun8i_ce_alg_template *algt __maybe_unused;
+		struct sun8i_ce_alg_template *algt;
 		struct ahash_alg *alg = crypto_ahash_alg(tfm);
 
 		algt = container_of(alg, struct sun8i_ce_alg_template,
-- 
2.50.0


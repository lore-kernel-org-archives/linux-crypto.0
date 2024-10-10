Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1286C1E7C27;
	Thu, 10 Oct 2024 19:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728589529; cv=none; b=EFPhTyWvc0F5dhCANxva9Id1igBWC+POh1AuFPu5z+BeQgZpuE0zHDUCRIY6EmU+u4OAlvamwYZk/knyDgxag1GiplSUWgR1SdwlxRu1l2lyDpU2/AKee1T20PyZit5MKB7/4okD8sKlHEbC/hn7hrHfndYWNn/5aNZC2rg4mKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728589529; c=relaxed/simple;
	bh=Av1xCzAK+uKt7P3u8vHTcsZRd7/NW6AnUr8uFgMtcA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGoUSLQNMYcwwXkNi8bjJx8TO4wqWLMjy/NZ2ajrPUmxdfgNHzzxE1fUntwiF3ioV7KJ7UCU6CpQ8UXtWpx/mrmJVk7cc8GMNq49J26GVBePzYQizlonhG2qUEWEZrykb7kmATpX3aJFPzCCFRpTD08t0joMwVTN2GZQXgGUCsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=geSU3+U9; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="geSU3+U9"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-71e05198d1dso964630b3a.1;
        Thu, 10 Oct 2024 12:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728589525; x=1729194325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3nfabQEDdcv7hLN1dH0q/bo0Hp0JIO5gPIPoowAAauU=;
        b=geSU3+U9uzNM6dFi8QiolUdgvZhysunDI0GZGmb4bZKbEy72be9SO7egQA7QJamzE4
         tv/tXJmTnSIOa+j+BFN4MRanLW8o4PVeZjBwqNj74SCOfPDBIeudlCDsdjS47i9aS0Yb
         JOmbJg/+SzL34B5L0gLlkU3S2uiQ06zNYR0wgXOXL/eSX2bYtYbpJlmT/YG8UcJn0cf8
         FKnGt/BKKaqrlNJ2Hf/21ZBDQVXzw+sxRohiadV/mlANIC3AW0PRutGXmyqSYYRnTHBe
         cecaCu2eZfZ09BT/0moUv1mUjGiVhyDTWBsLP5VzGfpFyJbkTlreLlOTdRr1c2jU/BmN
         fNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728589525; x=1729194325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3nfabQEDdcv7hLN1dH0q/bo0Hp0JIO5gPIPoowAAauU=;
        b=u31gu/Qnko4cQ0kFUougTrUNZuGXjTHo+1gsQnAE31xOkFgW7ohpgRuLooydqdXV+t
         lfq5H1JvyY9+bcyeutZQsoWrD/E6f8O1t+zH/tDn4dpHB3iiz/hNhhNjxRdTxlEruF6O
         DVKEJcpPbhlKExZmSDTIAFPVpCK6v3YzzL38tvyH77XYczDxmq2r6BIOULABoqqi9fUh
         gJi36WpO9ZQu4BZGdNgqGeFAt87D22bUo815vR03vM202KO+Vw4ghY0N6kOfqgbABA1S
         rvma3Vo5YNH0k5itHkkxFfGsPEP2Tmj8jjQm5/EBQckEY9GI+oFo0KyZYRnwRuTpRgXx
         j27w==
X-Forwarded-Encrypted: i=1; AJvYcCUgv0tNQHPJz7p1fyT5Koqr7ZcLT4qaP9dR9RhWy9eu9Zyb88aC3t0nVsF0rbTHe/ChI6ARCfkwPbeDkV0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYYJTP+EQyvr1c1UUmq/ClJ92vphYE8j14dkoTwkFxL4gCnIgL
	0yPUQLOcXq1UP6PHBH815G+fLcOO644OOX/1QJtRSNyQ7XAlhWRUZ73wLL6h
X-Google-Smtp-Source: AGHT+IHlqQU/t6YV4KmGc30H4lcfsZuM7HVN21cEg0okeM9ski00r/ZlMssJcZnNTe+yZdSU1TWQJQ==
X-Received: by 2002:a05:6a00:2314:b0:71d:fbff:a4b6 with SMTP id d2e1a72fcca58-71e380c5f82mr264766b3a.28.1728589525085;
        Thu, 10 Oct 2024 12:45:25 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea448fe50csm1374762a12.29.2024.10.10.12.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 12:45:24 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2 4/5] crypto: cesa: move loop to mv_cesa_put_sram
Date: Thu, 10 Oct 2024 12:45:16 -0700
Message-ID: <20241010194517.18635-5-rosenp@gmail.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241010194517.18635-1-rosenp@gmail.com>
References: <20241010194517.18635-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simpler to move it there. More readable remove.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 31 +++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 21e13f4a1f48..a65f328b7094 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -416,17 +416,23 @@ static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
 	return 0;
 }
 
-static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
+static void mv_cesa_put_sram(struct platform_device *pdev)
 {
 	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
-	struct mv_cesa_engine *engine = &cesa->engines[idx];
+	const struct mv_cesa_caps *caps = &orion_caps;
+	int i;
 
-	if (engine->pool)
-		gen_pool_free(engine->pool, (unsigned long)engine->sram_pool,
-			      cesa->sram_size);
-	else
-		dma_unmap_resource(cesa->dev, engine->sram_dma,
-				   cesa->sram_size, DMA_BIDIRECTIONAL, 0);
+	for (i = 0; i < caps->nengines; i++) {
+		struct mv_cesa_engine *engine = &cesa->engines[i];
+		if (engine->pool)
+			gen_pool_free(engine->pool,
+				      (unsigned long)engine->sram_pool,
+				      cesa->sram_size);
+		else
+			dma_unmap_resource(cesa->dev, engine->sram_dma,
+					   cesa->sram_size, DMA_BIDIRECTIONAL,
+					   0);
+	}
 }
 
 static int mv_cesa_probe(struct platform_device *pdev)
@@ -566,21 +572,16 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	return 0;
 
 err_cleanup:
-	for (i = 0; i < caps->nengines; i++)
-		mv_cesa_put_sram(pdev, i);
-
+	mv_cesa_put_sram(pdev);
 	return ret;
 }
 
 static void mv_cesa_remove(struct platform_device *pdev)
 {
 	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
-	int i;
 
 	mv_cesa_remove_algs(cesa);
-
-	for (i = 0; i < cesa->caps->nengines; i++)
-		mv_cesa_put_sram(pdev, i);
+	mv_cesa_put_sram(pdev);
 }
 
 static const struct platform_device_id mv_cesa_plat_id_table[] = {
-- 
2.46.2


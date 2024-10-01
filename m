Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC361CF5E1;
	Tue,  1 Oct 2024 23:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727825154; cv=none; b=iBnpMwP1+OyzsZMcC+wWNI1EqkT10wNtisH1+9BR5S/QXTW0aDIHVXaQEKlOAiEnIXywIgaM5Ju0sxxbwsITKKGgpCzdwEkhNygNIeg2m/MBJznwEM5QqrXN3fpsXrbrmWKeMREHz8Pr9NLqZMsx3ihCTW0OB0U0D8QzTmNGC5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727825154; c=relaxed/simple;
	bh=lo5OoE5NS4ZISLM1Q/pBTOCgK83yqQClyBy/YM3R3WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaXJiusZeiLJ9EMApv77pNG5+kI6XIUsdTN2Kh8DsBqI8hunwPzYhP2YKjKeEod5w30y51KwX+Wjp9FoY23iMAwkI3yazNg+kbsP3mXfmuJMFvojWWWRQnsltdrNbE1uhC2J+w+mTTBJLVuJLMBy88vXI1/nn+FePomWXshf1/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WoTyHoXk; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WoTyHoXk"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-718d704704aso5124909b3a.3;
        Tue, 01 Oct 2024 16:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727825152; x=1728429952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+BRLeIPOzKlGspJqEHRBhJfVfhiwh5nKq1NYIieIKaI=;
        b=WoTyHoXk5PVsFRgQ4K3YqBkHVgqzL2vZblBy8sfRMTdH+iC4mAKEiBTDJQneCxZa+/
         33G3OyhDe9hRB9tU5/skbn21hAPe4ZHhFggjQdCFNqULh0a8fwsLgqI0Nje3aY6mzmpZ
         njXO9y3JZ4xGrANrEFEzkXA+L9IivLglP97NuB6q6/K3TswQw/cdfRfiVqFa197s4f7d
         01EhNWHvaKMB/UGMbDLr1gd8Cuf9d0qmK7FsV//6j+yioJOPR4peXlkwCBTXd1KgEQSD
         QsiBfs5pAnCLSvlFFXzHnW8vv4/rgAjehg3mpNu9qcMBuMDje4lHN8vUD1L8pNlgMi+c
         Y0Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727825152; x=1728429952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+BRLeIPOzKlGspJqEHRBhJfVfhiwh5nKq1NYIieIKaI=;
        b=oWvQ+8QRSEzhZ23RPV76ij+PpOE01Q/YvCIspHmX37rfPtOnvArmHVG4l0VYwkDpiK
         yQ4YZFNxUenfatjjDs6FV5XIA7PqI9jJDs3ZrJau6Oa9WHpjl/lgVaEPdOKmNRUMirQW
         unwTRMD4EsywWYc7P9MiCeAy3jbA6OAusnxIRjkwg2oak4bJO5xgBqdZxWORgIs/fGFq
         3htebzkn/YCiJ3CbcMkJqndTfAQb+0gHTm5zr+W6/7g64X/oFp6QjzuGC1eNw4vVQKVt
         yahCr7l98RgGDOByka7V51m+MgxwKELjSzbeLquSDlVXpobY1gTXMi7H1iPsRSD9KN2v
         hVEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWt0P2fYUcrcybVL/T30VikyS0ntmpGO+g8DrTSjYPVCPQweroZo9+KwO3L5yc6m4C6c/ex5BX221S/+7U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUPPnQTdGfJyDb9u8qMCpcK2zQIQAa2Fs+gXMkMYC5nVwGUmls
	XT12pCG7RwijcpZFyAbZoK/TupnT8Fhr4uKCHsvJxtm7im9Z6dtPFwMLPhIr
X-Google-Smtp-Source: AGHT+IEGDOZSxoHLPpL3dnePzf4QIR+MpUVPpmP/+mTzgJ4JYTkFuoN42YY9m7oXr4jXRtTXQ85bkw==
X-Received: by 2002:a05:6a00:3e04:b0:718:ddd9:a8fa with SMTP id d2e1a72fcca58-71dc5c93cd5mr1965247b3a.16.1727825151874;
        Tue, 01 Oct 2024 16:25:51 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b26539c5asm8628143b3a.210.2024.10.01.16.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 16:25:51 -0700 (PDT)
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
Subject: [PATCH 2/5] crypto: cesa: use enabled variants for clk_get
Date: Tue,  1 Oct 2024 16:25:44 -0700
Message-ID: <20241001232547.355947-3-rosenp@gmail.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001232547.355947-1-rosenp@gmail.com>
References: <20241001232547.355947-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoids manual frees. Also simplifiies the code with _optional

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 5fd31ba715c2..1c90e65c89d8 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -510,24 +510,16 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		 * if the clock does not exist.
 		 */
 		snprintf(res_name, sizeof(res_name), "cesa%u", i);
-		engine->clk = devm_clk_get(dev, res_name);
+		engine->clk = devm_clk_get_optional_enabled(dev, res_name);
 		if (IS_ERR(engine->clk)) {
-			engine->clk = devm_clk_get(dev, NULL);
+			engine->clk = devm_clk_get_optional_enabled(dev, NULL);
 			if (IS_ERR(engine->clk))
-				engine->clk = NULL;
+				goto err_cleanup;
 		}
 
 		snprintf(res_name, sizeof(res_name), "cesaz%u", i);
-		engine->zclk = devm_clk_get(dev, res_name);
+		engine->zclk = devm_clk_get_optional_enabled(dev, res_name);
 		if (IS_ERR(engine->zclk))
-			engine->zclk = NULL;
-
-		ret = clk_prepare_enable(engine->clk);
-		if (ret)
-			goto err_cleanup;
-
-		ret = clk_prepare_enable(engine->zclk);
-		if (ret)
 			goto err_cleanup;
 
 		engine->regs = cesa->regs + CESA_ENGINE_OFF(i);
@@ -571,8 +563,6 @@ static int mv_cesa_probe(struct platform_device *pdev)
 
 err_cleanup:
 	for (i = 0; i < caps->nengines; i++) {
-		clk_disable_unprepare(cesa->engines[i].zclk);
-		clk_disable_unprepare(cesa->engines[i].clk);
 		mv_cesa_put_sram(pdev, i);
 		if (cesa->engines[i].irq > 0)
 			irq_set_affinity_hint(cesa->engines[i].irq, NULL);
@@ -589,8 +579,6 @@ static void mv_cesa_remove(struct platform_device *pdev)
 	mv_cesa_remove_algs(cesa);
 
 	for (i = 0; i < cesa->caps->nengines; i++) {
-		clk_disable_unprepare(cesa->engines[i].zclk);
-		clk_disable_unprepare(cesa->engines[i].clk);
 		mv_cesa_put_sram(pdev, i);
 		irq_set_affinity_hint(cesa->engines[i].irq, NULL);
 	}
-- 
2.46.2


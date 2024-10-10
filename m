Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551751E47BE;
	Thu, 10 Oct 2024 19:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728589525; cv=none; b=VSEXTQXzgGqgqtVmMN78sQuEJvPb3w5etTdenGuH3sKwTLIIpCZAS+2ULr3+quyXONHWPRXuOyOlnniU6GlFUu78U0AHt22fZ9HLxcYiDzACRJySTE3McAN+oNiE3sW23woQcpKqJrdj1K8iRDfSrhJi8+oC/DfG0uj90cIdVs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728589525; c=relaxed/simple;
	bh=Nx8VNWN+Ged3O1ECbBqO6R/sGi7JiDO0mxBfjYcGi+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T38xaQ0eQi02FWSdlXa9Dth3W11xcspC2iUcmtXrIS/D+YTjprwNdnWDpy/+NAEZUo4aY6Q0iNfxCHIwUYRNiKJ2cdcdi/7fActLYcWoOh6MHQM66A49FYGeaWOrfzsdYV2r0qU6A2wDg+HPsqpqHa7WoHcE6RzeBw50I+HVz/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TzaqbktZ; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TzaqbktZ"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7e9fdad5af8so924987a12.3;
        Thu, 10 Oct 2024 12:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728589523; x=1729194323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=amc+Up8qxLrazdJMaZGvOUoweFN2ceImAtncendD8oY=;
        b=TzaqbktZv/TiCfEMPEMK/lbkNIrdK9BqKQA7u33j2WJD6a/GBYUbXMJ3ozzwCsbY/Z
         KJK2H7BApa2laOdevpD11DYWuYaFlgycnuoHPcv1RQES5Fi+2ErxMLOKOk9d8phGyexU
         WA09gVw1IycIQbycIh4YKEmYxim6PdkZdWmsLdkZmtYPMI9M48UoJIMqj/u8bjovmU+9
         2dsgK/MTUMidbPzP3ufs9LjqM0GaxqNhg9UChnye3m8fY3UbBhHz39VlgRdpKrI00c4K
         9pP/EriHALYekI2zG6jodGrm6cUssOmCHs/tD5iu8cBRE/mmYnMgPuYr7f2nsRauPUmc
         w9Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728589523; x=1729194323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=amc+Up8qxLrazdJMaZGvOUoweFN2ceImAtncendD8oY=;
        b=r/xxBLC5sWM+Hhowu7tnvWG4xWMa7m7fk+S4QzkKCoy4jh5XV9GVNmFP3WHqRAOlhT
         jQRbD9gvwmUOT8gWmsD1GyKrPDcmOvQovUy/SWedm1EL0nhP5m111fBo8NlXJVrueCmj
         UkepdyefovKZ9B0n6w442hNMALVe5tbz6GHw5i5c10XcMgqIegLWN33Q/5trNqM5q9nu
         M5X2vxa9lauFUn1Qn9a7HK37i8r4XBanx83HiOp3/CxeMqBxy6t5u4ApMr6ZtcZv5aLV
         ZcQ45viu3odG+XshplipN4tiFo6A3FlVkwb4E6CIOjLo3VPg8vt65Vrn9TaPgbgxDeCn
         cJXA==
X-Forwarded-Encrypted: i=1; AJvYcCVPJCdKRLYut178KUXl8jekG4PkQbpOs8apax22S9STf36nKw9AyevXUQtLdmDq9Rm3D986w/EfNbTIc2g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoyJydwnbboW2DYgwtRxoGvWyTN5IsK2ukE/U1AszuRzeouYli
	wLJExL7xNsf1gZcZh0J7F6RtbOZd+CmexKH5VqvoBu09rBTTiarKDCHAhIQU
X-Google-Smtp-Source: AGHT+IFkirpTzTrqn2x77L+6KEBiz+UL2XhWYWjOstJb/n8nW3QzKgmGPGSB/e1AeS2U+BH360ea+A==
X-Received: by 2002:a05:6a21:3990:b0:1d2:bb49:63ac with SMTP id adf61e73a8af0-1d8bcfaa073mr151956637.40.1728589522067;
        Thu, 10 Oct 2024 12:45:22 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea448fe50csm1374762a12.29.2024.10.10.12.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 12:45:21 -0700 (PDT)
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
Subject: [PATCHv2 2/5] crypto: cesa: use enabled variants for clk_get
Date: Thu, 10 Oct 2024 12:45:14 -0700
Message-ID: <20241010194517.18635-3-rosenp@gmail.com>
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

Avoids manual frees. Also simplifiies the code with _optional

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 5fd31ba715c2..74a1d1ad67d3 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -510,25 +510,21 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		 * if the clock does not exist.
 		 */
 		snprintf(res_name, sizeof(res_name), "cesa%u", i);
-		engine->clk = devm_clk_get(dev, res_name);
+		engine->clk = devm_clk_get_optional_enabled(dev, res_name);
 		if (IS_ERR(engine->clk)) {
-			engine->clk = devm_clk_get(dev, NULL);
-			if (IS_ERR(engine->clk))
-				engine->clk = NULL;
+			engine->clk = devm_clk_get_optional_enabled(dev, NULL);
+			if (IS_ERR(engine->clk)) {
+				ret = PTR_ERR(engine->clk);
+				goto err_cleanup;
+			}
 		}
 
 		snprintf(res_name, sizeof(res_name), "cesaz%u", i);
-		engine->zclk = devm_clk_get(dev, res_name);
-		if (IS_ERR(engine->zclk))
-			engine->zclk = NULL;
-
-		ret = clk_prepare_enable(engine->clk);
-		if (ret)
-			goto err_cleanup;
-
-		ret = clk_prepare_enable(engine->zclk);
-		if (ret)
+		engine->zclk = devm_clk_get_optional_enabled(dev, res_name);
+		if (IS_ERR(engine->zclk)) {
+			ret = PTR_ERR(engine->zclk);
 			goto err_cleanup;
+		}
 
 		engine->regs = cesa->regs + CESA_ENGINE_OFF(i);
 
@@ -571,8 +567,6 @@ static int mv_cesa_probe(struct platform_device *pdev)
 
 err_cleanup:
 	for (i = 0; i < caps->nengines; i++) {
-		clk_disable_unprepare(cesa->engines[i].zclk);
-		clk_disable_unprepare(cesa->engines[i].clk);
 		mv_cesa_put_sram(pdev, i);
 		if (cesa->engines[i].irq > 0)
 			irq_set_affinity_hint(cesa->engines[i].irq, NULL);
@@ -589,8 +583,6 @@ static void mv_cesa_remove(struct platform_device *pdev)
 	mv_cesa_remove_algs(cesa);
 
 	for (i = 0; i < cesa->caps->nengines; i++) {
-		clk_disable_unprepare(cesa->engines[i].zclk);
-		clk_disable_unprepare(cesa->engines[i].clk);
 		mv_cesa_put_sram(pdev, i);
 		irq_set_affinity_hint(cesa->engines[i].irq, NULL);
 	}
-- 
2.46.2


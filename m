Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF110364935
	for <linux-crypto@vger.kernel.org>; Sun, 28 Jun 2026 23:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782688804; cv=none; b=saW8xoEZGGvyXE8jr2WMCPQOTQE4wtivgSDwaI4+rdLrd1k1hCSYKsqX8NOYu+pk7VQYkRr6ZVw63jt9LEkQ6yYgBNpI8ruLbzNpxrJdhGIlQIlqciB79DfknyaYFTkbO8dRxpT75kiHCtFHtJFsXKofc8bNN7ajCROmxw9zDVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782688804; c=relaxed/simple;
	bh=TFh52Z3aYd0ikbblTiHAbY7mMw+49K+zzSQUsYqlNE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XsTrk6k50fszmSKfCR4b+J3orNbZZFJ2syG0ZU/pYLkpY8jEHfDVO1VRS0VskyCaJtUtP29FiBzCsYP/5xY8xtXz2F/WEqvDUrRbbILSGecTFMteHQeRhKvTXsDrpupC9Nry/8kzZAR4v0vVkJYu+3LVX9B4iEiW7ZhCe76DhG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ci9efz4M; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ci9efz4M"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c85d4b4245aso1611279a12.1
        for <linux-crypto@vger.kernel.org>; Sun, 28 Jun 2026 16:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782688802; x=1783293602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UcVzp6hS2wbilTH9sWD8SVsexr892ADQOI78SGhqqdA=;
        b=Ci9efz4Mx4ek8ZBf1TIptrow7Xmyv2tRtuPLA4mxH4kq0JTnANeAYHfJn44exquuAs
         oG0T2EUp1vWnAJ+mWL2JHeg+DWe5KEHtrJPhhosAbGxlYLgnV1p6C3ih6UEwyQv5jukh
         Wi9IM6xSFqP3q311zHLDcKGt6XyMpEnch7o210FH4x5wOwvg9lqQ7qqqxR7EiJJgcGuj
         bTUCnpAsz++QfqxZauh8AUdxPJdpoCc7jHoDGeLpb4cAIXOMTGTBUgmodzuwhKDrLnwp
         wyzW/N+9d5Ypuda6BMNvJbjeL0X0pB6l8j1O6DXrSCmLAF6KLbqU9jciHNi8ysy7V+jf
         8H7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782688802; x=1783293602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UcVzp6hS2wbilTH9sWD8SVsexr892ADQOI78SGhqqdA=;
        b=RXWrvZzgbVVqbUfTpCwaHiLfAKFMMH+FI1GbBk21QBSI2ohaUY4hTmFBXa7kIld1qH
         2CnmbjEjefmc4u/vqySPfFhOKdVR56JYW/e5hgVE2FpRfO88bFocyTgXisUiNdmHnz9S
         d3oJ4DAyQ/GowTeZTqIIZEx0EqKvy2vvQO3yHBRo7/zorqb4YMzL4PhwsWhmJGGyIL6Y
         EXH1oEZLRkAtI7yTzGZCh+s97FFhg3Pjcdmg5runuZ+51q+pKSan3CQ2WrfreJFCXDP2
         AaeCxLbY+e2D50OWM9+OqJg2XnjEwk7eRNdEoRWZ3xZC4F+vSl98vQ4PpUFZCgxbqGhM
         XKWw==
X-Gm-Message-State: AOJu0YynECWAnzlzZAMuMYPW7z1NPYg36+OS1nMmZHKP/Bi5IkgxHSaW
	JbPKp3OkyPW6lu/c3Rfy74zuh2naoE9x6KYn4RFdRlott6filOuYen0tl8nS5g==
X-Gm-Gg: AfdE7cl7+rIgxWlPtXQbwCYXl0t9oRv66dbXJb9bmBQneNuL4JaWMXfC75Cr0Rkw16O
	FrUiYzONjWx+DEhBRrGoV4pzaVhUQu1T2VwdldjDFq6rJSGK9WjFOLmabBcorKnqIJeoBfewR04
	YtYUtuq8bgI3ARsM/Kwylwjnp4g96QoTBMTBTCMmmzv4LR6wRVpjVUhrghD8etTEssa+nPLj67J
	V88K4Ab1cZO+TuxZgOCfGPH1K2qne1Fc47OsEIoC98PhcD2kM5B9d0RaYm0YWcFZjGFgy5RGKi2
	xLe9XB5P/n2x3XIRN6R4W4CphJzOkdecndzP5i75YoH72uNCkFAVeNF+XkYAfinfHR55x4yRMni
	q/vVv38oirjL+YLm9Q2HRZJthBeimdUYaGgDs10R2g3UUTJ+zqyvUwHiduh5x//c0JwtGHzMZSf
	u+9KP8SL2m18WtOJZ3EOrGBNBQrzqj1wAfNf1FfEY5rM9vfWsHWV3n3euu84CyO96/4J0ZgXuZ2
	1Liix8WcQ==
X-Received: by 2002:a05:6a21:3a45:b0:3bf:a26e:3dbc with SMTP id adf61e73a8af0-3bfa26e4986mr859526637.19.1782688802070;
        Sun, 28 Jun 2026 16:20:02 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c92bcc91f6dsm6643007a12.27.2026.06.28.16.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 16:20:01 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: cesa: add missing free_irq() calls
Date: Sun, 28 Jun 2026 16:20:00 -0700
Message-ID: <20260628232000.1287439-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the missing free_irq() calls, along with irq_set_affinity_hint(NULL)
to clear the affinity hint set during probe.

Fixes: 5bbf25419f8e ("crypto: marvell/cesa - use request_threaded_irq instead of devm variant")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 75d8ba23d9a2..57c9295be711 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -511,7 +511,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		writel(engine->sram_dma & CESA_SA_SRAM_MSK,
 		       engine->regs + CESA_SA_DESC_P0);
 
-		ret = devm_request_threaded_irq(dev, irq, NULL, mv_cesa_int,
+		ret = request_threaded_irq(irq, NULL, mv_cesa_int,
 						IRQF_ONESHOT,
 						dev_name(&pdev->dev),
 						engine);
@@ -540,6 +540,10 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	return 0;
 
 err_cleanup:
+	while (i--) {
+		irq_set_affinity_hint(cesa->engines[i].irq, NULL);
+		free_irq(cesa->engines[i].irq, &cesa->engines[i]);
+	}
 	for (i = 0; i < caps->nengines; i++)
 		mv_cesa_put_sram(pdev, i);
 
@@ -553,8 +557,13 @@ static void mv_cesa_remove(struct platform_device *pdev)
 
 	mv_cesa_remove_algs(cesa);
 
-	for (i = 0; i < cesa->caps->nengines; i++)
+	for (i = 0; i < cesa->caps->nengines; i++) {
+		struct mv_cesa_engine *engine = &cesa->engines[i];
+
+		irq_set_affinity_hint(engine->irq, NULL);
+		free_irq(engine->irq, engine);
 		mv_cesa_put_sram(pdev, i);
+	}
 }
 
 static const struct platform_device_id mv_cesa_plat_id_table[] = {
-- 
2.54.0


Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37C8197A7E;
	Sun, 20 Oct 2024 19:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729452353; cv=none; b=Pz4G48dtYJ3KJW7J7+PDuxJL6ITpvoFeSzu3IFGKpe200Vd0Lx5V8nnFQfOenriaWT54Ag08keRG8/gsemsr2PnUoYnyRyR7KCNEkeR7uihVmdWVkSuHZOWp2BbKVNm62mbRkz4ZxJhQG58iox7TLXYFRgSNjk6H3Z4A4sX8F/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729452353; c=relaxed/simple;
	bh=RNcNm73YFxI2mw85298aHNysRxtbk1/YS15Ot0qclE0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cfPvZF9egsRQLFUY/wQSYXoxO2VEZLAe6xBoz4/9k83Z6JkR54a6LA51L0S3WmiVjj8AlA6wxr9J+7EoE7064vDB2Ssw05W+HwNfdZ1osyrTB11KlGxgl8jmCkh+skH+h27vJ/S+gBehsQOALBiCJEP1ld0vizpy3qMeRi9gTrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O2OqfKit; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O2OqfKit"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9932aa108cso561443466b.2;
        Sun, 20 Oct 2024 12:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729452350; x=1730057150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcOx4WxMY2WBK7Mc2su49jW4Eb6fS7Tdmt1bvzgDxKY=;
        b=O2OqfKit9y8URK5lrFf6m0tJUkQzZeFEqVxN42OdScF49IcbVb1UtDctMJ6mBzCqY2
         HT3WM7hfpaVA1QWWF6S8FEzPw7n9Tkfl1GkhOBwYZhLjik4NG9Cy/z60GveBQgvMwGCi
         AHR0iJGdPQaKrW1he/lgFQwAA4rCnuxXyv7mJ0AQfyxt6OLX+6SsZQESJckI9YuZ35h5
         x+H/RsrKQ4fmoy32w3zfvD0/ghAPDkPK6eeL/xDjKHZjw0bLHZEToySS2a8bLlmfaEb0
         xj3n75ymeh3tMpD/bS/w6RjbyDPs26R8fiOrV2PH9I9DUe1Xm1P0x6xQOnLYDy98EOvC
         rOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729452350; x=1730057150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YcOx4WxMY2WBK7Mc2su49jW4Eb6fS7Tdmt1bvzgDxKY=;
        b=qOnZp/XBxTluBXDqEgpCE2Jfl84lDHvnd/F5P08yEhh0wnvFi90WUV+DNhuPMTLgYv
         bObKvT86I1bvHQqZx2TvIf1lfE1VB4J/9o2hFErJJXc9/eyN8MuZp1iPzwTNkvRtOVj9
         aQ4mHCph55MmWcXWH7ykx+8tk+SDZ5/iPV+yE2toYEmCsg8eFzA3QL7KbzeoK43phGXC
         PLdcrlcQ6vvubM/8G7+MmfK+sUNcVYtu103ZTT5odRPClNfvYbql1kfdVCfO9PUxW1u4
         rG9b7QKcOqYLv3s/QvuphjUf8NBWM4QcQOkX1azKIF7NFF2MGE52OlzFjnlU0UxAdsTx
         m3xg==
X-Gm-Message-State: AOJu0YynCrUMTyBJmD+9D2dDnL9M/bAweT1enxwP07Yo2JZG4lm+hRmu
	HKatwei2PiEY/z9tdOX+Yv4jjHRYBVe2oo4Z5WvLRMx6JbN/PyptWfPE5kWZ
X-Google-Smtp-Source: AGHT+IHrIRR6662jiz1/MLPzgiL+O4H6cl5EH6smfC4/p9n/WH+PL9pdmKqtpO/eMa/r5fUsaam32A==
X-Received: by 2002:a17:906:478b:b0:a9a:3705:9ad9 with SMTP id a640c23a62f3a-a9a69c98d93mr917151366b.50.1729452349656;
        Sun, 20 Oct 2024 12:25:49 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c501:f600:f753:f6c2:4f3a:5d50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a915599dasm117957366b.118.2024.10.20.12.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2024 12:25:49 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>
Subject: [PATCH 2/2] crypto: starfive - remove unneeded crypto_engine_stop() call
Date: Sun, 20 Oct 2024 22:25:32 +0300
Message-Id: <20241020192532.4008-2-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241020192532.4008-1-ovidiu.panait.oss@gmail.com>
References: <20241020192532.4008-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The explicit crypto_engine_stop() call is not needed, as it is already
called internally by crypto_engine_exit().

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
Cc: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: William Qiu <william.qiu@starfivetech.com>

 drivers/crypto/starfive/jh7110-cryp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index e4dfed7ee0b0..56bb027210f3 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -151,7 +151,7 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 
 	ret = starfive_aes_register_algs();
 	if (ret)
-		goto err_algs_aes;
+		goto err_engine_start;
 
 	ret = starfive_hash_register_algs();
 	if (ret)
@@ -167,8 +167,6 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 	starfive_hash_unregister_algs();
 err_algs_hash:
 	starfive_aes_unregister_algs();
-err_algs_aes:
-	crypto_engine_stop(cryp->engine);
 err_engine_start:
 	crypto_engine_exit(cryp->engine);
 err_engine:
@@ -193,7 +191,6 @@ static void starfive_cryp_remove(struct platform_device *pdev)
 	starfive_hash_unregister_algs();
 	starfive_rsa_unregister_algs();
 
-	crypto_engine_stop(cryp->engine);
 	crypto_engine_exit(cryp->engine);
 
 	starfive_dma_cleanup(cryp);
-- 
2.39.5


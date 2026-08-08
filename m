Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28A82853F3
	for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2026 07:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786174687; cv=none; b=HbxcxMtW6yQApNxfWsQ9+RFmFhbl0Z1qMJbWJBmMjZA8dz/V31Z34M//n/wjkqRNwT6sXTZCGWPvg9taeOBkfjhUcZPjhaXz19HdMmSgR6O9svQaexNtctuUILIvTIk6Ic4d4qAfogrXoxJIGMHT5PFlL1GEAyoksen/EO/KBYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786174687; c=relaxed/simple;
	bh=a18SA0kQmpnDruLfcZasBwPsx02z9yaF3DFh6MG3i8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cuv/qtBhb7WuAu4H7QnpASIHxGfYwNCjEXTSaawE1QSjIoVoVjbbL2Xdk08r4z/r1rqN1yA8jeLHBdp+zI87ktpUSQjulI6AsLeL5oQNTBSnor35wvh3QPxJYbWg7ki61020rEypAt+yHjoprTT4V4EkdYwtbZ2oY8w9KRvCmNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDcQKnUN; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDcQKnUN"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ca957432c7fso257843a12.1
        for <linux-crypto@vger.kernel.org>; Sat, 08 Aug 2026 00:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786174685; x=1786779485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QZ3y0avheyoaouXFIVz5Hu8HDtYYb6j86ujlX80DrU4=;
        b=lDcQKnUN530XaW+ieNATqN9EGjJXnDU6tQD8q70fDH9nyU8pAUHFGmHsTBrTPcTNho
         WYYlsBN34SnFHtuOrKqRySHK6jwNQzL3RrBwi7FarSgDQElFC13QnbIR2GsTlR6yGyrf
         8VwOgQoqIQVjVzQnUVAJQHLS1/GY6tU4HAtR/YUotzhYreRpF/bVJco19McXG9KQPLWE
         0ujwXuONAcuK25/tI+ROH/jVzgZsuLDHA/wdKZhWb6JL+7yX57mqjQ6F6VDCogdUKMMx
         4axFQwaamzfYaKmpF0si4nIQEJnAPJbXfyPCrAy3Yc5O/AkaqelJYtzf01fjXT2Y8kuh
         /5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786174685; x=1786779485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QZ3y0avheyoaouXFIVz5Hu8HDtYYb6j86ujlX80DrU4=;
        b=QK9s+RPAFrt9sdVzLT8wHntGL6OZgUq9STlf9hVehqnibQzqVM2Pvzhn1eLkGJ9PNt
         DyrBZLixUkhsPYl0K3bPAro5wqqq79xpHdfOkyLHK2CFIexRfDL7mjseJP0XpY2MSX2+
         PSYyVXiKbcpzeST5lGEwa+EJwStfQ29itli3AaURWFUAbxWV7YLUYIDH9mxLgqVJFRgb
         YpCYKyLXn9fpQGI1PHuyA2liok1AlL3+wXSe4JHR+Z35TKHDTouh7QEgZDlmcruUfoxx
         bw1J2h3w9coKAHrJ3zCCmtY30PKNXEJMtcx+HjMuQ0yn8AXnVNBX0q7xjH3zeP91YmNK
         XcyQ==
X-Forwarded-Encrypted: i=1; AHgh+RoPpTZoOA5zj0vLldpVs23r5dAiAg+W4vMwqTSpPGXbiT5liMuKF4EfqP/naJrgYS/QIpfLqCt9Cq+VJzY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF2wnQNGYETq+zGfU8X6pkdy1zopobvqL6UdK1Ia9wMaTpWQ6T
	GiUqibESyCYw4InHMMvXGsrP4z7kt81POQ8oLJlh0GLtdnb+sKuj50yCuMIBDibaP7s=
X-Gm-Gg: AR+sD12b3v3urT1z7GYPB2I+gM+k9WqgnZPjSJ81r8QaTO19Gj8yFVCE0s/hsie5JfH
	giJwce15aXihmnMsSAjzSBal1/qUm2luzv51kqVCF8RCNuJlP8zOpyJ7UOcIkzCtSqjJ1xj8f+c
	Lu8Q207uGypOvtTAwRZx51IDmRJ5sYX3ZA1T6xGBYVTvVwBAKOSzoghpM1PtL5VxV7R2V53Yxh5
	38nqBgtYi9GHeTYOB2uN28zStcAtbPcuAsyDygdgaqKwSDFXrFwgiyLgaHFOKmR3yLENXwzRuD0
	3nxZHv2TgNFS6hZEgWKNjD93Rb9kasSDDEzR9RtRrgyahmL8TIuq0X6drX7a5okTyMZdIBYm0m3
	sXqUeKJRRCkZBRKm29oEJZ7TjXtikqS9CNueqxct80iJ8oULeWuLAPG6Hr/MS9di/HPEyNQIWpD
	eTXw2hD2svVFxWEML/aOM/bZyVF7Qm+MUzIClgB0DIKjfBEyfIOjur2dcamA==
X-Received: by 2002:a05:6a00:1ca2:b0:847:8ccc:d7c6 with SMTP id d2e1a72fcca58-84f2e0278d5mr31776713b3a.31.1786174685244;
        Sat, 08 Aug 2026 00:38:05 -0700 (PDT)
Received: from lgs.. ([101.76.249.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f5a58dce5sm1891208b3a.58.2026.08.08.00.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 00:38:04 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Andrew Jeffery <andrew@codeconstruct.com.au>,
	Avi Fishman <avifishman70@gmail.com>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Tali Perry <tali.perry1@gmail.com>,
	Patrick Venture <venture@google.com>,
	Nancy Yuen <yuenn@google.com>,
	Benjamin Fair <benjaminfair@google.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Thompson <danielt@kernel.org>,
	openbmc@lists.ozlabs.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] hwrng: npcm: fix usage_count leak when autosuspend_delay is negative
Date: Sat,  8 Aug 2026 15:37:48 +0800
Message-ID: <20260808073748.2649808-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

npcm_rng_probe() calls pm_runtime_use_autosuspend(), but neither the
probe failure path nor npcm_rng_remove() calls the matching
pm_runtime_dont_use_autosuspend() before disabling runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() calls to both the
probe failure and remove paths before disabling runtime PM.

This issue was found by manual code inspection.

Fixes: c98429297d8b ("hwrng: npcm - add NPCM RNG driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/char/hw_random/npcm-rng.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/hw_random/npcm-rng.c b/drivers/char/hw_random/npcm-rng.c
index 40d6e29dea03..43f96abee753 100644
--- a/drivers/char/hw_random/npcm-rng.c
+++ b/drivers/char/hw_random/npcm-rng.c
@@ -118,6 +118,7 @@ static int npcm_rng_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register rng device: %d\n",
 			ret);
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_set_suspended(&pdev->dev);
 		return ret;
@@ -131,6 +132,7 @@ static void npcm_rng_remove(struct platform_device *pdev)
 	struct npcm_rng *priv = platform_get_drvdata(pdev);
 
 	devm_hwrng_unregister(&pdev->dev, &priv->rng);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 }
-- 
2.43.0


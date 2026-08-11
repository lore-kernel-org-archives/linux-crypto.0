Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE573F484B
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 06:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430100; cv=none; b=EBq3KbvoZITfcmUM8cTAHdjD7Ys4HsbZP/PcDemaszpYLdR4MVcfZs9CZtPeVgS5WnytQsnQkZ4+UnJapkPxyIbxgZPPCtjLnacy9DCg3GOzd6TQRu5EtYWujIQGk3+j62+M0FPxfXwO7WytRgyk43IgahLSkfja9goEPDvLsOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430100; c=relaxed/simple;
	bh=/IPDx1Pz5QgHGpnA1FZ7e9RvOdTXuUppSFRWbC86Gk0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f2oFRRg7J/fx30e5+pctMyWEX46Ja+Fwb/1IdQtXt0SXDeTYdS0jmPIrrFMWyyuY6drc47r1HJlBooFeqTzCrynQRto5hdnt1TRhwVE6mihqjlgOyaKmc0uTF7/l/ahPkf5rTmoDQQ6frSTgFYZrQ0VErUP/D8SmEvR7+qXdNoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hZnsqbAf; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hZnsqbAf"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso6227845ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 23:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786430098; x=1787034898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rs1yPzUnIco2rjC6CFhLVWVyr0WMS18/eTcbCTT31s8=;
        b=hZnsqbAfdlKEFqEWO34CFnk2uOv752mXcLPq/0L63f9zp2Gsh+dN6pRQrORlTzWSZh
         IsB4INsw3R7wTz/YW7dtZf84YUPTGCBnaWczlxxFk0elDQhAyoqPBK5LURIGXuLdlGUN
         7FbvUBSmzN7FRYR1m4wdP1GFqWffJkrazGO6CvBJEnpDY/BmjAnpa1vebRop2W2RBdnP
         BIs8gi5yuIBCBS1NFqFEVvtx4pQag1VeRGjZnP5mcswEDge6OHu1wR/VIKyi88q3Yr7j
         3MDnuO7rYFeacg2TSo7A2VLuKt06rV5eqJZRuiKARRf/PXafCg5bjy6SC9sFUoZEab2D
         dCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786430098; x=1787034898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rs1yPzUnIco2rjC6CFhLVWVyr0WMS18/eTcbCTT31s8=;
        b=H270ZzLxhAefMqa0tdUZo9S4QtlFz7zoplzClpuKArjejljGc43OADmamSEs4+2DK1
         ywuL5V80NeSTnLUtcpauzD7JfMXIwfQfsDkalgp9XxBcsZ3568te1uY0heYa0dF5wEgQ
         QtatEiOMCEpM7Soi1kaYSqX0UvMlIvM2ZlaJJql1UFdlJJUHSW5sv2AFeGDLsKIeDzCU
         vZB5VQJbcOcMqX9Pt9K9PQvbRa+hwLH8p56p0c4bvOWMzCghiQ5goaMtCmIu3m0FmJR/
         +78f7WfdtiKgFsZau6m15EMCFx9v2bSQWA7X1QBXKIhjrv9wV4t3qXjBSVSYQhjSUowA
         SiCA==
X-Forwarded-Encrypted: i=1; AHgh+RqoGYqH5I3/HJyjkmgrBXqo+5R4ptB4od14HpBuNLydZKGiNFdgV+9r6u5JoaL9KFf05QJE6VC3aJ96BVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTmCk+froxreIwgN8+5Y8oIupX2Y2+OQEFEchRQVt/j9SRBLpV
	M58RHAmaqXUsvr+UIWlxy7wmLWn54RCsSI0nRP07jMK9/idvb3cTH21E
X-Gm-Gg: AR+sD12ljf8JAyDJWNCExdJ1eKS78P0VwM4caiwdhRL3Ye+4DW/et4/r5t7pcXb6jsk
	DTotg4GZgkW4Fa76o/mN24ytp35wgDJVWncyd29QNldxxGu/+2XL547RtLjEPTqSa8E7z9xk/bh
	7ouJWATv9XcsLPOTGezz+m+KKQBcFft2Xw39F+r5K4NxZgneGYHYxp5XY/AmSeUaMQQm6lD3+Qb
	j5ilgK1Dnn2zots8S43urzgvUPGJAqml4PY+Gwt7/76e4xwpzz9iYO7NdAgLa7oCUaCFIahQ53C
	ovLHoSH3JvMJ0azV4yCh1x4RWoG8rui37kXtYHBNreV2zuPuRaFoItmxX6o7SgQ93A0c86bMhQm
	x+kwpWqRpMX/mCo3AfCuark8ZICC8mk4XRSAqXoRPRVzZUq/t0F5jgnF3q2HFs4T3Z8Hv2UtjYD
	hgaBJuaOIlHbPOvk24+2lf7FT1VHrRNnqkAndyJRWI52cUru/16B8=
X-Received: by 2002:a17:902:da87:b0:2c6:a772:7e43 with SMTP id d9443c01a7336-2d31798510cmr11974795ad.18.1786430097998;
        Mon, 10 Aug 2026 23:34:57 -0700 (PDT)
Received: from lgs.. ([101.36.106.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d315ef11e8sm2383365ad.1.2026.08.10.23.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 23:34:57 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Daniel Thompson <danielt@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2] hwrng: stm32: fix usage_count leak when autosuspend_delay is negative
Date: Tue, 11 Aug 2026 14:34:42 +0800
Message-ID: <20260811063442.3058074-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

stm32_rng_probe() calls pm_runtime_use_autosuspend(), but runtime PM is
enabled with pm_runtime_enable() and the matching
pm_runtime_dont_use_autosuspend() is not called on driver teardown.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

Use devm_pm_runtime_enable() so that pm_runtime_dont_use_autosuspend()
and pm_runtime_disable() are automatically called on probe failure and
driver teardown. With runtime PM cleanup handled by devres,
stm32_rng_remove() is no longer needed.

This issue was found by manual code inspection.

Fixes: c6a97c42e399 ("hwrng: stm32 - add support for STM32 HW RNG")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v2:
  - Replace pm_runtime_enable() with devm_pm_runtime_enable() to handle
    runtime PM cleanup through devres.
  - Remove stm32_rng_remove() and the manual cleanup on the probe failure
    path.

 drivers/char/hw_random/stm32-rng.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 9a8c00586ab0..f5bfe54c01dc 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -368,11 +368,6 @@ static int stm32_rng_init(struct hwrng *rng)
 	return 0;
 }
 
-static void stm32_rng_remove(struct platform_device *ofdev)
-{
-	pm_runtime_disable(&ofdev->dev);
-}
-
 static int __maybe_unused stm32_rng_runtime_suspend(struct device *dev)
 {
 	struct stm32_rng_private *priv = dev_get_drvdata(dev);
@@ -590,7 +585,9 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 
 	pm_runtime_set_autosuspend_delay(dev, 100);
 	pm_runtime_use_autosuspend(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	return devm_hwrng_register(dev, &priv->rng);
 }
@@ -602,7 +599,6 @@ static struct platform_driver stm32_rng_driver = {
 		.of_match_table = stm32_rng_match,
 	},
 	.probe = stm32_rng_probe,
-	.remove = stm32_rng_remove,
 };
 
 module_platform_driver(stm32_rng_driver);
-- 
2.43.0


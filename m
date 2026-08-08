Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A172C4B04B7
	for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2026 07:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786175213; cv=none; b=MTmY0AjV+yeuJlY9nu9sWS5FM2H1pmCdRANZkV2dlNKgHub14ga+Oo6qMz4JcsMRgbo5zbFzr0yN6vvcBC3SQgT+69/6H6wLmv2FXdTzgdhdDW6KVCd4rlDInbfD0f4g+o9OvVlvr9dRBU6sEXCloQMXosXdq30dDuNQTi0qHWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786175213; c=relaxed/simple;
	bh=96QeQH404kv11psTBdIwIsvuB/DrYdWj1xbBgm0+lFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D6HBm6G4CPLhF2ABMLdmpFPVRx/I61jidyLcaSiTw5xXnLl7c0FZP9wy7WYI9LAMgZEIW07VkL0O5V33hJeQkF9Yu5TzmfZNNzYxH+wMsyXp7pDpZO2rt1guQEmn0Cnr0JH/lEqgfjpbqDWAM+jUVAI8dEmoKCb3SmO6aY8FFgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qf9fXShW; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qf9fXShW"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38deea72eebso262064a91.1
        for <linux-crypto@vger.kernel.org>; Sat, 08 Aug 2026 00:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786175211; x=1786780011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9y4KPReC2ZyGezILlDFx1J9Ati94r3HeNKJB0BgmAUQ=;
        b=qf9fXShWiigPkYBXYy5M6V6sXeN7anCf7YcsupKeAgm3gNWkqr4WCR8PA4YhPqYaK0
         TYA0chvNplVKfQ7j0JmcEGL6fcs7HHXw1oarfigCtn8dgKm9WFAKRx7+0y2KWk/mBQPf
         CZbFPoy5w/xZ/Kju/vw4aUzAbc7uod3Ewjke/2LsBjNHfPJr3WhbgO/wGufq4R6/W8Pq
         Tx0yF3lcrQUC5iR2Q9AUjQ/0Ga5mQXzjNJ45ilto3r8sKOYQWmWLJBAJNyaSVD7G+i8X
         UOyRT/7pqY++xOpYWxI9e1V/ymV2TIDceQO2dYo9F95nmPpeXxENrNfP3GoE1q6aqJJf
         uWVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786175211; x=1786780011;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9y4KPReC2ZyGezILlDFx1J9Ati94r3HeNKJB0BgmAUQ=;
        b=Xx/ar8QxLcpcX3Xt/PXBPZBlxUkfphruHWeLL6vdnezp60wZYm8Y6IGO2dkeVO2KNQ
         gv1BD5VRri7GSDHRQ6ES6XigKlQkOAN2FvlYjzn0ZI1/u3DUOIu0xXXq1QhhVxhO5RjM
         F6WO+xbcIVo3rdJreIRDd3jk+zusJAZxpLZDA2kgpSOux/FuDnjIIAAMmaMg/71ahSmG
         AO2dXWHeVg1Amt4o9ZR+lxD1sL4E3VkT8SWSO7euTjxfxTAtV0VObHrIXRqanD3fqjWq
         A95Nh2TUD1VF9p2DCTWcJJ+MdSRhNoWhHbfvEOsTWcrPqkcJpaPU9is0ycI/K6WoJoz3
         Qb7g==
X-Forwarded-Encrypted: i=1; AHgh+Roloc0zpbwVXBRdSG4Am0RDOXODHU7O9NdPl2mLNWroV4OL8WqvmJRVz+aP77Ak0W2bc6vlad4tOriXozk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp5Sjdzam5SGzM/4PQEnhBAmvxwygaZlmgiqOHIxFX5Ty6D2p1
	a1ANgNFx/XCCdblU6oTTroktprL1+dNw+dmDoMERQP1/g7E3+Bs1gPU1
X-Gm-Gg: AR+sD11eMBmxgLz/vNfbJCn0STzE+HtsfIACIbRit8fRlgHF+HGClJhJAbpx89xZUWS
	pMSpIhc4iUfH0IrFmQO0WgAKs8qc0AUrBTgYTQWs0c6N5lICLyFs8LRFV3wWjTTiZYzs2aVvE0T
	WVv7gR0oWaULrZ2LzjPJfFqX5mMUQGXQ7vD+rUiTJ5gD8pkTXAZaobrur8LrY5b586WyIOKVU0s
	QzDpCr/HZhwDV+8nhrA7n91BoUg8ghMf6xRwxw2IZSh4Kkip6YZ/3Ep0pLghW8OsbstbhBI+POr
	POI2t5IwBqAqtLXggWbiAKhS8zJBu0vwAlfpYGlhjwkRxLUBABBaDTmPX10AuuLRZbtqa/gyHJG
	G5Kmf1/HkoYnHBhOuNT+qGK1ZyNJ6OFjParXaXN6EpGhgl2kovcbEyxd3K/yq4INhXr+5CshVON
	pqv+ic4LbwrtWDu0UFUThydHNgH8a6eat48e72E43qsWqxd73ecpysFupgtQ==
X-Received: by 2002:a17:90b:2249:b0:36b:bec8:94c5 with SMTP id 98e67ed59e1d1-3928242ffc4mr4644954a91.10.1786175211057;
        Sat, 08 Aug 2026 00:46:51 -0700 (PDT)
Received: from lgs.. ([101.76.249.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3925fd95794sm5282123a91.7.2026.08.08.00.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 00:46:50 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Daniel Thompson <danielt@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] hwrng: stm32: fix usage_count leak when autosuspend_delay is negative
Date: Sat,  8 Aug 2026 15:45:10 +0800
Message-ID: <20260808074510.2655473-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

stm32_rng_probe() calls pm_runtime_use_autosuspend(), but neither the
probe failure path nor stm32_rng_remove() calls the matching
pm_runtime_dont_use_autosuspend() before disabling runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() calls to both the
probe failure and remove paths before disabling runtime PM.

This issue was found by manual code inspection.

Fixes: c6a97c42e399 ("hwrng: stm32 - add support for STM32 HW RNG")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/char/hw_random/stm32-rng.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 9a8c00586ab0..6de4c52bd4d6 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -370,6 +370,7 @@ static int stm32_rng_init(struct hwrng *rng)
 
 static void stm32_rng_remove(struct platform_device *ofdev)
 {
+	pm_runtime_dont_use_autosuspend(&ofdev->dev);
 	pm_runtime_disable(&ofdev->dev);
 }
 
@@ -592,7 +593,14 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_enable(dev);
 
-	return devm_hwrng_register(dev, &priv->rng);
+	ret = devm_hwrng_register(dev, &priv->rng);
+	if (ret) {
+		pm_runtime_dont_use_autosuspend(dev);
+		pm_runtime_disable(dev);
+		return ret;
+	}
+
+	return 0;
 }
 
 static struct platform_driver stm32_rng_driver = {
-- 
2.43.0


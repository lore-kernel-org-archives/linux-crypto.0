Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0F532D7C7
	for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 18:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786561071; cv=none; b=UgfvvVwHV5v2utY6XGDd8/c6p8C46GysmIsMQGOgm3T2A2BP3JtRHRYA9ztTHvp9fkRTD9G0l8mPSyms7vdYlbHMvBi63kzOnT1eAH8JHRkeAI36yCHhplCaiN4M6YaJfBItIzt1cj6UqLr9W5PBk27z9PPIFwXXx+xmHCpLS5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786561071; c=relaxed/simple;
	bh=zSlSaYUbU1ffsUmFeCx108UKK0wEENYkJjaU17IPQcs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KpRQN6XN+vy5k8MMREKURATERTPtQT0Zo65RdO8fmupVtSjWVhwP+jk6AHAZE/i6cQ+tRqmPyV3aV5cWthP5exJkEqJ1OXTCglew5o8m1cTabNEpgaCGiWNbfQUkt5OtkPuS1PvATEpyIBRX8lHN+3Q053Bo4B/U3Mvk9xkZzcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcspvx+Q; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcspvx+Q"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8485bd28dd0so1537909b3a.2
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 11:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786561069; x=1787165869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SbuKYxlpXdTIHYEQZH0kyOsSn8MfjOwovOK6ivNRmwQ=;
        b=bcspvx+QsBXmTjILRxkw7UpWZb6EcrJbqn0zKvVj3eEo4evkU4kFIRqK7+4o2Lrbio
         ji4oVRiuWf4ozfENqWgGBMOc+c+LI6HUg1TaOAzvP2aLlJj3vdbkPPaAk6LtTQEFOKWl
         T/2XR3Iib7nZcpHDrrh0xwRMEzZT/0r8FJecL+eaHE5NLn62AnzwT8D8/GogJ+IoLUpB
         CMTAJmzK/C4h1c7SFynUtl/Wbb9hE1cmztxGK+sw0O7PmaiITtMa+4knfrFWfLhvN3Hw
         kYCgrBr+EedtugsRkYLir21dH9vjrX6f0eXnBcnMe9vaWYdOnCidLh/3u7Txv/WUp7yD
         3I8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786561069; x=1787165869;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SbuKYxlpXdTIHYEQZH0kyOsSn8MfjOwovOK6ivNRmwQ=;
        b=eKnD5ftkcBB7d+R479IaqP7+BaS5fQbhb38oJbaYi8zZC8R2PwwmQb3q0GhZTxV19g
         S8cEhF2JHR8HUrtufxaZ5sQlvg9TIXI0V6lzwmyNWFxdIT7Wvi1OQMXlSbAHPYJ+kjmE
         ti7QdM4bShGaqrs4sqikGfDJO/l/muiMaOkaxdwp+LbsUb19CAWr6RCgWj+tApPAU/Zf
         DGoUlZvoCv1L69g9FcVxH1RmqbuzwB1znt14l6bf2K/eZbKMK/7+3d2MKYo5CcqOhVBU
         krooZCK5Ztsn4bBfPiyR1MpBf8DnQxUR+rUMzbukCX9ahBhVn/Ag0Ex/LrYBzoAEERes
         lTbw==
X-Gm-Message-State: AOJu0Ywb6sZxJn+w/OXPdeRKfjVBfuNTvWB9ZZ6dd2Hv2Muxuj5Yaa9/
	MDwVKhco4IThe91Ly3B+RFzp1xXY0Se9dprpAqdT8VJxOjaYXYHMve7sDccWdydm
X-Gm-Gg: AR+sD101imsL8uRjypElgCug2aoMllG7s0tG3CghcXKG6EIsdN+T8o0HiToJizSQLBi
	kixaMjIKxZhT9bDG+t/MT/CTJc7rl6vsdr4pMtwjDgA5Y4qwz3j/N2fD9DG/qFpU8OpxRJiT3Em
	pehRmvqxgGQJmebImuhII2JTehC71OWhXGCQa9HUzHL1HTcsmCmLaIz1qSy0BW/ESrTYzRVzlFY
	iirQvsjQrBuzL6bgwCzLCD0OUpXp2S5WTjGkb42nPo+TR5mt4k3ywerDvNWxShYwaCrKksM9Qvc
	HCI2AkEL+xcqW9blA/vYaJWGwwc9sz+4p4pduyHbQxUmijcS5I1Is30KRNs0qFQgX4XlbMfQF9c
	d7ObO8yeXsvAYZ3/eBWZ1ZOm7vh1gFL51SR6xklABv/bGnCCG+nMpBbTAi8ZxYMo5Qeu4b5K4oV
	h3WHnrK/9dHMQv8apkYIljhO49J/ZsA1jJWFFhrF+zP1kNT7AJVK0/DbWNWsLkGm0tvcZRn0Dpi
	n4uMW3CWFHWVL4emBGI58Bu49dtac/7yDmrZaW00JlC5Js5Qm1VIVg0HJ0Et8oj0zDPSRxAu0st
	RlqniLCvXXreTRJNWAKrvK/WUbX0hUbVELYpHQ==
X-Received: by 2002:a05:6a21:60c4:b0:3bf:b8d8:8296 with SMTP id adf61e73a8af0-3cc55488526mr571271637.26.1786561069171;
        Wed, 12 Aug 2026 11:57:49 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbef722b616sm85689a12.28.2026.08.12.11.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 11:57:48 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: amcc: trng: use devm_of_iomap()
Date: Wed, 12 Aug 2026 11:57:47 -0700
Message-ID: <20260812185747.79173-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert of_iomap() to devm_of_iomap() so that the TRNG register
mapping is automatically unmapped on driver detach, eliminating
the need for manual iounmap() calls in the error and remove paths.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_trng.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/crypto4xx_trng.c
index cfd66b779ce1..4dd699c41c8a 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.c
+++ b/drivers/crypto/amcc/crypto4xx_trng.c
@@ -82,9 +82,9 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 		return;
 	}
 
-	dev->trng_base = of_iomap(trng, 0);
+	dev->trng_base = devm_of_iomap(core_dev->device, trng, 0, NULL);
 	of_node_put(trng);
-	if (!dev->trng_base)
+	if (IS_ERR(dev->trng_base))
 		goto err_out;
 
 	rng = kzalloc_obj(*rng);
@@ -108,9 +108,7 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 	return;
 
 err_out:
-	iounmap(dev->trng_base);
 	kfree(rng);
-	dev->trng_base = NULL;
 	core_dev->trng = NULL;
 }
 
@@ -121,7 +119,6 @@ void ppc4xx_trng_remove(struct crypto4xx_core_device *core_dev)
 
 		devm_hwrng_unregister(core_dev->device, core_dev->trng);
 		ppc4xx_trng_enable(dev, false);
-		iounmap(dev->trng_base);
 		kfree(core_dev->trng);
 	}
 }
-- 
2.55.0


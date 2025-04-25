Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD609242D73;
	Fri, 25 Apr 2025 12:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745585153; cv=none; b=SGl2ySrt87yS+cjGaJ2vFzx6cQQAOn1nboh992Y4vY3GCOX16/3bKz7BoWAlJABQ8zOtwu0jkVLO1XLmNwOAXl7aZPITgDIUwHEVzlplPz6QCMMLbVRU8L2mylIYCNZROnYBBb2yotdgM/HVfDxjy1O9r77hkRXQMsySvgvU7Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745585153; c=relaxed/simple;
	bh=exRkwnVeS/Cdsai2sezNI/oSufx/K7jdx/8Kohn6yVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBj2xt2XWFl6o+UPNZ0rJT2ow6Mh6ZQk0EyeryZEGhP0uD4Tl5QxsXugVyEnqNsJeNd29pw6JM3tJDQoFIRNb9OKWUhNZNuWxT8oyXlFdOOUnzv87V/RHVDwSrZc4pqwfccxRoGy0n+d2f2cqSXruH3N5W5imRskQBx9FEleryk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YUxWNf32; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YUxWNf32"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5f6222c6c4cso3559674a12.1;
        Fri, 25 Apr 2025 05:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745585150; x=1746189950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJZkOqtqIFJNQlkOlUTiGoivFhrWHNceh/fOrvQbc9Q=;
        b=YUxWNf32pUUClzCh/wDUZgyuAXc/Txxv9rYVmB7TQQ7Z/1vz4XtfX1GYX0oBm0MuK6
         KSRpztQV5ts8T27BlUj7NrhB2aP/4gO350iuRK8brFf0BQXqFZ53CRls6ZktHMyRJ+bq
         ZVG8IrL2mNn8g9SUb4OZrqBna1Y43k2sOo2QvRbmV9xpJS58umZI2wjMbdmeKBbA0Ovo
         3QXGx3ltE0iSC0F1LzXBZirO5nhsR/T5DDwvB4NDj8pLXAL2FWERB1WawxEF5oMFnskz
         XrwLEvZ+6szrWYB8AIdTnamR9UFUvNquF14aeTFaTWi9cybgn7ZVX//hMCfRg4GI0m+Z
         WEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745585150; x=1746189950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zJZkOqtqIFJNQlkOlUTiGoivFhrWHNceh/fOrvQbc9Q=;
        b=giSkTTgC4Ok4wcwu2OqQHoT4nRm1TYMBGwnpdhO4DDdo0NUdHLoPi87YJ/jlTKr1E9
         8GicgrVS85WCjBMMZGpSahoMMK+d43FQK+JeuIdjm4jCxzqn23cZPDTD7H/RmUr7yAt+
         S0POv0n1OfmKqEM1+GDbUVzeQVT+46bdg1rLHfv001p+RIEKZ4MvhknYd7qurciafQrD
         q3lUT5nW0YuDUVAH43Wae5l1kFAXWhAvuVcXEIFcBqQ1bnj2HL8tIOfNboY8XozgeY0z
         sZ1dULM0MGPsB9F2sBnwm31ZmOGLqQ+uiPBR7KXPh3EPMGm6tJZ1BhSf65qNhi07bjIp
         cUBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPtfDtb1DeftDHa6CBJY2PF5j5tf/gsHJBe906MAAbW006IoP1q6CXk2PBrRnSocvB/mEjdVk/hF/EPoU=@vger.kernel.org, AJvYcCWmaubYYPHTaCarBCQ/CAOrdqDm70dTOc3oVJZmSGdKU2YCL7lt2QzRGSQcb0x6d3IcH0q/s1jlK9y0Wfnp@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+ZMobTk3yriUrMxwC9ue3f0Q5IIFAtcCw3x6yEaO6orf5NDnG
	8N5F4z8jQ9wjM3vNGLRx8oqtV402HuygN0y5w4u25NXrUvfWNT4x
X-Gm-Gg: ASbGncuLxwysacMwZZhpbZ2e/bNDrvq7hMYc13165JflTmJU63BpUu5rWKWloCQM2ZU
	QFD+x1pfQsMlpWHNsQnUURl4NaCPbUOEOivEsDVETyc1L6xWFUzirrQ7RAJrYz1SzfgqdOGA+qu
	rXLR3trLH6PVRN1wRXc6cgLkQIv3nrhd/n/dGr9pROp7ueyxZt44h0wAbue+J4kpfPrhxHKNogb
	3aeLSpI6Dwx7RTbZuYYQWMVRY0f4vD3fsJ/IrQ5F8SBn9VMhwbrL1Jb0YDvDusW3JLaKnLslJ75
	k836G/yOZjHPggSMiGD/UKjg+zRc3NdsKfArzn73jJQ57EGEarm62e0EwmYP6U9/M9cC
X-Google-Smtp-Source: AGHT+IHX1fUvg5R4L0dWk/e/ZPWlYj/hBTwXn2LGbh3X7N19EfXlUA+lvP4IWHRCaDEIAuZ5mEtnsQ==
X-Received: by 2002:a17:907:7ba7:b0:ac7:cfcb:c3e3 with SMTP id a640c23a62f3a-ace7136ccadmr194648166b.45.1745585149643;
        Fri, 25 Apr 2025 05:45:49 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e4e7094sm134641766b.56.2025.04.25.05.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 05:45:49 -0700 (PDT)
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
Subject: [PATCH 4/4] crypto: sun8i-ce-cipher - use pm_runtime_resume_and_get()
Date: Fri, 25 Apr 2025 15:45:17 +0300
Message-ID: <20250425124517.2225963-4-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
References: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace pm_runtime_get_sync() usage with pm_runtime_resume_and_get() to
simplify error handling.

This is recommended in the documentation of pm_runtime_get_sync():
/**
 * pm_runtime_get_sync - Bump up usage counter of a device and resume it.
...
 * Consider using pm_runtime_resume_and_get() instead of it, especially
 * if its return value is checked by the caller, as this is likely to result
 * in cleaner code.
...
 */

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 433cd18f0b5b..471eec743f1c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -456,13 +456,12 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 		       crypto_skcipher_driver_name(op->fallback_tfm),
 		       CRYPTO_MAX_ALG_NAME);
 
-	err = pm_runtime_get_sync(op->ce->dev);
+	err = pm_runtime_resume_and_get(op->ce->dev);
 	if (err < 0)
 		goto error_pm;
 
 	return 0;
 error_pm:
-	pm_runtime_put_noidle(op->ce->dev);
 	crypto_free_skcipher(op->fallback_tfm);
 	return err;
 }
-- 
2.48.1


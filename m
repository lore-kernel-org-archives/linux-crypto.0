Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B773370EC
	for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2026 09:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786182213; cv=none; b=gg5znONuwzaI6eS6gKiTQdPfMc2hJN+n6tKeFjWQZqbs8lPjRqXcyJRPyCrrPtnIJJxYKA4RQrxf2SQVWIcd8x1naFWMdb8FNSUlIhmxf0ytFBjPXQsfpdUpWWA62ILToc+yeFH/vpAI3BqF+Wam3eoO1wI0dafvSVxwv+0afTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786182213; c=relaxed/simple;
	bh=r6nfrHf9VWnHnAVX3pP+NYypBFwJru0XwFToKW5t2DY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P9EjyuSuz7bFcA5woD4thEfhC7bQXAUY01t5hvMwNbDa/bGl9cqhnYU+//a3QtteRVgAfluTjEM8Wc71zjhUkGyPXtSiyTFsOqffprJBwM0d2Imd0H9/3WIcv6IDf93ahfy8GdIV/F6P6zjQfEmOndxEQQNl7d/ZoSpyo8Ojm3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hA6gL1nG; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hA6gL1nG"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cace91f112so3526995ad.0
        for <linux-crypto@vger.kernel.org>; Sat, 08 Aug 2026 02:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786182211; x=1786787011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fDbi4zALnFhUD4L9Nk6WABMkAbrLbdj/pPHftS8rUB0=;
        b=hA6gL1nGLJwB0r6Ykkti04RzpX9yCIaB8wtGoSLqt3PKQG6gb1KPvSg+UWMRiCtltW
         ySLX2C2BnQcVwOCWPzrB4uZ9HM4Fc3NDKTpSbqGttN1xCxg7eJxSHreFx1tUpGRO2JcS
         JCFEr2CiGryD6k5i7ZmQdj8HN4LVOhjM8lQHDyL656AEWHi3LDFyyEB8T2fTOjn05nAi
         Ov2qSjCMbcG1O5+tZBY/zQv6RDIEfBvA7iXZ/gMl5MHF81hCW+f2lnnWHsLxd4nSjVmY
         4/Lkck8R1bzFhNEA5dTsVmd5SoUqA1Q4xOW/NeyOg+HJt6sGp2/hr1izFz8AZphOt9vN
         Euow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786182211; x=1786787011;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fDbi4zALnFhUD4L9Nk6WABMkAbrLbdj/pPHftS8rUB0=;
        b=fufrrYTLDg+/AJukbwDJh2xOKqGTFjkzcwbXtCMloKPRJ0CiFDVzdsmOU9IUdEOycP
         thjZVnGfQyOYJK9D7oPLpHFpY/S45k0QD3ora9LO8oWaN06EPqO3nzQRUPecUYtbaYx3
         BEUjl2GUUy0EKuRfNY0TWLkf7O+O49+o85DkhoD88ULf06T8qI69mtTpGVAgUdOL15Ci
         bEZlAlAmK5Vq5V92BtfX6jQ4h1OLdhFt+PiKY9G0lkvHAgptKhLEj6C3xF1WfU1PS0b4
         Wm/skAJqIm0f8I086uZj6mZkKAylO2pX/N3nmYihNg8kjYQQswmdrnoJERkuJoOMUtuP
         DGiw==
X-Forwarded-Encrypted: i=1; AHgh+RrybG+b+cPytX8wKFotTIxQi2lzTBfMr7mhN8e2OMfGD3bM5W1mrgF+qQ0WpQzesxADezDIGabrMivW8qo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHtxzdt+UxeWpKewlL4ZDqqNSvopf6XuI+oXTtZtaduOEpVNJM
	qM9g0byiwUlrAPwz+wFQv8gIHXP68gTZsfeAlC9nPkd24x733akiZJwI
X-Gm-Gg: AR+sD13AGoL5+V3EcSOBnBtQenLD/v8Jojq52LNHRARroKGpxFf9BdcJuPRAepYidw0
	/OK2VlEh7XrTTpP55e1CpWB4pfsY4k2zy+IiIBjIeYEWnHiztwY5VWN4+MNs87LB1t9t7qLXzGE
	KhQiU2CIQDyHtW8ZA77rA8IWn+0fXr2lUDpz8uZGmFGcOToSVFgVfQRE/lXWAf7vqueiVQTX905
	N89Jvib88sY3SPz0W22v7EOr2tEOKbIEWpjfoT2XrFIwuNzrFEhfQOnD67S0WS4X1dYpxvfr9V0
	PHb0w+Fyl75y0ImG5VlDmkN4AJufqXGgBfeLe5jmmam/ctKkBMETukwO5+5kwZ5Vl5fgo7sdavU
	QpKdP16IymqoqwQfE7Rd8ssmHnbcK6RYLOjlnnlH2pcwnfHIuNvL/C6Rp3QxS44oUtaKAyT/GUo
	0nqY/tA75KPfGeM1OQuJqVPvxzKtdY01uVDzJuGzrDNolx8qQ7kwGm/Q==
X-Received: by 2002:a05:6a20:b598:b0:3c8:f342:132c with SMTP id adf61e73a8af0-3cb85e99264mr35264761637.11.1786182211362;
        Sat, 08 Aug 2026 02:43:31 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe8f1b3eb2sm1707505a12.13.2026.08.08.02.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 02:43:30 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"lionel.debieve@st.com" <lionel.debieve@st.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] crypto: stm32/hash: fix autosuspend cleanup during teardown
Date: Sat,  8 Aug 2026 17:41:14 +0800
Message-ID: <20260808094114.2750088-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

stm32_hash_probe() calls pm_runtime_use_autosuspend(), but neither the
probe failure path nor stm32_hash_remove() calls the matching
pm_runtime_dont_use_autosuspend() before disabling runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() calls to both the
probe failure and remove paths before disabling runtime PM.

This issue was found by manual code inspection.

Fixes: 8b4d566de6a5 ("crypto: stm32/hash - Add power management support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/crypto/stm32/stm32-hash.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index dada5951082c..12fa1a8f67eb 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -2456,6 +2456,7 @@ static int stm32_hash_probe(struct platform_device *pdev)
 	if (hdev->dma_lch)
 		dma_release_channel(hdev->dma_lch);
 err_reset:
+	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
 
@@ -2482,6 +2483,7 @@ static void stm32_hash_remove(struct platform_device *pdev)
 	if (hdev->dma_lch)
 		dma_release_channel(hdev->dma_lch);
 
+	pm_runtime_dont_use_autosuspend(hdev->dev);
 	pm_runtime_disable(hdev->dev);
 	pm_runtime_put_noidle(hdev->dev);
 
-- 
2.43.0


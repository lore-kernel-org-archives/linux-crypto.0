Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89286197A6C;
	Sun, 20 Oct 2024 19:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729452351; cv=none; b=b9dxzLiA3CBxc67HwddgMsTNirbXo1JVBWgmvaR0cCs5aYt7lP/Zz+erih//bmSdvXl4asoFLGBcFYdy3DqR27Cm0ogJILnO8T2dndvjPxuxTSKGS6NZQUMWtnk2yXnHotguZNVYLYA9ECGTwiHr4ZeVAYcuOcKMVPzDTARPzho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729452351; c=relaxed/simple;
	bh=eTrWZfj3b1SV9DAWDUfBG8mJCGcSqYAFT7ITaERAMtw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SK7TreoGPgkC/fbb4KgAWr/p1m93I6QvSYMWuTmSU6sS0aykWvL6hxWTSyToj+QdMaIIiSsoIFyidKOm99WS4Zg5nKiwW2+oiaRD5fMiax6E5j3pVQOT9iWh8YgBfVsbla9XrjvZnZmnFYUrfRcwjwAzO/GQAqaz5TbSieblzM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mFm8vy0Y; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mFm8vy0Y"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c9c28c1ecbso4659103a12.0;
        Sun, 20 Oct 2024 12:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729452348; x=1730057148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fa82SFshV6nEwAVMBdimXeinCih4JEM3G6NXQJF+Z+A=;
        b=mFm8vy0YcvjId4mNZQux1MNPmF6vT2vSTGbj9dE/go+RsTa9VkmwXLBQXpYrsCb7vB
         R29Id+LhDu1kc3XCUDp5L3Dlm698+SGc7sL19jopZZLabx3DkuitPeX7Y5rOma2hGZaF
         5Z/rPSz9io6CdZ+ADJNxKeLxkTRlpeIC8QHbX1T2GU7SzQC2EJgUiNmXcHy7M1EJo+35
         bEIBSrMGGtLQC2QTY/XrS15uafq0Y0W7bg2t6xEW+tUXFD12g+Rgo8kn2SNKyMEQVbqq
         Hzyg5yldutsMJFqUnh+dhCQ7nFtwM8X6TUHFX93iK2Q5RvxPlika00aulZR5aBis1UFc
         RAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729452348; x=1730057148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fa82SFshV6nEwAVMBdimXeinCih4JEM3G6NXQJF+Z+A=;
        b=cHF/J5LJZFXJXPWyc988GiziC0cI258NtqrH3z9bs+WGkA/0CWosOpy+yMMsAVbeH3
         SPaP9IIJQJywElo2T5kWl6AHKZUczSfj13JV6i2koDV2c9pVNhyF7LRUO+acQbhSKyR8
         fQxq1UEhm3/RNqalICcyux70ZPQjlQOgiEoel4UUydprmBTCYXzDyBfqUIca9Yo+tMf8
         nc7dl0IQGCxxjwgYdxldqn1blHpDFXeRFaXkbv2nnAbCI0bESA/Mlf6j3tS8487IC+FO
         cN6q8S0XQqRdKfe9OI3H3/edW8znnq5hVNewayvsR2C2k8erys8Q0cj/38xRcZ4yCgSA
         VqOw==
X-Forwarded-Encrypted: i=1; AJvYcCU5iDPJf57NsUJWB+mDiUMzw46JzAHdF18CKZqNmjFCy171OE+/4LtdhvniRuMiUEEiJrAPIUQEFwVnow==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWM4XRu6gCu2TYqCSt6Hdxk5w7jCz74AJNRyt6Val+20vB6VZh
	wkkj/E6QalCkHRhKENjcu+6VclizmOvBgl6ZpipDnkNyPXzPR9oHxRpGdPUY
X-Google-Smtp-Source: AGHT+IFLPB1z9G26SqagG7Lh3/KIYmfKr6AU0oKoTjb+qwUIyo1gYVk/ntSeTAE/ZLpn7bY+JzUVxw==
X-Received: by 2002:a17:907:7f15:b0:a99:43e5:ac37 with SMTP id a640c23a62f3a-a9a69a73b51mr928910166b.15.1729452347520;
        Sun, 20 Oct 2024 12:25:47 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c501:f600:f753:f6c2:4f3a:5d50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a915599dasm117957366b.118.2024.10.20.12.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2024 12:25:47 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	linux-tegra@vger.kernel.org
Subject: [PATCH 1/2] crypto: tegra - remove unneeded crypto_engine_stop() call
Date: Sun, 20 Oct 2024 22:25:31 +0300
Message-Id: <20241020192532.4008-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.39.5
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
Cc: Akhil R <akhilrajeev@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: linux-tegra@vger.kernel.org

 drivers/crypto/tegra/tegra-se-main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index f94c0331b148..af11a0b5194d 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -312,7 +312,6 @@ static int tegra_se_probe(struct platform_device *pdev)
 
 	ret = tegra_se_host1x_register(se);
 	if (ret) {
-		crypto_engine_stop(se->engine);
 		crypto_engine_exit(se->engine);
 		return dev_err_probe(dev, ret, "failed to init host1x params\n");
 	}
@@ -324,7 +323,6 @@ static void tegra_se_remove(struct platform_device *pdev)
 {
 	struct tegra_se *se = platform_get_drvdata(pdev);
 
-	crypto_engine_stop(se->engine);
 	crypto_engine_exit(se->engine);
 	host1x_client_unregister(&se->client);
 }
-- 
2.39.5


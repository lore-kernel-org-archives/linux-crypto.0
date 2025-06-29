Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B0338DEC;
	Sun, 29 Jun 2025 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751218346; cv=none; b=Uj+ikzzUx+XlT4e9TkdSC+gQMQhDYbdnz+AjxZvUJv4kf6GchaOi32yXOVtKV5rdSSchlEAGUEgxKCihdMSHcId0yrUOVQKikk0vfApnnENCHooIZMuxcAiFhpwoaaXAzwb+T8xm5hgYKj+R4XmHtk7aaknsVfq1qI+GaI+GzEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751218346; c=relaxed/simple;
	bh=wdwgNbsNRPBufkJ5VtM94BJhRN1c/3knJlzT3Ebe0MI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LMFSsUAmHc7fJixvzDyvBozLqWxQoB4zLt9FRBKQrCYrMosqCp4fLU7fXLZJtOwfNAwsOpF1JKMKHLjc3TOuk/eqX/qeenlyOvJGea1lv/rHh/DqtVoWXpuhgy7MA/fFxQ4QyEQw7YPfoD4yHn72NUQDVsNlTxhj7bfs+ZyBIik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NI7XviOg; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NI7XviOg"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6070293103cso2422196a12.0;
        Sun, 29 Jun 2025 10:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751218343; x=1751823143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B6xQ1Y7hBvJR57XJgMbIXAzfr8lk18+IiDuMHlwLxZQ=;
        b=NI7XviOgZYA2nUuUG4U6qVjSOVDicKEpZaN/+Ane/5KawAMGZTzkbH75sudJvc5T6u
         lkkxdb43dIOu8CPs4B7ekYl34z8AkNcnDyzCFpDWen6Cne8PoMliCqDgReROxabn12cI
         yFGOsH8UHZwct3kGyX4ZsAvhWA2Ts5o53+oinxZyCPyeUPwFuyR6wYvuYGo2BY+tLcgU
         ri0FIN7G60p7QXqbyfT8V0zNPfEZ59yj/78LvkgAq2m8RXGAM/08yRnCb5vCbWl84D6B
         ts6XuzjHC3OGIS39YZ2QpLVbMJ0B02Qg8tMoDjJPLzjnNKZoyWGDR1NkGHNc1594mz8C
         kugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751218343; x=1751823143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B6xQ1Y7hBvJR57XJgMbIXAzfr8lk18+IiDuMHlwLxZQ=;
        b=rF032Hzj19J2hW8PBfViwhacszcmXXegSdac7dfqrApoC/XlIu0f78nux8y/aFNrz4
         3mSBwt50APSmd+Zqzwikjtr2qgEVAjeLy9oEKit9eaa+rYNbRDIEqQAC83X5t7gBH9Kd
         VItaT8XtbVhRMKWjqtjO/ZCytY2qpDODketCjlsAm7y7O6QfKeX++/7afuC7GzBuvrQ3
         0TJgANTJbwyjiwibPukF1yWhxo8PD07uXZa1x9Yinbm1KbAM5bXP+ZstnMYbA7gcmkS4
         mpxlJLo4gfZBe28fXdmsQbbPxk1vCVX+91+OVfBLh+C3NCvf+/1jDiryDcuvYdjLzEqd
         y2Tg==
X-Forwarded-Encrypted: i=1; AJvYcCXZYULu4JyEWjbeywjMJiXvf70sOkp0Cwz++a2raOMVIbs5k9Q+nL33ZTjgYYf2OSaFwQReQH5WqibOE5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHiOnGi+/mQGEwI1iCJxdMWuID6EsRcg53jhtQ0jvkb3Nv8p9D
	xY3PdOE9mtgD5qO+o2mnB0R/6tnsV5fYj+ZRkRBTnYGhsCzBkrgeODRT
X-Gm-Gg: ASbGnctC4ykZCwx+aibAD9Ml6psX00WZy/8fU4JLlUPq3Nacxezqhg5+ZLPWjXwinwO
	lXWkl+i16gpwOCBqd7C15ZVrGVFvGZFmQBAtF+zKDOP5uuEndWnTqlhvzbhRu0Z34/TKdd7QqHU
	FfYjaX113vP5ad0jbIwwmDux/Y0d3HqrigPkETo0zGrq9WIe7G0QaUP0Rj8eYj3smqLBZYMbG9c
	LoHua/89X16sslTeBbiFsPX0vgncrinz0fUMA91M+lDG2X5NL6ocAehtmu5FXHbfB7dz5qXphyJ
	bEYEa1VYWdqUL7kfFunOAHJOYWGeJV1MUaAGX4j54Vv4o7Ef5CVj2hEZgT152SVSzHSrUZEVFgy
	Bo2ND9tlZbQKmdw==
X-Google-Smtp-Source: AGHT+IEkQU4DhfJJjyRDWns6fYatVrqoTFcRiDvvpFr1CvT5I3mlltWZlVGmaskJ6UNFDI5bDQF/Pg==
X-Received: by 2002:a05:6402:2787:b0:60c:4782:e4e1 with SMTP id 4fb4d7f45d1cf-60c88e2fe32mr9889331a12.27.1751218342378;
        Sun, 29 Jun 2025 10:32:22 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c831ff8b3sm4607789a12.67.2025.06.29.10.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jun 2025 10:32:21 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: sean.wang@mediatek.com,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH] hwrng: mtk - handle devm_pm_runtime_enable errors
Date: Sun, 29 Jun 2025 20:31:41 +0300
Message-ID: <20250629173141.2423728-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Although unlikely, devm_pm_runtime_enable() call might fail, so handle
the return value.

Fixes: 78cb66caa6ab ("hwrng: mtk - Use devm_pm_runtime_enable")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/char/hw_random/mtk-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index b7fa1bc1122b..d09a4d813766 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -143,7 +143,9 @@ static int mtk_rng_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, priv);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, RNG_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 
 	dev_info(&pdev->dev, "registered RNG driver\n");
 
-- 
2.49.0


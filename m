Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234502D4B47;
	Tue, 24 Jun 2025 13:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773196; cv=none; b=gO0Qbi2NOmToMY+C4IJGEJwR621OzF3iuzWcK+oYvJwUFIkKbElRL/e53ylvtH0hO3A9KQKznF5IwKJXfn2rsZZ1QmyzASj3b1AQ7lDXM4UBeefEM6uHUCFV7cx/emfSmQusvQrypz5LvyLADZNHDVMynKe5CNEx3eGmVZ/HX6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773196; c=relaxed/simple;
	bh=xusTcC8LPaIRB6OKmJ0o5yoOL3gFmuABAHVhkhe0RfY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZOMpOWHPSDKv316+ztv9s1X80fAF91s/vQJ00H2qGlrP6J4/+RnJntIlQ3HVkniTdZopnwLyS9DrmW6kM3G12dDllEnBSTvHoBQizMEd1WVR5Tf0n3NhbX2EFQpUzRvVTxJgi00N7hMGevPMG7KUAzOTQj16F5GmydmzsxGwUyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DoLsG6eV; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DoLsG6eV"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-32ade3723adso64105661fa.0;
        Tue, 24 Jun 2025 06:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773192; x=1751377992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o6VQVxWPrKSBA2sbYaQf9GploMxfJIkFBHTbYFWvLtg=;
        b=DoLsG6eV9eSR06jEZBQiqoK5nW9wSP84HKbRN9ZU6UiQ9UaYVpdowxpCZ7ZubSU7AF
         FCe0CMkaHnCGGQNRfqWyIE4JuGpqaqgMwE1sWgVK8KUYCUdDAe5xUMaoqZT7vYxti/m/
         p/cIPTZIZvcwrMbvcYlaTpJkGvsqZStz3yGqWJMroabgYhBdQWh4xNnDfFAWC/wLuoO6
         BcekLHvsZ4z8h+YtQFgZUIwi/eXSiWbZ+lEPIk7oI8Lp5c5lIbxsbcgFK63Bn4fNGuYz
         mAHlMq/EZAZOXPgzsBJwGeLBvmyDcR4Ev9dZAQ1jRu4XlAqugJPZCAI9B5tr5P3kJjwV
         v7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773192; x=1751377992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o6VQVxWPrKSBA2sbYaQf9GploMxfJIkFBHTbYFWvLtg=;
        b=oPuOZKmPgWx2XvX39EWJw7cqJ4hjxdcVHT3dPic7DklFmoA35O4LLbpXoHSs+3y/E2
         tIQU4iEepYpZ6cSBgYmNUyZ7i/qBJoL5rXrILjkSNCjhfKjbPCJninF04tdeZyLmJ9Qc
         FNMoSEEbgh7rjVcb4Pgj/bvuwg/A6fYOytDkDhxKkMQzFtiszAWJXtfb0LekZmzieLry
         WaAff+Y97VZ2mE21DaTvwxA7f0PH0eOVVWP8cxnZbjxiPxpY9WEFmy1WD9c6z+TzY3bx
         Nh6Pta8qEKKwTTVZULbnvap6W191Mi2AZxLWkPiNOTWo4HYVYif7R9wTGlmsHOJ9HkNC
         5h1g==
X-Forwarded-Encrypted: i=1; AJvYcCU3DlJ3ptGxnbzF+wOYVIKWowZseI0EJEEfyc3TUiVqdUjnqPhY2/8iTx/O8gqvtdaf3QQg5dyZJmyqGbqW@vger.kernel.org, AJvYcCVJCCEfuU7rTl4PrIcU2q6O9ZudulKOw1hizq+XDEfe3D5gq0n4KmhA3vj+Z47vXJCyZwepsC1kEVWK@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/+oQo3ymKDkW8ch4stARyRjroD0TEAF976q0nrHB9dV8989Tj
	M9+jehs52433sU/Wbynn113nZ3AimE0mCE0/xciVJb0E8MmA3pP+W2q6
X-Gm-Gg: ASbGncvmp/NL5iFk8E44mU9pOTRlhJWB8EnOSZ7Hj7WPGlcdmYNibMdtHusKK0sOJAI
	bGyksriz+RU/4aO3jP7PFJf2rE/FnlSRzV4Pl2lZMvNvoGzhD2NZLUtVECP2bvOp/FcxlwwIok5
	LRNww2lfhzoMa2VifDRomPqtXyT2hWtv10CFBQCLGPussSsI7CiCygwzxYOZN74ZIjsOvlaQ7IC
	5Xxa10v3EUEW+xLjTM7TClaGXT+GjwYryAfBAJLrDQsaGYa5McWAi7MKZ+GV2nKK8ykel9mdZAB
	uAHr2LpE4SThH6D6L7yiZlWBYckgIyFKRnMT6WeJXT73wVhXz/DcxBn/U+16kRSdAHU++cbk4Zi
	7Nz+eQ+g5ogRX0F/FH2RSR0dxdbRLuFXLSDyNAWIpDhu5a4IlgkobQDlLqlt56E3HqGpgooX4
X-Google-Smtp-Source: AGHT+IFDQOmpu2KqgvgKBvVUGcsKCyKXlJo6cbGYkD0fUpbKYOofU/NED/QQobHL/74ty7DfuDhAhA==
X-Received: by 2002:a05:651c:4102:b0:32b:3879:ce7f with SMTP id 38308e7fff4ca-32b98c930f3mr28231231fa.0.1750773191996;
        Tue, 24 Jun 2025 06:53:11 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:11 -0700 (PDT)
From: Alexey Romanov <romanov.alexey2000@gmail.com>
To: neil.armstrong@linaro.org,
	clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	khilman@baylibre.com,
	jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v12 06/22] crypto: amlogic - Drop status field from meson_flow
Date: Tue, 24 Jun 2025 16:51:58 +0300
Message-Id: <20250624135214.1355051-7-romanov.alexey2000@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
References: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This field is used only to check for timeout. But there is more
convenient way to achive the same goal.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 13 +++++++++----
 drivers/crypto/amlogic/amlogic-gxl-core.c   |  1 -
 drivers/crypto/amlogic/amlogic-gxl.h        |  2 --
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 18e9e2d39b1f..dc0b100c5de2 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -219,13 +219,18 @@ static int meson_cipher(struct skcipher_request *areq)
 	}
 
 	reinit_completion(&mc->chanlist[flow].complete);
-	mc->chanlist[flow].status = 0;
 	meson_dma_start(mc, flow);
-	wait_for_completion_interruptible_timeout(&mc->chanlist[flow].complete,
-						  msecs_to_jiffies(500));
-	if (mc->chanlist[flow].status == 0) {
+
+	err = wait_for_completion_interruptible_timeout(&mc->chanlist[flow].complete,
+							msecs_to_jiffies(500));
+	if (err == 0) {
 		dev_err(mc->dev, "DMA timeout for flow %d\n", flow);
 		err = -EINVAL;
+	} else if (err < 0) {
+		dev_err(mc->dev, "Waiting for DMA completion is failed (%d)\n", err);
+	} else {
+		/* No error */
+		err = 0;
 	}
 
 	dma_unmap_single(mc->dev, phykeyiv, keyivlen, DMA_TO_DEVICE);
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 44e71e917e5e..9259ad0417d1 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -53,7 +53,6 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
 	for (flow = 0; flow < mc->flow_cnt; flow++) {
 		if (mc->chanlist[flow].irq == irq) {
 			if (meson_dma_ready(mc, flow)) {
-				mc->chanlist[flow].status = 1;
 				complete(&mc->chanlist[flow].complete);
 				return IRQ_HANDLED;
 			}
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index cb70277c3a31..0dde7662ae37 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -59,7 +59,6 @@ struct meson_desc {
  * @engine:	ptr to the crypto_engine for this flow
  * @keylen:	keylen for this flow operation
  * @complete:	completion for the current task on this flow
- * @status:	set to 1 by interrupt if task is done
  * @irq:	IRQ number for amlogic-crypto
  * @t_phy:	Physical address of task
  * @tl:		pointer to the current ce_task for this flow
@@ -68,7 +67,6 @@ struct meson_desc {
 struct meson_flow {
 	struct crypto_engine *engine;
 	struct completion complete;
-	int status;
 	int irq;
 	unsigned int keylen;
 	dma_addr_t t_phy;
-- 
2.34.1


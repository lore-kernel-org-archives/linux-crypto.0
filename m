Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6E63BAD9C
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 21:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786483235; cv=none; b=Uyfa7SMzM/S9CTneAfoO4+NxYB3QFNjrW1/ZbqpmdbEgoX/NkxnmfLSfgM1qsXzwi+FDn2uQSYmnq6LUtm+mx2eeo6ejvsWAX2KcasUIB9k96WxDp9UYM9bqJGUkVUsuYbgfSprknYlbOEFHealRxnaQJHt0nYHQfByI/9ZuZFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786483235; c=relaxed/simple;
	bh=59HySrGh0wkTlRznQMiEAoSLvYm4uJIFTa9mxas83m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoGnWPwUxVt0PHjL/p/McYEYl6ylbawJ7QodrmsbqgNwDkTS2d56CD3ZJJUDQAnRPdS96YLTuH5Rl5ZJzvMpyraLDMuK+WdQuzCK4vAMlK2mY6ifB28NRfa0CKN7AiZH2kACQHvlhhdj+53M76gey2soqdThgF6RTkDcBktLgxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qPbQYEYt; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qPbQYEYt"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc97653887so4505005ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 14:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786483233; x=1787088033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VMlE7iyQxKkbltuLSXml3jBS6nzbSIIQJp7mD4q4ahg=;
        b=qPbQYEYttaGBX4WFopHwTTC4No21K5/vbATtakJhPm1cxh04AJTbkf/KkLl59N3pgi
         pBCEJgwjl3WO0g/4vWNQOVGtW5Cudcjhunm8+Ud/tPUNM5gw9sCaJ9JJ5uMX8ba5VTLQ
         O7i/7c3l7810GoCcFiAxuPKE33bJtWbOcRYhtwROvNKAVOPV4VrNy73tSuQQj7iQCe0F
         Tyzhp0DPtd3fLugJ0h1Lx4RcZnYE3hj46+POgq90hti64sN2DWWyoGciKVWLaan8XN14
         ji03z0dDidiZg9gfaF7RLyedWEVOTfHOtXejA0epIbaN74sO6WR2QeJI72DeuFQsfRRC
         aNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786483233; x=1787088033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VMlE7iyQxKkbltuLSXml3jBS6nzbSIIQJp7mD4q4ahg=;
        b=QbDknSLMnVXiqaNABoVoFPE/2GSbs3h3E8dTNbwQrtntn4UMlxhLJSK8HAHpv4grxQ
         tkaeY2TrWMmnR12dBr5EOCGrEFIqLilPZsk5i9uEVoy9OBnEUj0mxaFCpxeGrRg6vghL
         08e2m1f0S5g/4ML8M44zSTNDZwfiuUUS+wD65YomM6dPnT+OtVmR673c2zYIXB6YaLj8
         EQEQDw/+7nXI/oCeV3hGmMZ7FgJeW1hMfGaDGamhNaSeCp6pg59GAQQDLr11NfLha7xq
         pdzROVY94NyJukyR9IgLv2SXiSzTJ+RUq/04b5+qcu6fOjDi7XWTyDQEFAZkMsJEZqzk
         ByoA==
X-Gm-Message-State: AOJu0YxDQTmtsz+4MZgZiYgZWU+5irgUMSL0FKBUnOJiU0Kfurv+BsP5
	DXptxltg9qoffH7vRDm42TGDgybtBxVkU7GERYkxoLyjUV1ngFfoQAS/3IOGIg==
X-Gm-Gg: AR+sD10mp+003m/dLHEa+rGyYYMcEdhyO+Wbi8Skz5sgdFFgjGW+ZfmjYGfXg4BJi03
	2KRtm0U4GO2xHBgJ6dYX27ya+BSvz6GQQAJqYAhEN7CqiIkr7hdbVDusgAeMS7YopuMObwn7v2r
	WbFgg9uEFzOU/1HA/mfeqqU/UPQyKkNt9gOMPwUNDyW8VfGamClQ0JW1IxMEKj8yMW6htAT60wQ
	I/imnYNNslDAFtiHvUg5KrK9QpZ5oXrrhtjvF0/JxizAhpxs5bSWUtJDKLRoDlgCikHYaLkPoev
	6ps+z/fgVINHcpvGwDnfnX0iXD2QpAphWNw+6HbEWNpsT/IZvuPZUq7t+2K0BxaKCy37srJJLmV
	PUY0kyC84tcDTSoTin6XTESmtqmiwM4AqxqKDP5nzxY5Bifjgwxk/AAfRsgDITSxZUHIz/Z1j30
	8ijluF+avEgOoFLdLBAOeM0dUaWn5kIC6JVJjquKxx/eNYQNB5Sjj6lmnGxEnAfIl/EkFb0Mh9c
	HG0usdjtJ/+EvIKO1Cd/cCkBFbkKn3roDYDYVFrqsCI65BoslY7Xsbww7QJMmd/1ibIstPvwpVl
	/BBul7XY++zY4Rwo+sLBoteUz1/g+2NY3gWNHA==
X-Received: by 2002:a17:902:d48f:b0:2ca:6c8:abd8 with SMTP id d9443c01a7336-2d34569b410mr3686125ad.12.1786483233132;
        Tue, 11 Aug 2026 14:20:33 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d315f2e10dsm12605465ad.23.2026.08.11.14.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 14:20:32 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] crypto: img-hash: fetch resources into locals before probe body
Date: Tue, 11 Aug 2026 14:20:29 -0700
Message-ID: <20260811212030.20057-2-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811212030.20057-1-rosenp@gmail.com>
References: <20260811212030.20057-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fetch the IRQ, iomem resources, and clocks at the start of img_hash_probe
and assign them to locals, then copy into hdev after it is allocated. This
keeps resource acquisition together at the top of probe and allows
direct return instead of having to use goto. These can also return
-EPROBE_DEFER so that helps to avoid pointless work.

Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/img-hash.c | 65 ++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 1ccfc0eccc73..f7265347901c 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -923,9 +923,37 @@ static int img_hash_probe(struct platform_device *pdev)
 	struct img_hash_dev *hdev;
 	struct device *dev = &pdev->dev;
 	struct resource *hash_res;
-	int	irq;
+	void __iomem *cpu_addr;
+	void __iomem *io_base;
+	struct clk *hash_clk;
+	struct clk *sys_clk;
+	int irq;
 	int err;
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	io_base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(io_base))
+		return PTR_ERR(io_base);
+
+	cpu_addr = devm_platform_get_and_ioremap_resource(pdev, 1, &hash_res);
+	if (IS_ERR(cpu_addr))
+		return PTR_ERR(cpu_addr);
+
+	hash_clk = devm_clk_get_enabled(&pdev->dev, "hash");
+	if (IS_ERR(hash_clk)) {
+		dev_err(dev, "clock initialization failed.\n");
+		return PTR_ERR(hash_clk);
+	}
+
+	sys_clk = devm_clk_get_enabled(&pdev->dev, "sys");
+	if (IS_ERR(sys_clk)) {
+		dev_err(dev, "clock initialization failed.\n");
+		return PTR_ERR(sys_clk);
+	}
+
 	hdev = devm_kzalloc(dev, sizeof(*hdev), GFP_KERNEL);
 	if (hdev == NULL)
 		return -ENOMEM;
@@ -944,25 +972,12 @@ static int img_hash_probe(struct platform_device *pdev)
 	crypto_init_queue(&hdev->queue, IMG_HASH_QUEUE_LENGTH);
 
 	/* Register bank */
-	hdev->io_base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(hdev->io_base)) {
-		err = PTR_ERR(hdev->io_base);
-		goto res_err;
-	}
-
+	hdev->io_base = io_base;
 	/* Write port (DMA or CPU) */
-	hdev->cpu_addr = devm_platform_get_and_ioremap_resource(pdev, 1, &hash_res);
-	if (IS_ERR(hdev->cpu_addr)) {
-		err = PTR_ERR(hdev->cpu_addr);
-		goto res_err;
-	}
+	hdev->cpu_addr = cpu_addr;
 	hdev->bus_addr = hash_res->start;
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		err = irq;
-		goto res_err;
-	}
+	hdev->hash_clk = hash_clk;
+	hdev->sys_clk = sys_clk;
 
 	err = devm_request_irq(dev, irq, img_irq_handler, 0,
 			       dev_name(dev), hdev);
@@ -970,20 +985,6 @@ static int img_hash_probe(struct platform_device *pdev)
 		goto res_err;
 	dev_dbg(dev, "using IRQ channel %d\n", irq);
 
-	hdev->hash_clk = devm_clk_get_enabled(&pdev->dev, "hash");
-	if (IS_ERR(hdev->hash_clk)) {
-		dev_err(dev, "clock initialization failed.\n");
-		err = PTR_ERR(hdev->hash_clk);
-		goto res_err;
-	}
-
-	hdev->sys_clk = devm_clk_get_enabled(&pdev->dev, "sys");
-	if (IS_ERR(hdev->sys_clk)) {
-		dev_err(dev, "clock initialization failed.\n");
-		err = PTR_ERR(hdev->sys_clk);
-		goto res_err;
-	}
-
 	err = img_hash_dma_init(hdev);
 	if (err)
 		goto res_err;
-- 
2.55.0


Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67152EEE88
	for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 19:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786562160; cv=none; b=ZffTjd57cXYa/HVAWybmHAvvMDLgWHfQ2YkDGcB9SYhdhG6q5llAtqa9R4G4MsQ/vKzI7fVhyJpzue9bMvr6AIywEGm9OWVFZp5kcUY3YTW85GqWPTiDO9BmgKGHilJLvUF4qW7KeRsMmF9YNHV5HANRZ9OuCVMNTgSH26vC2iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786562160; c=relaxed/simple;
	bh=4UCxHq2BE2GmSAQwBjwba6T9BMdiv8X/fPPv5suPNRY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AnHjhCqRyRoiARCGq+BHPaC0l40HJ0i7wl2tvuUFGbrtDtwVaCTJ09PgO58jblXP/UKo9Fi6PfmGKeCfx0N4d2KTtq6n9Ek1EHx4mhKDWRuyTW/Bw/NQ6vAMwRCjcakwiX1DR8r1ip8RSu73K/pvzzvlSOwASVnfoj9FP921Mts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UG4J0wkS; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UG4J0wkS"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7ee125ec926so1144944a34.2
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 12:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786562157; x=1787166957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V8NoH9PdC69aEVVjQOzaQxKll6cNu7PHBh8D+vhIKqg=;
        b=UG4J0wkSIlz4uxk4uJGaWJXvevqxGsa8p4Dj3pmly1wbqq3bPCTD73TZEnf97NX9WU
         UA5xgkToZpijmeKE282NCkttuvQv9jczsxpyOFDU/NGqJsZWye7O+ac/IW4wo8YfmxIi
         qSPNJygPax/wjvyoOe1SQmZraV1yRxIBlOg+qFYwyUW0BmJk0T6JS1i2O1nBZ5Mk9rIl
         FDwlqeCZivgT6hpIlbpumwpItfshArjxW6CElEGLxAcswjLJI0nyr3ldEo39h39WE6iw
         h8vrFl8D/4kCAUyS/nItTvkB8LiCuiOgdVqnQM32DUWF6hKSbCXTOGoDRwz2oKeHhTEj
         KN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786562157; x=1787166957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V8NoH9PdC69aEVVjQOzaQxKll6cNu7PHBh8D+vhIKqg=;
        b=s4j3JKDx9v2iR+4EfbFyqH2PvgxFuKD4rUpAkZC31c09mmxrKHZcaH3Li+BwjvZ69t
         uMd+ktwl7Ag/AhWiGyZ3/yb6d5rxb0SdKodrGjoUUVkCn8pzumUbp8J4XAhXKC4CXaiB
         5cUb7nnOghgyQll81wQ56ltBnkWPdEF35ypeCkbdqDvETtEwsvecyfwWGMFj6AfBKRaU
         Juao43OuAeV98zMeqD7msvEunQkW3GQcvAVoAgTjCoVSGn+2Nd8JFOWKat9ZZXGEx4Ch
         f8vwXjjG6y0Ga6NiVlMyi2v3QSRp/n+lrNNCD1fVjXYpeweTMZzV8dVappq8C6ObL8hL
         WFFA==
X-Gm-Message-State: AOJu0YwFtbo4XDbYSuZ4QxPxoZ9SPt8bjve2sR4p/x4HorzdDuE9Gzb8
	Ea0EjnepXW4fZNlXofxa5cmCLHPWIOltDgqlFHRh2wpHFrj4VTD/CjVjPf5G9jrV
X-Gm-Gg: AR+sD11REqiaQtMiJCdnd8xL2zu+hQX6jPHefLYxxIzVkXdZ/bv5SHcrU6lrY98A9+d
	zh46HCElLJkLT4W/cBokHwVElW7K5p59CTvq1gsyNgAIG9JW5kfvKMBWiIWvtROEGsH3U3VPqy3
	6W6BZKAlIzPkKU/wIY4urT+J2vyrPRC56+BkNTPNAeX9SL4ouyxoIv66rzVsmYX9NbseRz9zCZ8
	MaGd9vFEKxB+MNZOw0UOoI3NLiQMiCXVpBx26AKc/0kZ8VGnrrS9+TJ66V9dqvIDq2x7m6YS/pg
	wkujegG1Fioo8cEAnsUzW0kFDHx3VQ8XqQK34lc23ziMvjs+xjRddJ8wn+I52xNYLLvaRcmsHnG
	gzsLJY8hhclm8Tm6ojmgA/rvv5A5FBZ9O4ZfyM5zqO6qv2kMR/dMICtvCe6oesaswE+W4s8Ytjp
	2w0ID5IGd2ZsC2LZ6uJwuX8aSLGjFIjc6eCsUz2Lmqdep23ZOnLLtGEk82ZWj49kcWTF/+NCcKK
	Iyz3p5/mBBjfjhxvmS0bDTqZOJCWIhvmhu/ziZKjNRQB0kV3MUUIyFOIjpB/GG6LzUt/JSJKcoa
	jEmPFlURT3zAYidZlItW9cpzgUJT5rtRgHep0g==
X-Received: by 2002:a05:6830:6185:b0:7dd:9b19:a875 with SMTP id 46e09a7af769-7f3ca53fc6amr59805a34.2.1786562157466;
        Wed, 12 Aug 2026 12:15:57 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3c9ca7b0bsm106999a34.15.2026.08.12.12.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 12:15:56 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: amcc: pass core_dev to request_irq
Date: Wed, 12 Aug 2026 12:15:55 -0700
Message-ID: <20260812191555.93423-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of using a get_drvdata function to get the proper struct, just
pass the proper thing directly.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index bbc5162178f5..88d52e4a947e 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1057,8 +1057,7 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
 static inline irqreturn_t crypto4xx_interrupt_handler(int irq, void *data,
 						      u32 clr_val)
 {
-	struct device *dev = data;
-	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
+	struct crypto4xx_core_device *core_dev = data;
 
 	writel(clr_val, core_dev->dev->ce_base + CRYPTO4XX_INT_CLR);
 	tasklet_schedule(&core_dev->tasklet);
@@ -1314,7 +1313,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	rc = request_irq(core_dev->irq,
 			 is_revb ? crypto4xx_ce_interrupt_handler_revb :
 				   crypto4xx_ce_interrupt_handler,
-			 0, KBUILD_MODNAME, dev);
+			 0, KBUILD_MODNAME, core_dev);
 	if (rc)
 		goto err_tasklet;
 
@@ -1331,7 +1330,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	return 0;
 
 err_irq:
-	free_irq(core_dev->irq, dev);
+	free_irq(core_dev->irq, core_dev);
 err_tasklet:
 	tasklet_kill(&core_dev->tasklet);
 err_build_sdr:
@@ -1352,7 +1351,7 @@ static void crypto4xx_remove(struct platform_device *ofdev)
 	 * Free IRQ before killing the tasklet to prevent the interrupt
 	 * handler from rescheduling the tasklet after it has been killed.
 	 */
-	free_irq(core_dev->irq, dev);
+	free_irq(core_dev->irq, core_dev);
 	tasklet_kill(&core_dev->tasklet);
 	/* Un-register with Linux CryptoAPI */
 	crypto4xx_unregister_alg(core_dev->dev);
-- 
2.55.0


Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F8123EAAF
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 01:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780364826; cv=none; b=Khc5VZg2JVxVsDXA1rRtheSKRNpClTMcRxsDzbGVxR5w6GgNRF4fVoWSFRQ6o3+ne0CWeg25M2Opr1Xc+YjSxiUPFq4PBehWWd/K43WTDELN+HqKN9H6V/S3IC0NnG3ahDzebysFH5BNLpcOcu3sRiP+k+8IcZ9qe/qaQjoWZiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780364826; c=relaxed/simple;
	bh=bsVYNCTaBm8NP/a8z4vT5Nw9PVJWnd6S/RIbZpCokA4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rD9/xhSG+mSs9F8BKe93vXfT4jJPLJgBtK8NqUhHcJSpIbrzfjRtSJZ5NueOGXQL1RqNl4k4l1G+EXH5E9W28heCiy+a/idjSINLdTlTSgQjSQPC5Aa0J8xZ4h9MdKhtk7M70Cj4P8QmO8jbigAEx/o0TeWHVEQAkZ4gZrVcpAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZU3xzdQE; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZU3xzdQE"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c0c32f6ce1so12653685ad.2
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jun 2026 18:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780364823; x=1780969623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KhwKwq+oR5VxK7FFuu21d6kQ4Vbv5ERvHXpa8GTJxhA=;
        b=ZU3xzdQE2nMTgx9ASWtjo6y+IdWD2O69SYMVe2Y15Kvt/+sawNu8sCIUF7ce9eWxRP
         9nrfaRgSEfUFzvRUkGLYz18CDz9B0d9to6Q+p35roNq6i43A5m2ofa1RMc36nc3Xb0oD
         s2R3Fy4clyR2XPuncJqOV7P7h39FQtx9JhBQoDEB7ftxNpdZVSXPH4SyybyGjllZoQb7
         Ko0Ku73qED24zXgqNWh/yUES3XE1GwzPVSUP0dvMOVZhsr4YpiPy/aSf92D3vE7di0Lv
         dC12CSys/MmaMjTZ39UggV6mBVYKVhd22LL8tA5wNWSAeqVV2zhzDMpS/iOzqPyKTY8W
         1Chg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780364823; x=1780969623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KhwKwq+oR5VxK7FFuu21d6kQ4Vbv5ERvHXpa8GTJxhA=;
        b=lVi2SFr2IZPuYKQU4nAUhtVy3OXtJpTt1YNxuFFdZO3bG/gBG3jo4OGZzJlHkF4yQH
         T2LMW8fHImKs09ehUT5DgFDPYoJKFBQKM0v5Fpx7dnhcWtLhxbqqnWL8r1wsgxFj4KLK
         CPLzG6S6PHiyphtrkqrCsdQgVLazCnu9rPstBmE/i3z0HBiZnhh0oPT2JjGXPRhxBMWd
         I514if8vKWaHrp3oaY2V5aI6YtFZBNT2CwVaOX0wsuPvfatj5JZayvh+OF45WMwb+LHg
         zxkQSoScFjd8EuOrjvnkr4TB5zw86tdy2lDDaaENAuM7U+/QOwWICpgvXzhE3pAu3ijn
         MIZw==
X-Gm-Message-State: AOJu0Ywf0pDM+QMQ7l/Nw1IFEceu9y41juyY5dEuGFVccgjcVZJ1O6pb
	GCu+lFffJS4QsbLoaGhdiidk0WpMI+eGWSiJURcZp4mWHK8jPcf2DzALHg0eNQ==
X-Gm-Gg: Acq92OGS/4XIh8vEA4a0keDCND1SwjcSoTb+3O6f5AJXG2ZcTR5teV8JwGZHq1iIwlY
	ah7dsYor8bnDqW0IbFv3ZbIZhR6bFWLw0J9fFrPvm0xj1rgtDGDjjXXx/uBmDlN3e3V5ZSj+PvT
	FP/VwQ6wbG5QGEENXogZi03Jzhb2KMb/cPGGW9S62RBAIMK0kt5mTedxDWaHn3PLZ6i+oSWYi0v
	Kx/pO+T9vB/WgXj7dzxOAc9LYKFtGTtkbgB5uq02Dv7K5Ze2orWbLFcSgXHYoz3QjeTIsd2cETO
	SuGTCSZQzYpTRTJsPpUqL0wTMCeMl7VDf50JAFwC/1mzvABMmtZshmZDKsfOEPprJzBXB779WdD
	DtJebnQkqRTilIf+BTsEgD6YwDTf5p7pzAa+OKeW4NHAJkMY9WRBG+wI5i3VgSup1A3dZtPPXBx
	y/WuLCvtJ/B2hxyZXLrpaweyIvkxfzMdZ8pZ12BGf5Mc8QE6heCOWEhGJlsDr5D4YJm5Q2Qyeha
	jmCbyZqLlf4hZNxXXxi5jeJGo6/tOvyWd43XHIQpl4FAw==
X-Received: by 2002:a17:903:240e:b0:2ae:450c:951e with SMTP id d9443c01a7336-2bf367f27dcmr142894745ad.17.1780364823307;
        Mon, 01 Jun 2026 18:47:03 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239fd84fsm119660615ad.23.2026.06.01.18.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 18:47:02 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: amcc - convert irq_of_parse_and_map to platform_get_irq
Date: Mon,  1 Jun 2026 18:46:45 -0700
Message-ID: <20260602014645.522137-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the deprecated irq_of_parse_and_map() call with the modern
platform_get_irq() in the probe function. This also improves error
handling: platform_get_irq() returns a negative errno on failure,
whereas irq_of_parse_and_map() returned 0.

Change the irq field in struct crypto4xx_core_device from u32 to int
to match the return type of platform_get_irq().

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 6 +++++-
 drivers/crypto/amcc/crypto4xx_core.h | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index b7b6c97d2147..063282a2ad63 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1382,7 +1382,11 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	}
 
 	/* Register for Crypto isr, Crypto Engine IRQ */
-	core_dev->irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
+	core_dev->irq = platform_get_irq(ofdev, 0);
+	if (core_dev->irq < 0) {
+		rc = core_dev->irq;
+		goto err_iomap;
+	}
 	rc = devm_request_irq(&ofdev->dev, core_dev->irq,
 			      is_revb ? crypto4xx_ce_interrupt_handler_revb :
 					crypto4xx_ce_interrupt_handler,
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index ee36630c670f..391475d00bdb 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -108,7 +108,7 @@ struct crypto4xx_core_device {
 	struct crypto4xx_device *dev;
 	struct hwrng *trng;
 	u32 int_status;
-	u32 irq;
+	int irq;
 	struct tasklet_struct tasklet;
 	spinlock_t lock;
 	struct mutex rng_lock;
-- 
2.54.0


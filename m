Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D3C8635D
	for <linux-crypto@vger.kernel.org>; Sat, 29 Aug 2026 03:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787975987; cv=none; b=oZ0LMppQmjTZY1MNGaxE/TY57MQ9jDqaK0Dc/6EpOlR0MvSkGyBwOjb7LYe3t0bkxgi+PY1NcyKxbvICW8fkVtHZm/aRQueFzXOPBLUzIgvz2/sx3XmAuEzo4S+MtNI8GVDZXXMcGtW5Dd6iNjlkf2kcUI/8EarfXEME/BoxmTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787975987; c=relaxed/simple;
	bh=rzJtIdLT8UA8L588NMG94kUUnaCb9UBM2MX+0o46NKo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rk5pAkNxDPB9uUA4ZcSMNps65FoAuwgCYggp6LA9aBpuVcGx5ISP44x5HGZXnl6Aa5jpA8JQMCHju66UNji1a+u05nyxxSWvpmrQ7EXAMp4+Zouf4cfyGZPsvIZTAy14gQVUIt/2qXlgrX9Pv5D3FiYuh5Qb38I/srMjDZbYCpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eHV+VNBG; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eHV+VNBG"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so15723485e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2026 20:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787975984; x=1788580784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TUlNGUgQY5khe/spcmDkrmv1B33pEeDXrJ5iK2i5+wc=;
        b=eHV+VNBG3Zs9Eng7apvvCq2tCRnC5t0Xp/UY89sAn5Jdllbu9JWkhQK8CGIJca4Dtw
         mBPBzp4DgunQhS3JL2W5g8KBtzPk3M++NmTRQcLud7AdHtQ7ebLjRBJ/E1lB7fQRFJWO
         Aj+umnyB6EWc9uVObEGHVEZqZseAlcNZx6Jft7NDQetLStI6o9ptDD+I6106aeo3V5xZ
         FPDMizYiYKeWAzwJoRoOY5HRsET9E/zbaVxhyWtjBhOzfZ4CICzEC9R+KOiDBuE4S9xE
         YA9/ClqQ0MAT+Uliw3vjgYrBP+LA7ImIS1039+/SF6mDIW+FkOazB7XS+0otTY/x3CtD
         IzRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787975984; x=1788580784;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TUlNGUgQY5khe/spcmDkrmv1B33pEeDXrJ5iK2i5+wc=;
        b=IKCzBGUQ1hynbV73XC8p4cAFJ/QBEnrJ5suum1kxAdzv75aevKH2+YcDs20fL5EPh8
         uYFkHAXK0v85UoFb6M3lGpCY+F6nyoDzJbLS5tAYMxvN5pwsuZw27rAC4sw42uRqmXZb
         kTeqmnrfr6bzK6mQ3XFWhBRW/7J4OY6ttWXHiFkY7v5Q+t7CJyIyQeK47TWO6yuOVUXl
         SVAUDQVa25dZZQ02WsnVKIJB7ThkkPZ8Yfq+xDE2xnj87vljoriLA9j7m6yDTjpAXlGE
         u3E3cPOX/afvAelglEvLkh9G3sMYI3xyA8OYszZLphU10R0apts1l0LazdJ4bJoyC22g
         /uFw==
X-Forwarded-Encrypted: i=1; AHgh+RosnfTlIH9SnDhXJ/5F/Us1gFDEQohDgkW0HAs9v2DaD/l2sxcIRSSlXqHtkpFaHySz/0n5luXFFm7WUto=@vger.kernel.org
X-Gm-Message-State: AFuF++kf05X8AXs8S2izs9fTPeE2JjPWMhFFA7N1Rr6154I8GYLs4h87
	emRsSSIrg19roUeFGE0vjqAen3GdZLEeR8d08Kx+k3jcwOzeIh9rGs2U
X-Gm-Gg: AR+sD11ZtgWxAj2M+GBqjKYecy4383gg5oBy0jzTnOHJVxzkKfIkLdMuCth6yCIA+Ui
	q/S+pTwhv3nXlDYJGxTjpNTY+VyPZiwg4cqHW7C92EoH8k1FgRTo4ox4Auu+C5qMjy98dE1jo/R
	QigQ8vfGX1i9VyeP/5Cj5MaapqKnWY8CpGs8a/+r5GmTMH5qtGemWHGbd1mTwWvv2lrtLKq+5E7
	+mYESHp2NGwv8ceAAKA04EyaLbr9Pg1iUi6ulsfw1QTpBNz2Iuz/lsJeI1kOPemId4E4o0XulDy
	xgyZRfvg0L4yZ/M3umsnnLiD3nml3OaKWWOGsZJoMbnyPzMnxZFyb47VRQZQpiGNpxqUzSHik6J
	NcLk9g8RaqECRbesXpuXx2jRGPLcsM5h6VZdn7/2cKzUDiqKtY6Z6G0K94KrIItZIDSVuVYjOwT
	tirsSjsy/EhPYtmNl7jaFLmOTjiof/Lfflz8SLvdL6H6lZiH8G3R66u2OmGNV52PAOvfZ2/TH7z
	vcDFi7u81kQQPuoV7qVzUEIWe9LxfGq4BMcI2dyQrwfGcWChW+2AELLSefELfbHWOlEBxRui3Um
	hc25r8qbiFKnXdpFj/NN
X-Received: by 2002:a05:600c:1c0a:b0:499:51f0:a9b2 with SMTP id 5b1f17b1804b1-49b91c1dd3fmr176903705e9.1.1787975983850;
        Fri, 28 Aug 2026 20:59:43 -0700 (PDT)
Received: from localhost.localdomain (dynamic-077-007-015-136.77.7.pool.telefonica.de. [77.7.15.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b94dd2517sm100738355e9.7.2026.08.28.20.59.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 28 Aug 2026 20:59:43 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Pramod Gurav <pramod.gurav@smartplayin.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-tdes - zero-initialize device state
Date: Sat, 29 Aug 2026 05:58:21 +0200
Message-Id: <20260829035821.67220-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of
kzalloc") accidentally replaced kzalloc() with devm_kmalloc(), so the
device state is no longer zeroed.

atmel_tdes_hw_init() tests dd->flags during probe: a stale TDES_FLAGS_INIT
skips the hardware reset, and a stale TDES_FLAGS_BUSY makes
atmel_tdes_handle_queue() treat the engine as permanently busy, leaving
every request queued and never dispatched.

Seen on a SAM9X75 Curiosity: the first TDES request after boot never
completes and the TDES interrupt count stays at zero, while the AES and
SHA engines on the same SoC work normally.

Switch to devm_kzalloc(), matching the Atmel AES and SHA drivers.

Fixes: c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of kzalloc")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 drivers/crypto/atmel-tdes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index ffea1db74651..2756dab3f4c7 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -933,7 +933,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	struct resource *tdes_res;
 	int err;
 
-	tdes_dd = devm_kmalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
+	tdes_dd = devm_kzalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
 	if (!tdes_dd)
 		return -ENOMEM;
 
-- 
2.39.5 (Apple Git-154)


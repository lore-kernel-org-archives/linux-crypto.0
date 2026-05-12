Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFCD3A5457
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625854; cv=none; b=ebaaxcdvtO9QmanB9Ysi4KryBNqOuD7B8b/JKlCHt6aZ9zqLul2uXtFiKJf2ICngQmRSvedlAFdlancloRJlzjSdDWIRLLlqDEiVBWIIc+Y9rSkb10j4xLww/gUd2fAmUSfz8cO4FFDfIn9Cmw/r+Xs9R2qZMUabkVjMjXSNyWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625854; c=relaxed/simple;
	bh=PPl0u8i7CeGWGfwyBBjG3tIzn/X8jFNZ9qbNXXig3Ro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dS/AozOHN0rFajbieuTo2h2xQJmmMfbrRVJBKfXJuhdNbjrS7fOhi3/JFVbARrwrlKmL8dLIDKbaPnMVIKAqC2KaM+aqgJsqw7bYzOLHAQsEnf7rYYEhUaQM4VpHiofOVn9IoHvtSvNYe/w8IQlCZrsLR1nDI9VXrMb2yBH3VPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZM7vzaYr; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZM7vzaYr"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4462f8d2488so334696f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625850; x=1779230650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WoTuR9u/S7BS3l0dt8ueu9k+dX7v2fjdA6MLehy70Ow=;
        b=ZM7vzaYrZD5cL0kVJF4rL7vpwpv4ikLl/wtgOnKlp70kko/xvlT8FLIQG+5/7tJ/5r
         qAZF/7WtXTgIjqudNlNFVMXhHOyIbVmKf9du8UC8H2xxkgEMToebqc5PIuhaxgQwHaz5
         bSqIHRB40WGqRQ/esDo2fDc6ra+JrQBSUrcRm8RSe7Hw6SQZklSZzxgDpZ2G50+eoUqh
         2h1fZuSBYLJi3iOGUEb0o4JdKawqUrsde4FsbC1zzV5SIx5dOcAOAtBX8sZ2RX48tGKM
         t44yW13vWWm6DQqd5IDIsnLZqL0cUftGUWmHQe8+35e5E+awj+fLQGpE7/UYabcy5K+c
         1OTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625850; x=1779230650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WoTuR9u/S7BS3l0dt8ueu9k+dX7v2fjdA6MLehy70Ow=;
        b=JjOunYvGLToMzjq8s/Wg/U89XuBvNLdC22crk5nwmoTpWj2jvfxyhy2x3o/LnYOohl
         dIk6F2aN2vjdMjMamc30nNu6T/uEMa0SdJ3+G7S3tRwKAgGsoMStXB0DcjdLaUo2p0YC
         vyWJoWg6uBs3noQS5BBk0SZNZIfxXy0rTEpBljX0XN93ZIcHxZEPaS7fq0vvtwX6HA/2
         w+8ZC84m3mx1YqHk8AmNOs/nu+toQAZ+G4aWanCiGu5u5Os4PfwMVlsFs99dZ7jr854n
         H0cpTpyEVadxdDLyErgofGw7XRno6ZTUhKrCpqjZSev9+lTNYN5T2d8R4UEG+H5p8EMw
         flvQ==
X-Gm-Message-State: AOJu0Yxs78Zy3KYYgezvCxbSTfERvRWLqB9V4+muKHSa3i4rHFKFCXkW
	hm8r/l/Il6OfXIhl80dYiJWuAG3j46baazXGJ+Utj1M8qPpnA87T75A1
X-Gm-Gg: Acq92OEx/898eRcqlmQwudHzZtXlxETsnDsedW/+pQxfc3jOgtxqCGZnh0OZhWO3TAK
	s/zDGaSr/w1zT2lzWMeWXWb1U/7wvr0BE2/ay5EBJ86dC5clgJODCkN1tgxw5d0lVGfCRtF6Qms
	I9n5D1c40j+xDabEJ/Y7f1Xt5sGVJCPi2IY21fGbucuGmXV/reJA+O67Qx0tmXyd+kg1eJmVHS2
	3iTurYRk43nO5m+TbJwFe45dOFtXXE8W0MQgsSrL9xf3omDFsEW3A8pdGmkDVNMWJHu+pSdM3fB
	4pUoc/8PWPoDK5G1dqg6R7aE6oXMliBofUW+WZYKaDgt6A4kVSBARQPLviXw0QkAoPri2632b25
	CdMgTfdEueMIlTO/Y/FAAlNEbCbCKIZ2khdDv13yboXZDhTHfvwu1l2p750OhCQxrhHyD/0BKrr
	ybztP5QFhRCSWw11NQtY0qIFpDAqqU4/nOCBLim87Cu+/HPdYpqUIHJt2qw48EiQ4=
X-Received: by 2002:a05:600c:35c5:b0:48a:797f:24f8 with SMTP id 5b1f17b1804b1-48fc99a8965mr6254295e9.0.1778625850432;
        Tue, 12 May 2026 15:44:10 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:10 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH 03/12] crypto: atmel - remove obsolete CONFIG_OF guard
Date: Tue, 12 May 2026 22:43:40 +0000
Message-Id: <20260512224349.64621-4-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260512224349.64621-1-l.rubusch@gmail.com>
References: <20260512224349.64621-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the CONFIG_OF preprocessor guard around the OF device match
table in atmel-ecc.

OF match tables are expected to be present unconditionally and the
MODULE_DEVICE_TABLE(of, ...) handling already accounts for
configurations where OF support is disabled. Keeping the additional
guard provides no benefit and only adds unnecessary conditional
compilation.

Also compact the match table formatting while touching the code.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index c63d30947bd7..0dede3707b73 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -339,18 +339,12 @@ static void atmel_ecc_remove(struct i2c_client *client)
 	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
 }
 
-#ifdef CONFIG_OF
 static const struct of_device_id atmel_ecc_dt_ids[] = {
-	{
-		.compatible = "atmel,atecc508a",
-	}, {
-		.compatible = "atmel,atecc608b",
-	}, {
-		/* sentinel */
-	}
+	{ .compatible = "atmel,atecc508a", },
+	{ .compatible = "atmel,atecc608b", },
+	{ }
 };
 MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
-#endif
 
 static const struct i2c_device_id atmel_ecc_id[] = {
 	{ "atecc508a" },
-- 
2.53.0


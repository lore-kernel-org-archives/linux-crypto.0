Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC9C1E4B2;
	Fri,  3 May 2024 21:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714770663; cv=none; b=CoWJ1WHwBU0hysETIXuthPG2gL9/m/dLkMmZNHE29z+77mzVyaZsc2YyTYCt95MncVUN8Fup3zxZ8FcakJ6kkTzTUX3JTRQ6APQDjqbKBu4lRFsQN0iP83nDEvOdyLmmSwhx0cXih4whyFPYev1SNumXg4MRpZ/zh46oFeM2gjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714770663; c=relaxed/simple;
	bh=XLdC5qn7NUj7ZNF45m9HMk56tLA1bORESFIZhcKt7pc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b6GBy603jJq33lvsuwZwr+XqMRhtbmF24mIDJ2ZkY3hGM3nyglv7EXZum4UHSCWMP+Bt6gz0PQ6gcxbKZ+eL7WNHatXiP3w9iXIup3hkmHTizzWo9FhOCVoU0BBEi1peIE5mvv0NUo8FzDQIFKJScwStnwtxQhRbavyflHhhBmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tb0ApT9D; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tb0ApT9D"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-518a56cdbcfso120436e87.2;
        Fri, 03 May 2024 14:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714770660; x=1715375460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9UWU2Pj2wFPOsyzBavdjQBrnHrxoTktVx14vmK/kvmM=;
        b=Tb0ApT9D2GtKPGjvqZM3tb+BuLRXRTcYNkkXzYnyhIv+vUT27kjryqnWAcIJD2YfUu
         723YrZernzmOkBZCMdFWl5IzghCat1bS9JA781sOA2ghpxb0SbLpqqADk4pMS8AR6C8r
         BjGegO4zuTlwe3hyDN7RsvqbQo27PQXaAgL5gHI0VeNbhw8EqABEUaCm0MJVFz8ByK9k
         XZFicStCTVl2uMqCHVyQFGwElU8PSf8LNxFE7lstipMtp4CDjt2wwsL2c2V0ILGZdAqz
         MsUA6VqVTCoFLZrk2XUd1ByiPamtbTLnfGKnpXttgGO8m72pV+egL1O4lS92NmwZQcdy
         WaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714770660; x=1715375460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9UWU2Pj2wFPOsyzBavdjQBrnHrxoTktVx14vmK/kvmM=;
        b=R1HbvFY4any+dPgYLlBwew6sW0sP4d5BKy5rO7xKn+HXT4lbEbJJn+EWdfFH2JNT2l
         FNgy0cfi3N4AWRXwLg0JGeKdf1m/w/YPRJBayatKM8LpTHJ/17jHkGm/DDJ0GypfS5aI
         PAXQV/FR69NLmEQRZMZAYoGI98cl84n+/R6iRy3PX2uZznHtaHrNOusG6TvrFYJrotJJ
         R1zG1eVCgLkIPWt+Ts0uUK2dF6Q6hHZQaVQrZSm6mfOHFaFogrze5sj5QNlWqLhRC/n1
         4sWW0zneZrORpRZYKZwS1OOuU8VOL/gPplygX79zXwq9R4bvxkS3BgW+eYmlF/2GGHhY
         2XVw==
X-Forwarded-Encrypted: i=1; AJvYcCWOtH5AQrCPTYLSWdA2zMNBNxvM/9Ea+HmcV1IENdkBwjwyt7k9Xjn4m1K1jd5pF49hzoxOTMlBSOoihGL35/3JIqS/VSniaFlmhIWUEs8s6e1Om7GYnbA0KP9qssGIIHZwGhanuhWHcC6D
X-Gm-Message-State: AOJu0YxDS3zygvWVxne/9r0eVpmChz3auDRgxRzq3hAYsE5BlXD3iXoL
	1TMaqKLFNXjOfMrPB30+dKBD/qQl4YdiMESNNJYFdCGYFSCuDYqr
X-Google-Smtp-Source: AGHT+IHSQxDQ8eUemresl9Z39QyNfJCgSf9VzmanaY47hjqfPs+A4iCrX+xpQtCza2tsN+44zftjvA==
X-Received: by 2002:a05:6512:6d5:b0:51f:6ab6:9e5b with SMTP id u21-20020a05651206d500b0051f6ab69e5bmr4280357lff.36.1714770659798;
        Fri, 03 May 2024 14:10:59 -0700 (PDT)
Received: from 58b9ec80ce2f.v.cablecom.net (84-72-156-211.dclient.hispeed.ch. [84.72.156.211])
        by smtp.gmail.com with ESMTPSA id jy9-20020a170907762900b00a598646f173sm1475948ejc.191.2024.05.03.14.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 14:10:59 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v2 1/4] crypto: atmel-i2c - add missing arg description
Date: Fri,  3 May 2024 21:10:51 +0000
Message-Id: <20240503211054.1231-2-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240503211054.1231-1-l.rubusch@gmail.com>
References: <20240503211054.1231-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing description for argument hwrng.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-i2c.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index c0bd429ee..a442b47a4 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -124,6 +124,7 @@ struct atmel_ecc_driver_data {
  * @wake_token          : wake token array of zeros
  * @wake_token_sz       : size in bytes of the wake_token
  * @tfm_count           : number of active crypto transformations on i2c client
+ * @hwrng               : hold the hardware generated rng
  *
  * Reads and writes from/to the i2c client are sequential. The first byte
  * transmitted to the device is treated as the byte size. Any attempt to send
-- 
2.25.1


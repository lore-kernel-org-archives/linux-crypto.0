Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884DC18A6B4
	for <linux-crypto@vger.kernel.org>; Wed, 18 Sep 2024 12:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726662767; cv=none; b=M5QVt1uM+zQXxWme0Af4Lg71PX+ElRses6ZdBenqQwOoBWibnRlsL3a/TBlz7rNdIgwUmVExpIDZM577AmlmDXhaBBoxPfYaSUu8xVCPEk9QsKx0boq+S6TTmi+wY3hAgcHmx4do+FFo/z2oeXjHpcBNXgg0iU2exb87F5+amfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726662767; c=relaxed/simple;
	bh=vKJnZkWWS80Qtmju8Q/9wyDHuf8ljsMViMpaXgjgy/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pThNlF8DUp2NlYUay4m8wNegLGmR+mUe1cCg4KHWKgV51/X/S2TE0PU4F0N8PfpsVGChPTFrojJuwR9hTPzY9zYae6kaais6DK8yOvYwEEpBHMi+7t03TmAWE9B1UoST8/2mfVTaeNR/sxHy+mIy+FF+RkMBbiGhJRPrjSGgcqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=2/VUG48w; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="2/VUG48w"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5c42384c517so6153278a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 18 Sep 2024 05:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1726662764; x=1727267564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hZhliqxgyY7Mq8AOL7Bnvj0uEwOcI/YT63YI4qZtzkU=;
        b=2/VUG48wos5nwvTghv2tYXSIhK9338T4qt85FGhCIK8kHweLkTIMk17i6uMUnFQh9P
         XcIa76XrLmN5OB2OyueeMQs05Jt7nWxVfZrF0h4Xr5dF1dx3c7M0Dc0Ic+snD3GVvB+m
         Ef8jnXRiPzclW1KGaXjlYEbLM1g07joZ4aFMS4qv0JNCymyO4KMwkt3dJ8hc5r/4T+54
         QTpKyW9l8RzBBPDO/2e/l9H6kfWU2wsgkrsF7U10DFOxFn0SYpga/1FlW+sulRT0/HXM
         H866GEKeIG02Qfo9qtx5D7ogKurPG2oLdtDf7W4GqWD7j5oPU2BjA6RgqFFLT4P3P3q8
         qMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726662764; x=1727267564;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hZhliqxgyY7Mq8AOL7Bnvj0uEwOcI/YT63YI4qZtzkU=;
        b=fpYY2R4Lfqm0q7giXFTFhqqCs08kw3PLwMvIPtVR/SYP8pgMGKO4vcVXnAEzveNqpY
         WtGUtGe36T0A2kV151WkIrZj9wv9l8UerHcwgLL96LrrBhARpdN5IsngCNdNltB1Gxly
         TjkQjV5cnIe0DIzk6/6c7aQ91iPRP2uT/MScROipxmKkqnPdIUtaj+wWJaU0NVU3ym3S
         d3YRPbMDmn4hNratfESrZ/+wirVAsOtHDkP/TJMMExAWo9Ey3OZT5CwKbnBSflPKwJJq
         uyiiH2cUo4S+EoPBFYqtON5g7zAMrYPgjKUQBQ0xQA0QaiZ4kEC5nE1qBE7YkgrS3n32
         vgGA==
X-Forwarded-Encrypted: i=1; AJvYcCUTJBvcFty8znI7hl4k1c3Mt4/sj1A38g+ZVuNjHFpr85UNB8OpdbOAKz/wPjClDfLVw+OzK9Y3+e8H1x0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyyc3EJxFS5VtyPBwzHcFCONvPdxkZPOLBupDPZK9x1OB8dfmWk
	bdWNWNwuenHLtjYFeHejPJkIPBbIAHdgPz0KNUflwtWhZvDBiWYuYwiet/sYdK8=
X-Google-Smtp-Source: AGHT+IEEDVpwRhC6Scvjb+H97Br0hyyr92G4Ib/fmF+/0i4P6aqXZzcuKxCynYAv7kEBWVtqeg7aiw==
X-Received: by 2002:a05:6402:40c4:b0:5c4:23ba:95c4 with SMTP id 4fb4d7f45d1cf-5c423ba9733mr16448765a12.9.1726662763852;
        Wed, 18 Sep 2024 05:32:43 -0700 (PDT)
Received: from localhost ([2a02:8071:b783:6940:a2bb:f619:b5e9:672f])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c42bb89e07sm4851775a12.76.2024.09.18.05.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 05:32:43 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: Drop explicit initialization of struct i2c_device_id::driver_data to 0
Date: Wed, 18 Sep 2024 14:31:52 +0200
Message-ID: <20240918123150.1540161-10-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1525; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=vKJnZkWWS80Qtmju8Q/9wyDHuf8ljsMViMpaXgjgy/0=; b=owGbwMvMwMXY3/A7olbonx/jabUkhrRXJ1w8dDpM8y8z5jDwORyTZn4WmPqhwennjICZHXItE hlHjrt0MhqzMDByMciKKbLYN67JtKqSi+xc++8yzCBWJpApDFycAjAR5kfs/6smq/sGl/Xlab2J sP/LE3yI1/l2v/WrgFcqNY6m7/wXOBn87Shg/NEpfd3IptDEe0HP8Xu3kzi6z62JFXjxlimp71w hv+7irQ+SAxY7pN1fdXtVblhl88520YW29++c2++2SjBoq8/P9OKGjcyml6KUtsXammo5JH2W4P osJDJNr9RtiXyBlMRGidg4xgo3nmXmSWIbzdoT9Nm4Zt54Z7BQz3+nlFzmqqeKr34ceNiUqHO0d lVRMNPeHl/DJ5G220/k2mn/O58ky/Yqmpml/TVT+ByNgGa1LQoLH/28nlK51LTY0tyH+3lJ9IPf +tlej757Bt1O+rjj2ORfrP51sWdF0qynXH/64+vGaaEA
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

These drivers don't use the driver_data member of struct i2c_device_id,
so don't explicitly initialize this member.

This prepares putting driver_data in an anonymous union which requires
either no initialization or named designators. But it's also a nice
cleanup on its own.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/crypto/atmel-ecc.c     | 2 +-
 drivers/crypto/atmel-sha204a.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 590ea984c622..0d48e64d28b1 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -379,7 +379,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
 #endif
 
 static const struct i2c_device_id atmel_ecc_id[] = {
-	{ "atecc508a", 0 },
+	{ "atecc508a" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index a02d496f4c41..75bebec2c757 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -202,8 +202,8 @@ static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
 MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
 
 static const struct i2c_device_id atmel_sha204a_id[] = {
-	{ "atsha204", 0 },
-	{ "atsha204a", 0 },
+	{ "atsha204" },
+	{ "atsha204a" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);

base-commit: 55bcd2e0d04c1171d382badef1def1fd04ef66c5
-- 
2.45.2


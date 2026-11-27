Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780882;
	b=WLQYTM59goGQXMA8zhrbbyAf77PbzPpTUVzS+cmf9c6U0H6ovFs9ORbsP2HJechtUJk9
	 Nzn9ZnJWWninkJQv0Pa7VDOMooXzu7r/i1SOd+L2xwd4e2ggvYpalfNwY9t+hB3LiYD+w
	 evlQfJPHx3jdl94uLNz4i8uOiqCryZtkGrq/Ursc/kswc4ac3+qQ59Qxr0b8Eox1gxJO2
	 NzQRPp+6RGuHQXk+2n0rXVx0sj6YIaLldmANXJmvKoFCoIimSXzCePWBPbSJV+UZltnFw
	 iwt5Kxai6sm0ToRIGemUE24P7dKsyTWqM4OqEzmwGXNWnLrKv6gYMndUqXxKvvVmjrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780882;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6uthyLmx54eP91qPBkkIsXEHnEP4gw+2z/PB/gcG1vQ=;
	b=27toXDMwwaux0gOMmuXmzh3/jiQThP5V2BdwwZ7kWhB+qwAFSlGzjioWgeQfkhHAf545
	 93Q3TMrGXTmdx+m9dzeurMMwkZ2IJrC9G1FF5ySi+bLc9Se9bLcwhrZ02we6uWIum/lLt
	 HL9uCeOXu2o5FiatltJCyZuV9W8jTAyHS2k4qsrm+lfyegwkcwPzSt3Ivla3ZOAoMjDMb
	 jpvHaj4wYyyppnCSjhwzJCEV7jcXR5zoxIg81Ff8EwUb+RIwiD5vtt2XSiwNP39W7JluL
	 CPcki2iF2UxlYZAOYhYUiT1ZMhWN/WxnQ3WcxNZnIa5p8STw7m4gQ7/ixBU5cDrf2SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Gu2pB+Oq;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2255A606A32E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2255A606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Gu2pB+Oq
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb64c99d2fso73489865e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780879; x=1796385679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6uthyLmx54eP91qPBkkIsXEHnEP4gw+2z/PB/gcG1vQ=;
        b=Gu2pB+Oqk0Y6dmVa2CurRFsr+jY4+1kweudW8DO6IY6fC07rnGQj7RX2Zh80o66Ttx
         bZpQfB4s+liR4aT5vGQ6jCaQn+UHHAzbTPlPWtyF/CGZuGasG35xzKhOpsxfNxVxEgL+
         mg6hVa7YitaZQG+ddP/czijC2W89IKLhYa7VccKXYe4j1RctwleUTQMxNtrAdbkw4iBm
         W6WDmtbZz/dDp3g++++FHcH7sRVc24OD2TlyYkztuLzTHVJTXAJ5tD2/qA2NLtQ+8JdS
         zHK/ZpPXHBQ2jhsXyK1rP/9wxGjF6HsDMSNSi/jSUA4cI58KvfNd4BD9GhkwfK8pBMDu
         C5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780879; x=1796385679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6uthyLmx54eP91qPBkkIsXEHnEP4gw+2z/PB/gcG1vQ=;
        b=kCzt50vS/FDE1NqJtq5KkqBrbcPKw4cqmTNe9+G5HDZ4wsjUPVoZZ2j94pxjG01F1L
         thMZdBs/GGTN/To5Nx9z1O+E8MzqqggOHBpg8Dta8OZ2QSqVQKJYXGfbaKQu0O4Zwo7+
         hodRUSLSR/6LG3NW1J/uCxxouUgj2sKeo3iy019L2jsXJBSUllH/ItvZrvQXwKnpSwUS
         fJdHdbmIKOGYqnDXk2bdiekwUVIWHNrL8s5+FY1bG1n9qQp4FDTE4wr4QjTA32JSmXGl
         PByJqST6UdGfQUvbnz+Ep11dV7pzM3PQqoQQJ0vjUIpcJagjYrT2BQqN3VquoxmdJAkA
         7Atg==
X-Gm-Message-State: APuU4Z/0VzkybcrRQQ4/Nr0b3LSrVP1GlcLxWzZyp7iZgn+rpxo0dsMv
	BZB7dRa9XPBSzGnY6Qv7wb7JSrRKHkB0thsrkvnVq21EEieq2bGH/w2L
X-Gm-Gg: AZFdTZcrL7tBQ/W+j4+mSTanZu1GuFXyO6gSPC1/WuFb3ukEidHovc/bil+JbMR64eE
	MpYZaJoahUYkmWykhjh7mcZOII7iDkOpk9NrnUjGj2/5zUl2wLLbmi1bC6WES9nyJl+/GNguev2
	+LL67RR769KomAjs+dtGBv2dtKFy4x6xTJFsunCGriVmsauYV+Xqe/052ns4XkKKx7rDNCBJfMO
	o7Npd0ouWX9+IQX6JoamWrh8GuXA3Y/cn5hHjrPooN674hYR0XoQR0h96FpGuOJDNLD2t0kAVXr
	wyYmZ6znFom3rauhSo8o0m8+sH4Y0+xlzgiaGtP0j4Fq062QIcIqT7t1rWPyiI46+VLVJOs2dtA
	gW4VqErAeS8aG2uNekAk3doeLuuIJjfAP8vkZ/NoMCbZXSGpEw/CddCXHDl74ea04BWAx2RQaC5
	CdOdl6e8XF7KUA4IduiAPDpP14Byljez+i0XpEWSx5Ctl1Cme5z6itS8M8ibMtF9kG+SVGbcR0y
	uxSLfsYr859CWhOqB0dYH8qXm4ZqNsMTd9FfioEMXrLgT+LEFeK20mkS9WVPvnjZK1a6cEXQ8VH
	UZCjSH2t1WPjLVStAUMsdfGQBWLp/z2zWSIm4k72UNLz6qs=
X-Received: by 2002:a05:600c:4f10:b0:4bb:60bd:5398 with SMTP id 5b1f17b1804b1-4bb88804d35mr550669735e9.10.1795780879108;
        Fri, 27 Nov 2026 04:01:19 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:18 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v14 05/30] crypto: amlogic - Remove clock input
Date: Fri, 27 Nov 2026 13:00:38 +0100
Message-ID: <20261127120103.1532882-6-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexey Romanov <romanov.alexey2000@gmail.com>

Amlogic crypto IP, which uses DMA crypto engine,
doesn't take a clock input.

Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 8 --------
 drivers/crypto/amlogic/amlogic-gxl.h      | 2 --
 2 files changed, 10 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 24ef7d5a5607..37224d75edfb 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -9,7 +9,6 @@
 
 #include <crypto/engine.h>
 #include <crypto/internal/skcipher.h>
-#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
@@ -267,13 +266,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	if (IS_ERR(mc->base))
 		return PTR_ERR(mc->base);
 
-	mc->busclk = devm_clk_get_enabled(&pdev->dev, "blkmv");
-	if (IS_ERR(mc->busclk)) {
-		err = PTR_ERR(mc->busclk);
-		dev_err(&pdev->dev, "Cannot get/enable core clock err=%d\n", err);
-		return err;
-	}
-
 	err = meson_allocate_chanlist(mc);
 	if (err)
 		return err;
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index e0bc5c39bf2c..5149dc6e9f60 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -91,7 +91,6 @@ struct meson_pdata {
 /*
  * struct meson_dev - main container for all this driver information
  * @base:	base address of amlogic-crypto
- * @busclk:	bus clock for amlogic-crypto
  * @dev:	the platform device
  * @chanlist:	array of all flow
  * @flow:	flow to use in next request
@@ -101,7 +100,6 @@ struct meson_pdata {
  */
 struct meson_dev {
 	void __iomem *base;
-	struct clk *busclk;
 	struct device *dev;
 	const struct meson_pdata *pdata;
 	struct meson_flow *chanlist;
-- 
2.47.3


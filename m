Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721589;
	b=dQEJ4kJG6G9UCV0s5zRMAHZ5mfD22gnjiIGw7IVGSPo5NRYSp05ddQid5H94TX+GcFUl
	 i0rLRHrxg25VNVJP5a670JdIFkv9eJcstQGYI+dHz6amnicfvJ+HztY/sJ6eKMTq8dJ9b
	 yxHRRvw6SuW/CHIYfeUsHI/MEzlUndNylv2Ya6BF2idbZJfjfG6YYmY7mNUOo/lTgXSqg
	 ofgIkM/16d357itSXN3/CeLShDrWLa17Iz6geoMepUPM+8VqujfQk0QoUi8H3+YQ2aT4C
	 T1irlmZtU58/oc6cu+MaUENUB0Z9cOqOOz/tbresjD6GgfOyxQtPWs3jolhqadVadcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721589;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6uthyLmx54eP91qPBkkIsXEHnEP4gw+2z/PB/gcG1vQ=;
	b=ZsItJswPnd0O1z4DQy1f93f3/7b6DltEdiCG8phHGvJiCGmIN+Y0zoMJcl7+tQNv4EtE
	 bdSqQTPtgxsR5J7hlxPnXdmWC2MWEolCS0HPjpwDNctJcyDG+HJlaWeJXxVQXAL/GWD+a
	 fIhCH0KTcCOJl+li0Yg6iGe3lyTzD8E6GI4H9Azg6tbe4y/Wi0RWakRZwdtDp5f2aDWSJ
	 h+P86PzDY4oqJEkM0Y+/8X/LneIXNL9Fw3TbJnEgiQNJ96kv8Z2fOkuz78JrSOMqJFQge
	 hLL1vK/7CwmE+WvfExQzmeqU9tawtbhxXtG52MbgT14kPGdVB4KwnkITJpBT1pyatPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="qp/xR+KM";
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416E1606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 416E1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qp/xR+KM
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-491971ac844so6550644f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721588; x=1796326388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6uthyLmx54eP91qPBkkIsXEHnEP4gw+2z/PB/gcG1vQ=;
        b=qp/xR+KMn6PiVlfwtym8sGxp4vg9UXSjfc/ep/eUwq1Zw5TrgQrRMvp4uK3T4ptcBz
         HDfcb+uaIMoJAYTe5PqBTEOLWbswacGcS920H1vlvoSxD2oY09LsW4IdqeRB7QyMo35+
         2hc56CzTlJ/4MzTvYhmhxN5Z+dHxvcF9RWKBTH+LavBJueIo8X5Oe9LnwdHuUanMvTXi
         jKNTB0LXEsgPpIw6WrJYxNQQJirlqcWP0+QTQJmxGCQU/nG+CSOrKuUFHpMNvIWB6/2X
         HwIjvqQD2dO4GEL6InxTZTDDMFPmPva0u5JVP2RwCbe9Jc1C0WSerIJcQyyalnhkxjba
         zq3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721588; x=1796326388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6uthyLmx54eP91qPBkkIsXEHnEP4gw+2z/PB/gcG1vQ=;
        b=XKs9LqlKy70rGtaZwk2adLGMYT88qtOiWpp0uCgdYgF8Dze4UTLdLcAFsns9IvDNiM
         iQMTRBGjt9eSfBvH7P27YKdNhdw77V3FBZKJVTtYdpKszSUoThnD+A9nWV4mwpkc+UIT
         fJbFqwyxdWVNQcBO66PbZnZQqdn4NPtp7M/XOKMcQhK9yo2w7IrGDh3m2unPC5/3nlTI
         vb0nU+VbIornTCiBtBuCDiYjPyzV+Gadg7RwLg33D/UCalpo9aiQmjYkTso1XXq607/M
         2/iBJ0keaMmnb66DxvJcWGSQMS63I6JaRr01A1L0nJxYIAW8d09rFktNZAHuftyEr//i
         ypgQ==
X-Gm-Message-State: APuU4Z+Gvo0y3ZF9FGPV7Nc0L8Y7HpBeD5D2GyfcTzHNEhJDHRBJkfom
	XvX7AdYVh5wH1QrwND8kTrmoAqbpQ1gcRKY8v6p6+liY5Tb9l5patDPN
X-Gm-Gg: AZFdTZcW6WilC/tBoifvYl34NbeHKSYwyOVgehT1sFq6IeJoym4eABXgtROXIzz6SOP
	0TJOFhUmHle7hUQ0FiUh5DlnkyYTqdQGOeP+AWgLdKapevtnet3BCiJYmhLCUTD1nnqXgGXhhzv
	a0LQnqgH2CGWacNzmNXmz7a7gpi2AC0gLgdfuXb9E7MoxLqeAsa4O22NyWpnsTyHZjvEY5mE98I
	ON20XzzzIQuoPs2SzvjR3nwxpQR+uedKXVHTvkZ447SOZjQMVyxIiouVgeN+Lb8vnffQzqP5/LJ
	nYxbqMsjMldQ/vewvQS+jRZilKzT/p7MlfPupGi8mUJ1BKP6xyPLKBaPZyXW4HX0Rbv7YJ7in7y
	BZ3XPocTUtqz6v0KKO743TGcJyAANeTot3ag56ZKwHen7Mp/ibJJxtWx0/Rd8qHVlRL4CAjBaxn
	CTmA8aZhTujNfi1dYZKdNhq2Kq5w8JEegICojywu6i2xmQyVqPpRzAaIXBDxM6acsTVLnml7xTG
	MhzFOA5l2ekZkDHZ5uuWZ8K7I4QIKTe9VFSvKc67ZoqYwMSDYiSMynUNST8QcrmBYb9AByzwDpb
	tmjPSAA2qRtKf5DzUSXK8egmkvdMqKsAZX+tHNMcH81NKQ==
X-Received: by 2002:a05:600c:4e0b:b0:49f:e772:6ddf with SMTP id 5b1f17b1804b1-4bb8881ae90mr457062975e9.32.1795721587613;
        Thu, 26 Nov 2026 11:33:07 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:05 -0800 (PST)
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
Subject: [PATCH v13 05/25] crypto: amlogic - Remove clock input
Date: Thu, 26 Nov 2026 20:32:21 +0100
Message-ID: <20261126193241.1471372-6-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
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


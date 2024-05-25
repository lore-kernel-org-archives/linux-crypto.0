Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DCDF9F8;
	Sat, 25 May 2024 19:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716664963; cv=none; b=kAcpzvWrY75CXW2gjoHsJSnlkcLm71uE/dBuBM9WXU8J7XVWIPv0xAaSYxLs5qkmjefMLDCVOT1+NIQoTIggt0JncY3QUh3vqUQ5ku5iwrcY6l8NZX6PxkCN5czOLaZKePBARojGcdHbZBsSGbNlbyofBrk7JdrIw4Q0jMDAdeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716664963; c=relaxed/simple;
	bh=vwCtoMW69UqvD+dOVlS5VBtmZbwRY8k0dewgj6oIEkE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aJEwKkfqXaCaOhjlDEJjdbCnooPj7cMBcw8K6OTOTMDHZHZsBGIP8Ovc6hU8xgwbe1mD8pmoQoBzI05id7sxQa50mu9oZi9Ukh2OaYxJfMAg2Avj1xiB/eRdBKHmgbqshuF4ilXulAKqbjDJ0wXlTbWiv6w/bl3SwN/Ty/tYWyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J7XoaV/J; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J7XoaV/J"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4202cea9941so72973465e9.1;
        Sat, 25 May 2024 12:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716664961; x=1717269761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L8MCPhQT7noHqmvmJire3u4Gi4h4yWWwXkiOGYuXUaw=;
        b=J7XoaV/JdfVcPDTWasKj9KJrh2NziiRUVbfmeiSxe4MW/SWoLE7mxGJohXkZF+HPeu
         yLMUg1NyszjpdF8SoO6Ij6lOBCYMOGiLjfUjb++PWExXniXXnum9uBCQ+IxRScHZGlhn
         5GS81rT1I7Axnle5PvUPzfKdJ39Or7l/thKtSNxi7EfrMbfOKzpUiFBSlPer3CtXjlce
         adxGftrnhzmQBkJYKIw7urepJmMGLOb5CosjuoQjp0d8VWXXsGA+ORSubqPTl2z9s6wi
         XZ1gQx7oJ14S6VlA1fd+lppUTlMxkLCkFj171Amt9FiIQuNRB2CkTIZESVNBLxw3kj/H
         X/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716664961; x=1717269761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L8MCPhQT7noHqmvmJire3u4Gi4h4yWWwXkiOGYuXUaw=;
        b=Qeusq18t7K17R1ZKtdr7n9seZZ8I3wz3wnrwXlKOQiLDv2SXFP6Rxl46uHAEc6S9uT
         bLL4z0jktCRakMjHTUNaxIPcLt82S0TKw2hciek4Ynxlo/4YmmzBKSFdoMuKPu4CbvWf
         vhf77hHTPk2fXK8s6QsZTUjTlXSsxYuekslBDIXVYdEuHwzYkyIzvBoZkbM3IgVtaSiy
         8oEQ9OkYOc2TmzyQJwcrb40EMHQ+IXIx0hwK/Ofr2J4E7RST40m2BjlwkVPiBwMN2+6E
         zejv2dxuIzBg5jkJUZykQ1HxjOtyFnL3CqtravjVVegmA2RxjCpXqqhR/0J+AyTD79Jl
         Bm4A==
X-Forwarded-Encrypted: i=1; AJvYcCXcyBa8jDgKog/xfe72VprHFkf6b3r9wOYSvsNc5cy2UxdpXpIMYbZgjfXRsWjO/Pyb94ontxeZiZMZbWyfk7mA99jAJX0Cxf6Bt9E5S2U8oZGBjWZQ6aRpLuTjS0KN2Iind5TWyYM7rxaD
X-Gm-Message-State: AOJu0YxRY1v28KMoJXcc8SRZztZaXkZ4V+vQGaYYcp9yULZHKlBu0xC+
	TYAzvg28FTRsb1X+K4oJSwJCoSn0PYwD7M9uq+djSdNRzbbXx56Z
X-Google-Smtp-Source: AGHT+IERkIy03icxUl2SODD5nZiZYFnyNluiiiPPa/mCUEkjdVytK3ca57JQ7MWLVkgmDZslBTx2VA==
X-Received: by 2002:a05:600c:295:b0:41b:da5b:a60d with SMTP id 5b1f17b1804b1-421089ec277mr48325605e9.6.1716664960374;
        Sat, 25 May 2024 12:22:40 -0700 (PDT)
Received: from 4728cded2e8d.v.cablecom.net (84-72-156-211.dclient.hispeed.ch. [84.72.156.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4210897bc02sm56661955e9.22.2024.05.25.12.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 May 2024 12:22:40 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: dan.carpenter@linaro.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH] crypto: atmel-sha204a - fix negated return value
Date: Sat, 25 May 2024 19:22:37 +0000
Message-Id: <20240525192237.9837-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix negated variable return value.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-crypto/34cd4179-090e-479d-b459-8d0d35dd327d@moroto.mountain/
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 24ffdf505023..2034f6031518 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -106,7 +106,7 @@ static int atmel_sha204a_otp_read(struct i2c_client *client, u16 addr, u8 *otp)
 
 	if (cmd.data[0] == 0xff) {
 		dev_err(&client->dev, "failed, device not ready\n");
-		return -ret;
+		return -EINVAL;
 	}
 
 	memcpy(otp, cmd.data+1, 4);
-- 
2.39.2


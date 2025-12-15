Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072BD3376A5
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 16:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765816736; cv=none; b=KPv/G/HA02oqQ9QwtmjyhfkJTYyz8UqAz1bCJf169+U0xT+TSxc1eSwezdJqTS08MU1a7KMzOrECZSSI0tWvfmjekc3xCUu47zAbV/z3v6+yy/JtRxlt2n5q6SsspUMvT/LdFkmMqiRI23CCgfCwvaUakxkRt5ytaiELE2x7NiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765816736; c=relaxed/simple;
	bh=tveRsbPZXzZXhM+Y4ZL/xeAZhYPJspnG2nmDI5Lswyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iigeRaecsSwVw3/U+lDDX51YWQ8XO7AXNCpshTa0kfSAUb2K3ivNENQqsaRD8sWeFBm+WUV6lzOTuVkKLnW212XI2CIHWi/WS0ettVGPfbxhmMHb6e3WVIQKe0W/4cYm08F70hm5NpGus8RwF2/YLI2oPIpcdM2k1MLshGPBfkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=TIMTbnL5; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="TIMTbnL5"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-477aa218f20so24301585e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 08:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765816728; x=1766421528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0GXKAmimvfw8ijk1jKim17aNEIYNsEIF53cEg9wyafg=;
        b=TIMTbnL5Em/KH6EZ1AcGswOTA8nTJvUHKKm2Pz771cI9CVZvlCDopkoqTAva50aEqA
         VAvTMj14W/P63wkCe6DJS/XYIr//ifvfGpzvvw75fSuf45b05uLOG5DOs6HVtszdnv9Q
         OIUMeF9yWoqOyIgcdPi0ZMEBbNuYljd1ptw8AU9xi7TEhisDZdScz0eHTCfMc7x9wXrt
         kpmH42zqbUL5cORxpDZr0pbZx8mEZox9sb54O2O+K9r4/kbOTj4S6RYajMGwfNIXAdd9
         Sgwghwqcz8imo3Z7cjI4LtBBTMVjsidan0IG4I0hZQVfX4VGYq7t9/5kFtSJMPJpi4OX
         UULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816728; x=1766421528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0GXKAmimvfw8ijk1jKim17aNEIYNsEIF53cEg9wyafg=;
        b=dhZIhmx0u24g0OgnkuhMmP2KcI6cas1fa8NUX4Se/w0akz1LSQrV6WxOvuYW++QEbA
         g+Dcew2qlFc5lzsFlnhkut0Zz03res7J9k2d4G86WIdf5TMl0yxyfvqO/8lR2f7A1FXQ
         pO1P907BF3+wgqycT+VudXRgQd4LqsrsbBg2//KDh7Pu2phIYW/N2tSib1GuFk5P+uKu
         jQZZjLGnZ50XlhlRl/Ytz/UmWt0B987P7ne7ga0LAqAzx4wtTgm3WzksudHZoev43f4F
         7+x95LoNPw8dr7wIszV31kO03R9EPNa1xVlin3JQIDKrrmKEMVNna51ShOm2hvOnlqrn
         XwOg==
X-Forwarded-Encrypted: i=1; AJvYcCV4TjW79tbS6Ye2BFzFHdfQ36xa1qa9GWJePox44r+elsCZ6stjyJkX+EkHp5NAGFWHTW4YJ0j1T1kbdkc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywul3cUGF40iNzEBqzgmNgMpdKJ4DXGRo3/eg/JcvF8CDqoukWe
	aC17F67il7SExo1U5E1TtfYvdqGF0KhLy2ZBO+Dakz3cweHQUwIwhHcyAyS7XN/vUNQ=
X-Gm-Gg: AY/fxX4hQZu43V8ENs7KTg4W1yyrXLTtTzHucgGvBI+nItgihNhXx562ZVECsCtqGIb
	W2yuaWpEdlXyEfgmsCsG9pni9HS7O7IbwOj4+NSzyLcAU8/RKdFtsBpVWBCPh+GSiaSJZDVHhpA
	qdCs6BKveBUOlJoIlPsdiZU5bClMsUpVe4CZ4Ae4Kr3brl1sUdX1ehx68RNY/AOQH/bGTspx+5n
	17Ss+04uifFBsnZHmRgMXDzGMwz9v1akFKKQ5ZBWCoFV6k/4exdy0EotNTR2DJwamIR4ujxDjmv
	Om8GQfd1fqMrOmia6mKu3fvO0qrq28p8Ku/xVYBwUtu42RweJu5GPmBrFOIfIFqbmvR1X3HYBhW
	g4XhA4kKY6xl7Z+y5CC0S+PKXdwrrleP2eeexc51HcNOOailyc9Xbz+y2mZBbUQWZFIbb52GOQA
	wdg6RnNNNgClakHrmOhh6R+wUVfNT5Bea6YAEh3nZNhEkjRVu1+iWUINs=
X-Google-Smtp-Source: AGHT+IFkqZliIsZtRCNZPvKJ2k+bwRt8m/V9TgUCZlXWy3Yhe4IyvA99Hp8H08ozBRujUcKubFPJwA==
X-Received: by 2002:a05:600c:524b:b0:477:bb0:751b with SMTP id 5b1f17b1804b1-47a8f90d716mr120031825e9.27.1765816728371;
        Mon, 15 Dec 2025 08:38:48 -0800 (PST)
Received: from fedora (cpezg-94-253-146-254-cbl.xnet.hr. [94.253.146.254])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47a8f74b44csm192209725e9.3.2025.12.15.08.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:38:47 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com,
	UNGLinuxDriver@microchip.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vkoul@kernel.org,
	linux@roeck-us.net,
	andi.shyti@kernel.org,
	lee@kernel.org,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linusw@kernel.org,
	olivia@selenic.com,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	mturquette@baylibre.com,
	sboyd@kernel.org,
	richardcochran@gmail.com,
	wsa+renesas@sang-engineering.com,
	romain.sioen@microchip.com,
	Ryan.Wanner@microchip.com,
	lars.povlsen@microchip.com,
	tudor.ambarus@linaro.org,
	charan.pedumuru@microchip.com,
	kavyasree.kotagiri@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-clk@vger.kernel.org,
	mwalle@kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v2 09/19] dt-bindings: i2c: atmel,at91sam: add microchip,lan9691-i2c
Date: Mon, 15 Dec 2025 17:35:26 +0100
Message-ID: <20251215163820.1584926-9-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215163820.1584926-1-robert.marko@sartura.hr>
References: <20251215163820.1584926-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document Microchip LAN969x I2C compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml b/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
index e61cdb5b16ef..c83674c3183b 100644
--- a/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
@@ -26,6 +26,7 @@ properties:
               - microchip,sam9x60-i2c
       - items:
           - enum:
+              - microchip,lan9691-i2c
               - microchip,sama7d65-i2c
               - microchip,sama7g5-i2c
               - microchip,sam9x7-i2c
-- 
2.52.0


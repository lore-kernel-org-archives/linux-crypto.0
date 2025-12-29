Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72263396F0
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033629; cv=none; b=bQ7Gl84r0IJ0NrIAQ27Svui6+cuTepmaPEWN142SD4qvll4mbzWZ1qI8ySSuSBIx9hxuC0J/JcHTWYwITHpwhDWVhCEwhynxf5AidogQk4VpPSwdpcz3W/c2D73PrGRGdn7W57avXaoyuaESL299nns/Dbp3pjfggSZxRo4nNT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033629; c=relaxed/simple;
	bh=FesjP41xiT0Kda2nCLhQhKtJNrqGgysPl3yJ23vj64A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJlthnzxZjlGdI/jJkOuG27JbqAuYRrlqhRO8ZISCnl3yQEDU6zOaRZA+OBT0FcXb8DaH3nD4OnIrFkhg7muxSD0IM/pLVme3lE88J4wNbdUxhXuUCSiXKhsGVAo1V/86wzbSiIwkJCGZOCvMByOXGsIoCh5rlHAgDtRoGiZObg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=LxExKaDF; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="LxExKaDF"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477770019e4so78728755e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033625; x=1767638425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ClyoGQdLbQ+NSakHU5SbIxGsiXAmeIUAvdUGZfMfHas=;
        b=LxExKaDFv6uraKbr+yups4L5dBCWndQ+BVeBeBthUnl/mH1kB4Ls9qNN/M3IYMPAeB
         7kliaa7Cr3EJ8W5qDWd9PWb+ZEaXk+HiIoJyIECYHKmRu34OFvZx/eQumReZG/4jfPVs
         ciQ8mZnqyCEXea8WhUxwJAkOL6ARc1YKP3d+MpkUSl8kuAd7McX033YEB5aETP95086G
         Smo1X2VH+HzwgbCOwr0Wqkyd2ETC2NVtxkCG7MV+59lO6D5d4cIjBoaYzPcHP1mfv2rL
         QRf6Wt9KFjJRrMVVPHbUmfwIZMAmyrBtexsip9mnS0FU/TNf8Mzcx4Zc67iLbTlJLTqE
         oS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033625; x=1767638425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ClyoGQdLbQ+NSakHU5SbIxGsiXAmeIUAvdUGZfMfHas=;
        b=AYCueGq1c6XzuPeeOo+PU47cLD+ieL9EaEzP6oKmFUg2wwUVLYSiewA3HXh4nP8jbd
         J7A/APrDpUZTV2gWmFGBnUarT1uveY3n6S/BH8ez5ID+h5S3UQVuz1cO5N9PH9FXP1p9
         Bb6xAbyf7+78a2zFEX+QvfJrW2u9oqDrX1tZz0C156jXlSbbkfA7NmStcKR0X5Ba64q7
         2XKlqcwXS2CF2F+vg+5L7SQgZFdwfbNQdRbzrRe+13iK0kZegJbObhFY1iMc02/HNEzQ
         xOdSFYSKC1id4XL7BmlyJkV1cFixrn90M/zDJDjpkAuZE2RbgmF9c9oSLiV1C+w+NtrL
         FYTw==
X-Forwarded-Encrypted: i=1; AJvYcCVa4tC+A15on96eLL4h8FJfH+ihpQ+NRMB47XXfoVKc5z1iebQ0YMc8kwnpnkncD60Su3DmOQyjuGKxveg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVezK9ziBzEog/eS468NjNnDDt43RJtrskSKqh05ZYE5NIqjdf
	o2em2XJFeCVm+l0uUcFLoRssLb/YoIaCIa9j+njfe8L5aaiuSz5bF5CM2hKCaeFXnvM=
X-Gm-Gg: AY/fxX7BjhxeVkjuBkAhEjhiCdSP6flu9kZ+FbHVNFgjs16TLFsJb75wospgmFJp32W
	1QFZ/JGdh1Ed3k9kNK9ByKxeuqCaJlLRnpPB2lNOYVzYBtHDxxj6GvCbeAwpKM3mrHXPDa2o8Uw
	4lEGJH+d3PLVJzU6fogfFkn3ofoWq8WoSYxaxt+Tz5UXywz6rce0YsGNb7Djk6KmDIzDylzAbUh
	yiv/KSUsys/4GgxUgOoEvRrOx22Gk/Asq3WiWnGG1RptTLpBxmbp7guVrFEbGYz6Q9R/fR9mbAL
	2K1X/gNC3Ix2TurXG1hUYNXlqad2waYrlNhMCpL0jZ5LpVxW5HVJh7DIIoQaxExsqYLZT/Yv2qS
	dqRPSoKlBnuMPr/GdSFk210PAcZZ7U190/KgulOzzp/uGL3N3rLOmIAWYpD1tayP3ylMWN8UZUk
	Q9wvGS1lvnLqyACprH9GVR3Wt4l592YORvYEp245aovrSHCVHbP1G2fVqyobDxmeUwvoviSL107
	Z8Gy5QW53Q1S+DvmsdLYp49zri/XCqKiX1OAk0=
X-Google-Smtp-Source: AGHT+IE/qB6NEHP1QqGV5PfcwRRofx95tVM5do9NhE19foMR/57boxHx8KStBk+G0GxCGRT1W9RoKA==
X-Received: by 2002:a05:600c:444b:b0:477:9814:6882 with SMTP id 5b1f17b1804b1-47d1953b77fmr317021115e9.5.1767033624761;
        Mon, 29 Dec 2025 10:40:24 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:24 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vkoul@kernel.org,
	andi.shyti@kernel.org,
	lee@kernel.org,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linusw@kernel.org,
	Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com,
	UNGLinuxDriver@microchip.com,
	olivia@selenic.com,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	broonie@kernel.org,
	lars.povlsen@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v4 06/15] dt-bindings: rng: atmel,at91-trng: add microchip,lan9691-trng
Date: Mon, 29 Dec 2025 19:37:47 +0100
Message-ID: <20251229184004.571837-7-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229184004.571837-1-robert.marko@sartura.hr>
References: <20251229184004.571837-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document Microchip LAN9696X TRNG compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
Changes in v3:
* Pick Acked-by from Conor

 Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
index f78614100ea8..3628251b8c51 100644
--- a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
+++ b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
@@ -19,6 +19,7 @@ properties:
           - microchip,sam9x60-trng
       - items:
           - enum:
+              - microchip,lan9691-trng
               - microchip,sama7g5-trng
           - const: atmel,at91sam9g45-trng
       - items:
-- 
2.52.0


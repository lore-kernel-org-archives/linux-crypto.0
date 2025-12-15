Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBFB2EBB8D
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 16:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765816751; cv=none; b=Dec4k0wr5rrUIrD4fq2KwkgT55bEOm7YGTrkIVpXL75YajFyCY6ari1mRIfqYWeEbuEJusge/p8NIe86ivLvB9R26lP2+w6cwjuxmDWZnOQz1+s+03WaKPbG/+FZGiNV7eTFQs8p0BWb9Ed13fE7SQEtv0b4OF/8zRgcU1r5ykk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765816751; c=relaxed/simple;
	bh=H5qZHJBlkQV6+/j+zTVqie7Q24nFHuF3MlV57DgQSPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3IKgrPGHtQ6vJVnYtQItCPLP90Q5FSJjtydTdj9sU76XPAf9mg/blrghRUFVLw27/k2yFE6t16QEFWcLMcm1y8iVQGvDLGj6RrVj6y1sDkxIBYxHZl5KlcDssXhkwr6P1eNxSOTrQrOC/df/WrQVTAGI7uBFnBuXeUy96b9pvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=g+Jpw/Rq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="g+Jpw/Rq"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4775ae77516so44372465e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 08:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765816733; x=1766421533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cvy2LXuomfpj1nBing2L+jv3vaShIDCdMet4k/EboCs=;
        b=g+Jpw/RqdSE8R3RrrjQvhbjLiVU5JJvGAMD4icDPe28PPyf9q7p33NAR2brta51Jk1
         vhKfrzJqyBKDndGSaKieS7beK81YB610auUCmT+2t2R9OxgxySm5j6UcXqt7vDwr2yca
         IuvDhLzV7LpgZ2naTmCudKK9fP60HkJlmNpO5/Svow1GgRTRosFh1KiW3zICe/wl6SKe
         gjELLThAa/7h/I8jFCkxujmPa2VFPMEilRd1q68bEJMPgd/hEtLuCCXGcHJ6yfTsFE3e
         VjMvyu9I5um1nsezeE1uGkkQJcEcPANF4u/Csjni370le8TjbMdqiTU/AQK+gb7/fSl9
         q2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816733; x=1766421533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cvy2LXuomfpj1nBing2L+jv3vaShIDCdMet4k/EboCs=;
        b=HlqZXOMEf3YRJRHsIjy4+yirccsYLY5fS1p0iVceVB+ikvhg/h8VPgo+yDHvAj/jm7
         kY1IvQTZLVVumNhkHt7Hvpx2wDcUvC1a9Ve6SmVe4tvtrR2OhWIbk1BDUhrfKdmfcjTI
         kU4XSSMMDh/u3ujdiovfGxK7COabjelPdfNY8WQbQ24zm4c0MHeWyxZLNCLOK0KKp30Q
         4vZp1h9Z5iK4BKRvzx2jGlfiGp+QBW4NEbqC0W1bwf4/7ohoy/nKhiSjLHgWqAN4R0Yh
         xt+S6dwtTpMGVvRxi7vg0iColv+E6dkL59H/h9ffi+3i0jLa9CXco8V6Fi+D2tC1OOE6
         M3pg==
X-Forwarded-Encrypted: i=1; AJvYcCUzgP4UqZgmlGLL5jpiE85g7J418gnuyuZdLYzDD546KNN4qBn9wdXoKCXMUFJr2SI6zTMvbik3P72R2CU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjy5fO84N4s67JY+8Gifj2UJuVMMkxZreRV9x8mNEIzHdHoMAS
	oEzFVx0bAyxcifVgH+clPYjRkMTZkQeAFC6q57Mn2lotldGQ+6GoZdTXvQA5435vESg=
X-Gm-Gg: AY/fxX5SGyLIhAuLzPO7pHOfBKFzPiPrpdYrbJjI022/cLNKpHq5yFQih4RXnoLhHEN
	aoqA3lN26v26oeGVg+7yxFhc4AGZYLw4Sr2Dv8fpFJS+84sg+5EhUJL4QypQpwM6g5JgB8kyfpn
	/+HIMarGfHgyyrkajhF+hTAVDF7RILIJucKGY2Sp4u506cDqTj6tbKwIUx091MIrbpcMaDJWQyl
	tSw4Acqh1DpdehfO2iRIZstjFW7GOQUVNxjiE1m3t2eIXRlOcDWVgBaikyzXoPSU8WTwAJ4HXLq
	TAwJ9+DdNNDcbxXl3lmFXLCWIW9i+kMVJra8mwC1gc0+ZuTY5WbizsNzuMRIfUIZx9HXxdlApOF
	VJ0fL4QiFCB83SveR/jElOYGebfVacb/vhPWPex9z+9DS5B1Udrwys6ZN4st/uI58WOVKkv0YBE
	kFQmkGm1ffiZYLqpQknl11AMLtrafgiuoD1ByTQmfLu/s8
X-Google-Smtp-Source: AGHT+IFiI7Ni2LKcVl3YPoJbZhPL5dwoIiYSj1m9w7GWGjr7ZRqjP07iguNywDfLKiIq9PsRU4kDWg==
X-Received: by 2002:a05:600c:64cf:b0:477:58af:a91d with SMTP id 5b1f17b1804b1-47a8f89be65mr106452615e9.5.1765816732996;
        Mon, 15 Dec 2025 08:38:52 -0800 (PST)
Received: from fedora (cpezg-94-253-146-254-cbl.xnet.hr. [94.253.146.254])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47a8f74b44csm192209725e9.3.2025.12.15.08.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:38:52 -0800 (PST)
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
Subject: [PATCH v2 11/19] dt-bindings: crypto: atmel,at91sam9g46-aes: add microchip,lan9691-aes
Date: Mon, 15 Dec 2025 17:35:28 +0100
Message-ID: <20251215163820.1584926-11-robert.marko@sartura.hr>
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

Document Microchip LAN969x AES compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 .../devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml        | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
index 19010f90198a..f3b6af6baf15 100644
--- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
+++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
@@ -16,6 +16,7 @@ properties:
       - const: atmel,at91sam9g46-aes
       - items:
           - enum:
+              - microchip,lan9691-aes
               - microchip,sam9x7-aes
               - microchip,sama7d65-aes
           - const: atmel,at91sam9g46-aes
-- 
2.52.0


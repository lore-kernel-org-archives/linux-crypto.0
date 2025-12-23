Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7DC34E246
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766521236; cv=none; b=RbBkjxjLWCxCf/34OPAhZwFpDP7AYjRFhxs7O5Ylv5x6ijL0ObYTtmIe3FEj8Xh2N9k6kdCc6IGzDzKmeBRaAxUE88WV5SdWeYwtdaCI34/gVM2yTmE1YhysCKpTmklCEP4YclbE1GB0QELsYL+sPVLE+hIZWCX6Ekbnuh7LVrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766521236; c=relaxed/simple;
	bh=fcTtzHF7gWsSvucVbLas/Xk6BXcFxykzA9hcJy3JeRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKzvcYWsoxrCmUqwyqHMfok8Z49Hyt+xuQMXQjqLd9GUjQBmmkzvY8wP2TDrMMucu9nWHw9MArNi5+0Tob6rBaYg8k28MJot+XuVOvx5oC+CBJ+KBzvp6ya2mZq6sjjmxz9HVJPTmDA154fQxfFKrCXDnt8UlNKnqnKdFv1AcXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=LUNMGrbH; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="LUNMGrbH"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7f0da2dfeaeso5498119b3a.1
        for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 12:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1766521233; x=1767126033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfrUlgr4mKAwpRgF31HqFmZ+jq2Qg/gWBBCl9WoQ4uk=;
        b=LUNMGrbHejcYyFw2a6c/kwd75fcTpoU1Txm3aDp5WPaRLflEN5x2KyQhCtoR9nYbgT
         G52WiWvsYMxeLN/e/NSOuMsHnDfXefk6LgHaMbT8DP/khfakpFdXf78tzEfqEQYq9umm
         8rUPkhi3lgUD8VCN0hh0xf5Tv1It8Rv1rO+V2kqbTcq9xtv6gqraS5r9CYDAF0oDXnwy
         A6H/V+0geM16PmRCt0ZWpCoe9tUowVQVnULVxxmuV0eluI1StV4l38cNFbXf7zru+Fid
         /S+ns2Pa9hMFFGRmLhFQ0nB62Ctm1T8/RBYKVCWZIl/75WNAdNzC5Bt5WKa2FK2zeCHI
         z4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766521233; x=1767126033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PfrUlgr4mKAwpRgF31HqFmZ+jq2Qg/gWBBCl9WoQ4uk=;
        b=lPE9+pkAvdNbcfyDdpS2l/ajpCiALS3e+BWfs+EESxwHfWyrO/PSDcLNKZ8FkIpwip
         LnymgmwOJ0sR4V4Zij5G+OxKZiiE3qcuWmlV12Wq4qY2VSKXkVGvVDHViuy7L7D2YAnC
         K8SSUNoLNoOxI0BDth5AcyKbOpcJnas4GGRZAJwcG+QjyElaWk5mCZu8kjhBrodPKC3c
         c28CVxAgPWMwiAOMhb4HLkGIY9C/Er+/ZpS1lWRdzv2RpCCKy9XAJ4jahiUvgqjF5F2y
         GF18hWsd0HYPsLmmH8lKLZmO6VDYWzEGZuTlgJSwLhIKOaUmf8HDniion1EhBjlJCNH7
         niCA==
X-Forwarded-Encrypted: i=1; AJvYcCXy6IgHuJHWgieOjTcYnEjH9CyCm+c8U+djt9sct63sYE2b/zVkPXCbF/kWT/Heg2puN5ky5qOPZCKHZgM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOoY4Sn3zdFB1/ifPrziK0DXfPusEVHUEJ5Kqbxpa2xF3UdTzU
	IiQxOBIck+2HzcV0qeMLowdkfCGUy1nLONZ6FySoj9zWypMEcIE6MAlSmNdcVL/qh8g=
X-Gm-Gg: AY/fxX5kdZCyUc7FxR/LQY7XTygB5+iyu06I/ESHx3cb9bc66gEalPDbCYYPu/lbka4
	MfDbMadJMp8+XEptLfbbVoUbSDYmbfwS2OGs/nWw98OJSqRxQ5uOH73yu6g6Noh+rQtF723EYGe
	fRUAJXjXwJJkJbeR2umjhk6vy2lTmldeyLQm2Vc0mtSNDrFEn6CjDEOrMij4OS4qsNDNQNKrEqn
	/6rB85qB+A4w2nhxq6+ljfaAgBMQezj3wXkASDCXeeD3QwH9KfYoPDmDnTr1Ki1aLMk3eFkz42x
	Rq9JT3+Q1Xx4E03wQHt8Icm/5D4WszfdiBALpVy2RDtybXlnSMra6GgltKRGykQB82xM3CF683g
	SAsFoEs1h3Ia3E7p0tw9Fj0nzpf63EE1Jv5FkuuT0vSeZUAaiMqd5HsDjbLfCx4o4oAxS6H5FlP
	sfy/IvElFAn0UugBdasazEchVEjUDQM0AaBQvcHxGgawQB5Wnuy/RZUa8FwS+HGl004IXcuUGzD
	0fKJ5K1
X-Google-Smtp-Source: AGHT+IH+vGo67Kz7b+8QZvoO1bYGr/XHDGO/seoLyNk1DncRQFKXbN1uskDp9cfikbL8HUPUhf7HaQ==
X-Received: by 2002:a05:6a21:32a3:b0:366:14ac:e1e1 with SMTP id adf61e73a8af0-376ab2e706dmr14672619637.71.1766521232584;
        Tue, 23 Dec 2025 12:20:32 -0800 (PST)
Received: from fedora (dh207-15-53.xnet.hr. [88.207.15.53])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c1e7cbfa619sm12567549a12.36.2025.12.23.12.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 12:20:32 -0800 (PST)
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
	mturquette@baylibre.com,
	sboyd@kernel.org,
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
	linux-usb@vger.kernel.org,
	linux-clk@vger.kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v3 06/15] dt-bindings: i2c: atmel,at91sam: add microchip,lan9691-i2c
Date: Tue, 23 Dec 2025 21:16:17 +0100
Message-ID: <20251223201921.1332786-7-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251223201921.1332786-1-robert.marko@sartura.hr>
References: <20251223201921.1332786-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document Microchip LAN969x I2C compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
Changes in v3:
* Pick Acked-by from Conor

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


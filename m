Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174F4332EBD
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 16:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765816722; cv=none; b=HacAHZt9D0F/hkF58AJo6Q40nrn2qRa0Pk5SqWOyYWbSGFudOekaOe7OH0SwMu4VUy8vcJNv9k4qJKB3IdCQl95I7kWTHdV9DsXKgXTnJzdUPQq/QRzPqEcoMaH1lTVWLUzgmETfSF6dnMk5ttzQ3Bbqy09wavfxobNLGqDnD14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765816722; c=relaxed/simple;
	bh=KckEDwOpPTvVDuV6vEp85iQKEd6lVbIzeIrpO820OvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPCKOw2Bpsrpu7C56tIOVEVe2VfQUr9YyZVMcTU7t5oMSF4ZrYbPro4TuyUPmq2SCU6yF+IXB/l1AsW1ce7R2szDa3SWuDE90pLRCJwnI9cCR8Mo6N3N6Ylk2+wieEdZZ9CGTwuxFIz8VSfcBLtQPYXRCckrw+acqJ10HUOMhNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=v+T8RzjO; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="v+T8RzjO"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477bf34f5f5so28797305e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 08:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765816717; x=1766421517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Glxh1+4wMOAEOdPMYe7TVA1/ll/sUwlQUZ1Z0+HONCM=;
        b=v+T8RzjODpQ2o7XMuoOGoo26SSMjx6obFhRx1WllniiTrhMuXJbcM//TfBZBcR/Ka/
         g+hDI8INtxekK1pvWAzhJ8ObK2Ja2zlYBIAtc11s2rFb9C2fvjzrSJQGl1ECLR1/c+ju
         ETmZ6hzDDCNv5aOrlTLwjlSTw5hurjSZRkI8/NxGcEo3hJPzHVk6amLwpNldSF9xjiu1
         zgahaIHce3vgT3My/TcIxJDCjVgozsuUB0rRsyTh9ocDsVFWmEgc2S/eT4pKaNeFpNos
         vFJjsEduyB0oLFdK4zLfbFY2OSLX7gBayxbx9cJs9PYlEin87d24+LCvdrMg0q6a+eZw
         Rdbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816717; x=1766421517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Glxh1+4wMOAEOdPMYe7TVA1/ll/sUwlQUZ1Z0+HONCM=;
        b=p+k8T+RoujxGAvPKb46spWPhiMTnbvg0zVUt/2Qeuswe+p9griQJ+lStk+cTGvjC5h
         ddnQTgNnxF5vamvOQwTMqwb0fgzBzd5n8J798m0R7cR9iQx+R0g4H1dQUoOO8gZWCHT1
         00SffXwtcOjXVnYr0TbXjifQq9gQYstSx0KijEoYNRKapoKSLL8vQX8jam7yx8jbxXQU
         Qjsu+N5dCz6awADcyDdrksbsFedCzuh4Q9p4jjI+TeTQ8yKefxlFZhTtgH4w3xLgZ1gJ
         AFPj++IwghIxW82vK7jWpeJnZt5I0/fcrZ1wQqjjt3fL93rK+0D/N+gatYn1SDqqxLM2
         UlBA==
X-Forwarded-Encrypted: i=1; AJvYcCUdvIsJzOtsJjHRPcuYqboeWiRLSwA57qSo5IA+RpxhGEyWhuBh4gsN4QJ/uAlDn3H/nzxTujot4EDvxOI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTPDFft7hvUs+zOLQMg6X8nUpMRxz1RmJHeLh0ubNbNnTKDXaw
	5h//kTSqnGf1pMVVlekoNv241ENlbgo6D1IZrFCnUr4bKKe4oog2jRHC/07oaQ/rgI4=
X-Gm-Gg: AY/fxX6fUWjil57YkB4qiYvv5T5SgNrIEnShGDoHjG9oCZV70pLPxdwnj6AXVrUFJti
	FkGMdMlgL7YEdfU54FXXD2pGSbAHjDPXQNoXzwUMvGYAcXdNXFP/HLZ4ENLeUkyXv8JUUtSGpLD
	eBszHCkAdrhqTgyAUrq3zcx5hY4KLC+9Yo+d8fJdjmyskCw7ZVm5bOpPr+wAYVAL73JoeXyTf5D
	dY/P+8xF79bryBt4cpOwQSB3RCZzMm7A8dbIOL3x875gkLMBhA3RHk+Aksus0fMZgD8pVWX8oaq
	uLkBC0LhCVaj9EtLiWx9ZXEKvzWRUv2fBQscONFd9p32zHsnfiB9k8qHTgaxnf+3i5ol0BDD4Ae
	qnaJ9a3G7EHWe6GElnh5c7YpN7Mi9oTUNkzfpzM5R9CCXU+qWaG1N9r/yNhSgrCqnbi6G/7wmzO
	P8MP2QM/W72202d5nzk3jXfOvf8S9opQGwrgKi7V/LdL1e
X-Google-Smtp-Source: AGHT+IET494SX2l9gCFBDAsNgva9GdCaocHF5w6Fqopjo065ROPc9sjb2/YbJQBUdoy8LPQteXLhmg==
X-Received: by 2002:a05:600c:a31a:b0:47a:9165:efc4 with SMTP id 5b1f17b1804b1-47a9165f157mr97992715e9.33.1765816716425;
        Mon, 15 Dec 2025 08:38:36 -0800 (PST)
Received: from fedora (cpezg-94-253-146-254-cbl.xnet.hr. [94.253.146.254])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47a8f74b44csm192209725e9.3.2025.12.15.08.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:38:36 -0800 (PST)
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
Subject: [PATCH v2 04/19] dt-bindings: arm: move AT91 to generic Microchip binding
Date: Mon, 15 Dec 2025 17:35:21 +0100
Message-ID: <20251215163820.1584926-4-robert.marko@sartura.hr>
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

Create a new binding file named microchip.yaml, to which all Microchip
based devices will be moved to.

Start by moving AT91, next will be SparX-5.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 .../bindings/arm/{atmel-at91.yaml => microchip.yaml}       | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)
 rename Documentation/devicetree/bindings/arm/{atmel-at91.yaml => microchip.yaml} (98%)

diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.yaml b/Documentation/devicetree/bindings/arm/microchip.yaml
similarity index 98%
rename from Documentation/devicetree/bindings/arm/atmel-at91.yaml
rename to Documentation/devicetree/bindings/arm/microchip.yaml
index 88edca9b84d2..3c76f5b585fc 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.yaml
+++ b/Documentation/devicetree/bindings/arm/microchip.yaml
@@ -1,19 +1,16 @@
 # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/arm/atmel-at91.yaml#
+$id: http://devicetree.org/schemas/arm/microchip.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Atmel AT91.
+title: Microchip platforms
 
 maintainers:
   - Alexandre Belloni <alexandre.belloni@bootlin.com>
   - Claudiu Beznea <claudiu.beznea@microchip.com>
   - Nicolas Ferre <nicolas.ferre@microchip.com>
 
-description: |
-  Boards with a SoC of the Atmel AT91 or SMART family shall have the following
-
 properties:
   $nodename:
     const: '/'
-- 
2.52.0


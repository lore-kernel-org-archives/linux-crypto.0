Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D61345731
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 11:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772450526; cv=none; b=mYELxz8TGQnlf+7ptGKK/tjD3m1ICuJPIQuHdnlyLtfRJfqok2azPI9Dm5lRd/LZIMENzjCwPvrJ28O2NZrtU6oU26Ybp3tLn8EW3PHpxbhkr1wg6846vOnElnVGXA6RWHeatFLlJcgZrjopdcmM3rvH4puBGjor/gxzqlxOefk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772450526; c=relaxed/simple;
	bh=6IIQUbyZGOF8ofJDPgy82sEzZ9Ny3AGVpK58BJFrOzM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WZXk7vHRfiqHnT3QA15WyNTH0Qj8vbwzBXU5z4J7LNszYK1n3MSlMVZmw3kI/QqQjpZwUpAEMpKL0KRBpyiZBNm9EpTMYSMgRKH5wMByIxp/PKRGYrfvyclPiJK9VAoNvXyLgC5X4ixXSKrGy98HruAQsQyovIKWUntn5tSvbD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=jd0WLhmr; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="jd0WLhmr"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so48800705e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 03:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1772450523; x=1773055323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9OyoJW81V1ePbm3yEDh6NHzrMwB3X1grrgMlNcKt/q4=;
        b=jd0WLhmrQy/4HTxoMDcPRXpXNYHPXmPjPrqD8SQs1gqYEdv6BUKEeX6WJXj+jtERg6
         nmYcoQL5167kpBuT1vKeDyfDZH0yh8WhdDikuhPWCr3GeQ082A0CNGQg5AfEreTvuD3a
         9KHIcEKhnA8NAFGEaw22z0XTVfxmzVhEVyvFSJ8UjOJsGqn+WLVfDw/0e/B3n3kK29az
         3W7VnQzPzO/aYkWrLzvFtfaLhzqnofo4kUHK9+I822aBQT1IOn/7ZHDksR65DvXGYdcL
         lMuupbOd50JM/XjBZahCDp+XynskK5jSm8ehlHryfeV/MxpY93VSXeH8/1j27MCuJTJB
         bPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450523; x=1773055323;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9OyoJW81V1ePbm3yEDh6NHzrMwB3X1grrgMlNcKt/q4=;
        b=hSOqBtkpCaK/FUzmkZUT/0eeDYwkV+pEFm6J8oEV6/5SdQFtlK/AJ5WWvYyS/K8u2r
         6IzqOmqeeBZLqt9p0rLwC9sj+m8jp6jMYZWsr/KRhjSohlF4Ytn5QvCMLvzq92YeXU+G
         8YhoQCkiD2WZF4GtN+E19GkcpXccVdA1EkM9Nd/r51+P804m9B0GV2mub2PXsqba8uZj
         VEtlHMUQ6MI5ueFMnFigwkNfgDvQUAn+J/Mt54irpXlb6NL+r12MN3KdM1PRkWpZAvS9
         a4jYNygCQrMCR3UmDnUhnWAQVDVc/ZiAAAicpLTfsCRc5DEZv4sXc5rd+TBo2dLRbNYq
         dikw==
X-Forwarded-Encrypted: i=1; AJvYcCVLBQfiO+q5mwba3ulq68EUQMNDZ9NCJEi64BIsELWtq07qy8Qlfk2nPuhEUNQMEvaZ2JePiFzNbqsjkYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFy8YEh6xfwWOsVSIw28XKO2+ZlK3jC/Ba58Ni5sZVLutrSJdI
	SS7jWwC08Eu74lZ+fcsu6ZOT6v5QSKR0U0bQi5dgDYZKcjXs0fwIHnuzc32Xua1Uahc=
X-Gm-Gg: ATEYQzy54FNnJcfCCTfLrM5FNn1kb0cylzV+ynPJnCzjttCh1AzcRzjPmeFyp2nE2oH
	EdeWQ5Aj+jQ9umMiNpdeUKHC8x2ePqkNePmMtWSkJcLjZeAB5G4Vwu+r8FP/5k2ABMXTMeJgBqb
	Sa9T/TgUNCNYFqkg82B68WLGVOwppa34hr8/n2M9BeZdClAcJi066afjKYPwxqtH9BIGoww/cxD
	mmzJfBSQcL6U4BGqtAXileTAWCPbMJTtvuwH4Rf+Z4wuit3MTM/kzCWexYOlWDQ0qmwX/b/656R
	l7Y4c0wom5dgPQI+0i+GT8bR4B/4GQIsoeNXwtVqK/lMuS7HO3RnSGPtJnc7Gs4nsIMrjG5PdVe
	mpF4O0q2irWLkhUMJN2Jp7AWuBdNIwiRobBo7HcmUCNP2I29rGQ9Z8JQzyVHj+bSvks0veb1Ojo
	b/B0WeAkS61aJ1UD38GBjzSk9BzhKd+jNWrNPrTThnirKnPQAQSHtwm+7Fk660Xvd1pWxPOp1Ig
	1FmndH2JeXNJzJzlEGG5VpdgfmpPrVUKUQchcWZihY=
X-Received: by 2002:a05:600c:548a:b0:483:6e32:50d4 with SMTP id 5b1f17b1804b1-483c9bed9bbmr211639925e9.18.1772450522114;
        Mon, 02 Mar 2026 03:22:02 -0800 (PST)
Received: from fedora (cpe-109-60-83-135.zg3.cable.xnet.hr. [109.60.83.135])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-483bfbb465bsm292493035e9.3.2026.03.02.03.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:22:01 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	horatiu.vultur@microchip.com,
	Ryan.Wanner@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	daniel.machon@microchip.com
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v6 0/6] Add support for Microchip LAN969x
Date: Mon,  2 Mar 2026 12:20:08 +0100
Message-ID: <20260302112153.464422-1-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for the Microchip LAN969x switch SoC family.

Series is a bit long since after discussions in previous versions, it was
recommended[1][2] to add SoC specific compatibles for device nodes so it
includes the required bindings updates.

[1] https://lore.kernel.org/all/20251203-splendor-cubbyhole-eda2d6982b46@spud/
[2] https://lore.kernel.org/all/173412c8-c2fb-4c38-8de7-5b1c2eebdbf9@microchip.com/
[3] https://lore.kernel.org/all/20251203-duly-leotard-86b83bd840c6@spud/
[4] https://lore.kernel.org/all/756ead5d-8c9b-480d-8ae5-71667575ab7c@kernel.org/

Signed-off-by: Robert Marko <robert.marko@sartura.hr>

Changes in v6:
* Drop AES, SHA, SGPIO, SparX-5 and Flexcom bindings as those were picked
* Add Reviewed-by, Acked-by and Tested-by tags
* Rebase onto next-20260227

Changes in v5:
* Picked Acked-by and Reviewed-by tags
* Change clock header license to match the DTSI one
* Alphabetize EV23X71A pin nodes
* Remove the requirment for all ethernet-port nodes to have phys property
as when RGMII is used there is no SERDES being used
* Drop phys from RGMII port on EV23X71A
* Drop USB, DMA, MIIM, SPI and I2C bindings as those were already picked

Changes in v4:
* Pick Acked-by from Andi for I2C bindings
* Move clock indexes from dt-bindings into a DTS header as suggested by
Krzysztof[4]

Changes in v3:
* Pick Acked-by from Conor
* Drop HWMON binding as it was picked into hwmon already
* Document EV23X71A into AT91 binding
* Drop SparX-5 and AT91 bindings merge
* Apply remark from Conor on DMA binding regarding merging cases

Changes in v2:
* Change LAN969x wildcards to LAN9691 in patches
* Split SoC DTSI and evaluation board patches
* Add the suggested binding changes required for SoC specific compatibles
* Merge SparX-5 and AT91 bindings as suggested[3]

Robert Marko (6):
  dt-bindings: serial: atmel,at91-usart: add microchip,lan9691-usart
  dt-bindings: rng: atmel,at91-trng: add microchip,lan9691-trng
  arm64: dts: microchip: add LAN969x clock header file
  arm64: dts: microchip: add LAN969x support
  dt-bindings: arm: AT91: document EV23X71A board
  arm64: dts: microchip: add EV23X71A board

 .../devicetree/bindings/arm/atmel-at91.yaml   |   6 +
 .../bindings/rng/atmel,at91-trng.yaml         |   1 +
 .../bindings/serial/atmel,at91-usart.yaml     |   1 +
 arch/arm64/boot/dts/microchip/Makefile        |   1 +
 arch/arm64/boot/dts/microchip/clk-lan9691.h   |  24 +
 arch/arm64/boot/dts/microchip/lan9691.dtsi    | 488 +++++++++++
 .../boot/dts/microchip/lan9696-ev23x71a.dts   | 756 ++++++++++++++++++
 7 files changed, 1277 insertions(+)
 create mode 100644 arch/arm64/boot/dts/microchip/clk-lan9691.h
 create mode 100644 arch/arm64/boot/dts/microchip/lan9691.dtsi
 create mode 100644 arch/arm64/boot/dts/microchip/lan9696-ev23x71a.dts

-- 
2.53.0


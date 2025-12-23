Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F5334B196
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 20:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766521182; cv=none; b=QnOisdgtutwc3fQ2jdrq7Efy9SpiFB3uCn4uQEcj9s8hYI7Y+zZ3DXsRqsmYDrSlAgyPsxoCYPDuQbSHrN1jawqvj/jVFeCVA9HO/c4CAL16KndsxyeW+M8RxLzUupGkNw/mGkHgomS4fl7D4wwns0riiZTCYvf48kgBBpNox/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766521182; c=relaxed/simple;
	bh=dIzeT2bAtbNpWCzGPjuV3B4HClIyvUup/5uZSPzsL1M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NhFAqnV5v6soTNpkapUozP6kY0Nzj50jqFVX5TkTXzS8sJXHW7QyExlMVkVx4YrWJK+nWH79tm3mwQR4jHnIzLxSTVkuTc4FT/DXD9iT0jLhZ5CzEIzPMnW+F9H+zAm+AwAGHJ+efSqxygYsehqoxx9SHa85MZQIsuj3Y8BLCbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=sp/p1grd; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="sp/p1grd"
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-7fc0c1d45a4so4885366b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 12:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1766521179; x=1767125979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g1vfXs4RxjLrMI0+CYv1SSuI1FXB9RtpNik5CYzHMIg=;
        b=sp/p1grd5lkwv7sdu7MGJVw2B0P0H5QVE8/lQhc+Z2UZNVOBBoNa5ucm40go5i/fj9
         3bRj50JzDaFFJsr8MI2FZzYTHMYcmCqt9nTPUe/PVXN/Ps5bwDnjgwZbERarBuwr46lB
         OuKPXCXNsGCklL60xZHfTLjhhnEY5kVGOl2EbzI7+pE0JMk7XTcTMKO3iF8NqtWdSiPq
         CtXHKt9XfTwL4LnbC9WBGzL1k8xf/LnpbWEJ8S0okPTAwOoUaB65017hanldfEULAnHn
         jvXLRNVzVHerjoc6u2P31IfxpTha4cFgFpF8CMffs77aGOMk+4Me/DGg/qiGyEx6ff9o
         EWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766521179; x=1767125979;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1vfXs4RxjLrMI0+CYv1SSuI1FXB9RtpNik5CYzHMIg=;
        b=Q8O21YKM4RRTo+dnqeGsXjqwwV4rFqcwbNCLQft849xjo4998WeNIQ6fh+VdGSQvrT
         WETLsXaP00MghIB1pfDIVaD9tZhDO99iUW2eDryFZAwjVd+A7g41qp67aXmLBiszSEH8
         f01X/7iRP9ZQvQHjrZ7tUgtLZyYkR25iGptgGxEymAR9dqSjd1rdsuWOJHKKFKCMR7/8
         +kh4Ju8bas86lZ+JKJ+xlVhcPCVMaRdnmcKGXWmZhv+k1ELq5Pd3Jn9bbfA7nc4G2xxH
         5mCqZaCUzKzpyCVNJQPVKIAKibcVfQM5d6PxIietmsom2kgwUZ+HVMMAwTnlcIfZmWNV
         21QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVByVO1S0hI5Ar21XJju7+RpmhkusnEb/4HJuhX64scVJ+ivezJJEcmLxAYp0fqa5kCERojVRCUVJ/XVzw=@vger.kernel.org
X-Gm-Message-State: AOJu0YywcERBJbDAh4TBJlgcyOAcROyp2zV8LZOpWNCCZED53YJPpQO+
	jhylPvufCssBVt0n3sgIuPTCz+atn7NeldD9HYUOw0KKVP9xJFEzqw6lN3CdClgN+Ms=
X-Gm-Gg: AY/fxX67tWwGRURBUmAYAyuc9bV75JMlZgNPFnD4USvNiZeAizVHFMOV/FK7LCkRJYv
	Dm6hZzCYYBl5KO+xZrCXFVxbJcIo4NKEOmhmt/o/XoDDcxtVfDVXz/QctZ6VtH9uwAB5Hzm7xZY
	tnacOoHHEaxOdhfPLqrxukiQd/BxKASK5FbJJtSwv14Av0SXdpdbc78S2LpgDqV3gyooedJrWkP
	qqfP5b6INNeGd36++WV3U7GbIXfMlhIof7ZFdhWm52gny4/Dtm54+HvpqQdO8TX7TphMgyn0xm2
	UpUxSlMmAo81lcd362nG45PXhGG0NHuYYbD3B+K2lWbwOyY3hJY2uRx3qyPgP7lGye15Jg/pt9b
	9EMXSlzTzlyVnoBgElbQWOe7eJgzeQPlrn6cIBYblsGwX7B1iEs4SByyjg9xYF1MKfTnPrsk6vl
	1M9syOYGwTh99IUSKFhtfFqXKqlfbnkfFDKHOS2LFDRYw3w0jzQKW+S0KQeXjxy1U8YHCQIsOOo
	j6QBe8r
X-Google-Smtp-Source: AGHT+IElu2DeQr7IoImhfsWaHg06ftf4nZ3LUQN+WUZ/izPfinsCvzTpfHsJa/ze8aScZK07T0eUkA==
X-Received: by 2002:a05:6a20:918d:b0:35d:d477:a801 with SMTP id adf61e73a8af0-376a7eed254mr14238755637.13.1766521179192;
        Tue, 23 Dec 2025 12:19:39 -0800 (PST)
Received: from fedora (dh207-15-53.xnet.hr. [88.207.15.53])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c1e7cbfa619sm12567549a12.36.2025.12.23.12.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 12:19:38 -0800 (PST)
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
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v3 00/15] Add support for Microchip LAN969x
Date: Tue, 23 Dec 2025 21:16:11 +0100
Message-ID: <20251223201921.1332786-1-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
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

Signed-off-by: Robert Marko <robert.marko@sartura.hr>

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

Robert Marko (15):
  include: dt-bindings: add LAN969x clock bindings
  dt-bindings: usb: Add Microchip LAN969x support
  dt-bindings: mfd: atmel,sama5d2-flexcom: add microchip,lan9691-flexcom
  dt-bindings: serial: atmel,at91-usart: add microchip,lan9691-usart
  dt-bindings: spi: at91: add microchip,lan9691-spi
  dt-bindings: i2c: atmel,at91sam: add microchip,lan9691-i2c
  dt-bindings: rng: atmel,at91-trng: add microchip,lan9691-trng
  dt-bindings: crypto: atmel,at91sam9g46-aes: add microchip,lan9691-aes
  dt-bindings: crypto: atmel,at91sam9g46-sha: add microchip,lan9691-sha
  dt-bindings: dma: atmel: add microchip,lan9691-dma
  dt-bindings: net: mscc-miim: add microchip,lan9691-miim
  dt-bindings: pinctrl: pinctrl-microchip-sgpio: add LAN969x
  arm64: dts: microchip: add LAN969x support
  dt-bindings: arm: AT91: document EV23X71A board
  arm64: dts: microchip: add EV23X71A board

 .../devicetree/bindings/arm/atmel-at91.yaml   |   6 +
 .../crypto/atmel,at91sam9g46-aes.yaml         |   1 +
 .../crypto/atmel,at91sam9g46-sha.yaml         |   1 +
 .../bindings/dma/atmel,sama5d4-dma.yaml       |   4 +-
 .../bindings/i2c/atmel,at91sam-i2c.yaml       |   1 +
 .../bindings/mfd/atmel,sama5d2-flexcom.yaml   |   1 +
 .../devicetree/bindings/net/mscc,miim.yaml    |  11 +-
 .../pinctrl/microchip,sparx5-sgpio.yaml       |  20 +-
 .../bindings/rng/atmel,at91-trng.yaml         |   1 +
 .../bindings/serial/atmel,at91-usart.yaml     |   1 +
 .../bindings/spi/atmel,at91rm9200-spi.yaml    |   1 +
 .../bindings/usb/microchip,lan9691-dwc3.yaml  |  68 ++
 arch/arm64/boot/dts/microchip/Makefile        |   1 +
 arch/arm64/boot/dts/microchip/lan9691.dtsi    | 487 +++++++++++
 .../boot/dts/microchip/lan9696-ev23x71a.dts   | 757 ++++++++++++++++++
 include/dt-bindings/clock/microchip,lan9691.h |  24 +
 16 files changed, 1376 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/microchip,lan9691-dwc3.yaml
 create mode 100644 arch/arm64/boot/dts/microchip/lan9691.dtsi
 create mode 100644 arch/arm64/boot/dts/microchip/lan9696-ev23x71a.dts
 create mode 100644 include/dt-bindings/clock/microchip,lan9691.h

-- 
2.52.0


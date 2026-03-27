Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA7938D01A;
	Fri, 27 Mar 2026 20:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774642225; cv=none; b=AvIpqqX0JZBPYgzjOQu8a6ms/nrOJLIR4wG6Uyqdf5hUmxD3w2TPYxoDLF9zbp9Bx4gYYhsuF7Rt+CFjnmifK6udwWZPVUrk3A5KZRYWAa9DPdUf3TWDR63nUYqHSsF1M8eLkt4NuCdMFQUDW1lDqKKfSeNvsDtdW8GCRCC/yqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774642225; c=relaxed/simple;
	bh=85MXpOpj6RSdKZ3x8OwGzEhLk72dNQDdaoUsy5d801g=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HMQNUiC1axQxMSfc+5/5cz/YGIMDb5kDgrwrP6NkRlOdhHe94MAPwP4jHYKPDggAuhbVzgS50/MB3fZu42xxqqbJDeqVxX9feV/MxNdRq6Mp1g64hXmdLuGVaZgSQpv+6E40RyhGJsNX9SUuY3Z8uVkppDCkILQVWgJ/bPc89bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=idtjumX3; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="idtjumX3"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 3DE2FC5874B;
	Fri, 27 Mar 2026 20:10:50 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 639E960268;
	Fri, 27 Mar 2026 20:10:21 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5A95C10451AF7;
	Fri, 27 Mar 2026 21:10:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1774642220; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=bIF1JM1V9WjeIpsAeYPNhtxBVFUAIahSL4+PQQ6GA8Q=;
	b=idtjumX3N7aL5zh0U7AcOqrLvWNM+8wlPe7LjyhJBxmkInWzWdX/AT6Uhn0fXaqOSSZZIT
	5XFgknSuIVE78+a/cIBq9PkB/ELxa4CFAP0g1DWCGytB3hI419L6E8MDmpF/h8c6p8757l
	Pm+MMPUDr8qrygTFhnhf7QqLSuJV6oY5J/Km/Yge3BMszcuYxHjQ3IUcKiwI4Bj+MLwKmj
	5fjtQksbvWTYwg/aJGmVQz3zoIor73mQshrQkEFoFu4C2fpNG2eZFERp/mjLDPKYDW+I4n
	qBCLQEpj+L3ePYiAb1v8+IUfpsOkRXqastQOVymUBweYsMXRMuMksRoY3Wh8QA==
From: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Subject: [PATCH 00/16] Add support for Inside-Secure EIP-150 crypto block
Date: Fri, 27 Mar 2026 21:09:22 +0100
Message-Id: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MPQ6DMAxA4asgz1hKwl/Uq6AOYJviJSCnQkWIu
 zdi/Ib3LshiKhle1QUmh2bdUoGvK6B1Sh9B5WIILvSuCQNmWpMoi+ExoEMjj2Tn/t2wi8Sx7Zn
 n6KH0u8miv+c9vu/7D8kS3VJrAAAA
X-Change-ID: 20260327-schneider-v7-0-rc1-crypto-58cd846ddb81
To: Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Jayesh Choudhary <j-choudhary@ti.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Christian Marangi <ansuelsmth@gmail.com>, 
 Antoine Tenart <atenart@kernel.org>, 
 Geert Uytterhoeven <geert+renesas@glider.be>, 
 Magnus Damm <magnus.damm@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Pascal EBERHARD <pascal.eberhard@se.com>, 
 Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-clk@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>
X-Mailer: b4 0.14.3
X-Last-TLS-Session-Version: TLSv1.3

Hello,

This is a series adding support for the EIP-150, which is a crypto block
containing:
- a public key accelerator
- a random number generator
- an interrupt controller

The series is a bit long but every subsystem may take its own share
independently. I might want to split it into several chunks in the
future if it expands but at as for now, here is the full picture.

For instance, the clock part has grown due to the inputs From Stephan
Boyd (addition of Kunit tests + a couple of misc preliminary changes).
Link: https://lore.kernel.org/linux-clk/20260129201003.288605-1-miquel.raynal@bootlin.com/

Regarding the big engine, the EIP-28 Public Key Accelerator, it
currently only supports RSA, but more algorithms might be added
later. The hardware supports (EC)DSA and (EC)DH. It also requires a
firmware.

The very last patch adds the block in the Renesas RZ/N1D DTSI, as this
is the platform I am using this hardware one.

Thanks,
Miquèl

Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
---
Miquel Raynal (Schneider Electric) (16):
      dt-bindings: clock: Introduce nexus nodes
      dt-bindings: interrupt-controller: Describe EIP-201 AIC
      dt-bindings: rng: Rename the title of the EIP-76 file
      dt-bindings: crypto: eip28: Describe EIP-28 PKA
      dt-bindings: bus: eip150: Describe the EIP-150 container node
      clk: tests: Add clk_parse_clkspec() Kunit testing
      clk: tests: Add Kunit testing for of_clk_get_parent_name()
      clk: Improve a couple of comments
      clk: Use the generic OF phandle parsing in only one place
      clk: Add support for clock nexus dt bindings
      clk: tests: Add Kunit testing for nexus nodes
      irqchip/eip201-aic: Add support for Safexcel EIP-201 AIC
      hwrng: omap: Enable on Renesas RZ/N1D
      crypto: Group Inside-Secure IPs together and align the titles
      crypto: eip28: Add support for SafeXcel EIP-28 Public Key Accelerator
      ARM: dts: renesas: r9a06g032: Describe the EIP-150 block

 .../bus/inside-secure,safexcel-eip150.yaml         |  58 ++
 .../bindings/clock/clock-nexus-node.yaml           |  39 ++
 .../crypto/inside-secure,safexcel-eip28.yaml       |  31 +
 .../inside-secure,safexcel-eip201.yaml             |  41 ++
 .../bindings/rng/inside-secure,safexcel-eip76.yaml |   2 +-
 arch/arm/boot/dts/renesas/r9a06g032.dtsi           |  42 ++
 drivers/char/hw_random/Kconfig                     |   2 +-
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk.c                                  |  12 +-
 drivers/clk/clk_test.c                             | 154 +++++
 drivers/clk/kunit_clk_parse_clkspec.dtso           |  31 +
 drivers/crypto/Kconfig                             |  55 +-
 drivers/crypto/inside-secure/Makefile              |   1 +
 drivers/crypto/inside-secure/eip28.c               | 760 +++++++++++++++++++++
 drivers/crypto/inside-secure/eip93/Kconfig         |   2 +-
 drivers/irqchip/Kconfig                            |   8 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-eip201-aic.c                   | 221 ++++++
 .../inside-secure,safexcel-eip201.h                |  14 +
 19 files changed, 1444 insertions(+), 31 deletions(-)
---
base-commit: f6ad621bcf627fe4719cbf97c1d3c9366cc49eff
change-id: 20260327-schneider-v7-0-rc1-crypto-58cd846ddb81

Best regards,
-- 
Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>


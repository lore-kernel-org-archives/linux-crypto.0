Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F4928EA40
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051554; cv=none; b=X+F63eBdAfvrFd9J3PmvXDNPkuWIeD8bLdaqBm2xwnEVDFgS5tL3hfjZA1ZbUcOpKq5+VbUL73+4GygGfJhoDkC/weTlssF6uoxcmSSFWPopNJjKvBHMwJR0/eWe9w3h8HsuMHyr2SxPYNpLv6ETL7Dis7JhtdoRUHGWt3Azlg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051554; c=relaxed/simple;
	bh=hGbxGH5yGJjhrsnGq8KKSQmjoGKOJ88kHNHG2QnknXs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=QS9UtJlTbluPr1hZr6tEn/9xLnFZcgR9zC2YtU3bo6aBIdpjowk9kgksxKlgaUtLpzoreKYnjaqfVkZBNOB/G4fJDYFd8qEXJg5OWve93GOCmkDE+dgaTEuosBnhZQEoxlxQWAbTC2g5FNPy6qn731xBtHG9fghHnyJd+PkvePg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rAuyMkqJ; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rAuyMkqJ"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54e98f73850so4964515e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051550; x=1747656350; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eqq9EOpsvH4cCrKKHdoK8XIb3RBbsUtuMBaIr9hLm9M=;
        b=rAuyMkqJKxTPaNd/xkQTq14vcg/JthoNzz7H4r4ar0jGbJcP+Pa43EzMnAqeaMpj/Y
         v/qgwb89vzqDwbpLjMequ6aoDOSDzj1ChqjCCaeLGutXpqOYRuCHr7ZZyS1kA7/5mgUk
         sBPZVn6fu2BF4xriZbtOuQziuFGHboP6cPw5PjA/bHeFOKJl/04+nOAeiOdFpn+uE5no
         hnHrZpAQe5zHA59eBCAOQwVYWMBrKcFngQWCLuJxt/vMs8modQmXolvki4r+aDdAg9fp
         NYWtb9KmuwKFFcWSAoyfg162V6V+Cz6HaLqK+ouKjdYWwfie9AYHB9+yL2nS96jss2EG
         HaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051550; x=1747656350;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eqq9EOpsvH4cCrKKHdoK8XIb3RBbsUtuMBaIr9hLm9M=;
        b=OiVbZ5UkwNYRJQYX/1s1SAm5s/hPihEtz99IgDPichMH08xjJ+LF9uwlxcuqZYrKbq
         LXxHn/OeBsqLcQJVTB69aOUeRQAI6rxsnpic361kJ6zFU939R7smcM7StZOQhGX1op8q
         quPFnueErQXtXGpf2IiCLnxYFyw08bNb6uTzs62fYXA4B1Gghlo6/Txz0Rvpd5+xy9Ga
         W5zdjxfgdTQalu/OkoBFI8ozRX2ZmpiE5eRpfNr9v8Q2BJCnFIivgZ+UyqiLJ2VOLXA2
         WgVzPJ+AqDc1xWGQ6cWXGlmNPY17FgGqWsLwZNZhA3BPA0fA5RompCnt2T6ks0N/7QUQ
         zXTg==
X-Forwarded-Encrypted: i=1; AJvYcCXEnGqXowBt9UfKoEBqq7Mmd7YqVe34oCx4l9hgtqokF3uJMKzWwaxEl3Bz1EuQuUxuAcfgAp4kdwVrbxY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlurM7//oQnCzHptrFMSj5lHDomZkuwyBtG5VYwdgS8d6lQT8+
	BxmU4YDmEZH5UGF2EzXMSfe4atjRPbBC6dcUoHLSX1bdM3akIPp8xoOyddK5Jv5Toj7kFsixKgY
	G
X-Gm-Gg: ASbGnct1W1semosJXU5IyCiNafNZQQHpjJOC7ucv/TIRaLevzSvytGpm2S2Cca17vhQ
	niVJt8DnK2o9cSsh22NicuGrsR4S9aIKqBzjHoI0Op7n1rjqRxdisp0ZGCDwVeTTzzGzoFeiOyf
	wig15LQ84G5J5gLh23DFrXJyTe5vs45PLoRBmBWgDNv4bFw3nCQ3oASvZ23AdfPuxb6Gk9YmP+q
	qV07AkfQXtpFDLODpowPGPaT9zq/uoePM73k9RMeNSdyQ0BoEvyFFyMHk7WIMB4QqnIac2FyM7R
	vJwJIsqklHQjVmwAS1kvuSmRSV55e8Eh9ykl8duzNj65EvbcTl3ndGHn0sqw0A==
X-Google-Smtp-Source: AGHT+IEtMbYBx+a632QmIMw0l2IjvUt8nlgRerOvebXBflb81teL0c+tliYnd2cE+4Cdmm0EE2PWZg==
X-Received: by 2002:a05:6512:228b:b0:54a:cc11:b55f with SMTP id 2adb3069b0e04-54fc67c97fbmr4315059e87.22.1747051549931;
        Mon, 12 May 2025 05:05:49 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64bf8a3sm1466033e87.189.2025.05.12.05.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 05:05:49 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 00/12] ARM: bcm: Add some BCMBCA peripherals
Date: Mon, 12 May 2025 14:05:46 +0200
Message-Id: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABrkIWgC/3XNQQqDMBCF4auUrJuSTIy1XfUepYskjhpQI5MSW
 sS7NwqldOHyH3jfzCwieYzsepgZYfLRhzGHOh6Y68zYIvd1bgYCtFBw5tYN1hk+5dnUIZk+ckM
 DrxurJAgNqlQsjyfCxr82+P7I3fn4DPTe/iS5Xr9ktUcmyQXHArXUtbvYyt16PxoKp0AtW80EP
 6cQ5a4D2QGQSlSqdID1n7MsywdvlilcBQEAAA==
X-Change-ID: 20250327-bcmbca-peripherals-arm-dfb312052363
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 William Zhang <william.zhang@broadcom.com>, 
 Anand Gore <anand.gore@broadcom.com>, 
 Kursad Oney <kursad.oney@broadcom.com>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Olivia Mackall <olivia@selenic.com>, Ray Jui <rjui@broadcom.com>, 
 Scott Branden <sbranden@broadcom.com>, 
 Florian Fainelli <f.fainelli@gmail.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-crypto@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.14.2

This adds a bunch peripherals to the Broadcom BRCMBCA
SoC:s that I happened to find documentation for in some
vendor header files.

It started when I added a bunch of peripherals for the
BCM6846, and this included really helpful peripherals
such as the PL081 DMA, for which I think the most common
usecase is to be used as a memcpy engine to offload
transfer of blocks from NAND flash to/from the NAND
flash controller (at least this is how the STMicro
FSMC controller was using it).

So I took a sweep and added all the stuff that has
bindings to:

ARM:
- BCM6846
- BCM6855
- BCM6878
- BCM63138
- BCM63148
- BCM63178

ARM64:
- BCM4908
- BCM6856
- BCM6858
- BCM63158

There are several "holes" in this SoC list, I simply
just fixed those that I happened to run into documentation
for.

Unfortunately while very similar, some IP blocks vary
slightly in version, the GPIO block is differently
integrated on different systems, and the interrupt assignments
are completely different, so it's safest to add these to each
DTSI individually.

I add the interrupt binding for the RNG block in the
process as this exists even if Linux isn't using the
IRQ, and I put the RNG and DMA engines as default-enabled
because they are not routed to the outside and should
"just work" so why not.

I did a rogue patch adding some stuff to BCM6756 based
on guessed but eventually dropped it. If someone has
docs for this SoC I can add it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Changes in v3:
- Rebased in v6.15-rc1
- Set the UART IRQ to 92 and not 28 on BCM6878.
- Set RNG IRQ to 85 on BCM6878
- Set RNG IRQ to 85 on BCM6846.
- Set RNG IRQ to 85 on BCM63138.
- Extend the peripheral bus to 0x400000 on the BCM4908 and
  add the DMA at offset 0x59000.
- Extend the peripheral bus to 0x400000 on the BCM6856 and
  add the DMA at offset 0x59000.
- Extend the peripheral bus to 0x400000 on the BCM6858 and
  add the DMA at offset 0x59000.
- Use the existing 0x800000 peripheral window for the extra
  peripherals on the BCM63158 instead of defining subwindows.
- Link to v2: https://lore.kernel.org/r/20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org

Changes in v2:
- Pick up Krzysztof's ACK
- Push the BCM6858 DMA block into its own simple bus.
- Fix GPIO node names and registers on BCM63138.
- Fix GPIO node names and registers on BCM63148.
- Link to v1: https://lore.kernel.org/r/20250328-bcmbca-peripherals-arm-v1-0-e4e515dc9b8c@linaro.org

---
Linus Walleij (12):
      ARM: dts: bcm6878: Correct UART0 IRQ number
      dt-bindings: rng: r200: Add interrupt property
      ARM: dts: bcm6846: Add interrupt to RNG
      ARM: dts: bcm6855: Add BCMBCA peripherals
      ARM: dts: bcm6878: Add BCMBCA peripherals
      ARM: dts: bcm63138: Add BCMBCA peripherals
      ARM: dts: bcm63148: Add BCMBCA peripherals
      ARM: dts: bcm63178: Add BCMBCA peripherals
      ARM64: dts: bcm4908: Add BCMBCA peripherals
      ARM64: dts: bcm6856: Add BCMBCA peripherals
      ARM64: dts: bcm6858: Add BCMBCA peripherals
      ARM64: dts: bcm63158: Add BCMBCA peripherals

 .../devicetree/bindings/rng/brcm,iproc-rng200.yaml |   6 +
 arch/arm/boot/dts/broadcom/bcm63138.dtsi           |  79 ++++++++++++-
 arch/arm/boot/dts/broadcom/bcm63148.dtsi           |  64 ++++++++++
 arch/arm/boot/dts/broadcom/bcm63178.dtsi           | 112 ++++++++++++++++++
 arch/arm/boot/dts/broadcom/bcm6846.dtsi            |   1 +
 arch/arm/boot/dts/broadcom/bcm6855.dtsi            | 127 ++++++++++++++++++++
 arch/arm/boot/dts/broadcom/bcm6878.dtsi            | 120 ++++++++++++++++++-
 arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi   | 116 +++++++++++++++++-
 arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi  | 129 ++++++++++++++++++++
 arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi   | 130 ++++++++++++++++++++-
 arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi   | 119 ++++++++++++++++++-
 11 files changed, 996 insertions(+), 7 deletions(-)
---
base-commit: 35ec8841914c9777209046ea0838acbe23e06b39
change-id: 20250327-bcmbca-peripherals-arm-dfb312052363

Best regards,
-- 
Linus Walleij <linus.walleij@linaro.org>


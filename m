Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FDB17BD6
	for <linux-crypto@vger.kernel.org>; Sun,  6 Apr 2025 15:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743953568; cv=none; b=J1g0TwnM0WT4U1sZxVMNbPt8vgcj+pn/gEsynF+kYRB8rLBX45XV55WTYQo7Vv9NnCcHSNqDbQhizfFotsTWH3mRas4XZUhCkZ9y2r5ENShOCjVhoi8zFIoqCT7Vr8o+/JrQpe3oMSIDa49Tq834l20iFGd9QDz3exHiiDpwMhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743953568; c=relaxed/simple;
	bh=RrDYVvXGMrS2RJSeE/ouGc3RKfdBBgDdwl6sfUfy4Fs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mBigmuo1T6/u1T1+yfYnb4+TVfxkJqO6f0yCXCoLe6BalWT8xXkDydmss7wmuMsQSCMvpOYuUr2ko3PkV2pXi7nhDGQ28hkFbwXnF7InrZfy4ONvGobmebvx9kTJIVe1wP7MEM8G6/EAeNq7u9kxNYiTDavXidNSXok5qpXHbaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H86zqTQ3; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H86zqTQ3"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5499d2134e8so4320795e87.0
        for <linux-crypto@vger.kernel.org>; Sun, 06 Apr 2025 08:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743953564; x=1744558364; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4CdrV4Ee8NZHiWicfEBhecLPl2Fi4hX+Hn0hDWKuVUI=;
        b=H86zqTQ3W3BpLm4W3pKs1/dbDMUwXhqp2GQMWwl6bJhKNXQ/t6BiABcFxhOPm2Aa5c
         NTsfT5LRavx1Utglwbv+CVkqO6dzAcEfF+jG8hYuuXEYeFHBWKloyViBW9VvwYorTAUw
         C9GnR12xFYGfcitRuUBz5WLk5snaVUfVoaJVmFV1IfWgQYD/LyFshru3vDuVupIs6n9N
         F4WvqZ4/ha8mezxFsI0SeeNZ4A7tMrwbnowgSFXnRyhTp25mtBlfy+9eQiwtCYhgVYtU
         Jw2olVpJGZuJIyr/RvKsEGwACbxSTmRZXDnQ8XahN55ghxfnhsjDxbjGctBdYiwwkGal
         q0zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743953564; x=1744558364;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4CdrV4Ee8NZHiWicfEBhecLPl2Fi4hX+Hn0hDWKuVUI=;
        b=tjVG942zll1hx/mz+N20MD/3dl7MKsjGl0Wyxl5M5sQdGIMry9NU08VXlRqCIJyu7r
         Q5DNLgxLwuCoejRmaC5jITzdUZn5Hk2P9VQKpV138rFs5Cx+Syhe9+XoZsKsvSFVWqes
         gQCHKL9R503ZJy/7ybu+VohtsFnXyl0yNNQ+RtAejr9Vm97Q4zA3GAk3mqi3Qqu0AFd8
         3S33oIYG9DRWWlsWph2mpAi3AiOed8xYwObw1yi9ZQpwqFuHK9YyQg6Om62n1xIAJCml
         lgAW4tHldIFG1lWwFuHNwKGqoGq/lMG/dg2Bo2cTMDXZBWLed4ZwHFyDzO0RXqbCBHd4
         9L2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVoB/w3563hAtaHGLpoYRe4d6XDg9RmxclbjLBr+F3NyYH+7Jg3IVSl23J5hzjMXoaDzwxRtrLdWeazutk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx48xXaP4qK4aTk8WAfcY4D9WTKlreHgitjsbmlRvqqTR9flMqU
	kiFrtqX/eTnDyKSiDcQ4gf4Grr/FObEXeRjo27OrTKIiLpIPhyZ7qFVsHk5mBh4=
X-Gm-Gg: ASbGncu+i9CygE3YgzUv7nVYAI+Q8htgykx5XPI4RjNqwFtWXJOD2qYKoTa+uz1jk3E
	e9lhFNrGZ9RavMNItsEXDOqELP4v5dpDZmXdWof0gPLjCQ6f0N6+LXs6yEocX6jwOEdaU2lNOkL
	Lo+opIWkmrS9gtusVon97rxqL+WKkMEnuqXIyHScdwiYnBRfPq3aZijgWO5GzByM3HgvFTt+DjI
	fbQOiUPLkShLg4JI5U5Lklxw1LtF5lGFLUY+1nj3ZARIQs/Do7cKi7fT8tP30TtpxA7mFtrL9W+
	0F67Vz1n64gkVFlk2Fjr/wuUvB8YlcaWmXe8SbA8ueTHCXDat8jOlCE=
X-Google-Smtp-Source: AGHT+IEMHKYs50VUiFzJJhPb55V1nqrOulEUzIjHGG1eD8uKA6HQzfi4EyS5Z1ub10c0zQJ8J/mcug==
X-Received: by 2002:a05:6512:118d:b0:549:6451:7e8c with SMTP id 2adb3069b0e04-54c2984805dmr1640715e87.50.1743953564304;
        Sun, 06 Apr 2025 08:32:44 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54c1e671fa8sm989747e87.218.2025.04.06.08.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 08:32:43 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2 00/12] ARM: bcm: Add some BCMBCA peripherals
Date: Sun, 06 Apr 2025 17:32:40 +0200
Message-Id: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJie8mcC/3WNyw6CMBBFf4XM2jF9WEVX/odh0ZYBmgBtpoZoC
 P9uJXHp8tzknLtCJg6U4VatwLSEHOJcQB0q8IOde8LQFgYllBFaXdD5yXmLqWhpILZjRssTtp3
 TUgmj9FlDkRNTF157+NEUHkJ+Rn7vP4v8rr9k/S+5SBRIJzLStP7qan8fw2w5HiP30Gzb9gFLA
 zCzvQAAAA==
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
 arch/arm/boot/dts/broadcom/bcm63138.dtsi           |  79 ++++++++++-
 arch/arm/boot/dts/broadcom/bcm63148.dtsi           |  64 +++++++++
 arch/arm/boot/dts/broadcom/bcm63178.dtsi           | 112 +++++++++++++++
 arch/arm/boot/dts/broadcom/bcm6846.dtsi            |   1 +
 arch/arm/boot/dts/broadcom/bcm6855.dtsi            | 127 +++++++++++++++++
 arch/arm/boot/dts/broadcom/bcm6878.dtsi            | 120 ++++++++++++++++-
 arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi   | 122 ++++++++++++++++-
 arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi  | 150 ++++++++++++++++++++-
 arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi   | 138 ++++++++++++++++++-
 arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi   | 127 ++++++++++++++++-
 11 files changed, 1037 insertions(+), 9 deletions(-)
---
base-commit: 8359b1e7edc722d4b1be26aa515041a79e4224a3
change-id: 20250327-bcmbca-peripherals-arm-dfb312052363

Best regards,
-- 
Linus Walleij <linus.walleij@linaro.org>


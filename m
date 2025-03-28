Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2335421146D
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 07:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147847; cv=none; b=qHrqnNhGLDVt6aRIpvHQ++nlIio2AE721ufyRGFINF1FSQ7xYm19B5r8LSBLSbEOv4ig13sgFFvLuSkvbykpD1F4FrgUCxp55P0OrspA61Md5Cisq9NidWG+mByrBm45s//jwiVyb1G0eLjxdpHXXCvPeMDDpXqvhfHkdKgTPQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147847; c=relaxed/simple;
	bh=bQNAOLncjZ55StGnNbbul6w593t1Q3Ii5iuZ14D5Tzw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UhU/q8liw46ROq6gcjGXQ6U9v49OJQz/PdE4/xU3H/p1W6VOZvry65+R6oiW+DMj9Au0PoVrLHO+egJZwnDl0dgX9vfNNWDZEH/flBrQ9IQEAdOpeit2VRYX/A6RykrJ0E8ncavsRD+baLtaOCrbJyP09M3LMTOUd9DxvVI935k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oKSqu4/E; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oKSqu4/E"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54991d85f99so3040951e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 00:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743147843; x=1743752643; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F8x/z/Nkqrr7H/Lu9hfS6HH6GDSoLC2Q3m41soDjtO8=;
        b=oKSqu4/EtFnKHXtodJnTVBsxJd1H4NT5MLESrtFU14jgXZQ5yBGNqaxcRAGqlvC3/d
         ReHzaheYAh1qKgj9wsAJwEHSOPq8OHjUPXhS/hnTjQUZoB+X7FDzB5ksR5qc3ywObcNb
         dX6MEebxMC5q+vyyneqr+wwlscTCqI7psYCiHySSII7r+YDrE/nC2YP2Z3vhIQkhj1dg
         QFzvuilafj7TZ2Oa6AbHuiKNQkiq0sb+SxUOnjhoD4pSGR1NKN5JGEaMhsn4BVXYFMcb
         0k/bOcHBI54k2e4UKe62rLquFaaFTvK3tqSK321+4RdSkkoZNJ8697YIt3sLi6Ua6t2G
         ScAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743147843; x=1743752643;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F8x/z/Nkqrr7H/Lu9hfS6HH6GDSoLC2Q3m41soDjtO8=;
        b=rai2Rg/8fH3g09l7A3NSxDcuejRQg8PRBWNxfMyPf9Pn6x0R9ZbjXDxesk/q++Quk4
         izDzmEwLdPYRyPDbFus1mRag4sviEPS1W7YJmlVtFwGtPqHz71NoDEcfbdiblzgsipZ1
         THNuqmewjHyew3AFpWOZnc28D8HZvrG8jJDvDiFqLaEwN/a0ZSLPAt5AR6UPg2gthEAY
         VWisjcsmEnrIs2xr1HxHH8B2FP8CzCc4gfz/vekzr3hajFiZpj7hKpYbEf46BNhVUQp8
         P59f1WNdaXKvGoNMHAKhsGdIuXQvG4yFJZ4uMxkplsb2Un13pMCFWEFVOmqMOmUKm4OW
         PoBA==
X-Forwarded-Encrypted: i=1; AJvYcCWK48ybH+eZuiSswEYprBwzH4GwBUL3GarB5zk0jsADGMrQUkCgQccLwFobOJTyTNCPwZsdeIqooY8pOzk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLDQmZv+AT4b7oYFvQhF4KBvR04G9x74NpP5+yj6GqYWdC3HuJ
	UDMnYrg1vHIebtJzTciGw33J+DxGo9cigYkvdpX5EmWGOYvzRarlwQVU2Pws0VI=
X-Gm-Gg: ASbGncvpeIb6OAPI1ma/A/icpzUDWmVU1PtmTkf40B57+wVzxRcNaZ7lgHpIOwINeS8
	Niji1KMlg/8fnCtLvSjh3zq3eCo6GS79trVqsO9SNZBVAqy3gFXgEhEXjGdD9p4DR0gFswj3JbQ
	g3Y+1CbmB7x1+iaUqMdF4Yuu/L1ydd8/v/U1KWqAoXkQIMPZ+3IAjZZiBNofWSca2QV2XcttW5D
	qJC9ePxsGOjqKJn4hjqnHFxJTX+1xbt866B4ZPOXANa1wHY+2srhgpvkhwbLv0m0VX33SYSQYGL
	xIIjBr3XBdJHLu4fli65I8gFouMZ2a763Q2dSy7DPM/24WvmJ2pHb3g=
X-Google-Smtp-Source: AGHT+IGwOpwq5nTctC/xlT0Ki4waUjHwgO55lfPawCG5kxZPMW8PL2t6IaqM0EloVwWDIeWXGrpXDw==
X-Received: by 2002:ac2:51c7:0:b0:549:9813:3e6b with SMTP id 2adb3069b0e04-54b0ad08976mr814131e87.0.1743147843127;
        Fri, 28 Mar 2025 00:44:03 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b094bb32esm215589e87.26.2025.03.28.00.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 00:44:02 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 00/12] ARM: bcm: Add some BCMBCA peripherals
Date: Fri, 28 Mar 2025 08:43:50 +0100
Message-Id: <20250328-bcmbca-peripherals-arm-v1-0-e4e515dc9b8c@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADdT5mcC/x3MSwqAMAwA0atI1gZqigpeRVy0NWrAT0lBhOLdL
 S5n8SZDYhVOMFQZlG9Jcp0lmrqCsLlzZZS5NJCh1ljq0YfDB4exsLixuj2h0wPnxduGTEu2s1B
 wVF7k+cfj9L4fFwvIjGgAAAA=
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
 linux-crypto@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
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
 arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi   | 120 ++++++++++++++++-
 11 files changed, 1030 insertions(+), 9 deletions(-)
---
base-commit: 8359b1e7edc722d4b1be26aa515041a79e4224a3
change-id: 20250327-bcmbca-peripherals-arm-dfb312052363

Best regards,
-- 
Linus Walleij <linus.walleij@linaro.org>


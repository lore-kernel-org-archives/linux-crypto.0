Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8191E2846
	for <linux-crypto@vger.kernel.org>; Fri,  1 Nov 2024 21:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730495616; cv=none; b=ANMprNTYWmpwDsRDtUSmSheKK5yHLHF626HVLUSTMkpucnduJXzeQwDtcaarCFFCr9MlBqZZNFCoO/bmS4XHvpPjyKGB1nleMH4LDpQgmYiqJpYeDaB+JJznifh5K9N9jljMLYOrcLOIlXAR+BoNAn+w62bl1AY+kD4VW+dfSZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730495616; c=relaxed/simple;
	bh=fVRyDwIDJEU3QhhtvsXhsXyGoQ+vQkIYsVbHH/ESiz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ngt06DFxWsBD4rMf6mwciC4od16ry/i2FmXYaCcOBMzDviOpLU+o9IVJJWP1CCUZa6c4FC2KUi/kxWcXWy3nMdm2PlbkqyUoP6gow2gRHek+gFDAkFRIlCNzmNDitf379DiaaG8jbDst/Fk1XamNoyZh9MmR32SWjZ9f1uTzWyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=eXLDEFVW; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eXLDEFVW"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-71e592d7f6eso1927184b3a.3
        for <linux-crypto@vger.kernel.org>; Fri, 01 Nov 2024 14:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1730495614; x=1731100414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MBfbdpDXvXyTc8pX+dqi/KLkO3CnvwNV1g4IugsXMhU=;
        b=eXLDEFVWoR8NyqBugrznes+87beQuNuYqvl5Tjnes5LW2+l62xu9TvzbkmgAERp67q
         4BjpxX1iGC1PfIwIhjCOaAm10qn4DtMVKrSU2qWeVimyUlNmzudyZCDbin+ZtuZ+0JN3
         77gyTDoUcw5Q2LXCXGanYAN7KyImbpgINkwxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730495614; x=1731100414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MBfbdpDXvXyTc8pX+dqi/KLkO3CnvwNV1g4IugsXMhU=;
        b=P3HxX6y//c7LShQyiIwDFAJCw6LMym8Fq59Zcjwwv38WTrpCNFBdAwdVVOgplFmV9Q
         0YXwAtBNAihQ3+eOzS61dhqFK3S3bPi03TsdCf8nInNN8dmK0kiMZAehkKByvqlbM44u
         1uHiAoH6agJoIFoh5lPIwDGSGaoyHnDBx7DsDxFnVRuhXXdSuxrTFyHDZdTEybmaMBKC
         UrmUcvcZXH8dKzJbpCML5HZhCJezBNJJvlYWDnD/YVae+Keu0/66IK+wZuO8T+q/FBfn
         MdsBbUzDpCyP2gzUtdA14nh7QUjB0OjF5XEHPG/IfLjmx22+T9zKTe9iOcgK3T0d0nwt
         KquA==
X-Forwarded-Encrypted: i=1; AJvYcCUucd9WSlNU9ONvy/0okLwsLpUKXW3NpgGtb5jiEJvyrxcDV6M6+QcUw1liltiUQ0D9FMI5ez3V9kUtKcE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKV0kxD3oaVWI9BbsoiGqixUHK1FhoMR3tFBpFX8mr4j9zKAxQ
	TiVTdjo95FUJL9kLApXSnMv2DN0k2C4HPXeU84LNtJ/sOCNZafJ2gCqzQMIWEg==
X-Google-Smtp-Source: AGHT+IHSF2JuOrjTjV/cyFRyjiRvzuvcMqrlb4ZbR1iu6WticcFNwva8vtTE8w1/zgmTXaNn/gruuA==
X-Received: by 2002:a05:6a00:4603:b0:71d:f821:1981 with SMTP id d2e1a72fcca58-720c98a5ebfmr7787754b3a.4.1730495614192;
        Fri, 01 Nov 2024 14:13:34 -0700 (PDT)
Received: from lbrmn-mmayer.ric.broadcom.net ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1b8992sm3109854b3a.44.2024.11.01.14.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2024 14:13:33 -0700 (PDT)
Received: by lbrmn-mmayer.ric.broadcom.net (Postfix, from userid 1000)
	id 8E67B6FC; Fri,  1 Nov 2024 14:13:32 -0700 (PDT)
From: Markus Mayer <mmayer@broadcom.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>
Cc: Markus Mayer <mmayer@broadcom.com>,
	Device Tree Mailing List <devicetree@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] hwrng: bcm74110 - Add Broadcom BCM74110 RNG driver
Date: Fri,  1 Nov 2024 14:13:13 -0700
Message-ID: <20241101211316.91345-1-mmayer@broadcom.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds a driver for the random number generator found on the
BCM74110 SoC.

Binding changes from v1:
  - renamed binding file to brcm,bcm74110-rng.yaml
  - ensure "brcm,bcm74110-rng" is being used instead of "...-trng"
  - removed "|" after "description:"
  - removed label "rng:"

Code-related changes from v1:
  - only enable the driver for ARCH_BRCMSTB || COMPILE_TEST

Markus Mayer (2):
  dt-bindings: rng: add binding for BCM74110 RNG
  hwrng: bcm74110 - Add Broadcom BCM74110 RNG driver

 .../bindings/rng/brcm,bcm74110-rng.yaml       |  35 +++++
 drivers/char/hw_random/Kconfig                |  13 ++
 drivers/char/hw_random/Makefile               |   1 +
 drivers/char/hw_random/bcm74110-rng.c         | 125 ++++++++++++++++++
 4 files changed, 174 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm74110-rng.yaml
 create mode 100644 drivers/char/hw_random/bcm74110-rng.c

-- 
2.47.0


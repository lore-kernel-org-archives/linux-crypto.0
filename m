Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0005303CB7
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 17:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755107255; cv=none; b=FOFRB7hAUOcY+YX8tmOUWm1GorOiI3ZrvnpFqZsWbp4xPkPcM2mbjgmxkDch8z4urZitUUh6Re6AlX6aEQJVDk8/BqCGqQtGaMCXu8mLKMJYAKP+NbF9oWEJMMfD5MJWarKFqiUh6bNkKd/xh9kOtEqQtfdu9OEUoDzT6fEFc6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755107255; c=relaxed/simple;
	bh=uW7fKb8DACG3fG/pvNEYkjNw8PF/bwmqPTIzgomZ1Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JNevlEL1yRf7upr2aYmKRzqGuNVhk1SAVCWQjTrcLWSf8BOKQnsQO8kzxRWCAh7aLa9HTRbX7nwpoXx1aGA0MoCM6HNeMoY5TYRaL7hKl1G9QAsYwOUed/rlD2H+n4T9/jDzI5D+FU+U9mmPf9ZrKl9QAALpo4vHjRZXxcD9rGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=aq7MQAhy; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="aq7MQAhy"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7e8704b7a3dso7878485a.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 10:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1755107251; x=1755712051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SBsfJFWg1o3SQZ+JkXCo0QRsi2YIFRfM5g31219RL4A=;
        b=aq7MQAhyDL4BdBpOk11DfL73d70i++ZqQTI5l7kOrPCgVCdleRIqPLqXPO4lR0lrch
         dBzBFQ6/BTCjTRvPFFTPvCLKfg2hLtaHNnZR9tCtw8mfaTRydkfwJ3Eu1i4NBi0i7NSL
         unT9TbNDWqEQMwQL2vI8DOnB6dzpgqwJLGCLz/BiL3SlmStBBdQNA3s7B595yGhZEuon
         2/FXSsWqQre2RGS1xfzpElc0N4L5ion9vubzzAEd9bHhylBKDFO7/7+J8+SoX0IA/wN+
         cHqw7o9nbcQ1bHrWGpr8gHhLcNkC3fUDAxsiIjLtqIIGlIyJWGpfSfGzCFpIIlmjBEyr
         T3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755107252; x=1755712052;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SBsfJFWg1o3SQZ+JkXCo0QRsi2YIFRfM5g31219RL4A=;
        b=b3XIJ50rslxGOZWsUNBNODzl1UV5nqI3Q4N1lscrQyhyIfeEOODtfRpz3VD8UOm2s+
         y0ALiwD2m0WTlSd9TR04GeO8+mANeYB39QXnAJRpF6Nd4xWoqI3rQ1cnxJMhyGF+C4wl
         hK/RvciD20CyezKnu1u6cVszlcvF8oizvcgGdQPRJlpqPsv8kPSYFhm2Z7a/BvuFbtC/
         pYVZKp1+u1SrKukUyFrr86uA8ao7wgkZ9DPqNg20n43UnC6zVkgBsXxyJeuN2fEdBpxL
         YknBeL4+5q3PW9wV+TFkFSqYsQCZmkLtIrmoUHvVX5kR316/+QvTijJZBAKM9mw6wyWd
         nF1g==
X-Forwarded-Encrypted: i=1; AJvYcCUqe1YJ25LLgO3+ASj10u/OvT3kIvLPRfeFngTxpRjhAU3GgWTTKkMgKqEdrnXaPETAhIPv/lshV4MDxCU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbYYRW058Bam5RMWbGmB9z05e1BGEWhqm3e0vZ0hgT0UySinlb
	7AmfPwtNJ3xQRrrZj9Ww+Kxh3GMl3sJs0Pusfhfamy9umg+LgTwYgvvFEAL7lxK6rN8=
X-Gm-Gg: ASbGncvKhhgpEGAHMwWg+UxLM6hBoLuzacyRdLa7Rqe7/MqBlY+0tZwOPRDPqAB5M/v
	2RYth9Dj26oTpIF68YiGFUQMlhcDfShigU0TdXp2zkHRU4oxolmxFLd7mY74RAOQRWLLUQnLz2y
	RN2x4ItQbVE2gsoDlxe6b1V2N2n8HLq+c7HRtXhD1q6UA240QoZS9UQVlt0/vpmggiA3nvBWC3t
	L2iGOEBREEDB8MGiDf9KpTtIpMhPj3lUMj2+4L2mVyc5NXc7wlRCAtzLyLIm2zzc7WFytwkkuRT
	RgI03JHVZENPk7mlEE7X3kniPskfl9uMkM+/HcrJomIFC/LKzve4RlT8vHR8cY1mceL0jzY/Wk8
	oPngOeVcsB9K8ITrxkHwkOcC6bHzXhl6KBWfqdgXdig==
X-Google-Smtp-Source: AGHT+IEB/95DXkKwomIf9ip6/yfm146L3qIifjKU7bl9DaOBgZQZz5rMpVm/bhHv87pLjMhka3uuqw==
X-Received: by 2002:a05:620a:a102:b0:7e8:434f:ffa7 with SMTP id af79cd13be357-7e8704761a0mr24882585a.52.1755107251577;
        Wed, 13 Aug 2025 10:47:31 -0700 (PDT)
Received: from fedora (d-zg2-251.globalnet.hr. [213.149.37.251])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7e7fa87e7d0sm1627122385a.82.2025.08.13.10.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 10:47:31 -0700 (PDT)
From: Robert Marko <robert.marko@sartura.hr>
To: linux@armlinux.org.uk,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	catalin.marinas@arm.com,
	will@kernel.org,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	andi.shyti@kernel.org,
	lee@kernel.org,
	broonie@kernel.org,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	arnd@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	o.rempel@pengutronix.de,
	daniel.machon@microchip.com
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v9 0/9] arm64: lan969x: Add support for Microchip LAN969x SoC
Date: Wed, 13 Aug 2025 19:44:36 +0200
Message-ID: <20250813174720.540015-1-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds basic support for Microchip LAN969x SoC.

It introduces the SoC ARCH symbol itself under the ARCH_MICROCHIP symbol
which allows to avoid the need to change dependencies of the drivers that
are shared for Microchip SoC-s in the future.

DTS and further driver will be added in follow-up series.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
Changes in v9:
* Make ARCH_MICROCHIP hidden symbol that is selected by SparX-5 and LAN969x
directly, this avoids breaking existing configs with ARCH_SPARX5

Changes in v8:
* Move to using ARCH_MICROCHIP as suggested by Arnd
* Dropped any review tags due to changes

Robert Marko (9):
  arm64: Add config for Microchip SoC platforms
  ARM: at91: select ARCH_MICROCHIP
  arm64: lan969x: Add support for Microchip LAN969x SoC
  mfd: at91-usart: Make it selectable for ARCH_MICROCHIP
  tty: serial: atmel: make it selectable for ARCH_MICROCHIP
  spi: atmel: make it selectable for ARCH_MICROCHIP
  i2c: at91: make it selectable for ARCH_MICROCHIP
  char: hw_random: atmel: make it selectable for ARCH_MICROCHIP
  crypto: atmel-aes: make it selectable for ARCH_MICROCHIP

 arch/arm/mach-at91/Kconfig     |  4 +++
 arch/arm64/Kconfig.platforms   | 51 ++++++++++++++++++++++++----------
 drivers/char/hw_random/Kconfig |  2 +-
 drivers/crypto/Kconfig         |  2 +-
 drivers/i2c/busses/Kconfig     |  2 +-
 drivers/mfd/Kconfig            |  2 +-
 drivers/spi/Kconfig            |  2 +-
 drivers/tty/serial/Kconfig     |  2 +-
 8 files changed, 47 insertions(+), 20 deletions(-)

-- 
2.50.1


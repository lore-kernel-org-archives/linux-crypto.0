Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22732E0B7B
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 11:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749814927; cv=none; b=BecFiyr/goMyC3O39j4jhGV0IoxPpKvAiqNARdGpfSFOrc696GegaEVEmsJQj99fQG7p7HBQmPSTzEVcrzcUfkSoa0W88RyDmMgyFaFeiP2e6OHi8gAEh/kZFc+7CgJi2sgy6/jm0NdAgUbCT+52cJ6henchm6mAGyvS9VaUQqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749814927; c=relaxed/simple;
	bh=N9EwmincliKfa+Mj4InfAX1k9UEb+FroSKDS7Tw5blg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIz5KzFIV5/8KN18cWVaC10j5dHxGCXPwzca+fP8qugADRTIETjfPfvTVVnC6WRC+PiV8/E96IZg0eKtTQmRpWb1dkgMvpUbZuKigEhESfvUl7Nb0VvJg3EuQfaTHrGhqQ+VgAc926PHj+uIM2rySD+qinC78S9JL4Ur0y36tgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=kp5alJbw; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="kp5alJbw"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6facc3b9559so29428146d6.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 04:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1749814925; x=1750419725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHtJLyTMYIFfJmuax7k6vu5lhjJG1PUEv0OdzzE0zPY=;
        b=kp5alJbw1ibON2Dab5a6SrDZ9iCGZ2Nf4bdRShSDrKmBRO1Km4Dd2GxERRY+45VY1+
         zASnCdxWsMjIn0EUNnZdr8j4CzO6PltJ/5KiboftiDD5mJFbXKUVEyeBpJ3U53rLRuwL
         tKsDfzynZly/EIZNa5TEXqbuNq8WZ6QtbjqXY46PKTmtPIYUcWv1iRv6QsA2iRZH4zDE
         9EXyH8bQqKY6DUaPRbEVSjmLz3ecH+i1KPXVBSgC43g9xH/X11ySjzt+SkgdLaUgnMrS
         a9QzkEJ3LZYUi24ZEESfHFEFwDrHwYaRnYVedGQgFvust4DNvenZrcd0zqnPka31K20z
         ws7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749814925; x=1750419725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PHtJLyTMYIFfJmuax7k6vu5lhjJG1PUEv0OdzzE0zPY=;
        b=madjDrLXsgss93Q6KgEPmg9T+ZZYn+EEnUPANDjAoTvOvULgXkQXe/gNdCmR4IcQ13
         iLQ6CSKVg8SA1Hc6dhKOJwdmm3W7DXorB+SY3JF8L4MLYATRoiQLMsLQdp0I8SFlEh1x
         IxdSJ87qMMAVmnOeMR7u1WDhIcewg5NIcgm9Iir+Kdu4JaTfLo5pyaO/fx03AQ49qfmQ
         pIr7RgASzwwINxwXXCdohZVrflT7E/wbzMaj82AnIt0A/cU9LFezFZIyIZmdLXUSa29o
         UwYMZl6oxqrq/fqS1Xuv57b8JV02XCLzkcCIc74YIVRi70uuk0ZfyjwX0bhfN1TSNU9v
         hozQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmY33GzK5P5tTquvpmVTFuinDQgaqXOR73FxfLL3cm71QCU3B814DMCw2oeVm2wOMxpdJXKkzTyhP5LYI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUadjZofIqRTgOjQHZqVjwLAxOBI/XFevDyEnclb7BpBHsluBV
	U5UxYa4xf3uq5f8CfJ6itL2z3ojf1rRU3RkaXNeZPQSfBr2sBmJVMwF+ORTJspNK634=
X-Gm-Gg: ASbGncs2TV+LHj3dlOHKtewzDQ9OUG6xfOvpiwa5axTGqwgNRlwg9yrUBdx0oLT5gB8
	xq9DjObaJlBDSg24IUB1cq2KBap2jC9r4LWckuRYqJ7cwGYIqG3ZXtDJx9BW8w73d7DsDOfeVSl
	rUcYNjS+SzxxyXiEHf8y+ccE793HvdVJgXxrkqb3l27+Oc9fZ7XjBaktFqpcdoYE4ndHDQFkgM5
	leQUwc3kwS0dlU94JD7V4lF4m2wSYlNJQmj2WIH8OrWp71zBGWE2nwrJvbazWtzhWcrxsojLmHX
	26huT0hmllBtr0p0qq33ZGEwFpjnD6Tc64qn36I92qr9n6ybsg0rSDWFdYSWa86TvobInJ/YzmF
	ji6WMIYmAa7npSV/eC/1F6g==
X-Google-Smtp-Source: AGHT+IFEhBGPIDsjq1frk0/wn96Fw6QfUCgUoIMTWna+hcxXY+/S62LesfKCTPJGDYw7KyfEPMYp/w==
X-Received: by 2002:ad4:5dc5:0:b0:6ed:19d1:212f with SMTP id 6a1803df08f44-6fb3e596a01mr39443246d6.5.1749814924913;
        Fri, 13 Jun 2025 04:42:04 -0700 (PDT)
Received: from fedora.. (cpe-109-60-82-18.zg3.cable.xnet.hr. [109.60.82.18])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6fb35b3058fsm20558206d6.37.2025.06.13.04.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 04:42:04 -0700 (PDT)
From: Robert Marko <robert.marko@sartura.hr>
To: catalin.marinas@arm.com,
	will@kernel.org,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vkoul@kernel.org,
	andi.shyti@kernel.org,
	broonie@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-spi@vger.kernel.org,
	kernel@pengutronix.de,
	ore@pengutronix.de,
	luka.perkov@sartura.hr,
	arnd@arndb.de,
	daniel.machon@microchip.com
Cc: Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v7 3/6] i2c: at91: make it selectable for ARCH_LAN969X
Date: Fri, 13 Jun 2025 13:39:38 +0200
Message-ID: <20250613114148.1943267-4-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613114148.1943267-1-robert.marko@sartura.hr>
References: <20250613114148.1943267-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LAN969x uses the AT91 TWI I2C, so make it selectable for ARCH_LAN969X.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 48c5ab832009..ba8c75e3b83f 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -414,7 +414,7 @@ config I2C_ASPEED
 
 config I2C_AT91
 	tristate "Atmel AT91 I2C Two-Wire interface (TWI)"
-	depends on ARCH_AT91 || COMPILE_TEST
+	depends on ARCH_AT91 || ARCH_LAN969X || COMPILE_TEST
 	help
 	  This supports the use of the I2C interface on Atmel AT91
 	  processors.
-- 
2.49.0


Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BBB29E0F0
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755107287; cv=none; b=poAA3GufLQCYVCoDTyNN943DbJA6Kut3nfbDs7wjiFqab4wV7dsoyd2vc81IilewXdnTEbCyF9EQ3jObZ1rcgJ2uxcviW+FdnPUmjxprOKkCAUlJPvvWjuc+hgcTsEw8Ais6Pa4QqBRIfOIwQtQZ/V3psuCq7n+dCYMeU4i7WE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755107287; c=relaxed/simple;
	bh=T33t/nZb8rPEuHbl7ykIT2YVRu2WYufkasb9fh7PUw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxKrDfYKNF7SVQs1LH39K61rLZh7FLIlEH13ZJhS82MNwL2tA7bGdOP8f5JPeMBUWjkz6kIlMbwG7zWmiPSxx5G55aTxWJvBqCFZEm5IwfvuBaOTQ1RHgvyWD0Ks8gnYphGwMox60WqPS7HhgedfFZSGH2JzUeKRIAE3TEnupkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=VdcbPEJa; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="VdcbPEJa"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7e87035a7c3so10828385a.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 10:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1755107284; x=1755712084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gfHoKyNgBhJf0xtcpDC78WNK1W92/OSNj7SkF7mLTxc=;
        b=VdcbPEJauo/T2vUPi79ylKREd5NVjpunxvRkOPfG4xs48gLBiyNTBiGGZF11PAL0UI
         SrjG4Bduqx+4rElejMfUEDBTa7VQRxDgPuNgEMtGJqEEqhFcQ8wQBdotbRonRNTKf4A/
         5NVsnaEGLgI5xfbq/z7og2qegyAFhHJsU382V9XNkeZxlQDDtks7lSl2lpPQs3kNTXTt
         nMmCaGHShUvXDdyMc5YZKPj0gKiErmDQE1fyBdZSoRP2cjVgE9FlhVnn3WyQqtgZNL5U
         e3H2rRufU0gv+OIRBJXQtClufiBWdYWe//Bf6NvcuQShqISVmHFyoOdHyR8vb3YuMjHJ
         3FQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755107284; x=1755712084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gfHoKyNgBhJf0xtcpDC78WNK1W92/OSNj7SkF7mLTxc=;
        b=utijrnE2ZrAwa1fvUocyf84m9g+l7sMjal/JMHNc3P39nCiH2B12opbKWCSNOZVixi
         NaJNX+G01NZd5RHL/jfdkPEsb8rmVsTtyZ0tC2RHvi8FFDfdWfgIPBlEU1JHweg2kxn7
         6iGz5EKcZ9Zx6P3Qn0KMXWQFAUrYmaWyRJ15joXPs2QS4CIq2k8vvBy7j/Kd6YBlE+IH
         NIPGQsXN5zb9c0qzWSZq37QWqy6RpxumrChvq4IfyCHP7IwgyxPYlouCaZttWxTVkRfM
         kf+JgzzG9vLn5IF+amj8tPb+LUvDabsLsja0VjDmGvA3jX4AQLhorh1DzM7QEqsx+Q8W
         o6ig==
X-Forwarded-Encrypted: i=1; AJvYcCU1ZzQpTM9s46BOwtz1VF50m9HCFXzIJY3WVfDO/B1RLF6brIS9JLa55XUjTvse302XYd64RAbRoCsnUWA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJN2w9aECIOYVSYnpe+jdwzqGnHNryDA2VjJzZMD3XYNepYrGN
	X1eprASZmK33/L73SooDO4cf7/D3VhNgoHOJ0nRT+35/lBQG0iOupDyNl8Dd2pYzKmg=
X-Gm-Gg: ASbGncuDP4dKsS4YLl2qE35xQxI3nts1g8IzKPQ6l368smPlO6XkI/COjTh4/K0c620
	Hv5tJsi9RGB+9FwGGRzcBqHMS59b4wA600XJha78oX5CIYP9PRgDLWoTpbOdn0z8fWO8uYEk0WD
	BxNObgR1cRu3L+fnGnKO6yGMhpCMp04yh/iaAKGt3oIZbYPkTuPyWqyOlp1VJLITeiF31iNBy0R
	CECEpYXEqTrXVkMmwfvmJNeOOtcgY4NC4J4RX71h8uslHIw/ESsc2gJ2SjJFmcWV+ttnw5DGYlj
	2b0DDqLqY1+vVT9n7oOgXJo5TzMYa9Tb8KbpJgu65wNGU6uySndukJFlCWZUA33JZ9X4dxKEqD0
	rEWy6CCnpNy5dAbIbZRZ5wNaYIGhU5V53TQvgWnqN6g==
X-Google-Smtp-Source: AGHT+IHk3Ep3PYhhUjUrzxiC9a3/t8LEKcJKp9X+LDRevsQvizEm3+mPb4XnpdaTjxQtoytK8PcKqg==
X-Received: by 2002:a05:620a:1791:b0:7e7:fdd2:cc58 with SMTP id af79cd13be357-7e870473db6mr37537485a.15.1755107284284;
        Wed, 13 Aug 2025 10:48:04 -0700 (PDT)
Received: from fedora (d-zg2-251.globalnet.hr. [213.149.37.251])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7e7fa87e7d0sm1627122385a.82.2025.08.13.10.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 10:48:03 -0700 (PDT)
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
Subject: [PATCH v9 8/9] char: hw_random: atmel: make it selectable for ARCH_MICROCHIP
Date: Wed, 13 Aug 2025 19:44:44 +0200
Message-ID: <20250813174720.540015-9-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813174720.540015-1-robert.marko@sartura.hr>
References: <20250813174720.540015-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LAN969x uses the Atmel HWRNG, so make it selectable for ARCH_MICROCHIP to
avoid needing to update depends in future if other Microchip SoC-s use it
as well.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
Changes in v8:
* Use ARCH_MICROCHIP for depends as its now selected by both ARM and ARM64
Microchip SoC-s

 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index c85827843447..e316cbc5baa9 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -77,7 +77,7 @@ config HW_RANDOM_AIROHA
 
 config HW_RANDOM_ATMEL
 	tristate "Atmel Random Number Generator support"
-	depends on (ARCH_AT91 || COMPILE_TEST)
+	depends on (ARCH_MICROCHIP || COMPILE_TEST)
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
-- 
2.50.1


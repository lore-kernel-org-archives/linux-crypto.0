Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B273315520
	for <linux-crypto@vger.kernel.org>; Wed,  2 Jul 2025 18:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751481602; cv=none; b=aUs42I2cqGJdVRPAPYwl548ngwjGiSJUsKjTx587cxW3pwfKY5yrpcWF4BXWOiSCyo0bMOGPBfEBRV5wMcu7BQAhvIPlqG+NB8LPiTD0qvoVOyMwohs/6ccQzlAtFKv8n/zo2Yxrzho+xmsgLGWVNSwmWQjnIZkd5I/BhjNETMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751481602; c=relaxed/simple;
	bh=ufOVlqAt3uI1zr6bmRH+USzQKY4G3SQiQndGTVQ2HBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmHOnLCsALy8tPpN/9/JOh0rzEEpQc2DyWkE5AS4ZimpTH+zbjB/3qF2otFdIfnZPEUzg6VYMznquWQa/BvHz+28nM09+gl5k6D5uIIL1jsbnB27QKWiZdnEvi8mCcVVJGUWrY3wEdSV0NPcVse34iYjtqMZm87ItBW6+BbZby8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=WgWn0EPl; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="WgWn0EPl"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-23636167b30so45081465ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jul 2025 11:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1751481600; x=1752086400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JBF3cwldevDNRr7SqXWBuHyX5mq5fUVy8++B9pNBuc=;
        b=WgWn0EPl4z9gSviEI9KEWNs4eztRqIE0YqYE8ajxkBtXvP3Wf0dGq6hnqL2G95//LY
         cpis32hI+BvVHFzMxWYvFqxhCvm90IA8ceAUBEEStj8fr0Qhoh5E2owuvpCeulrgCmAS
         zwsRsqtxi2kOVnTXmZgN53Tvei9GjOh6QYSOTjOK5pUOYU2jLGZujsXZBio26anN4Bhr
         1GwyzQwQ0vymmFyzaOD6AFnYJjpPd5iTduf6u68XBY8J1c8HJM55khjJ1ysW+AgV6bCk
         Jq9QFyMIeyC8mDdL2TgAzuq7Jb948wUtdxvyxN838xnWYYVx82Ru1LT4jHiJsYd1q0AZ
         zAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751481600; x=1752086400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7JBF3cwldevDNRr7SqXWBuHyX5mq5fUVy8++B9pNBuc=;
        b=q40NMZa7aYG1YRF0NUet0iAVJunQpWSk4PH3b1gtLhJi0395YfoZaFOcM1bcy6bPC/
         XltTQzm5BO/QwJIGFwsEizbVmmoBk04GKO8hH6M3XS8MZsjGEHcDRu/6dr+YpGeULg9H
         69KoVOATzPdw1jb6FeP0iXBgVvc8JxQr9jaJYJ1mt5hIXpEWP/PYrQMntETZ+HZUGnLQ
         HotJWacgSrU8AWxSOrS5I08+mtpHJZ13wfqfdBjkpO0+WvHEVKsAQ1BzSbaecSIEMiPJ
         9sHKxWquid0RH4CrxYAOOSxp49JYAziGusezNFtJy5kXeqjr7AbxBl4Y09xOmHqKih7b
         EfNA==
X-Forwarded-Encrypted: i=1; AJvYcCX9J4SCH4AUp6UNvyN0kl2TRrwlHEKjIZ08klNyPm5emB9eM2yNDu58Cc6nxjlA/LemRo5SuPRSHjQ/2cA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx6LIUHgt/BzU3ZPpEcpaH/5vww47yIeecqmpNKZ6ItTjOw7T+
	0UjGzgcIZnd5rxcHs/wvFP5EdX9d+cOq7z3Z7awAIcC8tDM246FyHOAW18LKPEoP7B0=
X-Gm-Gg: ASbGncvlfdviaVp96t7tWUSxeUo9LC2JinmnUczupLaPSa/m1NQOrk6y/IM9PKp+hbc
	3664EeA+BIvevLzDtG9U6YCm6kWa5Hnv2JvrhxdXaYfdcwEtAj1z7veMTA8skDrM+rsoVlKBpmT
	/OM6u+YJTohDjv+vmoOMKkM06N9kOffqNbpSv7LepTVhDmCbsFxW4x6UFhq4qmttKLn8EYXdc6Y
	4ZkzSMl/0NALZmNVfNcuK8bGHjqZJ8O/QYYIcUb8LIAiIOzX5KztCdRmh0NQXRc0q/i5pp28DRI
	IpN7YdQFWy/Iyzs5xd3JsvcyoshbZb5MkJd1YLyEsqXRNabXSAQo4tLIejrVZfb8T1ODHEfTFlV
	j9cujDY8I06RTWclmTdpv/V3LwRwoFd7TcQ==
X-Google-Smtp-Source: AGHT+IHb5I71nz8YJIIhY789TZ8DXVSueuTS+Cp9Lta7fg4qamQr3ZvWLBc2y6VdIoWci5wbIzzqcQ==
X-Received: by 2002:a17:903:3204:b0:235:c9a7:d5fb with SMTP id d9443c01a7336-23c7965da40mr5474425ad.16.1751481599876;
        Wed, 02 Jul 2025 11:39:59 -0700 (PDT)
Received: from fedora (cpe-94-253-164-144.zg.cable.xnet.hr. [94.253.164.144])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-23acb2f39bdsm143034195ad.80.2025.07.02.11.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 11:39:59 -0700 (PDT)
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
	vkoul@kernel.org,
	andi.shyti@kernel.org,
	lee@kernel.org,
	broonie@kernel.org,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	arnd@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	o.rempel@pengutronix.de,
	daniel.machon@microchip.com
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v8 07/10] i2c: at91: make it selectable for ARCH_MICROCHIP
Date: Wed,  2 Jul 2025 20:36:05 +0200
Message-ID: <20250702183856.1727275-8-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250702183856.1727275-1-robert.marko@sartura.hr>
References: <20250702183856.1727275-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LAN969x uses the Atmel TWI I2C, so make it selectable for ARCH_MICROCHIP to
avoid needing to update depends in future if other Microchip SoC-s use it
as well.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
Changes in v8:
* Use ARCH_MICROCHIP for depends as its now selected by both ARM and ARM64
Microchip SoC-s

 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 0a4ecccd1851..0101529c80a9 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -414,7 +414,7 @@ config I2C_ASPEED
 
 config I2C_AT91
 	tristate "Atmel AT91 I2C Two-Wire interface (TWI)"
-	depends on ARCH_AT91 || COMPILE_TEST
+	depends on ARCH_MICROCHIP || COMPILE_TEST
 	help
 	  This supports the use of the I2C interface on Atmel AT91
 	  processors.
-- 
2.50.0


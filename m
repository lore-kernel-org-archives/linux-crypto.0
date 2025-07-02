Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6462F5C5A
	for <linux-crypto@vger.kernel.org>; Wed,  2 Jul 2025 18:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751481595; cv=none; b=gjwA4EXPa8wvmUTCdSKLJvPY3jLWDPepWySSqDf6SQpkI7OB3ARlL3zS2yYuEf48tHbCa34/4KOuAoefRJwtM7B2vSoplJZYSflyD3s3udTMWBQs8BqoOcZC5fHHKwIYStET2s8IC/d/VjLtCWxFDt+rE5DfDXQIqA91WCBcwqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751481595; c=relaxed/simple;
	bh=rinGzCLeOfqarD788sUVMkKSqTzDgpo4gBTdpk6MIfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFs+QMfQoIpu5lpfiCgLa1xJhwEcrXlanBGeS1WK8IW2fddeU84n+0Axo0N/JpF+ZO9pPu38z+DVUe3XfEhPa4A3t1k3vEUsOKmRowDS7bp7fzgFhWZMvyyhyNQP9+wJuBmZ10r2iLEL6t4gbgSdrxbe5PZb/e18W5MRb9KHBd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=JRtB1/SY; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="JRtB1/SY"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-23633a6ac50so90545315ad.2
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jul 2025 11:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1751481593; x=1752086393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wD4QPHjT8G71M31CBThmdXAv4qoEcXYUM9xHzhJ3pQ0=;
        b=JRtB1/SYcPo8MTrJm9+PmWnAeU9vpMp/x8E3mYRWcDV5R+sME73FQJ5TBC4cCtRqhg
         qDcLMDUtSFGhMop+rWxwZXCC71uzODb0Nmxn7soE2Lgqq5GSpgH5gWlu+mQDS0cKSl9k
         yy3iBTSPV0d4mCU+JqhUxaxpEi3YAZSSwDNye27MEdjeo4W6pfTcjnObPJ0gbKLyreqs
         4C854uoNSrSebbfC9SfaS+7zawAQT4x1/uNRYBqRl71JxA3fhft71cyWzEYx1rTxxvCj
         EWPAbPgFc2YfbFpi+qbR9syslWZn+7+pjddzViUk0E3Ur53949DJlA9Us40B2WnF8E3R
         9huw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751481593; x=1752086393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wD4QPHjT8G71M31CBThmdXAv4qoEcXYUM9xHzhJ3pQ0=;
        b=YOQ2L/3uzbWsGA+qypWkKn4y7+r1TbztZhroS5QEgqoRhzCiaZygNv4Ap/fPLEJMs0
         3Hi4b+lUT6Aa9fs37zZ23rBu0A8AM/RlBox1hkV/O/l1MYLQDQ4CZvrjVE+qy8FyL8Fy
         jsxgO9BHzpVP4d7oUKNfxISp9rb+9e9qtbVsAwTkgzCB7nEqsAUR66oixCZph7+XIiVD
         KTCFJhrj30THRm4FbHl+ytmGzO2+LBiqcnCgT5PCEFMgzowWPG1DD4vKGbE9LuaFVlHk
         0aizOUUA6VLHkS09Id1Fhu53KKZaaKBlkZIO5ImyHfYXA3otPKtsZ41xRI1TonMSMTfl
         fJ4g==
X-Forwarded-Encrypted: i=1; AJvYcCWNFqVF3zccnodWYKh3c2jM5yFfR4AR2+9cVHiHCmpUMPOkd4PTnjPeARX3MtnbURaXniSpnDBiCCW3Oe8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNGQj3aOcOixGLYuY3zRKEqL78gU80G6zHm1/FOqr44tbu3Atb
	bPft7/cvsEEw2/VYp91WOduf8il8CSBf5mknzlZFW5fZhRjiKSERLxNQL3ZhfdECfG8=
X-Gm-Gg: ASbGncsyAvO1Rfp4gbjJWaXez5VPZQ5RCvls2seEHxcI+pYaTqkeBtjZn8tVmBaJdoo
	JoV8IniyWuHUMgz6i2MvJ0IF8Ij+waHoguStXcpMujTs6Iie83xSl/qLK2AC8yYEVlFXfkq0Vuq
	i61N7hkK1DWrClsLAzZpT1pE7Zs3zBJ37DU0wnJZ/dMCxpUffCQfi+CGY71FjAzpfV1E3OHVXAh
	lX1NCH4uRqBCSERHBsW3I5c8dLwQ03be252STrgk2uuBInF9VjekXAOxqdTVzo2VohQLd9pneaJ
	Zuq59+VGr0wCUWgbLmx3fro4onyd7Qh9rt8TCB49wz64lTmIx1ffxlsPkdmn6m8izNu7zPsGO4p
	ZVjmGSMCTJ1TxGLvHqIMjrkM=
X-Google-Smtp-Source: AGHT+IGAQ7JmlYBOBzbIQlby/TAkB16aHlqrj6A7a2pC4QxXfKmUKta4phGLGtsgT8ahWX5lEnwzqA==
X-Received: by 2002:a17:902:dace:b0:234:c549:da14 with SMTP id d9443c01a7336-23c6e592183mr58648255ad.29.1751481593085;
        Wed, 02 Jul 2025 11:39:53 -0700 (PDT)
Received: from fedora (cpe-94-253-164-144.zg.cable.xnet.hr. [94.253.164.144])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-23acb2f39bdsm143034195ad.80.2025.07.02.11.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 11:39:52 -0700 (PDT)
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
Subject: [PATCH v8 06/10] spi: atmel: make it selectable for ARCH_MICROCHIP
Date: Wed,  2 Jul 2025 20:36:04 +0200
Message-ID: <20250702183856.1727275-7-robert.marko@sartura.hr>
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

LAN969x uses the Atmel SPI, so make it selectable for ARCH_MICROCHIP to
avoid needing to update depends in future if other Microchip SoC-s use it
as well.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
Changes in v8:
* Use ARCH_MICROCHIP for depends as its now selected by both ARM and ARM64
Microchip SoC-s

 drivers/spi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index f2d2295a5501..a7ca7cd9648f 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -145,7 +145,7 @@ config SPI_ASPEED_SMC
 
 config SPI_ATMEL
 	tristate "Atmel SPI Controller"
-	depends on ARCH_AT91 || COMPILE_TEST
+	depends on ARCH_MICROCHIP || COMPILE_TEST
 	depends on OF
 	help
 	  This selects a driver for the Atmel SPI Controller, present on
-- 
2.50.0


Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827BB2BE647
	for <linux-crypto@vger.kernel.org>; Wed,  2 Jul 2025 18:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751481581; cv=none; b=iF+Q54D2wtxj56uCzr1UMG4ID44yQXTjPmEy2ehgG/4h8CjyG9uLlLc3K2g94mwcyVdZoDV1QxNbGYRBuuDBHkcPJ58eKmi5D3gM/zAj2OCteMyo0ayMnzQJQ2/UTvVNBrB7W1oIm9K2XyG/TJIVoYxUQrG2DYHANor7iUp33Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751481581; c=relaxed/simple;
	bh=oaGmzUZUXJWd6raW4UkBJCtJB/M94OwXRkxkbmWDquM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9PEP7k+uQzx4o6Wj93cKPGi3q54Y2sMdqd0cylGDD933Z2f+vS4NJYw661rDErrHorDuyrIyvtarQEuFdgmVIV8rPC1TUN1V38Geo33JIEba09q9O7EcpIKPuvoxck5E1ArBsSAao0HzsoYRdQFL3r8+PPtfwPCf2/CJUNPtFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=L9neN5Jg; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="L9neN5Jg"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-234f17910d8so70718675ad.3
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jul 2025 11:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1751481580; x=1752086380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iKtbK/2WRQ+wXXbB4rZi2px+YsVtXfxGP3mE8Odmzx4=;
        b=L9neN5JgjzZR0GYfywIkgQVDepDdjZiaUQuPlZsdznjWxdHPGZueSa9coSHkBRpiEo
         bkj1WnAK4yikbfKDqlxObgAOTnmUhMoErn2GJQML9pfB4/282zgqbWjYOy0RtWBz7wwi
         9yhUcHQfA3WJr2KrFk2hignrTjjB8JmIDTfd1IkX8DBVHtg7Zbxh758M8nrYEtjrWa39
         dG2cH7h7eCUaIeez+u1NURW3a4w4uFbNJDr4ZBYW80rYNVlz6KZePQs8Ypkg5WJiNYXx
         1LITr7L2Vo/inGLs3bnk/IxuaNhQ8N4r9QnqmWWZ5+qrPiClxQ0bmkIV97paaDgfY2Np
         odbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751481580; x=1752086380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iKtbK/2WRQ+wXXbB4rZi2px+YsVtXfxGP3mE8Odmzx4=;
        b=d/s27mIinoauBodDqJYJs/IqZPuwiKsCZgUyJokQ3GUOI+GoKyu3M9fI83vxrx7aUE
         /6fdM9+FUIP5oqVqtB5gnc7vT9wW8PgtpiioaFSY9ekewI/4ZbFlV4WIsooGRJnVkiy1
         SnjODT8kW62DNFkY8jK7O/WpK3a6hphrmYcwf5Ip4to6snAv2Aau46qHRyur9icORKKk
         YYlklKnvW8F2vXBNzUmwTXrWi9cstMgsgow2qphgDyPPWnDaLTMtbscVDEOn+z9BkIjO
         oKdmpYZm1sHYJpYTgVd9yku85Zl1dPEX2lMei02Y48nAw97giwb91Mi5XfRqn1QcRkL/
         7wNg==
X-Forwarded-Encrypted: i=1; AJvYcCWDWiiCUlBigdEbTMF8hG14fqPwGrPJh99nUBgYKXuSaw0uSOX88XulOCWC/0cr+T01licsSSL+Vbj4J1I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3azYd2d5aj7tKcBhe+cfjf4+RVItZCxz2RSZ/3WOuiyfF9m3R
	2podZAWJzpZaOb7PDKXRXrar/YrhMlkHH+BZWhi1QmEwqYbWShJuFtTzZ00VDj0WZ+0=
X-Gm-Gg: ASbGnctv+6uRkgWux7hLzp4PKeSBKFRzVMmqvwPd/BGcZ3zz+R6uyNaSEE1s2BVgEDh
	QIKqnqaJ7UqavHz2AgayoTysspTaBsD6wyrWNuRv0DsleEfW9cIBwgTyDzSsqG52hpQfadtcWpx
	23v4+F2r5NK9RnXntboQppn719HoKQ1ZwJRGd8goiaJ4StGwqj+CNjL8tL2/it+5KPImMxzGavD
	4HpdcD9WN3yEnizsH1Vnd3mScwBB53G/kXHoM5ReGK3ujxMqt0biJU3Z4EKs0PEopr02UCHhFt9
	1L2egSsQwbJmLmo/FJkpcj5fBXW38SJkNUZFnlgBwwkOw9fhRDOJpQ6MyjqYdrRKuHODywItnDM
	+Zi9Z/URpsSAZg3cWGlSB58FUOd4cEgQQOQ==
X-Google-Smtp-Source: AGHT+IFMiw5zVlKSlo142PqqKAhtgqF1TVkOxw4N8sD11BQn40MJ5BTx7e9G7Jb+TWyMfU9vkgJvWA==
X-Received: by 2002:a17:902:e5c1:b0:235:91a:31 with SMTP id d9443c01a7336-23c796a1c47mr5430865ad.8.1751481579607;
        Wed, 02 Jul 2025 11:39:39 -0700 (PDT)
Received: from fedora (cpe-94-253-164-144.zg.cable.xnet.hr. [94.253.164.144])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-23acb2f39bdsm143034195ad.80.2025.07.02.11.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 11:39:39 -0700 (PDT)
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
Subject: [PATCH v8 04/10] mfd: at91-usart: Make it selectable for ARCH_MICROCHIP
Date: Wed,  2 Jul 2025 20:36:02 +0200
Message-ID: <20250702183856.1727275-5-robert.marko@sartura.hr>
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

LAN969x uses the Atmel USART, so make it selectable for ARCH_MICROCHIP to
avoid needing to update depends in future if other Microchip SoC-s use it
as well.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 drivers/mfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 6fb3768e3d71..0ea3a97bb93d 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -138,7 +138,7 @@ config MFD_AAT2870_CORE
 config MFD_AT91_USART
 	tristate "AT91 USART Driver"
 	select MFD_CORE
-	depends on ARCH_AT91 || ARCH_LAN969X || COMPILE_TEST
+	depends on ARCH_MICROCHIP || COMPILE_TEST
 	help
 	  Select this to get support for AT91 USART IP. This is a wrapper
 	  over at91-usart-serial driver and usart-spi-driver. Only one function
-- 
2.50.0


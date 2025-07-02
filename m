Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2372F5301
	for <linux-crypto@vger.kernel.org>; Wed,  2 Jul 2025 18:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751481615; cv=none; b=k2MTQmsstvClamZaGSljxSPJbIehylqPqxXHdPKdg0q9f6mgXb03uIVVsT9FTBLplksIPSxCiGfi2jCxYDP737hNo+WSE1hTTSKHozCMckhNVnlwpv34a8eWtTuY8NAj3FRmRuUVMdx9uB6I0czL9SSDZrNaU1bOgUcgtZSB9pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751481615; c=relaxed/simple;
	bh=Cz63RwNeleL0UIjH6azz0oQ3j2RQxKtigND+2Rg8ZE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxKZEuoEyHeeaOMRnebprsD37yom9smMEPB+IHap2B5EP1fbRBr0loeI7jx5WE4vHDHFS5PkcoaKg0zlRDbK/TBxDeiHQohxoPOpwVwqAc/UCwBIab6z4f8D6BOP6zqNhHscq4v0+mXALq4Fshwpu2P6KYyx4DtlBYybQchm/bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=Va0YdXqd; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="Va0YdXqd"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-23649faf69fso43719305ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jul 2025 11:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1751481613; x=1752086413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iLgkgM2dsMzuH/fyTk3FJbcZgyqMvTqyvvSzdaeBl9c=;
        b=Va0YdXqd7Ix0e8Et2+b4uQKK8bYPewjZFS9B4xkIe/yC8TrKnqu64lE9zRKXq5IS+j
         MJC9Kre+ADc/I1UNLxUxqIwZMYx3ky0BYiQLgzPLxUrxyA1CbSmU0yEgNbjdv8HEYKiA
         UbxcgRny46t1PVx3PhdNzHQOqgLrJLdopipxzgEIadB/AjlHEa1WnOB+JUVLqldlnBnv
         b+eipirIyAbEFfkLAW1iBk75Se+7NHLsHcoXNMupYN8qzDyaMcZxuHJyxX38rmt6ozDl
         8qQFlURzt3vua6+NZNRFnI1WSMw4vAHFtVJI2ZPrUbG+v3+tzT43DxO0j8Kojtir5STe
         VtEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751481613; x=1752086413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iLgkgM2dsMzuH/fyTk3FJbcZgyqMvTqyvvSzdaeBl9c=;
        b=RN07vkpIAgQ7WE32wy3U8Ib+gvP9lIJqy9Iwx0SVrJsstCEJkZ7YSnbnuDYtGGYPZ3
         0VJ6nXtE+xctUvScWrvrGQE0EFlTw1lGOKuZdrAnTHDkdcsH4tTnJH1mbH3KkGA9QVgF
         piR59VBTJ8T4hYKCzUzIb0DsZ89jiAqQTCzZiabB08y8TQVsQXfHEouUBz5KsXiWchC2
         krbEkOou+bO2+iHvZIfH4STbQgRUBTef5rVYS7Pfa5zle4TDxFLrpahK5O3azDtdbIw4
         RWXtEYgjI+4hDwY3+Pn8cZQj4TVukDKkE0q8DfO8vyUkdijCv9i9DSBTDKQHbigkIWV0
         zzaA==
X-Forwarded-Encrypted: i=1; AJvYcCWNNPy4vpQJFbGDuCs71xj6OUqRwE5RIds7Oa8FsCm9t0ih2ypRR6umLMmklm58kH7EfIsj+bWxNTMRv+E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4FMPCosDemO4N0kh1g1PPdtzmAamR0S3RuVNAaPKXuJJqCw0q
	fKIM5Z+qs1FJQj/3BlqO1O1pOZ6XcE4mejFBzobxUROVDRLSkVRJRoi3nO4KA98H1oY=
X-Gm-Gg: ASbGncuPZVzM5+1yjbl2KssFEodzdIBzQionCTvPIok+ma9A6yWKNQqI8biphBfUqRF
	+ptqYDNAjmtaVvFUxXRtXIE7hRAiGQuY+7N9tAxZgAO7BVMMSea3Xbqtb/4MNsZcCoThc0xSeeC
	72zSvWQrMnSJLFGgTtaF8UtYn8/eLlPzS4b2S8Z8WBnXWoWuMay1BSks087JgcPT1Zn4GyD88dy
	8lbi1yQ/75Y7PV5dZoEUatkJiAW1r5mORjkC87VUBW7kTwVVsNBJP63PLA1QxGM6g2vR6x3Db3S
	wLfCQ7mwV456eVZyh2MMSVeuorBho7ytkSVEudaA3lZZp8L7KJwkX2G955kyxGW9FFgyDcODnwA
	W49F9/Eqwbz9dTSp7pQnZX+w=
X-Google-Smtp-Source: AGHT+IGIKE9F8Co83/dHlUj/BJjldce2wZ+yTKPm0xGwC9EdJvNItuAvUNQ8nezHwuOa2fWnkwRauw==
X-Received: by 2002:a17:902:da88:b0:235:880:cf8a with SMTP id d9443c01a7336-23c6e4ac48emr57113295ad.15.1751481613470;
        Wed, 02 Jul 2025 11:40:13 -0700 (PDT)
Received: from fedora (cpe-94-253-164-144.zg.cable.xnet.hr. [94.253.164.144])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-23acb2f39bdsm143034195ad.80.2025.07.02.11.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 11:40:12 -0700 (PDT)
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
Subject: [PATCH v8 09/10] char: hw_random: atmel: make it selectable for ARCH_MICROCHIP
Date: Wed,  2 Jul 2025 20:36:07 +0200
Message-ID: <20250702183856.1727275-10-robert.marko@sartura.hr>
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
2.50.0


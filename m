Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FA529E0F4
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 17:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755107284; cv=none; b=fmdtuHoi9iKgLozgz0sVrL7tw0/y72mvKmQEjiZHVO1BxTGAKPppkdlgXZUERDD5jgglrH3CApNzjUxtGS66wnDxWNUZZJDNi6sLId0lfZRvQuBov8RbuE1hbpzFOZRr5VyemF4D8OLHCgtNYQikBQBxoxR/x4VuISK2z0vq86o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755107284; c=relaxed/simple;
	bh=ONd4Qs9MdmtR2emzr2R9EQwalmRVkxN82kEJbRPVoKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhzbNmf1twhkBK7q0NaXZVgXXpVT/l4OecEP5mm7HiGT0xBW2olAL5j9Sq6K3heDGZyoxPg7ajtq5JMOE5D21LJgP7FcQIXXGYm71FeIzg9rzW297hXLXVP11teW3LlHrei7U+WtgaQ9IibSrJf9C/3FJFnekDTMzhXyoV0MALU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=JNF06wX6; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="JNF06wX6"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7e8704cdc76so7744885a.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 10:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1755107280; x=1755712080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLNf+0ZsNl67A+boQNElFMCPPvbgNyj3cPEZ0b5ZYx0=;
        b=JNF06wX6gz39a09M7XuaKCZW3/otWAO4pMw9c0PAncCcsbSayAeyfWFwUmKsOnYlAG
         v3gtNyeV8KSFPs1YjW8t0Ky1f3IVP1iQ5rcvbHy/YlecSDNZebO6QsfatVp6vFJKViXh
         fSmyyXZxUOJhjs/R3cH1YwlxmtTbQa8ThKI3UHXri7lpI1mAOIch3Mhv/QkL4f3hvN76
         R+Rp5rmnr1ThB6h7iTevYKSp/MSwsd5bwBBBt9OOuvRjqYFAVUNUqU/C5DXypohSERtx
         /4uzV8DzmpfHf4M9cJLlzhvDGormIM+qeyluC6jXzuVLzpHHBdzU8hveYSKEt4htd9Gt
         naYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755107280; x=1755712080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bLNf+0ZsNl67A+boQNElFMCPPvbgNyj3cPEZ0b5ZYx0=;
        b=aFs1ubPYhkxz+rkpn4f7V04UX0/S/KpCL1RmkJo1XrslmgWbReylIplcwVFwHzA4HC
         JM03aEmwcobEQzqcaU9B8zGqJUk5Ek27ugY4viOddJWh6JzzDogzA6K0rX2LAVHb5vVG
         5OEjCeO6GhBjauW/900oM37yZe6b4YGlPF+vTkv+fASrsOjN56AnLpSJ3F3D636mt2f3
         0vWRIvqaWXrfDAkxx3kUi2gTs5pGwC55f3/AnxZDZyGuC61W3eXBesh5GwFJ0KNfl1la
         N8xRiEdc2ZQaoibPTmPDkzqaRIh/kLI4/48UHPSeoWFWZhgRYUJLXV4T/7ITR0Fv1MP4
         JyMg==
X-Forwarded-Encrypted: i=1; AJvYcCV/cbnVL4LZN/97eIDY5din208ROwoOFKSLzcm4EEfa44/0/iCgwcBM0cs3zQERpljVY5Ky32fOUnLyY/A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt51YniF2jXuTY34aY2lVob7q/cwzL6w9ole5SHcoB7SaL2FB8
	rg6q549ZP1JAaEr8PlIhaeTMGrxLQAXIVyG0BISdEE+Kh0ASZwkL1IFGGAUXO3z2aI8=
X-Gm-Gg: ASbGncvSTAth9Bx/7PPTUyEhmVG6hKfedQ5M1SRhPdRmblGqKCpYZeE/SGdlxDSYaTm
	XTKg932uiokyAqVUBtK/imgDJPzTdKcco10Nv0LYeZNnAUtEvyqxW4yGq9e4VHTFRa4oFnVcUhs
	9agiRYyvM/uaQTNI8lv7qh40tKossRWQAmmjhTL7SlECPZpLzJztUtnNhfs/bGAQ98gdaeMjNIK
	Twa1ojNFdndN3c0ZYrZmIjqeP2+utgT082I0dvjtxNs9tDI+AL1e6SaKY3FMEP36G0G/EmnURg3
	+/mzWhgGDjtx6dMltKGyhGPYr8okxs4PvqjlmAp60E6uDEaslNVGor3g84RwD3w2qDPq6UV+175
	vHA9ORH86YFdJJStJTGATYR5AqWxCSiR6B0KSt5Ea8g==
X-Google-Smtp-Source: AGHT+IG/snJ5W/RG0E/erOkIvUu/WH4PIM7qXx4xAitymXiD3NRL3HZn1ijMkWxa/MDJZoHs07TE8A==
X-Received: by 2002:a05:620a:270b:b0:7e6:9a4f:a299 with SMTP id af79cd13be357-7e87041fe25mr33631785a.16.1755107280240;
        Wed, 13 Aug 2025 10:48:00 -0700 (PDT)
Received: from fedora (d-zg2-251.globalnet.hr. [213.149.37.251])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7e7fa87e7d0sm1627122385a.82.2025.08.13.10.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 10:47:59 -0700 (PDT)
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
Subject: [PATCH v9 7/9] i2c: at91: make it selectable for ARCH_MICROCHIP
Date: Wed, 13 Aug 2025 19:44:43 +0200
Message-ID: <20250813174720.540015-8-robert.marko@sartura.hr>
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
index 070d014fdc5d..c0aea0920f61 100644
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
2.50.1

